-- FileName: MainDestinyCtrl.lua
-- Author:  lizy
-- Date: 2014-04-00
-- Purpose: 天命模块的入口， ctrl
--[[TODO List]]

module("MainDestinyCtrl", package.seeall)
require "script/module/public/UIHelper"
require "script/module/destiny/MainDestinyData"
require "script/module/destiny/MainDestinyView"
require "script/module/destiny/MainDestinyTransferSuccess"
require "script/network/RequestCenter"
require "db/i18n"
require "script/module/config/AudioHelper"
require "script/model/user/UserModel"
require "script/module/destiny/MainDestinyShipData"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_layMain
local btnTransferag = 100
--进阶成功界面需要的数据
local m_tbSucceedNeedData = {}
-- 按钮事件
local tbBtnEvent = {}



local function init()

end

function destroy(...)
	package.loaded["MainDestinyCtrl"] = nil
end

function moduleName()
	return "MainDestinyCtrl"
end

--返回按钮执行的动作事件
tbBtnEvent.onBacks = function ( sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		MainDestinyView.stopAllAction()
		AudioHelper.playBackEffect()
		require "script/module/main/MainScene"
		MainScene.homeCallback()
	end
end

--修炼按钮执行的事件
tbBtnEvent.onTrain = function ( sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		 AudioHelper.playCommonEffect()
		onTrain()
		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideTrainView"
		if (GuideModel.getGuideClass() == ksGuideDestiny and GuideTrainView.guideStep == 3) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createTrainGuide(4,0,function() GuideCtrl.createTrainGuide(5,0,function () GuideCtrl.removeGuide() end) end)
		end
	end
end


function create()
	getDestinyInfo( createView)
end

function createView( ... )
	m_layMain = MainDestinyView.create(tbBtnEvent)
	LayerManager.changeModule(m_layMain, MainDestinyCtrl.moduleName(), {1}, true)  --公共模块保留跑马灯
	PlayerPanel.addForPublic()

	---------------  new guide step 3 begin -----
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideTrainView"
	if (GuideModel.getGuideClass() == ksGuideDestiny and GuideTrainView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createTrainGuide(3)
	end
	---------------  new guide step 3 end -----
end

-- 默认的关闭按钮事件
local function onClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.removeLayout()
	end
end

--修炼按钮执行事件
function onTrain()
	local destroyInfo = MainDestinyData.getNextDestiny()
	local sliverNum = tonumber(UserModel.getUserInfo().silver_num)
	local cur_destiny = tonumber(MainDestinyData.getNextDestinyId())
	local shipInfo = MainDestinyData.getDestinyInfo()  --当前主船信息

	if (tonumber(shipInfo.left_score) < destroyInfo.costCopystar) then
		local dlg = UIHelper.createCommonDlg(gi18nString(2701) , nil ,onClose ,1)
		LayerManager.addLayout(dlg)
	elseif (tonumber(sliverNum) < tonumber(destroyInfo.silverCost)) then
		local dlg = UIHelper.createCommonDlg(gi18nString(2702) , nil ,onClose ,1)
		LayerManager.addLayout(dlg)
	else
		local user = UserModel.getUserInfo()
		if ((tonumber(shipInfo.cur_break)) == tonumber(MainDestinyData.getNextDestinyId() )) then
			MainDestinyData.setNextDestinyId()
		end
		LayerManager:addUILoading() --联网之前添加屏蔽层
		RequestCenter.ship_shipBreak(activateDestiny_callback )


	end
end

function getDestinyInfo(callbackFunc)
	local function getDestinyInfo_callback(cbFlag, dictData, bRet)
		if (bRet) then
			MainDestinyData.setDestinyInfo(dictData.ret)
			DataCache.setDestinyCurInfo(dictData.ret)

			--初始化主船配置数据
			MainDestinyShipData.setShipId(MainDestinyData.getCurShip())
			MainDestinyShipData.setShipInfo()
			MainDestinyShipData.setShipBaseAttr()

			callbackFunc()
		end
	end
	---------------by yangna  主船信息 新接口----------
	RequestCenter.ship_getShipInfo( getDestinyInfo_callback )

end

function activateDestiny_callback(cbFlag, dictData, bRet)
	if (not bRet) then 
		return 
	end 

	MainDestinyView.rememberProperty(1) --纪录改造前属性值
	UserModel.setInfoChanged(true) -- zhangqi, 属性值增加，标记需要刷新战斗力
	local cur_destiny = tonumber(MainDestinyData.getNextDestinyId())
	local destinyInfo = MainDestinyData.getDestinyById(cur_destiny)
	local exceptStar = destinyInfo.costCopystar  -- 当前突破消耗副本星星数
	local itemDesc_ = m_fnGetWidget(m_layMain, "lay_tupo_fit")  --副本星星数目
	UserModel.addSilverNumber(- destinyInfo.silverCost)  --金币刷新
	MainDestinyData.changeCopyStar(exceptStar)    --副本星刷新

	if (destinyInfo.isBreak ~= nil and  destinyInfo.isBreak ~=0) then
		itemDesc_:setVisible(false)
		updateInfos()
		MainDestinyData.setIsBreak(true)
	else
		MainDestinyData.setNextDestinyId()
		MainDestinyData.initBaseInfo()	--更新属性加成
	end

	MainDestinyView.rememberProperty(2) --纪录改造后属性值
	UserModel.updateFightValue() --战斗里刷新
	--删除屏蔽层
	LayerManager:begainRemoveUILoading()
	
	MainDestinyView.updateInfo()	


	logger:debug("GuideTrainView.guideStep === " .. GuideTrainView.guideStep)
	if (GuideModel.getGuideClass() == ksGuideDestiny
		and (GuideTrainView.guideStep == 2 or GuideTrainView.guideStep == 3 or GuideTrainView.guideStep == 4)) then
		GuideCtrl.setPersistenceGuide("destiny","close")
	end
end

--更新进阶前后的修炼属性
function updateInfos( ... )

	require "db/DB_Heroes"
	require "script/model/hero/HeroModel"

	m_tbSucceedNeedData = {}
            
	-- 进阶前
	--计算修炼累加的属性和
	MainDestinyData.initBaseInfo()

	local htid = UserModel.getAvatarHtid()
	local tPreDB = DB_Heroes.getDataById(htid)
	local tPreData = {}

	tPreData.life = MainDestinyShipData.getHp() + MainDestinyData.getHp()
	tPreData.phyAttack = MainDestinyShipData.getPhyAttack() + MainDestinyData.getPhyAttack()
	tPreData.magicAttack = MainDestinyShipData.getMagAttack() + MainDestinyData.getMagAttack()
	tPreData.phyDefned = MainDestinyShipData.getPhyDefend() + MainDestinyData.getPhyDefend()
	tPreData.magicDefend = MainDestinyShipData.getMagDefend() + MainDestinyData.getMagDefend()
	table.insert(m_tbSucceedNeedData, tPreData)

	--进阶后
	--进阶后的修炼属性累加
	--主船突破后，主船id在客户端修改，同时更新DataCache中的缓存信息,（DataCache 用于阵容hero属性和战力计算,）
	UserModel.setShipFigure(MainDestinyData.getCurShip()+1)  --更新UserMode中主船figure
	MainDestinyData.setCurShip(MainDestinyData.getCurShip()+1)   
	DataCache.setDestinyCurInfo(MainDestinyData.getDestinyInfo())  
	MainDestinyData.setNextDestinyId()
	MainDestinyData.initBaseInfo()

	--刷新主船基本属性 
	MainDestinyShipData.setShipId(MainDestinyData.getCurShip())
	MainDestinyShipData.setShipInfo()
	MainDestinyShipData.setShipBaseAttr()

	local tAfterData = {}
	local shipGraph = MainDestinyShipData.getShipGraph()
	tAfterData.gainShipImg = "images/ship/ship_gain/gain_ship" .. shipGraph .. ".png"
	tAfterData.life = MainDestinyShipData.getHp() + MainDestinyData.getHp()
	tAfterData.phyAttack = MainDestinyShipData.getPhyAttack() + MainDestinyData.getPhyAttack()
	tAfterData.magicAttack =  MainDestinyShipData.getMagAttack() + MainDestinyData.getMagAttack()
	tAfterData.phyDefned =  MainDestinyShipData.getPhyDefend() + MainDestinyData.getPhyDefend()
	tAfterData.magicDefend = MainDestinyShipData.getMagDefend() + MainDestinyData.getMagDefend()
	table.insert(m_tbSucceedNeedData, tAfterData)
end

--主船进阶
function transferAnimation( )
	local laySucceed = MainDestinyTransferSuccess.create(m_tbSucceedNeedData)
	LayerManager.addLayout(laySucceed)
end


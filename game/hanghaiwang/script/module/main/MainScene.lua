-- FileName: MainScene.lua
-- Author: zhangqi
-- Date: 14-3-29
-- Purpose: 创建主场景，并负责模块之间的切换


module("MainScene", package.seeall)

require "script/module/public/GlobalScheduler"
require "script/model/user/UserModel"
require "script/module/config/AnnounceCtrl"
require "script/module/main/PlayerPanel"
require "script/module/copy/ExplorData"
require "script/battle/notification/NotificationNames"
require "script/module/main/MainShip"

-- UI控件引用变量 --
local layRoot -- 最底层容器，满足适配，放置所有UI, Z-order 0
local m_imgLastGlow -- 记录上一个主菜单按钮的光圈，用于显示和隐藏, 2015-03-18


elementScale = 1.0   --2015.1.24  yangna script/ui／main/MainScene 的变量

-- 模块局部变量 --
local m_ExpCollect = ExceptionCollect:getInstance()
local nZPmd = 1 -- 跑马灯
local nZPlayer = 2 -- 玩家信息
local nZMenu = 3 -- 主菜单

local m_fnLoadUI = g_fnLoadUI
local m_fnGetWidget = g_fnGetWidgetByName

local m_showNoticeTime 		-- menghao 公告显示次数
local m_layMainMenu 		-- menghao 下面的6大天王键
local m_btnBaseName = {"HOME", "FORMATION", "COPY", "TRAIN", "BAR", "BAG", }
local m_btnModuleMap = {["MainShip"] = "HOME", ["MainFormation"] = "FORMATION",
	["MainCopy"] = "COPY", ["MainActivityCtrl"] = "TRAIN",
	["MainShopCtrl"] = "BAR", ["MainBagCtrl"] = "BAG", 
	["MainEquipmentCtrl"] = "BAG", ["MainTreaBagCtrl"] = "BAG", 
	["SBListCtrl"] = "BAG", ["MainConchCtrl"] = "BAG",
	["AwakeBagCtrl"] = "BAG"
}

-- 模块局部方法 --
local fnCreatePaoMaDeng -- 跑马灯
local fnCreateMainMenu -- 主菜单
local fnCreateMainShip -- 主船

-- Xufei 2015-10-15 日常按钮上的小红点
function updateTrainTip( ... )
	if (m_layMainMenu) then

		require "script/module/copyActivity/MainCopyModel"
        local num=MainCopyModel.getAllAtackNums()
        local activityCopyTip = false
        if (num>0) then
           activityCopyTip=true
        end
		local imgTipBar = m_fnGetWidget(m_layMainMenu, "IMG_RICHANG_TIP")
		local isShowTip = false
		require "script/module/impelDown/ImpelDownMainModel"
		if (ImpelDownMainModel.isNoGainSweepReward() or ImpelDownMainModel.isHasFreeRefresh() or activityCopyTip) then
			isShowTip = true
		end
		if (MineModel.isTips()) then
			isShowTip = true
		end
		if(not imgTipBar:getNodeByTag(10)) then
			imgTipBar:removeAllNodes()
			local copyTipAnimination = UIHelper.createRedTipAnimination()
			copyTipAnimination:setTag(10)
			imgTipBar:addNode(copyTipAnimination,10)
		end
		imgTipBar:setVisible(isShowTip)
	end
end

-- menghao 招募或者购买礼包后更新商店小红点
function updateShopTip( ... )
	if (m_layMainMenu) then
		local imgTipBar = m_fnGetWidget(m_layMainMenu, "IMG_TIP_BAR")
		local isShowTip = true
		-- if (DataCache.getRecuitFreeNum() == 0 and DataCache.getCanReceiveVipNUm() == 0) then
		if (DataCache.getRecuitFreeNum() == 0) then
			isShowTip = false
		end
		if(not imgTipBar:getNodeByTag(10)) then
			imgTipBar:removeAllNodes()
			local copyTipAnimination = UIHelper.createRedTipAnimination()
			copyTipAnimination:setTag(10)
			imgTipBar:addNode(copyTipAnimination,10)
		end
		imgTipBar:setVisible(isShowTip)
	end
end

--[[desc:zhaoqiangjun 20141218 阵容按钮上的小红点
    arg1: nil
    return: nil
    ]]
function updateFormTip( bShow )
	logger:debug(bShow)
	logger:debug("显示红点提示！！！")
	if (UIHelper.isGood(m_layMainMenu)) then
		local countImgbg = m_fnGetWidget(m_layMainMenu, "IMG_FORMATION_TIP")
		if(not countImgbg:getNodeByTag(10)) then
			countImgbg:removeAllNodes()
			local copyTipAnimination = UIHelper.createRedTipAnimination()
			copyTipAnimination:setTag(10)
			countImgbg:addNode(copyTipAnimination, 10)
		end
		countImgbg:setVisible(bShow)
	end
end
--[[desc:李卫东 20140813 副本冒险按钮上的小红点
    arg1: nil
    return: nil
—]]
function updateCopyTip( ... )
	if (m_layMainMenu) then
		local isShowTip = false
		local countImgbg = m_fnGetWidget(m_layMainMenu, "IMG_TIP_COPY")
		local worldData = DataCache.getEliteCopyData()
		if (worldData~=nil) then
			if (worldData.can_defeat_num and tonumber(worldData.can_defeat_num)>0) then
				isShowTip=true
			else
				isShowTip=false
			end
		else
			isShowTip=false
		end
		require "script/module/guild/GuildDataModel"
		require "script/module/guild/GuildUtil"
		if (GuildDataModel.getIsHasInGuild() and GuildUtil.isGuildCopyOpen()) then
			require "script/module/guildCopy/GCItemModel"
			if (GCItemModel.getAtackNum()>0 and GuildCopyModel.isHaveAttackingCopy()) then
				isShowTip=true
			end
		end

		if(not countImgbg:getNodeByTag(10)) then
			countImgbg:removeAllNodes()
			local copyTipAnimination = UIHelper.createRedTipAnimination()
			copyTipAnimination:setTag(10)
			countImgbg:addNode(copyTipAnimination, 10)
		end
		countImgbg:setVisible(isShowTip)
	end
end

-- menghao 公告弹出后改变公告已经显示次数
function addNoticeTime( ... )
	m_showNoticeTime = m_showNoticeTime + 1
end


function  buttonCircleAnimation( imageLayout )

-- local m_arAni1 = UIHelper.createArmatureNode({
--          filePath =  "images/main/mainbutton/button1.ExportJson",
--          animationName = "button1",
--          loop = 1,
--          fnMovementCall = nil,
--      })
--      if (imageLayout:getNodeByTag(1023)) then
--          imageLayout:getNodeByTag(1023):removeFromParentAndCleanup(true)
--          imageLayout:removeNodeByTag(1023)
--      end
--        --  m_arAni1:setAnchorPoint(ccp(0.5,0.49))
--          imageLayout:addNode(m_arAni1,-1,1023)


end

function updateBgLightOfMenu( ... )
	if (m_imgLastGlow) then
		m_imgLastGlow:setEnabled(false)
	end

	local glowName = m_btnModuleMap[LayerManager.curModuleName()]
	if (glowName) then
		m_imgLastGlow = m_fnGetWidget(m_layMainMenu, "IMG_" .. glowName)
		m_imgLastGlow:setEnabled(true)
	end
	-- 以上是 2015-03-18 修改
end

--创建主船模块，返回Layout对象
fnCreateMainShip = function ( ... )
	if (LayerManager.curModuleName() ~= MainShip.moduleName()) then
		local layout = MainShip.create()
		if (layout) then
			LayerManager.changeModule(layout, MainShip.moduleName(), {1, 3}, true)
			PlayerPanel.addForMainShip()
			updateBgLightOfMenu() -- 刷新主菜单光晕背景的显示
		end
	end
end

--[[desc:创建跑马灯UI
 arg:跑马灯显示的文本字符串
 return: panel
 ]]
fnCreatePaoMaDeng = function ()
	require "script/module/main/TopBar"
	local layPaomadeng = TopBar.create()
	layPaomadeng:setName("PaoMaDeng")
	layRoot:addChild(layPaomadeng, nZPmd, nZPmd)
	LayerManager.insertPMDParents(layRoot,nZPmd)
end

--[[desc:创建主菜单
 arg:依次为菜单按钮对应的function handler
 return: panel
 ]]
fnCreateMainMenu = function ( ... )
	m_imgLastGlow = nil
	-- local tbNames = {"HOME", "FORMATION", "COPY", "TRAIN", "BAR", "BAG", }
	local tbEvents = {...}

	m_layMainMenu = m_fnLoadUI("ui/home_menu.json")

	-- zhangqi, 清理主菜单引用变量的方法
	-- UIHelper.registExitAndEnterCall(m_layMainMenu, function ( ... )
	
	-- end)

	--zhangjunwu 2015-8-25 充值成功后更新酒馆的红点  ------start
	--	Xufei 2015-10-15 增加深海监狱领取扫荡奖励后更新试炼红点注册通知
	local  function updateSHopInfo	(  )
		function shopInfoCallback( cbFlag, dictData, bRet )
			DataCache.setShopCache(dictData.ret)
			updateShopTip()
		end

		if(SwitchModel.getSwitchOpenState(ksSwitchShop) == true) then
			RequestCenter.shop_getShopInfo(shopInfoCallback, nil)
		end
	end

	UIHelper.registExitAndEnterCall(m_layMainMenu,
		function()
			m_layMainMenu = nil
			GlobalNotify.removeObserver("PUSHCHARGEOK", "CHARGEOK_UPDATE_SHOP")
			GlobalNotify.removeObserver("IMPEL_DOWN_UPDATE_TIP", "IMPEL_DOWN_END_SWEEP_UPDATE_TRAIN") -- Xufei 2015-10-15
			GlobalNotify.removeObserver(MineModel._MSG_.CB_REFRESH_TIP, "MainScene")
		end,
		function()
			GlobalNotify.addObserver("PUSHCHARGEOK", updateSHopInfo, nil, "CHARGEOK_UPDATE_SHOP")
			GlobalNotify.addObserver("IMPEL_DOWN_UPDATE_TIP", function ( ... )
				updateTrainTip()
			end, nil, "IMPEL_DOWN_END_SWEEP_UPDATE_TRAIN") -- Xufei 2015-10-15
			GlobalNotify.addObserver(MineModel._MSG_.CB_REFRESH_TIP, function ( ... )
				updateTrainTip()
			end, nil, "MainScene")
		end
	) 
	--zhangjunwu 2015-8-25 充值成功后更新酒馆的红点  ------end
	
	for i, v in ipairs(m_btnBaseName) do
		local btn = m_fnGetWidget(m_layMainMenu, "BTN_" .. v)
		if (btn) then
			btn:addTouchEventListener(tbEvents[i])
			btn.moduleName = "MODULE_" .. v
		end
		local glow = m_fnGetWidget(m_layMainMenu, "IMG_" .. v) -- 2015-03-18, 隐藏所有光圈
		glow:setEnabled(false)
	end

	if (layRoot) then
		layRoot:addChild(m_layMainMenu, nZMenu, nZMenu)
	end

	updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示

	updateBagPoint() -- 2014-08-08, zhangqi, 刷新背包按钮的红点提示

	updateShopTip() 	-- menghao 商店小红点
	updateCopyTip()		--liweidong 副本小红点
	schedule(m_layMainMenu,updateCopyTip,1.0) --liweidong 副本小红点
	updateTrainTip()	-- Xufei 试炼小红点

	logger:debug("pass createMainMenu")

	--检测阵容的红点
	ItemUtil.justiceBagInfo()
end

-- 主菜单各按钮触摸回调函数
function homeCallback( ... )
	if (MainShip.moduleName() ~= LayerManager.curModuleName()) then
		fnCreateMainShip()
		m_showNoticeTime = m_showNoticeTime or 0
		if (m_showNoticeTime == 0 and (BTUtil:getGuideState() == false)) then
			AnnounceCtrl.create()
		end
	end
end
-- 主页按钮
local function onHome( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		DropUtil.releaseAllRsumInfo()
		AudioHelper.playMainMenuBtn()
		-- AudioHelper.playMainMusic()

		local tfdHome = m_fnGetWidget(m_layMainMenu,"IMG_HOME_NAME")

		if (sender == nil) then
			sender = m_fnGetWidget(m_layMainMenu, "BTN_HOME")
		end
		UIHelper.buttonCircle(sender)-- lizy ,放大效果
		UIHelper.buttonCircle(tfdHome)-- lizy ,放大效果

		homeCallback()
	end
end
--[[desc: 改变下面六个主菜单 光圈效果的显示    ---lizy add 10.22
    参数：nSwithShow: 传入数字  1：主船按钮显示，2，整容按钮 显示，3冒险按钮显示 4 试炼显示 5 酒馆显示 6 背包显示
    return:  
—]]
function changeMenuCircle( nSwithShow )
	local btnShow =  m_fnGetWidget(m_layMainMenu, "BTN_" .. m_btnBaseName[nSwithShow or 1])
	for i, v in ipairs(m_btnBaseName) do
		local btnBg = m_fnGetWidget(m_layMainMenu, "BTN_" .. v)
		if (i == nSwithShow) then
			if (btnBg:getNodeByTag(1023) == nil) then
				UIHelper.buttonCircle(btnBg)
				buttonCircleAnimation(btnBg)
			end
		else
			if (btnBg:getNodeByTag(1023)) then
				btnBg:getNodeByTag(1023):removeFromParentAndCleanup(true)
				btnBg:removeNodeByTag(1023)
			end
		end
	end
end
function onFormation( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		DropUtil.releaseAllRsumInfo()
		local tfdFormation = m_fnGetWidget(m_layMainMenu,"IMG_FORMATION_NAME")
		-- AudioHelper.playMainMusic()
		if (sender == nil) then
			sender = m_fnGetWidget(m_layMainMenu, "BTN_FORMATION")
		end
		if (sender and not sender.isNoAudio) then 
			AudioHelper.playMainMenuBtn()  --modify yangna 2016.3.9策划需求失败结算面板阵容按钮音效为 anniu.mp3
		end 

		if (m_layMainMenu) then
			UIHelper.buttonCircle(sender)-- lizy ,放大效果
			UIHelper.buttonCircle(tfdFormation)
		end
		require "script/module/switch/SwitchModel"
		if(not SwitchModel.getSwitchOpenState(ksSwitchFormation,true)) then
			return
		end

		require "script/module/formation/MainFormation"
		if (MainFormation.moduleName() ~= LayerManager.curModuleName()) then
			local layFormation = MainFormation.create(0)
			if (layFormation) then
				LayerManager.changeModule(layFormation, MainFormation.moduleName(), {1,3}, true)
			end
			updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
		end
	end
end
local function onCopy( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		DropUtil.releaseAllRsumInfo()
		local tfdCopy = m_fnGetWidget(m_layMainMenu,"IMG_COPY_NAME")
		AudioHelper.playMainMenuBtn()
		if (sender == nil) then
			sender = m_fnGetWidget(m_layMainMenu, "BTN_COPY")
		end
		UIHelper.buttonCircle(sender)-- lizy ,放大效果
		UIHelper.buttonCircle(tfdCopy)
		logger:debug("onCopy name = %s", sender:getName())


		require "script/module/guide/GuideCtrl"
		require "script/module/guide/GuideShipMainView"
		if GuideShipMainView.guideStep == 6 and GuideModel.getGuideClass() == ksGuideMainShip then
			GuideCtrl.removeGuide()
		end

		require "script/module/copy/MainCopy"
		if (MainCopy.moduleName() ~= LayerManager.curModuleName() or MainCopy.isInExploreMap()) then
			MainCopy.destroy()
			LayerManager.changeModule(Layout:create(), "ExploreAndCopyChange", {}, true)
		
			TimeUtil.timeStart("copyModule")
			TimeUtil.timeStart("copyCreatModul")
			local layCopy = MainCopy.create()
			TimeUtil.timeEnd("copyCreatModul")
			if (layCopy) then
				LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
				TimeUtil.timeEnd("copyModule")
				PlayerPanel.addForCopy()
				MainCopy.updateBGSize()
				MainCopy.setFogLayer()
				
			end
			updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
		end
	end
end

local function onTrain( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		DropUtil.releaseAllRsumInfo()
		AudioHelper.playMainMenuBtn()
		-- AudioHelper.playMainMusic()
		local tfdTrain = m_fnGetWidget(m_layMainMenu,"IMG_ACT_NAME")

		if (sender == nil) then
			sender = m_fnGetWidget(m_layMainMenu, "BTN_TRAIN")
		end
		UIHelper.buttonCircle(sender)-- lizy ,放大效果
		UIHelper.buttonCircle(tfdTrain)-- lizy ,放大效果

		require "script/module/switch/SwitchModel"
		if(not SwitchModel.getSwitchOpenState(ksSwitchActivity,true)) then
			return
		end
		require "script/module/activity/MainActivityCtrl"
		if (MainActivityCtrl.moduleName() ~= LayerManager.curModuleName()) then
			MainActivityCtrl.create()
			updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
		end
	end
end

local function onShop(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		DropUtil.releaseAllRsumInfo()
		local tfdShop = m_fnGetWidget(m_layMainMenu,"IMG_BAR_NAME")
		AudioHelper.playMainMenuBtn()
		-- AudioHelper.playMainMusic()
		if (sender == nil) then
			sender = m_fnGetWidget(m_layMainMenu, "BTN_BAR")
		end
		UIHelper.buttonCircle(sender)-- lizy ,放大效果
		UIHelper.buttonCircle(tfdShop)
		logger:debug("onShop name = %s", sender:getName())

		require "script/module/switch/SwitchModel"
		if(not SwitchModel.getSwitchOpenState(ksSwitchShop,true)) then
			return
		end
		require "script/module/shop/MainShopCtrl"

		if (MainShopCtrl.moduleName() ~= LayerManager.curModuleName()) then
			local layShop = MainShopCtrl.create()
			if (layShop) then
				LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
				PlayerPanel.addForPublic()
			end
			updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
		end
	end
end

function getBagBtn( ... )
	if (m_layMainMenu) then
		return m_fnGetWidget(m_layMainMenu, "BTN_BAG")
	end
end

-- 刷新背包按钮的红点
function updateBagPoint( ... )
	logger:debug("MainScene-updateBagPoint")
	if (m_layMainMenu) then
		local btnBag = m_fnGetWidget(m_layMainMenu, "BTN_BAG")
		if (btnBag) then
			local imgTip = m_fnGetWidget(m_layMainMenu, "IMG_TIP_BAG")
			imgTip:removeAllNodes()
			-- 2015-10-9 装备红点的判断不使用g_redPoint，是通过装备碎片数目改变，此处对g_redPoint中equip字段的判断暂时保留，其实没用。
			require "script/model/utils/EquipFragmentHelper"
			require "script/module/specialBag/SBListModel"
			-- 此处添加这些碎片个数的判断独立于利用物品变动的推送引起的g_redPoint变动，用于在刚刚进入游戏时显示红点
			require "script/module/grabTreasure/TreasureData"
			local treaFragNum = TreasureData.getCanFuseNum()
			logger:debug({treaFragNum = treaFragNum})
			logger:debug({g_redPoint = g_redPoint})
			logger:debug(EquipFragmentHelper.getCanFuseNum())
			logger:debug(SBListModel.getFragCompoundNum())
			if (g_redPoint.equip.visible or g_redPoint.conch.visible or g_redPoint.bag.visible or g_redPoint.treasure.visible or g_redPoint.special.visible or EquipFragmentHelper.getCanFuseNum() > 0 or SBListModel.getFragCompoundNum() > 0 or treaFragNum > 0 or g_redPoint.awake.visible) then
				imgTip:addNode(UIHelper.createRedTipAnimination())
			elseif (g_redPoint.bag.lastVisible) then -- 如果上次是显示的状态才需要清除新增标志
				g_redPoint.bag.lastVisible = false
				DataCache.clearNewFlagOfItem() -- zhangqi, 2014-12-22, 重置红点后清除缓存背包的道具上的新增标志
			end
		end
	end
end
local function onBag( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local tfdBag = m_fnGetWidget(m_layMainMenu,"IMG_BAG_NAME")
		AudioHelper.playBtnEffect("anniu_beibao.mp3")
		AudioHelper.playMainMenuBtn()
		
		if (sender == nil) then
			sender = m_fnGetWidget(m_layMainMenu, "BTN_BAG")
		end
		UIHelper.buttonCircle(sender)-- lizy ,放大效果
		UIHelper.buttonCircle(tfdBag)
		logger:debug("onBag name = %s", sender:getName())

		require "script/module/main/BagListView"
		local bagListView = BagListView:new()
		LayerManager.addLayoutNoScale(bagListView:create())

	end
end

--创建公共模块
function CreatePublic( nTag )
	-- zhangqi, 2014-07-16, 断网重新登录后切换模块导致layRoot被置为nil, 加判断避免Lua错误和无法显示玩家信息面板和主菜单等公共UI
	if (not layRoot) then
		layRoot = LayerManager.getRootLayout()
	end

	if (nTag == nZPmd) then
		if (not layRoot:getChildByTag(nZPmd)) then
			fnCreatePaoMaDeng()
		end
	elseif (nTag == nZPlayer) then
		if (not layRoot:getChildByTag(nZPlayer)) then
			PlayerPanel.addForMainShip()
		end
	elseif (nTag == nZMenu) then
		if (not layRoot:getChildByTag(nZMenu)) then
			fnCreateMainMenu(onHome, onFormation, onCopy, onTrain, onShop, onBag)
		end
	end
end

function init( ... )
	m_showNoticeTime = 0
	m_layMainMenu = nil
end

-- 析构函数，释放纹理资源
function destroy( ... )
	logger:debug("call MainScene.destroy")
	m_layMainMenu = nil
	package.loaded["MainScene"] = nil
end

function create( ... )
	m_ExpCollect:start("MainScene")

	init()

	if(g_system_type == kBT_PLATFORM_IOS ) then
		-- 注册 烧鸡 本地通知 add by huxiaozhou 2014-05-29
		NotificationManager:cancelAllLocalNotification()
		require "script/utils/NotificationUtil"
		NotificationUtil.addChickenEnergyNotification_noon()
		NotificationUtil.addChickenEnergyNotification_evening()
		NotificationUtil.addChickenEnergyNotification_night()
		-- 注册世界boss本地通知 add by lvnanchun 2015-12-7
		NotificationUtil.addWorldBossStartNotification()
	end

	require "script/module/guide/GuideModel"
	GuideModel.setGuideClass() -- 跳过重新登录之前的新手引导，不会影响加断点的新手引导
	SwitchCtrl.reset()
	require "script/module/guide/GuideCtrl"
	GuideCtrl.removeGuide()
	m_ExpCollect:info("MainScene", "Guide process ok")

	layRoot = LayerManager.getRootLayout()

	fnCreateMainMenu(onHome, onFormation, onCopy, onTrain, onShop, onBag)
	m_ExpCollect:info("MainScene", "CreateMainMenu ok")

	fnCreateMainShip()
	m_ExpCollect:info("MainScene", "CreateMainShip ok")

	AudioHelper.playMainMusic()

	-- menghao 将引导初始化放在这里，之后再判断引导状态弹出公告
	require "script/module/guide/GuideCtrl"
	GuideCtrl.createPersistenceGuide()
	m_ExpCollect:info("MainScene", "GuideCtrl.createPersistenceGuide ok")

	-- m_showNoticeTime = m_showNoticeTime or 0
	logger:debug("MainScene: getGuideState = %s", tostring(BTUtil:getGuideState()))
	if (m_showNoticeTime == 0 and (BTUtil:getGuideState() == false)) then
		AnnounceCtrl.create()
		m_ExpCollect:info("MainScene", "AnnounceCtrl.create ok")
	end

	m_ExpCollect:finish("MainScene")

	-- 版署版公告
	-- if (not g_debug_mode) then
	-- 	LayerManager.addLayout(UIHelper.createEditionCheckNotice())
	-- end

end




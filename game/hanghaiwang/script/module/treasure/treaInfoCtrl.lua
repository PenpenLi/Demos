-- FileName: treaInfoCtrl.lua
-- Author:menghao
-- Date: 2014-04-00
-- Purpose: 宝物信息控制模块
--[[TODO List]]

module("treaInfoCtrl", package.seeall)
require "script/module/treasure/treaInfoView"
require "script/module/treasure/treaInfoModel"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local fnEventCallBack = {} --点击事件结合
local numCurTreaId --当前选择的宝物id
local heroId --当前装备宝物的伙伴
local posIndex --当前宝物的位置
local numSrcType --来源
local m_nHeroIndex

local m_tbTreaInfo

local function init(...)

end

function destroy(...)
	package.loaded["treaInfoCtrl"] = nil
end

function moduleName()
	return "treaInfoCtrl"
end

fnEventCallBack.onBtnClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		LayerManager.removeLayout()
	end
end

--去强化
fnEventCallBack.onBtnForge = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		-- 如果宝物强化未开启，提示后直接返回
		if (not SwitchModel.getSwitchOpenState(ksSwitchTreasureForge,true) ) then
			return
		end

		-- 先判断是否经验宝物，如果是经验宝物提示不能强化，避免多调用一次treaForgeCtrl.create
		local treaInfo = treaInfoModel.fnGetTreasAllData(numCurTreaId)
		assert(treaInfo, "treadId not found:" .. numCurTreaId)
		if (treaInfo.dbData.isExpTreasure == 1 or tonumber(treaInfo.dbData.id) == 501010) then
			ShowNotice.showShellInfo(m_i18n[1512])
			return
		end

		require "script/module/treasure/treaForgeCtrl"
		LayerManager.removeLayout()
		local layout = treaForgeCtrl.create(numCurTreaId,numSrcType, m_nHeroIndex)
		LayerManager.changeModule(layout, treaForgeCtrl.moduleName(), {1, 3}, true)
		--PlayerPanel.addForPublic()
		PlayerPanel.addForPartnerStrength()
	end
end

--去精炼
fnEventCallBack.onBtnFefining = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		require "script/module/treasure/treaRefineCtrl"
		treaRefineCtrl.create(numCurTreaId,numSrcType, m_nHeroIndex)
	end
end


--去获取
fnEventCallBack.onDrop = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		require "script/module/public/FragmentDrop"
		local treaDB  = m_tbTreaInfo.treaData.dbData
		local fragFeild = treaDB.fragment_ids
		if (fragFeild) then
			local tbfrag = lua_string_split(fragFeild, "|")
			local fragTid = tonumber(tbfrag[1])
			logger:debug({fragTid=fragTid})
			PublicInfoCtrl.createItemDropInfoViewByTid(fragTid,nil,true)
		else
			PublicInfoCtrl.createItemDropInfoViewByTid(treaDB.id,nil,true)
		end
	end
end

local function removeTreasureCallback( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("卸下宝物回掉 的时候把宝物背包的数据清空")
		BagModel.setBagUpdateByType(BAG_TYPE_STR.treas)

		local allHeros = HeroModel.getAllHeroes()
		local oldConch = allHeros[tostring(heroId)].equip.treasure[tostring(posIndex)]
		if(oldConch and tonumber(oldConch) ~= 0) then
			ItemUtil.pushitemCallback(oldConch, 2)
		end

		HeroModel.removeTreasFromHeroBy(heroId,posIndex)
		LayerManager.removeLayout()
		
		UserModel.setInfoChanged(true)
		UserModel.updateFightValue({[heroId] = {HeroFightUtil.FORCEVALUEPART.TREASURE,
												HeroFightUtil.FORCEVALUEPART.MASTER,
												HeroFightUtil.FORCEVALUEPART.UNION,
												},})

		require "script/module/formation/MainFormation"
		MainFormation.removeHeroTreasure(posIndex) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效

		MainFormation.showFlyQuality()
	end
end

-- 更换宝物
fnEventCallBack.onChange = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		LayerManager.removeLayout()
		require "script/module/formation/AddTreaChooseCtrl"
		local tbInfo = {hid = heroId, treaType = posIndex, from = 0}
		local treasList = AddTreaChooseCtrl.create(tbInfo)
		LayerManager.addLayoutNoScale(treasList, LayerManager.getModuleRootLayout())
		UIHelper.changepPaomao(treasList) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
	end
end

--卸载宝物
fnEventCallBack.onBtnUnload = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		if(ItemUtil.isTreasBagFull(true, function () LayerManager.removeLayout() end))then
			return
		end
		if (heroId and posIndex) then
			local args = Network.argsHandler(heroId, posIndex)
			RequestCenter.hero_removeTreasure(removeTreasureCallback,args )
		end
	end
end

-- 获取途径
fnEventCallBack.onGain = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local treaType
		if (m_tbTreaInfo.treaData.dbData.type == 0) then
			treaType = 1
		else
			treaType = m_tbTreaInfo.treaData.dbData.type
		end
		require "script/module/treasure/treaRefineCtrl"

		-- 先更新宝物碎片数据
		require "script/module/grabTreasure/TreasureService"
		if (not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure, false)) then
			return
		end
		TreasureService.getSeizerInfo(function ( ... )
		end)
	end
end

--前往夺宝
fnEventCallBack.onBtnRob = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		require "script/module/grabTreasure/MainGrabTreasureCtrl"
		MainGrabTreasureCtrl.create()
	end
end

function initScv( ... )
	treaInfoView.initScvHeight()
end


-- 1, 获取途径，可进阶 2, 确定，可进阶 3,	 确定，不可进阶 4 ,获取途径，不可进阶 5 抢夺 ，不可进阶
function create(treasureId, srcType, _hid, _posIndex, level, evolve, heroIndex, heroLv, isDrawTip)
	numCurTreaId = treasureId
	numSrcType = srcType
	m_nHeroIndex = heroIndex

	heroId = _hid
	posIndex = _posIndex
    
	if (numCurTreaId) then
		local openFetter = treaInfoModel.fnOpenFetters(numCurTreaId)
		local treasInfo = treaInfoModel.getSimpleTreaInfo(numCurTreaId, srcType) -- zhangqi, 2015-06-15
		-- zhangqi, 2015-06-15
		treasInfo.awakeInfo = treaInfoModel.fnGetAwakeInfo(treasInfo.treaData.dbData, treasInfo.treaData.equip_hid)

		m_tbTreaInfo = treasInfo

		if level then
			if tonumber(level) >= 1 then
				treasInfo.level = tonumber(level)
				treasInfo.property = treaInfoModel.fnGetTreaProperty(numCurTreaId, tonumber(level))
			end
		end

		if evolve then
			if (treasInfo.treaData) then
				if (treasInfo.treaData.va_item_text) then
					treasInfo.treaData.va_item_text.treasureEvolve = evolve
				end
			end
		end

		if (openFetter) then
			LayerManager.hideAllLayout("treaInfoCtrl")
		end

		local treasureLayer = treaInfoView.create(openFetter,treasInfo,numSrcType,fnEventCallBack, heroLv, isDrawTip)

		return treasureLayer
	end
end

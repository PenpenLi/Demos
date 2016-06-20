-- FileName: GameBookCtrl.lua
-- Author: LvNanchun
-- Date: 2015-12-22
-- Purpose: function description of module
--[[TODO List]]

module("GameBookCtrl", package.seeall)

-- UI variable --

-- module local variable --
local _instanceView
-- 界面中各个按钮的状态。mainTab为1，2，3。mainList为定位的index
local _tbBtnState = {}

local function init(...)

end

function destroy(...)
    package.loaded["GameBookCtrl"] = nil
end

function moduleName()
    return "GameBookCtrl"
end

--[[desc:关闭按钮回调
    arg1: 
    return: 
—]]
local function onClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
	end
end

--[[desc:根据左侧listView按钮的按钮类型初始化中间的界面
    arg1: 按钮类型
    return: 无 
—]]
function initLayByBtnType( btnType )
	_instanceView:initLayByBtnType( btnType )
end

--[[desc:刷新中间的主要显示区
    arg1: 左侧listView的按钮类型
    return: 无  
—]]
function reloadMainLay( btnType, infoIndex )
	if (btnType == 1) then
		-- 推荐阵容
		local tbMainLayInfo = GameBookModel.getRecommendFormationInfo()
		_instanceView:reloadMainLayFormation(tbMainLayInfo)
	elseif (btnType == 2) then
		-- 推荐伙伴
		local tbMainLayInfo = GameBookModel.recommendPartner( infoIndex )
		_instanceView:reloadMainLayRecommendPartner( tbMainLayInfo )
	elseif (btnType == 3) then
		-- 伙伴图鉴
		local tbMainLayInfo = GameBookModel.partnerDictionary(infoIndex)
		local tbHaveNumInfo = GameBookModel.partnerDictionaryNum(infoIndex)
		_instanceView:reloadPartnerDictionary(tbMainLayInfo, tbHaveNumInfo)
	elseif (btnType == 4) then
		-- 我要变强
		local tbMainLayInfo = GameBookModel.wantStrong( infoIndex )
		_instanceView:reloadMainLayWantStrong( tbMainLayInfo )
	end
end

--[[desc:刷新界面左侧的listView
    arg1: mainTab是主标签的索引
    return: 无  
—]]
function reloadMainListView( mainTabIndex )
	local mainListInfo = GameBookModel.getMainListViewInfo(mainTabIndex)
	logger:debug("GameBookCtrl")
	logger:debug({mainListInfo = mainListInfo})
	for i,v in ipairs(mainListInfo.tbList) do 
		mainListInfo.tbList[i].btnFunc = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playTabEffect()
				initLayByBtnType(v.btnType)
				logger:debug({reloadMainListView = v.btnType})
				reloadMainLay(v.btnType, v.infoIndex)
				_instanceView:setMainListPreBtn(sender)
			end
		end
	end
	_instanceView:reloadMainList(mainListInfo)
	if (mainTabIndex == 1) then
		initLayByBtnType(1)
		reloadMainLay(1)
	elseif (mainTabIndex == 2) then
		initLayByBtnType(3)
		reloadMainLay(3, 4)
	elseif (mainTabIndex == 3) then
		initLayByBtnType(4)
		reloadMainLay(4, 1)
	end
end

--[[desc:点击tab上的按钮的共有事件
    arg1: 标点的索引
    return: 无
—]]
local function tabFunc( mainTabIndex )
	_tbBtnState.mainTab = mainTabIndex
	_instanceView:reloadMainTab(mainTabIndex)
	reloadMainListView(mainTabIndex)
end

--[[desc:推荐阵容按钮的回调
    arg1: 
    return: 
—]]
local function onRecommendFormation( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		tabFunc(1)
		logger:debug("recommondFormation")
	end
end

--[[desc:伙伴图鉴的按钮回调
    arg1: 
    return:
—]]
local function onPartnerDictionary( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		tabFunc(2)
		logger:debug("onPartnerDictionary")
	end
end

--[[desc:我要变强按钮回调
    arg1: 
    return: 
—]]
local function onWantStrong( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		tabFunc(3)
		logger:debug("onWantStrong")
	end
end

--[[desc:刷新战斗力
    arg1: 无
    return: 无
—]]
function reloadFightValue(  )
	local fightValue = UserModel.getFightForceValue()
	local function onRise( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			MainRaiseFightCtrl.create()
		end
	end
	_instanceView:reloadFightValue(fightValue, onRise)
end

function create(...)
	GameBookModel.setHadPartner(DataCache.getHeroBook())
	-- 设置默认值
	_tbBtnState.mainTab = 1
	
	_instanceView = GameBookView:new(_tbBtnState)
	tabFunc(1)
	reloadFightValue()
	
	-- 主界面上的主要按钮事件
	local tbBtn = {}
	tbBtn.onClose = onClose
	tbBtn.onRecommendFormation = onRecommendFormation
	tbBtn.onPartnerDictionary = onPartnerDictionary
	tbBtn.onWantStrong = onWantStrong
	
	LayerManager.addLayout(_instanceView:create(tbBtn))
end


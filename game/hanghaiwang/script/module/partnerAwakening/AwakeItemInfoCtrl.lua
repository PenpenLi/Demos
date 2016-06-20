-- FileName: AwakeItemInfoCtrl.lua
-- Author: LvNanchun
-- Date: 2015-11-18
-- Purpose: 觉醒物品信息界面控制器
--[[TODO List]]

module("AwakeItemInfoCtrl", package.seeall)

-- UI variable --

-- module local variable --
local _itemInfo = {}
local _viewInstance

local function init(...)

end

function destroy(...)
    package.loaded["AwakeItemInfoCtrl"] = nil
end

function moduleName()
    return "AwakeItemInfoCtrl"
end

-- 关闭按钮事件
local function fnBtnClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
	end
end

-- 确认按钮事件
local function fnBtnSure( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		LayerManager.removeLayout()
	end
end

-- 刷新界面上的拥有数量
function refreshHaveNum(  )
	local haveNum = ItemUtil.getAwakeNumByTid(_itemInfo.itemId)
	_viewInstance:refreshHaveNum( haveNum )
end

function create( itemId, fromType, tbFnCallBack )
	_viewInstance = AwakeItemInfoView:new()

	-- 根据id获取构造界面的数据
	local tbInfo = {}
	tbInfo = AwakeItemInfoModel.getInfoById( itemId )
	logger:debug({AwakeItemInfoModel = tbInfo})
	-- 添加图标按钮和按钮事件
	-- 信息面板点击图标不应该有按钮事件
	local function fnBtnIcon( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("press icon")
		end
	end
	tbInfo.icon = ItemUtil.createBtnByTemplateId(itemId, fnBtnIcon, {false, false})
	_itemInfo = tbInfo

	-- 根据不同的按钮形式构造不同的按钮事件，需要什么按钮传什么回调
	local tbBtn = {}
	-- 显示确认按钮
	if (fromType == "bag") then
		tbBtn.close = fnBtnClose
		tbBtn.sure = fnBtnSure
	elseif (fromType == "equip") then
	-- 需要显示装备按钮
		-- 构造装备按钮回调事件
		local fnBtnEquip = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				tbFnCallBack.equip()
				--LayerManager.removeLayout()
			end
		end
		tbBtn.equip = fnBtnEquip
		tbBtn.close = fnBtnClose
	elseif (fromType == "compose") then
	-- 显示合成和获取按钮
		-- 构造获取按钮回调
		local fnBtnGain = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				tbFnCallBack.gain()
			end
		end
		-- 构造合成按钮回调
		local fnBtnCompose = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				tbFnCallBack.compose()
			end
		end
		tbBtn.gain = fnBtnGain
		tbBtn.compose = fnBtnCompose
		tbBtn.close = fnBtnClose
	-- 不是从以上途径进入的
	else
		tbBtn.close = fnBtnClose
		tbBtn.sure = fnBtnSure
	end

	local infoView = _viewInstance:create( tbBtn, tbInfo )

	LayerManager.addLayout(infoView)
end


-- FileName: copyAwakeRewardView.lua
-- Author: liweidong
-- Date: 2015-11-19
-- Purpose: 副本得星宝箱
--[[TODO List]]

module("copyAwakeRewardView", package.seeall)

-- UI控件引用变量 --
local _layoutMain

-- 模块局部变量 --
local _copyId
local _boxId
local _tbCopyInfo
local g_fnGetWidgetByName = g_fnGetWidgetByName

local function init(...)

end

function destroy(...)
	package.loaded["copyAwakeRewardView"] = nil
end

function moduleName()
    return "copyAwakeRewardView"
end
--奖励物品预览
local function fnRewardGoods( layerReward )
	local tbGoodsTmp
	if (_boxId == 3) then
		tbGoodsTmp = _tbCopyInfo["pt_box"]
	elseif (_boxId == 2) then
		tbGoodsTmp = _tbCopyInfo["au_box"]
	else
		tbGoodsTmp = _tbCopyInfo["ag_box"]
	end

	if(tbGoodsTmp ~= nil) then
		local goodsTemp = RewardUtil.parseRewards(tbGoodsTmp)
		for i=1,4 do
			if (i <= #goodsTemp) then
				local goodsImg = g_fnGetWidgetByName(layerReward, "IMG_"..i, "ImageView")
				local goodsTitle = g_fnGetWidgetByName(layerReward, "TFD_NAME_"..i, "Label")
				
				goodsImg:addChild(goodsTemp[i].icon)
				if (goodsTitle) then
					goodsTitle:setText(goodsTemp[i].name)
					goodsTitle:setColor(g_QulityColor[tonumber(goodsTemp[i].quality)])
				end
			else
				local dropLayer = g_fnGetWidgetByName(layerReward, "LAY_DROP"..i, "Layout")
				if (dropLayer) then
					dropLayer:setVisible(false)
				end
			end
		end
	end
end
--国际化
function setUIStyleAndI18n(base)
	UIHelper.titleShadow(base.BTN_GET,gi18n[1315])
	-- base.BTN_BACK:setTitleText(m_i18n[1019])
	-- base.TFD_SOLDIER_LEVEL:setText(m_i18n[1067])
	-- base.tfd_soldier_con:setText(m_i18n[3708])
	-- base.tfd_active:setText(m_i18n[5931])
	-- base.tfd_soldier_title:setText(m_i18n[5955])
end
--加载UI
function loadUI()
	_layoutMain = g_fnLoadUI("ui/copy_reward.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		)
	setUIStyleAndI18n(_layoutMain)
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	
	local starTemp = lua_string_split(_tbCopyInfo.starlevel,",")
	local starNum = tonumber(starTemp[_boxId])
	_layoutMain.TFD_NUM:setText(starNum)

	local rewardStatus = copyAwakeModel.getCopyRewardStatusById(_copyId)
	if (rewardStatus[_boxId]==2) then
		_layoutMain.BTN_GET:setEnabled(false)
		_layoutMain.IMG_CANNOTGET:setVisible(false)
	elseif (rewardStatus[_boxId]==1) then
		_layoutMain.IMG_CANNOTGET:setVisible(false)
		_layoutMain.IMG_RECEIVED:setVisible(false)
		_layoutMain.BTN_GET:addTouchEventListener(function( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					copyAwakeCtrl.onGetBoxReward(_copyId,_boxId)
				end
			end)
	else
		UIHelper.setWidgetGray(_layoutMain.IMG_CANNOTGET,true)
		_layoutMain.IMG_RECEIVED:setVisible(false)
		_layoutMain.BTN_GET:setEnabled(false)
	end

	fnRewardGoods(_layoutMain)
	updateUI()
	return _layoutMain
end
--更新界面
function updateUI()
	
end
function create(copyId,boxId)
	_copyId = tonumber(copyId)
	_tbCopyInfo = DB_Disillusion_copy.getDataById(copyId)
	_boxId = tonumber(boxId)
	return loadUI()
end

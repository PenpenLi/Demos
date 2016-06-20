-- FileName: WARewardCtrl.lua
-- Author: Xufei
-- Date: 2016-02-18
-- Purpose: 海盗激斗 奖励预览
--[[TODO List]]

module("WARewardCtrl", package.seeall)

-- UI控件引用变量 --
local _WARewardViewIns
-- 模块局部变量 --

function getBtnFunByName( funName )
	local btnEvent = {}
	btnEvent.onChooseTab = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local tabTag = sender:getTag()
			WARewardModel.setTabName("TAB_"..tabTag)
			_WARewardViewIns:showPreview()
		end
	end

	btnEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	btnEvent.onConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end	

	return btnEvent[funName]
end


local function init(...)

end

function destroy(...)
	package.loaded["WARewardCtrl"] = nil
end

function moduleName()
    return "WARewardCtrl"
end

function create(...)
	WARewardModel.create()

	_WARewardViewIns = WARewardView:new()
	local rewardView = _WARewardViewIns:create()
	LayerManager.addLayout(rewardView) 	
end

-- FileName: WARankCtrl.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

module("WARankCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _WARankViewIns

function getBtnFunByName( funName )
	local btnEvent = {}
	btnEvent.onChooseTab = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local tabTag = sender:getTag()
			WARankModel.setTabName("TAB_"..tabTag)
			_WARankViewIns:showRankView()
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
	package.loaded["WARankCtrl"] = nil
end

function moduleName()
    return "WARankCtrl"
end

function create( rankInfo )
	logger:debug({rank_info = rankInfo})

	WARankModel.create( rankInfo )

	_WARankViewIns = WARankView:new()
	local rankView = _WARankViewIns:create()
	LayerManager.addLayout(rankView) 	
end

-- FileName: WABetCtrl.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

module("WABetCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _WABetViewIns

function getBtnFunByName( funName )
	local btnEvent = {}
	btnEvent.onChooseTab = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local tabTag = sender:getTag()
			WABetModel.setTabName("TAB_"..tabTag)
			_WABetViewIns:showBetView()
		end
	end

	btnEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
			GlobalNotify.postNotify("WABETREDPOINT")
		end
	end

	btnEvent.onConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			GlobalNotify.postNotify("WABETREDPOINT")
		end
	end	

	return btnEvent[funName]
end

function updateBetData( tbData )
	WABetModel.updateBetData(tbData, _WABetViewIns)
end

local function init(...)

end

function destroy(...)
	package.loaded["WABetCtrl"] = nil
end

function moduleName()
    return "WABetCtrl"
end

function create( betInfo )
	logger:debug({print_betInfo = betInfo})

	WABetModel.create(betInfo)

	_WABetViewIns = WABetView:new()
	local betView = _WABetViewIns:create()
	LayerManager.addLayout(betView)
end

-- FileName: WAMessageBoardCtrl.lua
-- Author: Xufei
-- Date: 2015-03-00
-- Purpose: 海盗激斗 留言板
--[[TODO List]]

module("WAMessageBoardCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _WAMsgIns = nil

function getBtnFunByName( funName )
	local btnEvent = {}

	btnEvent.onReturn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			local nState = WAUtil.getCurState()
			if (nState and (nState == WAUtil.WA_STATE.attack or nState == WAUtil.WA_STATE.reward)) then
				WAEntryCtrl.create()
			else
				local layout = MainShip.create()
				if (layout) then
					LayerManager.changeModule(layout,  MainShip.moduleName(), {1, 3}, true)
					PlayerPanel.addForMainShip()
				end
			end
		end
	end

	btnEvent.onLeaveMsg = function ()
		local leavingMsg = WAMessageBoardModel.getLeavingMsg()
		WAService.leaveMsg(leavingMsg, function ( ... )
			WAMessageBoardModel.addMyMsgNum()
			WAService.getMsg(function ( msgInfo )
				WAMessageBoardModel.create(msgInfo)
				_WAMsgIns:refreshView()
			end)
		end)
	end

	return btnEvent[funName]
end


local function init(...)
	_WAMsgIns = nil
end

function destroy(...)
	package.loaded["WAMessageBoardCtrl"] = nil
end

function moduleName()
    return "WAMessageBoardCtrl"
end


function create( msgInfo )
	logger:debug({print_msgInfo = msgInfo})

	WAMessageBoardModel.create(msgInfo)

	_WAMsgIns = WAMessageBoardView:new()
	local WAMsgView = _WAMsgIns:create()
	LayerManager.changeModule(WAMsgView, WAMessageBoardCtrl.moduleName(), {1}, true)
	
end

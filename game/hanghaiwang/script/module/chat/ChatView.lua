-- FileName: ChatView.lua
-- Author: menghao
-- Date: 2015-04-22
-- Purpose: 聊天主view


module("ChatView", package.seeall)


-- UI控件引用变量 --
local _UIMain


-- 模块局部变量 --
local mi18n = gi18n


function destroy(...)
	package.loaded["ChatView"] = nil
end


function moduleName()
	return "ChatView"
end


function upRedPoint( ... )
	_UIMain.IMG_TIP1:setEnabled(g_redPoint.chat.visible)
	_UIMain.LABN_TIP1:setStringValue(g_redPoint.chat.num)
end


function setBtnsFocusedByType( nType )
	local t = {_UIMain.BTN_WORLD, _UIMain.BTN_PRIVATE, _UIMain.BTN_LEGION, _UIMain.BTN_GM}
	for i=1,#t do
		t[i]:setFocused(i == nType)
	end
end


function create( tbEvents )
	_UIMain = g_fnLoadUI("ui/chat_frame.json")
	_UIMain.BTN_CLOSE:addTouchEventListener(tbEvents.onClose)
	_UIMain.BTN_WORLD:addTouchEventListener(tbEvents.onWorld)
	_UIMain.BTN_PRIVATE:addTouchEventListener(tbEvents.onPrivate)
	_UIMain.BTN_LEGION:addTouchEventListener(tbEvents.onUnion)
	_UIMain.BTN_GM:addTouchEventListener(tbEvents.onGM)
	UIHelper.titleShadow(_UIMain.BTN_WORLD, mi18n[2801])
	UIHelper.titleShadow(_UIMain.BTN_PRIVATE, mi18n[2802])
	UIHelper.titleShadow(_UIMain.BTN_LEGION, mi18n[2803])
	UIHelper.titleShadow(_UIMain.BTN_GM, mi18n[2804])

	UIHelper.titleShadow(_UIMain.BTN_CLOSE,mi18n[1019])
	upRedPoint()   

	return _UIMain
end



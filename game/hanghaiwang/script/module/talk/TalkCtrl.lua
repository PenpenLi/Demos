-- FileName: TalkCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-06-10
-- Purpose: function description of module
--[[TODO List]]
-- 对话 控制器


module("TalkCtrl", package.seeall)

require "script/module/talk/TalkView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["TalkCtrl"] = nil
end

function moduleName()
    return "TalkCtrl"
end

function create( talkID )
	assert(talkID,"talkID must be not nil")

	assert(LayerManager.getTalkLayer()==nil,"You can only create one talkview 只能创建一个对话")


	local talkView = TalkView.create(talkID)
	logger:debug("talkID == " .. talkID)
	LayerManager.addTalkLayer(talkView)
	TalkView.easeFunc1()
	TalkView.easeFunc2()
	-- TalkView.showNext()
end

function removeTalk(  )
	LayerManager.removeTalkLayer()
end

function setCallbackFunction( fnCallBack )
	TalkView.setCallbackFunction(fnCallBack)
end

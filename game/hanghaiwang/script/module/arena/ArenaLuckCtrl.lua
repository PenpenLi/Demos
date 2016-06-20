
-- FileName: ArenaLuckCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-12
-- Purpose: 幸运排名的控制模块

module("ArenaLuckCtrl", package.seeall)

require "script/module/arena/ArenaLuckView"
-- UI控件引用变量 --

-- 模块局部变量 --
local luckyView

local function init(...)
	luckyView = nil
end

function destroy(...)
	package.loaded["ArenaLuckCtrl"] = nil
end

function moduleName()
    return "ArenaLuckCtrl"
end

-- 得到幸运排名数据
-- callbackFunc:回调
function getLuckyList( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			logger:debug(dictData)
			ArenaData.luckyListData = dictData.ret
			callbackFunc()
		end
	end
	RequestCenter.arena_getLuckyList(requestFunc)
end


function createView(  )
	local tbBtnEvent = {}
	-- 关闭按钮
	-- tbBtnEvent.onClose = function ( sender, eventType)
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		logger:debug("tbBtnEvent.onClose")
	-- 		AudioHelper.playCloseEffect()
	-- 		LayerManager.removeLayout(luckyView)
	-- 	end
	-- end
	luckyView = ArenaLuckView.create(tbBtnEvent)
	LayerManager.addLayout(luckyView)
end


function create(...)
	getLuckyList(createView)
end

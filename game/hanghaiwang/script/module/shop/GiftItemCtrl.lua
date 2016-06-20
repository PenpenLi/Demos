-- FileName: GiftItemCtrl.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: 礼包奖励预览
--[[TODO List]]

module("GiftItemCtrl", package.seeall)
require "script/module/shop/GiftItemView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["GiftItemCtrl"] = nil
end

function moduleName()
	return "GiftItemCtrl"
end

--[[desc:
    arg1: 礼包奖励物品数据 ,arg2:vip等级
    return: 是否有返回值，返回值说明  
—]]
function create(giftData,vipLevel)
	local tbBtnEvent = {}
	--关闭按钮
	tbBtnEvent.onClose = function ( sender, eventType  )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onClose clicked")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end
	--物品按钮
	tbBtnEvent.onItem = function ( sender, eventType  )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onItem clicked")
			local vipId = sender:getTag()			--礼包id
		end
	end

	local layMain = GiftItemView.create( tbBtnEvent, giftData,vipLevel)
	return layMain
end

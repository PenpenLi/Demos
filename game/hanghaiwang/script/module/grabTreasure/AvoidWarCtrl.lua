-- FileName: AvoidWarCtrl.lua
-- Author: menghao
-- Date: 2014-5-11
-- Purpose: 夺宝免战弹出框ctrl


module("AvoidWarCtrl", package.seeall)


require "script/module/grabTreasure/AvoidWarView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["AvoidWarCtrl"] = nil
end


function moduleName()
	return "AvoidWarCtrl"
end


function create(...)
	tbInfo = {}

	-- 免战牌数量
	local itemTable = TreasureData.getShieldItemInfo()
	local itemInfo = ItemUtil.getCacheItemInfoBy(tonumber(itemTable[1].itemTid))
	if itemInfo then
		tbInfo.itemAvoidNum = tonumber(itemInfo.item_num)
	else
		tbInfo.itemAvoidNum = 0
	end

	-- 关闭按钮事件
	tbInfo.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	-- 免战牌免战
	tbInfo.onAvoidWar = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			LayerManager.removeLayout()
			local freeType = 2
			TreasureService.whiteFlag(freeType , cancelBtnCallBack)
		end
	end

	-- 金币免战
	tbInfo.onGold = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			LayerManager.removeLayout()
			local freeType = 1
			TreasureService.whiteFlag(freeType , cancelBtnCallBack)
		end
	end

	local layMain = AvoidWarView.create( tbInfo )

	return layMain
end


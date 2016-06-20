-- FileName: AddSpecialTreaRequest.lua
-- Author: yucong
-- Date: 2015-09-21	
-- Purpose: function description of module
--[[TODO List]]

module("AddSpecialTreaRequest", package.seeall)
require "script/module/specialTreasure/SpecialConst"

-- 装备专属宝物
-- @param hid 装备的武将
-- @param pos 装备的栏位
-- @param itemId 装备id
-- @param fromHid 装备所属原武将id
-- @param func 回调，默认nil
function addExclusive( hid, pos, itemId, fromHid, func )
	local args = CCArray:create()
	args:addObject(CCInteger:create(hid))
	args:addObject(CCInteger:create(pos))
	args:addObject(CCInteger:create(itemId))
	if (fromHid) then
		args:addObject(CCInteger:create(fromHid))
	end
	RequestCenter.hero_addExclusive(function ( cbFlag, dictData, bRet )
		if (func) then
			func()
		end
		-- 刷新专属宝物显示
		--GlobalNotify.postNotify(SpecialConst.MSG_RELOAD_SPECIAL)
		-- 显示阵容界面
		GlobalNotify.postNotify(SpecialConst.MSG_SPECIAL_SELECT_CLOSED)
		-- 飚字
		--GlobalNotify.postNotify(SpecialConst.MSG_PLAY_ATTRIB)
		-- 穿戴完成
		GlobalNotify.postNotify(SpecialConst.MSG_LOAD_SPECIAL_SUCCESS)
	end, args)
end
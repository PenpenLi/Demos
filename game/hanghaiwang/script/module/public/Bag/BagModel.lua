-- FileName: BagModel.lua
-- Author: zhangqi
-- Date: 2015-09-26
-- Purpose: 统一管理背包处理对象的模块
--[[TODO List]] 

-- 全局变量，保存后端背包类型名称和配置表物品类型的对应
-- BAG_TYPE = {
-- 	arm = 1,
-- 	armFrag = 5,
-- 	excl = 2,
-- 	exclFrag = 4,
-- 	heroFrag = 7,
-- 	treas = 11,
-- 	treasFrag = 12, -- 宝物碎片，目前不在后端的背包信息中，从夺宝的接口获取
-- 	conch = 13,
-- 	props = 14,
-- }

module("BagModel", package.seeall)

require "script/module/public/Bag/BagHandler"

-- 模块局部变量 --
local _tbHandler = {} -- 存放每种背包的处理对象，可以提供初始化和填充一条数据，增加删除修改一条数据等方法


-- 模块局部方法 --
-- 调试用
local function assertInfo( ... )
	return select(1, ...) .. " can not find bagType:" .. select(2, ...)
end

-- 外部访问方法 --
function createBagHandler( bagType )
	if (_tbHandler[bagType]) then
		return _tbHandler[bagType]
	end

	local basePath = "script/module/bag/"
	if (bagType == BAG_TYPE_STR.treas) then
		logger:debug("createBagHandler: BAG_TYPE_STR.treas")
		require "script/module/public/Bag/TreasBagHandler"
		_tbHandler[bagType] = TreasBagHandler:new()
		-- print(_tbHandler[bagType])
		GlobalNotify.addObserver(GlobalNotify.TREAS_CHANGED, 
			function ( ... )
				updateBagHandler(BAG_TYPE_STR.treas)
			end, false, "TREAS_BAG_CHANGED")
	elseif (bagType == BAG_TYPE_STR.treasFrag) then
		logger:debug("createBagHandler: BAG_TYPE_STR.treasFrag")
		require "script/module/public/Bag/TreasFragBagHandler"
		_tbHandler[bagType] = TreasFragBagHandler:new()
		-- print(_tbHandler[bagType])
		-- zhangqi, 2015-10-21, 注册饰品碎片变化的通知
		GlobalNotify.addObserver(GlobalNotify.TREAS_FRAG_CHANGED, 
			function ( ... )
				updateBagHandler(BAG_TYPE_STR.treasFrag)
			end, false, "TREASFRAG_BAG_CHANGED")
	elseif (bagType == BAG_TYPE_STR.awake) then                  -- 觉醒物品背包
		require "script/module/public/Bag/AwakeBagHandler"
		_tbHandler[bagType] = AwakeBagHandler:new()
	end

	_tbHandler[bagType]:init()
	_tbHandler[bagType]:initList()

	return _tbHandler[bagType]
end

-- 指定背包类型返回背包列表的处理对象
function getBagHandler( bagType )
	local bagHandler = _tbHandler[bagType] or createBagHandler(bagType)
	assert(bagHandler, assertInfo("getBagHandler", bagType))
	return bagHandler
end

function updateBagHandler( bagType )
	if (bagType) then
		local handler = getBagHandler(bagType)
		if (handler) then
			handler:updateBagInfo()
		end
	else
		for k, handler in pairs(_tbHandler) do
			handler:updateBagInfo()
		end
	end
end

function setBagUpdateByType( bagType )
	local handler = _tbHandler[bagType]
	if (handler) then
		handler:updateBagInfo()
	end
end

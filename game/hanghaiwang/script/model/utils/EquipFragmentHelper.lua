-- FileName: EquipFragmentHelper.lua
-- Author: zhangqi
-- Date: 2014-08-09
-- Purpose: 装备碎片相关的方法，主要处理数据，相当于之前的util模块
--[[TODO List]]

module("EquipFragmentHelper", package.seeall)

require "script/model/DataCache"
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["EquipFragmentHelper"] = nil
end

--[[desc: 返回当前装备碎片可合成的单个装备数量
    arg1: 参数说明
    return: Number, 可合成的单个装备数量
—]]
function getCanFuseNum( ... )
    local localBag, num = DataCache.getBagInfo(), 0
    local nOwn, nNeed = 0, 0
    for i, v in ipairs(localBag.armFrag or {}) do
        nOwn = tonumber(v.item_num)
        nNeed = tonumber(v.itemDesc.need_part_num)
        if ( nOwn >= nNeed) then
            num = num + math.floor(nOwn/nNeed) -- zhangqi, 2015-09-30, 修改为可正确处理碎片数量超过需要数量的情况
        end
    end
    
    return num
end


-- FileName: SpecTreaInfoCtrl.lua
-- Author: sunyunpeng
-- Date: 2014-09-17
-- Purpose: function description of module
--[[TODO List]]

module("SpecTreaInfoCtrl", package.seeall)
require "script/module/specialTreasure/SpecTreaInfoView"
require "script/module/specialTreasure/SpecTreaData"

require "db/DB_Item_exclusive"
require "db/DB_Item_exclusive_fragment"
require "db/DB_Exclusive_evolve"



-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["SpecTreaInfoCtrl"] = nil
end

function moduleName()
    return "SpecTreaInfoCtrl"
end

-- 参数列表
-- Tid 	专属宝物id 或者 专属宝物碎片id   refineLel  精炼等级  （只做展示时，不需要进一步进阶时候，只传2个参数即可）
-- speTreaListInfo      其他附属信息（其他界面计算后传入） { specTreaTb = { { tid --  专属宝物id  itemId -- ,refineLevel -- 精炼等级 (nil 为不可精炼 )，} 
--  																    ...
--                                                       nowTreaIndex   -- 当前索引   
--                                                                     } }
-- footerBtnType 底部边栏按钮 -1 默认确定（不可进阶），0 确定（可以进阶，自己阵容） 1 获取途径（可以进阶，背包） 2 获取途径 不可进阶（查看别人阵容）
function create(Tid,refineLel,itemId,footerBtnType)
	local specTreaData = SpecTreaData:new()
	local specInfoData = specTreaData:initInfo(Tid,refineLel,itemId,footerBtnType)

	local specTreaInfoView = SpecTreaInfoView:new()
	local speTreaLayout = specTreaInfoView:init(specInfoData,footerBtnType)

	LayerManager.addLayout(speTreaLayout,nil,nil,nil,true)

end








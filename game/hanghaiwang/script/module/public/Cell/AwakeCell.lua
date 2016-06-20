-- FileName: AwakeCell.lua
-- Author: LvNanchun
-- Date: 2015-11-11
-- Purpose: function description of module
--[[TODO List]]
require "script/module/public/Cell/Cell"
AwakeCell = class("AwakeCell", Cell)

-- UI variable --

-- module local variable --

function AwakeCell:moduleName()
    return "AwakeCell"
end


-- sUseType, 取值范围 CELL_USE_TYPE
function AwakeCell:init(sUseType)
	self.UseNames = {["LAY_AWAKE_BAG"]=false,}
	self:initBase(CELLTYPE.AWAKE, sUseType)

end

-- 刷新背包的方法
function AwakeCell:refreshBag( tbData )
    if (self.mCell) then
        local cell = self.mCell

        -- 添加分解按钮触摸事件
        local useBtn = cell.BTN_USE
        useBtn:setEnabled(true)
        self:addMaskButton(useBtn, "BTN_USE", tbData.btnUse)
        UIHelper.titleShadow(useBtn, gi18n[7423])
    end
end

-- 刷新方法
function AwakeCell:refresh(tbData)
    if (self.mCell) then

        if (self.subType == CELL_USE_TYPE.BAG or self.subType == CELL_USE_TYPE.SALE) then
            self:bagHandler():fillOne(tbData) -- 背包类型的cell补全每个元素的其他字段
        end

        self:refreshBase(tbData)
        self:refreshCommon(tbData)
        self:refreshByType(tbData)
    end
end

function AwakeCell:refreshCommon(tbData)
    if (self.mCell) then

        local cell = self.mCell
        cell.TFD_OWN_NUM:setText("数量：" .. tostring(tbData.item_num))

        -- 描述文字
        local tfdDesc = cell.TFD_DESC
        tfdDesc:setText(tbData.dbConf.info)

    end
end

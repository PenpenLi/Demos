-- FileName: SpecialTreasCell.lua
-- Author: zhangjunwu
-- Date: 2015-10-08
-- Purpose: 分解屋专属宝物cell
--[[TODO List]]

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName


SpecialTreasCell = class("SpecialTreasCell",Cell)

-- sUseType, 取值范围 CELL_USE_TYPE
function SpecialTreasCell:init(sUseType)
    self.UseNames = {["LAY_SPECIAL_BAG"]=false, ["LAY_SPECIAL_LOAD"]=false,}
    self:initBase(CELLTYPE.SPECIAL, sUseType)
end

function SpecialTreasCell:refresh(tbData)
    if (self.mCell) then
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        self:refreshBase(tbData)

        -- self:refreshReborn(tbData)

        self:refreshByType(tbData)
    end
end

-- 刷新装备cell 公用部分
function SpecialTreasCell:refreshReborn(tbData)
    if (self.mCell) then
    	local cell = self.mCell

      -- UIHelper.setLabel(cell.TFD_SIGN, {text = tbData.sign, color = self.qualityColor[tbData.nQuality]}) -- 子类型

        local labLevel = m_fnGetWidget(cell, "TFD_SPECIAL_LV") -- 强化等级
      	local TFD_RANK = m_fnGetWidget(cell, "TFD_RANK")   -- 强化等级
        TFD_RANK:setText(tbData.sScore .. "")
        UIHelper.labelAddStroke(labLevel,   tbData.level  .. m_i18n[6933])

        self.cbxSelect = m_fnGetWidget(cell, "CBX_REBORN_SELECT")
        self.cbxSelect:setSelectedState(tbData.isSelected)

        -- if (tbData.tbAttr) then  -- 一般属性描述
        --     self:addAttrByTable(tbData.tbAttr)
        -- end
        local tbAttr = tbData.tbAttr
        for i=1,6 do
          local tfd_name = m_fnGetWidget(cell, "TFD_AFFIX_".. i)
          local tfd_value = m_fnGetWidget(cell, "TFD_AFFIX_NUM_".. i)
          if (tbAttr[i]) then
            tfd_name:setText(tbAttr[i].name ..":")
            tfd_value:setText("+" .. tbAttr[i].value)
            tfd_name:setVisible(true)
            tfd_value:setVisible(true)
          else
            tfd_name:setVisible(false)
            tfd_value:setVisible(false)
          end
        end

    end
end

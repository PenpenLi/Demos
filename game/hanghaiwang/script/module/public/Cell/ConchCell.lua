-- FileName: ConchCell.lua
-- Author: zhangqi
-- Date: 2015-05-06
-- Purpose: 空岛贝背包和选择列表Cell
--[[TODO List]]

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName


ConchCell = class("ConchCell",Cell)

-- sUseType, 取值范围 CELL_USE_TYPE
function ConchCell:init(sUseType)
    self.UseNames = {["LAY_CONCH_BAG"]=false, ["LAY_CONCH_LOAD"]=false,}
    self:initBase(CELLTYPE.CONCH, sUseType)
end

function ConchCell:refresh(tbData)
    if (self.mCell) then
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        self:refreshBase(tbData)

        self:refreshCommon(tbData)

        self:refreshByType(tbData)
    end
end

-- 刷新装备cell 公用部分
function ConchCell:refreshCommon(tbData)
    if (self.mCell) then
    	local cell = self.mCell

        UIHelper.setLabel(cell.TFD_SIGN, {text = tbData.sign, color = self.qualityColor[tbData.nQuality]}) -- 子类型

    	local labLevel = m_fnGetWidget(cell, "TFD_STRONG_LEVEL") -- 强化等级
        UIHelper.labelAddStroke(labLevel, "Lv." .. tbData.level)

        local i18n_rank = m_fnGetWidget(cell, "tfd_conch_quality_lv")
        i18n_rank:setText(m_i18n[4901])
        local labRank = m_fnGetWidget(cell,"TFD_RANK") --装备品级, 2015-04-30
        labRank:setText(tbData.sScore)

        if (tbData.tbAttr) then  -- 一般属性描述
            self:addAttrByTable(tbData.tbAttr)
        elseif (tbData.sMagicExp) then -- 附魔经验，2015-02-09，zhangqi
            self:addExpByIdx(1, m_i18n[1723] .. " +" .. tbData.sMagicExp)
        end
    end
end

-- 背包
function ConchCell:refreshBag(tbData)
    if (self.layMod) then
         	local labOwner = self.layMod.TFD_OWNER -- 装备于的人名
          UIHelper.labelEffect(labOwner)

         	if (tbData.owner) then
              labOwner:setVisible(true)
              UIHelper.labelEffect(labOwner, m_i18nString(1681, tbData.owner))
         	else
              labOwner:setVisible(false)
         	end

         	self:addMaskButton(self.layMod.BTN_STRONG, "BTN_STRONG", tbData.onConchStrong)
    end
end

--选择列表
function ConchCell:refreshLoad( tbData)
    if (self.layMod) then
       	local labOwner = self.layMod.TFD_OWNER -- 装备于的人名
        self.btnLoad = self.layMod.BTN_WEAR

       	if (tbData.owner) then
            labOwner:setEnabled(true)
        
            if (tbData.bSameType) then -- zhangqi, 2015-03-10, 已装备同类型空岛贝的标志
                UIHelper.labelEffect(labOwner, tbData.owner)
                UIHelper.titleShadow(self.btnLoad, m_i18n[1601])
            else
                UIHelper.labelEffect(labOwner, m_i18nString(1681, tbData.owner))
                UIHelper.titleShadow(self.btnLoad, m_i18n[1252]) 
            end

            self.btnLoad:loadTextureNormal("ui/green_04_n.png") -- 2015-05-15, 别人已穿戴的需要显示绿色按钮
            self.btnLoad:loadTexturePressed("ui/green_04_h.png")
       	else 
            labOwner:setEnabled(false)
            UIHelper.titleShadow(self.btnLoad, m_i18n[1601])

            self.btnLoad:loadTextureNormal("ui/orange_04_n.png") -- 2015-05-15，无人穿戴的显示橙色按钮
            self.btnLoad:loadTexturePressed("ui/orange_04_h.png")
       	end
       
        self:removeMaskButton("BTN_WEAR")
        self:addMaskButton(self.btnLoad, "BTN_WEAR", tbData.onLoad)
    end
end

-- FileName: ItemCell.lua
-- Author: zhangqi
-- Date: 2014-05-23
-- Purpose: 定义道具列表用的Cell类
--[[TODO List]]

local m_i18n = gi18n
local m_i18nString = gi18nString

require "script/module/public/Cell/Cell"

local m_fnGetWidget = g_fnGetWidgetByName

-- 构造 ItemCell 需要传递的数据
--[[
tbItem = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = {id = tid, onTouch = func}, 
    sOwnNum = 10, sDesc = "宝物等等....", -- Item
    onUse = func, -- bag
    sPrice = 1000, bSelect = true, -- sale
} --]]

----------------------------- 定义道具 ItemCell  -----------------------------
ItemCell = class("ItemCell", Cell)

-- ItemCell.UseNames = {["LAY_ITEM_BAG"]=false, ["LAY_ITEM_SALE"]=false,}


function ItemCell:refreshBag( tbData ) -- 背包列表
    if (self.layMod) then
        local tbKeyTid = {["30011"] = true, ["30012"] = true, ["30013"] = true} -- zhangqi, 2015-04-13, 三种钥匙的id
        local btnUse = m_fnGetWidget(self.layMod, "BTN_USE")
        btnUse:setEnabled(true)

        if (tbData.onUse) then -- 如果存在使用按钮事件才做相应处理, zhangqi, 20140621
            if (tbKeyTid[tbData.icon.id]) then
                UIHelper.titleShadow(btnUse, m_i18n[1535]) -- zhangqi, 2015-04-13, 钥匙的使用按钮标题要改为"开宝箱"
            else
                UIHelper.titleShadow(btnUse, m_i18n[1501])
            end

            btnUse:setTag(tonumber(tbData.gid))
            btnUse.idx = tbData.idx -- 保存当前物品在列表中的索引

            self:addMaskButton(btnUse, "BTN_USE", tbData.onUse)
        elseif (tbData.onEnhance) then -- zhangqi, 2015-08-31, 去附魔的按钮事件（打开装备背包）
            UIHelper.titleShadow(btnUse, m_i18n[1172])
            self:addMaskButton(btnUse, "BTN_USE", tbData.onEnhance)
        elseif (tbData.onDecompose) then -- Xufei, 2015-10-21，去分解主船道具
            UIHelper.titleShadow(btnUse, m_i18n[1537])
            self:addMaskButton(btnUse, "BTN_USE", tbData.onDecompose)
        elseif (tbData.onActivate) then -- Xufei, 2015-10-21， 去激活主船
            UIHelper.titleShadow(btnUse, m_i18n[1538])
            self:addMaskButton(btnUse, "BTN_USE", tbData.onActivate)
        elseif (tbData.onVipCard) then
            if (VipCardModel.bGetOrNotToday()) then
                UIHelper.titleShadow(btnUse, m_i18n[1536]) -- zhangqi, 2015-11-26, 去月卡界面
                UIHelper.setWidgetGray(btnUse, false)
                self:addMaskButton(btnUse, "BTN_USE", tbData.onVipCard)
            else
                UIHelper.titleShadow(btnUse, m_i18n[4372]) -- zhangqi, 2015-11-26, 已领取
                UIHelper.setWidgetGray(btnUse, true) -- 不能买就把按钮置灰
                self:removeMaskButton("BTN_USE")
            end
        else
            btnUse:setEnabled(false)
            self:removeMaskButton("BTN_USE")
        end

        -- zhangqi, 2014-12-22, 背包里的新道具添加 New 的特效标志
        local layNew = m_fnGetWidget(self.mCell, "LAY_EFFECT")
        if (layNew) then
            layNew:removeAllNodes() -- 先删除之前添加的
            if (tbData.newOrder and tbData.newOrder > 0) then
            BagUtil.addNewFlgToCell(layNew)
            end 
        end
    end
end

function ItemCell:refreshSale( tbData ) -- 出售列表
    if (self.layMod) then
       local labCoin = m_fnGetWidget(self.layMod, "TFD_SELL_PRICE") -- 2015-04-29
       labCoin:setText(tbData.sPrice)
       
       self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_SELL_SELECT")
       self.cbxSelect:setSelectedState(tbData.bSelect)
    end
end

function ItemCell:refreshDecomp( tbData ) -- 回收列表
    if (self.layMod) then
       self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_SELECT")
       self.cbxSelect:setSelectedState(tbData.isSelected)
    end
end

function ItemCell:refresh(tbData)
    if (self.mCell) then
        self:refreshBase(tbData)
        logger:debug({tbData = tbData})
        local labOwn = m_fnGetWidget(self.mCell, "TFD_OWN_NUM") -- 数量, 2015-04-29
        labOwn:setText(m_i18nString(1456, tbData.sOwnNum))
        
        local labDesc = m_fnGetWidget(self.mCell, "TFD_DESC")
        labDesc:setText(tbData.sDesc)
        
        self:refreshByType(tbData)
    end
end

-- sUseType, 取值范围 CELL_USE_TYPE
function ItemCell:init(sUseType)
    self.UseNames = {["LAY_ITEM_BAG"]=false, ["LAY_ITEM_SALE"]=false,["LAY_ITEM_DECOMPOSE"]=false,}
    self:initBase(CELLTYPE.ITEM, sUseType)
end

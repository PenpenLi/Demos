-- FileName: TreaFragCell.lua
-- Author: zhangqi
-- Date: 2014-05-23
-- Purpose: 定义宝物列表用的Cell类
--[[TODO List]]  

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI
local m_sFontCuYuan = g_sFontCuYuan
local mItemUtil = ItemUtil
local jsonforRecommand = "images/effect/recommend/recommand.ExportJson"

-- 构造 TreaFragCell 需要传递的数据
--[[
local tbData = {
    name = "", icon = icon = {id = htid, bHero = false, onTouch = func}, 
    nOwn = xx, nNeed = xx, onCompond = onCompond, onDrop = onDrop,
} -]]

----------------------------- 定义宝物 TreaFragCell  -----------------------------
TreaFragCell = class("TreaFragCell", Cell)

function TreaFragCell:refreshCommon( tbData )
    self.mCell.tfd_progress_i18n:setText(m_i18n[1332])

    self.mCell.TFD_MEMBER_NUM:setText(tbData.nOwn) -- 拥有数量
    self.mCell.TFD_DOMIT_NUM:setText(tbData.nNeed) -- 合成需要数量
end

function TreaFragCell:refreshBag( tbData ) -- 背包列表
	if (self.mCell) then
		local bCompond = tbData.nOwn >= tbData.nNeed
		self.mCell.TFD_DESC:setEnabled(not bCompond) -- 不够合成显示数量不足

		self.mCell.BTN_COMPOND:setEnabled(bCompond) -- 合成按钮
		if (tbData.onCompond) then
			self:addMaskButton(self.mCell.BTN_COMPOND, "BTN_COMPOND", tbData.onCompond)
            -- self.mCell.BTN_COMPOND:setTag(tonumber(tbData.item_id))
            self.mCell.BTN_COMPOND:setTag(tonumber(tbData.frag_id))
		end

		self.mCell.BTN_DROP:setEnabled(not bCompond) -- 不够合成显示掉落引导
		if (tbData.onDrop) then
			self:addMaskButton(self.mCell.BTN_DROP, "BTN_DROP", tbData.onDrop)
             -- self.mCell.BTN_DROP:setTag(tonumber(tbData.item_id))
             self.mCell.BTN_DROP:setTag(tonumber(tbData.frag_id))
		end
	end
end

function TreaFragCell:refreshSale( tbData ) -- 出售列表
    if (self.layMod) then
        local labCoin = m_fnGetWidget(self.layMod, "TFD_SELL_PRICE")
        labCoin:setText(tbData.sPrice)

        self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_SELL_SELECT")
        self.cbxSelect:setSelectedState(tbData.bSelect)
    end
end

function TreaFragCell:refresh(tbData)
	if (self.mCell) then
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        if (tbData.isBtnBar) then -- 如果是按钮面板
            self.imgBg:setEnabled(false)
            self.mCell:setEnabled(false)

            self.layBtnBar:setEnabled(true)
            self.objBtnBar:refresh(tbData, tbData.idx - 1) -- 按钮面板初始化功能按钮实际要取index小1的实际cell的属性
        else
            if (self.layBtnBar) then
                self.layBtnBar:setEnabled(false)
                self.imgBg:setEnabled(true)
            end

            if (self.subType == CELL_USE_TYPE.BAG or self.subType == CELL_USE_TYPE.SALE) then
                self:bagHandler():fillOne(tbData) -- 背包类型的cell补全每个元素的其他字段
            end

            self:refreshBase(tbData)
            self:refreshCommon(tbData)
            self:refreshByType(tbData)
        end
	end
end

-- sUseType, 取值范围 CELL_USE_TYPE
function TreaFragCell:init(sUseType)
	self.UseNames = {["LAY_TREA_FRAG_BAG"] = false, ["LAY_TREA_FRAG_SALE"] = false,}
	self:initBase(CELLTYPE.TREA_FRAG, sUseType)

	if (self.subType == CELL_USE_TYPE.BAG) then
        require "script/module/public/Cell/BtnBarCell"                                           
        self.objBtnBar = BtnBarCell:new()                                                        
        self.objBtnBar:init(CELL_USE_TYPE.BAG, self)                                             
        self.layBtnBar = self.objBtnBar.mCell                                                    
                                                                                                 
        self.imgBg = m_fnGetWidget(self.mCell, "img_bg")                            
                                                                                                 
        self.mCell:addChild(self.layBtnBar)                                                      
    end
end

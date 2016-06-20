-- FileName: AddSpecialTreaCell.lua
-- Author: yucong
-- Date: 2015-09-16
-- Purpose: 专属宝物选择列表的cell
--[[TODO List]]

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI
local jsonforRecommand = "images/effect/recommend/recommand.ExportJson"

----------------------------- 定义宝物 AddSpecialTreaCell  -----------------------------
AddSpecialTreaCell = class("AddSpecialTreaCell", Cell)

function AddSpecialTreaCell:refreshBag( tbData ) -- 背包列表
	if (self.layMod) then
		local labOwner = m_fnGetWidget(self.layMod, "TFD_OWNER") -- 装备于伙伴名称
		if (tbData.sOwner ~= "") then
			UIHelper.labelEffect(labOwner, m_i18nString(1681, tbData.sOwner))
			labOwner:setEnabled(true)
		else
			labOwner:setEnabled(false)
		end

		self:refreshBarBtn(tbData.idx)
	end
end

function AddSpecialTreaCell:refreshLoad( tbData ) -- 更换列表
	if (self.layMod) then
        local cell = self.mCell   
        cell.LAY_SPECIAL_LOAD:setVisible(true)
        local imgCellBg = m_fnGetWidget(cell, "img_special_bg") -- Cell的背景图片

		local labOwner = m_fnGetWidget(cell, "TFD_OWNER") -- 装备于伙伴名称
		local btnDrop = m_fnGetWidget(cell, "BTN_DROP")
		self.btnLoad = m_fnGetWidget(cell, "BTN_STRENGTHEN") -- 装备按钮
		self:addMaskButton(self.btnLoad, "BTN_STRENGTHEN", tbData.onLoad)
		UIHelper.titleShadow(btnDrop, m_i18n[1098])
		-- 穿在他人身上
		if (tbData.sOwner ~= "" and tbData.isHeroBusy == true) then
			labOwner:setEnabled(true)
			UIHelper.labelEffect(labOwner, m_i18nString(1681, tbData.sOwner))
			
            self.btnLoad:loadTextureNormal("ui/green_04_n.png")
            self.btnLoad:loadTexturePressed("ui/green_04_h.png")
            UIHelper.titleShadow(self.btnLoad, m_i18n[1252])
		else
			labOwner:setEnabled(false)

            self.btnLoad:loadTextureNormal("ui/orange_04_n.png")
            self.btnLoad:loadTexturePressed("ui/orange_04_h.png")
			UIHelper.titleShadow(self.btnLoad, m_i18n[1601])
		end
	end
end

function AddSpecialTreaCell:refreshReborn( tbData ) -- 重生列表
	if (self.layMod) then
		self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_REBORN_SELECT")
		self.cbxSelect:setSelectedState(tbData.bSelect)
	end
end

function AddSpecialTreaCell:refresh(tbData)
	if (self.mCell) then
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        if (tbData.isBtnBar) then -- 如果是按钮面板
            self.imgBg:setEnabled(false)
            self.layMod:setEnabled(false)

            self.layBtnBar:setEnabled(true)
            self.objBtnBar:refresh(tbData, tbData.idx - 1) -- 按钮面板初始化功能按钮实际要取index小1的实际cell的属性
        else
        	logger:debug("AddSpecialTreaCell:refresh")
            if (self.layBtnBar) then
                self.layBtnBar:setEnabled(false)
                self.imgBg:setEnabled(true)
            end

            self:refreshBase(tbData)
        	self:refreshCommon(tbData)
            self:refreshByType(tbData)
        end
	end
end

function AddSpecialTreaCell:refreshCommon(tbData)
	if (self.mCell) then

		local cell = self.mCell

        --cell.TFD_SIGN:setColor(self.qualityColor[tbData.nQuality])

		-- zhangqi, 2014-12-22, 宝物的精炼信息修改为数字标签
		local labnTransfer = m_fnGetWidget(cell, "TFD_SPECIAL_LV")
		if (tbData.sRefinNum) then
			labnTransfer:setText(tbData.sRefinNum..m_i18n[6933])
			labnTransfer:setEnabled(true)
		-- else
		-- 	labnTransfer:setEnabled(false)
		-- 	imgPlus:setEnabled(false)
		end

        --if (self.subType ~= CELL_USE_TYPE.LOAD) then
	        local i18n_rank = m_fnGetWidget(cell, "tfd_special_quality_lv") -- 品级标题
	        i18n_rank:setText(m_i18n[4901])

	        local labRank = m_fnGetWidget(cell, "TFD_RANK") -- 品级数值
	        labRank:setText(tbData.sRank)
	    --end

		-- local labStrongLv = m_fnGetWidget(cell, "TFD_STRONG_LEVEL") -- 强化等级
		-- labStrongLv:setText("Lv." .. tbData.sStrongNum)

		local tbFilter = {CELL_USE_TYPE.BAG, CELL_USE_TYPE.REBORN, CELL_USE_TYPE.SALE, CELL_USE_TYPE.STRONG}
		if (tbData.awakeDes) then -- 专属属性描述
			self:addAttrOfAwake(tbData.awakeDes,3,18)
		elseif (tbData.tbAttr) then  -- 一般属性描述
			if (table.include(tbFilter, self.subType)) then
				self:addAttrByTable(tbData.tbAttr)
			else
				self:addAttrForOther(tbData.tbAttr)
			end
		elseif (tbData.sSupplyExp) then -- 经验马等显示提供经验
			self:addExpByIdx(1, m_i18n[1723] .. " +" .. tbData.sSupplyExp)
		end
 
        if (tbData.itemDesc and tonumber(tbData.itemDesc.is_refine_item)== 1) then --  宝物精华属性显示
        	self:addAttrOfAwake(tbData.itemDesc.info,1)
			--self:addAttrForOther({{value = tbData.itemDesc.info}})  --可用于精炼紫色宝物
        end
	end
end

-- 2015-05-06, zhangqi, 添加专属属性值 或者宝物经验属性 1 专属属性 2宝物羁绊属性
function AddSpecialTreaCell:addAttrOfAwake(sAttr,zone,titleSize)
	self:clearAttrInfo()

	local titleF = g_AttrFont.title

	local layAttr = m_fnGetWidget(self.mCell, "LAY_ATTR_DESC_" .. zone) -- 属性描述
	local sizeInfo = layAttr:getSize()
	local labAttr = UIHelper.createUILabel( sAttr, titleF.name, (titleSize or titleF.size), titleF.color)
	labAttr:setAnchorPoint(ccp(0, 1))
	labAttr:setPosition(ccp(0, sizeInfo.height ))
	labAttr:ignoreContentAdaptWithSize(false)
	labAttr:setSize(CCSizeMake(sizeInfo.width, 0))
	local rSize = labAttr:getVirtualRenderer():getContentSize()
	labAttr:setSize(CCSizeMake(rSize.width, rSize.height+10))
	layAttr:addChild(labAttr)
	layAttr:setVisible(true)
end

-- 2015-05-06, zhangqi, 添加除宝物背包外其他列表用到的属性值（因为tbAttr的结构和背包准备的tbAttr不同）
function AddSpecialTreaCell:addAttrForOther( tbAttr )
	self:clearAttrInfo()

	local titleF = g_AttrFont.title
	local valueF = g_AttrFont.value

	local i, descIdx = 0, 1
	for idx, attr in ipairs(tbAttr) do
	    local layAttr = m_fnGetWidget(self.mCell, "LAY_ATTR_DESC_" .. descIdx) -- 属性描述
	    local szInfo = layAttr:getSize()
	    
        local labTitle = UIHelper.createUILabel( attr.name, titleF.name, titleF.size, titleF.color)
        local szTitle = labTitle:getSize()

        labTitle:setAnchorPoint(ccp(0, 1))
        labTitle:setPosition(ccp(0, szInfo.height - i*szTitle.height))
        layAttr:addChild(labTitle)

        local attrValue
        if (attr.value) then
        	 attrValue = attr.value
        end
        logger:debug(tbAttr)
        logger:debug("tbAttr")

        local labValue = UIHelper.createUILabel( " +" .. attrValue, valueF.name, valueF.size, valueF.color)
        labValue:setAnchorPoint(ccp(0, 1))
        labValue:setPosition(ccp(szTitle.width, 0))
        labTitle:addChild(labValue)

        i = i + 1

  --       if (idx%2 == 0) then
		-- 	descIdx = descIdx + 1
		-- end
	end
end


-- sUseType, 取值范围 CELL_USE_TYPE
function AddSpecialTreaCell:init(sUseType)
	self.UseNames = {["LAY_SPECIAL_BAG"]=false, ["LAY_SPECIAL_SALE"]=false,["LAY_SPECIAL_LOAD"]=false, ["LAY_SPECIAL_REBORN"]=false, ["LAY_SPECIAL_STRONG"]=false,}
	self:initBase(CELLTYPE.SPECIAL, sUseType)

	if (self.subType == CELL_USE_TYPE.BAG) then -- 如果是伙伴背包需要初始化按钮面板加到伙伴Cell上
        require "script/module/public/Cell/BtnBarCell"                                           
        self.objBtnBar = BtnBarCell:new()                                                        
        self.objBtnBar:init(CELL_USE_TYPE.BAG, self)                                             
        self.layBtnBar = self.objBtnBar.mCell                                                    
                                                                                                 
        self.imgBg = m_fnGetWidget(self.mCell, "img_cell_special_bg")                            
                                                                                                 
        self.mCell:addChild(self.layBtnBar)                                                      
    end

    if (self.subType == CELL_USE_TYPE.LOAD) then
    	--self.mCell.img_quality_bg:removeFromParentAndCleanup(true) -- 品级背景

        --self.mCell.tfd_special_quality_lv:removeFromParentAndCleanup(true) -- 品级标题

       -- self.mCell.TFD_RANK:removeFromParentAndCleanup(true) -- 品级数值
    end
end


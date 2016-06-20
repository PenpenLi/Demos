-- FileName: TreasureCell.lua
-- Author: zhangqi
-- Date: 2014-05-23
-- Purpose: 定义宝物列表用的Cell类
--[[TODO List]]

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local _recommandAnimationTag = 1111
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI
local m_sFontCuYuan = g_sFontCuYuan
local mItemUtil = ItemUtil
local jsonforRecommand = "images/effect/recommend/recommand.ExportJson"

-- 构造 TreasureCell 需要传递的数据
--[[
local tbData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = icon = {id = htid, bHero = false, onTouch = func}, 
    sStrongNum = 10, sStar = 88, sRank = 15, tbAttr = {"string of all attribute",}, sRefinNum = 0[精炼等级，icon右下角钻石], -- Treasure
    sOwner = "小刀胖子", sSupplyExp = "1000", onRefining = onRecruitCall, onStrong = onRecruitCall, -- bag sSupplyExp:提供经验
    sPrice = 9999, bSelect = false, -- sale
    sOwner = "小刀胖子", onLoad = onRecruitCall, -- load
    bSelect = (idx%5 == 0), -- reborn
    sExp = 1000, bSelect = false, -- strong
} -]]

----------------------------- 定义宝物 TreasureCell  -----------------------------
TreasureCell = class("TreasureCell", Cell)

-- TreasureCell.UseNames = {["LAY_TREASURE_BAG"]=false, ["LAY_TREASURE_SALE"]=false,["LAY_TREASURE_LOAD"]=false, ["LAY_TREASURE_REBORN"]=false, ["LAY_TREASURE_STRONG"]=false,}

function TreasureCell:refreshBag( tbData ) -- 背包列表
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

function TreasureCell:refreshSale( tbData ) -- 出售列表
	if (self.layMod) then
		local labCoin = m_fnGetWidget(self.layMod, "TFD_SELL_PRICE")
		labCoin:setText(tbData.sPrice)

		self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_SELL_SELECT")
		self.cbxSelect:setSelectedState(tbData.bSelect)
	end
end


function TreasureCell:refreshLoad( tbData ) -- 更换列表
	if (self.layMod) then
        local cell = self.mCell   
        local imgCellBg = m_fnGetWidget(cell, "img_cell_treasure_bg") -- Cell的背景图片
        local imgTreasureInfoBg = m_fnGetWidget(cell, "img_bag_treasure_list_bg") -- 宝物的背景图片
        local tfdCanActivation = m_fnGetWidget(cell, "TFD_CAN_ACTIVATION")  -- 可激活羁绊
    	
		local recommandAnimatNode = cell:getNodeByTag(_recommandAnimationTag)

		if ((tbData.isZhuanshu) or tbData.isFetterTrea) then
			--推荐特效
		    -- cell:removeAllNodes()
			local recommandAnimation = UIHelper.createArmatureNode({
				filePath = jsonforRecommand,
				animationName = "recommand",
			})
			recommandAnimation:setPosition(ccp(0.05 * cell:getSize().width,0.8 * cell:getSize().height))
	        recommandAnimation:setTag(_recommandAnimationTag)

		    if (not recommandAnimatNode) then
        		cell:addNode(recommandAnimation)
		    end
		    tfdCanActivation:setEnabled(true)
            tfdCanActivation:setText(m_i18nString(1745,1))

		else
		    if (recommandAnimatNode) then
				cell:removeNodeByTag(_recommandAnimationTag)
		    end
            tfdCanActivation:setEnabled(false)
		end

		local labOwner = m_fnGetWidget(cell, "TFD_OWNER") -- 装备于伙伴名称
		local btnDrop = m_fnGetWidget(cell, "BTN_DROP")
		self.btnLoad = m_fnGetWidget(cell, "BTN_LOAD") -- 装备按钮

		local i18n_desc = m_fnGetWidget(cell, "TFD_DESC") -- 专属标示
		i18n_desc:setText(m_i18n[1115])

		local labStrongLv = m_fnGetWidget(cell, "TFD_STRONG_LEVEL") -- 强化等级
		local imgPlus = m_fnGetWidget(cell, "img_plus") -- 精炼等级标示
		local labn = m_fnGetWidget(cell, "LABN_TRANSFER_NUM") -- 精炼等级数字

		local i18n_lv = m_fnGetWidget(cell, "tfd_lv") -- 品级标示
		i18n_lv:setText(m_i18n[4901])

		local labRank = m_fnGetWidget(cell, "TFD_LV_RANK") -- 品级数字
		labRank:setText(tbData.sRank)

		UIHelper.titleShadow(btnDrop, m_i18n[1098])
		if (tbData.sOwner ~= "") then
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
        
        -- 如果是新添加的 推荐专属 则显示推荐Cell 显示获取途径按钮 隐藏整备按钮
		if (tbData.isAddZhuanShu) then
			btnDrop:setEnabled(true)
			self.btnLoad:setEnabled(false)
			i18n_desc:setEnabled(true)
			labStrongLv:setEnabled(false)
			--imgPlus:setEnabled(false)
			--labn:setEnabled(false)
			i18n_lv:setEnabled(false)
			labRank:setEnabled(false)
			tfdCanActivation:setEnabled(false)
			self:removeMaskButton("BTN_LOAD")
			self:removeMaskButton("BTN_DROP")
			self:addMaskButton(btnDrop, "BTN_DROP", tbData.onGet)
            
            imgCellBg:loadTexture(mItemUtil.getCellBgByItem({ item_type = 3}))
            imgTreasureInfoBg:loadTexture(mItemUtil.getCellBgByItem( { item_type = 4}))
		else
			btnDrop:setEnabled(false)
			self.btnLoad:setEnabled(true)
			i18n_desc:setEnabled(false)
			labStrongLv:setEnabled(true)
			--imgPlus:setEnabled(true)
			--labn:setEnabled(true)
          	i18n_lv:setEnabled(true)
			labRank:setEnabled(true)

			self:removeMaskButton("BTN_LOAD")
			self:removeMaskButton("BTN_DROP")
			self:addMaskButton(self.btnLoad, "BTN_LOAD", tbData.onLoad)

			imgCellBg:loadTexture(mItemUtil.getCellBgByItem({ item_type = 1}))
            imgTreasureInfoBg:loadTexture(mItemUtil.getCellBgByItem( { item_type = 2}))
		end
	end
end

function TreasureCell:refreshReborn( tbData ) -- 重生列表
	if (self.layMod) then
		self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_TREASURE_SELECT")
		self.cbxSelect:setSelectedState(tbData.isSelected)
	end
end

function TreasureCell:refreshStrong( tbData ) -- 强化选择列表
	if (self.layMod) then
		local i18n_exp = m_fnGetWidget(self.layMod, "tfd_exp")
		i18n_exp:setText(m_i18n[1725])
		local labExpNum = m_fnGetWidget(self.layMod, "TFD_TREASURE_EXP_NUM")
		labExpNum:setText(tbData.sExp)

		self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_TREASURE_STRONG_SELECT")
		self.cbxSelect:setSelectedState(tbData.bSelect)
	end
end

function TreasureCell:refresh(tbData)
	if (self.mCell) then
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        if (tbData.isBtnBar) then -- 如果是按钮面板
            self.imgBg:setEnabled(false)
            self.layMod:setEnabled(false)

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

function TreasureCell:refreshCommon(tbData)
	if (self.mCell) then

		local cell = self.mCell

		local labSign = m_fnGetWidget(cell, "TFD_SIGN") -- 物品类型名称
        UIHelper.setLabel(labSign, {text = tbData.sign, color = self.qualityColor[tbData.nQuality]})

		-- zhangqi, 2014-12-22, 宝物的精炼信息修改为数字标签
		local labnTransfer = m_fnGetWidget(cell, "LABN_TRANSFER_NUM")
		local imgPlus = m_fnGetWidget(cell, "img_plus")
		if (tbData.sRefinNum) then
			labnTransfer:setStringValue(tbData.sRefinNum)
			labnTransfer:setEnabled(true)
			imgPlus:setEnabled(true)
		else
			labnTransfer:setEnabled(false)
			imgPlus:setEnabled(false)
		end

        if (self.subType ~= CELL_USE_TYPE.LOAD) then
	        local i18n_rank = m_fnGetWidget(cell, "tfd_treasure_quality_lv") -- 品级标题
	        i18n_rank:setText(m_i18n[4901])

	        local labRank = m_fnGetWidget(cell, "TFD_RANK") -- 品级数值
	        labRank:setText(tbData.sRank)
	    end

		local labStrongLv = m_fnGetWidget(cell, "TFD_STRONG_LEVEL") -- 强化等级
		labStrongLv:setText("Lv." .. tbData.sStrongNum)

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
 
   		if (tbData.bRefineItem) then -- 宝物精华属性显示，zhangqi, 2015-09-16
   			self:addAttrOfAwake(tbData.info,1)
   		end
	end
end

-- 2015-05-06, zhangqi, 添加专属属性值 或者宝物经验属性 1 专属属性 2宝物羁绊属性
function TreasureCell:addAttrOfAwake(sAttr,zone,titleSize)
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
end

-- 2015-05-06, zhangqi, 添加除宝物背包外其他列表用到的属性值（因为tbAttr的结构和背包准备的tbAttr不同）
function TreasureCell:addAttrForOther( tbAttr )
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
	end
end


-- sUseType, 取值范围 CELL_USE_TYPE
function TreasureCell:init(sUseType)
	self.UseNames = {["LAY_TREASURE_BAG"]=false, ["LAY_TREASURE_SALE"]=false,["LAY_TREASURE_LOAD"]=false, ["LAY_TREASURE_REBORN"]=false, ["LAY_TREASURE_STRONG"]=false,}
	self:initBase(CELLTYPE.TREASURE, sUseType)

	if (self.subType == CELL_USE_TYPE.BAG) then -- 如果是背包需要初始化按钮面板加到Cell上
        require "script/module/public/Cell/BtnBarCell"                                           
        self.objBtnBar = BtnBarCell:new()                                                        
        self.objBtnBar:init(CELL_USE_TYPE.BAG, self)                                             
        self.layBtnBar = self.objBtnBar.mCell                                                    
                                                                                                 
        self.imgBg = m_fnGetWidget(self.mCell, "img_cell_treasure_bg")                            
                                                                                                 
        self.mCell:addChild(self.layBtnBar)                                                      
    end

    if (self.subType == CELL_USE_TYPE.LOAD) then
    	local imgRankBg = m_fnGetWidget(self.mCell, "img_quality_bg") -- 品级背景
    	imgRankBg:removeFromParentAndCleanup(true)

        local i18n_rank = m_fnGetWidget(self.mCell, "tfd_treasure_quality_lv") -- 品级标题
        i18n_rank:removeFromParentAndCleanup(true)

        local labRank = m_fnGetWidget(self.mCell, "TFD_RANK") -- 品级数值
        labRank:removeFromParentAndCleanup(true)
    end
end

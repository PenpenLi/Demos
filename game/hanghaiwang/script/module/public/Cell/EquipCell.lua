-- FileName: EquipCell.lua
-- Author: huxiaozhou
-- Date: 2014-05-22
-- Purpose: 装备列表 界面 cell
--[[TODO List
[1007] = "强化",
[1603] = "洗练",
[1208] = "装备于",
[1601] = "装备",
]]

require "script/module/public/Cell/Cell"

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

------------------------------ 定义装备-Cell------------------------------------------
EquipCell = class("EquipCell",Cell)

-- EquipCell.UseNames = {["LAY_EQUIP_BAG"]=false, ["LAY_EQUIP_SALE"]=false, ["LAY_EQUIP_LOAD"]=false, ["LAY_EQUIP_REBORN"]=false,}

--[[
--tbData 格式
tbData = {	level =  等级, starLvl = 星级, sScore = 品级, name = "小刀海贼-" .. idx, , sign = "item_type_shadow.png", , icon = btnIcon, bSelect = true or false,
            onLoad =  穿装备方法, onXilian = 洗练方法, onStrong = 强化方法, owner = "人名", price = "  " 出售价格, tbAttr = {'xxx', 'yyyy'} -- zhangqi, 2014-07-24
--]]

-- 刷新装备cell 公用部分
function EquipCell:refreshEquipCommon(tbData)
    if (self.mCell) then
    	local cell = self.mCell

        local labSign = m_fnGetWidget(self.mCell, "TFD_SIGN")
        UIHelper.setLabel(labSign, {text = tbData.sign, color = self.qualityColor[tbData.nQuality]})

        -- zhangqi, 2015-01-21, 添加装备的附魔信息
        local labn = m_fnGetWidget(cell, "LABN_TRANSFER_NUM")
        local imgPlus = m_fnGetWidget(cell, "img_plus")
        if (tbData.sMagicNum) then
            labn:setStringValue(tbData.sMagicNum)
            labn:setEnabled(true)
            imgPlus:setEnabled(true)
        else
            labn:setEnabled(false)
            imgPlus:setEnabled(false)
        end

    	local labLevel = m_fnGetWidget(cell, "TFD_EQUIP_LV") -- 装备等级
        UIHelper.labelAddStroke(labLevel, "Lv." .. tbData.level)

        local i18n_rank = m_fnGetWidget(cell, "tfd_equip_quality_lv")
        i18n_rank:setText(m_i18n[4901])
        local labRank = m_fnGetWidget(cell,"TFD_RANK") --装备品级, 2015-04-30
        labRank:setText(tbData.sScore)

        if (tbData.tbAttr) then  -- 一般属性描述
            self:addAttrByTable(tbData.tbAttr)
        elseif (tbData.sMagicExp) then -- 附魔经验，2015-02-09，zhangqi
            self:addExpByIdx(1, m_i18n[1746] .. " +" .. tbData.sMagicExp)
        end
    end
end

-- 背包
function EquipCell:refreshBag(tbData)
	if (self.layMod) then
       	local TFD_OWNER = m_fnGetWidget(self.layMod, "TFD_OWNER")	-- 装备于的人名
       	if (tbData.owner) then
            TFD_OWNER:setVisible(true)
            UIHelper.labelEffect(TFD_OWNER, m_i18nString(1681, tbData.owner))
       		
       	else
       		TFD_OWNER:setVisible(false)
       	end

        logger:debug("EquipCell:refreshBag tbData.idx = %d", tbData.idx)
        self:refreshBarBtn(tbData.idx)
    end
end

-- 卖出
function EquipCell:refreshSale( tbData )
	if (self.layMod) then
        local sale = self.layMod

        local labSellPrice =  m_fnGetWidget(sale, "TFD_SELL_PRICE") --出售价格
        labSellPrice:setText(tbData.price)

        -- cell 内部保存 check box 状态
        self.cbxSelect = m_fnGetWidget(sale, "CBX_SELL_SELECT")
        self.cbxSelect:setSelectedState(tbData.bSelect)
    end
end

-- zhangqi, 2015-11-04, 处理穿装备选择时可激活加成的UI显示
function EquipCell:dealAddtionalAttrEnabled( tbData )
    local cell = self.mCell

    local i18n_lv = m_fnGetWidget(self.layMod, "tfd_lv") -- zhangqi, 2015-11-04, 添加选择cell专用的品级显示 
    i18n_lv:setText(m_i18n[4901]) -- 品级：

    local labLvRank = m_fnGetWidget(self.layMod, "TFD_LV_RANK")
    labLvRank:setText(tbData.sScore)

    local labActAttr = m_fnGetWidget(self.layMod, "TFD_CAN_ACTIVATION")  -- 可激活加成

    local imgRankBg = m_fnGetWidget(cell, "img_quality_bg") -- 需要隐藏的公用"品级"
    local i18n_rank = m_fnGetWidget(cell, "tfd_equip_quality_lv")
    local labRank = m_fnGetWidget(cell,"TFD_RANK")

    local tagEffect = 333 -- 推荐特效的 tag

    if (tbData.bActiveAdd) then -- 如果可激活加成
        imgRankBg:setEnabled(false)
        i18n_rank:setEnabled(false)
        labRank:setEnabled(false)

        labActAttr:setText(m_i18nString(1745,1))

        --推荐特效
        if (not cell:getNodeByTag(tagEffect)) then
            local effect = UIHelper.createArmatureNode({
                            filePath = "images/effect/recommend/recommand.ExportJson",
                            animationName = "recommand",
                        })
            effect:setPosition(ccp(0.05 * cell:getSize().width,0.8 * cell:getSize().height))
            cell:addNode(effect, tagEffect, tagEffect)
        end
    else
        i18n_lv:setEnabled(false)
        labLvRank:setEnabled(false)
        labActAttr:setEnabled(false)

        if (cell:getNodeByTag(tagEffect)) then
            cell:removeNodeByTag(tagEffect)
        end
    end
end

--装备选择
function EquipCell:refreshLoad( tbData )
	if (self.layMod) then
       	local TFD_OWNER = m_fnGetWidget(self.layMod, "TFD_OWNER")	-- 装备于的人名
        self.btnLoad = m_fnGetWidget(self.layMod, "BTN_LOAD")

        self:dealAddtionalAttrEnabled(tbData) -- zhangqi, 2015-11-04, 是否显示可激活加成

       	if (tbData.owner) then
            TFD_OWNER:setEnabled(true)
            UIHelper.labelEffect(TFD_OWNER, m_i18nString(1681, tbData.owner))
            UIHelper.titleShadow(self.btnLoad, m_i18n[1252])

            self.btnLoad:loadTextureNormal("ui/green_04_n.png") -- 2015-05-15, 别人已穿戴的需要显示绿色按钮
            self.btnLoad:loadTexturePressed("ui/green_04_h.png")
       	else 
            TFD_OWNER:setEnabled(false)
            UIHelper.titleShadow(self.btnLoad, m_i18n[1601])

            self.btnLoad:loadTextureNormal("ui/orange_04_n.png") -- 2015-05-15，无人穿戴的显示橙色按钮
            self.btnLoad:loadTexturePressed("ui/orange_04_h.png")
       	end
       
        self:removeMaskButton("BTN_LOAD")
        self:addMaskButton(self.btnLoad, "BTN_LOAD", tbData.onLoad)
    end
end

-- 装备重生
function EquipCell:refreshReborn( tbData )
	if (self.layMod) then
        local reBorn = self.layMod
        -- cell 内部保存 check box 状态
        self.cbxSelect = m_fnGetWidget(reBorn, "CBX_REBORN_SELECT")
        self.cbxSelect:setSelectedState(tbData.isSelected)
    end
end

-- 刷新方法
-- function EquipCell:refreshEquip(tbData)
-- 	if (self.mCell) then
-- 		local keyType = "LAY_EQUIP_" .. self.subType
-- 		self.UseNames[keyType] = true

-- 		for k, v in pairs(self.UseNames) do
-- 			local layUse = m_fnGetWidget(self.mCell, k)
-- 			if ((not v) and layUse) then
-- 				layUse:removeFromParentAndCleanup(true)
-- 			end
-- 		end
-- 		self.layMod = m_fnGetWidget(self.mCell, keyType) -- 当前用到类型的layout引用
--        	self:refreshByType(tbData) 
-- 	end

-- end

-------------------- 对外接口 begin---------------
--[[
	初始化方法 
	args string 类型
	sType  = BAG , -- 背包列表
	   		SALE , -- 出售列表
    		LOAD , -- 更换列表
			 REBORN -- 重生列表
--]]
 			
function EquipCell:init(sType)
    self.UseNames = {["LAY_EQUIP_BAG"]=false, ["LAY_EQUIP_SALE"]=false, ["LAY_EQUIP_LOAD"]=false, ["LAY_EQUIP_REBORN"]=false,}
    self:initBase(CELLTYPE.EQUIP, sType)

    if (self.subType == CELL_USE_TYPE.BAG) then -- 如果是伙伴背包需要初始化按钮面板加到伙伴Cell上
        require "script/module/public/Cell/BtnBarCell"                                           
        self.objBtnBar = BtnBarCell:new()                                                        
        self.objBtnBar:init(CELL_USE_TYPE.BAG, self)                                             
        self.layBtnBar = self.objBtnBar.mCell                                                    
                                                                                                 
        self.imgBg = m_fnGetWidget(self.mCell, "img_equip_bg")                            
                                                                                                 
        self.mCell:addChild(self.layBtnBar)                                                      
    end                                                                                          

end

-- 刷新
-- tbData 数据 见顶部  tbData.getCompleteData ：装备列表用语获取完整数据的接口
function EquipCell:refresh( tbData)
    if (tbData.getCompleteData) then 
        tbData = tbData.getCompleteData(tbData)
    end 

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

            self:refreshBase(tbData)
            self:refreshEquipCommon(tbData)
            self:refreshByType(tbData)
        end
    end
end



-- 重用时需要先清理, 然后调用refresh
function EquipCell:clearAndRefresh(tbData)
    self:clear(tbData)
    self:refresh(tbData)
end

------------------ 对外接口 end ------------------------
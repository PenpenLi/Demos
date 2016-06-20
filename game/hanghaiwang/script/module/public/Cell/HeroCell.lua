-- FileName: HeroCell.lua
-- Author: zhangqi
-- Date: 2014-05-22
-- Purpose: 定义伙伴和影子列表用的Cell类
--[[TODO List
    [1005] = "进阶",
    [1006] = "时装",
    [1007] = "强化",
    [1012] = "可招募",
]]

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

require "script/module/public/Cell/Cell"

----------------------------- 定义英雄 HeroCell  -----------------------------
HeroCell = class("HeroCell", Cell)

function HeroCell:refreshHero(tbData)
    if (self.mCell) then
        self:refreshBase(tbData)
        
        if (self.baseType == g_fnCellBaseType(CELLTYPE.PARTNER)) then
            local trendInfo = HeroModel.fnGetHeroTypeInfo(tbData.trend) -- 2015-04-29
            -- local labTrend = m_fnGetWidget(self.mCell, "TFD_TYPE") -- 2015-12-17 sunyunpeng
            -- UIHelper.setLabel(labTrend, {text = trendInfo.string, color = self.qualityColor[tbData.nQuality]})
            -- labTrend:setEnabled(false) -- zhangqi,2015-11-11, 监修包隐藏
        
            local i18n_level = m_fnGetWidget(self.mCell, "TFD_LEVEL_TXT")
            i18n_level:setText(m_i18n[1067]) -- 2015-04-29
            self.labLevel = m_fnGetWidget(self.mCell, "TFD_LEVEL") -- 只有伙伴显示等级
            self.labLevel:setText(tbData.sLevel) -- 2015-04-29, 需要改为 xx/xx 格式
        end
        -- 去掉风火雷电标示 sunyunpneg 2015-11-06
        -- local imgSign = m_fnGetWidget(self.mCell, "IMG_SIGN")
        -- imgSign:setVisible(true)
        -- imgSign:loadTexture(tbData.sign)
    end
end

function HeroCell:initHero(sType, sSubType)
    self:initBase(sType, sSubType)
end

----------------------------- 定义影子 ShadowCell  -----------------------------
ShadowCell = class("ShadowCell", HeroCell)

-- tbShadowData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = btnIcon, sLevel = "Lv." .. idx, nStar = 4, nOwn = 1, nMax = idx+1, onRecruit = onRecruitCall}
function ShadowCell:refreshBag(tbData)
    if (self.mCell) then
        local cell = self.mCell
        
        self:removeMaskButton("BTN_RECRUITMENT")

        local btnRecruit = m_fnGetWidget(cell, "BTN_RECRUITMENT") -- 招募
        btnRecruit.idx = tbData.idx
        btnRecruit:setEnabled(false)
        
        local labTitle = m_fnGetWidget(cell, "tfd_progress_i18n") -- 数量：
        labTitle:setText(m_i18n[1332])

        local labSlash = m_fnGetWidget(cell, "tfd_backslash") -- 斜杠
        labSlash:setEnabled(true)
        local labOwn = m_fnGetWidget(cell, "TFD_MEMBER_NUM") -- 分子
        labOwn:setText(tbData.nOwn)
        UIHelper.setLabel(labOwn, {text = tbData.nOwn, color = ccc3(0x57, 0x1E, 0x01)})
        local labMax = m_fnGetWidget(cell, "TFD_DOMIT_NUM") -- 分母
        labMax:setText(tbData.nMax)
        labMax:setEnabled(true)
        
        local btnDrop = m_fnGetWidget(cell, "BTN_DROP")-- 查看掉落按钮
        local tfdDesc = m_fnGetWidget(cell, "TFD_DESC")-- 数量不足

        btnDrop:setEnabled(false)
        btnDrop.idx = tbData.idx

        local labLack = m_fnGetWidget(cell, "TFD_DESC") -- 未集齐提示
        labLack:setText(m_i18n[1127])
        labLack:setEnabled(false)

        local recruitColor = ccc3(0x00, 0x8a, 0x01)

        if (tbData.isRecruited) then -- 可招募的
            tfdDesc:setEnabled(false)
            labOwn:setColor(recruitColor)
            btnRecruit.idx = tbData.idx
            btnRecruit:setEnabled(true)
            UIHelper.titleShadow(btnRecruit, m_i18n[1012])
            self:addMaskButton(btnRecruit, "BTN_RECRUITMENT", tbData.onRecruit)
        else
            if (tonumber(tbData.is_compose) ~= 1) then -- 不允许招募
                tfdDesc:setEnabled(false)
                labOwn:setColor(recruitColor)
                labSlash:setEnabled(false)
                labMax:setEnabled(false)
                labLack:setEnabled(false)
                btnDrop:setEnabled(true)
                self:addMaskButton(btnDrop, "BTN_DROP", tbData.findDrop)
            elseif (tbData.expact and tbData.nOwn < tbData.nMax) then -- 允许招募但数量不足
                tfdDesc:setEnabled(true)
                btnDrop:setEnabled(true)
                self:addMaskButton(btnDrop, "BTN_DROP", tbData.findDrop)
                labLack:setEnabled(true)
                labOwn:setColor(ccc3(0xdf, 0x01, 0x0c))
            elseif(tbData.isBuddy) then  -- 已招募
                tfdDesc:setEnabled(false)
                labSlash:setEnabled(false)
                labMax:setEnabled(false)
                labOwn:setColor(recruitColor)
                btnDrop:setEnabled(true)
                self:addMaskButton(btnDrop, "BTN_DROP", tbData.findDrop)
            end
        end
    end
end


--刷新分解列表
function ShadowCell:refreshDecomp( tbData )
    if (self.mCell) then
        local cell = self.mCell

        self.cbxSelect = m_fnGetWidget(self.mCell, "CBX_SHADOW_REBORN_SELECT")
        self.cbxSelect:setSelectedState(tbData.isSelected)

        local labTitle = m_fnGetWidget(cell, "tfd_progress_i18n") -- 进度条标题
        labTitle:setText(m_i18n[1332])
        labTitle:setVisible(true)


        local IMG_CAN_DECOMP = m_fnGetWidget(cell, "IMG_DECOMPOSE") -- 不可分解

        local imgUnComplete = m_fnGetWidget(cell, "IMG_UNCOMPLETE") -- 未集齐
        local btnRecruit = m_fnGetWidget(cell, "BTN_RECRUITMENT") -- 可招募
        UIHelper.titleShadow(btnRecruit, m_i18n[5526])

        if(tbData.bCanSelectd == true) then
            self.cbxSelect:setEnabled(true)
            IMG_CAN_DECOMP:setEnabled(false)
        else
            self.cbxSelect:setEnabled(false)
            IMG_CAN_DECOMP:setEnabled(true)
        end

        local labCollect = m_fnGetWidget(self.mCell,"tfd_collect_i18")   --(集齐)
        labCollect:setText(m_i18n[7142])  

        local tfd_decompose_i18 = m_fnGetWidget(self.mCell,"tfd_decompose_i18")  --个可进行分解）
        tfd_decompose_i18:setText(m_i18n[7143])  

        local labNum2 = m_fnGetWidget(self.mCell,"TFD_SHADOW_NUM") 
        labNum2:setText(tbData.max_stack)
        
        labCollect:setEnabled(false)
        tfd_decompose_i18:setEnabled(false)
        labNum2:setEnabled(false)


        local labOwn = m_fnGetWidget(cell, "TFD_MEMBER_NUM")
        labOwn:setText(tbData.item_num)
        local labMax = m_fnGetWidget(cell, "TFD_DOMIT_NUM")
        labMax:setText(tbData.max_stack)
    end
end
function ShadowCell:refresh(tbData)
    if (self.mCell) then
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        self:refreshHero(tbData)
         
        self:refreshByType(tbData)
    end
end
-- sUseType, 取值范围 CELL_USE_TYPE
function ShadowCell:init(sUseType)
    self.UseNames = {["LAY_SHADOW_DECOMPOSE"]=false, ["LAY_SHADOW_BAG"]=false}
    self:initHero(CELLTYPE.SHADOW, sUseType)
end

----------------------------- 定义英雄 PartnerCell  -----------------------------
PartnerCell = class("PartnerCell", HeroCell)

function PartnerCell:setTransferLevel( tbData )
    local labTransLv = m_fnGetWidget(self.layMod, "TFD_TRANSFER_NUM")
    if(tonumber(tbData.sTransfer) > 0) then
        labTransLv:setText(tbData.sTransfer)
        labTransLv:setColor(self.qualityColor[tbData.nQuality]) -- 先按较暗的配色
    else
        labTransLv:setEnabled(false)
    end
end

-- PartnerCell.UseNames = {["LAY_PARTNER_BAG"]=false, ["LAY_PARTNER_SALE"]=false, ["LAY_PARTNER_LOAD"]=false, ["LAY_PARTNER_STRONG"]=false,
-- 						["LAY_PARTNER_TRANSFER"]=false, ["LAY_PARTNER_REBORN"]=false, ["LAY_PARTNER_DECOMPOSE"]=false, ["LAY_SMALL_PARTNER_ALONE"]=false,}

--[[
-- tbPartnerData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = btnIcon, sLevel = "Lv." .. idx, nStar = 4, nQuality = idx,
                    sTransfer = idx, bLock = (idx%2 == 0), bPlayer = (idx == 0), onTransfer = func, onStrong = func, onFashion = func, bLoaded = (idx%3 == 0), bSmall = (idx%5 == 0), -- bag
                    sPrice = 1000, bSelect = false, -- sale
                    sTransfer = idx, onLoad = func, -- load
                    sExp = 1000, bSelect = false, -- strong
                    sTransfer = idx, onTransfer = func, -- transfer
                    sTransfer = idx, bSelect = false, -- reborn
                    bSelect = false,  -- decompose
 }
--]]
function PartnerCell:refreshBag( tbData ) -- 背包列表
    if (self.layMod) then
        local bag = self.layMod

        self:setTransferLevel(tbData) -- 进阶等级
        self:setAwakeLel( tbData )   -- 觉醒等级

        local imgLoaded = m_fnGetWidget(bag, "IMG_LOADED") -- 已上阵标签
        imgLoaded:setEnabled(tbData.bLoaded)

        local imgBench = m_fnGetWidget(bag, "IMG_BENCH") -- 小伙伴标签
        imgBench:setEnabled(tbData.bBench)

        local BTN_DOWN = m_fnGetWidget(bag, "BTN_DOWN") -- 进阶红点 2015-11-18
        local btnDownRedPoint = m_fnGetWidget(BTN_DOWN, "IMG_RED") 
        local BTN_UP = m_fnGetWidget(bag, "BTN_UP") -- -- 进阶红点 2015-11-18
        local btnUpRedPoint = m_fnGetWidget(BTN_UP, "IMG_RED") 

        local imgBench = m_fnGetWidget(bag, "BTN_DOWN") -- 小伙伴标签

        if (tbData.transNotice or tbData.awakeNotice) then  -- 可进阶 或者 可觉醒
            btnDownRedPoint:removeAllNodes()
            btnDownRedPoint:addNode(UIHelper.createRedTipAnimination())
            btnUpRedPoint:removeAllNodes()
            btnUpRedPoint:addNode(UIHelper.createRedTipAnimination())
        else
            btnDownRedPoint:removeAllNodes()
            btnUpRedPoint:removeAllNodes()
        end

        self:refreshBarBtn(tbData.idx)
     
    end
end


function PartnerCell:setAwakeLel( tbData )
    logger:debug({setAwakeLel = tbData})

    local bAwake = tbData.isCanAwake or false
    local tfdAwakeNum = m_fnGetWidget(self.mCell, "TFD_AWAKE_NUM")  -- 几星几级  
    local tfdAwake = m_fnGetWidget(self.mCell, "tfd_awake") 
    if (bAwake) then
        local awake_attr = tbData.awake_attr
        local level = tonumber(awake_attr.level or 0)
        local star = tonumber(awake_attr.star_lv or 0)

        tfdAwakeNum:setEnabled(true)
        tfdAwake:setEnabled(true)
        tfdAwakeNum:setText(gi18nString(7403,star,level))

        for i=1,5 do
            local imgAwakeAsh = m_fnGetWidget(self.mCell, "img_awake_ash_" .. i)  -- 星底
            imgAwakeAsh:setEnabled(true)

            local imgAwake = m_fnGetWidget(self.mCell, "img_awake_" .. i) -- 星
            imgAwake:setEnabled(i <= star)

        end
    else
        tfdAwakeNum:setEnabled(false)
        tfdAwake:setEnabled(false)

        for i=1,5 do
            local imgAwakeAsh = m_fnGetWidget(self.mCell, "img_awake_ash_" .. i) 
            imgAwakeAsh:setEnabled(false)

            local imgAwake = m_fnGetWidget(self.mCell, "img_awake_" .. i) 
            imgAwake:setEnabled(false)
        end
    end

end

-- tbSale = {sPrice = 1000, bSelect = false}
function PartnerCell:refreshSale( tbData ) -- 出售列表, 废弃
	if (self.layMod) then
       local labCoin = m_fnGetWidget(self.layMod, "TFD_SELL_PRICE")
       labCoin:setText(tbData.sPrice)
       
       self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_SELL_SELECT")
       self.cbxSelect:setSelectedState(tbData.bSelect)
    end
end

-- tbLoad = {sTransfer = idx, onLoad = func}
function PartnerCell:refreshLoad( tbData ) -- 更换列表
	if (self.layMod) then
        self:setTransferLevel(tbData)
        self:setAwakeLel(tbData)

        local labItemNum = m_fnGetWidget(self.mCell, "TFD_QUALITY") -- 资质数值
        labItemNum:setText(tbData.heroQuality)
        
        self.btnLoad = m_fnGetWidget(self.layMod, "BTN_LOAD")
        UIHelper.titleShadow(self.btnLoad, m_i18n[1210])
        -- self.btnLoad:addTouchEventListener(tbData.onLoad)
        --上阵按钮
        self:addMaskButton(self.btnLoad, "BTN_LOAD", tbData.onLoad)
        self.btnLoad:setTag(tbData.heroid)
    end
end

-- tbStrongData = {sExp = 1000, bSelect = false}
function PartnerCell:refreshStrong( tbData ) -- 强化列表
	if (self.layMod) then
        local labZz = m_fnGetWidget(self.mCell, "tfd_quality_i18n") -- 资质标题需要改成数量
        labZz:setText(m_i18n[1332])

        local labItemNum = m_fnGetWidget(self.mCell, "TFD_QUALITY") -- 资质数值
        labItemNum:setText(tbData.item_num)
        
        local i18n_exp = m_fnGetWidget(self.mCell, "tfd_exp")
        i18n_exp:setText(m_i18n[1725])
        local labExpNum = m_fnGetWidget(self.mCell, "TFD_EXP_NUM")
        labExpNum:setText(tbData.sExp)
        
        self.cbxSelect = m_fnGetWidget(self.mCell, "CBX_STRONG_SELECT")
        self.cbxSelect:setSelectedState(tbData.bSelect)

        local tfdAwakeNum = m_fnGetWidget(self.mCell, "TFD_AWAKE_NUM")  -- 几星几级  
        local tfdAwake = m_fnGetWidget(self.mCell, "tfd_awake") 

        tfdAwakeNum:setEnabled(false)
        tfdAwake:setEnabled(false)

        for i=1,5 do
            local imgAwakeAsh = m_fnGetWidget(self.mCell, "img_awake_ash_" .. i) 
            imgAwakeAsh:setEnabled(false)

            local imgAwake = m_fnGetWidget(self.mCell, "img_awake_" .. i) 
            imgAwake:setEnabled(false)
        end
    end
end

-- tbLoad = {sTransfer = idx, onTransfer = func}
function PartnerCell:refreshTransfer( tbData ) -- 进阶列表
	if (self.layMod) then
        self:setTransferLevel(tbData)
        
        local labItemNum = m_fnGetWidget(self.mCell, "TFD_QUALITY") -- 资质数值
        labItemNum:setText(tbData.heroQuality)

        local btnTrans = m_fnGetWidget(self.layMod, "BTN_TRANSFER")
        btnTrans.phid = tbData.id
        UIHelper.titleShadow(btnTran, m_i18n[1005])
        -- btnTrans:addTouchEventListener(tbData.onTransfer)
        self:addMaskButton(btnTrans, "BTN_TRANSFER", tbData.onTransfer)
    end
end

-- tbRbornData = {sTransfer = idx, isSelected = false}
function PartnerCell:refreshReborn( tbData ) -- 重生列表
	if (self.layMod) then
        local reBorn = self.layMod

        
        self.cbxSelect = m_fnGetWidget(reBorn, "CBX_REBORN_SELECT")
        self.cbxSelect:setSelectedState(tbData.isSelected)
    end
end

-- tbDecompData = {isSelected = false}
function PartnerCell:refreshDecomp( tbData ) -- 分解列表
	if (self.layMod) then
        local labZz = m_fnGetWidget(self.mCell, "tfd_quality_i18n") -- 资质标题需要改成数量  --zhangjunwu 继续改回去 改为资质
        labZz:setText(m_i18n[1003])

        self:setTransferLevel(tbData)
        self:setAwakeLel( tbData )   -- 觉醒等级
        local labItemNum = m_fnGetWidget(self.mCell, "TFD_QUALITY") -- 资质数值
        labItemNum:setText(tbData.heroQuality)
        
        self.cbxSelect = m_fnGetWidget(self.layMod, "CBX_DECOMPOSE_SELECT")
        self.cbxSelect:setSelectedState(tbData.isSelected)
    end
end

-- 2015-04-29, LAY_SMALL_PARTNER_ALONE, 小伙伴上阵
function PartnerCell:refreshSmall( ... )
    if (self.layMod) then
        self:setTransferLevel(tbData)

        local btnLoad = m_fnGetWidget(self.layMod, "BTN_SMALL_PARTNER_FORMATION")
        UIHelper.titleShadow(btnLoad, m_i18n[1210]) -- 上阵
    end
end

function PartnerCell:refresh(tbData)
    if (self.mCell) then
        if (tbData.getItemData) then
            tbData=tbData.getItemData(tbData)
        end
        self:clearMaskButton() -- 刷新前清除所有之前的按钮事件绑定信息

        if (tbData.isBtnBar) then -- 如果是按钮面板
            self.imgBg:setEnabled(false)
            self.layMod:setEnabled(false)

            self.layBtnBar:setEnabled(true)
            logger:debug({PartnerCellrefresh = tbData.idx})
            self.objBtnBar:refresh(tbData, tbData.idx - 1) -- 按钮面板初始化功能按钮实际要取index小1的实际cell的属性
        else
            if (self.layBtnBar) then
                self.layBtnBar:setEnabled(false)
                self.imgBg:setEnabled(true)
            end

            self.layMod:setEnabled(true)

            self:refreshHero(tbData)
            
            local labZz = m_fnGetWidget(self.mCell, "tfd_quality_i18n") -- 资质标题
            labZz:setText(m_i18n[1003])

        	local labZiZ = m_fnGetWidget(self.mCell, "TFD_QUALITY") -- 资质数值
        	labZiZ:setText(tbData.heroQuality)

            self:refreshByType(tbData)
        end
    end
end

-- sUseType, 取值范围 CELL_USE_TYPE
function PartnerCell:init(sUseType,idx)
    logger:debug({PartnerCell = idx})
    if (idx==nil) then
        idx=9
    end
    self.UseNames = {["LAY_PARTNER_BAG"]=false, ["LAY_PARTNER_SALE"]=false, ["LAY_PARTNER_LOAD"]=false, ["LAY_PARTNER_STRONG"]=false,
                        ["LAY_PARTNER_TRANSFER"]=false, ["LAY_PARTNER_REBORN"]=false, ["LAY_PARTNER_DECOMPOSE"]=false, ["LAY_PARTNER_SMALL"]=false,}

    self:initHero(CELLTYPE.PARTNER, sUseType)

    if (self.subType == CELL_USE_TYPE.BAG) then -- 如果是伙伴背包需要初始化按钮面板加到伙伴Cell上
        self.imgBg = m_fnGetWidget(self.mCell, "img_cell_partner_bg")
        performWithDelayFrame(self.imgBg,function()
                require "script/module/public/Cell/BtnBarCell"
                self.objBtnBar = BtnBarCell:new()
                self.objBtnBar:init(CELL_USE_TYPE.BAG, self)
                self.layBtnBar = self.objBtnBar.mCell
                self.mCell:addChild(self.layBtnBar)
            end,0)--9-idx) --liweidong 注掉 说不好有好的想法再加上

        
    end
end

-- FileName: Cell.lua 
-- Author: zhangqi
-- Date: 2014-05-21 
-- Purpose: 各种列表里的Cell类定义

local m_fnGetWidget = g_fnGetWidgetByName

function fnRectAnchorCenter(x, y, size)
    return CCRectMake(x - size.width/2, y - size.height/2, size.width, size.height)
end

----------------------------- 定义基类 Cell, 加载一次公共cell的json文件 -----------------------------
-- 记录name颜色用深色方案的cell type
local tbColor = {LAY_ITEM = true, LAY_PARTNER = true, LAY_SHADOW = true, LAY_EQUIP = true, LAY_FRAGMENT = true,
                     LAY_TREASURE = true, LAY_CONCH = true, LAY_TREA_FRAG = true, LAY_AWAKE = true}

CELLTYPE = {
    PARTNER = "partner",
    SHADOW = "shadow",
    ITEM = "item",
    TREASURE = "treasure",
    EQUIP = "equip",
    FRAGMENT = "fragment",
    CONCH = "conch",
    BTN_BAR = "down",
    TREA_FRAG = "trea_frag", -- 宝物碎片
    SPECIAL = "special",
    SPECIAL_FRAG = "spec_frag",
    AWAKE = "awake", -- 觉醒物品
}

CELL_TYPE_CHK = {} -- 保存cell类型，用于有效性检查
for k, v in pairs(CELLTYPE) do
    CELL_TYPE_CHK[v] = true
end

CELL_USE_TYPE = {
    BAG = "BAG", -- 背包列表
    SALE = "SALE", -- 出售列表
    LOAD = "LOAD", -- 更换列表
    STRONG = "STRONG", -- 强化列表
    TRANSFER = "TRANSFER", -- 进阶列表
    REBORN = "REBORN", -- 重生列表
    DECOMP = "DECOMPOSE", -- 分解列表
}

CELL_CLONE = {} -- 保存每个大类的cell的对象，避免每次创建

-- zhangqi, 2015-06-12, 根据类型加载每种cell对应的画布，并将layout对象缓存起来避免每次都加载
local function loadCell(sType)
    assert(CELL_TYPE_CHK[sType], sType .. " Must be a type in CELLTYPE.")
    if (not CELL_CLONE[sType]) then
        -- TimeUtil.timeStart("Cell:load: " .. sType) -- 2015-06-10
        local layout = g_fnLoadUI("ui/cell_" .. sType .. ".json")
        -- layout:retain()
        foreverObjectArr:addObject(layout) --liweidong放到常住内存数组中
        CELL_CLONE[sType] = layout
        -- TimeUtil.timeEnd() -- 2015-06-10
    end
end
--liweidong 获得cell
function getCellByType(sType)
    loadCell(sType)
    return CELL_CLONE[sType]
end
function g_fnCellBaseType( sType )
    return "LAY_" .. string.upper(sType)
end

-- 全局方法，根据指定的cell 类型返回size，代替原来需要类示例调用的cellSize方法
function g_fnCellSize(sType)
    loadCell(sType)

    local widget = m_fnGetWidget(CELL_CLONE[sType], g_fnCellBaseType(sType))
    local szCell = widget:getSize()
    logger:debug("Cell:size: %s", sType)
    logger:debug("szCell.width = %f,  szCell.height = %f", szCell.width, szCell.height)
    logger:debug("szCell.width* = %f,  szCell.height* = %f", szCell.width*g_fScaleX, szCell.height*g_fScaleX)

    return CCSizeMake(szCell.width*g_fScaleX, szCell.height*g_fScaleX)
end

Cell = class("Cell")

function Cell:ctor(objView)
    self.tabExp = 6666 -- 2015-05-06, 显示经验属性的label的tag

    self.objView = objView -- 2015-04-27

    self.tbMaskRect = {} -- 保存需要屏蔽cell touch 事件的按钮点击区域
    self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件

    self._bagHandler = nil -- cell 对应的背包数据的缓存对象
end

function Cell:bagHandler( objHandler )
    if (objHandler) then
        self._bagHandler = objHandler
    else
        return self._bagHandler
    end
end

function Cell:cellSize( ... )
    return self.szCell
end

function Cell:initBase(sType, sSubType)
    loadCell(sType)

    self.mCellTemp = CELL_CLONE[sType]

    self.baseType = g_fnCellBaseType(sType)
    self.subType = sSubType

    self.nameColor = (tbColor[self.baseType] == true) and g_QulityColor or g_QulityColor2
    self.qualityColor = g_QulityColor
    self.qualityColor2 = g_QulityColor2

    self.mCell = self:createCellTemplateByType()
    self.mCell:setVisible(true)
    self.mCell:setScale(g_fScaleX)
    -- self.mCell:setSize(CCSizeMake(self.mCell:getSize().width*g_fScaleX,self.mCell:getSize().height*g_fScaleX)) --缩放cell
    -- local childArr = self.mCell:getChildren()
    -- for i=0,childArr:count()-1 do
    --     local item = tolua.cast(childArr:objectAtIndex(i), "Widget")
    --     item:setScale(g_fScaleX)
    -- end
end

-- tbData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = {id = htid, bHero = false, onTouch = func}}
function Cell:refreshBase(tbData)
    if (self.mCell) then
        --logger:debug(tbData)
        self.labName = m_fnGetWidget(self.mCell, "TFD_NAME")
        UIHelper.labelEffect(self.labName, tbData.name)

        assert(tbData.nQuality, "Cell:refreshBase: nQuality is " .. tbData.nQuality or type(tbData.nQuality ))
        self.labName:setColor(self.nameColor[tonumber(tbData.nQuality)])

        self.layIcon = m_fnGetWidget(self.mCell, "LAY_ICON") -- 图标按钮容器
        self.layIcon:removeAllChildren() -- 先删除之前添加的icon button
        
        local szIcon = self.layIcon:getSize()
        local btnIcon
        if (tbData.icon.bHero) then
            btnIcon = HeroUtil.createHeroIconBtnByHtid(tbData.icon.id) --, nil, tbData.icon.onTouch)
            
            if (tbData.idx) then
                btnIcon.idx = tbData.idx
            end 
        else
            local tbSign = {}
            if (self.baseType == g_fnCellBaseType(CELLTYPE.FRAGMENT)
                    and (self.subType == CELL_USE_TYPE.BAG or self.subType == CELL_USE_TYPE.SALE)) then
                -- zhangqi, 2014-10-16, 如果是背包和出售列表的装备碎片，则不显示碎片标签
                tbSign.hideArticleContr = true
            end
            btnIcon = ItemUtil.createBtnByTemplateId(tbData.icon.id, nil, tbSign)
        end

        if(tbData.icon.bSui)then
            ItemUtil.addSuiSignToWidget(btnIcon)
        end
        
        btnIcon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
        self.layIcon:addChild(btnIcon)
        self.tbMaskRect["LAY_ICON"] = self:getRect(self.layIcon)
        self.tbBtnEvent["LAY_ICON"] = {sender = btnIcon, event = tbData.icon.onTouch}  
        self:maskCellSpace( true )
    end
end

-- 屏蔽cell和cell之间的空隙
function Cell:maskCellSpace( flag )
    -- 屏蔽cell和cell之间的空隙
    if (self.mCell) then
        local cellSize = self.mCell:getSize()
        local cellSpacePercent = 0.1
        logger:debug("MaskCellSpace")
        self.tbMaskRect["LAY_CELLSPACE"] = CCRectMake(0, 0 + cellSize.height * (1 - cellSpacePercent), cellSize.width *g_fScaleX, cellSize.height * cellSpacePercent * g_fScaleX) 
        self.tbBtnEvent["LAY_CELLSPACE"] = {sender = self.mCell, event = function ( ... )
        end} 
    else
        self.tbMaskRect["LAY_CELLSPACE"] = nil
        self.tbBtnEvent["LAY_CELLSPACE"] = nil
    end
end


function Cell:getRect( widget )
    local sz = widget:getSize()
    local pWorld = widget:convertToWorldSpace(ccp(0,0))
    local pCell = self.mCell:convertToNodeSpace(pWorld)
    return CCRectMake(pCell.x, pCell.y, sz.width*g_fScaleX, sz.height*g_fScaleX)
end


-- 保存Cell上所有按钮的Rect，用于CCTableView.kTableCellTouched 里检测触点
-- 如果落在这些区域内则跳过 CellTouched 事件处理
function Cell:addMaskButton(btn, sName, fnBtnEvent)
    if ( not self.tbMaskRect[sName]) then
        local rect = self:getRect(btn)
        self.tbMaskRect[sName] = fnRectAnchorCenter(rect.origin.x*g_fScaleX, rect.origin.y*g_fScaleX, rect.size)
    end

    -- zhangqi, 2015-09-14, 每次都重新给按钮事件赋值，避免每次先调用 removeMaskButton 方法
    self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}
end

-- 删除需要屏蔽的按钮信息，
-- 用于避免类似影子cell上点击了招募按钮隐藏后，但点击该区域仍然会激发招募的按钮事件的问题
function Cell:removeMaskButton( sName )
    logger:debug("Cell:removeMaskButton btnName = %s", sName)
    if (self.tbMaskRect[sName]) then
        self.tbMaskRect[sName] = nil
        self.tbBtnEvent[sName] = nil
        logger:debug("Cell:removeMaskButton btnName = %s is nil", sName)
    end
end

function Cell:clearMaskButton( ... )
    --logger:debug({clearMaskButton = self.tbMaskRect})
    if (not table.isEmpty(self.tbMaskRect)) then
        self.tbMaskRect = {}
        self.tbBtnEvent = {}
    end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function Cell:touchMask(point)
    logger:debug("Cell:touchMask, tbMaskRect.count = %d", table.count(self.tbMaskRect))

    -- 可能有别的Cell没有完全按public/Cell的模式去实现，保险起见再加一层对self.tbMaskRect的nil检查, 2014-07-22
    if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
        return nil
    end
    for name, rect in pairs(self.tbMaskRect) do
        logger:debug("Cell:touchMask rect: %f, %f, %f, %f  point.x = %f, point.y = %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height, point.x, point.y)
        if (rect:containsPoint(point)) then
            logger:debug("hitted button: %s", name)
            return self.tbBtnEvent[name]
        end
    end
end

function Cell:getGroup()
    if (self.mCell) then
        -- local tg = HZTouchGroup:create() -- 可接受触摸事件，传递给UIButton等UI控件
        -- tg:addWidget(self.mCell)
        -- return tg
        return self.mCell
    end
    return nil
end

-- 根据指定的cell 类型初始化对应的cell 模板layout
-- sType, string, 取值范围 CELLTYPE,
function Cell:createCellTemplateByType(...)
    local widget = m_fnGetWidget(self.mCellTemp, self.baseType)
    if (widget) then
        local instCell = widget:clone()
        logger:debug("mCell name: %s", instCell:getName())

        local szCell = instCell:getSize()
        self.szCell = CCSizeMake(szCell.width*g_fScaleX, szCell.height*g_fScaleX)

        local useName = self.baseType .. "_" .. self.subType
        if (self.baseType == g_fnCellBaseType(CELLTYPE.BTN_BAR)) then -- 2015-05-06, 如果是下拉按钮面板只需要保留layout名称
            useName = self.baseType
        end

        logger:debug("useName = %s", useName)
        self.UseNames = self.UseNames or {}
        self.UseNames[useName] = true
        
        for k, v in pairs(self.UseNames) do
            local layUse = m_fnGetWidget(instCell, k)
            if ((not v) and layUse) then
                layUse:removeFromParentAndCleanup(true)
            end
        end

        if (self.baseType == useName) then
            self.layMod = instCell -- 如果是下拉按钮面板，这两个变量都只需要引用同一个layout
        else
            self.layMod = m_fnGetWidget(instCell, useName) -- 当前用到类型的layout引用
        end

        return instCell
    end
end

-- 刷新某种子类 self.baseType 的某种类型(CELL_USE_TYPE)的cell
-- 子类必须记录 subType ，并提供用到的 refresh 方法
function Cell:refreshByType(tbData)
	if (self.mCell) then
        local useName = self.baseType .. "_" .. self.subType
        if (useName == self.baseType .. "_BAG") then
            self:refreshBag(tbData)
        elseif (useName == self.baseType .. "_SALE") then
            self:refreshSale(tbData)
        elseif (useName == self.baseType .. "_LOAD") then
            self:refreshLoad(tbData)
        elseif (useName == self.baseType .. "_STRONG") then
            self:refreshStrong(tbData)
        elseif (useName == self.baseType .. "_TRANSFER") then
            self:refreshTransfer(tbData)
        elseif (useName == self.baseType .. "_REBORN") then
            self:refreshReborn(tbData)
        elseif (useName == self.baseType .. "_DECOMPOSE") then
            self:refreshDecomp(tbData)
        end
	end
end

function Cell:refreshBarBtn( idxData )
    if (not self.btnDown) then
        self.btnDown = m_fnGetWidget(self.layMod, "BTN_DOWN") -- 展开按钮面板 2015-04-24
        local btnDownRedPoint = m_fnGetWidget(self.btnDown, "IMG_RED") -- 进阶红点 2015-11-18

        self.btnUp = m_fnGetWidget(self.layMod, "BTN_UP") -- 收回按钮面板 2015-04-24
        local btnUpRedPoint = m_fnGetWidget(self.btnUp, "IMG_RED") -- 进阶红点 2015-11-18
    end

    if (not idxData) then -- 空岛贝和装备共用cell的特殊处理，空岛贝cell需要隐藏下拉按钮
        self.btnDown:setEnabled(false)
        self.btnUp:setEnabled(false)
        return
    end

    local nDownIdx = self.objView:getBtnBarDataIdx()
    logger:debug("refreshBarBtn_nDownIdx: " .. tostring(nDownIdx) .. "  idxData: " .. tostring(idxData))

    if ( nDownIdx > 0 and nDownIdx == idxData + 1) then -- 已经展开
        logger:debug("refreshBarBtn: true")
        self.btnDown:setEnabled(false)
        self:removeMaskButton("BTN_DOWN")

        self.btnUp:setEnabled(true)
        self.btnUp.idxData = idxData
        self:addMaskButton(self.btnUp, "BTN_UP", self:UpEvent())
    else
        logger:debug("refreshBarBtn: false")
        self.btnUp:setEnabled(false)
        self:removeMaskButton("BTN_UP")

        self.btnDown:setEnabled(true)
        self.btnDown.idxData = idxData
        self:addMaskButton(self.btnDown, "BTN_DOWN", self:DownEvent())
    end
end

function Cell:addDownCallback( fnOnBtnDown )
    self.onDownCallback = fnOnBtnDown
end

function Cell:addUpCallback( fnOnBtnUp )
    self.onUpCallback = fnOnBtnUp
end

function Cell:DownEvent( ... )
    return function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            -- 展开音效
            AudioHelper.playDeployedEffect()
            logger:debug("DownEvent")
            self.objView:saveOffsetYBeforeBarDown() -- 2015-05-11, 下拉按钮点击时的listView offset
            self.onDownCallback(sender.idxData)

            sender:setEnabled(false)
            self:removeMaskButton("BTN_DOWN")

            self.btnUp:setEnabled(true)
            self:addMaskButton(self.btnUp, "BTN_UP", self:UpEvent())

            self.objView:reloadDataForBtnBar(1, sender.idxData)
        end
    end
end

function Cell:UpEvent( ... )
    return function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            -- 收起音效
            AudioHelper.playRetractedEffect()
            logger:debug("UpEvent")
            self.objView:saveOffsetYBeforeBarDown() -- 2015-05-11, 下拉按钮点击时的listView offset
            sender:setEnabled(false)
            self:removeMaskButton("BTN_UP")

            self.btnDown:setEnabled(true)
            self:addMaskButton(self.btnDown, "BTN_DOWN", self:DownEvent())
    
            self.objView:reloadDataForBtnBar(-1, sender.idxData)
        end
    end
end
-- 2015-05-06, 从背包的tbData.tbAttr的属性字符串转换为属性名为key,属性值为value的table
function Cell:getAttrTable( sAttr )
    local tbRet = {}
    local tbLine = string.strsplit(sAttr, "\n")
    for i, sLine in pairs(tbLine) do
        local tbAttr = string.strsplit(sLine, " ")
        -- tbRet[tbAttr[1]] = " " .. tbAttr[2]
        table.insert(tbRet,tbAttr)
    end

    return tbRet
end
-- 2015-05-06, zhangqi, 添加到某个数值属性容器
function Cell:addAttrByIdx( idx, sAttr )
    local layAttr = m_fnGetWidget(self.mCell, "LAY_ATTR_DESC_" .. idx) -- 属性描述
    if (not layAttr) then
        return
    end

    local tbAttr = self:getAttrTable(sAttr)

    local szInfo = layAttr:getSize()
    local titleF = g_AttrFont.title
    local valueF = g_AttrFont.value

    local i = 0
    for k, v in pairs(tbAttr) do
        local labTitle = UIHelper.createUILabel( v[1], titleF.name, titleF.size, titleF.color)
        local szTitle = labTitle:getSize()

        labTitle:setAnchorPoint(ccp(0, 1))
        labTitle:setPosition(ccp(0, szInfo.height - i*szTitle.height))
        layAttr:addChild(labTitle)

        
        local labValue = UIHelper.createUILabel( v[2], valueF.name, valueF.size, valueF.color)
        labValue:setAnchorPoint(ccp(0, 1))
        labValue:setPosition(ccp(szTitle.width, 0))
        labTitle:addChild(labValue)

        i = i + 1
    end
end
-- 2015-05-06, zhangqi, 常用添加数值属性方法
function Cell:addAttrByTable( tbAttr )
    self:clearAttrInfo()
    for i, sAttr in ipairs(tbAttr) do
        self:addAttrByIdx(i, sAttr)
    end
end

-- 2015-05-06, zhangqi, 添加经验属性
function Cell:addExpByIdx( idx, sAttr )
    local layAttr = m_fnGetWidget(self.mCell, "LAY_ATTR_DESC_" .. idx) -- 属性描述
    if (not layAttr) then
        return
    end

    self:clearAttrInfo()

    local tbAttr = self:getAttrTable(sAttr)

    local szInfo = layAttr:getSize()
    local titleF = g_AttrFont.title
    local valueF = g_AttrFont.value

    for k, v in pairs(tbAttr) do
        local labTitle = UIHelper.createUILabel( v[1], titleF.name, titleF.size, titleF.color)
        local szTitle = labTitle:getSize()

        labTitle:setAnchorPoint(ccp(0, 1))
        labTitle:setPosition(ccp(0, szInfo.height))
        layAttr:addChild(labTitle)

        
        local labValue = UIHelper.createUILabel( v[2], valueF.name, valueF.size, valueF.color)
        labValue:setAnchorPoint(ccp(0, 1))
        labValue:setPosition(ccp(0, szInfo.height - szTitle.height))
        layAttr:addChild(labValue)
    end
end

-- 2015-05-06, zhangqi, 清除Cell的属性值容器
function Cell:clearAttrInfo( ... )
    for i = 1, 3 do
        local layAttr = m_fnGetWidget(self.mCell, "LAY_ATTR_DESC_" .. i) -- 属性描述
        if (layAttr) then
            layAttr:removeAllChildren()
        end
    end
end

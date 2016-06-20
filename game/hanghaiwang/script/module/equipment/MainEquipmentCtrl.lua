-- FileName: MainEquipmentCtrl.lua 
-- Author: zhaoqiangjun 
-- Date: 14-7-2 
-- Purpose: function description of module
-- Modified:
--[[
    2015-06-09, zhagnqi, 
        1.删除显示强化UI的方法，改为从EquipStrengModel调用创建
        2.优化背包推送的回调，如果只是强化返回则不重新构造碎片列表数据
        3.调整列表的刷新方法，增强视觉体验
        4.整理部分代码，删除弃用的方法
]]

module("MainEquipmentCtrl", package.seeall)

require "script/module/public/Bag"
require "script/module/bag/BagUtil"
require "script/module/public/Cell/EquipCell"
require "script/module/public/Cell/EquipFragCell"
require "script/network/PreRequest"
require "script/module/public/ShowNotice"
require "script/module/public/ItemUtil"
require "script/model/user/UserModel"
require "db/DB_Heroes"
require "script/model/hero/HeroModel"
require "script/model/utils/EquipFragmentHelper"
require "script/module/equipment/EquipFixModel"
require "script/module/equipment/EquipInfoCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbAllBagInfo -- 后端给的原始的背包信息
local m_tbBagInfo -- 按类型（装备，道具，宝物等）分类处理后的背包信息
local m_bag -- Bag 类的对象引用
local m_nExpandNum = 5 -- 背包一次扩充固定的 5 个格子

local m_nUseTid
local m_nUseNum
local m_nUseGid
local m_tbUseItem
local m_equipSelectStar

local fnGetArmFragCellsData
local fnGetArmCellsData
local tbBagInfo = {}

m_tbArmsValue = {}          --listview中的所有装备数据
m_tbArmsFragValue = {}       --listview装备碎片的所有数据 

--限制的卖装备的的星级
local m_saleEquipStar = 4

local m_saleEquipList

local m_tbSaleData -- 出售列表数据

local m_CompandName -- 要合成的装备名称
local m_Compandtid  -- 要合成的装备tid
local m_allEquipData = nil  --用于缓存装备数据
local resumInfo ={} -- 去副本或者其他地方之前报存 列表的便宜 和执行方法信息
local changeModuleInfo = {}

local function init(...)
    m_tbAllBagInfo = nil
    m_tbBagInfo = nil
    m_CompandName = m_i18n[1601] -- 默认"装备"
    m_nUseTid = nil
    m_nUseNum = nil
    m_nUseGid = nil
    m_tbUseItem = nil
    m_equipSelectStar = {}
end

function destroy(...)
    -- init()
    m_equipSelectStar = nil
	package.loaded["MainEquipmentCtrl"] = nil
end

function moduleName()
    return "MainEquipmentCtrl"
end

function setReturnInfo(  )
    DropUtil.insertReturnInfo(moduleName(),"topBar",function ( ... )
        PlayerPanel.addForPartnerStrength()
    end)
end

function touchTabWithIndex( nIndex )
    if (m_bag) then
        logger:debug("MainEquipmentCtrl.touchTabWithIndex")
        m_bag:touchTabWithIndex(nIndex)
    end
end

-- 按物品tid 排序
local function fnCompareWithTid(h1, h2)
    -- logger:debug(h1.tid .. h2.tid)
    if tonumber(h1.tid) == tonumber(h2.tid) then
        return false
    else
        return tonumber(h1.tid) > tonumber(h2.tid)
    end
end

-- 按装备的位置高低排序  武器还是头盔 还是衣服 还是项链
local function fnCompareWithType(h1, h2)
    if tonumber(h1.type)  == tonumber(h2.type) then
        return fnCompareWithTid(h1, h2)
    else
        return h1.type < h2.type
    end
end

-- 按装备的品级高低排序 
local function fnCompareWithBaseSore(h1, h2)
    if tonumber(h1.sScore)  == tonumber(h2.sScore) then
        return fnCompareWithType(h1, h2)
    else
        return h1.sScore > h2.sScore
    end
end

-- 按装备的s数量高低排序 
local function fnCompareWithCurNum(h1, h2)
    if tonumber(h1.curNum)  == tonumber(h2.curNum) then
        return fnCompareWithBaseSore(h1, h2)
    else
        return h1.curNum > h2.curNum
    end
end

-- 装备背包的排序
local function sortEquip(equip_1, equip_2)
    local isPre = false

    -- 2015-04-16, zhangqi, 经验装备比其他装备排后，然后按原规则排序
    if (equip_1.type == 5 and equip_2.type ~= 5) then
        isPre = false -- 前面是经验装备就排后
    elseif (equip_1.type ~= 5 and equip_2.type == 5) then
        isPre = true -- 后面是经验装备保持不变
    else
        if (tonumber(equip_1.fromHid) > 0 and tonumber(equip_2.fromHid) == 0) then
            isPre = true
        elseif ( tonumber(equip_1.fromHid) == 0 and tonumber(equip_2.fromHid) > 0 ) then
            isPre = false
        else
            if ( tonumber(equip_1.starLvl) > tonumber(equip_2.starLvl)) then
                isPre = true
            elseif(tonumber(equip_1.starLvl) == tonumber(equip_2.starLvl)) then
                local t_equip_score_1 = equip_1.quality
                local t_equip_score_2 = equip_2.quality
        
                if (t_equip_score_1 > t_equip_score_2) then
                    isPre = true
                elseif (t_equip_score_1 == t_equip_score_2) then
                    if (tonumber(equip_1.level) > tonumber(equip_2.level)) then
                        isPre = true
                    elseif (tonumber(equip_1.level) == tonumber(equip_2.level)) then
                        isPre = fnCompareWithType(equip_1,equip_2)
                    else
                        isPre = false
                    end
                else
                    isPre = false
                end
            else
                isPre = false
            end
        end
    end

    return isPre
end

-- 装备碎片排序
local function equipFragSort( equip_1, equip_2 )
    local isPre = false

    local curNum1, curNum2 = tonumber(equip_1.curNum), tonumber(equip_2.curNum)
    local maxNum1, maxNum2 = tonumber(equip_1.maxNum), tonumber(equip_2.maxNum)

    if (curNum1 == maxNum1 and curNum2 < maxNum2) then
        isPre = true
    elseif (curNum1 < maxNum1 and curNum2 == maxNum2) then
        isPre = false
    else
        if( tonumber(equip_1.nQuality) > tonumber(equip_2.nQuality))then
            isPre = true
        elseif (tonumber(equip_1.nQuality) == tonumber(equip_2.nQuality))then
            isPre = fnCompareWithCurNum(equip_1,equip_2)
        else
            isPre = false
        end 
    end
    return isPre
end

-- 更新本模块背包数据
local function updateBagInfo ( ... )
    m_tbAllBagInfo = DataCache.getRemoteBagInfo() or {}
    -- logger:debug(m_tbAllBagInfo)
    m_tbBagInfo = DataCache.getBagInfo() or {}
    -- logger:debug(m_tbBagInfo)
    -- logger:debug("equipCount = %d", #m_tbBagInfo.arm)
    -- logger:debug({updateBagInfo = m_tbAllBagInfo})

end

local function getMaxNumByIndex( nIndex )
    local gridMaxNum
    if(nIndex == 1) then
        gridMaxNum = m_tbAllBagInfo.gridMaxNum.arm
    elseif(nIndex == 2) then
        gridMaxNum = m_tbAllBagInfo.gridMaxNum.armFrag
    end
    return gridMaxNum 
end

-- 扩充按钮事件回调
-- nIndex = 1, 装备; 2 装备碎片; 3 时装 
function onExpand ( nIndex )
    local expData = {{itype = 1, i18nWarn = 1605, i18nRet = 1010, goldNeed = BagUtil.getNextOpenArmGridPrice()},
                     {itype = 4, i18nWarn = 1606, i18nRet = 1010, goldNeed = BagUtil.getNextOpenArmFragGridPrice()} -- 后端请求参数
                    }
    local strMsg = m_i18nString(expData[nIndex].i18nWarn, m_nExpandNum, expData[nIndex].goldNeed)

    local function expandCallback( cbFlag, dictData, bRet )
        if (bRet) then
            UserModel.addGoldNumber(- expData[nIndex].goldNeed)
            ShowNotice.showShellInfo(m_i18nString(expData[nIndex].i18nRet, expData[nIndex].goldNeed, m_nExpandNum))
            DataCache.addGidNumBy(expData[nIndex].itype, m_nExpandNum)
            updateBagInfo() -- 刷新背包信息
            if (LayerManager.curModuleName() == moduleName()) then
                local extIndex = nIndex
                if (m_bag.mBtnIndex == nIndex) then
                    extIndex = nil -- 如果是在背包里回调的扩充事件，nil 指定更新最大数，否则只提示扩充不更新最大数
                end
                m_bag:updateMaxNumber(getMaxNumByIndex(nIndex), extIndex) -- 刷新携带数
            end
        end
    end

    local function onConfirm ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            if (expData[nIndex].goldNeed <= UserModel.getGoldNumber()) then
                AudioHelper.playBuyGoods() 
                local args = Network.argsHandler(m_nExpandNum, expData[nIndex].itype) -- nIndex=1, 开启装备格子; 2, 开启装备碎片格子
                RequestCenter.bag_openGridByGold(expandCallback, args)
                LayerManager.removeLayout()
            else -- 金币不足, 弹提示充值面板
                AudioHelper.playCommonEffect()
                LayerManager.removeLayout() -- 关闭扩充提示面板
                LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
            end
        end
    end
    
    LayerManager.addLayout(UIHelper.createCommonDlg(strMsg, nil, onConfirm))
end

-- 后端推送背包信息的回调
function refreshArmAndArmFragList(nDelNum)
    logger:debug("refrashItemAndTreasureList")

    updateBagInfo() -- 先同步模块背包信息和Cache的背包信息，以便在背包推送后可以正确刷新
    
    local viewData = nil
    if (m_bag.mBtnIndex == 1) then
        m_tbArmsValue = {} -- 清空装备列表缓存，便于更新                      
        viewData = fnGetArmCellsData()
        m_bag:updateCurrentListWithData(viewData, nil, nDelNum)
    elseif (m_bag.mBtnIndex == 2) then
        -- 需要同时清空装备和碎片列表缓存，便于更新
        m_tbArmsValue = {}                         
        m_tbArmsFragValue = {}                     

        viewData = fnGetArmFragCellsData()

        --如果是碎片合成的话，还需要再刷新左边的列表,木有办法啊
        equipViewData = fnGetArmCellsData()
        m_bag:updateListWithData(equipViewData, 1)
        m_bag:updateCurrentListWithData(viewData,nil ,1)
        m_bag:udpateRedCircle(true, EquipFragmentHelper.getCanFuseNum()) -- zhangqi, 2014-08-09
    end
   
    PreRequest.removeBagDataChangedDelete() -- zhangqi, 2014-07-23, 一次使用后的背包信息推送返回后删除之前的回调方法，避免UI刷新报错
    return true
end

--[[desc:替换已经存在的装备碎片
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function replaceEquipFragDataByGid(gid,data)
    --判断之前是否进入过背包
    if(not table.isEmpty(m_tbArmsFragValue)) then
        for i,v in ipairs(m_tbArmsFragValue) do
            if(tonumber(v.gid) == tonumber(gid)) then
                logger:debug("替换的装备碎片的未经过处理的信息是：")
                logger:debug(data.gid)
                data.gid = gid
                logger:debug(data.gid)
                local tbArmData = getArmFragDataByValue(data)
                m_tbArmsFragValue[i] = tbArmData
                
                g_bagRefresh.equipFragRefresh = true
                return
            end
        end
    end
end

--[[desc:插入新装备碎片数据
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function insertEquipFragDataByGid(gid,data)
    --判断之前是否进入过背包,
    if(not table.isEmpty(m_tbArmsFragValue)) then
        logger:debug("插入的装备碎片的未经过处理的信息是：")
        logger:debug(data.gid)
        data.gid = gid
        logger:debug(data.gid)
        local tbNewArmData = getArmFragDataByValue(data)
        logger:debug(tbNewArmData)
        table.insert(m_tbArmsFragValue,tbNewArmData)
        g_bagRefresh.equipFragRefresh = true
    end
end

--[[desc:删除旧数据装备碎片
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function removeEquipFragDataByGid(gid)
     --判断之前是否进入过背包
    if(not table.isEmpty(m_tbArmsFragValue)) then
        local index = 0
        for i=1,#m_tbArmsFragValue do
            if(tonumber(m_tbArmsFragValue[i].gid) == tonumber(gid)) then
                index = i
                break
            end
        end

        table.remove(m_tbArmsFragValue, index)
        g_bagRefresh.equipFragRefresh = true
    end
end

--[[desc:替换已经存在的装备
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function replaceEquipDataByGid(gid,data)
    logger:debug("replaceEquipDataByGid")
    --判断之前是否进入过背包
    if(not table.isEmpty(m_tbArmsValue)) then
        for i,v in ipairs(m_tbArmsValue) do
            if(tonumber(v.id) == tonumber(data.item_id)) then
                data.gid = gid
                local tbArmData = getArmDataByValue(data)
               -- logger:debug(tbArmData)
                m_tbArmsValue[i] = tbArmData
                -- logger:debug(i)
                -- logger:debug(m_tbArmsValue)
                g_bagRefresh.equipRefresh = true
                return
            end
        end
    end
end

--[[desc:插入新装备数据
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function insertEquipDataByGid(gid,data)
    --判断之前是否进入过背包
    if(not table.isEmpty(m_tbArmsValue)) then
        data.gid = gid
        local tbNewArmData = getArmDataByValue(data,true)
        logger:debug(tbNewArmData)
        table.insert(m_tbArmsValue,tbNewArmData)
        g_bagRefresh.equipRefresh = true
    end
end


--[[desc:替换已经存在的装备
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function replaceEquipDataByItemId( itemId )
    local refreshData = {}
    local DatacachData = ItemUtil.getItemInfoByItemId(tonumber(itemId))

    if (not DatacachData) then
        DatacachData = ItemUtil.getEquipInfoFromHeroByItemId(tonumber(itemId))
    end

    refreshData = table.hcopy(DatacachData,refreshData)
    --判断之前是否进入过背包
    if(not table.isEmpty(m_tbArmsValue)) then
        for i,v in ipairs(m_tbArmsValue) do
            if(tonumber(v.id) == tonumber(refreshData.item_id)) then
                logger:debug("v.id = item_id")

                local tbArmData = getArmDataByValue(refreshData)
                tbArmData.idx = v.idx
                m_tbArmsValue[i] = tbArmData
                g_bagRefresh.equipRefresh = true
                return
            end
        end
    end
    
end

--[[desc:删除旧数据 z装备
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
function removeEquipDataByGid(gid)
     --判断之前是否进入过背包
    if(not table.isEmpty(m_tbArmsValue)) then
        local index = 0
        for i=1,#m_tbArmsValue do
            if(tonumber(m_tbArmsValue[i].gid) == tonumber(gid)) then
                index = i
                break
            end
        end
        logger:debug(m_tbArmsValue[index])
        table.remove(m_tbArmsValue, index)
        logger:debug(m_tbArmsValue[index])
        g_bagRefresh.equipRefresh = true
    end
end

--[[
    desc:跳转到附魔界面
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
-—]]
function fnShowFixLayer( item_info )
    require "script/module/equipment/EquipFixCtrl"
    if (not SwitchModel.getSwitchOpenState(ksSwitchEquipFixed,true)) then
        return
    end 

    local tbEuipIds = { item_id = item_info.item_id, item_template_id = item_info.item_template_id} -- 2015-04-30
    logger:debug(tbEuipIds)
    
    local isCanFix = EquipFixModel.isEuipCanFixByTid(tbEuipIds.item_template_id)

    if(tonumber(isCanFix) ==  1) then
        local createType = g_equipStrengthFrom.CreateType.createTypeEquipList -- zhangqi, 2015-06-19
         TimeUtil.timeStart("EquipFixCtrl.create")
        EquipFixCtrl.create(tbEuipIds, createType)
        TimeUtil.timeEnd("EquipFixCtrl.create")
        
    else
        ShowNotice.showShellInfo(m_i18n[5201])
    end
end

--出售装备后把背包的数据清空
function cleanArmData( )
    m_tbArmsValue = nil
    m_tbArmsValue = {}
end

function cleanArmFragData( )
    m_tbArmsFragValue = nil
    m_tbArmsFragValue = {}
end

--bState 是否需要排序  如果不传  为nil 则需要排序
fnGetArmCellsData = function ( bState )
    if(not table.isEmpty(m_tbArmsValue)) then
        logger:debug(g_bagRefresh.equipRefresh)
        if(g_bagRefresh.equipRefresh) then
            table.sort( m_tbArmsValue, sortEquip ) -- 2014-08-02

            for i, item in ipairs(m_tbArmsValue) do -- zhangqi, 2015-05-06
                item.idx = i
            end

            g_bagRefresh.equipRefresh  = false
            m_tbArmsValue.ownNum = table.count(m_tbAllBagInfo.arm) -- zhangqi, 2014-07-16, 添加不包含已装备的携带数
        end
        return m_tbArmsValue
    end


    if(m_tbAllBagInfo  == nil)then
        updateBagInfo()
    end

    local tbCells = {}

    m_allEquipData = {}
    for g_id, s_arm in pairs(m_tbAllBagInfo.arm) do
        table.insert(m_allEquipData, s_arm)
    end

    local heroEquips = ItemUtil.getEquipsOnFormation()
    for k,v in pairs(heroEquips) do
        table.insert(m_allEquipData, v)
    end

    for i, v in ipairs(m_allEquipData or {}) do
        -- local tbData  = getArmDataByValue(v)
        local tbData  = getArmDataByValueSort(v)
        table.insert(tbCells, tbData)
    end

    if (bState == nil ) then
        table.sort( tbCells, sortEquip ) -- 2014-08-02
    end

    for i, item in ipairs(tbCells) do -- zhangqi, 2015-05-06
        item.idx = i
    end


    tbCells.cellCount = table.count(tbCells)  --modify by yn  2015-9-7 创建cell时，如果cellCount小于一屏幕，不使用下一帧刷新cell的方案
    tbCells.ownNum = table.count(m_tbAllBagInfo.arm) -- zhangqi, 2014-07-16, 添加不包含已装备的携带数
    m_tbArmsValue = tbCells

    return tbCells
end



-- 只获取用于排序的字段
function getArmDataByValueSort( v,b_State )
    if(v.itemDesc == nil) then
        v.itemDesc = DB_Item_arm.getDataById(v.item_template_id)
        v.itemDesc.desc = v.itemDesc.info
    end

    --排序的时候用
    local tbData = {}
    tbData.type = v.itemDesc.type
    tbData.tid = v.item_template_id
    tbData.fromHid = v.equip_hid and v.equip_hid or 0
    tbData.starLvl  = v.itemDesc.quality
    tbData.level    = v.va_item_text.armReinforceLevel

    tbData.item_id = v.item_id    --用于获取单个cell的完整数据
    tbData.getCompleteData = getAllDataForCell  --用于获取单个cell的完整数据

    if(b_State) then
        logger:debug("getEquipNumerialByIIDFromRemoteBag")
        tbAttr, tbPLAttr, nScore, tbEquipDbInfo = ItemUtil.getEquipNumerialByIIDFromRemoteBag(v.item_id)
    else
        -- tbAttr, tbPLAttr, nScore, tbEquipDbInfo = ItemUtil.getEquipNumerialByIID(v.item_id)
        nScore = ItemUtil.getEquipNumerialByIID_score(v.item_id)
    end

    tbData.quality  = nScore
    return tbData
end

--b_State 是否是插入数据,后端数据还没有本地化处理，所以执行itemUtil里的getEquipNumerialByIIDFromRemoteBag方法
function getArmDataByValue( v, b_State)
    if(v.itemDesc == nil) then
        v.itemDesc = DB_Item_arm.getDataById(v.item_template_id)
        v.itemDesc.desc = v.itemDesc.info
    end   

    local tbAttr, tbPLAttr, nScore, tbEquipDbInfo = nil
        
    if(b_State) then
        logger:debug("getEquipNumerialByIIDFromRemoteBag")
        tbAttr, tbPLAttr, nScore, tbEquipDbInfo = ItemUtil.getEquipNumerialByIIDFromRemoteBag(v.item_id)
    else
        tbAttr, tbPLAttr, nScore, tbEquipDbInfo = ItemUtil.getEquipNumerialByIID(v.item_id)
    end

    local tbData    = {}
    tbData.gid      = v.gid
    tbData.id       = v.item_id
    tbData.level    = v.va_item_text.armReinforceLevel
    tbData.starLvl  = v.itemDesc.quality
    tbData.quality  = nScore
    tbData.sScore   = tostring(v.itemDesc.base_score) -- zhangqi, 2014-07-24, 星级改品级
    tbData.nQuality = v.itemDesc.quality
    tbData.name     = v.itemDesc.name
    tbData.sign     = ItemUtil.getSignTextByItem(v.itemDesc) -- 2015-04-30
    tbData.icon     = { id = v.item_template_id, bHero = false }
    tbData.icon.onTouch = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playInfoEffect()
            EquipInfoCtrl.createForEquip(v)
        end
    end

    tbData.item_info = v
    tbData.bSelect  = false
    tbData.fromHid  = 0

    --排序的时候用
    tbData.type = v.itemDesc.type
    tbData.tid = v.item_template_id

    -- 如果是经验装备，显示返还的附魔经验，2015-02-09, zhangqi
    -- 2015-04-16, zhangqi, 修改新的经验装备判断，子类型 type == 5
    if (tonumber(tbData.type) == 5) then
        --zhangjunwu 2015-4-20 
        tbData.sMagicExp = tostring(v.va_item_text.armEnchantExp or 0)
    else
        -- zhangqi, 2014-07-24, 属性值改为2列显示，1列显示3个
        tbData.tbAttr = {}
        logger:debug(tbAttr)
        if (v.itemDesc.canEnchant == 1) then -- 可以附魔
            -- zhangqi, 2015-01-26, 装备附魔等级
            if (EquipFixModel.isEuipCanFixByTid(v.item_template_id) == 1) then
                tbData.sMagicNum = v.va_item_text.armEnchantLevel or "0" -- 如果后端数据没有附魔字段则默认为 "0"
            end
        end

        if (tbData.sMagicNum and tonumber(tbData.sMagicNum) > 0) then
            ItemUtil.addEnchantAttr(v.itemDesc, tbData.sMagicNum, tbAttr, tbData.tbAttr)
        else
            ItemUtil.insertEquipAttr(tbAttr, tbData.tbAttr) -- 一般属性
        end
    end
    
    if (v.equip_hid) then
        tbData.owner    = HeroUtil.getHeroNameByHid(v.equip_hid) -- zhangqi, 2015-02-26
        logger:debug("tbData.owner" .. tbData.owner)
        tbData.fromHid  = v.equip_hid
    end

    return tbData
end

function eventXilian( ... ) -- 2015-04-30
    return function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()

            local tbData = m_tbArmsValue[sender.idx]

            fnShowFixLayer(tbData.item_info)
        end
    end
end

function eventStrength( ... ) -- 2015-04-30
    return function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()

            local tbData = m_tbArmsValue[sender.idx]

            if(tonumber(tbData.type) == 5) then
                ShowNotice.showShellInfo(m_i18n[1663])
            else
                 -- zhangqi, 2015-06-19，从装备背包列表进入强化
                local createType = g_equipStrengthFrom.CreateType.createTypeBtnBar

                require "script/module/equipment/EquipStrengModel"
                local layout = EquipStrengModel.create(tbData.item_info, nil, createType)
                LayerManager.addLayoutNoScale(layout, LayerManager.getModuleRootLayout())
            end
        end
    end
end

local function getArmViewConfig( ... )
    -- 构造列表需要的数据
    local tbView = {}
    tbView.szCell = g_fnCellSize(CELLTYPE.EQUIP)
    tbView.tbDataSource = fnGetArmCellsData()

    tbView.CellAtIndexCallback = function (tbData, idx, objView)
        local instCell = EquipCell:new(objView)
        instCell:init(CELL_USE_TYPE.BAG)

        instCell:addDownCallback(function ( idxData )   
            logger:debug("EquipCell downCallback: idxData = " .. idxData)  

            require "db/DB_Switch"
            local strenthLv = DB_Switch.getDataById(ksSwitchWeaponForge).level
            local xilianLv = DB_Switch.getDataById(ksSwitchEquipFixed).level

            -- 插入一条相对于按钮面板cell的人造数据 2015-04-24
            require "script/module/public/Cell/BtnBarCell"
            local size = g_fnCellSize(CELLTYPE.BTN_BAR)
            local barData = {isBtnBar = true, width = size.width, height = size.height}
            barData.events = {{event = eventStrength(), unlock = strenthLv, i18n = 1007}, 
                              {event = eventXilian(), unlock = xilianLv, i18n = 1603}, 
                              {}, {}
                             }
            objView:setBtnBarData(barData, idxData) -- 2015-05-13, 添加按钮面板的数据
        end)
        instCell:refresh(tbData)
        -- -- cell个数小于一屏，只直接刷新
        -- if(tbView.tbDataSource.cellCount<5) then 
        --     instCell:refresh(tbData)
        -- else 
        --     performWithDelayFrame(instCell.mCell,function ( ... )
        --          instCell:refresh(tbData)
        --     end,idx)
        -- end 
       
        return instCell
    end

    return tbView
end



local function fnComposeEquipCallBack( cbFlag, dictData, bRet )
    if (bRet) then
        logger:debug("composeEquipCallBack")
        --ShowNotice.showShellInfo(m_i18nString(1642, m_CompandName))
        m_CompandName = m_i18n[1601] -- 默认"装备"
        local refreshDown = false
        PreRequest.setBagDataChangedDelete( function ( ... )
             refreshDown = refreshArmAndArmFragList()
        end)

        require "script/module/shop/HeroDisplay"
        local data = {}
        data.tid = tonumber(m_Compandtid)
        data.num = 1 -- 数量为 1
        data.iType = 6 -- 5 代表类型为：装备碎片装备
        HeroDisplay.create(data, 6,function ( ... )
            return refreshDown
        end)
    end
end



--[[
starLvl = 星级 name = "小刀海贼-" .. idx,  sign = "item_type_shadow.png",  icon = btnIcon bSelect = true or false 
onCompond =  合成装备方法 func price = "  " 出售价格 单件的价格 curNum -- 当前拥有数量 maxNum -- 可以合成的数量
]]
--bNeedSort 不穿默认为true则不进行排序
fnGetArmFragCellsData = function ( bNeedSort )
    if(not table.isEmpty(m_tbArmsFragValue)) then
        logger:debug(g_bagRefresh.equipFragRefresh)
        if(g_bagRefresh.equipFragRefresh) then
            table.sort( m_tbArmsFragValue, equipFragSort ) -- 2014-08-02
            g_bagRefresh.equipFragRefresh  = false

        end
        return m_tbArmsFragValue
    end

    local tbCells = {}
    for g_id, s_armFrag in pairs(m_tbAllBagInfo.armFrag or {}) do
        local tempItem = {}
        tempItem = s_armFrag
        tempItem.gid = g_id
        tempItem.itemDesc = ItemUtil.getItemById(s_armFrag.item_template_id)
        tempItem.itemDesc.desc = tempItem.itemDesc.info

        local tbData  = getArmFragDataByValue(tempItem)
        table.insert(tbCells, tbData)
    end
    
    if (_bNeedSort == nil ) then
        table.sort( tbCells, equipFragSort ) -- 2014-08-02
    end

    m_tbArmsFragValue = tbCells
    return tbCells
end

local function getFragmentInfoByGID(_gid)
    for k,v in pairs(MainEquipmentCtrl.m_tbArmsFragValue) do
        if(v.gid == _gid) then
            return v
        end
    end
    return nil
end

-- 返回装备碎片数量
function getFragmentNumByTID(tid)
    local fragNum = 0
    local armfragments = DataCache.getLocalBagInfo().armFrag
    for k,v in pairs(armfragments) do
        if(tonumber(v.item_template_id) == tonumber(tid)) then
            fragNum = v.item_num
            return fragNum
        end
    end
    return fragNum
end


function getArmFragDataByValue(v)
    if(v.itemDesc == nil) then
        v.itemDesc = ItemUtil.getItemById(v.item_template_id)
        v.itemDesc.desc = v.itemDesc.info
    end

    local item = {}
    item.name = v.itemDesc.name or " "
    item.icon = {id = v.item_template_id, bSui = true,}
    item.icon.onTouch = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playInfoEffect()
            EquipInfoCtrl.createForEquipFrag(v)
        end
    end
    
    item.starLvl    = v.itemDesc.quality
    item.curNum     = tonumber(v.item_num)
    item.bSelect    = false
    item.maxNum     = tonumber(v.itemDesc.need_part_num)
    item.price      = "0"
    item.nQuality   = v.itemDesc.quality
    item.tid = v.item_template_id
    item.item_id = v.item_id
    item.gid = v.gid
    item.item_num = v.item_num

    -- zhangqi, 2014-07-24, 星级改为品级
    require "db/DB_Item_arm"
    local equip = DB_Item_arm.getDataById(v.itemDesc.aimItem)
    item.sScore = tostring(equip.base_score)
    item.compondName = equip.name -- 合成后的装备名称

    item.sign = ItemUtil.getSignTextByItem(equip)

    item.onCompond = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            logger:debug(" AudioHelper.playCommonEffect()")
            AudioHelper.playCompound()
            --先判断装备背包是否满了。
            if (ItemUtil.isEquipBagFull(true)) then
                return
            end
            logger:debug("ItemUtil.isEquipBagFull = false ")
            local tbInfo = sender.tbNeed
            if(tbInfo == nil ) then
                return 
            end
            logger:debug(tbInfo)
            logger:debug("onCompond: gid = %d, item_id = %d, item_num = %d, name = %s",
                            tbInfo.gid, tbInfo.item_id, tbInfo.item_num, m_CompandName)
            m_CompandName = tbInfo.name -- 记录要合成的装备名称
            m_Compandtid = equip.id
           
            logger:debug("要合成的装备名字是" .. m_CompandName)
            local args      = CCArray:create()
            args:addObject(CCString:create(tbInfo.gid))
            args:addObject(CCString:create(tbInfo.item_id))
            args:addObject(CCString:create(tbInfo.item_num))
            -- 点击后屏蔽按钮 避免再次点击 重复发生请求 sunyunpeng 2016-01-29
            local FnRemoveCompondMaskButton = sender.FnRemoveCompondMaskButton
            if (FnRemoveCompondMaskButton) then
                FnRemoveCompondMaskButton()
            end
            RequestCenter.bag_useItem(fnComposeEquipCallBack, args)
            sender.tbNeed = nil
        end
    end
    item.type = v.itemDesc.item_type

    -- wangming, 2014-12-07, 添加掉落引导查看
    item.onFindDrop = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            require "script/module/equipment/MainEquipDropCtrl"
            logger:debug("查看掉落的碎片的下表是" .. sender.idx)
            local equipInfo = getFragmentInfoByGID(sender.idx)
            local tArgs={selectEquip = equipInfo}
            -- 去副本前设置状态
            require "script/module/public/DropUtil"
            local returnInfo = {}
            local curModuleName = LayerManager.curModuleName()

            require "script/module/equipment/MainEquipmentCtrl"
            local callFn = function ( ... )
                MainEquipmentCtrl.resumBagCallFn(equipInfo.tid,2)
            end
            require "script/module/public/FragmentDrop"
            local fragmentDrop = FragmentDrop:new()
  
            local fragmentDropLayout = fragmentDrop:create(equipInfo.tid,callFn)
            LayerManager.addLayout(fragmentDropLayout)
        end
    end

    return item
end

local function getArmFragViewConfig( ... )
    -- 构造列表需要的数据
    local tbView = {}
    tbView.szCell = g_fnCellSize(CELLTYPE.FRAGMENT)
    tbView.getData = fnGetArmFragCellsData

    tbView.CellAtIndexCallback = function (tbData)
        local instCell = EquipFragCell:new()
        instCell:init(CELL_USE_TYPE.BAG)
        instCell:refresh(tbData)
        return instCell
    end

    return tbView
end

--装备出售的排序
local function sortSale(equip_1, equip_2)    
    local isPre = false
    if ( tonumber(equip_1.starLvl) < tonumber(equip_2.starLvl))then
        isPre = true
    elseif (tonumber(equip_1.starLvl) == tonumber(equip_2.starLvl))then
        local t_equip_score_1 = equip_1.quality
        local t_equip_score_2 = equip_2.quality

        if (t_equip_score_1 < t_equip_score_2)then
            isPre = true
        elseif (t_equip_score_1 == t_equip_score_2) then
           if (tonumber(equip_1.level) > tonumber(equip_2.level)) then
                isPre = true
            elseif(tonumber(equip_1.level) == tonumber(equip_2.level)) then
                isPre = fnCompareWithType(equip_1,equip_2)
            else
                isPre = false
            end
        else
            isPre = false
        end
    else
        isPre = false
    end

    return isPre
end

-- 装备碎片排序
local function equipFragSaleSort( equip_1, equip_2 )
    local isPre = false
    
    if ((tonumber(equip_1.curNum) == tonumber(equip_1.maxNum)) and (tonumber(equip_2.curNum) < tonumber(equip_2.maxNum))) then
        isPre = false
    elseif((tonumber(equip_1.curNum) < tonumber(equip_1.maxNum)) and (tonumber(equip_2.curNum) == tonumber(equip_2.maxNum))) then
        isPre = true
    else
        local frag1DBInfo   = ItemUtil.getItemById(equip_1.tid)
        local item1DBInfo   = ItemUtil.getItemById(frag1DBInfo.aimItem)

        local frag2DBInfo   = ItemUtil.getItemById(equip_2.tid)
        local item2DBInfo   = ItemUtil.getItemById(frag2DBInfo.aimItem)

        if( tonumber(item1DBInfo.quality) < tonumber(item2DBInfo.quality))then
            isPre = true
            elseif(tonumber(item1DBInfo.quality) == tonumber(item2DBInfo.quality))then
                if(tonumber(item1DBInfo.type) > tonumber(item2DBInfo.type))then
                    isPre = true
                elseif(tonumber(item1DBInfo.type) == tonumber(item2DBInfo.type))then
                    local t_equip_score_1 = item1DBInfo.base_score
                    local t_equip_score_2 = item2DBInfo.base_score

                    if(t_equip_score_1 < t_equip_score_2)then
                        isPre = true
                    else
                        isPre = false
                    end
                else
                isPre = false
            end
        else
            isPre = false
        end 
    end
    return isPre
end
------------------------------------- 出售列表数据准备 -------------------------------------
--[[
tbItem = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = {id = tid, onTouch = func}, 
    sOwnNum = 10, sDesc = "宝物等等....", -- Item
    sPrice = 1000, bSelect = true, -- sale
} --]]
local function getArmsSaleData()    
    logger:debug("getArmsSaleData")

    updateBagInfo() -- zhangqi, 2014-08-06, changeModule到出售列表后才会调到这个方法，装备模块的背包信息已经被destroy过了，需要重新获取

    local tbCells = {}
    for i, v in ipairs(m_tbBagInfo.arm or {}) do
        logger:debug("bagInfo:")
        logger:debug(v)
        local starLvl  = v.itemDesc.quality
        if (v.itemDesc.sellable == 1 and starLvl < m_saleEquipStar) then -- 2015-04-20, zhangqi, 增加可售字段的判断条件
            local tbAttr, tbPLAttr, nScore, tbEquipDbInfo = ItemUtil.getEquipNumerialByIID(v.item_id)
            local tbData    = {}
            tbData.id       = v.item_id
            tbData.gid      = v.gid
            tbData.level    = v.va_item_text.armReinforceLevel
            tbData.starLvl  = v.itemDesc.quality
            tbData.quality  = nScore
            tbData.sScore   = tostring(v.itemDesc.base_score) -- zhangqi, 2014-07-24, 星级改品级
            tbData.nQuality = v.itemDesc.quality
            tbData.name     = v.itemDesc.name
            tbData.sign     = ItemUtil.getSignTextByItem(v.itemDesc) -- 2015-04-30
            tbData.icon     = { id = v.item_template_id, bHero = false }
            tbData.icon.onTouch = function ( sender, eventType )
                if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    EquipInfoCtrl.createForSellEquip(v)
                end
            end

            tbData.item_id  = v.item_id
            tbData.nNum     = 1
            logger:debug(tbData.name )
            logger:debug("price ".. v.itemDesc.sellNum)
            tbData.price    = v.itemDesc.sellNum + v.va_item_text.armReinforceCost

            -- zhangqi, 2014-09-03, 属性值改为2列显示，1列显示3个
            tbData.tbAttr = {}
            if (v.itemDesc.canEnchant == 1) then -- 可以附魔
                -- zhangqi, 2015-01-26, 装备附魔等级
                if (EquipFixModel.isEuipCanFixByTid(v.item_template_id) == 1) then
                    tbData.sMagicNum = v.va_item_text.armEnchantLevel or "0" -- 如果后端数据没有附魔字段则默认为 "0"
                end
            end

            if (tbData.sMagicNum and tonumber(tbData.sMagicNum) > 0) then
                ItemUtil.addEnchantAttr(v.itemDesc, tbData.sMagicNum, tbAttr, tbData.tbAttr)
            else
                ItemUtil.insertEquipAttr(tbAttr, tbData.tbAttr) -- 一般属性
            end

            tbData.idx = #tbCells - 1 -- 保存当前物品在列表中的索引，CCTableViewCell的索引从0开始，需要 - 1

            tbData.bSelect  = false

            --ZHANGJUNWU 排序所用 2014 -11 -22
            tbData.tid = v.item_template_id
            tbData.type = v.itemDesc.type

             --zhangjunwu 1.01-11-1 临时背包里的装备碎片 不出现在出售列表
            if (tonumber(v.gid) >= 2000001 and tonumber(v.gid) < 3000000 ) then
                table.insert(tbCells, tbData)
            end
            
        end
    end

    -- zhangqi, 2015-01-23, 将出售数量和价格的计算从背包所有item循环中拿出来，只计算整理后的item（不含临时背包）
    for i, data in ipairs(tbCells) do
        -- logger:debug(m_equipSelectStar)
        if m_equipSelectStar then
            for i,v in ipairs(m_equipSelectStar) do
                if(tonumber(data.starLvl) == tonumber(v)) then
                    data.bSelect  = true
                    m_bag.saleList.mSellList[data.gid] = data.bSelect == true and data or nil
                    m_bag.saleList:changeItem(true, data.price, data.idx)
                end
            end
        end
    end

    table.sort( tbCells, sortSale )
    return tbCells
end
--[[
local tbData = {name = "小刀海贼-" .. idx, sign = "item_type_shadow.png", icon = icon = {id = htid, bHero = false, onTouch = func}, 
    sStrongNum = 10, sStar = 88, sRank = 15, sAttr = "string of all attribute", sRefinNum = 0[精炼等级，icon右下角钻石], -- Treasure
    sPrice = 9999, bSelect = false, -- sale
} -]]
local function getArmFragsSaleData()
    local tbCells   = {}

    for i, v in ipairs(m_tbBagInfo.armFrag or {}) do
        local item  = {}

        item.tid  = v.item_template_id
        item.type = v.itemDesc.type 

        item.gid    = v.gid
        item.name   = v.itemDesc.name or " "
        item.icon   = {id = v.item_template_id}
        item.icon.onTouch = function ( sender, eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playInfoEffect()
                EquipInfoCtrl.createSellEquipFrag(v)
            end
        end

        item.starLvl    = v.itemDesc.quality
        item.curNum     = tonumber(v.item_num)
        item.bSelect    = false
        item.maxNum = tonumber(v.itemDesc.need_part_num)
        item.nQuality   = v.itemDesc.quality
        logger:debug("sPrice:" .. v.itemDesc.sell_num)
        item.price = v.itemDesc.sell_num
        item.nNum       = v.item_num

        -- zhangqi, 2014-07-24, 星级改为品级
        require "db/DB_Item_arm"
        local equip = DB_Item_arm.getDataById(v.itemDesc.aimItem)
        item.sScore = tostring(equip.base_score)

        item.item_id = v.item_id
        item.sign   = ItemUtil.getSignTextByItem(equip)


        --zhangjunwu 1.01-11-1 临时背包里的装备碎片 不出现在出售列表
        if (tonumber(v.gid) >= 6000001 and tonumber(v.gid) < 7000000)then
            table.insert(tbCells, item) -- 装备碎片
        end

        item.idx    = #tbCells - 1 -- 保存当前物品在列表中的索引，CCTableViewCell的索引从0开始，需要 - 1
    end

    table.sort( tbCells, equipFragSaleSort )

    return tbCells
end

local function getArmsSaleView( objSaleList )
    -- 构造列表需要的数据
    local tbView = {}

    tbView.szCell = g_fnCellSize(CELLTYPE.EQUIP)
    tbView.tbDataSource = getArmsSaleData()

    tbView.CellAtIndexCallback = function (tbData)
        local instCell = EquipCell:new()
        logger:debug("tbData")
        -- logger:debug(tbData)
        instCell:init(CELL_USE_TYPE.SALE)
        instCell:refresh(tbData)
        return instCell
    end

    tbView.CellTouchedCallback = function ( view, cell, objCell)
        AudioHelper.playCommonEffect()
        local index = cell:getIdx()
        local item  = objSaleList.mList.Data[index + 1] -- 需要从HZListView的Data成员取对应的cell数据

        local bStat     = not objCell.cbxSelect:getSelectedState()
        objCell.cbxSelect:setSelectedState(bStat)
        item.bSelect    = bStat

        local itemPrice = tonumber(item.price) * 1-- 选中某种物品实际要加上所有数量*单价的总价
        m_bag.saleList:changeItem(bStat, itemPrice, index) 

        m_bag.saleList.mSellList[item.gid] = bStat == true and item or nil
        objSaleList.mList.Data[index + 1] = item
    end

    return tbView
end

local function getArmFragsSaleView( objSaleList )
    logger:debug("getArmFragsSaleView")
    -- 构造列表需要的数据
    local tbView    = {}

    tbView.szCell   = g_fnCellSize(CELLTYPE.FRAGMENT)
    tbView.tbDataSource     = getArmFragsSaleData()

    tbView.CellAtIndexCallback  = function (tbData)
        local instCell  = EquipFragCell:new()
        instCell:init(CELL_USE_TYPE.SALE)
        instCell:refresh(tbData)
        return instCell 
    end

    tbView.CellTouchedCallback = function ( view, cell, objCell)
        local index     = cell:getIdx()
        local item  = objSaleList.mList.Data[index + 1] -- 需要从HZListView的Data成员取对应的cell数据

        local bStat     = not objCell.cbxSelect:getSelectedState()
        objCell.cbxSelect:setSelectedState(bStat)
        item.bSelect    = bStat

        local itemPrice = tonumber(item.price) * item.curNum -- 选中某种物品实际要加上所有数量*单价的总价
        m_bag.saleList:changeItem(bStat, itemPrice, index)

        m_bag.saleList.mSellList[item.gid] = bStat == true and item or nil
        objSaleList.mList.Data[index + 1] = item
    end

    return tbView
end

-- 必须实现getSaleListConfig这个方法，SaleList 类里会调用
local function getSaleListData( objSaleList )
    logger:debug("getSaleListData")
    updateBagInfo() -- 同步模块背包信息和Cache的背包信息
    local tbData

    if (objSaleList.bagIndex == 1) then
        tbData = getArmsSaleData()
    elseif(objSaleList.bagIndex == 2) then
        tbData = getArmFragsSaleData()
    else
        -- TODO: 时装出售
    end

    return tbData
end

-- 必须实现getSaleListConfig这个方法，SaleList 类里会调用
local function getSaleListConfig( objSaleList )
    logger:debug("getSaleListConfig")
    local tbCfg
    if (objSaleList.bagIndex == 1) then
        tbCfg = getArmsSaleView(objSaleList)
    elseif(objSaleList.bagIndex  == 2) then
        tbCfg = getArmFragsSaleView(objSaleList)
    else
        -- TODO: 时装出售
    end
    return tbCfg 
end

--选择星级后进行筛选
local function setEquipSelectStateByStarLv( tstarLvl, saleList )
    if (saleList) then
        m_equipSelectStar       = tstarLvl
        saleList:updateIncome()
        saleList.mSellList   = {}
        local tbEquipData = getArmsSaleData()

        saleList.mList:changeDataSource(tbEquipData)
    end
end

-- 选择星级后进行筛选
function setEquipSelectStateBySellStar ( tbStarSelState, saleList )
    local tstarLvl  = {}
    local index     = 1
    if (tbStarSelState[1]) then
        tstarLvl[index]     = 2  -- zhangqi, 2014-07-24, 改为按品级出售，白色品级表示选择包括原1星和2星的装备
        index               = index + 1
    end

    if (tbStarSelState[2]) then
        tstarLvl[index]     = 3
    end
    setEquipSelectStateByStarLv(tstarLvl, saleList)
end

local function onBtnStarSell(saleList)
    require "script/module/partner/PartnerSellStar"
    local layer = PartnerSellStar.create(1, saleList)
    if (layer) then
        LayerManager.addLayout(layer)
    end    
end


-- 获取单个cell的全部数据,和刷新对应的缓存数据。不完成的数据isNotComplete＝true
function getAllDataForCell( tbData )
    local item_id  = tbData.item_id
    local cellData = nil
    for k,v in pairs(m_allEquipData) do 
        if tonumber(v.item_id) == tonumber(item_id) then 
            cellData = v
            break
        end 
    end 

    local idx = tbData.idx
    tbData = getArmDataByValue(cellData)
    tbData.idx = idx
    m_tbArmsValue[idx] = tbData   
    
    return tbData
end


--设置去副本之前的状态 
function setListViewStatus( listViewIndex,fraginfoTid,callfn )
    resumInfo = {}
    -- resumInfo.newOffset= m_bag:getListViewData(listViewIndex)
    resumInfo.callfun = callfn
    resumInfo.tableIndex = listViewIndex
    resumInfo.fraginfoTid = fraginfoTid
    logger:debug({resumInfo=resumInfo})
end


-- 从副本过来刷新列表
function resumBagCallFn( fraginfoTid ,tableIndex)
    logger:debug({returnInfo=returnInfo})
    local indexid = fraginfoTid
    listViewIndex = tableIndex 
    local ListValue 
    local cellIndex = 0
    if (listViewIndex ~= 0 and m_bag) then     -- 是从背包进入副本
        updateBagInfo()
        if (listViewIndex ==  1) then
            ListValue = fnGetArmCellsData()
            for i,v in ipairs(ListValue) do
                if (tonumber(v.tid) ~= tonumber(indexid)) then
                    cellIndex = cellIndex + 1
                else
                    break
                end
            end
            --更新碎片列表数据
            local fragListValue = fnGetArmFragCellsData()
            m_bag:resettbDataSource(fragListValue,2)

        elseif (listViewIndex ==  2) then
            ListValue = fnGetArmFragCellsData()

            for i,v in ipairs(ListValue) do
                if (tonumber(v.tid) ~= tonumber(indexid)) then
                    cellIndex = cellIndex + 1
                else
                    break
                end
            end
        end
        m_bag:updateCurrentListWithData(ListValue, nil,1,cellIndex)
        m_bag:udpateTabRedCircle(2,true, EquipFragmentHelper.getCanFuseNum()) --更新碎片红点
    elseif (listViewIndex ~= 0 and not m_bag) then
        require "script/module/equipment/MainEquipmentCtrl"
        local layEquipment = create(listViewIndex)
        if layEquipment then
            LayerManager.changeModule(layEquipment, moduleName(), {1, 3}, true)
            PlayerPanel.addForPartnerStrength()
        end
    end

end


-- resumInfo 是否 从副本或者其他界面回来
function create(nTabIndex)
    changeModuleInfo = {}
    changeModuleInfo.nTabIndex = nTabIndex
    init()
    updateBagInfo()
    tbBagInfo = {}
    tbBagInfo = {sType = BAGTYPE.EQUIP, expands = {1,2}, sales = {1,2}, nums = {1,2}} -- zhangqi, 2015-09-29, 加入扩充和出售的配置项
    tbBagInfo.onExpand = onExpand
    tbBagInfo.tbTab = {}

    performWithDelayFrame(nil,function() --这里找不到控件绑定，10帧后必执行，bag.lua里做了11帧的屏蔽层
                tbBagInfo.tbTab[1] = {nMaxNum = tonumber(m_tbAllBagInfo.gridMaxNum.arm), tbView = getArmViewConfig()} -- 装备列表数据
            end,nTabIndex~=2 and 0 or 10)
    
    performWithDelayFrame(nil,function() --这里找不到控件绑定，10帧后必执行，bag.lua里做了11帧的屏蔽层
                tbBagInfo.tbTab[2] = {nMaxNum = tonumber(m_tbAllBagInfo.gridMaxNum.armFrag), tbView = getArmFragViewConfig(), num = EquipFragmentHelper.getCanFuseNum()} -- 装备碎片列表数据
            end,nTabIndex==2 and 0 or 10)

    -- 出售列表
    tbBagInfo.tbSale = {fnGetSaleListConfig = getSaleListConfig, fnGetSaleListData = getSaleListData }
    tbBagInfo.tbSale.onStarSale = {onBtnStarSell}

    m_bag = Bag.create(tbBagInfo, nTabIndex)


    UIHelper.registExitAndEnterCall(m_bag.mainList,
            function()
                UIHelper.removeArmatureFileCache()
            end,
            function()
            end
        )
    logger:debug({mainList = m_bag.mainList})
    return m_bag.mainList
end
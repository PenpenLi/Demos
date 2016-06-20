-- FileName: MainConchCtrl.lua
-- Author: zhangqi
-- Date: 2015-02-25
-- Purpose: 空岛贝背包模块主控程序
--[[TODO List]]

module("MainConchCtrl", package.seeall)

require "script/module/public/Bag"
require "script/module/bag/BagUtil"
require "script/module/public/Cell/ConchCell"
require "script/module/conch/ConchStrength/SkyPleaModel"


-- UI控件引用变量 --

-- 模块局部变量 --
local mItemUtil = ItemUtil
local mModel = SkyPleaModel
local m_i18n = gi18n
local m_tbBagInfo -- 按类型（装备，道具，宝物等）分类处理后的背包信息
local m_bag -- Bag 类的对象引用
local m_tbConch = {}  --缓存背包列表需要的所有数据，除非原始背包信息有变，否则不会更新，优化背包打开速度

local function init(...)
	m_tbBagInfo = nil
	m_bag = nil
	m_tbConch = {}
end

function destroy(...)
	package.loaded["MainConchCtrl"] = nil
end

function moduleName()
    return "MainConchCtrl"
end

-- 更新本模块背包数据
local function updateBagInfo ( ... )
	m_tbBagInfo = DataCache.getBagInfo() or {}
end

-- zhangqi, 2015-02-25, 空岛贝背包排序
--[[
   排序规则
a)  按照是否已装备排序，已装备的空岛贝排在前面，未装备的空岛贝排在后面
b)  按照空岛贝的星级排列，星级越高，排列越靠前
c)  按照空岛贝的等级排列，等级高的排列在前面
d)  按照空岛贝的sort字段排序（用于同类型空岛贝的排序字段），id小的排列在前面，id大的排列在后面
e)  按照空岛贝的id字段排序，大的在前，小的在后
]]
local function conchSort( item_1, item_2 )
    local isPre = false
    if (tonumber(item_1.fromHid) > 0 and tonumber(item_2.fromHid) == 0) then
        isPre = true
    elseif (tonumber(item_1.fromHid) == 0 and tonumber(item_2.fromHid) > 0 ) then
        isPre = false
    else
        if (item_1.nQuality > item_2.nQuality) then
            isPre = true
        elseif (item_1.nQuality == item_2.nQuality) then
            if (tonumber(item_1.level) > tonumber(item_2.level)) then
                isPre = true
            elseif (tonumber(item_1.level) == tonumber(item_2.level)) then
                if (tonumber(item_1.sortNum) < tonumber(item_2.sortNum)) then
                    isPre = true
                elseif (tonumber(item_1.sortNum) == tonumber(item_2.sortNum)) then
                    if (item_1.itemDesc.id > item_2.itemDesc.id) then
                        isPre = true
                    end
                end
            end
        end
    end

    return isPre
end

-- zhangqi, 2015-02-25, 得到了新空岛贝后打开背包时需要先按是否新空岛贝来排序
local function newConchSort( item_1, item_2 )
    return conchSort(item_1, item_2)
    -- return tonumber(item_1.itemDesc.quality) > tonumber(item_2.itemDesc.quality) 
end

-- zhangqi, 2015-02-26
local function insertAttr( tbSrcAttr, tbDesAttr )
    local strAttrDesc, i = "", 1
    for k, attr in pairs(tbSrcAttr) do
        strAttrDesc = strAttrDesc .. attr.name .. " +" .. attr.num .. "\n"
        if (i%3 == 0 ) then
            table.insert(tbDesAttr, strAttrDesc)
            strAttrDesc = ""
        end
        i = i + 1
    end
    table.insert(tbDesAttr, strAttrDesc)
    logger:debug(tbDesAttr)
end

--b_State 是否是插入数据,后端数据还没有本地化处理，所以执行itemUtil里的getEquipNumerialByIIDFromRemoteBag方法
function getDataByValue( conch, b_State) 
    local tbData    = {}

    tbData.itemDesc = conch.itemDesc
    if(tbData.itemDesc == nil) then
        tbData.itemDesc = DB_Item_conch.getDataById(conch.item_template_id)
        tbData.itemDesc.desc = tbData.itemDesc.info
    end

    tbData.gid      = conch.gid
    tbData.id       = conch.item_id
    tbData.level    = conch.va_item_text.level
    tbData.sScore   = tostring(tbData.itemDesc.scorce) -- zhangqi, 2014-07-24, 星级改品级
    tbData.nQuality = tbData.itemDesc.quality
    tbData.name     = tbData.itemDesc.name
    tbData.sign = ItemUtil.getSignTextByItem(tbData.itemDesc)
    tbData.icon     = { id = conch.item_template_id, bHero = false }
    tbData.icon.onTouch = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            logger:debug("%s icon.onTouch", tbData.name)
            require "script/module/conch/ConchStrength/SkyPieaInfoCtrl"
            SkyPieaInfoCtrl.createForConch(conch)
        end
    end

    tbData.bSelect  = false
    tbData.fromHid  = 0

    --排序的时候用，
    tbData.sortNum = tbData.itemDesc.sort
    tbData.tid = conch.item_template_id
    tbData.onConchStrong = function( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            logger:debug("onConchStrong")
            logger:debug(conch)


            -- if(mItemUtil.fnIsExpConchType(tbData.itemDesc.type) ) then-- 经验空岛贝
            --     ShowNotice.showShellInfo(m_i18n[5509])
            -- else
                require "script/module/conch/ConchStrength/SkyPieaStrenthMain"
                SkyPieaStrenthMain.create(conch, "bag")
            -- end
        end
    end
           
    if (mItemUtil.fnIsExpConchType(tbData.itemDesc.type) ) then -- 如果是经验空岛贝
        local pNumber = mModel.getExpOfConchSuplly(conch)
        tbData.sMagicExp = tostring(pNumber)
        -- tbData.sMagicExp = tostring(tbData.itemDesc.baseExp) 提经验的数值
    else
        -- zhangqi, 2014-07-24, 属性值改为2列显示，1列显示3个
        local tbAttr = mItemUtil.getConchNumerialByItemId(conch.item_id, b_State, conch)
        tbData.tbAttr = {}
        logger:debug(tbAttr)
        insertAttr(tbAttr, tbData.tbAttr) -- 一般属性
    end

    tbData.fromHid = 0
    if (conch.equip_hid) then
        tbData.owner = HeroUtil.getHeroNameByHid(conch.equip_hid)
        logger:debug("tbData.owner" .. tbData.owner)
        tbData.fromHid = conch.equip_hid
        fromHid = conch.equip_hid
    end

    return tbData
end

--bState 是否需要排序  如果不传  为nil 则需要排序
function getConchCellsData( bState )
    updateBagInfo()

    if(not table.isEmpty(m_tbConch)) then
        logger:debug(g_bagRefresh.conchRefresh)
        if(g_bagRefresh.conchRefresh) then
            table.sort( m_tbConch, conchSort ) -- 2014-08-02
            g_bagRefresh.conchRefresh  = false
            m_tbConch.ownNum = table.count(m_tbBagInfo.conch)
        end
        return m_tbConch
    end

    local tbCells = {}
    local allConch = {}

    -- 背包中未装备的空岛贝信息
    table.hcopy(m_tbBagInfo.conch, allConch)

    -- 取伙伴已装备的空岛贝信息
    local heroConchs = ItemUtil.getConchesOnFormation()
    for k,v in pairs(heroConchs) do
        table.insert(allConch, v)
    end

    for i, v in ipairs(allConch) do
        local tbData  = getDataByValue(v)
        table.insert(tbCells, tbData)
    end
    
    if (bState == nil ) then
        table.sort( tbCells, conchSort )
    end

    tbCells.ownNum = table.count(m_tbBagInfo.conch) -- zhangqi, 2014-07-16, 添加不包含已装备的携带数
    logger:debug("getConchCellsData: new ownNum = %d", tbCells.ownNum)

    m_tbConch = tbCells -- 缓存空岛贝背包列表的数据，优化再次打开背包时的速度
    logger:debug(m_tbConch)

    return tbCells
end

local function getConchViewConfig( ... )
	-- 构造列表需要的数据
	local tbView = {}
	tbView.szCell = g_fnCellSize(CELLTYPE.CONCH)
	tbView.tbDataSource = getConchCellsData()

	tbView.CellAtIndexCallback = function (tbData)
		local instCell = ConchCell:new()
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:refresh(tbData)
		return instCell
	end

	return tbView
end

-- 2015-09-30 modified by LvNanchun 加一个参数传入进入该界面时的大模块名以便返回。
function create( preModuleName )
	init()

	updateBagInfo()

	local tbBagInfo = {sType = BAGTYPE.CONCH, nums = {1}}

	-- tbBagInfo.onExpand = onExpand
    -- tbBagInfo.onWear = function ( ... )
    --     logger:debug("btnConch onClick")
    --     MainScene.onFormation()
    --     require "script/module/formation/MainFormation"
    --     MainFormation.changeConch(true)
    -- end

    tbBagInfo.eventWear = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()

            MainScene.onFormation(sender, eventType)

            require "script/module/formation/MainFormation"
            MainFormation.changeConch(true)
        end
    end

    tbBagInfo.eventBack = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playBackEffect()

            -- 2015-09-30 根据参数判断返回的界面
            logger:debug({conchPreModuleName = preModuleName})
            if (preModuleName) then
                require "script/module/public/DropUtil"
                local curModuleName = LayerManager.curModuleName()
                DropUtil.getReturn(curModuleName)
            else
                require "script/module/SkyPiea/MainSkyPieaCtrl"
                MainSkyPieaCtrl.create()
            end
        end
    end

    local origBag = DataCache.getRemoteBagInfo()
	tbBagInfo.tbTab = {}
	tbBagInfo.tbTab[1] = {nMaxNum = tonumber(origBag.gridMaxNum.conch), tbView = getConchViewConfig()} -- 空岛贝列表数据

	-- 出售列表
	-- tbBagInfo.tbSale = {fnGetSaleListConfig = getSaleListConfig, fnGetSaleListData = getSaleListData }
	m_bag = Bag.create(tbBagInfo, nTabIndex)

	local layBag = m_bag.mainList
	UIHelper.registExitAndEnterCall(layBag, function ( ... )
		m_bag = nil
		logger:debug("registExitAndEnterCall(layBag), m_bag = %s", type(m_bag))
	end)
	return layBag
end

--强化之后重新重置列表数据
function resetDataAfterReinforce( ... )
    m_tbConch = nil
    m_tbConch = {}
    getConchCellsData()
end

--[[desc:替换已经存在的装备
    args: gid:背包格子id；data:后端给的空岛贝信息
    return: void
—]]
function replaceConchDataByGid(gid, data)
    logger:debug("replaceConchDataByGid")
    --判断之前是否进入过背包
    if(not table.isEmpty(m_tbConch)) then
        for i, v in ipairs(m_tbConch) do
            if(tonumber(v.id) == tonumber(data.item_id)) then
                data.gid = gid
                local tbConch = getDataByValue(data)
                m_tbConch[i] = tbConch
                g_bagRefresh.conchRefresh = true
                return
            end
        end
    end
end

--[[desc:插入新装备数据
    arg1: gid:背包格子id；data:后端给的空岛贝信息
    return: void 
—]]
function insertConchDataByGid(gid, data)
    --判断之前是否进入过背包
    if(not table.isEmpty(m_tbConch)) then
        data.gid = gid
        local tbNewData = getDataByValue(data, true)
        table.insert(m_tbConch, tbNewData)
        g_bagRefresh.conchRefresh = true
    end
end

--[[desc:删除旧数据 z装备
    arg1: gid:背包格子id；
    return: void  
—]]
function removeConchDataByGid(gid)
     --判断之前是否进入过背包
    if(not table.isEmpty(m_tbConch)) then
        local index = 0
        for i=1,#m_tbConch do
            if(tonumber(m_tbConch[i].gid) == tonumber(gid)) then
                index = i
                break
            end
        end

        table.remove(m_tbConch, index)
        g_bagRefresh.conchRefresh = true
    end
end

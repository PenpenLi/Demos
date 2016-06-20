-- FileName: MainPartner.lua 
-- Author: fubei
-- Date: 14-3-28 
-- Purpose: function description of module 

module("MainPartner", package.seeall)
require "script/module/public/ShowNotice"
require "script/module/public/Bag"
require "script/module/bag/BagUtil"
require "script/module/public/Cell/HeroCell"
require "script/module/partner/PartnerYingZi"
require "script/module/partner/HeroSortUtil"
require "script/module/partner/PartnerTransCtrl"
require "script/module/partner/PartnerModle"
-- vars
local m_i18n = gi18n
local m_i18nString = gi18nString
m_bNeedSortFrag  = false   --进入背包的时候，是否需要对数据列表进行排序 

m_tbHeroesValue = {}          --listview中的所有伙伴数据
m_tbHerosFragValue = {}       --listview影子碎片的所有数据
local m_nSelectHeroIndex            --所选英雄ID

local MainPartner 
local imgRecruit                    --可招募的数量背景

local btnExpand                     --扩展按钮
local btnSale                       --出售按钮
local nCountOfYingzi                --影子数量
local tagFrameLight = 10            --头像点亮框 tag

local m_fnUpdatePartnerData            --更新伙伴数据函数

local nTypeTag = 1                  --当前需要定位到的标签栏 ，默认1为伙伴标签，2为影子标签
local m_bag -- Bag 类的对象引用
local resumInfo  = {}   -- 去副本之前保存的信息 ，列表偏移量和重新回来的方法

-- 初始化和析构
-- 获取数据
function init( ... )
    --m_tbHeroesValue = m_fnUpdatePartnerData()
    m_bag = nil
end

function destroy( ... )
    m_bag = nil
end

function moduleName()
    return "MainPartner"
end

--更新可招募的数量
local function updateRecruit( ... )
    local nRecruit = HeroSortUtil.getFuseSoulNum()
    local showRecruit = false
    if(nRecruit > 0) then
        showRecruit = true
    end
    m_bag:udpateRedCircle(showRecruit,nRecruit)

end

function onBtnExpand( index )
    if (BagUtil.getNextOpenPropGridPrice() > UserModel.getGoldNumber()) then
        LayerManager.addLayout(UIHelper.createNoGoldAlertDlg()) -- zhangqi, 2015-10-26, 统一充值提示面板
        return
    end

    --更新伙伴的人数/可携带数
    local function updatePartnerNum( ... )
        if (m_bag) then
            local extIndex = 1
            if (m_bag.mBtnIndex == 1) then
                extIndex = nil
            end
            local nLimitHeroNum = UserModel.getHeroLimit()
            m_bag:updateMaxNumber(nLimitHeroNum, extIndex) -- 刷新携带数
        end
    end
    logger:debug("updatePartnerNum")
    require "script/module/partner/Prompt"
    Prompt.create(updatePartnerNum)
end

-- 选择伙伴
function onBtnSelectPartner( sender, eventType )
    
    logger:debug("wm----onBtnSelectPartner")
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playInfoEffect()
        require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = m_tbHeroesValue[sender.idx] --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])awake_attr
        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.hid or 0,strengthenLevel = pHeroValue.level or 0,transLevel = pHeroValue.evolve_level or 0,awake = pHeroValue.awake_attr}
        local tArgs = {}
        tArgs.heroInfo = heroInfo
        if (not heroInfo.hid) then
            return
        end
        local layer = PartnerInfoCtrl.create(tArgs,1)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer)

    elseif (eventType == TOUCH_EVENT_BEGAN) then
        local frameLight = CCSprite:create("images/hero/quality/highlighted.png")
        frameLight:setAnchorPoint(ccp(0.5, 0.5))
        sender:addNode(frameLight,10,tagFrameLight)
    elseif (eventType == TOUCH_EVENT_CANCELED) then
        sender:removeNodeByTag(tagFrameLight)
    end

end 

-- 觉醒
local function onBtnAwake( sender, eventType  )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        if(not SwitchModel.getSwitchOpenState(ksSwitchAwake or 40,true)) then
            return
        end
        local pHeroValue = m_tbHeroesValue[sender.idx] --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx]) --m_tbHeroesValue[sender.idx]
        if(pHeroValue and pHeroValue.db_hero ) then
            require "script/module/partnerAwakening/MainAwakeCtrl"
            MainAwakeCtrl.create(0,pHeroValue.hid)
        end
    end
end

-- 突破
local function onBtnBreak( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        if(not SwitchModel.getSwitchOpenState(ksSwitchHeroBreak,true)) then
            return
        end
        local pHeroValue = m_tbHeroesValue[sender.idx] --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx]) --m_tbHeroesValue[sender.idx]
        if(pHeroValue and pHeroValue.db_hero and pHeroValue.db_hero.break_id) then
            require "script/module/partner/PartnerBreakCtrl"
            PartnerBreakCtrl.create(pHeroValue.hid,1)
            return
        end
        ShowNotice.showShellInfo(m_i18n[1120])
    end
end

-- 进阶
local function onBtnJinJie( sender, eventType)  
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        local pHeroValue = m_tbHeroesValue[sender.idx] --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        if(pHeroValue and pHeroValue.db_hero and pHeroValue.db_hero.advanced_id) then
            PartnerTransCtrl.create(pHeroValue.hid,1)     --所选择武将信息
            return
        end
        ShowNotice.showShellInfo(m_i18n[1107])
    end
end

local function onBtnFashion( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        ShowNotice.showShellInfo(m_i18n[1366]) -- "功能暂未开启，敬请期待！",
    elseif (eventType == TOUCH_EVENT_BEGAN) then
        sender:setTitleColor(ccc3(140,238,252))
    elseif (eventType == TOUCH_EVENT_CANCELED) then
        sender:setTitleColor(ccc3(255,255,255))
    end
end

-- 强化
local function onBtnIntensify( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        logger:debug("sender.idx"..sender.idx)
        require "script/module/partner/PartnerStrenCtrl"
        require "script/module/main/PlayerPanel"
        local itemData = m_tbHeroesValue[sender.idx] --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        logger:debug({onBtnIntensify = itemData})
        AudioHelper.playCommonEffect()
        logger:debug({onBtnIntensify = itemData.hid})
        PartnerStrenCtrl.create(itemData.hid,1)
    end
end

--伙伴数据做了修改之后，重新加载界面所有数据
function refreshYingZiListView()
    logger:debug("refreshYingZiListView")
    --logger:debug(m_tbHerosFragValue)
    m_tbHeroesValue = nil
    m_tbHeroesValue = {}
    m_tbHeroesValue = PartnerModle.getAllPartnerSampleData()

    m_tbHerosFragValue = nil
    m_tbHerosFragValue = {}
    m_tbHerosFragValue = PartnerYingZi.updateYingZiData()

    if ( LayerManager.curModuleName() == moduleName()) then
        -- 如果是伙伴背包列表 刷新红点显示
        updateRecruit()
        local tbYingziValue = PartnerYingZi.updateYingZiData()
        --logger:debug(tbYingziValue)
        local nCountNew = 0 
        if (m_tbHerosFragValue) then
            nCountNew = #m_tbHerosFragValue
        end

        m_bag:updateCurrentListWithData(m_tbHerosFragValue,nil,tonumber(nCountOfYingzi) - tonumber(nCountNew))
        m_bag:updateListWithData(m_tbHerosFragValue,nil)
        
        m_bag:updateListWithData(m_tbHeroesValue,1) 
    end
end

--点击招募之后，伙伴推送之后初始化了 影子数据，但是再背包推送里，被招募的影子数据就因为银子数据被初始化了 所以无法排序，所以在背包的deleget里再做一次处理
function updateShadowList( ... )

    m_tbHerosFragValue = nil
    m_tbHerosFragValue = {}

    m_tbHeroesValue = PartnerModle.getAllPartnerSampleData()
    m_tbHerosFragValue = PartnerYingZi.updateYingZiData()

    if ( LayerManager.curModuleName() == moduleName()) then
        updateRecruit()
        local tbYingziValue = PartnerYingZi.updateYingZiData()

        local nCountNew = 0 
        if (m_tbHerosFragValue) then
            nCountNew = #m_tbHerosFragValue
        end
        logger:debug(tonumber(nCountOfYingzi) - tonumber(nCountNew))
        nCountOfYingzi = nCountNew
        
        m_bag:updateListWithData(m_tbHeroesValue,1) 
        m_bag:updateCurrentListWithData(m_tbHerosFragValue,nil,1)
    end
    
end
--设置去副本之前的状态 
function setListViewStatus( listViewIndex,fraginfoTid,callfn )
    resumInfo = {}
    resumInfo.fraginfoTid = fraginfoTid
    resumInfo.tableIndex = listViewIndex
    -- if (listViewIndex ~= 0) then  -- 是从背包进入副本
    --     resumInfo.newOffset= m_bag:getListViewData(listViewIndex)
    -- end
    resumInfo.callfun = callfn

end

-- 从副本过来刷新列表
function resumBagCallFn( fraginfoTid,tableIndex)
    TimeUtil.timeStart("resumBagCallFn")
    local indexid = fraginfoTid
    listViewIndex = tableIndex 
    local ListValue 

    if (listViewIndex ~= 0 and m_bag) then     -- 是从背包进入副本
        local cellIndex = 0

        if (listViewIndex ==  1) then
            ListValue = PartnerModle.getAllPartnerSampleData()

            for i,v in ipairs(ListValue) do
                if (tonumber(v.htid) ~= tonumber(indexid)) then
                    cellIndex = cellIndex + 1
                else
                    break
                end
            end
        elseif (listViewIndex ==  2) then
            ListValue = PartnerYingZi.updateYingZiData() 
            for i,v in ipairs(ListValue) do
                if (tonumber(v.id) ~= tonumber(indexid)) then
                    cellIndex = cellIndex + 1
                else
                    break
                end
            end
        end

        m_bag:updateCurrentListWithData(ListValue,nil,1,cellIndex)
        --- 更新碎片ListView红点
        local nRecruit = HeroSortUtil.getFuseSoulNum()
        local showRecruit = false
        if(nRecruit > 0) then
         showRecruit = true
        end
        m_bag:udpateTabRedCircle(2,showRecruit,nRecruit)     

    end
    TimeUtil.timeEnd("resumBagCallFn")
end

function cleanHeroData( ... )
    g_bagRefresh.parnterRefresh = true
end

function cleanHeroFragData( ... )
    m_tbHerosFragValue = nil
    m_tbHerosFragValue = {}
end

--添加伙伴
function updataHeroDataByHtid( tbHeroAddData )
    g_bagRefresh.parnterRefresh = true
end

--[[desc:替换已经存在的伙伴，更新数据
    arg1: 
    return: 是否有返回值，返回值说明  
—]]

function replaceHeroDataByHid(Hid)
    g_bagRefresh.parnterRefresh = true
end



--[[desc:替换已经存在的影子碎片
    arg1: 
    return: 是否有返回值，返回值说明  
—]]

function replacHeroFragDataByGid(gid,data)
    logger:debug("replacHeroFrageDataByGid")
    --判断之前是否进入过背包
    local  b_empty = isHeroFragDataEmpty()

    if(b_empty == false) then
        for i,v in ipairs(m_tbHerosFragValue) do
            if(tonumber(v.gid) == tonumber(gid)) then
                local tbFrag = PartnerYingZi.getHeroFragDataByGid(gid,data)
                m_tbHerosFragValue[i] = tbFrag
                
                g_bagRefresh.partnerFragRefresh = true
          
                return
            end
        end
    end
end

--[[desc:插入新影子碎片数据
    arg1: 
    return: 是否有返回值，返回值说明  
—]]

function insertHeroFragDataByGid(gid,data)
    --判断之前是否进入过背包,
    local b_empty = isHeroFragDataEmpty()

    if(b_empty == false) then
        local tbNewFrag = PartnerYingZi.getHeroFragDataByGid(gid,data)
        table.insert(m_tbHerosFragValue,tbNewFrag)
         g_bagRefresh.partnerFragRefresh = true
    end
end
--[[desc:删除旧数据影子碎片
    arg1: 
    return: 是否有返回值，返回值说明  
—]]

function removeHeroFragDataByGid(gid)
    --判断之前是否进入过背包
    local b_empty = isHeroFragDataEmpty()

    -- logger:debug(b_empty)

    if(b_empty == false) then
        local index = 0
        for i=1,#m_tbHerosFragValue do
            if(tonumber(m_tbHerosFragValue[i].gid) == tonumber(gid)) then
                index = i
                break
            end
        end

        table.remove(m_tbHerosFragValue, index)
        g_bagRefresh.partnerFragRefresh = true
    end
    
end


--[[desc:判断当前伙伴和伙伴碎片的数据是否已经准备好了，也就是说看以前是否进入过伙伴背包,如果没有准备好，则初始化数据，
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]

function isHeroFragDataEmpty()
    if(table.isEmpty(m_tbHerosFragValue)) then
        logger:debug("table.isEmpty")
        return  true
    end
    return false
end

--伙伴列表
local function getPartnerViewConfig( ... )
    m_tbHeroesValue =  PartnerModle.getAllPartnerSampleData()-- m_fnUpdatePartnerData()
    
    -- 构造列表需要的数据
    local tbView = {}
    tbView.szCell = g_fnCellSize(CELLTYPE.PARTNER)
    tbView.tbDataSource = m_tbHeroesValue
    
    tbView.CellAtIndexCallback = function (tbData, idx, objView) -- idx 是tableView的索引，从0开始
        local instCell = PartnerCell:new(objView)
        instCell:init(CELL_USE_TYPE.BAG)

        instCell:addDownCallback(function ( idxData )   
            -- PartnerModle.addPartnerTransfer(tbData)
            -- logger:debug(m_tbHeroesValue)
            tbData = m_tbHeroesValue[idxData]
            -- 判断是否可以突破
            local bBreak = true
            -- tbData = PartnerModle.getHeroDataByHid(tbData)
            -- logger:debug(tbData)
            tbData.db_hero = tbData.db_hero or DB_Heroes.getDataById(tbData.htid)
            bBreak = tbData.db_hero.break_id or false

            local bAwake = true
            bAwake = tbData.db_hero.disillusion_quality or false

            -- 插入一条相对于按钮面板cell的人造数据 2015-04-24
            require "db/DB_Switch"

            local breakLv = DB_Switch.getDataById(ksSwitchHeroBreak).level
            local awakeLv = DB_Switch.getDataById(ksSwitchAwake or 40).level

            require "script/module/public/Cell/BtnBarCell"
            local size = g_fnCellSize(CELLTYPE.BTN_BAR)
            local barData = {isBtnBar = true, width = size.width, height = size.height}
            barData.events = {{event = onBtnIntensify, unlock = 2, i18n = 1007}, -- 强化固定2级开启
                              {event = onBtnJinJie, unlock = 4, canTrans = tbData.transNotice , i18n = 1005}, -- 进阶固定4级开启
                              {event = onBtnBreak, unlock = breakLv, i18n = 1110, canBreak = bBreak}
                             }
            if (bAwake) then
                table.insert(barData.events,{event = onBtnAwake, unlock = awakeLv, canAwake = tbData.awakeNotice ,i18n = 7401})
            else
                table.insert(barData.events,{})
            end

            objView:setBtnBarData(barData, idxData) -- 2015-05-13, 添加按钮面板的数据
        end)
        if (#m_tbHeroesValue>10) then
         performWithDelayFrame(instCell.mCell,function()
                    instCell:refresh(tbData)
                end,idx)
        else
            instCell:refresh(tbData)
        end
        -- local scene = CCDirector:sharedDirector():getRunningScene()
        -- if (idx<7) then
        --     -- performWithDelay(scene, function(...)
        --     --     instCell:refresh(tbData)
        --     -- end, g_cellAnimateDuration*idx)
        --     -- local frames=0
        --     -- local function onCall()
        --     --     if (frames==idx) then
        --     --         instCell:refresh(tbData)
        --     --         instCell.mCell:unscheduleUpdate()
        --     --     end
        --     --     frames = frames+1
        --     -- end
        --     -- instCell.mCell:scheduleUpdateWithPriorityLua(onCall,1000)
        --     performWithDelayFrame(instCell.mCell,function()
        --             instCell:refresh(tbData)
        --         end,idx)
        -- else
        --     instCell:refresh(tbData)
        -- end
        


        return instCell
    end
    
    return tbView
end

--影子列表
local function getShadowViewConfig( ... )
    -- 构造列表需要的数据
    local tbView = {}
    tbView.szCell = g_fnCellSize(CELLTYPE.SHADOW)
    tbView.getData = PartnerYingZi.updateYingZiData

    -- local  tbYingziValueInit = PartnerYingZi.updateYingZiData()
    -- if (tbYingziValueInit) then
    --     nCountOfYingzi = #tbYingziValueInit
    -- else
    --     nCountOfYingzi = 0
    -- end
    nCountOfYingzi = 0
    tbView.CellAtIndexCallback = function (tbData)
        -- logger:debug(tbData)
        local instCell = ShadowCell:new()
        instCell:init(CELL_USE_TYPE.BAG)
        instCell:refresh(tbData)
        return instCell
    end

    return tbView
end

--copyCome 从副本过来
function create( nType )
    init()
    TimeUtil.timeStart("ready Partner Data")
    local tbBagInfo = {sType = BAGTYPE.PARTNER, nums = {1}}
    tbBagInfo.tbTab = {}
    -- tbBagInfo.tbTab[1] = {nMaxNum = UserModel.getHeroLimit(),num = PartnerTransUtil.getIsHaveHroAdvanced() and 1 or 0, tbView = getPartnerViewConfig()} -- 伙伴列表数据
    tbBagInfo.tbTab[1] = {nMaxNum = UserModel.getHeroLimit(),tbView = getPartnerViewConfig()} -- 伙伴列表数据
    TimeUtil.timeEnd("ready Partner Data")
    TimeUtil.timeStart("ready Shadow Data")
    local viewShadow = getShadowViewConfig() -- zhangqi, 2014-07-23, 减少一次 PartnerYingZi.updateYingZiData() 调用
    tbBagInfo.tbTab[2] = {nMaxNum = 1000, num = HeroSortUtil.getFuseSoulNum(),tbView = viewShadow} -- 影子列表数据, 无携带上限1000只是占位而已
    TimeUtil.timeEnd("ready Shadow Data")
    TimeUtil.timeStart("ready View")

    m_bag = Bag.create(tbBagInfo, nType)
    TimeUtil.timeEnd("ready View")
    --------------------------- new guide begin -------------------------------------
    --CCLuaLog("getShadowViewConfig-GuideModel-begin: " .. os.clock())
    TimeUtil.timeStart("ready Guild")
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuidePartnerAdvView"
    if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createPartnerAdvGuide(2)  

          -- add by huxiaozhou 2014-08-20
         local onEnterNode = CCNode:create()
         m_bag.mLists[m_bag.mBtnIndex].view:addChild(onEnterNode)
         UIHelper.registExitAndEnterCall(onEnterNode,nil,function (  )
            logger:debug("m_bag.mLists[m_bag.mBtnIndex].view:setTouchEnabled(false)")
            m_bag.mLists[m_bag.mBtnIndex].view:setTouchEnabled(false)
         end)
        
        
    end
    TimeUtil.timeEnd("ready Guild")
    --CCLuaLog("getShadowViewConfig-GuideModel-end: " .. os.clock())
    ---------------------------- new guide end --------------------------------------
    return m_bag.mainList


end
---判断是否有可招募影子
function hasTipInPartner( ... )
    local nShadowNum   = HeroSortUtil.getFuseSoulNum()
    local bShow = nShadowNum ~= nil and nShadowNum > 0
    
    return bShow
end


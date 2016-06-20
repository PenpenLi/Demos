-- FileName: PartnerYingZi.lua 
-- Author: FuBei 
-- Date: 14-4-2 
-- Purpose: function description of module 


module("PartnerYingZi", package.seeall)

-- 局部变量
local m_fnGetWidget = g_fnGetWidgetByName     --全局获取widget函数,更高效
local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbHeroFragments
local m_sPartnerName                -- 合成的伙伴名称，用于提示

--回调函数
local m_fnOnNetworkFlagRecruit      --招募的回调函数
local m_current_gid -- 当前格子id
local m_current_htid -- 当前格子内的影响的htid

local m_itemNumAfterRecruit

local tagFrameLight = 10            --头像点亮框 tag

-- 初始化和析构
function init( ... )
    
end

function destroy( ... )
    package.loaded["PartnerYingzi"] = nil 
end

function moduleName()
    return "PartnerYingzi"
end


local function onBtnSelectPartner( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playInfoEffect()
        require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = MainPartner.m_tbHerosFragValue[sender.idx] --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        logger:debug({pHeroValue=pHeroValue})
        local tbherosInfo = {}
        local heroInfo = {htid =pHeroValue.id ,hid = 0 ,strengthenLevel = 0,transLevel = 0 }
        table.insert(tbherosInfo,heroInfo)
        local tArgs = {}
        tArgs.heroInfo = heroInfo
        logger:debug({tArgs=tArgs})
        local layer = PartnerInfoCtrl.create(tArgs,3)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer)

    elseif (eventType == TOUCH_EVENT_BEGAN) then
        local frameLight = CCSprite:create("images/hero/quality/highlighted.png")
        frameLight:setAnchorPoint(ccp(0.5, 0.5))
        sender:addNode(frameLight,10,tagFrameLight)
    elseif (eventType == TOUCH_EVENT_CANCELED) then
        sender:removeNodeByTag(tagFrameLight)
    end
end

local function onBtnRecruit( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        require "script/module/public/ItemUtil"
        AudioHelper.playCommonEffect( )
        if (ItemUtil.isPartnerFull(true)) then
            return
        end
        logger:debug("m_tbHerosFragValue : " .. tostring(#MainPartner.m_tbHerosFragValue) )
        logger:debug("sender1111 : " .. tostring(sender) )
        if (not sender or not sender.idx) then
             logger:debug("sender222 : " .. tostring(sender.idx) )
             return
        end
        if (not MainPartner.m_tbHerosFragValue or sender.idx > #MainPartner.m_tbHerosFragValue) then
         logger:debug("sender222 : " .. tostring(sender.idx) )
            return
        end
        local value = MainPartner.m_tbHerosFragValue[sender.idx]
        m_sPartnerName = value.name -- zhangqi, 2014-08-11, 记录要招募的伙伴名称
        require "script/network/RequestCenter"

        local args = Network.argsHandler(value.gid, value.item_id, value.nMax) --参数序列化
        m_fnOnNetworkFlagRecruit = RequestCenter.bag_useItem(fnHandlerOfNetworkRecruitCallback, args)
        m_current_gid = value.gid
        m_current_htid = value.htid

        m_itemNumAfterRecruit = value.nOwn - value.nMax

        -- PreRequest.setBagDataChangedDelete(RecruitFromBagDeleget)
    end
end
--查看掉落
local function onBtnFindDrop( sender, eventType  )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        local curModuleName = LayerManager.curModuleName()

        require "script/module/public/FragmentDrop"
        logger:debug("查看掉落的影子的下表是" .. sender.idx)
        local fraginfo = MainPartner.m_tbHerosFragValue[sender.idx]
        local fraginfoTid = fraginfo.id
        local Args = {selectedHeroes = fraginfo}
        require "script/module/public/DropUtil"
        require "script/module/partner/MainPartner"
        local callFn = function ( ... )
             MainPartner.resumBagCallFn(fraginfoTid,2)
        end
        -- DropUtil.insertCallFn(curModuleName,callFn)

        require "script/module/public/FragmentDrop"
        local fragmentDrop = FragmentDrop:new()

        local fragmentDropLayer = fragmentDrop:create(fraginfoTid,callFn)

        LayerManager.addLayout(fragmentDropLayer)
    end
end


--背包的推送之后更新本界面的数据  2015-2-5-22 修改为伙伴信息面板关闭之后再更新背包
function RecruitFromBagDeleget( ... )
    MainPartner.updateShadowList()
    UserModel.updateInfoBar()
end


-- 招募武将网络回调处理
function fnHandlerOfNetworkRecruitCallback(cbName, dictData, bRet)
    if (bRet) then
        if (cbName == m_fnOnNetworkFlagRecruit) then

           MainPartner.m_tbHerosFragValue = nil
           MainPartner.m_tbHerosFragValue = {}

            g_redPoint.partner.visible = false -- zhangqi, 2014-08-11, 伙伴招募成功把伙伴按钮红点状态置为false, 返回主船不再显示红点

            if (m_itemNumAfterRecruit == 0) then
                DataCache.delHeroFragOfGid(m_current_gid)
            else
                DataCache.setHeroFragItemNumOfGid(m_current_gid, m_itemNumAfterRecruit)
            end

            --require "script/module/public/ShowNotice"
            --ShowNotice.showShellInfo(m_i18nString(1015, m_sPartnerName or ""))
            require "script/module/shop/HeroDisplay"
            local data = {}
            data.tid = tonumber(m_current_htid)
            data.num = 1 -- 默认招募的是伙伴，数量为 1
            data.iType = 1 -- 默认招募伙伴为1，影子为 2
            logger:debug(m_current_htid)
            HeroDisplay.create(data, 4 ,RecruitFromBagDeleget)
        end
    end
end


function updateYingZiData( ... )
    -- TimeUtil.timeStart("updateYingZiData")
    require "script/module/partner/HeroSortUtil"
    local refMainFrag = MainPartner.m_tbHerosFragValue

    -- if(not table.isEmpty(refMainFrag)) then
    --     --如果有新的伙伴碎片加入到伙伴背包里，则需要重新排序
    --     logger:debug("是否需要刷新伙伴影子列表:")
    --     logger:debug(g_bagRefresh.partnerFragRefresh)

    --     if(g_bagRefresh.partnerFragRefresh) then
    --         table.sort(refMainFrag, HeroSortUtil.sortPartnerSoul)
    --         for i, frag in ipairs(refMainFrag) do
    --             frag.idx = i
    --         end
    --         m_tbHeroFragments =  refMainFrag
    --         g_bagRefresh.partnerFragRefresh  = false

    --     end

    --     return refMainFrag
    -- end
    
    require "script/model/DataCache"
    local tHeroFrag = DataCache.getHeroFragFromBag()
    --logger:debug({tHeroFrag = tHeroFrag})
    
    --local tHeroFrag = DataCache.getAllHerofragByTid()
    logger:debug(tHeroFrag)
    local heroesValue = {}
    for k,v in pairs(tHeroFrag) do
        heroesValue[#heroesValue + 1] = getHeroFragDataByGid(k,v)
    end
    
    if (#heroesValue > 1) then
        table.sort(heroesValue, HeroSortUtil.sortPartnerSoul)
    end

    for i, frag in ipairs(heroesValue) do
        frag.idx = i
    end

    m_tbHeroFragments = heroesValue
    MainPartner.m_tbHerosFragValue = m_tbHeroFragments
    -- TimeUtil.timeEnd("updateYingZiData")
    return m_tbHeroFragments
end


function getHeroFragDataByGid( k ,v)
    -- TimeUtil.timeStart("getHeroFragDataByGid".. k)
    require "db/DB_Item_hero_fragment"
    local dbFrag = DB_Item_hero_fragment.getDataById(v.item_template_id)

    require "db/DB_Heroes"
    local db_hero = DB_Heroes.getDataById(dbFrag.aimItem)

    local value = {}

    value.gid = tonumber(k)
    value.id = v.item_template_id
    value.item_id = tonumber(v.item_id)
    value.htid = dbFrag.aimItem
    value.name = db_hero.name
    value.isBuddy = HeroModel.isBuddy(value.htid) -- zhangqi, 2014-07-23, 是否已招募过

    value.sign = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
    value.sTransfer = tostring(v.evolve_level)
    value.icon = { id = value.htid, bSui = true, bHero = true, onTouch = onBtnSelectPartner }
    value.findDrop =  onBtnFindDrop 
    value.sLevel = tostring(db_hero.level)
    value.nStar = db_hero.star_lv
    value.nQuality = db_hero.potential
    value.sExp = db_hero.decompos_soul

    value.onRecruit = onBtnRecruit 
    value.nOwn = tonumber(v.item_num) or 0
    value.nMax = tonumber(dbFrag.need_part_num) or 0

    value.is_compose = dbFrag.is_compose
    value.isRecruited = false -- 是否可招募
    value.expact = false -- 是否可招募但数量不够
    logger:debug(value.isBuddy)
    logger:debug(value.is_compose)
    if (value.is_compose == 1 and not value.isBuddy) then -- 可以招募
        if (value.nOwn >= value.nMax) then
            value.isRecruited = true
        else
            value.expact = true
        end
    end
    -- TimeUtil.timeEnd("getHeroFragDataByGid".. k)
    return value
end




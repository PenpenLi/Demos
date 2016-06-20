-- FileName: PartnerModle.lua
-- Author: liweidong
-- Date: 2015-08-10
-- Purpose: 伙伴背包modle
--[[TODO List]]

module("PartnerModle", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local DB_Heroes = DB_Heroes
local UserModel = UserModel
local HeroModel = HeroModel
local HeroPublicUtil = HeroPublicUtil

local function init(...)

end

function destroy(...)
	package.loaded["PartnerModle"] = nil
end

function moduleName()
    return "PartnerModle"
end

function create(...)

end
--单独计算是否可突破数据 额为增加
function addPartnerTransfer(value)
    if(value.bLoaded or value.bBench) then
        TimeUtil.timeStart("PartnerTransfer.fnCanTransfer")
        -- value.canTrans = PartnerTransfer.fnCanTransfer(false,value)
        TimeUtil.timeEnd("PartnerTransfer.fnCanTransfer")
    end
end
--获取一个伙伴的详情
function getHeroDataByHid(sampleData)
        local hid = sampleData.hid
        local userinfo  =  UserModel.getUserInfo()
        logger:debug(hid)
        local value = {}
        value.idx = sampleData.idx
        value.hid = hid
        local hero = sampleData --HeroModel.getHeroByHid(hid)
        -- logger:debug(hero)
        if  tonumber(sampleData.htid) == tonumber(userinfo.htid) then
            hero.level = userinfo.level        
        end 

        value.soul = tonumber(hero.soul)
        value.level = tonumber(hero.level)
        local db_hero = DB_Heroes.getDataById(hero.htid)

        value.name = db_hero.name
        value.htid = hero.htid
        value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
        
        value.head_icon = db_hero.head_icon_id
        value.decompos_soul = db_hero.decompos_soul
        value.lv_up_soul_coin_ratio = db_hero.lv_up_soul_coin_ratio
        value.awake_id = db_hero.awake_id
        value.grow_awake_id = db_hero.grow_awake_id
        value.heroQuality = db_hero.heroQuality
        value.potential = db_hero.potential
        value.beforeID = db_hero.before_id
        
        value.star_lv = db_hero.star_lv
        value.exp_id = db_hero.exp
        
        value.isBusy = HeroPublicUtil.isBusyWithHid(hid) -- 武将是否在阵上
        value.isOnBench = HeroPublicUtil.isOnBenchByHid(hid) -- 武将是否在替补上


        value.evolve_level = tonumber(hero.evolve_level)
        value.db_hero = db_hero
        value.disillusion_quality = db_hero.disillusion_quality
        value.fight_value = 0

        value.id = hid
        value.sign = value.country_icon
        value.sTransfer = "+" .. hero.evolve_level
        value.icon = { id = value.htid, bHero = true ,onTouch = MainPartner.onBtnSelectPartner}
        value.sLevel = value.level .. "/" .. UserModel.getHeroLevel()
        value.nStar = value.star_lv
        value.nQuality = db_hero.potential
        value.sExp = value.decompos_soul
        value.trend = db_hero.trend -- 2015-04-29, 添加子类型，物攻型等

        value.bLoaded = value.isBusy -- 2014-07-25
        if (value.isBusy or value.isOnBench) then          -- 2015-11-18 判断是否是 在阵上 并可进阶
            value.transNotice = PartnerTransUtil.checkPartnerCanTrans(hero.htid,value.level,value.evolve_level) 
        end
        if (value.isBusy or value.isOnBench) then          -- 2016-01-27 判断是否是 在阵上 并可觉醒
            value.awakeNotice = MainAwakeModel.isCanAwakeByHid(hid) 
        end
        value.awake_attr = sampleData.awake_attr
        value.isCanAwake = db_hero.disillusion_quality and SwitchModel.getSwitchOpenState(ksSwitchAwake or 40) 
        value.bSmall =  HeroPublicUtil.isOnLittleFriendBy(tonumber(value.htid)) 
        value.bBench = HeroPublicUtil.isOnBenchByHtid(tonumber(value.htid))

        -- if(value.bLoaded or value.bBench) then
        --     TimeUtil.timeStart("PartnerTransfer.fnCanTransfer")
        --     value.canTrans = PartnerTransfer.fnCanTransfer(false,value)
        --     TimeUtil.timeEnd("PartnerTransfer.fnCanTransfer")
        -- end
        -- value.canTrans = true
        table.hcopy(value,sampleData)
        sampleData.getItemData = nil
        return value
end

-- 按伙伴id大小排序
function fnCompareWithHeroId(h1, h2)
    if (h1 and h2) then
        return tonumber(h1.htid) > tonumber(h2.htid)
    end
end
-- 按强化等级由高到低排序
local function fnCompareWithLevel(h1, h2)
    if (h1 and h2) then
        if tonumber(h1.level) == tonumber(h2.level) then
            return fnCompareWithHeroId(h1, h2)
        else
            return tonumber(h1.level) > tonumber(h2.level)
        end
    end
end
local function fnCompareWithQuality(h1, h2)
    local db_hero1 = DB_Heroes.getDataById(h1.htid)
    h1.heroQuality = db_hero1.heroQuality
    local db_hero2 = DB_Heroes.getDataById(h2.htid)
    h2.heroQuality = db_hero2.heroQuality
    if h1.heroQuality == h2.heroQuality then
        return fnCompareWithLevel(h1, h2)
    else
        return h1.heroQuality > h2.heroQuality
    end
end
-- 按进阶次数排序
local function fnCompareWithEvolveLevel(h1, h2)
    if tonumber(h1.evolve_level) == tonumber(h2.evolve_level) then
        return fnCompareWithQuality(h1, h2)
    else
        return tonumber(h1.evolve_level) > tonumber(h2.evolve_level)
    end
end
-- 1: 武将界面排序规则
-- 规则. a: 主角优先排第一位，
--		b: 已上阵武将优先显示在最上面(上阵武将再按战斗力排序)，
--		c: 剩下的则根据武将星级高低排序，高的排上，低的排下，
--		d: 若星级相同则根据战斗力高低排序
function getSortAllHeros()
    TimeUtil.timeStart("sort hero time")
    local tAllHeroes = HeroModel.getAllHeroes()
    tAllHeroes = table.hcopy(tAllHeroes,{})

	local tSortedHeroes = {}
    local arrBusyHeroes = {} -- 上阵武将数组
	local formationInfo = DataCache.getFormationInfo()
    
    -- 从阵容信息中获取该武将是否已上阵
    for k,v in pairs(formationInfo) do
        local key = tostring(v)
        if (tAllHeroes[key]) then
            tAllHeroes[key].getItemData = getHeroDataByHid
            table.insert(arrBusyHeroes,tAllHeroes[key])
            tAllHeroes[key] = nil
            -- table.remove(tAllHeroes,v)
        end
    end

    local arrBenchHeros = {} --  替补武将数组
    local benchInfo = DataCache.getBench()
    for k, v in pairs(benchInfo) do
        local key = tostring(v)
        if (tAllHeroes[key]) then
            tAllHeroes[key].getItemData = getHeroDataByHid
            table.insert(arrBenchHeros,tAllHeroes[key])
            tAllHeroes[key] = nil
            -- table.remove(tAllHeroes,v)
        end
    end

    local arrSmallHeros = {} -- 小伙伴武将数组
    local littleFriendInfo = DataCache.getExtra()
    for k, v in pairs(littleFriendInfo) do
        local key = tostring(v)
        if (tAllHeroes[key]) then
            tAllHeroes[key].getItemData = getHeroDataByHid
            table.insert(arrSmallHeros,tAllHeroes[key])
            tAllHeroes[key] = nil
            -- table.remove(tAllHeroes,v)
        end
    end
	
	local arrStarLevelHeroes = {} -- 各星级武将数组, 目前只包含最高星级为 10 级
	for i=1, 10 do
		table.insert(arrStarLevelHeroes, {})
	end
    for _,val in pairs(tAllHeroes) do
        if (val) then
            val.getItemData = getHeroDataByHid
            local db_hero = DB_Heroes.getDataById(val.htid)
            local star_lv = tonumber(db_hero.star_lv)
            if (not star_lv or star_lv == 0) then
                star_lv = 1
            end
            table.insert(arrStarLevelHeroes[star_lv], val)
        end
    end

	table.sort(arrBusyHeroes, fnCompareWithQuality) -- 上阵武将按资质排序排序
	table.sort(arrBenchHeros, fnCompareWithQuality) --wangming, 2015-01-15, 上阵替补按资质排序排序
	table.sort(arrSmallHeros, fnCompareWithQuality) --zhangjunwu, 2014-11-13, 上阵小伙伴按资质排序排序

	-- table.sort(arrBusyHeroes, fnCompareWithStarLevel) -- 上阵武将再按战斗力排序

	-- 星级相同的武将再按战斗力排序
	for i=1, #arrStarLevelHeroes do
		table.sort(arrStarLevelHeroes[i], fnCompareWithEvolveLevel)
	end
	-- 把已排序好的上阵武将加入到 武将排序数组中
	for i=1, #arrBusyHeroes do
		arrBusyHeroes[i].idx = #tSortedHeroes  + 1
		table.insert(tSortedHeroes, arrBusyHeroes[i])
	end

	-- wangming, 2015-01-15, 把已排序好的替补加入到 武将排序数组中
	for i=1, #arrBenchHeros do
		arrBenchHeros[i].idx = #tSortedHeroes  + 1
		table.insert(tSortedHeroes, arrBenchHeros[i])
	end

	-- zhangjunwu,2014-11-13, 把已排序好的小伙伴加入到 武将排序数组中
	for i=1, #arrSmallHeros do
		arrSmallHeros[i].idx = #tSortedHeroes  + 1
		table.insert(tSortedHeroes, arrSmallHeros[i])
	end

	-- 把已排序好的星级/战斗力英雄数组加入到 武将排序数组中
	for i=1, 10 do
		local arrStarLevel = arrStarLevelHeroes[10-i+1]
		local arrLen = #arrStarLevel
		if arrLen > 0 then
			for k=1, arrLen do
				arrStarLevel[k].idx = #tSortedHeroes + 1
				table.insert(tSortedHeroes, arrStarLevel[k])
			end
		end
	end
    TimeUtil.timeEnd("sort hero time")
	return tSortedHeroes
end
--生成所有伙伴排序后的数据缓存
local m_tbHeroesValue = {}
function getAllPartnerSampleData()
	-- if(not table.isEmpty(m_tbHeroesValue)) then
 --        if (g_bagRefresh.parnterRefresh) then
 --            m_tbHeroesValue = getSortAllHeros()
 --            return m_tbHeroesValue
 --        end
 --        return m_tbHeroesValue
 --    end
    m_tbHeroesValue = getSortAllHeros()
    return m_tbHeroesValue
end



function getTreaDes( treaID ,hid,activelimitLel)
    local m_color_normal = ccc3( 0x7f, 0x5f, 0x20)
    local m_color_get = ccc3( 0x01, 0x8a, 0x00)

    local isHave     = false
    local isActive = false
    local labelColor = m_color_normal
    local treaInfo = 1

    local richTextInfo = {} 
    local nFlag = 0 
    local heroInfo =  HeroModel.getHeroByHid(hid)
    local equipInfo =  heroInfo.equip
    if  equipInfo and  equipInfo.arming  then
        local  pArm = equipInfo.arming[""..4] or nil
        if (pArm and pArm.item_template_id) then
            local templateId = tonumber(pArm.item_template_id)
            if tonumber(treaID) == templateId then
                isHave     = true
                if (tonumber(pArm.va_item_text.exclusiveEvolve) >= activelimitLel) then
                    isActive = true
                    labelColor = m_color_get
                end
            end
        end
        logger:debug({getTreaDes_pTrea = pArm})
    end

    if  equipInfo and  equipInfo.exclusive  then
        local pTrea = equipInfo.exclusive[""..1] or nil
        if (pTrea and pTrea.item_template_id) then
            local templateId = tonumber(pTrea.item_template_id)
            if (tonumber(treaID) == templateId ) then
                isHave     = true
                if (tonumber(pTrea.va_item_text.exclusiveEvolve) >= activelimitLel) then
                    isActive = true
                    labelColor = m_color_get
                end
            end
        end
        logger:debug({getTreaDes_pTrea = pTrea})
    end

    return labelColor,isHave,heroInfo,isActive
end







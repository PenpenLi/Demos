-- FileName: PartnerInfoModle.lua
-- Author: sunyunpeng
-- Date: 2015-11-01
-- Purpose: function description of module
--[[TODO List]]

PartnerInfoModle = class("PartnerInfoModle")


function PartnerInfoModle:ctor( ... )



end

function PartnerInfoModle:create( partnerPageInfo , layType  )
 	self.pageViewType = nil
    self.curModuleName = LayerManager.curModuleName()
	self.layoutStyle = layType
    self.externHeroInfo = partnerPageInfo.externHeroInfo
    self.pageViewType = partnerPageInfo.pageViewType or 3  --1 自己阵容 2 别人阵容 -- 3 默认一页自己英雄 4 默认一页 英雄碎片
    local tbHeros,heroIndex = self:getFormationData(self.pageViewType,partnerPageInfo)

    self.tbHeros = tbHeros
    self.heroIndex = heroIndex

	self:initHeroInfo(heroIndex)
    return self
end

function PartnerInfoModle:getHeroAwakes( heroInfo )
    local heroDB = heroInfo.heroDB

    local arrAwakeId = nil
    if heroDB.awake_id then
        arrAwakeId = string.split(heroDB.awake_id, ",")
    end
    local arrGrowAwakeId = nil
    if heroDB.grow_awake_id then
        arrGrowAwakeId = string.split(heroDB.grow_awake_id, ",")
    end
    
    require "db/DB_Awake_ability"
    -- 如果存在天赋ID
    local tAwakes = {}
    if arrAwakeId then
        for i=1, #arrAwakeId do
            tAwakes[#tAwakes+1] = {}
            local awake =  tAwakes[#tAwakes]
            awake.id = arrAwakeId[i]
        end
    end
    if arrGrowAwakeId then
        for i=1, #arrGrowAwakeId do
            tAwakes[#tAwakes+1] = {}
            local awake =  tAwakes[#tAwakes]
            local levelAndId = string.split(arrGrowAwakeId[i], "|")
            local awkae_type = tonumber(levelAndId[1])
            if awkae_type == 1 then
                awake.id = tonumber(levelAndId[3])
                awake.level = tonumber(levelAndId[2])
                awake.evolve_level = 0
                awake.type = 1
                awake.value = tonumber(levelAndId[2])
            elseif awkae_type == 2 then
                awake.id = tonumber(levelAndId[3])
                awake.evolve_level = tonumber(levelAndId[2])
                awake.level = 0
                awake.type = 2
                awake.value =  tonumber(levelAndId[2])
            end
        end
    end
    return tAwakes
end


function PartnerInfoModle:initHeroInfo( heroIndex )
    self.heroIndex = heroIndex
    local curModuleName = LayerManager.curModuleName()

	local tempHeroInfo = self.tbHeros[heroIndex]
	local heroInfo = {}

    local itemType = ItemUtil.getItemTypeByTid(tempHeroInfo.htid)

    heroInfo = tempHeroInfo 
    heroInfo.curModuleName = curModuleName
    heroInfo.itemType = itemType
    if (not itemType.isShadow) then
	    local heroDB = DB_Heroes.getDataById(tempHeroInfo.htid)
        local heroFragTid = heroDB.fragment
        local heroFragDB = DB_Item_hero_fragment.getDataById(heroFragTid)
        local heroAllMes
        if (self.fromType == 1) then
            heroAllMes = HeroModel.getHeroByHid(tempHeroInfo.hid)
        elseif (self.fromType == 2) then 
            heroAllMes = heroInfo.heroValue
        end
	    heroInfo.heroDB = heroDB
        heroInfo.heroFragDB = heroFragDB
        heroInfo.heroAllMes = heroAllMes
    else
        local heroFragDB = DB_Item_hero_fragment.getDataById(tempHeroInfo.htid)
        local heroAimTid = heroFragDB.aimItem
        local heroDB = DB_Heroes.getDataById(tonumber(heroAimTid))
        heroInfo.heroFragDB = heroFragDB
        heroInfo.heroDB = heroDB
    end

    heroInfo.heroAwakes = self:getHeroAwakes(heroInfo)
    heroInfo.layoutStyle = self.layoutStyle
    heroInfo.externHeroInfo = self.externHeroInfo
    heroInfo.heroValue = tempHeroInfo.heroValue
    heroInfo.pageViewType = self.pageViewType
	self.heroInfo = heroInfo
end


function PartnerInfoModle:getModleData( ... )
	return self.heroInfo
end


function PartnerInfoModle:getFormationData( formationType,partnerPageInfo )
    local dbHeros = {}
    local heroIndex = 0
    local heroNums = 0
    local pageViewType = self.pageViewType
    local checkHid = tonumber(partnerPageInfo.heroInfo.hid)

    local function returnArgs( tempHeroInfo )
        return {htid = tempHeroInfo.htid ,hid = tempHeroInfo.hid or 0 ,strengthenLevel = tempHeroInfo.level or 0 ,transLevel = tempHeroInfo.evolve_level or 0,location = tempHeroInfo.location or 1,heroValue = tempHeroInfo,awake = tempHeroInfo.awake_attr or tempHeroInfo.awakeInfo}
    end 

    if (pageViewType == 1) then
        local allHeroInfo = {}

        local squad = DataCache.getSquad() -- 自己伙伴
        local bench = DataCache.getBench() -- 自己替补
        local squadNum =  MainFormationTools.fnGetSquadNum() and tonumber(MainFormationTools.fnGetSquadNum())
        logger:debug({squadNum = squadNum})
        for i=0,squadNum - 1 do
            local hid = tonumber(squad[i .. ""])
            if (tonumber(hid) > 0) then
                local tempInfo = {}
                tempInfo.location = tonumber(i) + 1
                tempInfo.heroInfo =  HeroModel.getHeroByHid(tonumber(hid))
                table.insert(allHeroInfo,tempInfo)
            end
        end

        for k,hid in pairs(bench) do
            if (tonumber(hid) > 0) then
                local tempInfo = {}
                tempInfo.location = squadNum 
                tempInfo.heroInfo =  HeroModel.getHeroByHid(tonumber(hid))
                table.insert(allHeroInfo,tempInfo)
            end
        end

        for k,v in ipairs(allHeroInfo) do
            if  (v.heroInfo and (tonumber(v.heroInfo.hid) > 0 )) then
                local tempHeroInfo = v.heroInfo 
                local heroDB = DB_Heroes.getDataById(tempHeroInfo.htid)
                tempHeroInfo.exp_id = heroDB.exp
                tempHeroInfo.star_lv = heroDB.star_lv
                tempHeroInfo.soul = tempHeroInfo.soul
                tempHeroInfo.level = tonumber(tempHeroInfo.level)
                tempHeroInfo.location = v.location
                local heroInfo = returnArgs(tempHeroInfo)
                table.insert(dbHeros,heroInfo)
                heroNums = heroNums + 1
                if ( tonumber(heroInfo.hid) == tonumber(checkHid)) then
                    heroIndex = heroNums 
                end
            end
        end

    elseif (pageViewType == 2) then
        local externHeroInfo = self.externHeroInfo
        local tempDbHeros = {}
        for k,tempHero in pairs(externHeroInfo.arrHero) do
            if (tempHero and tempHero.hid and  tonumber(tempHero.hid) > 0) then
                local heroInfo = returnArgs(tempHero)

                logger:debug({PartnerInfoModle_tempHero = tempHero})
                logger:debug({PartnerInfoModle_heroInfo = heroInfo})

                tempDbHeros[tempHero.hid .. ""] = heroInfo
            end
        end


        local squad = externHeroInfo.squad

        for k,hid in pairs(squad) do
            if (tonumber(hid) > 0) then
                local heroInfo = tempDbHeros[hid .. ""]
                heroInfo.pos = tonumber(k)
                table.insert(dbHeros,heroInfo)
            end
        end

        table.sort( dbHeros, function ( v1,v2 )
            return tonumber(v1.pos) < tonumber(v2.pos)
        end )

        for i,heroInfo in ipairs(dbHeros) do
            heroNums = heroNums + 1
            if ( tonumber(heroInfo.hid) == tonumber(checkHid)) then
                heroIndex = heroNums 
            end
        end

        for i,tempHero in pairs(externHeroInfo.arrBench) do
            if ( tempHero and tempHero.hid and tonumber(tempHero.hid) > 0) then
                local heroInfo = returnArgs(tempHero)

                logger:debug({PartnerInfoModle_tempHero = tempHero})
                logger:debug({PartnerInfoModle_heroInfo = heroInfo})

                table.insert(dbHeros,heroInfo)
                heroNums = heroNums + 1
                if ( tonumber(heroInfo.hid) == tonumber(checkHid)) then
                    heroIndex = heroNums 
                end
            end
        end
    else
        local heroInfo = partnerPageInfo.heroInfo 
        logger:debug({partnerPageInfo = partnerPageInfo})
        -- 线上报错
        if (tonumber(heroInfo.hid) > 0) then
            self.pageViewType = 3  --  自己英雄信息
        else
            self.pageViewType = 4  -- 碎片信息
        end
        table.insert(dbHeros,heroInfo)
        heroIndex = 1
    end

    return dbHeros,heroIndex 
end


function PartnerInfoModle:getHeroIndex( ... )
    return self.heroIndex,#self.tbHeros
end


-- 获取页面容器里的所有图片模型资源地址
function PartnerInfoModle:getheroModelPageView( ... )
    local heroModelListviewInfo = {}
    local itemType = self.heroInfo.itemType

    for i,tempHeroInfo in ipairs(self.tbHeros) do
        if (not itemType.isShadow) then
           local heroDB = DB_Heroes.getDataById(tempHeroInfo.htid)
           table.insert(heroModelListviewInfo,heroDB) 
        else
            local heroFragDB = DB_Item_hero_fragment.getDataById(tempHeroInfo.htid)
            local heroAimTid = heroFragDB.aimItem
            local heroDB = DB_Heroes.getDataById(tonumber(heroAimTid))
           table.insert(heroModelListviewInfo,heroDB)
        end
    end

    return heroModelListviewInfo
end






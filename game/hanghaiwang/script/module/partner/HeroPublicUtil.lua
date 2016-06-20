-- Filename: HeroPublicUtil.lua
-- Author: fang
-- Date: 2013-08-23
-- Purpose: 该文件用于: 武将系统lua公用方法

module("HeroPublicUtil", package.seeall)

-- 获得所有英雄信息数组
-- tAppend，期望附加进数据结构的信息table
function getAllHeroValues(tAppend)
	require "script/model/hero/HeroModel"
	require "db/DB_Heroes"
	require "script/module/partner/HeroFightUtil"

	local hids = HeroModel.getAllHeroesHid()
	local heroesValue = {}
	for i=1, #hids do
		local value = {}
		value.hid = hids[i]
		local hero = HeroModel.getHeroByHid(hids[i])
        value.soul = tonumber(hero.soul)
		value.htid = hero.htid
		value.level = tonumber(hero.level)
		
		local db_hero = DB_Heroes.getDataById(hero.htid)
		local bIsFiltered = false
		if tAppend.filters then
			for i=1, #tAppend.filters do
				if tonumber(value.htid) == tAppend.filters[i] then
					bIsFiltered = true
				end
			end
		end
		if not bIsFiltered then
			value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
			value.name = db_hero.name
			
	        value.decompos_soul = db_hero.decompos_soul
	        value.lv_up_soul_coin_ratio = db_hero.lv_up_soul_coin_ratio
			value.evolve_level = tonumber(hero.evolve_level)
			value.star_lv = db_hero.star_lv
			value.awake_id = db_hero.awake_id
			value.grow_awake_id = db_hero.grow_awake_id
			value.exp_id = db_hero.exp
			-- 如果存
			if tAppend.heroTagBegin then
			 	value.tag_hero = tAppend.heroTagBegin+i
			end
			value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
			value.quality_bg = "images/hero/quality/"..value.star_lv..".png"
			value.quality_h = "images/hero/quality/highlighted.png"
			-- 还需要什么数据信息都可以在这里加
			value.fight_value = 0
			value.isBusy = isBusyWithHid(value.hid)
			
			heroesValue[#heroesValue+1] = value
		end
	end

	return heroesValue
end

-- 通过武将hid获得其属性相关数据
function getHeroDataByHid(hid)
-- 以下引用导致"stack overflow"
	require "script/model/hero/HeroModel"
	require "db/DB_Heroes"
	local tHeroData = {}
	local hero = HeroModel.getHeroByHid(hid)
	if hero then
		tHeroData.hid = hid
		tHeroData.soul = tonumber(hero.soul)
		tHeroData.htid = hero.htid
        tHeroData.level = tonumber(hero.level)
		tHeroData.evolve_level = tonumber(hero.evolve_level)
		
		local db_hero = DB_Heroes.getDataById(hero.htid)
		tHeroData.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
		-- zhangqi, 2015-01-09, 去主角修改
		-- local bIsAvatar = HeroModel.isNecessaryHero(tHeroData.htid)
		-- if bIsAvatar then
		-- 	tHeroData.name = UserModel.getUserName()
		-- else
			tHeroData.name = db_hero.name
		-- end
		tHeroData.decompos_soul = db_hero.decompos_soul
		tHeroData.lv_up_soul_coin_ratio = db_hero.lv_up_soul_coin_ratio
		tHeroData.star_lv = db_hero.star_lv
		tHeroData.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
		tHeroData.quality_bg = "images/hero/quality/"..db_hero.star_lv .. ".png"
		tHeroData.quality_h = "images/hero/quality/highlighted.png"
        tHeroData.awake_id = db_hero.awake_id
		tHeroData.grow_awake_id = db_hero.grow_awake_id
		tHeroData.exp_id = db_hero.exp
        tHeroData.fight_value = HeroFightUtil.getAllForceValues(tHeroData).fightForce
		-- 还需要什么数据信息都可以在这里加
	end
	
	return tHeroData
end

-- 通过武将hid获得其属性相关数据
function getHeroDataByHid02(hid)
-- 以下引用导致"stack overflow"
	require "script/model/hero/HeroModel"
	require "db/DB_Heroes"
	local tHeroData = {}
	local hero = HeroModel.getHeroByHid(hid)
	if hero then
		tHeroData.hid = hid
		tHeroData.soul = tonumber(hero.soul)
		tHeroData.htid = hero.htid
        tHeroData.level = tonumber(hero.level)
		tHeroData.evolve_level = tonumber(hero.evolve_level)
		
		local db_hero = DB_Heroes.getDataById(hero.htid)
		tHeroData.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
		-- zhangqi, 2015-01-09, 去主角修改
		-- local bIsAvatar = HeroModel.isNecessaryHero(tHeroData.htid)
		-- if bIsAvatar then
		-- 	tHeroData.name = UserModel.getUserName()
		-- else
			tHeroData.name = db_hero.name
		-- end
		tHeroData.decompos_soul = db_hero.decompos_soul
		tHeroData.lv_up_soul_coin_ratio = db_hero.lv_up_soul_coin_ratio
		tHeroData.star_lv = db_hero.star_lv
		tHeroData.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
		tHeroData.quality_bg = "images/hero/quality/"..db_hero.star_lv .. ".png"
		tHeroData.quality_h = "images/hero/quality/highlighted.png"
        tHeroData.awake_id = db_hero.awake_id
		tHeroData.grow_awake_id = db_hero.grow_awake_id
		tHeroData.exp_id = db_hero.exp
		-- 还需要什么数据信息都可以在这里加
	end
	
	return tHeroData
end

-- 通过hid判断一个武将是否在阵上
function isBusyWithHid(hid)
	local bStatus = false
	require "script/model/DataCache"
	local formationInfo = DataCache.getFormationInfo()
	if not formationInfo then
		return bStatus
	end
	-- 从阵容信息中获取该武将是否已上阵
	for k, v in pairs(formationInfo) do
		if (tostring(v) == tostring(hid)) then
			bStatus=true
			break
		end
	end
	return bStatus
end


-- add by huxiaozhou 2015-01-15
-- 根据hid 判断小伙伴中存在的武将 是否是这个hid
function isOnlittleFmtByHid( hid )
	local bStatus = false
	--判断是否在小伙伴阵容里
	local t_squad = DataCache.getExtra()

	if not t_squad then
		return bStatus
	end

	for i,v in ipairs(t_squad) do
		if (tonumber(hid) == tonumber(v)) then
			bStatus=true
		end
	end
	return bStatus
end

-- add by huxiaozhou 2015-01-15
-- 根据hid 判断替补中存在的武将 是否是 这个hid
function isOnBenchByHid( hid )
	local bStatus = false
	local benchInfo = DataCache.getBench()
    local tAllHeroes = HeroModel.getAllHeroes()
    if table.isEmpty( benchInfo) then
    	return false
    end
	for k, v in pairs(benchInfo) do
		if tonumber(v) > 0 and tonumber(tAllHeroes[tostring(v)].hid) == tonumber(hid) then
			bStatus=true
			break
		end
	end
    
	return bStatus
end

-- add by huxiaozhou 
-- 根据hid 判断 是否在阵容 或者替补上 或者小伙伴上
function isBusyByHid(hid)
	local bBusy = isBusyWithHid(hid)
	if not bBusy then
		bBusy = isOnBenchByHid(hid)
	end
	if not bBusy then
		bBusy = isOnlittleFmtByHid(hid)
	end
	return bBusy
end

--- add by huxiaozhou
-- 根据hid 判断 是否在阵容 或者替补上
function isOnFmtByHid(hid)
	local bBusy = isBusyWithHid(hid)
	if not bBusy then
		bBusy = isOnBenchByHid(hid)
	end
	return bBusy
end

-- 通过htid判断阵容中是否存在某一类武将
function isBusyWithHtid(htid)

    local bStatus = false
	require "script/model/DataCache"
	local formationInfo = DataCache.getFormationInfo()
	local benchInfo = DataCache.getBench()
	logger:debug({formationInfo = formationInfo})
	logger:debug({benchInfo = benchInfo})
    local tAllHeroes = HeroModel.getAllHeroes()
    if not formationInfo then
    	return false
    end
	for k, v in pairs(formationInfo) do
		if tonumber(v) > 0 then
			local modelId_1 = HeroModel.getHeroModelId(tonumber(tAllHeroes[tostring(v)].htid))
			local modelId_2 = HeroModel.getHeroModelId(tonumber(htid))
			if (modelId_1 == modelId_2) then
				bStatus=true
				break
			end
		end
	end
	if (not bStatus) then
		for k, v in pairs(benchInfo) do
			if tonumber(v) > 0 then
				local modelId_1 = HeroModel.getHeroModelId(tonumber(tAllHeroes[tostring(v)].htid))
				local modelId_2 = HeroModel.getHeroModelId(tonumber(htid))
				if (modelId_1 == modelId_2) then
					bStatus=true
					break
				end
			end
		end
	end
    -- logger:debug("htid == " .. htid  )
    -- logger:debug(bStatus)
	return bStatus
end

-- addBy chengliang
-- 通过htid判断小伙伴中是否存在某一类武将
function isOnLittleFriendBy(htid)
    local bStatus = false
	local littleFriendInfo = DataCache.getExtra()
    local tAllHeroes = HeroModel.getAllHeroes()
    if table.isEmpty( littleFriendInfo) then
    	return false
    end
	for k, v in pairs(littleFriendInfo) do
		if tonumber(v) > 0 and tonumber(tAllHeroes[tostring(v)].htid) == tonumber(htid) then
			bStatus=true
			break
		end
	end
    
	return bStatus
end

-- addBy wangming
-- 通过htid判断替补中是否存在某一类武将
function isOnBenchByHtid(htid)
    local bStatus = false
	local benchInfo = DataCache.getBench()
    local tAllHeroes = HeroModel.getAllHeroes()
    if table.isEmpty( benchInfo) then
    	return false
    end
	for k, v in pairs(benchInfo) do
		if tonumber(v) > 0 and tonumber(tAllHeroes[tostring(v)].htid) == tonumber(htid) then
			bStatus=true
			break
		end
	end
    
	return bStatus
end



-- addBy wangming
-- 通过htid判断阵容、小伙伴、替补中是否存在某一类武将
function isHeroBusyByHtid(htid)
	local pBusy = isBusyWithHtid(htid)
	if(not pBusy) then
		pBusy = isOnLittleFriendBy(htid)
	end
	if(not pBusy) then
		pBusy = isOnBenchByHtid(htid)
	end
	return pBusy
end


local tColorsOfQulity = {
 	{0xff, 0xff, 0xff},
 	{0xff, 0xff, 0xff},
 	{0, 0xeb, 0x21},
 	{0x51, 0xfb, 0xff},
 	{255, 0, 0xe1},
 	{255, 0x84, 0},
 	{255, 0x27, 0x27},
}
-- 获得星级对应的品质颜色
function getCCColorByStarLevel(nStarLevel)
	local color = tColorsOfQulity[nStarLevel]
	if not color then
		color = {255, 255, 255}
	end
	return ccc3(color[1], color[2], color[3])
end

function getHeroSoulByFullLevel( exp_id )
	require "db/DB_Level_up_exp"
	local db_level = DB_Level_up_exp.getDataById(exp_id)
	local pHeroLevel = UserModel.getHeroLevel()
	local pTotleSoul = 0
	local nLevelToSoul = 1
	for i=2, pHeroLevel do
		local nSoul = db_level["lv_"..i]
		if not nSoul then
			break
		end
		pTotleSoul = pTotleSoul + tonumber(nSoul)
	end
	return pTotleSoul
end

-- 武将增加经验后对应的级别,和剩余的经验，和升级所占的比例
function getHeroLevelByAddSoul(tParam)
	local maxLel = tonumber(UserModel.getHeroLevel())

	require "db/DB_Level_up_exp"
	local db_level = DB_Level_up_exp.getDataById(tParam.exp_id)
	local curLel = tonumber(tParam.level)
	local addExp = tonumber(tParam.added_soul)
	local nowLeftoul = tonumber(tParam.nowLeftoul) + addExp
	local affterLel = curLel
	local bluePersent = 0

	for i = curLel + 1 ,maxLel  do
		nowLeftoul = nowLeftoul - tonumber(db_level["lv_"..i]) 
		if (nowLeftoul >= 0 ) then
			affterLel = affterLel + 1
			if (affterLel > maxLel) then
				affterLel = maxLel
				nowLeftoul = nowLeftoul + tonumber(db_level["lv_"..i])
				bluePersent = 0
				break
			end
		else
			nowLeftoul = nowLeftoul + tonumber(db_level["lv_"..i])
			bluePersent = intPercent(nowLeftoul, tonumber(db_level["lv_"..i]))
			break
		end
	end

	return affterLel,nowLeftoul,bluePersent
end

-- 武将升至下一级需要的经验
function getSoulToNextLevel(tParam)
	require "db/DB_Level_up_exp"
	local db_level = DB_Level_up_exp.getDataById(tParam.exp_id)
	local nNextLevelSoul = 0
	for i=2, tParam.level+1 do
		local nSoul = db_level["lv_"..i]
		if not nSoul then
			break
		end
		nNextLevelSoul = nNextLevelSoul + tonumber(nSoul)
	end
	local nSoulNeeded = nNextLevelSoul - tonumber(tParam.soul)
	if nSoulNeeded < 0 then
		nSoulNeeded = 0
	end

	return nSoulNeeded
end
-- 武将等级对应的武魂数量
function getSoulOnLevel(tParam)
	require "db/DB_Level_up_exp"
	local db_level = DB_Level_up_exp.getDataById(tParam.exp_id)
	local nTotalSoul = 0
	for i=2, tParam.level do
		local nSoul = db_level["lv_"..i]
		if not nSoul then
			break
		end 
		nTotalSoul = nTotalSoul + tonumber(nSoul)
	end

	return nTotalSoul
end

-- add by yucong
--[[desc: 判断指定htid是否拥有过，不论出售还是分解了
    _htid: 
    heHeroBook: 对方的图鉴
    return: true 拥有过
-—]]
function isHeroOnceHaveWithHtid( _htid, heHeroBook )
	local htid = _htid
	local data = heHeroBook or DataCache.getHeroBook()-- or HeroModel.getAllHeroesHid()
	for k, v in pairs(data) do
		if tonumber(v) > 0 and tonumber(v) == tonumber(htid) then
			return true
		end
	end
	return false
end

-- add by yucong
--[[desc: 根据modelid 取出图鉴里有的htid
    modelID: 
    heHeroBook: 对方的图鉴，可选参数
    return: 
-—]]
function fnGetBookHtidByModelID( modelID, heHeroBook )
	local haveHtid = 0
	local recomHtid = 0
	local pModelID = tonumber(modelID)
	local data = heHeroBook or DataCache.getHeroBook() or {}
	-- yucong 快速搜索 
	local hashData = {}
	for k, v in pairs(data) do
		hashData[tostring(v)] = 1
	end

	if(not pModelID) then
		return haveHtid
	end
	
	--TimeUtil.timeStart("fnGetBookHtidByModelID_DB_Hero_model_id slow 100ms") -- 2015-06-10
	require "db/DB_Hero_model_id"
	--TimeUtil.timeEnd()
	local pDBModel = DB_Hero_model_id
	local pDB = pDBModel.getDataById(pModelID)
	if(not pDB) then
		return haveHtid
	end
	recomHtid = tonumber(pDB.recommend_htid)
	
	local phtids = string.split(pDB.htids,"|")
	if(table.count(phtids) > 0) then
		local pHeroInfo = nil
		--for pkey,phtid in pairs(data) do
			for k,v in pairs(phtids) do
				local pHtid2 = tonumber(v) or 0
				--if(tonumber(phtid) == pHtid2) then
				if (hashData[tostring(pHtid2)] == 1) then
					haveHtid = pHtid2
					return haveHtid
				end
			end
		--end
	end
	
	if (haveHtid == 0) then
		haveHtid = recomHtid
	end
	return haveHtid
end
--------------yangna 2015.1.34  -----------  script/ui/HeroPublicLua中的方法
--较暗的颜色
local m_QulityColor = g_QulityColor
--较暗的颜色
function getDarkColorByStarLv( nStarLevel )    

	local color = m_QulityColor[nStarLevel]
	if not color then
		color = ccc3(255, 255, 255)
	end
	return color
end

local m_QulityColor2 = g_QulityColor2
--较亮的颜色
function getLightColorByStarLv( nStarLevel )   

	local color = m_QulityColor2[nStarLevel]
	if not color then
		color = ccc3(255, 255, 255)
	end
	return color
end


-- Filename: HeroSortUtil.lua
-- Author: fang
-- Date: 2013-08-30
-- Purpose: 该文件用于: 武将排序(所有有关武将排序的方式都放在这里统一处理)

module("HeroSortUtil", package.seeall)

-- 排序种类
-- 1: 武将界面
m_hero=1
-- 2: 武魂界面
m_heroSoul=2
-- 3: 武将出售界面
m_heroSell=3
-- 4: 选择更换武将界面
m_heroChange=4
-- 5: 武将进阶选择武将界面
m_transferSelectHero=5
-- 6: 武将强化选择武将材料界面
m_strengthenSelectHero=6
-- 7: 强化所武将进阶界面
m_strengthenPlaceTransfer=7
-- 8: 强化所武将强化界面
m_strengthenPlaceStrengthen=8

-- (按战斗力高->低排序)
local function fnCompareWithFightValue(h1, h2)
	return tonumber(h1.fight_value) > tonumber(h2.fight_value)
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
-- 按资质高低排序
local function fnCompareWithQuality(h1, h2)
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

-- 按星级高低排序
local function fnCompareWithStarLevel(h1, h2)
	if h1.star_lv == h2.star_lv then
		return fnCompareWithQuality(h1, h2)
	else
		return h1.star_lv > h2.star_lv
	end
end

-- 按伙伴id大小排序
function fnCompareWithHeroId(h1, h2)
	if (h1 and h2) then
		return tonumber(h1.htid) > tonumber(h2.htid)
	end
end

-- 按是否是小伙伴排序
local function fnCompareWithisExtra(h1, h2)
	if (h1.isExtra and h2.isExtra) then
		return h1.isExtra > h2.isExtra
	end
end

-- 1: 武将界面排序规则
-- 规则. a: 主角优先排第一位，
--		b: 已上阵武将优先显示在最上面(上阵武将再按战斗力排序)，
--		c: 剩下的则根据武将星级高低排序，高的排上，低的排下，
--		d: 若星级相同则根据战斗力高低排序
function fnSortOfHero(heroes)
	local tSortedHeroes = {}
	
	local arrBusyHeroes = {} -- 上阵武将数组
	local arrBenchHeros = {} -- wangming, 2015-01-15, 替补武将数组
	local arrSmallHeros = {} -- zhangjunwu, 2014-11-13, 小伙伴武将数组

	local arrStarLevelHeroes = {} -- 各星级武将数组, 目前只包含最高星级为 10 级
	for i=1, 10 do
		table.insert(arrStarLevelHeroes, {})
	end

	require "script/model/hero/HeroModel"
	for i=1, #heroes do
		local value=heroes[i]
		if value.isBusy then
			table.insert(arrBusyHeroes, value)
		elseif(value.bBench) then --然后是替补 --wangming 2015-01-15
			table.insert(arrBenchHeros, value)
		elseif (value.bSmall) then --然后是小伙伴 --zhangjunwu 2014-11-13
			table.insert(arrSmallHeros, value)
		else -- 其他武将先按星级分类
			local star_lv = value.star_lv
			if (not star_lv or star_lv == 0) then
				star_lv = 1
			end
			table.insert(arrStarLevelHeroes[star_lv], value)
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

	return tSortedHeroes
end

--[[ 影子背包排序, zhangqi, 2015-05-11
第一优先级：未招募且数量足够的>未招募且数量不足的>已招募的影子>不可招募的影子（即is_compose字段填0时） 
第二优先级：品质，品质大的排在前面
第三优先级：数量，数量大的排在前面
第四优先级：id，id小的排在前面
]]
function sortPartnerSoul( item1, item2 )
	if (item1.isRecruited and not item2.isRecruited) then
		return true
	elseif (not item1.isRecruited and item2.isRecruited) then
		return false
	else
		if (item1.expact and not item2.expact) then
			return true
		elseif (not item1.expact and item2.expact) then
			return false
		else
			if (item1.isBuddy and not item2.isBuddy) then
				return true
			elseif (not item1.isBuddy and item2.isBuddy) then
				return false
			else
				if (item1.is_compose == 1 and item2.is_compose == 0) then
					return true
				elseif (item1.is_compose == 0 and item2.is_compose == 1) then
					return false
				else
					if (item1.nStar > item2.nStar) then
						return true
					elseif (item1.nStar == item2.nStar) then
						if (item1.nOwn > item2.nOwn) then
							return true
						elseif (item1.nOwn == item2.nOwn) then
							if (item1.id < item2.id) then
								return true
							else
								return false
							end
						else
							return false
						end
					else
						return false
					end
				end
			end
		end
	end
end

-- zhangqi, 2015-05-12, 得到玩家可合成影子数
function getFuseSoulNum( ... )
	require "db/DB_Item_hero_fragment"
	require "script/model/DataCache"
    local tHeroFrag = DataCache.getHeroFragFromBag()

	local num = 0
	for k, frag in pairs(tHeroFrag or {}) do
		local dbFrag = DB_Item_hero_fragment.getDataById(frag.item_template_id)
		local bHave = HeroModel.isBuddy(dbFrag.aimItem)
		local bRecruited = (tonumber(frag.item_num) >= tonumber(dbFrag.need_part_num) and dbFrag.is_compose == 1)

    	if(not bHave and bRecruited) then
			num = num + 1
    	end
	end
	return num
end
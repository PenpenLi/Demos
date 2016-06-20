-- Filename：	FormationUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-7-18
-- Purpose：		阵型工具

--                   _oo0oo_
--                  o8888888o
--                  88" . "88
--                  (| -_- |)
--                  0\  =  /0
--                ___/`---'\___
--              .' \\|     |-- '.
--             / \\|||  :  |||-- \
--            / _||||| -:- |||||- \
--           |   | \\\  -  --/ |   |
--           | \_|  ''\---/''  |_/ |
--           \  .-\__  '-'  ___/-. /
--         ___'. .'  /--.--\  `. .'___
--      ."" '<  `.___\_<|>_/___.' >' "".
--     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
--     \  \ `_.   \_ __\ /__ _/   .-` /  /
-- =====`-.____`.___ \_____/___.-`___.-'=====
--                   `=---='


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--          佛祖保佑   永无BUG   永不修改

module("FormationUtil", package.seeall)
require "script/utils/LuaUtil"
require "script/model/hero/HeroModel"
require "script/module/partner/HeroPublicUtil"
require "script/model/DataCache"
require "script/model/user/UserModel"
require "db/DB_Union_profit"


local mDB_union = DB_Union_profit
local mUModel = UserModel

--检测竞技场内小伙伴是否上了。
local function isOnLittleFriendBy(htid ,m_litFriInfo)
    local bStatus = false
	local littleFriendInfo = m_litFriInfo

    if table.isEmpty( littleFriendInfo) then
    	return false
    end
	for k, v in pairs(littleFriendInfo) do
		local ehtid = v.htid
		if tonumber(ehtid) > 0 and ehtid == tostring(htid) then
			bStatus=true
			break
		end
	end
    
	return bStatus
end

--检测竞技场内替补是否上了。
local function isOnBenchByHtid(htid ,m_benchInfo)
    local bStatus = false
	local benchInfo = m_benchInfo

    if table.isEmpty( benchInfo) then
    	return false
    end
	for k, v in pairs(benchInfo) do
		local ehtid = 0
		if(v and tonumber(v) ~= 0) then
			ehtid = v.htid
		end
		if tonumber(ehtid) > 0 and ehtid == tostring(htid) then
			bStatus=true
			break
		end
	end
    
	return bStatus
end

-- 通过htid判断阵容中是否存在某一类武将
function isBusyWithHtid(formInfo, allHero, htid)
    local bStatus = false
	-- if not formInfo then
 --    	return false
 --    end
	-- for k, v in pairs(formInfo) do
		for i,hero in pairs(allHero or {}) do
			-- local hid = hero.hid
			-- if tonumber(hid) == tonumber(v) then
				local ehtid = hero.htid
				if tonumber(ehtid) > 0 and tonumber(ehtid) == tonumber(htid) then
					bStatus = true
					break
				end
			-- end
		end
	-- end
    
	return bStatus
end

-- 对于查看别人阵容 专属宝物是否穿戴
function isBattleExclusiveHave( hid, m_externHero,avtiveLel)
    local m_color_normal = ccc3( 0x7f, 0x5f, 0x20)
    local m_color_get = ccc3( 0x01, 0x8a, 0x00)

	local labelColor ,isHave,heroInfo,isActive
	labelColor = m_color_normal
	isHave = false
	isActive = false
	for k,tempHeroInfo in pairs(m_externHero.arrHero) do
		if (tonumber(tempHeroInfo.hid) == tonumber(hid)) then
			local exclusiveInfo = tempHeroInfo.equipInfo.exclusive
			logger:debug({exclusiveInfo = exclusiveInfo})
			if ( exclusiveInfo["1"] and exclusiveInfo["1"].va_item_text) then
				if (tonumber(exclusiveInfo["1"].va_item_text.exclusiveEvolve or 0) >= avtiveLel ) then
					isActive = true
					heroInfo = tempHeroInfo
					labelColor = m_color_get
					isHave = true
					logger:debug("isBattleExclusiveHave")
    				return labelColor,isHave,heroInfo,isActive
				else
					labelColor = m_color_normal
					isHave = true
					isActive = false
    				return labelColor,isHave,heroInfo,isActive
    			end
			end
		end
    end

    for i,tempHeroInfo in pairs(m_externHero.arrBench) do
		if ( tonumber(tempHeroInfo.hid) == tonumber(hid)) then
			local exclusiveInfo = tempHeroInfo.equipInfo.exclusive
			if ( exclusiveInfo["1"] and exclusiveInfo["1"].va_item_text) then
				if (tonumber(exclusiveInfo["1"].va_item_text.exclusiveEvolve or 0)>= avtiveLel ) then
					isActive = true
					heroInfo = tempHeroInfo
					labelColor = m_color_get
					isHave = true
    				return labelColor,isHave,heroInfo,isActive
				else
					labelColor = m_color_normal
					isHave = true
					isActive = false
    				return labelColor,isHave,heroInfo,isActive
    			end
			end
		end
    end
	return labelColor,isHave,heroInfo,isActive
end


--对于竞技场内的伙伴的羁绊开启问题。
function isBattleUnionActive( u_id, hid, curHeroData, m_externHero)
	local t_union_profit = mDB_union.getDataById(u_id)
	local card_ids = string.split(t_union_profit.union_card_ids, ",")
	local pStrings = {}
	local pColors = {}
	local isActive = true
	local bType = 0
    --if m_externHero then
    	-- local benchInfo 	= m_externHero.arrBench
	    -- local litFriInfo    = m_externHero.littleFriend
	    -- local formFriInfo   = m_externHero.squad
	    -- local allHero       = m_externHero.arrHero
	    local heHeroBook    = m_externHero and m_externHero.hero_book or nil

		for k,type_card in pairs(card_ids) do
			local type_card_arr = string.split(type_card, "|")
			bType = tonumber(type_card_arr[1])
			if(tonumber(type_card_arr[1]) == 1)then
				local modelId = tonumber(type_card_arr[2]) or 0
				logger:debug("modelId"..modelId)
				if(modelId == 0)then
					isActive = false
					break
				elseif (HeroModel.getHeroModelId(tonumber(curHeroData.htid)) ~= modelId) then 	-- 不包括伙伴自身
					local pHaveHtid = tonumber(HeroPublicUtil.fnGetBookHtidByModelID(modelId, heHeroBook)) or 0--tonumber(HeroModel.fnGetHaveHtidByModelID(pValue)) or 0
					local pStr = ""
					local pData = HeroUtil.getHeroLocalInfoByHtid(pHaveHtid)
					if(pData) then
						pStr = pData.name or ""
					end
					table.insert(pStrings,pStr)
					--yucong 羁绊修改
					-- if(not (isBusyWithHtid(formFriInfo, allHero, pHaveHtid))
					--  and (not isOnLittleFriendBy(pHaveHtid,litFriInfo)) 
					--  and (not isOnBenchByHtid(pHaveHtid,benchInfo)) 
					--  ) then
					--print(pValue)
					--print("htid:%s", pHaveHtid)
					if (not HeroPublicUtil.isHeroOnceHaveWithHtid(pHaveHtid, heHeroBook)) then
				    	isActive = false
						table.insert(pColors,false)
					else
						table.insert(pColors,true)
					end
				end
			elseif(tonumber(type_card_arr[1]) == 2)then
				isActive = false
				local itemType = ItemUtil.getItemTypeByTid(tonumber(type_card_arr[2]))
				if (itemType.isTreasure) then
					bType = 2
				elseif (itemType.isArm) then
					bType = 3
				end
				if(curHeroData.equipInfo) then
					for k,v in pairs(curHeroData.equipInfo.treasure or {}) do
						-- 宝物
						if( not table.isEmpty(v)) then
							if(tonumber(v.item_template_id) ==tonumber(type_card_arr[2]) )then
								isActive = true
								break
							end
						end
					end
				end
				if(isActive == false)then
					-- 装备

					if(curHeroData.equipInfo) then
						for k,v in pairs(curHeroData.equipInfo.arming or {}) do
							if( not table.isEmpty(v)) then
								if(tonumber(v.item_template_id) ==tonumber(type_card_arr[2]) )then
									isActive = true
									break
								end
							end
						end
					end
				end

				if(isActive == false) then
					break
				end
			end
		end

		-- if(isActive == true and t_union_profit.union_arribute_starlv)then
		-- 	local starLvArr = string.split(t_union_profit.union_arribute_starlv, "|")
		-- 	local starInfo = StarUtil.getStarInfoBySid(starLvArr[1])
		-- 	if(tonumber(starInfo.level) < tonumber(starLvArr[2]) ) then
		-- 		isActive = false
		-- 	end
		-- end

 	-- else
 	-- 	isActive = false
 	-- 	for k,type_card in pairs(card_ids) do
 	-- 		local type_card_arr = string.split(type_card, "|")
		-- 	if(tonumber(type_card_arr[1]) == 1)then
		-- 		local modelId = tonumber(type_card_arr[2]) or 0
		-- 		if(modelId ~= 0 and HeroModel.getHeroModelId(tonumber(curHeroData.htid)) ~= modelId)then
		-- 			local pStr = ""
		-- 			local pHaveHtid = tonumber(HeroModel.fnGetHaveHtidByModelID(modelId)) or 0
		-- 			local pData = HeroUtil.getHeroLocalInfoByHtid(pHaveHtid)
		-- 			if(pData) then
		-- 				pStr = pData.name or ""
		-- 			end
		-- 			table.insert(pStrings,pStr)
		-- 			table.insert(pColors,false)
		-- 		end
		-- 	end
		-- end
 	-- end

 	if (bType == 1) then
		if (isActive) then
			isActive = BondData.isBondOpen(tonumber(curHeroData.htid), u_id, true)
		end
	end

	return isActive , pStrings , pColors
end

--[[desc:根据hid的table获取总羁绊数量和激活的羁绊数
    arg1: hid的table
    return: 总羁绊数，激活羁绊数  
—]]
local function fnGetUnionActiveNumByHidTable( pTable )
	if(not pTable or table.isEmpty(pTable)) then
		return 0 , 0
	end
	local p_TotleNum = 0
	local p_ActiveNum = 0
	
	for key,v_hid in pairs(pTable) do
		if(v_hid and tonumber(v_hid) ~= 0) then
			local pHero = HeroModel.getHeroByHid(v_hid)
			if(pHero) then
				local p_DBhero = DB_Heroes.getDataById(pHero.htid)
				if(p_DBhero and p_DBhero.link_group1) then
					local linkGroupArr = lua_string_split(p_DBhero.link_group1, ",") or {}
					p_TotleNum = p_TotleNum + table.count(linkGroupArr)
					for i,v in ipairs(linkGroupArr or {}) do
						local openUnion = FormationUtil.isUnionActive(v, v_hid)
						if(openUnion) then
							p_ActiveNum = p_ActiveNum + 1
						end
					end
				end
			end
		end
	end
	return p_TotleNum , p_ActiveNum
end

--[[desc:获取阵容、替补的总羁绊数和当前激活羁绊数
    arg1: 参数说明
    return: 总羁绊数，激活羁绊数  
—]]
function fnGetUnionActiveNum()
	local p_TotleNum = 0 --总羁绊数
	local p_ActiveNum = 0 --激活羁绊数

	local pSquad = DataCache.getSquad()
	local pT1, pA1 = fnGetUnionActiveNumByHidTable(pSquad)

	local pBench = DataCache.getBench()
	local pT2 , pA2 = fnGetUnionActiveNumByHidTable(pBench)
	p_TotleNum = pT1 + pT2
	p_ActiveNum = pA1 + pA2
	return p_TotleNum,p_ActiveNum
end

-- 某个羁绊技能是否开启
-- hid: 如果为nil，使用htid
-- htid: 可选 
function isUnionActive( u_id, hid, htid )
	-- logger:debug("isUnionActive")
	-- logger:debug("hid:")
	-- logger:debug(hid)
	-- logger:debug("htid:")
	-- logger:debug(htid)

	local isActive = true
	local pStrings = {}
	local pColors = {}
	local tModels = {}
	local bType = 0
	local nTreasureId = 0

	local t_union_profit = mDB_union.getDataById(u_id)
	local curHeroData = nil
	if(hid and tonumber(hid) ~= 0) then
		htid = HeroModel.getHtidByHid(hid)
		curHeroData = HeroUtil.getHeroInfoByHid(hid)
	end
	--开启羁绊需要的modelId  类型|modelId,...
	local card_ids = string.split(t_union_profit.union_card_ids, ",")

	for k,type_card in pairs(card_ids) do
		local type_card_arr = string.split(type_card, "|")
		bType = tonumber(type_card_arr[1])
		if(tonumber(type_card_arr[1]) == 1)then
			local modelId = tonumber(type_card_arr[2]) or 0
			local pHaveHtid = 0
			local isOwn = false
			if(modelId == 0)then
				isActive = false
				break
			elseif (HeroModel.getHeroModelId(htid) ~= modelId) then 	-- 不包括伙伴自身
				local pStr = ""
				pHaveHtid = tonumber(HeroPublicUtil.fnGetBookHtidByModelID(modelId)) or 0--tonumber(HeroModel.fnGetHaveHtidByModelID(modelId)) or 0--
				--print("yc==ModelID:"..tostring(modelId).."图鉴中的实际ID:"..tostring(pHaveHtid))
				local pData = HeroUtil.getHeroLocalInfoByHtid(pHaveHtid)
				if(pData) then
					pStr = pData.name or ""
				end
				
				table.insert(pStrings,pStr)
				-- yucong 羁绊判断修改
				--if(not curHeroData or not (HeroPublicUtil.isHeroBusyByHtid(pHaveHtid)) ) then

				if (not curHeroData and htid) then
					curHeroData = DB_Heroes.getDataById(tonumber(htid))     ---卡获得碎片情况下，只得到htid
				end
				isOwn = HeroPublicUtil.isHeroOnceHaveWithHtid(pHaveHtid)
				if(not curHeroData or not isOwn ) then
					--print("yc==羁绊不满足 "..t_union_profit.union_arribute_name)
					isActive = false
					table.insert(pColors,false)
				else
					--print("yc==羁绊满足 "..t_union_profit.union_arribute_name) recommend_htid
					table.insert(pColors,true)
				end
				-- 保存需求的modelId，不包括自己
				table.insert(tModels, {tonumber(modelId), isOwn})
			end
		elseif(tonumber(type_card_arr[1]) == 2)then
			isActive = false
			nTreasureId = tonumber(type_card_arr[2])
			local itemType = ItemUtil.getItemTypeByTid(nTreasureId)
			if (itemType.isTreasure) then
				bType = 2
			elseif (itemType.isArm) then
				bType = 3
			end
			if(curHeroData) then
				for k,v in pairs(curHeroData.equip.treasure) do
					-- 宝物
					if( not table.isEmpty(v)) then
						if(tonumber(v.item_template_id) ==tonumber(type_card_arr[2]) )then
							isActive = true
							break
						end
					end
				end
				if(isActive == false)then
					-- 装备
					for k,v in pairs(curHeroData.equip.arming) do
						if( not table.isEmpty(v)) then
							if(tonumber(v.item_template_id) ==tonumber(type_card_arr[2]) )then
								isActive = true
								break
							end
						end
					end
				end

				if(isActive == false) then
					break
				end
			else
				isActive = false
			end
		end
	end

	-- if(isActive == true and t_union_profit.union_arribute_starlv)then
	-- 	local starLvArr = string.split(t_union_profit.union_arribute_starlv, "|")
	-- 	local starInfo = StarUtil.getStarInfoBySid(starLvArr[1])
	-- 	if(tonumber(starInfo.level) < tonumber(starLvArr[2]) ) then
	-- 		isActive = false
	-- 	end
	-- end
	local state = BondManager.BOND_NOT_REACHED	-- 未达成
	if (bType == 1) then
		if (isActive) then
			isActive = BondData.isBondOpen(htid, u_id)
			if (isActive) then
				state = BondManager.BOND_OPEN	-- 已激活
			else
				state = BondManager.BOND_REACHED 	-- 可激活
			end
		end
	elseif (bType == 2 or bType == 3) then
		if (isActive) then
			state = BondManager.BOND_OPEN
		end 
	end

	local tBond = {}
	tBond["models"] = tModels
	tBond["state"] = state
	tBond["type"] = bType
	tBond["treaId"] = nTreasureId
	logger:debug({tBond = tBond})
	return isActive , pStrings , pColors, tBond
end


-- 当前阵型开启的位置个数
function getFormationOpenedNum()
	return getFormationOpenedNumByLevel(mUModel.getHeroLevel())
end

-- 阵型等级开启的位置个数
function getFormationOpenedNumByLevel(level)
	level = tonumber(level)
	require "db/DB_Formation"
	local f_data = DB_Formation.getDataById(1)
	local userInfo = mUModel.getUserInfo()
	-- local f_open_levels = lua_string_split(f_data.openPositionLv, ",")
	-- local open_num = 0
	-- -- 计算开启了几个位置
	-- for k, openLv in pairs(f_open_levels) do
	-- 	if(tonumber(userInfo.level) >= tonumber(openLv)) then
	-- 		open_num = open_num + 1
	-- 	end
	-- end
	local f_open_levels_str = lua_string_split(f_data.openNumByLv, ",")
	local f_open_levels = {}
	local open_num = 0
	for k,v in pairs(f_open_levels_str) do
		local temp_t = lua_string_split(v, "|")
		if( tonumber(temp_t[1])<= level )then
			if( open_num < tonumber(temp_t[2]) )then
				open_num = tonumber(temp_t[2])
			end
		end
	end
	return open_num
end

-- 某个位置是否开启 m_pos：start with 0
function isOpenedByPosition( m_pos )
	m_pos = tonumber(m_pos)
	require "db/DB_Formation"
	local f_data = DB_Formation.getDataById(1)

	local f_open_nums = lua_string_split(f_data.openSort, ",")
	local f_open_levels = lua_string_split(f_data.openPositionLv, ",")
	local open_num = 0
	local userInfo = mUModel.getUserInfo()
	local curIndx = 0
	for k, v_pos in pairs(f_open_nums) do
		if(tonumber(v_pos) == m_pos) then
			curIndx = k
			break
		end
	end
	return tonumber(userInfo.level) >= tonumber(f_open_levels[curIndx])
end

-- 获得某个位置的开启等级
function getOpenLevelByPosition( m_pos )
	assert(m_pos)
	m_pos = tonumber(m_pos)
	require "db/DB_Formation"
	local f_data = DB_Formation.getDataById(1)

	local f_open_nums = lua_string_split(f_data.openSort, ",")
	local f_open_levels = lua_string_split(f_data.openPositionLv, ",")
	local open_num = 0

	local userInfo = mUModel.getUserInfo()
	local curIndx = 0
	for k, v_pos in pairs(f_open_nums) do
		-- print(v_pos, "   ", m_pos)
		if( tonumber( v_pos) == tonumber(m_pos) )then
			curIndx = k
			break
		end
	end

	return tonumber(f_open_levels[curIndx])
end

-- 下一个上阵个数的开启等级
function nextOpendFormationNumAndLevel()
	
	require "db/DB_Formation"
	local f_data = DB_Formation.getDataById(1)
	local userInfo = mUModel.getUserInfo()

	local f_open_levels_str = lua_string_split(f_data.openNumByLv, ",")
	local f_open_levels = {}
	local nextLevel = 999
	for k,v in pairs(f_open_levels_str) do
		local temp_t = lua_string_split(v, "|")
		if( tonumber(temp_t[1])> mUModel.getHeroLevel() )then
			if(nextLevel > tonumber(temp_t[1]))then
				nextLevel = tonumber(temp_t[1])
			end
		end
	end

	return nextLevel
end

-- 下一个阵型开启的位置和等级
function nextOpendPosAndLevel()
	local opendNum = getFormationOpenedNum()

	require "db/DB_Formation"
	local f_data = DB_Formation.getDataById(1)
	
	local f_open_nums = lua_string_split(f_data.openSort, ",")
	local f_open_levels = lua_string_split(f_data.openPositionLv, ",")
	local nextPos = f_open_nums[opendNum+1]
	local nextLevel = f_open_levels[opendNum+1]
	return nextPos, nextLevel
end

-- 当前的上阵和能上阵的  返回值 number/number <==> 上阵将领个数/最大上阵个数
function getOnFormationAndLimited()
	local formationInfo = DataCache.getFormationInfo()
	local onNum = 0
	if(not table.isEmpty(formationInfo)) then
		for k,v in pairs(formationInfo) do
			if(tonumber(v)>0)then
				onNum = onNum +1
			end
		end
	end

	return onNum, getFormationOpenedNum()
end

-- 是否有相同将领已经上阵已经上阵
function isHadSameTemplateOnFormation(h_id)
	local isOn = false
	h_id = tonumber(h_id)
	local heroInfo = HeroUtil.getHeroInfoByHid(h_id)
	local formationInfo = DataCache.getFormationInfo()
	local onNum = 0
	for k,v in pairs(formationInfo) do
		if(tonumber(v)>0)then
			local t_heroInfo = HeroUtil.getHeroInfoByHid(v)
			if(t_heroInfo.htid == heroInfo.htid)then
				isOn = true
				break
			end
		end
	end
	return isOn
end


-- 计算其他阵容武将的连携
function parseOtherHeroUnionProfit( cur_Hid, link_group ,heroInfo ,externHero)
	local s_link_arr = string.split(link_group, ",")
	local t_link_infos = {}
	for k, link_id in pairs(s_link_arr) do
		logger:debug("parseOtherHeroUnionProfit begin")
		local t_union_profit = mDB_union.getDataById(link_id)
		logger:debug("parseOtherHeroUnionProfit end")
		local link_info = {}
		link_info.dbInfo = t_union_profit
		link_info.isActive , link_info.showNames , link_info.showColors= isBattleUnionActive(link_id, cur_Hid, heroInfo ,externHero)

		table.insert(t_link_infos, link_info)
	end

	return t_link_infos
end
-- 计算武将的连携
function parseHeroUnionProfit( cur_Hid, link_group )
	local s_link_arr = string.split(link_group, ",")
	local t_link_infos = {}
	for k, link_id in pairs(s_link_arr) do
		local t_union_profit = mDB_union.getDataById(link_id)
		local link_info = {}
		link_info.dbInfo = t_union_profit
		link_info.isActive , link_info.showNames , link_info.showColors = FormationUtil.isUnionActive( link_id, cur_Hid )


		table.insert(t_link_infos, link_info)
	end

	return t_link_infos
end


-- 空岛贝格子是否开启
function isConchOpenByPos( posIndex )
	require "db/DB_Normal_config"
	local dbInfo = DB_Normal_config.getDataById(1)
	posIndex = tonumber(posIndex)
	local openLvArr = string.split(dbInfo.conchOpenLevel, ",")
	local isOpen = false
	local openLv = tonumber(openLvArr[posIndex]) or 0
	local userLv = tonumber(mUModel.getHeroLevel()) or 1
	if( userLv >= openLv )then
		isOpen = true
	else
		isOpen = false
	end

	return isOpen, openLv
end

--得到别的阵容的宝物和空岛贝开放的位置
function getOtherTreasureAndConchOpenPos(level)
    local conchOpenPos = 0
    local treaOpenPos = 0

    local userLevel = tonumber(level) or 1

    --计算空岛贝显示问题
    require "db/DB_Normal_config"
    local conchOpenByLv = DB_Normal_config.getDataById(1).conchOpenLevel
    local splitConchArr = lua_string_split(conchOpenByLv, ",")
    local pI = 0
    local openFightLv = 0
    for i,v in ipairs(splitConchArr) do
		openFightLv = tonumber(v) or 0
        if(userLevel >= openFightLv) then
        	pI = tonumber(i) or 1
            if(conchOpenPos < pI) then
                conchOpenPos = pI
            end
        end
    end
    --计算宝物显示的问题
    local treasureOpenByLv = DB_Normal_config.getDataById(1).treasureOpenLevel
    local splitTreasureArr = lua_string_split(treasureOpenByLv, ",")
    local openTreaLv = 0
    for i,v in ipairs(splitTreasureArr) do
        local openTreaLv = tonumber(v) or 0
        if(userLevel >= openTreaLv) then
        	pI = tonumber(i) or 1
            if(treaOpenPos < pI) then
                treaOpenPos = pI
            end
        end
    end

    return conchOpenPos, treaOpenPos
end

--得到阵型上宝物的信息,返回按照位置来确定的宝物开启的等级
function getTreasureOpenLvInfo( ... )
    require "db/DB_Normal_config"
    --计算宝物显示的问题
    local treasureOpenByLv = DB_Normal_config.getDataById(1).treasureOpenLevel
    local splitTreasureArr = lua_string_split(treasureOpenByLv, ",")
    return splitTreasureArr
end

function getConchOpenPos( ... )
	local conchOpenPos = 0
	local userLevel = tonumber(mUModel.getHeroLevel()) or 1
	require "db/DB_Normal_config"
    local conchOpenByLv = DB_Normal_config.getDataById(1).conchOpenLevel
    local splitConchArr = lua_string_split(conchOpenByLv, ",")
    local openFightLv = 0
    local pI = 0
    for i,v in ipairs(splitConchArr) do
		openFightLv = tonumber(v) or 0
        if(userLevel >= openFightLv) then
        	pI = tonumber(i)
            if(conchOpenPos < pI) then
                conchOpenPos = pI
            end
        end
    end
    logger:debug("wm----conchOpenPos : " .. tostring(conchOpenPos))
    return conchOpenPos
end

--得到宝物和空岛贝开放的位置。
function getTreasureAndConchOpenPos()
    local conchOpenPos = 0
    local treaOpenPos = 0

    --计算空岛贝显示问题
    conchOpenPos = getConchOpenPos()
    --计算宝物显示的问题
    local userLevel = tonumber(mUModel.getHeroLevel()) or 1
    local treasureOpenByLv = DB_Normal_config.getDataById(1).treasureOpenLevel
    local splitTreasureArr = lua_string_split(treasureOpenByLv, ",")
    local openTreaLv = 0
    for i,v in ipairs(splitTreasureArr) do
		openTreaLv = tonumber(v) or 0
        if(userLevel >= openTreaLv) then
        	pI = tonumber(i)
            if(treaOpenPos < pI) then
                treaOpenPos = pI
            end
        end
    end

    return conchOpenPos, treaOpenPos
end
--得到另外一个人的位置信息
-- function fnGetOtherFormationPos(level)
--     local heroOpenForm = 1
--     local litHeroOpenPos = 0

--     local userLevel = level
--     --取出的值，目前固定为1.策划立誓说不会改，坐等他反悔。

--     require "db/DB_Formation"
--     local openFormByLv = DB_Formation.getDataById(1).openNumByLv

--     local splitData_FormLv = lua_string_split(openFormByLv, ",")

--     --阵容的英雄位置
--     for i,v in ipairs(splitData_FormLv) do
--         -- print(i,v)
--         local openLv = lua_string_split(v,"|")[1]
--         --如果比当前等级高就可以把该等级的位置给开启了
--         if (tonumber(userLevel) >= tonumber(openLv)) then
--             --得到当前的开放的位置。
--             local openPos = lua_string_split(v,"|")[2]

--             --在得到的网络数据中选择显示(将数据记录下来，用来判断究竟显示什么样的数据。)
--             if (tonumber(openPos) > tonumber(heroOpenForm)) then
--                 heroOpenForm = openPos
--             end
--         end
--     end
--     -- 阵容中小伙伴的位置
--     local openFriendByLv = DB_Formation.getDataById(1).openFriendByLv
--     local splitOpenFriend = lua_string_split(openFriendByLv, ",")
--     logger:debug("wm----splitOpenFriend : " .. userLevel)
--     for i,v in ipairs(splitOpenFriend) do
--         local openLv = lua_string_split(v ,"|")[1]
--         if(tonumber(userLevel) >= tonumber(openLv)) then
--             local openPos = lua_string_split(v , "|")[2]
--             if(tonumber(openPos)>tonumber(litHeroOpenPos)) then
--                 litHeroOpenPos = openPos
--             end
--         end
--     end

--     return heroOpenForm,litHeroOpenPos
-- end
--得到阵容的位置数(根据表中的数据来确定已经开放的位置数)
function fnGetFormationPos(level)
    local heroOpenForm = 1
    -- local litHeroOpenPos = 0

    local userLevel = level or mUModel.getHeroLevel()

    --取出的值，目前固定为1.策划立誓说不会改，坐等他反悔。

    require "db/DB_Formation"
    local openFormByLv = DB_Formation.getDataById(1).openNumByLv
    local splitData_FormLv = lua_string_split(openFormByLv, ",")

    -- 阵容的英雄位置
    for i,v in ipairs(splitData_FormLv) do
        -- print(i,v)
        local openLv = lua_string_split(v,"|")[1]
        --如果比当前等级高就可以把该等级的位置给开启了
        if (tonumber(userLevel) >= tonumber(openLv)) then
            --得到当前的开放的位置。
            local openPos = lua_string_split(v,"|")[2]

            --在得到的网络数据中选择显示(将数据记录下来，用来判断究竟显示什么样的数据。)
            if (tonumber(openPos) > tonumber(heroOpenForm)) then
                heroOpenForm = openPos
            end
        end
    end
    -- -- 阵容中小伙伴的位置
    -- local openFriendByLv = DB_Formation.getDataById(1).openFriendByLv
    -- local splitOpenFriend = lua_string_split(openFriendByLv, ",")

    -- for i,v in ipairs(splitOpenFriend) do
    --     local openLv = lua_string_split(v ,"|")[1]
    --     if(tonumber(userLevel) >= tonumber(openLv)) then
    --         local openPos = lua_string_split(v , "|")[2]
    --         if(tonumber(openPos)>tonumber(litHeroOpenPos)) then
    --             litHeroOpenPos = openPos
    --         end
    --     end
    -- end

    return heroOpenForm
    -- , litHeroOpenPos
end

function getFormationPosLevel( formationOpen )
    require "db/DB_Formation"
    local openFormByLv = DB_Formation.getDataById(1).openNumByLv
    local splitData_FormLv = lua_string_split(openFormByLv, ",")
    local openPos = lua_string_split(splitData_FormLv[tonumber(formationOpen)-1] , "|")[1]
    return openPos
end


-- 当前阵型开启的位置(注意阵型索引值域:[0,5])
function currentOpendPositions()
	require("db/DB_Formation")
	local f_data = DB_Formation.getDataById(1)
	assert(f_data,"未找到阵型1的数据")
	local f_open_slots = lua_string_split(f_data.openSort, ",")
	local f_open_levels = lua_string_split(f_data.openPositionLv, ",")
	local result = {}

	local userInfo = mUModel.getUserInfo()
	local level  = tonumber(userInfo.level)
	
	for i=1,6 do
		if(level >= tonumber(f_open_levels[i])) then
	 		table.insert(result,tonumber(f_open_slots[i]))
		end
	end
 	
 	return result
end

--根据hid获取专属宝物和羁绊宝物
function fnGetOnlyAndUniconTrea( sq_hid )
	local mOnlyID = 0
	local mUniconID = {}
	if(not sq_hid or tonumber(sq_hid) <= 0) then
		return mOnlyID, mUniconID
	end
	local pHero = HeroUtil.getHeroInfoByHid(sq_hid)
	
	if(pHero and pHero.localInfo) then
		local pTreaID = pHero.localInfo.treaureId or ""
		local pInfoID = lua_string_split(pTreaID,"|")
		mOnlyID = tonumber(pInfoID[1]) or 0
		local pLink = pHero.localInfo.link_group1
		-- ex. 151,152,153,164,154,155
		if(pLink) then
			local linkGroupArr = string.split(pLink, ",") or {}
			for i,v in ipairs(linkGroupArr) do
				local t_union_profit = mDB_union.getDataById(v)
				
				local card_ids = string.split(t_union_profit.union_card_ids, ",")
				for k,type_card in pairs(card_ids) do
					local type_card_arr = string.split(type_card, "|")
					if(tonumber(type_card_arr[1]) == 2)then
						mUniconID[i] = type_card_arr[2] or 0
					end
				end
			end
		end
	end
	return mOnlyID, mUniconID
end

function getNewEffect( ... )
	local newEffect = UIHelper.createArmatureNode({
		filePath = "images/effect/newhero/new.ExportJson",
		animationName = "new",
	})
	--newEffect:setAnchorPoint(widgetMain.IMG_CAN_ACTIVATE:getAnchorPoint())
	--newEffect:setPosition(ccp(widgetMain.IMG_CAN_ACTIVATE:getPositionX(), widgetMain.IMG_CAN_ACTIVATE:getPositionY()))
	--widgetMain.img_jiban_paper:addNode(newEffect)
	return newEffect
end
-- "可激活"特效
function getActiveEffect( ... )
	local activeEffect = UIHelper.createArmatureNode({
		filePath = "images/effect/formation/can_activate.ExportJson",
		animationName = "can_activate",
	})
	return activeEffect
end
-- "可进阶"特效
function getTransEffect( ... )
	local activeEffect = UIHelper.createArmatureNode({
		filePath = "images/effect/formation/canTrans/can_activate.ExportJson",
		animationName = "can_activate",
	})
	return activeEffect
end

-- 强化大师按钮特效
function getGuruEffect( ... )
	local guruEffect = UIHelper.createArmatureNode({
		filePath = "images/effect/formation/str_guru.ExportJson",
		animationName = "str_guru",
	})
	return guruEffect
end

function getGuruPopAction( widget )
	local actions = CCArray:create()
	actions:addObject(CCScaleTo:create(0, 0, 0))
	actions:addObject(CCCallFunc:create(function ( ... )
		widget:setVisible(true)
		widget:setTouchEnabled(true)
	end))
	actions:addObject(CCScaleTo:create(6/60, 100/100, 5/100))
	actions:addObject(CCScaleTo:create(10/60, 100/100, 100/100))
	actions:addObject(CCCallFunc:create(function ( ... )
		
	end))
	return CCSequence:create(actions)
end

function getGuruPushAction( widget )
	local actions = CCArray:create()
	actions:addObject(CCScaleTo:create(0, 100/100, 100/100))
	actions:addObject(CCScaleTo:create(6/60, 100/100, 105/100))
	actions:addObject(CCScaleTo:create(10/60, 100/100, 5/100))
	actions:addObject(CCScaleTo:create(4/60, 0, 0))
	actions:addObject(CCCallFunc:create(function ( ... )
		widget:setVisible(false)
		widget:setTouchEnabled(false)
	end))
	return CCSequence:create(actions)
end
-- FileName: SpecTreaModel.lua
-- Author: sunyunpeng
-- Date: 2015-09-16
-- Purpose: function description of module
--[[TODO List]]

module("SpecTreaModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local numTreaProperty = 5
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["SpecTreaModel"] = nil
end

function moduleName()
    return "SpecTreaModel"
end

function create(...)

end


--获取专属宝物属性
-- return {
--			 {name - 属性名字   value - 数值   refineLevel - 精炼等级} 
--			  ...
--		  }	

function fnGetTreaProperty( tid,refineLevel )
	local tbBasePro = {}
	require "db/DB_Affix"
	local treasData = DB_Item_exclusive.getDataById(tid)

	local baseAtrr = lua_string_split(treasData.base_attr, ",")

	local evolveAwakeTb = {}
	for i=1,20 do
		if (not treasData["awaken" .. i]) then
			break
		end
		table.insert(evolveAwakeTb,treasData["awaken" .. i])
	end


	for i=1,#baseAtrr do
		local tbProperty = {}
		local baseDB = lua_string_split(baseAtrr[i], "|")
		local valueNum = baseDB[2]

		if (refineLevel and refineLevel > 0) then
			for j=1,refineLevel do
				local tbProperty = {}
				local increaAtrr =  lua_string_split(treasData["increase_attr" .. j], ",")
				local increaseDB = lua_string_split(increaAtrr[i], "|")
				valueNum = valueNum + increaseDB[2]
			end
		end
		local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(baseDB[1]),valueNum)
		tbProperty.name = baseInfo.displayName
		tbProperty.value = displayNum
		tbProperty.realNum = realNum
		tbProperty.numType = tonumber(baseDB[1])
		tbProperty.refineLevel = refineLevel
		-- 进阶能力
		for _,evolveAwake in ipairs(evolveAwakeTb) do
			local evolveTb = string.split(evolveAwake, ",")
			for i,v in ipairs(evolveTb) do
				local awakeItems = string.split(v, "|")
				if ((refineLevel >= tonumber(awakeItems[1]))) then
					if (tonumber(awakeItems[2]) == tbProperty.numType)then
						displayNum = displayNum + tonumber(awakeItems[3])
					end
				end
			end
		end
		tbProperty.value = displayNum
		table.insert(tbBasePro,tbProperty)
	end
	logger:debug({tbBasePro=tbBasePro})
	return tbBasePro
end


--获取专属宝物进阶属性
-- return {
--			 {name - 属性名字   value - 数值   refineLevel - 精炼等级} 
--			  ...
--		  }	

function fnGetTreaAdvanceProperty( tid,refineLevel )
	local tbBasePro = {}
	require "db/DB_Affix"
	local treasData = DB_Item_exclusive.getDataById(tid)

	local baseAtrr = lua_string_split(treasData.base_attr, ",")

	local baseAtts = string.split(treasData.base_attr, ",")
	for i=1,#baseAtrr do
		local tbProperty = {}
		local baseDB = lua_string_split(baseAtrr[i], "|")
		local valueNum = 0

		if (refineLevel and refineLevel > 0) then
			for j=1,refineLevel do
				local tbProperty = {}
				local increaAtrr =  lua_string_split(treasData["increase_attr" .. j], ",")
				local increaseDB = lua_string_split(increaAtrr[i], "|")
				valueNum = valueNum + increaseDB[2]
			end
		end
		local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(baseDB[1]),valueNum)
		tbProperty.name = baseInfo.displayName
		tbProperty.realNum = realNum
		tbProperty.numType = tonumber(baseDB[1])
		tbProperty.refineLevel = refineLevel

		tbProperty.value = displayNum
		table.insert(tbBasePro,tbProperty)
	end

	return tbBasePro
end


-- 获取专属宝物进阶等级相关觉醒数据
-- return {
--            {
--				awakenAttr = { 
--						  		 { name - 觉醒属性名    value - 觉醒数值  refineLevelLimit - 解锁等级}
--                                ...
--						 	 }	
--         		refineLevelLimit  	                -- 解锁等级
--		   		info                                -- 觉醒描述 
--		  		}
--             ...
--		  }
function fnGetTreaAwakenInfo( tid)
	local tbAwakenInfo = {}
	local awakenNum = 20
	require "db/DB_Affix"
	local treasData = DB_Item_exclusive.getDataById(tid)
	for i=1,awakenNum do
		local tbAwaken = {}
		local awakenAttr = {}
		if (not treasData["awaken" .. i]) then
			break
		end
		local awkenItemDB = lua_string_split(treasData["awaken" .. i], ",")
		for i,v in ipairs(awkenItemDB) do
			local awkenAttrItem = {}
			local wakenItem = lua_string_split(v, "|")
			local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(wakenItem[2]),wakenItem[3])
			awkenAttrItem.name = baseInfo.displayName
			awkenAttrItem.value = displayNum
			awkenAttrItem.refineLevelLimit = wakenItem[1]
			table.insert(awakenAttr,awkenAttrItem)
		end
		tbAwaken.awakenAttr = awakenAttr
		tbAwaken.refineLevelLimit = awakenAttr[1].refineLevelLimit
		tbAwaken.info = treasData["awakeninfo" .. i]
		table.insert(tbAwakenInfo,tbAwaken)
	end

	return tbAwakenInfo
end

-- 获取对应精炼等级解锁的 觉醒数据信息(1)
function fnGetTreaAwakByRefineLel( tid,refineLevel )
	local allWaken = fnGetTreaAwakenInfo(tid)
	local awakeninfo = {}

	for i,v in ipairs(allWaken) do
		local tempAwakeninfo = v
		local awakenIndex = i
		local awakeName = m_i18nString(6943,awakenIndex) 

		if (tonumber(refineLevel) <= tonumber(v.refineLevelLimit)) then
			awakeninfo = v.info
			local refineLevelLimit = v.refineLevelLimit
			return awakeninfo,refineLevelLimit,awakeName
		end
		if (tonumber(refineLevel) > tonumber(allWaken[#allWaken].refineLevelLimit))then
			local refineLevelLimit = allWaken[#allWaken].refineLevelLimit
			awakeninfo = allWaken[#allWaken].info
			return awakeninfo,refineLevelLimit,awakeName
		end

	end
	return nil
end


-- 获取对应精炼等级解锁的 觉醒数据信息(2) 英雄相关解锁
function getSpecAwakeForOnHero( item_id )
	local wakeForHero = {}
	-- local awakenIndex = 1
	local awakeForHero = getAllAwakeForHero(item_id)
	for i,showAwakeInfo in ipairs(awakeForHero) do
		logger:debug({getSpecAwakeForOnHero = showAwakeInfo})
		local isOnHero = showAwakeInfo.isOnHero 

		if (isOnHero ) then
			local tbAwaken = {}
			local showHeroId = showAwakeInfo.showHeroId 
			local showAwakeId = showAwakeInfo.showAwakeId 

			local showHeroDB = DB_Heroes.getDataById(showHeroId)
			if (showAwakeId and tonumber(showAwakeId) ~= 0) then
				local showAwakeDB = DB_Awake_ability.getDataById(showAwakeId)
				local awakeName = showAwakeDB.name
				local treaureId = showHeroDB.treaureId
				local refineLevelLimit = tonumber(lua_string_split(treaureId,"|")[3])
				-- if (tonumber(refineLevel) <= tonumber(refineLevelLimit)) then
				local info = showAwakeDB.des_cut or ""
				tbAwaken.refineLevelLimit = refineLevelLimit
				tbAwaken.info = info
				tbAwaken.awakeName = awakeName
				table.insert(wakeForHero,tbAwaken)
				-- awakenIndex = awakenIndex + 1
				-- return info,refineLevelLimit,1
				-- end
				-- if (tonumber(refineLevel) > tonumber(refineLevelLimit)) then
				-- 	local info = showAwakeDB.des_cut or ""
				-- 	tbAwaken.refineLevelLimit = refineLevelLimit
				-- 	tbAwaken.info = info
				-- 	return info,refineLevelLimit,1
			end

			-- else
			-- 	return nil
			-- end
		end
	end

	return wakeForHero
end



-- 获取所有技能和天赋
function getAllSkill( tid, item_id,refineLevel)
	local allSkills = {}
	local allWaken = fnGetTreaAwakenInfo(tid)
	local awakeForHero = getSpecAwakeForOnHero(item_id)

	for i,showAwakeInfo in ipairs(allWaken) do
		showAwakeInfo.awakeName = m_i18nString(6943,i) 
		table.insert(allSkills,showAwakeInfo)
	end

	for i,showAwakeInfo in ipairs(awakeForHero) do
		table.insert(allSkills,showAwakeInfo)
	end

	table.sort(
     		    allSkills, function (a,b) return tonumber(a.refineLevelLimit) < tonumber(b.refineLevelLimit) end
    		  )

	for i,v in ipairs(allSkills) do
		if (tonumber(refineLevel) <= tonumber(v.refineLevelLimit)) then
			awakeninfo = v.info
			local refineLevelLimit = v.refineLevelLimit
			local awakeName = v.awakeName 
			return awakeninfo,refineLevelLimit,awakeName
		end
		if (tonumber(refineLevel) > tonumber(allWaken[#allWaken].refineLevelLimit))then
			local refineLevelLimit = allWaken[#allWaken].refineLevelLimit
			awakeninfo = allWaken[#allWaken].info
			local awakeName = v.awakeName
			return awakeninfo,refineLevelLimit,awakeName
		end
	end
	return nil
end


-- 获取精炼的消耗材料
-- return { silverCost -- 消耗金币  
--			normalCost = { - 普通物品消耗
--							{tid -- 消耗物品id needNum --  消耗物品需要数量 haveNum -- 消耗物品拥有数量（不包括自己，和精炼等级大于0的） costList = { {tid itemId num } ... } -- 消耗品详细列表
--							...
--						  }	
--         }

function fnGetRefineCost( itemId,tid, refineLevel)
	local treasData = DB_Item_exclusive.getDataById(tid)
	local evolveId =  treasData.evolveid
	require "db/DB_Exclusive_evolve"
	local evolveDB = DB_Exclusive_evolve.getDataById(evolveId)
	local evolveField = evolveDB["consume" .. refineLevel]
	local consumeField = lua_string_split(evolveField, ",")
	local consumeInfo = {}
	local normalCost = {}
	for i,v in ipairs(consumeField) do
		local consumeItemInfo = lua_string_split(v, "|")
		local consumeType = consumeItemInfo[1]
		-- 消耗贝里
		if (tonumber(consumeType) == 1) then
			consumeInfo.silverCost = tonumber(consumeItemInfo[3])
		end
		-- 消耗普通物品
		local itemType = ItemUtil.getItemTypeByTid(consumeItemInfo[2])

		if (tonumber(consumeType) == 7) then
			local consumeNormal= {}
			consumeNormal.tid = tonumber(consumeItemInfo[2])
			consumeNormal.needNum = tonumber(consumeItemInfo[3])
			if ( itemType.isNormal ) then
				local costList,allNum = getNormalMatrerialNum(consumeItemInfo[2])  -- 道具
				consumeNormal.haveNum = allNum
				consumeNormal.costList = costList
			elseif (  itemType.isSpeTreasure ) then
				local costList,allNum,canRefineNum = getSpecTreaNumByTid(itemId,consumeItemInfo[2]) -- 专属宝物
				if ( tonumber(tid )== tonumber( consumeItemInfo[2])) then
					canRefineNum = canRefineNum 
				end
				consumeNormal.haveNum = canRefineNum
				consumeNormal.costList = costList
			end
			table.insert(normalCost,consumeNormal)
		end
	end
	consumeInfo.normalCost = normalCost
	return consumeInfo
end

--根据tid获取专属宝物在背包中的个数 
-- return itemAllNum 计算所有
--        itemCanRefineNum 表示专属宝物精炼时计算个数（不算自己，和精炼等级大于1的）
function getSpecTreaNumByTid( itemid,tid )
	local itemAllNum = 0
	local itemCanRefineNum = 0
	local allBagInfo = DataCache.getRemoteBagInfo()
	local costList = {}
	if( allBagInfo) then
		for k,item_info in pairs( allBagInfo.excl  or {}) do
			local costItemInfo = {}
			if(tonumber(item_info.item_template_id) == tonumber(tid)) then
				itemAllNum = itemAllNum + tonumber(item_info.item_num)
			end
			if (tonumber(item_info.item_template_id) == tonumber(tid) 
			and (tonumber(item_info.va_item_text.exclusiveEvolve) == 0)
			and  (tonumber(item_info.item_id) ~= tonumber(itemid))) then
				costItemInfo.itemId = item_info.item_id
				costItemInfo.num = item_info.item_num
				costItemInfo.tid = item_info.item_template_id
				table.insert(costList,costItemInfo)
				itemCanRefineNum = itemCanRefineNum + tonumber(item_info.item_num)
			end
		end
	end
	return costList,itemAllNum,itemCanRefineNum  -- 去掉自己
end


--获取普通材料数量
function getNormalMatrerialNum( tid )
	local itemAllNum = 0
	local allBagInfo = DataCache.getRemoteBagInfo()
	local costList = {}
	if(allBagInfo) then
		for k,item_info in pairs( allBagInfo.props or {}) do
			local costItemInfo = {}
			if(tonumber(item_info.item_template_id) == tonumber(tid)) then
				costItemInfo.itemId = item_info.item_id
				costItemInfo.num = item_info.item_num
				costItemInfo.tid = item_info.item_template_id
				table.insert(costList,costItemInfo)
				itemAllNum = itemAllNum + tonumber(item_info.item_num)
			end
		end
	end
	return costList,itemAllNum
end


function getRealCost( normalCost )
	local realcost = {}
	for i,v in ipairs(normalCost) do
		local  costList = v.costList
		local leftnum = v.needNum
		for m,costItemInfo in ipairs(costList) do
			leftnum = leftnum - tonumber(costItemInfo.num)
			table.insert(realcost,costItemInfo)
			if (leftnum <= 0) then
				break
			end
		end
	end
	logger:debug({realcost=realcost})
	return realcost
end

-- 获取专属的详细信息
function getSpecTreaByItemId( itemId )
	local allSpecial = ItemUtil.getAllSpecial()
	for k,item_info in pairs( allSpecial or {}) do
		if (tonumber(item_info.item_id) == tonumber(itemId)) then
			return item_info
		end
	end

end

-- heroId 和awakeId 多个英雄“ hero11|hero12 ,hero21 | hero22” 对多个觉醒技能 “ wakeid1|wakeid2 ,wakeid3 | wakeid4” 
-- heromodelid是heroId中的所有原型id。“hero1|hero2”
-- 获取专属宝物对应的伙伴羁绊信息
function getHeroAwakenInfo( speTreaTid )
	local tbHeroInfo = {}
	-- 所属
	local speTreaDb = DB_Item_exclusive.getDataById(speTreaTid)
	local heromodelidFeild= speTreaDb.heromodelid
	local heroFeild = speTreaDb.heroId
	local awakeIDFeild =  speTreaDb.awakeId
	local tberomodelid 
	if (heromodelidFeild) then
		tberomodelid = lua_string_split(heromodelidFeild,"|")
	end
	if (heroFeild) then
		local tbHeroIds = lua_string_split(heroFeild,",")
		local tbawakeIDs = lua_string_split(awakeIDFeild,",")
		for i,heromodelid in ipairs(tberomodelid or {}) do
			local heroInfo = {}
			heroInfo.heromodelid = heromodelid
			heroInfo.tbHeroIds = lua_string_split(tbHeroIds[i],"|")
			heroInfo.tbawakeIds = lua_string_split(tbawakeIDs[i],"|")
			table.insert(tbHeroInfo,heroInfo)
		end
	else
		local heroInfo = {}
		heroInfo.heromodelid = tberomodelid[1]
		heroInfo.tbHeroIds = lua_string_split(tberomodelid[1],"|")
		heroInfo.tbawakeIds = lua_string_split("0","|")
		table.insert(tbHeroInfo,heroInfo)
	end
	return tbHeroInfo
end

-- 获取默认专属宝物对应英雄信息 羁绊信息
function getDefaultAwakenInfo( speTreaTid,hid )
	local tbHeroInfo = getHeroAwakenInfo(speTreaTid)
	local tbShowAwakeInfo = {}
	for i,heroInfo in ipairs(tbHeroInfo) do
		local tbHeroIds = heroInfo.tbHeroIds or {}
		local tbawakeIds = heroInfo.tbawakeIds or {}
		local showAwakeInfo = {}
		local showHeroId = heroInfo.heromodelid
		local showAwakeId = nil
		local isOnHero = false
		local ownerInfo = nil
		if (hid and tonumber(hid) ~= 0) then
			ownerInfo =  HeroModel.getHeroByHid(hid)
		end

		-- 设置初始原型id awakeid
		for i,heroId in ipairs(tbHeroIds or {}) do
			if (tonumber(heroId) == tonumber(showHeroId)) then
				showAwakeId = tbawakeIds[i]
			end
		end
		--  如果此宝物有人穿戴
		if (ownerInfo) then
			for i,heroId in ipairs(tbHeroIds or {}) do
				if (tonumber(heroId) == tonumber(ownerInfo.htid))  then
					showHeroId = heroId
					showAwakeId = tbawakeIds[i]
					isOnHero =  true
				end
			end
		end
		showAwakeInfo.showHeroId = showHeroId 
		showAwakeInfo.showAwakeId = showAwakeId
		showAwakeInfo.isOnHero = isOnHero
		table.insert(tbShowAwakeInfo,showAwakeInfo)
	end

	return tbShowAwakeInfo
end


-- 获取专属宝物 对所有可羁绊英雄的信息
function getAllAwakeForHero( item_id )
	local specTreaCacheInfo = getSpecTreaByItemId(item_id)
	local equipHid = specTreaCacheInfo.equip_hid
	local specTid = specTreaCacheInfo.item_template_id
	local tbShowAwakeInfo = getDefaultAwakenInfo(specTid,equipHid)
	return tbShowAwakeInfo
end














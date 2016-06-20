-- FileName: TreaInfoData.lua
-- Author: 
-- Date: 2016-01-23
-- Purpose: function description of module
--[[TODO List]]

TreaInfoData = class("TreaInfoData")

function TreaInfoData:ctor( ... )
	-- body
end


function TreaInfoData:getModleData( ... )
	return self.treaInfo
end

function TreaInfoData:initTreaDataBtItemId( itemId )
	self.treaInfo = {}

	self.treaInfo.itemId = itemId
	local treaCacheInfo = treaInfoModel.fnGetTreasNetData(itemId)

	logger:debug({treaCacheInfo = treaCacheInfo})

	self.treaInfo.treaCacheInfo = treaCacheInfo
	self.treaInfo.equipHid = treaCacheInfo.equip_hid
	self.treaInfo.tid = treaCacheInfo.item_template_id
	self.treaInfo.forgLel = treaCacheInfo.va_item_text and treaCacheInfo.va_item_text.treasureLevel or 0  
	self.treaInfo.refineLel = treaCacheInfo.va_item_text and treaCacheInfo.va_item_text.treasureEvolve or 0

	-- DB信息
	local treaDb      -- 宝物db
	local treaFragDb  -- 碎片db
	local itemType = ItemUtil.getItemTypeByTid(self.treaInfo.tid)


	local treaDb = DB_Item_treasure.getDataById(self.treaInfo.tid)

	if (treaDb.fragment_ids) then
		local treaFrag = lua_string_split(treaDb.fragment_ids, "|") 
		local fragTid = treaFrag[1]
		treaFragDb = DB_Item_treasure_fragment.getDataById(fragTid)
	end

	self.treaInfo.itemType = itemType
	self.treaInfo.treaDb = treaDb
	self.treaInfo.treaFragDb = treaFragDb
	self.treaInfo.property = self:fnGetTreaProperty(treaDb.id,self.treaInfo.forgLel)
	return self
end


function TreaInfoData:initTreaDataBtTid(  Tid,forgLel,refineLel)
	self.treaInfo = {}
	self.treaInfo.tid = Tid  -- 初始传入的id 可能是碎片的 可能是整体的
	-- DB信息
	local treaTid     -- 饰品id
	local fragTid     -- 碎片id

	local treaDb      -- 宝物db
	local treaFragDb  -- 碎片db

	local itemType = ItemUtil.getItemTypeByTid(Tid)
	if( itemType.isTreasure )then -- 饰品
		treaTid  = Tid
		treaDb = DB_Item_treasure.getDataById(treaTid)

		if (treaDb.fragment_ids) then
			local treaFrag = lua_string_split(treaDb.fragment_ids, "|") 
			fragTid = treaFrag[1]
			treaFragDb = DB_Item_treasure_fragment.getDataById(fragTid)
			self.treaInfo.refineLel = refineLel  or 0
		end
	elseif ( itemType.isTreasureFragment ) then --饰品碎片
		fragTid = Tid
		treaFragDb = DB_Item_treasure_fragment.getDataById(fragTid)
		treaTid = treaFragDb.treasureId
		treaDb = DB_Item_treasure.getDataById(treaTid)
	end
	self.treaInfo.itemType = itemType
	self.treaInfo.treaDb = treaDb
	self.treaInfo.treaFragDb = treaFragDb

	self.treaInfo.forgLel = forgLel  
	self.treaInfo.refineLel = refineLel  


	logger:debug({initTreaDataBtTid = self.treaInfo.forgLel})
	logger:debug({initTreaDataBtTid = self.treaInfo.refineLel})

	logger:debug({initTreaDataBtTid = forgLel})
	logger:debug({initTreaDataBtTid = refineLel})

	self.treaInfo.property = self:fnGetTreaProperty(treaDb.id,self.treaInfo.forgLel)
	-- self.treaInfo.awakeInfo = self:fnGetAwakeInfo(treaDb,hid)

	return self

end

-- 获取专属属性
function TreaInfoData:fnGetAwakeInfo( dbData, hid)
	if ( dbData.awakeId ) then
		local awakeId
		local tbawake= string.split(dbData.awakeId,"|")


		local tbAwake = {}
		local heroId
		local tbHeroId= string.split(dbData.heroId,"|")
		if (#tbHeroId==2 ) then
			if (HeroUtil.getHeroNumByHtid( tbHeroId[2]) >0 ) then
				heroId = tbHeroId[2]
				awakeId = tbawake[2]
			else
				heroId = tbHeroId[1]
				awakeId = tbawake[1]
			end
		elseif (#tbHeroId==1) then
			heroId = tbHeroId[1]
			awakeId = tbawake[1]
		end
		local data = DB_Heroes.getDataById(heroId)

		tbAwake.heroName = data.name
		tbAwake.heroQuality = data.potential
		if (hid) then
			local htid = HeroModel.getHeroByHid(hid).htid
			tbAwake.isOpen = (tonumber(htid) == heroId)
		else
			tbAwake.isOpen = false
		end

		tbAwake.awakeDes = DB_Awake_ability.getDataById(awakeId).des

		return tbAwake
	else
		return nil
	end
end


--获取宝物属性
function TreaInfoData:fnGetTreaProperty( tid,level )
	local tbBasePro = {}
	require "db/DB_Affix"
	local treasData = DB_Item_treasure.getDataById(tid)
	for i=1,6 do
		local tbProperty = {}
		local proBaseTemp = treasData["base_attr" .. i]
		local proAddRowTemp = treasData["increase_attr" .. i]
		local blexpTreas = ItemUtil.isGoldOrSilverTreas(tid)
		if (proBaseTemp) then
			local proBaseArr = lua_string_split(proBaseTemp, "|")
			if (#proBaseArr == 2) then
				local baseValue = tonumber(proBaseArr[2])
				if (tonumber(level) > 0 and proAddRowTemp) then
					local proRowArr = lua_string_split(proAddRowTemp, "|")
					baseValue = baseValue + tonumber(proRowArr[2]) * tonumber(level)
				end
				local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(proBaseArr[1]),baseValue)
				tbProperty.name = baseInfo.displayName
				tbProperty.value = displayNum
				table.insert(tbBasePro,tbProperty)
			end
		else
			if (blexpTreas) then
				tbProperty.name = m_i18n[1723]
				tbProperty.value = treasData.base_exp_arr
				table.insert(tbBasePro,tbProperty)
			end

		end
	end
	return tbBasePro
end
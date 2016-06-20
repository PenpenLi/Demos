-- FileName: SpecTreaData.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

SpecTreaData = class("SpecTreaData")

-- UI控件引用变量 --

-- 模块局部变量 --

function SpecTreaData:ctor( ... )
	-- body
end



function SpecTreaData:initInfo( Tid,refineLel,itemId,footerBtnType )
	self.specTreaInfo = {}
	self.specTreaInfo.footerBtnType = footerBtnType
	self.specTreaInfo.itemId = itemId or 0
	local specCacheInfo = self:initSpecTb(itemId)

	self.specTreaInfo.hid = specCacheInfo and specCacheInfo.equip_hid or 0

	local speTreaTid     -- 宝物id
	local speFragTid     -- 碎片id

	local speTreaDb      -- 宝物db
	local speTreaFragDb  -- 碎片db

	local itemType = ItemUtil.getItemTypeByTid(Tid)
	if( itemType.isSpeTreasure )then -- 专属宝物
		speTreaTid  = Tid
		speTreaDb = DB_Item_exclusive.getDataById(speTreaTid)
		local speTreaFrag = lua_string_split(speTreaDb.fragment, "|") 
		if (speTreaFrag) then
			speFragTid = speTreaFrag[1]
			speTreaFragDb = DB_Item_exclusive_fragment.getDataById(speFragTid)
			self.specTreaInfo.refineLel = refineLel  or 0
		end
	elseif ( itemType.isSpeTreasureFragment ) then --专属宝物碎片
		speFragTid = Tid
		speTreaFragDb = DB_Item_exclusive_fragment.getDataById(speFragTid)
		speTreaTid = speTreaFragDb.treasureId
		speTreaDb = DB_Item_exclusive.getDataById(speTreaTid)
		self.specTreaInfo.refineLel = refineLel  
	end
	local evolveid = speTreaDb.evolveid
	-- 最大进阶等级
	if (evolveid) then
		self.specTreaInfo.maxRefineLevel = DB_Exclusive_evolve.getDataById(evolveid).maxlevel
	end
	-- 宝物DB
	self.specTreaInfo.speTreaDb = speTreaDb
	-- 碎片DB
	self.specTreaInfo.speTreaFragDb = speTreaFragDb
	-- 所属
	local tbHeroInfo 
	if (speTreaDb.id ~= 720001) then
		tbHeroInfo = SpecTreaModel.getHeroAwakenInfo(speTreaTid)
	end
	self:initSpecTb()
	self.specTreaInfo.tbHeroInfo = tbHeroInfo
	return self
end



-- 滑动列表数据
function SpecTreaData:initSpecTb( itemId )
	local curModuleName = LayerManager.curModuleName()
	local specTb , index = {} ,1
		-- pageView 准备数据
	if (curModuleName == "MainFormation") then
		specTb, index = FormationSpecialModel.getSpecialInfoDatas(tonumber(itemId))
	else
		local curSpecTrea = {}
		local allTreaOnBag = ItemUtil.getSpecialOnBag()
		for i,treaItem in ipairs(allTreaOnBag) do
			if (tonumber(treaItem.item_id) == tonumber(itemId)) then
				curSpecTrea = treaItem
				break
			end
		end
		local allTreaOnForm = FormationSpecialModel.getSpecialInfoDatas()
		for i,treaItem in ipairs(allTreaOnForm) do
			if (tonumber(treaItem.item_id) == tonumber(itemId)) then
				curSpecTrea = treaItem
				break
			end
		end

		table.insert(specTb, curSpecTrea)
	end

	self.specTreaInfo.specTb = specTb
	self.specTreaInfo.index  = index
	return specTb[index]
end


function SpecTreaData:getModleData( ... )
	return self.specTreaInfo
end






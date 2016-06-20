-- FileName: ResolveModel.lua
-- Author:zhangjunwu
-- Date: 2014-05-10
-- Purpose: 分解数据
module("ResolveModel", package.seeall)

require "script/model/hero/HeroModel"
require "db/DB_Item_arm"
require "db/DB_Item_treasure"
require "db/DB_Heroes"
require "script/module/equipment/EquipFixModel"
local m_tbAllParnter  		= {} 		--所有可以分解的伙伴
local m_tbParnterAuto 		= {}  		--符合自动添加的伙伴

local m_tbAllEquips   		= {}		--所有可以分解的装备
local m_tbEquipsAuto  		= {}		--符合自动添加的装备

local m_tbAllShadows  		= {}		--所有可以分解的影子
local m_tbShodowAuto  		= {}		--符合自动添加的影子

local m_tbAllTreasure 		= {}		--所有可以分解的饰品
local m_tbTreasureAuto 		= {}		--符合自动添加的饰品

local m_tbAllSPTreasure 	= {}		--所有可以分解的专属宝物
local m_tbSPTreasureAuto 	= {}		--符合自动添加的专属宝物

local m_tbAllShipItem	 	= {}		--所有可以分解的主船
local m_tbShipItemAuto 		= {}		--符合自动添加的主船

local m_tbRebornParnter 	= {}

local m_tbSelected 			= {}		--被选中的物品集合
local m_nSelectedIndex 		= 1		--
local m_RecoveryType 		= 1 		--当前分解的类型 1：伙伴 2：影子：3：装备 4：饰品 5：专属宝物 6:主船 7:伙伴重生



 T_Parnter 		= 1
 T_Shadow 		= 2
 T_RebornParnter= 3
 T_Equip 		= 4
 T_Treasure 	= 5
 T_SPTreasure 	= 6
 T_SPShipItem 	= 7
 

local m_i18n = gi18n
--伙伴，影子，装备，饰品 专属宝物
local tbItem 	= {m_i18n[7107], m_i18n[7106],m_i18n[7152],m_i18n[7108], m_i18n[7110] ,m_i18n[7109],m_i18n[7146]}

-- tbAddAutoTips 	= {"您没有低于紫色品质的伙伴", "您没有低于紫色品质的伙伴影子", 
-- 					"您没有低于紫色品质的装备", "您没有低于紫色品质的饰品" ,"您没有低于紫色品质的宝物" ,}

tbAddAutoTips 	= {m_i18n[7122],m_i18n[7123], m_i18n[7123], m_i18n[7124], m_i18n[7125] ,m_i18n[7126],m_i18n[7125]}
-- tbNoItemTips 	= {"没有可回收的伙伴", "没有可回收的影子", "没有可回收的装备", "没有可回收的饰品" ,"没有可回收的宝物" ,}
tbNoItemTips 	= {m_i18n[7117],m_i18n[7118], m_i18n[7160], m_i18n[7119], m_i18n[7120] ,m_i18n[7121],m_i18n[7147]}
-- 1713] = "已选择饰品",
tbChoiceTips 	= {m_i18n[1020], m_i18n[1523], m_i18n[1020],m_i18n[1522], m_i18n[1713] ,m_i18n[7137],m_i18n[7149]}

-- tbRecoveryTips  = {"此次回收中含有高品质伙伴","此次回收中含有高品质伙伴影子","此次回收中含有高品质装备",
-- 					"此次回收中含有高品质饰品","此次回收中含有高品质宝物",}
tbRecoveryTips  = {m_i18n[7133],m_i18n[7132],m_i18n[7157],m_i18n[7134],m_i18n[7135],m_i18n[7136],m_i18n[7150]}

tbHelpTips  = 	  {m_i18n[7102],m_i18n[7101],m_i18n[7153],m_i18n[7103],m_i18n[7104],m_i18n[7105],m_i18n[7144]}
--"请选择想要回收的伙伴",
tbNoRecoverItemTips  = {m_i18n[7127],m_i18n[7128],m_i18n[7155],m_i18n[7129],m_i18n[7130],m_i18n[7131],m_i18n[7148]}

function getRecoveryList()
	return tbItem
end

function destroy(...)
	package.loaded["ResolveModel"] = nil
end

function moduleName()
	return "ResolveModel"
end

local function init(...)
end

function resetAutoAddSelectIndex(  )
	m_nSelectedIndex = 1
	m_tbSelected = {}
	resetListData()
end

--影子碎片的排序
local function fnCOMbyStarLV(w1,w2 )
	if(w1.star_lv ~= w2.star_lv) then
		return  w1.star_lv < w2.star_lv
	elseif(w1.item_num ~= w2.item_num) then
		return w1.item_num < w2.item_num
	elseif(w1.nQuality ~= w2.nQuality) then
		return  w1.nQuality < w2.nQuality
	else
		return w1.id > w2.id
	end
end

local function sortPartnerSoul( item1, item2 )
	if (item1.bCanSelectd and not item2.bCanSelectd) then
		return true
	elseif (not item1.bCanSelectd and item2.bCanSelectd) then
		return false
	else
		return fnCOMbyStarLV(item1, item2)
	end
end



	--按照星级排序，
local function sortReborn(a, b)
	if (a.star_lv ~= b.star_lv) then
		return a.star_lv > b.star_lv
	elseif (a.heroQuality ~= b.heroQuality) then
		return a.heroQuality > b.heroQuality
	elseif (a.sLevel ~= b.sLevel) then
		return a.sLevel > b.sLevel
	elseif (a.sTransferValue ~= b.sTransferValue) then
		return a.sTransferValue >b.sTransferValue
	elseif (a.id ~= b.id) then
		return a.id <b.id
	end
end


local function spTreasSort(a,b )
	if (a.starLvl ~= b.starLvl) then
		return a.starLvl < b.starLvl
	elseif (a.nQuality ~= b.nQuality) then
		return a.nQuality < b.nQuality
	elseif (a.level ~= b.level) then
		return a.level < b.level
	elseif (a.id ~= b.id) then
		return a.id > b.id
	end
end

--进入列表之前对数据进行排序，被选中的放在前列
function sortListData(  )
	local allData = getAllAddDataByType()

	if(m_RecoveryType == T_RebornParnter) then
		table.sort(allData,sortReborn)
		return 
	end

	table.sort( allData, function ( a,b )
		if((a.isSelected == true) and (b.isSelected == false)) then
			return true
		elseif((a.isSelected == false) and (b.isSelected == true)) then
			return false
		elseif(m_RecoveryType == T_Shadow) then
			return sortPartnerSoul(a,b)
		elseif(m_RecoveryType == T_SPTreasure) then
				return spTreasSort(a,b)
		elseif(a.star_lv ~= b.star_lv) then
			return  a.star_lv < b.star_lv
		else
			return a.id > b.id
		end
	end )


end

--自动添加数据处理
function addItemData()
	for i,v in ipairs(m_tbSelected) do
		v.isSelected = false
	end

	m_tbSelected = {}
	local tbAutoAdd = getAutoAddDataByType()
	if(m_nSelectedIndex >= #tbAutoAdd) then
		m_nSelectedIndex = 1
	end

	if(m_nSelectedIndex <= #tbAutoAdd) then
		local addCount = 0
		for i = m_nSelectedIndex,#tbAutoAdd do
			if(addCount < 5 and tbAutoAdd[i]) then
				table.insert(m_tbSelected,tbAutoAdd[i])
				m_nSelectedIndex = m_nSelectedIndex + 1
				tbAutoAdd[i].isSelected = true
			else
				break
			end
			addCount = addCount + 1
		end
	end
end

--从列表中选择了item之后，按确定回到主界面重新设计数据
function setSelectedData()
	m_tbSelected = {}
	local allData = getAllAddDataByType()
	for i,v in ipairs(allData) do
		if(v.isSelected == true) then
			table.insert(m_tbSelected,v)
		end

	end
end

--从列表中选择了item之后，点击返回按钮 
function setSelectedDataBytemp(tbTemp)
	m_tbSelected = {}
	local allData = getAllAddDataByType()
	for i,v in ipairs(allData) do
		v.isSelected = false
		for ii,vv in ipairs(tbTemp) do
			if(v.id == vv.id) then
				v.isSelected = true
				break
			end
			
		end

	end
	m_tbSelected = tbTemp
end

--自动添加所需要的数据
function getAutoAddDataByType()
	if(m_RecoveryType == T_Parnter) then
		return m_tbParnterAuto
	elseif(m_RecoveryType == T_Equip) then
		return m_tbEquipsAuto
	elseif(m_RecoveryType == T_Shadow) then
		return m_tbShodowAuto
	elseif(m_RecoveryType == T_Treasure) then
		return m_tbTreasureAuto
	elseif(m_RecoveryType == T_SPTreasure) then
		return m_tbSPTreasureAuto
	elseif(m_RecoveryType == T_SPShipItem) then
		return m_tbShipItemAuto
	elseif(m_RecoveryType == T_RebornParnter) then
		return {}
	end
end

--选择列表所需要的数据
function getAllAddDataByType()
	if(m_RecoveryType == T_Parnter) then
		return m_tbAllParnter
	elseif(m_RecoveryType == T_Equip) then
		return m_tbAllEquips
	elseif(m_RecoveryType == T_Shadow) then
		return m_tbAllShadows
	elseif(m_RecoveryType == T_Treasure) then
		return m_tbAllTreasure
	elseif(m_RecoveryType == T_SPTreasure) then
		return m_tbAllSPTreasure
	elseif(m_RecoveryType == T_SPShipItem) then
		return m_tbAllShipItem
	elseif(m_RecoveryType == T_RebornParnter) then
		return  m_tbRebornParnter
	end
end

function getRecoveryType()
	return m_RecoveryType
end

function setRecoveryType(_type)
	 m_RecoveryType  = _type
end

function getSelectedData()
	return  m_tbSelected
end

function isSkyHero(hid)
	local tbSkyHeroHids = DataCache.getSkypieaData()
	for k,v in pairs(tbSkyHeroHids) do
		if(tonumber(k) == tonumber(hid)) then
			return true
		end
	end
	return false
end

function getSelectedCount(  )
	local tbAllItem = getAllAddDataByType()
	local nCount = 0
	for i,v in ipairs(tbAllItem) do
		if(v.isSelected == true)then
			nCount = nCount + 1
		end
	end
	return nCount
end

function setListDataCheckState()
	local tbAllItem = getAllAddDataByType()
	local tbAutoAddItem = getAutoAddDataByType()

	for i,v in ipairs(tbAllItem) do
		for ii,vv in ipairs(tbAutoAddItem) do
			if(tonumber(v.id) == tonumber(vv.id)) then
				v.isSelected = true
				break
			end
		end
	end

end

--切换标签的时候，吧所有的选中的item重置
function resetListData()
	local tbAllItem = getAllAddDataByType()

	for i,v in ipairs(tbAllItem) do
		v.isSelected = false
	end

end
--过滤伙伴
function getFilterPartnerList(_bRedPoint)
	logger:debug("getFilterPartnerList")
	 m_tbAllParnter = {}
	 m_tbParnterAuto = {}
	 m_tbRebornParnter = {}
	local hids = HeroModel.getAllHeroesHid()
	local userinfo  =  UserModel.getUserInfo()
	for i=1, #hids do
		local hid = hids[i]
		local value = {}
		value.hid = hid
		value.id = hid
		local hero = HeroModel.getHeroByHid(hid)
		logger:debug(hero)
		local tbAwake = hero.awake_attr or {}
		local awakeLevel = tbAwake.level or  0
		local db_hero = DB_Heroes.getDataById(hero.htid)
		local isSky = isSkyHero(hid)
		value.awake_attr = hero.awake_attr or {}
		value.disillusion_quality = db_hero.disillusion_quality or false
		value.awakeLevel = tonumber(awakeLevel)
		value. isCanAwake = db_hero.disillusion_quality and SwitchModel.getSwitchOpenState(ksSwitchAwake or 40) 
		value.isBusy = DataCache.isHeroBusy(hid)
		value.star_lv = db_hero.star_lv
		value.sLevel = tonumber(hero.level or 0)
		value.htid = hero.htid
		value.heroQuality = db_hero.heroQuality
		value.showLevel = value.sLevel
		value.sTransferValue = tonumber (hero.evolve_level)
		-- value.evolve_level = tonumber(hero.evolve_level)
		value.is_decompos = db_hero.is_decompos
		value.name = db_hero.name
		if  (tonumber(hero.htid) ~= tonumber(userinfo.htid) and  value.isBusy == false and tonumber( value.is_decompos ) == 1 and isSky == false) then

			if(db_hero.star_lv < 5) then
				table.insert(m_tbParnterAuto,value)
			end
			-- logger:debug(value.sLevel)
			if(value.sLevel >=2 or value.sTransferValue >= 1) then
				value.rebirth_basegold = db_hero.rebirth_basegold
				
				table.insert(m_tbRebornParnter,value)
			end
			--如果是计算红点 则下面的代码不执行
			if(_bRedPoint == nil) then
				value.sTransfer = "+" .. (hero.evolve_level)
				value.sTransferValue = tonumber (hero.evolve_level)
				value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
				value.head_icon = "images/base/hero/head_icon/" ..  db_hero.head_icon_id
				
				value.nQuality = db_hero.potential
				value.sign = value.country_icon
				value.icon = { id = value.htid, bHero = true ,onTouch = onBtnSelectPartner}
				value.isSelected = false
				table.insert(m_tbAllParnter,value)
			end


		end
	end
	--按照星级排序，
	local function sort(a, b)
		if (a.star_lv ~= b.star_lv) then
			return a.star_lv < b.star_lv
		elseif (a.heroQuality ~= b.heroQuality) then
			return a.heroQuality <b.heroQuality
		elseif (a.sLevel ~= b.sLevel) then
			return a.sLevel <b.sLevel
		elseif (a.sTransferValue ~= b.sTransferValue) then
			return a.sTransferValue <b.sTransferValue
		elseif(a.awakeLevel ~= b.awakeLevel) then
			return a.awakeLevel < b.awakeLevel
		elseif (a.id ~= b.id) then
			return a.id <b.id
		end
	end

	--如果是计算红点 则下面的代码不执行
	if(_bRedPoint == nil ) then
		table.sort(m_tbAllParnter, sort)
		table.sort(m_tbParnterAuto, sort)
		
	end
	-- logger:debug(m_tbAllParnter)
	return m_tbAllParnter
end
-- 按装备的基础经验
local function fnCompareWithNum(h1, h2)
	return tonumber(h1.item_num)  < tonumber(h2.item_num)
end
-- 按装备的基品级
local function fnCompareWithBaseScore(h1, h2)
	if tonumber(h1.star_lv)  == tonumber(h2.star_lv) then
		return fnCompareWithNum(h1, h2)
	else
		return h1.star_lv < h2.star_lv
	end
end
--过滤影子
function getFilterHeroList(_bRedPoint)
	 m_tbAllShadows = {}
	 m_tbShodowAuto = {}
	local bagHeroFragsInfo = DataCache.getHeroFragFromBag()
	for k,v in pairs(bagHeroFragsInfo) do
		local heroFragment = DB_Item_hero_fragment.getDataById(v.item_template_id)
		local db_hero = DB_Heroes.getDataById(heroFragment.aimItem)
		v.item_num = tonumber(v.item_num) 										--拥有的碎片个数
		v.max_stack = tonumber(heroFragment.max_stack or  0) 							--堆叠上限
		v.bCanSelectd =  true  -- (v.item_num >= v.max_stack)
		v.nQuality  = tonumber(heroFragment.quality)
		v.star_lv = db_hero.star_lv  
		v.showLevel = nil
		if(heroFragment.is_decompos == 1 ) then

			if(tonumber(v.star_lv) < 5 and v.bCanSelectd) then
				table.insert(m_tbShodowAuto,v)
			end

			if(_bRedPoint == nil ) then
				v.isSelected = false 													--是否被选中（在选择列表中）
				v.sign = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
				v.item_id = tonumber(v.item_id) 										--（碎片id）
				v.id  = tonumber(v.item_id) 										--（碎片id）
				v.icon = {id = db_hero.id, bHero = true,bShadow = true}
				v.name = db_hero.name 													--名字
				v.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id 	--头像图片
				table.insert(m_tbAllShadows,v)
			end
		end
	end
	--如果是计算红点 则下面的代码不执行
	if(_bRedPoint == nil) then
		table.sort(m_tbAllShadows, sortPartnerSoul)	
		table.sort(m_tbShodowAuto, sortPartnerSoul)	
	end
	return m_tbAllShadows
end


--过滤宝物
function getFiltersForTreas(_bRedPoint)
	require "script/module/treasure/treaInfoModel"
	 m_tbAllTreasure = {}
	 m_tbTreasureAuto = {}
	local bagInfo = DataCache.getBagInfo()
	-- logger:debug(bagInfo.treas)
	for k,v in pairs(bagInfo.treas) do
		if (tonumber(v.itemDesc.is_decompos) == 1) then
			v.isSelected = false
			v.star_lv = v.itemDesc.quality
			v.nQuality = v.itemDesc.quality
			if(tonumber(v.itemDesc.quality) < 6) then
				table.insert(m_tbTreasureAuto,v)

				table.sort(m_tbTreasureAuto,function(a,b)
					if (a.itemDesc.quality ~= b.itemDesc.quality) then
						return a.itemDesc.quality < b.itemDesc.quality
					elseif (a.va_item_text.treasureLevel ~= b.va_item_text.treasureLevel) then
						return a.va_item_text.treasureLevel < b.va_item_text.treasureLevel
					elseif (tonumber(a.va_item_text.treasureEvolve or 0) ~= tonumber(b.va_item_text.treasureEvolve or 0)) then
						return tonumber(a.va_item_text.treasureEvolve or 0) < tonumber(b.va_item_text.treasureEvolve or 0)
					elseif (a.itemDesc.id ~= b.itemDesc.id) then
						return a.itemDesc.id > b.itemDesc.id
					end
				end)
				
			end

			local tbTreaInfo = treaInfoModel.getSimpleTreaInfo(v.item_id) -- zhangqi, 2015-06-15, 替换开销小的方法
			-- tbData赋值
			v.id = v.item_id
			v.showLevel = v.va_item_text.treasureLevel or 0
			v.name = tbTreaInfo.name
			v.sign = ItemUtil.getSignTextByItem(v.itemDesc)
			v.icon = { id = tbTreaInfo.treaData.item_template_id, bHero = false }
			v.sStrongNum = tbTreaInfo.level
			v.sRefinNum = tbTreaInfo.treaEvolve[1].lv
			v.sRank = tbTreaInfo.base_score

			local strAttrDesc = ""
			v.tbAttr = {}
			-- 添加基础属性信息 add by sunyunpeng 2015.07.10
			logger:debug(tbTreaInfo.baseProperty)
			for i, vv in ipairs(tbTreaInfo.baseProperty or {}) do
				strAttrDesc = strAttrDesc .. vv.name .. " +" .. vv.value .. "\n"
				if (i%3 == 0 ) then
					table.insert(v.tbAttr, strAttrDesc)
					strAttrDesc = ""
				end
			end

			for i, vvv in ipairs(tbTreaInfo.property or {}) do
				strAttrDesc = strAttrDesc .. vvv.name .. " +" .. vvv.value .. "\n"
				if (i%3 == 0 ) then
					table.insert(v.tbAttr, strAttrDesc)
					strAttrDesc = ""
				end
			end
			table.insert(v.tbAttr, strAttrDesc)
			table.insert(m_tbAllTreasure,v)
		end
	end
	if(_bRedPoint == nil) then
		table.sort(m_tbAllTreasure,function(a,b)
			if (a.itemDesc.quality ~= b.itemDesc.quality) then
				return a.itemDesc.quality < b.itemDesc.quality
			elseif (a.va_item_text.treasureLevel ~= b.va_item_text.treasureLevel) then
				return a.va_item_text.treasureLevel < b.va_item_text.treasureLevel
			elseif (tonumber(a.va_item_text.treasureEvolve or 0) ~= tonumber(b.va_item_text.treasureEvolve or 0)) then
				return tonumber(a.va_item_text.treasureEvolve or 0) < tonumber(b.va_item_text.treasureEvolve or 0)
			elseif (a.itemDesc.id ~= b.itemDesc.id) then
				return a.itemDesc.id > b.itemDesc.id
			end
		end)
	end
	return m_tbAllTreasure
end

--过滤装备
function getFiltersForEquips(_bRedPoint)
	logger:debug("getFiltersForEquips")
	local tbAllBagInfo = DataCache.getBagInfo()
	 m_tbAllEquips = {}
	 m_tbEquipsAuto = {}
	for key,v in pairs(tbAllBagInfo.arm) do
		local tbData = {}
		local mt = {}
		mt.__index = v
		setmetatable(tbData, mt)
		tbData.nQuality	= v.itemDesc.quality
		tbData.id 		= v.item_id
		tbData.isSelected 	= false
		if(tonumber(tbData.nQuality) < 5) then
			table.insert(m_tbEquipsAuto,tbData)
		end
		if(_bRedPoint == nil ) then

		    local sEnchant = nil 
		    if (EquipFixModel.isEuipCanFixByTid(v.item_template_id) == 1) then
		        sEnchant = v.va_item_text.armEnchantLevel or "0" -- 如果后端数据没有附魔字段则默认为 "0"
		    end   

			local tbAttr,tbPLAttr,nScore,tbEquipDbInfo = ItemUtil.getEquipNumerialByIID(v.item_id)
			tbData.level 	= v.va_item_text.armReinforceLevel
			tbData.showLevel = v.va_item_text.armReinforceLevel or 0
			tbData.star_lv  = tbData.nQuality
			tbData.sScore 	= tostring(v.itemDesc.base_score)
			tbData.name 	= v.itemDesc.name
			tbData.sMagicNum = sEnchant 
			tbData.nMagicNum = tonumber(sEnchant ) --排序用
			tbData.sign     = ItemUtil.getSignTextByItem(v.itemDesc)
			tbData.icon 	= { id = v.item_template_id, bHero = false }
			tbData.icon.onTouch = function ( sender, eventType )
		        if (eventType == TOUCH_EVENT_ENDED) then
		            AudioHelper.playCommonEffect()
		            require "script/module/equipment/EquipInfoCtrl"
		            local layout = EquipInfoCtrl.createForSellEquip(v) -- 只带一个"返回"按钮的装备信息面板
		            LayerManager.addLayoutNoScale(layout)
		        end
		    end
			
			tbData.tbAttr    = {}
			local strDesc, i = "", 1
			for k, v in pairs(tbAttr) do
				if (v ~= 0) then
				    strDesc = strDesc .. g_AttrNameWithoutSign[k] .. " +" .. v .. "\n"
				    if (i%3 == 0 ) then
				        table.insert(tbData.tbAttr, strDesc)
				        strDesc = ""
				    end
				    i = i + 1
				end
			end
			table.insert(tbData.tbAttr, strDesc)
			table.insert( m_tbAllEquips, tbData )
		end
	end
	if(_bRedPoint == nil) then
		local function equipSort(a,b )
			if (a.nQuality ~= b.nQuality) then
				return a.nQuality < b.nQuality
			elseif (a.level ~= b.level) then
				return a.level < b.level
			elseif (a.nMagicNum ~= b.nMagicNum) then
				return a.nMagicNum < b.nMagicNum
			elseif (a.itemDesc.id ~= b.itemDesc.id) then
				return a.itemDesc.id > b.itemDesc.id
			end
		end
		table.sort(m_tbAllEquips,equipSort)
		table.sort(m_tbEquipsAuto,equipSort)

	end
end

--过滤专属宝物
function getFiltersForSPTreas(_bRedPoint)
	require "script/module/specialTreasure/SpecTreaModel"
	local tbAllBagInfo = ItemUtil.getSpecialOnBag() --DataCache.getBagInfo()
	 m_tbAllSPTreasure = {}
	for key,v in pairs(tbAllBagInfo) do
		local tbData = {}
		local mt = {}
		mt.__index = v
		setmetatable(tbData, mt)
		tbData.nQuality	= v.itemDesc.quality
		if(v.itemDesc.is_decompos == 1 ) then
			if(tonumber(tbData.nQuality) < 5) then
				table.insert(m_tbSPTreasureAuto,tbData)
			end
			local tbAttr = SpecTreaModel.fnGetTreaProperty(tonumber(v.item_template_id),tonumber(v.va_item_text.exclusiveEvolve))
			tbData.id 		= v.item_id
			tbData.level 	= tonumber(v.va_item_text.exclusiveEvolve) or 0
			tbData.showLevel = tbData.level
			tbData.starLvl 	= v.itemDesc.base_score  
			tbData.sScore 	= tostring(v.itemDesc.base_score)
			tbData.name 	= v.itemDesc.name
			tbData.icon 	= { id = v.item_template_id, bHero = false }
			tbData.isSelected 	= false
			tbData.tbAttr = tbAttr
			table.insert( m_tbAllSPTreasure, tbData )
			v.star_lv = tbData.nQuality
		end

	end

	local function spTreasSort(a,b )
		if (a.starLvl ~= b.starLvl) then
			return a.starLvl < b.starLvl
		elseif (a.nQuality ~= b.nQuality) then
			return a.nQuality < b.nQuality
		elseif (a.level ~= b.level) then
			return a.level < b.level
		elseif (a.id ~= b.id) then
			return a.id > b.id
		end
	end
	-- logger:debug(m_tbAllSPTreasure)
	table.sort( m_tbAllSPTreasure, spTreasSort )
end

require "db/DB_Item_ship"
require "script/module/ship/ShipData"
--过滤主船
function getFiltersForShipInfo(_bRedPoint)
	logger:debug("getFiltersForShipInfo")
	local tbAllBagInfo = DataCache.getBagInfo()
	 m_tbAllShipItem = {}
	 m_tbShipItemAuto = {}
	 -- logger:debug(tbAllBagInfo.props)
	for key,v in pairs(tbAllBagInfo.props) do
		local tbData = {}
		local mt = {}
		mt.__index = v
		setmetatable(tbData, mt)
		local i_id = tonumber(v.itemDesc.id)
		if(i_id >= 40001 and i_id <= 50000) then -- 激活主船物品
			local isActiveShip = ShipData.getIfShipActivatedByItemId(i_id)
			logger:debug({isActiveShip = isActiveShip})
			if(isActiveShip == true ) then
				tbData.showLevel = nil
				tbData.id 		= v.item_id
				tbData.sOwnNum 	= v.item_num or 0 
				tbData.sScore 	= tostring(v.itemDesc.base_score)
				tbData.name 	= v.itemDesc.name
				tbData.sDesc 	= v.itemDesc.desc
				tbData.nQuality 	= v.itemDesc.quality
				if(tbData.nQuality < 5)then
					table.insert( m_tbShipItemAuto, tbData )
				end
				tbData.icon 	= { id = v.item_template_id, bHero = false }
				tbData.isSelected 	= false
				table.insert( m_tbAllShipItem, tbData )
				v.star_lv = tbData.nQuality
			end
		end
	end
	local function shipItemSort(a,b )
		if (a.nQuality ~= b.nQuality) then
			return a.nQuality < b.nQuality
		else
			return a.id > b.id
		end
	end

	-- table.sort( m_tbAllShipItem, equipSort )
	-- logger:debug({m_tbAllShipItem = m_tbAllShipItem})
	table.sort( m_tbAllShipItem, shipItemSort )
end

function create(...)

end

--被分解的东西里是否有可以被自动添加的，用来判断是否刷新红点
local function fnHasAutoItemInSeleceted()
	local maxQuilty = 5
	--饰品可以自动添加紫色饰品
	if(m_RecoveryType == T_Treasure) then
		maxQuilty = 6
	end
	for i,v in ipairs(m_tbSelected) do
		logger:debug(v.star_lv)
		if(tonumber(v.star_lv) < maxQuilty) then
			return  true
		end
	end
	return false
end

--被分解的东西里是否有紫色品质或者紫色品质以上的
 function fnHasHightItem()
	for i,v in ipairs(m_tbSelected) do
		if(tonumber(v.star_lv) > 4) then
			return  true
		end
	end
	return false
end

local function updateTabRedPoint( )
	if(fnHasAutoItemInSeleceted() == true) then
		MainRecoveryView.updateRedImg()
	end
	m_tbSelected = {}
end
--发送分解请求后，背包的推送之后更新本界面的数据
function refreshEquipData()
	getFiltersForEquips()
	updateTabRedPoint( )


end
function refreshTreasData()
	getFiltersForTreas()
	updateTabRedPoint( )
end

-- zhangqi, 2015-10-23, 添加更新影子背包数据的处理, 避免伙伴分解后影子背包的缓存数据没有更新的问题
local function updateShadowBagData( ... )
	MainPartner.cleanHeroFragData() -- 先清除影子背包数据，下面的更新处理才有效
	PartnerYingZi.updateYingZiData()
end

function refreshHerosData()
	getFilterHeroList()
	updateTabRedPoint( )
end

function refreshPartnerData()
	if(m_RecoveryType == T_RebornParnter) then
		local pDB = HeroUtil.getHeroInfoByHid(m_tbSelected[1].hid)
		logger:debug({wm___pDB = pDB})
		local beforeID
		if(pDB and pDB.localInfo) then
			beforeID = pDB.localInfo.before_id
		end
		logger:debug("wm----beforeID : %s",tostring(beforeID))
		if(beforeID) then
			HeroModel.setHtidByHid(m_tbSelected[1].hid, beforeID)
		end

		HeroModel.setHeroLevelByHid(m_tbSelected[1].hid,1)
		local heroInfo = HeroModel.getHeroByHid(m_tbSelected[1].hid)
		HeroModel.addEvolveLevelByHid(m_tbSelected[1].hid,-heroInfo.evolve_level)
		HeroModel.setHeroSoulByHid(m_tbSelected[1].hid,0)
		HeroModel.resetAwakedHeroInfo(m_tbSelected[1].hid)

		removeSpTreasByReborn()
	else
		for i = 1,#m_tbSelected do
			HeroModel.deleteHeroByHid(m_tbSelected[i].id)
		end
	end
	
	--初始化所有的数据
	getFilterPartnerList()
	-- --因为回收伙伴会产生伙伴影子，所以回收伙伴之后要判断影子的回收逻辑
	-- getFilterHeroList()

	updateShadowBagData() -- 2015-10-23

	local nAutoSelectCount = #m_tbShodowAuto
	m_redPoint[T_Shadow].visible = nAutoSelectCount >= 5

	updateTabRedPoint()
end

function refreshSPTreasData()
	m_tbSelected = {}
	getFiltersForSPTreas()
end

function refreshShipItemData()
	m_tbSelected = {}
	getFiltersForShipInfo()
end


function bagDeleget()
	if(m_RecoveryType == T_Parnter) then
		refreshPartnerData()
	elseif(m_RecoveryType == T_Equip) then
		refreshEquipData()
	elseif(m_RecoveryType == T_Shadow) then
		refreshHerosData()
	elseif(m_RecoveryType == T_Treasure) then
		refreshTreasData()
	elseif(m_RecoveryType == T_SPTreasure) then
		refreshSPTreasData()
	elseif(m_RecoveryType == T_SPShipItem) then
		refreshShipItemData()
	elseif(m_RecoveryType == T_RebornParnter) then
		refreshPartnerData()
	end
end

--如果回收的是专属宝物，并且专属宝物和武将关联了，则需要手动从背包里删除此专属宝物
function removeSpTreasBy()

	for i = 1,#m_tbSelected do

		if(m_tbSelected[i].equip_hid)then
			logger:debug(m_tbSelected[i].gid)
			-- ItemUtil.reduceItemByGid(m_tbSelected[i].gid,1,true)

			local heroInfo = HeroModel.getHeroByHid(m_tbSelected[i].equip_hid)
			heroInfo.equip.exclusive = {} 
		end
	end
end

--如果回收的是伙伴，并且专属宝物和武将关联了，则需要手动从背包重置次宝物的属性
function resetSpTreasBy()
	for i = 1,#m_tbSelected do
		local tid,hid = ItemUtil.getSpecialOnHero(m_tbSelected[i].id)
		if(tid ~= nil)then
			DataCache.resetTreasureInfoByItemID(hid)
		end
	end
end

--如果回收的是伙伴，并且专属宝物和武将关联了，则需要手动从背包重置次宝物的属性
function removeSpTreasByReborn()
	local tid,hid = ItemUtil.getSpecialOnHero(m_tbSelected[1].id)
	local heroInfo = HeroModel.getHeroByHid(m_tbSelected[1].id)
	heroInfo.equip.exclusive = {} 
end

--如果回收的是专属宝物，则判断被回收的宝物中是否有 后端会给背包推送的
function isAllTreasOnHeros()
	local isb = true
	for i = 1,#m_tbSelected do
		if(m_tbSelected[i].equip_hid)then
		else
			return false
		end
	end
	return true
end

--计算饰品精华的个数
function getTreasItemCount()
	local treasTid = 60008
	local allBagInfo = DataCache.getRemoteBagInfo()
	local item_num = 0
	if( not table.isEmpty(allBagInfo)) then
		if( not table.isEmpty( allBagInfo.props)) then
			for k,item_info in pairs( allBagInfo.props) do
				if(tonumber(item_info.item_template_id) == treasTid) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
	end
	logger:debug(item_num)
	return item_num
end

--计算亚当树的个数
function getShipItemCount()
	local propsTid = 60601
	local allBagInfo = DataCache.getRemoteBagInfo()
	local item_num = 0
	if( not table.isEmpty(allBagInfo)) then
		if( not table.isEmpty( allBagInfo.props)) then
			for k,item_info in pairs( allBagInfo.props) do
				if(tonumber(item_info.item_template_id) == propsTid) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
	end
	logger:debug(item_num)
	return item_num
end
------------红点相关------------- 


function getRecoveryRedPoint()
	if (SwitchModel.getSwitchOpenState( ksSwitchResolve) == false) then
		return false
	else
		logger:debug(m_redPoint)
		for i,v in ipairs(m_redPoint) do
			if(v.call) then

				v.visible = v.call()
				if(v.visible == true) then
					return true
				end
			end
		end
	end
end

function getParnterRedNum()
	getFilterPartnerList(true)
	local nAutoSelectCount = #m_tbParnterAuto
	return nAutoSelectCount >= 5
end

function getShadowRedNum()
	getFilterHeroList(true)
	local nAutoSelectCount = #m_tbShodowAuto
	return nAutoSelectCount >= 5
end

function getEquipRedNum()
	getFiltersForEquips(true)
	local nAutoSelectCount = #m_tbEquipsAuto
	return nAutoSelectCount >= 5
end

function getTreasureRedNum()
	getFiltersForTreas(true)
	local nAutoSelectCount = #m_tbTreasureAuto
	return nAutoSelectCount >= 5
end
-- 按钮红点提示的全局状态变量
m_redPoint = {
				{visible = false, call = getParnterRedNum}, -- 伙伴按钮
				{visible = false, call = getShadowRedNum}, -- 影子按钮
				{visible = false, call = nil}, --伙伴重生
	 			{visible = false, call = getEquipRedNum}, -- 装备背包按钮
	 			{visible = false, call = getTreasureRedNum}, -- 宝物按钮
		 		{visible = false, call = nil}, --专属宝物
		 		{visible = false, call = nil}, --主船
		 		
			}



-- function setTabType(  )
-- 	if (SwitchModel.getSwitchOpenState(ksSwitchReborn,false)) then
-- 		table.remove(tbItem,T_RebornParnter)
-- 		table.remove(tbAddAutoTips,T_RebornParnter)
-- 		table.remove(tbNoItemTips,T_RebornParnter)
-- 		table.remove(tbChoiceTips,T_RebornParnter)
-- 		table.remove(tbRecoveryTips,T_RebornParnter)
-- 		table.remove(tbHelpTips,T_RebornParnter)
-- 		table.remove(tbNoRecoverItemTips,T_RebornParnter)
-- 		table.remove(m_redPoint,T_RebornParnter)
-- 	end

-- 	if (SwitchModel.getSwitchOpenState(ksSwitchMainShip,false)) then

-- 		table.remove(tbItem,T_SPShipItem)
-- 		table.remove(tbAddAutoTips,T_SPShipItem)
-- 		table.remove(tbNoItemTips,T_SPShipItem)
-- 		table.remove(tbChoiceTips,T_SPShipItem)
-- 		table.remove(tbRecoveryTips,T_SPShipItem)
-- 		table.remove(tbHelpTips,T_SPShipItem)
-- 		table.remove(tbNoRecoverItemTips,T_SPShipItem)
-- 		table.remove(m_redPoint,T_SPShipItem)
-- 	end
-- end

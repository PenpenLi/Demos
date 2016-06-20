-- FileName: EquipFixModel.lua
-- Author: zhangjunwu
-- Date: 2014-12-08
-- Purpose: 装备附魔(洗练)数据处理模块
--[[TODO List]]


-- /**
-- 	 * 附魔
-- 	 * 
-- 	 * @param int $itemId			物品id
-- 	 * @param int $itemIds			消耗的物品id组
-- 	 * @param int $type				类型0贝里1金币
-- 	 * @return array
-- 	 * <code>
-- 	 * {
-- 	 * 		'item_id':int			物品ID
-- 	 * 		'item_template_id':int	物品模板ID
-- 	 * 		'item_num':int			物品数量
-- 	 * 		'item_time':int			物品产生时间
-- 	 * 		'va_item_text':			物品扩展信息
-- 	 * 		{
-- 	 * 			'armReinforceLevel':强化等级
--      * 			'armReinforceCost':强化费用
--  	 * 			'armEnchantLevel':附魔等级
--  	 * 			'armEnchantExp':附魔经验
-- 	 * 		}
-- 	 * }
-- 	 */
-- 	public function enchant($itemId, $itemIds, $type);

module("EquipFixModel", package.seeall)
local m_i18n = gi18n
local m_i18nString = gi18nString
-- UI控件引用变量 --

-- 模块局部变量 --
-- local m_tbAllBagInfo 						-- 后端给的原始的背包信息
local m_tbBagInfo 								-- 按类型（装备，道具，宝物等）分类处理后的背包信息
local m_tbStuffData			 			= nil 	--用来附魔的材料	
local m_tbSelectedData 					= nil   --被选中的附魔材料
local m_tbEquipNeedFix          		= nil   --被附魔的装备的id和tid

local m_EnchantType						= 1 	--1为贝里附魔，2为金币附魔 ，默认是贝里附魔
local m_nCurExpByCurLevel 				= 0 	--当前等级升到下一等 所拥有的经验
local m_nExpAdded 						= 0 	--所选择的材料带来的经验值

local m_tbEquipInfo						= nil 
m_nFinalPercent  						= 0      --添加材料之后算出来的最后的百分比
m_nExpOverflow 							= 0 	--每次添加材料i后溢出的经验值

 E_Belly_Type 							= 0
 E_Gold_Type 				    		= 1

function init(...)
	m_tbBagInfo 						= 	nil 	
	m_nCurExpByCurLevel 				=  	0 	
	m_nExpAdded 						= 	0 	

	m_tbStuffData			 			= 	nil 	--用来附魔的材料	
 	m_tbSelectedData 					= 	nil   --被选中的附魔材料
	m_tbEquipNeedFix         			= 	nil   --被附魔的装备的id和tid
	m_tbEquipInfo						= 	nil 
end

function removeSelectedStuff( ... )
	if(m_tbSelectedData ~= nil and m_tbStuffData ~= nil ) then
		for i,v in ipairs(m_tbSelectedData) do

			for _i,_v in ipairs(m_tbStuffData) do
				if(tonumber(v.item_id) == tonumber(_v.item_id)) then
					table.remove(m_tbStuffData,_i)
					break
				end
			end

		end
	end
	m_tbSelectedData = nil 
	m_tbSelectedData = {}
end

--更新附魔材料的数据
function updataFixStuffData()
	m_tbEquipInfo						= 	nil 
	m_nCurExpByCurLevel 				=  	0 	
	m_nExpAdded 						= 	0 	

	initEquipInfo()
	removeSelectedStuff()
end

function getSelectedItemInfo()
	return m_tbSelectedData or {}
end

function destroy(...)
	package.loaded["EquipFixModel"] = nil
end

function moduleName()
    return "EquipFixModel"
end

function create(...)

end
function setCurExpByCurLevel(_curExp)
	m_nCurExpByCurLevel = _curExp

end

--设置附魔方式
function setEnchatType( _type )
	m_EnchantType = _type
	-- EquipFixView.setEnchatBtnCheckBoxState(m_EnchantType)
end

--获取附魔方式
function getEnchatType(  )
	return m_EnchantType
end
 
function setEuipInfo( tbInfo )
	m_tbEquipNeedFix = tbInfo
end

function canGoldFix()
	local goldValue = m_tbEquipInfo.itemDesc.goldValue
	logger:debug(goldValue)
	if(goldValue) then
		return true
	else
		return false
	end
end

--判断装备是否可以附魔
function isEuipCanFixByTid( equipTid )
	local equipInfo = ItemUtil.getItemById(equipTid)
	 --1可以附魔 0 不可以
	local nCanFix  = equipInfo.canEnchant
	logger:debug("此装备是否可以附魔:")
	logger:debug(equipInfo.canEnchant)
	return nCanFix
end

--获得此装备的所有附魔经验
function getAllExp()
	local enchantExp   =   m_tbEquipInfo.va_item_text.armEnchantExp or 0
	return enchantExp
end

--附魔到某一等级所需要的经验
function getEnchatExpByLevel(_level)
	local equipInfo   = ItemUtil.getItemById(m_tbEquipNeedFix.item_template_id)
	local dbEquipt = equipInfo.itemDesc or DB_Item_arm.getDataById(m_tbEquipNeedFix.item_template_id) --表里配的最大附魔等级
	local expId		  = dbEquipt.expId
	require "db/DB_Level_up_exp"
	local dbExp  = DB_Level_up_exp.getDataById(tonumber(expId))
	local s_lv = "lv_" .. _level
	return dbExp[s_lv]
end

--附魔到当前等级下一等级所需要的经验
function getEnchatExpByNextLevel()

	local enchatCurLevel  = getEquipEnchatLevel()

	return getEnchatExpByLevel(enchatCurLevel + 1) or 0
	--logger:debug(nExp)
end

--达到附魔等级所需要的所有经验
function getAllExpToCurLevel()
	local enchatLevel  = getEquipEnchatLevel()
	local allExp = 0
	if(enchatLevel >0) then
		local eachLevelExp  = 0
		for i=1, enchatLevel do
			eachLevelExp = getEnchatExpByLevel(i)
			allExp = allExp + eachLevelExp
		end
	end
	return allExp 
end

--达到附魔最大等级（表里配的最大等级）所需要的所有经验
function getAllExpToMaxDBLevel()
	--表里配的最大附魔等级
	local maxEnchantLV  	= m_tbEquipInfo.itemDesc.maxEnchantLV

	local allExpToMax = 0
	if(maxEnchantLV >0) then
		local eachLevelExp  = 0
		for i=1, maxEnchantLV do
			eachLevelExp = getEnchatExpByLevel(i)
			allExp = allExp + eachLevelExp
		end
	end
	return allExpToMax 
end


--获取装备的最大附魔等级
function getMaxEnchatLevel()
	return ItemUtil.getMaxEnchatLevel(m_tbEquipInfo)
end

function getDBMacEnchantLevel()

	return  m_tbEquipInfo.itemDesc.maxEnchantLV or 0
end

function initEquipInfo()
	if(m_tbEquipInfo == nil ) then
		local equip_item_id = m_tbEquipNeedFix.item_id
		m_tbEquipInfo =  ItemUtil.getItemInfoByItemId(equip_item_id)

		if(m_tbEquipInfo == nil ) then
			m_tbEquipInfo = ItemUtil.getEquipInfoFromHeroByItemId(tonumber(equip_item_id))
			logger:debug(m_tbEquipInfo)
		end
		if(m_tbEquipInfo and not m_tbEquipInfo.itemDesc) then
			m_tbEquipInfo.itemDesc = DB_Item_arm.getDataById(m_tbEquipInfo.item_template_id)
		end
	end
	return m_tbEquipInfo
end

--获取需要附魔的装备的附魔等级
function getEquipEnchatLevel()
	logger:debug("次装备的附魔等级是:")
	logger:debug(m_tbEquipInfo.va_item_text.armEnchantLevel)
	if(m_tbEquipInfo.va_item_text.armEnchantLevel) then
		return tonumber(m_tbEquipInfo.va_item_text.armEnchantLevel)
	else
		return 0
	end
end

--获得装备的名字
function getEquipNameByTid()
	local equipName = m_tbEquipInfo.itemDesc.name
	return equipName
end

-- 按装备的tid高低排序 
local function fnCompareWithTid(h1, h2)
    return h1.tid < h2.tid
end

-- 按装备的基础经验
local function fnCompareWithBaseExp(h1, h2)
    if tonumber(h1.baseEnchantExp)  == tonumber(h2.baseEnchantExp) then
        return fnCompareWithTid(h1, h2)
    else
        return (tonumber(h1.baseEnchantExp) or 0) < (tonumber(h2.baseEnchantExp) or 0)
    end
end

-- 按装备的基品级
local function fnCompareWithBaseBaseScore(h1, h2)
    if tonumber(h1.nScore)  == tonumber(h2.nScore) then
        return fnCompareWithBaseExp(h1, h2)
    else
        return h1.nScore < h2.nScore
    end
end

--附魔材料排序
local function fixStuffSort( item_1, item_2 )
	if (tonumber(item_1.nQuality)  == tonumber(item_2.nQuality)) then
        return fnCompareWithBaseBaseScore(item_1, item_2)
    else
        return item_1.nQuality < item_2.nQuality
    end
end

local m_tbAllStuffInfo = {}
function getEnchatExpByItemId(item_id)
 	for i,v in ipairs(m_tbAllStuffInfo) do
 		if(tonumber(item_id) == tonumber(v.tid)) then
 			return v.base_exp
 		end
 	end
 	return 0
 end 

--初始化所有的材料信息
function setFixStuff()
	m_tbAllStuffInfo = {}
	local tbAllStuffId = {60501,60502,60503,60504}
	m_tbBagInfo = DataCache.getBagInfo() or {}
	for i,tid in ipairs(tbAllStuffId) do
		local tbStuffInfo  = {}
		logger:debug(tid)
		local itemData = ItemUtil.getItemById(tid)
		tbStuffInfo.tid = tid
		tbStuffInfo.name = itemData.name
		tbStuffInfo.picPath = itemData.imgFullPath
		tbStuffInfo.base_exp = itemData.enhance_exp
		tbStuffInfo.item_num = 0
		tbStuffInfo.quality = itemData.quality
		for k,v in pairs(m_tbBagInfo.props) do
			if(tonumber(tid) == tonumber(v.item_template_id)) then
				-- tbStuffInfo = v
				tbStuffInfo.item_num = tonumber(v.item_num)
				tbStuffInfo.item_id = tonumber(v.item_id)
	
				break
			end
		end
		table.insert(m_tbAllStuffInfo,tbStuffInfo)
	end
	logger:debug(m_tbAllStuffInfo)
	return m_tbAllStuffInfo
end

-- 获取所有可以用来被附魔的装备信息
function getAllQuipInfoForFix()
	return {}
	-- if(m_tbStuffData == nil ) then
	-- 	m_tbStuffData = {}
	-- 	--需要附魔的装备的品质
	-- 	local needFixEquipDesc = DB_Item_arm.getDataById(m_tbEquipNeedFix.item_template_id)
	-- 	local nQuality   = needFixEquipDesc.quality 

	-- 		m_tbBagInfo = DataCache.getBagInfo() or {}
	-- 		--logger:debug(bagInfo.arm )
	-- 		--用来附魔的材料
	
	-- 		for k,v in pairs(m_tbBagInfo.arm) do
	-- 			local baseEnchantExp = v.itemDesc.baseEnchantExp or 0
	-- 			local nQuality1   = v.itemDesc.quality 
	-- 			local isexpArm    = tonumber(v.itemDesc.type) -- 2015-04-16, zhangqi, 修改新的经验装备判断，子类型 type == 5
	-- 			--装备附魔基础经验 》 0  即可以用来被当做附魔材料 ,品质小余要附魔的的物品品质，并且不能选择自己
	-- 			local bIsSameQuip = v.item_id == m_tbEquipNeedFix.item_id
	-- 			-- logger:debug(bIsSameQuip)

	-- 			if ((tonumber(baseEnchantExp) > 0 and nQuality >= nQuality1) or isexpArm == 5) then -- 2015-04-16, zhangqi
	-- 					local tb = {}
	-- 					tb.tid 				= v.item_template_id
	-- 					tb.name 			=  v.itemDesc.name
	
	-- 					tb.item_id   		= v.item_id
	-- 					tb.nQuality 		=  v.itemDesc.quality 
	-- 					tb.nScore 			= v.itemDesc.base_score
	-- 					tb.armReinforceCost = v.va_item_text.armReinforceCost  or  0			--强化费用

	-- 				--zhangjunwu 1.01-11-1 临时背包里的装备碎片 不出现在出售列表
	-- 	            -- if (tonumber(v.gid) >= 2000001 and tonumber(v.gid) < 3000000 and bIsSameQuip == false) then
	-- 	                --table.insert(tbCells, tbData)
	-- 	            -- end
	-- 	            if (bIsSameQuip == false) then
	-- 	                table.insert(m_tbStuffData,tb)
	-- 	            end
	-- 			end
	-- 		end

	-- 		table.sort(m_tbStuffData,fixStuffSort)
	-- 		--logger:debug(m_tbStuffData)
	-- 		return m_tbStuffData
	-- else
	-- 	return m_tbStuffData
	-- end
end

function getItemInfoByIndex( _index )
	local tbStuff = m_tbAllStuffInfo[_index]
	return  tbStuff or {}
end

--判断一个材料是否已经被选中
function isItemSelected(index)
	logger:debug("选中的数据是：")
	logger:debug(m_tbSelectedData)

	local tbStuff = m_tbStuffData[index]
	logger:debug("被点击的材料的信息是:")
	logger:debug(tbStuff)
	for i=1,#(m_tbSelectedData or {}) do
		if(tonumber(m_tbSelectedData[i].item_id) == tonumber(tbStuff.item_id)) then
			return true
		end
	end

	return false
end

--附魔等级是否达到最大
function isEnchantLvLimited( ... )
	local maxEnchantLv = getMaxEnchatLevel()
	local curEnchantLv = getEquipEnchatLevel()
	if(curEnchantLv >= maxEnchantLv) then
		return true 
	else

		return false
	end
end

--自动添加
function addAllStuff()
	m_tbSelectedData = nil
	m_tbSelectedData = {}

	m_tbSelectedData = table.hcopy (m_tbStuffData ,m_tbSelectedData)
end

--自动反添加
function removeAllSelectStuff( )
	m_tbSelectedData = nil
	m_tbSelectedData = {}
end

--添加一个材料
function addSelectStuff(index )
	if(m_tbSelectedData == nil) then
			m_tbSelectedData = {}
	end	

	local tbStuff = m_tbStuffData[index]

	table.insert(m_tbSelectedData,tbStuff) 
end

--删除一个材料
function removeSelectStuff(index )
	if(m_tbSelectedData == nil) then
		return 
	end

	local tbStuff = m_tbStuffData[index]
	logger:debug("被点击的材料的信息是:")
	logger:debug(tbStuff)

	local removeIndex = 0
	for i=1,#(m_tbSelectedData or {}) do
		if(tonumber(m_tbSelectedData[i].item_id) == tonumber(tbStuff.item_id)) then

			removeIndex = i

			break
		end
	end

	table.remove(m_tbSelectedData,removeIndex)

end

-- --计算经验值
-- function calculateExp()
-- 	if(m_tbSelectedData == nil ) then
-- 		return 
-- 	end

-- 	m_nExpAdded = 0
-- 	for i=1,#(m_tbSelectedData or {}) do
-- 		m_nExpAdded = m_nExpAdded + getEnchatExpByItemId(m_tbSelectedData[i].item_id)
-- 	end

-- 	logger:debug("所选的材料能提供的所有经验值为：---------------------")
-- 	logger:debug(m_nExpAdded)


-- 	local nSelectdCount = #m_tbSelectedData
-- 	local nStuffCount = #m_tbStuffData
-- 	logger:debug("被选中的材料个数为:" .. nSelectdCount)
-- 	logger:debug("所有的的材料个数为:" .. nStuffCount)

-- 	if(nSelectdCount == 0 and nStuffCount > 0) then
-- 		EquipFixView.setAddBTNState(true)
-- 	end

-- 	if((nSelectdCount == nStuffCount) and nStuffCount > 0) then
-- 		EquipFixView.setAddBTNState(false)
-- 	end
	
-- 	updateExpBar()
-- end


--更新附魔经验相关的ui
-- function updateExpBar()
	
-- 	local maxEnchantLv = getMaxEnchatLevel()
-- 	logger:debug("最大附魔等级是:" .. maxEnchantLv)

-- 	local curEnchantLv = getEquipEnchatLevel()

-- 	--当前装备所拥有的所有经验
-- 	local equipAllExp =  getAllExp()
-- 	--附魔到当前等级所需要的所有附魔经验
-- 	local expNeeded = getAllExpToCurLevel()
-- 	local curExp = equipAllExp - expNeeded
-- 	--一共的经验  =   以前剩余的 + 材料提供
-- 	logger:debug(m_nExpAdded)
-- 	local expTotle = curExp + m_nExpAdded

-- 	if(maxEnchantLv == 0 ) then
-- 		--	[5220] = "只能附魔强化过的装备",
-- 		ShowNotice.showShellInfo(m_i18n[5220])
-- 		return
-- 	end
-- 		--添加的材料可以 附魔升级 几级
-- 	local index = 0
-- 	local requirExp = 0 
-- 	m_nExpOverflow = 0
-- 	m_nFinalPercent= 0 
-- 	local nExpOwn = expTotle
-- 	local nExpLeft  = expTotle

-- 	for i = curEnchantLv + 1, maxEnchantLv do
-- 		local nExpByLevel = getEnchatExpByLevel(i)
-- 		logger:debug("升满低%s级 需要的经验是:%s" , i,nExpByLevel)
-- 		requirExp =  requirExp + nExpByLevel

-- 		logger:debug("累计所需要的经验是:%s" ,requirExp)
-- 		nExpLeft = nExpLeft - nExpByLevel
-- 		logger:debug("除去用来升级，剩下的经验是:%s" ,nExpLeft)
-- 		if(nExpLeft < 0) then

-- 			m_nFinalPercent = (nExpByLevel - (nExpLeft * -1)) / nExpByLevel * 100
-- 		else
-- 			-- nExpOwn = nExpOwn - nExpByLevel
-- 		end

-- 		logger:debug(m_nFinalPercent)

-- 		if(requirExp > expTotle) then
-- 			-- m_nFinalPercent = (nExpByLevel - requirExp - expTotle) / nExpByLevel * 100
-- 			break
-- 		end
-- 		m_nFinalPercent = 100
-- 		index = index + 1
-- 	end

-- 	m_nExpOverflow = expTotle - requirExp
-- 	logger:debug("溢出的附魔经验是:")
-- 	logger:debug(m_nExpOverflow)

-- 	logger:debug("所选的材料能让装备提高多少级的附魔等级呢？----%s" , index)
-- 	--更新经验进度条
-- 	EquipFixView.updateAddExpBar(m_nExpAdded)
-- 	--更新附魔增加的等级
-- 	logger:debug("updateExpBar")
-- 	EquipFixView.updateEnchantAddLevel(index)
-- 	EquipFixView.setBellyAndGoldImage()
-- end


--获取贝里附魔的经验系数
local function getEnchantBellyRatio()
	--贝里消耗系数|贝里经验系数
	local bellyValue = m_tbEquipInfo.itemDesc.bellyValue
	--贝里消耗系数
	local bellyNum = string.split(bellyValue,"|")
	-- logger:debug("贝里附魔系数:")
	-- logger:debug(bellyNum)
	return bellyNum
end

--获取金币附魔的金币系数
local function getEnchantGoldRatio()
	--金币消耗系数|金币经验系数
	local goldValue = m_tbEquipInfo.itemDesc.goldValue or  0
	return goldValue
end

--获得装备的附魔解锁属性
function getEquipLockEnchantAffix()
	-- 解锁属性
	local  tbInfoLock =  m_tbEquipInfo.itemDesc.addEnchantAffix
	logger:debug(tbInfoLock)
	local lockInfo = string.split(tbInfoLock,",")
	local nEnchatLv =  tonumber(m_tbEquipInfo.va_item_text.armEnchantLevel or 0)

	--下一级解锁锁带来的属性加成
	local nextLockInfo = {}
	--当前等级的下一级解锁 是多少级
	local nextLevel = 0
	for i,v in ipairs(lockInfo) do
		local tbEachInfo 		= string.split(v,"|")
		local unLockLevel 		= tonumber(tbEachInfo[1])
		local unLockAttrId 		= tbEachInfo[2]
		local unLockAttrValue 	= tbEachInfo[3]
		if(unLockLevel > nEnchatLv)then
			nextLevel = unLockLevel
			break
		end
	end

	-- local strUnlockStr =  ""
	local dbMaxEnchantLv = getDBMacEnchantLevel()
	if(nextLevel > dbMaxEnchantLv or not tbInfoLock or nextLevel == 0) then
		return nextLockInfo
	end
	for i,v in ipairs(lockInfo) do
		local tbEachInfo 		= string.split(v,"|")
		local unLockLevel 		= tonumber(tbEachInfo[1])
		local unLockAttrId 		= tbEachInfo[2]
		local unLockAttrValue 	= tbEachInfo[3]
		if(unLockLevel == nextLevel )then
			local affixStr = ItemUtil.parseAffixString(unLockAttrId .."|" .. unLockAttrValue .. ",")
			affixStr = affixStr[1]
			local tb = {}
			tb.descName = affixStr.name
			tb.openLv = unLockLevel
			tb.affixType= DB_Affix.getDataById(unLockAttrId).type
			tb.realNum = affixStr.realNum --特效出需要
			if (string.find(affixStr.num, "%%")) then
				local displayNum = affixStr.realNum / 100 
				if(displayNum > math.floor(displayNum))then
					displayNum = string.format("%.1f", displayNum)
				end
				tb.descString = string.format("+%s%%", displayNum)
			else
				tb.descString = string.format("+%d",   affixStr.num)
			end
			table.insert(nextLockInfo,tb)
		end
	end
	return nextLockInfo
end

--附魔增加n级 带来的属性加成
function getEnchatAffixByLevelUp()
	getEquipLockEnchantAffix()
	local t_numerial, t_numerial_PL,t_equip_score,equipData = ItemUtil.getEquipNumerialByIID(tonumber(m_tbEquipInfo.item_id))
	local nEnchatLv = m_tbEquipInfo.va_item_text.armEnchantLevel or 0
	local enchantAffix = m_tbEquipInfo.itemDesc.enchantAffix or {}
	logger:debug(enchantAffix)

	local  addEnchantAffix = m_tbEquipInfo.itemDesc.enchantAffix
	local tbAffixInfo  = string.split(addEnchantAffix,",") or {}
	local dbMaxEnchantLv = getDBMacEnchantLevel()

	local nNextLv = (nEnchatLv + 1) > dbMaxEnchantLv and dbMaxEnchantLv or (nEnchatLv + 1)

	local tbAddAffix = {}
	local preciFmt = "%." .. 1 .. "f"
	for k, str_act in pairs(tbAffixInfo) do
		local temp_act_arr = string.split(str_act, "|")
 		local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(temp_act_arr[1]),tonumber(temp_act_arr[2]))
 		local tb = {}
		tb.affixName = baseInfo.displayName
		if(baseInfo.type == 3)then
			local showNum = realNum * nEnchatLv  / 100
			local showNumNext = realNum * nNextLv / 100
			if(showNum > math.floor(showNum))then
				showNum = string.format(preciFmt, showNum)
			end
			showNum = showNum .. "%"

			if(showNumNext > math.floor(showNumNext))then
				showNumNext = string.format(preciFmt, showNumNext)
			end
			showNumNext = showNumNext .. "%"

			tb.AttrValue = showNum
			tb.AttrValueNextLv = showNumNext
		else
			tb.AttrValue = realNum * nEnchatLv 
			tb.AttrValueNextLv = realNum * nNextLv
		end
 
		tb.enchantAffix = realNum   --升级的时候 提示提升多少属性用的
		tb.displayNumType = baseInfo.type   --升级的时候 提示提升多少属性用的
		table.insert(tbAddAffix,tb)

	end
	logger:debug(tbAddAffix)
	return tbAddAffix
end

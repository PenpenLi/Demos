-- Filename：	BagUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-9-10
-- Purpose：		物品Item
-- modified: 
-- zhangqi, 2015-05-18, 后端在baginfo中增加了一个gradInit的table,存放某些背包的默认携带数常量便于前后统一使用

module("BagUtil", package.seeall)


require "script/utils/LuaUtil"


function getNextOpenPropGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.props - bagInfo.gridInit.props) / 5 + 1) * 5*5
	end 
	return price
end

function getNextOpenArmFragGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.armFrag - bagInfo.gridInit.armFrag) / 5 + 1) * 5*5
	end 
	return price
end

function getNextOpenArmGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.arm - bagInfo.gridInit.arm) / 5 + 1) * 5*5
	end
	return price
end

function getNextOpenExclGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.excl - bagInfo.gridInit.excl) / 5 + 1) * 5*5
	end
	return price
end

function getNextOpenExclFragGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.exclFrag - bagInfo.gridInit.exclFrag) / 5 + 1) * 5*5
	end
	return price
end

function getNextOpenTreasGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.treas - bagInfo.gridInit.treas) / 5 + 1) * 5*5
	end
	return price
end

function getNextOpenDressGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.dress - 100) / 5 + 1) * 5*5
	end
	return price
end

-- 觉醒背包
function getNextOpenAwakeGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.awake - bagInfo.gridInit.awake) / 5 + 1) * 5*5
	end
	return price
end

--zhangqi, 2015-11-17, 指定bagHandler类型返回开格子价格
function getNextOpenPriceByType( bagHandlerType )
	local hType = bagHandlerType
	local typeStr = BAG_TYPE_STR

	local bagInfo = DataCache.getRemoteBagInfo()
	if (table.isEmpty(bagInfo)) then
		return 0 -- 默认返回 0
	end

	local counter = {} -- 各种背包开格子的计算公式
	counter[typeStr.treas] = ((bagInfo.gridMaxNum[hType] - bagInfo.gridInit[hType]) / 5 + 1) * 5*5

	return counter[hType]
end

-- 装备碎片排序
function equipFragSort( equip_1, equip_2 )
	local isPre = false

	local equip1Tid 	= equip_1.item_template_id
  	require "script/module/public/ItemUtil"
  	local frag1DBInfo 	= ItemUtil.getItemById(equip1Tid)
  	local aim1Tid		= frag1DBInfo.aimItem
  	local item1DBInfo 	= ItemUtil.getItemById(aim1Tid)

	local equip2Tid 	= equip_2.item_template_id
  	require "script/module/public/ItemUtil"
  	local frag2DBInfo 	= ItemUtil.getItemById(equip2Tid)
  	local aim2Tid		= frag2DBInfo.aimItem
  	local item2DBInfo 	= ItemUtil.getItemById(aim2Tid)

	if( tonumber(item1DBInfo.quality) > tonumber(item2DBInfo.quality))then
		isPre = true
	elseif(tonumber(item1DBInfo.quality) == tonumber(item2DBInfo.quality))then
		if(tonumber(item1DBInfo.type) < tonumber(item2DBInfo.type))then
			isPre = true
		elseif(tonumber(item1DBInfo.type) == tonumber(item2DBInfo.type))then
			local t_equip_score_1 = item1DBInfo.base_score
			local t_equip_score_2 = item2DBInfo.base_score

			if(t_equip_score_1 > t_equip_score_2)then
				isPre = true
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end
	return isPre
end
-- 装备排序算法 （策划需求的 逆序）
function equipSort( equip_1, equip_2 )
	local isPre = false

	local equip1Tid = equip_1.item_template_id
  	require "script/module/public/ItemUtil"
  	local item1DBInfo = ItemUtil.getItemById(equip1Tid)

	local equip2Tid = equip_2.item_template_id
  	local item2DBInfo = ItemUtil.getItemById(equip2Tid)

	if( tonumber(item1DBInfo.quality) > tonumber(item2DBInfo.quality))then
		isPre = true
	elseif(tonumber(item1DBInfo.quality) == tonumber(item2DBInfo.quality))then
		if(tonumber(item1DBInfo.type) < tonumber(item2DBInfo.type))then
			isPre = true
		elseif(tonumber(item1DBInfo.type) == tonumber(item2DBInfo.type))then
			local t_equip_score_1 = item1DBInfo.base_score + tonumber(equip_1.va_item_text.armReinforceLevel) * item1DBInfo.grow_score
			local t_equip_score_2 = item2DBInfo.base_score + tonumber(equip_2.va_item_text.armReinforceLevel) * item2DBInfo.grow_score

			if(t_equip_score_1 > t_equip_score_2)then
				isPre = true
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end
	return isPre
end

-- 宝物排序算法
--[[
-- modified by zhangqi, 2014-04-24
海贼卡牌宝物排序需求
先判断宝物是否已经装备，已装备的宝物>未装备宝物。
然后按照宝物品质排序，高品质>低品质
最后按照宝物ID排序，ID大>ID小
]]
function treasSort( equip_1, equip_2 )
	local isPre = false
	if( tonumber(equip_1.itemDesc.quality) > tonumber(equip_2.itemDesc.quality))then
		isPre = true
	elseif(tonumber(equip_1.itemDesc.quality) == tonumber(equip_2.itemDesc.quality))then

		if(tonumber(equip_1.itemDesc.id) == tonumber(equip_2.itemDesc.id)) then

			if (tonumber(equip_1.item_id) > tonumber(equip_2.item_id)) then
				isPre = true
			end
		else
			isPre = tonumber(equip_1.itemDesc.id) > tonumber(equip_2.itemDesc.id)
		end
	end
	-- 	if(tonumber(equip_1.itemDesc.type) > tonumber(equip_2.itemDesc.type))then
	-- 		isPre = true
	-- 	elseif(tonumber(equip_1.itemDesc.type) == tonumber(equip_2.itemDesc.type))then
	-- 		local t_equip_score_1 = equip_1.itemDesc.base_score + tonumber(equip_1.va_item_text.treasureLevel) * equip_1.itemDesc.increase_score
	-- 		local t_equip_score_2 = equip_2.itemDesc.base_score + tonumber(equip_2.va_item_text.treasureLevel) * equip_2.itemDesc.increase_score

	-- 		if(t_equip_score_1 < t_equip_score_2)then
	-- 			isPre = true
	-- 		else
	-- 			isPre = false
	-- 		end
	-- 	else
	-- 		isPre = false
	-- 	end
	-- else
	-- 	isPre = false
	-- end
	return isPre
end

function getPropOrderPriority( item_template_id )
	item_template_id = tonumber(item_template_id)
	local orderN = 0
	if(item_template_id >= 30001 and item_template_id <= 40000) then  -- Item_randgift
		orderN = 1
	elseif(item_template_id >= 20001 and item_template_id <= 30000) then -- Item_gift, 2015-07-30
		orderN = 2
	elseif(item_template_id >= 10001 and item_template_id <= 20000) then -- item_direct
		orderN = 3
	elseif(item_template_id >= 40001 and item_template_id <= 50000) then -- item_star_gift
		orderN = 4
	elseif(item_template_id >= 60001 and item_template_id <= 70000) then -- item_normal
		orderN = 5
	else
		orderN = 6
	end
	return orderN
end

-- 道具排序 （策划需求的 逆序）
-- modified by zhangqi, 2014-04-23
--[[
海贼卡牌道具排序需求：
首先根据物品种类排序
Item_randgift>item_direct>item_star_gift>item_normal
在同种类物品中，按照物品品质排序，高品质>低品质
在同种类同品质物品中，按照物品 ID排序，ID大>ID小
]]
function propsSort( item_1, item_2 )
	local order_1 = getPropOrderPriority(item_1.item_template_id)
	local order_2 = getPropOrderPriority(item_2.item_template_id)
	local isPre = false

	if (order_1 < order_2) then
		isPre = true
	elseif (order_1 == order_2) then
		if ( tonumber(item_1.itemDesc.quality) > tonumber(item_2.itemDesc.quality) ) then
			isPre = true
		elseif (tonumber(item_1.itemDesc.quality) == tonumber(item_2.itemDesc.quality) ) then
			if (tonumber(item_1.item_template_id) > tonumber(item_2.item_template_id)) then
				isPre = true
			end
		end
	end

	return isPre
end
-- zhangqi, 2014-12-22, 得到了新道具后打开背包时需要先按是否新道具来排序
-- 在 propsSort 基础上增加了根据背包推送中新加的字段：newOrder（新物品的序号）按降序排序，没有变化的物品序号为0
function newPropsSort( item_1, item_2 )
	local order_1 = getPropOrderPriority(item_1.item_template_id)
	local order_2 = getPropOrderPriority(item_2.item_template_id)
	local isPre = false

	if (item_1.newOrder > item_2.newOrder) then
		isPre = true
	elseif (item_1.newOrder == item_2.newOrder) then
		if  (order_1 < order_2) then
			isPre = true
		elseif (order_1 == order_2) then
			if ( tonumber(item_1.itemDesc.quality) > tonumber(item_2.itemDesc.quality) ) then
				isPre = true
			elseif (tonumber(item_1.itemDesc.quality) == tonumber(item_2.itemDesc.quality) ) then
				if (tonumber(item_1.item_template_id) > tonumber(item_2.item_template_id)) then
					isPre = true
				end
			end
		end
	end

	return isPre
end

function addNewFlgToCell( layNew )
	local newFlag = UIHelper.createArmatureNode({
		filePath = "images/effect/newhero/new.ExportJson",
		animationName = "new",
	})
	newFlag:setAnchorPoint(ccp(0, 0))
	layNew:addNode(newFlag)
end

-- 从背包中选出宝物
function getTreasInfosExceptGid(ex_itemId, posType)
	local bagInfo = DataCache.getBagInfo()
	local treas_bag = bagInfo.treas
	if(ex_itemId and posType)then
		local temp_treas = {}
		ex_itemId = tonumber(ex_itemId)
		for k,v in pairs(treas_bag) do
			if(tonumber(v.item_id) ~= ex_itemId and tonumber(posType) == tonumber(v.itemDesc.type))then
				table.insert(temp_treas, v)
			end
		end
		treas_bag = temp_treas
	end

	return treas_bag
end

-- 解析特定字符串 (0|100,1|200)
function parseTreasString( treas_str )
	local result_arr = {}
	local t_arr = string.split(string.gsub(treas_str, " ", ""), "," )
	for k,v in pairs(t_arr) do
		local tt_arr = string.split(string.gsub(v, " ", ""), "|" )
		result_arr[tt_arr[1]] = tonumber(tt_arr[2])
	end
	return result_arr
end

-- 计算宝物的升级概率
function getTreasUpgradeRate( item_id, m_item_ids )
	local rate = 0
	if( item_id and (not table.isEmpty(m_item_ids)) )then
		local s_total = 0
		for k, itemId in pairs(m_item_ids) do
			local itemInfo = ItemUtil.getItemInfoByItemId(tonumber(itemId))
			itemInfo.itemDesc = ItemUtil.getItemById(tonumber(itemInfo.item_template_id))
			local result_arr = parseTreasString(itemInfo.itemDesc.base_exp_arr)
			s_total = s_total + result_arr["" .. itemInfo.va_item_text.treasureLevel]
		end
		local item_Info = ItemUtil.getItemInfoByItemId(tonumber(item_id))

		if(table.isEmpty(item_Info))then
			item_Info = ItemUtil.getTreasInfoFromHeroByItemId(tonumber(item_id))
		end
		item_Info.itemDesc = ItemUtil.getItemById(tonumber(item_Info.item_template_id))
		local result_arr = parseTreasString(item_Info.itemDesc.total_upgrade_exp)
		local t_total = result_arr["" .. item_Info.va_item_text.treasureLevel]
		rate = s_total/t_total
	end
	rate = rate > 1 and 1 or rate
	
	return rate
end

-- 计算宝物的获得的经验
function getTreasAddExpBy( m_item_ids )

	local totalExp = 0
	for k, m_item_id in pairs(m_item_ids) do
		local item_Info = ItemUtil.getItemInfoByItemId(tonumber(m_item_id))

		totalExp = totalExp + ItemUtil.getBaseExpBy(item_Info.item_template_id, tonumber(item_Info.va_item_text.treasureLevel)) + tonumber(item_Info.va_item_text.treasureExp)

	end

	return totalExp
end

-- 计算宝物升级所需硬币
function getCostSliverByItemId( item_id )
	local item_Info = ItemUtil.getItemInfoByItemId(tonumber(item_id))

	if(table.isEmpty(item_Info))then
		item_Info = ItemUtil.getTreasInfoFromHeroByItemId(tonumber(item_id))
	end
	item_Info.itemDesc = ItemUtil.getItemById(tonumber(item_Info.item_template_id))
	local result_arr = parseTreasString(item_Info.itemDesc.upgrade_cost_arr)
	local costSliver = result_arr["" .. item_Info.va_item_text.treasureLevel]
	local levelLimited = item_Info.itemDesc.level_limited
	costSliver = costSliver or 0
	
	return costSliver, levelLimited
end

-------------- 添加装备碎片能合成个数提示  by licong---------------    
-- 装备碎片能合成装备的个数
function getCanCompoundNumByArmFrag( ... )
	local bagInfo = DataCache.getBagInfo()
	local  armFragData = {}
	if (bagInfo) then
		armFragData = bagInfo.armFrag
	end
	-- print("装备碎片数据：")
	-- print_t(armFragData)
	local num = 0
	for k,v in pairs(armFragData) do
		if( tonumber(v.itemDesc.need_part_num) <= tonumber(v.item_num) )then
			num = num + 1
		end
	end
	return num
end

-- 是否显示装备按钮上红圈
function isShowTipSprite( ... )
	local num = getCanCompoundNumByArmFrag()
	if(num > 0)then
		return true
	else
		return false
	end
end

----------------------------------------------------------















-- FileName: MainAwakeModel.lua
-- Author: Xufei
-- Date: 2015-11-16
-- Purpose: 伙伴觉醒主界面 数据
--[[TODO List]]

module("MainAwakeModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _allHeroModel = nil
local _canSlip = nil
local _nowHid = nil
local _nowIndex = nil
local _partnerNum = nil
local _btnEvent = nil
local _partnerListWithNoEmpty = {} -- 伙伴数据表
local _classOfChildNeeds = 0	-- 用于在递归时记录合成层数
local _tbItemIds = {}			-- 用于记录查询过的itemId
local _tbItemInfos = {}			-- 用于记录查询过的item的数量
local _tbPreAttrs = {}			-- 用于记录增加前的属性
local _tbDBHerosDisIds = {}		-- 记录计算过的的英雄的disId表

local _tbDBItemDis = {}
local _tbDBHeros = {}
local _tbDBDis = {}

local _i18n = gi18n

local function init(...)
	_allHeroModel = nil
	_canSlip = nil
	_nowHid = nil
	_nowIndex = nil
	_partnerNum = nil
	_partnerListWithNoEmpty = {}
end

--[[desc:计算背包中的是否够
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getIfEnough( itemId, needNum )
	return ItemUtil.getAwakeNumByTid(itemId) >= needNum
end


----------------------------------------计算是否能合成 begin
--[[desc:计算能否足够合成本物品，对外的接口为: mainGetIfCanCompose(itemId, needNum)
    arg1: 需要计算的物品id(觉醒道具)，需要的数量
    return: 如果背包里本来就足够，或者有足够的子物品来合成，返回true，否则，返回false
—]]
-- 将背包中的物品数量进行缓存，并在计算消耗时减少相应的物品的数量，满足同一子物品可以合成多种父物品的情况
local function getItemRemainNumById( itemId, needNum )
	-- 如果记录表里没有此id，则记录下来，并减少消耗的个数，否则，找到对应的记录，减去需要的数字并返回
	if (not table.include(_tbItemIds, itemId)) then
		table.insert(_tbItemIds, itemId)
		local tbTempInfo = {}
		tbTempInfo.id = itemId
		tbTempInfo.num = ItemUtil.getAwakeNumByTid(itemId) - needNum
		table.insert(_tbItemInfos, tbTempInfo)
		return tbTempInfo.num
	else
		for k,v in ipairs(_tbItemInfos) do
			if (v.id == itemId) then
				v.num = v.num - needNum
				return v.num
			end
		end
	end
end

-- 根据父物品所缺，获得需要多少子物品以及他们的id
local function getComposNeedByItemId( itemId, parentItemNeedNum )
	local itemDB = DB_Item_disillusion.getDataById(itemId)
	-- 如果没有合成路径，则返回nil，否则，返回合成所需的三个材料，以及他们的需要的数量
	if (itemDB.need_items == nil) then
		return nil
	else
		local tbNeedItems = {}
		local tempNeedItems = lua_string_split(itemDB.need_items or {},",")
		for k,v in ipairs(tempNeedItems or {}) do
			local tbNeedItem = lua_string_split(v,"|")
			local temp = {}
			temp.itemNeedId = tonumber(tbNeedItem[1])
			temp.itemNeedNum = tonumber(tbNeedItem[2]) * parentItemNeedNum
			table.insert(tbNeedItems, temp)
		end
		return tbNeedItems
	end
end

-- 判断当前物品是否满足需求，或者是否足够被合成
local function ifCanComposeNow( itemId, needNum )
	-- 当前背包里扣除需要的，还剩几个物品（可以小余0）
	local itemNum = getItemRemainNumById(itemId, needNum)
	-- 如果已经满足，则返回true，否则，查看它的合成路径，并依次查看每条路径是否满足
	if (itemNum>=0) then
		return true
	else
		-- 此物品的合成路径（配置为三个子物品）
		local tbComposNeed = getComposNeedByItemId(itemId, -itemNum)
		-- 如果没有合成路径，则返回false，否则，依次判断三个合成路径是否满足条件，若有不满足的，返回false，如果全部满足，返回true
		if (tbComposNeed == nil) then
			return false
		else
			for k,v in pairs(tbComposNeed) do
				if (not ifCanComposeNow( v.itemNeedId, v.itemNeedNum )) then
					return false
				end
			end
			return true
		end
	end
end

-- 对外使用的接口
function mainGetIfCanCompose( itemId, needNum )
	_tbItemIds = {}
	_tbItemInfos = {}
	return ifCanComposeNow(itemId, needNum)
end
----------------------------------------计算是否能合成 end

----------------------------------------获得合成表 begin
--[[desc:通过觉醒物品id，获得它的所有合成表，子物品可以被合成的，会递归到最底层的物品
		 对外的接口：getComposTableByItemId(itemId, needNum)
    arg1: 物品id，需要的数量（可选）
    return: 
{
	classNum = 0						-- 表示从输入的物品开始，向下递归了几层子物品，最外层从0开始
	childItems = {						-- 子合成物品表，内部格式每一层都一样
		1 = {
			classNum = 1
			childItems = {
				1 = {...}
				2 = {...}
				3 = {...}	
			itemDB = {...}
			itemNeedNum = 1
			canCompose = 1
			itemId = 811002
			}	
		2 = {...}
		3 = {...}
	itemDB = {...}						-- 本物品的详细信息
	itemNeedNum = 0						-- 表示需要多少来合成，最外层默认为0
	canCompose = 1						-- 为1表示非原子物品，可以被其他合成，为0则不行
	itemId = 831003						-- 本物品id
}
—]]
local function insertNeedItem(itemId, needNum, classNum)
	_classOfChildNeeds = _classOfChildNeeds+1
	local itemDB = DB_Item_disillusion.getDataById(itemId)
	local needInfo = {}
	needInfo.itemId = itemId
	needInfo.itemDB = itemDB
	needInfo.itemNeedNum = needNum
	needInfo.childItems = {} 
	needInfo.canCompose = 0
	needInfo.classNum = classNum
	if (itemDB.need_items) then
		needInfo.canCompose = 1
		local tbNeedItems = lua_string_split(itemDB.need_items or {},",")
		for i,needItem in ipairs(tbNeedItems or {}) do
			local tbGoodInfo = lua_string_split(needItem,"|")
			local itemNeedId = tonumber(tbGoodInfo[1])
			local itemNeedNum = tonumber(tbGoodInfo[2])
			local classNum = _classOfChildNeeds
			local itemNeedInfo = insertNeedItem(itemNeedId, itemNeedNum, classNum)
			table.insert(needInfo.childItems, itemNeedInfo)
		end
	end
	_classOfChildNeeds = _classOfChildNeeds-1
	return needInfo
end
-- 对外的接口
function getComposTableByItemId( itemId, needNum )
	_classOfChildNeeds = 0
	local numNeedItem = needNum or 0
	local classNum = _classOfChildNeeds
	local tbComposNeed = insertNeedItem(itemId, numNeedItem, classNum)

	return tbComposNeed
end
----------------------------------------获得合成表 end










-- 设置觉醒的数据，通过heroModel的数据
function setAwakeInfoByHeroInfo( heroInfo )
	local starLv = tonumber(heroInfo.awake_attr.star_lv)
	local level = tonumber(heroInfo.awake_attr.level)
	local awakeItem = heroInfo.awake_attr.awake_item 

	-- 满级的标记，1：满级， 0：没满级
	local isMaxLevel = 0

	----------------- 处理觉醒id
	local awakeConsumeStr = heroInfo.localInfo.disillusion_consume_id
	-- 觉醒的所有等级消耗table
	local splitAwakeConsume = lua_string_split(awakeConsumeStr, ",")
	-- 转化成一个二维table,key1是星级，key2是等级，value是觉醒表的id
	local tbAwakeConsumeId = {} 									
	for k,v in ipairs(splitAwakeConsume) do
		local temp = lua_string_split(v, "|")
		if (table.isEmpty(tbAwakeConsumeId[tonumber(temp[1])])) then
			tbAwakeConsumeId[tonumber(temp[1])] = {}
		end
		tbAwakeConsumeId[tonumber(temp[1])][tonumber(temp[2])] = {}
		tbAwakeConsumeId[tonumber(temp[1])][tonumber(temp[2])].value = tonumber(temp[3])
		tbAwakeConsumeId[tonumber(temp[1])][tonumber(temp[2])].index = k
	end
	----------------- 处理觉醒装备镶嵌情况的数据
	-- 本星级级数对应的觉醒消耗
	local tbAwakeConsume = {}
	local awakeConsumeNowIndex
	-- 如果是初始级数，则当前级数的序号为0，否则，为二维table里对应的项的index
	if (starLv == 0 and level == 0) then
		awakeConsumeNowIndex = 0
	else
		awakeConsumeNowIndex = tbAwakeConsumeId[starLv][level].index
	end
	-- 计算下一等级的序号
	local awakeConsumeNextIndex = awakeConsumeNowIndex+1
	-- 如果下一等级大于最高等级数，说明已经满级 ,加上满级的标记
	if (awakeConsumeNextIndex > #splitAwakeConsume) then
		awakeConsumeNextIndex = #splitAwakeConsume
		isMaxLevel = 1
	end
	-- 按照下一等级数，获取消耗的配置
	local splitNextConume = lua_string_split(splitAwakeConsume[awakeConsumeNextIndex], "|") -- 获取到下一觉醒等级的消耗id
	local awakeConsume = DB_Disillusion.getDataById( tonumber(splitNextConume[3]) ) 
	local awakeEquip = {} -- 觉醒装备
	local splitAwakeEquip = lua_string_split(awakeConsume.need_items, ",")
	for k,v in ipairs (splitAwakeEquip) do
		local temp = lua_string_split(v, "|")
		awakeEquip[tonumber(k)] = {}
		awakeEquip[tonumber(k)].pos = k
		awakeEquip[tonumber(k)].itemId = tonumber(temp[1])
		awakeEquip[tonumber(k)].itemNum = tonumber(temp[2])
		awakeEquip[tonumber(k)].installed = 0
	end
	-- 将已经镶嵌的状态设置
	for k,v in pairs(awakeItem) do      
		awakeEquip[tonumber(k)].installed = 1
	end
	----------------- 处理进阶能力文字说明
	-- 获得下一等级的星级
	local nextStar
	-- 如果已经满级，则下一星级数不变，否则，下一星级是本星级加1
	if (isMaxLevel == 1) then
		nextStar = starLv
	else
		nextStar = starLv + 1
	end
	local advanceDes = heroInfo.localInfo.disillusion_quality_des
	local splitAdvanceDes = lua_string_split(advanceDes, ",")
	local tbAdvanceDes = {}											-- 进阶能力的文字说明，key是下一星级数，value是文字
	for k,v in pairs(splitAdvanceDes) do
		local tbTemp = lua_string_split(v, "|")
		tbAdvanceDes[tonumber(tbTemp[1])] = tbTemp[2]
	end
	local nextAdvanceDesStr = tbAdvanceDes[nextStar]


	local needStones = {}
	local splitStonesStr = lua_string_split(awakeConsume.need_stone, "|")
	needStones.id = tonumber(splitStonesStr[1])
	needStones.num = tonumber(splitStonesStr[2])

	local needFragment = {}
	needFragment.id = heroInfo.localInfo.fragment
	needFragment.num = awakeConsume.need_fragment or 0

	tbAwakeConsume.lvInfo = {}
	tbAwakeConsume.lvInfo.isMaxLv = isMaxLevel
	tbAwakeConsume.lvInfo.nextStar = splitNextConume[1]
	tbAwakeConsume.lvInfo.nextLv = splitNextConume[2]
	tbAwakeConsume.advanceDes = nextAdvanceDesStr
	tbAwakeConsume.advanceNextStar = nextStar
	tbAwakeConsume.equip = awakeEquip
	tbAwakeConsume.stone = needStones
	tbAwakeConsume.fragment = needFragment
	tbAwakeConsume.belly = awakeConsume.need_belly
	tbAwakeConsume.limitLv = awakeConsume.limit_lv
	tbAwakeConsume.property = awakeConsume.disillusion_property
	tbAwakeConsume.star = starLv
	tbAwakeConsume.level = level
	tbAwakeConsume.preView = {} -- 用于计算装备预览的数据
	tbAwakeConsume.preView.consumeIds = splitAwakeConsume
	tbAwakeConsume.preView.nextLvIndex = awakeConsumeNextIndex
	return tbAwakeConsume
end


-- 设置全部的觉醒数据，初始化时调用
function setAwakeInfo( canSlip, hid )

	_allHeroModel = nil
	_canSlip = nil
	_nowHid = nil
	_nowIndex = nil
	_partnerNum = nil
	_partnerListWithNoEmpty = {}

	local partnerList = {}
	_canSlip = canSlip or 0
	_nowHid = hid

	if (_canSlip == 1) then -- 获取上阵伙伴和替补列表
		
		local squad = {}
		table.hcopy(DataCache.getSquad(), squad)
		local bench = {}
		table.hcopy(DataCache.getBench(), bench)
		
		local maxPosInSquad = 0
		for k,v in pairs (squad) do
			if (tonumber(k) >= maxPosInSquad) then
				maxPosInSquad = tonumber(k)
			end
		end

		local maxPosInbench = 0
		for k,v in pairs (bench) do
			if (tonumber(k) >= maxPosInbench) then
				maxPosInbench = tonumber(k)
			end
		end

		for i = 0, maxPosInbench do
			if (bench[tostring(i)] ~= -1) then
				maxPosInSquad = maxPosInSquad + 1
				squad[tostring(maxPosInSquad)] = bench[tostring(i)]
			end
		end

		for k,v in pairs(squad) do
            local tempInfo = {}
            tempInfo.pos = tonumber(k)
            tempInfo.hid = tonumber(v)
            tempInfo.heroInfo =  HeroModel.getHeroByHid(tonumber(v))
            table.insert(partnerList,tempInfo)
	    end

	    table.sort( partnerList, function ( v1,v2 )
	        return tonumber(v1.pos) < tonumber(v2.pos)
	    end )
--	    logger:debug({wefwef = partnerList})
	else
		local tempInfo = {}
        tempInfo.pos = 0				-- 不能横着滑动时，只显示当前伙伴，默认放到0位置
        tempInfo.hid = _nowHid

        tempInfo.heroInfo =  HeroUtil.getHeroInfoByHid(_nowHid)
        table.insert(partnerList,tempInfo)
    end

  	_partnerNum = 0
	for k,v in ipairs(partnerList) do
    	if ( v.heroInfo ) then
    		if (v.heroInfo.localInfo.disillusion_consume_id) then
    			if (tonumber(v.heroInfo.hid) == tonumber(_nowHid)) then
	    			_nowIndex = _partnerNum
	    		end
	    		v.heroInfo.awakeConsume = setAwakeInfoByHeroInfo(v.heroInfo)
	    		table.insert(_partnerListWithNoEmpty,v)
	    		_partnerNum = _partnerNum + 1
	    	end
    	end
    end
end

-- 设置当前的显示的hero序号
function setNowIndex( index )
	_nowIndex = tonumber(index)
end

-- 传进来按钮事件逻辑
function setBtnEvent( btnEvent )
	_btnEvent = btnEvent
end

-- 当前是否可以翻动hero
function getIfCanSlip( ... )
	return _canSlip
end

-- 得到伙伴列表，按照阵容排列，如果阵容中有空位置，则跳过此序号
function getPartnerListWithNoEmpty( ... )
	return _partnerListWithNoEmpty
end

-- 得到当前显示的伙伴在阵容列表里的位置
function getNowIndex( ... )
	return _nowIndex or 0
end

-- 得到伙伴列表中伙伴的个数
function getPartnerNum( ... )
	return _partnerNum or 0
end

-- 得到当前显示的伙伴的信息
function getNowPartnerInfo(  )
	local partnerListWithNoEmpty = getPartnerListWithNoEmpty()
	local nowPartnerInfo = partnerListWithNoEmpty[getNowIndex()+1]

	return nowPartnerInfo
end

-- 通过tag得到所对应的物品信息
function getNowEquipmentInfo( tag )
	local nowPartnerInfo = getNowPartnerInfo()
	local awakeInfo = nowPartnerInfo.heroInfo.awakeConsume
	local tbEquip = awakeInfo.equip[tag]
	return tbEquip
end

-- 更新伙伴的数据
function updateDataOfHero(hid)
	_partnerListWithNoEmpty[getNowIndex()+1].heroInfo.awakeConsume = setAwakeInfoByHeroInfo(HeroModel.getHeroByHid(tonumber(hid)))
	--logger:debug({pppppparttttttner_info = _partnerListWithNoEmpty[getNowIndex()+1].heroInfo.awakeConsume})
end

-- 更新觉醒级数
function updateAwakeLv( heroInfo )
	_partnerListWithNoEmpty[getNowIndex()+1].heroInfo = heroInfo
	_partnerListWithNoEmpty[getNowIndex()+1].heroInfo.awakeConsume = setAwakeInfoByHeroInfo(heroInfo)
end

-- 由觉醒物品背包里选出合适的item_id
function getItemIdByTidAndNum( tid, itemNum )
	local tbItems = {}
	local itemBagInfo = DataCache.getRemoteBagInfo().awake
	for k,v in pairs (itemBagInfo) do
		if (tonumber(v.item_template_id) == tonumber(tid)) then
			local tempInfo = {}
			tempInfo.itemId = v.item_id
			tempInfo.itemNumInBag = tonumber(v.item_num)
			table.insert(tbItems, tempInfo)
		end
	end
	table.sort( tbItems, function ( v1,v2 )
		return tonumber(v1.itemNumInBag) < tonumber(v2.itemNumInBag)
	end )
	local nowGet = 0
	local tbItemToUse = {}
	for k,v in ipairs( tbItems ) do
		if (v.itemNumInBag<itemNum-nowGet) then
			nowGet = nowGet+v.itemNumInBag
			table.insert(tbItemToUse, v)
		else
			local tempInfo = {}
			tempInfo.itemId = v.itemId
			tempInfo.itemNumInBag = itemNum-nowGet
			nowGet = itemNum
			table.insert(tbItemToUse, tempInfo)
			break
		end
	end
	local tbFinalArgs = {}
	for k,v in pairs(tbItemToUse) do
		tbFinalArgs[v.itemId] = v.itemNumInBag
	end
	if (nowGet<itemNum) then
		return nil
	else
		return tbFinalArgs
	end
end

-- 返回当前是否可以点击觉醒按钮
function canAwake(  )
	local partnerInfo = getNowPartnerInfo().heroInfo
	local partnerConsumeInfo = partnerInfo.awakeConsume
	for k,v in ipairs( partnerConsumeInfo.equip ) do
		if ( v.installed == 0 ) then
			return false
		end
	end

	if ( tonumber(ItemUtil.getNumInBagByTid(partnerConsumeInfo.stone.id)) < partnerConsumeInfo.stone.num ) then
		return false
	end

	if ( DataCache.getHeroFragNumByItemTmpid(partnerConsumeInfo.fragment.id) < partnerConsumeInfo.fragment.num ) then
		return false
	end

	if ( UserModel.getSilverNumber() < partnerConsumeInfo.belly ) then
		return false
	end

	if ( tonumber(partnerInfo.level) < partnerConsumeInfo.limitLv ) then
		return false
	end

	return true
end

function canAwakeAndItemisEnough( ... )
	local partnerInfo = getNowPartnerInfo().heroInfo
	local partnerConsumeInfo = partnerInfo.awakeConsume

	if (partnerConsumeInfo.lvInfo.isMaxLv == 1) then -- 如果已经满级，则不能觉醒
		return false
	end

	for k,v in ipairs( partnerConsumeInfo.equip ) do -- 如果没装备的物品，背包中数量也不够，则不能觉醒
		if ( v.installed == 0 ) then
			if (tonumber(ItemUtil.getAwakeNumByTid(tonumber(v.itemId))) < tonumber(v.itemNum)) then
				return false
			end
		end
	end

	if ( tonumber(ItemUtil.getNumInBagByTid(partnerConsumeInfo.stone.id)) < partnerConsumeInfo.stone.num ) then -- 如果觉醒石不够，不能觉醒
		return false
	end

	if ( DataCache.getHeroFragNumByItemTmpid(partnerConsumeInfo.fragment.id) < partnerConsumeInfo.fragment.num ) then -- 如果碎片不够，不能觉醒
		return false
	end

	if ( UserModel.getSilverNumber() < partnerConsumeInfo.belly ) then -- 如果贝里不够，不能觉醒
		return false
	end

	if ( tonumber(partnerInfo.level) < partnerConsumeInfo.limitLv ) then -- 如果等级不够，不能觉醒
		return false
	end

	return true -- 条件都符合，可以觉醒
end


function initDB( ... )
	if (table.isEmpty(_tbDBItemDis)) then
		_tbDBItemDis = DB_Item_disillusion
	end
	if (table.isEmpty(_tbDBHeros)) then
		_tbDBHeros = DB_Heroes
	end
	if (table.isEmpty(_tbDBDis)) then
		_tbDBDis = DB_Disillusion
	end
end



-- 根据装备物品的信息，返回装备上它能提升的属性
function getAttrsByEquipItemInfo( itemId, itemNum )
	initDB()

	local itemDB = _tbDBItemDis.getDataById(itemId)
	local attrs = itemDB.base_attr
	local tbSplitAttrs = lua_string_split(attrs, ",")
	local addAttrs = {}
	for k,v in ipairs(tbSplitAttrs) do
		local temp = {}
		local splitAttr = lua_string_split(v, "|")
		if (tonumber(splitAttr[1]) == 1) then 
			temp.num = tonumber(splitAttr[2]) * itemNum
			temp.txt = _i18n[1068]
			temp.type = 1
		elseif (tonumber(splitAttr[1])==2) then
			temp.num = tonumber(splitAttr[2]) * itemNum
			temp.txt = _i18n[1069]
			temp.type = 2
		elseif (tonumber(splitAttr[1])==3) then
			temp.num = tonumber(splitAttr[2]) * itemNum
			temp.txt = _i18n[1070]
			temp.type = 3
		elseif (tonumber(splitAttr[1])==4) then
			temp.num = tonumber(splitAttr[2]) * itemNum
			temp.txt = _i18n[1071]
			temp.type = 4
		elseif (tonumber(splitAttr[1])==5) then
			temp.num = tonumber(splitAttr[2]) * itemNum
			temp.txt = _i18n[1072]
			temp.type = 5
		end
		table.insert(addAttrs, temp)
	end

	return addAttrs
end

-- 获得处理过的觉醒ID表
function getHeroDisIdTable( htid, strDisIDs )
	for k,v in pairs (_tbDBHerosDisIds) do
		if (k == htid) then
			return v
		end
	end	
	local splitStrDisIds = lua_string_split(strDisIDs, ",")
	local tbIds = {}
	for k,v in ipairs(splitStrDisIds) do
		local tbTemp = {}
		local splitV = lua_string_split(v, "|")
		tbTemp.stars = splitV[1]
		tbTemp.lv = splitV[2]
		tbTemp.disId = splitV[3]
		table.insert(tbIds, tbTemp)
	end
	_tbDBHerosDisIds.htid = tbIds
	return tbIds 
end
-- 计算hid对应的觉醒系统属性
function getAwakeTotalAttrsByHid( hid )
	initDB()

	local heroInfo = HeroUtil.getHeroInfoByHid(hid)
--	logger:debug({nowPartnerInfoGetAttr = heroInfo})	
	local htid = heroInfo.htid
	local awakeStatus = heroInfo.awake_attr
	local awakeItemEquiped = awakeStatus.awake_item

	local heroDB = _tbDBHeros.getDataById(htid)
	local disQuality = heroDB.disillusion_quality 			--升星的加成

	local tbAwakePercentAdd = {}

	local totalAttrs = {}
	for i = 1,5 do
		tbAwakePercentAdd[i] = 0
		local temp = {}
		temp.awakeAttrNum = 0
		temp.awakeAttrPer = 0
	--	temp.awakeInnerPer = 0
		temp.id = i
		if (i == 1) then 
			temp.desc = "life"
		elseif (i==2) then
			temp.desc = "physicalAttack"
		elseif (i==3) then
			temp.desc = "magicAttack"
		elseif (i==4) then
			temp.desc = "physicalDefend"
		elseif (i==5) then
			temp.desc = "magicDefend"
		end
		table.insert(totalAttrs, temp)
	end
	local starCount = 0


	local strDisIDs = heroDB.disillusion_consume_id			--每一级对应的觉醒ID
	if (strDisIDs == nil) then 								-- 为空说明没有觉醒能力
		return totalAttrs
	end

	local tbDisIds = getHeroDisIdTable(htid, strDisIDs) 	--获得此hero每一级觉醒ID处理过的表



	for itemPos, itemTb in pairs (awakeItemEquiped) do
		for itemId, itemNum in pairs (itemTb) do
			local tempAttrs = getAttrsByEquipItemInfo(itemId, tonumber(itemNum))
			for k2,v2 in ipairs(tempAttrs) do
				totalAttrs[tonumber(v2.type)].awakeAttrNum = totalAttrs[tonumber(v2.type)].awakeAttrNum + v2.num
			end
		end
	end -- 当前装备的物品


	if (tonumber(awakeStatus.star_lv) == 0 and tonumber(awakeStatus.level) == 0 ) then
		logger:debug({
		hero_name = heroInfo.localInfo.name,
		totalAttr_table = totalAttrs})
		return totalAttrs
	end

	for k,v in ipairs(tbDisIds) do
		local disIdNow = v.disId
		local disDBNow = _tbDBDis.getDataById(disIdNow)
		local equipItemStr = disDBNow.need_items
		local splitEquipItemStr = lua_string_split(equipItemStr, ",")
		for k1,v1 in ipairs(splitEquipItemStr) do
			local splitV = lua_string_split(v1, "|")
			local tempAttrs = getAttrsByEquipItemInfo(splitV[1], splitV[2])
			for k2,v2 in ipairs(tempAttrs) do
				totalAttrs[tonumber(v2.type)].awakeAttrNum = totalAttrs[tonumber(v2.type)].awakeAttrNum + v2.num
			end
		end -- 四个物品装备完

		local disUpLvAttrStr = disDBNow.disillusion_property
		local splitDisUpLvAttrStr = lua_string_split(disUpLvAttrStr, ",")
		for k1,v1 in ipairs(splitDisUpLvAttrStr) do
			local tempSplit = lua_string_split(v1, "|")
			totalAttrs[tonumber(tempSplit[1])].awakeAttrNum = totalAttrs[tonumber(tempSplit[1])].awakeAttrNum + tonumber(tempSplit[2])
		end -- 普通升级觉醒加成

		if (tonumber(v.stars) == starCount+1) then
			starCount = starCount+1
			local splitDisQuality = lua_string_split(disQuality,",")
			for k,v in ipairs(splitDisQuality) do
				local splitTemp = lua_string_split(v,"|")
				if (tonumber(splitTemp[1]) == starCount) then
					if (splitTemp[2] == "1") then

						local affixId = tonumber(splitTemp[3])
						local affixDb = DB_Affix.getDataById(affixId)
						if (affixDb.type == 1) then -- affix表数值型
							if (affixDb.id == 1) then
								totalAttrs[1].awakeAttrNum = totalAttrs[1].awakeAttrNum + tonumber(splitTemp[4])
							elseif (affixDb.id == 2) then
								totalAttrs[2].awakeAttrNum = totalAttrs[2].awakeAttrNum + tonumber(splitTemp[4])
							elseif (affixDb.id == 3) then
								totalAttrs[3].awakeAttrNum = totalAttrs[3].awakeAttrNum + tonumber(splitTemp[4])
							elseif (affixDb.id == 4) then
								totalAttrs[4].awakeAttrNum = totalAttrs[4].awakeAttrNum + tonumber(splitTemp[4])
							elseif (affixDb.id == 5) then
								totalAttrs[5].awakeAttrNum = totalAttrs[5].awakeAttrNum + tonumber(splitTemp[4])
							end
						elseif (affixDb.type == 3) then -- 外部百分比型
							if (affixDb.id == 11) then
								totalAttrs[1].awakeAttrPer = totalAttrs[1].awakeAttrPer + tonumber(splitTemp[4])
							elseif (affixDb.id == 12) then
								totalAttrs[2].awakeAttrPer = totalAttrs[2].awakeAttrPer + tonumber(splitTemp[4])
							elseif (affixDb.id == 13) then
								totalAttrs[3].awakeAttrPer = totalAttrs[3].awakeAttrPer + tonumber(splitTemp[4])
							elseif (affixDb.id == 14) then
								totalAttrs[4].awakeAttrPer = totalAttrs[4].awakeAttrPer + tonumber(splitTemp[4])
							elseif (affixDb.id == 15) then
								totalAttrs[5].awakeAttrPer = totalAttrs[5].awakeAttrPer + tonumber(splitTemp[4])
							end
						end

					elseif (splitTemp[2] == "2") then -- 内部百分比型
						tbAwakePercentAdd[tonumber(splitTemp[3])] = tbAwakePercentAdd[tonumber(splitTemp[3])] + tonumber(splitTemp[4])
						--totalAttrs[tonumber(splitTemp[3])].awakeInnerPer = totalAttrs[tonumber(splitTemp[3])].awakeInnerPer + tonumber(splitTemp[4])
					end
					--break
				end
			end 
		end	-- 星级升级的加成

		if (tonumber(awakeStatus.star_lv) == tonumber(v.stars) and tonumber(awakeStatus.level) == tonumber(v.lv) ) then
			break
		end
	end

--	logger:debug({awake_attr_percent  =  tbAwakePercentAdd})
	for key,percentNumber in pairs (tbAwakePercentAdd) do
		totalAttrs[key].awakeAttrNum = math.floor(totalAttrs[key].awakeAttrNum * (1+percentNumber/10000)) 
	end	-- 百分比加成


	logger:debug({
		hero_name = heroInfo.localInfo.name,
		totalAttr_table = totalAttrs})
	return totalAttrs
end


-- 获得装备当前的hero属性值
function getNowEquipAttr()
	local heroData = getNowPartnerInfo()
	local equipItems = heroData.heroInfo.awakeConsume.equip
	local nowAttrs = getAwakeTotalAttrsByHid( heroData.hid )
	for k,v in ipairs(equipItems) do
		local attrsEquip = getAttrsByEquipItemInfo(v.itemId, v.itemNum)
		for k1,v1 in ipairs(attrsEquip) do
			nowAttrs[tonumber(v1.type)].awakeAttrNum = nowAttrs[tonumber(v1.type)].awakeAttrNum + v1.num
		end
	end

	-- local forceValue = HeroFightUtil.getAllForceValuesByHid(heroInfo.hid)
	-- local tbAttr = {}
	-- for i = 1, 5 do
	-- 	local temp = {}
	-- 	if (i == 1) then 
	-- 		temp.num = forceValue.life
	-- 		temp.txt = _i18n[1068]
	-- 	elseif (i==2) then
	-- 		temp.num = forceValue.physicalAttack
	-- 		temp.txt = _i18n[1069]
	-- 	elseif (i==3) then
	-- 		temp.num = forceValue.magicAttack
	-- 		temp.txt = _i18n[1070]
	-- 	elseif (i==4) then
	-- 		temp.num = forceValue.physicalDefend
	-- 		temp.txt = _i18n[1071]
	-- 	elseif (i==5) then
	-- 		temp.num = forceValue.magicDefend
	-- 		temp.txt = _i18n[1072]
	-- 	end
	-- 	table.insert(tbAttr, temp)
	-- end
	 
	--return tbAttr
--	logger:debug({yidingyaoyoua = nowAttrs})
	return nowAttrs
end

-- 在属性提升前先记录一遍属性值，在ctrl里调用
function setHeroPreAttrs( ... )
	local heroData = getNowPartnerInfo()
	local equipItems = heroData.heroInfo.awakeConsume.equip
	_tbPreAttrs = getAwakeTotalAttrsByHid(heroData.hid)
end
-- 在属性提升后，再读取一遍属性值，计算增加的属性
function getNowHeroAddAttrs( ... )
	local preAttrs = _tbPreAttrs
	local heroData = getNowPartnerInfo()
	local nowAttrs = getAwakeTotalAttrsByHid( heroData.hid )
	local addAttrs = {}
	for k,v in ipairs (preAttrs) do
		local temp = {}
		temp.num = nowAttrs[k].awakeAttrNum-v.awakeAttrNum
		if (tonumber(k) == 1) then 
			temp.txt = _i18n[1068]
		elseif (tonumber(k)==2) then
			temp.txt = _i18n[1069]
		elseif (tonumber(k)==3) then
			temp.txt = _i18n[1070]
		elseif (tonumber(k)==4) then
			temp.txt = _i18n[1071]
		elseif (tonumber(k)==5) then
			temp.txt = _i18n[1072]
		end
		table.insert(addAttrs,temp)
	end
--	logger:debug({addAttrsaddAttrs = addAttrs})
	return addAttrs
end




-- 获得装备预览的信息
function getItemPreviewData( ... )
	local nowPartnerInfo = getNowPartnerInfo()
	local consumePreviewInfo = nowPartnerInfo.heroInfo.awakeConsume.preView

	local consumeIds = consumePreviewInfo.consumeIds
	local nextLvIndex = consumePreviewInfo.nextLvIndex
	local listViewData = {}
	local listViewDataInLine = {}

	if (nowPartnerInfo.heroInfo.awakeConsume.lvInfo.isMaxLv == 1) then -- 如果已经满级，则返回空的
		return listViewData, listViewDataInLine
	end


	local index = 1
	for i = 1, 5 do 
		if (nextLvIndex > #consumeIds) then
			break
		else
			local nextLvInfo = consumeIds[nextLvIndex] 

			local splitNextLvInfo = lua_string_split(nextLvInfo, "|")
			local tbTemp = {}
			tbTemp.star = splitNextLvInfo[1]
			tbTemp.Lv = splitNextLvInfo[2]
			local disilusionId = splitNextLvInfo[3]
			local consumeInfo = DB_Disillusion.getDataById( tonumber(disilusionId) ) 
			tbTemp.consumeInfo = {}
			local splitConsumeInfo = lua_string_split(consumeInfo.need_items, ",")
			for k,v in ipairs(splitConsumeInfo) do
				local temp = {}
				local split = lua_string_split(v, "|")
				temp.Id = split[1]
				temp.num = split[2]
				temp.icon = ItemUtil.createBtnByTemplateId(tonumber(split[1]), _btnEvent.onGetWayByid, {false,false})
				temp.icon:setTag(index)
				temp.haveNum = tonumber(ItemUtil.getAwakeNumByTid(tonumber(split[1])))
				table.insert(tbTemp.consumeInfo, temp)
				table.insert(listViewDataInLine, temp)
				index = index + 1
			end
			table.insert(listViewData, tbTemp)

			nextLvIndex = nextLvIndex+1
		end
	end
	-- logger:debug({nowpartnerPrever = listViewData,
	-- 	listViewDataInLine = listViewDataInLine})	
	return listViewData, listViewDataInLine
end

-- 判断有无合成字段，有则返回true
function getIfCanComposeOnlyByConfig( itemId )
	local itemDB = DB_Item_disillusion.getDataById(itemId)
	if (itemDB.need_items == nil) then
		return false
	else
		return true
	end
end




--[[desc:根据物品tid，返回是否是上阵伙伴中需要的（包括作为子物品是需要的）,
    arg1: isNeedThisItem( itemTId )
    return: 如果需要则返回true
—]]
local function isRequire( parentItemId, childItemId )
	parentItemId = tonumber(parentItemId)
	childItemId = tonumber(childItemId)
	if (parentItemId == childItemId) then
		return true
	else 
		local needItems = getComposNeedByItemId( parentItemId, 1 )
		if (needItems == nil) then
			return false
		else	
			for k,v in pairs (needItems) do
				if (tonumber(v.itemNeedId) == tonumber(childItemId)) then
					return true
				end
			end
			return false
		end
	end
end

function isNeedThisItem( itemTId )
	local partnerList = {}
	local squad = {}
	table.hcopy(DataCache.getSquad(), squad)
	local bench = {}
	table.hcopy(DataCache.getBench(), bench)

	local maxPosInSquad = 0
	for k,v in pairs (squad) do
		if (tonumber(k) >= maxPosInSquad) then
			maxPosInSquad = tonumber(k)
		end
	end

	local maxPosInbench = 0
	for k,v in pairs (bench) do
		if (tonumber(k) >= maxPosInbench) then
			maxPosInbench = tonumber(k)
		end
	end

	for i = 0, maxPosInbench do
		if (bench[tostring(i)] ~= -1) then
			maxPosInSquad = maxPosInSquad + 1
			squad[tostring(maxPosInSquad)] = bench[tostring(i)]
		end
	end

	for k,v in pairs(squad) do
	    local tempInfo = {}
	    tempInfo.pos = tonumber(k)
	    tempInfo.hid = tonumber(v)
	    tempInfo.heroInfo =  HeroModel.getHeroByHid(tonumber(v))
	    table.insert(partnerList,tempInfo)
	end

	table.sort( partnerList, function ( v1,v2 )
	    return tonumber(v1.pos) < tonumber(v2.pos)
	end )

	local partnerListWithNoEmpty = {}
	for k,v in ipairs(partnerList) do
		if ( v.heroInfo ) then
			if (v.heroInfo.localInfo.disillusion_consume_id) then
	    		v.heroInfo.awakeConsume = setAwakeInfoByHeroInfo(v.heroInfo)
	    		table.insert(partnerListWithNoEmpty,v)
	    	end
		end
	end

	-- logger:debug({functionGetIsNeed_partnerList = partnerListWithNoEmpty,
	-- 	partnerNum =  getPartnerNum()})

	local needItemList = {}
	needItemList.itemIdRecord = {}
	needItemList.itemNeedNum = {}
	for k, partnerInfo in pairs ( partnerListWithNoEmpty ) do
		if (partnerInfo.heroInfo.awakeConsume.lvInfo.isMaxLv ~= 1) then
			for i, equip in pairs(partnerInfo.heroInfo.awakeConsume.equip) do
				if (tonumber(equip.installed) == 0) then
					if (not table.include(needItemList.itemIdRecord, equip.itemId)) then
						table.insert(needItemList.itemIdRecord, equip.itemId)
						needItemList.itemNeedNum[equip.itemId] = equip.itemNum
					else
						needItemList.itemNeedNum[equip.itemId] = equip.itemNum + needItemList.itemNeedNum[equip.itemId]
					end
				end
			end
		end
	end
	--logger:debug({functionGetIsNeed_needItemList = needItemList})

	for index, itemId in ipairs (needItemList.itemIdRecord) do
		if (isRequire(itemId, itemTId)) then
			logger:debug("functionGetIsNeed_return_true")
			return true
		end
	end
	logger:debug("functionGetIsNeed_return_false")
	return false
end


function decreaseItemNumByTid( itemTid, numDecrease, itemType )
	local numDec = tonumber(numDecrease)
	local propsInfo
	if (itemType == "props") then
		propsInfo = DataCache.getRemoteBagInfo().props
	elseif (itemType == "awake") then
		propsInfo = DataCache.getRemoteBagInfo().awake
	end
	for gid, item in pairs(propsInfo) do


		local itemId = item.item_template_id
		if (tonumber(itemTid) == tonumber(itemId)) then
			if (tonumber(item.item_num)>tonumber(numDec)) then
				ItemUtil.reduceItemByGid(gid, numDec)
				break
			else
				ItemUtil.reduceItemByGid(gid, tonumber(item.item_num))
				numDec=numDec-tonumber(item.item_num)
			end
		end
	end
end

function tempAddItem( itemTid, num )
	local bagInfo = DataCache.getRemoteBagInfo()
	local nowGid = 0

	local isHaveThisKey = false
	for key,valud in pairs(bagInfo) do
		if (key == "awake") then
			isHaveThisKey = true
			break
		end
	end
	if (not isHaveThisKey) then
		bagInfo.awake = {}
	end

	local isHaveThisGid = false 
	for gid, itemInfo in pairs(bagInfo.awake) do
		if (tonumber(itemInfo.item_template_id) == tonumber(itemTid)) then
			isHaveThisGid = true
			nowGid = tostring(gid)
			break
		end
		if (tonumber(gid)>tonumber(nowGid)) then
			nowGid = tostring(gid)
		end
	end
	if (not isHaveThisGid) then
		if (tonumber(nowGid)+1 <= 11000000) then
			nowGid = tostring(nowGid+1)
		end
		bagInfo.awake[nowGid] = {}
		bagInfo.awake[nowGid].item_num = tostring(num)
		bagInfo.awake[nowGid].item_template_id = tostring(itemTid)
	else
		bagInfo.awake[nowGid].item_num = tostring(tonumber(bagInfo.awake[nowGid].item_num)+tonumber(num))
	end
	DataCache.setBagInfo(bagInfo)
end



local isNeedEquipEnough = function ( needEquips )
	
	local needItemList = {}
	needItemList.itemIdRecord = {}
	needItemList.itemNeedNum = {}

	for i, equip in pairs(needEquips) do
		if (tonumber(equip.installed) == 0) then
			if (not table.include(needItemList.itemIdRecord, equip.itemId)) then
				table.insert(needItemList.itemIdRecord, equip.itemId)
				needItemList.itemNeedNum[equip.itemId] = equip.itemNum
			else
				needItemList.itemNeedNum[equip.itemId] = equip.itemNum + needItemList.itemNeedNum[equip.itemId]
			end
		end
	end

	for itemId,itemNeedNum in pairs (needItemList.itemNeedNum) do
		if (tonumber(ItemUtil.getAwakeNumByTid(tonumber(itemId))) < tonumber(itemNeedNum)) then
			return false
		end
	end
	return true
end


function isCanAwakeByHid( hid )
	local heroInfo = HeroUtil.getHeroInfoByHid(hid)
	if (heroInfo.localInfo.disillusion_consume_id == nil) then
		return false	
	else
		local partnerConsumeInfo = setAwakeInfoByHeroInfo(heroInfo)

		if (partnerConsumeInfo.lvInfo.isMaxLv == 1) then -- 如果已经满级，则不能觉醒
			return false
		end

		if ( not isNeedEquipEnough(partnerConsumeInfo.equip) ) then -- 如果没装备的物品，背包中数量也不够，则不能觉醒
			return false
		end

		if ( tonumber(ItemUtil.getNumInBagByTid(partnerConsumeInfo.stone.id)) < partnerConsumeInfo.stone.num ) then -- 如果觉醒石不够，不能觉醒
			return false
		end

		if ( DataCache.getHeroFragNumByItemTmpid(partnerConsumeInfo.fragment.id) < partnerConsumeInfo.fragment.num ) then -- 如果碎片不够，不能觉醒
			return false
		end

		if ( UserModel.getSilverNumber() < partnerConsumeInfo.belly ) then -- 如果贝里不够，不能觉醒
			return false
		end

		if ( tonumber(heroInfo.level) < partnerConsumeInfo.limitLv ) then -- 如果等级不够，不能觉醒
			return false
		end

		return true -- 条件都符合，可以觉醒
	end
end

---------------------------------------------------


function destroy(...)
	package.loaded["MainAwakeModel"] = nil
end

function moduleName()
    return "MainAwakeModel"
end

function create(...)

end

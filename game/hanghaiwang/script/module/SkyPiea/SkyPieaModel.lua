-- FileName: SkyPieaModel.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛模块 数据缓存 啥的
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("SkyPieaModel", package.seeall)
local m_i18nString = gi18nString
local m_i18n = gi18n
-- 1为战斗层、2为宝箱层、3为buff层 4为最终层
EVENTTYPE = {
	BATTLE_LAYER    = 1,
	BOX_LAYER       = 2,
	BUFF_LAYER      = 3,
	LAST_LAYER      = 4,
}
-- 1为属性buff、2为回复血量buff、3回复怒气buff 4为复活buff
BUFFTYPE = {
	ATTR_BUFF    					= 1,
	RECOVER_HP_BUFF    		 		= 2,
	RECOVER_RAGE_BUFF		     	= 3,
	REBORN_BUFF					     = 4,
}


BUFF_RATIO  	= 	 100

require "db/DB_Sky_piea_floor"
require "db/DB_Sky_piea_buff"

local m_tbSkyFloorData = nil 		-- 当前层的所有信息
local m_tbCurFloorInfo = nil 		-- 当前层的表信息
local m_tbFormationInfo = nil 		-- 当前阵容信息
local m_isFormationLock
local m_isAllHeroDead


--设置爬塔的信息
function setSkypieaData( _data )
	m_tbSkyFloorData = _data
	-- m_tbSkyFloorData.cur_base = 2
	logger:debug(m_tbSkyFloorData)
	m_tbCurFloorInfo = DB_Sky_piea_floor.getDataById(m_tbSkyFloorData.cur_base)
	logger:debug("当前层的表信息是")
	logger:debug(m_tbCurFloorInfo)

	setFormationAndBench(m_tbSkyFloorData.va_pass.formation, m_tbSkyFloorData.va_pass.bench)
end

function getIsFormationLock( ... )
	return m_isFormationLock
end


function getIsAllDead( ... )
	m_isAllHeroDead = true
	if (m_tbSkyFloorData.va_pass.heroInfo) then
		for k, v in pairs(m_tbSkyFloorData.va_pass.heroInfo) do
			if (tonumber(v.currHp) > 0) then
				m_isAllHeroDead = false
				break
			end
		end
	else
		m_isAllHeroDead = false
	end
	logger:debug(m_isAllHeroDead)

	return m_isAllHeroDead
end


-- 设置当前层数
function setCurFloor( curBase )
	if (tonumber(m_tbSkyFloorData.cur_base) ~= tonumber(curBase)) then
		m_tbSkyFloorData.cur_base = curBase
		m_tbCurFloorInfo = DB_Sky_piea_floor.getDataById(m_tbSkyFloorData.cur_base)

		MainSkyPieaView.afterPass()
	else
		MainSkyPieaView.backLufei()
	end
end

--获取当前所处的层数
function getCurFloor()
	return  m_tbSkyFloorData.cur_base or 1
end


function getPercentBase( ... )
	return m_tbSkyFloorData.percentBase
end


function getHistoryPoint( ... )
	return m_tbSkyFloorData.history_point
end


function setPoint( point )
	m_tbSkyFloorData.point = point
	if tonumber(m_tbSkyFloorData.history_point) < tonumber(point) then
		m_tbSkyFloorData.history_point = point
	end
end


function getPoint( ... )
	return m_tbSkyFloorData.point
end


function setStarNum( star )
	m_tbSkyFloorData.star_star = star
end


function getStarNum( ... )
	return m_tbSkyFloorData.star_star
end


-- 设置英雄血量和怒气相关
function setHeroInfo( tbHeroInfo )
	m_tbSkyFloorData.va_pass.heroInfo = tbHeroInfo
	m_isFormationLock = true
end


-- 获取英雄血量和怒气相关
function getHeroInfo( ... )
	return m_tbSkyFloorData.va_pass.heroInfo
end


-- 根据formation和bench信息更新formationinfo
function setFormationAndBench( tbFor, tbBench )
	m_tbFormationInfo = {0,0,0,0,0,0,0,0,0}
	if (tbFor) then
		m_isFormationLock = true
		for pos, hid in pairs(tbFor) do
			m_tbFormationInfo[tonumber(pos)] = (tonumber(hid) <= 0 and 0 or tonumber(hid))
		end
		for pos, hid in pairs(tbBench) do
			m_tbFormationInfo[tonumber(pos) + 6] = (tonumber(hid) <= 0 and 0 or tonumber(hid))
		end
	else
		m_isFormationLock = false
		for pos, hid in pairs(DataCache.getFormationInfo()) do
			m_tbFormationInfo[tonumber(pos) + 1] = (tonumber(hid) <= 0 and 0 or tonumber(hid))
		end
		for pos, hid in pairs(DataCache.getBench()) do
			m_tbFormationInfo[tonumber(pos) + 7] = (tonumber(hid) <= 0 and 0 or tonumber(hid))
		end
	end
end

-- 设置爬塔阵容信息
function setFormationInfo( tbFormation )
	m_tbFormationInfo = tbFormation
end


-- 获取爬塔阵容信息
function getFormationInfo( ... )
	return m_tbFormationInfo
end


--获取当前塔层名称
function getTowerName()
	return m_tbCurFloorInfo.name
end

--获取当前塔层的类型  1为战斗层、2为宝箱层、3为buff层 4为最终层
function getFloorType()
	return m_tbCurFloorInfo.type
end

--获取当前塔层怪物名称
function getArmName()
	return m_tbCurFloorInfo.layerName
end

--获取当前塔层攻打需要的等级
function getNeedLevel()
	return m_tbCurFloorInfo.needLevel
end

--获取上一轮的刷新时间
function getRefrshTime()
	return tonumber(m_tbSkyFloorData.refresh_time)
end

function cleanSkyFloorData()
	m_tbSkyFloorData = nil 
end

function getSkyFloorData()
	return m_tbSkyFloorData
end
--获取通过次关后 回复的血量和怒气
function getPassRecover()
	local info  = m_tbCurFloorInfo.passRecover

	local tbInfo  = lua_string_split(info,"|")
	--回复的血量
	local recoverBlood = tbInfo[1]

	local recoverAnger = tbInfo[2]
	logger:debug("通过次层后回复的血量和怒气是：")
	logger:debug(recoverBlood .. "++++++" .. recoverAnger)

	return recoverBlood,recoverAnger

end

-- 获取通关星级
function getStarLv( hpGrade )
	local str = m_tbCurFloorInfo.gradeCount
	local arr = string.split(str, ",")
	for i=1,3 do
		local arrOne = string.split(arr[i], "|")
		if (hpGrade >= arrOne[1]) then
			return i, arrOne[2] / 10000, arrOne[3] / 10000
		end
	end
end

--获取当前关卡的塔层模型
function getMonsterModel()
	if(m_tbCurFloorInfo.monsterModel) then
		return "images/skypiea/" .. m_tbCurFloorInfo.monsterModel .. ".png"
	else
		return "images/skypiea/" .. "equip_2" .. ".png"
	end
end

---------------宝箱数据处理------------
-- 获取当前层的基础积分和得星倍率信息
function getBaseRewardInfo( ... )

	local str = m_tbCurFloorInfo.baseReward     -- "1|100|2,2|200|3,3|300|5"

	local tbInfo = {}

	local tbTemp = string.split(str, ",")
	for i=1,#tbTemp do
		local tbOne = string.split(tbTemp[i], "|")
		local tbData = { level = tbOne[1], base = tbOne[2], star = tbOne[3] }
		table.insert(tbInfo, tbData)
	end

	return tbInfo
end


-- 重置开金币宝箱的次数
function resetBoxInfo()
	m_tbSkyFloorData.luxurybox_num = 0

	if(m_tbSkyFloorData.va_pass.chestShow == nil) then
		m_tbSkyFloorData.va_pass.chestShow = {}
	end

	m_tbSkyFloorData.va_pass.chestShow.goldChest = 0
	m_tbSkyFloorData.va_pass.chestShow.freeChest = 0
end

-- 重置免费宝箱的标志位 为已买过
function setFreeBoxState()
	if(m_tbSkyFloorData.va_pass.chestShow == nil) then
		m_tbSkyFloorData.va_pass.chestShow = {}
	end
	m_tbSkyFloorData.va_pass.chestShow.freeChest = 1
end

-- 重置金币宝箱的标志位已买过
function setGoldBoxState()
	if(m_tbSkyFloorData.va_pass.chestShow == nil) then
		m_tbSkyFloorData.va_pass.chestShow = {}
	end
	m_tbSkyFloorData.va_pass.chestShow.goldChest = 1
end


-- 获取还可以开启的宝箱次数
function getCanOpenBoxNum()

	--开宝藏宝箱的次数,
	local buyTimes = m_tbSkyFloorData.luxurybox_num or 0

	local per_arr = string.split(m_tbCurFloorInfo.openCost, ",")

	local last_arr = per_arr[#per_arr]
	local lastTimes = string.split(last_arr,"|")
	logger:debug(last_arr)
	logger:debug(lastTimes)
	logger:debug(buyTimes)
	return  lastTimes[1] - buyTimes

end

--开启宝箱的花费金币数为
function getBuyOpenBoxGoldByTimes( ... )
	--开宝藏宝箱的次数,
	local buyTimes = m_tbSkyFloorData.luxurybox_num

	local per_arr = string.split(m_tbCurFloorInfo.openCost, ",")
	local c_price = 0
	if(per_arr)then
		local tmp1 = string.split(per_arr[1],"|")
		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2])


		for _,val in pairs(per_arr) do
			local tmp = string.split(val,"|")
			logger:debug(buyTimes)
			logger:debug("次数上线为：" .. tmp[1])
			logger:debug("金币为："  .. tmp[2])
			if (tonumber(buyTimes)<tonumber(tmp[1])) then
				c_price = tmp[2]
				break
			end
		end

	else
		logger:debug("不是包厢层，取不到数据")
	end

	return c_price
end


--[[desc:如果是宝箱层，能否继续开宝箱
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]] 
function canOpenBox()
	--开宝藏宝箱的次数,
	local buyTimes = m_tbSkyFloorData.luxurybox_num

	local per_arr = string.split(m_tbCurFloorInfo.openCost, ",")
	logger:debug(per_arr)

	local last_arr = per_arr[#per_arr]
	local lastTimes = string.split(last_arr,"|")
	logger:debug(last_arr)
	logger:debug(lastTimes)
	logger:debug(buyTimes)
	if(tonumber(buyTimes) >= tonumber(lastTimes[1]))then
		return false
	else
		return true
	end
end

--进入爬塔后是否直接显示买宝箱的界面
function needShowGoldBoxLayer()
	if( m_tbSkyFloorData.va_pass.chestShow == nil) then
		return  false
	end
	-- 0 or  nil 是没处理 1是处理过了
	local goldState = m_tbSkyFloorData.va_pass.chestShow.goldChest or 0
	local floorType = getFloorType()
	if(floorType == EVENTTYPE.BOX_LAYER  and tonumber(goldState) == 0)then
		return true
	else
		return false
	end
end

--进入爬塔后是否直接显示买免费宝箱的界面
function needShowFreeBoxLayer()

	logger:debug(m_tbSkyFloorData.va_pass.chestShow)


	if( m_tbSkyFloorData.va_pass.chestShow == nil) then
		return  true
	end

	-- 0 or  nil 是没处理 1是处理过了
	local freeState = m_tbSkyFloorData.va_pass.chestShow.freeChest or 0
	logger:debug("0 or  nil 是没处理 1是处理过了 freeState免费宝箱的标识位为：")
	logger:debug(freeState)
	logger:debug(EVENTTYPE.BOX_LAYER)
	local floorType = getFloorType()
	logger:debug(floorType)
	if(floorType == EVENTTYPE.BOX_LAYER  and tonumber(freeState) == 0)then
		return true
	else
		return false
	end
end

--增加一次购买箱子的次数
function addBuyBoxTimes()
	m_tbSkyFloorData.luxurybox_num = m_tbSkyFloorData.luxurybox_num + 1
end



------------------------排行榜数据  排行榜奖励 ------------------------
require "db/DB_Sky_piea_rank_reward"
--[[
	@desc: 返回所有排行奖励 整理需要的格式
    @return: tbRewards  type:  table 排序后的数组格式
—]]
function getAllRankRewards( )
	local tbRewards = {}
	local dbData = DB_Sky_piea_rank_reward.Sky_piea_rank_reward

	local keys = DB_Sky_piea_rank_reward.keys
	local mt = {}
	mt.__index = function (table, key)
		for i = 1, #keys do
			if (keys[i] == key) then
				return table[i]
			end
		end
	end

	for _,v in pairs(dbData) do
		if getmetatable(v) == nil then
			setmetatable(v, mt)
		end
		table.insert(tbRewards, v)
	end

	table.sort(tbRewards,function ( data1, data2)
		return tonumber(data1.id) < tonumber(data2.id)
	end)
	return tbRewards
end
------------------------ 排行榜 信息 -------------------

local tbRankList = {} -- 排行榜信息缓存

-- 缓存 排行榜数据
function setRankList( tbRank )
	tbRankList = tbRank
	for i,v in ipairs(tbRankList.top) do
		v.rank = i
	end
	logger:debug(tbRankList)
end

-- 获取当前排行榜数据
function getRankList(  )
	return tbRankList
end

-- 获取自己当前排名的奖励
function getSkyRewardNum(  )
	local myRank = tonumber(tbRankList.myRank)
	local tReward = getAllRankRewards()
	for _,reward in ipairs(tReward) do
		local min = tonumber(reward.min)
		local max = tonumber(reward.max)
		if myRank >= min and myRank <= max then
			local tab = string.split(reward.items, "|")
			if(not table.isEmpty(tab)) then
				return tab[3]
			end
		end
	end
	return 0

end

------------------------ 爬塔商店 ----------------------

require "db/DB_Sky_piea_shop"
require "db/DB_Sky_piea_goods"

local tbShopInfo= {}  -- 商店数据缓存

local tbShopDbData = DB_Sky_piea_shop.getDataById(1) -- DB_Sky_piea_shop 表中配置的相关数据

--[[
	@desc: 获取存储的数据缓存
    @return: tbShopInfo  type: table
—]]
function  getShopInfo(  )
	return tbShopInfo
end

--[[
	@desc: 存储商店信息数据
    @param 	shopInfo  type: table 拉取的网络数据
—]]
function setShopInfo( shopInfo)
	tbShopInfo = shopInfo
end

--[[
    @des:   得到当前刷新花费的金币数量
    @return: 金币数
]]
function getRfrGoldNum( )
	local goldStr = tbShopDbData.goldGost
	local goldArr = string.split(goldStr , ",")
	local tbGold = {}
	for i,str in ipairs(goldArr) do
		local tempArr = string.split(str, "|")
		table.insert(tbGold,tempArr)
	end

	for i,v in ipairs(tbGold) do
		if(getAlreadyGoldRfrNum() >= tonumber(tbGold[#tbGold][1])) then -- 如果大于最大取最大
			return tonumber(tbGold[#tbGold][2])
		elseif getAlreadyGoldRfrNum() < tonumber(tbGold[i][1]) then
			return tonumber(tbGold[i][2])
		end
	end
end

--[[
    @des:   获取已经用去得刷新次数
    @return: 已经用掉的金币刷新次数 type: number
]]
function getAlreadyGoldRfrNum( )
	return tonumber(tbShopInfo.refresh_num) or 0
end

--[[
 	@desc: 获取当前拥刷新道具的数量 
    @return: num  type: number 当前拥有的刷新道具数量
 —]] 
function getRfrItemNum()
	local num=0

	if tbShopDbData.item == nil then -- 如果未配置道具则返回 0 表示不支持道具刷新
		return num
	end

	local itemInfo=  ItemUtil.getCacheItemInfoBy(tonumber(tbShopDbData.item))
	if(itemInfo) then
		num = tonumber(itemInfo.item_num)
	end
	return num
end

-- 判断当前刷新次数是否达到最大值，true:到了， false:没有
function isRfrMax( )
	if tonumber(tbShopDbData.refresh) <= getAlreadyGoldRfrNum() then
		return true
	end
	return false
end

--[[
    @des:       得到自动刷新剩余时间
    @return:  time type: number  refresh_cd
]]
function getRefreshCdTime( )
	local refresh_cd = tonumber(tbShopInfo.refresh_cd)
	local time = (refresh_cd - TimeUtil.getSvrTimeByOffset())
	if(time > 0) then
		return time
	else
		return 0
	end
end

--[[
    @des:       得到物品的table
    @return:   table{
        item = {
            id : DB_Sky_piea_goods
            items: 要兑换的物品的信息
            canBuyNum: 可以购买的次数
            costNum： 花费的数值
            costType: 1：花费类型为空岛币 , 2：花费类型为金币
            needLvl: 购买需要的等级限制
        }
            
    }
]]

function getSkyPieaGoodsList(  )
	local tbItems ={}
	logger:debug(tbShopInfo.goods_list)
	for goodsId,canBuyNum in pairs(tbShopInfo.goods_list) do
		local item = {}
		local goodData = DB_Sky_piea_goods.getDataById(goodsId)
		logger:debug(goodData)
		local goods = lua_string_split(goodData.items,"|")

		if tonumber(goodData.isSold) == 1 then
			item.id = goodData.id
			item.items = goodData.items
			item.type = tonumber(goods[1])
			item.tid = tonumber(goods[2])
			item.num = tonumber(goods[3])
			item.canBuyNum= tonumber(canBuyNum)
			item.costNum= tonumber(goodData.costNum)
			item.costType= tonumber(goodData.costType)
			item.needLvl = tonumber(goodData.needlv)
			table.insert(tbItems, item)
		end
	end
	return tbItems
end

--[[
    @des:       修改神秘商店里canBuyNum
    @return:    
]]
function changeCanBuyNumByid( _goodsId , value)
	for goodsId, canBuyNum  in pairs(tbShopInfo.goods_list) do
		if(tonumber(goodsId)==tonumber(_goodsId)) then
			tbShopInfo.goods_list[goodsId] = tonumber(canBuyNum) - value or 1
			break
		end
	end
end

-------------------------------------------------------------------------------

function getAttrName( attrId )
	local attrName = ""
	for k,v in pairs(g_LockAttrNameConfig) do
		if(tonumber(attrId) == tonumber(k)) then
			attrName = v
			break
		end
	end
	-- logger:debug(attrName)
	-- logger:debug(g_AttrNameWithoutSign[attrName])
	return g_AttrNameWithoutSign[attrName] or ""
end

-----------buff---------------
--根据buffid 获取buff描述

--[[desc:功能简介
    arg1: 参数说明
    return: s_Des:buff描述
  		  buffType:buff类型
  		  n_AttrType:如果是属性加成，则加成的属性id
  		  n_heroCount:buff可作用的伙伴个数  0 为表示全体武将
—]]
-- function getBuffDesById( buffId )
-- 	local tb_DBInfo = DB_Sky_piea_buff.getDataById(buffId)
-- 	--buff类型|参数1|参数2
-- 	local buff = tb_DBInfo.buff
-- 	local buffAttrData  = lua_string_split(buff,"|")
-- 	--buff类型buffer类型：1：属性加成2:回复血量 3:回复怒气 4：复活
-- 	local buffType = buffAttrData[1]
-- 	--buffType ==1的时候  代表属性种类ID    =2 =3 =4表示buff可作用的人数
-- 	local buffNum = buffAttrData[2]
-- 	--buff作用带来的百分比
-- 	local buffPercent 	= buffAttrData[3]
-- 	local n_AttrType 	= 0
-- 	local s_Des 		= ""
-- 	local n_heroCount 	= 0
-- 	logger:debug(tb_DBInfo)
-- 	if(tonumber(buffType) == BUFFTYPE.ATTR_BUFF) then

-- 		n_AttrType = buffNum
-- 		s_Des = "全体武将"  .. "增加" .. buffPercent / BUFF_RATIO .. "%" .. tb_DBInfo.title
-- 	elseif(tonumber(buffType) == BUFFTYPE.RECOVER_HP_BUFF) then

-- 		s_Des = "回复" .. buffNum .. "名伙伴" .. (buffPercent / BUFF_RATIO) .. "%" .. "血量"
-- 		n_heroCount = buffNum
-- 	elseif(tonumber(buffType) == BUFFTYPE.RECOVER_RAGE_BUFF) then
-- 		n_heroCount = buffNum
-- 		s_Des = "回复" .. buffNum .. "名伙伴" .. buffPercent ..  "点怒气点数"
-- 	elseif(tonumber(buffType) == BUFFTYPE.REBORN_BUFF) then
-- 		n_heroCount = buffNum
-- 		s_Des = "复活" .. buffNum .. "名伙伴." .. "复活后拥有" .. (buffPercent / BUFF_RATIO) .. "%" .. "血量"
-- 	end

-- 	return s_Des, buffType, n_AttrType, n_heroCount
-- end


function getBuffInfoBought()
	return m_tbSkyFloorData.va_pass.buffInfo or {}
end

function setBuffInfoBought( tbAtrrBuff )
	m_tbSkyFloorData.va_pass.buffInfo = tbAtrrBuff
end

-- 将后端传的 buff 表进行处理
local buff_path = "images/skypieaBuff"
local heroColor = {r=0xff;g=0xff;b=0xff}
local attrColor = {r=0xff;g=0xf6;b=0x00}
local attrValueColor = {r = 0x4d,g = 0xec,b = 0x15}
-- ccc3(0x00,0x62,0x0c),

function parseBuffData(dictData)
	local tbBuffData = {}
	local buffId = 0
	for i,v in ipairs(dictData or {}) do
		local buffItem = {}
		buffId = v.buff
		local tb_DBInfo 				= DB_Sky_piea_buff.getDataById(buffId)

		--buff类型|参数1|参数2
		local buff = tb_DBInfo.buff
		local firstBuff = lua_string_split(buff,",")[1]
		local buffAttrData  = lua_string_split(firstBuff,"|")
		--buff类型buffer类型：1：属性加成2:回复血量 3:回复怒气 4：复活
		local buffType = buffAttrData[1]
		--buffType ==1的时候  代表属性种类ID    =2 =3 =4表示buff可作用的人数
		local buffNum = buffAttrData[2]
		--buff作用带来的百分比
		local buffPercent 			= buffAttrData[3]

		local n_AttrType 			= 0 													--如果是属性加成，则加成的属性id
		local s_Des 				= "" 													--buff描述
		local n_heroCount 			= 0 													--buff可作用的伙伴个数  0 为表示全体武将
		local recoveHp 				= 0 													--回复武将血量值
		local recoveRage 			= 0 													--回复武将怒气值
		local rebornRecoveHP 		= 0 													--复活武将并且回复血量值
		local attrValue		 		= 0 													--属性buff增加的值
		local s_richText 			= ""
		local tb_richColor 			= {}
		local richText 				= nil
		local iconImage = buff_path .. "/big_buff_icon/" .. tb_DBInfo.icon
		local nameImage = buff_path .. "/big_buff_name/" .. tb_DBInfo.icon

		if(tonumber(buffType) == BUFFTYPE.ATTR_BUFF) then
			n_AttrType = buffNum
			s_Des = m_i18nString(5437 , tb_DBInfo.title , buffPercent / BUFF_RATIO .. "%" )
			-- s_richText = m_i18nString(5439) .. "|"  .. tb_DBInfo.title  .. "|" .. m_i18nString(5440) .. "|" .. buffPercent / BUFF_RATIO .. "%"
			-- tb_richColor = {{color = heroColor, style = {type=1}} , {color = attrColor, style = {type=1}} , {color = heroColor, style = {type=1}}, {color = attrValueColor, style = {type=1}}}

			attrValue =  buffPercent / 100
			local tbAffixData = SkyPieaUtil.getAffixDataById(n_AttrType)
			iconImage = buff_path .. "/big_buff_icon/" .. tbAffixData.icon
			nameImage = buff_path .. "/big_buff_name/" .. tbAffixData.icon

		elseif(tonumber(buffType) == BUFFTYPE.RECOVER_HP_BUFF) then

			s_Des = m_i18nString(5441 ,  buffPercent / BUFF_RATIO .. "%" )
			-- s_richText 		= m_i18nString(5433) .. "|"  .. buffNum .. "|" ..  m_i18nString(5436) .. "|" .. (buffPercent / BUFF_RATIO) .. "%" .. "|" ..  "血量"
			-- tb_richColor	 = {{color = heroColor, style = {type=1}} , {color = attrColor, style = {type=1}} , {color = heroColor, style = {type=1}} , {color = attrValueColor, style = {type=1}} , {color = attrColor, style = {type=1}}}

			n_heroCount 	= buffNum
			recoveHp 		= (buffPercent / BUFF_RATIO)
		elseif(tonumber(buffType) == BUFFTYPE.RECOVER_RAGE_BUFF) then

			s_Des 			= m_i18nString(5442,buffPercent)
			-- s_richText 		= m_i18nString(5433) .. "|"  .. buffNum .. "|" ..  m_i18nString(5436) .. "|" .. "+" .. buffPercent ..  m_i18nString(5435)
			-- tb_richColor	 = {{color = heroColor, style = {type=1}} , {color = attrColor, style = {type=1}} , {color = heroColor, style = {type=1}} , {color = attrValueColor, style = {type=1}} , {color = attrColor, style = {type=1}}}

			n_heroCount 	= buffNum
			recoveRage 		= buffPercent
		elseif(tonumber(buffType) == BUFFTYPE.REBORN_BUFF) then

			s_Des 			=m_i18nString(5449,buffPercent / BUFF_RATIO .. "%")
			-- s_richText 		= m_i18nString(5437) .. "|" .. buffNum .. "|" ..  m_i18nString(5436) .. "," ..  m_i18nString(5438) .. "|" .. (buffPercent / BUFF_RATIO) .. "%" .. "|血量"
			-- tb_richColor	 = {{color = heroColor, style = {type=1}} , {color = attrColor, style = {type=1}} , {color = heroColor, style = {type=1}} , {color = attrValueColor, style = {type=1}} , {color = attrColor}, style = {type=1}}

			n_heroCount 	= buffNum
			rebornRecoveHP 	= buffPercent / BUFF_RATIO
		end

		if(tonumber(buffType) == BUFFTYPE.ATTR_BUFF) then
			richText = BTRichText.create(m_i18n[5436],nil,nil,tb_DBInfo.title,buffPercent / BUFF_RATIO .. "%")
		elseif(tonumber(buffType) == BUFFTYPE.RECOVER_HP_BUFF) then
			richText = BTRichText.create(m_i18n[5434],nil,nil,buffNum,buffPercent / BUFF_RATIO .. "%")
		elseif(tonumber(buffType) == BUFFTYPE.RECOVER_RAGE_BUFF) then
			richText = BTRichText.create(m_i18n[5433],nil,nil,buffNum,buffPercent)
		elseif(tonumber(buffType) == BUFFTYPE.REBORN_BUFF) then
			richText = BTRichText.create(m_i18n[5435],nil,nil,buffNum,buffPercent / BUFF_RATIO .. "%")
		end
		richText:retain()
		buffItem.richText 				= richText
		-- buffItem.tb_richColor 			= tb_richColor
		buffItem.name 					= tb_DBInfo.tips   												--buff名字
		buffItem.costStarNum 			= tb_DBInfo.costStar 											--购买此buff需要消耗的星数

		buffItem.iconImg 	 			= iconImage														--buff的Icon图片
		buffItem.nameImg 	 			= nameImage													 	--buff的名字图片
		buffItem.des 					= s_Des															--此buff的描述
		buffItem.status 				= tonumber(v.status) 											--此buff是否已经被处理过了
		buffItem.buffType 				= tonumber(buffType) 											--如果次buff的type
		buffItem.buffId 				= tonumber(buffId) 												--buff id
		buffItem.buffEffectCount 		= tonumber(n_heroCount)
		buffItem.attrType 				= tonumber(n_AttrType)
		buffItem.recoveHp 				= (recoveHp)
		buffItem.recoveRage 			= tonumber(recoveRage)
		buffItem.rebornRecoveHP 		= (rebornRecoveHP)
		buffItem.attrValue 				= (attrValue)

		table.insert(tbBuffData,buffItem)
	end
	logger:debug("可购买的buff信息是:")
	logger:debug(tbBuffData)
	return tbBuffData
end




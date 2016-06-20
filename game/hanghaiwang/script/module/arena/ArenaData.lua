-- FileName: ArenaData.lua 
-- Author: huxiaozhou 
-- Date: 2014-05-09 
-- Purpose: 竞技场数据

module("ArenaData", package.seeall)
require "script/model/user/UserModel"

TimeUtil.timeStart("DB_Arena_reward")
require "db/DB_Arena_reward"
TimeUtil.timeEnd("DB_Arena_reward")

-- 全局变量
arenaInfo = nil                         -- 竞技场数据
luckyListData = nil                     -- 幸运排名数据
rewardData = nil						-- 领取奖励数据
rankListData = nil                      -- 排行榜前十数据
challengeData = nil                     -- 挑战后返回数据
scheduleId_data = nil					-- 数据定时器
arenaScheduleId = {}           			-- 竞技UI定时器
rankScheduleId = nil 					-- 排名UI定时器

replayList = {}

m_mesShop = {}

local listData 					=  nil 		-- 竞技场挑战对手列表缓存数据
allUserData = nil 							-- 竞技场创建挑战列表tableView用数据
local m_prestige = nil
--得到table的大小
function tableCount(ht)
    if(ht == nil) then
        return 0
    end
    local n = 0
    for _, v in pairs(ht) do
        n = n + 1
    end
    return n;
end

-- 得到自己竞技场当前排名
function getSelfRanking()
	return tonumber(arenaInfo.position)
end

function setMyPrestigeData( _prestige )
	prestigeData = _prestige
end

function getMyPrestigeData(  )
	return prestigeData or 0
end

-- 设置自己竞技场当前排名
function setSelfRanking( position )
	arenaInfo.position = position
end

-- 得到今日剩余挑战次数 这种算法已舍弃
function getTodayChallengeNum()
	return tonumber(arenaInfo.challenge_num)
end

-- 设置今日剩余挑战次数 这种算法已舍弃
function setTodaySurplusNum( num )
	arenaInfo.challenge_num = num
end

-- 获取已经购买的竞技场次数
function getBuyTimesNum()
	return tonumber(arenaInfo.buy_num)
end

-- 增加已购买的次数
function addBuyTimes( buy_num )
	arenaInfo.buy_num = arenaInfo.buy_num + buy_num
end

-- 获取当前vip 能购买的最大次数
function getMaxBuyTimes(  )
	local userVipLevel  =  UserModel.getUserInfo().vip 
	local buy_arena_times  	=  DB_Vip.getDataById(tonumber(userVipLevel)).buy_arena_times
	return tonumber(buy_arena_times)
end

-- 获取一次购买增加的竞技场次数
function getBuyAddTimes(  )
	require "db/DB_Arena_properties"
	local data = DB_Arena_properties.getDataById(1)
	return data.buy_add_times or 0
end

-- 根据当前购买的竞技场次数，需要的金币数
function getNeedGoldByBuyNum( )
	local buy_num = getBuyTimesNum() + 1
	require "db/DB_Arena_properties"
	local data = DB_Arena_properties.getDataById(1)
	local buyArr =  string.split(data.buy_gold , ",")
	--"1|10,5|50,10|100"
	local gold = 0
	for i,str in ipairs(buyArr) do
		local goldArr = string.split(str, "|")
		if buy_num >= tonumber(goldArr[1]) then
			gold = tonumber(goldArr[2])
		end	
	end
	return gold 
end

-- 获取当前vip能够获得的竞技场次数
function getCanBuyNums( )
	return getMaxBuyTimes()*getBuyAddTimes()
end

function getNextVipCanBuyNums( )
	if(UserModel.getVipLevel() >= table.count(DB_Vip.Vip)) then
		return getMaxBuyTimes()*getBuyAddTimes()
	else
		local buy_arena_times = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())+1).buy_arena_times
		return buy_arena_times*getBuyAddTimes()
	end
end

--  设置添加今日的可挑战次数
function addTodayChallengeNum( num )
	if arenaInfo == nil or (arenaInfo ~= nil and arenaInfo.challenge_num == nil) or num == nil then
		return
	end
	arenaInfo.challenge_num = tonumber(arenaInfo.challenge_num) + tonumber(num)
end

-- 获取当前最大的挑战次数 和剩余挑战次数
function getChallengeTimes( )
	require "db/DB_Arena_properties"
	local data = DB_Arena_properties.getDataById(1)
	local userLevel  		=  UserModel.getUserInfo().level 
	local userVipLevel  	=  UserModel.getUserInfo().vip 
	local timeAddArr 		=  string.split(data.level_limit , ",")
	local vipAdd  			=  DB_Vip.getDataById(tonumber(userVipLevel)).arena_times_limit
	local nAddInitialTime 	= 0 
	for i=#timeAddArr,1, -1 do
		local attArr = string.split(timeAddArr[i], "|")	
		if (tonumber(attArr[1]) <= tonumber(userLevel) ) then
			nAddInitialTime =nAddInitialTime +  tonumber(attArr[2])
			break
		end
	end
	nAddInitialTime = nAddInitialTime + tonumber(vipAdd)
	local maxTimes = data.challenge_times
	return maxTimes + nAddInitialTime
end


function getAddTimesByLevel(  )
	require "db/DB_Arena_properties"
	local data = DB_Arena_properties.getDataById(1)
	local timeAddArr = string.split(data.level_limit , ",")
	local userLevel  =  UserModel.getUserInfo().level 

	for i=1, #timeAddArr do
		local attArr = string.split(timeAddArr[i], "|")	
		if (tonumber(attArr[1]) == tonumber(userLevel) ) then
			if i == 1 then
				return attArr[2]
			else
				local attArrPre = string.split(timeAddArr[i-1], "|")
				return attArr[2] - attArrPre[2]
			end
		end
	end
end


-- 获取历史最好排名
function getMinPosition( ... )
	return tonumber(arenaInfo.min_position)
end

-- 获取历史最好排名
function setMinPosition( minPos)
	if tonumber(minPos) <= tonumber(arenaInfo.min_position) then
		arenaInfo.min_position = minPos
	end
end

-- 得到领奖倒计时
function getAwardTime()
	local time = arenaInfo.reward_time
	return tonumber(time)
end


--[[
    @des:       得到刷新剩余时间
    @return:    time interval
]]
function getRefreshCdTime( )
	if (not arenaInfo) then
		return
	end
    local endRfrTime = tonumber(arenaInfo.reward_time)
    local time = endRfrTime - TimeUtil.getSvrTimeByOffset()
    if(time > 0) then
        return time 
    else
        return 0
    end
end

-- -- 设置倒计时
function setAwardTime( time )
	arenaInfo.reward_time = time + TimeUtil.getSvrTimeByOffset()
end

-- 设置opponents 挑战列表数据
function setOpponentsData( opponents_data )
	listData = opponents_data
end

-- 获取排行榜中是不是有npc
function getRankListContainNPC( ... )
	local topTenData = ArenaData.getTopTenData( ArenaData.rankListData )
	local bNpc = false
	for _,v in ipairs(topTenData or {}) do
		if tonumber(v.armyId) ~= 0 then
			bNpc = true
			break
		end
	end
	return bNpc
end


function setReplayList( _replayList )
	local tData = {}
	for k,v in pairs(_replayList or {}) do
		tData[#tData+1] = v
	end

	table.sort(tData, function ( data1, data2 )
		local n1 = tonumber(data1.attack_position) or 0
		local n2 = tonumber(data2.attack_position) or 0
		return n1 < n2
	end)

	replayList = tData
end

function getReplayList( ... )
	return replayList
end


-- 得到opponents 挑战列表数据
function getOpponentsData( ... )
	local data = {}
	if(listData == nil)then
		return data
	end
	data = getAllUserData(listData)
	return data
end

-- 得到竞技场玩家的数据(包括主角)
--[[
 Table[1] ={
    [level] => 17   		-- 等级
    [position] => 1 		-- 排名
    [utid] => 2   			-- 用户模板id
    [uid] => 21921 			-- 用户id
    [uname] => 789789 		-- 用户名字
    [luck] => 0				-- 是否处在幸运位置 0不是,1是
}
--]]
function getAllUserData( arenaUserData )
	local tData = {}
	for k,v in pairs(arenaUserData) do
		tData[#tData+1] = v
	end
	-- 按position从小到大重新生成新表
	for i=1,tableCount(tData) do
		for j=1,tableCount(tData)-i do
			if(tonumber(tData[j].position) > tonumber(tData[j+1].position) )then
				-- 交换位置
				tData[j],tData[j+1] = tData[j+1],tData[j]
			end
		end
	end
	-- 添加新元素 是否是幸运位置 
	if(luckyListData ~= nil)then
		for k,v in pairs(tData) do
			-- 遍历当前幸运位置
			for x,y in pairs(luckyListData.current) do
				if(tonumber(v.position) == tonumber(y.position))then
					-- 在幸运位置 为1
					v.luck = 1
					break
				else 
					-- 否则为0
					v.luck = 0
				end
			end
		end
	end
	-- ("排序,添加幸运位置后生成新表:")
	return tData
end


-- 得到排名奖励
-- 参数 position:排名位置,level:等级
-- 返回
-- 贝里数量,将魂数量,物品表
--[[
table = {
	 [1] => Table
        (
            [item_id] => 80001
            [item_num] => 1
        )
    [2] => Table
        (
            [item_id] => 80002
            [item_num] => 2
        )
	}
--]]

local _tRewardRank = {}

function getReard( position )
	if table.isEmpty(_tRewardRank) then
		for k,reward in pairs(DB_Arena_reward.Arena_reward) do
			table.insert(_tRewardRank, reward[1])
		end
		table.sort(_tRewardRank, function ( rank1, rank2)
			return tonumber(rank1) < tonumber(rank2)
		end)
	end

	logger:debug({_tRewardRank = _tRewardRank})

	local pos1,pos2 = 0,0
	
	for i, pos in ipairs(_tRewardRank) do

		if tonumber(position) == tonumber(pos)then
			local dbReward = DB_Arena_reward.getDataById(position)
			return tonumber(dbReward.reward_coin),tonumber(dbReward.reward_prestige), tonumber(dbReward.reward_coin_base)
		end

		if tonumber(position) > tonumber(pos)then
			pos1 = pos
		end
		if tonumber(position) < tonumber(pos) then
			pos2 = pos
			break
		end
	end

	logger:debug("pos1 = %s, pos2 = %s", pos1, pos2)

	if pos2==0 then -- 如果超过最大排名 则没有奖励
		return 0, 0, 0
	end

	local dbData1 = DB_Arena_reward.getDataById(pos1)
	local dbData2 = DB_Arena_reward.getDataById(pos2)
--[[注意：该表当中名次是不连续的，为了优化计算时间，如右侧
发奖时，若当前名次表中没有，则需要计算，按照每段之间平分向下取整的原则,即
在M——N名之间（M<N）有一名次A，MN游戏币分别m，n(m>n)，则A游戏币a=int(m-(m-n）/(N-M)*(A-M))
例如，69名，在50-100之间。则
游戏币=int(650-(650-625)/(100-50)*(69-50))
为640
--]]

	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 4 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	function countReward(M, N, m, n)
		return math.floor(m-(m-n)/(N-M)*(position-M)*multiplyRate)
	end

	local coin = countReward(pos1, pos2, dbData1.reward_coin, dbData2.reward_coin)
	local prestige = countReward(pos1, pos2, dbData1.reward_prestige, dbData2.reward_prestige)
	local coin2 = countReward(pos1, pos2, dbData1.reward_coin_base, dbData2.reward_coin_base)

	return coin, prestige, coin2
end

function getAwardItem( position, level)
	-- 表里基础值
	local coin, prestige, coin2 = getReard(position)

	-- 新需求 根据自己的等级计算奖励 显示为 自己的等级*奖励基础值  by 2013.12.09
	local level = UserModel.getHeroLevel()
	-- 基础值*max(level,30)
	local lv = math.max(tonumber(level),30)
	-- 声望
	-- 活动奖励系数
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 4 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})

	local active_rate = tonumber(arenaInfo.active_rate) or 1
	return math.floor((coin*lv + coin2)*active_rate*multiplyRate), math.floor(prestige*active_rate*multiplyRate)
end


-- 得到排行榜前十玩家数据
--[[
 Table[1] ={
    [level] => 17   		-- 等级
    [position] => 1 		-- 排名
    [utid] => 2   			-- 用户模板id
    [uid] => 21921 			-- 用户id
    [uname] => 789789 		-- 用户名字
    [luck] => 0				-- 是否处在幸运位置 0不是,1是
}
--]]
function getTopTenData( tUserData )
	local tData = {}
	for k,v in pairs(tUserData) do
		tData[#tData+1] = v
	end

	-- 如果只有一个人直接返回
	if(tableCount(tData) < 2 )then
		return tData
	end

	table.sort( tData, function (data1,data2)
		return tonumber(data1.position) < tonumber(data2.position)
	end )

	-- 添加新元素 是否是幸运位置 
	if(luckyListData ~= nil)then
		for k,v in pairs(tData) do
			-- 遍历当前幸运位置
			for x,y in pairs(luckyListData.current) do
				if(tonumber(v.position) == tonumber(y.position))then
					-- 在幸运位置 为1
					v.luck = 1
					break
				else 
					-- 否则为0
					v.luck = 0
				end
			end 
		end
	end
	return tData
end


-- 根据位置得到玩家的uid
function getUidByPosition( position )
	local uid = nil
	if(allUserData == nil)then
		return
	end
	for k,v in pairs(allUserData) do
		if(tonumber(position) == tonumber(v.position))then
			uid = tonumber(v.uid)
			break
		end
	end
	return uid
end


-- 得到挑战胜利后获得的贝里和将魂,exp
-- 表配置*自己等级
function getCoinAndSoulForWin()
	require "db/DB_Arena_properties"
	local data = DB_Arena_properties.getDataById(1)
	local base_coin = tonumber(data.win_base_coin)
	local base_exp = tonumber(data.win_base_exp)
	local base_prestige = tonumber(data.winPrestige)
	require "script/model/user/UserModel"
	local level = tonumber(UserModel.getUserInfo().level)
	if(UserModel.hasReachedMaxLevel()) then
		base_exp = 0
	end
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 4 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	local floor = math.floor
	return floor(base_coin*level*multiplyRate), floor(base_exp*level*multiplyRate), floor(base_prestige*multiplyRate)
end




-- 得到挑战失败后获得的贝里和将魂,exp
-- 表配置*自己等级
function getCoinAndSoulForFail()
	require "db/DB_Arena_properties"
	local data = DB_Arena_properties.getDataById(1)
	local base_coin = tonumber(data.lose_base_coin)
	local base_exp = tonumber(data.lose_base_exp)
	local base_prestige = tonumber(data.losePrestige)
	require "script/model/user/UserModel"
	local level = tonumber(UserModel.getUserInfo().level)
	if(UserModel.hasReachedMaxLevel()) then
		base_exp = 0
	end
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 4 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	local floor = math.floor
	return floor(base_coin*level*multiplyRate), floor(base_exp*level*multiplyRate), floor(base_prestige*multiplyRate)
end


-- 得到竞技列表中玩家的信息 
function getHeroDataByUid( uid )
	local tab = {}
	for k,v in pairs(allUserData) do
		if(tonumber(uid) == tonumber(v.uid))then
			tab = v
		end
	end
	return tab
end


-- 玩家名字的颜色
function getHeroNameColor( utid )
	local name_color = nil
	local stroke_color = nil
	if(tonumber(utid) == 1)then
		-- 女性玩家
		name_color = ccc3(0xf9,0x59,0xff)
		stroke_color = ccc3(0x00,0x00,0x00)
	elseif(tonumber(utid) == 2)then
		-- 男性玩家 
		name_color = ccc3(0x00,0xe4,0xff)
		stroke_color = ccc3(0x00,0x00,0x00)
	end
	return name_color, stroke_color
end


-- 根据npc的hid得到对应的头像icon
function getNpcIconByhid( hid )
	-- 根据hid查找DB_Monsters表得到对应的htid
	require "db/DB_Monsters"
	local htid = DB_Monsters.getDataById(hid).htid
	-- 根据htid查找DB_Monsters_tmpl表得到icon
	require "db/DB_Monsters_tmpl"
	local heroData = DB_Monsters_tmpl.getDataById(htid)
	local icon ="images/base/hero/head_icon/" .. heroData.head_icon_id
	local quality_bg ="images/hero/quality/"..heroData.star_lv .. ".png"

	local icon_sprite  = CCSprite:create(icon)
	local quality_sprite = CCSprite:create(quality_bg)
	icon_sprite:setAnchorPoint(ccp(0.5, 0.5))
	icon_sprite:setPosition(ccp(quality_sprite:getContentSize().width/2, quality_sprite:getContentSize().height/2))
	quality_sprite:addChild(icon_sprite)
	return quality_sprite
end

-- 得到npc的名字
function getNpcName( uid, utid )
	require "db/DB_Npc_name"
	-- 表中第几个key
	local surname_index = nil
	local girl_name_index = nil
	local boy_name_index = nil
	for k,v in pairs(DB_Npc_name.keys) do
		if(v == "surname")then
			surname_index = k
		end
		if(v == "girl_name")then
			girl_name_index = k
		end
		if(v == "boy_name")then
			boy_name_index = k
		end
	end
	-- 姓 个数
	local surname_count = 0
	for k,v in pairs(DB_Npc_name.Npc_name) do
		if(v[tonumber(surname_index)] ~= nil)then
			surname_count = surname_count + 1
		end
	end
	-- 男名 个数
	local boy_name_count = 0
	for k,v in pairs(DB_Npc_name.Npc_name) do
		if(v[tonumber(boy_name_index)] ~= nil)then
			boy_name_count = boy_name_count + 1
		end
	end
	-- 女名 个数
	local girl_name_count = 0
	for k,v in pairs(DB_Npc_name.Npc_name) do
		if(v[tonumber(girl_name_index)] ~= nil)then
			girl_name_count = girl_name_count + 1
		end
	end
	-- 取得姓的id
	local surname_id = math.mod(tonumber(uid),surname_count)+1
	-- 姓
	local surnameStr = DB_Npc_name.getDataById( surname_id ).surname
	-- 名字id
	local name_id = nil
	local nameStr = nil
	-- 男名id
	if(tonumber(utid) == 2)then
		name_id = math.mod(tonumber(uid),boy_name_count)+1
		nameStr = DB_Npc_name.getDataById( name_id ).boy_name
	end
	-- 女名id
	if(tonumber(utid) == 1)then
		name_id = math.mod(tonumber(uid),girl_name_count)+1
		nameStr = DB_Npc_name.getDataById( name_id ).girl_name
	end
	return surnameStr .. nameStr
end

-------------------------------------------------------------------------------
								-- 兑换商城
-------------------------------------------------------------------------------
local allGoods = {}

-- 初始化排行商店信息
function initAllGoods(  )
	require "db/DB_Arena_shop"
	
	allGoods = {}

	local tData = {}
	for k, v in pairs(DB_Arena_shop.Arena_shop) do
		table.insert(tData, v)
	end
	
	for k,v in pairs(tData) do
		-- isSold为1的显示到出售列表
		local itemData = DB_Arena_shop.getDataById(v[1])
		if( tonumber(itemData.isSold) == 1 and tonumber(itemData.highest_rank_display) > getMinPosition()) then

			local maxLimitNum =  tonumber(itemData.baseNum) - getBuyNumBy(itemData.id)
			if tonumber(itemData.limitType) == 2 and maxLimitNum > 0 then
				table.insert(allGoods, itemData)
			elseif tonumber(itemData.limitType) == 1 then
				table.insert(allGoods, itemData)
			end
		end
	end
	tData = nil

	local function keySort ( goods_1, goods_2 )
	   	return tonumber(goods_1.sortType) < tonumber(goods_2.sortType)
	end

	table.sort( allGoods, keySort )
end

-- 得到表配置的所有商品数据
function getArenaAllShopInfo()
	return allGoods
end


-- 仅需要在竞技场界面中的商店按钮和点进去之后的排名商店按钮添加红点即可。
-- 点击排名商店按钮后，两处的红点消失。 大退再登陆后，若还有可兑换的， 则继续显示红点。
local bNeedShowRedPoint = true
local bShowRedPoint = false

function setNeedShowRedPoint( bNeed )
	bNeedShowRedPoint = bNeed or false
end

--  获取商店上显示不显示红点
function getBShowRedPoint(  )
	if not bNeedShowRedPoint then
		return false
	end
	if table.isEmpty(allGoods) then initAllGoods() end
	for i,tData in ipairs(allGoods) do
		if ArenaData.getMinPosition() <= tonumber(tData.highest_rank) then
			bShowRedPoint = true
			break
		end
	end
	return bShowRedPoint
end


-- 根据goodsid 获取在第几个index
function getIndexByGoodsId(_goods_id )
	for i,v in ipairs(allGoods or {}) do
		if tonumber(v.id) == tonumber(_goods_id) then
			return i
		end
	end
end


-- 得到兑换物品的 物品类型，物品id，物品数量
function getItemData( item_str )
	local tab = string.split(item_str,"|")
	return tonumber(tab[1]),tonumber(tab[2]),tonumber(tab[3])
end


-- 获取某个物品的当前购买次数
function getBuyNumBy( goods_id )
	local goods_id = tonumber(goods_id)
	local number = 0
	if(arenaInfo.goods == nil)then
		return number
	end
	if(not table.isEmpty(arenaInfo.goods)) then
		for k_id, v in pairs(arenaInfo.goods) do
			if(tonumber(k_id) == goods_id) then
				number = tonumber(v.num)
				break
			end
		end
	end
	return number
end


-- 修改摸个商品的购买次数
function addBuyNumberBy( goods_id, n_addNum )
	local addNum = tonumber(n_addNum)
	if(table.isEmpty(arenaInfo.goods)) then
		arenaInfo.goods = {}
	end
	if(arenaInfo.goods["" .. goods_id])then
		arenaInfo.goods["" .. goods_id].num = tonumber(arenaInfo.goods["" .. goods_id].num) + addNum
	else
		arenaInfo.goods["" .. goods_id] = {}
		arenaInfo.goods["" .. goods_id].num = addNum
	end
end

-------------------------------------------------------------------------------------------------------
										-- 竞技场神秘商店
-------------------------------------------------------------------------------------------------------
-- 竞技场神秘商店信息
function getArenaMesShopInfo(  )
	return m_mesShop
end

require "db/DB_Arena_refreshgoods"
require "db/DB_Arena_refreshshop"
-- 设置竞技场神秘商店信息
local m_OMesShop = nil
function setArenaMesShopInfo( _tbShopInfo )
	m_OMesShop = _tbShopInfo
	local tbGoods = {}
	for k,v in pairs(_tbShopInfo.goodsList or {}) do
		local item = DB_Arena_refreshgoods.getDataById(k)
		if tonumber(item.isSold) == 1 then
			item.canBuyNum = v
			table.insert(tbGoods, item) 
		end
	end
	local function sortId ( data1, data2 )
		return tonumber(data1.id) < tonumber(data2.id)
	end

	table.sort(tbGoods, sortId)
	m_mesShop = tbGoods
end

-- 修改竞技场神秘商店兑换信息
function addMesGoodsBuyNum( index, n_addNum )
	local num = m_mesShop[index].canBuyNum 
	num = num + n_addNum
	m_mesShop[index].canBuyNum = num
end

-- 获取已经用去得刷新次数
function  getAlreadyGoldRfrNum( )
	return tonumber(m_OMesShop.gold_rfr_num)
end

--
function addAlreadyGOldRfrNum( add_num )
	m_OMesShop.gold_rfr_num = m_OMesShop.gold_rfr_num + add_num
end

-- 获取刷新需要的金币数
function getRfrGoldNum(  )
	local goldStr = DB_Arena_refreshshop.getDataById(1).gold
	local goldArr = string.split(goldStr, ",")
	local tbGold = {}
	for i,str in ipairs(goldArr) do
		local tempArr = string.split(str, "|")
		table.insert(tbGold,tempArr)
	end

	for i,v in ipairs(tbGold) do
		if getAlreadyGoldRfrNum()+1 < tonumber(tbGold[i][1]) then
			return tbGold[i-1][2]
		elseif(getAlreadyGoldRfrNum()+1 >= tonumber(tbGold[#tbGold][1])) then
			return tbGold[#tbGold][2]
		end
	end
end

-- 获取 刷新需要的item 有几个
function getRfrItemNum(  )
	local itemId = DB_Arena_refreshshop.getDataById(1).item
	local num=0
    local itemInfo=  ItemUtil.getCacheItemInfoBy(tonumber(itemId))
    if(itemInfo) then
        num = tonumber(itemInfo.item_num)
    end
    return num
end

function isRfrMax( ... )
	return getMaxRfrTimes() <= getAlreadyGoldRfrNum()
end

-- 获取最大的刷新次数
function getMaxRfrTimes(  )
	local maxNum = 0
	local userVipLevel  	=  UserModel.getUserInfo().vip 
	maxNum =  DB_Vip.getDataById(tonumber(userVipLevel)).arenashop_refreshtimes

	return tonumber(maxNum)
end

-----------------------  挑战列表的小船位置 -------------------------------
function getShipPosition( )
	require "db/DB_Arena_properties"
	local dataStr = DB_Arena_properties.getDataById(1).ship_position
	local posArr1 = string.split(dataStr, ",")

	local tbPos = {}
	for i,v in ipairs(posArr1) do
		local tempArr = string.split(v, "|")
		local temp1 = {}
		temp1.x = tempArr[1]
		temp1.y = tempArr[2]
		table.insert(tbPos, temp1)
	end
	return tbPos
end



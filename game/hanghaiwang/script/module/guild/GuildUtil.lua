-- Filename：	GuildUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-12-20
-- Purpose：		军团工具
-- modified by huxiaozhou 2014-09-15

module("GuildUtil", package.seeall)

require "db/DB_Legion"
require "db/DB_Legion_feast"
require "script/module/guild/GuildDataModel"
require "db/DB_Legion_shop"
require "db/DB_Legion_copy"
require "db/DB_Legion_copy_build"


local guildDBInfo = DB_Legion.getDataById(1)
--联盟副本表信息
local guildCopyDBInfo = DB_Legion_copy_build.getDataById(1)

-- 增加 first 字段 如果是1表示 第一次加入 不计算cd 否则 计算cd
local function getReJoinTime( singleInfo )
	if  singleInfo.va_member and tonumber(singleInfo.va_member.first) == 0 then
		return tonumber(singleInfo.rejoin_time)
	else
		return 0
	end
end

--  返回是不是在cd 中 联盟大厅的捐献 人鱼咖啡厅 etc。。。
function isInJoinCD(  )
	local db_cd = tonumber(guildDBInfo.cd)
	local nowTime = TimeUtil.getSvrTimeByOffset()
	local singleInfo = GuildDataModel.getMineSigleGuildInfo()
	local joinTime = getReJoinTime(singleInfo)
	if (nowTime-joinTime) <= db_cd then
		return tonumber(db_cd - (nowTime - joinTime))
	end
	return false
end

function getContriCD( )
	local nowTime = TimeUtil.getSvrTimeByOffset() -- zhangqi, 2015-01-20，本地当前时间
	local ymd = tostring(TimeUtil.getLocalOffsetDate("%Y-%m-%d",nowTime))

	local contri_time = GuildDataModel.getMineContriTime()
	local ymd2 = tostring(TimeUtil.getLocalOffsetDate("%Y-%m-%d",contri_time)) -- 捐献时间

	local rfrTime = TimeUtil.getZeroClockTime() + 3600*24 -- 2016-02-17，取到服务器当前日期的次日0点的时间戳，也就是下一次刷新贡献时间
	local _, nowSvr = TimeUtil.getServerDateTime(nowTime) -- 2016-02-17, zhangqi, 取得服务器的当前时间
	local now2Rfr = rfrTime -  nowSvr  -- 2016-02-17，计算当前到次日0点的剩余秒数
	local cd = isInJoinCD()             -- cd 时间

	if cd ~= false then -- 如果在cd 时间内
		logger:debug("cd ~= false, cd = %d, now2Rfr = %d ", cd, now2Rfr)
		if (cd >= now2Rfr) then
			return TimeUtil.getTimeString(cd)
		else
			return TimeUtil.getTimeString(now2Rfr)
		end

	else -- 不在重新加入cd 时间内
		logger:debug("cd == false, ymd = %s, ymd2 = %s, now2Rfr = %s ", tostring(ymd), tostring(ymd2), now2Rfr)
		if(ymd == ymd2)then -- 今天贡献过
			return TimeUtil.getTimeString(now2Rfr)
		else -- 今天没有共贡献过
			return TimeUtil.getTimeString(0)
		end
	end
end

function isCanContri(  )
	local scount = getContriCD()
	if scount ~= "00:00:00" then
		return false
	end
	return true
end

-- 在不在咖啡厅CD中
function getCafeCD(  )
	local db_cd = tonumber(DB_Legion_feast.getDataById(1).cd)
	local beginTime = tonumber(DB_Legion_feast.getDataById(1).beginTime) -- 时间字符串 hhmmss
	local endTime = tonumber(DB_Legion_feast.getDataById(1).endTime) -- 时间字符串 hhmmss
	local nowTime = TimeUtil.getSvrTimeByOffset()

	local singleInfo = GuildDataModel.getMineSigleGuildInfo()
	local rewardTime = singleInfo.reward_time
	local rewardNum = singleInfo.reward_num
	local joinTime = getReJoinTime(singleInfo) -- 服务器返回的时间戳，相当于本地时间戳

	-- getSvrIntervalByTime 返回的是一个对应服务器时区的时间戳
	local t_time1 = TimeUtil.getSvrIntervalByTime(beginTime) + 86400 -- 明天开始时间的时间戳
	local t_time2 = TimeUtil.getSvrIntervalByTime(endTime) -- 今天结束时间的时间戳

	-- zhangqi, 2016-02-19, 需要先把nowTime,joinTime转换成服务器时区的时间戳，才能和t_time1，t_time2进行正确比较
	_, nowTime = TimeUtil.getServerDateTime(nowTime) -- 转换为服务器时区的时间戳
	_, joinTime = TimeUtil.getServerDateTime(joinTime) -- 转换为服务器时区的时间戳

	if (nowTime-joinTime) <= db_cd then
		if (db_cd + joinTime > t_time1) then
			return (db_cd - (nowTime - joinTime))
		else
			if (rewardNum == "1" and (db_cd + joinTime > t_time1 - 86400) and (db_cd + joinTime < t_time2)) then
				return (db_cd - (nowTime - joinTime))
			else
				return (t_time1 - nowTime)
			end
		end
	else
		if (tonumber(rewardNum) == 0) then
			return (t_time1 - nowTime)
		end
		if (tonumber(rewardNum) == 1) then
			if (nowTime < t_time1 - 86400 ) then
				return (t_time1 - nowTime - 86400)
			elseif (nowTime > t_time2) then
				return (t_time1 - nowTime)
			else
				return 0
			end
		end
	end
end


function isCanBaiGuangong()
	if (getCafeCD() ~= 0) then
		return false
	else
		return true
	end
end


function isShowTip( ... )
	local singleInfo = GuildDataModel.getMineSigleGuildInfo()
	-- logger:debug(singleInfo)
	if not singleInfo then
		return false
	end

	if (table.isEmpty(singleInfo)) then
		return false
	end
	require "script/module/guildCopy/GCItemModel"
	local attackNum = GCItemModel.getAtackNum()
	local isCopyOpen = isGuildCopyOpen()
	local isCopyRed = attackNum > 0 and  isCopyOpen and GuildCopyModel.isHaveAttackingCopy() --liweidong 公会副本红点

	local mineSigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()

	local isRedTip = (tonumber(mineSigleGuildInfo.member_type) == 1 or tonumber(mineSigleGuildInfo.member_type) == 2) and g_redPoint.newGuildMemApply.visible
	if (isCanBaiGuangong()== true or isCanContri() == true or isCopyRed or isRedTip) and tonumber(GuildDataModel.getMineSigleGuildInfo().guild_id )~= 0  then
		return true
	end
	return false
end

--  返回是不是在cd 中 联盟商店
local guildShopInfo = DB_Legion_shop.getDataById(1)
function isShopCD(  )
	local db_cd = tonumber(guildShopInfo.convertCd)
	local nowTime = TimeUtil.getSvrTimeByOffset()
	local singleInfo = GuildDataModel.getMineSigleGuildInfo()
	local joinTime = getReJoinTime(singleInfo)
	if (nowTime-joinTime) <= db_cd then
		return tonumber(db_cd - (nowTime - joinTime))
	end
	return false
end



-- 创建所需银币
function getCreateNeedSilver()
	return guildDBInfo.costSilver
end

-- 创建所需金币
function getCreateNeedGold()
	return guildDBInfo.costGold
end

-- 军团人数上限 param 军团等级
function getMaxMemberNum(curLv)
	curLv = tonumber(curLv)
	local baseNumStr = guildDBInfo.baseNum
	local maxMemberNum = 1
	local baseNumArr = string.split(guildDBInfo.baseNum, ",")
	for k,v in pairs(baseNumArr) do
		local b_v = string.split(v, "|")
		if(tonumber(b_v[1]) == curLv )then
			maxMemberNum = tonumber(b_v[2])
			break
		end
	end

	return maxMemberNum
end

-- 是否达到成员流动次数上限
function isCanAgreeNum()
	return getMaxMemberNum(GuildDataModel.getGuildHallLevel()) + guildDBInfo.jionNumLimit
end

-- 获取每天新加成员人数上限
function getJoinNumLimit( ... )
	return guildDBInfo.jionNumLimit
end

-- 捐献方式
function getDonateInfoBy( d_type )
	local donateStr = guildDBInfo["donate"..d_type]
	local donateArr = string.split(donateStr, "|")

	local t_donate = {}

	t_donate.silver 	 = tonumber(donateArr[1])
	t_donate.gold 		 = tonumber(donateArr[2])
	t_donate.guildDonate = tonumber(donateArr[3])
	t_donate.sigleDonate = tonumber(donateArr[4])
	t_donate.needVip 	 = tonumber(donateArr[5])

	return t_donate
end


-- 副军团长人数 param 军团等级
function getMaxViceLeaderNumBy(curLv)
	curLv = tonumber(curLv)
	local donateArr = string.split(guildDBInfo.viceLevelArr, ",")
	local viceNum = 99

	for k, v in pairs(donateArr) do
		local v_arr = string.split(v, "|")
		if( curLv <= tonumber(v_arr[1]) and viceNum > tonumber(v_arr[2]) )then
			viceNum = tonumber(v_arr[2])
		end
	end

	return viceNum
end

-- 军团大厅升级所需经验
function getNeedExpByLv( curLv )
	require "script/utils/LevelUpUtil"
	local needExp = 0
	needExp = LevelUpUtil.getNeedExpByIdAndLv( guildDBInfo.expId, curLv )
	return needExp
end

-- 关公殿
function getGuanyuNeedExpByLv( curLv )
	require "script/utils/LevelUpUtil"
	local needExp = 0
	needExp = LevelUpUtil.getNeedExpByIdAndLv( DB_Legion_feast.getDataById(1).expId, curLv )
	return needExp
end

-- 商城
function getShopNeedExpByLv( curLv )
	require "script/utils/LevelUpUtil"
	local needExp = 0
	needExp = LevelUpUtil.getNeedExpByIdAndLv( DB_Legion_shop.getDataById(1).legionShopExp, curLv )
	return needExp
end

-- 士兵船坞
function getCopyNeedExpByLv( curLv )
	require "script/utils/LevelUpUtil"
	local needExp = 0
	needExp = LevelUpUtil.getNeedExpByIdAndLv( guildCopyDBInfo.expid, curLv )
	return needExp
end

-- 军机大厅
function getMilitaryNeedExpByLv( curLv )
	require "script/utils/LevelUpUtil"
	local needExp = 0
	needExp = LevelUpUtil.getNeedExpByIdAndLv( DB_Legion_copy.getDataById(1).expId, curLv )
	return needExp
end

function getCopyHallNeedExpByLv( curLv )
	require "script/utils/LevelUpUtil"
	local needExp = 0
	needExp = LevelUpUtil.getNeedExpByIdAndLv( DB_Legion_copy.getDataById(1).expId, curLv )
	return needExp
end

-- 弹劾军团长的费用
function getCostForAccuse()
	return guildDBInfo.accuseCost
end


-- 得到创建军团所需的等级
function getCreateGuildNeedLevel( ... )
	return tonumber(guildDBInfo.needLevel)
end

-- 军团最大等级
function getMaxGuildLevel()
	return guildDBInfo.maxLevel
end

-- 关公殿最大等级
function getMaxGongyuLevel()
	return math.ceil(getMaxGuildLevel()*DB_Legion_feast.getDataById(1).levelRatio/100)
end

-- 军团商店最大等级
function getMaxShopLevel()
	return math.ceil(getMaxGuildLevel()*DB_Legion_shop.getDataById(1).levelRatio/100)
end

-- 军机大厅最大等级
function getMaxHallCopyLevel()
	return math.ceil(getMaxGuildLevel()*DB_Legion_copy.getDataById(1).levelRatio/100)
end

---------------------------联盟图标 --------------------------
require "db/DB_Legion_logo"

function getAllIcons( ... )
	local tbAllIcons = {}
	local tbIcons = {}
	for k,v in pairs(DB_Legion_logo.Legion_logo or {}) do
		table.insert(tbIcons, v[1])
	end
	table.sort(tbIcons)

	local tbSub = {}
	for i,v in ipairs(tbIcons) do
		table.insert(tbSub,v)
		if(table.maxn(tbSub)>=4) then
			table.insert(tbAllIcons,tbSub)
			tbSub = {}
		elseif(i==table.maxn(tbIcons)) then
			table.insert(tbAllIcons,tbSub)
			tbSub = {}
		end
	end
	return tbAllIcons
end

function getLogoDataById(id)
	return DB_Legion_logo.getDataById(id)
end

--------------------------- 联盟商店 -------------------------
require "db/DB_Legion_goods"
require "script/module/guild/GuildDataModel"

local _normalGoodsInfo = {}
local _specialGoodsInfo= {}

-- 获得道具的物品信息
function getNormalGoods( )
	local normalGoods= DB_Legion_goods.getArrDataByField("goodType", 2)

	_normalGoodsInfo = {}
	-- 对数据进行排序
	local function keySort ( goods1, goods2 )
		return tonumber(goods1.sortType ) < tonumber(goods2.sortType)
	end
	table.sort( normalGoods, keySort)

	for i=1, #normalGoods do
		if(tonumber(normalGoods[i].isSold)==1) then
			local goodInfo= {}
			local normalGoods = normalGoods[i]
			local goods = lua_string_split(normalGoods.items,"|")
			goodInfo.id= tonumber(normalGoods.id)
			goodInfo.type = tonumber(goods[1])
			goodInfo.tid = tonumber(goods[2])
			goodInfo.num = tonumber(goods[3])
			goodInfo.costContribution = normalGoods.costContribution
			goodInfo.limitType= normalGoods.limitType
			goodInfo.needLegionLevel= normalGoods.needLegionLevel
			goodInfo.baseNum= normalGoods.baseNum
			goodInfo.personalLimit= normalGoods.personalLimit
			goodInfo.costGold = normalGoods.costGold
			table.insert( _normalGoodsInfo, goodInfo)
		end
	end
	return _normalGoodsInfo
end

-- 通过 goodId来获得某一个道具物品信息
function getNormalGoodById( id)
	for i=1,#_normalGoodsInfo do
		if(tonumber(id)== _normalGoodsInfo[i].id) then
			return _normalGoodsInfo[i]
		end
	end
end

-- 获得珍品的物品信息
function getSpecialGoods( )

	local specialGoods = GuildDataModel.getSpecialGoodsInfo()

	_specialGoodsInfo={}
	for goodId, values in pairs(specialGoods) do
		local goodInfo = {}
		logger:debug(" goodId is = %s: ", goodId)

		local goodData = DB_Legion_goods.getDataById(tonumber(goodId))
		local goods = lua_string_split(goodData.items,"|")
		goodInfo.id = goodData.id
		goodInfo.type = tonumber(goods[1])
		goodInfo.tid = tonumber(goods[2])
		goodInfo.num = tonumber(goods[3])
		goodInfo.sortType= goodData.sortType
		goodInfo.costContribution = goodData.costContribution
		goodInfo.limitType= goodData.limitType
		goodInfo.needLegionLevel= goodData.needLegionLevel
		goodInfo.baseNum= goodData.baseNum
		goodInfo.personalLimit= goodData.personalLimit
		goodInfo.recommended = goodData.recommended
		goodInfo.costGold = goodData.costGold
		table.insert(_specialGoodsInfo, goodInfo)
	end

	local function keySort ( goods1, goods2 )
		return tonumber(goods1.sortType ) < tonumber(goods2.sortType)
	end
	table.sort( _specialGoodsInfo, keySort)

	return _specialGoodsInfo
end

-- 通过 goodId 来获得某一珍品的物品信息
function getSpcialGooodById( id)
	for i=1,#_specialGoodsInfo do
		if(tonumber(id)== _specialGoodsInfo[i].id) then
			return _specialGoodsInfo[i]
		end
	end
end


-- 建设情况
function getContriStringByInfo(member_info)
	local t_text_arr = {}
	l_time = member_info.contri_time or 0
	l_time = tonumber(l_time)

	-- 今天00:00:00 的时间戳
	local t_time = TimeUtil.getSvrIntervalByTime(000000)
	local c_text = ""
	if(l_time>=t_time)then
		if(tonumber(member_info.contri_type) == 1)then
			local t_text = {}
			t_text.text = gi18n[3678] .. gi18n[1520] .. gi18n[3680]
			t_text.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text)

		elseif(tonumber(member_info.contri_type) == 2)then
			local t_text = {}
			t_text.text = gi18n[3678]
			t_text.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text)

			local t_text_2 = {}
			t_text_2.text = "20" .. gi18n[2220]
			t_text_2.color = ccc3(0xff, 0xf6, 0x00)
			table.insert(t_text_arr, t_text_2)

			local t_text_3 = {}
			t_text_3.text = gi18n[3680]
			t_text_3.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text_3)

		elseif(tonumber(member_info.contri_type) == 3)then
			local t_text = {}
			t_text.text = gi18n[3678]
			t_text.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text)

			local t_text_2 = {}
			t_text_2.text = "200" .. gi18n[2220]
			t_text_2.color = ccc3(0xff, 0xf6, 0x00)
			table.insert(t_text_arr, t_text_2)

			local t_text_3 = {}
			t_text_3.text = gi18n[3680]
			t_text_3.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text_3)

		elseif(tonumber(member_info.contri_type) == 4)then
			local t_text = {}
			t_text.text = gi18n[3678]
			t_text.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text)

			local t_text_2 = {}
			t_text_2.text = "300" .. gi18n[2220]
			t_text_2.color = ccc3(0xff, 0xf6, 0x00)
			table.insert(t_text_arr, t_text_2)

			local t_text_3 = {}
			t_text_3.text = gi18n[3680]
			t_text_3.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text_3)
		else
			logger:debug("this contri_type is no add !!!")
		end

	else
		local c_days = 0
		c_days = math.ceil( ( t_time- l_time)/(60*60*24) )
		if(c_days<=7)then
			local t_text = {}
			t_text.text = gi18nString(3606, c_days)
			t_text.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text)
		else
			local t_text = {}
			t_text.text = "7天以上未建设"
			t_text.color = ccc3(0xff, 0xff, 0xff)
			table.insert(t_text_arr, t_text)
		end
	end
	return t_text_arr
end


-- 成员审核排序 按时间
function sortCheckByTime( memberData )
	local function keySort ( data_1, data_2 )

		if(tonumber(data_1.apply_time) > tonumber(data_2.apply_time))then
			-- 按在线
			return false
		else
			return true
		end

	end
	table.sort( memberData, keySort )
	return memberData
end

-- 成员审核排序 按等级
function sortCheckByLevel( memberData )
	local function keySort ( data_1, data_2 )
		if(tonumber(data_1.level) >= tonumber(data_2.level))then
			return false
		else
			return true
		end
	end
	table.sort( memberData, keySort )
	return memberData
end

-- 成员审核排序 按战斗力
function sortCheckByForce( memberData )
	local function keySort ( data_1, data_2 )
		if(tonumber(data_1.fight_force) >= tonumber(data_2.fight_force))then
			return false
		else
			return true
		end
	end
	table.sort( memberData, keySort )
	return memberData
end

-- 成员审核排序 按竞技排名
function sortCheckByRank( memberData )
	local function keySort ( data_1, data_2 )
		if(data_1.position == nil)then
			return true
		end
		if(data_2.position == nil)then
			return false
		end
		if(tonumber(data_1.position) <= tonumber(data_2.position))then
			return false
		else
			return true
		end
	end
	table.sort( memberData, keySort )
	return memberData
end


function isGuildCopyOpen( ... )
	local openLv = GuildDataModel.getGuildLvToOpenCopy()
	local hallLV = GuildDataModel.getGuildHallLevel()

	-- logger:debug("开启联盟副本需要的工会大厅等级是:" .. openLv)
	-- logger:debug("工会大厅等级是:" .. hallLV)
	return hallLV >= openLv
end
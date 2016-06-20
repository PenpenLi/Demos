-- FileName: MainCopyModel.lua
-- Author: liweidong
-- Date: 2015-01-10
-- Purpose: 活动副本model
--[[TODO List]]

module("MainCopyModel", package.seeall)

-- UI控件引用变量 --
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["MainCopyModel"] = nil
end

function moduleName()
    return "MainCopyModel"
end

function create(...)

end
--获取一个据点 简单难度 最后一场战斗的整容信息 --baseId, 所占id
function getBaseLastFront(baseId,level)
	require "db/DB_Stronghold"
	require "db/DB_Army"
	require "db/DB_Team"
	require "db/DB_Monsters"

	local base=DB_Stronghold.getDataById(baseId)
	local armyids=lua_string_split(base.army_ids_simple, ",")
	local armyid=armyids[#armyids]
	local army = DB_Army.getDataById(armyid)
	local team = DB_Team.getDataById(army.monster_group)
	local monsterIds=lua_string_split(team.monsterID, ",")

	local heroIds={}
	for i=1,6 do
		local id = tonumber(monsterIds[i])
		if (id==0) then
			table.insert(heroIds,0)
		else
			local hero = DB_Monsters.getDataById(id)
			table.insert(heroIds,tonumber(hero.htid))
		end
	end
	return heroIds
end
--获取db所有id
function getActivityDbIds()
	require "db/DB_Activitycopy"
	local ids = {}
	for keys,val in pairs(DB_Activitycopy.Activitycopy) do
		local keyArr = lua_string_split(keys, "_")
		table.insert(ids,tonumber(keyArr[2]))
	end
	return ids
end
--判断一个活动副本是否已经开启
function activityIsOpened(id)
	local db=DB_Activitycopy.getDataById(id)
	local tbUserInfo = UserModel.getUserInfo()
	local openLv=lua_string_split(db.limit_lv, "|")
	return tonumber(tbUserInfo.level)>=tonumber(openLv[1])
end
--返回副本开启等级
function getActivityOpenLv(id)
	local db=DB_Activitycopy.getDataById(id)
	local openLv=lua_string_split(db.limit_lv, "|")
	return openLv[1]..gi18n[5531]--"级开启"
end
--判断一个活动副本是否在活动期间
function activityIsOnTime(id)
	local db=DB_Activitycopy.getDataById(id)
	if (db.week==nil) then
		return true
	end
	local curSecond = TimeUtil.getSvrTimeByOffset()
	local todayInfo=TimeUtil.getLocalOffsetDate("*t",curSecond)

	local todaySecond=todayInfo.hour*60*60+todayInfo.min*60+todayInfo.sec*1
	local isInTime = false
	if (db.start_time<=todaySecond and db.end_time>=todaySecond) then
		isInTime=true
	end
	local days = tostring(TimeUtil.getLocalOffsetDate("%w",tonumber(curSecond)))
	local dayArr=lua_string_split(db.week, "|")
	local onTime = table.include(dayArr,{days})
	return onTime and isInTime
end
--返回副本开启时间
function getActivityOpenTimeStr(id)
	local dayStr={[0]=gi18n[4321],[1]="1",[2]="2",[3]="3",[4]="4",[5]="5",[6]="6"}  --TODO
	local db=DB_Activitycopy.getDataById(id)
	if (db.week==nil) then
		return ""
	end
	logger:debug("week days =="..db.week)
	local dayArr=lua_string_split(db.week, "|")
	local openStr = gi18n[4322] --"周"  --TODO
	for i,v in ipairs(dayArr) do
		local week
		if (i==#dayArr) then
			week=dayStr[tonumber(v)]
		else
			week=dayStr[tonumber(v)]..","  --TODO
		end
		openStr=openStr..week
	end
	openStr=openStr..gi18n[4007] --"开启"  --TODO
	return openStr
end
--获取活动副本列表信息 返回对id排序 并返回活动期间的副本
function getActivityListData()
	local ids = getActivityDbIds()
	local tmpids = {}
	local ids1 = {}
	local ids2 = {}
	local ids3 = {}
	for _,id in ipairs(ids) do
		if activityIsOpened(id) then
			table.insert(tmpids,id)
		else
			table.insert(ids3,id)
		end
	end
	for _,id in ipairs(tmpids) do
		if activityIsOnTime(id) then
			table.insert(ids1,id)
		else
			table.insert(ids2,id)
		end
	end

	local function sortByLv(a,b)
		local dba=DB_Activitycopy.getDataById(a)
		local dbb=DB_Activitycopy.getDataById(b)
		local openLva=lua_string_split(dba.limit_lv, "|")
		local openLvb=lua_string_split(dbb.limit_lv, "|")
		return tonumber(openLva[1])<tonumber(openLvb[1]) 
	end
	table.sort(ids1,sortByLv)
	table.sort(ids2,sortByLv)
	table.sort(ids3,sortByLv)

	local sortIds = {}
	for _,id in pairs(ids1) do
		table.insert(sortIds,id)
	end
	for _,id in pairs(ids2) do
		table.insert(sortIds,id)
	end
	for _,id in pairs(ids3) do
		table.insert(sortIds,id)
	end
	return sortIds,ids1
end
--返回当前活动副本总计可攻打次数
function getAllAtackNums()
	if (not SwitchModel.getSwitchOpenState(ksSwitchActivityCopy,false) ) then
		return 0
	end
	local _,ids=getActivityListData()
	local atackNums=0
	for _,id in pairs(ids) do
		atackNums=atackNums+getRemainAtackTimes(id)
	end
	return atackNums
end
--根据id获得DataCache中的活动副本信息，如果为空则创建
function getACopyItemById(id)
	local data = DataCache.getActiviyCopyInfo()
	if (data==nil) then
		data = {}
	end
	if (data[""..id]==nil) then
		data[""..id]={
				va_copy_info={},
				copy_id = ""..id,
				atk_num = "0",
				buy_atknum = "0"
			}
	end
	local item = data[""..id]
	return item
end
--12点重置活动副本数据
function resetAcopyData()
	DataCache.setActiviyCopyInfo({})
	require "script/module/copyActivity/MainCopyCtrl"
	MainCopyCtrl.updateUI()
	require "script/module/copyActivity/BellyChanlage"
	BellyChanlage.updateUI()
	require "script/module/copyActivity/ChanglageMonster"
	ChanglageMonster.updateUI()
	require "script/module/copyActivity/BuyBattleTimes"
	BuyBattleTimes.updateUI()
end
--获得副本剩余攻打次数
function getRemainAtackTimes(id)
	-- local data = DataCache.getActiviyCopyInfo()
	-- logger:debug(id.."========== remain times id")
	local item = getACopyItemById(id)
	local db=DB_Activitycopy.getDataById(id)
	return db.times_num+item.buy_atknum-item.atk_num
end
--获取某个副本当前第几次购买战斗次数 
function getBuyTimes(id)
	--local data = DataCache.getActiviyCopyInfo()
	local item = getACopyItemById(id)
	return item.buy_atknum+1
end
--获取今日还可购买 增加战斗次数  的次数
function getBuyTimesRemainNum(id)
	local dbVip = DB_Vip.getDataById(UserModel.getVipLevel())
	local copys = lua_string_split(dbVip.acopy_buytimes, ",")
	local allnum=0
	for _,v in ipairs(copys) do
		local item = lua_string_split(v,"|")
		if (tonumber(item[1])==tonumber(id)) then
			allnum=tonumber(item[2])
			break
		end
	end
	local canbuyTimes=allnum-getBuyTimes(id)+1
	if (canbuyTimes<0) then
		canbuyTimes=0
	end
	return canbuyTimes 
end
--获取当前购买 增加战斗次数 所需金币
function getBuyTimesGold(id)
	local buyTimes = getBuyTimes(id)
	local db=DB_Activitycopy.getDataById(id)
	
	local c_price = 0
	if db.buy_gold then
		local per_arr = string.split(db.buy_gold, ",")
		local tmp1 = string.split(per_arr[1], "|")
		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2])
		for _,val in pairs(per_arr) do
			local tmp = string.split(val, "|")
			if (tonumber(buyTimes)<tonumber(tmp[1]) and tonumber(buyTimes)>=prekey) then
				c_price = preval
				break
			end
			prekey,preval = tonumber(tmp[1]),tonumber(tmp[2])
			c_price = preval --大于等于最大次数情况 和 只填写第一次的情况
		end
	end
	return tonumber(c_price)
end
--增加一次战斗次数
function addBattleTimes(id)
	--local data = DataCache.getActiviyCopyInfo()
	local item = getACopyItemById(id)
	item.buy_atknum=item.buy_atknum+1
end
--使用一次战斗次数
function subBattleTimes(id)
	--local data = DataCache.getActiviyCopyInfo()
	local item = getACopyItemById(id)
	item.atk_num=item.atk_num+1
end
--获取当前购买 更换影子 所需金币
function getBuyChangeRewardGold(id)
	local buyTimes = getBuyChangeRewardTimes()
	local db=DB_Activitycopy.getDataById(id)

	local c_price = 0
	if db.refresh_gold then
		local per_arr = string.split(db.refresh_gold, ",")
		local tmp1 = string.split(per_arr[1], "|")
		local prekey,preval = tonumber(tmp1[1]),tonumber(tmp1[2])
		for _,val in pairs(per_arr) do
			local tmp = string.split(val, "|")
			if (tonumber(buyTimes)<tonumber(tmp[1]) and tonumber(buyTimes)>=prekey) then
				c_price = preval
				break
			end
			prekey,preval = tonumber(tmp[1]),tonumber(tmp[2])
			c_price = preval --大于等于最大次数情况 和 只填写第一次的情况
		end
	end
	return tonumber(c_price)
end
local buyChangeRewardTime=0
--当前更换影子次数
function getBuyChangeRewardTimes()
	return buyChangeRewardTime+1
end
--初始化当前更换影子次数
function initBuyChangeRewardTimes()
	buyChangeRewardTime=0
end
--增加当前更换影子次数
function addBuyChangeRewardTimes()
	buyChangeRewardTime=buyChangeRewardTime+1
end
-- FileName: MainFdsData.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 好友列表数据model
--[[TODO List]]

module("MainFdsData", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
cuPageNum = 1 --当前页数
local prePageDataCout = 10 --每页的数据量
local curMsgId --留言的玩家id
local msgText --留言内容

local tbFriendsData --我的好友

--处理删除好友与更新好友状态的冲突变量
isDelFds = false
local tbStatusLine = {} --更新状态的数据

local function init(...)

end

function destroy(...)
	package.loaded["MainFdsData"] = nil
end

function moduleName()
    return "MainFdsData"
end

function create(callback)
	require "script/network/RequestCenter"
	RequestCenter.friend_getFriendInfoList(callback,nil)
end

function setFriendsList( tbData )
	local tbTempData = {}
	tbTempData = table.hcopy(tbData,tbTempData)
	if (tbTempData ~= nil) then
		
		local tbForce = {}
		local tbStatus = {}

		-- 战力高低排序
		local function ftforceSort( a, b )
			if (b and a) then
				return tonumber(b.fight_force) < tonumber(a.fight_force)
			end
		end
		table.sort( tbTempData, ftforceSort)

		-- 等级高低排序
		local function levelSort( a, b )
			if (b and a) then
				return tonumber(b.level) < tonumber(a.level)
			end
		end
		table.sort( tbTempData, levelSort )

		for k,v in pairs(tbTempData) do
			table.insert(tbForce,v)
		end

		-- 是否在线排序
		for k,v in pairs(tbForce) do
			if(v.status ~= nil) then
				if (tbStatus[tonumber(v.status)] == nil) then
					tbStatus[tonumber(v.status)] = {}
				end
				table.insert(tbStatus[tonumber(v.status)],v)
			end
		end
		
		tbFriendsData = {}
		-- for i = 1,#tbStatus do
		-- 	if (tbStatus[i] ~= nil) then
		-- 		for k,v in pairs(tbStatus[i]) do
		-- 			table.insert(tbFriendsData,v)
		-- 		end
		-- 	end
		-- end
		for i,v in ipairs(tbStatus[1] or {}) do
			table.insert(tbFriendsData,v)
		end
		for i,v in ipairs(tbStatus[2] or {}) do
			table.insert(tbFriendsData,v)
		end

		logger:debug("tbFriendsData")
		-- logger:debug(tbFriendsData)
	end

end

-- 获取我的好友数量
function getFriendsCount( ... )
	if(not tbFriendsData)then 
		return 0
	end 
	return table.count(tbFriendsData)
end

function getFriendsList( ... )
	return tbFriendsData
end

local function getFdsPage( ... )
	return math.ceil(#tbFriendsData / prePageDataCout)
end

local function fnGetStatus( status )
    if(status == 4) then
        return gi18n[2908]
    elseif(status == 3) then  
        return gi18n[2911]
    elseif(status == 2) then
        return gi18n[2909]
    else
        return gi18n[2910]
    end 
end


function getPageFdsData( onCallBack )
	local tbPageFdsData = {}
	local i = 1
	for k,v in pairs(tbFriendsData) do
		if (v ~= nil) then
			if (cuPageNum * prePageDataCout >= i) then
				v.eventBack = onCallBack
				--是否已经赠送过耐力  
				-- local isGive = isGiveTodayByTime( v.lovedTime )  --服务器刷新时间不一定是0点，不能按照0点计算
				v.isGive = tonumber(v.lovedTime)>0 and true or false   --服务器0点重置时loveTime置0，客户端重新拉取数据
				v.stateText = fnGetStatus(tonumber(v.status))
				table.insert(tbPageFdsData,v)
				i = i + 1 
			end
		end
	end

	if (cuPageNum < getFdsPage() and #tbPageFdsData > 0) then
		table.insert(tbPageFdsData,{more = true,eventBack = onCallBack})
	end

	logger:debug("getPageFdsData")
	logger:debug(tbPageFdsData)
	return tbPageFdsData
end

function delMineFds( uid )
	local mineFds = {}
	mineFds = table.hcopy(tbFriendsData,mineFds)
	for k,v in pairs(mineFds) do
		if (tonumber(v.uid) == uid) then
			mineFds[k] = nil
		end
	end
	setFriendsList(mineFds)
end

function updateMineFds( ... )
	isDelFds = false
	delMineFds(curMsgId)
	updateOnOffData() --更新上下线状态
	curMsgId = nil
end

function delSomeFds( tbFds )
	if (tbFds ~= nil) then
		for k,v in pairs(tbFds) do
			delMineFds(tonumber(v))
		end
	end
end

function getMsgUid( ... )
	return curMsgId	
end

function getMsgName( ... )
	local msgName = nil
	for k,v in pairs(tbFriendsData) do
		if (tonumber(v.uid) == curMsgId) then
			msgName = v.uname
		end
	end
	return msgName	
end

function setMsgUid( fuid )
	curMsgId = fuid
end

function setMsgText( content )
	msgText = content
end

function upFdsDataLine( upData )
	local tbFdsLine = {}
	tbFdsLine = table.hcopy(tbFriendsData,tbFdsLine)
	for k,v in pairs(tbFdsLine) do
		for i,j in pairs(upData) do
			if( tonumber(v.uid) == tonumber(j.uid) )then
				v.status = j.lineStatus
			end
		end
	end
	setFriendsList(tbFdsLine)
end

--删除好友后更新上下线状态数据
function updateOnOffData( ... )
	if (#tbStatusLine > 0) then
		upFdsDataLine(tbStatusLine)
		tbStatusLine = {}
	end
end

-- 设置好友上线状态
-- online = 1
function setFriendOnline( tabData )
	local tbd = {}
	for k,v in pairs(tabData) do
		local tb = {lineStatus = 1,uid = v}
		table.insert(tbd,tb)
	end
	if (isDelFds) then
		for lk,lv in ipairs(tbd) do
			table.insert(tbStatusLine,lv)
		end
	else
		upFdsDataLine(tbd)
	end
end

-- 设置好友下线状态
-- offline = 2
function setFriendOffline( tabData )
	local tbd = {}
	for k,v in pairs(tabData) do
		local tb = {lineStatus = 2,uid = v}
		table.insert(tbd,tb)
	end
	if (isDelFds) then
		for lk,lv in ipairs(tbd) do
			table.insert(tbStatusLine,lv)
		end
	else
		upFdsDataLine(tbd)
	end
end

------------------------------------------- 好友赠送体力 --------------------------------------

-- 得到一次可赠送的体力值
function getGiveStaminaNum( ... )
	require "db/DB_Give_stamina"
	local num = 0
	local data = DB_Give_stamina.getDataById(1)
	num = tonumber(data.give_stamina_num)
	return num
end

-- 把当前时间设置为上次赠送的时间
function setGiveTimeBystma( uid )
	if(tbFriendsData == nil)then
		return
	end

	for k,v in pairs(tbFriendsData) do
		if(tonumber(uid) == tonumber(v.uid))then
			local curServerTime = TimeUtil.getSvrTimeByOffset()
			v.lovedTime = curServerTime
		end
	end 
end

-- 把当前时间设置为上次赠送的时间
function setGiveTimeByUid( ... )
	setGiveTimeBystma(curMsgId)
end

function objAtIndexCell( ... )
	for k,v in pairs(tbFriendsData) do
		if(tonumber(curMsgId) == tonumber(v.uid))then
			return tonumber(k) - 1
		end
	end
end

-- 判断当天是否赠送过该玩家体力
-- timeData：时间戳
function isGiveTodayByTime( timeData )
	local curServerTime = TimeUtil.getSvrTimeByOffset()
	local date = TimeUtil.getLocalOffsetDate("*t", curServerTime)
	local curHour = tonumber(date.hour)

	local curMin = tonumber(date.min)

	local cruSec = tonumber(date.sec)

	-- 今天从0点到现在的所有秒数
	local curTotal = curHour*3600 + curMin*60 + cruSec
	-- timeData 跟 现在时间 的时间差
	local subTime = curServerTime - tonumber(timeData)
	-- 判断是否在同一天
	-- 两个时间段相差的秒数
	local overTime =  subTime - curTotal
	-- overTime 大于0表明不是今天
	if( overTime > 0)then
		return false
	else
		return true
	end
end


---------数据请求
function sendMsgReq( callback )
	local args = Network.argsHandler(curMsgId, "0" ,msgText)
	RequestCenter.mail_sendMail(callback,args)
end

function removeFdsReq( callback )
	isDelFds = true
	local args = Network.argsHandler(curMsgId)
	RequestCenter.friend_delFriend(callback,args)
end

function loveFriends( callback )
	local args = Network.argsHandler(curMsgId)
	RequestCenter.friend_loveFriend(callback,args)
end
-- FileName: AdventureModel.lua
-- Author: liweidong
-- Date: 2015-04-02
-- Purpose: 奇遇主model
--[[TODO List]]

module("AdventureModel", package.seeall)
require "script/module/adventure/AdBattleEventCtrl"
require "script/module/adventure/AdvMysticBoxCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["AdventureModel"] = nil
end

function moduleName()
    return "AdventureModel"
end
function create()
	
end
--id 某个事件id 不是db中的事件id，是由服务器返回的id ，返回剩余秒数、时间字符串(如：01:00:15)
function getRemainTimeSec(id)
	local item=getEventItemById(id)
	require "db/DB_Exploration_things"
	local eventDb=DB_Exploration_things.getDataById(item.etid)
	-- require "script/utils/TimeUtil"
	-- local curServerTime = TimeUtil:getSvrTimeByOffset()
	-- local remainTime = item.time+eventDb.time-curServerTime
	-- if remainTime<0 then
	-- 	remainTime=0
	-- end
	-- return remainTime,string.format("%.2d:%.2d:%.2d", remainTime/(60*60), remainTime/60%60, remainTime%60)
	require "script/utils/TimeUtil"
	local timeStr,isFinish,remainTime=TimeUtil.expireTimeString(tonumber(item.time),tonumber(eventDb.time))
	if (isFinish) then
		remainTime=0
	end
	return remainTime,timeStr
end
--获取datacach奇遇事件数据
function getAdventureDataFromDataCache()
	if (DataCache.getExploreInfo().va_explore.event==nil) then
		DataCache.getExploreInfo().va_explore.event={}
	end
	return DataCache.getExploreInfo().va_explore.event
end
--获取当前所有奇遇事件数据 并排序
function getAdventureData()
	require "script/module/adventure/AdvSingleBoxCtrl"
	require "script/module/adventure/AdvQuestionCtrl"
	require "script/module/adventure/AdvMysticBoxCtrl"
	local data=getAdventureDataFromDataCache() --DataCache.getExploreInfo().va_explore.event
	--临时数据 local data=DataCache.getAdventureData()
	local listData1={}  --单个宝箱
	local listData2 = {} --答题
	local listData3 = {} --三个宝箱
	local listData={}
	for key,val in pairs(data) do
		if (val~=nil) then
			local eventDb=DB_Exploration_things.getDataById(val.etid)
			if (tonumber(eventDb.thingType)==11 and AdvSingleBoxCtrl.isOpenBox(val.index)) then
				table.insert(listData1,val)
			elseif (tonumber(eventDb.thingType)==9 and AdvQuestionCtrl.isHaveAnswered(val.index)) then
				table.insert(listData2,val)
			elseif (tonumber(eventDb.thingType)==10 and AdvMysticBoxCtrl.isOpenBox(val.index)) then
				table.insert(listData3,val)
			else
				table.insert(listData,val)
			end
		end
	end
	table.sort(listData,function(a,b)
			return (tonumber(a.time)>tonumber(b.time)) --最晚的在前面
		end
		)
	table.sort(listData1,function(a,b)
			return (tonumber(a.time)>tonumber(b.time)) --最晚的在前面
		end
		)
	table.sort(listData2,function(a,b)
			return (tonumber(a.time)>tonumber(b.time)) --最晚的在前面
		end
		)
	table.sort(listData3,function(a,b)
			return (tonumber(a.time)>tonumber(b.time)) --最晚的在前面
		end
		)
	--合并
	for i,val in ipairs(listData2) do
		listData1[#listData1+1]=listData2[i]
	end
	for i,val in ipairs(listData3) do
		listData1[#listData1+1]=listData3[i]
	end
	for i,val in ipairs(listData) do
		listData1[#listData1+1]=listData[i]
	end
	return listData1
end
--返回当前奇遇事件个数
function getAdventureEventNum()
	local data=getAdventureDataFromDataCache() --DataCache.getExploreInfo().va_explore.event
	--临时数据 local data=DataCache.getAdventureData()
	return table.count(data)
end


local function commanRedStatus(evtid)
	return true
end
local showRedTipFunction = {
	[4]=AdBattleEventCtrl.isShowRedTip,  --继承血量战斗 遭遇海王类
	[5]=AdBattleEventCtrl.isShowRedTip, --非继承血量战斗
	[6]=commanRedStatus, --神秘熊猫人
	[7]=commanRedStatus,  --伙伴招募 -慕名而来
	[8]=commanRedStatus, --好友 -声明远播
	[9]=commanRedStatus,  --答题事件
	[10]=AdvMysticBoxCtrl.isOpenBox,  --神秘宝箱事件 三个宝箱
	[11]=commanRedStatus  --奇遇宝箱 一个宝箱
}
--返回当前奇遇事件红点个数
function getAdventureRedNum()
	local data=getAdventureDataFromDataCache() --DataCache.getExploreInfo().va_explore.event
	local num = 0
	for _,eventInfo in pairs(data) do
		require "db/DB_Exploration_things"
		local eventDb=DB_Exploration_things.getDataById(eventInfo.etid)
		local redFunc=showRedTipFunction[tonumber(eventDb.thingType)]
		if (redFunc(eventInfo.index)) then
			num = num+1
		end
	end
	return num
end

--刷新奇遇事件：有些事件已经到期，每次进入奇遇主界面时需要删除，各个事件模块如果需要删除，请自己请单独处理，勿调用
function refreshAdventureData()
	local data=getAdventureDataFromDataCache() --DataCache.getExploreInfo().va_explore.event
	--临时数据 local data=DataCache.getAdventureData()
	for key,val in pairs(data) do
		local remainTime,_ = getRemainTimeSec(val.index)
		if (val.complete==true or remainTime<=0) then --false时间到，临时去掉条件
			data[key]=nil
		end
	end
end
--增加一个奇遇事件
function addAdventureData(retExplore)
	local data=getAdventureDataFromDataCache() --DataCache.getExploreInfo().va_explore.event
	--临时数据local data=DataCache.getAdventureData()
	if (retExplore.info and retExplore.info.index) then
		data[tostring(retExplore.info.index)]=retExplore.info
		refreshAdventureData()
	end
end
--完成一个奇遇事件 设置complete标识为true
function setEventCompleted(id)
	local event = getEventItemById(id)
	event.complete=true
end
-- --设置一个奇遇事件红点状态完成
-- function setEventRedCompleted(id)
-- 	local event = getEventItemById(id)
-- 	event.completeRed=true
-- end
-- --设置一个奇遇事件红点状态未完成
-- function setEventRedNotCompleted(id)
-- 	local event = getEventItemById(id)
-- 	event.completeRed=false
-- end
--更据id从datacache中获得一条事件数据
function getEventItemById(id)
	local data=getAdventureDataFromDataCache() --DataCache.getExploreInfo().va_explore.event
	--临时数据local data=DataCache.getAdventureData()
	local itemData=nil
	for key,v in pairs(data) do
		if (tonumber(id) == tonumber(v.index)) then
			itemData = v
			break
		end
	end
	--之前临时数据用的是eventid，正式数据用etid。如果多人改起来麻烦，以可增加原表
	-- local mt = {}
	-- mt.__index = function (table, key)
	-- 	if (key=="eventid") then
	-- 		return table["etid"]
	-- 	else
	-- 		return table[key]
	-- 	end
	-- end
	-- if getmetatable(itemData) ~= nil then
	-- 	return itemData
	-- end
	-- setmetatable(itemData, mt)
	return itemData
end
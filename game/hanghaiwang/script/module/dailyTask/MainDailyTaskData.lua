-- FileName: MainDailyTaskData.lua
-- Author: lizy
-- Date: 2014-11-11
-- Purpose: function description of module
--[[TODO List]]

module("MainDailyTaskData", package.seeall)
require "db/DB_Daytask"
require "db/DB_Daytask_reward"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local _dailyTaskInfo   	= nil   -- 每日任务信息
local _dt_lv = 1
local _dtr_lv = 1

local function init(...)

end

-------------------------------------- 每日任务-------------------------------------
-- 获取每日任务的进度信息  add by  lizy  2014.11.11 
function getDailyTaskInfo( ... )
	
	return _dailyTaskInfo
end
-- 设置每日任务的进度信息 
function setDailyTaskInfo( dailyTaskInfo )
	_dailyTaskInfo = dailyTaskInfo
	logger:debug("每日任务")
	logger:debug(_dailyTaskInfo)


	_dt_lv = 1
	_dtr_lv = 1
	if(_dailyTaskInfo and _dailyTaskInfo.va_active) then
		local userShowLv = tonumber(_dailyTaskInfo.va_active.level) or 1

		local pCount = table.count(DB_Daytask.Daytask)
		for i=1,pCount do
			local ptb = DB_Daytask.getDataById(i)
			local pnum = tonumber(ptb.needLv) or 1
			if(pnum <= userShowLv and pnum > _dt_lv) then
				_dt_lv = pnum
			end
		end



		local pCount = table.count(DB_Daytask_reward.Daytask_reward)
		for i=1,pCount do
			local ptb = DB_Daytask_reward.getDataById(i)
			local pnum = tonumber(ptb.needLv) or 1
			if(pnum <= userShowLv and pnum > _dtr_lv) then
				_dtr_lv = pnum
			end
		end

		logger:debug({_dt_lv=_dt_lv})
		logger:debug({_dtr_lv=_dtr_lv})
		
	end
end


function destroy(...)
	package.loaded["MainDailyTaskData"] = nil
end

function moduleName()
    return "MainDailyTaskData"
end

function create(...)

end

function getHaveTaskOver( ... )
	
end

function setTaskOver( ... )

end

-- 排序table
local function sortAllTask( a , b )
	if a.level > b.level then
	   return true  
	elseif a.level == b.level then
		return a.sortId < b.sortId

	end

end
 
function getAwardInfo( taskId )
	-- logger:debug("getAwardInfo: taskId = " .. taskId)
	local tbTask = DB_Daytask.getDataById(taskId)

	local rewardData = {}
	table.hcopy(tbTask, rewardData) -- zhangqi, 2015-04-27, 外部使用要求包含配置信息，先做个配置信息的copy

	local _, _, num = string.match(tbTask.reward, "(.*)|(.*)|(.*)")
	local rewardInfo = RewardUtil.parseRewards(tbTask.reward)
	-- logger:debug({getAwardInfo = rewardInfo})
	rewardData.rewardName = rewardInfo[1].name -- parseRewards 返回的是array，但这里只配置一个所以用[1]访问
	rewardData.num = num

	return rewardData
end
-- 根据等级获取所有任务 
function getAllTasks( tbTaskInfo )

	local tbAllTasks 		= {}
	local index 			= table.count(DB_Daytask.Daytask)
	local tbTask 			= DB_Daytask.getDataById(index)
	local reward 
	local tasks  			= tbTaskInfo.va_active.task
    local taskPrize  		= tbTaskInfo.va_active.task_prize
	 
	for i=1,index do
		local tbTask 		= DB_Daytask.getDataById(i)
		tbTask.level 		=  2   -- 前往状态 优先级 3 

		if tasks then
			if tasks[tbTask.id .. ""] then
			 	if tonumber(tasks[tbTask.id .. ""]) >= tonumber(tbTask.needNum) then
			 		tbTask.level = 3   -- 可以领取状态了 优先级 2 
			 	end
		 	end
		end
		if taskPrize then
			for j=1,#taskPrize do 
        		if tonumber(tbTask.id) == tonumber(taskPrize[j]) then
        			tbTask.level = 1   -- 领取完成状态 优先级 1
        			
        		end
        	end
		end
		local pLV = tonumber(tbTask.needLv) or 0
		if(pLV == _dt_lv) then
			table.insert(tbAllTasks,tbTask) 
		end
	end

	-- repeat
	-- 	  reward 		= tbTask.reward
	-- 	  local array 	= string.split(reward,"|")  
	-- 	  -- for i=1,#array do
		  	  
	-- 	  -- end
	-- 	  table.insert(tbAllTasks,tbTask) 
	-- 	  index 		= index + 1
	-- 	  tbTask 		= DB_Daytask.getDataById(index)
	-- until tbTask == nil 
	table.sort(tbAllTasks,sortAllTask)
	-- for q=1,#tbAllTasks do
	-- 	logger:debug(tbAllTasks[q])
	-- end
	return  tbAllTasks
end


function addRewardToUser( rewardInfoArray )
	if tonumber(rewardInfoArray[1]) == 6 or tonumber(rewardInfoArray[1]) == 7 then
		
	else
		if (tonumber(rewardInfoArray[1])  == 1) then 
			UserModel.addSilverNumber(tonumber(rewardInfoArray[3]))
		elseif(tonumber(rewardInfoArray[1]) == 3) then 
			UserModel.addGoldNumber(tonumber(rewardInfoArray[3]))
		end
	end
end

function addPrizeToUser( nRedwardId )

	local tbItem = {} 
	local redwardInfo = getDB_rewardInfo(nRedwardId)
	local rewardArray  = string.split(redwardInfo.reward, ",")	
	for i=1,#rewardArray  do
		local rewardInfoArray = string.split(rewardArray[i], "|")	
		addRewardToUser(rewardInfoArray)
		-- if tonumber(rewardInfoArray[1]) == 6 or tonumber(rewardInfoArray[1]) == 7 then
		
		-- else
		-- 	if (tonumber(rewardInfoArray[1])  == 1) then 
		-- 		UserModel.addSilverNumber(tonumber(rewardInfoArray[3]))
		-- 	-- elseif(tonumber(rewardInfoArray[1])  == 2) then -- zhangqi, 2015-01-10, 去经验石
		-- 	-- 	UserModel.addSoulNum(tonumber(rewardInfoArray[3]))
		-- 	elseif(tonumber(rewardInfoArray[1]) == 3) then 
		-- 		UserModel.addGoldNumber(tonumber(rewardInfoArray[3]))
		-- 	end
		-- --	tb.icon = UIHelper.getItemIcon(rewardInfoArray[1], rewardInfoArray[3])
			 
		-- end
	end
	  
end

function getRewardInfoById( nRedwardId )
	local tbItem = {} 
	local redwardInfo = getDB_rewardInfo(nRedwardId)

	local rewardArray  = string.split(redwardInfo.reward, ",")	
	for i=1,#rewardArray  do
		local rewardInfoArray = string.split(rewardArray[i], "|")	
		local tb = {}
		local goodInfo

		logger:debug(" rewardInfoArray[1]=" .. rewardInfoArray[1])

		if tonumber(rewardInfoArray[1]) == 6 or tonumber(rewardInfoArray[1]) == 7 then
			tb.icon = UIHelper.getItemIcon(rewardInfoArray[1], rewardInfoArray[2].."|"..rewardInfoArray[3])
			goodInfo =  ItemUtil.getItemById(rewardInfoArray[2])
			tb.quality = goodInfo.quality
		 	tb.name = goodInfo.name
		else
			 
			tb.icon = UIHelper.getItemIcon(rewardInfoArray[1], rewardInfoArray[3])
			tb.name,tb.quality = getNameByType(rewardInfoArray[1])
		end
		 

		table.insert(tbItem, tb)
	end
	 return  tbItem
end
function getNameByType( nType )
	if tonumber(nType) == 1 then
	 	 return m_i18n[1520] ,2
	elseif tonumber(nType) == 2 then
	 	 return m_i18n[1087],4 --  "经验石"
	elseif tonumber(nType) == 3 then
	 	 return m_i18n[2220] ,5	 
	elseif tonumber(nType) == 4 then
	 	 return m_i18n[1922], 5
	end 
end

-- 任务达成推送
function setOver( _dates )
	local pID = tostring(_dates) or nil
	if(not pID) then
		return
	end
	if _dailyTaskInfo then
		if(not _dailyTaskInfo.va_active) then
			_dailyTaskInfo.va_active = {}
		end
		local tasks = _dailyTaskInfo.va_active.task
		if(not tasks) then
			_dailyTaskInfo.va_active.task = {}
			tasks = _dailyTaskInfo.va_active.task
		end
		if(not tasks[pID]) then
			_dailyTaskInfo.va_active.task[pID] = 0
		end
		local pdb = DB_Daytask.getDataById(pID)
		if(not pdb or not pdb.needNum) then
			return
		end
		_dailyTaskInfo.va_active.task[pID] = pdb.needNum
	end
end

-- 三个宝箱的开启所需积分 ，对应 DB_Daily_reward 表。
function getBaseValue( ... )
	return {25,60,100} 
end

function getDB_rewardInfo( id )
	local pID = tonumber(id) or 1
	if(pID < 1) then
		pID = 1
	elseif(pID > 3) then
		pID = 3
	end
	local basevalue = getBaseValue() 
	local pNum = basevalue[pID] or 0
	
	local ptable = DB_Daytask_reward.getArrDataByField("needLv", _dtr_lv)
	for i,v in ipairs(ptable) do
		local pScore = tonumber(v.needScore) or 0
		if(pScore == pNum) then
			return v
		end
	end
	return nil
end

function getRewardAbleNum(  )
	local tbTaskInfo 		      = _dailyTaskInfo
	local num                 	  = 0
	
	 
	if tbTaskInfo then
		local tasks  			  = tbTaskInfo.va_active.task   --当前完成的次数
	    local taskPrize  		  = tbTaskInfo.va_active.task_prize  --已经领过奖的任务id
	    local tbAllTasks          = getAllTasks(tbTaskInfo)
	    local prizeArray          = tbTaskInfo.va_active.prize
	    for i=1,#tbAllTasks do
	    	local nId 			  = tbAllTasks[i].id..""
		    if tasks then  -- 判断 是否可以前往
		    	 
	            if tasks[nId] then
	               
	               if tonumber(tasks[nId]) >= tonumber(tbAllTasks[i].needNum) then
	              		num = num +1 
	               end 
	            end
		        
		    end
		       
	        if taskPrize then -- 判断是否已经领取奖励
	        	for j=1,#taskPrize do
	        		 
	        		if tonumber(tbAllTasks[i].id) == tonumber(taskPrize[j]) then
	        			num = num -1 
	        		
	        		end
	        	end
	        end
	    end 
	    

	    for i=1,3 do
	    	local redwardInfo = getDB_rewardInfo(i)
	    	if tonumber(redwardInfo.needScore)<= tonumber(tbTaskInfo.point) then

	        	local flag = 0
	        	if prizeArray then
	        		
		    		for j=1,#prizeArray do
		    			if tonumber(prizeArray[j]) == tonumber(redwardInfo.id) then
		    				flag = 1
		    			end
		    		end
		    	end 
	    		if tonumber(flag) == 0 then
	    			num = num+1
	    		end
	    	end 
    	end   
	end
	 
	return num
end



function getRewrdItems( rewardDataStr )
	local tbReward = RewardUtil.getItemsDataByStr(rewardDataStr)
	logger:debug(tbReward)
	local tbRewardItem = {}
	for _, reward in ipairs(tbReward) do
		logger:debug(reward)
		if reward.type == "item" then
			table.insert(tbRewardItem, reward.tid)
		end
	end
	return tbRewardItem
end

-- 根据奖励判定背包是否已满 true:已满 
function judgeBagIsFull( tbreward )
	local rewardTids = getRewrdItems(tbreward)
	if(not table.isEmpty(rewardTids) and ItemUtil.bagIsFullWithTids(rewardTids,true)) then
		return  true
	end

	return false
end

-- FileName: ExplorData.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 探索模块数据model
--[[TODO List]]
require "db/DB_Switch"

module("ExplorData", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local copyID = 1  --当前探索副本id
local exploration --探索表数据 
local exploreTimeInfo 	
local timeFormat  = "%H:%M:%S"
local ITEM_CONFIG_ID = 20
local explore_time 
require "db/DB_Exploration"
require "db/DB_Vip"
require "script/utils/TimeUtil"
local function init(...)

end

function destroy(...)
	package.loaded["ExplorData"] = nil
end

function moduleName()
    return "ExplorData"
end

function create(...)

end
--设置当前副本id
function initExplore(id)
	copyID=id
end
--当前探索是否可显示红点 返回 1：是否可显示红点 2：显示可探索次数
function getRedStatus()
	if (not SwitchModel.getSwitchOpenState(ksSwitchExplore,false)) then
		return false,0
	end
	--local exploreNum=ItemUtil.getCacheItemNumBy(60019)
	local stamina = UserModel.getStaminaNumber()
	stamina=math.modf(stamina/getNeedStaminaNumber())
	exploreNum= stamina -- 修改不计算道具的数量 exploreNum+stamina
	local status=false
	if stamina>=4 then --exploreNum >=5 then
		status=true
	end
	return status,exploreNum
end
--返回当前可探索次数
function getCanExploreTimes()
	if (not SwitchModel.getSwitchOpenState(ksSwitchExplore,false)) then
		return 0
	end
	local exploreNum=ItemUtil.getCacheItemNumBy(60019)
	local stamina = UserModel.getStaminaNumber()
	stamina=math.modf(stamina/getNeedStaminaNumber())
	exploreNum=exploreNum+stamina
	return exploreNum
end
--获取当前副本探索进度,和可领奖次数
--return 当前进度，进度上线，第几次奖励（随机奖励为0），奖励数据（随机奖励返回nil）
function getExploreProgress()
	logger:debug("explor data")
	logger:debug(DataCache.getExploreInfo())
	
	if (DataCache.getExploreInfo() == nil ) then
		getExploreInfoFromServer()
		return 0,0,0,nil
	end


	if (DataCache.getExploreInfo().va_explore==nil) then
		DataCache.getExploreInfo().va_explore={}
	end
	if (DataCache.getExploreInfo().va_explore.copy==nil) then
		DataCache.getExploreInfo().va_explore.copy={}
	end
	if (DataCache.getExploreInfo().va_explore.award==nil) then
		DataCache.getExploreInfo().va_explore.award=0
	end
	local data=DataCache.getExploreInfo().va_explore.copy["-1"]
	if (data==nil) then
		-- DataCache.getExploreInfo().va_explore.copy["-1"]={[1]=0,[2]=0}
		data={[1]=0,[2]=0} --DataCache.getExploreInfo().va_explore.copy["-1"]
		--后端数据结构修改 [-1]数据不存在，为了减少前端修改量，生成之前的【-1】数据["-1"]={[1]=0,[2]=0} 其中1是探索总次数，2是是否可领取奖励
		local explors=DataCache.getExploreInfo().va_explore.copy
		logger:debug("explor data")
		logger:debug(DataCache.getExploreInfo())
		for _,val in pairs(explors) do
			data[1] = data[1]+val[1]
		end
		if (tonumber(DataCache.getExploreInfo().va_explore.award)<data[1] or tonumber(DataCache.getExploreInfo().va_explore.award)==0) then
			data[2]=1
		end
		DataCache.getExploreInfo().va_explore.copy["-1"]=data
		logger:debug(DataCache.getExploreInfo())
	end
	if (data[1]==nil) then
		data[1]=0
	end
	if (data[2]==nil) then
		data[2]=0
	end


	local pross = tonumber(data[1]) 
	require "db/DB_Normal_config"
	local progressArr = lua_string_split(DB_Normal_config.getDataById(1).explore_sure_reward, ",")
	local rewardTimes = 0 --默认第随机奖励次  第0次奖励为随机奖励
	local maxNum = tonumber(DB_Normal_config.getDataById(1).explore_rank_reward) --默认上线为随机奖励上线
	local minNum = 0 --当前进度
	local rewardInfo = nil --奖励内容，如果是随机奖励返回nil

	for i,val in pairs(progressArr) do
		local infoArr = lua_string_split(val, "|")
		local tmpMax = tonumber(infoArr[1])
		if (pross<tmpMax) then
			rewardTimes=i
			maxNum=tmpMax
			rewardInfo = infoArr
			minNum=pross
			break
		elseif (pross==tmpMax) then
			if (tonumber(data[2])==1) then
				rewardTimes=i
				maxNum=tmpMax
				rewardInfo = infoArr
				minNum=pross
				break
			end
		end
		pross=pross-tmpMax
	end
	if (rewardTimes==0) then
		minNum = pross%maxNum
		if (tonumber(data[2])==1 and pross>0 and minNum==0) then
			minNum=maxNum
		end
	end

	return minNum,maxNum,rewardTimes,rewardInfo
end
--增加当前探索进度
function addExploreProgress()
	local data=DataCache.getExploreInfo().va_explore.copy["-1"]
	-- if tonumber(data[2])==0 then
		local min,max,times = getExploreProgress() --必须放在增加进度之前获取，原因：当前可领取为0，但加1之后可领取，没有设置成1，调用时会返回下一进度，从0开始
		data[1]=data[1]+1
		if (min+1==max) then
			data[2]=1
		end
	-- end
end
--重置探索奖励
function resetExploreProgressReward()
	local data=DataCache.getExploreInfo().va_explore.copy["-1"]
	data[2]=0
end
--获取当前副本完成进度
-- function getExploreFinishProgress()
-- 	return DB_Copy.getDataById(copyID).finish_num
-- end


--当开始探索时从服务器拉数据，因为登陆时没有开启，需要在升级中手动拉取
function getExploreInfoFromServer()
	local function getExploreInfoCallBack( cbFlag, dictData, bRet ) 
 		 DataCache.setExploreInfo( dictData.ret)
 	end
	
	if  (DataCache.getExploreInfo() == nil ) then
		RequestCenter.explorInfo(getExploreInfoCallBack)
	end
end

--获取探索一次需要的耐力
function getNeedStaminaNumber()
	require "db/DB_Normal_config"
	return tonumber(DB_Normal_config.getDataById(1).explore_cost)
end
--探索消耗耐力或消耗探索指针 type = 1减少耐力 2减少道具
function subStaminaByExplore(type)
	if (tonumber(type)==1) then
		local stamina = UserModel.getStaminaNumber()
		if (stamina>=getNeedStaminaNumber()) then
			UserModel.addStaminaNumber(-getNeedStaminaNumber())
		end
	end

	-- if (ItemUtil.getCacheItemNumBy(60019)<=0) then
	-- 	UserModel.addStaminaNumber(-getNeedStaminaNumber())
	-- end
end
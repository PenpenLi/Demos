-- FileName: copyAwakeModel.lua
-- Author: liweidong
-- Date: 2015-11-16
-- Purpose: 觉醒副本model
--[[TODO List]]

module("copyAwakeModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _awakeCopyWordId = 40000 --觉醒副本地图
local _enterenceData = {} --地图入口数据
local gi18n = gi18n
local isOpenNewCopy = false

local function init(...)

end

function destroy(...)
	package.loaded["copyAwakeModel"] = nil
end

function moduleName()
    return "copyAwakeModel"
end

function create(...)

end
--获取副本datachach数据
function getCopyData()
	local data = DataCache.getAwakeCopyData()
	--logger:debug({awakeData=data})
	return data.copy_list
end
--战斗结束后增加副本数据
function addCopyData(data)
	--logger:debug("addCopyData=======")
	--logger:debug({addCopyData=data})
	local oldData = getCopyData()
	local oldNum = table.count(oldData)
	for k,v in pairs(data.awakecopy) do
		oldData[k] = v
	end
	--logger:debug("old_copyData ====== ")
	--logger:debug({oldData=oldData})
	local newNum = table.count(oldData)
	if (newNum>oldNum) then
		isOpenNewCopy = true
	else
		isOpenNewCopy = false
	end
	-- copyAwakeBaseView.updateUI()
end
--返回当前是否有新副本开启
function isOpenNewCopyStaus()
	return isOpenNewCopy
end
--返回所有地图入口数组
function getAllMapEnterences()
	local db = DB_World.getDataById(_awakeCopyWordId)
	local enterenceArr = lua_string_split(db.disillusion_id,"|")
	return enterenceArr
end
--根据id返回前一个副本的id
function getBeforCopyId(id)
	local serData = getCopyData()
	id = tostring(id)
	local ids = getAllMapEnterences()
	local beforId = 0
	for _,v in ipairs(ids) do
		if (v==id) then
			break
		end
		beforId = v
	end
	return beforId
end
--返回一个副本不能进入的原因
function getCanNotEnterCopyReason(id)
	local serData = getCopyData()
	id = tostring(id)
	local copyDb = DB_Disillusion_copy.getDataById(id)
	--logger:debug("copy pass " .. id)
	if (copyDb.need_player_lv>UserModel.getHeroLevel()) then
		return string.format(gi18n[7422],copyDb.need_player_lv) --TODO
	end
	if (not MainCopy.fnCrossCopy(copyDb.need_pass_ncopy)) then
		local norCopyDb = DB_Copy.getDataById(copyDb.need_pass_ncopy)
		return string.format("需通关普通副本%s",norCopyDb.name) --TODO
	end
	local beforId = getBeforCopyId(id)
	local beforCopyDb = DB_Disillusion_copy.getDataById(beforId)
	return string.format("需通关觉醒副本%s",beforCopyDb.name) --TODO
end
--判断一个副本是否通关
function copyIsPassedById(id)
	local serData = getCopyData()
	id = tostring(id)
	if (serData[id]==nil) then
		return false
	end
	if (serData[id].va_copy_info==nil) then
		return false
	end
	if (serData[id].va_copy_info.baselv_info==nil) then
		return false
	end
	--普通副本没通关
	local copyDb = DB_Disillusion_copy.getDataById(id)
	--logger:debug("copy pass " .. id)
	if (copyDb.need_player_lv>UserModel.getHeroLevel()) then
		return false
	end
	if (not MainCopy.fnCrossCopy(copyDb.need_pass_ncopy)) then
		return false
	end
	if (serData[tostring(id+1)]) then
		return true
	end
	local baseArr = lua_string_split(copyDb.bases,"|")
	local baseInfo = serData[id].va_copy_info.baselv_info[baseArr[#baseArr]]
	if (baseInfo==nil) then
		return false
	end
	if (tonumber(baseInfo["1"].status)<3) then
		return false
	end
	return true
end
--返回当前入口副本id
function getCurEnterenceId()
	local serData = getCopyData()
	local enterenceArr = getAllMapEnterences()
	local curId=0 --enterenceArr[1]
	for i=#enterenceArr,1,-1 do  --之前是循环到2
		local id = enterenceArr[i]
		if (serData[id]~=nil) then
			--普通副本有没有通关
			local copyDb = DB_Disillusion_copy.getDataById(id)
			if (copyDb.need_player_lv<=UserModel.getHeroLevel() and MainCopy.fnCrossCopy(copyDb.need_pass_ncopy)) then
				curId = id
				break
			end
		else
			local copyDb = DB_Disillusion_copy.getDataById(id)
			if (copyDb.need_player_lv<=UserModel.getHeroLevel() and MainCopy.fnCrossCopy(copyDb.need_pass_ncopy)) then
				if (i-1>=1) then
					if (copyIsPassedById(tonumber(enterenceArr[i-1]))) then
						curId = id
						break
					end
				elseif (i==1) then
					curId = id
					break
				end
			end
		end
	end
	--logger:debug("cur copy id " .. curId)
	return tonumber(curId)
end
--返回当前地图中可显示的入口信息 fresh 是否刷新
function getMapEnterenceInfo(fresh)
	local serData = getCopyData()
	if (not fresh) then
		return _enterenceData
	end
	_enterenceData = {}
	local enterenceArr = getAllMapEnterences()
	local curId=getCurEnterenceId()
	for _,id in ipairs(enterenceArr) do
		if (tonumber(id)<=curId+1) then
			local item ={}
			item.id=tonumber(id)
			item.db=DB_Disillusion_copy.getDataById(id)
			if (tonumber(id)<=curId) then
				item.clickStatus=1
			else
				item.clickStatus=0
			end
			if (tonumber(id)==curId) then
				item.curEntrance=true
			end
			table.insert(_enterenceData,item)
		else
			break
		end
	end
	return _enterenceData
end

--返回一个副本是否有可领取的宝箱
function getRewardStatusById(id)
	local serData = getCopyData()
	id = tostring(id)
	local status=false
	if (serData[id]==nil) then
		return false
	end
	if (serData[id].va_copy_info==nil) then
		return false
	end
	if (serData[id].va_copy_info.box_info==nil) then
		serData[id].va_copy_info.box_info = {}
	end
	if (serData[id].va_copy_info.box_info["1"]==nil) then
		serData[id].va_copy_info.box_info["1"] = {}
	end
	if (serData[id].va_copy_info.box_info["1"].star_box==nil) then
		serData[id].va_copy_info.box_info["1"].star_box = {}
	end
	local bt2={0,0,0}
	if (serData[id].va_copy_info and serData[id].va_copy_info.box_info and serData[id].va_copy_info.box_info["1"] and serData[id].va_copy_info.box_info["1"].star_box) then
		for i=1,3 do
			if (serData[id].va_copy_info.box_info["1"].star_box[tostring(i)]) then
				bt2[i]=tonumber(serData[id].va_copy_info.box_info["1"].star_box[tostring(i)])
			end
		end
	end
	local copyDbinfo = DB_Disillusion_copy.getDataById(id)
	local getScore = getCopyStarById(id)
	if(copyDbinfo and copyDbinfo.starlevel) then
		local startLv = lua_string_split(copyDbinfo.starlevel,",")
		for k,v in ipairs(startLv) do
			if (k<= #bt2 ) then
				if (getScore >= tonumber(v)) and (bt2[k] ~= 1) then
					return true  --可以领
				end
			end
		end
	end
	return false
end
--返回一个副本所有宝箱的状态｛0，0，0｝ 0不可领取 1可领取 2已领取
function getCopyRewardStatusById(id)
	local serData = getCopyData()
	id = tostring(id)
	local status = {0,0,0}
	if (serData[id]==nil) then
		return status
	end
	if (serData[id].va_copy_info==nil) then
		return status
	end
	if (serData[id].va_copy_info.box_info==nil) then
		serData[id].va_copy_info.box_info = {}
	end
	if (serData[id].va_copy_info.box_info["1"]==nil) then
		serData[id].va_copy_info.box_info["1"] = {}
	end
	if (serData[id].va_copy_info.box_info["1"].star_box==nil) then
		serData[id].va_copy_info.box_info["1"].star_box = {}
	end
	local bt2={0,0,0}
	if (serData[id].va_copy_info and serData[id].va_copy_info.box_info and serData[id].va_copy_info.box_info["1"] and serData[id].va_copy_info.box_info["1"].star_box) then
		for i=1,3 do
			if (serData[id].va_copy_info.box_info["1"].star_box[tostring(i)]) then
				bt2[i]=tonumber(serData[id].va_copy_info.box_info["1"].star_box[tostring(i)])
			end
		end
	end
	local copyDbinfo = DB_Disillusion_copy.getDataById(id)
	local getScore = getCopyStarById(id)
	if(copyDbinfo and copyDbinfo.starlevel) then
		local startLv = lua_string_split(copyDbinfo.starlevel,",")
		for k,v in ipairs(startLv) do
			if (k<= #bt2 ) then
				if (getScore >= tonumber(v)) then
					if (bt2[k] ~= 1) then
						status[k] = 1
					else
						status[k] = 2
					end
				end
			end
		end
	end
	return status
end
--设置宝箱状态
function setCopyRewardStatusById(id,boxId)
	local serData = getCopyData()
	id = tostring(id)
	boxId = tostring(boxId)
	local status = {0,0,0}
	if (serData[id]==nil) then
		return
	end
	if (serData[id].va_copy_info==nil) then
		return
	end
	if (serData[id].va_copy_info.box_info==nil) then
		serData[id].va_copy_info.box_info = {}
	end
	if (serData[id].va_copy_info.box_info["1"]==nil) then
		serData[id].va_copy_info.box_info["1"]={}
	end
	if (serData[id].va_copy_info.box_info["1"].star_box==nil) then
		serData[id].va_copy_info.box_info["1"].star_box={}
	end
	serData[id].va_copy_info.box_info["1"].star_box[boxId]=1
end
--返回一个副本的得星情况
function getCopyStarById(id)
	local serData = getCopyData()
	id = tostring(id)
	local copyDbinfo = DB_Disillusion_copy.getDataById(id)
	local getScore = 0
	if (serData[id] and serData[id].score) then
		getScore = tonumber(serData[id].score)
	end
	return getScore,copyDbinfo.all_stars
end
--返回一个据点是副本的第几个据点，idx
function getStrongHoldInx(id,holdId)
	local copyDb = DB_Disillusion_copy.getDataById(id)
	local baseArr = lua_string_split(copyDb.bases,"|")
	for k,v in ipairs(baseArr) do
		if (tonumber(v)==tonumber(holdId)) then
			return k
		end
	end
	return 0
end
--返回据点进度信息 -1 不可攻打 0 当前据点，1 攻打完成
function getStrongHoldStatus(id,holdId)
	local serData = getCopyData()
	--logger:debug("getStrongHoldStatus" .. id .. "  " .. holdId)
	id = tostring(id)
	holdId = tostring(holdId)
	local defaultStatus = -1
	local holdIdx = getStrongHoldInx(id,holdId)
	if (holdIdx==1) then
		defaultStatus = 0
	end
	if (serData[id]==nil) then
		return defaultStatus
	end
	if (serData[id].va_copy_info==nil) then
		return defaultStatus
	end
	if (serData[id].va_copy_info.baselv_info==nil) then
		return defaultStatus
	end
	if (serData[id].va_copy_info.baselv_info[holdId]==nil) then
		return defaultStatus
	end
	if (serData[id].va_copy_info.baselv_info[holdId]["1"]==nil) then
		return defaultStatus
	end
	local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
	if (baseInfo.status and tonumber(baseInfo.status)>=3) then
		return 1
	end
	return 0
end
--判断是否打过某一个据点
function isACopyChanlage(copyId,holdId)
	return getStrongHoldStatus(copyId,holdId)==1
end
--返回一个据点的得星数量
function getHoldStarNumber(id,holdId)
	local serData = getCopyData()
	--logger:debug("getStrongHoldStatus" .. id .. "  " .. holdId)
	id = tostring(id)
	holdId = tostring(holdId)
	if (serData[id]==nil) then
		return 0
	end
	if (serData[id].va_copy_info==nil) then
		return 0
	end
	if (serData[id].va_copy_info.baselv_info==nil) then
		return 0
	end
	if (serData[id].va_copy_info.baselv_info[holdId]==nil) then
		return 0
	end
	if (serData[id].va_copy_info.baselv_info[holdId]["1"]==nil) then
		return 0
	end
	local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
	if (baseInfo.score) then
		return tonumber(baseInfo.score)
	end
	return 0
end
--返回一个据点的攻打次数信息
function getHoldAttackInfo(id,holdId)
	local serData = getCopyData()
	id = tostring(id)
	holdId = tostring(holdId)
	local baseItemInfo = DB_Stronghold.getDataById(holdId)
	local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
	local maxNum = tonumber(fightTimes[1])
	if (serData[id]==nil) then
		return maxNum,maxNum
	end
	if (serData[id].va_copy_info==nil) then
		return maxNum,maxNum
	end
	if (serData[id].va_copy_info.baselv_info==nil) then
		return maxNum,maxNum
	end
	if (serData[id].va_copy_info.baselv_info[holdId]==nil) then
		return maxNum,maxNum
	end
	if (serData[id].va_copy_info.baselv_info[holdId]["1"]==nil) then
		return maxNum,maxNum
	end
	local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
	if (baseInfo.can_atk_num) then
		return tonumber(baseInfo.can_atk_num),maxNum
	else
		return maxNum,maxNum
	end
end
--减少一个据点的挑战次数
function subHoldAttackNum(copyId,holdId,times)
	local serData = getCopyData()
	local id = tostring(copyId)
	holdId = tostring(holdId)
	local remain = getHoldAttackInfo(copyId,holdId)
	remain = remain-times
	if (remain<=0) then
		remain =0
	end
	if (serData[id].va_copy_info and serData[id].va_copy_info.baselv_info and serData[id].va_copy_info.baselv_info[holdId] and serData[id].va_copy_info.baselv_info[holdId]["1"]) then
		local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
		baseInfo.can_atk_num = remain
	end
end
--重置一个据点的挑战次数
function resetHoldAttackNum(copyId,holdId)
	local serData = getCopyData()
	local id = tostring(copyId)
	holdId = tostring(holdId)
	local remain,allNum = getHoldAttackInfo(copyId,holdId)
	if (serData[id].va_copy_info and serData[id].va_copy_info.baselv_info and serData[id].va_copy_info.baselv_info[holdId] and serData[id].va_copy_info.baselv_info[holdId]["1"]) then
		local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
		baseInfo.can_atk_num = allNum
	end
end
--获取据点已经重置几次
function getHaveResetHoldTimes( copyId,holdId)
	local serData = getCopyData()
	local id = tostring(copyId)
	holdId = tostring(holdId)
	local resetNum = 0
	if (serData[id].va_copy_info and serData[id].va_copy_info.baselv_info and serData[id].va_copy_info.baselv_info[holdId] and serData[id].va_copy_info.baselv_info[holdId]["1"]) then
		local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
		if (baseInfo.reset_num) then
			resetNum = tonumber(baseInfo.reset_num)
		end
	end
	return resetNum
end
--增加据点已经重置几次
function addHaveResetHoldTimes( copyId,holdId)
	local serData = getCopyData()
	local id = tostring(copyId)
	holdId = tostring(holdId)
	local resetNum = getHaveResetHoldTimes(copyId,holdId)
	resetNum = resetNum+1
	if (serData[id].va_copy_info and serData[id].va_copy_info.baselv_info and serData[id].va_copy_info.baselv_info[holdId] and serData[id].va_copy_info.baselv_info[holdId]["1"]) then
		local baseInfo = serData[id].va_copy_info.baselv_info[holdId]["1"]
		-- if (baseInfo.reset_num) then
			baseInfo.reset_num = resetNum
		-- end
	end
end
--获取当前重置战斗次数花费的金币数量
function getResetHoldNeedGold( copyId,holdId)
	local serData = getCopyData()
	local id = tostring(copyId)
	holdId = tostring(holdId)
	local golds = 0
	require "db/DB_Normal_config"
	local dbNormalConfig = DB_Normal_config.getDataById(1)
	if (dbNormalConfig.resetDcopyBaseCost ~= nil) then
		local costGoldArr = lua_string_split(dbNormalConfig.resetDcopyBaseCost,"|")
		local resetNum = getHaveResetHoldTimes(copyId,holdId)
		--logger:debug("resetNum"..resetNum)
		golds = tonumber(costGoldArr[1])
		if(resetNum > 0) then
			local maxCostGold = tonumber(costGoldArr[3])
			local curCost = resetNum * tonumber(costGoldArr[2]) + golds
			if (curCost < maxCostGold) then
				golds = curCost
			else
				golds = maxCostGold
			end
		end
	end
	return golds
end
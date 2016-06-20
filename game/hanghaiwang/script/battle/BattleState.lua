
module ("BattleState",package.seeall)

local isPlayRecord = false
local isPlayBattleRecord = false
local callBackList = {}
local _hasNextBattle = false
local _bird = 0 -- 战报id

function setBrid( value )
	_bird = value
end


local apiType,battleType,strongHoldid,hardLevel,battleIndex
-- 设置战报数据(战报用)
function setBattleRecordInfo( apitype,battletype,strongholdid,hardlevel,battleindex)
	apiType = apitype
	battleType = battletype
	strongHoldid = strongholdid
	hardLevel = hardlevel
	battleIndex = battleindex

	print("== setBattleRecordInfo:",apiType,battleType,strongHoldid,hardLevel,battleIndex)

end
-- 设置stronghold战斗索引(战报用)
function setBattleIndex( value )
	battleIndex = value
end


function getRecordData( ... )
	-- 如果数据不合法 我们会将类型定义为单场战斗战报(这样就是需要战斗串正确就可以运行)
	if(apiType == nil or battleType == nil or strongHoldid == nil or hardLevel == nil) then
		apiType = BATTLE_CONST.BATTLE_API_TYPE_SINGLE
		battleType = BATTLE_CONST.BATTLE_TYPE_ARENA
	end

	if(battleIndex == nil) then
		battleIndex = ""
	end

	
	if(apiType == BATTLE_CONST.BATTLE_API_TYPE_SINGLE) then
		 return tostring(_bird) .. "|" .. tostring(apiType) .. "|" .. tostring(battleType)
	else
		 return tostring(_bird) .. "|" .. tostring(apiType) .. "|" .. tostring(battleType) .. "|" .. tostring(strongHoldid) .. "|" .. tostring(hardLevel) .. "|" .. tostring(battleIndex)
	end
end




function setPlaying( value )

	if(isPlayRecord == true and value == false) then
		-- 如果有回调 我们执行回调
		for k,callBack in pairs(callBackList) do
			if(type(callBack) == "function") then
				callBack()
			end
		end
		callBackList = {}
	end
	isPlayRecord = value

	-- if(value == false) then
	-- 	callBackList = {}
	-- end
	-- if()
end

-- 是否有下一场战斗(如果有,则断线从连需要从新调用enterbattle)
function hasNextBattle( )
	return _hasNextBattle
end


function setHasNextBattle( value )
	_hasNextBattle = value	
end

function isPlaying( ... )
	return isPlayRecord == true
end
--是否处于播放战斗录像状态
function isOnPlayRecord()
	return isPlayBattleRecord
end

function setPlayRecordState( value )
	isPlayBattleRecord = value or false
end
-- 战斗结束后会回调
function addCallBack( callBack )
	if(type(callBack) == "function") then
		table.insert(callBackList,callBack)
	else
		print("BattleState.addCallBack error",callBack)
	end
end

-- 获取当前战报id
function getBattleBrid()
	return _bird
end
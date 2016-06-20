module("db_vip_util",package.seeall)



--通过id来检索
function getItemByid( id )
	
	if(id == nil ) then

		--print("=============== getItemByid is nill======================")
		--print(debug.traceback())
		--print("===========================================================")
	 

	end 
	return DB_Vip.getDataById(tonumber(id))
end

-- 通过vip等级获取vip数据(等级>= 1)
function getItemByVIPLevel( level )
	if(level == nil or level < 1) then level = 1 end
	return getItemByid(level)
end



-- 是否可以调过普通副本
function canJumpNormalCopyBattle(copyPassed)

	if(copyPassed) then return true end
	
	local item = getItemByVIPLevel(UserModel.getVipLevel())

	if(item) then
		local jumpInfo = lua_string_split(item.normal_skip,"|")

		return (tonumber(jumpInfo[1]) >= 1)and 
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	end

	return false
end

-- 是否可以调过精英本
function canJumpEliteCopyBattle( ... )

	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item) then
		local jumpInfo = lua_string_split(item.elite_skip,"|")
		local uLevel   = UserModel.getHeroLevel()
		if(uLevel == nil or uLevel < 1) then
			return false
		end 
		return (tonumber(jumpInfo[1]) >= 1) or 
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	else

	end

	return false
end
-- 是否可以跳过活动副本战斗
function canJumpACopy( ... )
	
	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item and item.acopy_skip) then
		local jumpInfo = lua_string_split(item.acopy_skip,"|")
		Logger.debug("db_vip_util:" .. tostring(item.acopy_skip))
		local uLevel   = UserModel.getHeroLevel()
		
		if(uLevel == nil or uLevel < 1) then
			return false
		end 
		-- or BattleMainData.fightRecord.replayed
		return (tonumber(jumpInfo[1]) >= 1)  or
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	end

	return false
	
end

-- 是否可以跳过觉醒副本
function canJumpDCopyBattle( ... )
	
	if(item and item.dcopy_skip_limit) then
		local jumpInfo = lua_string_split(item.dcopy_skip_limit,"|")
		Logger.debug("db_vip_util dcopy_skip_limit:" .. tostring(item.dcopy_skip_limit))
		local uLevel   = UserModel.getHeroLevel()
		
		if(uLevel == nil or uLevel < 1) then
			return false
		end 
		-- or BattleMainData.fightRecord.replayed
		return (tonumber(jumpInfo[1]) >= 1)  or
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	end

	return false
	
end
-- 是否可以跳过公会副本
function canJumpICopyBattle(  )
	
	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item and item.lcopy_skip_limit) then
		local jumpInfo = lua_string_split(item.lcopy_skip_limit,"|")
		Logger.debug("db_vip_util lcopy_skip_limit:" .. tostring(item.lcopy_skip_limit))
		local uLevel   = UserModel.getHeroLevel()
		
		if(uLevel == nil or uLevel < 1) then
			return false
		end 
		-- or BattleMainData.fightRecord.replayed
		return (tonumber(jumpInfo[1]) >= 1)  or
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	end

	return false
end


-- 是否可以跳过竞技场
function canJumpArena()
	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item and item.arena_skip) then
		
		local uLevel   = UserModel.getHeroLevel()
		if(uLevel == nil or uLevel < 1) then
			return false
		end 

		local jumpInfo = lua_string_split(item.arena_skip,"|")
		local debugInfo = "arena_skip:" .. tostring(item.arena_skip) .. " vip:" .. tostring(UserModel.getVipLevel()) .. " level:" .. tostring(UserModel.getHeroLevel()) .. " replayed:" .. tostring(BattleMainData.replayed)

		Logger.debug(debugInfo)
		--or BattleMainData.fightRecord.replayed 
		return (tonumber(jumpInfo[1]) >= 1) or
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel()) , debugInfo
	end

	return false
end

-- 是否可以跳过觉醒副本
function canJumpDCopyBattle( copyPassed )
	-- 如果已经打过,那么是可以跳过战斗的
	if(copyPassed == true) then return true end
	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item and item.dcopy_skip_limit) then
		local jumpInfo = lua_string_split(item.dcopy_skip_limit,"|")
		Logger.debug("db_vip_util dcopy_skip_limit:" .. tostring(item.dcopy_skip_limit))
		local uLevel   = UserModel.getHeroLevel()
		
		if(uLevel == nil or uLevel < 1) then
			return false
		end 
		-- or BattleMainData.fightRecord.replayed
		return (tonumber(jumpInfo[1]) >= 1)  or
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	end

	return false
	
end

--最大加速(1,2,3)
function speedUpMax()
	if(canSpeedTriple()) then
		return 3
	elseif(canSpeedDouble()) then
		return 2
	else
		return 1
	end
end

-- 是否可以2倍速
function canSpeedDouble()
	
	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item) then
		local jumpInfo = lua_string_split(item.double_speed,"|")
		return (tonumber(jumpInfo[1]) >= 1) or 
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	else

	end

	return false
end

-- 是否可以3倍速
function canSpeedTriple()
	local item = getItemByVIPLevel(UserModel.getVipLevel())
	if(item) then
		local jumpInfo = lua_string_split(item.triple_speed,"|")
		return (tonumber(jumpInfo[1]) >= 1) or 
			   (tonumber(jumpInfo[2]) <= UserModel.getHeroLevel())
	else

	end

	return false
end


 
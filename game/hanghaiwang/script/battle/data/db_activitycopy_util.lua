
-- 活动本数据
module("db_activitycopy_util",package.seeall)
require "db/DB_Activitycopy"

--通过copyid来检索
function getItemByid( id )
	return DB_Activitycopy.getDataById(tonumber(id))
end

-- 获取指定副本,指定伤害值可以得到的贝里
function getDamgeDesInfo(id )
	local item = getItemByid(id)
	if(item ~= nil) then
		local dpsArray = lua_string_split(tostring(item.dps),"|")
		local bellyArray = lua_string_split(tostring(item.belly),"|")
		if(
			dpsArray == nil 	or 
			#dpsArray <=1 	 	or 
			bellyArray == nil 	or 
			#bellyArray <= 1	or
			#dpsArray ~= #bellyArray
		  ) then
			error("DB_Activitycopy 副本 dps 或者 belly参数错误: dps->" .. tostring(item.dps) ..  " belly->" .. tostring(item.belly))
		else
			-- 这里强转下数字
			for index=1,#dpsArray do
				dpsArray[index] = tonumber(dpsArray[index])
				bellyArray[index] = tonumber(bellyArray[index])
			end
			return dpsArray,bellyArray
		end
	else
		error("DB_Activitycopy 未找到副本:" .. tostring(id))
	end
end

 
-- 获取贝里系数(用于计算贝里计算)
function getBellyRatio( id )
	local item = getItemByid(id)
	if(item ~= nil) then
		return tonumber(item.belly_attack)/10000
	else
		error("DB_Activitycopy 未找到副本:" .. tostring(id))
	end
	
end

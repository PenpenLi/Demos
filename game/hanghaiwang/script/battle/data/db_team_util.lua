
module("db_team_util",package.seeall)

--local lastnpcTeam = DB_Team.getDataById(lastArmy.monster_group_npc)

	--通过id来检索
	function getItemByid( id )
		
		if(id == nil ) then

			--print("=============== getItemByid is nill======================")
			--print(debug.traceback())
			--print("===========================================================")
		 

		end 
		return DB_Team.getDataById(tonumber(id))
	end
	-- 把value当做key
local function getMarkMap(source)

		local result 	

		if source ~= nil then
			result 			= {}
			for i,v in ipairs(source) do
				result[tonumber(v)]	= true
			end
		end
		return result
end	-- function end

local function transArrayKeyToNumber( data )
	if data == nil then return nil end
	for i,v in ipairs(data) do
		data[tonumber(i)] = tonumber(v)
	end
	return data
end
	--
	function getMonsterIDArray( id )
		local  item = getItemByid(id)
		if item ~= nil then
			local listString = item.monsterID
			local array
			if listString ~= nil and listString ~= "" then
				array = lua_string_split(listString,",")
				-- for k,v in pairs(array) do
				-- 	--print("getMonsterIDArray:",k," ",v)
				-- end
			end
			-- --print("**************************************		team monsterID :",listString)
			return transArrayKeyToNumber(array)
		else 
			----print("**************************************		team id :",id," is nil")
		end
	end	
 	-- 2x2 boss
	function getBossIDMap( id )
		--print("getBossIDMap:",id)
		if(type(id) == "table") then
			--print("=============== getBossIDMap is table======================")
			--print(debug.traceback())
			--print("===========================================================")
		 
		 end
		local idArray 		= getBossIDArray(id)
		if idArray ~= nil then
			return getMarkMap(idArray)
		end -- if end
	end -- function end
	-- 2x2 boss
	function getBossIDArray( id )
		local  item = getItemByid(id)
		if item ~= nil then
			local array

			local listString = item.bossID
			--print("**************************************		team bossID :",listString)
			if listString ~= nil and listString ~= "" then
				array = lua_string_split(listString,",")
				return transArrayKeyToNumber(array)
			end
			 
			--return item.bossID
		end
	end		


 
	-- function getDemonLoadIdMap( id )
	-- 	local idArray 		= getDemonLoadIdArray(id)
 -- 		return getMarkMap(idArray)
	-- end -- function end

	--魔王(2倍黑卡,三国遗留,暂时不用)
	function getDemonLoadIdArray( id )
		local  item = getItemByid(id)
		if item ~= nil then
			local array
			local listString = item.demonLoadId
			-- print("**************************************		team demonLoadId :",listString)
			if listString ~= nil and listString ~= "" then
				array = lua_string_split(listString,",")
				for i,v in ipairs(array) do
			----print("************************************** 		item:",v)
				end
			end
			return transArrayKeyToNumber(array)
			 
		end
	end		



 	 --魔王(2倍黑卡,三国遗留,暂时不用)
	function getDemonLoadIdMap( id )
		local idArray 		= getDemonLoadIdArray(id)
		return getMarkMap(idArray)
	end -- function end


 	-- 3x3 无边框怪物
	function getOutlineIdMap( id )
		local idArray 		= getOutlineIdArray(id)
		return getMarkMap(idArray)
	end -- function end

	-- 3x3 无边框怪物
	function getOutlineIdArray( id )
		local  item = getItemByid(id)
		if item ~= nil then
			local array
			local listString = item.outlineId
			-- print("**************************************		team outlineId :",listString)
			if listString ~= nil and listString ~= "" then
				array = lua_string_split(listString,",")
			end
			return array
		end
	end	


	-- 4x4 超大边框怪物
	function getSuperCardIdMap( id )
		local idArray 		= getuperCardIdArray(id)
		return getMarkMap(idArray)
	end -- function end

	-- 4x4 无边框怪物
	function getuperCardIdArray( id )
		local  item = getItemByid(id)
		if item ~= nil then
			local array
			local listString = item.superCardId
			-- print("**************************************		team superCardId :",listString)
			if listString ~= nil and listString ~= "" then
				array = lua_string_split(listString,",")
			end
			return array
		end
	end	



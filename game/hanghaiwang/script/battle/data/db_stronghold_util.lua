
module("db_stronghold_util",package.seeall)

 

 
	------------------ properties ----------------------
	 -- LEVEL_MAX										=  5
	 -- LEVEL_MIN										=  1

	------------------ functions -----------------------
	
	
-- 	npc_army_ids_难度等级：npc的Armyid
-- army_ids_难度等级：armyid
-- revive_mode_simple:复活模型？
-- fire_scene：场景背景图（2张自己添加_0 _1)
-- startposition战斗起始位置（1，2，3）
-- fire_music:背景音乐

	function getItemByid( id )
		return DB_Stronghold.getDataById(tonumber(id))
	end


	function getDisplayName( id )
		local  item = getItemByid(id)
		if item ~= nil then
			return tostring(item.name)
		end
	end

	--获取战斗起始索引[1,2,3]
	function getFightStartIndex( id )
		
		local  item = getItemByid(id)
		if item ~= nil then
			return tonumber(item.startposition)
		end
	end
	--通过难度和 id来获取armyid  level(数字) ps:返回的是分割好的table
	function getArmyByHardLevelAndId( id,level )

		-- level = filterLevel(level)
		
		local  item = getItemByid(id)
		if item ~= nil then
			local listString = item["army_ids_"..level]
			if(listString == nil) then
				error("army data error:id=" .. tostring(id).. " army_ids_" .. tostring(level))
			end
			local armyIdArray = lua_string_split(listString,",")
			return armyIdArray
		end
	end
	 -- 获取npc列表 id,level(数字) ps:返回的是分割好的table
 
	function getNPCArmyByHardLevelAndId( id,level )
		 --level = filterLevel(level)

		local  item = getItemByid(id)
		if item ~= nil then
			local listString 	= item["npc_army_ids_"..level]
			if listString ~= nil and listString ~= "" then

				local npcIdArray 	= lua_string_split(listString,",")
				return npcIdArray
			end
			return nil
		end
	end	

	function getArmyNum( id )
		
		local item = getItemByid(id)
		if item ~= nil then
			return item.army
		end
	end
	--复活模型？
	function getRevive_mode_simple( id )
		local item = getItemByid(id)
		if item ~= nil then
			return item.revive_mode_simple
		end
	end
	--获取背景图名字
	function getBackGroundImageName( id )
		local item = getItemByid(id)
		if item ~= nil then
			return item.fire_scene
		end
	end

	--获取背景音乐名字
	function getBackGroundMusic( id )
		local item = getItemByid(id)
		if item ~= nil then
			return item.fire_music
		end
		return "music01.mp3"
	end

-- -- 过滤level等级 不在这里处理，我们把过滤函数放到数据的入口，这样只需要一次就可达到目的
-- local function filterLevel( level )
-- 	if level < LEVEL_MIN or level > LEVEL_MAX then
-- 			level = LEVEL_MIN
-- 	end
-- 	return level
-- end 





module("db_animations",package.seeall)

require "db/DB_Army"
 

	------------------ properties ----------------------
	TYPE_NPC										= 2

	------------------ functions -----------------------
 
   -- local army = DB_Army.getDataById(armyIdArray[m_currentArmyIndex])
	--通过monster的id来检索
	function getItemByid( id )
		return DB_Army.getDataById(tonumber(id))
	end
	-- 获取队伍名字
	function getName( id )
		local  item = getItemByid(id)
		if item ~= nil then
			return item.display_name
		end
	end
	--获取回合前对话id
 	function getStartTalkid( id )
 		local  item = getItemByid(id)
		if item ~= nil then
			return item.dialog_id_pre
		end 
 	end
 
 	--是否是npc
	function isNPC( id )
		
		local  item = getItemByid(id)
		if item ~= nil then
			return tonumber(item.type) == TYPE_NPC 
		end 
		return false
	end



 	--获取完成对话后后音乐 
	function getAfterTalkMusic( id )
		
		local  item = getItemByid(id)
		if item ~= nil then
			return item.dialog_music_over
		end 
		return false
	end


 	--获取完成对话后后背景更换为
	function getAfterTalkBackGroudImage( id )
		
		local  item = getItemByid(id)
		if item ~= nil then
			return item.dialog_scene_over
		end 
		return false
	end

	--获取teamid
	function getTeamid( id )
			local  item = getItemByid(id)
		if item ~= nil then
			return item.monster_group
		end 
		return false
	end

	--获取npc teamid
	function getNPCTeamid( id )
			local  item = getItemByid(id)
		if item ~= nil then
			return item.monster_group_npc
		end 
		return false
	end

	--获取上场方式
	function getPlayerShowWay( id )
			local  item = getItemByid(id)
		if item ~= nil then
			return tonumber(string.sub(item.appear_style,1,1))
		end 
		return false
	end


	
 

module("db_army_util",package.seeall)

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
 	-- 获取对战中对话  回合->对话id
 	function getFightingTalks( id )
 		local item = getItemByid(id)
 		local roundToTalkMap = {}
 		local count = 0
 		if(item ~= nil) then
 			-- 战斗中对话
 			local dialog_ids = item.dialog_ids_fighting
 			 
			-- print(id," dialog_ids_fighting:",dialog_ids)
			

 			if(dialog_ids ~= nil and dialog_ids ~= "") then

 				local dialog_idArray
 				if(string.find(dialog_ids,",") ~= nil) then
 				 	dialog_idArray = lua_string_split(dialog_ids,",")
 				else
 					print(" dialog_ids_fighting:木有逗号啊")
 					dialog_idArray = {}
 					table.insert(dialog_idArray,dialog_ids)
 				end
 			
	 			for i=1,#dialog_idArray do

	 				local dialogInfo = lua_string_split(dialog_idArray[i],"|")
	 				
			        local dialogRound = tonumber(dialogInfo[1])
			        ----print("--------- dialogRound:",dialogRound)
			        if(dialogRound ~= nil)then
			            local talkId = tonumber(dialogInfo[2])
			            -- print(" dialog_idArray:",talkId,dialogRound)
			            if(talkId~=nil)then
			              count = count + 1
			              roundToTalkMap[tostring(dialogRound)] = talkId  
			            end-- if end
			        end -- if end
			    end -- for end
 			end
 			
		    if(count > 0) then
		    	return roundToTalkMap
		    end
 		end
 	end	
 	--获取完成对话后后背景更换为
 	-- 对话后的背景改变
 	function getAfterTalkChangeBackGround( id )
 		local item = getItemByid(id)
 		local backGround = {}
 		local count = 0
 		if(item ~= nil) then
 			-- 战斗中对话
 			local dialog_ids = item.dialog_scene_over
 			if(dialog_ids ~= nil and dialog_ids ~= "") then

 				local dialog_idArray 	 = lua_string_split(dialog_ids,",")
 			
	 			for i=1,#dialog_idArray do
	 				local dialogInfo 	 = lua_string_split(dialog_idArray[i],"|")
			        local dialogFromTalk = tonumber(dialogInfo[1])
			        ----print("--------- dialogRound:",dialogRound)
			        if(dialogFromTalk ~= nil)then
			            local img 	     = tostring(dialogInfo[2])
			            if(img~=nil)then
			              count = count + 1
			              backGround[dialogFromTalk] = img  
			            end-- if end
			        end -- if end
			    end -- for end
 			end
 			
		    if(count > 0) then
		    	return backGround
		    end
 		end
 	end

--获取完成对话后后音乐 
 	-- 对话后的声音改变
 	function getAfterTalkMusicChange( id )
 		local item = getItemByid(id)
 		local music = {}
 		local count = 0
 		if(item ~= nil) then
 			-- 战斗中对话
 			local dialog_ids = item.dialog_scene_over
 			if(dialog_ids ~= nil and dialog_ids ~= "") then

 				local dialog_idArray 	 = lua_string_split(dialog_ids,",")
 			
	 			for i=1,#dialog_idArray do
	 				local dialogInfo 	 = lua_string_split(dialog_idArray[i],"|")
			        local dialogFromTalk = tonumber(dialogInfo[1])
			        ----print("--------- dialogRound:",dialogRound)
			        if(dialogFromTalk ~= nil)then
			            local sound 	     = tostring(dialogInfo[2])
			            if(sound~=nil)then
			              count = count + 1
			              music[dialogFromTalk] = sound  
			            end-- if end
			        end -- if end
			    end -- for end
 			end
 			
		    if(count > 0) then
		    	return music
		    end
 		end
 	end
 
 	--获取结束对话接口
 	function getCompleteTalkid( id )
 		local  item = getItemByid(id)
		if item ~= nil then
			return tonumber(item.dialog_id_over)
		end 
 	end
 	-- 获取切换背景的信息(背景,对话等)
 	function getChangeBackGroudInfoString(id)

 		local  item = getItemByid(id)
		if (item ~= nil and item.dialog_scene_over ~= nil)then
			return tostring(item.dialog_scene_over)
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



 	
	-- function getAfterTalkMusic( id )
	-- 	
	-- 	local  item = getItemByid(id)
	-- 	if item ~= nil then
	-- 		return item.dialog_music_over
	-- 	end 
	-- 	return false
	-- end


 	
	-- function getAfterTalkBackGroudImage( id )
	-- 	
	-- 	local  item = getItemByid(id)
	-- 	if item ~= nil then
	-- 		return item.dialog_scene_over
	-- 	end 
	-- 	return false
	-- end

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
		if item ~= nil and item.appear_style then
			return tonumber(string.sub(item.appear_style,1,1))
		end 
		return 0
	end

	function getShowWayString( id )
		local  item = getItemByid(id)
		if item ~= nil and item.appear_style then
			return tostring(item.appear_style)
		end 
		return nil
	end

	function getShowWayParas( id )
		local  item = getItemByid(id)
		if(item ~= nil and item.appear_style ~= nil) then
			return lua_string_split(item.appear_style,"|")
		end 
		return nil
	end


	
 

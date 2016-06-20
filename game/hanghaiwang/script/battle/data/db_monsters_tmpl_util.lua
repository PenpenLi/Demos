module("db_monsters_tmpl_util",package.seeall)

require "db/DB_Monsters_tmpl"
	
	--主要是对DB_Monsters_tmpl的数据封装

	------------------ properties ----------------------
	

	------------------ functions -----------------------
	--通过monster的id来检索
	function getItemByid( htid )
		
		return DB_Monsters_tmpl.getDataById(tonumber(htid))
	end

	function getGrade(htid)
		
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.star_lv
		end
	end

	function getName( htid )
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.name
		end
	end

	-- 英雄动作图片
	function getActionModuleName( htid ,isBoss,isOutline,isSuper)
		
		local  item = getItemByid(htid)
		if item ~= nil then
			
			-- if isBoss ~= true then
				local actionName = nil
				if(isOutline ~= true) then
					if(item.action_module_id == nil) then

		               ObjectTool.showTipWindow( "monstersTem:" .. htid .. "属性action_module_id 为空", nil, false, nil)
	                else
	                	actionName = item.action_module_id
	                end


	            else
	            	if(item.body_img_id == nil) then
		               ObjectTool.showTipWindow( "monstersTem:" .. htid .. "body_img_id 为空", nil, false, nil)
	                else
	                	actionName = item.body_img_id
	                end
	            end
				-- print("@@@getActionModuleName find:",htid,isBoss,item.action_module_id)
				local url,actionName = BattleURLManager.getActionImageURL(actionName,isBoss,isOutline,isSuper)
				-- local url = BattleURLManager.getActionImageURL(item.action_module_id,isBoss,isOutline)
				if(file_exists(url) ~= true) then
					
					 if(isBoss) then
					 	ObjectTool.showTipWindow( "monstersTem Boss:" .. htid .. "资源不存在", nil, false, nil)
					 	return "zhan_jiang_modongzhuo.png"
					 else
					 	ObjectTool.showTipWindow( "monstersTem :" .. htid .. "资源不存在", nil, false, nil)
					 	return "fight_elite_labu.png"
					 end
				else
					return actionName
				end
				 -- if(isBoss) then
				 	-- print("##boss:"..url)
				 -- end
				return item.action_module_id
			-- else
			-- 	-- --print("@@@getActionModuleName find:",htid,isBoss,item.boss_icon_id)
			-- 	if(item.boss_icon_id == nil) then
	  --               ObjectTool.showTipWindow( "monstersTem Boss:" .. htid .. "boss_icon_id 为空", nil, false, nil)
	  --               return "zhan_jiang_modongzhuo.png"
   --              end
			-- 	return item.boss_icon_id
			-- end
		else
			error("@@@getActionModuleName not find:"..htid)
		end
	end

	-- 获取怒气头像图片名字
	function getRageHeadIconName( htid )
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.rage_head_icon_id
		end
	end	
	--获取身体图片名字
	function getBodyImageName( htid )
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.body_img_id
		end
	end	

	-- 获取反击技能
	function getBeatBackSkillId( id )
		local item = getItemByid(id)
		if item ~= nil then
			return tonumber(item.beat_back_skill_id)
		end
	end
	


module("db_heroes_util",package.seeall)

require "db/DB_Heroes"



	function getItemByid( id )
		return DB_Heroes.getDataById(tonumber(id))
	end

	function getRageHeadImage( id )
		local  item = getItemByid(id)
		if item ~= nil then
			return item.rage_head_icon_id
		end
	end

	function getName( htid )
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.name
		end
	end
	
	function getGrade(htid)
		
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.star_lv
		end
	end
	-- 英雄动作图片
	function getActionModuleName( htid ,isBoss,isOutLine)
		
		isBoss = isBoss or false
		local  item = getItemByid(htid)
		if item ~= nil then
			if isOutLine ~= true then
				return item.action_module_id
			else
			 	return item.body_img_id
			end
		else
			error("未找到英雄:" .. htid .. " isBoss:" .. tostring(isBoss == true).. " isOutLine:" .. tostring(isOutLine == true))
		end
	end
	-- 获取全身像
	function getBodyImage( id )
		local  item = getItemByid(id)
		if item ~= nil then
			return item.body_img_id
		end
	end	
	--获取原始module id
	function getModelId( id )
		local item = getItemByid(id)
		if item ~= nil then
			return item.model_id
		end
	end

	-- 获取反击技能
	function getBeatBackSkillId( id )
		local item = getItemByid(id)
		if item ~= nil then
			return tonumber(item.beat_back_skill_id)
		end
	end



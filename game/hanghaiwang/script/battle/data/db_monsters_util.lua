module("db_monsters_util",package.seeall)

require "db/DB_Monsters"
	
	--主要是对DB_Monsters的数据封装

	------------------ properties ----------------------
	

	------------------ functions -----------------------
	--通过monster的id来检索
	function getItemById( id )
		
		return DB_Monsters.getDataById(tonumber(id))
	end
	-- ??
	function getHtid( id )
		
		local  item = getItemById(id)
		if item ~= nil then
			return item.htid
		end
	end
 
	-- 获取怒气头像图片名字
	function getRageHeadIconName( id )
		local  htid = getHtid(id)
		return db_monsters_tmpl_util.getRageHeadIconName(htid)
	end	

	function getName( htid )
		local  item = getItemByid(htid)
		if item ~= nil then
			return item.name
		end
	end
	


module("db_ship_util",package.seeall)

require "db/DB_Ship"



function getItemByid( id )
	return DB_Ship.getDataById(tonumber(id))
end

-- 获取主船信息界面中主船icon的url
function getBattleInfoShipImg(id)
	local item = getItemByid(id)
	local img = nil
	if(item) then
		 img = item.ship_battle_icon
		 return BattleURLManager.getShipInfoIcon(img)
	end	
end
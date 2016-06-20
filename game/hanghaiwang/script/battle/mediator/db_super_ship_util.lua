module("db_super_ship_util",package.seeall)
require "db/DB_Super_ship"


function getItemByid( id )
	return DB_Super_ship.getDataById(tonumber(id))
end

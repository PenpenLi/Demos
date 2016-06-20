

module("db_battlingShow_util",package.seeall)

require "db/battlingShow"

function getItemByid( id )
	return battlingShow.indexLogicByArmyID(id)
end

function hasArmyLogic( id )
	return battlingShow.hasArmyLogic(id)
end
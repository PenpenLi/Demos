module("db_cardSize_util",package.seeall)

require "db/DB_BattleCardSizes"


	function getCardDataByLevel( level )
		local dataes = DB_BattleCardSizes.getArrDataByField("level",level)
		if(dataes and dataes[1]) then
			return dataes[1]
		end
	end

	function getCardRectangleByLevel(level)
		levelInfo = getCardDataByLevel(level)
		w,h = 0
		if(levelInfo and levelInfo.width > 0 and levelInfo.height > 0) then
			w,h = levelInfo.width,levelInfo.height
		end
		return CCSizeMake(w,h)
	end

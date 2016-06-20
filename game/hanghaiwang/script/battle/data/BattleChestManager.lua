module ("BattleChestManager",package.seeall)

local flyingChestsBuffer = nil
local flyingActions = nil

function ini( ... )
	flyingChestsBuffer = {}
	flyingActions = {}
end

-- BattleChestData input
function pushChest( data )
	 table.insert(flyingChestsBuffer,data)
end

function runActionFromBuffer( ... )
	 
end

function addAction( data )
	
end












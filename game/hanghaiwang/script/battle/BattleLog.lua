
module("BattleLog", package.seeall)

ERROR_LEVEL_BASE 					= 0
printLevel 							= 0

function printLog(info,level)
	if level == nil then
		level = 0
	end
	if printLevel >= level then
	--print(info)
	end
end

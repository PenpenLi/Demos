 
module("BattleArmyDataDisplayManager", package.seeall)

local selfDisplays 							= nil -- 
local armyDisplays 							= nil --
local lastArmyData 							= nil -- 上一场
function reset(armyData)

	-- 如果有上一场数据,需要处理替换问题
	if lastArmyData ~= nil then 
		-- -- todo
		-- if lastArmyData.isNPC == true and armyData.isNPC then

		-- end
	else

	end
 	-- 初始化自己队伍的人
     local display = require("script/battle/ui/BattlPlayerDisplay").new()
    display:reset(v)

    -- 初始化敌方队伍的人
end 			

-- 删除table内的显示对象
function removeTeamDisplay(list)

end	
-- 切换牌的战斗ui的可视性
function switchCardBattleUI()
	
end
 


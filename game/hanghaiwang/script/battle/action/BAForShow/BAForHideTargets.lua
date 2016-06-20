
 -- 根据索引(0-11)隐藏指定目标
local BAForHideTargets = class("BAForHideTargets",require(BATTLE_CLASS_NAME.BaseAction))

function BAForHideTargets:start( ... )
	-- Logger.debug("BAForHideTargets:start0")
	if(self.data) then
		-- Logger.debug("BAForHideTargets:start")
		-- for k,v in pairs(self.data) do
		-- 	print("BAForHideTargets:start",k,v)
		-- end
		local playersDataList = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data)
		if(playersDataList and #playersDataList > 0) then
			for k,displayData in pairs(playersDataList) do
				displayData:setVisible(false)
			end
		else
			Logger.debug("== BAForHideTargets:start target is zero")
		end
	end
	self:complete()	
end





return BAForHideTargets
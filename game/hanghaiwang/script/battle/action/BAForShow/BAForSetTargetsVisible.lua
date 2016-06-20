



 -- 根据索引(0-11) 显示指定目标
local BAForSetTargetsVisible = class("BAForSetTargetsVisible",require(BATTLE_CLASS_NAME.BaseAction))

function BAForSetTargetsVisible:start( ... )
	-- Logger.debug("BAForSetTargetsVisible:start0")
	if(self.data) then
		-- Logger.debug("BAForSetTargetsVisible:start")
		-- for k,v in pairs(self.data) do
			-- print("BAForSetTargetsVisible:start",k,v)
		-- end
		local playersDataList = BattleTeamDisplayModule.getPlayerDisplayByPositionList(self.data)
		if(playersDataList and #playersDataList > 0) then
			for k,displayData in pairs(playersDataList) do
				displayData:setVisible(true)
			end
		else
			Logger.debug("== BAForSetTargetsVisible:start target is zero")
		end
	end
	self:complete()	
end





return BAForSetTargetsVisible
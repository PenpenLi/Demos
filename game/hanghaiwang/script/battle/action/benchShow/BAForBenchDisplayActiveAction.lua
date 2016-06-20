
--  替补显示数据激活
require (BATTLE_CLASS_NAME.class)
local BAForBenchDisplayActiveAction = class("BAForBenchDisplayActiveAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForBenchDisplayActiveAction.hid 					= nil
	BAForBenchDisplayActiveAction.position				= nil
	BAForBenchDisplayActiveAction.teamid 				= nil
	------------------ functions -----------------------
	function BAForBenchDisplayActiveAction:start()
		
		Logger.debug("BAForBenchDisplayActiveAction:start")
		if(self.hid and self.position and self.teamid) then
			local target = BattleMainData.fightRecord:getTargetData(self.hid)
			if(target) then 
				local displayData = target:getCardDisplayData()
				displayData:reset(displayData.hid,displayData.htid,self.position,self.teamid)
				BattleTeamDisplayModule.activeNewPlayer(displayData,self.position,self.teamid)
				-- 刚刚出场的替补需要隐藏
				-- local display = BattleTeamDisplayModule.getCardByPostionAndTeam(self.position,self.teamid)
				-- if(display) then
				-- 	-- display:setVisible(false)
				-- end
			else
				error("未发现替补:".. tostring(self.hid))
			end
		else
			Logger.debug("BAForBenchDisplayActiveAction:start error")
			-- print("=== BAForBenchDisplayActiveAction:",self.hid,self.position,self.teamid)

		end

		
		self:complete()
	end
 
return BAForBenchDisplayActiveAction
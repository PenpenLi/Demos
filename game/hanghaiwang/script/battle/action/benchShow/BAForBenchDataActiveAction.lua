-- 替补数据激活
require (BATTLE_CLASS_NAME.class)
local BAForBenchDataActiveAction = class("BAForBenchDataActiveAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForBenchDataActiveAction.hid						= nil	-- 替补hid 
	BAForBenchDataActiveAction.position					= nil 	-- 替补位置
	BAForBenchDataActiveAction.teamid					= nil 	-- 替补teamid
	------------------ functions -----------------------
	function BAForBenchDataActiveAction:start()

		if(self.hid and self.position and self.teamid) then
			BattleMainData.fightRecord:activeBenchData(self.hid,self.position,self.teamid)
		else
			Logger.debug("BAForBenchDataActiveAction:start error")
			-- print("=== BAForBenchDisplayActiveAction:",self.hid,self.position,self.teamid)

		end

		self:complete()
	end
 
return BAForBenchDataActiveAction
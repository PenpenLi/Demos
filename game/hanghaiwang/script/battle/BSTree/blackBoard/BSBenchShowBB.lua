



 -- 死亡
require (BATTLE_CLASS_NAME.class)
local BSBenchShowBB = class("BSBenchShowBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
  
 	------------------ properties ----------------------
 	BSBenchShowBB.benchID				= nil -- 
 	BSBenchShowBB.benchPosition			= nil -- 
 	BSBenchShowBB.benchs 				= nil -- 要上场的替补
 	BSBenchShowBB.showEffectName		= nil -- 出场特效
 	BSBenchShowBB.fadeInTime 			= nil -- 出场渐现的时间
 	BSBenchShowBB.teamid				= nil
 	BSBenchShowBB.postionX				= nil -- 特效出现x位置
 	BSBenchShowBB.postionY				= nil -- 特效出现y位置
 	BSBenchShowBB.des 							= "BSBenchShowBB"
 	-- BSBenchShowBB.effectPosition		= nil
 	-- BSBenchShowBB.oldPlayer				= nil 
 	-- BSBenchShowBB.targets 				= 
 	------------------ functions -----------------------
 	function BSBenchShowBB:reset(hid,positon)
 		self.benchID 			= hid
 		self.benchPosition 		= positon
 		
 		self.showEffectName		= "tibu_arise"
 		-- self.effectPosition		= BATTLE_CONST.POS_MIDDLE
 		
 		local benchData = BattleMainData.fightRecord:getTargetData(hid)
 		if(benchData) then
 			self.teamid				= benchData.teamId
	 		self.benchs = {}
 			table.insert(self.benchs,hid)
	 	else
	 		error("未发现替补:" .. tostring(hid) .. " positon:" .. tostring(positon))
	 	end

	 	local uiData = BattleTeamDisplayModule.getCardByPostionAndTeam(positon,self.teamid)
	 	local pos = uiData:globalCenterPoint()
	 	self.postionX = pos.x
	 	self.postionY = pos.y

	 	-- print("showEffectName:",self.showEffectName,"total time:",db_BattleEffectAnimation_util.getAnimationTotalFrame(self.showEffectName))
	 	self.fadeInTime			= db_BattleEffectAnimation_util.getAnimationTotalFrame(self.showEffectName) * 0.8 /60		-- todo load from db
			
	 	-- print("=== BSBenchShowBB:",self.benchID,self.benchPosition,self.teamid)

 	end



 	-- function BSBenchShowBB:update( ... )
 	-- 	 local benchData = BattleMainData.fightRecord:getTargetData(hid)
 	-- 	 self.benchs = {}
 	-- end

 return BSBenchShowBB

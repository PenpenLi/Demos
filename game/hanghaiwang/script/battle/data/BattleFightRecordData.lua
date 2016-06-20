-- 战斗录像数据


 

local BattleFightRecordData = class("BattleFightRecordData")

 	
	------------------ properties ----------------------
	BattleFightRecordData.recordData  					= nil -- 录像数据 BattleDataADT
	-- BattleFightRecordData.reward 						= nil -- 奖励物品
	-- BattleFightRecordData.extra_reward 					= nil -- 其他奖励信息
	-- BattleFightRecordData.copyCallBackData 				= nil -- 副本 回调 数据,用于结束画面
	-- BattleFightRecordData.isWin 						= nil -- 是否是胜利
	-- BattleFightRecordData.score 						= nil -- 分数
	 
	------------------ functions -----------------------

	function BattleFightRecordData:reset(data)
		-- 战斗串
		self.recordData 			= require(BATTLE_CLASS_NAME.BattleDataADT).new()
		self.recordData:reset(data.fightRet)

		-- 是否胜利
		self.isWin 					= string.lower(data.appraisal) ~= "f" and string.lower(data.appraisal) ~= "e"

		-- 奖励信息
		self.reward 				= data.reward
		
		self.extra_reward 			= data.extra_reward

		--
		if(data.newcopuorbase) then
			self.copyCallBackData 	= data.newcopuorbase.normal
		end
		
		self.score 					= data.getscore
	end
	-- 获取下一个回合的战斗
	function BattleFightRecordData:getNextRoundData()
		return self.recordData:getNextRoundData()
	end
	
return BattleFightRecordData
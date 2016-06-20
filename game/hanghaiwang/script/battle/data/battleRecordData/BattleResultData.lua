
local BattleResultData = class("BattleResultData")

 
	------------------ properties ----------------------
	
	--BattleResultData
	------------------ functions -----------------------
	-- appraisal : string 	//评价
	-- type : int			//战斗类型：竞技场/副本
	-- reward : object		//战斗奖励：不同类型的战斗数据结构不同
	-- {
	-- 	...
	-- }
	function BattleResultData:reset(data)
		self.appraisal 				= data.appraisal
		self.type					= data.type
		self.reward					= data.reward
	end
return BattleResultData
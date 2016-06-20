

-- 一个个的顺序播放action,通过push方法插入,callbacker是永久的
local BAForRunActionQueueSequencely = class("BAForRunActionQueueSequencely",require(BATTLE_CLASS_NAME.BAForRunActionSequencely))
	
	function BAForRunActionQueueSequencely:ctor()
		--BaseAction.super:ctor()
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattleForEverCallBacker).new()	
		-- self.listForRunning 		= {}
		self.listForComplete 		= {}
		self.total 					= 0
		self.running 				= false
	end

return BAForRunActionQueueSequencely





local BattleQueueMediator = class("BattleQueueMediator")
 

 	------------------ properties ----------------------
 	BattleQueueMediator.name 			= "BattleQueueMediator"
 	BattleQueueMediator.queue 			= nil 						-- 队列
 	------------------ functions -----------------------
 	function BattleQueueMediator:ctor()
 		self.queue 						= require(BATTLE_CLASS_NAME.LinkNodeQueue).new()
 	end

 	function BattleQueueMediator:push( f )
 		self.queue:push(f)
 	end

 	function BattleQueueMediator:runNext()
 		if(self.queue:hasNext()) then
 			local nextNode = self.queue:pop()
 			
 		end
 	end
 	
return BattleQueueMediator
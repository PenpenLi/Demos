require (BATTLE_CLASS_NAME.class)
local TestAction = class("TestAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	TestAction.leftTime									= 1


	------------------ functions -----------------------
	function TestAction:ctor()
		 	self.super:ctor()
	end
	function TestAction:start(data)
			self.leftTime								= 2
			self:addToRender()
	end
	function TestAction:update( dt )
			self.leftTime								= self.leftTime - 1
			--print("TestAction:update update leftTime->",self.leftTime)
			if self.leftTime <= 0 then
				--print("TestAction:update update complete")
				self:removeFromRender(self)
				--BattleActionRender.removeAction(self)
				self:runCompleteCall()
				--self.call:runCompleteCall()
			end
	end
return TestAction
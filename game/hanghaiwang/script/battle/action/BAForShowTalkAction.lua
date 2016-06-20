

-- BSTree 技能hp改变
require (BATTLE_CLASS_NAME.class)
local BAForShowTalkAction = class("BAForShowTalkAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForShowTalkAction.talkId				= nil 	-- 对话id
	BAForShowTalkAction.talkLayer 			= nil	--
	------------------ functions -----------------------
	
	function BAForShowTalkAction:start( ... )
		--yangna 2015.1.28  script/ui
		-- require "script/ui/talk/talkLayer"

		-- if(self.talkId ~= nil and self.talkId > 0) then
		-- 		local onComplete = function ( ... )
		-- 			self:onTalkComplete()
		-- 		end
		-- 	    local runningScene 			= CCDirector:sharedDirector():getRunningScene()
		-- 	    TalkLayer.setCallbackFunction(onComplete)
		-- 	    self.talkLayer 				= TalkLayer.createTalkLayer(talkID)
		-- 	    runningScene:addChild(talkLayer,999999)
		-- else
		-- 	self:complete()
		-- end
	end
	function BAForShowTalkAction:release( ... )
		self.disposed 						= true
		self:removeFromRender()		
		self.calllerBacker:clearAll()
		self.blockBoard						= nil
	end

	function BAForShowTalkAction:onTalkComplete( ... )
		if(self.disposed ~= nil) then
			self:complete()
		end
	end

 

return BAForShowTalkAction
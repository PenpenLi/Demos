 -- 播放指定对话
local BAForPlayTalk = class("BAForPlayTalk",require(BATTLE_CLASS_NAME.BaseAction))

BAForPlayTalk.talkCallBack = nil

function BAForPlayTalk:start( ... )
	if(self.data) then

		
		local talkCallBack = function ( ... )
 			-- self.talkCallBack = nil
			-- Logger.debug("============= 对话完成:" .. self.data[1])
			self:complete()
			self:release()

		end
		-- 
		 -- Logger.debug("============= 创建对话:" .. self.data[1])
		 TalkCtrl.create(self.data[1],talkCallBack)
		 TalkCtrl.setCallbackFunction(talkCallBack)
	     -- TalkCtrl.setCallbackFunction(self.talkCallBack)
	else
		self:complete()	
	end
	
end

function BAForPlayTalk:release( ... )
	-- Logger.debug("============= BAForPlayTalk:release")
	self.super.release(self)
	self.talkCallBack = nil
end





return BAForPlayTalk
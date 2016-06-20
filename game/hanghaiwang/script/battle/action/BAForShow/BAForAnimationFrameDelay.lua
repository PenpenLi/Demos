-- 延迟制定帧数后结束
local BAForAnimationFrameDelay = class("BAForAnimationFrameDelay",require(BATTLE_CLASS_NAME.BaseAction))

 -- BAForAnimationFrameDelay.animationName = nil		-- 动画名称
 BAForAnimationFrameDelay.totalFrame 	= nil 		-- 总时间
 BAForAnimationFrameDelay.costTime 		= nil 		-- 消耗时间
 BAForAnimationFrameDelay.totalTime		= nil 		-- 总时间
 -- BAForAnimationFrameDelay.delayFrom		= nil
function BAForAnimationFrameDelay:start( ... )
	-- Logger.debug("BAForAnimationFrameDelay:start1" .. tostring(self.data) .. tostring(self.data[1]))
	if(self.data and self.data[1]) then
		-- Logger.debug("BAForAnimationFrameDelay:start2")
		-- self.animationName = i
		-- self.totalFrame								   = db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName)		-- todo load from db
		self.totalFrame								   = tonumber(self.data[1])		-- todo load from db
	 	if(self.totalFrame<= 0 ) then
	 		self.totalFrame = 1
	 	end
	 	if(self.totalFrame >= 500) then
	 		self.totalFrame = 500
	 	end
	 	-- self.totalFrame 							   = math.ceil(self.totalFrame/2)
		self.costTime								   = 0
		self.totalTime								   = BATTLE_CONST.FRAME_TIME * self.totalFrame
		self.isComplete								   = false
		-- self.keyframes 									= db_BattleEffectAnimation_util.getAnimationKeyFrameArray(self.animationName)--{3,4,5} -- todo load from db
	 	self:addToRender()			
	else
		-- Logger.debug("BAForAnimationFrameDelay:start error")
		self:complete()	
	end
	
end

function BAForAnimationFrameDelay:update(dt)

		-- Logger.debug("BAForAnimationFrameDelay:update" .. tostring(self.costTime) .. ":" .. tostring(self.totalTime))
		if(self.disposed ~= true) then
			 
			 self.costTime = self.costTime + dt
			
			-- 判断是否播完
			 if self.costTime >=  self.totalTime then
			  
			 	self:complete()
			 end
		else
			error("BAForAnimationFrameDelay:update disposed")
		end

end

 



return BAForAnimationFrameDelay




require (BATTLE_CLASS_NAME.class)
local BaseActionForKeyFramesTrigger = class("BaseActionForKeyFramesTrigger",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BaseActionForKeyFramesTrigger.keyframes 				= nil 	-- 关键帧列表
	BaseActionForKeyFramesTrigger.notExcutedFrame			= nil -- 未激活的keyframe

	BaseActionForKeyFramesTrigger.currentFrame  			= nil 	-- 当前帧数
	BaseActionForKeyFramesTrigger.totalFrame				= nil 	-- 总帧数

	BaseActionForKeyFramesTrigger.currentTime				= nil 	-- 当前时间
	BaseActionForKeyFramesTrigger.totalTime					= nil 	-- 总时间

	BaseActionForKeyFramesTrigger.isLoop					= false -- 是否是循环
	BaseActionForKeyFramesTrigger.isComplete				= false	-- 是否完成



	BaseActionForKeyFramesTrigger.excutedKeyFrames  		= 0 	-- 当前帧数
	BaseActionForKeyFramesTrigger.totalKeyFrame				= 0		-- 总keyFrame

	BaseActionForKeyFramesTrigger.animationName 			= nil
	------------------ functions -----------------------
	function BaseActionForKeyFramesTrigger:ctor()
		
		ObjectTool.setProperties(self)
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	
		self.keyFrameCaller			= require(BATTLE_CLASS_NAME.BattleForEverCallBacker).new()	
		self.notExcutedFrame		= {}
		--print("create BaseActionForKeyFramesTrigger ")
	end

	function BaseActionForKeyFramesTrigger:start(data)
		self.currentFrame								= 0
		self.totalFrame									= db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName)		-- todo load from db
		--print("BaseActionForKeyFramesTrigger:totalFrame -> ",self.totalFrame)
		self.currentTime								= 0
		self.totalTime									= BATTLE_CONST.FRAME_TIME * self.totalFrame
		self.isComplete									= false
		self.keyframes 									= db_BattleEffectAnimation_util.getAnimationKeyFrameArray(self.animationName)--{3,4,5} -- todo load from db

		self.totalKeyFrame								= db_BattleEffectAnimation_util.getAnimationTotalKeyFrames(self.animationName)		-- todo load from db
		--print("BaseActionForKeyFramesTrigger:totalFrame -> ",self.totalKeyFrame)
		self.excutedKeyFrames							= 0
		if self.totalKeyFrame <= 0 or self.keyframes == nil then
			--print("error:BaseActionForKeyFramesTriger keyframes <= 0")
		end
		self:generateNotExcutedFrame()
		self:addToRender()
	end
	function BaseActionForKeyFramesTrigger:generateNotExcutedFrame()
		self.notExcutedFrame							= {}
		self.totalKeyFrame 								= 0
		self.excutedKeyFrames							= 0
		-- 生成
		for i,v in ipairs(self.keyframes) do
			 table.insert(self.notExcutedFrame,v)
			 self.totalKeyFrame 						= self.totalKeyFrame + 1
		end

	end
	-- 处理关键帧,如果关键帧则会激活回调
	function BaseActionForKeyFramesTrigger:handleKeyFrame()

		if self.excutedKeyFrames <= self.totalKeyFrame then 
			for i,v in pairs(self.notExcutedFrame) do
				 --如果当前关键帧没有被激活过,且当前帧大于等于关键帧
				 -- 之所以用大于,是为了方式1次update直接就过了

				 if self.currentFrame >= tonumber(v) then 
				 	--v.excuted = true
				 	self.keyFrameCaller:runCallBack(self,math.floor(self.currentFrame))
				 	self.notExcutedFrame[i] = nil
				 	self.excutedKeyFrames = self.excutedKeyFrames + 1
				 	--print("BaseActionForKeyFramesTrigger:handleKeyFrame :",v)
				 end -- if end
			end -- for end
		 
		end -- if end
		
	end -- function end

	-- 更新函数
	function BaseActionForKeyFramesTrigger:update(dt)
		self.currentTime 			= self.currentTime + dt
		self.currentFrame 			= self.currentFrame + dt/BATTLE_CONST.FRAME_TIME
		self:handleKeyFrame()
		-- 如果播放完
		if self.currentTime >= self.totalTime then
			--print("BaseActionForKeyFramesTrigger play complete")
			-- 如果不是循环播放
			if self.isLoop == false then 
				self.isComplete 	= true
				self:complete()
			-- 如果是循环 就重置属性
			else
				self:generateNotExcutedFrame()
				self.currentFrame 	= 0
				self.currentTime  	= 0
			end			
		end
		
	end

		-- 释放函数
	function BaseActionForKeyFramesTrigger:release(data)
		if self.calllerBacker then 
			self.calllerBacker:clearAll()
		end
		
		if self.keyFrameCaller then 
			self.keyFrameCaller:clearAll()
		end
		self.blackBoard 			= nil
	end 
return BaseActionForKeyFramesTrigger
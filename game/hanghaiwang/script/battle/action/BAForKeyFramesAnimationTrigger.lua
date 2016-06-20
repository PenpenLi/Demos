

-- 带回调的多帧回调触发器 
-- keyFrameCaller 多帧回调
 

require (BATTLE_CLASS_NAME.class)
local BAForKeyFramesAnimationTrigger = class("BAForKeyFramesAnimationTrigger",require(BATTLE_CLASS_NAME.BaseAction))
 

 
	------------------ properties ----------------------
	BAForKeyFramesAnimationTrigger.keyframes 				= nil 	-- 关键帧列表
	BAForKeyFramesAnimationTrigger.notExcutedFrame			= nil	-- 未激活的keyframe

	BAForKeyFramesAnimationTrigger.currentFrame  			= nil 	-- 当前帧数
	BAForKeyFramesAnimationTrigger.totalFrame				= nil 	-- 总帧数

	BAForKeyFramesAnimationTrigger.currentTime				= nil 	-- 当前时间
	BAForKeyFramesAnimationTrigger.totalTime				= nil 	-- 总时间

	BAForKeyFramesAnimationTrigger.isLoop					= false -- 是否是循环
	BAForKeyFramesAnimationTrigger.isComplete				= false	-- 是否完成



	BAForKeyFramesAnimationTrigger.excutedKeyFrames  			= 0 	-- 已触发关键帧数
	BAForKeyFramesAnimationTrigger.totalKeyFrame				= 0		-- 总keyFrame




	BAForKeyFramesAnimationTrigger.shakeKeyframes 				= nil 	-- 震屏关键帧列表
	BAForKeyFramesAnimationTrigger.shakeNotExcutedFrame			= nil	-- 震屏未激活的keyframe
	BAForKeyFramesAnimationTrigger.excutedShakeKeyFrames  		= 0 	-- 已触发震屏关键帧数
	BAForKeyFramesAnimationTrigger.totalShakeKeyFrame			= 0		-- 总震屏keyFrame
	BAForKeyFramesAnimationTrigger.notExcutedShakeFrame			= 0		-- 未触发震屏keyFrame list



	BAForKeyFramesAnimationTrigger.animationName 			= nil


	BAForKeyFramesAnimationTrigger.keyFrameCaller 			= nil -- 关键帧回调
	BAForKeyFramesAnimationTrigger.shakeFrameCaller 		= nil -- 震屏帧回调
	------------------ functions -----------------------
	function BAForKeyFramesAnimationTrigger:ctor()
		
		ObjectTool.setProperties(self)
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	
		self.keyFrameCaller			= require(BATTLE_CLASS_NAME.BattleForEverCallBacker).new()	
		self.shakeFrameCaller		= require(BATTLE_CLASS_NAME.BattleForEverCallBacker).new()	
		self.notExcutedFrame 		= {}
		self.notExcutedShakeFrame 	= {}
		-- --print("create BAForKeyFramesAnimationTrigger ")
	end

	function BAForKeyFramesAnimationTrigger:start(data)
		self.currentFrame								= 0
		self.totalFrame									= db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName)		-- todo load from db
		-- Logger.debug("BAForKeyFramesAnimationTrigger:totalFrame -> " .. self.animationName .. ":" .. self.totalFrame)
		self.currentTime								= 0
		self.totalTime									= BATTLE_CONST.FRAME_TIME * self.totalFrame
		self.isComplete									= false

		self.keyframes 									= db_BattleEffectAnimation_util.getAnimationKeyFrameArray(self.animationName)--{3,4,5} -- todo load from db

		self.totalKeyFrame								= db_BattleEffectAnimation_util.getAnimationTotalKeyFrames(self.animationName)		-- todo load from db
		-- --print("BAForKeyFramesAnimationTrigger:totalFrame -> ",self.totalKeyFrame)
		self.excutedKeyFrames							= 0
		if self.totalKeyFrame <= 0 then
			error("error:BAForKeyFramesAnimationTrigger keyframes <= 0")
		end

		self.shakeKeyframes 								= db_BattleEffectAnimation_util.getAnimationShakeKeyFrameArray(self.animationName)
		self.shakeTypes 									= db_BattleEffectAnimation_util.getShakeTypeArray(self.animationName)
		self.totalShakeFrameNum 							= #self.shakeKeyframes

		self:generateNotExcutedFrame()
		self:addToRender()
	end
	function BAForKeyFramesAnimationTrigger:generateNotExcutedFrame()
		self.notExcutedFrame							= {}
		self.totalKeyFrame 								= 0
		self.excutedKeyFrames							= 0
		-- 生成
		for i,v in ipairs(self.keyframes) do
			 table.insert(self.notExcutedFrame,v)
			 self.totalKeyFrame 						= self.totalKeyFrame + 1
		end


		self.notExcutedShakeFrame							= {}
		self.totalShakeKeyFrame 							= 0
		self.excutedShakeKeyFrames							= 0
		-- 生成
		for i,v in ipairs(self.shakeKeyframes) do
			 table.insert(self.notExcutedShakeFrame,v)
			 self.totalShakeKeyFrame 						= self.totalShakeKeyFrame + 1
		end

	end
	-- 处理关键帧,如果关键帧则会激活回调
	function BAForKeyFramesAnimationTrigger:handleKeyFrame()
		if(self.disposed ~= true) then
			if self.excutedKeyFrames <= self.totalKeyFrame then 
				for i,v in pairs(self.notExcutedFrame) do
					
					 if self.currentFrame >= tonumber(v) then 
					 	--v.excuted = true
					 	self.keyFrameCaller:runCompleteCallBack(self,math.floor(self.currentFrame))
					 	self.notExcutedFrame[i] = nil
					 	self.excutedKeyFrames = self.excutedKeyFrames + 1
					 	-- --print("BAForKeyFramesAnimationTrigger:handleKeyFrame :",v)
					 end -- if end
				end -- for end
			 
			end -- if end


			if self.excutedShakeKeyFrames <= self.totalShakeKeyFrame then 
				for i,v in pairs(self.notExcutedShakeFrame) do
					
					 if self.currentFrame >= tonumber(v) then 
					 	--v.excuted = true
					 	self.shakeFrameCaller:runCompleteCallBack(self,self.shakeTypes[i])
					 	self.notExcutedShakeFrame[i] = nil
					 	self.excutedShakeKeyFrames = self.excutedShakeKeyFrames + 1
					 	-- --print("BAForKeyFramesAnimationTrigger:handleKeyFrame :",v)
					 end -- if end
				end -- for end
			 
			end -- if end


		end
		
		
	end -- function end

	-- 更新函数
	function BAForKeyFramesAnimationTrigger:update(dt)
		self.currentTime 			= self.currentTime + dt
		self.currentFrame 			= self.currentFrame + dt/BATTLE_CONST.FRAME_TIME
		self:handleKeyFrame()
		-- 如果播放完
		if self.currentTime >= self.totalTime then
			-- --print("BAForKeyFramesAnimationTrigger play complete")
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
	function BAForKeyFramesAnimationTrigger:release(data)

		self.super.release(self)

		if self.calllerBacker then 
			self.calllerBacker:clearAll()
		end
		
		if self.keyFrameCaller then 
			self.keyFrameCaller:clearAll()
		end

		if self.shakeFrameCaller then 
			self.shakeFrameCaller:clearAll()
		end

		self.blackBoard 			= nil
	end 
return BAForKeyFramesAnimationTrigger
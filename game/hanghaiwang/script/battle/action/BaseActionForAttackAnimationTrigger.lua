
-- xml攻击动画的trigger


require (BATTLE_CLASS_NAME.class)
local BaseActionForAttackAnimationTrigger = class("BaseActionForAttackAnimationTrigger",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BaseActionForAttackAnimationTrigger.animationName 					= nil -- 动画名称
	BaseActionForAttackAnimationTrigger.keyFramesTriger					= nil

	------------------ functions -----------------------
	function BaseActionForAttackAnimationTrigger:start(data)
		--print(" BaseActionForAttackAnimationTrigger:start")
		if self.blackBoard ~= nil and tonumber(self.blackBoard.skill) > 0 then
			local skill = self.blackBoard.skill
			local attackName  = db_skill_util.getSkillActionName(tonumber(skill))
			if attackName ~= nil then
				-- 生成 triger
				-- 添加 triger 回调
			 	self.keyFramesTriger 						= require(BATTLE_CLASS_NAME.BaseActionForKeyFramesTrigger).new()

			 	self.keyFramesTriger.animationName 			= attackName

			 	--print("BaseActionForAttackAnimationTrigger animation :",attackName)
			 	
			 	-- 设置triger为handMode
			 	self.keyFramesTriger.handMode 				= true
 				-- 添加keyFrame
 				self.keyFramesTriger.keyFrameCaller.addCallBacker(self.keyFramesTriger.keyFrameCaller,self,self.onKeyFrame)
				self.keyFramesTriger:start()

				self.hasKeyFrame							= self.keyFramesTriger.totalKeyFrame > 0
				self:addToRender()
			 end -- if end
		else-- 退出
			--print(" BaseActionForAttackAnimationTrigger:start error")
			self:complete()
		end
	end

	function BaseActionForAttackAnimationTrigger:onKeyFrame()
		-- 当前关键帧
		-- self.keyFramesTriger.excutedKeyFrames
		-- 总关键帧
		-- self.keyFramesTriger.totalKeyFrame
		self.keyFramesTriger:release()
		self:sendSkillMessage()

		-- 发送技能信息
	end
	function BaseActionForAttackAnimationTrigger:sendSkillMessage()
	--print("BaseActionForAttackAnimationTrigger:sendSkillMessage")
		EventBus.sendNotification(NotificationNames.EVT_EXCUTE_SKILL,self.blackBoard)
	end
		-- 更新函数
	function BaseActionForAttackAnimationTrigger:update(dt)
		-- 更细 triger
		self.keyFramesTriger:update(dt)
		
		-- 判断是否播完
		 if self.keyFramesTriger.isComplete then
		 	-- 如果没有关键帧,在动画结束的时候触发伤害
		 	if self.hasKeyFrame == false then 
		 		self:sendSkillMessage()
		 	end
		 	self:complete()
		 end

	end

		-- 释放函数
	function BaseActionForAttackAnimationTrigger:release(data)
		-- self.keyFramesTriger:release()
		-- self.calllerBacker:clearAll()
		-- self.blockBoard	= nil
	end 

return BaseActionForAttackAnimationTrigger
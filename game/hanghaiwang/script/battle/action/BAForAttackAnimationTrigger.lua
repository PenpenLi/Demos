
--  动画的trigger
require (BATTLE_CLASS_NAME.class)
local BAForAttackAnimationTrigger = class("BAForAttackAnimationTrigger",require(BATTLE_CLASS_NAME.BaseAction))


 
	------------------ properties ----------------------
	BAForAttackAnimationTrigger.animationName 					= nil -- 动画名称
	BAForAttackAnimationTrigger.keyFramesTriger					= nil

	------------------ functions -----------------------
	function BAForAttackAnimationTrigger:start(data)

		-- --print(" BAForAttackAnimationTrigger:start")
		if self.blackBoard ~= nil and tonumber(self.blackBoard.skill) > 0 and self:isOK() then
			local skill = self.blackBoard.skill
			local attackName  = self.blackBoard.attackAnimation
			-- db_skill_util.getSkillActionName(tonumber(skill))
			if attackName ~= nil then
				-- 生成 triger
				-- 添加 triger 回调
			 	self.keyFramesTriger 						= require(BATTLE_CLASS_NAME.BAForKeyFramesAnimationTrigger).new()

			 	self.keyFramesTriger.animationName 			= attackName

			 	-- --print("BAForAttackAnimati onTrigger animation :",attackName)
			 	
			 	-- 设置triger为handMode
			 	self.keyFramesTriger.handMode 				= true
 				-- 添加keyFrame
 				self.keyFramesTriger.keyFrameCaller:addCallBacker(self,self.onKeyFrame)
				self.keyFramesTriger:start()

				self.hasKeyFrame							= self.keyFramesTriger.totalKeyFrame > 0
				self:addToRender()
			-- 如果攻击动作是空,则立即结束
			else
				self:sendSkillMessage()
				self:complete()
			end -- if end
		else-- 退出
			--print(" BAForAttackAnimationTrigger:start error")
			self:complete()
		end
	end

	function BAForAttackAnimationTrigger:onKeyFrame()
		-- 当前关键帧
		-- self.keyFramesTriger.excutedKeyFrames
		-- 总关键帧
		-- self.keyFramesTriger.totalKeyFrame
		-- --print("")
		if(self.disposed ~= true) then
			self.keyFramesTriger:release()
			self:sendSkillMessage()
		end
		-- 发送技能信息
	end
	function BAForAttackAnimationTrigger:sendSkillMessage()
	if(self.disposed ~= true) then
		-- Logger.debug("BAForAttackAnimationTrigger:sendSkillMessage")
		-- EventBus.sendNotification(NotificationNames.EVT_EXCUTE_SKILL,self.blackBoard)
		if(self.blackBoard and self.blackBoard.EVT_EXCUTE_SKILL ~= nil) then
			-- print("---- BAForAttackAnimationTrigger send",self.blackBoard.EVT_EXCUTE_SKILL)
			EventBus.sendNotification(self.blackBoard.EVT_EXCUTE_SKILL,self.blackBoard)
		else
			EventBus.sendNotification(NotificationNames.EVT_EXCUTE_SKILL,self.blackBoard)
		end
		 --BattleSkillModule.pushSkill(self.blackBoard)
	end

	end
		-- 更新函数
	function BAForAttackAnimationTrigger:update(dt)

		if(self.disposed ~= true) then
			-- 更细 triger
			self.keyFramesTriger:update(dt)
			
			-- 判断是否播完
			 if self.keyFramesTriger.isComplete then
			 	-- --print("BAForAttackAnimationTrigger:update isComplete = true")
			 	-- 如果没有关键帧,在动画结束的时候触发伤害
			 	if self.hasKeyFrame == false then 
			 		self:sendSkillMessage()
			 	end
			 	-- --print("BAForAttackAnimationTrigger:complete")
			 	self:complete()
			 end
		else
			-- error("BAForAttackAnimationTrigger:update disposed")
			self:release()
		end

	end

		-- 释放函数
	function BAForAttackAnimationTrigger:release(data)

		self.super.release(self)

		if(self.calllerBacker ~= nil ) then 
			self.calllerBacker:clearAll()
		end

		if(self.keyFramesTriger ~= nil ) then
			self.keyFramesTriger:release()
		end
		
		self.blockBoard	= nil
		-- self.keyFramesTriger:release()
		-- self.calllerBacker:clearAll()
		-- self.blockBoard	= nil
	end 

return BAForAttackAnimationTrigger
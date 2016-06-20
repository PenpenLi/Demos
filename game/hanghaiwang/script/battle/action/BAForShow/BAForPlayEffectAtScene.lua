
 -- 场景指定点(敌方中点,屏幕中点,我方中点)
local BAForPlayEffectAtScene = class("BAForPlayEffectAtScene",require(BATTLE_CLASS_NAME.BaseAction))

	------------------ properties ----------------------
	BAForPlayEffectAtScene.data 						= nil -- 外部数据
	BAForPlayEffectAtScene.showEffectName 				= nil -- 特效名称
	BAForPlayEffectAtScene.playPostionIndex 			= nil -- 特效位置索引点(0:敌方中点,1:屏幕中央,2:我方中点)
	BAForPlayEffectAtScene.animation 					= nil -- 动画
	------------------ functions -----------------------
	
	function BAForPlayEffectAtScene:start( ... )
		if(self.data and #self.data == 2) then
			--最后一个位置为特效名称
			self.showEffectName = self.data[2]
			self.playPostionIndex = self.data[1]
			local postion
			if(self.playPostionIndex == 0) then
				postion = BattleGridPostion.getEnemyPointByIndex()
			elseif(self.playPostionIndex == 2) then
				postion = BattleGridPostion.getSelfTeamCenterPostion()
			else
				postion = BattleGridPostion.getCenterScreenPostion()
			end

			self.animation = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
			self.animation.postionX = postion.x
			self.animation.postionY = postion.y
			self.animation.animationName = self.showEffectName
			self.animation:addCallBacker(self,self.onEffectComplete)
			self.animation:start()

		else
			self:complete()
		end
	end


	function BAForPlayEffectAtScene:onEffectComplete( ... )
		self:complete()
	end

	function BAForPlayEffectAtScene:release( ... )
		ObjectTool.removeObject(self.animation)
		self.animation = nil
		self.showEffectName = nil
		self.data = nil
		self.super.release(self)
	end

return BAForPlayEffectAtScene
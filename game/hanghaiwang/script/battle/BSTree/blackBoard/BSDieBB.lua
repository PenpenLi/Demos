

 -- 死亡
require (BATTLE_CLASS_NAME.class)
local BSDieBB = class("BSDieBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
  
 	------------------ properties ----------------------
 	BSDieBB.targetData 				= nil -- 死亡英雄数据
 	BSDieBB.targetUI 				= nil -- 死亡英雄的显示类
 	BSDieBB.isMonster 				= nil -- 是否是怪物
  	BSDieBB.isHero 					= nil -- 是否是怪物
  	BSDieBB.dropNum 			 	= nil -- 掉落数量
 	
 	BSDieBB.heroWillDropItem 		= false -- 英雄是否掉落
 	BSDieBB.playDropAnimation 		= true  -- 播放死亡掉落动画(调过战斗不需要播放掉落动画)
 	BSDieBB.fentouEffectName 		= BATTLE_CONST.EFFECT_DIE_1 -- 坟头动画
 	BSDieBB.fentou1EffectName 		= BATTLE_CONST.EFFECT_DIE_2 --BATTLE_CONST.EFFECT_FEN -- 坟头动画
 	BSDieBB.loopFenTou      		= false --BATTLE_CONST.EFFECT_FEN -- 坟头动画
 	BSDieBB.ghostFireEffectName 	= BATTLE_CONST.EFFECT_GUIHUO -- 鬼火动画名字
 	BSDieBB.dropAnimationName 		= BATTLE_CONST.EFFECT_DIAOLUO-- 掉装动画
 	BSDieBB.dieAnimationName 		= BATTLE_CONST.XML_ANI_DIE_HERO_DIE -- 死亡xml动画
 	BSDieBB.des 					= "死亡"
 	BSDieBB.ghostPostionAt 			= BATTLE_CONST.POS_MIDDLE
 	-- BSDieBB.dropEventName 			= NotificationNames.EVT_UI_REFRESH_RESOURCE
 	BSDieBB.dieEffectName 			= BATTLE_CONST.EFFECT_DIE
 	BSDieBB.dieEffectKeyFrame 		= nil -- 死亡冒烟动画关键帧
 	BSDieBB.dieXMLKeyFrame			= nil
 	BSDieBB.chestEvent 				= NotificationNames.EVT_CHEST_ADD
 	BSDieBB.dropItemShineName		= nil --= BATTLE_CONST.BATTLE_DROP_SHINE_NAME
 	BSDieBB.dropEventDelay			= 5					-- 掉落物品发送事件延迟
 	BSDieBB.fenTouFrames			= nil -- 坟头动画总帧数(用于延迟)

 	BSDieBB.targetX 				= nil
 	BSDieBB.targetY					= nil
 	BSDieBB.kickOut					= nil
 	BSDieBB.actionDie 				= nil
 	BSDieBB.isShowGraveStone 		= true -- 2015.9.14 曾铮需求:由于未通过审核,墓碑动画暂时不播
 										   -- 2015.10.14 需求变更 开启
 	------------------ functions -----------------------
 	function BSDieBB:reset( target ,play , skill)
 		if(target ~= nil ) then
 			if(play == nil) then
 				play = true
 			end
 			self.targetData			= target
 			self.playDropAnimation  = play
 			self.targetUI 			= target.displayData
 			


 			-- 张 翕伦  
			-- 夺宝，竞技场，竞技场王者对决，爬塔，以上战斗的战报，在双方伙伴死亡后，都显示墓碑特效
			-- 普通副本，精英副本，活动副本，世界BOSS，只显示我方伙伴的墓碑特效，怪物不显示
 
 			if(
 				BattleMainData.winType == BATTLE_CONST.WINDOW_ROB 			 or
 				BattleMainData.winType == BATTLE_CONST.WINDOW_ARENA 		 or
 				BattleMainData.winType == BATTLE_CONST.WINDOW_SEA_PIEA 		 or
 				BattleMainData.winType == BATTLE_CONST.WINDOW_ARENA_BILLBOARD
 			  ) then

 				self.isMonster 			= false
 			else
 			
 				self.isMonster 			= target.isPlayer == false
 			end
 			if(skill == nil or skill <= 0) then
 				self.kickOut 			= false -- 是否踢飞
 				self.actionDie 			= true
 			else
 				local dieActionType    	= db_skill_util.getDieActionType(skill)
	 			if(dieActionType == nil or dieActionType == BATTLE_CONST.DIE_ACTION) then
	 				self.kickOut 			= false -- 是否踢飞
	 				self.actionDie 			= true
	 			else
	 				self.kickOut 			= true -- 是否踢飞
	 				self.actionDie 			= false
	 			end
 			end
 			
 			-- self.kickOut 			= true -- 是否踢飞
	 		-- self.actionDie 			= false
	 		-- 如果是不需要播放动画的那么就默认
	 		if(play ~= true) then
	 			self.kickOut 			= false-- 是否踢飞
	 			self.actionDie 			= true 
	 		end
 			-- self.kickOut 			= false -- 是否踢飞
 			-- self.kickOut 			= true -- 是否踢飞
 			-- self.actionDie 			= false
			-- 如果是踢飞 我们不需要延迟播放坟头 和 掉落 直接执行即可 			
 			if(self.kickOut == true) then
 				self.dieXMLKeyFrame 	= 0 
 			else
 				self.dieXMLKeyFrame 	= 13 * BATTLE_CONST.FRAME_TIME
 			end


 			self.isHero				= target.isPlayer
 			self.willDropItem 		= target.willDropItem
 			self.dropNum			= target.dropItemNum
 			self.fenTouFrames		= db_BattleEffectAnimation_util.getAnimationTotalFrame(self.fentouEffectName) * 1.1/60

 			-- 读取 死亡冒烟动画关键帧,美术要求 冒烟关键帧 触发鬼魂动画
 			local keyFrames			= db_BattleEffectAnimation_util.getAnimationKeyFrameArray(self.dieEffectName) 
 			if(keyFrames and keyFrames[1]) then
 				self.dieEffectKeyFrame = tonumber(keyFrames[1])/60
 			else
 				self.dieEffectKeyFrame = 1/60
 			end
 					-- todo load from db
			
			local centerPosition 	= self.targetUI:globalCenterPoint()
			self.targetX 			= centerPosition.x
			self.targetY 			= centerPosition.y
			-- print("== fenTouFrames:",self.fenTouFrames)
 			if(self.willDropItem == true) then
 				self.dropItemShineName = BATTLE_CONST.BATTLE_DROP_SHINE_NAME
 			end
 			-- print("== die:",self.isMonster,self.willDropItem,self.dropItemShineName)
 			-- self.itemInfo			= target:popAll()
 		else
 			error(" BSDieBB:reset target is nil")
 		end
 	end

 return BSDieBB

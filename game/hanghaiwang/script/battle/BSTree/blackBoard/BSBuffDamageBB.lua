	

-- buff删除
require (BATTLE_CLASS_NAME.class)
local BSBuffDamageBB = class("BSBuffDamageBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 

 		------------------ properties ----------------------
  		BSBuffDamageBB.damageEffectName 				= nil -- buff伤害特效名字
  		BSBuffDamageBB.hasDamageAnimation 				= nil -- 
  		BSBuffDamageBB.des								= "BSBuffDamageBB"
  		BSBuffDamageBB.willDie 							= false
  		BSBuffDamageBB.showZero 						= true
  		BSBuffDamageBB.hasHpDamage 						= nil
  		BSBuffDamageBB.willNearDeath 					= nil
  		BSBuffDamageBB.rageUp							= nil
  		-- BSBuffDamageBB.showZeroSign 					= nil -- 是否
 		------------------ functions -----------------------
 		
 		function BSBuffDamageBB:refresh()
 			 self:refreshDeathState()

 		end
		function BSBuffDamageBB:reset( data ) --BattleBuffDamage



		local buffDamage 	= require(BATTLE_CLASS_NAME.BattleBuffDamage).new()
 

		local buffid 						= data.id 			-- 获取buffid
		 -- 是否有buff伤害特效

		 local damageEffName 				= db_buff_util.getDamageEffectName(buffid)
		 --print("BuffHurtLogic:getBlackBoard  damageEffName:",damageEffName)
		 self.damageEffectName 				= damageEffName
		 self.hasDamageAnimation 			= damageEffName ~= nil	


		 -- 伤害数值
		 self.hasDamage 					= data:hasDamage()			-- 是否有伤害信息
		 self.hasHpDamage 					= data.hpChange or false 	-- 是否有hp伤害
		 self.hasRageDamage 				= data.rageChang or false 	-- 是否有怒气伤害

		 -- print("hasHpDamage:",self.hasHpDamage,data.hpDamage)
		 -- print("hasRageDamage:",self.hasRageDamage)

		 -- 人物动作
		 local hasBuffAction 				= false
		 self.hasBuffAction 				= hasBuffAction
		 self.damageActionName 	 			= BATTLE_CONST.ANIMATION_BUFFER

		 self.showHpSign 						= false -- 显示血量正负号
		 if(self.hasHpDamage) then
		 	-- 如果是加血
		 	if(data.hpDamage > 0) then
		 		self.hasBuffAction 			= false
		 		self.showHpSign 			= true
		 		--print("----- showHpSign")
		 		
		 	else
		 		self.damageActionName 		= BATTLE_CONST.ANIMATION_BUFFER
		 	end
		 	--print(data.hpDamage)
		 end

		 if(self.hasRageDamage) then

		 	self.rageDamage 				= data.rageDamage
		 	--print("self.rageDamage:",self.rageDamage)
		 	self.rageUp = data.rageUp
		 	-- if(data.rageDamage > 0) then -- 
		 	
		 	-- else
		 		
		 	-- end

		 	self.buffChangeEffect 			= "meffect_14"

		 end	 

		 self.buffDamageTitle 				= db_buff_util.getDamageTitle(buffid)
		 -- if(blackBoard.buffDamageTitle ~= nil ) then 
		 -- 	blackBoard.hasDamageTitle 		= true
		 -- 	blackBoard.buffDamageTitle 		= BattleURLManager.getNumberURL(buffid)
		 -- end
		 -- --print("BuffHurtLogic buffDamageTitle:",self.buffDamageTitle)
		 self.hpNumberColor 				= BattleDataUtil.getHpNumberColor(data.hpDamage)--"red"						-- 数字颜色
		 self.hpDamage 						= data.hpDamage or 0			-- 总伤害

		 -- buff释放对象
		 local targetId 					= data.targetId
		 local target 						= BattleMainData.fightRecord:getTargetData(targetId)
		 self.target 						= target
		 self.attackerUI 					= target.displayData
		 -- buff数据
		 self.data 							= data
		 

 		 self:refreshDeathState()

 		 -- self.willDie						= self.target:willDie(data.hpDamage)
 		 -- Logger.debug("hero:%d hp:%d damage:%d",self.target.id,self.target.currHp,data.hpDamage)
	end

	function BSBuffDamageBB:refreshDeathState( ... )
		if(self.target and self.data) then
			self.willNearDeath 					= self.target:willNearDeath(self.data.hpDamage)	
	 		if(self.willNearDeath == true) then
	 			self.willDie 						= false
	 		else
	 			self.willDie						= self.target:willDie(self.data.hpDamage)
	 		end	
	 	end
	end

	function BSBuffDamageBB:getBlackBoard(data) -- data BattleBuffDamage

		local blackBoard 					= {}
		local buffid 						= data.id 			-- 获取buffid
		 -- 是否有buff伤害特效

		 local damageEffName 				= db_buff_util.getDamageEffectName(buffid)
		 -- --print("BuffHurtLogic:getBlackBoard  damageEffName:",damageEffName)
		 blackBoard.damageEffectName 		= damageEffName
		 blackBoard.hasDamageAnimation 		= damageEffName ~= nil	

		 -- 人物动作
		 local hasBuffAction 				= false
		 blackBoard.hasBuffAction 			= hasBuffAction
		 blackBoard.damageActionName 	 	= BATTLE_CONST.ANIMATION_BUFFER

		 -- 伤害数值
		 blackBoard.hasDamage 				= data:hasDamage()			-- 是否有伤害信息
		 blackBoard.hasHpDamage 			= data.hpChange or false 	-- 是否有hp伤害
		 blackBoard.hasRageDamage 			= data.rageChang or false 	-- 是否有怒气伤害
		 if(blackBoard.hasRageDamage) then

		 	blackBoard.rageDamage 			= data.rageDamage
		 	if(data.rageDamage > 0) then -- 
		 		
		 	else
		 		
		 	end

		 	blackBoard.buffChangeEffect 	= "meffect_14"

		 end	 

		 -- blackBoard.buffDamageTitle 		= db_buff_util.getDamageTitle(buffid)
		 blackBoard.buffDamageTitle 		= db_buff_util.getDamageTip(buffid)
		 -- if(blackBoard.buffDamageTitle ~= nil ) then 
		 -- 	blackBoard.hasDamageTitle 		= true
		 -- 	blackBoard.buffDamageTitle 		= BattleURLManager.getNumberURL(buffid)
		 -- end
		 --print("BuffHurtLogic buffDamageTitle:",blackBoard.buffDamageTitle)
		 blackBoard.hpNumberColor 			= "red"						-- 数字颜色
		 blackBoard.hpDamage 				= data.hpDamage 			-- 总伤害

		 -- buff释放对象
		 local targetId 					= data.targetId
		 local target 						= BattleMainData.fightRecord:getTargetData(targetId)
		 blackBoard.attackerUI 				= target.displayData
		 -- buff数据
		 blackBoard.data 					= data
		 return blackBoard

	end
		
return BSBuffDamageBB
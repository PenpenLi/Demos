

local BattlPlayerDisplay = class("BattlPlayerDisplay")
	

	--人物动画类 封装了人物基础行为
	-- todo 动画替换怎么处理？
	-- todo	显示类的选择
	-- todo	回调和通知怎么发送？

-- 美术总是会问卡牌挂点,无奈... 加个注释吧 	
-- (0,0)点为左下角,卡牌为带阴影卡牌
-- 脚底点= (卡牌宽度/2,卡牌高度* 0.15 + 15)
-- 中心点= (卡牌宽度/2,卡牌高度* 0.55 + 15)
-- 头顶点= (卡牌宽度/2,卡牌高度* 0.85 + 15)

-- 2015.12.3
-- 去掉了卡牌框,只保留了底端,因此卡牌边框size需要读表

	------------------ properties ----------------------
	--人物模型资源名称
	BattlPlayerDisplay.materialName 		= nil
	-- 卡牌
	BattlPlayerDisplay.cardAnimations		= nil -- 动画容器
	-- 人物
	BattlPlayerDisplay.heroImg				= nil
 
	BattlPlayerDisplay.nameLabel			= nil
 

	--hp ui
	BattlPlayerDisplay.hpBaseBar			= nil
 
	-- 怒气条
	BattlPlayerDisplay.rageBar 				= nil


	BattlPlayerDisplay.data					= nil -- BattlePlayuerData
	--玩家原始位置
	BattlPlayerDisplay.rawPositon			= nil	-- 原始位置
	--当前动画
	-- BattlPlayerDisplay.currentAnimation		= nil
 
 	--撞击y偏移
 	BattlPlayerDisplay.impactY				= nil
 
	-- buff列表
	BattlPlayerDisplay.buffList				= nil
	BattlPlayerDisplay.buffCount				= nil

	-- 玩家容器
	BattlPlayerDisplay.container			= nil
	BattlPlayerDisplay.cardRectange  		= nil
	BattlPlayerDisplay.isGhostState			= nil
	BattlPlayerDisplay.x4RageBack 			= nil
	-- BattlPlayerDisplay.actionRunningList 	= nil 							-- 动作执行队列

	-- BattlPlayerDisplay.currentAction		= nil 								-- 当前执行action

	-- BattlPlayerDisplay.actionRunner 		= nil 								-- 动作执行队列

	BattlPlayerDisplay.cardRawState 		= nil 	-- 卡片原始数据
	BattlPlayerDisplay.revertAnimation		= nil -- 是否反转动画
	BattlPlayerDisplay.extEffectList 		= nil
	BattlPlayerDisplay.actionCallBacker		= nil
	BattlPlayerDisplay.xmlActionCallList 	= nil
	BattlPlayerDisplay.isPlayAction			= nil
	BattlPlayerDisplay.animationName 		= nil
	BattlPlayerDisplay.cardBackSize			= nil   -- 空卡片size
	BattlPlayerDisplay.isDead				= nil
 	BattlPlayerDisplay.disposed 			= nil


 	BattlPlayerDisplay.animationBone		= nil
 	BattlPlayerDisplay.boneBinder 			= nil -- 骨骼绑定容器
	------------------ functions -----------------------
	function BattlPlayerDisplay:ctor()
	    -- --print("create BattlPlayerDisplay")
 		self.buffList 			= {}
 		self.buffCount 			= {}
 		self.extEffectList  	= {}
 		self.rawPositon 		= {x=0,y=0} 
 		self.animationName 		= ""
 		self.revertAnimation 	= false
 		self.isPlayAction 		= false
 		self.impactY 			= 0
 		self.actionCallBacker 	= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
 		self.xmlActionCallList 	= {}
 		ObjectTool.setProperties(self)
	end
	function BattlPlayerDisplay:isMoved( ... )
		if(math.abs(self.container:getPositionX() - self.rawPositon.x) < 1 and 
		   math.abs(self.container:getPositionY() - self.rawPositon.y) < 1) then
			return false
		end
		return true
	end

	function BattlPlayerDisplay:toStartState( ... )
		self:normalState()
		self:removeAllBuff()
		self.buffList 			= {}
		self.buffCount 			= {}
 		self.extEffectList  	= {}
	end

	function BattlPlayerDisplay:diedState( ... )
		if(self.boneBinder) then
			local myNode 					= tolua.cast(self.boneBinder,"CCNode")
			myNode:setVisible(false)
			myNode:stopAllActions()
		end

		self.hpBaseBar:setVisible(false)
		self.rageBar:setVisible(false)

		 local animation = ObjectTool.getAnimation(BATTLE_CONST.EFFECT_DIE_2,true)
	     animation:setAnchorPoint(CCP_HALF)

		self:addExtEffectAt(animation,BATTLE_CONST.POS_MIDDLE)
	end
	
	function BattlPlayerDisplay:ghostState( ... )

		-- print("== ghostState1")
		if(self.isGhostState ~= true) then
			-- print("== ghostState2")
			self:toRawZOder()
			-- 删除特效
			-- 显示牌内容
			-- 增加闪烁特效 
			self:removeAllExtEffect()
			self.container:setVisible(true)

			self.hpBaseBar:setVisible(false)
			self.rageBar:setVisible(false)


			if(self.boneBinder) then
				local myNode 					= tolua.cast(self.boneBinder,"CCNode")
				myNode:setVisible(true)
				myNode:stopAllActions()
			end

			local shineAction = CCArray:create()
	        shineAction:addObject(CCFadeOut:create(0.5))
	        shineAction:addObject(CCFadeIn:create(0.5))
	        self.container:stopAllActions()
	        self.container:runAction(CCRepeatForever:create(CCSequence:create(shineAction)))

	        -- 复活翅膀动画
	        local animation = ObjectTool.getAnimation(BATTLE_CONST.EFFECT_REVIVED,true)
	        animation:setAnchorPoint(CCP_HALF)
	        -- self.animation:setPosition(postion.x,postion.y);
	 		self:addExtEffectAt(animation,BATTLE_CONST.POS_MIDDLE)
	   		-- local animation = require(BATTLE_CLASS_NAME.BattleAnimation).new()
			
			-- animation:setAnchorPoint(ccp(0.5, 0));
			-- self.animation:retain()
			-- self.animation:setPosition(postion.x,postion.y);
			-- self:addExtEffectAt(animation,BATTLE_CONST.POS_MIDDLE)
			-- animation:createAnimation(BATTLE_CONST.EFFECT_REVIVED,true)
	 		self.isGhostState = true
	 		self.isDead		  = true
	 	end

	end

	function BattlPlayerDisplay:deadState( ... )
		-- 删除所有buff
		-- 删除所有额外特效
		-- 添加坟头动画
		-- 坟头动画跳转到最后一帧停止
		
	end
	function BattlPlayerDisplay:shineState( ... )
		if(self.container and self:isOnStage()) then
			local shineAction = CCArray:create()
	        shineAction:addObject(CCFadeOut:create(0.5))
	        shineAction:addObject(CCFadeIn:create(0.5))
	        self.container:stopAllActions()
	        self.container:runAction(CCRepeatForever:create(CCSequence:create(shineAction)))
	    end
	end
	function BattlPlayerDisplay:normalState( ... )
		-- --print("normalState call")
		-- Logger.debug( "++++++++++++++++++ normalState:" .. self.animationName)
		self:removeAllExtEffect()

		self.container:setVisible(true)


		

		self.container:stopAllActions()
		self.isGhostState = false
		self.container:setOpacity(255)
		self.cardAnimations:setVisible(false)
		self:toRawPosition()
		local myNode 					= tolua.cast(self.boneBinder,"CCNode")
		myNode:setVisible(true)
		self.isDead  	= false

		local animation = tolua.cast(self.cardAnimations,"CCArmature")
		animation:getAnimation():play("A009", -1, -1, 0)
		self.cardAnimations:getAnimation():gotoAndPause(1)
		self.boneBinder:setColor(self.cardRawState.color)


		-- 如果是无边框,怒气和血量不需要显示
		if(self.data and self.data.isOutline == true) then
 			self.rageBar:setVisible(false)
 			self.hpBaseBar:setVisible(false)
 		else
 			self.hpBaseBar:setVisible(true)
			self.rageBar:setVisible(true)
 		end

	end

	function BattlPlayerDisplay:setRotation( value )
		-- self.boneBinder:setOpacity(value)
		if(self.boneBinder) then
			self.boneBinder:setExtRotation(value)
		end
	end

	function BattlPlayerDisplay:getRotation()
		if(self.boneBinder) then
			return self.boneBinder:getRotation()
		end
	end

	function BattlPlayerDisplay:setColor( r,g,b )
		if(self.boneBinder) then
			-- local rgbNode 				= tolua.cast(self.cardAnimations,"CCNodeRGBA")
			self.boneBinder:setExtRGB(r,g,b)
		end
				-- :setColor(ccc3(255, 255, 255))
	end
	function BattlPlayerDisplay:toRawPosition( ... )
		if(self.container and self.rawPositon) then
			self.container:setPosition(self.rawPositon.x,self.rawPositon.y)
		end
		self:setColor(0,0,0)
		self:setRotation(0)
	end

	function BattlPlayerDisplay:toZOder( value )
		if(self.boneBinder ) then
			self.boneBinder:setZOrder(value)
		end
	end
	function BattlPlayerDisplay:getZOrder( ... )
		if(self.boneBinder) then
			return self.boneBinder:getZOrder()
		end
		return 0
	end
	function BattlPlayerDisplay:getOrderOfArrival( ... )
		if(self.boneBinder ) then
			return self.boneBinder:getOrderOfArrival()
		end
		return 0
	end


	function BattlPlayerDisplay:toRawZOder( ... )
		if(self.boneBinder and self.data) then
			self.boneBinder:setZOrder(self.data.zOder)
		end

	end

	function BattlPlayerDisplay:getRawZOder( ... )
		if(self.data) then
			return  self.data.zOder
		end
		return 0
	end
	-- 可复活状态
	function BattlPlayerDisplay:canReviveState( ... )
		-- 向extEffect中添加翅膀特效
		-- self:removeAllExtEffect()
		-- self.container:setVisible(true)
	
	end

 

	-- todo 释放工作
	function BattlPlayerDisplay:addExtEffectAt( target ,postionIndex)
		assert(target)
		assert(postionIndex)
		
			local postion  
            if(postionIndex == BATTLE_CONST.POS_FEET) then
           		
           		postion = self:feetPoint()
           		-- --print("BAForAddEffectAtHero is feet:",postion.x," ",postion.y)

            elseif (postionIndex == BATTLE_CONST.POS_HEAD)then
            	postion = self:headPoint()

            elseif (postionIndex == nil or  postionIndex == BATTLE_CONST.POS_MIDDLE)then

            	postion = self:centerPoint()
            end

            target:setPosition(postion.x,postion.y)
			-- local globalPos = self.container:convertToWorldSpace(ccp(postion.x ,postion.y ))               
            -- target:setPosition(postion.x,postion.y + self.cardRectange.height * 0.25)
 			-- print("========== addExtEffectAt:", tostring(globalPos.x) .. ","  .. tostring(globalPos.y), " index:",postionIndex)
   		self.container:addChild(target)
		-- self.boneBinder:addChild(target)
		self.extEffectList = self.extEffectList or {}
		table.insert(self.extEffectList,target)
		-- table.insert(self.extEffectList,target)
	end
 	function BattlPlayerDisplay:rageBarChangeBy( value )
 		self.rageBar:setValue(value)
 	end

 	function BattlPlayerDisplay:hpBarChangeBy( value )
 		self.hpBaseBar:setValue(value)
 	end

	function BattlPlayerDisplay:die( ... )
		if(self:isOnStage() ~= true) then
			return 
		end
		self.isDead = true
		if(self.cardAnimations) then
			self.cardAnimations:setVisible(false)
		end
		if(self.boneBinder) then
			local myNode 					= tolua.cast(self.boneBinder,"CCNode")
			myNode:setVisible(false)
			myNode:stopAllActions()
		end
	end

	function BattlPlayerDisplay:setVisible( value )
		self.container:setVisible(value)
		self.boneBinder:setVisible(value)
		
	end
	-- 设置显示等级(0全部显示,1不显示卡牌,2都不显示)
	function BattlPlayerDisplay:setVisibleWithLevel(level,value)
		 if(level == 1) then
		 	self.heroImg:setVisible(value)
		 elseif(level == 2) then
		 	 self:setVisible(value)
		 -- else
		 -- 	 self:setVisible(true)
		 end
	end

	function BattlPlayerDisplay:setOpacity( value )
		self.boneBinder:setOpacity(value)
	end
	function BattlPlayerDisplay:setBarsVisiable( value )
		self.rageBar.container:setVisible(value)
	end
	-- function BattlPlayerDisplay( ... )
	-- 	
	-- end
	function BattlPlayerDisplay:isPlaying( ... )
		return self.isPlayAction
	end

	function BattlPlayerDisplay:stopAction( ... )
		if(self.currentAnimation~= nil ) then 
			self.currentAnimation:complete()
		end
	end

	function BattlPlayerDisplay:runCalls( ... )
		for i=1,#self.xmlActionCallList do
				 self.xmlActionCallList[i]()
				 -- table.remove(self.xmlActionCallList, i) 
		end	
		for i=1,#self.xmlActionCallList do
				 table.remove(self.xmlActionCallList, i) 
		end	
	end
	function BattlPlayerDisplay:playXMLAnimationWithCallBack( nextAnimationName,target,callFunction,loop)
	 	
	 	if(self:isOnStage() ~= true) then
	 		if(callFunction) then
	 			callFunction()
	 		end
	 		return
	 	end
	 	 -- Logger.debug("last:".. tostring(self.animationName) .. " nextAnimationName:" .. nextAnimationName)
		 self.animationName  = nextAnimationName
		-- 如果当前正在播放,那么需要强制停止当前
		-- if(self.isPlayAction == true) then
		
		
		-- end
		-- self.actionCallBacker:runCompleteCallBack(self)
		-- self.actionCallBacker:clearAll()
		self:stop()
		-- self.actionCallBacker 	= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
		
		-- 添加新的回调
		-- self:runCalls()
		-- self.actionCallBacker:addCallBacker(target,callFunction)
		-- table.insert(self.xmlActionCallList,callFunction)
		if(self.xmlCallPacker ~= nil) then
			 
			self.xmlCallPacker("over call")
			self.xmlCallPacker = nil
			self:resetCardState()
		end
		self.isPlayAction 	=  true

		

		self.xmlCallPacker = callFunction

		local complete = function ( endAnimationName,sender )
		 
			-- if(self.container and 
			--    self.animationName == animationName) then
			-- if(self.container) then 
				-- self.actionCallBacker:runCompleteCallBack(self)
				-- self.actionCallBacker:clearAll()
				-- Logger.debug(tostring(endAnimationName) .. " xxxxxx endCall:" .. nextAnimationName)
				-- Logger.debug(tostring(self.animationName) .. " xxxxxx endCall:" .. nextAnimationName)
				if(callFunction ~= nil) then
					callFunction()
					callFunction = nil
				end
				-- self.animationName = nil
				self.isPlayAction = false
				if(self.cardAnimations) then
					self.animationBone = self.cardAnimations:getBone("kapian")
					self.animationBone:setPosition(0,0)
				end
				if(self.cardAnimations) then
					self.boneBinder:setPosition(self.cardAnimations:getPositionX(),self.cardAnimations:getPositionY())
				end
				
				-- self:resetCardState()
				self.xmlCallPacker = nil
			-- end	
			-- end
			-- self:onXMLAnimationComplete()
			-- self:setBarsVisiable(true)
		end
		 
 
		
		
		-- 应策划需求:同一个action动画可以有不同的关键帧配置
		-- 			所以这里采用映射动作方式来实现
		local reflectAni = db_BattleEffectAnimation_util.getReflectionAction(nextAnimationName)
		if(reflectAni ~= nil) then
			nextAnimationName = reflectAni
		end
		self:playXMLAnimation(nextAnimationName,true)
		-- self.cardAnimations:registerCompleteHandler(complete)

		local fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if(MovementEventType == EVT_COMPLETE) then
				complete()
			end
		end
		 
		self.cardAnimations:getAnimation():setMovementEventCallFunc(fnMovementCall)
		 

		-- Logger.debug( self.data.hid .. "---------------->  playXMLAnimation:" .. animationName)

	end

	function BattlPlayerDisplay:onXMLAnimationComplete()
		if(self.container) then 
			   -- self.animationName == animationName) then

				self.actionCallBacker:runCompleteCallBack(self)
				self.actionCallBacker:clearAll()
				self.isPlayAction = false
				self:resetCardState()
				
		end
	end
	-- function BattlPlayerDisplay:onAnimationComplete()
	 
	-- end
	-- 转换到站立模式(停止当前动画)
 	function BattlPlayerDisplay:toStandState( ... )

 		-- self.cardAnimations:setIsLoop(false)
		-- self.cardAnimations:clearHanders()
		-- Logger.debug( self.data.hid .."++++++++++++++++++ toStandState:" .. self.animationName)
		-- self.cardAnimations:stop()

		-- self.cardAnimations:setIsLoop(false)
		-- self.cardAnimations:stop()
 
		-- self.cardAnimations:setRotation(0)
		-- self.cardAnimations:setPosition(0,0)
		
		if(self:isOnStage() ~= true) then
			return 
		end

		local node 					= tolua.cast(self.cardAnimations,"CCNode")

		local rgbNode 				= tolua.cast(self.cardAnimations,"CCNodeRGBA")
		rgbNode:setColor(self.cardRawState.color)
		rgbNode:setOpacity(self.cardRawState.a)
 
		self.cardAnimations:getAnimation():gotoAndPause(1)
		
 	end
	-- 停止播放动画
	function BattlPlayerDisplay:stop()
		-- 
		-- self.cardAnimations:setIsLoop(false)
		-- self.cardAnimations:clearHanders()
		-- self.cardAnimations:stop()
		-- Logger.debug( self.data.hid .."++++++++++++++++++  BattlPlayerDisplay:stop:" .. self.animationName)
		self:resetCardState()
		
	end
 
	function BattlPlayerDisplay:playXMLAnimation(animationName,playMp3,loop,startFrame)
		-- local f = self:getXMLAnimationAction(animationName,target,callFunction)
		-- local shake = require(BATTLE_CLASS_NAME.BAForShakeScreen).new()
		-- shake.total=1
		-- shake:start()
		-- 获取总帧数
		if(self:isOnStage() ~= true) then
			return 
		end

		self.animationName = animationName
		if(loop ~= true) then
			loop = 0
		else
			loop = 1
		end
		if (animationName) then
			local animation = tolua.cast(self.cardAnimations,"CCArmature")
			animation:getAnimation():play(animationName, -1, -1, loop)
			-- animation:getAnimation():play(animationName, -1, -1, loop)
			if(animation ~= nil and startFrame ~= nil and tonumber(startFrame) > 0) then
	 			animation:getAnimation():gotoAndPlay(startFrame)
	 		end
		end
		-- --print("++++++++++++++++++ BattlPlayerDisplay:playXMLAnimation->",animationName)
		-- self.cardAnimations:getAnimation("")
		-- self.cardAnimations:playAnimationWithName(animationName,"kapian")
		if(playMp3 == true) then
			BattleSoundMananger.playEffectSound(animationName,false)
		end
		
		--return self.cardAnimations:runXMLAnimation(CCString:create(animationName))
	end
	-- function BattlPlayerDisplay:playXMLAnimationAction(animationName,target,callFunction)
	-- 		local f = self:getXMLAnimationAction(animationName,target,callFunction)
	-- end


		--播放普通攻击动画
	function BattlPlayerDisplay:playMoveAnimation(loop,startFrame)
		
		--停止播放动画
		-- 当前播放动画是否继续保留呢？销毁还是仅仅是visble?
		--BattlPlayerDisplay.stop()
		-- --print("")
	 	if(self:isOnStage() ~= true) then
			return 
		end
	 	 
	 	-- self.cardAnimations:setIsLoop(true)
	 	self:playXMLAnimation("A006",false,loop,startFrame)

	 	-- self.cardAnimations:setIsLoop(true)
		----print(" 播放动画："..self.aniNameGetter.getMoveName(data.htid))
		-- return self.cardAnimations:runXMLAnimation(CCString:create(BATTLE_CONST.ANIMATION_WALK_0))
	end
 

	function BattlPlayerDisplay:getDisplayState()
		local node 					= tolua.cast(self.cardAnimations,"CCNode")
				
		self.cardRawState 			= {}
		self.cardRawState.x 		= node:getPositionX()
		self.cardRawState.y 		= node:getPositionY()
		self.cardRawState.scale 	= node:getScaleX()

		local rgbNode 				= tolua.cast(self.cardAnimations,"CCNodeRGBA")
		
 		self.cardRawState.color 	= rgbNode:getColor()
 		self.cardRawState.a 		= rgbNode:getOpacity()

	end
	function BattlPlayerDisplay:resetCardState( )

		-- Logger.debug( "++++++++++++++++++ resetCardState:" .. self.animationName)
		-- print(debug.traceback())
		if(self:isOnStage() ~= true) then
			return 
		end
		-- self.cardAnimations:setIsLoop(false)
		-- self.cardAnimations:getAnimation():gotoAndPause(1)
		-- self:normalState()
		local animation = tolua.cast(self.cardAnimations,"CCArmature")
		animation:getAnimation():play("A009", -1, -1, 0)
		
		self.container:stopAllActions()

		-- self.cardAnimations:setRotation(0)
		-- self.cardAnimations:setPosition(0,0)

		local node 					= tolua.cast(self.cardAnimations,"CCNode")
 		-- print(self.cardRawState.scale)
		node:setScale(self.cardRawState.scale)
		-- print("=== reset state:",self.cardRawState.scale)
		if(self.isGhostState) then
			self.isGhostState = false
			self:removeAllExtEffect()
			self:ghostState()
		end

		local rgbNode 				= tolua.cast(self.cardAnimations,"CCNodeRGBA")
		rgbNode:setColor(self.cardRawState.color)
		rgbNode:setOpacity(self.cardRawState.a)

		self.cardAnimations:setVisible(false)

		self.boneBinder:setColor(self.cardRawState.color)
 		-- self.cardRawState.color 	= rgbNode:getColor()
 		-- self.cardRawState.a 		= rgbNode:getOpacity()

		-- node:setRotationX(0)
		-- node:setRotationY(0)


	end

 	function BattlPlayerDisplay:getAABBBox( ... )
	    local boundingBox = require(BATTLE_CLASS_NAME.BaseBoundingBox).new()

	    if(self.container and self.cardBoard and self.boneBinder) then
	    	local p 	= self.boneBinder:getAnchorPoint()
		    local world = self.container:convertToWorldSpace(CCP_ZERO)
		    -- local size  = self.cardBoard:getContentSize()
		    local size  = self:getRectangle()
		    boundingBox:iniWithData(world.x - p.x * size.width,world.y - p.y * size.height,size.width,size.height)
		end
	    return boundingBox  
 	end
	
	function BattlPlayerDisplay:getRectangle()
		if(self.data and self.data.cardSizeType >= 1) then
			return db_cardSize_util.getCardRectangleByLevel(self.data.cardSizeType)
		end
		return db_cardSize_util.getCardRectangleByLevel(1)
	end
	function BattlPlayerDisplay:reset(data)
		
		-- self.isDead 									= false
		self:release(false)
		self.disposed 									= false
		self.data 										= data
 
		self.container									= CCLayerRGBA:create()
		-- end
		
        self.container:setCascadeOpacityEnabled(true)
        self.container:setCascadeColorEnabled(true)
		-- 无框模式 只是用了一个透明的背景
		-- if self.data.isOutline ~= true then
		   -- self.cardAnimations								= CCXMLSprite:create(data.backImgURL)
		   -- self.cardAnimations:initXMLSprite(CCString:create(data.backImgURL));

		   --  local ts = CCAnimationSprite:create()

		   -- self.cardAnimations								= CCAnimationSprite:create()
		   -- self.cardAnimations:addImageWithURL(data.backImgURL)


           ObjectTool.loadRoleAnimation()
		   -- self.animationBoneSprite 					= CCSkin:create(data.backImgURL)
		   -- self.animationBoneSprite 					= CCNode:create()
		   -- self.animationBoneSprite 					= CCSprite:create(data.backImgURL)
		   -- CCSprite:create(data.backImgURL)
		   -- local ccskin = 
		   self.cardAnimations 								= CCArmature:create("kapian")
		   self.cardAnimations:setVisible(false)
		
 
		   self.container:addChild(self.cardAnimations)
		   self.container:setZOrder(300)
		   

		   local node 					= tolua.cast(self.cardAnimations,"CCNode")
		   node:setAnchorPoint(CCP_HALF)
		   -- node:setCascadeOpacityEnabled(true)
		   -- node:setCascadeColorEnabled(true)
		 


			self.boneBinder = CCBattleBoneBinder:create()
			 self.boneBinder:setAnchorPoint(CCP_HALF)
			 self.boneBinder:setCascadeOpacityEnabled(true)
			-- 
			
			-- BattleLayerManager.battlePlayerLayer:addChild(self.boneBinder)
			self.animationBone = self.cardAnimations:getBone("kapian")
			self.boneBinder:bindBone(self.animationBone)
			-- 
			self.cardRectange =  self:getRectangle()
			-- 如果是无边框卡牌,不显示牌
			self.hangPoint4 = nil
			local cardImgFix = 0
			local nameFix = 0
			if(self.data.isOutline) then
				cardImgFix = BATTLE_CONST.CARD_X4_HERO_IMG_Y
				nameFix = BATTLE_CONST.NAME_X4_Y
				self.hangPoint4 = BATTLE_CONST.UI_X4_CARD_HPOINT_4
			elseif(self.data.isSuperCard) then
				cardImgFix = BATTLE_CONST.CARD_X3_HERO_IMG_Y
				nameFix = BATTLE_CONST.NAME_X3_Y
				self.hangPoint4 = BATTLE_CONST.UI_X3_CARD_HPOINT_4
			elseif(self.data.isBigCard) then
				cardImgFix = BATTLE_CONST.CARD_X2_HERO_IMG_Y
				nameFix = BATTLE_CONST.NAME_X2_Y
				self.hangPoint4 = BATTLE_CONST.UI_BIG_CARD_HPOINT_4
			else
				cardImgFix = BATTLE_CONST.CARD_X1_HERO_IMG_Y
				nameFix = BATTLE_CONST.NAME_X1_Y
				self.hangPoint4 = BATTLE_CONST.UI_SMALL_CARD_HPOINT_4
			end

			if(self.data.isOutline ~= true) then
				local card	= CCSprite:create(data.backImgURL)
			    card:setAnchorPoint(CCP_HALF)
			    -- self.cardBackSize = db_cardSize_util.getCardRectangleByLevel() --card:getContentSize()
			    -- self.cardBackSize = self:getRectangle() --card:getContentSize()
			    self.cardBackSize = self:getRectangle()
			    self.cardRectange = self:getRectangle()
				self.cardBoard  = card
				BattleNodeFactory.regeistTextureURL(data.backImgURL)
				-- card:setPosition(0,-self.cardRectange.height/2)
				-- self.boneBinder:addChild(card,3,2)
				self.boneBinder:addChild(card)
				card:setCascadeOpacityEnabled(true)
        		card:setCascadeColorEnabled(true)
        		if(self.data.isSuperCard) then
        			card:setAnchorPoint(ccp(0.5,0.5 - BATTLE_CONST.X3_DY))
        		end
        		-- cardImgFix = 0.257
        	else
        		self.x4RageBack = require(BATTLE_CLASS_NAME.Battle4XRageBackImages):new()
        		self.boneBinder:addChild(self.x4RageBack,6,5)
        		self.x4RageBack:reset(self.cardRectange)
			end
			-- self.boneBinder:bindBone(self.animationBoneSprite)
			
			
			 --card:getContentSize()
		 

		   -- --print("---------------------------------------- heroImgURL:",data.heroImgURL)
		   if(file_exists(data.heroImgURL)~= true) then
		   		error("未发现英雄动作图片:"..data:toString())
		   end
		   -- assert(file_exists(data.heroImgURL) == true,)
		   self.heroImg = CCSprite:create(data.heroImgURL)
		   self.heroImg:setAnchorPoint(ccp(0.5,0))

		   --  local blendFunc1 =  ccBlendFunc()
		   --  local blendFunc2 =  ccBlendFunc()
	    --     blendFunc1.src = GL_ONE
	    --     blendFunc1.dst = GL_ONE_MINUS_SRC_ALPHA

	    --     blendFunc2.src = GL_DST_COLOR
	    --     blendFunc2.dst = GL_ONE_MINUS_SRC_ALPHA

		   -- self.heroImg:setBlendFunc(blendFunc1)
		   -- card:setBlendFunc(blendFunc2)
    	   -- self.heroImg:setAnchorPoint(ccp(0.5,0))
    	   -- self.boneBinder:addChild(self.heroImg,2,3)
    	   self.boneBinder:addChild(self.heroImg)

    	    self.heroImg:setCascadeOpacityEnabled(true)
        	self.heroImg:setCascadeColorEnabled(true)
			
		

		    -- self.heroImg:setPosition(0, card:getContentSize().height/2  + data.imgOffset[2])
		    self.heroImg:setPosition(data.imgOffset[1], self.cardRectange.height* cardImgFix  + data.imgOffset[2])
		    -- print("==self.heroImg:setPosition:",self.cardRectange.height,cardImgFix ,data.imgOffset[2],self.heroImg:getPositionY())
		    self:getDisplayState()

		    self.actionCallBacker:clearAll()
		    self.ref = nil

		Logger.debug("cardUIdata is blank:".. tostring(self.data.isOutline))

		self.hpBaseBar = require(BATTLE_CLASS_NAME.BattleHeroHPBarUI).new()
	    self.hpBaseBar:setParent(self.boneBinder,self.cardRectange,self.data.isBigCard,self.data.isSuperCard,self.data.isOutline)
	    -- self.hpBaseBar:setParent(self.boneBinder,card:getContentSize(),false,true)
	    -- self.hpBaseBar:setParent(self.boneBinder)

	    self.rageBar   = require(BATTLE_CLASS_NAME.BattleHeroRageBar).new(self.data.isBigCard,self.data.isSuperCard,self.data.isOutline)
	    self.rageBar.psize = self.cardRectange

	    local myNode 					= tolua.cast(self.boneBinder,"CCNode")
	 
	    self.boneBinder:addChild(self.rageBar,6,5)
		   --self:addChild(self.cardAnimations)
		self.cacheFeet 		= self:feetPoint()
		self.cacheHeart 	= self:heartPoint()
		self.cacheHead 		= self:headPoint()
 		

 		if(data.teamId == BATTLE_CONST.TEAM2) then
			-- self.cardAnimations:setRotation(180)
			-- self.animationBoneSprite:setRotation(180)
			self.boneBinder:setOppsiteY()
			self.impactY 					= -self.cardRectange.height * (0.5 + 0.3) 
		else
			self.impactY 					= self.cardRectange.height * (0.5 + 0.3) 
 		end
		

 		ObjectTool.removeObject(self.nameLabel)

 		-- 如果是无边框,怒气和血量不需要显示
 		if(self.data and self.data.isOutline == true) then
 			-- self.rageBar:setVisible(false)
 			-- ObjectTool.removeObject(self.rageBar)
 			-- self.hpBaseBar:release()
 		end
 
		-- Logger.debug("== heroName:" .. tostring(data.name))
 		self.nameLabel = Label:create()
 		-- 如果是无边框,怒气和血量不需要显示
 		self.nameLabel:setPositionY(self.cardRectange.height * nameFix) 
 

 		self.nameLabel:setFontName(g_sFontPangWa) -- zhangqi, 2015-04-22, 所有跑马灯字体用方正粗圆简体
    	self.nameLabel:setFontSize(20)
    	self.nameLabel:setColor(self.data.nameColor or ccc3(0,0,0))

		UIHelper.labelNewStroke(self.nameLabel,ccc3(0,0,0),2)
 		self.boneBinder:addChild(self.nameLabel,100)

 		-- self.nameLabel:setText(tostring("中文名"))

 		-- self.nameLabel:setVisible(false)
	end
	function BattlPlayerDisplay:refreshDisplayName()
		if(self.data) then
			self.data:refreshName()
			if(self.nameLabel) then
				-- self.nameLabel:setString(tostring(self.data.name))
				self.nameLabel:setText(tostring(self.data.name))
			end
		end
	end
	function BattlPlayerDisplay:showName()
		if(self.nameLabel) then
			self.nameLabel:setVisible(true)
		end
	end

	function BattlPlayerDisplay:hideName()
		if(self.nameLabel) then
			self.nameLabel:setVisible(false)
		end
	end

	function BattlPlayerDisplay:printRawPostion( ... )
		--print(self.data.heroImgURL,"rawPositon:",self.rawPositon.x,self.rawPositon.y)
	end
	function BattlPlayerDisplay:getParent( ... )
		if(self.container ) then
			return self.container:getParent()
		end
		return nil
	end

	function BattlPlayerDisplay:retain( ... )
		if self.container ~= nil then 
			self.container:retain()
		end
	end

	function BattlPlayerDisplay:removeFromParent( ... )
		ObjectTool.removeObject(self.container)
		ObjectTool.removeObject(self.boneBinder)
	end

	function BattlPlayerDisplay:setParent( partent )
		-- 如果有父级容器删除
		if self.container:getParent() ~= nil then 
			 self.container:getParent():removeChild(self.container)
		end
		-- --print("will index:",self.data.positionIndex)
		 
        self.container:setPosition(self.data.rawPostion.x,self.data.rawPostion.y)
      
        self.rawPositon.x = self.data.rawPostion.x
        self.rawPositon.y = self.data.rawPostion.y
        self.rawPositon.z = self.data.zOder
        -- --print("addChild :",self.data.rawPostion.x," ",self.data.rawPostion.y,self.rawPositon.z)
        -- 添加到舞台
		partent:addChild(self.container,self.data.zOder + 1)
		partent:addChild(self.boneBinder,self.data.zOder)
		
		local positon 	
		--- 测试用
		 -- local cc = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
   --         		BattleLayerManager.battleAnimationLayer:addChild(cc)
   --         		cc:setPosition(postion.x,postion.y)
   --         		local displayName = CCLabelTTF:create("feet",g_sFontName,30)

           	-- local scene = CCDirector:sharedDirector():getRunningScene()
		   -- local displayName = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
 		  --  positon = self:globalFeetPoint()
		   -- displayName:setAnchorPoint(CCP_HALF)
		   -- displayName:setPosition(positon.x,positon.y)
		   -- scene:addChild(displayName,999990)

		   -- Logger.debug("po:" .. positon.x .. ",".. positon.y)

		   -- local mdisplayName = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
 		  --  positon	 = self:globalCenterPoint()
		   -- mdisplayName:setAnchorPoint(CCP_HALF)
		   -- mdisplayName:setPosition(positon.x,positon.y)
		   -- scene:addChild(mdisplayName,999990)

		   -- local hdisplayName = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
 		   -- positon 	 = self:globalHeadPoint()
		   -- hdisplayName:setAnchorPoint(CCP_HALF)
		   -- hdisplayName:setPosition(positon.x,positon.y)
		   -- scene:addChild(hdisplayName,999990)
		   -- local animation1 = ObjectTool.getAnimation(BATTLE_CONST.EFFECT_DIE_1,true)
		   -- self:addExtEffectAt(animation1,BATTLE_CONST.POS_MIDDLE)
		   -- positon	 = self:globalCenterPoint()

		   -- local animation2 = ObjectTool.getAnimation(BATTLE_CONST.EFFECT_DIE_2,true)
		   
		   -- scene:addChild(animation2,999990)
		   -- animation2:setPosition(positon.x,positon.y)
		   
	end
	function BattlPlayerDisplay:isOnStage( ... )
		return self.boneBinder ~= nil and self.container ~= nil and
			   self.boneBinder:getParent() ~= nil and self.container:getParent()~= nil
	end
	function BattlPlayerDisplay:release(flag)
		-- if(self.disposed) then return end
		self.disposed = flag or true
		-- self.disposed = true
		self:removeBars()
		
		if(self.boneBinder) then
			ObjectTool.removeObject(self.boneBinder)
			-- self.boneBinder:setParent(nil)
			self.boneBinder = nil
		end
		if(self.cardAnimations) then
			ObjectTool.removeObject(self.cardAnimations)
			self.cardAnimations = nil
		end
		if(self.x4RageBack) then
			-- self.x4RageBack:releaseUI()
			self.x4RageBack = nil
		end
		-- if(self.cardAnimations) then
		-- 	self:stop()
		-- 	local  sp	  = tolua.cast(self.cardAnimations,"CCSprite")
		-- 	sp:removeFromParentAndCleanup(true)
		-- 	self.cardAnimations = nil
		-- end
		


		-- if(self.currentAnimation) then
		-- 	self.currentAnimation:release()
		-- 	self.currentAnimation = nil
		-- end

		-- self:removeAllBuff()
		if(self.cardBoard) then
			ObjectTool.removeObject(self.cardBoard)
			self.cardBoard = nil
		end

		self:removeAllExtEffect()
		self.buffList =  {}
		self.buffCount =  {}

		self.extEffectList = nil
		if(self.container ~= nil) then
			-- Logger.debug("self.container:release")
			ObjectTool.removeObject(self.container)
			-- if(self.container:retainCount() > 0 and self.container:getParent() ~= nil) then
			-- 	Logger.debug("self.container:retainCount:" .. tostring(self.container:retainCount()))
			-- 	self.container:removeFromParentAndCleanup(true)
			-- end
			self.container = nil
		end
	end

	function BattlPlayerDisplay:dead( ... )
		self:removeAllBuff()
		self.isDead = true
		-- self:removeAllExtEffect()
	end
	
	function BattlPlayerDisplay:removeBars()
		if(self.hpBaseBar) then
			self.hpBaseBar:release()
			self.hpBaseBar = nil
		end

		if(self.rageBar) then
			self.rageBar:releaseUI()
			self.rageBar = nil
		end

	end

	function BattlPlayerDisplay:moveBy(dx,dy)
		-- self.cardAnimations.x = self.cardAnimations.x + dx
		-- self.cardAnimations.y = self.cardAnimations.y + dy
		if(self.container) then
			self.container:setPosition(self.container:getPositionX() + dx,self.container:getPositionY() + dy)
		end
	end
	function BattlPlayerDisplay:getPositionX()
		return self.container:getPositionX()
	end
	function BattlPlayerDisplay:getPositionY()
		return self.container:getPositionY()
	end

	function BattlPlayerDisplay:scale(value)
		return self.container:setScale(value)
	end
								-- setPosition

	function BattlPlayerDisplay:setPosition(x,y)
		-- self.cardAnimations.x = x
		-- self.cardAnimations.y = y
		if(self.container) then
			self.container:setPosition(x,y)
		end
	end

	-- function BattlPlayerDisplay:setPostion(x,y)
	-- 	-- self.cardAnimations.x = x
	-- 	-- self.cardAnimations.y = y

	-- 	self.container:setPosition(x,y)
	-- end


	function BattlPlayerDisplay:postionIndex()
		if (self.data ~= nil) then 
			return self.data.positionIndex
		end
		--print("BattlPlayerDisplay:postionIndex data is nil")
		return 0
	end

	function BattlPlayerDisplay:getImpactPoint()
		local point = nil
		local size 	= self.cardRectange
		if(self.data and self.data.isOutline == true) then
			 point = self.container:convertToWorldSpace(ccp(0 ,
	 															   size.width * BATTLE_CONST.CARD_X4_IMPACT_Y)) 
		elseif(self.data and self.data.isSuperCard == true) then
			 point = self.container:convertToWorldSpace(ccp(0 ,
	 															   size.width * BATTLE_CONST.CARD_X3_IMPACT_Y)) 
		-- elseif(self.data == nil or self.data.isOutline ~= true) then
	 		
 		else
 			local scale = math.abs(self.cardAnimations:getScaleX())
	         point = self.container:convertToWorldSpace(ccp(self.cacheFeet.x ,
	 															  self.cacheFeet.y + self.impactY))   
 		end  

        return point
	end

 	function BattlPlayerDisplay:globalFeetPoint( )
 		local size 	= self.cardRectange
 		local scale = math.abs(self.cardAnimations:getScaleX())
 		-- --print("BattlPlayerDisplay:globalFeetPoint: ",scale," x,y:",self.cardAnimations:getPositionX(),",",self.cardAnimations:getPositionY())
        local point = self.container:convertToWorldSpace(ccp(self.cacheFeet.x ,
 															  self.cacheFeet.y ))       
        return point
 	end
 	function BattlPlayerDisplay:globalCenterPoint()
 		if(self.container) then
	 		local size 	= self.cardRectange
			local point = self.container:convertToWorldSpace(ccp(self.cacheHeart.x ,
	 															 self.cacheHeart.y ));
	        return point
	    end
	    return CCP_ZERO
 	end

 	 	function BattlPlayerDisplay:globalHeartPoint()
 	 		if(self.container) then
		 		local size 	= self.cardRectange
		 		local scale = math.abs(self.cardAnimations:getScaleX())

			 	local point = self.container:convertToWorldSpace(ccp(self.cacheHeart.x ,
															 		 self.cacheHeart.y ));
		        return point
 			else
 				return CCP_ZERO
 			end
 	end


 	function BattlPlayerDisplay:globalHeadPoint()
 		if(self.container) then

	 		local size 	= self.cardRectange
	 		local scale = math.abs(self.cardAnimations:getScaleX())
	 		-- --print("globalHeadPoint width:",size.width," height:",size.height," scale:",self.cardAnimations:getScale())
	 		local point = self.container:convertToWorldSpace(ccp(self.cacheHead.x,
	 															self.cacheHead.y));
	        return point
	    else
 			return CCP_ZERO
 		end
 	end



 	function BattlPlayerDisplay:feetPoint( )
 		local size 	= self.cardRectange
 		local scale = math.abs(self.cardAnimations:getScaleX())
 		local point = CCP_ZERO;
        -- return point
         return ccp(0,size.height*scale*-0.35 + scale * 15)
         -- return ccp(size.width*scale*0.5,-size.height*scale*0.15)
 	end
 	function BattlPlayerDisplay:centerPoint()
 		local size 	= self.cardRectange
 		local scale = math.abs(self.cardAnimations:getScaleX())
 		local point = ccp(0,size.height*scale*0.05 + scale * 15);
 		-- local point = ccp(size.width*scale*0.5,size.height*scale*0.55);
        return point
 	end

 	 	function BattlPlayerDisplay:heartPoint()
 		local size 	= self.cardRectange
 		local scale = math.abs(self.cardAnimations:getScaleX())
 		-- local point = ccp(size.width*scale*0.5,size.height*scale*0.8);
 		local point = ccp(0,size.height*scale*0.05 + scale * 15);
        return point
 	end


 	function BattlPlayerDisplay:headPoint()
 		local size 	= self.cardRectange
 		local scale = math.abs(self.cardAnimations:getScaleX())
 		-- --print("globalHeadPoint width:",size.width," height:",size.height," scale:",self.cardAnimations:getScale())
 		local point = ccp(0,size.height*scale*0.35 + scale * 15);
        return point
 	end



	function BattlPlayerDisplay:setLoop( loop )
		self.cardAnimations:setIsLoop(loop)
	end
	
 	
 	function BattlPlayerDisplay:addBuffUI(name,postionIndex)
 		-- postionIndex = 4
 		if(self.disposed) then 
 			Logger.debug("BattlPlayerDisplay:addBuffUI disposed")
 			return 
 		end
 		local postion  
 		local node 					= tolua.cast(self.cardAnimations,"CCNode")
 		
 		if(self.cardRectange == nil) then
 			self.cardRectange = self:getRectangle()
 		end

        if(postionIndex == BATTLE_CONST.POS_FEET) then
       		
       		postion = ccp(0,-self.cardRectange.height/2 * 0.35)
       		-- postion = ccp(self.cardRectange.width/2,-self.cardRectange.height/2 * 0.35)
       		-- --print("BAForAddEffectAtHero is feet:",postion.x," ",postion.y)

        elseif (postionIndex == BATTLE_CONST.POS_HEAD)then
        	postion = ccp(0,self.cardRectange.height/2 * 0.35)

        elseif (postionIndex == BATTLE_CONST.POS_BUFF)then
        	
        	if(self.hangPoint4 == nil or self.hangPoint4[1] == nil or  self.hangPoint4[2] == nil) then
        		self.hangPoint4 = {0,0.5}
        	end
        	
        	postion = ccp(self.cardRectange.width * self.hangPoint4[1],self.cardRectange.height * self.hangPoint4[2])
        
        elseif (postionIndex == nil or  postionIndex == BATTLE_CONST.POS_MIDDLE)then

        	postion = ccp(0,-self.cardRectange.height/2 * 0.05)
        end

        -- postion = ccp(self.cardRectange.width/2,self.cardRectange.height/2 * 0.55)
         -- postion = ccp(self.cardRectange.width/2,self.cardRectange.height/2 * 0.35)
 		-- Logger.debug("添加buff:" .. name .. "  ".. tostring(self.buffCount[name]) .. "  postion:" .. tostring(postion))
 		if self.buffList[name] == nil then
 

 			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(name)
 			if(filesExists == true) then 
 				 
		 			local bufficon = ObjectTool.getAnimation(name,true)
		 			-- BattleSoundMananger.playEffectSound(name)
		 		 
		 			self.boneBinder:addChild(bufficon,100)
		 			self.buffList[name] = bufficon
		 			-- bufficon:setAnchorPoint(CCP_ZERO)
 					bufficon:setPosition(postion.x,postion.y)
 					bufficon:getAnimation():playWithIndex(0,0,-1,1)
 					self.buffCount[name] = 1
 			else
 				error("buff不存在:"..name)
 			end
 		else
 			if(self.buffCount[name] >= 0) then
 				self.buffCount[name] = self.buffCount[name] + 1
 			end
 		end

 	end

 	function BattlPlayerDisplay:removeBuffUI(name)
 		
 		-- name = "bullet_2"
 		Logger.debug(self.data.hid .. "删除buff:" .. name .. "  " .. tostring(self.buffCount[name]))
 		if(self.buffCount[name] ~= nil and self.buffCount[name] > 0) then
 			self.buffCount[name] = self.buffCount[name] - 1
 		end
 		if(self.buffCount[name] == nil or self.buffCount[name] <= 0 ) then
	 		if(self.buffList[name]) then
	 			-- self.buffList[name].loop = false
	 			self.buffList[name]:getAnimation():stop()
	 			self.buffList[name]:removeFromParentAndCleanup(true)
	 			self.buffList[name] = nil
	 			Logger.debug("删除buff:" .. name .. "完成")
	 			self.buffCount[name] = 0
	 		end
	 	end

 		-- self:removeAllBuff()
 		
 	end

 	function BattlPlayerDisplay:removeAllBuff()
 		if(self.buffList) then 
 			for k,v in pairs(self.buffList) do
 				v:getAnimation():stop()
 				-- v:release()
 				v:removeFromParentAndCleanup(true)
 				v = nil
 			end
 			-- self.buffList = nil
 		end
 	 	self.buffList 		= {}
 		self.buffCount 		= {}
 	end

 	function BattlPlayerDisplay:removeAllExtEffect()
 		if(self.extEffectList) then 
 			for k,v in pairs(self.extEffectList) do
                ObjectTool.removeObject(v)
 				v = nil
 			end
 			self.extEffectList = nil
 		end
 	end

 

  
return BattlPlayerDisplay

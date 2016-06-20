

-- 怒气改变动画
require (BATTLE_CLASS_NAME.class)
local BAForRageChangeAnimationAction = class("BAForRageChangeAnimationAction",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	BAForRageChangeAnimationAction.value			= nil
 	BAForRageChangeAnimationAction.target			= nil
 	-- BAForRageChangeAnimationAction.container		= nil
 	BAForRageChangeAnimationAction.rageUp			= nil
 	------------------ functions -----------------------
 	function BAForRageChangeAnimationAction:start( ... )
 		-- 	self:addToRender()
 		-- else

 			-- if(true) then
 			-- 	self:complete() 
 			-- -- end
		 	-- else
		 	-- if(true) then
		 	-- 	self:complete()
		 	-- 	return 
		 	-- end

 			if(self.value and self.target) then
		 		
			 		-- self.container 		= CCSprite:create()
			 		local postion  		
			 		self.rageTextLabel = nil
			 		self.rageValueLabel = nil

			 		local labelPath 	= 1
			 		-- self.targets  	    = {}
			 		
			 		-- print("-- BAForRageChangeAnimationAction:",self.value)
			 		if(self.rageUp) then
			 			self.rageValueLabel = WordsAnimationManager.getRageUpNumber(self.value,true,false)
			 			self.rageTextLabel  = WordsAnimationManager.getWord(BATTLE_CONST.RAGE_UP_IMG_TEXT,false)
						postion 			= self.target:globalHeartPoint()
						-- postion 			= self.target:globalFeetPoint()
			 			 
			 		else

			 			self.rageValueLabel = WordsAnimationManager.getRageDownNumber(self.value,false)
			 			self.rageTextLabel  = WordsAnimationManager.getWord(BATTLE_CONST.RAGE_DOWN_IMG_TEXT,false)
			 			postion 			= self.target:globalHeadPoint()
			 		 
			 		end

			 		self.rageValueLabel:removeFromParentAndCleanup(false)
			 		self.rageTextLabel:removeFromParentAndCleanup(false)
			 		-- self.rageTextLabel:setOpacity(255)
			 		-- local container = CCSpriteBatchNode:create(BATTLE_CONST.ALL_WORDS_TEXTURE)
			 		self.container = CCNode:create()
			 		self.container:addChild(self.rageValueLabel)
			 		self.container:addChild(self.rageTextLabel)
			 		-- table.insert(self.targets,self.rageTextLabel)
			 		-- table.insert(self.targets,self.rageValueLabel)
			 		
			 		local action = nil
			 		
			 		local completeCall  = function ()
			 			-- print("=== rageChange Animation complete")
			     		if(self.disposed ~= true) then
			     			ObjectTool.removeObject(self.container)
			     			self.container = nil
			     			self:onActionComplete()
			     		end
			     		
			     	end

			     	-- print("=== rageChange Animation 1")
			 		if(self.value >0) then
			 			action = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RAGE_UP,completeCall)
			 			-- action1 = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RAGE_UP)
			 		else
			 			action = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RAGE_DOWN,completeCall)
			 			-- action1 = WordsAnimationManager.getAnimation(BATTLE_CONST.NUM_ANI_RAGE_DOWN)
			 		end

					-- local totalWidth = self.rageValueLabel:getContentSize().width/2
					local totalWidth =  self.rageValueLabel:getContentSize().width/4 + self.rageTextLabel:getContentSize().width/4

					-- self.rageTextLabel:setPosition(postion.x - totalWidth,postion.y)
					self.rageTextLabel:setPosition(- totalWidth,0)
			        -- self.rageValueLabel:setPosition(postion.x - totalWidth + self.rageTextLabel:getContentSize().width - 5,postion.y)
			        self.rageValueLabel:setPosition(25 + totalWidth,0)
			        self.container:setPosition(postion.x,postion.y)
			        BattleLayerManager.battleNumberLayer:addChild(self.container)

			        self.container:runAction(action)

			else
				self:complete()
			end

		-- end
		

 		-- self:complete()
 	end -- function end


 	-- function BAForRageChangeAnimationAction:update( dt )
 	-- 	if(self.delay > 0) then
 	-- 		self.delay = self.delay - 1
 	-- 	else
 	-- 		self:removeFromRender()
 	-- 		self:start()
 	-- 	end
 	-- end

 	function BAForRageChangeAnimationAction:onActionComplete( ... )
 		--print("BAForRageChangeAnimationAction:onActionComplete")
 		if(self.rageValueLabel) then
 			ObjectTool.removeObject(self.rageValueLabel)
 			-- self.rageValueLabel:release()
 			self.rageValueLabel = nil
 		end

 		ObjectTool.removeObject(self.rageTextLabel)
 		self:complete()
 	end

 	function BAForRageChangeAnimationAction:release( ... )
 		
 		-- if(self.rageValueLabel ~= nil) then
 			-- self.rageValueLabel:release()
		ObjectTool.removeObject(self.container)
		self.container = nil

		ObjectTool.removeObject(self.rageValueLabel)
		self.rageValueLabel = nil
 		-- end
 		
 		ObjectTool.removeObject(self.rageTextLabel)
 		self.rageTextLabel = nil
 		
 		self.target = nil
 		self.value = nil
 		
 		self.disposed 	= true
		self:removeFromRender()					-- 执行
		self.calllerBacker:clearAll()
		self.blockBoard	= nil

 	end
 return BAForRageChangeAnimationAction
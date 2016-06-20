



--- 指定目标 淡入/淡出
--- 必要: targets,createFunction
 
local BAForShowBattleNumberStateAction = class("BAForShowBattleNumberStateAction",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
	-- BAForShowBattleNumberStateAction.
 	-- BAForShowBattleNumberStateAction.strongHoldName 	= nil
 	-- BAForShowBattleNumberStateAction.progressTxt  		= "进度:"
 	-- BAForShowBattleNumberStateAction.currentNum 		= 0
 	-- BAForShowBattleNumberStateAction.totalNum 			= 0

 	BAForShowBattleNumberStateAction.displayNameLabel 	= nil
 	BAForShowBattleNumberStateAction.progressLabel 		= nil
 	BAForShowBattleNumberStateAction.currentNumLabel	= nil
 	BAForShowBattleNumberStateAction.separator			= nil
 	BAForShowBattleNumberStateAction.totoalNumLabel		= nil
 	BAForShowBattleNumberStateAction.bg 				= nil
 	BAForShowBattleNumberStateAction.animation  		= nil




	------------------ functions -----------------------
	function BAForShowBattleNumberStateAction:start( ... )
		if( 
			self.blackBoard ~= nil and
		    self.blackBoard.strongHoldName ~= nil and 
		    self.blackBoard.currentNum ~= nil and
		    self.blackBoard.totalNum ~= nil and
		    self.blackBoard.totalNum > 1 -- 2015.10.21 曾铮需求:当总场次为1的时候不显示该动作
		  ) then
		-- if(self.currentNum >= 0 and self.totalNum > 0) then
 			
 			self.bg 			= CCSprite:create()
 			self.bg:setAnchorPoint(CCP_HALF)

 			local size 							= CCDirector:sharedDirector():getWinSize()
		    self.bg:setPosition(size.width/2,size.height*0.5)
		    self.bg:setCascadeOpacityEnabled(true)
		    self.bg:setScale(MainScene.elementScale)

		    local layer 		= BattleLayerManager.battleAnimationLayer
		    layer:addChild(self.bg,9999,9999)
		    

		    self.animation 				= ObjectTool.getAnimation("fight_progress",false)
		    self.bg:addChild(self.animation)
		    self.animation:setAnchorPoint(CCP_HALF)
		    self.animation:setPosition(0,30)
		    -- 375 × 91
		    local sizeX,sizeY =-20,60
		    self.displayNameLabel		= CCLabelTTF:create(self.blackBoard.strongHoldName,g_sFontName,30)
		    -- self.displayNameLabel		= CCLabelTTF:create("四个字啊",g_sFontName,30)
		    -- self.displayNameLabel		= CCLabelTTF:create("三个字",g_sFontName,30)
		    -- self.displayNameLabel		= CCLabelTTF:create("2字",g_sFontName,30)
		    -- self.displayNameLabel		= CCLabelTTF:create("六个字啊啊啊",g_sFontName,30)
		    -- self.displayNameLabel		= CCLabelTTF:create("7个字啊啊啊啊",g_sFontName,30)
		    -- self.displayNameLabel		= CCLabelTTF:create("8个字啊啊啊啊",g_sFontName,30)
		    self.displayNameLabel:setAnchorPoint(CCP_HALF)
		    self.displayNameLabel:setPosition(sizeX/2,sizeY*0.7)
		    self.bg:addChild(self.displayNameLabel)

		    local progressTxt = gi18nString(5801) -- "进度"

		    local sizeW = self.displayNameLabel:getContentSize().width
		    -- print("--textSize:",self.displayNameLabel:getContentSize().width)
		    self.progressLabel  = CCLabelTTF:create(progressTxt,g_sFontName,22)
			self.progressLabel:setAnchorPoint(CCP_HALF)
			-- self.progressLabel:setPosition(sizeX/2 + 20 - sizeW/2.7,sizeY*0.25)
			self.bg:addChild(self.progressLabel)

			local downSize = 0
			-- self.currentNumLabel = LuaCC.createNumberSprite02(BATTLE_CONST.BNT_NUMBER_PATH,"" .. self.blackBoard.currentNum,15)
			self.currentNumLabel = LuaCC.createNumberSpriteWithName(BATTLE_CONST.STRONGHOLD_BATTLE_NUM_PATH,"round_yellow_num_","" .. self.blackBoard.currentNum,15)
			self.currentNumLabel:setAnchorPoint(CCP_HALF)
			-- self.currentNumLabel:setPosition(sizeX/2 + 60 - sizeW/2.7,sizeY*0.2)
			-- self.currentNumLabel:setPosition(96*0.45,sizeY*0.20)
			self.bg:addChild(self.currentNumLabel)
			
			self.separator = CCSprite:create(BATTLE_CONST.STRONGHOLD_SEPARATOR)
			self.separator:setAnchorPoint(CCP_HALF)
			-- self.separator:setPosition(96*0.65,sizeY*0.2)
			-- self.separator:setPosition(sizeX/2 + 80 - sizeW/2.7,sizeY*0.2)
			self.bg:addChild(self.separator)

			-- self.totoalNumLabel = LuaCC.createNumberSprite02(BATTLE_CONST.BNT_NUMBER_PATH,"" .. self.blackBoard.totalNum,15)
			self.totoalNumLabel = LuaCC.createNumberSpriteWithName(BATTLE_CONST.STRONGHOLD_BATTLE_NUM_PATH,"round_red_num_","" .. self.blackBoard.totalNum,15)
			self.totoalNumLabel:setAnchorPoint(CCP_HALF)
			-- self.totoalNumLabel:setPosition(sizeX/2 + 100 - sizeW/2.7,sizeY*0.2)
			-- self.totoalNumLabel:setPosition(96*0.85,sizeY*0.2)
			self.bg:addChild(self.totoalNumLabel)

			-- 获取第二行所有元素的宽
			local progressWidth = self.progressLabel:getContentSize().width 
			local currentNumWidth = self.currentNumLabel:getContentSize().width 
			local separatorWidth = self.separator:getContentSize().width 
			local totoalNumWidth = self.totoalNumLabel:getContentSize().width 

			-- 计算总宽度
			downSize =  progressWidth   + progressWidth  + separatorWidth + totoalNumWidth
 
			-- 计算每个元素的坐标
			self.progressLabel:setPosition(sizeX/2  - downSize/2 + progressWidth/2 ,sizeY*0.15)
			self.currentNumLabel:setPosition(self.progressLabel:getPositionX() + progressWidth  + 0,sizeY*0.15)
			self.separator:setPosition(self.currentNumLabel:getPositionX() + currentNumWidth  + 0,sizeY*0.15)
			self.totoalNumLabel:setPosition(self.separator:getPositionX() + separatorWidth  + 0,sizeY*0.15)
			local removeSelf = function ()
				if(self.bg:getParent()) then
					self.bg:removeFromParentAndCleanup(true)
				end
				-- self:start()
				self:complete()
			end -- function end
			
			local actionArray = CCArray:create()
			actionArray:addObject(CCDelayTime:create(1.5))
			actionArray:addObject(CCFadeOut:create(0.5))
			-- actionArray:addObject(CCDelayTime:create(5))
			actionArray:addObject(CCCallFuncN:create(removeSelf))
			self.bg:runAction(CCSequence:create(actionArray))
			

 		else
 			self:complete()
 		end
	end


 	function BAForShowBattleNumberStateAction:onComplete()
 		
 		if(self.disposed ~= true) then
 			self:complete()
 		end

 	end

 	function BAForShowBattleNumberStateAction:release()
 		
 		self.disposed 				= true

 		self:removeFromRender()					 
		self.calllerBacker:clearAll()


 		if(self.bg) then
 			self.bg:stopAllActions()
 			if(self.bg:getParent()) then
 		 		self.bg:removeFromParentAndCleanup(true)
 		 	end
 		 	-- self.bg:removeAllChildrenWithCleanup(true)
 		 	self.bg 				= nil

 		 	self.displayName 		= nil
			self.progressLabel	 	= nil
			self.currentNumLabel	= nil
			self.separator			= nil
			self.totoalNumLabel		= nil
 		end
 
 	end


return BAForShowBattleNumberStateAction
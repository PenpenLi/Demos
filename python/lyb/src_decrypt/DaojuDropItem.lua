-------------------------------------------------------
--DaojuDropItem class
-------------------------------------------------------

DaojuDropItem = class(Layer);

function DaojuDropItem:ctor()
    self.class = DaojuDropItem;
    self.loopTimes = 0
end

function DaojuDropItem:removeSelf()
    self.class = nil;
end

function DaojuDropItem:dispose()
	self:removeForceTimer()
	self:removeStayTimer()
    self:removeSelf();
	self.itemCount = nil
	self.itemQueueID = nil
	self.daojuDrop = nil
	self.fightUI = nil
	self.itemType = nil
end

function DaojuDropItem:loadByArtID(imageID,itemType,ItemId)
	if itemType == "silver" then
		self.imageIconBg = cartoonPlayer("1730",0,0,0,nil,1,nil,nil)
	else
		self.imageIconBg = getImageByArtId(imageID)
	end
	self.imageIconBg:setAnchorPoint(CCPointMake(0,0.2));
	self.imageIconBg.touchEnabled=true;
	self:addChild(self.imageIconBg)
	self.ItemId = ItemId
end

function DaojuDropItem:initIconData(daojuDrop,itemCount,place,itemQueueID,fightUI,itemType)
	self.place = place
	self.effectLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS)
	local middle = self:getPositionX()+self.effectLayer:getPositionX()
	local targetX,targetY
	if middle > GameConfig.STAGE_WIDTH*2/3 then
		targetX = GameConfig.STAGE_WIDTH - 200
		targetX = targetX - (place-1)*60
	elseif middle > GameConfig.STAGE_WIDTH/3 then
		if middle > GameConfig.STAGE_WIDTH/2 then
			targetX = middle
			targetX = targetX - (place-1)*60
		else
			targetX = middle
			targetX = targetX - (place-1)*60
		end
	else
		targetX = 150
		targetX = targetX + (place-1)*60
	end
	targetY = math.random((BattleConfig.Up_Y-BattleConfig.Down_Y)/2+BattleConfig.Down_Y,BattleConfig.Up_Y-100)
	self.itemCount = itemCount
	self.itemQueueID = itemQueueID
	self.daojuDrop = daojuDrop
	self.fightUI = fightUI
	self.itemType = itemType
	self:daojuAnimation1(targetX,targetY)
	-- if self.itemType == "silver" then
	-- 	self.name = BattleConfig.SortOn_0
	-- end
	self.targetX = targetX
end

function DaojuDropItem:daojuAnimation1(targetX,targetY)
	local function animationBack()
		local dx = targetX- self.effectLayer:getPositionX() - self:getPositionX()
		local dy = targetY - self.effectLayer:getPositionY() - self:getPositionY()
		local distance1 = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
		if distance1 < 50 then
			-- local dropEffect = cartoonPlayer("138_1001",ccp(35,-40),0,nil,1,nil,nil)
			if self.itemType ~= "silver" then
				ParticleSystem:adddDropDaojuPlist(self,self.itemType)
			end
			-- self:addChildAt(dropEffect,0)
			-- self.imageIconBg:addEventListener(DisplayEvents.kTouchTap,self.daojuAnimation2,self);
			self.animation1Complete = true
			self:forceToMove(self.place)
			return
		end
		self.loopTimes = self.loopTimes + 1;
		self:daojuAnimation1(targetX,targetY)
	end
	local px = (targetX - self.effectLayer:getPositionX() - self:getPositionX())/2
	local py = (targetY - self.effectLayer:getPositionY() - self:getPositionY())/2
	local distance2 = math.sqrt(math.pow(px, 2)+math.pow(py, 2));
	local moveAction = CCMoveBy:create(distance2/(1000 + self.loopTimes*300), ccp(px,py));
	local callBack = CCCallFunc:create(animationBack);
	local array = CCArray:create();
	array:addObject(moveAction);
    array:addObject(callBack);
	self:runAction(CCSequence:create(array));
end

function DaojuDropItem:addDaojuIcon()
	if self.itemType == "silver" then return end
	if not self.ItemId then return end
	self:removeChild(self.imageIconBg)
	self.imageIconBg = nil
	self.imageIconBg = getImageByArtId(1061)
	self:addChild(self.imageIconBg)
	self.imageIcon=BagItem.new();
  	self.imageIcon:initialize({ItemId = self.ItemId, Count = 1});
	local bg = CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
	bg:setScale(0.6)
	bg:setPositionXY(15,15)
	self:addChild(bg)
	self.imageIcon:setScale(0.6)
	self.imageIcon:setPositionXY(20,20)
	self:addChild(self.imageIcon)
end

function DaojuDropItem:daojuAnimation2(event)
	if not self.animation1Complete then
		self.needAnimation2 = true
		return
	end
	if self.hasFly then return end
	self.hasFly = true
	self:addDaojuIcon()
	self:removeStayTimer()
	
	if not self:getPositionX() then return end
	if  self.itemType == "silver" then
		self:daoju_Animation2()
		return
	end

	local function stayTimerFun()
		self:removeStayTimer()
		self:daoju_Animation2()
	end
	self.stayTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(stayTimerFun, 1, false)
end

function DaojuDropItem:daoju_Animation2()
	local px = self:getPositionX()+self.effectLayer:getPositionX()
	local py = self:getPositionY()+self.effectLayer:getPositionY()
	self.effectLayer:removeChild(self,false)
	if self.itemType ~= "silver" then
		self.imageIconBg:setVisible(false)
	end
	self:setPositionXY(px,py)
	self.fightUI:addChild(self)
	local function animationBack()
		self.daojuDrop:clickBackFun(self.itemQueueID)--GameData.uiOffsetY)*GameData.gameUIScaleRate
	end
	local flyPosition = self.itemType == "silver" and self.fightUI.yinliangText:getPosition() or self.fightUI.baoxiangText:getPosition()
	local addY = self.itemType == "silver" and 5 or 0
	local moveAction = CCMoveTo:create(0.7, ccp((flyPosition.x + 50),flyPosition.y+addY+GameData.uiOffsetY));
	local callBack = CCCallFunc:create(animationBack);
	local array = CCArray:create();
	local scale1 = CCScaleTo:create(0.7,0.4);
	local upArray = CCArray:create();
    upArray:addObject(CCEaseSineOut:create(moveAction,0.7));
    upArray:addObject(CCEaseSineOut:create(scale1,0.7));
	array:addObject(CCSpawn:create(upArray));
    array:addObject(callBack);
	self:runAction(CCSequence:create(array));
end

function DaojuDropItem:forceToMove(number)
	if self.hasFly then return end
	self:removeForceTimer()
	local function forceTimerFun()
		self:removeForceTimer()
		self:daojuAnimation2()
	end
	if number == 0 then
		forceTimerFun()
	else
		self.forceTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(forceTimerFun, 0.2*number, false)
	end
end

function DaojuDropItem:removeStayTimer()
    if self.stayTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.stayTimer);
        self.stayTimer = nil
    end
end

function DaojuDropItem:removeForceTimer()
    if self.forceTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.forceTimer);
        self.forceTimer = nil
    end
end

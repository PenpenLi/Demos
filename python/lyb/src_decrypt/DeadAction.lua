DeadAction = class();

function DeadAction:ctor()
	self.class = DeadAction;
	self.imageArray = {}
	self.pointX = nil
	self.pointY = nil
	self.pointArray1 = {{x=0,y=450},{x=330,y=330}}
	self.pointArray2 = {{x=-40,y=380},{x=260,y=300}}
	self.pointArray3 = {{x=60,y=460},{x=-230,y=380}}
	self.pointArray4 = {{x=100,y=420},{x=-200,y=330}}
	self.guideImage = nil
	self.loopTimes = 0;
	self.speed = 350;
end

function DeadAction:removeSelf()
	self.class = nil;
end

function DeadAction:dispose()
	self.imageArray = nil
	self.pointX = nil
	self.pointY = nil
	self.pointArray = nil
	self.pointArray1 = nil
	self.pointArray2 = nil
	self.guideImage = nil
	self.loopTimes = nil
	self:removeSelf();
end

function DeadAction:initAction(rolePosition,dircet)
	local random = math.random(2)
	if dircet == "right" and random == 1 then
		self.pointArray = self.pointArray1
	elseif dircet == "right" and random == 2 then
		self.pointArray = self.pointArray2
	elseif dircet == "left" and random == 1 then
		self.pointArray = self.pointArray3
	elseif dircet == "left" and random == 2 then
		self.pointArray = self.pointArray4
	end
	
	self.guideImage = Image.new();
	self.guideImage:loadByArtID(2420)
	self.guideImage:setPositionXY(rolePosition.x,rolePosition.y+40)
	self.guideImage:setVisible(false)
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS):addChild(self.guideImage)
  	for k1=1,10 do
  		local image = Image.new()
  		if k1==1 then
		  	image:loadByArtID(713)
		  	image:setPositionXY(rolePosition.x,rolePosition.y+40)
		  	 
  		else
		  	image:loadByArtID(2420)
		  	image:setPositionXY(rolePosition.x,rolePosition.y-3*k1+40)
		  	image:setScale(1 - 0.045*k1)
		  	image:setAlpha(1 - 0.025*k1)
  		end
  		image:setRotation(90)
  		image:setAnchorPoint(CCPointMake(0, 0.5));
  		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS):addChild(image)
		table.insert(self.imageArray,image)
  	end
  	local function frameHandle()
  		if not self.imageArray[1] or not self.guideImage or not self.imageArray[1].sprite or not self.guideImage.sprite then
  			self:removeCacheHandleTimer()
  			return;
  		end
		local px = self.imageArray[1]:getPositionX() + (self.guideImage:getPositionX() - self.imageArray[1]:getPositionX()) *0.7
		local py = self.imageArray[1]:getPositionY() + (self.guideImage:getPositionY() - self.imageArray[1]:getPositionY()) *0.7
		self.imageArray[1]:setPositionX(px);
		self.imageArray[1]:setPositionY(py);
		local arr = {};
		arr[1] = math.atan2(self.imageArray[1]:getPositionY() - self.guideImage:getPositionY(), self.imageArray[1]:getPositionX() - self.guideImage:getPositionX());
		self.imageArray[1]:setRotation(-arr[1] * 180 / 3.141593);
		for i=2,10 do
			arr[i] = math.atan2(self.imageArray[i]:getPositionY() - self.imageArray[i - 1]:getPositionY(), self.imageArray[i]:getPositionX() - self.imageArray[i - 1]:getPositionX());
			local ppx = self.imageArray[i]:getPositionX() + ((self.imageArray[i - 1]:getPositionX() - self.imageArray[i]:getPositionX()) / 1.1 + 5 * math.cos(arr[i]))
			local ppy = self.imageArray[i]:getPositionY() + ((self.imageArray[i - 1]:getPositionY() - self.imageArray[i]:getPositionY()) / 1.1 + 5 * math.sin(arr[i]))
			self.imageArray[i]:setPositionX(ppx);
			self.imageArray[i]:setPositionY(ppy);
			self.imageArray[i]:setRotation(-arr[i] * 180 / 3.141593);
		end
  end
  self.frameHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(frameHandle, 0, false)
  self:guideAnimation(rolePosition)
end

function DeadAction:loopAnimation()
	local effectLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS)
	local function animation()
		local dx = 90*GameData.gameUIScaleRate - effectLayer:getPositionX()-self.guideImage:getPositionX()
		local dy = 90 - self.guideImage:getPositionY();
		local distance1 = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
		if distance1 < 50 then
			self:addblowEffect()
			return;
		end
		self.loopTimes = self.loopTimes + 1;
		self:loopAnimation()
	end
	if self.loopTimes >= 5 then
		self:addblowEffect()
		return;
	end
	local px = (90*GameData.gameUIScaleRate - effectLayer:getPositionX()-self.guideImage:getPositionX())*0.5
	local py = (90 - self.guideImage:getPositionY())*0.5
	local distance2 = math.sqrt(math.pow(px, 2)+math.pow(py, 2));
	local moveAction = CCMoveBy:create(distance2/(self.speed+1700+self.loopTimes*1700), ccp(px,py));
	local callBack = CCCallFunc:create(animation);
	local array = CCArray:create();
	array:addObject(moveAction);
    array:addObject(callBack);
	self.guideImage:runAction(CCSequence:create(array));
end

function DeadAction:guideAnimation(rolePosition)
	local function animation()
		self:loopAnimation()
	end
	local callBack = CCCallFunc:create(animation);
	local array = CCArray:create();
	local ccB = ccBezierConfig:new()
	ccB.controlPoint_1 = ccp(rolePosition)
	ccB.controlPoint_2 = ccp(self.pointArray[1].x,self.pointArray[1].y)
	ccB.endPosition = ccp(self.pointArray[2].x,self.pointArray[2].y)
	local moveUp = CCBezierBy:create(self:getThreePTime(rolePosition),ccB);
	array:addObject(moveUp);
    array:addObject(callBack);
	self.guideImage:runAction(CCSequence:create(array));
end

function DeadAction:getThreePTime(rolePosition)
	local d1x = 0;
	local d1y = rolePosition.y - self.pointArray[1].y;
	local distance1 = math.sqrt(math.pow(d1x, 2)+math.pow(d1y, 2));
	local d2x = self.pointArray[1].x - self.pointArray[2].x;
	local d2y = self.pointArray[1].y - self.pointArray[2].y;
	local distance2 = math.sqrt(math.pow(d2x, 2)+math.pow(d2y, 2));
	return (distance1 + distance2)/self.speed
end

function DeadAction:removeCacheHandleTimer()
    if self.frameHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.frameHandle);
        self.frameHandle = nil
    end
end

function DeadAction:removeImageArray()
	local effectLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS)
	for k1, v1 in pairs(self.imageArray) do
		effectLayer:removeChild(v1)
	end
	self.imageArray = nil;
	effectLayer:removeChild(self.guideImage);
	self.guideImage = nil
end

function DeadAction:addblowEffect()
	local uiLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI)
	local fightUI = uiLayer:getChildByName("fightUI");
	local function removeEffect()
	  self:dispose()
	  if self.effect and self.effect.parent then
	        fightUI.movieClip5.layer:removeChild(self.effect)
	        self.effect = nil;
	  end
	end
	self.effect = cartoonPlayer("2477",90,90,1,removeEffect,1.3,nil,nil)
	self.effect.touchEnabled=false
    self.effect.touchChildren=false;
	fightUI.movieClip5.layer:addChild(self.effect)
	self:removeCacheHandleTimer()
	self:removeImageArray()
end


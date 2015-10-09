
BackBackGroundLayer = class(Layer);

function BackBackGroundLayer:ctor()
  self.class = BackBackGroundLayer;
  self.LEFT = 0;
  self.RIGHT = 1;
end

function BackBackGroundLayer:dispose()
	self:removeReviseTimer()
	self:removeAllEventListeners();
	self:removeChildren();
	BackBackGroundLayer.superclass.dispose(self);
end

function BackBackGroundLayer:onInit()    
  	self:initLayer();
end

function BackBackGroundLayer:setData(artId)
	self.bgImage = Image.new()
	self.bgImage:loadByArtID(artId)
	self:addChild(self.bgImage)

	self.IMAGE_WIDTH = self.bgImage:getContentSize().width

	self.bgImage2 = Image.new()
	self.bgImage2:loadByArtID(artId)
	self:addChild(self.bgImage2)
	self.bgImage2:setPositionX(self.IMAGE_WIDTH);
  -- local moveTo = CCMoveTo:create(0.8, CCPointMake(, ))
  -- local callBack = CCCallFunc:create(moveCallBack);
  -- local arr = CCArray:create();

  -- arr:addObject(moveTo);  
  -- arr:addObject(callBack); 
  -- self.image:runAction(CCSequence:create(arr));   

  self.MINX = 1280 - self.bgImage:getContentSize().width

  self.winSize = Director:sharedDirector():getWinSize();

  self.bgImage:setPositionY(400);
  self.bgImage2:setPositionY(400);
  self:reviseMapMove();
  -- local moveTo = CCMoveTo:create(15, ccp(winSize.width - self.bgImage:getContentSize().width, 0))
  -- local moveBack = CCMoveTo:create(15, ccp(0, 0))
  -- self.bgImage:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(moveTo, moveBack)))
end

function BackBackGroundLayer:reviseMapMove()
	self.direction = self.RIGHT;
    local function reviseTimer()
        self:revise_Map_Move()
    end
    self.reviseTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(reviseTimer, 0, false)
end
function BackBackGroundLayer:revise_Map_Move()

    if self.bgImage then
    	local stepX = -1;
      --右+左-
      local xPos = self:getPositionX()
      local bgXPos = self.bgImage:getPositionX()
      local bg2XPos = self.bgImage2:getPositionX()

      if xPos and bgXPos and bg2XPos then
    		local globalX1 = xPos + bgXPos
    		local globalX2 = xPos + bg2XPos
    		
    		if globalX1 < -self.IMAGE_WIDTH then
    	        self.bgImage:setPositionX(bg2XPos + self.IMAGE_WIDTH + stepX);
    		elseif globalX1 < self.MINX then	
    			self.bgImage:setPositionX(bgXPos + stepX);
    		else
    			self.bgImage:setPositionX(bgXPos + stepX);
    		end
    		if globalX2 < -self.IMAGE_WIDTH then
    	        self.bgImage2:setPositionX(bgXPos + self.IMAGE_WIDTH + stepX);
    		elseif globalX2 < self.MINX then	
    			self.bgImage2:setPositionX(bg2XPos + stepX);
    		else
    			self.bgImage2:setPositionX(bg2XPos + stepX);
    		end
      end
    else
      self:removeReviseTimer()
    end
end
function BackBackGroundLayer:removeReviseTimer()
  if self.reviseTimer then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.reviseTimer);
  end
  self.reviseTimer = nil;
end

function BackBackGroundLayer:clean()
	self:removeReviseTimer()
	self:removeChildren();
  self.bgImage = nil;
  self.bgImage2 = nil;
end

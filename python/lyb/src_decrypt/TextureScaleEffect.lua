TextureScaleEffect = class(Layer);

function TextureScaleEffect:ctor()
	self.class = TextureScaleEffect;
end

function TextureScaleEffect:dispose()
	self:removeAllEventListeners();
  	self:removeChildren();
	TextureScaleEffect.superclass.dispose(self);
	self.nextDO = nil;
	self.textureSprite = nil;
	--textureScaleEffectSelf = nil;
	self.desScale = nil;
end

function TextureScaleEffect:initialize(textureSprite,desScale)
	self:initLayer();
	self.nextDO = nil;
	--textureScaleEffectSelf = self;
	self.textureSprite = textureSprite;
	--self.textureSprite:setVisible(false);
	self:setAnchorPoint(ccp(0.5,0.5));
	self:setContentSize(textureSprite:getGroupBounds().size);
	self.textureSprite:setAnchorPoint(ccp(0.5,0.5));
	self.textureSprite:setPositionXY(0,0);
	self:addChild(self.textureSprite);
	self.desScale = desScale;
end

function TextureScaleEffect:nextEffect(nextDO)
	self.nextDO = nextDO;
end


function TextureScaleEffect:start(actionTime, scale, delayTime, context, cbfunction)
	if not scale then scale=100; end
	self.textureSprite:setScale(scale);
	local ccArray = CCArray:create();
	local function setVisible()
		if self.textureSprite then
			self.textureSprite:setVisible(true);
		end
	end

	local function nextEffectFun()
		if self.nextDO then
			self.nextDO:start(actionTime);
		end
	end
	ccArray:addObject(CCCallFunc:create(setVisible));
	ccArray:addObject(CCEaseSineOut:create(CCScaleTo:create(actionTime,self.desScale)));
	ccArray:addObject(CCDelayTime:create(0.1));
	
	ccArray:addObject(CCCallFunc:create(nextEffectFun));
	if delayTime then
		ccArray:addObject(CCDelayTime:create(delayTime));
	end
	if cbfunction then
		local function cb()
			cbfunction(context,self);
		end
		ccArray:addObject(CCCallFunc:create(cb));
	end
	self.textureSprite:runAction(CCSequence:create(ccArray));
end

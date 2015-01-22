require "hecore.display.Director"

TileCharacter = class(CocosObject)

local kTileContentSize = 65
local kResourcePrefix = "flash/"
local kCharacterAnimationTime = 1/30
local kCharacterSelectAnimationNum = 30
local kCharacterNormalAnimationNum = 50
local kCharacterLinearAnimationNum = 29
local kCharacterWrapperAnimationNum = 49
local kCharacterDestroyAnimationNum = 27

kTileCharacterAnimation = {
	kNormal = 1, kUp = 2, kDown = 3, kLeft = 4, kRight = 5, 
	kLineColumn = 6, kLineRow = 7, kWrap = 8,
	kSelect = 9, kDestroy = 10
}

function TileCharacter:toString()
	return string.format("TileCharacter [%s]", self.name and self.name or "nil");
end

function TileCharacter:create( name )
	local pngName = SpriteUtil:getRealResourceName(kResourcePrefix..name..".png");
	
	local node = TileCharacter.new(CCNode:create())
	node.name = name

	-- local hitArea = CocosObject:create()
	-- hitArea.name = kHitAreaObjectName
	-- hitArea:setContentSize(CCSizeMake(kTileContentSize, kTileContentSize))
	-- node:addChild(hitArea)

	local baseNode = CocosObject:create()
	baseNode:setRefCocosObj(CCSpriteBatchNode:create(pngName, 4));
	node:addChild(baseNode);

  	local mainSprite = Sprite:createWithSpriteFrameName(name.."_click_0.png")

  	baseNode:addChild(mainSprite)
  	baseNode.name = "baseNode"
  	node:addChild(baseNode)

  	node.mainSprite = mainSprite

  	return node
end

function TileCharacter:play( animation, delayTime )
	self:stopAllAnimations()

	if animation == kTileCharacterAnimation.kNormal then self:playNormalAnimation()
	elseif animation == kTileCharacterAnimation.kSelect then self:playDirectionAnimation(animation)
	elseif animation == kTileCharacterAnimation.kUp then self:playDirectionAnimation(animation)
	elseif animation == kTileCharacterAnimation.kDown then self:playDirectionAnimation(animation)
	elseif animation == kTileCharacterAnimation.kLeft then self:playDirectionAnimation(animation)
	elseif animation == kTileCharacterAnimation.kRight then self:playDirectionAnimation(animation) 
	elseif animation == kTileCharacterAnimation.kLineColumn then self:playLineAnimation(animation) 
	elseif animation == kTileCharacterAnimation.kLineRow then self:playLineAnimation(animation) 
	elseif animation == kTileCharacterAnimation.kWrap then self:playWrapAnimation(animation, delayTime)
	elseif animation == kTileCharacterAnimation.kDestroy then self:playDestroyAnimation()
	end
end

function TileCharacter:stopAllAnimations()
	if self.mainSprite then self.mainSprite:setVisible(false) end;

	if self.mainSprite then self.mainSprite:stopAllActions() end;
end

function TileCharacter:playNormalAnimation()
	return;
end

function TileCharacter:playSelectAnimation()
  	local context = self
	local pattern = self.name .. "_click_%d.png"
  	local function playAnim()
		local number = kCharacterSelectAnimationNum
		local frames = SpriteUtil:buildFrames(pattern, 0, number)
	  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
  		context.mainSprite:play(animate, 0, 1)
  	end

  	local sequenceAction = CCSequence:createWithTwoActions(CCCallFunc:create(playAnim), CCDelayTime:create(2))
  	self.mainSprite:removeFromParentAndCleanup(true)
	self.mainSprite = Sprite:createWithSpriteFrameName(string.format(pattern, 0))
	self:addChild(self.mainSprite)
  	if self.name == "cat" then
  		self.mainSprite:setPosition(ccp(0.5, -3.5))
  	elseif self.name == "fox" then 
  		self.mainSprite:setPosition(ccp(0.5,-1.5))
  	elseif self.name == "horse" then 
  		self.mainSprite:setPosition(ccp(1,-0.8))
  	elseif self.name == "chicken" then 
  		self.mainSprite:setPosition(ccp(0.8,-0.7))
  	elseif self.name == "bear" then 
  		self.mainSprite:setPosition(ccp(1,0))
  	elseif self.name == "frog" then 
  		self.mainSprite:setPosition(ccp(0,-0.5))
  	end
  	self.mainSprite:runAction(CCRepeatForever:create(sequenceAction))
end

function TileCharacter:stopSelectAnimation()
	if self.mainSprite then
		self.mainSprite:setPosition(ccp(0, 0))
		self.mainSprite:stopAllActions()
	end
end

---取消方向动画
function TileCharacter:playDirectionAnimation(animation)
	return;
	-- if self.name == "fox" then 
	-- 	self:playNormalAnimation()
	-- 	return
	-- end

	-- self.mainSprite:setVisible(true)

	-- local pattern = self.name
	-- if animation == kTileCharacterAnimation.kSelect then pattern = pattern.."_select%04d"
	-- elseif animation == kTileCharacterAnimation.kUp then pattern = pattern.."_up%04d"
	-- elseif animation == kTileCharacterAnimation.kDown then pattern = pattern.."_down%04d"
	-- elseif animation == kTileCharacterAnimation.kLeft then pattern = pattern.."_left%04d"
	-- elseif animation == kTileCharacterAnimation.kRight then pattern = pattern.."_right%04d" end

	-- local number = kCharacterNormalAnimationNum
	-- if animation == kTileCharacterAnimation.kSelect then number = kCharacterSelectAnimationNum end
	-- local frames = SpriteUtil:buildFrames(pattern, 0, number)
 --  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
 --  	self.mainSprite:play(animate)
end

function TileCharacter:playLineAnimation( animation )
	self.mainSprite:setVisible(true)

	local characterPattern = self.name;
	if animation == kTileCharacterAnimation.kLineColumn then 
		characterPattern = characterPattern.."_column_%d.png"
	elseif animation == kTileCharacterAnimation.kLineRow then 
		characterPattern = characterPattern.."_line_%d.png" 
	end

	self.mainSprite:removeFromParentAndCleanup(true)
	self.mainSprite = Sprite:createWithSpriteFrameName(string.format(characterPattern, 0))
	self:addChild(self.mainSprite)

	local frames = SpriteUtil:buildFrames(characterPattern, 0, kCharacterLinearAnimationNum)
  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
  	self.mainSprite:play(animate)

  	local effectPattern = "Line_Effect_%d.png"
  	local eframes = SpriteUtil:buildFrames(effectPattern, 0, 14)
  	local eanimate1 = SpriteUtil:buildAnimate(eframes, kCharacterAnimationTime)
  	local eanimate2 = SpriteUtil:buildAnimate(eframes, kCharacterAnimationTime)

  	local part1 = Sprite:createWithSpriteFrameName("Line_Effect_0.png");
  	local part2 = Sprite:createWithSpriteFrameName("Line_Effect_0.png");

  	part1:play(eanimate1);
  	part2:play(eanimate2);

	local baseNode = CocosObject:create()
	baseNode:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/TileEffect.png"), 4));
	baseNode.name = "tileEffect"
	self:addChild(baseNode);

	if animation == kTileCharacterAnimation.kLineColumn then 
		baseNode:setRotation(90);
		baseNode:setPosition(ccp(1.8,0));
	end
	baseNode:addChild(part1);
	baseNode:addChild(part2);

	part1:setPosition(ccp(-30, 0))
	part2:setPosition(ccp(30, 0))

	part2:setFlipX(true);
end

local es_spx = {-33, -27, -18, -4, 13, 26, 29}
local es_spy = {-26, 21, -30, -28, 30, -20, 10}

local es_epx = {-33, -27, -18, -4, 13, 26, 29}
local es_epy = {-2, 33, -25, -21, 34, 1, 33}

local es_delay = {0, 0.08, 0.21, 0.13, 0.28, 0.25, 0.19}
local es_sc = {0.22, 0.25, 0.33, 0.42, 0.36, 0.4, 0.31}

function TileCharacter:playWrapAnimation(animation, delayTime)
	self.mainSprite:setVisible(true)

	local characterPattern = self.name.."_wrap_%d.png";

	self.mainSprite:removeFromParentAndCleanup(true)
	self.mainSprite = Sprite:createWithSpriteFrameName(string.format(characterPattern, 0))
	self.mainSprite.name = "mainSprite"
	self:addChild(self.mainSprite)
	
	local frames = SpriteUtil:buildFrames(characterPattern, 0, kCharacterWrapperAnimationNum)
  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
  	self.mainSprite:play(animate)

	local baseNode = CocosObject:create()
	baseNode:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/TileEffect.png"), 20));
	baseNode.name = "tileEffect"
	self:addChild(baseNode);

  	for i=1,#es_spx do
	  	local effectStar_C = Sprite:createWithSpriteFrameName("Wrap_Effect_Star.png");
  		effectStar_C:setPosition(ccp(es_spx[i], es_spy[i]));
  		effectStar_C:setScale(es_sc[i]);
  		baseNode:addChild(effectStar_C);

		local function onTimeout()
			local delayAction = CCDelayTime:create(es_delay[i]);						----等待
	  		local showAction = CCFadeTo:create(0.2, 200 + i * i);						----显示
	  		local movetoAction = CCMoveTo:create(0.5, ccp(es_epx[i], (es_epy[i] + es_spy[i]) / 2));			----移动
	  		local sp1 = CCSpawn:createWithTwoActions(showAction, movetoAction); 

	  		local delayAction2 = CCDelayTime:create(0.1);						----等待
	  		local showAction2 = CCFadeTo:create(0.3, 0);						----显示
	  		local movetoAction2 = CCMoveTo:create(0.4, ccp(es_epx[i], es_epy[i]));			----移动
	  		local sq1 = CCSequence:createWithTwoActions(delayAction2, showAction2);
	  		local sp2 = CCSpawn:createWithTwoActions(sq1, movetoAction2);

	  		local movetoAction3 = CCMoveTo:create(0.01, ccp(es_spx[i], es_spy[i]));

	  		local arr = CCArray:create();
	  		arr:addObject(delayAction)
	  		arr:addObject(sp1)
	  		arr:addObject(sp2)
	  		arr:addObject(movetoAction3);
			effectStar_C:stopAllActions()
			effectStar_C:runAction(CCRepeatForever:create(CCSequence:create(arr)))
		end

		delayTime = delayTime or 0
  		effectStar_C:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), CCCallFunc:create(onTimeout)))
  	end
end

function TileCharacter:playDestroyAnimation()
	--self.destroySprite:setVisible(true)
	--local frames = SpriteUtil:buildFrames(self.name.."_destroy%04d", 0, kCharacterDestroyAnimationNum)
  	--local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)

 --  	local function onRepeatFinishCallback()
 --  		self:dp(Event.new(Events.kComplete, kTileCharacterAnimation.kDestroy, self))
 --  		self:removeFromParentAndCleanup(true);				----将自己从父节点删除
 --  	end 
 --  	self:addChild(destroySprite);

 --  	local destroySprite = Sprite:createWithSpriteFrameName("destroy_effect_0.png")
	-- local frames = SpriteUtil:buildFrames("destroy_effect_%d.png", 0, 20)
 --  	local animate = SpriteUtil:buildAnimate(frames, kCharacterAnimationTime)
	-- destroySprite:play(animate, 0, 1, onRepeatFinishCallback)

  	--self.destroySprite:play(animate, 0, 1, onRepeatFinishCallback)
end
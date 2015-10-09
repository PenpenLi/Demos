require "main.common.effectdisplay.TextureScaleEffect"
require "main.common.effectdisplay.EffectFigure";

LevelUpEffect = class(TouchLayer)

function LevelUpEffect:ctor()
	self.class = LevelUpEffect;
	self.levelUpSkeleton = nil;
end

function LevelUpEffect:dispose()
	self:removeAllEventListeners();
   self:removeChildren();
	LevelUpEffect.superclass.dispose(self);
	self.armature:dispose()
	levelUpSelf = nil
	BitmapCacher:removeUnused();
end


local function setLvInfo(sprite)
	local currentLv = sprite.currentLv;
	local nextLv = sprite.nextLv;
	local arrow = sprite.arrow;
	local currentLvInfo = sprite.currentLvInfo;
	local currentLvPos = sprite.currentLvPos;
	local nextLvInfo = sprite.nextLvInfo;
	local nextLvPos = sprite.nextLvPos;
	currentLv:setVisible(true); 
	nextLv:setVisible(true); 
	arrow:setVisible(true); 
	
	local str = tostring(currentLvInfo.lv);
	local lenght = string.len(str);
	for i=1,lenght do
		local tmp = string.sub(str,i,i);
		local currentNum = levelUpSelf.levelUpSkeleton:getCommonBoneTextureDisplay("common_vip_big_num_"..tmp);
		levelUpSelf.armature.display:addChild(currentNum);
		currentNum:setPosition(currentLvPos);
		currentLvPos.x = currentLvPos.x + currentNum:getGroupBounds().size.width;
	end
	--[[local nextNum = EffectFigure.new();
	nextNum:initialize(levelUpSelf.effectProxy,2,nextLvInfo.lv,_,_,false);
	levelUpSelf.armature.display:addChild(nextNum);
	nextNum:setPosition(nextLvPos);
	
	nextNum:start();]]
    
    local nextLevelLayer = Layer.new();
    nextLevelLayer:initLayer();
	str = tostring(nextLvInfo.lv);
	lenght = string.len(str);
	local xPos = 0;
	for i=1,lenght do
		local tmp = string.sub(str,i,i);
		local nextNum = levelUpSelf.levelUpSkeleton:getCommonBoneTextureDisplay("common_vip_big_num_"..tmp);
		  
		--[[levelUpSelf.armature.display:addChild(nextNum);
		nextNum:setPosition(nextLvPos);
		nextLvPos.x = nextLvPos.x + nextNum:getGroupBounds().size.width;]]
        nextNum:setPositionXY(xPos, 0);
		nextLevelLayer:addChild(nextNum);
		xPos = xPos + nextNum:getGroupBounds().size.width;
	end
	levelUpSelf.armature.display:addChild(nextLevelLayer);
	nextLevelLayer:setPosition(nextLvPos);
	local ccArray = CCArray:create();
    local scale1 = CCScaleTo:create(0.3,2);
    ccArray:addObject(scale1)
    local delay = CCDelayTime:create(0.1);
    ccArray:addObject(delay)
    local scale2 = CCScaleTo:create(0.3,1);
    ccArray:addObject(scale2)
    nextLevelLayer:runAction(CCSequence:create(ccArray));
end
local function selfRemove()
	levelUpSelf.parent:dispatchEvent(Event.new("REMOVE_LEVELUP_EFFECT", nil, self))
	levelUpSelf.playerLayer.levelUp = nil;
	levelUpSelf:removeAllEventListeners();
	levelUpSelf.parent:removeChild(levelUpSelf);
end
function LevelUpEffect:initializeUI(effectProxy, currentLvInfo, nextLvInfo, playerLayer)
	self.playerLayer = playerLayer;
	self.levelUpSkeleton = effectProxy:getLevelUpSkeleton();
	self.basicSkeleton = effectProxy:getBasicSkeleton();
	self.effectProxy = effectProxy;
	
	self:initLayer();
	levelUpSelf = self
	self.armature = self.levelUpSkeleton:buildArmature("main");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();

	local function removeEffect()
		self.parent:dispatchEvent(Event.new("REMOVE_LEVELUP_EFFECT", nil, self))
		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):removeChild(self);
		self.playerLayer.levelUp = nil;
	end

	local bg = LayerColorBackGround:getTransBackGround();
	-- bg:addEventListener(DisplayEvents.kTouchTap,removeEffect,self);
    local size = bg:getContentSize();
	 self:changeWidthAndHeight(size.width,size.height);
  
  	self:addChild(self.armature.display);
	self:addChild(bg);
	
	local upperArrary = CCArray:create();
	
    local level_title_bg = self.armature:getBone("level_title_bg"):getDisplay();
    self:starAnimation(level_title_bg, 1)

	--上侧底图
	local upperSideBG = self.armature:getBone("uppersideBG"):getDisplay();
	upperArrary:addObject(CCDelayTime:create(0.3));

	local halfAlphaBG = self.armature:findChildArmature("uppersideBG"):getBone("common_button_bg"):getDisplay()
	halfAlphaBG:addChild(LayerColorBackGround:getCustomBackGround(1280,320,150))
	
	--等级变化
	local currentLv = self.armature:getBone("currentLv"):getDisplay();
	local nextLv = self.armature:getBone("nextLv"):getDisplay();
	local arrow = self.armature:getBone("arrow"):getDisplay();
	
	local tmpDO = self.armature:getBone("currentLvNumHolder"):getDisplay();
	local currentLvPos = tmpDO:getPosition();
	currentLvPos.y = currentLvPos.y - tmpDO:getGroupBounds().size.height;
	self.armature.display:removeChild(tmpDO);
	tmpDO = nil;
	
	tmpDO = self.armature:getBone("nextLvNumHolder"):getDisplay();
	local nextLvPos = tmpDO:getPosition();
	nextLvPos.y = nextLvPos.y - tmpDO:getGroupBounds().size.height;
	self.armature.display:removeChild(tmpDO);
	tmpDO = nil;
	
	currentLv:setVisible(false);
	nextLv:setVisible(false);
	arrow:setVisible(false);
	
	upperSideBG.sprite.currentLv = currentLv;
	upperSideBG.sprite.nextLv = nextLv;
	upperSideBG.sprite.arrow = arrow;
	upperSideBG.sprite.currentLvInfo = currentLvInfo;
	upperSideBG.sprite.currentLvPos = currentLvPos;
	upperSideBG.sprite.nextLvInfo = nextLvInfo;
	upperSideBG.sprite.nextLvPos = nextLvPos;
	
	
	upperArrary:addObject(CCCallFuncN:create(setLvInfo));
	upperArrary:addObject(CCDelayTime:create(2.5));

	upperArrary:addObject(CCCallFunc:create(selfRemove));
	
	upperSideBG:runAction(CCSequence:create(upperArrary));
	
	self.armature.display:setPositionY(0);
	-------------------------------------------
end

function LevelUpEffect:starAnimation(singalStar,i)
	--[[local function animationComplete()
		ScreenShake:generalShake(self,5,5,3,3)
	end]]
	--singalStar:setAnchorPoint(CCPointMake(0.5,0.45));
	--singalStar:setAnchorPoint(CCPointMake(0.5,0.5));
 	singalStar:setScale(15);

 	singalStar:setOpacity(0)

	local num;
	if i==1 then num = 0.3 end;
	local ccArray = CCArray:create();
	local fadeArray = CCArray:create();
    --local upCallBack = CCCallFunc:create(animationComplete);
    local upDelay = CCDelayTime:create(num);
    local fadeTo = CCFadeIn:create(0.2, 1);
    local scale = CCScaleTo:create(0.2,1);
    local scaleEaseOut = CCEaseSineIn:create(scale,0.2);
    local fadeToEaseOut = CCEaseSineIn:create(fadeTo,0.2);
	fadeArray:addObject(scaleEaseOut);
	fadeArray:addObject(fadeToEaseOut);

    local fade = CCSpawn:create(fadeArray);
	ccArray:addObject(upDelay);
	ccArray:addObject(fade);
	--ccArray:addObject(upCallBack);
	singalStar:runAction(CCSequence:create(ccArray));
end

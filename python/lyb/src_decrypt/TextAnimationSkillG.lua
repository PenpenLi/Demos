--没有用
TextAnimationSkillG = class(Layer);
function TextAnimationSkillG:ctor()
	self.class = TextAnimationSkillG;  
  self.index = 0;
  self.name = "TextAnimationSkillG";
  self.textTable = {};
end

function TextAnimationSkillG:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  TextAnimationSkillG.superclass.dispose(self);
  self:removeLimitTimer();
  self.aiEngin = nil
  self.opacity = nil;
end
----------------
--center 2787,177,1489-------;175,176
----------------
function TextAnimationSkillG:textAnimation(numStr,bankPO,aiEngin)
  self.touchChildren = false;
  self.touchEnabled = false;
  self.skillNameId = numStr;
  self.bankPO = bankPO;
  self.aiEngin = aiEngin
  self.opacity = 0;
  local timeNum = BattleConfig.Battle_Card_TimeOut
  if not aiEngin.battleScene.battleProxy:isHandByUser(aiEngin.battleScene.userProxy) then
      timeNum = timeNum*2
  end
  self:removeLimitTimer();
  local function limitHandle()
        self:removeLimitTimer();
        local num1 = 30;
        local siteX = -num1*4/2;
        self:addImage(numStr,bankPO)
        self:oneAnimation();
  end
  self.limitHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(limitHandle, timeNum, false);
end

function TextAnimationSkillG:addImage(numStr,bankPO)
  if not bankPO then return end
  self.blackBg = LayerColorBackGround:getBlackBackGround()
  self.blackBg:setOpacity(self.opacity)
  self.blackBg:setPositionXY(-60,-100);
  self:addChild(self.blackBg);

  self.imageBgDown = Image.new()
  self.imageBgDown:loadByArtID(176)
  self.imageBgDown:setOpacity(self.opacity)
  self.imageBgDown:setScale(0.9)
  self.imageBgDown:setAnchorPoint(CCPointMake(0.5,0));
  self.imageBgDown:setPositionXY(GameConfig.STAGE_WIDTH/3.4,GameConfig.STAGE_HEIGHT/1.5);
  self:addChild(self.imageBgDown)

  self.imageIcon = Image.new()
  self.imageIcon:loadByArtID(bankPO.art1)
  self.imageIcon:setOpacity(self.opacity)
  self.imageIcon:setScale(0.5)
  --self.imageIcon.sprite:setFlipX(-1);
  self.imageIcon:setAnchorPoint(CCPointMake(0.5,0));
  self.imageIcon:setPositionXY(GameConfig.STAGE_WIDTH/3.3,GameConfig.STAGE_HEIGHT/2.4);
  self:addChild(self.imageIcon)

  self.imageBg = Image.new()
  self.imageBg:loadByArtID(175)
  self.imageBg:setOpacity(self.opacity)
  self.imageBg:setScale(0.9)
  self.imageBg:setAnchorPoint(CCPointMake(0.5,0));
  self.imageBg:setPositionXY(GameConfig.STAGE_WIDTH/2.8,GameConfig.STAGE_HEIGHT/3.1);
  self:addChild(self.imageBg)

  self.skillImage = Image.new()
  self.skillImage:loadByArtID(numStr)
  self.skillImage:setPositionXY(GameConfig.STAGE_WIDTH/6,GameConfig.STAGE_HEIGHT/2.5);
  self:addChild(self.skillImage)
  self.skillImage:setOpacity(self.opacity)
end
----------------
-- one animation
----------------
function TextAnimationSkillG:oneAnimation()
        ----------------
        -- two animation Complete
        ----------------
        local function twoAnimationComplete()
          self:removeAllEventListeners();
          self:removeChildren();
          self:getParent():removeChild(self);
          if self.heroLayer then
              self.heroLayer:getParent():removeChild(self.heroLayer);
          end
        end
        ----------------
        -- two animation
        ----------------
        local function twoAnimation()
                local upCallBack = CCCallFunc:create(twoAnimationComplete);
                local fadeOut = CCFadeTo:create(0.2,0);
                --local upMoveUp = CCMoveBy:create(0.2, ccp(GameConfig.STAGE_WIDTH/2,0));
                local arr = CCArray:create();
                --local arr1 = CCArray:create();
                local delay = CCDelayTime:create(0.5);
                --local upArray = CCArray:create();
                --upArray:addObject(upMoveUp);
                --upArray:addObject(fadeOut);
                --local upSpawn = CCSpawn:create(upArray);
                arr:addObject(delay);
                arr:addObject(fadeOut);
                --arr1:addObject(delay);
                --arr1:addObject(fadeOut);
                local sequence = CCSequence:create(arr)
                self.imageIcon:runAction(sequence:copy():autorelease())
                --self.imageName:runAction(sequence:copy():autorelease())
                self.imageBgDown:runAction(sequence:copy():autorelease())
                self.imageBg:runAction(sequence:copy():autorelease())
                self.skillImage:runAction(sequence:copy():autorelease())
                self.blackBg:runAction(CCSequence:createWithTwoActions(CCSequence:create(arr),upCallBack));
                if self.aiEngin.battleScene.battleProxy:isHandByUser(self.aiEngin.battleScene.userProxy) then
                    self:cloneMyself()
                end
        end
        ----------------
        -- one animation
        ---------------- 
        local callBack = CCCallFunc:create(twoAnimation);
        local fadeTo2 = CCFadeTo:create(0.15,160);
        local fadeTo3 = CCFadeTo:create(0.15,160);
        self.imageIcon:runAction(fadeTo3:copy():autorelease())
        --self.imageName:runAction(fadeTo3:copy():autorelease())
        self.imageBgDown:runAction(fadeTo3:copy():autorelease())
        self.skillImage:runAction(fadeTo3:copy():autorelease())
        self.blackBg:runAction(CCSequence:createWithTwoActions(fadeTo2, callBack));
        self.imageBg:runAction(fadeTo3:copy():autorelease())
end

function TextAnimationSkillG:removeAnimation()
        if not self.imageIcon then return end
        local function twoAnimationComplete()
          self:getParent():removeChild(self);
          self:removeSelf();
          if self.heroLayer then
              self.heroLayer:getParent():removeChild(self.heroLayer);
          end
        end
        local upCallBack = CCCallFunc:create(twoAnimationComplete);
        local fadeTo = CCFadeTo:create(0.2,0);
        --local upMoveUp = CCMoveBy:create(0.2, ccp(GameConfig.STAGE_WIDTH/2,0));
        --local upArray = CCArray:create();
        --upArray:addObject(upMoveUp);
        --upArray:addObject(fadeTo);
        --local upSpawn = CCSpawn:create(upArray);
        self.imageIcon:runAction(fadeTo:copy():autorelease())
        --self.imageName:runAction(upSpawn:copy():autorelease())
        self.imageBgDown:runAction(fadeTo:copy():autorelease())
        self.skillImage:runAction(fadeTo:copy():autorelease())
        self.blackBg:runAction(CCSequence:createWithTwoActions(fadeTo,upCallBack));
        self.imageBg:runAction(fadeTo:copy():autorelease())
end

function TextAnimationSkillG:removeLimitTimer()
    if self.limitHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.limitHandle);
        self.limitHandle = nil
    end
end

function TextAnimationSkillG:cloneMyself()
    self.opacity = 255
    local textAnimationSkillG = TextAnimationSkillG.new();
    textAnimationSkillG:initLayer();
    textAnimationSkillG:setPositionXY(-350,-500)
    textAnimationSkillG:addImage(self.skillNameId,self.bankPO);

    local heroLayer = Layer.new()
    heroLayer:initLayer()
    heroLayer:setPositionXY(350,500)
    heroLayer:setAnchorPoint(CCPointMake(0.6,0.4))
    heroLayer:addChild(textAnimationSkillG)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(heroLayer);

    local fadeOut = CCFadeTo:create(0.5,0);
    local scale = CCScaleTo:create(0.5,2);
    textAnimationSkillG.imageIcon:runAction(fadeOut:copy():autorelease())
    textAnimationSkillG.imageBgDown:runAction(fadeOut:copy():autorelease())
    textAnimationSkillG.imageBg:runAction(fadeOut:copy():autorelease())
    textAnimationSkillG.skillImage:runAction(fadeOut:copy():autorelease())
    textAnimationSkillG.blackBg:runAction(fadeOut:copy():autorelease());

    heroLayer:runAction(scale);
    self.heroLayer = heroLayer;
end
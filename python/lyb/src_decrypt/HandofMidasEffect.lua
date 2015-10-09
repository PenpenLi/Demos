-------------------------------------------------------------------------
--  Class include: HandofMidasEffect
-------------------------------------------------------------------------

HandofMidasEffect = class(TouchLayer);
function HandofMidasEffect:ctor()
	self.class = HandofMidasEffect;  
end

function HandofMidasEffect:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    HandofMidasEffect.superclass.dispose(self);
end
----------------
--center
----------------
function HandofMidasEffect:textAnimation(strAndNum,skeleton, context)
  self:initLayer()
  self.touchChildren = false;
  self.touchEnabled = false;
  self.context = context;

  self.effectArmature = skeleton:buildArmature("baojiEffect");
  self:addChild(self.effectArmature.display);

  if not self.effectArmature.display then
    print("self.effectArmature.display")
  end

  local long = string.len(strAndNum);
  
  local common_battle_bigred0 = self.effectArmature.display:getChildByName("bigred0")
  local common_battle_bigred1 = self.effectArmature.display:getChildByName("bigred1")
  
  self.bigred0Pos = convertBone2LB(common_battle_bigred0);
  self.bigred1Pos = convertBone2LB(common_battle_bigred1);

  self.effectArmature.display:removeChild(common_battle_bigred0)
  self.effectArmature.display:removeChild(common_battle_bigred1)
  print("long", long)

  for i = 1, long do
    local str = string.sub(strAndNum, i, i);
    str = tonumber(str);
    print("str", str)
    local xPos = (i-1) * 40 + 60;
    local yPos = 30;
    self:numTextNeg(str,xPos,yPos,skeleton);
  end
  self:starAnimation();
  local animationFunctionID
  local function animationCallBack()
      self.context:callBack();
      Director:sharedDirector():getScheduler():unscheduleScriptEntry(animationFunctionID);
      self.parent:removeChild(self)
  end
  animationFunctionID =Director:sharedDirector():getScheduler():scheduleScriptFunc(animationCallBack, 1.5, false);
end


function HandofMidasEffect:numTextNeg(numStr,xPos,yPos,skeleton)
  local tempString = "bigred";
  local bigred = skeleton:getBoneTextureDisplay(tempString..numStr);
  bigred:setPositionXY(xPos, yPos);
  bigred:setAnchorPoint(ccp(0.5,0.5))
  self.effectArmature.display:addChild(bigred);
end
function HandofMidasEffect:starAnimation()
  self:setScale(6);

  local num = 0.3
  local ccArray = CCArray:create();
  local fadeArray = CCArray:create();
    --local upCallBack = CCCallFunc:create(animationComplete);
  local upDelay = CCDelayTime:create(num);
  local fadeTo = CCFadeIn:create(0.03, 1.5);
  local scale = CCScaleTo:create(0.03,1.5);
  local scaleEaseOut = CCEaseSineIn:create(scale,0.03);
  local fadeToEaseOut = CCEaseSineIn:create(fadeTo,0.03);

  fadeArray:addObject(scaleEaseOut);
  fadeArray:addObject(fadeToEaseOut);

    local fade = CCSpawn:create(fadeArray);
  ccArray:addObject(upDelay);
  ccArray:addObject(fade);
  --ccArray:addObject(upCallBack);
  self:runAction(CCSequence:create(ccArray));
end

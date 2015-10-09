--没有用
TextAnimationSkillPet = class(Layer);
function TextAnimationSkillPet:ctor()
  self.class = TextAnimationSkillPet;  
  self.index = 0;
  self.name = "TextAnimationSkillPet";
  self.textTable = {};
end

function TextAnimationSkillPet:textAnimation(skillNameId)
  --local num1 = 30;
  --local siteX = -num1*4/2;
  self.touchChildren = false;
  self.touchEnabled = false;
  self:hanZiText(skillNameId)
  self:setScale(0);
  self:oneAnimation();
end

function TextAnimationSkillPet:oneAnimation()
        ----------------
        -- two animation Complete
        ----------------
        local function twoAnimationComplete()
          self:removeAllEventListeners();
          self:removeChildren();
          self:getParent():removeChild(self);
        end
        ----------------
        -- two animation
        ----------------
        local function twoAnimation()
                local upArray = CCArray:create();
                local upMoveUp = CCMoveBy:create(0.4, ccp(0,GameConfig.STAGE_HEIGHT/3));
                local upCallBack = CCCallFunc:create(twoAnimationComplete);
                local fadeOut = CCFadeTo:create(0.2, 1);
                
                upArray:addObject(upMoveUp);
                upArray:addObject(fadeOut);

                local upSpawn = CCSpawn:create(upArray);
                local arr = CCArray:create();
                local delay = CCDelayTime:create(1);
                arr:addObject(delay);
                arr:addObject(upSpawn);
                arr:addObject(upCallBack);
                self:runAction(CCSequence:create(arr));
        end
        ----------------
        -- one animation
        ---------------- 
        local timeOne = 0.1
        local array = CCArray:create();
        local callBack = CCCallFunc:create(twoAnimation);
        --local upDelay = CCDelayTime:create(3);
        local fadeTo1 = CCFadeTo:create(0, 0);
        local fadeTo2 = CCFadeTo:create(1, timeOne);
        local moveUp = CCMoveBy:create(timeOne, ccp(0,180));
        local moveEaseOut = CCEaseOut:create(moveUp,timeOne);
        local scale1 = CCScaleTo:create(timeOne,1);
        --local scale1EaseOut = CCEaseElasticOut:create(scale1,timeOne);
        
        array:addObject(fadeTo1);
        array:addObject(fadeTo2);
        array:addObject(moveEaseOut);
        array:addObject(scale1);
        local spawn = CCSpawn:create(array);
        self:runAction(CCSequence:createWithTwoActions(spawn, callBack));
end

function TextAnimationSkillPet:removeAnimation()
        local function twoAnimationComplete()
          self:getParent():removeChild(self);
          self:removeSelf();
          self = nil
        end
        local upArray = CCArray:create();
        local upMoveUp = CCMoveBy:create(0.15, ccp(-600,0));
        local upCallBack = CCCallFunc:create(twoAnimationComplete);
        local fadeTo = CCFadeTo:create(0.15, 1);
        
        upArray:addObject(upMoveUp);
        upArray:addObject(fadeTo);
        local upSpawn = CCSpawn:create(upArray);
        local arr = CCArray:create();
        arr:addObject(upSpawn);
        arr:addObject(upCallBack);
        self:runAction(CCSequence:create(arr));
end


----------------
--hanZi
----------------
function TextAnimationSkillPet:hanZiText(numStr)
  local backImage = Image.new()
  backImage:loadByArtID(numStr)
  backImage:setAnchorPoint(CCPointMake(0.5,0));
  self:addChild(backImage)
end

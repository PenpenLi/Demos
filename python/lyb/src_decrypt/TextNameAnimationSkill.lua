
--技能名字，飘出来
TextNameAnimationSkill = class(Layer);
function TextNameAnimationSkill:ctor()
  self.class = TextNameAnimationSkill;  
  self.index = 0;
  self.name = "TextNameAnimationSkill";
  self.textTable = {};
end

function TextNameAnimationSkill:textAnimation(skillId,skeleton)
    self.touchChildren = false;
    self.touchEnabled = false;
   local nameText = analysis("Jineng_Jineng",skillId,"nameart")
   if nameText == 0 then
    self:removeAnimation()
    return
  end
  self:hanZiText(nameText,skeleton)
  -- self:setScale(0);
  self:oneAnimation();
end

function TextNameAnimationSkill:oneAnimation()
        ----------------
        -- two animation Complete
        ----------------
        local function twoAnimationComplete()
          self:removeAllEventListeners();
          self:removeChildren();
          if self.armature then
              self.armature:dispose()
              self.armature = nil
          end
          self:getParent():removeChild(self);
        end
        ----------------
        -- two animation
        ----------------
        local function twoAnimation()
                local upCallBack = CCCallFunc:create(twoAnimationComplete);
                local array = CCArray:create();
                local moveUp = CCMoveBy:create(0.5, ccp(0,150));
                local fadeTo2 = CCFadeOut:create(0.5);
                array:addObject(moveUp)
                array:addObject(fadeTo2)
                local spawn = CCSpawn:create(array);
                local arr = CCArray:create();
                local delay = CCDelayTime:create(1);
                arr:addObject(delay);
                arr:addObject(spawn)
                arr:addObject(upCallBack);
                self.imageBgup:runAction(CCSequence:create(arr));
        end
        ----------------
        -- one animation
        ---------------- 
        local timeOne = 0.1
        -- local array = CCArray:create();
        local callBack = CCCallFunc:create(twoAnimation);
        --local upDelay = CCDelayTime:create(3);
        -- local fadeTo1 = CCFadeTo:create(0, 0);
        -- local fadeTo2 = CCFadeTo:create(1, timeOne);
        -- local moveUp = CCMoveBy:create(timeOne, ccp(0,300));
        -- local moveEaseOut = CCEaseOut:create(moveUp,timeOne);
        local scale1 = CCScaleTo:create(timeOne,1);
        --local scale1EaseOut = CCEaseElasticOut:create(scale1,timeOne);
        
        -- array:addObject(fadeTo1);
        -- array:addObject(fadeTo2);
        -- array:addObject(moveEaseOut);
        -- array:addObject(CCEaseSineOut:create(scale1));
        -- local spawn = CCSpawn:create(array);
        self.imageBgup:runAction(CCSequence:createWithTwoActions(CCEaseSineOut:create(scale1), callBack));
end

function TextNameAnimationSkill:removeAnimation()
        self:removeAllEventListeners();
        self:removeChildren();
        if self.armature then
            self.armature:dispose()
            self.armature = nil
        end
        if self:getParent() then
          self:getParent():removeChild(self);
        end
end


----------------
--hanZi
----------------
function TextNameAnimationSkill:hanZiText(nameString,skeleton)
  self.imageBgup = getImageByArtId(nameString);
  self.imageBgup:setAnchorPoint(CCPointMake(0.5,0.5))
  self.imageBgup:setScale(0)
  self:addChild(self.imageBgup);
end

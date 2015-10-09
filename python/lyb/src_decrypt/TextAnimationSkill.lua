-------------------------------------------------------------------------
--  Class include: TextAnimationSkill
-------------------------------------------------------------------------

--没有用
TextAnimationSkill = class(Layer);
function TextAnimationSkill:ctor()
	self.class = TextAnimationSkill;  
  self.index = 0;
  self.name = "TextAnimationSkill";
  self.textTable = {};
end
----------------
--center
----------------
function TextAnimationSkill:textAnimation(type,aiEngin)
  self.touchChildren = false;
  self.touchEnabled = false;
  local num1 = 30;
  local siteX = -num1*4/2;
  self:hanZiText(type,siteX)
  self:setScale(10);
  self:oneAnimation(aiEngin);
end
----------------
-- one animation
----------------
function TextAnimationSkill:oneAnimation(aiEngin)
        ----------------
        -- two animation Complete
        ----------------
        local function twoAnimationComplete()
          self.textTable = nil;
          self:removeAllEventListeners();
          self:removeChildren();
          self:getParent():removeChild(self);
          self.aiEngin = nil
        end
        ----------------
        -- two animation
        ----------------
        local function twoAnimation()
            local len = table.getn(self.textTable);
            for k,v in pairs(self.textTable) do
                local upArray = CCArray:create();
                local upMoveUp = CCMoveBy:create(0.6, ccp(0,400));
                local upCallBack = CCCallFunc:create(twoAnimationComplete);
                local upDelay = CCDelayTime:create(0.3*(len-k +1));
                local fadeTo = CCFadeTo:create(0.6, 1);
                
                upArray:addObject(upMoveUp);
                upArray:addObject(fadeTo);
                local upSpawn = CCSpawn:create(upArray);
                if k ~= 1 then
                  v:runAction(CCSequence:createWithTwoActions(upDelay, upSpawn));
                else
                  local arr = CCArray:create();
                  arr:addObject(upDelay);
                  arr:addObject(upSpawn);
                  arr:addObject(upCallBack);
                  v:runAction(CCSequence:create(arr));
                end
            end
        end
        ----------------
        -- one animation
        ---------------- 
        local timeOne = 0.6
        local array = CCArray:create();
        local callBack = CCCallFunc:create(twoAnimation);
        local fadeTo1 = CCFadeTo:create(0, 0);
        local fadeTo2 = CCFadeTo:create(1, timeOne);
        local moveUp = CCMoveBy:create(timeOne, ccp(0,0));
        local moveEaseOut = CCEaseOut:create(moveUp,timeOne);
        local scale1 = CCScaleTo:create(timeOne,1);
        local scale1EaseOut = CCEaseElasticOut:create(scale1,timeOne);
        
        array:addObject(fadeTo1);
        array:addObject(fadeTo2);
        array:addObject(moveEaseOut);
        array:addObject(scale1EaseOut);
        local spawn = CCSpawn:create(array);
        self:runAction(CCSequence:createWithTwoActions(scale1EaseOut, callBack));
end


----------------
--hanZi
----------------
function TextAnimationSkill:hanZiText(numStr, siteX)
  local backImage = Image.new()
  backImage:loadByArtID(numStr)
  backImage.touchEnabled=false;
  backImage.touchChildren=false;
  backImage:setAnchorPoint(CCPointMake(0.5,0.4));
  local size = backImage:getContentSize()
  --backImage:setPositionX(-size.width/2,-size.height/2);
  self:addChild(backImage)
  table.insert(self.textTable, backImage);
end

-------------------------------------------------------------------------
--  Class include: TextAnimationPopAndUp
-------------------------------------------------------------------------
--暴击，弹字，可能会用
TextAnimationPopAndUp = class(Layer);
function TextAnimationPopAndUp:ctor()
	self.class = TextAnimationPopAndUp;  
            self.index = 0;
            self.name = "TextAnimatePopAndUp";
            self.textTable = {};
end


----------------
--center
----------------
function TextAnimationPopAndUp:textAnimation(numStr,num,skeleton)
  self.touchChildren = false;
  self.touchEnabled = false;
  local num1 = 30;
  local siteX = -num1*4/2;
  self:hanZiText(numStr,siteX,skeleton)
  self:setScale(0)
  self:oneAnimation();
end




----------------
-- one animation
----------------
function TextAnimationPopAndUp:oneAnimation()
        ----------------
        -- two animation Complete
        ----------------
        local function twoAnimationComplete()
          self.textTable = nil;
          self:removeAllEventListeners();
          self:removeChildren();
          self:getParent():removeChild(self);
        end
        ----------------
        -- two animation
        ----------------
        local function twoAnimation()
            -- local len = table.getn(self.textTable);
            -- for k,v in pairs(self.textTable) do
                local upArray = CCArray:create();
                local upMoveUp = CCMoveBy:create(0.4, ccp(0,150));
                local upCallBack = CCCallFunc:create(twoAnimationComplete);
                local upDelay = CCDelayTime:create(0.3);
                local fadeTo = CCFadeOut:create(0.4);
                
                upArray:addObject(upMoveUp);
                upArray:addObject(fadeTo);
                local upSpawn = CCSpawn:create(upArray);
                -- if k ~= 1 then
                  -- self:runAction(CCSequence:createWithTwoActions(upDelay, upSpawn));
                -- else
                  local arr = CCArray:create();
                  arr:addObject(upDelay);
                  arr:addObject(upSpawn);
                  arr:addObject(upCallBack);
                  self.imageBg:runAction(CCSequence:create(arr));
                -- end
            -- end
        end
        ----------------
        -- one animation
        ---------------- 
        local timeOne = 0.4
        local array = CCArray:create();
        local callBack = CCCallFunc:create(twoAnimation);
        local moveUp = CCMoveBy:create(timeOne, ccp(0,0));
        local moveEaseOut = CCEaseOut:create(moveUp,timeOne);
        local scale1 = CCScaleTo:create(timeOne,1);
        local scale1EaseOut = CCEaseElasticOut:create(scale1,timeOne);
        
        array:addObject(moveEaseOut);
        array:addObject(scale1EaseOut);
        local spawn = CCSpawn:create(array);
        self:runAction(CCSequence:createWithTwoActions(scale1EaseOut, callBack));
end


----------------
--hanZi
----------------
function TextAnimationPopAndUp:hanZiText(numStr, siteX,skeleton)
  self.imageBg = getImageByArtId(numStr)
  self.imageBg:setAnchorPoint(CCPointMake(0.5,0.5));
  self:addChild(self.imageBg)
end

-- ----------------
-- --source 
-- ----------------
-- function TextAnimationPopAndUp:textSource(cache, siteX)
--   local text = CommonSkeleton:getBoneTextureDisplay("common_battle_state"..numStr);
--   text:setPositionX(siteX);
--   text:setAnchorPoint(CCPointMake(0,0.95));
--   text:setScale(1.5);
--   table.insert(self.textTable, text);
--   self:addChild(text);
-- end
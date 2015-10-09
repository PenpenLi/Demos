-------------------------------------------------------------------------
--  Class include: TextAnimateUpAndUp
-------------------------------------------------------------------------
--掉血数字或文字加数字，漂字。
TextAnimateUpAndUp = class(BatchLayer);
function TextAnimateUpAndUp:ctor()
	self.class = TextAnimateUpAndUp;  
  self.name = "TextAnimateUpAndUp";
  self.playerType = nil;
  self.zl = -((math.random()*(4-1.5)+1.5)/4)/4; 
  self.oldPy = 0;
  self.lastPy = -100000;
  self.directNum = -1
end

function TextAnimateUpAndUp:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    TextAnimateUpAndUp.superclass.dispose(self);
end
----------------
--center
----------------
function TextAnimateUpAndUp:textAnimation(strAndNum,direction,skeleton)
  self:initBatchLayer(skeleton)
  self.touchChildren = false;
  self.touchEnabled = false;
  if strAndNum == 0 then return;end;
  local long = string.len(strAndNum);
  local num1 = 15;--text width/2
  local num2 = 4;--gaps
  local hanNum = 0;
  self.directNum = direction == "left" and -1 or 1;
  self.oldPy = self:getPositionY()
  local strArr
  if string.find(strAndNum, "_") ~= nil then
    hanNum = -2;
    strArr = StringUtils:lua_string_split(strAndNum, "_");
    local siteX = -num1 * (long - hanNum) + num2*(long - hanNum - 1);
    strAndNum = strArr[2];
    long = long - 2;
    self:numTextKe(strArr[1],siteX,skeleton)
  end
  for i = 1, long do
    local str = string.sub(strAndNum, i, i);
    
    if str == "-" or str == "+" then
        str = 10;
    else 
        str = tonumber(str);
    end

    local siteX = -num1 * (long + hanNum) + num2*(long + hanNum - 1) + num1*2*(i-1) - num2*2*(i-1);
    if tonumber(strAndNum) >= 0 then
      if not strArr or (strArr[1] ~= BattleConfig.Effect_Text_Huixin and strArr[1] ~= BattleConfig.Effect_Text_ZhuDang) then
        self:numTextPos(str,siteX,skeleton);
      else
        self:numTextNeg(str,siteX,skeleton);
      end
    else
        self:numTextNeg(str,siteX,skeleton);
    end
  end
  self:oneAnimation();
end

----------------
-- one animation
----------------
function TextAnimateUpAndUp:oneAnimation()
      self.vx = self.directNum-- *(math.random()); 
      local random = math.random(30,70)
      self.vy = math.sqrt(3*(-self.zl)*random)
      local scale = 1
      local function loopHandle()
        self.vy = self.vy + self.zl;
        if not self:getPositionX() then
            self:removeLoopHandleTimer();
            return;
        end
        self:setPositionX(self:getPositionX() + self.vx);
        self:setPositionY(self:getPositionY() + self.vy);
        if (self.oldPy - self:getPositionY()) > 0 and self.lastPy == -100000 then
            self.lastPy = self:getPositionY() - 10;
        end
        if self:getPositionY() < self.lastPy and self.oldPy > self:getPositionY() then
            self:removeLoopHandleTimer()
            self:getParent():removeChild(self);
            return
        end
        self.oldPy = self:getPositionY();
        self:setScale(scale)
        scale = scale - 0.007
      end
      self.loopHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopHandle, 0, false)
end

function TextAnimateUpAndUp:removeLoopHandleTimer()
    if self.loopHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopHandle);
        self.loopHandle = nil
    end
end
----------------
--positive
----------------
function TextAnimateUpAndUp:numTextPos(numStr,siteX,skeleton)
  if self.playerType == BattleConfig.BATTLE_RAGE then
      tempString = "common_battle_blue";
  else
      tempString = "common_battle_green";
  end
  local green = skeleton:getBoneTextureDisplay(tempString..numStr);
  green:setPositionX(siteX);
  green:setAnchorPoint(CCPointMake(0,1));
  self:addChild(green);
end

----------------
--negative
----------------
function TextAnimateUpAndUp:numTextNeg(numStr,siteX,skeleton)
  if not numStr then return;end
  local tempString --= "common_battle_litred";
  if self.playerType == BattleConfig.Battle_StandPoint_1 then
      tempString = "common_battle_litred";
  else
      tempString = "common_battle_bigred";
  end
  local bigred = skeleton:getBoneTextureDisplay(tempString..numStr);
  bigred:setPositionX(siteX);
  -- bigred:setScale(scaleNum);
  bigred:setAnchorPoint(CCPointMake(0,1));
  self:addChild(bigred);
end


function TextAnimateUpAndUp:numTextKe(numStr,siteX,skeleton)
  local imageId;
  if numStr == "1" then
    imageId = BattleConfig.Effect_Text_HuixinID;
  elseif numStr == "2" then
    imageId = BattleConfig.Effect_Text_ZhaojiaID;
  end
  self.imageBg = getImageByArtId(imageId)
  self.imageBg:setAnchorPoint(CCPointMake(0.5,0.5));
  self.imageBg:setPositionXY(siteX,-20)
  self:addChild(self.imageBg)
  -- if self.playerType == BattleConfig.BATTLE_OWER then
  --     tempString = "monster_ke_";
  -- elseif self.playerType == BattleConfig.BATTLE_MONSTER then
  --     tempString = "hero_ke_";
  -- elseif self.playerType == BattleConfig.BATTLE_PET or self.playerType == BattleConfig.BATTLE_YONGBING then
  --     tempString = "monster_ke_";
  -- end
  -- local green = skeleton:getBoneTextureDisplay(tempString..numStr);
  -- -- if not green then return end
  -- green:setPositionX(siteX-50);
  -- green:setAnchorPoint(CCPointMake(0,1));
  -- green:setScale(0.7);
  -- self:addChild(green);
end
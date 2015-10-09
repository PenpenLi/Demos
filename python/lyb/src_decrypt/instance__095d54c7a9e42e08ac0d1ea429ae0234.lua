-----------
--TextAnimateReward
-----------
-- singleton

require "core.controls.MultiColoredLabel"

local instance_ = nil;
function sharedTextAnimateReward()
    if instance_ == nil then
        instance_ = TextAnimateReward.new();
        instance_:initLayer();
    end
    return instance_;
end
function getTextAnimateRewardInstance()
    return instance_;
end

TextAnimateReward = class(Layer);
function TextAnimateReward:ctor()
    self.class = TextAnimateReward;  
    self.name = "TextAnimateReward";
    --self.currentLine = 1;
    self.bgWidth = 500;
    self.bgHeight = 50;
    self.runingArray = {};
    self.timerHandle = nil;
    self.defalt_str = "000000";
    self.isFirstIn = true;
    self.backgroundArray = {}
    self.removeNumber = 0;
    --textRewardSelf = self;
    self.placeArray = {}
    self.placeLimitNum = 5
    self.placeStartNum = 1
end
function TextAnimateReward:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    TextAnimateReward.superclass.dispose(self);
    --textRewardSelf = nil;
end
--ItemIdArray"内部格式:ItemId,Count"
function TextAnimateReward:animateStartByArray(ItemIdArray)
    self:addRewardToScene();
    for k,v in pairs(ItemIdArray) do
        table.insert(self.runingArray,v)
    end
    
    self:timerRunStart();
end

function TextAnimateReward:timerRunStart()
    if self.timerHandle then return;end;
    local time = 0;
    local function timerHandle()
        if self.isFirstIn then
                Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandle);
                self.timerHandle = nil;
                time = 0.8 
                self.timerHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerHandle, time, false)
                self.isFirstIn = false;
        end
        if #self.runingArray > 0 then 
            local v = self.runingArray[1];
            local background
            if v.ItemId == self.defalt_str then
                background  = self:initTextAnimate(v.Count);
            else
                 local bankPO = analysis("Daoju_Daojubiao",v.ItemId);
                 background  = self:initTextAnimate("你获得："..bankPO.name.." 数量："..v.Count);
            end
            self:animationRun(background);
            table.remove(self.runingArray,1);
        else
            if self.timerHandle then
                Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandle);
                self.timerHandle = nil;
                self.isFirstIn = true;
            end
        end
    end
    self.timerHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerHandle, time, false)
end


function TextAnimateReward:animateStartByString(rewardString)
        if not rewardString then return;end;
      self:forceStopAnimation()
      if not self.timerHandle then
          self:removeBackGround()
      end
      self:addRewardToScene();
      local tableArr = {ItemId = self.defalt_str,Count = rewardString};
      if not self:isChickSame(tableArr) then
          table.insert(self.runingArray,tableArr)
          self:timerRunStart();
      end
end

function TextAnimateReward:isChickSame(tableArr)
    for k1,v1 in pairs(self.runingArray) do
        if v1.Count == tableArr.Count then
            return true
        end
    end
    return false
end

function TextAnimateReward:forceStopAnimation()
    if self.forceHandle then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.forceHandle);
            self.forceHandle = nil;
    end
    local function forceHandle()
            self.runingArray = {}
    end
    self.forceHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(forceHandle, 3, false)
end

function TextAnimateReward:animationRun(background)
        if not background then
            self:disposeTextAnimateReward();
            return;
        end
        local function timerOut()
            local placeStartNum = self.backgroundArray[1].placeStartNum
            self.placeArray[placeStartNum] = nil;
            self:removeChild(self.backgroundArray[1]);
            table.remove(self.backgroundArray,1);
            if table.getn(self.backgroundArray) == 0 then
                self.placeStartNum = 1
            end
        end
        local function timerOut1()
            background.textLabel:setVisible(true)
        end
        local array = CCArray:create();
        array:addObject(CCFadeTo:create(0.1,220))
        array:addObject(CCCallFunc:create(timerOut1))
        array:addObject(CCDelayTime:create(0.8))
        array:addObject(CCFadeTo:create(0.5,0))
        array:addObject(CCCallFunc:create(timerOut))
        background:runAction(CCSequence:create(array));
        table.insert(self.backgroundArray,background);
end

function TextAnimateReward:removeBackGround()
    for k,v in pairs(self.backgroundArray) do
        self:removeChild(v);
    end
    self.backgroundArray = {}
    self.runingArray = {}
end

function TextAnimateReward:initTextAnimate(rewardString)
    if not self.list then
        self:disposeTextAnimateReward();
        return;
    end
    local background = self:initBackground();
    local tempNum = string.find(rewardString, "content");
    local tempString;
    if not tempNum then
        tempString = '<content><font color="#FFFFFF">'..rewardString..'</font></content>'
    else
        tempString = rewardString;
    end
    local text = MultiColoredLabel.new(tempString, "fonts/Microsoft YaHei.ttf", 24, CCSizeMake(500,50),kCCTextAlignmentCenter);
    text:setPositionY(15);
    local winsize = Director:sharedDirector():getWinSize()
    background:setPositionXY((winsize.width - self.bgWidth)/2,GameConfig.STAGE_HEIGHT/2+80 + (self.placeStartNum-1)*60);
    background:addChild(text);
    background.textLabel = text
    text:setVisible(false)
    self:addChild(background);

    background.placeStartNum = self.placeStartNum
    self.placeArray[self.placeStartNum] = self.placeStartNum
    self.placeStartNum = self.placeStartNum + 1
    if self.placeStartNum >= self.placeLimitNum then
        self.placeStartNum = 1
    end
    return background;
end

function TextAnimateReward:initBackground()
    local layerColor = getImageByArtId(1084);
    -- layerColor:initLayer();
    -- layerColor:changeWidthAndHeight(self.bgWidth,self.bgHeight);
    
    layerColor.touchEnabled=false;
    layerColor.touchChildren=false;
    -- layerColor:setColor(ccc3(0,0,0));
    -- layerColor:setOpacity(0);
    return layerColor;
end

function TextAnimateReward:clear()
        if self.timerHandle then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandle);
            self.timerHandle = nil;
        end
        self.isFirstIn = true;
        instance_ = nil;
end

function TextAnimateReward:addRewardToScene()
    if  self.parent then
          self.parent:removeChild(self,false);
    end
    commonAddToScene(self)
end

function TextAnimateReward:disposeTextAnimateReward()
        if self.timerHandle then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandle);
            self.timerHandle = nil;
        end
        if self.forceHandle then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.forceHandle);
            self.forceHandle = nil;
        end
        instance_ = nil;
        self.runingArray = {};
        
        if self.backgroundArray then
            for k,v in pairs(self.backgroundArray) do
            self:removeChild(v);
            end
            self.backgroundArray = nil
        end

        if  self.parent then
          self.parent:removeChild(self);
        end
end

require "main.view.activity.ui.amassFortunes.AmassFortunesAlertLayer";
require "main.view.activity.ui.amassFortunes.AmassFortunesCardItem";

AmassFortunesLayer=class(TouchLayer);

function AmassFortunesLayer:ctor()
  self.alertLayer = nil;
  self.class=AmassFortunesLayer;
  self.updateIdTable = {};
  self.cardListTable = {};--table里面是一个二级table.二级table有三个值:render1,render2,render3
  self.serverResultValue = nil;--服务器传过来的值
  self.resultTable = {};
  self.currentShowTable = {};
  self.TYPE_1 = 1;--正常状态
  self.TYPE_2 = 2;--更换卡牌
  self.TYPE_3 = 3;--停止
  self.speedTable = {[1] = 30, [2] = 36, [3] = 45, [4] = 34,[5] = 26};--决定速度,调速度的时候改这个
  self.curStage = nil;
  self.refreshTimeId = nil;
  self.isScrolling = false;
  self.isOutDate = nil;
end

function AmassFortunesLayer:dispose()
  self:disposeSpeed();
  self:disposeTime();
  self:removeAllEventListeners();
	self:removeChildren();
  AmassFortunesLayer.superclass.dispose(self);
	self.removeArmature:dispose()
end

function AmassFortunesLayer:initializeUI(skeleton, activityProxy, userCurrencyProxy, userDataAccumulateProxy)
  
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.userCurrencyProxy = userCurrencyProxy;
  self.userDataAccumulateProxy = userDataAccumulateProxy;


  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  
  AddUIBackGround(self);
  -- local layerColor = LayerColorBackGround:getBackGround()
  -- self:addChild(layerColor);

  --骨骼
  local armature=skeleton:buildArmature("amass_fortunes_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);


    local armature_dSize =  self.armature:getGroupBounds().size

  print("size.width,size.height", size.width,size.height)

  print("armature_dSize.width, armature_dSize.height",armature_dSize.width, armature_dSize.height)
  self.armature:setPositionXY((size.width - armature_dSize.width)/2, (size.height - armature_dSize.height)/2)

  print("armature_dSize.x, armature_dSize.y",self.armature:getPositionX(), self.armature:getPositionY())
  --currentHave
  local text="现有";
  local text_data=armature:getBone("currentHave").textData;
  self.currentHave=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.currentHave);
  
  --currentHave_value
  local text_data=armature:getBone("currentHave_value").textData;
  self.currentHave_value=createTextFieldWithTextData(text_data, userCurrencyProxy:getGold());
  self.armature:addChild(self.currentHave_value);


  local activityData = activityProxy:getDateByID(5);
  if activityData then
     self.endTime = activityData.RemainSecondsEnd;
  else
     self.endTime = 0
  end
  local text_data=armature:getBone("date").textData;
  self.date_value=createTextFieldWithTextData(text_data," ");
  self.armature:addChild(self.date_value);

--  self.noticeTextData = armature:getBone("notice").textData;
--createMultiColoredLabelWithTextData
  --card1
  self.render1 = self.armature:getChildByName("card1");
  --card2
  self.render2 = self.armature:getChildByName("card2");
  
  self.renderSizeWidth = self.render1:getContentSize().width;
  self.renderSizeHeight = self.render1:getContentSize().height;

  self.render1Pos = convertBone2LB(self.render1);

  local skew_x = convertBone2LB(self.render2).x - self.render1Pos.x;
  self.armature:removeChild(self.render1);
  self.armature:removeChild(self.render2); 


  for i = 1, 5 do
      local subTable = {};
      local tempCCSprite = CCSprite:create();
      local tempSprite = Sprite.new(tempCCSprite);
      local clipper1 = ClippingNode.new(tempSprite);
      clipper1:setAlphaThreshold(0.0);
      clipper1:setContentSize(makeSize(self.renderSizeWidth* GameData.gameUIScaleRate, self.renderSizeHeight* GameData.gameUIScaleRate));
      self.armature:addChild(clipper1);
       clipper1:setPositionXY(self.render1Pos.x + (i - 1) * skew_x, self.render1Pos.y);
      self:setOneListData(clipper1);
      
      --初始化
      self.currentShowTable[i] = 7;
  end

  --button_amass
  local button_amass=self.armature:getChildByName("common_copy_bluelonground_button");
  local button_amass_pos=convertBone2LB4Button(button_amass);
  self.armature:removeChild(button_amass);

  button_amass=CommonButton.new();
  button_amass:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  button_amass:initializeText(armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_bluelonground_button").textData,"招财进宝");
  button_amass:setPosition(button_amass_pos);
  button_amass:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
  self.armature:addChild(button_amass);
  self.button_amass=button_amass;



  --closeButton
  local closeButton=self.armature:getChildByName("common_copy_close_button");
  local close_pos=convertBone2LB4Button(closeButton);--closeButton:getPosition();
  self.armature:removeChild(closeButton);
  
  closeButton=CommonButton.new();
  closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  closeButton:setPosition(close_pos);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self.armature:addChild(closeButton);

  local count = self.userDataAccumulateProxy:getCount(GameConfig.ACCUMULATE_TYPE_4);
  
  if self.alertLayer == nil then
      self.alertLayer = AmassFortunesAlertLayer.new();
      self.alertLayer:initialize(self.skeleton, count);
  end
  
  if self.endTime - os.time() <= 0 then
    self.isOutDate = true;
  end
  local function funRefreshTime()
     local remainSecond = self.endTime - os.time();
     if remainSecond > 0 then
         local time = self:getTimeString(remainSecond)
         if self.refreshTimeId and not self.date_value.sprite then
            self:disposeTime()
         end
         self.date_value:setString(time)
     else
         removeMaskLayer()
         self:disposeTime()
         self.isOutDate = true;
         self.date_value:setString("活动已过期")
     end
  end
  if self.endTime then
    self.refreshTimeId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(funRefreshTime, 1, false);
  end

  local alert = self.armature:getChildByName("alert");
  self.armature:addChild(self.alertLayer);
  self.alertLayer:setPositionXY(alert:getPositionX(), alert:getPositionY());



end

function AmassFortunesLayer:disposeSpeed()
  if self.updateSpeedId then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateSpeedId);
    self.updateSpeedId = nil;
  end
end
function AmassFortunesLayer:disposeTime()
  if self.refreshTimeId then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.refreshTimeId);
    self.refreshTimeId = nil;
  end
end
function AmassFortunesLayer:getTimeString(remainSecond)
    
		print("remainSecond:"..remainSecond);
    local returnValue = "";
    local tempTime = remainSecond;
    local dayTime = nil;
    local hourTime = nil;
    local minuteTime = nil;
    local secondTime = 0;
    
    if tempTime > 24 * 60 * 60 then
      dayTime = math.floor(tempTime / (24 * 60 * 60));
      local num1 = tempTime - dayTime * 24 * 60 * 60;
      tempTime = num1;
    end

    if tempTime > 60 * 60 then
      hourTime = math.floor(tempTime / (60 * 60));
      local num1 = tempTime - hourTime * 60 * 60;
      tempTime = num1;
    end
    if tempTime > 60 then
      minuteTime = math.floor(tempTime / 60);
      local num2 = tempTime - minuteTime * 60;
      secondTime = num2;
    else 
      secondTime = tempTime;
    end
    if dayTime then 
      returnValue = dayTime .. "天";
    end
    if hourTime then
      returnValue = returnValue .. hourTime .. "时";
    end
    if minuteTime then
      returnValue = returnValue .. minuteTime .. "分";
    end
    if secondTime then
      returnValue = returnValue .. secondTime .. "秒后关闭";
    end
    return returnValue;
end
function AmassFortunesLayer:setOneListData(container)
   local subTable = {};
   for i = 0, 2 do
      local item = AmassFortunesCardItem.new();
      item:initialize(self.skeleton, 9 - i);
      item:setPositionXY(0,  (self.renderSizeHeight + 4) * i)

      table.insert(subTable, item);
      container:addChild(item)
   end

   table.insert(self.cardListTable, subTable);
end

function AmassFortunesLayer:onListFlip()
   self.curStage = 1;
   local function speedTick()
     self.curStage = self.curStage + 1;
     if self.curStage == #self.speedTable then-- 开始取消
        self:setResultData(self.serverResultValue);
        self:disposeSpeed()
     end
   end
   self.updateSpeedId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(speedTick, 1, false);

   local function tick1(dt)
     self:updatePosition(self.cardListTable[1], 1);
   end
   local function tick2(dt)
     self:updatePosition(self.cardListTable[2], 2);
   end
   local function tick3(dt)
     self:updatePosition(self.cardListTable[3], 3);
   end
   local function tick4(dt)
     self:updatePosition(self.cardListTable[4], 4);
   end
   local function tick5(dt)
     self:updatePosition(self.cardListTable[5], 5);
   end

   self.updateIdTable[1] = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick1, 0, false);
   self.updateIdTable[2] = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick2, 0, false);
   self.updateIdTable[3] = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick3, 0, false);
   self.updateIdTable[4] = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick4, 0, false);
   self.updateIdTable[5] = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick5, 0, false);

end
function AmassFortunesLayer:fixUpdatePosition(cardSubTable)
   local currentRender = self:getCurrentRender(cardSubTable);
   local standardYpos = currentRender:getPositionY();
   local nextRender = self:getNextRender(cardSubTable);
   local preRender = self:getPreRender(cardSubTable);
   if nextRender then
      nextRender:setPositionY(standardYpos + self.renderSizeHeight);
   end
   if preRender then
      preRender:setPositionY(standardYpos - self.renderSizeHeight);
   end
end
function AmassFortunesLayer:getNextValueByCurrent(value)
   if 0 == value then
      return 9;
   else
      return value - 1;
   end
end

function AmassFortunesLayer:updatePosition(cardSubTable, index)
    local result = self.TYPE_1;
    for i_k, i_v in pairs (cardSubTable) do
        result = self:checkPosition(i_v, index);
        if result == self.TYPE_2 or result == self.TYPE_3 then         
           break;
        end
    end

    if result == self.TYPE_2 then
       local nextValue = self:getNextValueByCurrent(self.currentShowTable[index]);
       local nextNextValue = self:getNextValueByCurrent(nextValue);
       self.currentShowTable[index] = nextValue;
       local willShowRender = self:getWillShowRender(cardSubTable);
      
       
       if willShowRender then
          willShowRender:setData(nextValue);
       end
    elseif result == self.TYPE_3 then
       local stopRender = self:getStopRender(cardSubTable);
       if stopRender then
          stopRender:setPositionY(0);
       end
       local stopDownRender = self:getStopDownRender(cardSubTable);
       if stopDownRender then
          stopDownRender:setPositionY(-self.renderSizeHeight);
       end
      local willShowRender = self:getWillShowRender(cardSubTable);
       if willShowRender then
          willShowRender:setPositionY(self.renderSizeHeight);
       end
       return;
    end

    self:fixUpdatePosition(cardSubTable);
end
function AmassFortunesLayer:getCurrentRender(subTable)
    for i_k, i_v in pairs(subTable) do
       if i_v:getPositionY() < 0 and i_v:getPositionY() >= -self.renderSizeHeight then
          return i_v;
       end
    end
    return nil;
end
function AmassFortunesLayer:getPreRender(subTable)
    for i_k, i_v in pairs(subTable) do
       if i_v:getPositionY() < -self.renderSizeHeight and i_v:getPositionY() >= self.renderSizeHeight * (-2) then
          return i_v;
       end
    end
    return nil;
end
function AmassFortunesLayer:getNextRender(subTable)
    for i_k, i_v in pairs(subTable) do
       if i_v:getPositionY() < self.renderSizeHeight and i_v:getPositionY() >= 0 then
          return i_v;
       end
    end
    return nil;
end
function AmassFortunesLayer:getStopDownRender(subTable)
    for i_k, i_v in pairs(subTable) do
       if i_v:getPositionY() < self.renderSizeHeight * (-1) / 2 and i_v:getPositionY() >= -self.renderSizeHeight * (-3) / 2 then
          return i_v;
       end
    end
    return nil;
end
function AmassFortunesLayer:getStopRender(subTable)
    for i_k, i_v in pairs(subTable) do
       if i_v:getPositionY() < self.renderSizeHeight / 2 and i_v:getPositionY() >= -self.renderSizeHeight / 2 then
          return i_v;
       end
    end
    return nil;
end
function AmassFortunesLayer:getWillShowRender(subTable)
    for i_k, i_v in pairs(subTable) do
       if i_v:getPositionY() == self.renderSizeHeight then
          return i_v;
       end
    end
    return nil;
end
function AmassFortunesLayer:checkPosition(render, index)
    local yPos = render:getPositionY();
    local nextYpos = self:getNextPos(yPos, index);

    if self:isCriticalValue(yPos) then
        render:setPositionY(self.renderSizeHeight);
        if self.updateIdTable[index] ~= nil and index == #self.updateIdTable and self.resultTable[index] == self.currentShowTable[index] then
           CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateIdTable[index]);
           --重置
           self.updateIdTable[index] = nil;
           self.currentShowTable[index] = self.resultTable[index];
           self.resultTable[index] = nil;
           if index == 1 then--所有的都停下来了。
             self:onAnimationEnd();
           end
           return self.TYPE_3;
        else
           render:setPositionY(self.renderSizeHeight);
           return self.TYPE_2;
        end
    else
        render:setPositionY(nextYpos);
        return self.TYPE_1;
    end
end

function AmassFortunesLayer:isNextShow(yPos)
  if (yPos <= self.renderSizeHeight + self.render1Pos.y) then
    return true;
  else
    return false;
  end
end
function AmassFortunesLayer:isCriticalValue(yPos)
  if (yPos <= self.renderSizeHeight * (-2)) then
    return true;
  else
    return false;
  end
end

function AmassFortunesLayer:getNextPos(yPos, index)
    return yPos - self.speedTable[self.curStage] - index;
end
function AmassFortunesLayer:onButtonTap(event)
  if self.isOutDate then
    sharedTextAnimateReward():animateStartByString("活动已过期了哦~");
    return;
  end

  local count = self.userDataAccumulateProxy:getCount(GameConfig.ACCUMULATE_TYPE_4);
  if analysisHas("Huodongbiao_Laohuji", count + 1) then
      local activityPo = analysis("Huodongbiao_Laohuji", count + 1);
      if self.userCurrencyProxy:getGold() >= activityPo.cost then
         self.button_amass:removeEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
         self:dispatchEvent(Event.new(ActivityNotifications.AMASS_FORTUNES_REQUEST_DATA,{},self));
         self.armature:removeChild(self.alertLayer, false);
         addMaskLayer();
      else
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_9));
				print("gotoRecharge")
				self:gotoRecharge();
      end
  else
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_103));
  end
end

function AmassFortunesLayer:refreshData(value)
   if not self.animationing then
      self:onListFlip();
      self.animationing = true
   end
   self.serverResultValue = value;
end

function AmassFortunesLayer:refreshAmassFortunesCount(count)
    self.count = count;
    self.alertLayer:setData(count);
end
function AmassFortunesLayer:confirmBack()
    self.currentHave_value:setString(self.userCurrencyProxy:getGold());
    self.armature:addChild(self.alertLayer);
end
function AmassFortunesLayer:onAnimationEnd()
  removeMaskLayer()
  
   self.animationing = nil;
   self.button_amass:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);

  local a=CommonPopup.new();
  a:initialize("恭喜你获得:" .. self.serverResultValue .. "元宝", self, self.confirmBack, nil,nil,nil,true,nil,nil,true);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(a);
  self.serverResultValue = nil;
end
function AmassFortunesLayer:setResultData(value)
   self.resultTable[1] = math.floor(value / 10000);
   self.resultTable[2] = math.floor((value - self.resultTable[1] * 10000) / 1000); 
   self.resultTable[3] = math.floor((value - self.resultTable[1] * 10000 - self.resultTable[2] * 1000) / 100); 
   self.resultTable[4] = math.floor((value - self.resultTable[1] * 10000 - self.resultTable[2] * 1000 - self.resultTable[3] * 100) / 10); 
   self.resultTable[5] = value % 10;
end

function AmassFortunesLayer:gotoRecharge()
  local event = Event.new("OPEN_RECHARGE_UI",_, self);
  self:dispatchEvent(event); 
end

--移除
function AmassFortunesLayer:onCloseButtonTap(event)
  self:dispatchEvent(Event.new(ActivityNotifications.AMASS_FORTUNES_CLOSE,nil,self));
end
-- function AmassFortunesLayer:refreshOtherPlayer(data)
--    local  content = '<content><font color="#FFFFFF">哇!</font><font color="#00FF00">' .. data.UserName .. '</font><font color="#FFFFFF">获得了</font><font color="#FF0000">'.. data.Gold ..'</font><font color="#FFFFFF">元宝</font></content>';
--    self:playGuangbo(content)
-- end

-- -- 播广播
-- function AmassFortunesLayer:playGuangbo(content)
    
--   local loopFunction

--   if self.guangboData then
--     local oldLength = table.getn(self.guangboData)
--     table.insert(self.guangboData,oldLength + 1,content)
--   else
--     self.guangboData = {}
--     self.guangboData[1] = content
--   end
  
--   local guangboText
--   local guangboTextWidth
--   if self.isScrolling == false then
--     local text_name = self.guangboData[1]
--     guangboText = MultiColoredLabel.new(text_name, "fonts/Microsoft YaHei.ttf", 24);
--     guangboText:setPositionXY(self.noticeTextData.x + self.noticeTextData.width, self.noticeTextData.y)
--     guangboText.touchEnabled = false;
--     guangboText.touchChildren = false;
--     self.armature:addChild(guangboText);
--     guangboTextWidth = guangboText:getContentSize().width
--   end
  
--   local function playComplete()
--     if self then
--       table.remove(self.guangboData,1)
--       local newLength = table.getn(self.guangboData)
--       if newLength > 0 then
--         text_name = self.guangboData[1]
--         self:removeChild(guangboText);
--         guangboText = nil
--         guangboText = MultiColoredLabel.new(text_name, "fonts/Microsoft YaHei.ttf", 24);
--         guangboText:setPositionXY(self.noticeTextData.x + self.noticeTextData.width, self.noticeTextData.y)
--         guangboText.touchEnabled = false;
--         guangboText.touchChildren = false;
--         self.armature:addChild(guangboText);
--         guangboTextWidth = guangboText:getContentSize().width
--         loopFunction()
--       else
--           self.isScrolling = false
--           self:removeChild(guangboText);
--         guangboText = nil
--         self.guangboData = nil
--       end
--     end
--     self = nil
--   end
--   local function scrollText()

--     self.isScrolling = true
--     local sequArr = CCArray:create()
--     local moveTo = CCMoveTo:create(7, ccp(self.noticeTextData.x-guangboTextWidth, self.noticeTextData.y))
    
--     sequArr:addObject(moveTo);
--     sequArr:addObject(CCCallFunc:create(playComplete));
--     guangboText:runAction(CCSequence:create(sequArr))
--   end 
  
--   loopFunction = scrollText 
--   if self.isScrolling == false then
--       loopFunction()
--   end
-- end


FamilySceneBanquet = class(Layer);
function FamilySceneBanquet:ctor()
  self.class = FamilySceneBanquet;
end

function FamilySceneBanquet:dispose()
  self:disposeRefreshTime()
  self:removeAllEventListeners();
  self:removeChildren();
  FamilySceneBanquet.superclass.dispose(self);
end

function FamilySceneBanquet:init(context, data)
  self:initLayer();
  self.data = data;
  self.context = context;
  local image = Image.new();
  image:loadByArtID(1655);
  self:addChild(image)
  image:addEventListener(DisplayEvents.kTouchTap,self.onClickBanquet,self)

  local userNameText=TextField.new(CCLabelTTFStroke:create(data.UserName.."的酒宴", GameConfig.DEFAULT_FONT_NAME, 22, 1, ccc3(0,0,0), CCSizeMake(0, 0), "center", kCCVerticalTextAlignmentCenter), true);
  userNameText.touchEnabled = false;
  userNameText:setColor(ccc3(0,255,252))
  local xPos = 117-userNameText:getContentSize().width/2;
  userNameText:setPositionXY(xPos, 190);
  self:addChild(userNameText)

  self:disposeRefreshTime();
  self.refreshTime=RefreshTime.new();
  self.refreshTime:initTime(data.RemainSeconds,self.onRefreshTime,self,3);
  self:onRefreshTime();

  
  self:refreshPerson()
end

-- function FamilySceneBanquet:addPerson(count, userIdNameArray)
--   for k, v in pairs(self.personTable) do
--     self:removeChild(v);
--   end
--   self.personTable = {};
--   self.data.Count = count;
--   self:refreshPerson();
--   self.userIdNameArray = userIdNameArray;
-- end


function FamilySceneBanquet:refreshPerson()
  print("self.data.Count", self.data.Count)
  local personCount = 4;
  if self.data.Type == 1 then
    personCount = 4;
  elseif self.data.Type == 2 then
    personCount = 6;
  end
  for i = 1, self.data.Count, 1 do
    print("11111111111111........", i)
    local personImage = Image.new();
    personImage:loadByArtID(1716)
    self:addChild(personImage)
    if personCount == 4 then
      personImage:setPositionXY(45 + (i-1) * 33, 140)
    elseif personCount == 6 then
      personImage:setPositionXY(12 + (i-1) * 33, 140)
    end
  end
  
  for i = self.data.Count + 1, personCount, 1 do
    print("22222222222222........", i)
    local personImage = Image.new();
    personImage:loadByArtID(1715)
    self:addChild(personImage)
    if personCount == 4 then
      personImage:setPositionXY(45 + (i-1) * 33, 140)
    elseif personCount == 6 then
      personImage:setPositionXY(12 + (i-1) * 33, 140)
    end
  end
end

function FamilySceneBanquet:disposeRefreshTime()
  if self.refreshTime then
    self.refreshTime:dispose();
    self.refreshTime=nil;
  end
end

function FamilySceneBanquet:onRefreshTime()
  if self.refreshTime:getTotalTime() == 0 then
    self:disposeRefreshTime();
    self.parent:removeChild(self);
    self.context.banquetArray[self.data.ID] = nil;
    local index = 1;
    for i,v in ipairs(self.context.BanquetInfoArray) do
      if v.ID == self.data.ID then
          index = i;
      end
    end
    --banquetInforArray中删除酒桌数据
    if index and self.context.BanquetInfoArray and #self.context.BanquetInfoArray >=1 then
      table.remove(self.context.BanquetInfoArray, index)
    end

    --scenBanquetArr中删除酒桌数据
    local index = 1;
    for i,v in ipairs(self.context.scenBanquetArr) do
      if self.data.ID == v.data.ID then
         index = i;
        end
    end
    if index and #self.context.scenBanquetArr >=1 then
      table.remove(self.context.scenBanquetArr, index)
    end


    if self.context.context.familyProxy.myBanquetData then
        for i1,v1 in ipairs(self.context.context.familyProxy.myBanquetData) do
          --酒桌举办者在自己所在的酒宴里--则自己在这个酒桌里
            if self.data.UserId == v1.UserId then
                
                print("Banquet Over!")
                self.context.context.familyProxy.myBanquetData = nil;
                sharedTextAnimateReward():animateStartByString("酒宴结束啦！去邮件领取奖励吧！");
            end
        end
    end

    return;
  end
  local remainTime = self.refreshTime:getTimeStr()
  
  if not self.time then
    self.time= TextField.new(CCLabelTTFStroke:create(remainTime, GameConfig.DEFAULT_FONT_NAME, 24, 1, ccc3(0,0,0), CCSizeMake(150, 30), "center", kCCVerticalTextAlignmentCenter), true);
    self.time.touchEnabled = false;
    self.time:setColor(ccc3(0,255,252))
    self:addChild(self.time)
    self.time:setPositionXY(77, 110)
  else
    self.time:setString(remainTime);
  end
    
end

function FamilySceneBanquet:onClickBanquet(event)
  
  Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_COMMAND, {Type = self.data.Type, ID = self.data.ID}));
  sendMessage(27, 31, {ID = self.data.ID});
  print("onClickBanquet")
  
end
function FamilySceneBanquet:clean()
  self:removeChildren();
end
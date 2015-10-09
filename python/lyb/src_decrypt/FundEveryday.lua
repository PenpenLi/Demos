require "main.view.activity.ui.amassFortunes.AmassFortunesAlertLayer";
require "main.view.activity.ui.amassFortunes.AmassFortunesCardItem";
require "main.view.activity.ui.fund.FundEverydayRender";

FundEveryday=class(TouchLayer);

local ChineseNumber={"一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五"}
function FundEveryday:ctor()
  self.class=FundEveryday;
  self.dayRenders = {};
  self.bagItems = {};
  self.currentDayIndex = 1;
end

function FundEveryday:dispose()
  self:removeAllEventListeners();
	self:removeChildren();
  FundEveryday.superclass.dispose(self);
	self.removeArmature:dispose()
end

function FundEveryday:initializeUI(skeleton, fundState, activityProxy, userCurrencyProxy, userDataAccumulateProxy)
  self:initLayer();
  
  self.skeleton=skeleton;
  self.fundState = fundState;
  self.activityProxy=activityProxy;
  self.userCurrencyProxy = userCurrencyProxy;
  self.userDataAccumulateProxy = userDataAccumulateProxy;
  
  -- local mainSize = Director:sharedDirector():getWinSize();
  -- self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));

  -- local layerColor = LayerColorBackGround:getBackGround()
  -- self:addChild(layerColor);

  --骨骼
  local armature=skeleton:buildArmature("fund_everyday");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armatureDefault = armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  
  -- AddUIBackGround(self);

  --text_des
  local text="特别注意：当天返利只能当天领取，错过了那就太可惜啦！";
  local text_data = armature:getBone("text_des").textData;
  self.text_des = createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_des);
  --text_titltName
  local tableData = analysis("Yunying_Jijinleixing",self.fundState);
  text=tableData.type;
  text_data = armature:getBone("text_titltName").textData;
  self.text_titltName = createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_titltName);

  --text_day
  text = "第"..ChineseNumber[1].."天\n  返利";
  self.text_day=createTextFieldWithTextData(armature:getBone("text_day").textData,text);
  self.armature:addChild(self.text_day);


  --dayRenderContainer
  local dayRenderContainer=self.armature:getChildByName("dayRenderContainer");
  local dayRenderContainer_pos=dayRenderContainer:getPosition();
  local fundMAX = {ActivityConstConfig.FUND_SILVER_MAX,ActivityConstConfig.FUND_GOLD_MAX,ActivityConstConfig.FUND_DIAMOND_MAX}
  for i=1,fundMAX[self.fundState] do
    self.dayRenders[i]=FundEverydayRender.new();
    self.dayRenders[i]:initialize(self.skeleton,i,self.activityProxy.fundStateArray[i]);
    --self.bagItems[i]:setBorderVisible(false);
    self.dayRenders[i]:setPositionXY(dayRenderContainer_pos.x+125*((i-1)%5),dayRenderContainer_pos.y-76*math.modf((i-1)/5));
    self.dayRenders[i].touchEnabled=true;
    self.dayRenders[i].touchChildren=true;
    self.dayRenders[i]:addEventListener(DisplayEvents.kTouchTap, self.onSelectDay, self)
    self.armature:addChild(self.dayRenders[i]);
  end

  --pos_fund_select
  local pos_fund_select=self.armature:getChildByName("pos_fund_select");
  self.fundSelectRender=FundSelectRender.new();
  self.fundSelectRender:initialize(self.skeleton,self.fundState,userCurrencyProxy,userProxy);
  self.fundSelectRender:setPosition(pos_fund_select:getPosition());
  self.fundSelectRender:setButtonVisible(false);
  self.armature:addChild(self.fundSelectRender);
  
  --common_copy_blueround_button
  local trimButtonData=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData; 
  local button=self.armature:getChildByName("common_copy_blueround_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);
  self.button=CommonButton.new();
  self.button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.button:initializeText(trimButtonData,"领取");
  self.button:setPosition(button_pos);
  self.armature:addChild(self.button);
  self.button:addEventListener(DisplayEvents.kTouchTap, self.onGet, self); 


  --common_copy_close_button
  local closeButton=self.armature:getChildByName("common_copy_close_button");
  local closeButton_pos = convertBone2LB4Button(closeButton);
  self.armature:removeChild(closeButton);
  closeButton=CommonButton.new();
  closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  closeButton:setPosition(closeButton_pos);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self:addChild(closeButton);
  self.button_close=closeButton;

  self.currentDayIndex = self.activityProxy.fundCurrentDay;
  self:setBagItem(self.currentDayIndex);

  --AddUIFrame(self); 
end

function FundEveryday:refresh()

  self.dayRenders[self.currentDayIndex]:setData(self.activityProxy.fundStateArray[self.currentDayIndex]==1);

  --todo ,现在不需要了，保留
  -- local nextDayIndex = self.activityProxy:getFirstFundAwardDayIndex();
  -- if nextDayIndex>0 then
  --   self.currentDayIndex = nextDayIndex;
  --   self:setBagItem(self.currentDayIndex);
  -- else

  -- end

  for k,v in pairs(self.dayRenders) do
    if tonumber(v.dayIndex)<self.currentDayIndex then
      v:isPassed(true);
    else
      v:isPassed(false);
    end
  end

  local boo = self.currentDayIndex<=self.activityProxy.fundCurrentDay and self.activityProxy.fundStateArray[self.currentDayIndex]==0;
  local tempButtonText=""
  if self.activityProxy.fundStateArray[self.currentDayIndex]==0 then
    tempButtonText="领取"
  elseif self.activityProxy.fundStateArray[self.currentDayIndex]==1 then
    tempButtonText="已领"
  else
    --容错
    tempButtonText="已领";
  end
  local trimButtonData=self.armatureDefault:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  self.button:initializeText(trimButtonData,tempButtonText);
  self.button:setGray(not boo,boo);


end

function FundEveryday:onSelectDay(event)
  local aa = event.target
  --self.currentDayIndex = aa.dayIndex;
  --if tonumber(aa.dayIndex)>=tonumber(self.currentDayIndex) then
  if true then
    self:setBagItem(aa.dayIndex);
  end
  

end

function FundEveryday:setBagItem(dayIndex)
  local curDayIndex
  if self.fundState == 1 then
    curDayIndex = dayIndex;  
    if dayIndex<1 or dayIndex>ActivityConstConfig.FUND_SILVER_MAX then return end;
  elseif self.fundState == 2 then
    curDayIndex = ActivityConstConfig.FUND_SILVER_MAX+dayIndex;
    if dayIndex<1 or dayIndex>ActivityConstConfig.FUND_GOLD_MAX then return end;
  elseif self.fundState == 3 then
    curDayIndex = ActivityConstConfig.FUND_SILVER_MAX+ActivityConstConfig.FUND_GOLD_MAX+dayIndex;
    if dayIndex<1 or dayIndex>ActivityConstConfig.FUND_DIAMOND_MAX then return end;
  end

  --print("%%%%%%%%1",dayIndex,curDayIndex)

  local text_dayValue = "第"..ChineseNumber[dayIndex].."天\n  返利";
  self.text_day:setString(text_dayValue);

  local boo = dayIndex==self.activityProxy.fundCurrentDay and self.activityProxy.fundStateArray[dayIndex]==0;
  local tempButtonText=""
  if self.activityProxy.fundStateArray[dayIndex]==0 then
    tempButtonText="领取"
  elseif self.activityProxy.fundStateArray[dayIndex]==1 then
    tempButtonText="已领"
  else
    --容错
    tempButtonText="已领";
  end
  local trimButtonData=self.armatureDefault:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  self.button:initializeText(trimButtonData,tempButtonText);
  self.button:setGray(not boo,boo);

  
  for k,v in pairs(self.dayRenders) do
    if v.dayIndex==dayIndex then
      v:select(true)
    else
      v:select(false)
    end

    if tonumber(v.dayIndex)<self.currentDayIndex then
      v:isPassed(true);
    else
      v:isPassed(false);
    end
  end


  local a=StringUtils:stuff_string_split(analysis("Yunying_Jijinfanli",curDayIndex,"award"));
  --local container=self.armature:getChildByName("container");
  --local bagItem_pos=container:getPosition();

  for k,v in pairs(self.bagItems) do
    self.armature:removeChild(v);
  end
  self.bagItems={};

  local pos = {}
  pos[1] = self.armature:getChildByName("common_copy_grid1"):getPosition()
  pos[2] = self.armature:getChildByName("common_copy_grid2"):getPosition()
  --print("%%%%%%%%2",a)
  for k,v in pairs(a) do
    if nil==self.bagItems[k] then
      self.bagItems[k]=BagItem.new();
      self.bagItems[k]:initialize({UserItemId=0,ItemId=v[1],Count=v[2],IsBanding=0,IsUsing=0,Place=0},nil,nil,false);
      --self.bagItems[k]:setBorderVisible(false);
      self.bagItems[k]:setPositionXY(pos[k].x+7,pos[k].y-(86-7));
      self.bagItems[k].touchEnabled=false;
      self.bagItems[k].touchChildren=false;
      self.armature:addChild(self.bagItems[k]);
    end
  end
end

function FundEveryday:onGet(event)
  
  --<param main="24" sub="42" desc="请求 领取基金">ID</param>
  print("sendMessage(24,42)",self.currentDayIndex)
  local msg = {ID = self.currentDayIndex};
  sendMessage(24,42,msg);
end

function FundEveryday:onCloseButtonTap(event)
  self.parent:dispatchEvent(Event.new(ActivityNotifications.FUND_CLOSE,nil,self));
end
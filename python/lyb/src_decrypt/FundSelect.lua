require "main.view.activity.ui.fund.FundSelectRender";

FundSelect=class(TouchLayer);

function FundSelect:ctor()
  self.class=FundSelect;

  self.isOutDate = false;
  self.refreshTimeId = nil;
  self.endTime = 0;
end

function FundSelect:dispose()
  self:removeAllEventListeners();
	self:removeChildren();
  FundSelect.superclass.dispose(self);
	self.removeArmature:dispose()
end

function FundSelect:initializeUI(skeleton, activityProxy, userCurrencyProxy, userDataAccumulateProxy,userProxy)
  self:initLayer();

  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.userCurrencyProxy = userCurrencyProxy;
  self.userDataAccumulateProxy = userDataAccumulateProxy;
  
  -- local mainSize = Director:sharedDirector():getWinSize();
  -- self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));


  local armature=skeleton:buildArmature("fund_select");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  -- AddUIBackGround(self);

  local text="<content><font color='#ffffff'>买VIP基金获超值返利，最高可达</font><font color='#00ff00'>300%</font><content><font color='#ffffff'>。购买当天即可领，只能选取一种基金购买哟~ </font>";
  local text_data=armature:getBone("text1").textData;
  self.text_day=createMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.text_day);

  text="";
  text_data=armature:getBone("text_time").textData;
  self.text_time=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_time);

  --text_instruction
  text='<content><font color="#00FF00" ref="1">查看说明</font></content>';
  text_data=armature:getBone("text_instruction").textData;
  self.text_instruction=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.text_instruction:addEventListener(DisplayEvents.kTouchTap,self.onShowTip,self);
  self.armature:addChild(self.text_instruction);

  self.textTipBg = self.armature:getChildByName("common_copy_background_inner_1");
  self.textTipBg:setVisible(false);
  --text_tip
  text = "1.只有拥有任意VIP等级的玩家可以购买基金。\n\n2.当天基金返利只能当天领取，逾期无法再次领取。\n\n3.基金返还比例分为150%、200%、300%三档，只能选取一档进行购买，确定之后无法再次购买其他档基金。";
  text_data=armature:getBone("text_tip").textData;
  self.text_tip=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_tip);
  self.text_tip:setVisible(false);


  --text_render1EverydayPrize
  local vo = analysis("Yunying_Jijinfanli",1);
  text = "每日至少领取\n"..vo.awardClient;
  text_data=armature:getBone("text_render1EverydayPrize").textData;
  self.text_render1EverydayPrize=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_render1EverydayPrize);

  --text_render2EverydayPrize
  local vo = analysis("Yunying_Jijinfanli",8);
  text = "每日至少领取\n"..vo.awardClient;
  text_data=armature:getBone("text_render2EverydayPrize").textData;
  self.text_render2EverydayPrize=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_render2EverydayPrize);

  --text_render3EverydayPrize
  local vo = analysis("Yunying_Jijinfanli",23);
  text = "每日至少领取\n"..vo.awardClient;
  text_data=armature:getBone("text_render3EverydayPrize").textData;
  self.text_render3EverydayPrize=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.text_render3EverydayPrize);


  if activityProxy then
    self.endTime = self.activityProxy.fundRemainTime[2];
  end

  self.isOutDate = self.endTime<=0;

  local function funRefreshTime()
      local remainSecond = self.endTime - (os.time()-self.activityProxy.fundRemainTime[3]);
     
      if remainSecond > 0 then
        local time = self:getTimeString(remainSecond)
        if self.refreshTimeId and not self.text_time.sprite then
          self:disposeTime()
        else
          self.text_time:setString(time)
        end
      else
        self:disposeTime()
        self.isOutDate = true;
        self.text_time:setString("活动已过期")
     end
  end
  if self.endTime then
    self.refreshTimeId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(funRefreshTime, 1, false);
  end

  local item1=self.armature:getChildByName("fund_select_render1");
  local item1_pos=item1:getPosition();
  self.armature:removeChild(item1);
  item1=FundSelectRender.new();
  item1:initialize(self.skeleton,1,userCurrencyProxy,userProxy);
  item1:setPosition(item1_pos);
  self:addChild(item1);

  local item2=self.armature:getChildByName("fund_select_render2");
  local item2_pos=item2:getPosition();
  self.armature:removeChild(item2);
  item2=FundSelectRender.new();
  item2:initialize(self.skeleton,2,userCurrencyProxy,userProxy);
  item2:setPosition(item2_pos);
  self:addChild(item2);

  local item3=self.armature:getChildByName("fund_select_render3");
  local item3_pos=item3:getPosition();
  self.armature:removeChild(item3);
  item3=FundSelectRender.new();
  item3:initialize(self.skeleton,3,userCurrencyProxy,userProxy);
  item3:setPosition(item3_pos);
  self:addChild(item3);


  --common_copy_blueround_button
  local trimButtonData=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData; 
  local button=self.armature:getChildByName("common_copy_blueround_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);
  self.button=CommonButton.new();
  self.button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.button:initializeText(trimButtonData,"");
  self.button:setPosition(button_pos);
  self.armature:addChild(self.button);
  self.button:addEventListener(DisplayEvents.kTouchTap, self.onJumpToVip, self); 

  self.image_becomeVIP=self.armature:getChildByName("image_becomeVIP");
  self.image_becomeVIP.touchEnabled = false;
  self.armature:removeChild(self.image_becomeVIP,false);
  self.armature:addChild(self.image_becomeVIP);
  --self.image_becomeVIP:addEventListener(DisplayEvents.kTouchTap,self.onJumpToVip,self);

  --common_copy_close_button
  local closeButton=self.armature:getChildByName("common_copy_close_button");
  local closeButton_pos = convertBone2LB4Button(closeButton);
  self.armature:removeChild(closeButton);
  closeButton=CommonButton.new();
  closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  closeButton:setPosition(closeButton_pos);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self.armature:addChild(closeButton);
  self.closeButton=closeButton;

  self.armature:removeChild(self.textTipBg,false);
  self.armature:removeChild(self.text_tip,false);
  self:addChild(self.textTipBg);
  self:addChild(self.text_tip);

end

function FundSelect:disposeTime()
  if self.refreshTimeId then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.refreshTimeId);
    self.refreshTimeId = nil;
  end
end
function FundSelect:getTimeString(remainSecond)
  --print("remainSecond:"..remainSecond);
  local returnValue = "再不买，基金就消失咯！倒计时";
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
    returnValue = returnValue..dayTime .. "天";
  end
  if hourTime then
    returnValue = returnValue .. hourTime .. "时";
  end
  if minuteTime then
    returnValue = returnValue .. minuteTime .. "分";
  end
  if secondTime then
    returnValue = returnValue .. secondTime .. "秒";
  end
  return returnValue;
end

function FundSelect:onCloseButtonTap(event)
  self.parent:dispatchEvent(Event.new(ActivityNotifications.FUND_CLOSE,nil,self));
end

function FundSelect:onShowTip()
  --print("OK1")
  self.textTipBg:setVisible(true);
  self.text_tip:setVisible(true);

  if self.tipLayer==nil then
    self.tipLayer = Layer.new();
    self.tipLayer:initLayer();
    self.tipLayer:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT));
    self.tipLayer:setPositionXY(0, 0);
    self:addChild(self.tipLayer);
  end
  self.tipLayer:addEventListener(DisplayEvents.kTouchTap,self.onHideTip,self);
  self.tipLayer:setVisible(true);
end

function FundSelect:onHideTip()
  --print("OK2");
  self.tipLayer:setVisible(false);
  self.textTipBg:setVisible(false);
  self.text_tip:setVisible(false);
end

function FundSelect:onJumpToVip()
 self.parent:onOpenVIPUI();
end

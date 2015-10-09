require "main.view.activity.ui.PayRebateItem";

PayRebateLayer=class(TouchLayer);

function PayRebateLayer:ctor()
  self.class=PayRebateLayer;
  self.currentActivityId = nil;
end

function PayRebateLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  PayRebateLayer.superclass.dispose(self);
  self.removeArmature:dispose()
end

function PayRebateLayer:initialize(skeleton, activityProxy, generalListProxy, parent_container,num)
  self.currentActivityId = num
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.generalListProxy=generalListProxy;
  self.parent_container=parent_container;

  local armature=skeleton:buildArmature("payRebate_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self.armature:removeChildAt(1);
  self:addChild(self.armature);

  local progressBar = armature:findChildArmature("progressBar");
  self.progressBar = ProgressBar.new(progressBar, "barUp");
  self.progressBar:setProgress(0);

  local text_data=armature:getBone("expense_time_text").textData;
  local activeTime=createTextFieldWithTextData(text_data,"活动时间 :");
  self.armature:addChild(activeTime);

  text_data=armature:getBone("expense_time_num_text").textData;
  self.activeTimeText=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.activeTimeText);

  text_data=armature:getBone("expense_add_value_text").textData;
  self.addValueText=createTextFieldWithTextData(text_data,"已累积充值 ：");
  self.armature:addChild(self.addValueText);

  text_data=armature:getBone("expense_add_text_1").textData;
  local addText=createTextFieldWithTextData(text_data,"累积");
  self.armature:addChild(addText);

  text_data=armature:getBone("expense_add_text_2").textData;
  addText=createTextFieldWithTextData(text_data,"累积");
  self.armature:addChild(addText);

  text_data=armature:getBone("expense_add_text_3").textData;
  addText=createTextFieldWithTextData(text_data,"累积");
  self.armature:addChild(addText);

  text_data=armature:getBone("expense_add_text_4").textData;
  addText=createTextFieldWithTextData(text_data,"累积");
  self.armature:addChild(addText);

  text_data=armature:getBone("expense_addNum_text_1").textData;
  self.addNumText1=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.addNumText1);

  text_data=armature:getBone("expense_addNum_text_2").textData;
  self.addNumText2=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.addNumText2);

  text_data=armature:getBone("expense_addNum_text_3").textData;
  self.addNumText3=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.addNumText3);

  text_data=armature:getBone("expense_addNum_text_4").textData;
  self.addNumText4=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.addNumText4);

  text_data=armature:getBone("expense_give_text_1").textData;
  self.giveText1=createTextFieldWithTextData(text_data,"另送");
  self.armature:addChild(self.giveText1);

  text_data=armature:getBone("expense_give_text_2").textData;
  self.giveText2=createTextFieldWithTextData(text_data,"另送");
  self.armature:addChild(self.giveText2);

  text_data=armature:getBone("expense_give_text_3").textData;
  self.giveText3=createTextFieldWithTextData(text_data,"另送");
  self.armature:addChild(self.giveText3);

  text_data=armature:getBone("expense_give_text_4").textData;
  self.giveText4=createTextFieldWithTextData(text_data,"另送");
  self.armature:addChild(self.giveText4);

  text_data=armature:getBone("expense_giveNum_text_1").textData;
  self.giveNumText1=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.giveNumText1);

  text_data=armature:getBone("expense_giveNum_text_2").textData;
  self.giveNumText2=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.giveNumText2);

  text_data=armature:getBone("expense_giveNum_text_3").textData;
  self.giveNumText3=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.giveNumText3);

  text_data=armature:getBone("expense_giveNum_text_4").textData;
  self.giveNumText4=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.giveNumText4);

  text_data=armature:getBone("expense_des_text").textData;
  local des=createTextFieldWithTextData(text_data,"小贴心：累计充值元宝~另送元宝噢！请在系统奖励领奖噢！");
  self.armature:addChild(des);

  local rechargeButtonData = armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  local rechargeButton=self.armature:getChildByName("common_copy_blueround_button");
  local rechargeButtonP = convertBone2LB4Button(rechargeButton);
  self.armature:removeChild(rechargeButton);

   rechargeButton=CommonButton.new();
   rechargeButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
   rechargeButton:initializeText(rechargeButtonData,"充值");
   rechargeButton:setPosition(rechargeButtonP);
   rechargeButton:addEventListener(DisplayEvents.kTouchTap,self.rechargeButtonHandler,self);
   self:addChild(rechargeButton);
   self.rechargeButton = rechargeButton;

  --[[local box1 = self.armature:getChildByName("common_copy_box_close_1");
  self.box1X = box1:getPositionX()
  local tempY = box1:getPositionY();
  self.box1Y = tempY - box1:getContentSize().height;
  self.armature:removeChild(box1);

  local box2 = self.armature:getChildByName("common_copy_box_close_2");
  self.box2X = box2:getPositionX()
  tempY = box2:getPositionY();
  self.box2Y = tempY - box2:getContentSize().height;
  self.armature:removeChild(box2);

  local box3 = self.armature:getChildByName("common_copy_box_close_3");
  self.box3X = box3:getPositionX()
  tempY = box3:getPositionY();
  self.box3Y = tempY - box3:getContentSize().height;
  self.armature:removeChild(box3);

  local box4 = self.armature:getChildByName("common_copy_box_close_4");
  self.box4X = box4:getPositionX()
  tempY = box4:getPositionY();
  self.box4Y = tempY - box4:getContentSize().height;
  self.armature:removeChild(box4);]]

  local table = {ConfigId = self.currentActivityId}
  sendMessage(24, 20, table);

end

function PayRebateLayer:refreshPay()
      local activityProxy = self.parent.parent.activityProxy;
      local hasExpenseValue = activityProxy:getRebateValue();
      local rebateId = activityProxy:getRebateId();
      local beginTime = activityProxy:getRebateBeginTimeStr();
      local endTime = activityProxy:getRebateEndTimeStr();
      local activityPO = analysis("Huodongbiao_Huodong",self.currentActivityId);
      local awards = "0,0#0;"..activityPO.awards
      local awardsTotalArr = StringUtils:lua_string_split(awards, ";")
      local awards1Str,awrds2Str,buttonNum = self:getAwardsArr(awardsTotalArr,hasExpenseValue);
      if awards1Str == "0" then
            local tempArr = StringUtils:lua_string_split(awardsTotalArr[2], ",")
            awards1Str = tempArr[1]
      end
      
      self.activeTimeText:setString(beginTime.."~"..endTime);
      self.addValueText:setString("已累积充值 ："..hasExpenseValue.."/"..awards1Str);
      self.progressBar:setProgress(hasExpenseValue/1000);
      --[[for i=1,4 do
            local state = "state1";
            if i <= buttonNum then
                    state = "state2";
            end

            local payRebateItem=PayRebateItem.new();
            local tempStr = self.parent.parent.countControlProxy:getRemainCountByID(CountControlConfig.PayRebate,i);
            if tempStr == 0 then
                    state = "state3";
            end

            payRebateItem.stateType = state;
            payRebateItem.itemId = i;
            local px;local py;
            if i == 1 then
                px = self.box1X
                py = self.box1Y
            elseif i == 2 then
                px = self.box2X
                py = self.box2Y
            elseif i == 3 then
                px = self.box3X
                py = self.box3Y
            elseif i == 4 then
                px = self.box4X
                py = self.box4Y
            end
            payRebateItem:initializeItem();
            payRebateItem:setPositionXY(px,py);
            self:addChild(payRebateItem);
      end]]

end

function PayRebateLayer:getAwardsArr(awardsTotalArr,hasExpenseValue)
      local len = table.getn(awardsTotalArr);
      local awards1Str;local awrds2Str;local buttonNum;
      for k,v in pairs(awardsTotalArr) do
          local tempArr = StringUtils:lua_string_split(awardsTotalArr[len], ",")
          if hasExpenseValue >=  tonumber(tempArr[1]) then
              awards1Str = tempArr[1];
              awrds2Str = tempArr[2];
              buttonNum = len-1;
          end
          if len == 2 then
              self.addNumText1:setString(tempArr[1]);
              local itemArr = StringUtils:lua_string_split(tempArr[2], "#");
              self.giveText1:setString(self:getItemName(itemArr));
              self.giveNumText1:setString(itemArr[2]);
          elseif len == 3 then
              self.addNumText2:setString(tempArr[1]);
              local itemArr = StringUtils:lua_string_split(tempArr[2], "#");
              self.giveText2:setString(self:getItemName(itemArr));
              self.giveNumText2:setString(itemArr[2]);
          elseif len == 4 then
              self.addNumText3:setString(tempArr[1]);
              local itemArr = StringUtils:lua_string_split(tempArr[2], "#");
              self.giveText3:setString(self:getItemName(itemArr));
              self.giveNumText3:setString(itemArr[2]);
          elseif len == 5 then
              self.addNumText4:setString(tempArr[1]);
              local itemArr = StringUtils:lua_string_split(tempArr[2], "#");
              self.giveText4:setString(self:getItemName(itemArr));
              self.giveNumText4:setString(itemArr[2]);
          end
          len = len - 1; 
      end
      return awards1Str,awrds2Str,buttonNum;
end

function PayRebateLayer:getItemName(itemArr)
      local tempStr;
      if itemArr[1] == "1" then
          tempStr = "经验";
      elseif itemArr[1] == "2" then
          tempStr = "银两";
      elseif itemArr[1] == "3" then
          tempStr = "元宝";
      end
      return tempStr;
end

function PayRebateLayer:rechargeButtonHandler(event)
    self.parent.parent:dispatchEvent(Event.new("vip_recharge",nil,self));
end
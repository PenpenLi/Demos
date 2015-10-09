

ExpenseRebateLayer=class(TouchLayer);

function ExpenseRebateLayer:ctor()
  self.class=ExpenseRebateLayer;
  self.currentActivityId = nil;
end

function ExpenseRebateLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ExpenseRebateLayer.superclass.dispose(self);
  self.removeArmature:dispose()
end

function ExpenseRebateLayer:initialize(skeleton, activityProxy, generalListProxy, parent_container,num)
  self.currentActivityId = num;
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.generalListProxy=generalListProxy;
  self.parent_container=parent_container;
  
  local armature=skeleton:buildArmature("expenseRebate_ui");
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

  text_data=armature:getBone("expense_can_text").textData;
  local can=createTextFieldWithTextData(text_data,"可领");
  self.armature:addChild(can);

  text_data=armature:getBone("expense_can_num_text").textData;
  self.canNumText=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.canNumText);

  text_data=armature:getBone("expense_has_text").textData;
  local has=createTextFieldWithTextData(text_data,"当前进度：已累积消费");
  self.armature:addChild(has);

  text_data=armature:getBone("expense_des_text").textData;
  local des=createTextFieldWithTextData(text_data,"小贴心：活动结束后请在小秘面板领奖噢！");
  self.armature:addChild(des);

  text_data=armature:getBone("expense_has_num_text").textData;
  self.hasNumText=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.hasNumText);

  text_data=armature:getBone("expense_once_text").textData;
  local onceText=createTextFieldWithTextData(text_data,"再消费");
  self.armature:addChild(onceText);

  text_data=armature:getBone("expense_once_num_text").textData;
  self.onceNumText=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.onceNumText);

  text_data=armature:getBone("expense_end_text").textData;
  local endText=createTextFieldWithTextData(text_data,"就可领");
  self.armature:addChild(endText);

  text_data=armature:getBone("expense_end_num_text").textData;
  self.endNumText=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.endNumText);

  text_data=armature:getBone("expense_end_des_text").textData;
  local endDesText=createTextFieldWithTextData(text_data,"咯！");
  self.armature:addChild(endDesText);
  local table = {ConfigId = self.currentActivityId}
  sendMessage(24, 20, table);
end

function ExpenseRebateLayer:refreshExpense()
      local activityProxy = self.parent.parent.activityProxy;
      local hasExpenseValue = activityProxy:getRebateValue();
      local rebateId = activityProxy:getRebateId();
      local beginTime = activityProxy:getRebateBeginTimeStr();
      local endTime = activityProxy:getRebateEndTimeStr();
      local activityPO = analysis("Huodongbiao_Huodong",self.currentActivityId);
      local awards = "0,0;"..activityPO.awards
      local awardsTotalArr = StringUtils:lua_string_split(awards, ";")

      local awards1,awrds2 = self:getAwardsArr(awardsTotalArr,hasExpenseValue);
      local percent = awrds2/100000
      
      self.activeTimeText:setString(beginTime.."~"..endTime);
      self.hasNumText:setString(math.floor(hasExpenseValue));
      self.canNumText:setString(math.floor(hasExpenseValue*percent));
      self.onceNumText:setString(math.floor(awards1 - hasExpenseValue));
      self.endNumText:setString(math.floor((awards1 - hasExpenseValue)*percent))
      self.progressBar:setProgress(hasExpenseValue/tonumber(awards1));
end

function ExpenseRebateLayer:getAwardsArr(awardsTotalArr,hasExpenseValue)
      local len = table.getn(awardsTotalArr);
      local tempLenArr = StringUtils:lua_string_split(awardsTotalArr[len], ",")
      for k,v in pairs(awardsTotalArr) do
          if len == 1 then
              return hasExpenseValue,tempLenArr[2]
          end
          local tempArr1 = StringUtils:lua_string_split(awardsTotalArr[len], ",")
          local tempArr2 = StringUtils:lua_string_split(awardsTotalArr[len-1], ",")
          if tonumber(tempArr1[1]) > hasExpenseValue and  hasExpenseValue >= tonumber(tempArr2[1]) then
              return tempArr1[1],tempArr1[2];
          end
          len = len - 1; 
      end
end
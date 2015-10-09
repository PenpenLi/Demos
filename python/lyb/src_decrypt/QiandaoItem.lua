
QiandaoItem=class(TouchLayer);

function QiandaoItem:ctor()
  self.class=QiandaoItem;
end

function QiandaoItem:dispose()
  self:removeAllEventListeners();
  QiandaoItem.superclass.dispose(self);
end

function QiandaoItem:initialize(context, index)
  self.context=context
  self.id = index;
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("qiandao_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);
  self.weekTable = {"第1天", "第2天", "第3天", "第4天", "第5天", "第6天", "第7天", }
  local text_data = self.armature:getBone("tianshu_txt").textData;
  self.tianshu_txt = createTextFieldWithTextData(text_data, self.weekTable[index]);
  self.armature_d:addChild(self.tianshu_txt);
  
  local text_data = self.armature:getBone("fenshu_txt").textData;
  self.num_txt = createTextFieldWithTextData(text_data,"x800");
  self.armature_d:addChild(self.num_txt);

  local text_data = self.armature:getBone("name_txt").textData;
  self.name_txt = createTextFieldWithTextData(text_data,"元宝", true);
  self.armature_d:addChild(self.name_txt);

  local gold_image=armature_d:getChildByName("gold_image");
  self.gold_pos = gold_image:getPosition();
  self.armature_d:removeChild(gold_image);
  

  self:addEventListener(DisplayEvents.kTouchTap,self.onTouch,self);

  self.panel = armature_d:getChildByName("panel_bg");
  self.panel_not = armature_d:getChildByName("panel_bg_not");
  
  self.diban = armature_d:getChildByName("diban_bg");
  self.diban_not = armature_d:getChildByName("diban_bg_not");

  self.haveTaken_pic = self.armature_d:getChildByName("haveTaken");
  self.haveTaken_pic:setVisible(false);

  --cartoon 1387
  self.panelSize = self.panel:getContentSize();
  if not self.cartoon then
    local size = self.panel:getContentSize();
    self.cartoon = cartoonPlayer("1387", size.width, 0, 0,nil, 2, nil, 1);
    self.cartoon:setAnchorPoint(ccp(0, 0))
    self.armature_d:addChild(self.cartoon)
    self.cartoon:setVisible(false)
  end

end

function QiandaoItem:refreshImageAndNumber(itemIdArray)
  
    self.num_txt:setString("x"..tostring(itemIdArray[1].Count));
    local itemData = analysis("Daoju_Daojubiao",itemIdArray[1].ItemId);

    local imageId = itemData.art;
    self.gold=Image.new()
    self.gold:loadByArtID(imageId)
    local x = self.gold_pos.x - 20
    local y = self.gold_pos.y - 75
    self.gold:setPosition(ccp(x, y));
    self.gold:setScale(1.2)
    self.armature_d:addChildAt(self.gold, self.armature_d:getChildIndex(self.haveTaken_pic)-1);

    local name = itemData.name;
    self.name_txt:setString(name)
end

function QiandaoItem:refreshState(count, maxCount, ConditionID, booleanValue)
  self.conditionID = ConditionID;
  
  if count == maxCount then
    self.takeType = 0;
    if booleanValue == 0 then
      self.haveTaken = false;
      self.haveTaken_pic:setVisible(false);
      self.cartoon:setVisible(true);

      self.panel:setVisible(false);
      self.diban:setVisible(false);
      self.panel_not:setVisible(true);
      self.diban_not:setVisible(true);
    elseif booleanValue == 1 then
      self.haveTaken = true;
      self.haveTaken_pic:setVisible(true);
      self.cartoon:setVisible(false)

      self.panel:setVisible(true);
      self.diban:setVisible(true);
      self.panel_not:setVisible(false);
      self.diban_not:setVisible(false);
    end
    

    -- print("今天可领奖keyi")
  elseif count > maxCount then

    self.takeType = -1;
    if booleanValue == 0 then 
      self.haveTaken = false;
      self.panel:setVisible(true);
      self.diban:setVisible(true);
      self.panel_not:setVisible(false);
      self.diban_not:setVisible(false);
      self.haveTaken_pic:setVisible(false);
      -- print("过了未领奖")
    else
      self.haveTaken = true;
      self.panel:setVisible(true);
      self.diban:setVisible(true);
      self.panel_not:setVisible(false);
      self.diban_not:setVisible(false);
      self.haveTaken_pic:setVisible(true);
      -- print("过了已领奖")
    end
    
  else  
    self.takeType = 1;

    self.panel:setVisible(false);
    self.diban:setVisible(false);
    self.panel_not:setVisible(true);
    self.diban_not:setVisible(true);
    -- print("未到时间weidao")
  end
end



function QiandaoItem:onTouch(event) 
  
  if self.takeType == 0 then
    if self.haveTaken == false then
      self.haveTaken_pic:setVisible(true);
      self.cartoon:setVisible(false)
      self.panel:setVisible(true);
      self.diban:setVisible(true);
      self.panel_not:setVisible(false);
      self.diban_not:setVisible(false);
      self.context:takeAward(self.conditionID);
      sendMessage(29, 3, {ConditionID = self.conditionID});
      self.haveTaken = true;
      
    else
      sharedTextAnimateReward():animateStartByString("您已领取奖励了！"); 
    end
    
  elseif self.takeType == -1 then 
    if self.haveTaken == false then
      sharedTextAnimateReward():animateStartByString("领奖时间已过，下次请赶早~"); 
    else
      sharedTextAnimateReward():animateStartByString("您已领取奖励了！"); 
    end
    
  else
    sharedTextAnimateReward():animateStartByString("还不能领取！"); 
  end
  
end
MailDetailWithBonus=class(Layer);

function MailDetailWithBonus:ctor()
  self.class=MailDetailWithBonus;
end

function MailDetailWithBonus:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	MailDetailWithBonus.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function MailDetailWithBonus:initialize(context, mailItem)
  self:initLayer();
  self.context = context;
  self.mailItem = mailItem;
  self.skeleton = self.context.skeleton;
  self.itemData = self.mailItem.itemData;
  self.bonus_count = 0;
  
  --骨骼
  local armature = self.skeleton:buildArmature("mail_detail_with_bonus_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  
  armature = armature.display;
  self:addChild(armature);

  local text_data = self.armature4dispose:getBone("mail_title_descb").textData;
  local mail_title_descb = createTextFieldWithTextData(text_data,self.itemData.Title);
  self:addChild(mail_title_descb);

  text_data = self.armature4dispose:getBone("mail_content_descb").textData;
  local mail_content_descb = createTextFieldWithTextData(text_data,self.itemData.Content);
  self:addChild(mail_content_descb);

  text_data = self.armature4dispose:getBone("mail_auther_descb").textData;
  local mail_auther_descb = createRichMultiColoredLabelWithTextData(text_data,"<content><font color='#FFFFFF'>发件人 : </font><font color='#FFA200'>" .. self.itemData.FromUserName .. "</font></content>");
  self:addChild(mail_auther_descb);

  -- self.closeButton = Button.new(self.armature4dispose:findChildArmature("common_blue_button"), false);
  -- self.closeButton.bone:initTextFieldWithString("common_blue_button","领取奖励");
  -- self.closeButton:addEventListener(Events.kStart, self.onGetBonus, self);

  local button=armature:getChildByName("common_blue_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature4dispose.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("领取奖励","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onGetBonus,self);
  self.armature4dispose.display:addChild(button);

  local _gold_count = self:getGoldBonus();
  if _gold_count then
    text_data = self.armature4dispose:getBone("common_gold_bg").textData;
    local common_gold_bg = createTextFieldWithTextData(text_data, _gold_count);
    self:addChild(common_gold_bg);
  else
    armature:getChildByName("common_gold_bg"):setVisible(false);
    armature:getChildByName("moji_1"):setVisible(false);
  end

  local _silver_count = self:getSilverBonus();
  if _silver_count then
    text_data = self.armature4dispose:getBone("common_silver_bg").textData;
    local common_silver_bg = createTextFieldWithTextData(text_data, _silver_count);
    self:addChild(common_silver_bg);

    if not _gold_count then
      local silver_bg = armature:getChildByName("common_silver_bg");
      local moji_2 = armature:getChildByName("moji_2");
      local gold_text_data = self.armature4dispose:getBone("common_gold_bg").textData;
      silver_bg:setPosition(armature:getChildByName("common_gold_bg"):getPosition());
      moji_2:setPosition(armature:getChildByName("moji_1"):getPosition());

      common_silver_bg:setPositionXY(gold_text_data.x,gold_text_data.y);
    end
  else
    armature:removeChild(armature:getChildByName("common_silver_bg"));
    armature:removeChild(armature:getChildByName("moji_2"));
  end

  local _bonus = self:getOtherBonus();
  if 0 ~= table.getn(_bonus) then
    self.const_item_num=3.5;
    self.const_item_size=makeSize(115,115);
    self.const_item_layer_pos=makePoint(35,160);

    --item
    self.item_layer=ListScrollViewLayer.new();
    self.item_layer:initLayer();
    self.item_layer:setPosition(self.const_item_layer_pos);
    self.item_layer:setViewSize(makeSize(self.const_item_num*self.const_item_size.width,
                                         self.const_item_size.height));
    self.item_layer:setItemSize(self.const_item_size);
    self.item_layer:setDirection(0);
    self:addChild(self.item_layer);

    for k,v in pairs(_bonus) do
      if 1000000 < v.ItemId then
        self.bonus_count = 1 + self.bonus_count;
      end

      local layer=Layer.new();
      layer:initLayer();
      self.item_layer:addItem(layer);

      local _item_bg = self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid");
      _item_bg:setPositionXY(2,2);
      layer:addChild(_item_bg);
      local _item = BagItem.new();
      _item:initialize({ItemId = v.ItemId, Count = v.Count});
      _item.touchChildren=true;
      _item.touchEnabled=true;
      _item:addEventListener(DisplayEvents.kTouchTap,self.onIconTap,self,_item);
      _item:setPositionXY(10,10);
      layer:addChild(_item);
    end
  end
end

function MailDetailWithBonus:onItemDetailLayerTap(event)
  self.itemDetailLayer:removeEventListener(DisplayEvents.kTouchBegin,self.onItemDetailLayerTap,self);
  self.itemDetailLayer.parent:removeChild(self.itemDetailLayer);
  self.itemDetailLayer=nil;
  self.equipDetailLayer.parent:removeChild(self.equipDetailLayer);
  self.equipDetailLayer=nil;
end

function MailDetailWithBonus:onIconTap(event, item)
  -- local targeClone = item:clone();
  self.itemDetailLayer=LayerColorBackGround:getOpacityBackGround();
  self.itemDetailLayer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.itemDetailLayer:addEventListener(DisplayEvents.kTouchBegin,self.onItemDetailLayerTap,self);
  self.parent.parent:addChild(self.itemDetailLayer);
  
  if analysisHas("Zhuangbei_Zhuangbeipeizhibiao",item:getItemID()) then
    self.equipDetailLayer=EquipDetailLayer.new();
    self.equipDetailLayer:initialize(self.context.bagProxy:getSkeleton(), item, false);
  elseif 12 >= item:getItemID() then
    self.equipDetailLayer=CurrencyDetailLayer.new();
    self.equipDetailLayer:initialize(self.context.bagProxy:getSkeleton(),analysis("Daoju_Daojubiao",item:getItemID(),"name") .. " " .. item:getItemData().Count);
    self.equipDetailLayer:setPositionXY(GameData.uiOffsetX+event.globalPosition.x,GameData.uiOffsetY+event.globalPosition.y);
  else
    self.equipDetailLayer=DetailLayer.new();
    self.equipDetailLayer:initialize(self.context.bagProxy:getSkeleton(), item, false);
  end

  if 12 >= item:getItemID() then

  else
    local size=self.parent:getContentSize();
    local popupSize=self.equipDetailLayer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
    self.equipDetailLayer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2)-20);
  end
  self.parent.parent:addChild(self.equipDetailLayer);
end

function MailDetailWithBonus:getGoldBonus()
  local _itemIdArray = self.mailItem.itemData.ItemIdArray;
  for k,v in pairs(_itemIdArray) do
    if 3 == v.ItemId then
      return v.Count;
    end
  end
end

function MailDetailWithBonus:getSilverBonus()
  local _itemIdArray = self.mailItem.itemData.ItemIdArray;
  for k,v in pairs(_itemIdArray) do
    if 2 == v.ItemId then
      return v.Count;
    end
  end
end

function MailDetailWithBonus:getOtherBonus()
  local _itemIdArray = self.mailItem.itemData.ItemIdArray;
  local _bonus = {};
  for k,v in pairs(_itemIdArray) do
    if 2 ~= v.ItemId and 3 ~= v.ItemId then
      table.insert(_bonus,v);
    end
  end
  return _bonus;
end

function MailDetailWithBonus:onGetBonus(event)
  if self.context.bagProxy:getBagLeftPlaceCount() < self.bonus_count then
    sharedTextAnimateReward():animateStartByString("背包满了呢 ~");
    return;
  end
  self.context:onGetBonus({MailId = self.itemData.MailId});
  self.context:closeMailItemDetail();
  self.context:removeMailItem(self.mailItem);
end
LangyabangPopLayerItem=class(Layer);

function LangyabangPopLayerItem:ctor()
  self.class=LangyabangPopLayerItem;
end

function LangyabangPopLayerItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	LangyabangPopLayerItem.superclass.dispose(self);
end

function LangyabangPopLayerItem:initialize(context, rank)
  self.context = context;
  self.rank = rank;

  self:initLayer();

  local select_type = self.context.selected_type;
  if 1 == select_type then
    self:refreshForBangpai();
  else
    self:refresh();
  end
end

function LangyabangPopLayerItem:refresh()
  --骨骼
  local armature=self.context.skeleton:buildArmature("detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local data = self.context.services[self.context.selected_type];

  local title = self.context.skeleton:getBoneTextureDisplay("rank_" .. self.rank);
  title.sprite:setAnchorPoint(CCPointMake(0.5,0.5));
  title:setPositionXY(163,420);
  self.armature:addChild(title);

  local text_data=armature:getBone("name_bg").textData;
  self.name_bg=createTextFieldWithTextData(text_data,data[self.rank].ParamStr1);
  self.armature:addChild(self.name_bg);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"等级：" .. data[self.rank].ParamStr4);
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("descb").textData;
  self.descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.descb);

  if 1 == self.context.selected_type then

  elseif 2 == self.context.selected_type then
    
    self.descb:setString("消费：       " .. data[self.rank].ParamStr3);

    local common_gold_bg = self.context.skeleton:getCommonBoneTextureDisplay("commonCurrencyImages/common_gold_bg");
    common_gold_bg:setScale(0.6);
    common_gold_bg:setPositionXY(135,293);
    self.armature:addChild(common_gold_bg);

  elseif 3 == self.context.selected_type then

    self.descb:setString("战力：" .. data[self.rank].ParamStr3);

  elseif 4 == self.context.selected_type or 5 == self.context.selected_type then

  end

  for k,v in pairs(data[self.rank].RankGeneralArray) do
    -- if 0 == v.BooleanValue then
      if 4 == k then
        break;
      end
      local heroRoundPortrait = HeroRoundPortrait.new();
      heroRoundPortrait:initialize(v,false);
      heroRoundPortrait:showName4RankList();
      heroRoundPortrait:setScale(0.65);
      heroRoundPortrait:setPositionXY(70,-85*(-1+k)+210);
      self.armature:addChild(heroRoundPortrait);
    -- end
  end
end

function LangyabangPopLayerItem:refreshForBangpai()
  --骨骼
  local armature=self.context.skeleton:buildArmature("detail_ui_bangpai");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local data = self.context.services[self.context.selected_type];

  local title = self.context.skeleton:getBoneTextureDisplay("rank_" .. self.rank);
  title.sprite:setAnchorPoint(CCPointMake(0.5,0.5));
  title:setPositionXY(163,420);
  self.armature:addChild(title);

  local text_data=armature:getBone("name_bg").textData;
  self.name_bg=createTextFieldWithTextData(text_data,data[self.rank].ParamStr1);
  self.armature:addChild(self.name_bg);

  text_data=armature:getBone("shili_descb").textData;
  self.shili_descb=createTextFieldWithTextData(text_data,"综合实力：" .. data[self.rank].ParamStr6);
  self.armature:addChild(self.shili_descb);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"帮派等级：" .. data[self.rank].ParamStr2);
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("bangzhong_descb").textData;
  self.bangzhong_descb=createTextFieldWithTextData(text_data,"帮众：" .. data[self.rank].ParamStr7);
  self.armature:addChild(self.bangzhong_descb);

  text_data=armature:getBone("bangzhu_descb").textData;
  self.bangzhu_descb=createTextFieldWithTextData(text_data,"帮主：" .. data[self.rank].ParamStr4);
  self.armature:addChild(self.bangzhu_descb);

  text_data=armature:getBone("descb").textData;
  self.descb=createTextFieldWithTextData(text_data,"" == data[self.rank].ParamStr8 and StringUtils:getString4Popup(PopupMessageConstConfig.ID_516) or data[self.rank].ParamStr8);
  self.armature:addChild(self.descb);

  local layer = Layer.new();
  layer:initLayer();
  layer:setContentSize(self.descb:getContentSize());
  layer:setPosition(self.descb:getPosition());
  if self.context.userProxy:getUserName() == data[self.rank].ParamStr4 then
    layer:addEventListener(DisplayEvents.kTouchTap, self.onChangeTap, self);
  end
  self.armature:addChild(layer);
end

function LangyabangPopLayerItem:onChangeTap(event)
  local pop_up = LangyabangPopLayerItemChangeNotice.new();
  pop_up:initialize(self.context, self);
  self.context.parent:addChild(pop_up);
end

LangyabangPopLayerItemChangeNotice=class(Layer);

function LangyabangPopLayerItemChangeNotice:ctor()
  self.class=LangyabangPopLayerItemChangeNotice;
end

function LangyabangPopLayerItemChangeNotice:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  LangyabangPopLayerItemChangeNotice.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

--
function LangyabangPopLayerItemChangeNotice:initialize(context, item)
  self:initLayer();
  self.context=context;
  self.item = item;
  self.skeleton=self.context.skeleton;
  
  self:initializeWithFound();
end

function LangyabangPopLayerItemChangeNotice:initializeWithFound()
  self:setContentSize(makeSize(1280,720));
  --骨骼
  local armature=self.skeleton:buildArmature("xiugaigonggao_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text='请输入帮派告示内容';
  local text_data=armature:getBone("common_descb").textData;
  self.descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  self.send_text_data=armature:getBone("input").textData;
  text="请输入...";
  self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));
  self.textInput:initialize();
  self.textInput:setMaxChars(25);
  self.textInput:setSingleline(true);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);

  -- local button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  -- button.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
  -- button:addEventListener(Events.kStart,self.onCancelTap,self);

  -- button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  -- button.bone:initTextFieldWithString("common_copy_blueround_button","确认");
  -- button:addEventListener(Events.kStart,self.onConfirmTap,self);

  --创建家族
  local button=self.armature:getChildByName("common_blueround_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("修改告示","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onConfirmTap,self);
  self.armature:addChild(button);

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onCancelTap, self);

  local size=Director:sharedDirector():getWinSize();
  local popupSize=self.armature:getChildByName("common_copy_panel_4"):getContentSize();
  self.armature:setPositionXY(math.floor((size.width-popupSize.width)/2), math.floor((size.height-popupSize.height)/2));
end

function LangyabangPopLayerItemChangeNotice:onCancelTap(event)
  self.parent:removeChild(self);
end

function LangyabangPopLayerItemChangeNotice:onConfirmTap(event)
  local a=self.textInput:getInputText();
  a=string.sub(a,10,-11);

  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end

  if defaultContent==a or ''==a then
    a='';
  else
    a=string.sub(a,23,-8);
  end
  if ''==a then
    sharedTextAnimateReward():animateStartByString("告示不能为空哦~");
    return;
  end
  --[[if not self.hasItem then
    sharedTextAnimateReward():animateStartByString("道具不足哦~");
    return;
  end
  if not self.hasItem and not self.hasGold then
    sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
    self.context:dispatchEvent(Event.new("vip_recharge",nil,self));
    return;
  end]]
  -- self.context:dispatchEvent(Event.new(FamilyNotifications.FAMILY_FOUND,{FamilyName=a},self));
  -- initializeSmallLoading();
  -- sendMessage(27,1,{FamilyName = a,Type = self.isGold and 1 or 2});
  self.item.descb:setString(a);
  self.context.services[self.context.selected_type][self.item.rank].ParamStr8 = a;
  sendMessage(25,2,{Notice=a});
  self:onCancelTap();
end
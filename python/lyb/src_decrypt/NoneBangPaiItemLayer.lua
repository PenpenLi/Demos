NoneBangPaiItemLayer=class(ListScrollViewLayerItem);

function NoneBangPaiItemLayer:ctor()
  self.class=NoneBangPaiItemLayer;
end

function NoneBangPaiItemLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	NoneBangPaiItemLayer.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

--
function NoneBangPaiItemLayer:initialize(context, data)
  self:initLayer();
  self.context = context;
  self.data = data;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
end

function NoneBangPaiItemLayer:onInitialize()
  --骨骼
  local armature=self.skeleton:buildArmature("bangpai_none_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  --title_1
  local text_data=armature:getBone("player_bg").textData;
  self.player_bg=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.player_bg);

  text_data=armature:getBone("bangpai_name").textData;
  self.bangpai_name=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.bangpai_name);

  text_data=armature:getBone("bangzhu_descb").textData;
  self.bangzhu_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.bangzhu_descb);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("renshu_descb").textData;
  self.renshu_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.renshu_descb);

  text_data=armature:getBone("manyuan_descb").textData;
  self.manyuan_descb=createTextFieldWithTextData(text_data,"已满员");
  self.armature:addChild(self.manyuan_descb);

  --查找家族
  local button=self.armature:getChildByName("shenqing_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("申请","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onShenqingButtonTap,self);
  self:addChild(button);
  self.shenqing_btn = button;

  --创建家族
  local button=self.armature:getChildByName("quxiao_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("取消","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onQuxiaoButtonTap,self);
  self:addChild(button);
  self.quxiao_btn = button;

  self:refresh();
  self:setSearch(false);
end

function NoneBangPaiItemLayer:onShenqingButtonTap(event)
  if self.data.Count >= analysis("Bangpai_Jiazushengjibiao",self.data.FamilyLevel,"renshu") then
    sharedTextAnimateReward():animateStartByString("此帮派人数已满哦~");
    return;
  end
  local count = 0;
  for k,v in pairs(self.context.bangpaiLayer.items) do
    if 1 == v.data.IsApplied then
      count = 1 + count;
    end
  end
  if 10 <= count then
    sharedTextAnimateReward():animateStartByString("超过申请数量上限了哦~");
    return;
  end
  initializeSmallLoading();
  sendMessage(27,13,{FamilyId = self.data.FamilyId,BooleanValue = 1});
  -- sharedTextAnimateReward():animateStartByString("申请已发送~");
  hecDC(3,23,5);
end

function NoneBangPaiItemLayer:onQuxiaoButtonTap(event)
  initializeSmallLoading();
  sendMessage(27,13,{FamilyId = self.data.FamilyId,BooleanValue = 0});
end

function NoneBangPaiItemLayer:refresh()
  if not self.isInitialized then
    self.isInitialized = true;
    self:onInitialize();
  end
  local configID = self.data.ConfigId;
  -- if configID then
  --   local img = Image.new();
  --   img:loadByArtID(analysis("Zhujiao_Zhujiaozhiye",configID,"art3"));
  --   img:setScale(0.76);
  --   img:setPositionXY(19,13);
  --   self.armature:addChild(img);
  -- end
  self.player_bg:setString(self.data.Ranking);
  self.bangpai_name:setString(self.data.FamilyName);
  self.bangzhu_descb:setString(self.data.UserName);
  self.level_descb:setString(self.data.FamilyLevel);
  self.renshu_descb:setString(self.data.Count .. "/" .. analysis("Bangpai_Jiazushengjibiao",self.data.FamilyLevel,"renshu"));

  self:refreshBTN();
end

function NoneBangPaiItemLayer:refreshIsApplied(bool)
  if not self.isInitialized then
    self.isInitialized = true;
    self:onInitialize();
  end
  self.data.IsApplied = bool;
  self:refreshBTN();
end

function NoneBangPaiItemLayer:refreshBTN()
  if self.data.Count >= analysis("Bangpai_Jiazushengjibiao",self.data.FamilyLevel,"renshu") then
    self.shenqing_btn:setVisible(false);
    self.quxiao_btn:setVisible(false);
    self.manyuan_descb:setVisible(true);
  else
    self.shenqing_btn:setVisible(0 == self.data.IsApplied);
    self.quxiao_btn:setVisible(1 == self.data.IsApplied);
    self.manyuan_descb:setVisible(false);
  end
end

function NoneBangPaiItemLayer:setSearch(bool)
  if not self.isInitialized then
    if not bool then
      return;
    else
      self.isInitialized = true;
      self:onInitialize();
    end
  end
  self.armature:getChildByName("bg_for_search"):setVisible(bool);
  self.armature:getChildByName("bangpai_none_item_bg"):setVisible(not bool);
end
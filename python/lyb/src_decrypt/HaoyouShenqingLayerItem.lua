HaoyouShenqingLayerItem=class(Layer);

function HaoyouShenqingLayerItem:ctor()
  self.class=HaoyouShenqingLayerItem;
end

function HaoyouShenqingLayerItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  HaoyouShenqingLayerItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function HaoyouShenqingLayerItem:initialize(context, container, data)
  self:initLayer();
  self.context=context;
  self.container = container;
  self.skeleton=self.context.skeleton;
  self.data=data;
  self.userID=self.context.userProxy:getUserID();

  --骨骼
  local armature=self.skeleton:buildArmature("shenqing_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local bg = CommonPanelSkeleton:getBoneTexture9DisplayBySize("commonPanels/common_item_bg_7",_,makeSize(1042,108));
  -- bg:setScaleX(1042/1066);
  -- bg:setScaleY(102/180);
  bg:setPositionXY(0,-3);
  self.armature:addChildAt(bg,0);

  local bg = CommonPanelSkeleton:getBoneTextureDisplay("commonPanels/common_meihua");
  -- bg:setScaleX(1042/1066);
  bg:setScaleY(0.9);
  bg:setPositionXY(792,5);
  self.armature:addChildAt(bg,1);

  self.img = Image.new();
  self.img:loadByArtID(analysis("Zhujiao_Huanhua",self.data.TransforId,"head"));
  self.img:setPositionXY(14,11);
  if nil ~= self.data.Vip and 0 ~= self.data.Vip then
    local vip = getVIPImgMainUI(self.data.Vip);
    if vip then
      vip:setScale(0.76);
      vip:setPositionXY(-12,55);
      self.img:addChild(vip);
    end
  end
  
  local touxiang_bg = self.armature:getChildByName("touxiang_bg");
  touxiang_bg:addChild(self.img);
  touxiang_bg:setScale(0.9);
  touxiang_bg:setPositionY(-3+touxiang_bg:getPositionY());

  local text=self.data.UserName;
  self.name_descb=createTextFieldWithTextData(armature:getBone("descb").textData,text);
  self:addChild(self.name_descb);

  text="Lv." .. self.data.Level;
  self.level_descb=createTextFieldWithTextData(armature:getBone("time_descb").textData,text);
  self:addChild(self.level_descb);

  local left_button=self.armature4dispose.display:getChildByName("button_1");
  local chat_channel_button_text_data=self.armature4dispose:findChildArmature("button_1"):getBone("common_small_red_button").textData;
  chat_channel_button_text_data = copyTable(chat_channel_button_text_data);
  chat_channel_button_text_data.y = 3 + chat_channel_button_text_data.y;
  local left_button_pos=convertBone2LB4Button(left_button);
  self.armature4dispose.display:removeChild(left_button);

  left_button=CommonButton.new();
  left_button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  left_button:initializeText(chat_channel_button_text_data,"忽 略",true);
  -- left_button:initializeBMText("忽略","anniutuzi");
  left_button:setPosition(left_button_pos);
  left_button:addEventListener(DisplayEvents.kTouchTap,self.onJujueTap,self);
  self.armature4dispose.display:addChild(left_button);

  local right_button=self.armature4dispose.display:getChildByName("button_2");
  local chat_channel_button_text_data=self.armature4dispose:findChildArmature("button_2"):getBone("common_small_blue_button").textData;
  chat_channel_button_text_data = copyTable(chat_channel_button_text_data);
  chat_channel_button_text_data.y = 3 + chat_channel_button_text_data.y;
  local right_button_pos=convertBone2LB4Button(right_button);
  self.armature4dispose.display:removeChild(right_button);

  right_button=CommonButton.new();
  right_button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  right_button:initializeText(chat_channel_button_text_data,"同 意",true);
  -- right_button:initializeBMText("同意","anniutuzi");
  right_button:setPosition(right_button_pos);
  right_button:addEventListener(DisplayEvents.kTouchTap,self.onTongyiTap,self);
  self.armature4dispose.display:addChild(right_button);
end

function HaoyouShenqingLayerItem:onJujueTap(event)
  self.container:deleteItem(self);
  sendMessage(21,9,{UserId=self.data.UserId});
end

function HaoyouShenqingLayerItem:onTongyiTap(event)
  -- self.container:deleteItem(self);
  if self.context.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString("好友数量已达上限哦 ~");
    return;
  end
  initializeSmallLoading();
  sendMessage(21,2,{UserId=self.data.UserId});
end
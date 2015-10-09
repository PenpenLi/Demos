require "main.view.buddy.ui.HaoyouShenqingLayerItem";

HaoyouShenqingLayer=class(Layer);

function HaoyouShenqingLayer:ctor()
  self.class=HaoyouShenqingLayer;
end

function HaoyouShenqingLayer:dispose()
	self.armature4dispose:dispose();
	HaoyouShenqingLayer.superclass.dispose(self);
end

function HaoyouShenqingLayer:initialize(context)
	self.context = context;
	self.buddyListProxy = self.context.buddyListProxy;
  self.items = {};

	self.skeleton = self.context.skeleton;
	self:initLayer();

	--骨骼
  local armature=self.skeleton:buildArmature("buddy_tab_4_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local title_1=createTextFieldWithTextData(armature:getBone("title_1").textData,"姓名");
  self.armature:addChild(title_1);

  local title_2=createTextFieldWithTextData(armature:getBone("title_2").textData,"等级");
  self.armature:addChild(title_2);

  local title_3=createTextFieldWithTextData(armature:getBone("title_3").textData,"操作");
  self.armature:addChild(title_3);

  local left_button=self.armature4dispose.display:getChildByName("btn_1");
  local left_button_pos=convertBone2LB4Button(left_button);
  self.armature4dispose.display:removeChild(left_button);

  left_button=CommonButton.new();
  left_button:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- left_button:initializeText(chat_channel_button_text_data,s[a]);
  left_button:initializeBMText("全部忽略","anniutuzi");
  left_button:setPosition(left_button_pos);
  left_button:addEventListener(DisplayEvents.kTouchTap,self.onJujueTap,self);
  self.armature4dispose.display:addChild(left_button);

  local right_button=self.armature4dispose.display:getChildByName("btn_2");
  local right_button_pos=convertBone2LB4Button(right_button);
  self.armature4dispose.display:removeChild(right_button);

  right_button=CommonButton.new();
  right_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- right_button:initializeText(chat_channel_button_text_data,s[a]);
  right_button:initializeBMText("全部同意","anniutuzi");
  right_button:setPosition(right_button_pos);
  right_button:addEventListener(DisplayEvents.kTouchTap,self.onTongyiTap,self);
  self.armature4dispose.display:addChild(right_button);

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(117,150);
  self.item_layer:setViewSize(makeSize(1042,455));
  self.item_layer:setItemSize(makeSize(1042,108));
  self.armature:addChildAt(self.item_layer,3);

  -- self:initializeShenqingData();
end

function HaoyouShenqingLayer:initializeShenqingData()
  initializeSmallLoading();
  sendMessage(21,8);
end

function HaoyouShenqingLayer:refreshShenqingData(data)
  self.item_layer:removeAllItems(true);
  self.items = {};
  for k,v in pairs(data) do
    local item=HaoyouShenqingLayerItem.new();
    item:initialize(self.context,self,v);
    self.item_layer:addItem(item);
    table.insert(self.items, item);
  end
end

function HaoyouShenqingLayer:onJujueTap(event)
  if 0 == table.getn(self.items) then
    return;
  end
  self.items = {};
  self.item_layer:removeAllItems(true);
  sendMessage(21,9,{UserId=0});
end

function HaoyouShenqingLayer:onTongyiTap(event)
  if self.context.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString("好友数量已达上限哦 ~");
    return;
  end
  if 0 == table.getn(self.items) then
    return;
  end
  -- self.items = {};
  -- self.item_layer:removeAllItems(true);
  sendMessage(21,2,{UserId=0});
end

function HaoyouShenqingLayer:deleteItem(item)
  for k,v in pairs(self.items) do
    if item == v then
      self.item_layer:removeItemAt(-1+k,true);
      table.remove(self.items,k);
      break;
    end
  end
end

function HaoyouShenqingLayer:refreshAddBuddys(userRelationArray)
  for k,v in pairs(userRelationArray) do
    for k_,v_ in pairs(self.items) do
      if v.UserId == v_.data.UserId then
        self:deleteItem(v_);
      end
    end
  end
end
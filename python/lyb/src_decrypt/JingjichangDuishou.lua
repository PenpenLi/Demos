JingjichangDuishou=class(TouchLayer);

function JingjichangDuishou:ctor()
  self.class=JingjichangDuishou;
end

function JingjichangDuishou:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	JingjichangDuishou.superclass.dispose(self);
end

function JingjichangDuishou:initialize(context)
  self:initLayer();
  self.context=context;
end

function JingjichangDuishou:refreshData(data)
  if self.item_layer then
    self:removeChild(self.item_layer);
    self.item_layer = nil;
  end
  self.data = data;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(628,108));
  self.item_layer:setViewSize(makeSize(482,440));
  self.item_layer:setItemSize(makeSize(470,105));
  self:addChild(self.item_layer);

  for k,v in pairs(self.data) do
    local item=JingjichangDuishouItem.new();
    item:initialize(self.context,v);
    self.item_layer:addItem(item);
  end
end


JingjichangDuishouItem=class(ListScrollViewLayerItem);

function JingjichangDuishouItem:ctor()
  self.class=JingjichangDuishouItem;
end

function JingjichangDuishouItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  JingjichangDuishouItem.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

function JingjichangDuishouItem:initialize(context, data)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
end

function JingjichangDuishouItem:onInitialize()
  --骨骼
  local armature=self.skeleton:buildArmature("tab_item_1");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local function cbfunc(event)
    print("---===",self.data.UserId,self.data.UserName);
    getUserButtonsSelector(self.data.UserId,self.data.UserName,event.globalPosition,self.context);
  end

  --name_descb
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createRichMultiColoredLabelWithTextData(text_data,"<content><font color = '#67190E' ref = " .. (self.data.UserId == self.context.userProxy:getUserID() and "'0'" or "'1'") .. ">" .. self.data.UserName .. " </font><font color = '#67190E'>Lv." .. self.data.Level .. "</font></content>");
  if not (self.data.UserId == self.context.userProxy:getUserID()) then
    self.name_descb:addEventListener(DisplayEvents.kTouchTap,cbfunc);
  end
  self.armature:addChild(self.name_descb);

  text_data=armature:getBone("jinfen_descb").textData;
  self.jinfen_descb=createTextFieldWithTextData(text_data,"积分：" .. self.data.Score);
  self.armature:addChild(self.jinfen_descb);

  local img_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_player_bg");
  img_bg:setPositionXY(20,13);
  self.armature:addChild(img_bg);

  local img = Image.new();
  img:loadByArtID(analysis("Zhujiao_Huanhua",self.data.TransforId,"head"));
  img:setScale(0.76);
  img:setPositionXY(26,18);
  self.armature:addChild(img);

  local button=self.armature:getChildByName("btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeBMText("战斗","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onZhandouButtonTap,self);
  self.armature:addChild(button);

  button:setVisible(0 == self.data.BooleanValue);

  self.armature:getChildByName("shengli_img"):setVisible(1 == self.data.BooleanValue);
end

function JingjichangDuishouItem:onZhandouButtonTap(event)
  self.context:popZhandou(self.data);
  -- sendServerTutorMsg({})
  -- closeTutorUI();
end
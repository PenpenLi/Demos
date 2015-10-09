BangpaiHuoyueduItemLayer=class(TouchLayer);

function BangpaiHuoyueduItemLayer:ctor()
  self.class=BangpaiHuoyueduItemLayer;
end

function BangpaiHuoyueduItemLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiHuoyueduItemLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function BangpaiHuoyueduItemLayer:initialize(context, data, container)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.container = container;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("huoyuedu_popup_item_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  --title_1
  local text_data=armature:getBone("huoyuedul_descb").textData;
  self.huoyuedul_descb=createTextFieldWithTextData(text_data,"",true);
  self.armature:addChild(self.huoyuedul_descb);

  text_data=armature:getBone("gold_descb").textData;
  self.gold_descb=createTextFieldWithTextData(text_data,"",true);
  self.armature:addChild(self.gold_descb);

  text_data=armature:getBone("silveri_descb").textData;
  self.silveri_descb=createTextFieldWithTextData(text_data,"",true);
  self.armature:addChild(self.silveri_descb);

  text_data=armature:getBone("yilingqu_descb").textData;
  self.yilingqu_descb=createTextFieldWithTextData(text_data,"",true);
  self.armature:addChild(self.yilingqu_descb);

  local lingqu_btn =self.armature4dispose.display:getChildByName("lingqu_btn");
  SingleButton:create(lingqu_btn);
  lingqu_btn:addEventListener(DisplayEvents.kTouchTap, self.onGeTBonus, self);
  self.lingqu_btn = lingqu_btn;
  self.lingqu_btn:setScale(0.8);
  self.lingqu_btn:setVisible(false);

  self:refresh();
end

function BangpaiHuoyueduItemLayer:onGeTBonus(event)
  initializeSmallLoading();
  sendMessage(27,19,{ID = self.data.id});
  -- self:refreshLingquByIDArray({{ID=self.data.id}});
  -- self.container:refreshHuoyueduHongdian();
end

function BangpaiHuoyueduItemLayer:refresh()
  self.huoyuedul_descb:setString(self.data.vitality);
  local bonus = StringUtils:stuff_string_split(self.data.gift);
  if bonus[1] then
    local img = Image.new();
    img:loadByArtID(analysis("Daoju_Daojubiao",bonus[1][1],"art"));
    img:setScale(0.4);
    img:setPositionXY(155,53);
    self.armature:addChild(img);
    self.gold_descb:setString(bonus[1][2]);
  end
  if bonus[2] then
    print("000000000000000->",bonus[2][1],analysis("Daoju_Daojubiao",bonus[2][1],"art"));
    local img = Image.new();
    img:loadByArtID(analysis("Daoju_Daojubiao",bonus[2][1],"art"));
    img:setScale(0.4);
    img:setPositionXY(155,20);
    self.armature:addChild(img);
    self.silveri_descb:setString(bonus[2][2]);
  end
end

function BangpaiHuoyueduItemLayer:refreshLingquByIDArray(idArray)
  for k,v in pairs(idArray) do
    if self.data.id == v.ID then
      self.lingqu_btn:setVisible(false);
      self.yilingqu_descb:setVisible(true);
      self.yilingqu_descb:setString("已领取");
      self.yilingqu_descb:setColor(ccc3(0,255,0));
      return;
    end
  end
  local huoyuedu = self.container.huoyuedu;
  if huoyuedu < self.data.vitality then
    self.lingqu_btn:setVisible(false);
    self.yilingqu_descb:setVisible(true);
    self.yilingqu_descb:setString("未达成");
    self.yilingqu_descb:setColor(ccc3(255,0,0));
  else
    self.lingqu_btn:setVisible(true);
    self.yilingqu_descb:setVisible(false);
  end
end
YongbingTabTwo=class(Layer);

function YongbingTabTwo:ctor()
  self.class=YongbingTabTwo;
end

function YongbingTabTwo:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	YongbingTabTwo.superclass.dispose(self);
end

--intialize UI
function YongbingTabTwo:initialize(context)
  self:initLayer();
  self.context = context;
  self.skeleton = self.context.skeleton;

  self.titleTF = BitmapTextField.new("琅琊佣兵","anniutuzi");
  self.titleTF:setPositionXY(560,615);
  self:addChild(self.titleTF);

  self:refreshYongbing();
end

function YongbingTabTwo:refreshOnTab()
  if self.sign_refresh then
    self:refreshYongbing();
  end
end

function YongbingTabTwo:refreshYongbing()
  self.data = self.context.familyProxy:getYongbingData();
  if self.item_layer then
    self:removeChild(self.item_layer);
    self.item_layer = nil;
  end
  if self.textField then
    self:removeChild(self.textField);
    self.textField = nil;
  end
  if 0 == table.getn(self.data) then
    self.textField = TextField.new(CCLabelTTF:create("还没有帮派佣兵哦 ~",FontConstConfig.OUR_FONT,30));
    self.textField.sprite:setColor(ccc3(218,200,161));
    self.textField:setPositionXY(640-self.textField:getContentSize().width/2, 360-self.textField:getContentSize().height/2);
    self:addChild(self.textField);
    return;
  end
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(153,120);
  self.item_layer:setViewSize(makeSize(930,465));
  self.item_layer:setItemSize(makeSize(930,236));
  -- self.item_layer:setDirection(0);
  self:addChild(self.item_layer);

  local layer;
  for k,v in pairs(self.data) do
    if 1 == k%4 then
      layer=Layer.new();
      layer:initLayer();
      self.item_layer:addItem(layer);
    end

    local item = YongbingTabTwoItem.new();
    item:initialize(self.context,v);
    item:setPositionXY(((-1+k)%4)*240,10);
    layer:addChild(item);
  end
end

function YongbingTabTwo:refreshChange()
  self.sign_refresh = true;
end


YongbingTabTwoItem=class(Layer);

function YongbingTabTwoItem:ctor()
  self.class=YongbingTabTwoItem;
end

function YongbingTabTwoItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  YongbingTabTwoItem.superclass.dispose(self);
  self.armature:dispose();
end

--intialize UI
function YongbingTabTwoItem:initialize(context, data)
  self:initLayer();
  self.context = context;
  self.data = data;
  self.skeleton = self.context.skeleton;

  local armature=self.skeleton:buildArmature("tab_ui_2_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  local heroRoundPortrait = HeroRoundPortrait.new();
  heroRoundPortrait:initialize(self.data);
  heroRoundPortrait:setScale(0.9);
  heroRoundPortrait:showName4Yongbing();
  heroRoundPortrait:setPositionXY(55,77);
  self.armature.display:addChild(heroRoundPortrait);

  local text_data=self.armature:getBone("descb").textData;
  self.descb=createTextFieldWithTextData(text_data,"战力：" .. self.data.Zhanli);
  self.armature.display:addChild(self.descb);

  if self.data.UserName then
    text_data=self.armature:getBone("name_descb").textData;
    self.name_descb=createTextFieldWithTextData(text_data,self.data.UserName .. "的佣兵");
    self.armature.display:addChild(self.name_descb);
  end
end
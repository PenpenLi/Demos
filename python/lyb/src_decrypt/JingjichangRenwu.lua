JingjichangRenwu=class(TouchLayer);

function JingjichangRenwu:ctor()
  self.class=JingjichangRenwu;
end

function JingjichangRenwu:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	JingjichangRenwu.superclass.dispose(self);
end

function JingjichangRenwu:initialize(context)
  self:initLayer();
  self.context=context;
  initializeSmallLoading();
  sendMessage(16,9);
end

function JingjichangRenwu:refreshData(data)
  uninitializeSmallLoading();
  self.data = data;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(628,78));
  self.item_layer:setViewSize(makeSize(482,463));
  self.item_layer:setItemSize(makeSize(470,65));
  self:addChild(self.item_layer);

  for i=1,9 do
    local item=JingjichangRenwuItem.new();
    item:initialize(self.context,i,self.data);
    self.item_layer:addItem(item);
  end
end


JingjichangRenwuItem=class(ListScrollViewLayerItem);

function JingjichangRenwuItem:ctor()
  self.class=JingjichangRenwuItem;
end

function JingjichangRenwuItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  JingjichangRenwuItem.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
end

function JingjichangRenwuItem:initialize(context, num, datas)
  self:initLayer();
  self.context=context;
  self.num = num;
  self.datas = datas;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
end

function JingjichangRenwuItem:onInitialize()  
  --骨骼
  local armature=self.skeleton:buildArmature("tab_item_4");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.data = analysis("Biwudahui_Saijirenwu",self.num);
  local condition = StringUtils:lua_string_split(self.data.condition,",");
  local s;
  if 1 == tonumber(condition[1]) then
    s = "积分 " .. condition[2];
  elseif 2 == tonumber(condition[1]) then
    s = "胜利 " .. condition[2] .. "场";
  elseif 3 == tonumber(condition[1]) then
    s = "参与 " .. condition[2] .. "场";
  end
  --name_descb
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,s);
  self.armature:addChild(self.name_descb);

  local bonus = self.data.award;
  bonus = StringUtils:stuff_string_split(bonus);
  if 1 == table.getn(bonus) then
    local bagItem=BagItem.new();
    bagItem:initialize({ItemId = tonumber(bonus[1][1]), Count = 1});
    bagItem:setScale(0.35);
    bagItem:setFrameVisible(false);
    bagItem:setPositionXY(340,23);
    self.armature:addChild(bagItem);

    s = bonus[1][2];
    textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(380,25);
    self.armature:addChild(textField);
  elseif 2 == table.getn(bonus) then
    local bagItem=BagItem.new();
    bagItem:initialize({ItemId = tonumber(bonus[1][1]), Count = 1});
    bagItem:setScale(0.35);
    bagItem:setFrameVisible(false);
    bagItem:setPositionXY(240,23);
    self.armature:addChild(bagItem);

    s = bonus[1][2];
    textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(280,25);
    self.armature:addChild(textField);

    bagItem=BagItem.new();
    bagItem:initialize({ItemId = tonumber(bonus[2][1]), Count = 1});
    bagItem:setScale(0.35);
    bagItem:setFrameVisible(false);
    bagItem:setPositionXY(340,23);
    self.armature:addChild(bagItem);

    s = bonus[2][2];
    textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(380,25);
    self.armature:addChild(textField);
  end
  local bool = false;
  for k,v in pairs(self.datas) do
    if self.num == v.ID and 1 == v.State then
      bool = true;
      break;
    end
  end
  local yiwancheng_img = self.armature:getChildByName("yiwancheng_img");
  self.armature:removeChild(yiwancheng_img,false);
  self.armature:addChild(yiwancheng_img);
  yiwancheng_img:setVisible(bool);
end
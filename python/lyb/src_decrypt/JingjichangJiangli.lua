JingjichangJiangli=class(TouchLayer);

function JingjichangJiangli:ctor()
  self.class=JingjichangJiangli;
end

function JingjichangJiangli:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	JingjichangJiangli.superclass.dispose(self);
end

function JingjichangJiangli:initialize(context)
  self:initLayer();
  self.context=context;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(628,78));
  self.item_layer:setViewSize(makeSize(482,470));
  self.item_layer:setItemSize(makeSize(470,740));
  self:addChild(self.item_layer);

  local item=JingjichangJiangliItem.new();
  item:initialize(self.context);
  self.item_layer:addItem(item);
end


JingjichangJiangliItem=class(TouchLayer);

function JingjichangJiangliItem:ctor()
  self.class=JingjichangJiangliItem;
end

function JingjichangJiangliItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  JingjichangJiangliItem.superclass.dispose(self);

  self.armature4dispose:dispose();
end

function JingjichangJiangliItem:initialize(context)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.rank = rank;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("tab_item_3");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  for i=1,18 do
    local y = 8 < i and (-38*(-8+i)+406) or (-38*(-1+i)+696);

    local img = Image.new();
    img:loadByArtID(analysis("Biwudahui_Jiangli",i,"icon"));
    img:setScale(0.75);
    img:setPositionXY(23,-2+y);
    self.armature:addChild(img);

    local mingci_data = analysis("Biwudahui_Jiangli",i);
    local min = mingci_data.min;
    local max = mingci_data.max;
    local s;
    if min == max then
      s = "第" .. min .. "名";
    else
      s = "第" .. min .. "~" .. max .. "名";
    end
    local textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(76,y);
    self.armature:addChild(textField);

    local bonus = analysis("Biwudahui_Jiangli",i,"award");
    bonus = StringUtils:stuff_string_split(bonus);
    if 1 == table.getn(bonus) then
      local bagItem=BagItem.new();
      bagItem:initialize({ItemId = tonumber(bonus[1][1]), Count = 1});
      bagItem:setScale(0.35);
      bagItem:setFrameVisible(false);
      bagItem:setPositionXY(331,-4+y);
      self.armature:addChild(bagItem);

      s = bonus[1][2];
      textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
      textField.sprite:setColor(ccc3(103,25,14));
      textField:setPositionXY(375,y);
      self.armature:addChild(textField);
    elseif 2 == table.getn(bonus) then
      local bagItem=BagItem.new();
      bagItem:initialize({ItemId = tonumber(bonus[1][1]), Count = 1});
      bagItem:setScale(0.35);
      bagItem:setFrameVisible(false);
      bagItem:setPositionXY(237,-3+y);
      self.armature:addChild(bagItem);

      s = bonus[1][2];
      textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
      textField.sprite:setColor(ccc3(103,25,14));
      textField:setPositionXY(277,y);
      self.armature:addChild(textField);

      bagItem=BagItem.new();
      bagItem:initialize({ItemId = tonumber(bonus[2][1]), Count = 1});
      bagItem:setScale(0.35);
      bagItem:setFrameVisible(false);
      bagItem:setPositionXY(331,-4+y);
      self.armature:addChild(bagItem);

      s = bonus[2][2];
      textField = TextField.new(CCLabelTTF:create(s,FontConstConfig.OUR_FONT,20));
      textField.sprite:setColor(ccc3(103,25,14));
      textField:setPositionXY(375,y);
      self.armature:addChild(textField);
    end
  end
end
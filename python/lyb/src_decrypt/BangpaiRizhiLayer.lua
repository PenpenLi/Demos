BangpaiRizhiLayer=class(TouchLayer);

function BangpaiRizhiLayer:ctor()
  self.class=BangpaiRizhiLayer;
end

function BangpaiRizhiLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiRizhiLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
  self.background.parent:removeChild(self.background);
end

--
function BangpaiRizhiLayer:initialize(context, container)
  self:initLayer();
  self.context=context;
  self.container = container;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("rizhi_popup_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self:setPositionXY(380,17);
  self.background = LayerColorBackGround:getOpacityBackGround();
  self.context.parent:addChild(self.background);

  self.headTitleText=BitmapTextField.new("帮派活动日志", "anniutuzi");
  self.headTitleText:setPositionXY(255-self.headTitleText:getContentSize().width/2,572);
  self.armature:addChild(self.headTitleText);

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onClose, self);
  if self.container.bangpaiMemberLayer then
    self.container.bangpaiMemberLayer.item_layer:setMoveEnabled(false);
  end
  if self.container.bangpaiZhaorenLayer and self.container.bangpaiZhaorenLayer.item_layer then
    self.container.bangpaiZhaorenLayer.item_layer:setMoveEnabled(false);
  end

  initializeSmallLoading();
  sendMessage(27,14);
end

function BangpaiRizhiLayer:onClose(event)
  self.parent:removeChild(self);
  self.container.bangpaiRizhiLayer=nil;
  if self.container.bangpaiMemberLayer then
    self.container.bangpaiMemberLayer.item_layer:setMoveEnabled(true);
  end
  if self.container.bangpaiZhaorenLayer and self.container.bangpaiZhaorenLayer.item_layer then
    self.container.bangpaiZhaorenLayer.item_layer:setMoveEnabled(true);
  end
end

function BangpaiRizhiLayer:refreshFamilyLogArray(familyLogArray)
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(31,38));
  self.item_layer:setViewSize(makeSize(438,510));
  self.item_layer:setItemSize(makeSize(438,100));
  self.armature:addChild(self.item_layer);

  self.items={};
  local function sf(a, b)
    return a.Time > b.Time;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  end
  table.sort(familyLogArray,sf);
  for k,v in pairs(familyLogArray) do
    local item=BangpaiRizhiItemLayer.new();
    item:initialize(self.context,v);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end
end
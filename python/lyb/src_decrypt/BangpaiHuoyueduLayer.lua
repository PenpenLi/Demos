BangpaiHuoyueduLayer=class(TouchLayer);

function BangpaiHuoyueduLayer:ctor()
  self.class=BangpaiHuoyueduLayer;
end

function BangpaiHuoyueduLayer:dispose()
  self:refreshHuoyueduHongdian();
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiHuoyueduLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
  self.background.parent:removeChild(self.background);
end

function BangpaiHuoyueduLayer:refreshHuoyueduHongdian()
  for k,v in pairs(self.items) do
    print("BangpaiHuoyueduLayer:refreshHuoyueduHongdian================",v.data.id,v.lingqu_btn:isVisible());
    if v.lingqu_btn:isVisible() then
      self.heroHouseProxy.Hongidan_Huoyuedu = 1;
      require "main.controller.command.family.BangpaiRedDotRefreshCommand";
      BangpaiRedDotRefreshCommand.new():execute();
      return;
    end
  end
  self.heroHouseProxy.Hongidan_Huoyuedu = nil;
  require "main.controller.command.family.BangpaiRedDotRefreshCommand";
  BangpaiRedDotRefreshCommand.new():execute();
end

--
function BangpaiHuoyueduLayer:initialize(context, container)
  self:initLayer();
  self.context=context;
  self.container = container;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("huoyuedu_popup_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self:setPositionXY(380,17);
  self.background = LayerColorBackGround:getOpacityBackGround();
  self.context.parent:addChild(self.background);

  --title_1
  local text_data=armature:getBone("title_1").textData;
  self.title_1=createTextFieldWithTextData(text_data,"活跃度");
  self.armature:addChild(self.title_1);

  text_data=armature:getBone("title_2").textData;
  self.title_2=createTextFieldWithTextData(text_data,"状态");
  self.armature:addChild(self.title_2);

  text_data=armature:getBone("title_3").textData;
  self.title_3=createTextFieldWithTextData(text_data,"奖励");
  self.armature:addChild(self.title_3);

  text_data=armature:getBone("huoyuedu_descb").textData;
  self.huoyuedu_descb=createTextFieldWithTextData(text_data,"今日累积帮派活跃度:");
  self.armature:addChild(self.huoyuedu_descb);

  self.headTitleText=BitmapTextField.new("今日累积活跃度奖励", "anniutuzi");
  self.headTitleText:setPositionXY(255-self.headTitleText:getContentSize().width/2,572);
  self.armature:addChild(self.headTitleText);

  self.zhanLi = CartoonNum.new();
  self.zhanLi:initLayer();
  self.zhanLi:setData(0,"common_number",40);--server
  self.zhanLi:setScale(0.7);
  self.zhanLi:setPositionXY(270,525);
  self.armature:addChild(self.zhanLi);

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onClose, self);

  self:refresh();
  if self.container.bangpaiMemberLayer then
    self.container.bangpaiMemberLayer.item_layer:setMoveEnabled(false);
  end
  if self.container.bangpaiZhaorenLayer and self.container.bangpaiZhaorenLayer.item_layer then
    self.container.bangpaiZhaorenLayer.item_layer:setMoveEnabled(false);
  end

  initializeSmallLoading();
  sendMessage(27,18);
end

function BangpaiHuoyueduLayer:onClose(event)
  self.parent:removeChild(self);
  self.container.bangpaiHuoyueduLayer=nil;
  if self.container.bangpaiMemberLayer then
    self.container.bangpaiMemberLayer.item_layer:setMoveEnabled(true);
  end
  if self.container.bangpaiZhaorenLayer and self.container.bangpaiZhaorenLayer.item_layer then
    self.container.bangpaiZhaorenLayer.item_layer:setMoveEnabled(true);
  end
end

function BangpaiHuoyueduLayer:refresh()
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(33,38));
  self.item_layer:setViewSize(makeSize(438,420));
  self.item_layer:setItemSize(makeSize(438,100));
  self.armature:addChild(self.item_layer);

  local data = analysisTotalTable("Bangpai_Huoyuejiangli");
  local tbs = {};
  for k,v in pairs(data) do
    table.insert(tbs, v);
  end
  data = tbs;

  self.items={};
  local function sf(a, b)
    return a.id < b.id;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  end
  table.sort(data,sf);
  for k,v in pairs(data) do
    local item=BangpaiHuoyueduItemLayer.new();
    item:initialize(self.context,v,self);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end
end

function BangpaiHuoyueduLayer:refreshHuoyuedujiangli(huoyuedu, idArray)
  self.huoyuedu = huoyuedu;
  self.idArray = idArray;
  for k,v in pairs(self.items) do
    v:refreshLingquByIDArray(idArray);
  end
  self.zhanLi:setData(self.huoyuedu,"common_number",40);
end

function BangpaiHuoyueduLayer:refreshHuoyuedulingjiang(id)
  table.insert(self.idArray,{ID = id});
  self:refreshHuoyuedujiangli(self.huoyuedu,self.idArray);
  self:refreshHuoyueduHongdian();
end
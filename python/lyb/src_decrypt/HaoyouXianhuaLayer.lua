require "main.view.buddy.ui.HaoyouXianhuaLayerItem";

HaoyouXianhuaLayer=class(Layer);

function HaoyouXianhuaLayer:ctor()
  self.class=HaoyouXianhuaLayer;
end

function HaoyouXianhuaLayer:dispose()
	self.armature4dispose:dispose();
	HaoyouXianhuaLayer.superclass.dispose(self);
end

function HaoyouXianhuaLayer:initialize(context)
	self.context = context;
	self.buddyListProxy = self.context.buddyListProxy;

	self.skeleton = self.context.skeleton;
	self:initLayer();

	--骨骼
  local armature=self.skeleton:buildArmature("buddy_tab_2_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local my_flower=createTextFieldWithTextData(armature:getBone("my_flower").textData,"我的鲜花");
  self.armature:addChild(my_flower);

  self.my_flower_descb=createTextFieldWithTextData(armature:getBone("my_flower_descb").textData,self.context.buddyListProxy:getFlowerCount());
  self.armature:addChild(self.my_flower_descb);

  local flower_9_count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_1);
  local flower_99_count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_2);
  local flower_9_count_max=self.context.countControlProxy:getJibencishu(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_1);
  local flower_99_count_max=self.context.countControlProxy:getJibencishu(CountControlConfig.FLOWER_SEND,CountControlConfig.Parameter_2);
  local text="<content><font color='#FF9900'>今日可送：</font><font color='#FFFFFF'>" .. flower_9_count .. "/" .. flower_9_count_max .."</font><font color='#FF9900'>次  今日可收：</font><font color='#FFFFFF'>" .. flower_99_count .. "/" .. flower_99_count_max .."</font><font color='#FF9900'>次</font></content>"
  self.bonus_descb=createRichMultiColoredLabelWithTextData(armature:getBone("bonus_descb").textData,text);
  self.armature:addChild(self.bonus_descb);

  local exp=createTextFieldWithTextData(armature:getBone("exp").textData,"赠人及被赠都可收获经验~赠人玫瑰手有余香~");
  self.armature:addChild(exp);

  local one_flower=createRichMultiColoredLabelWithTextData(armature:getBone("one_flower").textData,"<content><font color='#FF9900'>拒绝接受</font><font color='#FFFFFF'>1</font><font color='#FF9900'>鲜花</font></content>");
  self.armature:addChild(one_flower);

  local three_flower=createRichMultiColoredLabelWithTextData(armature:getBone("three_flower").textData,"<content><font color='#FF9900'>拒绝接受</font><font color='#FFFFFF'>3</font><font color='#FF9900'>鲜花</font></content>");
  self.armature:addChild(three_flower);

  for i=1,2 do
    local button_bg = self.armature:getChildByName("button_bg_" .. i);
    button_bg:addEventListener(DisplayEvents.kTouchBegin,self.onSelectButtonTap,self,i);

    local duihao_img = self.armature:getChildByName("duihao_img_" .. i);
    duihao_img:addEventListener(DisplayEvents.kTouchBegin,self.onSelectButtonDuihaoTap,self,i);
  end

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(12,65);
  self.item_layer:setViewSize(makeSize(970,430));
  self.item_layer:setItemSize(makeSize(975,105));
  self.armature:addChildAt(self.item_layer,3);
  --self:refreshItemLayer();
  self:getHistoryData();
end

function HaoyouXianhuaLayer:onSelectButtonTap(event, num)
  self.armature:getChildByName("duihao_img_1" .. num):setVisible(true);
  local tb = {};
  if true == self.armature:getChildByName("duihao_img_1"):isVisible() then
    table.insert(tb,{ID = 1});
  end
  if true == self.armature:getChildByName("duihao_img_2"):isVisible() then
    table.insert(tb,{ID = 2});
  end
  sendMessage(2,15,{IDArray=tb});
end

function HaoyouXianhuaLayer:onSelectButtonDuihaoTap(event, num)
  self.armature:getChildByName("duihao_img_" .. num):setVisible(false);
  local tb = {};
  if true == self.armature:getChildByName("duihao_img_1"):isVisible() then
    table.insert(tb,{ID = 1});
  end
  if true == self.armature:getChildByName("duihao_img_2"):isVisible() then
    table.insert(tb,{ID = 2});
  end
  sendMessage(2,15,{IDArray=tb});
end

function HaoyouXianhuaLayer:getHistoryData()
  initializeSmallLoading();
  sendMessage(21,6);
end

function HaoyouXianhuaLayer:refreshFlowerHistoryData(flowerHistoryArray)
  uninitializeSmallLoading();
  for k,v in pairs(flowerHistoryArray) do
    local item=HaoyouXianhuaLayerItem.new();
    item:initialize(self.context, data);
    self.item_layer:addItem(item);
  end
end

function HaoyouXianhuaLayer:refreshItemLayer()
  local item=HaoyouXianhuaLayerItem.new();
    item:initialize(self.context);
    self.item_layer:addItem(item);

    local item=HaoyouXianhuaLayerItem.new();
    item:initialize(self.context);
    self.item_layer:addItem(item);
end

-- /**
--   * 拒绝1朵鲜花
--   */
--  public static final int SYSTEM_SET_ID_2 = 2;
--  /**
--   * 拒绝3朵鲜花
--   */
--  public static final int SYSTEM_SET_ID_3 = 3;

-- function HaoyouXianhuaLayer:onSelectButtonTap(event, num)
--   event.target:select(not event.target:getIsSelected());
--   sendMessage(3,22,{IDArray={{ID=num}}});
-- end
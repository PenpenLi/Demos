require "main.view.buddy.ui.buddyPopup.BuddyFlowerItem";

BuddyFlowerLayer=class(Layer);

function BuddyFlowerLayer:ctor()
  self.class=BuddyFlowerLayer;
end

function BuddyFlowerLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyFlowerLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyFlowerLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.const_chat_content_item_num=10;
  self.historyData=nil;
  self.fower_9_id=2;
  self.fower_99_id=3;

  --骨骼
  local armature=self.skeleton:buildArmature("buddy_flower_ui");
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

  local button=CommonButton.new();
  button:initialize("commonImages/common_checkNormal","commonImages/common_checkSelect",CommonButtonTouchable.CUSTOM);
  button:setPositionXY(510,13);
  button:addEventListener(DisplayEvents.kTouchBegin,self.onSelectButtonTap,self,self.fower_9_id);
  self:addChild(button);
  button:select(self.context.operationProxy:getHasID(self.fower_9_id));

  button=CommonButton.new();
  button:initialize("commonImages/common_checkNormal","commonImages/common_checkSelect",CommonButtonTouchable.CUSTOM);
  button:setPositionXY(757,13);
  button:addEventListener(DisplayEvents.kTouchBegin,self.onSelectButtonTap,self,self.fower_99_id);
  self:addChild(button);
  button:select(self.context.operationProxy:getHasID(self.fower_99_id));


  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(12,65);
  self.item_layer:setViewSize(makeSize(970,430));
  self.item_layer:setItemSize(makeSize(975,105));
  self.armature:addChild(self.item_layer);
  --self:refreshItemLayer();
  self:getHistoryData();
end

function BuddyFlowerLayer:getHistoryData()
	initializeSmallLoading();
  	sendMessage(21,6);
end

function BuddyFlowerLayer:refreshFlowerHistoryData(flowerHistoryArray)
  uninitializeSmallLoading();
  for k,v in pairs(flowerHistoryArray) do
  	local item=BuddyFlowerItem.new();
    item:initialize(self.context, data);
    self.item_layer:addItem(item);
  end
end

function BuddyFlowerLayer:refreshItemLayer()
	local item=BuddyFlowerItem.new();
    item:initialize(self.context);
    self.item_layer:addItem(item);

    local item=BuddyFlowerItem.new();
    item:initialize(self.context);
    self.item_layer:addItem(item);
end

-- /**
-- 	 * 拒绝1朵鲜花
-- 	 */
-- 	public static final int SYSTEM_SET_ID_2 = 2;
-- 	/**
-- 	 * 拒绝3朵鲜花
-- 	 */
-- 	public static final int SYSTEM_SET_ID_3 = 3;

function BuddyFlowerLayer:onSelectButtonTap(event, num)
	event.target:select(not event.target:getIsSelected());
	sendMessage(3,22,{IDArray={{ID=num}}});
end
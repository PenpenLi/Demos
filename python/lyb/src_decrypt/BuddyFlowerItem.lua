BuddyFlowerItem=class(Layer);

local buddyFlowerItem = nil;

function BuddyFlowerItem:ctor()
  self.class=BuddyFlowerItem;
end

function BuddyFlowerItem:dispose()
  buddyFlowerItem = nil;
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyFlowerItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyFlowerItem:initialize(context, data)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.const_chat_content_item_num=10;
  self.data=data;
  self.userID=self.context.userProxy:getUserID();

  --骨骼
  local armature=self.skeleton:buildArmature("buddy_flower_scroll_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text;
  if self.userID==self.data.UserId then
    text="<content><font color='#FFFFFF'>亲，您送给 </font><font color='#00CCCC'>" .. self.data.TargetUserName .. "</font><font color='#FFFFFF'>".. self:getFlowerCountByType(self.data.Type) .. "朵鲜花，获得 </font><font color='#00FF00'>" .. self.data.Experience .. "</font><font color='#FFFFFF'> 经验</font></content>";
  else
    text="<content><font color='#00CCCC'>" .. self.data.TargetUserName .. "</font><font color='#FFFFFF'>送给我 </font><font color='#FFFFFF'>".. self:getFlowerCountByType(self.data.Type) .. "朵鲜花，获得 </font><font color='#00FF00'>" .. self.data.Experience .. "</font><font color='#FFFFFF'> 经验</font></content>";
  end
  local descb=createRichMultiColoredLabelWithTextData(armature:getBone("descb").textData,text);
  self.armature:addChild(descb);

  local time=os.time()-self.data.Time;
  if 3600>time then
    time=math.floor(time/60) .. "分钟前";
  elseif 86400>time then
    time=math.floor(time/3600) .. "小时前";
  else
    time=math.floor(time/86400) .. "天前";
  end
  local time_descb=createRichMultiColoredLabelWithTextData(armature:getBone("time_descb").textData,time);
  self.armature:addChild(time_descb);

  self.button=Button.new(armature:findChildArmature("button"),false);
  self.button.bone:initTextFieldWithString("common_small_blue_button","送花");
  self.button:addEventListener(Events.kStart,self.onButtonTap,self);
  self.armature:getChildByName("buddy_flower_scroll_item_over").touchEnabled=false;
  self:select(false);

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function BuddyFlowerItem:onButtonTap(event)
  self.context:onSendFlowerButtonTap(self.data);
end

function BuddyFlowerItem:onSelfTap(event)
  if buddyFlowerItem == self then
    return;
  end
  if buddyFlowerItem then
    buddyFlowerItem:select(false);
  end
  buddyFlowerItem = self;
  buddyFlowerItem:select(true);
end

function BuddyFlowerItem:select(bool)
  self.armature:getChildByName("buddy_flower_scroll_item_over"):setVisible(bool);
end

function BuddyFlowerItem:getFlowerCountByType(type)
  if 1 == flower_type then
    return 1;
  elseif 2 == flower_type then
    return 9;
  elseif 3 == flower_type then
    return 99;
  end
end
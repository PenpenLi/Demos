--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

ActivityItem=class(TouchLayer);

function ActivityItem:ctor()
  self.class=ActivityItem;
end

function ActivityItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ActivityItem.superclass.dispose(self);

  BitmapCacher:deleteTextureLua("resource/image/arts/P2065.lua");
  self.armature4dispose:dispose();
end

function ActivityItem:initialize(skeleton, name, num, context, onTap, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.name=name;
  self.num=num;
  self.context=context;
  self.onTap=onTap;
  self.parent_container=parent_container;
  self.effect=nil;
  
  --骨骼
  local armature=CommonSkeleton:buildArmature("common_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text=self.name;
  self.itemTextField=createTextFieldWithTextData(armature:getBone("common_copy_item_bg").textData,text);
  self.itemTextField.touchEnabled=false;
  self.itemTextField.touchChildren=false;
  self:addChild(self.itemTextField);

  if self.context.activityProxy:hasEffectID(self.num) then
    local size=self.armature:getChildByName("common_copy_item_over"):getContentSize();
    self.effect=cartoonPlayer(EffectConstConfig.ACTIVITY_ITEM,size.width/2,size.height/2,0);
    self.effect.touchEnabled=false;
    self.effect.touchChildren=false;
    self.armature:addChild(self.effect);
  end

  self.item_over=self.armature:getChildByName("common_copy_item_over");
  self.item_over.touchEnabled=false;
  self.item_over.touchChildren=false;
  self:select(false);
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function ActivityItem:onSelfTap(event)
  self.onTap(self.context,self:getNum());
end

function ActivityItem:select(boolean)
  if boolean then
    if self.effect then
      self.context.activityProxy:deleteEffectID(self.num);
      self.armature:removeChild(self.effect);
      self.effect=nil;
    end
    self.armature:addChildAt(self.item_over,1);
  else
    self.armature:removeChild(self.item_over,false);
  end
end

function ActivityItem:getNum()
  return self.num;
end
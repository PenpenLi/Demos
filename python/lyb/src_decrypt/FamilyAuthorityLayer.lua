--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyAuthorityLayer=class(TouchLayer);

function FamilyAuthorityLayer:ctor()
  self.class=FamilyAuthorityLayer;
end

function FamilyAuthorityLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyAuthorityLayer.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyAuthorityLayer:initialize(skeleton, familyProxy, userProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.userProxy=userProxy;
  self.parent_container=parent_container;
  -- self.const_item_num=8.5;
  

   local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  
  -- AddUIBackGround(self);


  local bg=LayerColorBackGround:getTransBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(bg);
  --骨骼
  local armature=skeleton:buildArmature("authority_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  
  local armature_dSize =  self.armature:getGroupBounds().size
  self.armature:setPositionXY((size.width - armature_dSize.width)/2, (size.height - armature_dSize.height)/2)

  local closeButton =self.armature4dispose.display:getChildByName("close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeTip, self);

  --local item=self.skeleton:getBoneTextureDisplay("authority_item_bg");
  --self.item_size=item:getContentSize();
  -- self.item_size=makeSize(400,50);
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(15,25);
  self.item_layer:setViewSize(makeSize(445,560));
  self.item_layer:setItemSize(makeSize(445,86));
  self.armature:addChild(self.item_layer);

  local authority=analysis("Bangpai_Zhiweidengjibiao",self.userProxy:getFamilyPositionID(),"quanxian");
  authority=StringUtils:lua_string_split(authority,",");
  for k,v in pairs(authority) do
    --屏蔽家族战
    --if tonumber(v)==12 then return end;
    local item=FamilyAuthorityItem.new();
    item:initialize(self.skeleton,self.familyProxy,self,self.parent_container,tonumber(v));
    self.item_layer:addItem(item);
  end
  --self.armature:setPositionXY(300,20);
end

function FamilyAuthorityLayer:closeTip(event)
  if self.parent then
    if self.parent.item_layer then
      self.parent.item_layer:setMoveEnabled(true);
    end
    self.parent:removeChild(self);
  end
end
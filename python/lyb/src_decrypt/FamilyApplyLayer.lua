--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyApplyLayer=class(TouchLayer);

function FamilyApplyLayer:ctor()
  self.class=FamilyApplyLayer;
end

function FamilyApplyLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyApplyLayer.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyApplyLayer:initialize(skeleton, familyProxy, userProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.userProxy=userProxy;
  self.parent_container=parent_container;
  self.const_item_num=6;
  
  --骨骼
  local armature=skeleton:buildArmature("apply_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  
  --page_descb
  local text="";
  local text_data=armature:getBone("bagpai_name_descb").textData;
  self.bagpai_name_descb=createRichMultiColoredLabelWithTextData(text_data,text,nil,1,ccc3(0,0,0));
  self.bagpai_name_descb.touchEnabled=false;
  self.armature:addChild(self.bagpai_name_descb);

  -- local item=self.skeleton:getBoneTextureDisplay("apply_item_bg");
  -- self.item_size=item:getContentSize();
  -- item:dispose();
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;

  -- self.item_size=makeSize(909,77);
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;


  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createStrokeTextFieldWithTextData(text_data,"玩家",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.name_descb);


  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createStrokeTextFieldWithTextData(text_data,"等级",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("operate_descb_1").textData;
  self.operate_descb_1=createStrokeTextFieldWithTextData(text_data,"拒绝",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.operate_descb_1);

  text_data=armature:getBone("operate_descb_2").textData;
  self.operate_descb_2=createStrokeTextFieldWithTextData(text_data,"同意",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.operate_descb_2);



  --rejectButton
  local rejectButton=self.armature:getChildByName("button_1");
  local rejectButton_pos=convertBone2LB4Button(rejectButton);
  textData=armature:findChildArmature("button_1"):getBone("common_blue_button").textData;
  self.armature:removeChild(rejectButton);

  rejectButton=CommonButton.new();
  rejectButton:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  --rejectButton:initializeText(textData,"全部拒绝");
  rejectButton:initializeBMText("全部拒绝","anniutuzi");
  rejectButton:setPosition(rejectButton_pos);
  rejectButton:addEventListener(DisplayEvents.kTouchTap,self.onRejectButtonTap,self);
  self.armature:addChild(rejectButton);
  self.rejectButton=rejectButton;

  local acceptButton=self.armature:getChildByName("button_2");
  local acceptButton_pos=convertBone2LB4Button(acceptButton);
  textData=armature:findChildArmature("button_2"):getBone("common_blue_button").textData;
  self.armature:removeChild(acceptButton);

  acceptButton=CommonButton.new();
  acceptButton:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  --acceptButton:initializeText(textData,"全部同意");
  acceptButton:initializeBMText("全部同意","anniutuzi");
  acceptButton:setPosition(acceptButton_pos);
  acceptButton:addEventListener(DisplayEvents.kTouchTap,self.onAcceptButtonTap,self);
  self.armature:addChild(acceptButton);
  self.acceptButton=acceptButton;

  -- local button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  -- button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  -- self.leftButton=button;

  -- button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  -- button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  -- self.rightButton=button;

  local data = self.familyProxy:getData();
  local str = "<content><font color='#00FFFF'>" .. data.FamilyName .. "</font>";
  str = str .. "<font color='#FFFFFF'>   Lv" .. data.FamilyLevel .. "</font></content>"
  self.bagpai_name_descb:setString(str);

  initializeSmallLoading();
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_FAMILY_APPLY_ARRAY,{FamilyId=self.userProxy:getFamilyID()},self));
end

function FamilyApplyLayer:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
end

function FamilyApplyLayer:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
end

function FamilyApplyLayer:onRejectButtonTap(event)
  self.item_layer:removeAllItems(true);
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_VERIFY,{UserId=0,BooleanValue=0},self));
end

function FamilyApplyLayer:onAcceptButtonTap(event)
  self.item_layer:removeAllItems(true);
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_VERIFY,{UserId=0,BooleanValue=1},self));
end

function FamilyApplyLayer:refreshButton()
  self.leftButton:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  self.rightButton:getDisplay():setVisible(self.max_page>self.item_layer:getCurrentPage());
  local page=0==self.max_page and 0 or self.item_layer:getCurrentPage();
  self.page_descb:setString("页数:" .. page .. "/" .. self.max_page);
end

function FamilyApplyLayer:refreshFamilyApplyArray(applierArray)
  uninitializeSmallLoading();
  self.applierArray=applierArray;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(365,170);
  self.item_layer:setViewSize(makeSize(590,335));
  self.item_layer:setItemSize(makeSize(590,75));
  self.armature:addChild(self.item_layer);

  local function sf(a, b)
    return a.Level<b.Level;
  end
  table.sort(self.applierArray,sf);
  self.items={};
  for k,v in pairs(self.applierArray) do
    local item=FamilyApplyItem.new();
    item:initialize(self.skeleton,self.familyProxy,self.parent_container,v,self);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end



  -- self.max_page=math.ceil(table.getn(applierArray)/self.const_item_num);
  -- self.rejectButton:setVisible(0~=self.max_page);
  -- if self.item_layer then
  --   self.armature:removeChild(self.item_layer);
  --   self.item_layer=nil;
  -- end
  -- self.item_layer=GalleryViewLayer.new();
  -- self.item_layer:initLayer();
  -- self.item_layer:setPosition(self.pos);
  -- self.item_layer:setViewSize(makeSize(self.item_size.width,
  --                                      self.const_item_num*self.item_size.height));
  -- self.item_layer:setContainerSize(makeSize(self.max_page*self.item_size.width,
  --                                           self.const_item_num*self.item_size.height));
  -- self.item_layer:setMaxPage(self.max_page);
  -- local function refreshButton()
  --   self:refreshButton();
  -- end
  -- self.item_layer:addFlipPageCompleteHandler(refreshButton);
  -- self.armature:addChild(self.item_layer);
  -- local index=self.armature:getChildIndex(self.item_layer);
  -- self.armature:setChildIndex(self.leftButton:getDisplay(),1+index);
  -- self.armature:setChildIndex(self.rightButton:getDisplay(),1+index);

  -- local function sf(a, b)
  --   return a.Level<b.Level;
  -- end
  -- table.sort(applierArray,sf);
  -- local layer;
  -- self.items={};
  -- for k,v in pairs(applierArray) do
  --   if 0==(-1+k)%self.const_item_num then
  --     layer=Layer.new();
  --     layer:initLayer();
  --     layer:setPositionX(math.floor((-1+k)/self.const_item_num)*self.item_size.width);
  --     self.item_layer:addContent(layer);
  --   end
  --   local item=FamilyApplyItem.new();
  --   item:initialize(self.skeleton,self.familyProxy,self.parent_container,v);
  --   item:setPositionY(self.item_size.height*(-1+self.const_item_num-(-1+k)%self.const_item_num));
  --   layer:addChild(item);
  --   table.insert(self.items,item);
  -- end
  -- self:refreshButton();
end

function FamilyApplyLayer:refreshFamilyVerify(userId, booleanValue)
  if 0==userId then
    self:refreshFamilyApplyArray({});
  end
end

function FamilyApplyLayer:getUserNameByApplyLayer(userId)
  for k,v in pairs(self.items) do
    if userId==v.data.UserId then
      return v.data.UserName;
    end
  end
end

function FamilyApplyLayer:removeItem(item)
  for k,v in pairs(self.items) do
    if item == v then
      table.remove(self.items,k);
      self.item_layer:removeItemAt(-1+k,true);
      break;
    end
  end
end
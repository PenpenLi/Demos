--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyMemberLayer=class(TouchLayer);

function FamilyMemberLayer:ctor()
  self.class=FamilyMemberLayer;
end

function FamilyMemberLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyMemberLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function FamilyMemberLayer:initialize(skeleton, familyProxy, userProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.userProxy=userProxy;
  self.container=parent_container;
  self.parent_container=parent_container.isLookInto and parent_container.parent or parent_container;
  self.const_item_num=7;
  
  --骨骼
  local armature=skeleton:buildArmature("members_ui");
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

  -- local item=self.skeleton:getBoneTextureDisplay("member_item_bg");
  -- self.item_size=item:getContentSize();
  -- self.item_size.width=2+self.item_size.width;
  -- item:dispose();
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;

  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createStrokeTextFieldWithTextData(text_data,"成员列表",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.name_descb);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createStrokeTextFieldWithTextData(text_data,"等级",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("position_descb").textData;
  self.position_descb=createStrokeTextFieldWithTextData(text_data,"职位",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.position_descb);


  text_data=armature:getBone("donate_descb").textData;
  self.donate_descb=createStrokeTextFieldWithTextData(text_data,"总贡献",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.donate_descb);

  text_data=armature:getBone("mark_descb").textData;
  self.mark_descb=createStrokeTextFieldWithTextData(text_data,"评分",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.mark_descb);

  text_data=armature:getBone("time_descb").textData;
  self.time_descb=createStrokeTextFieldWithTextData(text_data,"登录",nil,1,ccc3(0,0,0));
  self.armature:addChild(self.time_descb);

  local data = self.familyProxy:getData();
  local str = "<content><font color='#00FFFF'>" .. data.FamilyName .. "</font>";
  str = str .. "<font color='#FFFFFF'>   Lv" .. data.FamilyLevel .. "</font></content>"
  self.bagpai_name_descb:setString(str);

  -- self.item_size=makeSize(909,77);
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;

  -- local button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  -- button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  -- self.leftButton=button;

  -- button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  -- button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  -- self.rightButton=button;

  initializeSmallLoading();
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_FAMILY_MEMBER_ARRAY,{FamilyId=self.container.isLookInto and self.container.lookIntoFamilyID or self.userProxy:getFamilyID()},self));
end

function FamilyMemberLayer:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
end

function FamilyMemberLayer:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
end

function FamilyMemberLayer:refreshButton()
  if not self.item_layer then
    self.leftButton:getDisplay():setVisible(false);
    self.rightButton:getDisplay():setVisible(false);
    return;
  end
  self.leftButton:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  self.rightButton:getDisplay():setVisible(self.max_page>self.item_layer:getCurrentPage());
  local page=0==self.max_page and 0 or self.item_layer:getCurrentPage();
  self.page_descb:setString("页数:" .. page .. "/" .. self.max_page);
end

function FamilyMemberLayer:refreshFamilyMemberArray(familyId, memberArray)
  uninitializeSmallLoading();
  self.familyId=familyId;
  self.memberArray=memberArray;
  self.items={};

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(220,90);
  self.item_layer:setViewSize(makeSize(909,400));
  self.item_layer:setItemSize(makeSize(909,75));
  self.armature:addChild(self.item_layer);

  local function sf(a, b)
    if a.BooleanValue>b.BooleanValue then
      return true;
    elseif a.BooleanValue<b.BooleanValue then
      return false;
    end
    if a.FamilyPositionId<b.FamilyPositionId then
      return true;
    elseif a.FamilyPositionId>b.FamilyPositionId then
      return false;
    end
    return a.Donate<b.Donate;
  end
  table.sort(self.memberArray,sf);
  for k,v in pairs(self.memberArray) do
    local item=FamilyMemberItem.new();
    item:initialize(self.skeleton,self.familyProxy,self.parent_container,v);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end

  -- self.max_page=math.ceil(table.getn(memberArray)/self.const_item_num);
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
  --   if a.BooleanValue>b.BooleanValue then
  --     return true;
  --   elseif a.BooleanValue<b.BooleanValue then
  --     return false;
  --   end
  --   if a.FamilyPositionId<b.FamilyPositionId then
  --     return true;
  --   elseif a.FamilyPositionId>b.FamilyPositionId then
  --     return false;
  --   end
  --   return a.Donate<b.Donate;
  -- end
  -- table.sort(memberArray,sf);
  -- local layer;
  -- for k,v in pairs(memberArray) do
  --   if 0==(-1+k)%self.const_item_num then
  --     layer=Layer.new();
  --     layer:initLayer();
  --     layer:setPositionX(math.floor((-1+k)/self.const_item_num)*self.item_size.width);
  --     self.item_layer:addContent(layer);
  --   end
  --   local item=FamilyMemberItem.new();
  --   item:initialize(self.skeleton,self.familyProxy,self.parent_container,v);
  --   item:setPositionY(self.item_size.height*(-1+self.const_item_num-(-1+k)%self.const_item_num));
  --   layer:addChild(item);
  --   table.insert(self.items,item);
  -- end
  -- self:refreshButton();
end

function FamilyMemberLayer:refreshChangePositionID(userId, familyPositionId)
  for k,v in pairs(self.items) do
    if userId==v.data.UserId then
      v:refreshChangePositionID(familyPositionId);
      break;
    end
  end
end

function FamilyMemberLayer:refreshFamilyKick(userID)
  for k,v in pairs(self.items) do
    if userID==v.data.UserId then
      v:refreshFamilyKick();
      break;
    end
  end
end

function FamilyMemberLayer:getUserNameByMemberLayer(userId)
  for k,v in pairs(self.items) do
    if userId==v.data.UserId then
      return v.data.UserName;
    end
  end
end

function FamilyMemberLayer:getAppointableByPositionID(positionID)
  local a={"","fuzuzhang","yuanlao","jingying",""};
  a=a[positionID];
  local b=0;
  if ""==a then
    return true;
  end
  for k,v in pairs(self.memberArray) do
    if positionID==v.FamilyPositionId then
      b=1+b;
    end
  end
  if analysis("Jiazu_Jiazushengjibiao",self.familyProxy:getFamilyLevel(),a)>b then
    return true;
  end
  sharedTextAnimateReward():animateStartByString("任命的" .. analysis("Jiazu_Zhiweidengjibiao",positionID,"name") .. "人数超过上限了哦~");
  return false;
end
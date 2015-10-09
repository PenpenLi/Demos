--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyLogLayer=class(TouchLayer);

function FamilyLogLayer:ctor()
  self.class=FamilyLogLayer;
end

function FamilyLogLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyLogLayer.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyLogLayer:initialize(skeleton, familyProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  self.const_item_num=7;
  
  --骨骼
  local armature=skeleton:buildArmature("log_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature_d=armature.display;
  self:addChild(self.armature_d);

  --self.armature_d:removeChildAt(2);

  --page_descb
  local text="";
  local text_data=armature:getBone("bagpai_name_descb").textData;
  self.bagpai_name_descb=createRichMultiColoredLabelWithTextData(text_data,text,nil,1,ccc3(0,0,0));
  self.bagpai_name_descb.touchEnabled=false;
  self.armature_d:addChild(self.bagpai_name_descb);




     --   local leftButton=self.armature_d:getChildByName("common_copy_left_button");
     -- self.leftButtonP = convertBone2LB4Button(leftButton);
     -- self.armature_d:removeChild(leftButton);

     
     -- local rightButton=self.armature_d:getChildByName("common_copy_right_button");
     -- self.rightButtonP = convertBone2LB4Button(rightButton);
     -- self.armature_d:removeChild(rightButton);

  -- local item=self.skeleton:getBoneTextureDisplay("member_item_bg");
  -- self.item_size=item:getContentSize();
  -- item:dispose();
  -- self.pos=self.armature_d:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;

  -- self.item_size=makeSize(909,77);
  -- self.pos=self.armature_d:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y + 20;

  local data = self.familyProxy:getData();
  local str = "<content><font color='#00FFFF'>" .. data.FamilyName .. "</font>";
  str = str .. "<font color='#FFFFFF'>   Lv" .. data.FamilyLevel .. "</font></content>"
  self.bagpai_name_descb:setString(str);


  initializeSmallLoading();
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_FAMILY_LOG,{Page=1},self));
end

function FamilyLogLayer:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
end

function FamilyLogLayer:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
end

function FamilyLogLayer:refreshFamilyLog(familyLogArray)
  uninitializeSmallLoading();
  self.familyLogArray=familyLogArray;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(193,89);
  self.item_layer:setViewSize(makeSize(987,470));
  self.item_layer:setItemSize(makeSize(987,75));
  self.armature_d:addChild(self.item_layer);

  local function sf(a, b)
    return a.Time>b.Time;
  end
  table.sort(self.familyLogArray,sf);
  for k,v in pairs(self.familyLogArray) do
    local item=FamilyLogItem.new();
    item:initialize(self.skeleton,self.familyProxy,self.parent_container,v);
    self.item_layer:addItem(item);
  end

  -- self.max_page=math.ceil(table.getn(familyLogArray)/self.const_item_num);
  -- print(">>>>>>>>>",table.getn(familyLogArray),self.const_item_num);
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
  -- --self.armature_d:addChildAt(self.item_layer,2);
  -- self.armature_d:addChild(self.item_layer);
  -- local function sf(a, b)
  --   return a.Time>b.Time;
  -- end
  -- table.sort(familyLogArray,sf);
  -- local layer;
  -- for k,v in pairs(familyLogArray) do
  --   if 0==(-1+k)%self.const_item_num then
  --     layer=Layer.new();
  --     layer:initLayer();
  --     layer:setPositionX(math.floor((-1+k)/self.const_item_num)*self.item_size.width);
  --     self.item_layer:addContent(layer);
  --   end
  --   local item=FamilyLogItem.new();
  --   item:initialize(self.skeleton,self.familyProxy,self.parent_container,v);
  --   item:setPositionY(self.item_size.height*(-1+self.const_item_num-(-1+k)%self.const_item_num));
  --   layer:addChild(item);
  -- end
  -- self:refreshButton();
end

function FamilyLogLayer:refreshButton()
      
     if not self.leftButton then
       local leftButton=CommonButton.new();
       leftButton:initialize("common_left_button_normal","common_left_button_down",CommonButtonTouchable.BUTTON);
       leftButton:setPosition(self.leftButtonP);
       leftButton:addEventListener(DisplayEvents.kTouchTap,self.onLeftButtonTap,self);
       self.armature_d:addChild(leftButton);
       self.leftButton = leftButton;
     end

     if not self.rightButton then    
       local rightButton=CommonButton.new();
       rightButton:initialize("common_right_button_normal","common_right_button_down",CommonButtonTouchable.BUTTON);
       rightButton:setPosition(self.rightButtonP);
       rightButton:addEventListener(DisplayEvents.kTouchTap,self.onRightButtonTap,self);
       self.armature_d:addChild(rightButton);
       self.rightButton = rightButton;
     end



  -- local button=Button.new(self.armature4dispose:findChildArmature("common_copy_left_button"),false);
  -- button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  -- self.leftButton=button;

  -- button=Button.new(self.armature4dispose:findChildArmature("common_copy_right_button"),false);
  -- button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  -- self.rightButton=button;
  
  -- self.leftButton:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  -- self.rightButton:getDisplay():setVisible(self.max_page>self.item_layer:getCurrentPage());

  self.leftButton:setVisible(1<self.item_layer:getCurrentPage());
  self.rightButton:setVisible(self.max_page>self.item_layer:getCurrentPage()); 

  local page=0==self.max_page and 0 or self.item_layer:getCurrentPage();
  self.page_descb:setString("页数:" .. page .. "/" .. self.max_page);
end
--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

NoneFamilyLayer=class(TouchLayer);

function NoneFamilyLayer:ctor()
  self.class=NoneFamilyLayer;
end

function NoneFamilyLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	NoneFamilyLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function NoneFamilyLayer:initialize(parent_container, isLookInto)
  self:initLayer();
  self.parent_container=parent_container;
  self.skeleton=self.parent_container.skeleton;
  self.familyProxy=self.parent_container.familyProxy;
  self.userProxy=self.parent_container.userProxy;
  self.bagProxy=self.parent_container.bagProxy;
  self.userCurrencyProxy=self.parent_container.userCurrencyProxy;
  self.isLookInto=isLookInto;
  self.const_item_num=6;

  -- local bg=LayerColorBackGround:getBackGround();
  -- self:addChild(bg);
  
  --骨骼
  local armature=self.skeleton:buildArmature("none_family_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  --rank_descb
  local text_data=armature:getBone("rank_descb").textData;
  self.rank_descb=createTextFieldWithTextData(text_data,"排行");
  self.armature:addChild(self.rank_descb);

  text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,"帮派名称");
  self.armature:addChild(self.name_descb);

  text_data=armature:getBone("wanjia_name_descb").textData;
  self.wanjia_name_descb=createTextFieldWithTextData(text_data,"玩家名称");
  self.armature:addChild(self.wanjia_name_descb);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"等级");
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("population_descb").textData;
  self.population_descb=createTextFieldWithTextData(text_data,"人数");
  self.armature:addChild(self.population_descb);

  text_data=armature:getBone("operation").textData;
  self.operation=createTextFieldWithTextData(text_data,"操作");
  self.armature:addChild(self.operation);


  -- local button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  -- button.bone:initTextFieldWithString("common_copy_bluelonground_button","创建家族");
  -- button:addEventListener(Events.kStart,self.onFoundButtonTap,self);
  -- button:getDisplay():setVisible(not self.isLookInto);

  --创建家族
  local button=self.armature:getChildByName("button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("创建家族","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onFoundButtonTap,self);
  self:addChild(button);
  self.button=button;
  self.button:setVisible(not self.isLookInto);

  -- button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  -- button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  -- self.leftButton=button;

  -- button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  -- button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  -- self.rightButton=button;

  -- local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  -- button:addEventListener(Events.kStart,self.onCloseButtonTap,self);


  -- local item=self.skeleton:getBoneTextureDisplay("none_family_ui_item_bg");
  -- self.item_size=item:getContentSize();
  -- item:dispose();
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;

  -- self.item_size=makeSize(909,80);
  -- self.pos=self.armature:getChildByName("common_copy_button_bg"):getPosition();
  -- self.pos.y=-self.item_size.height*self.const_item_num+self.pos.y;
  

  initializeSmallLoading();
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,{Page=1},self));
end

--移除
function NoneFamilyLayer:onCloseButtonTap(event)
  if self.isLookInto then
    self.parent.onLookIntoNoneFamilyLayer=nil;
    self.parent:removeChild(self);
    return;
  end
  self.parent_container:onCloseButtonTap();
end

function NoneFamilyLayer:onFoundButtonTap(event)
  local needGold = analysis("Xishuhuizong_Xishubiao",1019,"constant");
  local needSilver = analysis("Xishuhuizong_Xishubiao",1020,"constant");
  self.isGoldEnough = needGold <= self.userCurrencyProxy:getGold();
  self.isSilverEnough =needSilver <= self.userCurrencyProxy:getSilver();
  local colorGold = self.isGoldEnough and "#00FF00" or "#FF00000";
  local colorSilver = self.isSilverEnough and "#00FF00" or "#FF00000";

  local str = "<content><font color='#FFFFFF'>亲可以花费</font>";
  str = str .. "<font color='" .. colorGold .. "'>" .. needGold .. "元宝</font>";
  str = str .. "<font color='#FFFFFF'>,或者</font>";
  str = str .. "<font color='" .. colorSilver .. "'>" .. needSilver/10000 .. "万银两</font>";
  str = str .. "<font color='#FFFFFF'>创建属于自己的帮派,努力瑟!</font></content>";

  local popup=CommonPopup.new();
  popup:initialize(str,self,self.onGoldFound,nil,self.onSilverFound,nil,nil,{"元宝创建","银两创建"},true,nil,true);
  self.parent_container:addChild(popup);
end

function NoneFamilyLayer:onSilverFound(event)
  if not self.isSilverEnough then
    sharedTextAnimateReward():animateStartByString("银两不足呢");
    return;
  end
  self:onConfirmFound(false);
end

function NoneFamilyLayer:onGoldFound(event)
  if not self.isGoldEnough then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
    return;
  end
  self:onConfirmFound(true);
end

function NoneFamilyLayer:onConfirmFound(isGold)
  local familyFuoundLayer=FamilyFuoundLayer.new();
  familyFuoundLayer:initialize(self.parent_container, isGold);
  self.parent_container:addChild(familyFuoundLayer);
end

function NoneFamilyLayer:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
  self.item_layer:setMoveEnabled(false);
end

function NoneFamilyLayer:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
  self.item_layer:setMoveEnabled(false);
end

function NoneFamilyLayer:refreshNoneFamilyLayerData(page, maxPage, familyInfoArray)
  uninitializeSmallLoading();
  self.page=page;
  self.max_page=maxPage;
  self.familyInfoArray=familyInfoArray;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(237,150);
  self.item_layer:setViewSize(makeSize(785,400));
  self.item_layer:setItemSize(makeSize(785,75));
  self.armature:addChild(self.item_layer);

  self.items={};
  local function sf(a, b)
    return a.Ranking<b.Ranking;
  end
  table.sort(self.familyInfoArray,sf);
  for k,v in pairs(self.familyInfoArray) do
    local item=NoneFamilyItem.new();
    item:initialize(self.parent_container,v);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end
  -- if 0==table.getn(familyInfoArray) then
  --   self:onFoundButtonTap();
  -- end
  -- if page>maxPage then
  --   page=maxPage;
  -- end
  -- if 0==maxPage then
  --   self.page=nil;
  --   self.max_page=nil;
  --   self.page_descb:setString("页数:" .. 0 .. "/" .. 0);
  --   self:refreshButton();
  --   return;
  -- end
  -- self.page=page;
  -- self.max_page=maxPage;
  -- self.familyInfoArray=familyInfoArray;

  -- if not self.item_layer then
  --   self.layers={};
  --   self.item_layer=GalleryViewLayer.new();
  --   self.item_layer:initLayer();
  --   self.item_layer:setPosition(self.pos);
  --   self.item_layer:setViewSize(makeSize(self.item_size.width,
  --                                        self.const_item_num*self.item_size.height));
  --   self.item_layer:setContainerSize(makeSize(self.max_page*self.item_size.width,
  --                                             self.const_item_num*self.item_size.height));
  --   self.item_layer:setMaxPage(self.max_page);
  --   local function refreshButton()
  --     self:refreshButton();
  --   end
  --   self.item_layer:addFlipPageCompleteHandler(refreshButton);
  --   self.armature:addChildAt(self.item_layer,3);
  --   local a=0;
  --   while self.max_page>a do
  --     a=1+a;
  --     local l=Layer.new();
  --     l:initLayer();
  --     l:setPositionX((-1+a)*self.item_size.width);
  --     self.item_layer:addContent(l);
  --     table.insert(self.layers,l);
  --   end
  -- end

  -- self.items={};
  -- self.layers[self.page]:removeChildren();
  -- local function sf(a, b)
  --   return a.Ranking<b.Ranking;
  -- end
  -- --table.sort(self.familyInfoArray,sf);
  -- for k,v in pairs(self.familyInfoArray) do
  --   local item=NoneFamilyItem.new();
  --   v.Ranking=k+self.const_item_num*(-1+page);
  --   item:initialize(self.skeleton,self.familyProxy,self.userProxy,self.bagProxy,self,self.parent_container,v);
  --   item:setPositionY(self.item_size.height*(-1+self.const_item_num-(-1+k)%self.const_item_num));
  --   self.layers[self.page]:addChild(item);
  --   table.insert(self.items,item);
  -- end
  -- self.item_layer:setMoveEnabled(true);
  -- self:refreshButton(true);
end

function NoneFamilyLayer:refreshButton(bool)
  if not self.page then
    self.leftButton:getDisplay():setVisible(false);
    self.rightButton:getDisplay():setVisible(false);
    return;
  end
  self.leftButton:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  self.rightButton:getDisplay():setVisible(self.max_page>self.item_layer:getCurrentPage());
  if not bool then
    self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,{Page=self.item_layer:getCurrentPage()},self));
  end
  local page=0==self.max_page and 0 or self.item_layer:getCurrentPage();
  self.page_descb:setString("页数:" .. page .. "/" .. self.max_page);
end

function NoneFamilyLayer:refreshFamilyApply(familyId, bool)
  for k,v in pairs(self.items) do
    if familyId==v.data.FamilyId then
      v:refreshFamilyApply(bool);
      break;
    end
  end
end
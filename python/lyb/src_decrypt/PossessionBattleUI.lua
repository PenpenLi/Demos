--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionBattleUI=class(TouchLayer);

function PossessionBattleUI:ctor()
  self.class=PossessionBattleUI;
end

function PossessionBattleUI:dispose()
  self.parent_container.battleUI=nil;
  self:disposeRefreshTime();
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionBattleUI.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

function PossessionBattleUI:disposeRefreshTime()
  if self.refreshTime then
    self.refreshTime:dispose();
    self.refreshTime=nil;
  end
end

--
function PossessionBattleUI:initializeUI(skeleton, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.userProxy=self.parent_container.userProxy;
  self.const_page=4;
  self.data=nil;
  self.refreshTime=nil;
  self.layers={};
  self.items={};

  --骨骼
  local armature=skeleton:buildArmature("battle_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="<content><font color='#00FF00' ling='1' ref='1'>查看比赛规则</font></content>";
  local text_data=armature:getBone("number_descb").textData;
  self.number_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.number_descb:addEventListener(DisplayEvents.kTouchTap,self.onRuleButtonTap,self);
  self.armature:addChild(self.number_descb);

  text="";
  text_data=armature:getBone("time_bg").textData;
  self.time_bg=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_bg);

  local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  button:addEventListener(Events.kStart,self.onCloseButtonTap,self);
  self.left_button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  self.left_button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  self.right_button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  self.right_button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  self:refreshGalleryViewLayer();
end

function PossessionBattleUI:onRuleButtonTap(event)
  local possessionRuleUI=PossessionRuleUI.new();
  possessionRuleUI:initialize(self.skeleton);
  self:addChild(possessionRuleUI);
end

function PossessionBattleUI:resume4Battle()
  local resumeData=self.parent_container.resumeData;
  if resumeData then
    self.item_layer:setPage(resumeData.MapID,false);
    if self.items[self.item_layer:getCurrentPage()] and self.items[self.item_layer:getCurrentPage()].buttons[resumeData.ButtonID]:isVisible() then
      self.items[self.item_layer:getCurrentPage()]:onViewButtonTap(nil,resumeData.ButtonID);
    end
    self.parent_container.resumeData=nil;
  end
end

--移除
function PossessionBattleUI:onCloseButtonTap(event)
  self.parent_container:onCloseButtonTap(event);
end

function PossessionBattleUI:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
end

function PossessionBattleUI:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
end

function PossessionBattleUI:onRefreshTime()
  for k,v in pairs(self.items) do
    if v.time_descb then
      v.time_descb:setString(self.refreshTime:getTimeStr());
    end
  end
  if self.parent_container.deployUI then
    self.parent_container.deployUI:setTimeString(self.refreshTime:getTimeStr());
  end
end

function PossessionBattleUI:refreshButton()
  self.left_button:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  self.right_button:getDisplay():setVisible(self.const_page>self.item_layer:getCurrentPage());
  local item=self.items[self.item_layer:getCurrentPage()];
  if not item then
    local item=PossessionBattleItem.new();
    item:initializeUI(self.skeleton,self.parent_container,self,self.item_layer:getCurrentPage());
    self.layers[self.item_layer:getCurrentPage()]:addChild(item);
    self.items[self.item_layer:getCurrentPage()]=item;
  end
  self.items[self.item_layer:getCurrentPage()]:refreshData();
  self.time_bg:setString(analysis("Jiazu_Lingdizhanbaoming",self.item_layer:getCurrentPage(),"name"));
  if self:getHasFamilyByMapID(self.item_layer:getCurrentPage()) then
    if not self.signed_img then
      self.signed_img=self.skeleton:getBoneTextureDisplay("signed_img");
      self.signed_img:setPosition(self.armature:getChildByName("pos"):getPosition());
    end
    self.armature:addChild(self.signed_img);
  else
    if self.signed_img then
      self.armature:removeChild(self.signed_img);
      self.signed_img=nil;
    end
  end
end

function PossessionBattleUI:refreshGalleryViewLayer()
  local size=Director:sharedDirector():getWinSize();
  self.item_layer=GalleryViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setViewSize(size);
  self.item_layer:setContainerSize(makeSize(self.const_page*size.width,size.height));
  self.item_layer:setMaxPage(self.const_page);
  local function refreshButton()
    self:refreshButton();
  end
  self.item_layer:addFlipPageCompleteHandler(refreshButton);
  self.armature:addChildAt(self.item_layer,2);
  local a=0;
  while self.const_page>a do
    a=1+a;
    local layer=Layer.new();
    layer:initLayer();
    layer:setPositionX((-1+a)*size.width);
    self.item_layer:addContent(layer);
    table.insert(self.layers,layer);
  end
  self:refreshButton();
end

function PossessionBattleUI:refreshStage(data)
  self:disposeRefreshTime();
  self:refreshData(data);
  self.refreshTime=RefreshTime.new();
  self.refreshTime:initTime(self.data.RemainSeconds,self.onRefreshTime,self);
  self:onRefreshTime();
  self.items[self.item_layer:getCurrentPage()]:refreshData();

  local a=0;
  local b;
  while 4>a do
    a=1+a;
    if self:getHasFamilyByMapID(a) then
      b=a;
      break;
    end
  end
  if b and 1==self.item_layer:getCurrentPage() then
    self.item_layer:setPage(b);
  end
end

function PossessionBattleUI:refreshData(data)
  if not self.data then
    self.data=data;
    return;
  end
  self.data.Stage=data.Stage;
  self.data.RemainSeconds=data.RemainSeconds;
  for k,v in pairs(data.FamilyPromotionArray) do
    self:refreshItemData(v);
  end
end

function PossessionBattleUI:refreshItemData(data)
  for k,v in pairs(self.data.FamilyPromotionArray) do
    if data.MapId==v.MapId and data.PromotionPositionId==v.PromotionPositionId then
      for k_,v_ in pairs(v) do
        v[k_]=data[k_];
      end
      return;
    end
  end
  table.insert(self.data.FamilyPromotionArray,data);
end

function PossessionBattleUI:getHasFamilyAttendByMapID(mapID)
  if self.data then
    for k,v in pairs(self.data.FamilyPromotionArray) do
      if mapID==v.MapId and 0~=v.FamilyId then
        return true;
      end
    end
  end
  return false;
end

function PossessionBattleUI:getHasFamilyByMapID(mapID)
  if self.data then
    for k,v in pairs(self.data.FamilyPromotionArray) do
      if mapID==v.MapId and 0~=self.userProxy:getFamilyID() and self.userProxy:getFamilyID()==v.FamilyId then
        return true;
      end
    end
  end
  return false;
end

function PossessionBattleUI:getFamilyIsPromotedByMapID(mapID)
  if self.data then
    for k,v in pairs(self.data.FamilyPromotionArray) do
      if mapID==v.MapId and 0~=self.userProxy:getFamilyID() and self.userProxy:getFamilyID()==v.FamilyId then
        return 1==v.BooleanValue;
      end
    end
  end
  return false;
end

function PossessionBattleUI:getDataByMapIDAndPromotionPositionId(mapID, promotionPositionId)
  local data={};
  for k,v in pairs(self.data.FamilyPromotionArray) do
    if mapID==v.MapId and promotionPositionId==v.PromotionPositionId then
      return v;
    end
  end
end

function PossessionBattleUI:galleryViewLayerEnabled(bool)
    if self.item_layer then
          self.item_layer:setMoveEnabled(bool);
    end
end
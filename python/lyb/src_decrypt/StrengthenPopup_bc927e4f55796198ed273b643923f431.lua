--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

	yanchuan.xie@happyelements.com
]]

require "core.controls.ListScrollViewLayer";
require "core.display.ccTypes";
require "core.display.Layer";
require "core.events.DisplayEvent";
require "main.view.strengthen.ui.strengthenPopup.StrengthenFormula";
require "main.view.strengthen.ui.strengthenPopup.StrengthenLayer";
require "main.view.strengthen.ui.strengthenPopup.StarAddLayer";
require "main.view.strengthen.ui.strengthenPopup.ForgeLayer";
require "main.view.strengthen.ui.strengthenPopup.GemLayer";
require "main.view.strengthen.ui.strengthenPopup.StrengthenItem";
require "main.view.strengthen.ui.strengthenPopup.DegradePopup";
require "main.view.strengthen.ui.strengthenPopup.StuffImg";
require "main.view.strengthen.ui.strengthenPopup.StuffTrackDetail";
require "main.view.bag.ui.bagPopup.EquipDetailLayer";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";

StrengthenPopup=class(TouchLayer);

function StrengthenPopup:ctor()
  self.class=StrengthenPopup;
end

function StrengthenPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StrengthenPopup.superclass.dispose(self);
  self.removeArmature:dispose()
  BitmapCacher:removeUnused();
end

function StrengthenPopup:initialize()
  self:initLayer();

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  -- self:addChild(LayerColorBackGround:getBackGround());
  self.skeleton=nil;
end

function StrengthenPopup:initializeStrengthenUI(skeleton, userCurrencyProxy, generalListProxy, equipmentInfoProxy, bagProxy, userProxy, openFunctionProxy)  
  local armature=skeleton:buildArmature("strengthen_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.strengthen_item_name_text_data=armature:findChildArmature("strengthenAndStarAdd_item"):getBone("strengthen_item_name").textData;
  self.forge_item_name_descb_text_data=armature:findChildArmature("forge_item"):getBone("forge_item_name_descb").textData;
  self.forge_item_name_descb_1_text_data=armature:findChildArmature("forge_item"):getBone("forge_item_name_descb_1").textData;
  
  self.tab_button_text_data=armature:findChildArmature("common_copy_tab_button"):getBone("common_copy_tab_button").textData;
  
  armature=armature.display;
  self.armature=armature;
  armature.touchEnabled=false;
  self:addChild(armature);

  self:setContentSize(makeSize(1223,685));
  AddUIBackGround(self);


  self.const_scroll_num=5.35;
  self.skeleton=skeleton;
  self.armature=armature;
  self.userCurrencyProxy=userCurrencyProxy;
  self.generalListProxy=generalListProxy;
  self.equipmentInfoProxy=equipmentInfoProxy;
  self.bagProxy=bagProxy;
  self.userProxy=userProxy;
  self.openFunctionProxy=openFunctionProxy;
  self.tab_buttons={};
  self.tab_button_tap=nil;
  self.tab_panel_select=nil;
  self.right_panel=nil;
  self.items={};
  self.item_select=nil;
  self.right_panel_tip={};

  self.small_bg_strengthen=Image.new();
  self.small_bg_strengthen:loadByArtID(StaticArtsConfig.STRENGTHEN);
  self.small_bg_strengthen:setPosition(ccp(403,38));
  self.armature:addChildAt(self.small_bg_strengthen,35);
  
  self.strengthenAndStarAdd_item=armature:getChildByName("strengthenAndStarAdd_item");
  self.forge_item=armature:getChildByName("forge_item");
  armature:removeChild(self.forge_item,false);

  
  --closeButton
  local closeButton=armature:getChildByName("common_copy_close_button");
  local closeButton_pos=convertBone2LB4Button(closeButton);--closeButton:getPositionX(),closeButton:getPositionY();
  armature:removeChild(closeButton);
  
  --common_copy_grid_new
  local common_copy_grid_new=self.strengthenAndStarAdd_item:getChildByName("common_copy_grid");
  self.common_copy_grid_new_pos=convertBone2LB(common_copy_grid_new);--common_copy_grid_new:getPosition();
  self.common_copy_grid_new_size=common_copy_grid_new:getContentSize();
  --common_copy_grid_new_forge
  common_copy_grid_new=self.forge_item:getChildByName("common_copy_grid");
  self.common_copy_grid_new_forge_pos=convertBone2LB(common_copy_grid_new);--common_copy_grid_new:getPosition();
  --common_copy_grid_new_1_forge
  common_copy_grid_new=self.forge_item:getChildByName("common_copy_grid_1");
  self.common_copy_grid_new_1_forge_pos=convertBone2LB(common_copy_grid_new);--common_copy_grid_new:getPosition();
  
  --common_copy_tab_button
  local common_copy_tab_button=armature:getChildByName("common_copy_tab_button");
  local common_copy_tab_button_pos={convertBone2LB4Button(common_copy_tab_button)};--{common_copy_tab_button:getPosition()};
  armature:removeChild(common_copy_tab_button);
  
  --common_copy_tab_button_1
  local common_copy_tab_button_1=armature:getChildByName("common_copy_tab_button_1");
  table.insert(common_copy_tab_button_pos,convertBone2LB4Button(common_copy_tab_button_1));--common_copy_tab_button_1:getPosition());
  armature:removeChild(common_copy_tab_button_1);
  
  --common_copy_tab_button_2
  local common_copy_tab_button_2=armature:getChildByName("common_copy_tab_button_2");
  table.insert(common_copy_tab_button_pos,convertBone2LB4Button(common_copy_tab_button_2));--common_copy_tab_button_2:getPosition());
  armature:removeChild(common_copy_tab_button_2);
	
	--common_copy_tab_button_3
  local common_copy_tab_button_3=armature:getChildByName("common_copy_tab_button_3");
  table.insert(common_copy_tab_button_pos,convertBone2LB4Button(common_copy_tab_button_3));--common_copy_tab_button_3:getPosition());
  armature:removeChild(common_copy_tab_button_3);
  
  --strengthen_ui_scroll_item
  local strengthen_ui_scroll_item=armature:getChildByName("strengthen_ui_scroll_item");
  local size=SizeDefine4Sprite9ridConfig.scroll_item_size_4_strengthen;
  local over_size=SizeDefine4Sprite9ridConfig.scroll_item__over_size_4_strengthen;
  self.strengthen_ui_scroll_item_pos=strengthen_ui_scroll_item:getPosition();
  self.strengthen_ui_scroll_item_width=size.width;
  self.strengthen_ui_scroll_item_height=size.height;
  self.strengthen_ui_scroll_item_over_width=over_size.width;
  self.strengthen_ui_scroll_item_over_height=over_size.height;
  armature:removeChild(strengthen_ui_scroll_item);
  
  --strengthen_ui_scroll_item_2
  local strengthen_ui_scroll_item_2=armature:getChildByName("strengthen_ui_scroll_item_2");
  self.item_skew_y=self.strengthen_ui_scroll_item_pos.y-strengthen_ui_scroll_item_2:getPositionY();--strengthen_ui_scroll_item_2:getPositionY()-self.strengthen_ui_scroll_item_pos.y;
  armature:removeChild(strengthen_ui_scroll_item_2);
  
  self:addListScrollViewLayer();
  
  --tab_button
  local a=0;
  local b={"强化","打造","宝石","精炼"};
  local c={FunctionConfig.FUNCTION_ID_25,FunctionConfig.FUNCTION_ID_26,FunctionConfig.FUNCTION_ID_82,FunctionConfig.FUNCTION_ID_27};
  while 3>a do
    a=1+a;
    common_copy_tab_button=CommonButton.new();
    common_copy_tab_button:initialize("common_tab_button_normal","common_tab_button_down",CommonButtonTouchable.CUSTOM);
    common_copy_tab_button:initializeText(self.tab_button_text_data,b[a]);
    common_copy_tab_button:setVisible(self.openFunctionProxy:checkIsOpenFunction(c[a]));
    common_copy_tab_button:setPosition(common_copy_tab_button_pos[a]);
    common_copy_tab_button:addEventListener(DisplayEvents.kTouchBegin,self.onTabButtonBegin,self);
    self:addChild(common_copy_tab_button);
    self.tab_buttons[a]=common_copy_tab_button;
  end
  self.tab_button_tap=self.tab_buttons[1];
  self.tab_button_tap:select(true);
  
  --closeButton
  closeButton=CommonButton.new();
  closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  closeButton:setPosition(closeButton_pos);
  closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  self:addChild(closeButton);
  self.closeButton=closeButton;
  
  self:onTabButtonTap(self.tab_buttons[1]);

  AddUIFrame(self);
end

--gemLayer
function StrengthenPopup:addGemLayer()
	self:tabElements(true);
	
  if self.right_panel then
    self.armature:removeChild(self.right_panel,false);
  end
  --self.right_panel=self.gem_item;
  self:removeRightPanelTip();
  --self.armature:addChild(self.right_panel);
  if self.gemLayer then
    self:removeEventListener(DisplayEvents.kTouchTap,self.gemLayer.onSelfTap,self);
    self:removeChild(self.gemLayer);
    self.gemLayer = nil;
  end
  self.gemLayer=GemLayer.new();
  self.gemLayer:initializeUI(self.skeleton,self,self.equipmentInfoProxy,self.bagProxy, self.generalListProxy, self.userProxy, self.userCurrencyProxy);
  self:addChild(self.gemLayer);
  self.tab_panel_select=self.gemLayer;
	-- self.gemLayer.touchChildren = true;
end

--forgeLayer
function StrengthenPopup:addForgeLayer()
	self:tabElements(false);
	
  if self.right_panel then
    self.armature:removeChild(self.right_panel,false);
  end
  self.right_panel=self.forge_item;
  self:removeRightPanelTip();
  self.armature:addChild(self.right_panel);

  self.forgeLayer=ForgeLayer.new();
  self.forgeLayer:initialize(self.skeleton,self,self.onForge,self.userCurrencyProxy,self.generalListProxy);
  self:addChild(self.forgeLayer);
  self.tab_panel_select=self.forgeLayer;

  self:refreshEquipmentData(2,true);
end

--starAddLayer
function StrengthenPopup:addStarLayer()
	self:tabElements(false);
	
  if self.right_panel then
    self.armature:removeChild(self.right_panel,false);
  end
  self.right_panel=self.strengthenAndStarAdd_item;
  self.armature:addChild(self.right_panel);

  self.starAddLayer=StarAddLayer.new();
  self.starAddLayer:initialize(self.skeleton,self,self.onStarAddLayer,self.userCurrencyProxy);
  self:addChild(self.starAddLayer);
  self.tab_panel_select=self.starAddLayer;

  self:refreshEquipmentData(4);
end

--strengthenLayer
function StrengthenPopup:addStrengthenLayer()
	self:tabElements(false);
	
  if self.right_panel then
    self.armature:removeChild(self.right_panel,false);
  end
  self.right_panel=self.strengthenAndStarAdd_item;
  self.armature:addChild(self.right_panel);

  self.strengthenLayer=StrengthenLayer.new();
  self.strengthenLayer:initialize(self.skeleton,self,self.onDegrade,self.onStrengthen,self.onStrengthenMax,self.userCurrencyProxy,self.generalListProxy);
  self:addChild(self.strengthenLayer);
  self.tab_panel_select=self.strengthenLayer;

  self:refreshEquipmentData(1);
end

function StrengthenPopup:tabElements(isGem)
	self.listScrollViewLayer:setVisible(not isGem);
  if self.no_item_4_forge then
    self:removeChild(self.no_item_4_forge);
  end
  self.small_bg_strengthen:setVisible(not isGem);
end

function StrengthenPopup:addListScrollViewLayer()
  if self.listScrollViewLayer then
    self.armature:removeChild(self.listScrollViewLayer);
    self.listScrollViewLayer=nil;
  end
  --scroll
  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(self.strengthen_ui_scroll_item_pos.x,self.strengthen_ui_scroll_item_pos.y-self.const_scroll_num*self.item_skew_y);
  self.listScrollViewLayer:setViewSize(makeSize(self.strengthen_ui_scroll_item_over_width,
                                  self.const_scroll_num*self.item_skew_y));
  self.listScrollViewLayer:setItemSize(makeSize(self.strengthen_ui_scroll_item_over_width,self.item_skew_y));
  self.armature:addChild(self.listScrollViewLayer);
end

--移除
function StrengthenPopup:onCloseButtonTap(event)
  self:dispatchEvent(Event.new("strengthenClose",nil,self));
end

--onTabButtonBegin
function StrengthenPopup:onTabButtonBegin(event)
  self:onTabButtonTap(event.target);
end

function StrengthenPopup:onTabButtonTap(button)
  if self.tab_button_tap then
    self.tab_button_tap:select(false);
    self:removeChild(self.tab_panel_select);
    self.tab_panel_select=nil;
  end

  self.tab_button_tap=button;
  self.tab_button_tap:select(true);

  if self.tab_buttons[1]==self.tab_button_tap then
    self:addStrengthenLayer();
  elseif self.tab_buttons[4]==self.tab_button_tap then	
		self:addStarLayer();
  elseif self.tab_buttons[3]==self.tab_button_tap then 
		self:addGemLayer();

	else
		self:addForgeLayer();

  end
end

function StrengthenPopup:changeTab(tabID)
  self:onTabButtonTap(self.tab_buttons[tabID]);
end

--onDegrade
function StrengthenPopup:onDegrade(event)
  if self.item_select then
    self:dispatchEvent(Event.new("onDegrade",self.item_select:getBagItemData().UserItemId,self));
  end
end

--onForge
function StrengthenPopup:onForge(event)
  if self.item_select then
    self:dispatchEvent(Event.new("onForge",self.item_select:getBagItemData().UserItemId,self));
  end
end

--onStarAddLayer
function StrengthenPopup:onStarAddLayer()
  if self.item_select then
    self:dispatchEvent(Event.new("onStarAdd",self.item_select:getBagItemData().UserItemId,self));
  end
end

--onStrengthen
function StrengthenPopup:onStrengthen()
  if self.item_select then
    self:dispatchEvent(Event.new("onStrengthen",self.item_select:getBagItemData().UserItemId,self));
  end
end

function StrengthenPopup:onStrengthenMax()
  if self.item_select then
    self:dispatchEvent(Event.new("onStrengthenMax",self.item_select:getBagItemData().UserItemId,self));
  end
end

function StrengthenPopup:onStuffTrack(itemID)
  self:dispatchEvent(Event.new("onTrack",{ItemId=itemID},self));
end

function StrengthenPopup:onIconTap(event)
  local targeClone = event.target:clone();
  self.listScrollViewLayer:setMoveEnabled(false);
  self.itemDetailLayer=LayerColorBackGround:getTransBackGround();
  self.itemDetailLayer:addEventListener(DisplayEvents.kTouchTap,self.onItemDetailLayerTap,self);
  self:addChild(self.itemDetailLayer);
  self.equipDetailLayer=EquipDetailLayer.new();
  self.equipDetailLayer:initialize(self.bagProxy:getSkeleton(), targeClone, event.target, false);
  local pos = makePoint(self.listScrollViewLayer.x, self.listScrollViewLayer.y);
  self.equipDetailLayer:setPosition(pos);
  self:addChild(self.equipDetailLayer);
end

function StrengthenPopup:onItemDetailLayerTap(event)
  self.itemDetailLayer:removeEventListener(DisplayEvents.kTouchTap,self.onItemDetailLayerTap,self);
  self.listScrollViewLayer:setMoveEnabled(true);
  self:removeChild(self.itemDetailLayer);
  self.itemDetailLayer=nil;
  self:removeChild(self.equipDetailLayer);
  self.equipDetailLayer=nil;
end

--onItemTap
function StrengthenPopup:onItemTap(item)
  if self.itemDetailLayer then
    return;
  end
  if self.item_select then
    self.item_select:selectItem(false);
  end
  self.item_select=item;
  self.item_select:selectItem(true);
  self:refreshPanelRight();
  if self.tab_panel_select then
    self.tab_panel_select:refreshTapItem(self.item_select);
  end
end

local function sfunc(a, b)
  if 1==a:getIsEquipped() and 0==b:getIsEquipped() then
    return true;
  elseif 0==a:getIsEquipped() and 1==b:getIsEquipped() then
    return false;
  else
    local aq=analysis("Zhuangbei_Zhuangbeibiao",a:getBagItemData().ItemId,"quality");
    local bq=analysis("Zhuangbei_Zhuangbeibiao",b:getBagItemData().ItemId,"quality");
    if aq<bq then
      return true;
    elseif aq>bq then
      return false;
    end
    local as=a:getStrengthLevel();
    local bs=b:getStrengthLevel();
    if as>bs then
      return true;
    elseif as<bs then
      return false;
    end
    local la=analysis("Daoju_Daojufenlei",a:getBagItem():getCategoryID(),"sequence");
    local lb=analysis("Daoju_Daojufenlei",b:getBagItem():getCategoryID(),"sequence");
    if la<lb then
      return true;
    elseif la>lb then
      return false;
    end
    return false;
  end
end

--更新装备
function StrengthenPopup:refreshEquipmentData(n ,isForge)
  local layer=nil;
  local item=nil;
  local a=0;
  local b=self.equipmentInfoProxy:getData();

  self.items={};
  self.item_select=nil;
  self:addListScrollViewLayer();

  if nil==b then
    return;
  end

  for k,v in pairs(b) do
    a=1+a;

    local equipmentItemID=self.bagProxy:getItemData(v.UserEquipmentId).ItemId;
    if nil==isForge or (isForge and analysisHas("Zhuangbei_Zhuangbeidazao",equipmentItemID)) then
      local strengthenItem=StrengthenItem.new();
      strengthenItem:initialize(self.skeleton,self,self.onItemTap,v,self.bagProxy:getItemData(v.UserEquipmentId),self.equipmentInfoProxy,self.bagProxy);
      strengthenItem:getBagItem().touchChildren=true;
      strengthenItem:getBagItem().touchEnabled=true;
      --strengthenItem:getBagItem():addEventListener(DisplayEvents.kTouchTap,self.onIconTap,self);
      table.insert(self.items,strengthenItem);
    end
  end

  table.sort(self.items,sfunc);

  a=0;
  for k,v in pairs(self.items) do
    a=1+a;
    
    layer=TouchLayer.new();
    layer:initLayer();
    layer:changeWidthAndHeight(self.strengthen_ui_scroll_item_over_width,self.item_skew_y);
    layer:addChild(v);
    self.listScrollViewLayer:addItem(layer);
    if nil==item then
      item=v;
    end
  end
  
  if item then
    self:onItemTap(item);
  end

  self.tab_panel_select:setVisible(0~=table.getn(self.items));
  if self.no_item_4_forge then
    self:removeChild(self.no_item_4_forge);
  end
  if 0==table.getn(self.items) then
    local s={"强化","打造","镶嵌","精炼"};
    local label=CCLabelTTFStroke:create("亲,  你还没有可以" .. s[n] .. "的装备哦 ~",FontConstConfig.OUR_FONT,22,1,ccc3(0,0,0),CCSizeMake(300,30));
    self.no_item_4_forge=TextField.new(label);
    self.no_item_4_forge:setColor(CommonUtils:ccc3FromUInt(65280));
    self.no_item_4_forge:setPositionXY(550,75);
    self:addChild(self.no_item_4_forge);
  end
end

function StrengthenPopup:refreshPanelRight()
  self:removeRightPanelTip();
  if nil==self.item_select then
    return;
  end

  if self.tab_buttons[1]==self.tab_button_tap or self.tab_buttons[4]==self.tab_button_tap then
    local item_select_prop=self.item_select:getBagItem():clone();
    local pos_x,pos_y=ConstConfig.CONST_GRID_ITEM_SKEW_X+self.common_copy_grid_new_pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+self.common_copy_grid_new_pos.y;
    item_select_prop:setPositionXY(pos_x,pos_y);
    self.right_panel:addChild(item_select_prop);
    table.insert(self.right_panel_tip,item_select_prop);
  
    --strengthen_item_name
    local text=analysis("Daoju_Daojubiao",self.item_select:getBagItemData().ItemId,"name");
    local quality=analysis("Zhuangbei_Zhuangbeibiao",self.item_select:getBagItemData().ItemId,"quality");
    local strengthen_item_name=createTextFieldWithQualityID(quality,self.strengthen_item_name_text_data,text);
    self.right_panel:addChild(strengthen_item_name);
    table.insert(self.right_panel_tip,strengthen_item_name);
  elseif self.tab_buttons[2]==self.tab_button_tap then
    local item_select_prop=self.item_select:getBagItem():clone();
    local pos_x,pos_y=ConstConfig.CONST_GRID_ITEM_SKEW_X+self.common_copy_grid_new_forge_pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+self.common_copy_grid_new_forge_pos.y;
    item_select_prop:setPositionXY(pos_x,pos_y);
    self.right_panel:addChild(item_select_prop);
    table.insert(self.right_panel_tip,item_select_prop);

    local forgeID=analysis("Zhuangbei_Zhuangbeidazao",self.item_select:getBagItemData().ItemId,"afterForgeId");
    item_select_prop=BagItem.new();
    item_select_prop:initialize({UserItemId=0,ItemId=forgeID,Count=1,IsBanding=0,IsUsing=0,Place=0});
    pos_x,pos_y=ConstConfig.CONST_GRID_ITEM_SKEW_X+self.common_copy_grid_new_1_forge_pos.x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+self.common_copy_grid_new_1_forge_pos.y;
    item_select_prop:setPositionXY(pos_x,pos_y);
    self.right_panel:addChild(item_select_prop);
    table.insert(self.right_panel_tip,item_select_prop);

    --forge_item_name
    local text=analysis("Daoju_Daojubiao",self.item_select:getBagItemData().ItemId,"name");
    local quality=analysis("Zhuangbei_Zhuangbeibiao",self.item_select:getBagItemData().ItemId,"quality");
    local strengthen_item_name=createTextFieldWithQualityID(quality,self.forge_item_name_descb_text_data,text);
    self.right_panel:addChild(strengthen_item_name);
    table.insert(self.right_panel_tip,strengthen_item_name);

    --forge_item_name
    text=analysis("Daoju_Daojubiao",forgeID,"name");
    quality=analysis("Zhuangbei_Zhuangbeibiao",forgeID,"quality");
    strengthen_item_name=createTextFieldWithQualityID(quality,self.forge_item_name_descb_1_text_data,text);
    self.right_panel:addChild(strengthen_item_name);
    table.insert(self.right_panel_tip,strengthen_item_name);
  end  
end

function StrengthenPopup:refreshStrengthenItem(userEquipmentId)
  for k,v in pairs(self.items) do
    if userEquipmentId==v:getBagItemData().UserItemId then
      if self.tab_buttons[2]==self.tab_button_tap and (not analysisHas("Zhuangbei_Zhuangbeidazao",v:getBagItemData().ItemId)) then
        self:onTabButtonTap(self.tab_buttons[2]);
        return;
      end
      v:refreshStrengthenItem();
      if self.item_select==v then
        self:onItemTap(self.item_select);
      end
      break;
    end
  end
end

function StrengthenPopup:removeRightPanelTip()
  for k,v in pairs(self.right_panel_tip) do
    v.parent:removeChild(v);
  end
  self.right_panel_tip={};
end

function StrengthenPopup:updateGemPanel()
	self.gemLayer:updatePanel();
end

function StrengthenPopup:getItemPosByUserItemID(userItemID)
  for k,v in pairs(self.items) do
    if userItemID==v:getBagItemData().UserItemId then
      self.listScrollViewLayer:scrollToItemByIndex(-1+k);
      return self.strengthen_ui_scroll_item_pos.x,
             self.strengthen_ui_scroll_item_pos.y-self.const_scroll_num*self.item_skew_y+self.item_skew_y*(#self.items-k)-self.listScrollViewLayer:getContentOffset();
    end
  end
end

function StrengthenPopup:refreshStuffByBags()
  if self.tab_buttons[4]==self.tab_button_tap then
    self.tab_panel_select:refreshStuffByBags();
  end
end

function StrengthenPopup:refreshStrengthenOnDouble(preStrengthenValue)
  if self.strengthenLayer then
    self.strengthenLayer:refreshStrengthenOnDouble(preStrengthenValue);
  end
end
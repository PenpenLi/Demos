require "core.controls.ListScrollViewLayer";
require "core.display.ccTypes";
require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.AccordionView";
require "core.controls.AccordionViewTab";
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
require "main.view.strengthen.ui.strengthenPopup.StrengthenItemPageView";
require "main.common.effectdisplay.strengthen.StrengthenEffect";

StrengthenPopup=class(LayerPopableDirect);

function StrengthenPopup:ctor()
  self.class=StrengthenPopup;
end

function StrengthenPopup:dispose()
  self.armature.display:getChildByName("effect"):stopAllActions();
  StrengthenPopup.superclass.dispose(self);
end

function StrengthenPopup:onDataInit()
  self.strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.equipmentInfoProxy = self:retrieveProxy(EquipmentInfoProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.skeleton = self.strengthenProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton, "strengthen_ui");
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);

  self.channel_buttons={};
  self.selected_button_num=0;
  self.leftList_pos=makePoint(56,80);
  self.leftList_view_size=makeSize(185,520);
  self.leftList_item_size=makeSize(180,80);

  self.bagList_grid_skew=makeSize(140,140);
  self.bagList_grid_column=3;
  self.bagList_grid_row=2;
  self.bagList_grid_count=self.bagList_grid_column*self.bagList_grid_row;
  self.bagList_pos=makePoint(669,70);

  self.pageButton_skew_x=40;

  self.leftList=nil;

  self.bagList=nil;

  self.bagListPageButtonsLayer=nil;
  self.bagListPageButtons={};

  self.bagItemSelected=nil;
end

function StrengthenPopup:onPrePop()
  self:changeWidthAndHeight(1280,720);

  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_2"):setScaleX(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_1_2"):setScaleX(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_2_2"):setScaleX(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_3_2"):setScaleX(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_4"):setScaleY(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2"):setScaleY(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_2_2"):setScaleY(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleX(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2_copy_1"):setScaleY(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_2_2_copy"):setScaleY(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2_copy_2"):setScaleY(-1);
  -- self.armature.display:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleY(-1);
  self.armature.display:setPositionXY(75,15);

  local chat_channel_button=self.armature.display:getChildByName("tabBtn1");
  local chat_channel_button_1=self.armature.display:getChildByName("tabBtn2");
  local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
  local chat_channel_button_text_data=self.armature:findChildArmature("tabBtn1"):getBone("common_tab_button").textData;
  local chat_channel_button_skew=chat_channel_button_1:getPositionY()-chat_channel_button:getPositionY();
  self.armature.display:removeChild(chat_channel_button);
  self.armature.display:removeChild(chat_channel_button_1);

  local a=1;
  local s={"雄\n英","包\n背"};
  while 3>a do
    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("commonButtons/common_tab_button_normal","commonButtons/common_tab_button_down",CommonButtonTouchable.CUSTOM);
    -- chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
    chat_channel_button:initializeBMText(s[a],"anniutuzi");
    chat_channel_button:setPositionXY(chat_channel_button_pos.x,(-1+a)*chat_channel_button_skew+chat_channel_button_pos.y);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
    chat_channel_button:setVisible(false);
    self.armature.display:addChild(chat_channel_button);
    table.insert(self.channel_buttons, chat_channel_button);
    a=1+a;
  end

  --common_small_blue_button
  local common_small_blue_button=self.armature.display:getChildByName("common_small_blue_button");
  local common_small_blue_button_pos=convertBone2LB4Button(common_small_blue_button);
  self.armature.display:removeChild(common_small_blue_button);

  local common_small_blue_button=CommonButton.new();
  common_small_blue_button:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  -- common_small_blue_button:initializeText(self.armature:findChildArmature("common_small_blue_button"):getBone("common_small_blue_button").textData,"一键强化");
  common_small_blue_button:initializeBMText("一键强化","anniutuzi");
  common_small_blue_button:setPosition(common_small_blue_button_pos);
  common_small_blue_button:addEventListener(DisplayEvents.kTouchTap,self.onStrengthenToTopTap,self);
  self.armature.display:addChild(common_small_blue_button);
  self.strengthenToTopButton=common_small_blue_button;

  --common_small_blue_button0
  local common_small_blue_button0=self.armature.display:getChildByName("common_small_blue_button0");
  local common_small_blue_button0_pos=convertBone2LB4Button(common_small_blue_button0);
  self.armature.display:removeChild(common_small_blue_button0);

  local common_small_blue_button0=CommonButton.new();
  common_small_blue_button0:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  -- common_small_blue_button0:initializeText(self.armature:findChildArmature("common_small_blue_button0"):getBone("common_small_blue_button").textData,"强 化");
  common_small_blue_button0:initializeBMText("强 化","anniutuzi");
  common_small_blue_button0:setPosition(common_small_blue_button0_pos);
  common_small_blue_button0:addEventListener(DisplayEvents.kTouchTap,self.onStrengthenTap,self);
  self.armature.display:addChild(common_small_blue_button0);
  self.strengthenButton=common_small_blue_button0;

  local text="空";
  self.null_descb=createTextFieldWithTextData(self.armature:getBone("null_descb").textData,text);
  self.armature.display:addChild(self.null_descb);
end

function StrengthenPopup:onUIInit()
  self.level_descb=createTextFieldWithTextData(self.armature:getBone("level_descb").textData,"");
  self.armature.display:addChild(self.level_descb);

  self.prop_descb=createTextFieldWithTextData(self.armature:getBone("prop_descb").textData,"");
  self.armature.display:addChild(self.prop_descb);

  self.silver_descb=createTextFieldWithTextData(self.armature:getBone("silver_descb").textData,"");
  self.armature.display:addChild(self.silver_descb);

  self.level_s_descb=createTextFieldWithTextData(self.armature:getBone("level_s_descb").textData,"");
  self.armature.display:addChild(self.level_s_descb);

  self.prop_s_descb=createTextFieldWithTextData(self.armature:getBone("prop_s_descb").textData,"");
  self.armature.display:addChild(self.prop_s_descb);

  local effect = self.armature.display:getChildByName("effect");
  local size = effect:getContentSize(effect);
  effect:setAnchorPoint(ccp(0.5,0.5));
  effect:setPositionXY(size.width/2+effect:getPositionX(),-size.height/2+effect:getPositionY());
  local rotateBy = CCRepeatForever:create(CCRotateBy:create(5, 360));
  effect:runAction(rotateBy);
  self:onChannelButtonTap(nil,1);

  local size = Director:sharedDirector():getWinSize();
  local bg = LayerColorBackGround:getCustomBackGround(size.width, size.height, 190);
  bg:setPositionXY(GameData.uiOffsetX,-GameData.uiOffsetY);
  self:addChildAt(bg,0);
end

function StrengthenPopup:onRequestedData()
  
end

function StrengthenPopup:onUIClose()
  self:dispatchEvent(Event.new("strengthenClose",nil,self));
end

function StrengthenPopup:onPreUIClose()
  
end

function StrengthenPopup:onChannelButtonTap(event, num)
  if num == self.selected_button_num then
    return;
  end
  if self.channel_buttons[self.selected_button_num] then
    self.channel_buttons[self.selected_button_num]:select(false);
  end
  self.selected_button_num=num;
  self.channel_buttons[self.selected_button_num]:select(true);
  self:refreshLeftList();
end

function StrengthenPopup:refreshLeftList()
  self:removeLeftList();

  self.leftList=ListScrollViewLayer.new();
  self.leftList:initLayer();
  self.leftList:setPosition(self.leftList_pos);
  self.leftList:setViewSize(self.leftList_view_size);
  self.leftList:setItemSize(self.leftList_item_size);
  self.armature.display:addChild(self.leftList);

  if 1 == self.selected_button_num then
    self:refreshLeftListHero();
  elseif 2 == self.selected_button_num then
    self:refreshLeftListBag();
  end
end

function StrengthenPopup:refreshLeftListHero()
  local function sortFunc(data_a, data_b)
    if data_a.IsPlay > data_b.IsPlay then
      return true;
    elseif data_a.IsPlay < data_b.IsPlay then
      return false;
    elseif data_a.Level > data_b.Level then
      return true;
    else
      return false;
    end
  end
  local data = self.heroHouseProxy:getGeneralArray();--getAllHeroEquipped();
  table.sort(data, sortFunc);
  local _count = 0;
  local _item;
  while table.getn(data) > _count do
    _count = _count + 1;

    local item = StrengthenItem.new();
    item:initializeHero(self, data[_count]);
    self.leftList:addItem(item);
    if not _item then
      _item = item;
    end
  end
  if _item then
    _item:onSelfTap(true);
  end

  if 0 == table.getn(data) then
    self.null_descb:setVisible(true);
    self:refreshRightListBag({});
  end
end

function StrengthenPopup:refreshLeftListBag()
  local _count = 1;
  local _item;
  while 7 > _count do
    local item = StrengthenItem.new();
    item:initializeBag(self, _count);
    self.leftList:addItem(item);
    if not _item then
      _item = item;
    end
    _count = _count + 1;
  end
  _item:onSelfTap(true);
end

function StrengthenPopup:onLeftListItemTap(item)
  if 1 == self.selected_button_num then
    self:onLeftListHeroItemTap(item);
  elseif 2 == self.selected_button_num then
    self:onLeftListBagItemTap(item);
  end
end

function StrengthenPopup:onLeftListHeroItemTap(item)
  local data = item.data.UsingEquipmentArray;
  local bagDatas = {};
  for k,v in pairs(data) do
    local itemData = self.bagProxy:getItemData(v.UserEquipmentId);
    if itemData then
      table.insert(bagDatas, itemData);
    end
  end
  self:refreshRightListBag(bagDatas);
end

function StrengthenPopup:onLeftListBagItemTap(item)
  local data = self.bagProxy:getStrengthenItemsByPlaceId(item.id);
  local temp = {};
  for k,v in pairs(data) do
    if 0 == v.IsUsing then
      table.insert(temp, v);
    end
  end
  self:refreshRightListBag(temp);
--   self:refreshRightListBag({{UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},
-- {UserItemId=0,ItemId=1100001,Count=1,IsUsing=0,Place=0},});
end

function StrengthenPopup:refreshRightListHero(bagItemDatas)
  if self.bagList then
    self.armature.display:removeChild(self.bagList);
    self.bagList=nil;
  end
end

function StrengthenPopup:refreshRightListBag(bagItemDatas)
  self:removeBagList();

  self.bagItemDatas4BagList = bagItemDatas;
  local _item_count=table.getn(bagItemDatas);
  local _page_count=math.ceil(_item_count/6);

  self.armature.display:getChildByName("arrow_1"):setVisible(0 < _item_count);
  self.armature.display:getChildByName("arrow_2"):setVisible(0 < _item_count);

  -- self.bagList=GalleryViewLayer.new();
  -- self.bagList:initLayer();
  -- self.bagList:setContainerSize(makeSize(self.bagList_grid_skew.width*self.bagList_grid_column*_page_count,self.bagList_grid_skew.height*self.bagList_grid_row));
  -- self.bagList:setViewSize(makeSize(self.bagList_grid_skew.width*self.bagList_grid_column,self.bagList_grid_skew.height*self.bagList_grid_row));
  -- self.bagList:setMaxPage(_page_count);
  -- self.bagList:setDirection(kCCScrollViewDirectionHorizontal);
  -- local function flipFunc()
  --   for k,v in pairs(self.bagListPageButtons) do
  --     if v:getIsSelected() then
  --       v:select(false);
  --     end
  --   end
  --   self.bagListPageButtons[self.bagList:getCurrentPage()]:select(true);
  -- end
  -- self.bagList:addFlipPageCompleteHandler(flipFunc);
  -- self.bagList:setPosition(self.bagList_pos);
  -- self.armature.display:addChild(self.bagList);

  -- self.bagListPageButtonsLayer=Layer.new();
  -- self.bagListPageButtonsLayer:initLayer();

  -- local _count_page = 0;
  -- local _count_item = 0;
  -- local _bagItem = nil;
  -- while _page_count > _count_page do
  --   _count_page = 1 + _count_page;

  --   local layer = Layer.new();
  --   layer:initLayer();
  --   layer:setPositionX(self.bagList_grid_skew.width*self.bagList_grid_column*(-1+_count_page));
  --   layer:setContentSize(makeSize(self.bagList_grid_skew.width*self.bagList_grid_column,self.bagList_grid_skew.height*self.bagList_grid_row));
  --   self.bagList:addContent(layer);

  --   while _item_count > _count_item do
  --     _count_item = 1+ _count_item;

  --     local grid=self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid");
  --     grid:setPositionXY(self:grid2Mouse(_count_item));
  --     layer:addChild(grid);

  --     local bagItem=BagItem.new();
  --     bagItem:initialize(bagItemDatas[_count_item]);
  --     bagItem.touchEnabled=true;
  --     bagItem.touchChildren=true;
  --     bagItem:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
  --     bagItem:addEventListener(DisplayEvents.kTouchTap,self.onBagItemTap,self,bagItem);
  --     grid:addChild(bagItem);
  --     if not _bagItem then
  --       _bagItem=bagItem;
  --     end

  --     if self.bagList_grid_count * _count_page == _count_item then
  --       break;
  --     end
  --   end
    
  --   local pageButton=CommonButton.new();
  --   pageButton:initialize("commonButtons/common_page_button_normal","commonButtons/common_page_button_down",CommonButtonTouchable.DISABLE);
  --   pageButton:setPositionX(self.pageButton_skew_x*(-1+_count_page));
  --   self.bagListPageButtonsLayer:addChild(pageButton);
  --   table.insert(self.bagListPageButtons,pageButton);
  -- end

  -- local width = self.bagListPageButtonsLayer:getGroupBounds().size.width;
  -- self.bagListPageButtonsLayer:setPositionXY(925-width/2,150);
  -- self.armature.display:addChild(self.bagListPageButtonsLayer);
  -- if self.bagListPageButtons[1] then
  --   self.bagListPageButtons[1]:select(true);
  -- end
  local isHeroBag = 1 == self.selected_button_num;
  if isHeroBag then
    local function sort_func(data_a, data_b)
      return analysis("Zhuangbei_Zhuangbeipeizhibiao", data_a.ItemId, "place")
             < analysis("Zhuangbei_Zhuangbeipeizhibiao", data_b.ItemId, "place");
    end
    table.sort(self.bagItemDatas4BagList, sort_func);
  end

  self.bagList=StrengthenItemPageView.new(CCPageView:create());
  self.bagList:initialize(self, _item_count, isHeroBag);
  self.bagList:setMoveEnabled(not isHeroBag);
  self.bagList:setPosition(self.bagList_pos);
  self.pageControl = self.bagList.pageViewControl;
  if self.pageControl and not isHeroBag then
    -- self.pageControl:setPositionXY(890-self.pageControl:getGroupBounds().size.width/2,130);
    -- self.armature.display:addChild(self.pageControl);
  end
  self.armature.display:addChildAt(self.bagList,20);
  local function onPageViewScrollStoped()
    self.bagList:onPageViewScrollStoped();
    self:refreshBagItemNumber();
  end
  self.bagList:registerScrollStopedScriptHandler(onPageViewScrollStoped);
  --item数量
  if self.item_number_textField then
    self.armature.display:removeChild(self.item_number_textField);
    self.item_number_textField = nil;
  end
  if not isHeroBag then
    self.item_number_textField=createTextFieldWithTextData(self.armature:getBone("bag_item_number").textData,"0 / 0");
    self.armature.display:addChild(self.item_number_textField);
    self:refreshBagItemNumber();
  end

  if _bagItem then
    --self:onBagItemTap(nil, _bagItem);
  end
end

--更新item数量
function StrengthenPopup:refreshBagItemNumber()
  if not self.item_number_textField then
    return;
  end
  local pages = math.ceil(table.getn(self.bagItemDatas4BagList)/9);
  if 0 == pages then
    pages = 1;
  end
  self.item_number_textField:setString(self.bagList:getCurrentPage() .. "/" .. pages);--self.context.bagProxy:getCountInBag() .. "/" .. self.placeOpened);
end

function StrengthenPopup:grid2Mouse(grid_number)
  grid_number=(grid_number-1)%self.bagList_grid_count;
  return grid_number%self.bagList_grid_column*self.bagList_grid_skew.width,math.floor((-1+self.bagList_grid_count-grid_number)/self.bagList_grid_column)*self.bagList_grid_skew.height;
end

function StrengthenPopup:onItemDetailLayerTap(event)
  self.itemDetailLayer:removeEventListener(DisplayEvents.kTouchBegin,self.onItemDetailLayerTap,self);
  self.itemDetailLayer.parent:removeChild(self.itemDetailLayer);
  self.itemDetailLayer=nil;
  self.equipDetailLayer.parent:removeChild(self.equipDetailLayer);
  self.equipDetailLayer=nil;
end

function StrengthenPopup:popDetail()
  self.itemDetailLayer=LayerColorBackGround:getTransBackGround();
  self.itemDetailLayer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.itemDetailLayer:addEventListener(DisplayEvents.kTouchBegin,self.onItemDetailLayerTap,self);
  self:addChild(self.itemDetailLayer);
  
  self.equipDetailLayer=EquipDetailLayer.new();
  self.equipDetailLayer:initialize(self.bagProxy:getSkeleton(), self.bagItemSelected, false);

  local size=self:getContentSize();
  local popupSize=self.equipDetailLayer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
  self.equipDetailLayer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  self:addChild(self.equipDetailLayer);
end

function StrengthenPopup:onBagItemTap(event, bagItem, isRefresh)
  if not isRefresh and bagItem and self.bagItemSelected and bagItem:getUserItemID() == self.bagItemSelected:getUserItemID() then
    self:popDetail();
    return;
  end
  self:removeBagItemSelected();

  self.bagItemSelected=bagItem:clone();
  self.bagItemSelected:setFrameVisible(false);
  self.bagItemSelected:setPositionXY(416,340);
  self.armature.display:addChild(self.bagItemSelected);

  local equipmentInfo=self.equipmentInfoProxy:getEquipmentInfo(bagItem:getUserItemID());
  local prop_name=analysis("Zhuangbei_Zhuangbeipeizhibiao",bagItem:getItemID(),"attribute");
  prop_name=analysis("Shuxing_Shuju",prop_name,"name");
  self.prop_name_cache = prop_name;
  self.prop_value_cache = self:getPropDescb(bagItem:getItemID(),equipmentInfo.StrengthenLevel);
  self.level_descb:setString("等级: " .. equipmentInfo.StrengthenLevel);
  self.prop_descb:setString(prop_name .. ": " .. self.prop_value_cache);
  self.silver_descb:setString("消耗银两: " .. self:getSilverDescb(1+equipmentInfo.StrengthenLevel));
  self.level_s_descb:setString((1+equipmentInfo.StrengthenLevel));
  self.prop_s_descb:setString("+ " .. self:getPropAddedNextLevel(bagItem:getItemID(),equipmentInfo.StrengthenLevel));
end

function StrengthenPopup:getPropDescb(itemID, level)
  local table_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemID);
  local prop = table_data.attribute;
  local prop_value = table_data.amount;
  local prop_name = analysis("Shuxing_Shuju",prop,"name");

  local _count = 0;
  local _prop_value_new = prop_value;
  -- while level > _count do
  --   _count = 1 + _count;
  --   _prop_value_new = analysis("Zhuangbei_Zhuangbeiqianghua",_count,"qiangN") + ( analysis("Zhuangbei_Zhuangbeiqianghua",_count,"qiangPer") / 100000 ) * prop_value + _prop_value_new;
  -- end
  local tb_data;
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",level) then
    tb_data = analysis("Zhuangbei_Zhuangbeiqianghua",level);
    _prop_value_new = tb_data.qiangN + ( tb_data.qiangPer / 100000 ) * prop_value + _prop_value_new;
  end

  return math.ceil(_prop_value_new);
end

function StrengthenPopup:getPropAddedNextLevel(itemID, level)
  -- local table_data = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemID);
  -- local prop = table_data.attribute;
  -- local prop_value = table_data.amount;
  -- local prop_name = analysis("Shuxing_Shuju",prop,"name");

  -- return math.ceil(analysis("Zhuangbei_Zhuangbeiqianghua",1+level,"qiangN") + (analysis("Zhuangbei_Zhuangbeiqianghua",1+level,"qiangPer") / 100000 ) * prop_value);
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",1 + level) then
    return self:getPropDescb(itemID, 1 + level) - self:getPropDescb(itemID, level);
  end
  return 0;
end

function StrengthenPopup:getSilverDescb(nextLevel)
  if analysisHas("Zhuangbei_Zhuangbeiqianghua",nextLevel) then
    return math.floor(analysis("Zhuangbei_Zhuangbeiqianghua",nextLevel,"cost")*analysis("Zhuangbei_Zhuangbeipeizhibiao",self.bagItemSelected:getItemID(),"level")/40);
  end
  return 0;
end

function StrengthenPopup:onStrengthenTap(event)
  if self.bagItemSelected then
    self:dispatchEvent(Event.new("onStrengthen",self.bagItemSelected:getUserItemID(),self));
  end
end

function StrengthenPopup:onStrengthenToTopTap(event)
  if self.bagItemSelected then
    self:dispatchEvent(Event.new("onStrengthenMax",self.bagItemSelected:getUserItemID(),self));
  end
end

function StrengthenPopup:refreshStrengthen(userEquipmentID, strengthenLevel, param1, param2)
  local value = self.prop_value_cache;
  self:onBagItemTap(nil, self.bagItemSelected, true);
  if 0 ~= param1 or 0 ~= param2 then
    -- local effect = cartoonPlayer(EffectConstConfig.STRENGTHEN_DOUBLE,ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2), 1);
    -- self.parent:addChild(effect);
    -- local effect = StrengthenEffect.new();
    -- effect:initialize(EffectConstConfig.STRENGTHEN_DOUBLE, self, makePoint(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2));
    sharedTextAnimateReward():animateStartByString("强化成功,暴击了呢~ " .. self.prop_name_cache .. "+" .. (self.prop_value_cache -value));
  else
    -- local effect = cartoonPlayer(EffectConstConfig.STRENGTHEN,ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2), 1);
    -- self.parent:addChild(effect);
    -- local effect = StrengthenEffect.new();
    -- effect:initialize(EffectConstConfig.STRENGTHEN, self, makePoint(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2));
    sharedTextAnimateReward():animateStartByString("强化成功~ " .. self.prop_name_cache .. "+" .. (self.prop_value_cache -value));
  end
end

function StrengthenPopup:removeLeftList()
  self.null_descb:setVisible(false);
  if self.leftList then
    self.armature.display:removeChild(self.leftList);
    self.leftList=nil;
  end
  self:removeBagList();
end

function StrengthenPopup:removeBagList()
  if self.pageControl then
    self.armature.display:removeChild(self.pageControl);
    self.pageControl=nil;
  end
  if self.bagList then
    self.armature.display:removeChild(self.bagList);
    self.bagList=nil;
  end
  if self.bagListPageButtonsLayer then
    self.armature.display:removeChild(self.bagListPageButtonsLayer);
    self.bagListPageButtonsLayer=nil;
    self.bagListPageButtons={};
  end
  self:removeBagItemSelected();

  self.armature.display:getChildByName("arrow_1"):setVisible(false);
  self.armature.display:getChildByName("arrow_2"):setVisible(false);

  StrengthenItemSlot:cleanCache();
end

function StrengthenPopup:removeBagItemSelected()
  if self.bagItemSelected then
    self.armature.display:removeChild(self.bagItemSelected);
    self.bagItemSelected=nil;
  end
  self.level_descb:setString("");
  self.prop_descb:setString("");
  self.silver_descb:setString("");
  self.level_s_descb:setString("");
  self.prop_s_descb:setString("");
end
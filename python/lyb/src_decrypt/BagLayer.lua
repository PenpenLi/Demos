require "main.view.bag.ui.bagPopup.BagItem";
require "main.view.bag.ui.bagPopup.CurrencyItem";
require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "core.controls.CommonLayer";
require "core.controls.CommonPopup";
require "core.controls.GalleryViewLayer";
require "core.display.ccTypes";
require "core.utils.CommonUtil";
require "main.view.bag.ui.bagPopup.BagItemPageView";
require "core.utils.ComponentUtils";

BagLayer=class(Layer);

function BagLayer:ctor()
  self.class=BagLayer;
end

function BagLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BagLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function BagLayer:initialize(context)
  self:initLayer();
  self.const_grid_column=4;
  self.const_grid_row=4;
  self.const_page_count=6;
  self.const_grid_count=self.const_grid_column*self.const_grid_row;
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.grids={};
  self.items={};
  self.grid_over={{},{},{},{}};
  self.placeOpened=0;
  self.isInBatchSell=false;
  self.inBatchSellItemDatas={};
  self.bagItemSlots={{},{},{},{}};
  self.dirty={0,0,0,0};

  self.tab_btns = {};
  self.tab_num = nil;
  self.scrollViews = {};

  
  --骨骼
  local armature=self.skeleton:buildArmature("bag_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  
  --text
  local trimButtonData=armature:findChildArmature("common_blue_button_1"):getBone("common_blue_button").textData;
  --item数量
  local itemNumberData=armature:getBone("bag_item_number").textData;
  
  armature=armature.display;
  self:addChild(armature);
  self.armature=armature;

  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_1_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_2_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_3_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_4"):setScaleY(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2"):setScaleY(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_2_2"):setScaleY(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleY(-1);

  --整理
  local button=armature:getChildByName("common_blue_button_1");
  local button_pos=convertBone2LB4Button(button);
  armature:removeChild(button);

  --批量出售
  local button_2=armature:getChildByName("common_blue_button_2");
  local button_2_pos=convertBone2LB4Button(button_2);
  armature:removeChild(button_2);
  
  --格子
  local grid=armature:getChildByName("common_grid");
  local grid_1=armature:getChildByName("common_grid_1");
  local grid_2=armature:getChildByName("common_grid_2");
  local grid_content_size=grid:getContentSize();
  self.const_grid_x,self.const_grid_y=convertBone2LB(grid).x,convertBone2LB(grid).y--grid:getPositionX(),grid:getPositionY();
  self.const_grid_width,self.const_grid_height=grid_content_size.width,grid_content_size.height;
  self.const_grid_skew_x,self.const_grid_skew_y=grid_1:getPositionX()-self.const_grid_x,self.const_grid_y-convertBone2LB(grid_2).y;--grid_2:getPositionY()-self.const_grid_y;
  armature:removeChild(grid);
  armature:removeChild(grid_1);
  armature:removeChild(grid_2);
  
  --锁
  local bagLock=armature:getChildByName("common_black_lock");
  self.const_lock_pad_x,self.const_lock_pad_y=convertBone2LB(bagLock).x-self.const_grid_x,convertBone2LB(bagLock).y-self.const_grid_y;--bagLock:getPositionX()-self.const_grid_x,bagLock:getPositionY()-self.const_grid_y;
  armature:removeChild(bagLock);
  
  --格子高亮
  local grid_over=armature:getChildByName("common_grid_over");
  self.const_grid_over_pad_x,self.const_grid_over_pad_y=convertBone2LB(grid_over).x-self.const_grid_x,convertBone2LB(grid_over).y-self.const_grid_y;--grid_over:getPositionX()-self.const_grid_x,grid_over:getPositionY()-self.const_grid_y;
  armature:removeChild(grid_over);
  
  --页
  -- local pageButton=armature:getChildByName("common_page_button");
  -- local pageButton_1=armature:getChildByName("common_page_button_1");
  -- local page_button_x,page_button_y=pageButton:getPositionX(),convertBone2LB4Button(pageButton).y;--pageButton:getPositionY();
  -- local page_button_pad_x=pageButton_1:getPositionX()-page_button_x;
  -- armature:removeChild(pageButton);
  -- armature:removeChild(pageButton_1);
  
  --页
  -- local page_button_count=0;
  -- self.pageButton={};
  -- while self.const_page_count>page_button_count do
  --   page_button_count=1+page_button_count;
    
  --   pageButton=CommonButton.new();
  --   pageButton:initialize("commonButtons/common_page_button_normal","commonButtons/common_page_button_down",CommonButtonTouchable.DISABLE);
  --   pageButton:setPositionXY((page_button_count-1)*page_button_pad_x+page_button_x,page_button_y);
  --   self:addChild(pageButton);
  --   table.insert(self.pageButton,pageButton);
  -- end
  -- self.pageButton[self:getPageSelect()]:select(true);
  
  --整理
  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("整理背包","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onTrimButtonTap,self);
  self:addChild(button);
  self.button=button;

  --批量出售
  button_2=CommonButton.new();
  button_2:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button_2:initializeText(trimButtonData,"批量出售");
  button_2:initializeBMText("批量出售","anniutuzi");
  button_2:setPosition(button_2_pos);
  button_2:addEventListener(DisplayEvents.kTouchTap,self.onBatchSellButtonTap,self);
  self:addChild(button_2);
  self.button_2=button_2;

  --item数量
  self.item_number_textField=createTextFieldWithTextData(itemNumberData,"0 / 0");
  self:addChild(self.item_number_textField);

  -- local closeButton = Button.new(self.armature4dispose:findChildArmature("common_close_button"), false);
  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.context.closeUI, self.context);

  local tab_btn_1=self.armature:getChildByName("tab_btn_1");
  local tab_btn_2=self.armature:getChildByName("tab_btn_2");
  local tab_btn_1_pos=convertBone2LB4Button(tab_btn_1);
  local tab_btn_1_text_data=self.armature4dispose:findChildArmature("tab_btn_1"):getBone("common_channel_button").textData;
  local tab_btn_1_skew=tab_btn_2:getPositionY()-tab_btn_1:getPositionY();
  armature:removeChild(tab_btn_1);
  armature:removeChild(tab_btn_2);

  local a=1;
  local s={"物\n宝","料\n材","片\n碎","石\n魂"};
  while 5>a do
    local tab_btn=CommonButton.new();
    tab_btn:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
    --tab_btn:initializeText(tab_btn_1_text_data,s[a]);
    tab_btn:initializeBMText(s[a],"anniutuzi",_,_,makePoint(26,50));
    tab_btn:setPositionXY(tab_btn_1_pos.x,(-1+a)*tab_btn_1_skew+tab_btn_1_pos.y);
    tab_btn:addEventListener(DisplayEvents.kTouchTap,self.onTabBTNTap,self,a);
    self.armature:addChildAt(tab_btn,-a+self.armature:getNumOfChildren());
    table.insert(self.tab_btns,tab_btn);
    a=1+a;
  end

  self.tab_btns[3]:setVisible(false);
  self.tab_btns[4]:setPosition(self.tab_btns[3]:getPosition());
end

function BagLayer:onTabBTNTap(event, num)
  if event then
    MusicUtils:playEffect(7,false);
  end
  if num == self.tab_num then
    return;
  end
  if self.tab_btns[self.tab_num] then
    self.tab_btns[self.tab_num]:select(false);
  end
  if self.scrollViews[self.tab_num] then
    self.scrollViews[self.tab_num]:setVisible(false);
  end
  self.tab_num = num;
  if 1 == self.tab_num then
    hecDC(3,2,2);
  elseif 2 == self.tab_num then
    hecDC(3,2,3);
  elseif 3 == self.tab_num then
    hecDC(3,2,4);
  elseif 4 == self.tab_num then
    hecDC(3,2,5);
  end
  self.tab_btns[self.tab_num]:select(true);
  for i=4,1,-1 do
  	if self.tab_num == i then

  	else
  		self.armature:removeChild(self.tab_btns[i],false);
  		self.armature:addChild(self.tab_btns[i]);
  	end
  end
  self.armature:removeChild(self.tab_btns[self.tab_num],false);
  self.armature:addChild(self.tab_btns[self.tab_num]);
  if not self.scrollViews[self.tab_num] then
    local scrollView=BagItemPageView.new(CCPageView:create());
    scrollView:initialize(self.context, self.tab_num);
    scrollView:setPositionXY(63,72);
    self.scrollViews[self.tab_num] = scrollView;
    local function onPageViewScrollStoped()
      scrollView:onPageViewScrollStoped();
      self:refreshBagItemNumber();
    end
    scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);
    local pageControl = scrollView.pageViewControl;
    if pageControl then
      --self.armature:addChild(pageControl);
    end
    -- self.buddy_count_text=TextField.new(CCLabelTTF:create("好友数:100/100",FontConstConfig.OUR_FONT,26));
    -- self.buddy_count_text:setPositionXY(890,75);
    -- layer:addChild(self.buddy_count_text);
    scrollView:update(self.context.bagProxy:getPageViewDatas(self.const_grid_count, self.tab_num));
    self.armature:addChildAt(self.scrollViews[self.tab_num],3);
    self.dirty[self.tab_num] = 0;
  end
  if 1 == self.dirty[self.tab_num] then
    self.scrollViews[self.tab_num]:update(self.context.bagProxy:getPageViewDatas(self.const_grid_count, self.tab_num));
    self.dirty[self.tab_num] = 0;
  end
  self:refreshBagItemNumber();
  self.scrollViews[self.tab_num]:setVisible(true);
end

function BagLayer:initializeGallery()

  self:onTabBTNTap(nil,1);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(70,725));
  layerColor:setPositionX(0);
  self.armature:addChildAt(layerColor,3);

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:setOpacity(0);
  layerColor:setContentSize(makeSize(120,725));
  layerColor:setPositionX(520);
  self.armature:addChildAt(layerColor,3);

  -- --翻页
  -- self.scrollView=GalleryViewLayer.new();
  -- self.scrollView:initLayer();
  -- self.scrollView.touchEnabled=false;
  -- self.scrollView.touchChildren=false;
  -- self.scrollView:setTouchEnabled(false);
  -- self.scrollView:setContainerSize(makeSize(self.const_grid_skew_x*self.const_grid_column*self.const_page_count,self.const_grid_skew_y*self.const_grid_row));
  -- self.scrollView:setViewSize(makeSize(self.const_grid_skew_x*self.const_grid_column,self.const_grid_skew_y*self.const_grid_row));
  -- self.scrollView:setMaxPage(self.const_page_count);
  -- self.scrollView:setDirection(kCCScrollViewDirectionHorizontal);
  -- self.scrollView:setPositionXY(self.const_grid_x,self.const_grid_y-self.const_grid_skew_y*(-1+self.const_grid_row));--self.const_grid_x,self.const_grid_y);
  -- self:addChild(self.scrollView);
  
  -- --翻页layer
  -- self.grid_layers={};
  -- local page_count=0;
  -- while self.const_page_count>page_count do
  --   page_count=1+page_count;
    
  --   local grid_layer=Layer.new();
  --   grid_layer:initLayer();
  --   grid_layer:setContentSize(makeSize(self.const_grid_skew_x*self.const_grid_column,self.const_grid_skew_y*self.const_grid_row));
  --   grid_layer:setPositionXY(self.const_grid_skew_x*self.const_grid_column*(page_count-1),0);
  --   grid_layer.touchEnabled=false;
  --   grid_layer.touchChildren=false;
  --   self.scrollView:addContent(grid_layer);
  --   table.insert(self.grid_layers,grid_layer);
  -- end
  
  -- --格子
  -- local grid_count=0;
  -- while self.const_grid_count*self.const_page_count>grid_count do
  --   grid_count=1+grid_count;
    
  --   grid=self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid");
  --   bagLock=self.skeleton:getCommonBoneTextureDisplay("commonImages/common_black_lock");
  --   bagLock:setPositionXY(self.const_lock_pad_x,self.const_lock_pad_y);
  --   grid:addChild(bagLock);
  --   grid:setPositionXY(self:grid2Mouse(grid_count));
  --   print("grid:setPositionXY",grid_count,self:grid2Mouse(grid_count));
  --   self:getGridLayerByPlace(grid_count):addChild(grid);
  -- end

  -- --touchLayer  
  -- self.touchLayer=CommonLayer.new();
  -- self.touchLayer:initialize(self.const_grid_column*self.const_grid_skew_x,self.const_grid_row*self.const_grid_skew_y,self,self.onTouchLayerBegin,self.onTouchLayerTap,self.onTouchLayerScroll);
  -- self.touchLayer:setPosition(self.scrollView:getPosition());
  -- self:addChild(self.touchLayer);
end

function BagLayer:removeGallery()
  for k,v in pairs(self.scrollViews) do
    self.armature:removeChild(v);
  end
  self.scrollViews={};
end

--高亮
function BagLayer:addGridOver(tab_num, place)
  local grid_over=self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_over");
  -- local x,y=self:grid2Mouse(place);
  -- grid_over:setPositionXY(self.const_grid_over_pad_x+x,self.const_grid_over_pad_y+y);
  -- self:getGridLayerByPlace(place):addChild(grid_over);
  grid_over:setPositionXY(self.const_grid_over_pad_x,self.const_grid_over_pad_y);
  for k,v in pairs(self.bagItemSlots[tab_num]) do
    if place == v:getID() then
      v:addGridOver(grid_over);
      break;
    end
  end
  table.insert(self.grid_over[tab_num],grid_over);
end

function BagLayer:removeGridOverByPlace(tab_num, place)
  for k,v in pairs(self.bagItemSlots[tab_num]) do
    if place == v:getID() then
      local grid_over = v:getGridOver();
      for k_,v_ in pairs(self.grid_over[tab_num]) do
        if grid_over == v_ then
          table.remove(self.grid_over,k_);
          break;
        end
      end
      v:removeGridOver();
      break;
    end
  end
end

--道具层
function BagLayer:getGridLayerByPlace(place)
  return self.grid_layers[self:getGridLayerNumberByPlace(place)];
end

function BagLayer:getGridLayerNumberByPlace(place)
  return 1+math.floor((place-1)/self.const_grid_count);
end

--获得道具
function BagLayer:getItemByPlace(place)
  for k,v in pairs(self.items) do
    local itemData=v:getItemData();
    if place==itemData.Place then
      return v;
    end
  end
  return nil;
end

--获得道具
function BagLayer:getItemByUIIDAndIID(userItemID,itemID)
  for k,v in pairs(self.items) do
    local itemData=v:getItemData();
    if userItemID==itemData.UserItemId and itemID==itemData.ItemId then
      return v;
    end
  end
end

--页
function BagLayer:getPageSelect()
  if self.scrollView then
    return self.scrollView:getCurrentPage();
  end
  return 1;
end

--grid2Mouse
function BagLayer:grid2Mouse(grid_number)
  grid_number=(grid_number-1)%self.const_grid_count;
  return grid_number%self.const_grid_column*self.const_grid_skew_x,math.floor((-1+self.const_grid_count-grid_number)/self.const_grid_column)*self.const_grid_skew_y;--math.floor(grid_number/self.const_grid_column)*self.const_grid_skew_y;
end

function BagLayer:locateToGridByItemID(itemID)
  local xPos, yPos
  for k,v in pairs(self.items) do
    if itemID==v:getItemData().ItemId then
      xPos, yPos=self:grid2Mouse(v:getItemData().Place);
      xPos=self.scrollView:getPositionX()+xPos;
      yPos=self.scrollView:getPositionY()+yPos;
      self:onTouchLayerScroll(self:getGridLayerNumberByPlace(v:getItemData().Place)-self:getPageSelect());
      break;
    end
  end
  return xPos, yPos;
end

--mouse2Grid
function BagLayer:mouse2Grid(x_number, y_number)
  if 0>x_number or 0>y_number then
    return 0;
  elseif self.const_grid_column*self.const_grid_skew_x<=x_number then
    return 0;
  elseif self.const_grid_row*self.const_grid_skew_y<=y_number then
    return 0;
  elseif x_number%self.const_grid_skew_x>self.const_grid_width then
    return 0;
  elseif y_number%self.const_grid_skew_y>self.const_grid_height then
    return 0;
  end
  
  local a=math.floor(x_number/self.const_grid_skew_x);
  local b=math.floor(y_number/self.const_grid_skew_y);
  return 1+self.const_grid_count*(self:getPageSelect()-1)+a+self.const_grid_column*(-1+self.const_grid_row-b);--1+self.const_grid_count*(self:getPageSelect()-1)+a+self.const_grid_column*b;
end

function BagLayer:closeCurrencyBgTip(event)
  if self.currency_bg then
    self.parent.parent:removeChild(self.currency_bg);
    self.currency_bg=nil;
  end
  if self.currencyItem then
    self.parent.parent:removeChild(self.currencyItem);
    self.currencyItem=nil;
  end
end

--onLocalTap
function BagLayer:onLocalTap(tg, x_number, y_number)
  x_number=GameData.uiOffsetX+x_number;
  y_number=GameData.uiOffsetY+y_number;
  local a=tg:convertToNodeSpace(CCPoint(x_number,y_number));
  return a.x,a.y;
end

--onSelfEnd
function BagLayer:onSelfEnd(event)
  self.parent:removeEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
  self.parent:removeEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
  local place=self:mouse2Grid(self:onLocalTap(self.touchLayer,event.globalPosition.x,event.globalPosition.y));
  local pos_x,pos_y=self.parent.avatarLayer:onLocalTap(self.parent.avatarLayer,event.globalPosition.x,event.globalPosition.y);
  local avatarPlace=self.parent.avatarLayer:getPlaceByPosition(pos_x,pos_y);
  if 0==place then
    -- 拖动取消
    -- if self.parent.avatarLayer:isEqual(self.dragItem,avatarPlace) then

    --   local occupation=analysis("Zhuangbei_Zhuangbeibiao",self.dragItem:getItemData().ItemId,"occupation");
    --   local lv=analysis("Zhuangbei_Zhuangbeibiao",self.dragItem:getItemData().ItemId,"lv");
    --   if occupation==self.parent.userProxy:getCareer() or 5==occupation then

    --     if lv<=self.parent.generalListProxy:getLevel() then
    --       local data={GeneralId=self.parent.userProxy:getUserID(),
    --                   UserEquipmentId=self.dragItem:getItemData().UserItemId,
    --                   Place=0,
    --                   BooleanValue=1==self.dragItem:getItemData().IsUsing and 0 or 1};
    --       self.parent:dispatchEvent(Event.new("avatarEquipOnOff",data,self.parent));
    --     else
    --       local a=CommonPopup.new();
    --       a:initialize("等级不符哦!",nil,nil,nil,nil,nil,true);
    --       self.parent:addChild(a);
    --     end

    --   else
    --     local a=CommonPopup.new();
    --     a:initialize("职业不符哦!",nil,nil,nil,nil,nil,true);
    --     self.parent:addChild(a);
    --   end

    -- end
  elseif self.placeOpened<place then
    
  elseif place==self.dragItem:getItemData().Place then
    
  else
    local table = {["SrcPlace"] = self.dragItem:getItemData().Place,["TargetPlace"]=place};
    self.parent:dispatchEvent(Event.new("bagItemChagePlace",table,self.parent));
  end
  self.parent:removeChild(self.dragItem);
  self.dragItem=nil;
  
  self:removeGridOver();
  self.parent.avatarLayer:removeGridOver();
end

--onSelfMove
function BagLayer:onSelfMove(event)
  self.dragItem:setPositionXY(self:onLocalTap(self.parent,event.globalPosition.x,event.globalPosition.y));
end

--onTouchLayerBegin
function BagLayer:onTouchLayerBegin(x, y)
  -- 道具移动取消
  -- local place=self:mouse2Grid(self:onLocalTap(self.touchLayer,x,y));
  -- print("place...",place);
  -- if 0==place then
  --   return;
  -- end
  -- self.dragItem=self:getItemByPlace(place);
  -- if self.dragItem then
  --   self.dragItem=self.dragItem:clone();
  --   self.dragItem:setPositionXY(self:onLocalTap(self.parent,x,y));
  --   self.parent:addChild(self.dragItem);
  --   self.parent:addEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
  --   self.parent:addEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
    
  --   self:addGridOver(place);
  --   拖动取消
  --   self.parent.avatarLayer:addGridOver(self.dragItem);
  -- end
end

--onTouchLayerScroll
function BagLayer:onTouchLayerScroll(a)
  -- self.pageButton[self:getPageSelect()]:select(false);
  -- self.scrollView:setPage(a+self.scrollView:getCurrentPage(),true);
  -- self.pageButton[self:getPageSelect()]:select(true);
end

--onTouchLayerTap
-- function BagLayer:onTouchLayerTap(x, y)
--   local place=self:mouse2Grid(self:onLocalTap(self.touchLayer,x,y));
--   print("place..",place);
--   if 0==place then
--     return;
--   end
--   local tapItem=self:getItemByPlace(place);
--   if self.isInBatchSell then
--     if tapItem then
--       table.insert(self.inBatchSellItemDatas,tapItem:getItemData());
--       self:addGridOver(place);
--       return;
--     else
--       return;
--     end
--   end
--   if tapItem then
--     self.parent:onItemTap(tapItem:clone(),true,tapItem);
--   elseif self.placeOpened<place then
--     self:openPlace(place);
--   end
-- end

function BagLayer:onTouchLayerTap(bagItemSlot, tab_num)
  local place=bagItemSlot:getID();
  local tapItem=bagItemSlot:getBagItem();
  local lock=bagItemSlot:getLock();

  if self.isInBatchSell then
    if tapItem then
      for k,v in pairs(self.inBatchSellItemDatas) do
        if v.UserItemId == tapItem:getItemData().UserItemId then
          table.remove(self.inBatchSellItemDatas,k);
          self:removeGridOverByPlace(tab_num, place);
          return;
        end
      end
      if 0 == analysis("Daoju_Daojubiao",tapItem:getItemData().ItemId,"price") then
        sharedTextAnimateReward():animateStartByString("这个道具不能出售呢");
        return;
      end
      print("userItemId->",tapItem:getItemData().UserItemId);
      table.insert(self.inBatchSellItemDatas,tapItem:getItemData());
      self:addGridOver(tab_num, place);
      return;
    else
      return;
    end
  end
  if tapItem then
    self.parent:onItemTap(tapItem,true);
  elseif lock then
    self:openPlace(place);
  end
end

function BagLayer:refreshButton()
  if self.isInBatchSell then
    self.button:refreshText("取消出售");
    self.button_2:refreshText("确定出售");
  else
    self.button:refreshText("整理背包");
    self.button_2:refreshText("批量出售");
  end
end

--整理
function BagLayer:onTrimButtonTap()
  if self.isInBatchSell then
    self.isInBatchSell=false;
    self.inBatchSellItemDatas={};
    self:refreshButton();
    self:removeGridOver();
    return;
  end
  if nil==self.trim_button_tap then
    self.parent:dispatchEvent(Event.new("bagItemTrim",nil,self.parent));
    self.trim_button_tap=true;
  end
end

function BagLayer:onBatchSellConfirm()
  -- error("");
  print("BagLayer:onBatchSellConfirm");
  self:removeGridOver();
  local data={};
  data.UserItemIdArray={};
  for k,v in pairs(self.inBatchSellItemDatas) do
    print("sellUserItemId->",v.UserItemId);
    table.insert(data.UserItemIdArray,{UserItemId=v.UserItemId,Count=v.Count});
  end
  self.inBatchSellItemDatas={};
  self.context:dispatchEvent(Event.new(BagPopupNotifications.BAG_BATCH_SELL,data,self.context));
end

function BagLayer:onBatchSellCancel()
  -- error("");
  print("BagLayer:onBatchSellCancel");
  self:removeGridOver();
  self.inBatchSellItemDatas={};
end

function BagLayer:onBatchSellButtonTap()
  if self.isInBatchSell then

    self.isInBatchSell=false;
    self:refreshButton();
    -- self:removeGridOver();

    if 0==table.getn(self.inBatchSellItemDatas) then
      sharedTextAnimateReward():animateStartByString("没有选择出售的物品呢");
      return;
    end
    local silver = 0;
    for k,v in pairs(self.inBatchSellItemDatas) do
      silver = analysis("Daoju_Daojubiao",v.ItemId,"price") * v.Count + silver;
    end
    local commonPopup=CommonPopup.new();
    commonPopup:initialize("售出的物品可以获得银两" .. silver .. "，确定出售吗？",self,self.onBatchSellConfirm,nil,self.onBatchSellCancel,nil,true,{"确定出售","取消出售"},nil,true,CommonPopupCloseButtonPram.CANCLE);
    self.parent.parent.parent:addChild(commonPopup);
  else
    self.isInBatchSell=true;
    self:refreshButton();
  end
end

--开格子
function BagLayer:openPlace(place)
  if nil==self.open_place then
    local a=self.placeOpened;
    while place>a do
      a=a+1;
      self:addGridOver(a);
    end
    local b=CommonPopup.new();
    local c=place-self.placeOpened;
    local d=c*analysis("Xishuhuizong_Xishubiao",1015,"constant");
    local id=self.parent.userProxy:getIsVip() and PopupMessageConstConfig.ID_297 or PopupMessageConstConfig.ID_17;
    b:initialize(StringUtils:getString4Popup(id,{d,c}),self,self.onOpenPlaceConfirm,place,self.removeGridOver,nil,false,StringUtils:getButtonString4Popup(id));
    self.parent:addChild(b);
  end
end

function BagLayer:onOpenPlaceConfirm(place)
  local c=place-self.placeOpened;
  local d=c*analysis("Xishuhuizong_Xishubiao",1015,"constant");
  if nil==self.userCurrency or d>self.userCurrency:getGold() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_18));
    self.parent:dispatchEvent(Event.new("vip_recharge",nil,self.parent));
    self:removeGridOver();
  else
    self:openPlaceConfirm(place);
  end
end

function BagLayer:openPlaceConfirm(place)
  self:removeGridOver();
  self.parent:dispatchEvent(Event.new("bagOpenPlace",place,self.parent));
  self.open_place=true;
end

--更新道具
function BagLayer:refreshBagData(data, booleanValue)
  if nil==data then
    return;
  end
  -- if 1==booleanValue then
  --   for k,v in pairs(self.items) do
  --     local place=v:getItemData().Place;
  --     self:getGridLayerByPlace(place):removeChild(v);
  --   end
  --   self.items={};
  --   for k,v in pairs(data) do
  --     if 0==v.Count or 1==v.IsUsing or 0==v.Place or self.placeOpened<v.Place then
        
  --     else
  --       local bagItem=BagItem.new();
  --       bagItem:initialize(v,true,self.parent.bagProxy);
  --       local pos_x,pos_y=self:grid2Mouse(v.Place);
  --       bagItem:setPositionXY(pos_x+ConstConfig.CONST_GRID_ITEM_SKEW_X,pos_y+ConstConfig.CONST_GRID_ITEM_SKEW_Y);
  --       local place=bagItem:getItemData().Place;
  --       self:getGridLayerByPlace(place):addChild(bagItem);
  --       table.insert(self.items,bagItem);
  --     end
  --   end
  -- else
  --   for k,v in pairs(data) do
  --     self:refreshBagDataItem(v);
  --   end
  -- end

  -- local slots = {};
  -- for k,v in pairs(data) do
  --   slots[v.Place] = true;
  --   for _k,_v in pairs(self.bagItemSlots) do
  --     local bagItem = _v:getBagItem(); 
  --     if bagItem and bagItem:getItemData().UserItemId == v.UserItemId then
  --       slots[v.Place] = true;
  --       break;
  --     end
  --   end
  -- end
  -- for k,v in pairs(self.bagItemSlots) do
  --   if slots[v:getID()] then
  --     v:setSlotData(v:getID());
  --   end
  -- end
  self.scrollViews[self.tab_num]:update(self.context.bagProxy:getPageViewDatas(self.const_grid_count, self.tab_num));
  for k,v in pairs(self.dirty) do
    if self.tab_num == k then
      self.dirty[k] = 0;
    else
      self.dirty[k] = 1;
    end
  end
  self.trim_button_tap=nil;
  self:refreshBagItemNumber();
end

--更新道具
function BagLayer:refreshBagDataItem(data)
  local uid=data.UserItemId;
  local id=data.ItemId;
  for k,v in pairs(self.items) do
    local itemData=v:getItemData();
    if uid==itemData.UserItemId and id==itemData.ItemId then
      if 0==itemData.Count or 1==data.IsUsing or 0==data.Place or self.placeOpened<data.Place then
        v.parent:removeChild(v);
        table.remove(self.items,k);
      else
        v:refreshData();
        v.parent:removeChild(v,false);
        local pos_x,pos_y=self:grid2Mouse(itemData.Place);
        local place=itemData.Place;
        self:getGridLayerByPlace(place):addChild(v);
        v:setPositionXY(pos_x+ConstConfig.CONST_GRID_ITEM_SKEW_X,pos_y+ConstConfig.CONST_GRID_ITEM_SKEW_Y);
      end
      return;
    end
  end
  if 0==data.Count or 1==data.IsUsing or 0==data.Place or self.placeOpened<data.Place then
    
  else
    local bagItem=BagItem.new();
    bagItem:initialize(data,true,self.parent.bagProxy);
    local pos_x,pos_y=self:grid2Mouse(data.Place);
    bagItem:setPositionXY(pos_x+ConstConfig.CONST_GRID_ITEM_SKEW_X,pos_y+ConstConfig.CONST_GRID_ITEM_SKEW_Y);
    local place=bagItem:getItemData().Place;
    self:getGridLayerByPlace(place):addChild(bagItem);
    table.insert(self.items,bagItem);
  end
end

function BagLayer:refreshBagDelete(data)
  for k,v in pairs(data) do
    self:refreshBagDeleteItem(v);
  end
  self:refreshBagItemNumber();
end

function BagLayer:refreshBagDeleteItem(data)
  local uid=data.UserItemId;
  local id=data.ItemId;
  for k,v in pairs(self.items) do
    local itemData=v:getItemData();
    if uid==itemData.UserItemId and id==itemData.ItemId then
      v.parent:removeChild(v);
      table.remove(self.items,k);
      return;
    end
  end
end

--更新打造道具
function BagLayer:refreshBagDataByForge(userItemId)
  for k,v in pairs(self.items) do
    local itemData=v:getItemData();
    if userItemId==itemData.UserItemId then
      v:refreshData();
      break;
    end
  end
end

--更新item数量
function BagLayer:refreshBagItemNumber()
  local pages = self.scrollViews[self.tab_num]:getMaxPage();
  if 0 == pages then
    pages = 1;
  end
  self.item_number_textField:setString(self.scrollViews[self.tab_num]:getCurrentPage() .. "/" .. pages);--self.context.bagProxy:getCountInBag() .. "/" .. self.placeOpened);
end

--更新格子
function BagLayer:refreshBagPlace(itemUseQueueProxy)
  local count=itemUseQueueProxy:getPlaceOpenedCount();
  print("placeOpened------------",count);
  self.placeOpened=count;
  -- local a=0;
  -- while count>a do
  --   a=1+a;
    
  --   local grid=self:getGridLayerByPlace(a):getChildAt((a-1)%self.const_grid_count);
  --   if 0<grid:getNumOfChildren() then
  --    grid:removeChildren();
  --   end
  -- end
  self.open_place=nil;
  self:refreshBagItemNumber();
end

--高亮移除
function BagLayer:removeGridOver()
  for k,v in pairs(self.grid_over) do
    for k_,v_ in pairs(v) do
      if not v_.isDisposed then
        v_.parent:removeChild(v_);
      end
    end
  end
  self.grid_over={{},{},{},{}};
end
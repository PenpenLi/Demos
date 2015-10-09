require "core.controls.ListScrollViewLayer";
require "core.display.ccTypes";
require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.AccordionView";
require "core.controls.AccordionViewTab";
require "main.view.strengthen.ui.component.SrengthenAccordionItem";
require "main.view.strengthen.ui.component.SrengthenAccordionFollow";
require "main.view.strengthen.ui.component.SrengthenUI";
require "main.view.strengthen.ui.component.SrengthenJinjieUI";
-- require "main.view.strengthen.ui.strengthenPopup.StrengthenFormula";
-- require "main.view.strengthen.ui.strengthenPopup.StrengthenLayer";
-- require "main.view.strengthen.ui.strengthenPopup.StarAddLayer";
-- require "main.view.strengthen.ui.strengthenPopup.ForgeLayer";
-- require "main.view.strengthen.ui.strengthenPopup.GemLayer";
-- require "main.view.strengthen.ui.strengthenPopup.StrengthenItem";
-- require "main.view.strengthen.ui.strengthenPopup.DegradePopup";
-- require "main.view.strengthen.ui.strengthenPopup.StuffImg";
-- require "main.view.strengthen.ui.strengthenPopup.StuffTrackDetail";
require "main.view.bag.ui.bagPopup.EquipDetailLayer";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
-- require "main.view.strengthen.ui.strengthenPopup.StrengthenItemPageView";
require "main.common.effectdisplay.strengthen.StrengthenEffect";

StrengthenPopup=class(LayerPopableDirect);

function StrengthenPopup:ctor()
  self.class=StrengthenPopup;
end

function StrengthenPopup:dispose()
  -- self.armature.display:getChildByName("effect"):stopAllActions();
  self:removeChildren();
  StrengthenPopup.superclass.dispose(self);
  -- self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
  --CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end

function StrengthenPopup:setNotification(notification)
  self.notification = notification;
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
  self.strengthenProxy.Qianghua_Bool = nil;

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 1);
  layerPopableData:setArmatureInitParam(self.skeleton, "strengthen_ui");
  -- layerPopableData:setShowCurrency(true);
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);

  self.channel_buttons={};
  self.selected_button_num=0;
  self.panels = {};
  self.scroll_items = {};
  self.scroll_follows = {};
  self.scroll_tabs = {};
  self.scroll_item_select = nil;
end

function StrengthenPopup:onPrePop()
  self:changeWidthAndHeight(1280,720);

  local chat_channel_button=self.armature.display:getChildByName("tab_btn_1");
  local chat_channel_button_1=self.armature.display:getChildByName("tab_btn_2");
  local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
  local chat_channel_button_text_data=self.armature:findChildArmature("tab_btn_1"):getBone("common_channel_button").textData;
  local chat_channel_button_skew=chat_channel_button_1:getPositionY()-chat_channel_button:getPositionY();
  self.armature.display:removeChild(chat_channel_button);
  self.armature.display:removeChild(chat_channel_button_1);

  local a=1;
  local s={"化\n强","造\n打"};
  while 3>a do
    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
    -- chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
    chat_channel_button:initializeBMText(s[a],"anniutuzi",_,_,makePoint(26,50));
    chat_channel_button:setPositionXY(chat_channel_button_pos.x,(-1+a)*chat_channel_button_skew+chat_channel_button_pos.y);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
    self:addChild(chat_channel_button);
    table.insert(self.channel_buttons, chat_channel_button);
    a=1+a;
  end

  self.channel_buttons[2]:setVisible(self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_45));

  local closeButton =self.armature.display:getChildByName("close_btn");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);
  self.armature.display:removeChild(closeButton,false);
  self:addChild(closeButton);

  self.redDotsTabBTN = {};
  for i=1,2 do
    local redDot = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
    redDot.name = "effect";
    redDot:setPositionXY(65,125);
    redDot:setVisible(false);
    self.channel_buttons[i]:addChild(redDot);
    table.insert(self.redDotsTabBTN,redDot);
  end

  self.panels[1] = SrengthenUI.new();
  self.panels[1]:initialize(self);
  self:addChild(self.panels[1]);
  self.panels[1]:setVisible(false);
  self.panels[2] = SrengthenJinjieUI.new();
  self.panels[2]:initialize(self);
  self:addChild(self.panels[2]);
  self.panels[2]:setVisible(false);

  self.askBtn = Button.new(self.armature:findChildArmature("ask"),false,"");
  self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
end

function StrengthenPopup:onShowTip()
  -- MusicUtils:playEffect(7,false);
  local text=analysis("Tishi_Guizemiaoshu",5,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function StrengthenPopup:onUIInit()
  self.item_layer=AccordionView.new();
  self.item_layer:initLayer();

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
  local data = self.heroHouseProxy:getGeneralArrayByType(5);--getAllHeroEquipped();
  -- data = copyTable(data);
  -- table.sort(data, sortFunc);
  local _count = 0;
  local _item;
  local title_size = makeSize(390,72+5);self.title_size=title_size;
  local follow_size = makeSize(385,235);
  while table.getn(data) > _count do
    _count = _count + 1;

    local tab=AccordionViewTab.new(title_size,follow_size);
    tab:initLayer();
    local item=SrengthenAccordionItem.new();
    item:initialize(self,data[_count].GeneralId);
    local item_follow=SrengthenAccordionFollow.new();
    item_follow:initialize(self,data[_count].GeneralId);
    tab:addTitleDisplay(item);
    tab:addContentDisplay(item_follow);
    table.insert(self.scroll_items,item);
    table.insert(self.scroll_follows,item_follow);
    table.insert(self.scroll_tabs,tab);
    self.item_layer:addTab(tab);
  end

  self.scrollPane=ListScrollViewLayer.new();
  self.scrollPane:initLayer();
  self.scrollPane:setPositionXY(107,60);
  -- self.scrollPane:setDirection(kCCScrollViewDirectionVertical);
  -- self.scrollPane:setContentSize(makeSize(title_size.width,GameData.gameUIScaleRate*(follow_size.height+table.getn(data)*title_size.height)));
  self.scrollPaneViewSize = makeSize(title_size.width,-5+570);
  self.scrollPane:setViewSize(self.scrollPaneViewSize);
  -- self.scrollPane:setContentOffset(self.scrollPane:minContainerOffset());
  self.scrollPaneItemSize = makeSize(title_size.width,follow_size.height+table.getn(data)*title_size.height);
  self.scrollPane:setItemSize(self.scrollPaneItemSize);
  self.scrollPane:addItem(self.item_layer);
  self.armature.display:addChild(self.scrollPane);
  if self.scroll_items[1] then
    self:onScrollItemTap(nil,self.scroll_items[1]);
  end
  if self.notification and self.notification:getData() and self.notification:getData().TAB then
    self:onChannelButtonTap(nil, self.notification:getData().TAB);
  else
    self:onChannelButtonTap(nil, 1);
  end

  self:refreshRedDotTABBTN();
end

function StrengthenPopup:onScrollItemTap(event, scroll_item)
  for k,v in pairs(self.scroll_items) do
    if scroll_item==v then
      if self.scroll_item_select==self.scroll_tabs[k] then
        --self.scroll_item_select:expand(true);
        break;
      end
      if self.scroll_item_select then
        self.scroll_item_select:expand(false);
      end
      for k,v in pairs(self.scroll_follows) do
        v:setVisible(false);
      end
      self.scroll_item_select=self.scroll_tabs[k];
      self.scroll_item_select:expand(true);
      self.scroll_follows[k]:initBag();
      self.scroll_follows[k]:setVisible(true);
      if event then
        self.scroll_follows[k]:onScrollItemTap(nil, self.scroll_follows[k].bagItems[1]);
      end
      break;
    end
  end
end

function StrengthenPopup:refreshPanelByTrack()
  self:onBagItemTap(nil,self.bagItemSelected);
end

function StrengthenPopup:onBagItemTap(event, bagItem)
  self.bagItemSelected = bagItem;
  for k,v in pairs(self.panels) do
    if v:isVisible() then
      v:refresh(self.bagItemSelected);
    end
  end
end

function StrengthenPopup:onRequestedData()
  
end

function StrengthenPopup:onUIClose()
  self:dispatchEvent(Event.new("strengthenClose",nil,self));
end

function StrengthenPopup:onPreUIClose()
  
end

function StrengthenPopup:onChannelButtonTap(event, num)
  if GameVar.tutorStage == TutorConfig.STAGE_2010 then
    if not self.hasTab then
      self.hasTab = true;
    else
      openTutorUI({x=754, y=69, width = 190, height = 60, alpha = 125});      
    end
  end
  if num == self.selected_button_num then
    return;
  end
  if self.channel_buttons[self.selected_button_num] then
    self.channel_buttons[self.selected_button_num]:select(false);
  end
  if self.panels[self.selected_button_num] then
    self.panels[self.selected_button_num]:setVisible(false);
  end
  self.selected_button_num=num;
  self.channel_buttons[self.selected_button_num]:select(true);
  self:removeChild(self.channel_buttons[self.selected_button_num],false);
  self:addChild(self.channel_buttons[self.selected_button_num]);
  self.panels[self.selected_button_num]:setVisible(true);
  -- for k,v in pairs(self.scroll_follows) do
  --   v:refreshFGOnTab();
  -- end

  local function getFollowSelect()
    for k,v in pairs(self.scroll_tabs) do
      if self.scroll_item_select==v then
        return self.scroll_follows[k];
      end
    end
  end
  local function getFollowSelectByGeneralID(generalID)
    for k,v in pairs(self.scroll_follows) do
      if generalID==v.generalID then
        return v;
      end
    end
  end
  -- if 1 == num then
    if not SrengthenAccordionFollow:getBagItem() then
      if self.notification and self.notification:getData() and self.notification:getData().GeneralId and self.notification:getData().ItemId then 
        for k,v in pairs(self.scroll_items) do
          if self.notification:getData().GeneralId == v.generalID then
            self:onScrollItemTap(nil,v);
            local offset_y_min = self.scrollPaneViewSize.height - self.scrollPaneItemSize.height;
            local offset_y = (-1+k)*self.title_size.height+self.scrollPaneViewSize.height-self.scrollPaneItemSize.height;
            if 0<offset_y then
              offset_y = 0;
            elseif offset_y_min>offset_y then
              offset_y = offset_y_min;
            end
            self.scrollPane:setContentOffset(makePoint(0,offset_y));
            break;
          end
        end
        local follow = getFollowSelectByGeneralID(self.notification:getData().GeneralId);
        local bagItem = follow.bagItems[math.floor(self.notification:getData().ItemId/1000000)];
        follow:onScrollItemTap(nil, bagItem);
      else
        local follow = getFollowSelect();
        local bagItem = follow.bagItems[1];
        follow:onScrollItemTap(nil, bagItem);
      end
    else
      local follow = getFollowSelect();
      follow:onScrollItemTap(nil, follow:getBagItem());
    end

    self:refreshRedDotChannel();
  -- elseif 2 == num then
  --   if not SrengthenAccordionFollow:getBagItem() then
  --     local follow = getFollowSelect();
  --     local bagItem;
  --     for k,v in pairs(follow.bagItems) do
  --       if follow:getLevelIsEnough(k) then
  --         bagItem = follow.bagItems[k];
  --         break;
  --       end
  --     end
  --     if bagItem then
  --       follow:onScrollItemTap(nil, bagItem);
  --     end
  --   else
  --     local follow;
  --     local bagItem;
  --     for k,v in pairs(self.scroll_follows) do
  --       if v.generalID == SrengthenAccordionFollow:getBagItem():getItemData().GeneralId then
  --         follow = v;
  --         break;
  --       end
  --     end
  --     if follow:getLevelIsEnough(analysis("Zhuangbei_Zhuangbeipeizhibiao",SrengthenAccordionFollow:getBagItem():getItemData().ItemId,"place")) then
  --       follow:onScrollItemTap(nil, SrengthenAccordionFollow:getBagItem());
  --       return;
  --     end
  --     follow = getFollowSelect();
  --     for k,v in pairs(follow.bagItems) do
  --       if follow:getLevelIsEnough(k) then
  --         bagItem = follow.bagItems[k];
  --         break;
  --       end
  --     end
  --     follow:onScrollItemTap(nil, bagItem);
  --   end
  -- end
end

function StrengthenPopup:refreshStrengthen(generalId, itemId, strengthenLevel, param1, param2)
  local value = self.panels[1].prop_value_cache;
  for k,v in pairs(self.scroll_follows) do
    if generalId == v.generalID then
      v:refreshByJinjie(itemId);
      break;
    end
  end

  if 0 ~= param1 or 0 ~= param2 then
    -- local effect = cartoonPlayer(EffectConstConfig.STRENGTHEN_DOUBLE,ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2), 1);
    -- self.parent:addChild(effect);
    -- local effect = StrengthenEffect.new();
    -- effect:initialize(EffectConstConfig.STRENGTHEN_DOUBLE, self, makePoint(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2));
    local size = self:getContentSize();
    local effect = cartoonPlayer(1661,size.width/2, size.height/2);
    self:addChild(effect);

    local count = param1 + 2 * param2;
    count = 10 < count and 10 or count;
    if 0 < count then
      effect = cartoonPlayer(1755 + (-1 + count),size.width/2, size.height/2);
      self:addChild(effect);
    end
    
    -- if 0 ~= param1 and 0 ~= param2 then
    --   effect = cartoonPlayer(1660,size.width/2, size.height/2);
    --   self:addChild(effect);
    -- elseif 0 ~= param1 then
    --   effect = cartoonPlayer(1658,size.width/2, size.height/2);
    --   self:addChild(effect);
    -- elseif 0 ~= param2 then
    --   effect = cartoonPlayer(1659,size.width/2, size.height/2);
    --   self:addChild(effect);
    -- end
    --sharedTextAnimateReward():animateStartByString("强化成功,暴击了呢~ " .. self.panels[1].prop_name_cache .. "+" .. (self.panels[1].prop_value_cache -value));
  else
    -- local effect = cartoonPlayer(EffectConstConfig.STRENGTHEN,ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2), 1);
    -- self.parent:addChild(effect);
    -- local effect = StrengthenEffect.new();
    -- effect:initialize(EffectConstConfig.STRENGTHEN, self, makePoint(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2));
    
    local size = self:getContentSize();
    local effect = cartoonPlayer(1662,size.width/2, size.height/2);
    self:addChild(effect);

    --sharedTextAnimateReward():animateStartByString("强化成功~ " .. self.panels[1].prop_name_cache .. "+" .. (self.panels[1].prop_value_cache -value));
  end
end

function StrengthenPopup:refreshStrengthenToTop(generalId, itemId, strengthenLevel)
  for k,v in pairs(self.scroll_follows) do
    if generalId == v.generalID then
      v:refreshByJinjie(itemId);
      break;
    end
  end
end

function StrengthenPopup:refreshJinjie()
  -- sharedTextAnimateReward():animateStartByString("进阶成功了呢~");
  for k,v in pairs(self.scroll_follows) do
    if self.equipmentInfoProxy.jinjie_general_id_cache == v.generalID then
      v:refreshByJinjie(self.equipmentInfoProxy.jinjie_item_id_cache);
      break;
    end
  end

  local effect = cartoonPlayer(1088,GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2, 1);
  self.parent:addChild(effect);
end

function StrengthenPopup:refreshRedDot()
  self:refreshRedDotTABBTN();
  self:refreshRedDotChannel();
end

function StrengthenPopup:refreshRedDotTABBTN()
  local hongdianDatas = self.heroHouseProxy:getHongdianDatas();
  self.redDotsTabBTN[1]:setVisible(false);
  self.redDotsTabBTN[2]:setVisible(false);
  for k,v in pairs(hongdianDatas) do
    if v.BetterEquip then
      self.redDotsTabBTN[1]:setVisible(true);
    end
    if v.BetterJinjieEquip then
      self.redDotsTabBTN[2]:setVisible(true);
    end
  end
end

function StrengthenPopup:refreshRedDotChannel()
  for k,v in pairs(self.scroll_items) do
    v:refreshRedDot();
  end
  for k,v in pairs(self.scroll_follows) do
    v:refreshRedDot();
  end
end

function StrengthenPopup:popEquipDetail(event, bagItem)
  local tipBg=LayerColorBackGround:getOpacityBackGround();
  local layer=EquipDetailLayer.new();
  local function closeTip(event)
    tipBg.parent:removeChild(tipBg);
    layer.parent:removeChild(layer);
  end
  tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  tipBg:addEventListener(DisplayEvents.kTouchBegin,closeTip);
  self.parent:addChild(tipBg);
  layer:initialize(self.bagProxy:getSkeleton(),bagItem);
  local size=self:getContentSize();
  local popupSize=layer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  self.parent:addChild(layer);
end

function StrengthenPopup:refreshOn6_2(changeGeneralArray)
  local tmp = {};
  for k,v in pairs(recvTable["ChangeGeneralArray"]) do
    tmp[v.GeneralId]=v.GeneralId;
  end
  for k,v in pairs(self.scroll_items) do
    if tmp[v.generalID] then
      v:refreshOn6_2();
    end
  end
end
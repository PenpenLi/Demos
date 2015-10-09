require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.RichLabelTTF";
require "core.controls.FlexibleListScrollViewLayer";
require "core.controls.RichTextLineInput";
require "main.view.chat.ui.chatPopup.ChatLayer";
require "main.view.chat.ui.chatPopup.ChatLayerPop";
require "main.view.chat.ui.popLayer.ChatEquipDetailLayer";
require "core.display.LayerPopable";
require "main.config.ConstItemIDConfig";
require "main.view.chat.ui.chatPopup.ButtonsSelector";

ChatPopup=class(LayerPopableDirect);

function ChatPopup:ctor()
  self.class=ChatPopup;
end

function ChatPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ChatPopup.superclass.dispose(self);
  removeSchedule(self,self.refreshTimercf);

  BitmapCacher:removeUnused();
end

function ChatPopup:onDataInit()
  self.chatListProxy = self:retrieveProxy(ChatListProxy.name);
  self.buddyListProxy = self:retrieveProxy(BuddyListProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.equipmentInfoProxy = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  -- self.teamShadowProxy = self:retrieveProxy(TeamShadowProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.skeleton = self.chatListProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  self:setLayerPopableData(layerPopableData);

  self.refreshTime=0;log("???////////////----------"..GameData.gameUIScaleRate.." "..GameData.gameMetaScaleRate);
end

function ChatPopup:onPrePop()
  local size=CCDirector:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self.chatLayer=ChatLayer.new();
  self.chatLayer:initialize(self);
  -- self.chatLayer:setPositionXY(75,0);
  self:addChild(self.chatLayer);
end

function ChatPopup:onUIInit()
  -- local chatListProxy=self:retrieveProxy(ChatListProxy.name);
  -- local insertData=chatListProxy:getInsertData();

  -- local chatPopup=self.chatPopupMediator:getViewComponent();
  -- local chatNumber=insertData and insertData.chatDataNum or 0;
  -- local chatBuddyNumber=insertData and insertData.buddyDataNum or self:retrieveProxy(ChatListProxy.name):getRecordNumber();
  -- chatPopup:dispatchEvent(Event.new("buddyDeletedToRefreshMainSceneIcon",{ChatNumber=chatNumber,ChatBuddyNumber=chatBuddyNumber},chatPopup));

  -- local chatTalkerScrollList=chatPopup.tab_panels[2].chatTalkerScrollList;
  -- local channelButtonPopup=chatPopup.tab_panels[1].chat_content_item_popup;
  -- if insertData then
  --   for k,v in pairs(insertData.buddyNameNum) do
  --     local a=chatTalkerScrollList:getItem(k);
  --     if a then
  --       a.pannel_tip:setNum(v);
  --     end
  --   end

  --   for k,v in pairs(insertData.effects) do
  --     channelButtonPopup:refreshTipByChannel(k);
  --   end

  --   if insertData.button_effect then
  --     chatPopup.tab_panels[1]:addEffectChannelButton();
  --   end
  -- else
  --   local record=chatListProxy:getRecord();
  --   if record then
  --     for k,v in pairs(record) do
  --       local a=chatTalkerScrollList:getItem(v.UserName);
  --       if a then
  --         a.pannel_tip:setNum(chatListProxy:getRecordNumberByUserName(v.UserName));
  --       end
  --     end
  --   end
  -- end
  local size = Director:sharedDirector():getWinSize();
  local bg = LayerColorBackGround:getCustomBackGround(size.width, size.height, 190);
  bg:setPositionXY(GameData.uiOffsetX,-GameData.uiOffsetY);
  self:addChildAt(bg,0);
  self.chatLayer:onInitChatLayerPop();
end

function ChatPopup:onRequestedData()
  
end

function ChatPopup:onUIClose()
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_CLOSE,data,self));
  --self:setVisible(false);
end

function ChatPopup:onPreUIClose()
  self.chatLayer:onRemoveChatLayerPop();
end

function ChatPopup:refreshChatContent(data)
  self.chatLayer:refreshChatContent(data);
end













function ChatPopup:buddyDeletedRefreshPannelTip(chatNum, chatBuddyNum)
  -- if self.tab_buttons[1]~=self.tab_button_tap then self.tab_tips[1]:setNum(chatNum); end
  -- if self.tab_buttons[2]~=self.tab_button_tap then self.tab_tips[2]:setNum(chatBuddyNum); end
end

--onTabButtonTap
function ChatPopup:onTabButtonBegin(event)
  self:tabButton(event.target);
end

function ChatPopup:tabButton(tab_button)
  if self.tab_buttons[2]==tab_button and 0==self.buddyListProxy:getBuddyNum() then
    local a=NoneBuddyAddPanel.new();
    a:initialize(self.skeleton,self,self.onAddBuddy);
    self.parent:addChild(a);
    -- return;
  end

  if self.tab_button_tap then
    self.tab_button_tap:select(false);
  end
  self.tab_button_tap=tab_button;
  self.tab_button_tap:select(true);

  if self.tab_buttons[1]==self.tab_button_tap then
    self:addChatLayer();
  elseif self.tab_buttons[2]==self.tab_button_tap then
    self:addBuddyLayer();
  elseif self.tab_buttons[3]==self.tab_button_tap then
    self:addBuddyFeedLayer();
  end
end

--好友
function ChatPopup:addBuddyLayer()
  -- self.tab_tips[2]:onTap();

  if self.tab_panel_by_tap then
    --self.armature:removeChild(self.tab_panel_by_tap,false);
    self.tab_panel_by_tap:setVisible(false);
  end
  self.tab_panel_by_tap=self.tab_panels[2];
  self.armature:addChildAt(self.tab_panel_by_tap,0);
  self.tab_panel_by_tap:setVisible(true);

  if self.tab_panel_by_tap.chatTalkerScrollList.talker_item_tap then

  elseif 0<table.getn(self.tab_panel_by_tap.chatTalkerScrollList.talker_items) then
    self.tab_panel_by_tap.chatTalkerScrollList:onBuddyItemTap(self.tab_panel_by_tap.chatTalkerScrollList.talker_items[1]);
  end
end

function ChatPopup:addBuddyFeedLayer()
  if self.tab_panel_by_tap then
    --self.armature:removeChild(self.tab_panel_by_tap,false);
    self.tab_panel_by_tap:setVisible(false);
  end
  self.tab_panel_by_tap=self.tab_panels[3];
  self.armature:addChildAt(self.tab_panel_by_tap,0);
  self.tab_panel_by_tap:setVisible(true);
  self.tab_panel_by_tap:initializeData();
end

--聊天
function ChatPopup:addChatLayer()
  -- self.tab_tips[1]:onTap();

  if self.tab_panel_by_tap then
    --self.armature:removeChild(self.tab_panel_by_tap,false);
    self.tab_panel_by_tap:setVisible(false);
  end
  self.tab_panel_by_tap=self.tab_panels[1];
  self.armature:addChildAt(self.tab_panel_by_tap,0);
  self.tab_panel_by_tap:setVisible(true);

  if not self.tab_panel_by_tap:getSubType() then
    self.tab_panel_by_tap:onChannelButtonTap(nil,ConstConfig.SUB_TYPE_WORLD);
  end
end

function ChatPopup:order4Record()
  self.tab_panels[2]:order4Record();
end



--加好友
function ChatPopup:refreshAddBuddy(userName, level, userID)
  self.tab_panels[2]:refreshAddBuddy(userName,level,userID);
end

--更新好友
function ChatPopup:refreshBuddyData()
  self.tab_panels[2]:refreshBuddyData();
end

function ChatPopup:refreshPopArmature()
  self.tab_panels[1]:refreshPopArmature();
  self.tab_panels[2]:refreshPopArmature();
end

--移除好友
function ChatPopup:deleteBuddy(userName, userID)
  self.tab_panels[2]:deleteBuddy(userName,userID);
end

--添加好友
function ChatPopup:onAddBuddyButtonTap()
  local a=BuddyAddPanel.new();
  a:initialize(self.skeleton,self,self.onAddBuddy);
  self.parent:addChild(a);
end

--添加好友
function ChatPopup:onAddBuddy(name, userID)
  userID = tonumber(userID);
  if nil==name or ""==name then
    sharedTextAnimateReward():animateStartByString("请输入玩家名字!");
    return;
  end
  if self.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString("好友数量已达上限哦 ~");
    return;
  end
  if self.buddyListProxy:getIsHaoyou(userID) then
    sharedTextAnimateReward():animateStartByString("已经是您的好友了哦 ~");
    return;
  end
  if self.buddyListProxy:getBuddyData(name) then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_62));
    return;
  end
  if ConstConfig.USER_NAME==name then
    sharedTextAnimateReward():animateStartByString("知道你会加自己的,O(∩_∩)O哈哈~!");
    return;
  end
  local d={UserName=name,UserId=userID};
  -- self:dispatchEvent(Event.new("chatAddBuddy",d,self));
  sendMessage(21,4,d);
  sharedTextAnimateReward():animateStartByString("加为好友请求已发出 ~");
end

function ChatPopup:closeTip(event)
  if self.tipBg then
    self:removeChild(self.tipBg);
    self.tipBg=nil;
  end
  self:equipDetailLayerCF();
  self:dispatchEvent(Event.new(TipNotifications.REMOVE_TIP_COMMOND,nil,self));
end

--移除好友
function ChatPopup:onDeleteTap(buddyItem)
  local a={UserId=buddyItem:getUserId(),UserName=buddyItem:getUserName()};
  self:onDeleteBuddyButtonTap(a);
end

--移除好友
function ChatPopup:onDeleteBuddyButtonTap(data)
  local a=CommonPopup.new();
  local b='<content><font color="#FFFFFF">你真的要删除好友</font><font color="#00FF00">' .. data.UserName .. '</font><font color="#FFFFFF">吗</font><font color="#FFFFFF">?</font><font color="#FFFFFF">删除以后就会从好友列表消失哦!</font></content>';
  a:initialize(b,self,self.onDeleteBuddy,data,nil,nil,nil,nil,true);
  self.parent:addChild(a);
end

function ChatPopup:onDeleteBuddy(data)
  self:dispatchEvent(Event.new("chatDeleteBuddy",data,self));
end

--移除
function ChatPopup:onCloseButtonTap(event)
  --self.parent:removeChild(self,false);
  --self:dispatchEvent(Event.new(ChatNotifications.CHAT_CLOSE,data,self));
  self:setVisible(false);
end

function ChatPopup:refreshTimercf()
  if 0>=self.refreshTime then
    removeSchedule(self,self.refreshTimercf);
    return;
  end
  self.refreshTime=-1+self.refreshTime;
end

function ChatPopup:onMsgSend(data)
  if 0>=self.bagProxy:getItemNum(ConstItemIDConfig.ID_1007001) then
    -- sharedTextAnimateReward():animateStartByString("小喇叭不足了呢!");
    -- return;
  end
  if ""==data.ChatContentArray or 0 == table.getn(data.ChatContentArray) then
    sharedTextAnimateReward():animateStartByString("还木有说话哦!");
    return;
  end
  if 0<self.refreshTime then
    sharedTextAnimateReward():animateStartByString("说话太快了哦!");
    return;
  end
  if "侠士"==data.UserName then
    sharedTextAnimateReward():animateStartByString("讨厌啦~人家正在做新手任务啦~");
    return;
  end
  
  self.refreshTime=60;
  addSchedule(self,self.refreshTimercf);
  self:dispatchEvent(Event.new("chatSend",data,self));
end

--查看
function ChatPopup:onViewTap(data)
  self:onView(data.UserName,data.UserId);
end
function ChatPopup:onView(userName, userID)
  print(">>>>>", userName, userID);
  -- self:dispatchEvent(Event.new("chatView",{playerName=userName,playerID=userID},self));
  initializeSmallLoading();
  self.buddyListProxy.lookIntoData = {UserName=userName,UserId=userID};
  sendMessage(3,11,self.buddyListProxy.lookIntoData);
end
--挑战
function ChatPopup:onChallenge(data)
  self:dispatchEvent(Event.new("DUEL_OTHER_PLAYER",data))
end
--私聊
function ChatPopup:onPrivateTap(data)
  self:onPrivateToPlayer(data.UserName,data.UserId);
end
function ChatPopup:onPrivateToPlayer(userName, userID)
  if self.buddyListProxy:getBuddyData(userName) then
    self:onPrivateToBuddy(userName);
    return;
  end
  self:tabButton(self.tab_buttons[1]);
  self.tab_panels[1]:onPrivateToPlayer(userName,userID);
end
function ChatPopup:onPrivateToBuddy(userName)
  self:tabButton(self.tab_buttons[2]);
  self.tab_panels[2]:onPrivateToBuddy(userName);
end
--添加好友
function ChatPopup:onAddTap(data)
  self:onAddBuddy(data.UserName,data.UserId);
end
--邀请
function ChatPopup:onInviteTap(data)
  -- if "侠士"==data.UserName then
  --   sharedTextAnimateReward():animateStartByString("讨厌啦~人家正在做新手任务啦~");
  --   return;
  -- end
  self:dispatchEvent(Event.new("invite_family",{UserId=data.UserId,UserName=data.UserName},self));
end
--好友
function ChatPopup:onMsgState(data)
  self:dispatchEvent(Event.new("chatMsgState",data,self));
end
function ChatPopup:onReport(data)
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_PLAYER_REPORT,{Type=5,Title="",Content="<UserName>" .. data.UserName .. "</UserName>" .. data.Text},self));
end

function ChatPopup:setTextInputResponsable(bool)
  self.tab_panel_by_tap:setVisible(bool);
end

function ChatPopup:lookInto(a, b, text, hasReport)
  local a=StringUtils:lua_string_split(a,",");
  a[1]=tonumber(a[1]);
  if ConstConfig.CHAT_NAME==a[1] then
    -- if true then return;end
    -- local buddyItemPopup=BuddyItemPopup.new();
    -- buddyItemPopup:initialize(self.skeleton,{UserId=a[3],UserName=a[2],Text=text},self,self.onViewTap,
    --                                                              self.onChallenge,
    --                                                              self.onPrivateTap,
    --                                                              self.onAddTap,
    --                                                              self.onInviteTap,
    --                                                              nil,
    --                                                              self.buddyListProxy:getBuddyData(a[2]),
    --                                                              0~=self.userProxy:getFamilyID(),
    --                                                              nil,
    --                                                              nil,
    --                                                              nil,
    --                                                              hasReport,
    --                                                              self.onReport);
    -- local pos;
    -- if self.buddy_item_popup_pos then
    --   pos=self.buddy_item_popup_pos;
    -- else
    --   pos=makePoint(400,400);
    -- end
    -- buddyItemPopup:setPos(pos);
    -- self:addChild(buddyItemPopup);

    
    -- local function onLookIntoUser(data)
    --   self:onView(data.UserName,data.UserId);
    -- end
    -- local function onAddBuddy(data)
    --   self:onAddBuddy(data.UserName,data.UserId);
    -- end
    -- local buttonsSelector=ButtonsSelector.new();
    -- local functions;
    -- local texts;
    -- if self.buddyListProxy:getIsHaoyou(tonumber(a[3])) then
    --   functions={onLookIntoUser};
    --   texts={"查看"};
    -- else
    --   functions={onLookIntoUser,onAddBuddy};
    --   texts={"查看","加好友"};
    -- end
    -- buttonsSelector:initialize(functions,texts,{UserId=a[3],UserName=a[2]});
    -- local pos;
    -- if self.buddy_item_popup_pos then
    --   pos=self.buddy_item_popup_pos;
    -- else
    --   pos=makePoint(400,400);
    -- end
    -- buttonsSelector:setPos(pos);
    -- self:addChild(buttonsSelector);

    local pos;
    if self.buddy_item_popup_pos then
      pos=self.buddy_item_popup_pos;
    else
      pos=makePoint(400,400);
    end
    getUserButtonsSelector(a[3],a[2],pos,self);

  elseif ConstConfig.CHAT_PANEL==a[1] then
    self:dispatchEvent(Event.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,tonumber(a[2]),self));
  elseif ConstConfig.CHAT_EQUIP==a[1] then
    initializeSmallLoading();
    self:lookIntoEquip(a[1],tonumber(a[2]),tonumber(a[3]));
  elseif ConstConfig.CHAT_PHOTO==a[1] then

  elseif ConstConfig.CHAT_RECORD==a[1] then

  elseif ConstConfig.CHAT_PROP==a[1] then
    self.tipBg=LayerColorBackGround:getTransBackGround();
    self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
    self:addChild(self.tipBg);
    self:onEquipDetailLayer();
    self:dispatchEvent(Event.new(TipNotifications.OPEN_TIP_COMMOND,tonumber(a[2]),self));
  elseif ConstConfig.CHAT_HERO==a[1] then
    initializeSmallLoading();
    self:lookIntoHero(a[1],tonumber(a[2]));
  elseif ConstConfig.CHAT_BANG_PAI_JIA_RU==a[1] then
    if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_30) then
      sharedTextAnimateReward():animateStartByString("帮派功能还未开启哦~");
    elseif 0 == self.userProxy:getFamilyID() then
      sendMessage(27,13,{FamilyId=tonumber(a[2]),BooleanValue=1});
      sharedTextAnimateReward():animateStartByString("申请发送成功咯~");
    else
      sharedTextAnimateReward():animateStartByString("已经加入过帮派了哦~");
    end
  elseif ConstConfig.CHAT_BANG_PAI_JIA_RU_JIU_YAN==a[1] then
print("===============");
    if self.userProxy.sceneType == GameConfig.SCENE_TYPE_1 then
      if self.userProxy:getHasFamily() then
        self.userProxy.banquetData = {Type = tonumber(a[2]), ID = tonumber(a[3])}
        sendMessage(27,2)
      else
        sharedTextAnimateReward():animateStartByString("还没有帮派哦~");
      end
      
    else
      if self.userProxy:getHasFamily() then
        Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_COMMAND, {Type = tonumber(a[2]), ID = tonumber(a[3])}));
        sendMessage(27, 31, {ID = tonumber(a[3])});
      else
        sharedTextAnimateReward():animateStartByString("还没有帮派哦~");
      end
    end
    self:closeUI();
  end
end

function ChatPopup:lookIntoEquip(type, generalId, itemId)
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_LOOK_INTO,{TYPE=type,PARAM={generalId,itemId}},self));
end

function ChatPopup:lookIntoHero(type, generalId)
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_LOOK_INTO,{TYPE=type,PARAM=generalId},self));
end

function ChatPopup:refreshChatEquipDetailLayer(skeleton, data)
  uninitializeSmallLoading();
  local chatEquipDetailLayer=ChatEquipDetailLayer.new();
  chatEquipDetailLayer:initialize(skeleton,data,self,self.equipDetailLayerCF);
  self:addChild(chatEquipDetailLayer);

  self:onEquipDetailLayer();
end

function ChatPopup:refreshChatHeroDetailLayer(skeleton, data)
  require "main.view.hero.heroPro.ui.HeroProScaleSlot";
  uninitializeSmallLoading();
  local layer = LayerColorBackGround:getTransBackGround();
  local function onSlotTap(event)
    self:removeChild(self.slot);
    self.slot = nil;
    self:removeChild(layer);
  end
  layer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  layer:addEventListener(DisplayEvents.kTouchTap, onSlotTap);
  self:addChild(layer);
  local size=self:getContentSize();--Director:sharedDirector():getWinSize();
  self.slot = HeroProScaleSlot.new();
  self.slot:initialize(skeleton,data,makePoint(640, 360));
  self.slot:getCard().touchEnabled = true;
  self.slot:getCard().touchChildren = true;
  self:addChild(self.slot);
  self.slot:addEventListener(DisplayEvents.kTouchTap, onSlotTap);
end

function ChatPopup:onEquipDetailLayer()
  self.chatLayer.channel_panel_select.listScrollViewLayer:setMoveEnabled(false);
end

function ChatPopup:equipDetailLayerCF()
  self.chatLayer.channel_panel_select.listScrollViewLayer:setMoveEnabled(true);
end

function ChatPopup:refreshFeed(data)
  if self.tab_panels[3].data_initialized then
    self.tab_panels[3]:addFeed(data);
  end
end

function ChatPopup:refreshFeedEXP()
  if self.tab_panels[3].data_initialized then
    self.tab_panels[3]:refreshFeedEXP();
  end
end

function ChatPopup:refreshBuddyCommend(data)
if self.tab_panels[3].data_initialized and self.tab_panels[3].buddyCommendLayer then
    self.tab_panels[3].buddyCommendLayer:initializeData(data);
  end
end

function ChatPopup:changeTab(tabID, openBuddyFeed)
  if not tabID then tabID=1; end
  self:tabButton(self.tab_buttons[tabID]);
  if 3==tabID and openBuddyFeed then
    self.tab_panels[3]:onCommendButtonTap();
  end
end

function ChatPopup:refreshPrivateChatValid(state)
  self.tab_panels[1]:refreshPrivateChatValid(state);
end

function ChatPopup:applyFamily(familyID)
  self:dispatchEvent(Event.new("APPLY_FAMILY",familyID))
end
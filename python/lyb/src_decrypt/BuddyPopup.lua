require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.RichLabelTTF";
require "core.controls.FlexibleListScrollViewLayer";
require "core.controls.RichTextLineInput";
require "main.view.buddy.ui.buddyPopup.BuddyLayer";
require "core.display.LayerPopable";
require "main.config.ConstItemIDConfig";
require "main.view.chat.ui.chatPopup.ButtonsSelector";

BuddyPopup=class(LayerPopableDirect);

function BuddyPopup:ctor()
  self.class=BuddyPopup;
end

function BuddyPopup:dispose()
	BuddyPopup.superclass.dispose(self);
  --CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
end

function BuddyPopup:onDataInit()
  self.chatListProxy = self:retrieveProxy(ChatListProxy.name);
  self.buddyListProxy = self:retrieveProxy(BuddyListProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.equipmentInfoProxy = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.operationProxy = self:retrieveProxy(OperationProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.skeleton = self.buddyListProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);

  self.refreshTime=0;
end

function BuddyPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self.buddyLayer=BuddyLayer.new();
  self.buddyLayer:initialize(self);
  -- self.buddyLayer:setPositionXY(85,0);
  self:addChild(self.buddyLayer);
end

function BuddyPopup:onUIInit()
  -- initializeSmallLoading();
  -- self:refreshBuddyData();
  self.buddyLayer:onChannelButtonTap(nil,1);
end

function BuddyPopup:onRequestedData()
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_BUDDY_ONLINE,nil,self));
end

function BuddyPopup:onUIClose()
  self:dispatchEvent(Event.new(ChatNotifications.BUDDY_CLOSE,data,self));
  --self:setVisible(false);
end

function BuddyPopup:onPreUIClose()
  self.buddyLayer:onChannelButtonTap(nil,0);
end

function BuddyPopup:refreshBuddyData()
  uninitializeSmallLoading();
  self.buddyLayer:onChannelButtonTap(nil,1);
end














































--添加好友
function BuddyPopup:onAddBuddy(name, userID)
  if nil==name or ""==name then
    sharedTextAnimateReward():animateStartByString("请输入玩家名字!");
    return;
  end
  if self.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_63));
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
  self:dispatchEvent(Event.new("chatAddBuddy",d,self));
end

function BuddyPopup:onFlowerTap(num_select, buddyItemSlotData)
  sendMessage(21,5,{UserId=buddyItemSlotData.UserId,Type=num_select});
end

function BuddyPopup:onSendFlowerButtonTap(buddy_item_data)
  local buddySendFlower=BuddySendFlower.new();
  buddySendFlower:initialize(self,buddy_item_data);
  self:addChild(buddySendFlower);
end











function BuddyPopup:buddyDeletedRefreshPannelTip(chatNum, chatBuddyNum)
  -- if self.tab_buttons[1]~=self.tab_button_tap then self.tab_tips[1]:setNum(chatNum); end
  -- if self.tab_buttons[2]~=self.tab_button_tap then self.tab_tips[2]:setNum(chatBuddyNum); end
end

--onTabButtonTap
function BuddyPopup:onTabButtonBegin(event)
  self:tabButton(event.target);
end

function BuddyPopup:tabButton(tab_button)
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
function BuddyPopup:addBuddyLayer()
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

function BuddyPopup:addBuddyFeedLayer()
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
function BuddyPopup:addChatLayer()
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

function BuddyPopup:order4Record()
  self.tab_panels[2]:order4Record();
end



--加好友
function BuddyPopup:refreshAddBuddy(userName, level, userID)
  self.tab_panels[2]:refreshAddBuddy(userName,level,userID);
end

-- --更新好友
-- function BuddyPopup:refreshBuddyData()
--   self.tab_panels[2]:refreshBuddyData();
-- end

function BuddyPopup:refreshPopArmature()
  self.tab_panels[1]:refreshPopArmature();
  self.tab_panels[2]:refreshPopArmature();
end

--移除好友
function BuddyPopup:deleteBuddy(userName, userID)
  self.tab_panels[2]:deleteBuddy(userName,userID);
end

--添加好友
function BuddyPopup:onAddBuddyButtonTap()
  local a=BuddyAddPanel.new();
  a:initialize(self.skeleton,self,self.onAddBuddy);
  self.parent:addChild(a);
end

function BuddyPopup:closeTip(event)
  if self.tipBg then
    self:removeChild(self.tipBg);
    self.tipBg=nil;
  end
  self:equipDetailLayerCF();
  self:dispatchEvent(Event.new(TipNotifications.REMOVE_TIP_COMMOND,nil,self));
end

--移除好友
function BuddyPopup:onDeleteTap(buddyItem)
  local a={UserId=buddyItem:getUserId(),UserName=buddyItem:getUserName()};
  self:onDeleteBuddyButtonTap(a);
end

--移除好友
function BuddyPopup:onDeleteBuddyButtonTap(data)
  local a=CommonPopup.new();
  local b='<content><font color="#FFFFFF">你真的要删除好友</font><font color="#00FF00">' .. data.UserName .. '</font><font color="#FFFFFF">吗</font><font color="#FFFFFF">?</font><font color="#FFFFFF">删除以后就会从好友列表消失哦!</font></content>';
  a:initialize(b,self,self.onDeleteBuddy,data,nil,nil,nil,nil,true);
  self.parent:addChild(a);
end

function BuddyPopup:onDeleteBuddy(data)
  self:dispatchEvent(Event.new("chatDeleteBuddy",data,self));
end

--移除
function BuddyPopup:onCloseButtonTap(event)
  --self.parent:removeChild(self,false);
  --self:dispatchEvent(Event.new(ChatNotifications.CHAT_CLOSE,data,self));
  self:setVisible(false);
end

function BuddyPopup:refreshTimercf()
  if 0>=self.refreshTime then
    removeSchedule(self,self.refreshTimercf);
    return;
  end
  self.refreshTime=-1+self.refreshTime;
end

function BuddyPopup:onMsgSend(data)
  if 0>self.bagProxy:getItemNum(ConstItemIDConfig.ID_1007001) then
    sharedTextAnimateReward():animateStartByString("小喇叭不足了呢!");
    return;
  elseif ""==data.ChatContentArray then
    --[[local b=CommonPopup.new();
    b:initialize("木有说话哦!",nil,nil,nil,nil,nil,true);
    self.armature:addChild(b);]]
    sharedTextAnimateReward():animateStartByString("还木有说话哦!");
    return;
  elseif 0<self.refreshTime then
    --[[local c=CommonPopup.new();
    c:initialize("说话太快了哦!",nil,nil,nil,nil,nil,true);
    self.armature:addChild(c);]]
    sharedTextAnimateReward():animateStartByString("说话太快了哦!");
    return;
  elseif "侠士"==data.UserName then
    sharedTextAnimateReward():animateStartByString("讨厌啦~人家正在做新手任务啦~");
    return;
  end
  self.refreshTime=60;
  addSchedule(self,self.refreshTimercf);
  self:dispatchEvent(Event.new("chatSend",data,self));
end

--查看
function BuddyPopup:onViewTap(data)
  self:onView(data.UserName,data.UserId);
end
function BuddyPopup:onView(userName, userID)
  self:dispatchEvent(Event.new("chatView",{playerName=userName,playerID=userID},self));
end
--挑战
function BuddyPopup:onChallenge(data)
  self:dispatchEvent(Event.new("DUEL_OTHER_PLAYER",data))
end
--私聊
function BuddyPopup:onPrivateTap(data)
  self:onPrivateToPlayer(data.UserName,data.UserId);
end
function BuddyPopup:onPrivateToPlayer(userName, userID)
  if self.buddyListProxy:getBuddyData(userName) then
    self:onPrivateToBuddy(userName);
    return;
  end
  self:tabButton(self.tab_buttons[1]);
  self.tab_panels[1]:onPrivateToPlayer(userName,userID);
end
function BuddyPopup:onPrivateToBuddy(userName)
  self:tabButton(self.tab_buttons[2]);
  self.tab_panels[2]:onPrivateToBuddy(userName);
end
--添加好友
function BuddyPopup:onAddTap(data)
  self:onAddBuddy(data.UserName,data.UserId);
end
--邀请
function BuddyPopup:onInviteTap(data)
  if "侠士"==data.UserName then
    sharedTextAnimateReward():animateStartByString("讨厌啦~人家正在做新手任务啦~");
    return;
  end
  self:dispatchEvent(Event.new("invite_family",{UserId=data.UserId,UserName=data.UserName},self));
end
--好友
function BuddyPopup:onMsgState(data)
  self:dispatchEvent(Event.new("chatMsgState",data,self));
end
function BuddyPopup:onReport(data)
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_PLAYER_REPORT,{Type=5,Title="",Content="<UserName>" .. data.UserName .. "</UserName>" .. data.Text},self));
end

function BuddyPopup:setTextInputResponsable(bool)
  self.tab_panel_by_tap:setVisible(bool);
end

function BuddyPopup:lookInto(a, b, text, hasReport)
  local a=StringUtils:lua_string_split(a,",");
  a[1]=tonumber(a[1]);
  if ConstConfig.CHAT_NAME==a[1] then
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
    local function onLookIntoUser()
      self:onView(data.UserName,data.UserId);
    end
    local function onAddBuddy()
      self:onAddBuddy(data.UserName,data.UserId);
    end
    local buttonsSelector=ButtonsSelector.new();
    local functions;
    local texts;
    if self.buddyListProxy:getBuddyData(a[2]) then
      functions={onLookIntoUser};
      texts={"查看"};
    else
      functions={onLookIntoUser,onAddBuddy};
      texts={"查看","加好友"};
    end
    buttonsSelector:initialize(functions,texts,{UserId=a[3],UserName=a[2]});
    local pos;
    if self.buddy_item_popup_pos then
      pos=self.buddy_item_popup_pos;
    else
      pos=makePoint(400,400);
    end
    buttonsSelector:setPos(pos);
    self:addChild(buttonsSelector);

  elseif ConstConfig.CHAT_PANEL==a[1] then
    self:dispatchEvent(Event.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,tonumber(a[2]),self));
  elseif ConstConfig.CHAT_EQUIP==a[1] then
    initializeSmallLoading();
    self:lookIntoEquip(a[1],tonumber(a[2]));
  elseif ConstConfig.CHAT_PHOTO==a[1] then

  elseif ConstConfig.CHAT_RECORD==a[1] then

  elseif ConstConfig.CHAT_PROP==a[1] then
    self.tipBg=LayerColorBackGround:getTransBackGround();
    self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
    self:addChild(self.tipBg);
    self:onEquipDetailLayer();
    self:dispatchEvent(Event.new(TipNotifications.OPEN_TIP_COMMOND,tonumber(a[2]),self));
  end
end

function BuddyPopup:lookIntoEquip(type, userEquipmentId)
  self:dispatchEvent(Event.new(ChatNotifications.CHAT_LOOK_INTO,{TYPE=type,PARAM=userEquipmentId},self));
end

function BuddyPopup:refreshChatEquipDetailLayer(skeleton, data)
  uninitializeSmallLoading();
  local chatEquipDetailLayer=ChatEquipDetailLayer.new();
  chatEquipDetailLayer:initialize(skeleton,data,self,self.equipDetailLayerCF);
  self:addChild(chatEquipDetailLayer);

  self:onEquipDetailLayer();
end

function BuddyPopup:onEquipDetailLayer()
  self.chatLayer.channel_panel_select.listScrollViewLayer:setMoveEnabled(false);
end

function BuddyPopup:equipDetailLayerCF()
  self.chatLayer.channel_panel_select.listScrollViewLayer:setMoveEnabled(true);
end

function BuddyPopup:refreshFeed(data)
  if self.tab_panels[3].data_initialized then
    self.tab_panels[3]:addFeed(data);
  end
end

function BuddyPopup:refreshFeedEXP()
  if self.tab_panels[3].data_initialized then
    self.tab_panels[3]:refreshFeedEXP();
  end
end

function BuddyPopup:refreshBuddyCommend(data)
if self.tab_panels[3].data_initialized and self.tab_panels[3].buddyCommendLayer then
    self.tab_panels[3].buddyCommendLayer:initializeData(data);
  end
end

function BuddyPopup:changeTab(tabID, openBuddyFeed)
  if not tabID then tabID=1; end
  self:tabButton(self.tab_buttons[tabID]);
  if 3==tabID and openBuddyFeed then
    self.tab_panels[3]:onCommendButtonTap();
  end
end

function BuddyPopup:refreshPrivateChatValid(state)
  self.tab_panels[1]:refreshPrivateChatValid(state);
end

function BuddyPopup:applyFamily(familyID)
  self:dispatchEvent(Event.new("APPLY_FAMILY",familyID))
end
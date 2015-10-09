--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.rankList.ui.RankListPopup";

RankListMediator=class(Mediator);

function RankListMediator:ctor()
  self.class=RankListMediator;
  self.viewComponent=RankListPopup.new();
end

rawset(RankListMediator,"name","RankListMediator");

function RankListMediator:intializeUI(skeleton, rankListProxy, chatListProxy, buddyListProxy, userProxy)
  self:getViewComponent():initializeUI(skeleton,rankListProxy,chatListProxy,buddyListProxy,userProxy);
end

function RankListMediator:changeTab(id)
  self:getViewComponent():changeTab(id);
end

function RankListMediator:onClose(event)
  self:sendNotification(RankListNotification.new(RankListNotifications.RANK_LIST_CLOSE));
end

function RankListMediator:onRequestData(event)
  self:sendNotification(RankListNotification.new(RankListNotifications.RANK_LIST_REQUEST_DATA,event.data));
end

function RankListMediator:onOpenMenu(event)
    local name=event.data.Name;
    local userName=event.data.UserName
    local userId=event.data.UserId
    if name == "查看" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_LOOK_INTO_PLAYER,{playerName=userName,playerID=userId}));
    elseif name == "切磋" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.DUEL_OTHER_PLAYER,{UserName = userName,UserId = userId}));
    elseif name == "私聊" or  name == "聊天" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_PRIVATE_CHAT,{playerName=userName}));
    elseif name == "加好友" then
      --添加好友
      self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_ADD_BUDDY,{UserName=userName,UserId=userId}));
    elseif name == "邀家族" then
      --邀请家族
      self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_INVITE,{UserName=userName}));
    end
end

function RankListMediator:refresh(type, rankArray)
  self:getViewComponent():refreshData(type, rankArray);
end

function RankListMediator:onRegister()
  -- self:getViewComponent():initialize();
  self:getViewComponent():addEventListener(RankListNotifications.RANK_LIST_REQUEST_DATA,self.onRequestData,self);
  self:getViewComponent():addEventListener("OPEN_MENU_COMMAND",self.onOpenMenu,self);
  self:getViewComponent():addEventListener(RankListNotifications.RANK_LIST_CLOSE,self.onClose,self);
end

function RankListMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
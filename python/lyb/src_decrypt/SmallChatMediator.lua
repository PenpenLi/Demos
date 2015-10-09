--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.smallChat.ui.SmallChatPopup";

SmallChatMediator=class(Mediator);

function SmallChatMediator:ctor()
  self.class=SmallChatMediator;
	self.viewComponent=SmallChatPopup.new();
end

rawset(SmallChatMediator,"name","SmallChatMediator");

function SmallChatMediator:intializeAvatarUI(skeleton, smallChatProxy, openFunctionProxy)
  self:getViewComponent():initializeUI(skeleton,smallChatProxy,openFunctionProxy);
end

function SmallChatMediator:onMenu()
  self:getViewComponent():onMenu();
end

function SmallChatMediator:onRefreshChatIconEffect(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.REFRESH_CHAT_ICON_EFFECT));
end

function SmallChatMediator:onToChat(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_CHAT));
end

function SmallChatMediator:refresh(hasChat)
  self:getViewComponent():refresh(hasChat);
end

function SmallChatMediator:refreshEffect()
  if self:getViewComponent().effect then
    self:getViewComponent().effect:setVisible(false);
  end
end

function SmallChatMediator:onRegister()
  self:getViewComponent():initialize();
  require "main.controller.notification.MainSceneNotification";
  self:getViewComponent():addEventListener(MainSceneNotifications.REFRESH_CHAT_ICON_EFFECT,self.onRefreshChatIconEffect,self);
  self:getViewComponent():addEventListener(MainSceneNotifications.TO_CHAT,self.onToChat,self);
end

function SmallChatMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
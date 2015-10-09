require "main.view.mainScene.otherPlayerMenu.ui.OtherPlayerMenuPopup";

OtherPlayerMenuMediator=class(Mediator);

function OtherPlayerMenuMediator:ctor()
  self.class = OtherPlayerMenuMediator;
	self.viewComponent=OtherPlayerMenuPopup.new();
end

rawset(OtherPlayerMenuMediator,"name","OtherPlayerMenuMediator");

function OtherPlayerMenuMediator:onRegister()
  self:getViewComponent():addEventListener("OPEN_MENU_COMMAND", self.onOpenMenu, self);
  self:getViewComponent():addEventListener("REMOVE_MENU_CLICK", self.onRemoveMenu, self);
end
function OtherPlayerMenuMediator:initializeUI(generalListProxy, buddyListProxy, userProxy, data)
  self.data = data;
  self:getViewComponent():initializeUI(generalListProxy, buddyListProxy, userProxy, data);
end
function OtherPlayerMenuMediator:onOpenMenu(event)
    local index = event.data.index;
    local label = self:getViewComponent().labelTable[index]
    if label == "查看" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_LOOK_INTO_PLAYER,{playerName = self.data.playerName,playerID=self.data.playerID}));
    elseif label == "切磋" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.DUEL_OTHER_PLAYER,{UserId = self.data.playerID, UserName = self.data.playerName}));
    elseif label == "私聊" or  label == "聊天" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_PRIVATE_CHAT,{playerName = self.data.playerName}));
    elseif label == "加好友" then
      --添加好友
      self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_ADD_BUDDY,{UserId=self.data.playerID,UserName=self.data.playerName}));
    elseif label == "邀家族" then
      --邀请家族
      self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_INVITE,{UserName=self.data.playerName}));
    end
end

function OtherPlayerMenuMediator:onRemoveMenu(event)
    self:sendNotification(LookIntoPlayerNotification.new(LookIntoPlayerNotifications.OTHER_PLAYER_MENU_CLOSE));
end

function OtherPlayerMenuMediator:onRemove()
	self:getViewComponent().parent:removeChild(self:getViewComponent());
end

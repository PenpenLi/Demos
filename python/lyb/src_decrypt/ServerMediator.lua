require "main.view.serverScene.ServerPopup";

ServerMediator=class(Mediator);

function ServerMediator:ctor()
  self.class = ServerMediator;
	self.viewComponent=ServerPopup.new();
end

rawset(ServerMediator,"name","ServerMediator");

function ServerMediator:intializeServerUI(skeleton)
  self:getViewComponent():intializeServerUI(skeleton);
end

function ServerMediator:onRegister()
    self:getViewComponent():addEventListener("serverClose",self.onServerClose,self);
    self:getViewComponent():addEventListener("beginLoad",self.onBeginLoad,self);
    self:getViewComponent():addEventListener(OfficialServerNotifications.OPEN_OFFICIAL_SERVER,self.onOpenOfficialServer,self);
end

function ServerMediator:initialize()
  self:getViewComponent():initialize();
end

function ServerMediator:onRemove()
    if self:getViewComponent().parent then
  	     self:getViewComponent().parent:removeChild(self:getViewComponent());
    end
end

function ServerMediator:addSelectButtonListener()
    self:getViewComponent():addSelectButtonListener();
end

function ServerMediator:onServerClose(event)
  self:sendNotification(ServerSceneNotification.new(ServerSceneNotifications.SERVER_CLOSE_COMMAND));
end

function ServerMediator:onOpenOfficialServer(event)
  self:sendNotification(OfficialServerNotification.new(OfficialServerNotifications.OPEN_OFFICIAL_SERVER));
end

function ServerMediator:onBeginLoad(event)
  -- local data = {};
  -- self:sendNotification(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data));
end
function ServerMediator:refreshClickCount()
  self:getViewComponent():refreshClickCount();
end

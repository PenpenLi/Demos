--
-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- Create date: 2013-5-2
-- yanchuan.xie@happyelements.com

require "main.view.officialServer.ui.OfficialServerPopup";
require "main.view.officialServer.ui.OfficialServerSignPopup";

OfficialServerMediator=class(Mediator);

function OfficialServerMediator:ctor()
  self.class=OfficialServerMediator;
	self.viewComponent=OfficialServerPopup.new();
end

rawset(OfficialServerMediator,"name","OfficialServerMediator");

function OfficialServerMediator:intializeUI(serverMergeProxy, serverMediator)
  self:getViewComponent():initializeUI(serverMergeProxy,serverMediator);
end

function OfficialServerMediator:onClose(event)
  self:sendNotification(OfficialServerNotification.new(OfficialServerNotifications.CLOSE_OFFICIAL_SERVER));
end

function OfficialServerMediator:refreshBindComplete()
  self:getViewComponent():refreshBindComplete();
end

function OfficialServerMediator:refreshCheckAccountComplete()
  self:getViewComponent():refreshCheckAccountComplete();
end

function OfficialServerMediator:refreshChangeComplete()
  self:getViewComponent():refreshChangeComplete();
end

function OfficialServerMediator:refreshSignComplete()
  self:getViewComponent():refreshSignComplete();
end

function OfficialServerMediator:onWanError()
  self:getViewComponent():onWanError();
end

function OfficialServerMediator:onRegister()
  self:getViewComponent():addEventListener(OfficialServerNotifications.CLOSE_OFFICIAL_SERVER,self.onClose,self);
end

function OfficialServerMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
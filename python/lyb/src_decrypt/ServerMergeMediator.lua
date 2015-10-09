--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.serverMerge.ui.ServerMergePopup";

ServerMergeMediator=class(Mediator);

function ServerMergeMediator:ctor()
  self.class=ServerMergeMediator;
  self.viewComponent=ServerMergePopup.new();
end

rawset(ServerMergeMediator,"name","ServerMergeMediator");

function ServerMergeMediator:initialize(serverMergeProxy, bagProxy, datas)
	self:getViewComponent():initialize(serverMergeProxy,bagProxy,datas);
end

function ServerMergeMediator:refreshUserName(userName)
	self:getViewComponent():refreshUserName(userName);
end

function ServerMergeMediator:onRegister()
	
end

function ServerMergeMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
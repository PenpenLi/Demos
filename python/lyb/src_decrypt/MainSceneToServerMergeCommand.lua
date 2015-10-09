--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

MainSceneToServerMergeCommand=class(Command);

function MainSceneToServerMergeCommand:ctor()
	self.class=MainSceneToServerMergeCommand;
end

function MainSceneToServerMergeCommand:execute(notification)
  require "main.view.serverMerge.ServerMergeMediator";
  require "main.model.ServerMergeProxy";
  require "main.model.BagProxy";
  local serverMergeMediator=ServerMergeMediator.new();
  self:registerMediator(serverMergeMediator:getMediatorName(),serverMergeMediator);
  serverMergeMediator:initialize(ServerMergeProxy.new(),BagProxy.new(),notification:getData());
  Director:sharedDirector():getRunningScene():addChild(serverMergeMediator:getViewComponent());
end
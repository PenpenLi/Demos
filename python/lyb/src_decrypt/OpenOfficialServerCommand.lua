--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-31

	yanchuan.xie@happyelements.com
]]

OpenOfficialServerCommand=class(Command);

function OpenOfficialServerCommand:ctor()
	self.class=OpenOfficialServerCommand;
end

function OpenOfficialServerCommand:execute()
  require "main.view.officialServer.OfficialServerMediator";
  require "main.model.ServerMergeProxy";
  self.officialServerMediator=self:retrieveMediator(OfficialServerMediator.name);
  if nil==self.officialServerMediator then
    self.officialServerMediator=OfficialServerMediator.new();
    self:registerMediator(self.officialServerMediator:getMediatorName(),self.officialServerMediator);
    self.officialServerMediator:intializeUI(ServerMergeProxy.new(),self:retrieveMediator(ServerMediator.name));
  end

  sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_LAYER_UI):addChild(self.officialServerMediator:getViewComponent());
end
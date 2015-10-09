require "main.view.yongbing.YongbingMediator";

MainSceneToYongbingCommand=class(Command);

function MainSceneToYongbingCommand:ctor()
	self.class=MainSceneToYongbingCommand;
end

function MainSceneToYongbingCommand:execute()
  self:require();
  --YongbingMediator
  self.yongbingMediator=self:retrieveMediator(YongbingMediator.name);
  if self.yongbingMediator then
    return;
  end
  if nil==self.yongbingMediator then
    self.yongbingMediator=YongbingMediator.new();
    self:registerMediator(self.yongbingMediator:getMediatorName(),self.yongbingMediator);
    self:registerCommands();
  end

  LayerManager:addLayerPopable(self.yongbingMediator:getViewComponent());
end

function MainSceneToYongbingCommand:registerCommands()
  self:registerCommand(YongbingNotifications.YONGBING_CLOSE,YongbingCloseCommand);
end

function MainSceneToYongbingCommand:require()
  require "main.controller.notification.YongbingNotification";
  require "main.controller.command.yongbing.YongbingCloseCommand";
end
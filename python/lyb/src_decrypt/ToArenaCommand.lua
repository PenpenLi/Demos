
ToArenaCommand=class(Command);

function ToArenaCommand:ctor()
	self.class=ToArenaCommand;
end

function ToArenaCommand:execute()
  self.arenaProxy = self:retrieveProxy(ArenaProxy.name);
  if 1 == self.arenaProxy:getIsUpdating() then
    sharedTextAnimateReward():animateStartByString("当前赛季结束,一分钟后开启新赛季哦 ~");
    return;
  end
	require "main.controller.notification.ArenaNotification";
	require "main.controller.command.arena.ArenaCloseCommand"
  require "main.view.arena.JingjichangMediator";
  local currencyGroupMediator=self:retrieveMediator(CurrencyGroupMediator.name);

  if currencyGroupMediator then
    currencyGroupMediator:refreshAreaRongYu()
  end
  local arenaMediator=self:retrieveMediator(JingjichangMediator.name);
  local arenaProxy=self:retrieveProxy(ArenaProxy.name);
  if nil==arenaMediator then
    arenaMediator=JingjichangMediator.new();
    self:registerMediator(arenaMediator:getMediatorName(),arenaMediator);
  end
  --self:retrieveMediator(MainSceneMediator.name):getViewComponent():addChild(arenaMediator:getViewComponent());  
  LayerManager:addLayerPopable(arenaMediator:getViewComponent());
  self:registerArenaCommands();
  self:observe(ArenaCloseCommand);

  if GameVar.tutorStage == TutorConfig.STAGE_1016 then
    print("arenaProxy.afterBattle", arenaProxy.afterBattle)
    if arenaProxy.afterBattle then

    else
      openTutorUI({x=954, y=469, width = 130, height = 51, alpha = 125});
    end
  end

end

function ToArenaCommand:registerArenaCommands()
  self:registerCommand(ArenaNotifications.ARENA_CLOSE_COMMOND,ArenaCloseCommand);
end
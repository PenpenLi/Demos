
OpenQuickBattleUICommand=class(Command);

function OpenQuickBattleUICommand:ctor()
	self.class=OpenQuickBattleUICommand;
end

function OpenQuickBattleUICommand:execute(notification)
    require "main.model.UserProxy";
    require "main.view.quickBattle.QuickBattleMediator";
    require "main.controller.command.quickBattle.CloseQuickBattleUICommand";


  local quickBattleMed = self:retrieveMediator(QuickBattleMediator.name);  
  if nil == quickBattleMed then
    quickBattleMed = QuickBattleMediator.new();
    self:registerMediator(quickBattleMed:getMediatorName(), quickBattleMed);
    self:registerQuickBattleCommands();
  end
  local data=notification.data;
  -- sendMessage(4, 3, {StrongPointId=data.StrongPointId})

  quickBattleMed:initData(data);--.StrongPointId
  LayerManager:addLayerPopable(quickBattleMed:getViewComponent());
end

function OpenQuickBattleUICommand:registerQuickBattleCommands()
  self:registerCommand(StrongPointInfoNotifications.CLOSE_QUICK_BATTLE_UI_COMMOND, CloseQuickBattleUICommand);
end
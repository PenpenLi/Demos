

ToAddCurrencyGroupCommand=class(Command);

function ToAddCurrencyGroupCommand:ctor()
	self.class=ToAddCurrencyGroupCommand;
end

function ToAddCurrencyGroupCommand:execute(visible)
  print("ToAddCurrencyGroupCommand execute")
  require "main.view.mainScene.component.CurrencyGroupMediator";
  
  local currencyGroupMed = self:retrieveMediator(CurrencyGroupMediator.name)
  if not currencyGroupMed then
      print("@@@@@@@@@@@@@@@@@@@@@@@@currencyGroupMed, visible", visible)

      currencyGroupMed = CurrencyGroupMediator.new()
      self:registerMediator(CurrencyGroupMediator.name,currencyGroupMed)
      currencyGroupMed:initialize()
      self:registerCurrencyGroupCommands()

      local layCurrency = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY)
      if layCurrency then
        print("*****************************layCurrency");
        layCurrency:addChild(currencyGroupMed:getViewComponent());
      else
        print("*****************************layCurrency  is nil");
      end
  end
  if not visible then
    currencyGroupMed:getViewComponent():setVisible(false)
  else
    currencyGroupMed:getViewComponent():setVisible(true)
  end

  if GameVar.hideCurrencyForTutor then
    currencyGroupMed:getViewComponent():setVisible(false)
  end
  self:observe(ToRemoveCurrencyGroupCommand);
end

function ToAddCurrencyGroupCommand:registerCurrencyGroupCommands()
  require "main.controller.command.mainScene.ToRemoveCurrencyGroupCommand";
  self:registerCommand(MainSceneNotifications.TO_REMOVE_CURRENCY_GROUP_COMMAND, ToRemoveCurrencyGroupCommand);
end


  -- local layCurrency = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI)
  --     if layCurrency then
  --       print("*****************************layCurrency");
  --       layCurrency:addChild(currencyGroupMed:getViewComponent());
  --     else
  --       print("*****************************layCurrency  is nil");
  --     end
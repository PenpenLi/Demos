

ToAddHButtonGroupCommand=class(Command);

function ToAddHButtonGroupCommand:ctor()
	self.class=ToAddHButtonGroupCommand;
end

function ToAddHButtonGroupCommand:execute(visible)
  
  require "main.view.mainScene.component.HButtonGroupMediator";
  
  local buttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
  if not buttonGroupMediator then
    if visible then
  		buttonGroupMediator = HButtonGroupMediator.new()
  		self:registerMediator(buttonGroupMediator:getMediatorName(),buttonGroupMediator)
      buttonGroupMediator:initialize();
      local winSize = Director:sharedDirector():getWinSize();
      buttonGroupMediator:getViewComponent():setPositionXY(winSize.width - 675 - 54, -GameData.uiOffsetY);

      buttonGroupMediator:refreshRedDot();

  		self:registerHButtonGroupCommands()
      local layCurrency = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI)
      if layCurrency then
		    print("ToAddHButtonGroupCommand *****************************layCurrency");
  		  layCurrency:addChild(buttonGroupMediator:getViewComponent());
      else
		    print("ToAddHButtonGroupCommand *****************************layCurrency  is nil");
      end
  	end
  else
	  if not visible then
      buttonGroupMediator:getViewComponent():setVisible(false)
    else
      buttonGroupMediator:getViewComponent():setVisible(true)
    end
  end

  self:observe(ToRemoveHButtonGroupCommand)
  
end

function ToAddHButtonGroupCommand:registerHButtonGroupCommands()
  require "main.controller.command.mainScene.ToRemoveHButtonGroupCommand";
  self:registerCommand(MainSceneNotifications.TO_REMOVE_HBUTTON_GROUP_COMMAND, ToRemoveHButtonGroupCommand);
end
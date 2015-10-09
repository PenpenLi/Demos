

ToAddButtonGroupCommand=class(Command);

function ToAddButtonGroupCommand:ctor()
	self.class=ToAddButtonGroupCommand;
end

function ToAddButtonGroupCommand:execute(visible)
  
  require "main.view.mainScene.component.ButtonGroupMediator";
  
  local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name)
  if not buttonGroupMediator then
    if visible then
  		buttonGroupMediator = ButtonGroupMediator.new()
  		self:registerMediator(buttonGroupMediator:getMediatorName(),buttonGroupMediator)
      buttonGroupMediator:initialize();
      local winSize = Director:sharedDirector():getWinSize();
      buttonGroupMediator:getViewComponent():setPositionXY(winSize.width - 112, -GameData.uiOffsetY+116);
  		self:registerGuangboCommands()
      local layCurrency = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI)
      if layCurrency then
		    print("ToAddButtonGroupCommand *****************************layCurrency");
  		  layCurrency:addChild(buttonGroupMediator:getViewComponent());
      else
		    print("ToAddButtonGroupCommand *****************************layCurrency  is nil");
      end
  	end
  else
	  if not visible then
      buttonGroupMediator:getViewComponent():setVisible(false)
    else
      buttonGroupMediator:getViewComponent():setVisible(true)
    end
  end
    self:observe(ToRemoveButtonGroupCommand);
end

function ToAddButtonGroupCommand:registerGuangboCommands()
  require "main.controller.command.mainScene.ToRemoveGuangboCommand";
  self:registerCommand(MainSceneNotifications.TO_REMOVE_BUTTON_GROUP_COMMAND, ToRemoveGuangboCommand);
end
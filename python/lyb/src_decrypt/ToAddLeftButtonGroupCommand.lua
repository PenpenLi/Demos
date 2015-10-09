

ToAddLeftButtonGroupCommand=class(Command);

function ToAddLeftButtonGroupCommand:ctor()
	self.class=ToAddLeftButtonGroupCommand;
end

function ToAddLeftButtonGroupCommand:execute(visible)
  
  require "main.view.mainScene.component.LeftButtonGroupMediator";
  self:registerLeftButtonGroupCommands()
  local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
  if not leftButtonGroupMediator then
    if visible then
  		leftButtonGroupMediator = LeftButtonGroupMediator.new()
  		self:registerMediator(leftButtonGroupMediator:getMediatorName(),leftButtonGroupMediator)
      leftButtonGroupMediator:initialize();
      local winSize = Director:sharedDirector():getWinSize();
      leftButtonGroupMediator:getViewComponent():setPositionXY(0, -GameData.uiOffsetY + 103);
      local layCurrency = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI)
      if layCurrency then
		    print("ToAddLeftButtonGroupCommand *****************************layCurrency");
  		  layCurrency:addChild(leftButtonGroupMediator:getViewComponent());
      else
		    print("ToAddLeftButtonGroupCommand *****************************layCurrency  is nil");
      end
  	end
  else
	  if not visible then
      leftButtonGroupMediator:getViewComponent():setVisible(false)
    else
      leftButtonGroupMediator:getViewComponent():setVisible(true)
    end
  end
    self:observe(ToRemoveLeftButtonGroupCommand);
end
function ToAddLeftButtonGroupCommand:registerLeftButtonGroupCommands()
  require "main.controller.command.mainScene.ToRemoveLeftButtonGroupCommand";
  self:registerCommand(MainSceneNotifications.TO_REMOVE_LEFT_BUTTON_GROUP_COMMAND, ToRemoveLeftButtonGroupCommand);
end
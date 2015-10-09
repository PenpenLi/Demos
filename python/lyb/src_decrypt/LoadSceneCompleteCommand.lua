--加载完成

  
LoadSceneCompleteCommand = class(MacroCommand);

function LoadSceneCompleteCommand:ctor()
  self.class = LoadSceneCompleteCommand;
end

function LoadSceneCompleteCommand:execute(notification)
    require "main.controller.command.load.HandleCompleteCommand";
    require "main.controller.command.gameInit.GameInitCommand";
    --避免在当前Scene掉线,弹出提示框后被清理掉
    -- if not GameData.isConnect then
    --   return ;
    -- end

    -- local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
    -- local loadingMediator=self:retrieveMediator(LoadingMediator.name);  
    -- local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
     
    local userProxy = self:retrieveProxy(UserProxy.name)
    if GameData.isKickByOther then
      return
    else
      self:addSubCommand(PreloadSceneCloseCommand);  
    end
    

    if not userProxy.hasInit and notification.data.type ~= GameConfig.SCENE_TYPE_2 then
      self:addSubCommand(GameInitCommand);
    end

    self:addSubCommand(HandleCompleteCommand);
    self:complete(notification);

    if notification.data.data then
      local sendTable = notification.data.data;
      OpenFunctionUICommand.new():execute(Notification.new(_,sendTable));
    end
    self:checkOpenPanelOnLoadMainSceneComplete(notification);
end

function LoadSceneCompleteCommand:checkOpenPanelOnLoadMainSceneComplete(notification)
  if notification.data.type == GameConfig.SCENE_TYPE_1 then
      local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
      local id=openFunctionProxy:getOpenPanelByLoadSceneComplete();
      if id then
        OpenFunctionUICommand.new():execute(Notification.new(_,id));
      end
  end
end
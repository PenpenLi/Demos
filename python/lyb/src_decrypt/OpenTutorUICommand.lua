

OpenTutorUICommand=class(Command);

function OpenTutorUICommand:ctor()
	self.class=OpenTutorUICommand;
end

function OpenTutorUICommand:execute(data)
  -- if true then
  --   return;
  -- end
  print("GameVar.tutorStage,OpenTutorUICommand, x, y, width, height,alpha", GameVar.tutorStage,data.x, data.y, data.width, data.height,data.alpha)
  GameVar.lastTutorData = data;
  self:requireCommands();

  
  self:removePopupPanels();
  
  local tutorMediator=self:retrieveMediator(TutorMediator.name);  
  local userProxy = self:retrieveProxy(UserProxy.name)
  if nil == tutorMediator then
    tutorMediator=TutorMediator.new();
    self:registerMediator(tutorMediator:getMediatorName(), tutorMediator);
    tutorMediator:initializeUI(nil, userProxy, data);
    self:registerCommands()
  else
    tutorMediator:refreshData(data);
  end
  tutorMediator:getViewComponent():setScale(1);

  local preloadSceneMediator=self:retrieveMediator(PreloadSceneMediator.name);
  if preloadSceneMediator and preloadSceneMediator:getViewComponent().sprite then
     tutorMediator:getViewComponent():setScale(GameData.gameUIScaleRate)
     preloadSceneMediator:getViewComponent():addChild(tutorMediator:getViewComponent());
     --修正屏幕适配
     --local winSize = CCDirector:sharedDirector():getWinSize();
     --tutorMediator:getViewComponent():setPositionXY((winSize.width - GameConfig.STAGE_WIDTH)/2 * GameData.gameUIScaleRate,(winSize.height - GameConfig.STAGE_HEIGHT)/2* GameData.gameUIScaleRate); 
  else
      local scene = Director.sharedDirector():getRunningScene();   
  
      if scene then
            print("scene.name", scene.name);
            if scene.name == GameConfig.MAIN_SCENE or (data.sceneName and data.sceneName == GameConfig.MAIN_SCENE) then
              sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(tutorMediator:getViewComponent());
            elseif  scene.name == GameConfig.BATTLE_SCENE and sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI) then
              if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):contains(tutorMediator:getViewComponent()) then
                sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):removeChild(tutorMediator:getViewComponent(), false);
              end
     
              tutorMediator:getViewComponent():setPositionXY(GameData.uiOffsetX * -1,GameData.uiOffsetY * -1)
              sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):addChild(tutorMediator:getViewComponent());
            end
       

       else
            if sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):contains(tutorMediator:getViewComponent()) then
                sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):removeChild(tutorMediator:getViewComponent(), false);
            end
            sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(tutorMediator:getViewComponent()); 
       end
  end
end
function OpenTutorUICommand:requireCommands()
	require "main.view.tutor.TutorMediator";
	--require "main.controller.command.tutor.TutorCloseCommand";
	--require "main.controller.notification.TutorNotification";
end
function OpenTutorUICommand:removePopupPanels()

  if ModalDialogMediator then
    local modalDialogMed=self:retrieveMediator(ModalDialogMediator.name);
    if modalDialogMed then
      self:removeMediator(modalDialogMed.name);
    end
  end
end

function OpenTutorUICommand:registerCommands()
  --self:registerCommand(TutorNotifications.TUTOR_UI_CLOSE, TutorCloseCommand);
end

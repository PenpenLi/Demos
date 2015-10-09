--[[

]]

require "main.view.storyLine.StoryLineMediator";

OpenStoryLineUICommand=class(Command);

function OpenStoryLineUICommand:ctor()
	self.class=OpenStoryLineUICommand;
end

function OpenStoryLineUICommand:execute(notification)
  -- if true then
  --           require "main.view.shadow.NewHeroOpenMediator";
  --           require "main.controller.command.shadow.NewHeroOpenCloseCommand";
  --           local shadowProxy = self:retrieveProxy(ShadowProxy.name)
            
  --           local newHeroOpenMediator = self:retrieveMediator(NewHeroOpenMediator.name)
  --           if nil == newHeroOpenMediator then
  --             newHeroOpenMediator = NewHeroOpenMediator.new();
  --             self:registerMediator(newHeroOpenMediator:getMediatorName(), newHeroOpenMediator);
  --             self:observe(NewHeroOpenCloseCommand);
  --             self:registerCommand(ShadowNotifications.CLOSE_NEW_HERO_OPEN_COMMAND,NewHeroOpenCloseCommand)
  --           end

  --           LayerManager:addLayerPopable(newHeroOpenMediator:getViewComponent());
  --           local heroId = analysis("Juqing_Yingxiongzhi", 21010101, "heroId");
  --           newHeroOpenMediator:initializeUI(heroId)
  --           return;
  -- end

  self.notification = notification;
  self:require();
  
  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name)

  if self.notification.data.strongPointId then
    self.tempStrongPointId =  self.notification.data.strongPointId;
    self.tempStrongPointState = self.storyLineProxy:getStrongPointState(self.tempStrongPointId)
  else
    self.tempStrongPointId =  self.storyLineProxy.lastStrongPointId;
    self.tempStrongPointState = self.storyLineProxy.lastStrongPointState
  end
  print("++++++++++++++++++++, self.tempStrongPointId, self.tempStrongPointState:", self.tempStrongPointId, self.tempStrongPointState)

  local scriptId;
  if self.tempStrongPointState == GameConfig.STRONG_POINT_STATE_3 and (GameVar.tutorStage ~= TutorConfig.STAGE_1006 or (GameVar.tutorStage == TutorConfig.STAGE_1006 and self:retrieveProxy(HeroHouseProxy.name):getGeneralDataByConfigID(77) ~= nil))then--又是新手
    local duiguaPos = analysisByName("Juqing_Guankaduihua", "paramId",self.tempStrongPointId);
    for k, v in pairs(duiguaPos)do
      if v.weizhi == 1 then
        scriptId = v.functionId;
      end
    end
  end
  if scriptId then
    print("scriptId:", scriptId)
    require "main.controller.command.scriptCartoon.MainSceneScript"
    self.mainSceneScript = MainSceneScript.new()
    self.mainSceneScript:initScript(self)
    self.mainSceneScript:beginScript(scriptId)

    if GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
      closeTutorUI(false);
    end
  else
    self:showStoryLineUI();
  end
end
function OpenStoryLineUICommand:readyEndScript()
  print("readyEndScript()")
  self.storyLineProxy:setStrongPointState(self.tempStrongPointId, GameConfig.STRONG_POINT_STATE_4);
  sendMessage(4,2,{StrongPointId = self.tempStrongPointId})
  if self.mainSceneScript then
    self.mainSceneScript:dispose()
    self.mainSceneScript = nil;
  end
  self:showStoryLineUI();
  -- error("OpenStoryLineUICommand:readyEndScript()")
end
function OpenStoryLineUICommand:showStoryLineUI()
  self.storyLineMediator=self:retrieveMediator(StoryLineMediator.name);  
  if nil==self.storyLineMediator then
    self.storyLineMediator=StoryLineMediator.new();
    self:registerMediator(self.storyLineMediator:getMediatorName(),self.storyLineMediator);
    self:registerStoryLineUI();
  end

  self:observe(StoryLineCloseCommand);
  LayerManager:addLayerPopable(self.storyLineMediator:getViewComponent());

  if GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
      if self.notification.data.storyLineId then
        log("self.notification.data.storyLineId:" .. self.notification.data.storyLineId)
        self.storyLineProxy.storyLineId = self.notification.data.storyLineId
      end
      
      local heroData = self:retrieveProxy(HeroHouseProxy.name):getGeneralDataByConfigID(77)
      if heroData then
        print("llllllllllllllllllllllllllllll0000000000000000000000llllllllll")
      end
      if GameVar.tutorStage == TutorConfig.STAGE_1006 and self:retrieveProxy(HeroHouseProxy.name):getGeneralDataByConfigID(77) == nil then
        self.storyLineMediator:refreshData(20001);
      else
        self.storyLineMediator:refreshData(self.storyLineProxy.storyLineId);
      end

      local storyLinePo = analysis("Juqing_Juqing",self.storyLineProxy.storyLineId)

      local strongPoints = analysisByName("Juqing_Guanka","storyId", self.storyLineProxy.storyLineId)
      local mapUIData = analysisMapUI(storyLinePo.mapId)
      local detailTable = mapUIData.outersTable
      
      local curBattleStrongPointId--当前可以打的战斗id
      ----add 房子
      for k,v in pairs(strongPoints) do
        print("strongPointId", v.id)
        local strongPointInEditor = detailTable[v.strongPointId]
        local strongPointData = self.storyLineProxy.strongPointArray["key_"..v.id];
        if strongPointData then
          if strongPointData.State == GameConfig.STRONG_POINT_STATE_3 or strongPointData.State == GameConfig.STRONG_POINT_STATE_4 then
             curBattleStrongPointId = v.id
             if (GameVar.tutorStage == TutorConfig.STAGE_1006 and self:retrieveProxy(HeroHouseProxy.name):getGeneralDataByConfigID(77) == nil) or GameVar.tutorStage == TutorConfig.STAGE_1027  then

             else
                openTutorUI({x=strongPointInEditor.xPos+6, y=strongPointInEditor.yPos-122, width = 95, height = 94, alpha = 125});
             end
             break;
          end
        end
      end

  elseif self.notification.data.strongPointId then
    self.storyLineMediator:setData(self.notification.data.strongPointId);
  else
    if self.notification.data.storyLineId then
      self.storyLineMediator:refreshData(self.notification.data.storyLineId);
      if self.notification.data.popUpFullStar then
        self.storyLineMediator:getViewComponent():popUpFullStar()
      end

    else
      self.storyLineMediator:refreshData(self.storyLineProxy.storyLineId);
    end
  end
end

function OpenStoryLineUICommand:registerStoryLineUI()
  self:registerCommand(StrongPointInfoNotifications.CLOSE_STORYLINE_UI_COMMOND, StoryLineCloseCommand);
end

function OpenStoryLineUICommand:require()

  require "main.controller.command.storyLine.StoryLineCloseCommand";
end
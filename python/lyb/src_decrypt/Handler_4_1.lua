
require "core.display.Director";
require "main.controller.command.load.BeginLoadingSceneCommand";
require "main.controller.notification.LoadingNotification";


--返回 关卡数据,为了提高用户体验，，，打开界面的时候不发命令。直接刷新界面
Handler_4_1 = class(MacroCommand);

function Handler_4_1:execute()
    

    self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
    self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);

    self.currentStoryLineId = recvTable["StoryLineId"]
    local strongPointArray = recvTable["StrongPointArray"];
    print("+++++++++++++++++++self.currentStoryLineId",self.currentStoryLineId)
    
    local scene = Director.sharedDirector():getRunningScene();      

    for i_k, i_v in pairs(strongPointArray) do  

      local key = "key_" .. i_v.StrongPointId;
      local oldStrongPointData = self.storyLineProxy.strongPointArray[key];
      
      if oldStrongPointData and oldStrongPointData.State ~= i_v.State and i_v.State == 1 then
        self:checkFunctionOpen(i_v.StrongPointId)
        self:setTutorStage(i_v.StrongPointId);
      elseif i_v.StrongPointId == 21010101 and  i_v.State == 1 and i_v.TotalCount == 1 and self.storyLineProxy.standPoint == 1 then
        -- print("i_v.StrongPointId == 21010101 xiaojingrui+++++++++++")
        if scene.name == GameConfig.BATTLE_SCENE then
          self:setTutorStage(i_v.StrongPointId);
        end
      end

      self.storyLineProxy.strongPointArray[key] = i_v;

      log("StrongPointId:" .. i_v.StrongPointId .. ",State:" ..  i_v.State .. "i_v.Count:" .. i_v.Count)
      local strongPointPo = analysis("Juqing_Guanka", i_v.StrongPointId)--1表示是主线关卡, "Gtype"

      if (i_v.State == 3 or i_v.State == 4) and strongPointPo.Gtype == 1 then--
        self.storyLineProxy.lastStrongPointId = i_v.StrongPointId;--开启的最远的关卡
        self.storyLineProxy.lastStrongPointState = i_v.State;
        self.storyLineProxy.storyLineId = strongPointPo.storyId;

        -- print("mmmmmmmmmmmmmmmmm  self.storyLineProxy.storyLineId", self.storyLineProxy.storyLineId)

        local battleProxy = self:retrieveProxy(BattleProxy.name)
        battleProxy.storyLineId = nil;
        self:setOpenedStoryLines();

      end

      if strongPointPo.Gtype == 2 then -- if is shadow
        if (oldStrongPointData == nil 
        or oldStrongPointData.State == GameConfig.STRONG_POINT_STATE_2
        or oldStrongPointData.State == GameConfig.STRONG_POINT_STATE_4) 
        and i_v.State == GameConfig.STRONG_POINT_STATE_3 then

          if i_v.StrongPointId ~= 21010101 then  -- 不是萧景睿才弹
            local shadowProxy = self:retrieveProxy(ShadowProxy.name)
            shadowProxy.newHeroStrongPointId = i_v.StrongPointId
          end
        end
      end 
    end

    -- if scene.name == GameConfig.MAIN_SCENE and GameVar.tutorStage ~= TutorConfig.STAGE_1002 then
    --    OpenStoryLineUICommand.new():execute(ShadowNotification.new(StrongPointInfoNotifications.OPEN_STORYLINE_UI_COMMOND,{storyLineId = self.currentStoryLineId}));
    -- end



    if self.currentStoryLineId == 0 then
      self:refreshShadowHeroUI()
    else
       local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.currentStoryLineId)
       for k, v in pairs(strongPoints) do
          local strongPointData = self.storyLineProxy.strongPointArray["key_" .. v.id];
          if not strongPointData then
            self.storyLineProxy.strongPointArray["key_" .. v.id] = {StrongPointId=v.id,State=2,Count=0,TotalCount=0}
          end
       end
    end
end

function Handler_4_1:refreshShadowHeroUI()
  if ShadowHeroImageMediator then
    local shadowHeroImageMediator=self:retrieveMediator(ShadowHeroImageMediator.name);  
    if shadowHeroImageMediator then
      shadowHeroImageMediator:refreshInfo()
      print("shadowHeroImageMediator:refreshInfo()")
    end
  end
end

function Handler_4_1:checkFunctionOpen(strongPointId)

  local openFunctionID = self.openFunctionProxy:getOpenFunctionButton(2,strongPointId)
  self.openFunctionProxy.newOpenFunctionId = openFunctionID;

end
-- function Handler_4_1:checkAllOpenFunctions()

--   -- 判断功能开启
--   self.openFunctionProxy:checkOpenFunctionsByStrongPoint(self.storyLineProxy.strongPointArray)

--   if ButtonGroupMediator then
--       local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name)
--       if buttonGroupMediator then
--         buttonGroupMediator:openButtons(self.openFunctionProxy:getOpenedVMenu());
--       end
--   end
--   if LeftButtonGroupMediator then
--       local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
--       if leftButtonGroupMediator then
--         leftButtonGroupMediator:openButtons(self.openFunctionProxy:getOpenedLeftMenu());
--       end
--   end
--   if HButtonGroupMediator then
--       local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
--       if hButtonGroupMediator then
--         hButtonGroupMediator:openButtons(self.openFunctionProxy:getOpenedHMenu1());
--       end
--   end

-- end
function Handler_4_1:setOpenedStoryLines()
  if not Utils:contain(self.storyLineProxy.openedStorylineIds, self.storyLineProxy.storyLineId) then
    table.insert(self.storyLineProxy.openedStorylineIds, self.storyLineProxy.storyLineId)
    local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineProxy.storyLineId)
    for k, v in pairs(strongPoints)do
      local strongPointData = self.storyLineProxy.strongPointArray["key_" .. v.id];
      if not strongPointData then
        local strongPointData = {StrongPointId = v.id, State= 2};
        local key = "key_" .. v.id;
        self.storyLineProxy.strongPointArray[key] = strongPointData;
      end
    end
  end
    -- self.storyLineProxy.openedStorylineIds = {};
    -- local tempStoryLineId2 = self.storyLineProxy.storyLineId;

    -- while (tempStoryLineId2 ~= 0 and tempStoryLineId2) do
    --   table.insert(self.storyLineProxy.openedStorylineIds, 1, tempStoryLineId2)

    --   if analysisHas("Juqing_Juqing", tempStoryLineId2) then
    --     tempStoryLineId2 = analysis("Juqing_Juqing", tempStoryLineId2, "parent")
    --     if tempStoryLineId2 ~= 0 then
    --       local strongPoints = analysisByName("Juqing_Guanka", "storyId", tempStoryLineId2)
    --       for k, v in pairs(strongPoints)do
    --         local strongPointData = self.storyLineProxy.strongPointArray["key_" .. v.id];
    --         if not strongPointData then
    --           local strongPointData = {StrongPointId = v.id, State= 1};
    --           local key = "key_" .. v.id;
    --           self.storyLineProxy.strongPointArray[key] = strongPointData;
    --         end
    --       end
    --     end
    --   else
    --     break;
    --   end
    -- end
end



--根据任务id，状态获得阶段
function Handler_4_1:getTutorByStrongPoint(strongPointId)
    local stageArr = analysisByName("Xinshouyindao_Xinshou", "guanqiaid", strongPointId)
    for i_k, i_v in pairs(stageArr) do
      return i_v.jieduan;
    end
    return nil;
end

function Handler_4_1:setTutorStage(strongPointId)
  if not GameVar.skipTutor then
     local stage = self:getTutorByStrongPoint(strongPointId);
     if stage then
        print("!!!!!!!!!!!!!!!!!!!stage:" .. stage .. ",strongPointId:" .. strongPointId);
     end
     if stage and stage > 0 and stage ~= TutorConfig.STAGE_2003 then
        GameVar.tutorStage = stage;
        GameVar.tuturReaccess = false;
        GameVar.tutorSmallStep = 0;
        sendServerTutorMsg({Stage = GameVar.tutorStage})
     end
  end
end


Handler_4_1.new():execute();

HandleTutorCommand = class(MacroCommand);

function HandleTutorCommand:ctor()
  self.class = HandleTutorCommand;
end

function HandleTutorCommand:execute(notification)
  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
  local bttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
  local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name);



  print("???????????????????????????????????????GameVar.tutorStage", GameVar.tutorStage)
  if GameVar.tutorStage == TutorConfig.STAGE_1002 then
      -- if GameVar.tutorStage == TutorConfig.STAGE_1002 and GameVar.tutorSmallStep == 0 then
      --   local scriptId;

      --   local duiguaPos = analysisByName("Juqing_Guankaduihua", "paramId",10001001);
      --   for k, v in pairs(duiguaPos)do
      --       scriptId = v.functionId;
      --   end
      --   --   require "main.controller.command.scriptCartoon.GameScript"
      --   -- local gameScript = GameScript.new()
      --   -- gameScript:beginScript(9009)
      --   GameVar.hideCurrencyForTutor = true;
      --   return;
      -- end
      GameVar.tutorSmallStep = 0;
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1003 then
    if GameVar.tutorSmallStep == 100311 then
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
        return;
    end
    
    GameVar.tutorSmallStep = 100301;
    local targetPosData = leftButtonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_12)--琅琊令
    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_SMALL_BTN_W, height = GameConfig.TUTOR_SMALL_BTN_H});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1004  then
    if GameVar.tutorSmallStep == 100407 then
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
    else
      local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});

      -- openTutorUI({x=100, y=100, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H, x2=200,y2=200,x3=200,y3=400});
    end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1005  then
      if GameVar.tutorSmallStep == 100503 then
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
      else
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_8)--任务
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1006 then
    print("GameVar.tutorSmallStep,",GameVar.tutorSmallStep)
    if StoryLineMediator and self:retrieveMediator(StoryLineMediator.name) then
      openTutorUI({x=64, y=593, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
    else
      if GameVar.tutorSmallStep == 100603 then
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      elseif GameVar.tutorSmallStep == 100607 then

        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});

      else
        GameVar.hideCurrencyForTutor = true;
        GameVar.tutorSmallStep = 0;
        OpenStoryLineUICommand.new():execute(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_STORYLINE_UI_COMMOND, {storyLineId =  20001}));
        openTutorUI({x=64, y=593, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
    end
  elseif  GameVar.tutorStage == TutorConfig.STAGE_1007  then
    local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_22)--英雄志
    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});

  elseif  GameVar.tutorStage == TutorConfig.STAGE_1008  then

    if GameVar.tuturReaccess then
      if GameVar.tutorSmallStep == 100808 then 
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
      else
        GameVar.tutorSmallStep = 100803
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
    else
      openTutorUI({x=1095, y=451, width = 93, height = 76});
    end
  elseif  GameVar.tutorStage == TutorConfig.STAGE_1009 then
      GameVar.tutorSmallStep = 100900
      local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H}); 
  elseif GameVar.tutorStage == TutorConfig.STAGE_1010 then
      if GameVar.tutorSmallStep == 101003 then
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H}); 
      else
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_8)--任务
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1023 then
      openTutorUI({x=29 - GameData.uiOffsetX, y=620 + GameData.uiOffsetY, width = 100, height = 85});
  elseif GameVar.tutorStage == TutorConfig.STAGE_2010 then
      local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_23)--装备强化
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});

  elseif GameVar.tutorStage == TutorConfig.STAGE_1012 then
      if GameVar.tutorSmallStep == 101216 then
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
      else
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_32)--势力
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1014 then
    local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H}); 
  elseif  GameVar.tutorStage == TutorConfig.STAGE_1017 then

    local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H}); 

  -- elseif GameVar.tutorStage == TutorConfig.STAGE_2003 then--2003是签到
  --     local targetPosData = leftButtonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_29)--签到
  --     openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_SMALL_BTN_W, height = GameConfig.TUTOR_SMALL_BTN_H});
  elseif GameVar.tutorStage == TutorConfig.STAGE_2004 then--2004是活动
      local targetPosData = mainSceneMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_41)--活动
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_SMALL_BTN_W, height = GameConfig.TUTOR_SMALL_BTN_H});
  elseif  GameVar.tutorStage == TutorConfig.STAGE_1005  or GameVar.tutorStage == TutorConfig.STAGE_1025 then--2006是任务
      if GameVar.tutorSmallStep == 100503 then
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
      else
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_8)--任务
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1024 or GameVar.tutorStage == TutorConfig.STAGE_1028 then--2008琅琊试炼

        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_36)--琅琊试炼
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});

  elseif GameVar.tutorStage == TutorConfig.STAGE_1016 then--1016是论剑

      local arenaProxy=self:retrieveProxy(ArenaProxy.name);
      if arenaProxy.afterBattle then
        GameVar.tutorSmallStep = 101604;
        openTutorUI({x=846, y=558, width = 86, height = 86, alpha = 125});
      else
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_26)--论剑
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
      end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1020 then--1020是寻宝
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_44)--寻宝
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1026 then--2012是势力
      local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
      if tenCountryProxy.afterBattle then
        if TenCountryMediator then
          local tenCountryMediator=self:retrieveMediator(TenCountryMediator.name);
          if tenCountryMediator then
            GameVar.tutorSmallStep = 102604
            openTutorUI({x=154, y=246, width = 73, height = 77, alpha = 125});
          end
        end
      else
        if GameVar.tutorSmallStep == 102608 then
          openTutorUI({x=29 - GameData.uiOffsetX, y=620 + GameData.uiOffsetY, width = 100, height = 85});
        else
          GameVar.tutorSmallStep = 0
          local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_32)--势力
          openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
        end
      end
  elseif GameVar.tutorStage == TutorConfig.STAGE_2014 then--2014是购买体力药
      openTutorUI({x=981, y=674+GameData.uiOffsetY, width = 40, height = 40});
  end
end


function HandleTutorCommand:addGuangbo()
  require "main.controller.command.mainScene.ToAddGuangboCommand";
  ToAddGuangboCommand.new():execute();
end
        
--变黑过度
function HandleTutorCommand:sceneBlackFade(blackFadeInBackFun)
    local function fadeInBack()
    	blackFadeInBackFun()
		local layer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE);
		blackFadeOut(nil,nil,nil,layer)
    end
    blackFadeIn(fadeInBack)
end
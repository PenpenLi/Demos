require "main.controller.command.mainScene.EnterBattleStuffCommand";
require "main.view.tutor.TutorMediator";
require "main.view.functionScene.FunctionSceneMediator";
require "main.controller.command.bagPopup.CheckBetterEquipCommand"
require "main.controller.command.load.HandleTutorCommand"

HandleCompleteCommand = class(MacroCommand);

function HandleCompleteCommand:ctor()
  self.class = HandleCompleteCommand;
end

function HandleCompleteCommand:execute(notification)


	require "main.controller.command.battleScene.OutBattleStuffCommand";
	require "main.view.mainScene.MainSceneMediator";
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
	local loadingMediator=self:retrieveMediator(LoadingMediator.name);  
	local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
  local huodongProxy = self:retrieveProxy(HuoDongProxy.name);

	local userProxy = self:retrieveProxy(UserProxy.name)

  LayerManager.showCurrencys = {};

	if userProxy.hasInit then
		if notification.data.type == GameConfig.SCENE_TYPE_1 or  notification.data.type == GameConfig.SCENE_TYPE_2 then
  		if not mainSceneMediator then
  			InitMainSceneCommand.new():execute();
  			mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
  		end
      if GameData.currentSceneIndex ~= 2 then

        if GameData.currentSceneIndex == 3 then
        	OutBattleStuffCommand.new():execute();--处理战场结束后做的事	
          JudgeReddotCommand.new():execute({data={functionId=0}})
        end
        GameData.isPopQuitPanel = false
        
        Director:sharedDirector():replaceScene(mainSceneMediator:getViewComponent());
        GameData.currentSceneIndex = 2
        self:addGuangbo();

        -- if GameData.isKickByOther then
        --   return
        -- else
        --   Director:sharedDirector():replaceScene(mainSceneMediator:getViewComponent());
        --   GameData.currentSceneIndex = 2

        --   self:addGuangbo();
        -- end
      end		    
			-- 切换场景时需要做的事
			sharedBattleLayerManager():disposeBattleLayerManager()
      if BattleOverMediator then
			   self:removeMediator(BattleOverMediator.name)	
      end
      -- if LotteryMediator then
			   -- self:removeMediator(LotteryMediator.name)
      -- end
			self:removeMediator(BattleSceneMediator.name)
			self:removeMediator(FunctionSceneMediator.name)
      
      if CurrencyGroupMediator then
        local currencyGroupMediator=self:retrieveMediator(CurrencyGroupMediator.name);  
        if currencyGroupMediator then
          currencyGroupMediator:setHuobiText()
        end
      end

		end
	end

  local operatonProxy = self:retrieveProxy(OperationProxy.name);
  local function blackFadeInBackFun()
      -- self:removeMediator(LoadingMediator.name);

    loadingMediator:getViewComponent().loadingShowLayer:onSlotScaleTap()
    loadingMediator:removeSelf()
    
      if notification.data.type == GameConfig.SCENE_TYPE_1 then--city
          local mapSceneData = notification.data.mapSceneData
          mainSceneMediator:changeStoryLine(mapSceneData);
          if not GameVar.isFirstEnterGame then
              GameVar.isFirstEnterGame = true;
              sendMessage(2, 13);
              addMaskLayer();
          end

          local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
          openFunctionProxy:checkAllOpenFunctions(userProxy:getLevel(), storyLineProxy.strongPointArray, userProxy.nobility)


          if ButtonGroupMediator then
              local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name)
              if buttonGroupMediator then
                buttonGroupMediator:openButtons(openFunctionProxy:getOpenedVMenu());
                buttonGroupMediator:refreshRenwu()
              end
          end
          if LeftButtonGroupMediator then
              local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
              if leftButtonGroupMediator then
                leftButtonGroupMediator:openButtons(openFunctionProxy:getOpenedLeftMenu());
                leftButtonGroupMediator:refreshQianDao()
                -- leftButtonGroupMediator:refreshRedDot()
              end
          end
          if HButtonGroupMediator then
              local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
              if hButtonGroupMediator then
                hButtonGroupMediator:openButtons(openFunctionProxy:getOpenedHMenu1());
              end
          end

          if mainSceneMediator then 
            mainSceneMediator:openButtons(openFunctionProxy:getOpenedHMenu2());
          end
          print("GameVar.tutorStage,openFunctionProxy.newOpenFunctionId", GameVar.tutorStage, openFunctionProxy.newOpenFunctionId)
          if openFunctionProxy.newOpenFunctionId and openFunctionProxy.newOpenFunctionId ~= 0 then
              local addFunctionOpen = true;
              if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
                if 2 == analysis("Xinshouyindao_Xinshou", GameVar.tutorStage * 100 + 1, "DialogueType") or  GameVar.tutorStage == TutorConfig.STAGE_1010  then
                  addFunctionOpen = false;
                end
              end
              if addFunctionOpen then
                ToAddFunctionOpenCommand.new():execute(MainSceneNotification.new(MainSceneNotifications.TO_ADD_FUNCTION_OPEN_UI, {functionId = openFunctionProxy.newOpenFunctionId}));
              else
                HandleTutorCommand.new():execute();
              end
          elseif GameVar.tutorStage == TutorConfig.STAGE_99999 then
            local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
            if userProxy:getLevel() < 20 then
              print("userProxy.mainGeneralLevel < 20")
              if hBttonGroupMediator then
                hBttonGroupMediator:addTutorEffect()
              end
            end
          elseif GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
            HandleTutorCommand.new():execute();
          end
      elseif notification.data.type == GameConfig.SCENE_TYPE_3 or notification.data.type == GameConfig.SCENE_TYPE_2 then--战场
        local scene = Director.sharedDirector():getRunningScene();
        if getTextAnimateRewardInstance() and scene.name == GameConfig.MAIN_SCENE then
           scene:removeChild(getTextAnimateRewardInstance());
        end
      	if battleProxy.isContinueBattle then
            self:removeMediator(BattleOverMediator.name)
            -- self:removeMediator(LotteryMediator.name)
      		  sharedBattleLayerManager():clear()
      	end
        --local data = {type = "Handler_7_1"}; --- fjm
        --BattleInitCommand.new():execute(data);
        local generalProxy=self:retrieveProxy(GeneralListProxy.name);
        local openFunProxy=self:retrieveProxy(OpenFunctionProxy.name);
        local operatonProxy = self:retrieveProxy(OperationProxy.name);
        local generalListProxy=self:retrieveProxy(GeneralListProxy.name);
        local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
        generalListProxy.expDontDisplay = true;--战场结束经验不飘字，特殊处理
        local battleSceneMediator=self:retrieveMediator(BattleSceneMediator.name);
        if not battleSceneMediator then
            battleSceneMediator=BattleSceneMediator.new();
            self:registerMediator(battleSceneMediator:getMediatorName(),battleSceneMediator);
            battleSceneMediator:intializeUI(battleProxy:getSkeleton(),battleProxy,userProxy,generalProxy,openFunProxy,operatonProxy,storyLineProxy);
        end
        battleProxy.AIBattleField:initBattle(battleSceneMediator);
      end
  end
  if notification.data.type == GameConfig.SCENE_TYPE_3 or notification.data.type == GameConfig.SCENE_TYPE_2 then
    self:sceneBlackFade(blackFadeInBackFun)
  else
    blackFadeInBackFun(true)
  end
end

function HandleCompleteCommand:addGuangbo()
  require "main.controller.command.mainScene.ToAddGuangboCommand";
  ToAddGuangboCommand.new():execute();
end
        
--变黑过度
function HandleCompleteCommand:sceneBlackFade(blackFadeInBackFun)
    local function fadeInBack()
    	blackFadeInBackFun()
		local layer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE);
		blackFadeOut(nil,nil,nil,layer)
    end
    blackFadeIn(fadeInBack)
end
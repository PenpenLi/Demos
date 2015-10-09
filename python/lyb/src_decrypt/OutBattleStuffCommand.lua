-------------------------
-- close battle Mediator
-------------------------

OutBattleStuffCommand=class(MacroCommand);

function OutBattleStuffCommand:ctor()
	self.class=OutBattleStuffCommand;
end

function OutBattleStuffCommand:execute()
   
 -- local shadowProxy = self:retrieveProxy(ShadowProxy.name)
        
 --          shadowProxy.newHeroStrongPointId = 21010101

 --            require "main.view.shadow.NewHeroOpenMediator";
 --            require "main.controller.command.shadow.NewHeroOpenCloseCommand";

 --            local newHeroOpenMediator = self:retrieveMediator(NewHeroOpenMediator.name)
 --            if nil == newHeroOpenMediator then
 --              newHeroOpenMediator = NewHeroOpenMediator.new();
 --              self:registerMediator(newHeroOpenMediator:getMediatorName(), newHeroOpenMediator);
 --              self:observe(NewHeroOpenCloseCommand);
 --              self:registerCommand(ShadowNotifications.CLOSE_NEW_HERO_OPEN_COMMAND,NewHeroOpenCloseCommand)
 --            end

 --            LayerManager:addLayerPopable(newHeroOpenMediator:getViewComponent());
 --            local heroId = analysis("Juqing_Yingxiongzhi", shadowProxy.newHeroStrongPointId, "heroId");
 --            newHeroOpenMediator:initializeUI(heroId)

 --            shadowProxy.newHeroStrongPointId = nil
               
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  if battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 then return end
  self:initializeSmallChat();

  local battleType = battleProxy.battleType;
  local openFunctionId = battleProxy.openFunctionId;
  local openGeneralId = battleProxy.openGeneralId;

  print("openFunctionId",openFunctionId);
  print("OutBattleStuffCommand,battleType",battleType)
  if openFunctionId then
       self:addSubCommand(OpenFunctionUICommand);
       battleProxy.openFunctionId = nil;
       battleProxy.openGeneralId = nil;
  else
      if battleType == BattleConfig.BATTLE_TYPE_1 then
          -- 寻宝特殊处理
          local xunbaoProxy = self:retrieveProxy(XunbaoProxy.name);
          if xunbaoProxy.isFromXunbao then
            sendMessage(8,6)
            xunbaoProxy.isFromXunbao = false
            return
          end

          local shadowProxy = self:retrieveProxy(ShadowProxy.name)
          -- shadowProxy.newHeroStrongPointId = 21010101
          if shadowProxy.newHeroStrongPointId and GameVar.tutorStage == TutorConfig.STAGE_99999 then -- 有新英雄志的英雄开启时，否则打开剧情图

            require "main.view.shadow.NewHeroOpenMediator";
            require "main.controller.command.shadow.NewHeroOpenCloseCommand";

            local newHeroOpenMediator = self:retrieveMediator(NewHeroOpenMediator.name)
            if nil == newHeroOpenMediator then
              newHeroOpenMediator = NewHeroOpenMediator.new();
              self:registerMediator(newHeroOpenMediator:getMediatorName(), newHeroOpenMediator);
              self:observe(NewHeroOpenCloseCommand);
              self:registerCommand(ShadowNotifications.CLOSE_NEW_HERO_OPEN_COMMAND,NewHeroOpenCloseCommand)
            end

            LayerManager:addLayerPopable(newHeroOpenMediator:getViewComponent());
            newHeroOpenMediator:initializeUI(shadowProxy.newHeroStrongPointId)

            shadowProxy.newHeroStrongPointId = nil

          else

            local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
            if GameVar.tutorStage == TutorConfig.STAGE_1006 then
              OpenStoryLineUICommand.new():execute(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_STORYLINE_UI_COMMOND, {storyLineId =  battleProxy.storyLineId}));
            elseif GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= 99999 then
            else
              local scriptId;
              local duiguaPos = analysisByName("Juqing_Guankaduihua", "paramId",battleProxy.strongPointId);
              for k, v in pairs(duiguaPos)do
                if v.weizhi == 2 then
                  scriptId = v.functionId
                end
              end
              if scriptId then
                require "main.controller.command.scriptCartoon.MainSceneScript"
                self.mainSceneScript = MainSceneScript.new()
                self.mainSceneScript:initScript(self)
                self.mainSceneScript:beginScript(scriptId)
              else
                self:showStoryLineUI()
              end
            end
          end

      elseif battleType == BattleConfig.BATTLE_TYPE_2 then
            sendMessage(3,6,{TimerType = GameConfig.USER_CDTIME_TYPE_1.."_0"})        
            local arenaProxy=self:retrieveProxy(ArenaProxy.name);
            arenaProxy.afterBattle = true

            self:initializeArena();
      elseif battleType == BattleConfig.BATTLE_TYPE_3 then
            if GameVar.tutorStage == TutorConfig.STAGE_1026 then
              -- GameVar.tutorSmallStep = GameVar.tutorSmallStep - 1;
              local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
              tenCountryProxy.afterBattle = true
            end
            self:initializeTenCountry();
      elseif battleType == BattleConfig.BATTLE_TYPE_7 then
            self:initializeObtainSilverUI()
      elseif battleType == BattleConfig.BATTLE_TYPE_5 then
            self:initializeTreasuryUI()
      elseif battleType == BattleConfig.BATTLE_TYPE_6 then
            self:initializeTreasuryUI()
      elseif battleType == BattleConfig.BATTLE_TYPE_9 then
        
            -- 寻宝特殊处理
            local xunbaoProxy = self:retrieveProxy(XunbaoProxy.name);
            if xunbaoProxy.isFromXunbao then
              sendMessage(8,6)
              xunbaoProxy.isFromXunbao = false
              return
            end

            self:initializeMeetingUI()
      elseif battleType == BattleConfig.BATTLE_TYPE_10 then--英雄志
           self:initializeHeroImage(battleProxy.strongPointId);
           if battleProxy.battleResault then
              local extensionTable = {}
              extensionTable["yingxiongzhiID"] = battleProxy.strongPointId
              hecDC(3,30,2,extensionTable)
           end
           -- self:initializeEighteenCopper();
      -- elseif battleType == BattleConfig.BATTLE_TYPE_11 then
      --       self:initializeFiveEleUI();
      elseif battleType == BattleConfig.BATTLE_TYPE_12 then --寻宝
            sendMessage(8,6)
      elseif battleType == BattleConfig.BATTLE_TYPE_17 then --家族BOSS
        self:initializeFamilyUI();
      end
  end


  local data = {functionid = openFunctionId,GeneralId = openGeneralId};
  self:complete(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID, data));
  --self:retrieveMediator(ChatPopupMediator.name):getViewComponent():onCloseButtonTap();
  ------------------------策划说没有这个需求---------------------------------
  -- if battleType == BattleConfig.BATTLE_TYPE_11 then
  --     local challengeMediator=self:retrieveMediator(ChallengeMediator.name); 
  --     if challengeMediator then
  --            challengeMediator:changeTab(2,85);  
  --     end
  -- end
  ---------------------------------------------------------------------------

  self:addBetterEquipLayers();
	
	if false == battleProxy.battleResault and not openFunctionId then --用于失败后没选择任何按钮直接退出战斗
		local showMiji = 1==analysis("Zhandoupeizhi_Zhanchangleixing",battleType,"miji");
    local generalListProxy = self:retrieveProxy(GeneralListProxy.name);
    if showMiji then
      if battleType == BattleConfig.BATTLE_TYPE_1 then
        local CheckpointLv = analysis("Juqing_Guanka",battleProxy.battleFieldId,"lv");
        local playerLv = generalListProxy:getLevel();
        if playerLv <= CheckpointLv - 3 then    --等级差距过大的判断(缺具体提示文字)
          local castTip = CommonPopup.new();
      		castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_178),self,self.openMijiUI,MijiConfig.EXP,_,_,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_178),false,true, true);
      		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(castTip);
        else
          -- local castTip = CommonPopup.new();
          -- castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_132),self,self.openMijiUI,MijiConfig.SCORE,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_132),false,true, true);
          -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(castTip);
        end
      else
        -- local castTip = CommonPopup.new();
        -- castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_132),self,self.openMijiUI,MijiConfig.SCORE,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_132),false,true);
        -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(castTip);  
      end
    end
	end
  local userProxy = self:retrieveProxy(UserProxy.name);
  if false == battleProxy.battleResault then
    if BATTLE_TYPE_17 == battleType and userProxy:getIsFamilyLeader() then
      local sendTbl = {};
      sendTbl.UserId = userProxy:getUserID();
      sendTbl.UserName = userProxy:getUserName();
      sendTbl.MainType = ConstConfig.MAIN_TYPE_CHAT;
      sendTbl.SubType = ConstConfig.SUB_TYPE_FACTION;
      sendTbl.ChatContentArray = {};
      sendTbl.ChatContentArray[1] = {};
      sendTbl.ChatContentArray[1].Type = 1;
      sendTbl.ChatContentArray[1].ParamStr1 = "F1FF00";
      sendTbl.ChatContentArray[1].ParamStr2 = "";
      sendTbl.ChatContentArray[1].ParamStr3 = "";
      local ChatText = analysis("Xiaoxi_Tishibiao",33,"text");
      sendTbl.ChatContentArray[1].ParamStr4 = ChatText;
      self:addSubCommand(ChatSendCommand);
      self:complete(Notification.new(_,sendTbl)); --蛋疼
    else

    end
  elseif battleProxy.battleResault then
    if BATTLE_TYPE_17 == battleType and userProxy:getIsFamilyLeader() then
      local sendTbl = {};
      sendTbl.UserId = userProxy:getUserID();
      sendTbl.UserName = userProxy:getUserName();
      sendTbl.MainType = ConstConfig.MAIN_TYPE_CHAT;
      sendTbl.SubType = ConstConfig.SUB_TYPE_FACTION;
      sendTbl.ChatContentArray = {};
      sendTbl.ChatContentArray[1] = {};
      sendTbl.ChatContentArray[1].Type = 1;
      sendTbl.ChatContentArray[1].ParamStr1 = "F1FF00";
      sendTbl.ChatContentArray[1].ParamStr2 = "";
      sendTbl.ChatContentArray[1].ParamStr3 = "";
      local ChatText = analysis("Xiaoxi_Tishibiao",32,"text");
      sendTbl.ChatContentArray[1].ParamStr4 = ChatText;
      self:addSubCommand(ChatSendCommand);
      self:complete(Notification.new(_,sendTbl)); --蛋疼
    else

    end


  end



	battleProxy.battleResault = nil;
end
function OutBattleStuffCommand:readyEndScript()
  self.mainSceneScript:dispose()
  self.mainSceneScript = nil;
  self:showStoryLineUI();
end
function OutBattleStuffCommand:showStoryLineUI()
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  OpenStoryLineUICommand.new():execute(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_STORYLINE_UI_COMMOND, {storyLineId =  battleProxy.storyLineId}));
end


function OutBattleStuffCommand:initializeHeroImage(strongPointId)
  if GameVar.tutorStage == TutorConfig.STAGE_1008 or GameVar.tutorStage == 99999 then
    OpenHeroImageUICommand.new():execute(ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND, {strongPointId = strongPointId}));
  end
end

function OutBattleStuffCommand:addBetterEquipLayers()
  BetterEquipManager:addLayers();
end

function OutBattleStuffCommand:initializeChat()
  self:addSubCommand(MainSceneToChatCommand);
end

function OutBattleStuffCommand:initializeSmallChat()
  MainSceneToSmallChatCommand.new():execute();
end

function OutBattleStuffCommand:initializeArena()
  self:openBattleUI();
  self:addSubCommand(ToArenaCommand);
end

function OutBattleStuffCommand:initializeEighteenCopper()
  self:openBattleUI();
  self:addSubCommand(ChallengeToEighteenCopperCommand);
end

function OutBattleStuffCommand:initializeTenCountry()
  self:addSubCommand(OpenFactionCommand)
  self:addSubCommand(ToTenCountryCommand);
  -- sendMessage(19,3)
end

function OutBattleStuffCommand:initializeObtainSilverUI()
  self:addSubCommand(OpenObtainSilverUICommand);
end

function OutBattleStuffCommand:initializeChallenge()
  self:addSubCommand(ToChallengeCommand);
end

function OutBattleStuffCommand:initializeFactionBattle()
  if self:retrieveProxy(ChallengeProxy.name):getDateByID(ActivityConstConfig.ID_6) then
    self:addSubCommand(ChallengeToFactionBattleCommand);
  end
end

function OutBattleStuffCommand:openBattleUI()
    local battleProxy = self:retrieveProxy(BattleProxy.name);
    if battleProxy.battleFrom == BattleConfig.Battle_From_Type_1 then
          self:addSubCommand(MainSceneToLittleHelperCommand);
          battleProxy.battleFrom = BattleConfig.Battle_From_Type_0;
    elseif battleProxy.battleFrom == BattleConfig.Battle_From_Type_2 then
    end
end

function OutBattleStuffCommand:openMijiUI(TYPE_ID)
	OpenFunctionUICommand.new():execute(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{ID = FunctionConfig.FUNCTION_ID_3, TYPE_ID = TYPE_ID}));
end

function OutBattleStuffCommand:initializeFamilyUI()
  self:addSubCommand(MainSceneToFamilyCommand);
end

-- function OutBattleStuffCommand:initializeFiveEleUI()
--   self:addSubCommand(ToFiveEleBtleCommand)
-- end

function OutBattleStuffCommand:initializeTreasuryUI()
  --self:addSubCommand(OpenFactionCommand)
  self:addSubCommand(ToTreasuryCommand)
end

function OutBattleStuffCommand:initializeMeetingUI()
  self:addSubCommand(OpenFactionCommand)
  self:addSubCommand(ToMeetingCommand)
  --sendMessage(19,9);
end
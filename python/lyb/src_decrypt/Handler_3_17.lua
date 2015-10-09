require "main.model.OperationProxy"

Handler_3_17 = class(MacroCommand);

function Handler_3_17:execute()
  
    local userProxy = self:retrieveProxy(UserProxy.name);
    local oldVipLevel = userProxy:getVipLevel()
    userProxy.vip = recvTable["Vip"];
    userProxy:refreshVipLevel()

    local oldLevel = userProxy.level;

    userProxy.level = recvTable["Level"];
    userProxy.mainGeneralLevel = recvTable["Level"];
    userProxy.experience = recvTable["Experience"];




    self:checkLevelUp(oldLevel, recvTable["Level"])

    self:retrieveProxy(ItemUseQueueProxy.name):setPlaceOpenedByVIP(userProxy);
    local newVipLevel = userProxy:getVipLevel()

    log("oldVipLevel="..oldVipLevel.."------newVipLevel=="..newVipLevel)

    -- vip达到3级以上时 告诉服务器端开启直接放无双
    if oldVipLevel < 3 and newVipLevel >= 3 then
      local operatonProxy = self:retrieveProxy(OperationProxy.name);
      if not operatonProxy then
        operatonProxy = OperationProxy.new();
        self:registerProxy(operatonProxy.class.name,operatonProxy);
      end      
      
      if operatonProxy.operationData and operatonProxy.operationData[5] then
        operatonProxy.operationData[5].value = false
      end
    end
    
  	local vipMediator=self:retrieveMediator(VipMediator.name);
  	if nil~=vipMediator then
    		vipMediator:onUpdateView();
  	end

	-- self:addSubCommand(VipGiftNoticeCommand);
	-- self:complete();
  if newVipLevel ~= oldVipLevel then
    local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);   
    if(nil ~= mainSceneMediator) then  
      mainSceneMediator:refreshVip();
    end
  end
end


function Handler_3_17:checkLevelUp(oldLevel, newLevel)
      if oldLevel == newLevel then
        return;
      end
      self:setTutorStage(newLevel);
      local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
      local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)    
      local userProxy = self:retrieveProxy(UserProxy.name)
      if oldLevel + 1 ~= newLevel then
            openFunctionProxy:checkOpenFunctionsByLevel(newLevel)
      else
            local openFunctionID = openFunctionProxy:getOpenFunctionButton(1,newLevel)
            if openFunctionID ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_1008 then
              if MainSceneMediator and self:retrieveMediator(MainSceneMediator.name) then
                ToAddFunctionOpenCommand.new():execute(MainSceneNotification.new(MainSceneNotifications.TO_ADD_FUNCTION_OPEN_UI, {functionId = openFunctionID}));
              else
                openFunctionProxy.newOpenFunctionId = openFunctionID;
              end
            else
                  if ButtonGroupMediator then
                        local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
                        if buttonGroupMediator then
                              buttonGroupMediator:openButtons(openFunctionProxy:getOpenedVMenu());
                        end
                  end
                  if HButtonGroupMediator then
                        local buttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
                        if buttonGroupMediator then
                              buttonGroupMediator:openButtons(openFunctionProxy:getOpenedHMenu1());
                        end
                  end
                  if LeftButtonGroupMediator then
                        local buttonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name);
                        if buttonGroupMediator then
                              buttonGroupMediator:openButtons(openFunctionProxy:getOpenedLeftMenu());
                        end
                  end
            end
      end


      deSetLevel(newLevel)

      if MainSceneMediator then
            local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
            if mainSceneMediator then
                mainSceneMediator:refreshUserLevel()   
                mainSceneMediator:openButtons(openFunctionProxy:getOpenedHMenu2());
                self.boneLightCartoon = BoneCartoon.new()
                self.boneLightCartoon:create(StaticArtsConfig.BONE_EFFECT_LEVEL_UP,1);
                self.boneLightCartoon:setMyBlendFunc()
                sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self.boneLightCartoon);
                local mainSize = Director:sharedDirector():getWinSize();
                self.boneLightCartoon:setPositionXY(mainSize.width/2-GameData.uiOffsetX / 2, mainSize.height/2-GameData.uiOffsetY / 2)
            end
      end
      if GameVar.tutorStage == TutorConfig.STAGE_99999 and newLevel > 19 then
        if HButtonGroupMediator then
          local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
          if hBttonGroupMediator then
            hBttonGroupMediator:removeTutorEffect()
          end
        end
      end
end

function Handler_3_17:getTutorByLevel(level)
    local stageArr = analysisByName("Xinshouyindao_Xinshou", "lvl", level)
    for i_k, i_v in pairs(stageArr) do
       if i_v.zhuangtai == taskState then
          return i_v.jieduan;
       end
    end
    return nil;
end
function Handler_3_17:setTutorStage(level)
  
   local stage = self:getTutorByLevel(level);
   if stage then
      print("!!!!!!!!!!!!!!!!!!!stage:" .. stage);
   end
   if stage and stage > 0 then
      GameVar.tutorStage = stage;
      GameVar.tuturReaccess = false;
      GameVar.tutorSmallStep = 0;
      sendServerTutorMsg({Stage = GameVar.tutorStage})

      local scene = Director.sharedDirector():getRunningScene();   
      if scene and scene.name == GameConfig.MAIN_SCENE then
        local len = table.getn(LayerManager.layerKeyBackables);
        for i = len, 1, -1 do
          local layerKeyBackable = LayerManager.layerKeyBackables[i];
          layerKeyBackable:closeUI(nil);
        end
        HandleTutorCommand.new():execute();
      end

   end
end



Handler_3_17.new():execute();
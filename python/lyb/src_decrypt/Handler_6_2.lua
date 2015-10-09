--返回 英魂列表 增删改

Handler_6_2 = class(Command);

function Handler_6_2:execute()
      
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.heroHouseProxy = heroHouseProxy;
  local generalArray = heroHouseProxy.generalArray;
  local changeGeneralArray = recvTable["ChangeGeneralArray"];
  local booleanValue = recvTable["BooleanValue"];
  print("------------------booleanValue:", booleanValue)
  -- for k,v in pairs(recvTable["ChangeGeneralArray"]) do
  --       print("..");
  --       for k_,v_ in pairs(v) do
  --         print(k_,v_);
  --       end
  --       print("skill..");
  --       for k_,v_ in pairs(v.SkillArray) do
  --         print("");
  --         for k__,v__ in pairs(v_) do
  --           print(k__,v__);
  --         end
  --       end
  --     end

  --GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
  --Type,GeneralId,ConfigId,SkillArray,Level,Experience,Grade,IsPlay,Time
  --<!-- Type:1(增),2(删),3(改) -->

  local num = #changeGeneralArray;
  local bool;
  for i=1,num do
        
    local data = heroHouseProxy:getGeneralData(changeGeneralArray[i].GeneralId);
    
    if data and 1 == data.IsMainGeneral then
      changeGeneralArray[i].IsMainGeneral = 1;
      local userProxy=self:retrieveProxy(UserProxy.name);
      userProxy.mainGeneralLevel = changeGeneralArray[i].Level;
      
      if data.Level ~= changeGeneralArray[i].Level then
            if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then
                  recordScore(changeGeneralArray[i].Level)
            end

      end
      
      if booleanValue == 1 then
         if changeGeneralArray[i].AddExp ~= 0 then
            sharedTextAnimateReward():animateStartByString("获得经验:" .. changeGeneralArray[i].AddExp);
         else
            print("changeGeneralArray[i].AddExp == 0")
         end
      end  
    else
      changeGeneralArray[i].IsMainGeneral = 0;
      if not GameVar.tutorXiLian and changeGeneralArray[i].Level >= 15 then
        local scene = Director.sharedDirector():getRunningScene();   
        if scene and scene.name == GameConfig.MAIN_SCENE then
          local len = table.getn(LayerManager.layerKeyBackables);
          for i = len, 1, -1 do
            local layerKeyBackable = LayerManager.layerKeyBackables[i];
            layerKeyBackable:closeUI(nil);
          end
          GameVar.tutorStage = TutorConfig.STAGE_1017;
          sendServerTutorMsg({Stage = GameVar.tutorStage})
          HandleTutorCommand.new():execute();
        end
        GameVar.tutorXiLian = true;
      end
    end
    
    if changeGeneralArray[i].Type == 1 then
      changeGeneralArray[i].FateLevelArray=self:getYuanfenData(changeGeneralArray[i].ConfigId);
      table.insert(generalArray, changeGeneralArray[i]);
      if booleanValue == 1 then
        self:popCard(changeGeneralArray[i].ConfigId)
      end
    elseif changeGeneralArray[i].Type == 2 then
      local removeIndex = 0;
      for j=1,#generalArray do
        if generalArray[j].GeneralId == changeGeneralArray[i].GeneralId then
              removeIndex = j;
              break;
        end;
      end
      if removeIndex ~= 0 then
            table.remove(generalArray,removeIndex)
      end;
    elseif changeGeneralArray[i].Type == 3 then
      local changeIndex = 0;
      for j=1,#generalArray do
            if generalArray[j].GeneralId == changeGeneralArray[i].GeneralId then
                  changeIndex = j;
                  break;
            end;
      end
      if changeIndex ~= 0 then
            changeGeneralArray[i].FateLevelArray = generalArray[changeIndex].FateLevelArray;
            generalArray[changeIndex] = changeGeneralArray[i];
      else
            changeGeneralArray[i].FateLevelArray=self:getYuanfenData(changeGeneralArray[i].ConfigId);
            table.insert(generalArray,changeGeneralArray[i]);
      end;
    end
    
    heroHouseProxy:setGeneralZhanliByGeneralID(changeGeneralArray[i].GeneralId);
    
    heroHouseProxy:setHongdianData(changeGeneralArray[i].GeneralId);

  end

  self:refreshMediator();

  if HeroRedDotRefreshCommand then
        HeroRedDotRefreshCommand.new():execute();
  end
      
end

function Handler_6_2:getYuanfenData(configID)
  local yuanfen_data = self.heroHouseProxy:getYuanfenDataByConfigID(configID);
  local data = {};
  for k,v in pairs(yuanfen_data) do
    table.insert(data,{ID=v.id,Level=1});
  end
  return data;
end

function Handler_6_2:popCard(configId)

  local _positionX,_positionY = GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2

  local itemTable = {}
  local itemTable = analysisByName("Daoju_Daojubiao", "parameter1",configId)
  local itemIdDisplay = 1
  for k,v in pairs(itemTable) do
    if v.functionID == 4 then
      itemIdDisplay = v.id
    end
  end

  local cardTable = analysis("Kapai_Kapaiku", configId)

  itemTable["isCard"] = 1
  itemTable["ConfigId"] = configId
  itemTable["StarLevel"] = 1
  itemTable["Grade"] = cardTable.quality
  itemTable["Level"] = 1
  itemTable["ItemId"] = itemIdDisplay
  itemTable["count"] = 1

  local cardsLayer = Layer.new()
  cardsLayer:initLayer()

  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(cardsLayer)

  local winSize = Director:sharedDirector():getWinSize()
  local backImage = Image.new()
  backImage:loadByArtID(StaticArtsConfig.LOADING_UI)
  backImage:setAnchorPoint(CCPointMake(0.5,0.5))
  backImage:setPositionXY(winSize.width / 2 - GameData.uiOffsetX,winSize.height / 2 - GameData.uiOffsetY)
  cardsLayer:addChild(backImage)
  
  local function _oncloseUI()
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(cardsLayer)
  end
  backImage:addEventListener(DisplayEvents.kTouchTap,_oncloseUI,self)

  --得到卡
  local function _getHeroCard(data)
    require "main.view.hero.heroPro.ui.HeroProScaleSlot";
    local scaleSlot = HeroProScaleSlot.new();
    scaleSlot:initialize(_heroSkeleton, data, makePoint(0,0));
    scaleSlot:getCard():setScale(0.165)
    return scaleSlot
  end

  local function _onItemTip()
    local itemData = BagItem.new();
    itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});    
    local itemTable = {data = {item = itemData,nil,nil,count=itemData.userItem.Count}}
    OpenItemTipCommand.new():execute(itemTable)
  end

  local function _boneLightBack2()

    local actionArr1 = CCArray.create()
    local actionArr2 = CCArray.create()


    if itemTable["isCard"] == 1 then --卡牌
      -- 太阳
      local _boneCartoon3 = BoneCartoon.new()
      _boneCartoon3:create(StaticArtsConfig.BONE_EFFECT_373,0);
      _boneCartoon3:setMyBlendFunc()
      _boneCartoon3:setPositionXY(GameConfig.STAGE_WIDTH / 2,GameConfig.STAGE_HEIGHT / 2)
      cardsLayer:addChild(_boneCartoon3);

      local _cardUI = _getHeroCard(itemTable)
      _cardUI:setScale(0.25)
      _cardUI:setPositionXY(_positionX,_positionY)
      cardsLayer:addChild(_cardUI);

      local function _callBackFunc()
        local _touchLayer = Layer.new()
        _touchLayer:initLayer()
        _touchLayer:setContentSize(Director:sharedDirector():getWinSize())
        cardsLayer:addChild(_touchLayer)
        local function _onclickTouchLayer()
          cardsLayer:removeChild(_boneCartoon3)
          _touchLayer:removeEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)
          cardsLayer:removeChild(_touchLayer)
          if GameVar.tutorStage == TutorConfig.STAGE_1003 then
              openTutorUI({x=1198, y=641 + GameData.uiOffsetY, width = 80, height = 80, alpha = 125});
          end
          local function _callBackFunc1()
            cardsLayer:removeChild(_cardUI);
            if itemTable["art"] then
      
            else
              local heroRoundPortrait = HeroRoundPortrait.new();
              heroRoundPortrait:initialize(itemTable,false);
              heroRoundPortrait:showName4Langyaling();
              heroRoundPortrait:setPositionXY(_positionX - heroRoundPortrait:getContentSize().width / 2,_positionY - heroRoundPortrait:getContentSize().height / 2);
              cardsLayer:addChild(heroRoundPortrait);

              local itemData = BagItem.new();
              itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});
              heroRoundPortrait:addEventListener(DisplayEvents.kTouchTap, _onItemTip, self,itemData);                 
            end

            local cartoon1
            local function removeCartoon1()
              cardsLayer:removeChild(cartoon1);
            end
            cartoon1 = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_1159,_positionX - 145,_positionY + 140,1,removeCartoon1,nil,nil,true)
            cardsLayer:addChild(cartoon1);

          end

          local actionArr3 = CCArray.create()
          local actionArr4 = CCArray.create()
          actionArr3:addObject(CCScaleTo:create(0.1,0.25,0.25))
          actionArr3:addObject(CCRotateBy:create(0.1 , 360))
          actionArr3:addObject(CCMoveTo:create(0.1, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
          actionArr4:addObject(CCSpawn:create(actionArr3))
          actionArr4:addObject(CCCallFunc:create(_callBackFunc1))
          _cardUI:runAction(CCSequence:create(actionArr4))

          if callBackFunc then
            callBackFunc()
          end

        end

        _touchLayer:addEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)

      end

      actionArr2:addObject(CCScaleTo:create(0.15,4,4))
      actionArr2:addObject(CCRotateBy:create(0.15 , 360))
      actionArr2:addObject(CCMoveTo:create(0.15, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
      actionArr1:addObject(CCSpawn:create(actionArr2))
      actionArr1:addObject(CCCallFunc:create(_callBackFunc))
      _cardUI:runAction(CCSequence:create(actionArr1))

    else -- 道具

    end
  end

  local function removeCartoon1()
    cardsLayer:removeChild(self.cartoon1);

    _boneLightBack2()
  end

  if not self.cartoon1 then
    self.cartoon1 = cartoonPlayer(1748,GameConfig.STAGE_WIDTH / 2 ,0,1,removeCartoon1,nil,nil,true)
    cardsLayer:addChild(self.cartoon1);
  end

end

function Handler_6_2:refreshMediator()
  
  if StrengthenPopupMediator then
    local mediator = self:retrieveMediator(StrengthenPopupMediator.name);
    if mediator then
      mediator:getViewComponent():refreshOn6_2(recvTable["ChangeGeneralArray"]);
    end
  end
end

Handler_6_2.new():execute();
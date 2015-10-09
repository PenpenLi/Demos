require "core.display.Director"
require "core.display.Scene"
require "core.display.Layer"
require "main.managers.MapDataManager"
require "main.config.MainConfig"
require "main.view.mainScene.layer.MapOuterLayer"
require "main.view.mainScene.layer.WalkLayer"
require "main.view.mainScene.layer.PlayerLayer"
require "main.view.mainScene.layer.BackGroundLayer"
require "main.view.mainScene.layer.BackBackGroundLayer"


local GRID_SIZE =25

MapScene = class(Layer);

-- creat
function MapScene:ctor()
  self.class = MapScene;
  self.isLayerInitialized = false;
  self.mapOuterLayer = nil
  self.walkLayer = nil;
end
-- init

function MapScene:setContext(context)
    self.context = context;
end
function MapScene:onInit()
  
  self:initLayer()

  local proxyRetriever  = ProxyRetriever.new();

  self.vipProxy=proxyRetriever:retrieveProxy(VipProxy.name);
  self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=proxyRetriever:retrieveProxy(GeneralListProxy.name);
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
  self.openFunctionProxy=proxyRetriever:retrieveProxy(OpenFunctionProxy.name);
  self.itemUseQueueProxy=proxyRetriever:retrieveProxy(ItemUseQueueProxy.name);
  self.heroHouseProxy=proxyRetriever:retrieveProxy(HeroHouseProxy.name)
  self.storyLineProxy = proxyRetriever:retrieveProxy(StoryLineProxy.name)
  self.familyProxy = proxyRetriever:retrieveProxy(FamilyProxy.name)
  

  self.artId1 = getCurrentBgArtId()
  
  -- self.mapSkyLayer = MapSkyLayer.new();
  -- self.mapSkyLayer:onInit()--StaticArtsConfig.MAIN_SCENE_SKY_BG
  -- self:addChild(self.mapSkyLayer);  

  self.backBackGroundLayer = BackBackGroundLayer.new();
  self.backBackGroundLayer:onInit();
  
  

  self:addChild(self.backBackGroundLayer);   

  self.backGroundLayer = BackGroundLayer.new();
  self.backGroundLayer:onInit()
  self:addChild(self.backGroundLayer);  
        
  self.walkLayer = WalkLayer.new()
  self.walkLayer.name = "walkLayer";
  self.walkLayer:onInit()
  self:addChild(self.walkLayer);


  self.mapOuterLayer = MapOuterLayer.new();
  self.mapOuterLayer:onInit()
  self.mapOuterLayer:setContext(self)
  self:addChild(self.mapOuterLayer);



  self.winSize = Director:sharedDirector():getWinSize();
  if GameVar.mapHeight - self.winSize.height > 30 then
    self.mapOuterLayer:setPositionY(-30)
  end


  self.playerLayer = PlayerLayer.new()
  self.playerLayer:onInit(self)
  self:addChild(self.playerLayer);






end
function MapScene:initRole(roleData)

  local itemIdBody, userId = roleData.itemIdBody, roleData.userId
  if not self.rolePlayer then
      self.playerLayer.myUserId = userId;
      self.rolePlayer = RolePlayer.new();
  end
  self.rolePlayer:initPlayer(itemIdBody, itemIdWeapon, userId);
  self.rolePlayer.compositeActionAllPart.userName = "MySelf";

  self.rolePlayer:setName(self.userProxy.userName, GameConfig.ROLE_NAME_X_OFFSET, GameConfig.ROLE_NAME_CITY_Y_OFFSET, GameConfig.MY_NAME_COLOR, userTitles, self.userProxy.vip)

end
function MapScene:dispose()

  self.mapOuterLayer = nil
  self.walkLayer = nil;

  -- self:removeReviseTimer()
  self:removeAllEventListeners();
  self:removeChildren();
  MapScene.superclass.dispose(self);
  
end

--缓动
-- function MapScene:reviseMapMove()
--     -- local winSize = Director:sharedDirector():getWinSize();
--     -- self.destY = winSize.height - GameVar.mapHeight
--     self.destY = 0;
--     local function reviseTimer()
--         self:revise_Map_Move()
--     end
--     self.reviseTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(reviseTimer, 0, false)
-- end
-- --缓动
-- function MapScene:revise_Map_Move()

--       if self.mapOuterLayer and self.mapOuterLayer:getPositionY() <= self.destY - 2 then
--         local disY = math.abs(self.destY - self.mapOuterLayer:getPositionY());
--         local stepy = disY/(1/GameConfig.Game_FreamRate)
--         self.mapOuterLayer:setPositionY(self.mapOuterLayer:getPositionY() + stepy);
--       else
--           self:removeReviseTimer()
--       end
-- end

-- function MapScene:removeReviseTimer()
--   if self.reviseTimer then
--     CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.reviseTimer);
--   end
--   self.reviseTimer = nil;
-- end
function MapScene:clean()
    -- self:removeReviseTimer();
  if self.commonGongGaoPopup and sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):contains(self.commonGongGaoPopup) then
    self.commonGongGaoPopup:removePopup();
    self.commonGongGaoPopup = nil;
  end
    if self:contains(self.walkLayer) then
       self.walkLayer:clean()
    end
    if self:contains(self.mapOuterLayer) then
       self.mapOuterLayer:clean()
    end
    if self:contains(self.playerLayer) then
       self.playerLayer:clean()
    end
    self.rolePlayer = nil;
    if self:contains(self.backGroundLayer) then
      self.backGroundLayer:clean()
    end
    if self.backBackGroundLayer then
      self.backBackGroundLayer:clean();
    end
  
end


function MapScene:updatePostion(xPos, yPos, rate1, rate2)  

    -- print("GameVar.mapBgX:", GameVar.mapBgX)
    rate1 = rate1 and rate1 or 1;
    rate2 = rate2 and rate2 or 1;
    GameVar.mapBgX = xPos;
    GameVar.mapBgY = yPos;

  
    self.backGroundLayer.sprite.x = xPos--0.4; * rate2
    -- self.backGroundLayer.sprite.y = yPos--0.4;  * rate2
    
    self.walkLayer.sprite.x = xPos;
    self.walkLayer.sprite.y = yPos;
    
    self.mapOuterLayer.sprite.x = xPos;
    self.mapOuterLayer.sprite.y = yPos;

    self.playerLayer.sprite.x = xPos;
    self.playerLayer.sprite.y = yPos;
 
    self.backBackGroundLayer.sprite.x = xPos*0.5;

end
function MapScene:getScenePostionByCenterPosition(x, y)
  
    local startX = GameVar.screenWidth / 2 - x;
    local startY = GameVar.screenHeight / 2 -  y;

    if startX > 0 then startX =  0 end;
    if startY > 0 then startY = 0 end;

    if ( GameVar.mapWidth + startX < GameVar.screenWidth) then
      startX =  GameVar.screenWidth - GameVar.mapWidth;
    end
    if ( GameVar.mapHeight + startY < GameVar.screenHeight) then
      startY = GameVar.screenHeight - GameVar.mapHeight;
    end
    if(startX > 0) then
     startX = 0;  
    elseif(GameVar.mapWidth + startX < GameVar.screenWidth) then
     startX = GameVar.mapWidth - GameVar.screenWidth;
    end

    if(startY > 0) then
     startY = 0;     
    elseif(GameVar.mapHeight + startY < GameVar.screenHeight) then
     startY = GameVar.mapHeight - GameVar.screenWidth;
    end
    return {x = startX, y = startY}
end


function MapScene:moveMapContain(x, y)
    if GameVar.moveMap.x < x and GameVar.moveMap.x + GameVar.moveMap.width > x and GameVar.moveMap.y < y and GameVar.moveMap.y + GameVar.moveMap.height > y then
       return true;   
    end
    return false;
end
function MapScene:__private_touchMap(evt)
    if self.sceneType ==  GameConfig.SCENE_TYPE_1 then
      return;
    end

    local xPos
    local yPos
  
    xPos = evt.metaglobalPosition.x - GameVar.mapBgX;
    yPos = evt.metaglobalPosition.y - GameVar.mapBgY;
    
    if self:isCanStand(xPos, yPos) then
      self:roleMoveTo(xPos, yPos);    
    end
    -- self:dispatchEvent(Event.new("CLICK_TO_MOVE", {}, self)); 

end
function MapScene:isCanStand(xPos, yPos)
    if yPos < 300 then
      return true;    
    else
      return false;
    end
    -- local xIndex = math.floor(xPos / GRID_SIZE);
    -- local yIndex = math.ceil(yPos / GRID_SIZE);
    -- if not MapDataManager:getCanStand(self.mapId, xIndex, yIndex) then
    --    print("can not stand")
    --    return false
    -- else
    --    return true;
    -- end
end
function MapScene:roleMoveTo(xPos, yPos)
    if self.sceneType ~= GameConfig.SCENE_TYPE_4 then return end;


    local xIndex = math.floor(xPos / GRID_SIZE);
    local yIndex = math.ceil(yPos / GRID_SIZE);

    
    local pathArr = nil;

    pathArr = {}
    table.insert(pathArr, {x = xPos, y = yPos}); 
    if self.rolePlayer then
      self.rolePlayer:setPath(pathArr, self.moveComplete, self);
    end
end
function MapScene:moveComplete(data)
    if data and data.NpcId then
      print("data.npcId:", data.NpcId)
      --对应帮派场景里面的ID
      if data.NpcId == 0 then--公告
        MusicUtils:playEffect(7);
        local hasQuanXian = self.userProxy:getHasQuanxian(self.userProxy:getFamilyPositionID());
        if hasQuanXian == false then
          sharedTextAnimateReward():animateStartByString("您没有修改公告权限哦！");
          return;
        end
        hecDC(3,26,5,{level = self.userProxy:getLevel()})
        require "main.view.mainScene.gonggao.CommonGongGaoPopup"
        self.commonGongGaoPopup = CommonGongGaoPopup.new();
        self.commonGongGaoPopup:initialize("修改", self, self.onConfirm)
        sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self.commonGongGaoPopup);
      elseif data.NpcId == 1 then--帮主

        hecDC(3,26,1,{level = self.userProxy:getLevel()})

        MusicUtils:playEffect(7);

        Facade.getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_FAMILY));
      elseif data.NpcId == 2 then--佣兵将军
        hecDC(3,26,3,{level = self.userProxy:getLevel()})
        Facade.getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_YONG_BING));
      elseif data.NpcId == 3 then--酒宴老板
        MusicUtils:playEffect(7);
        --举办者
        hecDC(3,26,2,{level = self.userProxy:getLevel()})
        for k, v in pairs(self.playerLayer.BanquetInfoArray) do
          if v.UserId == self.userProxy.userId then
            Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_COMMAND, {Type = v.Type, ID = v.ID}));
            sendMessage(27, 31, {ID = v.ID});
       
            return;
          end
        end

        --参加者
        self.isIn = false;
        if self.familyProxy.userIdNameArray then
          for i2,v2 in ipairs(self.familyProxy.userIdNameArray) do
              if self.userProxy.userId == v2.UserId then
                    --自己在酒宴里
                    self.isIn = true;
              end
          end
        end
        if self.isIn == true then
          for k, v in pairs(self.playerLayer.BanquetInfoArray) do
            if v.ID == self.familyProxy.banquetID then
              Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_COMMAND, {Type = v.Type, ID = v.ID}));
              sendMessage(27, 31, {ID = v.ID});
             
              return;
            end
          end
        end

          Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_HOLD_BANQUET_COMMAND));
      elseif data.NpcId == 4 then--告示牌
        
      elseif data.NpcId == 5 then--货娘
        hecDC(3,26,4,{level = self.userProxy:getLevel()})
        MusicUtils:playEffect(7);
        Facade.getInstance():sendNotification(FactionNotification.new(FactionNotifications.TO_SHOP_COMMAND, {Type = 2}));
      end
    end
end

function MapScene:onConfirm()
  local str = self.commonGongGaoPopup.common_content:getString();
  str1 = string.gsub(str, " ", "")
  if str1 == "" then
    sharedTextAnimateReward():animateStartByString("请输入文字哦");
    return;
  end

  local textField = TextField.new(CCLabelTTFStroke:create(str, FontConstConfig.OUR_FONT, 24, 1, ccc3(0,0,0),CCSizeMake(0, 0)));
  self:addChild(textField);
  textField:setVisible(false)
  --250  22个是530
  if textField:getContentSize().width > 530 then
    sharedTextAnimateReward():animateStartByString("字数有点多哦，精简一点吧");
    return;
  end
  
  self.commonGongGaoPopup:removePopup();
  hecDC(3,26,6,{level = self.userProxy:getLevel()})
  sendMessage(27,16, {ParamStr1 = str})
end
function MapScene:setMapScenePosition(xPos, yPos)
    local pt = self:getScenePostionByCenterPosition(xPos, yPos);
    self:updatePostion(pt.x, pt.y, 0.2, 0.4);    
end
function MapScene:changeStoryLine(mapSceneData)

    self.backMapId = nil
    self.forewardMapId = nil

    print("self.sceneType:", self.sceneType)
    self.sceneType = mapSceneData["sceneType"]; 
    if self.sceneType ==  GameConfig.SCENE_TYPE_1 then
      self.backGroundLayer.sprite.x = 0;
      self.walkLayer.sprite.x = 0;
      self.mapOuterLayer.sprite.x = 0;
      self.mapOuterLayer.sprite.y = 0;
      
      self.backGroundLayer:setData(self.artId1)
      if GameVar.mapHeight - self.winSize.height > 30 then
        self.backGroundLayer:setPositionY(-30)
      end

      self.mapOuterLayer:setData();
      self.walkLayer:addEffect(self.artId1);
      if GameData.isMusicOn then
        if 1 == self.storyLineProxy:getStrongPointState(10001011) then
          MusicUtils:play(1003,true)
        else
          MusicUtils:play(1002,true)
        end
      end


    elseif self.sceneType ==  GameConfig.SCENE_TYPE_4 then
      hecDC(3,26,7,{level = self.userProxy:getLevel()})
      if GameData.isMusicOn then
        MusicUtils:play(1001,true)
      end

      self.sceneType = mapSceneData["sceneType"]; 

      self.backBackGroundLayer:setData(1359);
      self.backGroundLayer:setData(1360)

      GameVar.moveMap.width = GameVar.mapWidth - GameVar.screenWidth;
      print("GameVar.moveMap.width", GameVar.moveMap.width)
      GameVar.moveMap.height = GameVar.mapHeight - GameVar.screenHeight;
      GameVar.moveMap.x = GameVar.screenWidth * 0.5;
      GameVar.moveMap.y = GameVar.screenHeight * 0.5;

      self.mapOuterLayer:addFamilyNpc();

      self.playerLayer:refreshFamilyBanquet(self.familyProxy.BanquetInfoArray);

      local userMapInfoArray = mapSceneData["SceneMemberArray"]
      for k, v in pairs(userMapInfoArray)do
        print("UserId,UserName",v.UserId,v.UserName)
      end
      print("====================================userMapInfoArray.length", #userMapInfoArray)
      self.playerLayer:addOtherPlayers(userMapInfoArray,true);
      
      local modelId
      if self.userProxy.transforId == 0 then
        modelId = analysis("Zhujiao_Zhujiaozhiye", self.userProxy.career, "shenti");
      else
        modelId = analysis("Zhujiao_Huanhua", self.userProxy.transforId, "body");
      end
      print("-------------modelId", modelId)
      local roleData = {userId=self.userProxy.userId,itemIdBody=modelId};
      self:initRole(roleData)
      self.rolePlayer:setPlayerPosition(500,200)
      self:setMapScenePosition(500,200)

      local key = "key_" .. self.rolePlayer.userId;
      self.playerLayer.playerList[key] =  self.rolePlayer;
      self.playerLayer:addChild(self.rolePlayer.compositeActionAllPart)
      
      if mapSceneData["banquetData"] then
        Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_BANQUET_COMMAND, mapSceneData["banquetData"]));
        self.userProxy.banquetData = nil;
        sendMessage(27, 31, {ID = mapSceneData["banquetData"].ID});
      end
    end 



    self.backGroundLayer:addEventListener(DisplayEvents.kTouchEnd, self.__private_touchMap, self);
	-- print("-------------------------------before--------------------------")
	-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();    
	  BitmapCacher:removeUnused();

end
function MapScene:addOrUpdateOtherPlayer(otherPlayerInfo,isOtherPlayerOn)
   self.playerLayer:addOrUpdateOtherPlayer(otherPlayerInfo,isOtherPlayerOn);
end


function MapScene:refreshGeneralRoleLayer()
  self.mapOuterLayer:refreshGeneralRoleData();
end
function MapScene:refreshFamilyBanquet(BanquetInfoArray)
  self.playerLayer:refreshFamilyBanquet(self.familyProxy.BanquetInfoArray);
end
function MapScene:removeOtherPlayer(userId)
  self.playerLayer:removeOtherPlayer(userId);
end

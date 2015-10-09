require "main.view.mainScene.player.MovePlayer"
require "main.view.mainScene.player.RolePlayer"
require "main.view.mainScene.player.Speed"
require "main.view.mainScene.layer.FamilySceneBanquet"
PlayerLayer = class(Layer);

function PlayerLayer:ctor()
  self.class = PlayerLayer;
  self.myUserId = nil;
  self.playerList = {};
  self.tempArr = {};
  self.scenBanquetArr = {};
  --TODO 
  self.banquetArray = {};
end

function PlayerLayer:dispose()
  self:disposeTickTime();
	for k1,v1 in pairs(self.playerList) do
		v1:dispose();
	end
	self.playerList = nil
  	self.tempArr = nil
	self:removeAllEventListeners();
	self:removeChildren();
	PlayerLayer.superclass.dispose(self);
end

function PlayerLayer:onInit(context)    
  self:initLayer();
  self.context = context;
  local proxyRetriever  = ProxyRetriever.new();
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
end

local function sortFun(a, b)
  if a and b then
    if a.y > b.y then
       return true
    elseif a.y < b.y then
      return false
    else
      return false;
    end
  end
  return false;
end


 function PlayerLayer:sortPlayers()--todo,优化  
  if 0 == #self.tempArr then
    for i_k, i_v in pairs(self.playerList) do
      if nil ~= i_v and i_v.compositeActionAllPart and i_v.compositeActionAllPart.sprite then
        local playerVO = {userId = i_v.userId, y = (i_v.compositeActionAllPart.sprite.y), index = i_v.compositeActionAllPart.index}
        table.insert(self.tempArr, playerVO)
      end
    end

    for i,v in ipairs(self.scenBanquetArr) do
      local banquetVO = {ID = v.data.ID, y = v:getPositionY()};
        table.insert(self.tempArr, banquetVO);
    end

    if nil ~= self.tempArr and table.getn(self.tempArr) > 0 then
        table.sort(self.tempArr, sortFun);
        for i_k, i_v in pairs(self.tempArr) do 
          local arrItem = nil;

          if  i_v.userId then
            local key = "key_" .. i_v.userId;
            arrItem = self.playerList[key].compositeActionAllPart
          elseif i_v.ID then
            for i1,v1 in ipairs(self.scenBanquetArr) do
              if v1.data.ID == i_v.ID then
                arrItem = v1;
              end
            end
          end
            
          if arrItem then
            self:setChildIndex(arrItem, i_k);
          end
        end
        self.tempArr = {}
    end
    -------
  end
end


function PlayerLayer:_tickTime() 
  local playerCount = self:getPlayerCount();
  local playerIndex = math.ceil(math.random(0,playerCount));
  local index = 0;
  if self.playerList then
    for k, v in pairs(self.playerList) do
      index = index + 1;
      if index == playerIndex and v.userId ~= self.myUserId then
        local xPos = math.random(1,1920)
        local yPos = math.random(1,300)
        v:setPath({[1] = {x = xPos, y = yPos}})
      end
    end
  end
end
function PlayerLayer:addOtherPlayers(userMapInfoArray,isOtherPlayerOn) 

  self.userMapInfoArray = userMapInfoArray;
  self.isOtherPlayerOn  = isOtherPlayerOn;
  if isOtherPlayerOn then

   --<sequence>UserId,UserName,Speed,ConfigId,ItemIdHead,ItemIdBody,ItemIdWeapon,CoordinateX,CoordinateY</sequence>
      for i_k, i_v in pairs(userMapInfoArray) do 
          if self.myUserId ~= i_v.UserId then   
             local key = "key_" .. i_v.UserId;
             local movePlayer = MovePlayer.new();
             local itemIdBody = analysis("Zhujiao_Huanhua", i_v.ConfigId, "body");
             local itemIdWeapon = nil;
             local titles={};
             if AbleTitleArray then
               for k,v in pairs(i_v.AbleTitleArray) do
                 table.insert(titles,v.EnableTitleId);
               end
             end
             movePlayer:initPlayer(itemIdBody, itemIdWeapon, i_v.UserId);
             movePlayer.compositeActionAllPart.career = i_v.ConfigId;
             movePlayer.compositeActionAllPart.userName = i_v.UserName;
             movePlayer.compositeActionAllPart:setVisible(isOtherPlayerOn)
             self:addChild(movePlayer.compositeActionAllPart);

             movePlayer.compositeActionAllPart.sprite.x = math.random(1,1920)
             movePlayer.compositeActionAllPart.sprite.y = math.random(1,300)
    		     local otherPlayerName = i_v.UserName--"Lv"..i_v.Level.." "..i_v.UserName
             local loseTitleName = i_v.TargetUserName;
             print("addOtherPlayers>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",i_v.TargetUserName)
             movePlayer:setName(otherPlayerName, GameConfig.ROLE_NAME_X_OFFSET, GameConfig.ROLE_NAME_CITY_Y_OFFSET, GameConfig.OTHER_NAME_COLOR, titles, i_v.Vip, loseTitleName)
             self.playerList[key] = movePlayer;
    		 
    		     movePlayer.compositeActionAllPart:addTouchEventListener(DisplayEvents.kTouchTap,self.onClickOtherPlayerHandler,self, i_v);

          end

      end

      local function tickTime()
       self:_tickTime()
      end
      self.tickTimeId = Director:sharedDirector():getScheduler():scheduleScriptFunc(tickTime, 2, false)
      self:_tickTime()
  end
end
function PlayerLayer:disposeTickTime()
  if self.tickTimeId then
      Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.tickTimeId);
      self.tickTimeId = nil
  end  
end
function PlayerLayer:onClickOtherPlayerHandler(event,otherPlayerData)
    print("CLICK_OTHER_PLAYER")

		-- local playerEvent = Event.new("CLICK_OTHER_PLAYER", otherPlayerData, self);
		-- self:dispatchEvent(playerEvent);
    local pos = event.globalPosition;
    pos.x = pos.x + 50;
    pos.y = pos.y + 150;
    getUserButtonsSelector(otherPlayerData.UserId, otherPlayerData.UserName, pos, sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP))--self.parent.parent.parent

end
--玩家进来或者换装
function PlayerLayer:addOrUpdateOtherPlayer(otherPlayerInfo,isOtherPlayerOn)  
  if not self.userMapInfoArray then return end;
  local hasUser;
  for i_k, i_v in pairs(self.userMapInfoArray) do
     if i_v.UserId == otherPlayerInfo.UserId then
         i_v = otherPlayerInfo;
         hasUser = true;
         break;
     end
  end
  if not hasUser then
     table.insert(self.userMapInfoArray, otherPlayerInfo);
  end

  self.isOtherPlayerOn = isOtherPlayerOn;
  if not isOtherPlayerOn then return end;

  local key = "key_" .. otherPlayerInfo.UserId; 
  local movePlayer =  self.playerList[key];
  local itemIdBody = analysis("Zhujiao_Huanhua", otherPlayerInfo.ConfigId, "body");
  local itemIdWeapon = nil;
  if nil == movePlayer then
       movePlayer = MovePlayer.new();   
       self.playerList[key] = movePlayer;
  end
  -- if otherPlayerInfo.AbleTitleArray then
  --   local titles={};
  --   for k,v in pairs(otherPlayerInfo.AbleTitleArray) do
  --     table.insert(titles,v.EnableTitleId);
  --   end
  -- end
  movePlayer:initPlayer(itemIdBody, itemIdWeapon, otherPlayerInfo.UserId);
  movePlayer.compositeActionAllPart.userName = otherPlayerInfo.UserName;
  movePlayer.compositeActionAllPart:setVisible(isOtherPlayerOn)
  self:addChild(movePlayer.compositeActionAllPart);
  movePlayer.compositeActionAllPart.sprite.x = math.random(1,1920)
  movePlayer.compositeActionAllPart.sprite.y = math.random(1,300)
  --movePlayer:setName("Lv".. otherPlayerInfo.Level .. " " .. otherPlayerInfo.UserName, GameConfig.ROLE_NAME_X_OFFSET, GameConfig.
  movePlayer:setName(otherPlayerInfo.UserName, GameConfig.ROLE_NAME_X_OFFSET, GameConfig.ROLE_NAME_CITY_Y_OFFSET, GameConfig.OTHER_NAME_COLOR, titles, otherPlayerInfo.Vip, otherPlayerInfo.LoseTitleName);
  
  movePlayer.compositeActionAllPart:addTouchEventListener(DisplayEvents.kTouchTap, self.onClickOtherPlayerHandler, self, otherPlayerInfo); 

  -- if otherPlayerInfo.PetConfigId ~= 0 and not movePlayer.pet then
  --     movePlayer.pet = PetPlayer.new();
  --     movePlayer.pet.userId = otherPlayerInfo.UserId .. "_" .. otherPlayerInfo.PetConfigId;
  --     movePlayer.pet:initPetPlayer(otherPlayerInfo.PetConfigId, otherPlayerInfo.ConfigId);
  --     local petKey = "key_" .. otherPlayerInfo.UserId .. "_" .. otherPlayerInfo.PetConfigId;
  --     self.playerList[petKey] = movePlayer.pet;

  --     movePlayer.pet.compositeActionAllPart:setVisible(isOtherPlayerOn)
  --     movePlayer.pet:setUserAndPetName(otherPlayerInfo.UserName);
  --     self:addChild(movePlayer.pet.compositeActionAllPart);
  --     movePlayer.pet.compositeActionAllPart.sprite.x = otherPlayerInfo.CoordinateX - 80;
  --     movePlayer.pet.compositeActionAllPart.sprite.y = otherPlayerInfo.CoordinateY;
  --     --movePlayer.pet.compositeActionAllPart:setScalingTo(GameConfig.PET_SCALE_RATE);
  -- end
  
  -- if movePlayer.userCityState ~= otherPlayerInfo.State then
  --    if otherPlayerInfo.State == GameConfig.USER_MAP_INFO_STATE_3 then
  --       movePlayer:standToSit()
  --    else
  --       movePlayer:sitToStand()
  --    end
  -- end

  self:sortPlayers();

end

--UserId,State,CoordinateX,CoordinateY,TargetCoordinateX,TargetCoordinateY
function PlayerLayer:showLevelUp(effectProxy,currentLvInfo,nextLvInfo)  
	self.levelUp = LevelUpEffect.new();
	self.levelUp:initializeUI(effectProxy,currentLvInfo,nextLvInfo,self);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self.levelUp);
end
function PlayerLayer:otherPlayerMove(moveInfo)  
  local key = "key_" .. moveInfo.UserId;
  local movePlayer =  self.playerList[key];
  if nil ~= movePlayer then
  	 if movePlayer.compositeActionAllPart.sprite then
	     local pathArr = {}
	     table.insert(pathArr, {x = moveInfo.MoveCoordinateX, y = moveInfo.MoveCoordinateY}); 
	     movePlayer:setPath(pathArr, self.moveComplete, self); 
	 else
	     self.playerList[key] = nil;
	 end
  end
end

function PlayerLayer:moveComplete()
   print("other user move complete");
end
function PlayerLayer:getPlayer(otherPlayerInfo)   
  for i_k, i_v in pairs(self.list) do 
     if i_v.userId == otherPlayerInfo.UserId then
      return i_v;
     end
  end
  return nil; 
end
function PlayerLayer:getPlayerByUserID(userID)
  for i_k, i_v in pairs(self.playerList) do 
    if i_v.compositeActionAllPart then
      print("????????????????????????????????????????getPlayerByUserID",i_v.compositeActionAllPart.userId,userID);
       if i_v.compositeActionAllPart.userId == userID then
        return i_v;
       end
    end
  end
end
 function PlayerLayer:removeOtherPlayer(userId)  
   if not self.userMapInfoArray then return end;

  for i_k, i_v in pairs(self.userMapInfoArray) do
   if userId == i_v.UserId then
    table.remove(self.userMapInfoArray, i_k);
    break;
   end
  end
 
  for i_k, i_v in pairs(self.list) do 
     if i_v.userId == userId then

       local key = "key_" .. i_v.userId;
       if self.playerList[key] then
	       self.playerList[key]:stopMove();

	       if self.playerList[key].pet then
	          self.playerList[key].pet:stopMove();
	          self:removeChild(self.playerList[key].pet.compositeActionAllPart, true);
	          self.playerList[key].pet:dispose()
	          self.playerList[key].pet = nil;
	       end
	       self:removeChild(i_v, true);
	       self.playerList[key]:dispose()
	       self.playerList[key] = nil;
	       break;
	    end
     end
   end
end

--
 function PlayerLayer:removePetByUserId(userId)   
    for i_k, i_v in pairs(self.list) do 
     if i_v.userId == userId then
        local key = "key_" .. i_v.userId;
        if self.playerList[key] then

	       self.playerList[key]:stopMove();

	       if self.playerList[key].pet then
	          self.playerList[key].pet:stopMove();
	          self:removeChild(self.playerList[key].pet.compositeActionAllPart, true);
	          self.playerList[key].pet:dispose()
	          self.playerList[key].pet = nil;
	       end
	       break;
	    end
     end
   end
   rolePlayer.pet = nil;
end


function PlayerLayer:getOtherPlayerXY(userId)  
  for i_k, i_v in pairs(self.list) do 
     if i_v.userId == userId then

       return i_v:getPositionX(), i_v:getPositionY();
     end
  end
  return nil, nil;
end
--
function PlayerLayer:showPlayer(userId)   
    for i_k, i_v in pairs(self.list) do 
     if i_v.userId == userId then
       local key = "key_" .. i_v.userId;
       local movePlayer = self.playerList[key];
       if movePlayer then
      	 	movePlayer.compositeActionAllPart:setVisible(true);
       		break;
        end
     end
   end
end
--UserId, PetConfigId, UserName
 function PlayerLayer:addPet(playerInfo)   
       rolePlayer.pet = PetPlayer.new();
        rolePlayer.pet.userId = playerInfo.UserId .. "_" .. playerInfo.PetConfigId;
        rolePlayer.pet:initPetPlayer(playerInfo.PetConfigId, playerInfo.ConfigId);
        local petKey = "key_" .. playerInfo.UserId .. "_" .. playerInfo.PetConfigId;
        self.playerList[petKey] = rolePlayer.pet;

        rolePlayer.pet:setUserAndPetName(playerInfo.UserName);
        self:addChild(rolePlayer.pet.compositeActionAllPart);
        rolePlayer.pet.compositeActionAllPart.sprite.x = rolePlayer.compositeActionAllPart.sprite.x - 80;
        rolePlayer.pet.compositeActionAllPart.sprite.y = rolePlayer.compositeActionAllPart.sprite.y;
        --rolePlayer.pet.compositeActionAllPart:setScalingTo(GameConfig.PET_SCALE_RATE);

end

function PlayerLayer:getPlayerCount()

   local returnValue = 0;
   if self.playerList then
     for i_k, i_v in pairs(self.playerList) do
        returnValue = returnValue + 1;
     end
   else
     self:disposeTickTime()
   end
   return returnValue;
end

function PlayerLayer:getFirstPlayer()
   local returnValue;
   for i_k, i_v in pairs(self.playerList) do
      local keyUserId = "key_" .. i_v.userId;
      returnValue = self.playerList[keyUserId];
      self.playerList[keyUserId] = nil;
      print("userId", returnValue.userId)
      return returnValue;
   end
   return returnValue;
end
-- 是否隐藏其他玩家
-- true 显示
-- false 隐藏
function PlayerLayer:visibleOtherPlayer(isVisible,userId,petConfigId)

  if isVisible then
      self:addOtherPlayers(self.userMapInfoArray, true);
  else
    local tempTable = {};
    local petId = userId .. "_" .. petConfigId;
    local childNumber = self:getPlayerCount();
    while(childNumber > 0) do
       local movePlayer = self:getFirstPlayer();
       if movePlayer then
          movePlayer:stopMove();
       end
       print("movePlayer.userId", movePlayer.userId);
       if userId ~= movePlayer.userId and (petConfigId == 0 or petId ~= movePlayer.userId) then
        self:removeChild(movePlayer.compositeActionAllPart, true);
       else
         self:removeChild(movePlayer.compositeActionAllPart, false);
        table.insert(tempTable, movePlayer);
       end
       childNumber = childNumber - 1;
    end
    --[[local childNumber = self:getNumOfChildren()
    while(childNumber > 0) do
      local child = self:getChildAt(0);
      local key = "key_" .. child.userId;
      if self.playerList[key] then
        self.playerList[key]:stopMove();
      else
	    log("playerList  is nil", key)
      end
      if userId ~= child.userId and (petConfigId == 0 or petId ~= child.userId) then
        self:removeChild(child, true);
      else
        self:removeChild(child, false);
        table.insert(tempTable, child);
      end
      childNumber = childNumber - 1;
    end]]
    
    for i_k, i_v in pairs(tempTable) do
       self:addChild(i_v.compositeActionAllPart);
       local keyUserId = "key_" .. i_v.userId;
       self.playerList[keyUserId] = i_v;
    end
  end
end

function PlayerLayer:clean()
  local childNumber = self:getNumOfChildren()
  while(childNumber > 0) do
    local child = self:getChildAt(0);
    if child.userId then
      local key = "key_" .. child.userId;
      if self.playerList[key] then
        self.playerList[key]:stopMove();
        self.playerList[key].pet = nil;
      end
    end
    self:removeChild(child);
    childNumber = childNumber - 1;
    --print("PlayerLayer..childNumber -----------"..childNumber )
  end
  self:disposeTickTime();
  self.playerList = {};
end

function PlayerLayer:refreshTitle(userID, title, enable)
  local player=self:getPlayerByUserID(userID);
  if player then
    player:refreshTitle(title,enable);
    return;
  end
  -- print("----------------------------------------player got nil----------------------------------------");
end

function PlayerLayer:refreshVip(userID, vip)
  local player=self:getPlayerByUserID(userID);
  if player then
    player:refreshVip(vip);
    return;
  end
  -- print("----------------------------------------player got nil----------------------------------------");
end


function PlayerLayer:refreshFamilyBanquet(BanquetInfoArray)
  self:cleanBanquetArray()
  if not BanquetInfoArray then
    return;
  end
  self.BanquetInfoArray = BanquetInfoArray;
  print("oooooooooooooooooooooooorefreshFamilyBanquet")
  for k, v in pairs(BanquetInfoArray)do
    print("k,v", k, v.ID);
    local familySceneBanquet = FamilySceneBanquet.new();
    familySceneBanquet:init(self, v);
    
    table.insert(self.scenBanquetArr,familySceneBanquet);
    self:addChild(familySceneBanquet);
    local xPos, yPos
    if k == 1 then
      xPos, yPos = 605+174, 245
    elseif k == 2 then
      xPos, yPos = 885+174, 245
    elseif k == 3 then
      xPos, yPos = 735+174, 90
    end
    familySceneBanquet:setPositionXY(xPos, yPos);
    self.banquetArray[v.ID] = familySceneBanquet
  end
end
function PlayerLayer:cleanBanquetArray()
  
  for i,v in ipairs(self.scenBanquetArr) do
    self:removeChild(v);
    v = nil;
  end
  self.scenBanquetArr = {};
  self.banquetArray = {};
end
-- function PlayerLayer:addBanquetPerson(id, count)
--   if self.banquetArray[id] then
--     self.banquetArray[id]:addPerson(count);
--   end
-- end
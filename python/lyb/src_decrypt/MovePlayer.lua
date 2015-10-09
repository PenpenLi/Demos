

require "main.view.mainScene.player.BasePlayer"
require "main.view.mainScene.player.VipUserHeadLayer"


MovePlayer = class(BasePlayer);
function MovePlayer:ctor()
	self.class = MovePlayer;
	self.pet = nil;
  self.petConfigId = 0;
  self.CONST_PET_DISTANCE = 80;
  self.ROLE_STAND_UP_CITY      = 9;
  self.ROLE_SIT_DOWN_CITY      = 10;
  self.ROLE_SIT_CITY      = 11;
  self.teamMates = nil;
end

function MovePlayer:removeSelf()
	self.class = nil;
end

function MovePlayer:dispose()
     self.nextPoint = nil;
    self:stopMove(nil);
    self.compositeActionAllPart = nil;
    self.speed:dispose()
    self.speed = nil;
    self.downEffect = nil
    self:removeSelf();
end


function MovePlayer:innerMove()
   self:checkAndSetPetPath()
   if gameSceneIns  then
      gameSceneIns.playerLayer:sortPlayers()
   end 
end
function MovePlayer:onStop(data)
   if self.pet and self.pet.compositeActionAllPart and  self.pet.compositeActionAllPart.bodySourceName then
      self.pet:stopMove(data);
   end
end
function MovePlayer:getPetDistance()
   local distance = (self.pet.compositeActionAllPart.sprite.x - self.compositeActionAllPart.sprite.x) * (self.pet.compositeActionAllPart.sprite.x - self.compositeActionAllPart.sprite.x) - (self.pet.compositeActionAllPart.sprite.y - self.compositeActionAllPart.sprite.y) * (self.pet.compositeActionAllPart.sprite.y - self.compositeActionAllPart.sprite.y)
   return math.sqrt(distance);
end
function MovePlayer:checkAndSetPetPath()
      if self.pet and self.CONST_PET_DISTANCE < self:getPetDistance() then
          if not self.pet.isMoving then
            if self.nextPoint.x > self.compositeActionAllPart.sprite.x and  self.compositeActionAllPart.sprite.x >  self.pet.compositeActionAllPart.sprite.x then
               self.pet:setPath({[1] = {x = (self.nextPoint.x - 79), y = (self.nextPoint.y)}});
            elseif self.nextPoint.x < self.compositeActionAllPart.sprite.x and  self.compositeActionAllPart.sprite.x < self.pet.compositeActionAllPart.sprite.x then
               self.pet:setPath({[1] = {x = (self.nextPoint.x + 79), y = (self.nextPoint.y)}});
            end
          else

            if self.speed:getDirection() ~= self.pet.speed:getDirection() then
              if self.nextPoint.x < self.compositeActionAllPart.sprite.x and  self.compositeActionAllPart.sprite.x <  self.pet.compositeActionAllPart.sprite.x then
                 self.pet:setPath({[1] = {x = (self.nextPoint.x - 79), y = (self.nextPoint.y)}});
              elseif self.nextPoint.x > self.compositeActionAllPart.sprite.x and  self.compositeActionAllPart.sprite.x >  self.pet.compositeActionAllPart.sprite.x then
                self.pet:setPath({[1] = {x = (self.nextPoint.x + 79), y = (self.nextPoint.y)}});
              end
            end
          end
      end
end
--宠物停下来之后不需要回调
function MovePlayer:setPetPath(pathArray)
  if self.pet and self.CONST_PET_DISTANCE < self:getPetDistance() then

      local dest_x, dest_y = pathArray[1].x, pathArray[1].y
      if dest_x > self.compositeActionAllPart.sprite.x and  self.compositeActionAllPart.sprite.x >  self.pet.compositeActionAllPart.sprite.x then
               self.pet:setPath({[1] = {x = (dest_x - 79), y = (dest_y)}});
      elseif dest_x < self.compositeActionAllPart.sprite.x and  self.compositeActionAllPart.sprite.x < self.pet.compositeActionAllPart.sprite.x then
               self.pet:setPath({[1] = {x = (dest_x + 79), y = (dest_y)}});
      end
  -- elseif self.teamMates then 
  --     for i_k, i_v in pairs(self.teamMates) do
  --       i_v:setPath(pathArray);
  --     end
  end
end

function MovePlayer:initPlayer(itemIdBody, itemIdWeapon, userId)

	self.speed.interval = 300 * 1/60;
	
    AvatarUtil:cacheCompositeRoleTable(itemIdBody, itemIdWeapon, BattleConfig.RUN);
    AvatarUtil:cacheCompositeRoleTable(itemIdBody, itemIdWeapon, BattleConfig.HOLD);

    local compsiteTable = AvatarUtil:getCompositeRoleTable(itemIdBody, itemIdWeapon, BattleConfig.HOLD);
    --print("itemIdBody--"..itemIdBody.."+++itemIdWeapon===="..itemIdWeapon)
    if self.compositeActionAllPart == nil then
    
        self.compositeActionAllPart  = CompositeActionAllPart.new();
        self.compositeActionAllPart:initLayer();
   
        self.compositeActionAllPart:transformPartCompose(compsiteTable);
  
        --self.sprite = self.compositeActionAllPart.sprite;
        --self.sprite:retain();

        local roleShadow = Image.new()
        roleShadow:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
        roleShadow:setPositionXY(0,10)
        roleShadow:setAnchorPoint(CCPointMake(0.5,0.75));
    		roleShadow.touchEnabled = false
    		roleShadow.touchChildren = false
        self.compositeActionAllPart:addChildAt(roleShadow,0);  

    end
    self.itemIdBody = itemIdBody;
    self.itemIdWeapon = itemIdWeapon;
    self.userId = userId;
    self.compositeActionAllPart.userId = userId;
	

end

function MovePlayer:setName(playerName, coordinateX, coordinateY, color, titles, vip)
    if not titles then
        if self.userTitleLayer and self.userTitleLayer:getTitles() then
          titles=self.userTitleLayer:getTitles();
        else
          titles={};
        end
    end

    if self.compositeActionAllPart then
        local level1Min=analysis("Huiyuan_Huiyuandengji", 1, "min");
        local vipwidth = 0
        local namewidth
        if nil ~= vip and vip >= level1Min then
            if nil == self.vipUserHeadLayer then
                self.vipUserHeadLayer=VipUserHeadLayer.new();
                self.vipUserHeadLayer:initialize(vip, 1);
                self.compositeActionAllPart:addChild(self.vipUserHeadLayer);
            else
                self.vipUserHeadLayer:refresh(vip, 1);
            end
            vipwidth = self.vipUserHeadLayer:getContentSize().width
        else
          self.compositeActionAllPart:removeChild(self.vipUserHeadLayer);
          self.vipUserHeadLayer = nil;
        end
    

        local txtAlign = "center";
        local txtAlign2 = kCCVerticalTextAlignmentCenter
        if nil ~= vip and vip >= level1Min then

          local txtAlign = "left";
          local txtAlign2 = kCCVerticalTextAlignmentCenter
        end


        if nil == self.userNameText then
          self.userNameText=TextField.new(CCLabelTTFStroke:create(playerName, GameConfig.DEFAULT_FONT_NAME, 22, 1, ccc3(0,0,0), CCSizeMake(0, 0), txtAlign, txtAlign2), true);
          self.userNameText:setColor(CommonUtils:ccc3FromUInt(color));
        end
        -- 根据名字的宽度定位
        self.userNameText:setString(" " .. playerName);
        self.userNameText.touchEnabled = false;
        namewidth = self.userNameText:getContentSize().width
        self.compositeActionAllPart:addChild(self.userNameText);

        if nil ~= vip and vip >= level1Min then
          self.vipUserHeadLayer:setPositionXY(-(vipwidth + namewidth) / 2, coordinateY - 20);
          self.userNameText:setPositionXY(vipwidth-(vipwidth + namewidth) / 2 - 10, coordinateY);
        else
          self.userNameText:setPositionXY(-namewidth/ 2, coordinateY);
        end



    end
end

function MovePlayer:refreshTitle(title, enable)
  self.userTitleLayer:refreshTitle(title,enable);
  self.userTitleLayer:setVisible(GameData.isShowPlayerTitle);
end

function MovePlayer:refreshVip(vip)
  if self.vipUserHeadLayer then
    self.vipUserHeadLayer:refresh(vip, 1);
  end
end
function MovePlayer:setState(state)
  self.userCityState = state;
  if state == GameConfig.USER_MAP_INFO_STATE_1 then
     self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_STAND_CITY));
  elseif state == GameConfig.USER_MAP_INFO_STATE_3 then
     print("role is sit *****************************************************************")
     self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_SIT_CITY));
     if not self.upEffect then
       self.upEffect = cartoonPlayer("341",-3,60, 0);
       local plistItem = plistData["key_341_1001"];
       self.upEffect.touchEnabled = false;
       self.compositeActionAllPart:addChild(self.upEffect)
       GameData.deleteSubMainSceneTextureMap[plistItem.source] = plistItem.source;
       GameData.deleteAllMainSceneTextureMap[plistItem.source] = plistItem.source;
     end
     
     if not self.downEffect then
       self.downEffect = cartoonPlayer("348",0,22, 0);
       self.downEffect.touchEnabled = false;
       self.compositeActionAllPart:addChildAt(self.downEffect, 0)
       plistItem = plistData["key_348_1001"];
       GameData.deleteSubMainSceneTextureMap[plistItem.source] = plistItem.source;
       GameData.deleteAllMainSceneTextureMap[plistItem.source] = plistItem.source;
     else
       print("hangupEffect is not nil (self.downEffect)")
     end


  end
end

function MovePlayer:sitToStand()
 
  local function standUpCallBack()
     if self.isMoving then
        self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_RUN));
     else
        self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_STAND_CITY));
     end
  end
  self.compositeActionAllPart:playAndBack(tostring(self.ROLE_STAND_UP_CITY), standUpCallBack);
  self.userCityState = GameConfig.USER_MAP_INFO_STATE_1;

  if self.upEffect then
    self.compositeActionAllPart:removeChild(self.upEffect)
  end

  if self.downEffect then
    self.compositeActionAllPart:removeChild(self.downEffect)
  end
end

function MovePlayer:standToSit()
  self.userCityState = state;
  local function sitDownCallBack()
     self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_SIT_CITY));
     self.upEffect = cartoonPlayer("341",-3,60, 0);
     local plistItem = plistData["key_341_1001"];
     GameData.deleteSubMainSceneTextureMap[plistItem.source] = plistItem.source;
     GameData.deleteAllMainSceneTextureMap[plistItem.source] = plistItem.source;
    

     self.upEffect.touchEnabled = false;
     self.compositeActionAllPart:addChild(self.upEffect)

     self.downEffect = cartoonPlayer("348",0,22, 0);
     plistItem = plistData["key_348_1001"];
      GameData.deleteSubMainSceneTextureMap[plistItem.source] = plistItem.source;
     GameData.deleteAllMainSceneTextureMap[plistItem.source] = plistItem.source;

     self.downEffect.touchEnabled = false;
     self.compositeActionAllPart:addChildAt(self.downEffect, 0)
  end
  self.compositeActionAllPart:playAndBack(tostring(self.ROLE_SIT_DOWN_CITY), sitDownCallBack);
  self.userCityState = GameConfig.USER_MAP_INFO_STATE_3;
end

function MovePlayer:cleanLoseTitle()
  if self.loserTitle then
    self.compositeActionAllPart:removeChild(self.loserTitle);
    self.loserTitle = nil;
  end
end
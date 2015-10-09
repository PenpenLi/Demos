
require "core.utils.class"
require "core.display.Scene"
require "core.display.Layer"
require "core.display.Director"
require "main.common.transform.CompositeActionAllPart"
require "main.config.MainConfig"
require "main.view.mainScene.player.Speed"

BasePlayer = class();
function BasePlayer:ctor()
	self.class = BasePlayer;
	self.movePlayerUpdateID = -1;
	self.nextPoint = nil;
  self.isMoving = false;
	self.speed = Speed.new();
  self.ROLE_RUN = 2;
  self.ROLE_STAND_CITY = 1;
  self.userCityState = GameConfig.USER_MAP_INFO_STATE_1;
end

function BasePlayer:removeSelf()
	self.class = nil;
end

function BasePlayer:dispose()
    self.nextPoint = nil;
    self:stopMove(nil);
   	self.compositeActionAllPart = nil;
    self.speed:dispose()
    self.speed = nil;
    self:removeSelf();
end

function BasePlayer:hasNextPoint()
  local len = table.getn(self.pathArray);
  if len > 0 then 
      self.nextPoint = table.remove(self.pathArray, 1);
      return true;
  else
      self.pathArray = {};
      return false;
	end
end

function BasePlayer:nextPathPoint()
    if self.compositeActionAllPart and self.compositeActionAllPart.sprite then
      self.speed:setPoint(self.compositeActionAllPart.sprite.x, self.compositeActionAllPart.sprite.y, self.nextPoint.x, self.nextPoint.y);
      if self.nextPoint.x >= self.compositeActionAllPart.sprite.x then 
        self.compositeActionAllPart:changeFaceDirect(false);
      else
        self.compositeActionAllPart:changeFaceDirect(true);
      end
    else
      log("!!!!!!!!!!!!!!!!!!!!!!BasePlayer:nextPathPoint self.compositeActionAllPart.sprite is nil")
      self:stopMove();
    end
end
function BasePlayer:innerMove()
    
end
function BasePlayer:onMove()
   if self.compositeActionAllPart and self.compositeActionAllPart.sprite then
      if self.speed.xSpeed and self.compositeActionAllPart.sprite.x then
         self.compositeActionAllPart.sprite.x = self.compositeActionAllPart.sprite.x + self.speed.xSpeed;
         self.compositeActionAllPart.sprite.y = self.compositeActionAllPart.sprite.y + self.speed.ySpeed;
         
         self:innerMove();
      end 
   end
end
function BasePlayer:isArrive()
	if  self.speed:getDistance() <  self.speed.speedValue then
	    return true;
	else 
      return false;
  end 
end
function BasePlayer:stopMove(data)
     if self.movePlayerUpdateID > -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.movePlayerUpdateID);
        self.movePlayerUpdateID = -1;
     end

     self.userCityState = GameConfig.USER_MAP_INFO_STATE_1;
     self.pathArray = {};
     self.isMoving = false;
     self:onStop(data);
     if self.compositeActionAllPart then
       self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_STAND_CITY));
     end
end
function BasePlayer:onStop(data)

end
--宠物停下来之后不需要回调
function BasePlayer:setPetPath(pathArray)

end
function BasePlayer:setPath(pathArray, moveComplete, target, data)
   self.pathArray = pathArray;
   self.target = target;
   self.moveComplete = moveComplete;
   self.data = data;
   if nil == pathArray then
     print("pathArray is nil");
     return;
   end     

    self:setPetPath(pathArray);
    local function tick(dt)
      local bArrive = self:isArrive();
      if bArrive then
        if self:hasNextPoint() then
           self.isMoving = true;
           self:nextPathPoint();
           self:onMove();
           if gameSceneIns then
            gameSceneIns.playerLayer:sortPlayers()
           end
        else 
            self:stopMove(nil);
            if self.moveComplete then
              self.moveComplete(self.target, self.data);
              -- log("self.moveComplete execute")
            end
        end
      else
         self.isMoving = true;
         self:nextPathPoint();
         self:onMove();
         self.speed:update(self.compositeActionAllPart.sprite.x, self.compositeActionAllPart.sprite.y);
     end
   end

    if self:hasNextPoint() then  
       if self.userCityState == GameConfig.USER_MAP_INFO_STATE_1 then
        self.compositeActionAllPart:playAndLoop(tostring(self.ROLE_RUN));
       end
       if self.movePlayerUpdateID == -1 then
            self.movePlayerUpdateID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0, false);   
       end
       self.isMoving = true;
       self:nextPathPoint();   
    end
    self.userCityState = GameConfig.USER_MAP_INFO_STATE_2;
end
function BasePlayer:initPlayer(itemIdBody, itemIdWeapon, userId)


end

function BasePlayer:setPlayerPosition(coordinateX, coordinateY)
         self.compositeActionAllPart.sprite:setAnchorPoint(CCPointMake(coordinateX, coordinateY));
         self.compositeActionAllPart.sprite.x = coordinateX;
         self.compositeActionAllPart.sprite.y = coordinateY;
end

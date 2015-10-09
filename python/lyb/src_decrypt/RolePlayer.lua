require "core.utils.class"
require "core.display.Scene"
require "main.view.mainScene.player.MovePlayer"

RolePlayer = class(MovePlayer);
function RolePlayer:ctor()
	self.class = RolePlayer;
  self.lastCoordinateX = nil;
  self.lastCoordinateY = nil;
  self.lastStopTime = nil;
  self.needFixPos = true;  --是否需要在剧情图中修正位置
end
function RolePlayer:dispose()
    self.nextPoint = nil;
    self:stopMove();
    --self.compositeActionAllPart.sprite:release();
    --self.compositeActionAllPart.sprite = nil;
    self.compositeActionAllPart = nil;
    self.speed:dispose()
    self.speed = nil;
    self:removeSelf();
end
function RolePlayer:innerMove()
       self:checkAndSetPetPath(); 
       self:updateSceneXY();
       if gameSceneIns and gameSceneIns.playerLayer then
           -- print("gameSceneIns.playerLayer:sortPlayers()")
           gameSceneIns.playerLayer:sortPlayers()
       end
       -- if nil == self.lastCoordinateX then
       --    self.lastCoordinateX = self.compositeActionAllPart.sprite.x;
       -- elseif (math.abs(self.lastCoordinateX - self.compositeActionAllPart.sprite.x) > 200) then
       --     if gameSceneIns and gameSceneIns.sceneType ==  GameConfig.SCENE_TYPE_1  then
       --       local msg = {TargetCoordinateX = self.compositeActionAllPart.sprite.x, TargetCoordinateY = self.compositeActionAllPart.sprite.y, State = 2};
       --       sendMessage(5,1,msg);
       --       self.lastCoordinateX = self.compositeActionAllPart.sprite.x;
       --     end
       -- end                
end


function RolePlayer:updateSceneXY()
    if not gameSceneIns then
        return
    end
     local isInMovemap = gameSceneIns:moveMapContain(self.compositeActionAllPart.sprite.x, self.compositeActionAllPart.sprite.y);
     -- print("isInMovemap:", isInMovemap)     
     if isInMovemap then   
      GameVar.mapBgX = GameVar.mapBgX - self.speed.xSpeed;
      GameVar.mapBgY = GameVar.mapBgY - self.speed.ySpeed;  
      gameSceneIns:updatePostion(GameVar.mapBgX,  GameVar.mapBgY, 0.2, 0.4);
      return;
     end
     if (GameVar.mapWidth + GameVar.mapBgX >= GameVar.screenWidth and GameVar.mapBgX <= 0) then
         local minWidth = GameVar.screenWidth * 0.5;
         if(self.compositeActionAllPart.sprite.x > minWidth and self.compositeActionAllPart.sprite.x < GameVar.mapWidth - minWidth) then
            -- print("GameVar.mapBgX, self.speed.xSpeed", GameVar.mapBgX, self.speed.xSpeed)
            GameVar.mapBgX = GameVar.mapBgX - self.speed.xSpeed;
            if(GameVar.mapBgX > 0) then
                GameVar.mapBgX = 0;
            end
            if(GameVar.mapWidth + GameVar.mapBgX <= GameVar.screenWidth) then
                GameVar.mapBgX = GameVar.screenWidth - GameVar.mapWidth;
            end
         elseif self.compositeActionAllPart.sprite.x < GameVar.screenWidth/2 - 8 then
            GameVar.mapBgX = GameVar.mapBgX/2;
         elseif self.compositeActionAllPart.sprite.x > GameVar.screenWidth/2 + 8 then
            GameVar.mapBgX = GameVar.screenWidth - GameVar.mapWidth;
         end
     end
     
     if ( GameVar.mapHeight + GameVar.mapBgY >= GameVar.screenHeight  and GameVar.mapBgY <= 0) then
         local minHeight = GameVar.screenHeight * 0.5;
         if(self.compositeActionAllPart.sprite.y > minHeight and self.compositeActionAllPart.sprite.y < GameVar.mapHeight - minHeight) then
            GameVar.mapBgY = GameVar.mapBgY - self.speed.ySpeed;
            if(GameVar.mapBgY > 0) then
                GameVar.mapBgY = 0;
            end
            if(GameVar.mapHeight + GameVar.mapBgY <= GameVar.screenHeight) then
                GameVar.mapBgY = GameVar.screenHeight - GameVar.mapHeight;
            end
         end       
     end
     -- print("before GameVar.mapBgX:", GameVar.mapBgX)
     self:correctSceneXY();
     -- print("after GameVar.mapBgX:", GameVar.mapBgX)

     gameSceneIns:updatePostion(GameVar.mapBgX, GameVar.mapBgY, 0.2, 0.4);
end
--修正
function RolePlayer:correctSceneXY()
   if(GameVar.mapBgX > 0) then
      GameVar.mapBgX = 0;  
   elseif(GameVar.mapWidth + GameVar.mapBgX < GameVar.screenWidth) then
     --print("GameVar.screenWidth:" .. GameVar.screenWidth)
     -- print("GameVar.mapWidth:" .. GameVar.mapWidth)
     -- print("GameVar.mapBgX:" .. GameVar.mapBgX)
     GameVar.mapBgX = GameVar.screenWidth - GameVar.mapWidth;
   end
   
   if(GameVar.mapBgY > 0) then
      GameVar.mapBgY = 0;     
   elseif(GameVar.mapHeight + GameVar.mapBgY < GameVar.screenHeight) then
     --print("GameVar.mapBgY:" .. GameVar.mapBgY)
     GameVar.mapBgY = GameVar.screenHeight - GameVar.mapHeight;
   end
  
end

function RolePlayer:onStop(data)
   if self.pet and self.pet.compositeActionAllPart and  self.pet.compositeActionAllPart.bodySourceName then
      self.pet:stopMove(data);
   end
   if gameSceneIns then
       if gameSceneIns.sceneType == GameConfig.SCENE_TYPE_2 and data and data.needFixPos then--,如果不想点一下关卡回到离玩家最近的位置只需要把注释解注
        -- gameSceneIns:resetState();
        --log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%it's dangerous, it will make person stop to do task%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
       else
         -- gameSceneIns:removeClickTarget();
        
       end
   end
end

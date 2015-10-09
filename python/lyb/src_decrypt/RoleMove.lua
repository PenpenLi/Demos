RoleMove = class();

function RoleMove:ctor()
    self.class = RoleMove;
end

function RoleMove:removeSelf()
    self.class = nil;
end

function RoleMove:dispose()
    self:removeSelf();
end

function RoleMove:initData(roleVO)
    self.roleVO = roleVO;
end

function RoleMove:startMove()
    if not self.roleVO or not self.roleVO.targetCoordinateX or not self.roleVO.targetCoordinateY then return end
    self.stdx,self.stdy = self.roleVO:getPositionXY();
    local dx = (self.roleVO.targetCoordinateX-self.stdx);
    local dy = (self.roleVO.targetCoordinateY-self.stdy);
    local sqr = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
    self.speed = self.roleVO.speed*GameConfig.Game_FreamRate
    self.stepx = self.speed*dx/sqr;
    self.stepy = self.speed*dy/sqr;
    
end

function RoleMove:positionMove()
    local standx,standy = self.roleVO:getPositionXY();
    if standx~=self.stdx or standy~=self.stdy then self:startMove() end
    self.stdx = self.stdx+self.stepx;
    self.stdy = self.stdy+self.stepy;
    self.roleVO:setPositionXY(self.stdx,self.stdy);
    local dx = self.roleVO.targetCoordinateX-self.stdx;
    local dy = self.roleVO.targetCoordinateY-self.stdy;
    local sqr = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
    if sqr <= self.speed then
        self.roleVO.battleIcon:playAndLoop(BattleConfig.HOLD);
        self.roleVO.battleIcon:changeFaceDirect(self.roleVO.standPoint == BattleConfig.Battle_StandPoint_2)
        self.roleVO:setPositionXY(self.roleVO.targetCoordinateX,self.roleVO.targetCoordinateY)
        return true;
    end
end
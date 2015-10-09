require "core.utils.class"

Speed = class();
function Speed:ctor()
	self.class = Speed;
    self.direction = 0;
    self.distance = 0;
    self.xSpeed = 0;
    self.ySpeed = 0;
    self.timeSpeed = 1;
 
    self.speedValue = 1;
    
    self.startX = nil;
    self.startY = nil;
    self.endX = nil;
    self.endY = nil;
	self.interval = 1
end

function Speed:removeSelf()
	self.class = nil;
end

function Speed:dispose()
	self:removeSelf();
end

function Speed:getDirection()
    return self.direction;
end
function Speed:getDistance()
    return self.distance;
end
function Speed:update(x, y)
    if (self.direction == 1 and x > self.endX) or (self.direction == -1 and self.startX < self.endX) then 
        self.startX = self.endX;
		self.startY = self.endY;
	else
	    self.startX = x;
		self.startY = y;  
    end
    self:updateSpeed()
end

function Speed:updateSpeed()
    self.distance= math.pow(self.startX - self.endX, 2) + math.pow(self.startY - self.endY, 2);
    self.distance = math.sqrt(self.distance);
    local radians = math.atan2(self.endY - self.startY, self.endX - self.startX );
    	
    --local interval = 10;
    self.speedValue = self.timeSpeed * self.interval*1.5;
    self.xSpeed = math.floor(self.speedValue * math.cos(radians));
    self.ySpeed = math.floor(self.speedValue * math.sin(radians));
    
    if self.startX > self.endX then
	    self.direction = -1;
	    self.xSpeed = -math.abs(self.xSpeed);
	else 
	    self.xSpeed = math.abs(self.xSpeed);
	    self.direction = 1;
	end
	
	if self.startY > self.endY then
	    self.ySpeed = -math.abs(self.ySpeed);
	else
	    self.ySpeed = math.abs(self.ySpeed);
	end

	--[[local content ="xSpeed:" ..self.xSpeed .. ",yspeedValue:" .. self.ySpeed
	if testfile ~= nil then
	   testfile:write(content)
	end
    if(clickcount > 6 ) then 
      testfile:close()
      testfile = nil
    end]]--
    
end
function Speed:setPoint(startX, startY, endX, endY)
    self.startX = math.floor(startX);
    self.startY = math.floor(startY);
    self.endX = math.floor(endX);
    self.endY = math.floor(endY);
    self:updateSpeed();
end

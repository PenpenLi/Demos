require "core.controls.MotionStreak"

MotionStreakBlade = class(Layer);

function MotionStreakBlade:ctor()
	self.class = MotionStreakBlade;
	self.startPointX = 0;
	self.startPointY = 0;

	--法向量 与资源图片中箭头所指的方向的反方向
	self.normalVectorX = 0;
	self.normalVectorY = 1;

	self.direction = 0;
end

function  MotionStreakBlade:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	MotionStreakBlade.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function MotionStreakBlade:initialize(context, fade, minSeg, stroke, color, tailID, headID)
	-- self.sprite = CCMotionStreakBlade:create(0.5, 0.5, 20.0, ccc3(255,255,255), "resource/0000.png");
	self:initLayer();

	self.tail = MotionStreak.new();
	self.tail:initialize(context, fade, minSeg, stroke, color, tailID);
	self:addChild(self.tail);

	self.head = Sprite.new(CCSprite:create(artData[headID].source));
	self.head:setScale(0.5);
	self:addChild(self.head);
	self.head:setAnchorPoint(ccp(0.5, 0.4));
	self.head:setVisible(false);

	context:addEventListener(DisplayEvents.kTouchBegin, self.streakBegin, self);
	context:addEventListener(DisplayEvents.kTouchMove, self.streakMove, self);
	context:addEventListener(DisplayEvents.kTouchEnd, self.streakEnd, self);
end

function MotionStreakBlade:streakBegin(evt)
	self.startPointX = evt.globalPosition.x;
	self.startPointY = evt.globalPosition.y;
	self:dispatchEvent(Event.new("BEGING_MOVE", ccp(self.startPointX, self.startPointY)));
	self.head:setPosition(evt.globalPosition);
	self.head:setVisible(true);
end

function MotionStreakBlade:streakMove(evt)
	local x1 = evt.globalPosition.x - self.startPointX;
	local y1 = evt.globalPosition.y - self.startPointY;
	self.startPointX = evt.globalPosition.x;
	self.startPointY = evt.globalPosition.y;
	local a = math.sqrt(x1*x1 + y1*y1);
	local b = math.sqrt(self.normalVectorX*self.normalVectorX + self.normalVectorY*self.normalVectorY);
	local c = x1*self.normalVectorX + self.normalVectorY*y1;
	local rotation = math.deg(math.acos(c/(a*b)));
	if x1 > 0 then
		self.head:setRotation(rotation+180, true);
		self.direction = rotation+180;
	else
		self.head:setRotation(-rotation-180, true);
		self.direction = -rotation-180;
	end
	self.head:setPosition(evt.globalPosition);
	self:dispatchEvent(Event.new("MOVING", ccp(evt.globalPosition.x, evt.globalPosition.y)));
end

function MotionStreakBlade:streakEnd(evt)
	self.head:setVisible(false);
	self:dispatchEvent(Event.new("STOP"));
end

function MotionStreakBlade:getDirection()
	if self.direction > 360 then
		return self.direction - 360
	elseif self.direction < -360 then
		return self.direction + 360
	else
		return self.direction
	end
end
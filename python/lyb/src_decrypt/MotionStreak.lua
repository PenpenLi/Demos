
MotionStreak = class(DisplayNode);

function MotionStreak:ctor()
	self.class = MotionStreak;
end

function MotionStreak:dispose()
	self.context:removeEventListener(DisplayEvents.kTouchBegin, self.streakBegin);
	self.context:removeEventListener(DisplayEvents.kTouchMove, self.streakMove);
	self.context:removeEventListener(DisplayEvents.kTouchEnd, self.streakEnd);
	self:removeAllEventListeners();
	self:removeChildren();
	MotionStreak.superclass.dispose(self);
	BitmapCacher:removeUnused();
end

function MotionStreak:initialize(context, fade, minSeg, stroke, color, artID)
	-- self.sprite = CCMotionStreak:create(0.5, 0.5, 20.0, ccc3(255,255,255), "resource/0000.png");
	
	self.sprite = CCMotionStreak:create(fade, minSeg, stroke, color, artData[artID].source);
	if self.sprite then
		self.sprite:retain();
		self.sprite:setAnchorPoint(CCPointMake(0,0));
		self.sprite:setFastMode(true);
	end

	self.context = context;
	context:addEventListener(DisplayEvents.kTouchBegin, self.streakBegin, self);
	context:addEventListener(DisplayEvents.kTouchMove, self.streakMove, self);
	context:addEventListener(DisplayEvents.kTouchEnd, self.streakEnd, self);
end

function MotionStreak:streakBegin(evt)
	if not self.sprite.isSchedule then
		self.sprite.isSchedule = true;
		self.sprite:setPosition(evt.globalPosition);
		self.sprite:scheduleUpdate();
	end
end

function MotionStreak:streakEnd(evt)
	self.sprite:reset();
end

function MotionStreak:streakMove(evt)
	self.sprite:setPosition(evt.globalPosition);
end
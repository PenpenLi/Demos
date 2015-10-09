BloodProgressBar = class(Layer);

function BloodProgressBar:ctor()
	self.class = BloodProgressBar;  

end

function BloodProgressBar:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    BloodProgressBar.superclass.dispose(self);
end

function BloodProgressBar:initUI(skeleton)
	self.barDown = skeleton:getBoneTextureDisplay("blood_progressbar_down");
	local size = self.barDown:getContentSize()
	self.barDown:setPositionXY(-size.width/2,-size.height/2)
	self:addChild(self.barDown);
	require "core.controls.ProgressBarSkeleton";
	local barUp = ProgressBarSkeleton.new(skeleton,"blood_progressbar_up")
	local size = barUp:getContentSize()
	barUp:setPositionXY(-size.width/2,-size.height/2)
	barUp:setProgress(1)
	self:addChild(barUp);
	self.barUp = barUp;
	self.barDown:setAlpha(0);
	self.barUp:setAlpha(0)
end

function BloodProgressBar:refreshBarData(value)
	self.barUp:setProgress(value)
	self:fadeInAndFadeOut()
end

function BloodProgressBar:fadeInAndFadeOut()
	self.barDown:stopAllActions()
	self.barUp:stopAllActions()
	local fadeIn = CCFadeIn:create(0.2, 1);
	local fadeOut = CCFadeOut:create(0.3,0)
	local delay = CCDelayTime:create(2);
	local ccArray = CCArray:create();
	ccArray:addObject(fadeIn)
	ccArray:addObject(delay)
	ccArray:addObject(fadeOut)
	self.barUp:runAction(CCSequence:create(ccArray))
	local ccArray1 = CCArray:create();
	ccArray1:addObject(fadeIn:copy():autorelease())
	ccArray1:addObject(delay:copy():autorelease())
	ccArray1:addObject(fadeOut:copy():autorelease())
	self.barDown:runAction(CCSequence:create(ccArray1))
end
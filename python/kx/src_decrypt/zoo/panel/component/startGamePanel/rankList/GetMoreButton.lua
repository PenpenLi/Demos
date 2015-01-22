
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê11ÔÂ13ÈÕ  10:03:40
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- GetMoreButton
---------------------------------------------------

GetMoreButton = class(BaseUI)

function GetMoreButton:ctor()
end

function GetMoreButton:init(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	-----------------
	-- Init Base Class
	-------------------
	BaseUI.init(self, ui)

	---------------------
	-- Get UI Component
	-- --------------

	local btnWithoutShadow	= ui:getChildByName("btnWithoutShadow")
	self.threeLittleMan	= btnWithoutShadow:getChildByName("threeLittleMan")
	local leftLittleMan	= self.threeLittleMan:getChildByName("left")
	local middleLittleMan	= self.threeLittleMan:getChildByName("middle")
	local rightLittleMan	= self.threeLittleMan:getChildByName("right")
	self.label		= btnWithoutShadow:getChildByName("label")
	self.blueBg		= btnWithoutShadow:getChildByName("_blueBg")
	self.grayBg		= btnWithoutShadow:getChildByName("_grayBg")

	assert(leftLittleMan)
	assert(middleLittleMan)
	assert(rightLittleMan)
	assert(self.label)
	assert(self.blueBg)
	assert(self.grayBg)

	------------
	-- Init UI
	-- --------
	he_log_warning("should use localization text !")
	self.label:setString("Get More")
	self.grayBg:setVisible(false)
end

function GetMoreButton:setToWaitState(...)
	assert(#{...} == 0)

	self.label:setString("Wait ... ")
	self.grayBg:setVisible(true)
	self.blueBg:setVisible(false)

	local threeLittleManAnim = self:createLittleManJumpAction(self.threeLittleMan)
	local repeatForever = CCRepeatForever:create(threeLittleManAnim)
	self.threeLittleMan:runAction(repeatForever)
end

function GetMoreButton:createLittleManJumpAction(threeLittleManResource, ...)
	assert(threeLittleManResource)
	assert(#{...} == 0)

	-- Get UI To Control
	local leftLittleMan	= threeLittleManResource:getChildByName("left")
	local rightLittleMan	= threeLittleManResource:getChildByName("right")
	local middleLittleMan	= threeLittleManResource:getChildByName("middle")

	assert(leftLittleMan)
	assert(rightLittleMan)
	assert(middleLittleMan)

	local leftLittleManAnimInfo = {
		secondPerFrame = 1/24,
		object = {
			node 		= leftLittleMan,
			deltaScaleX	= 1,
			deltaScaleY	= 1,
			originalScaleX	= 1,
			originalScaleY	= 1,
		},
		keyFrames = {
			{ tweenType = "normal", frameIndex = 1,		x = 5 + 0, y = -8, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 5,		x = 5 + 0, y = -8, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 9,		x = 5 + 0, y = -13, sx = 0.8, sy = 0.681 },
			{ tweenType = "normal", frameIndex = 11,	x = 5 + 0, y = 10 + 6.75, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 15,	x = 5 + 0, y = -4.25, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 17,	x = 5 + 0, y = -19, sx = 0.8, sy = 0.538 },
			{ tweenType = "static", frameIndex = 19,	x = 5 + 0, y = -8, sx = 0.8, sy = 0.8 },
			{ tweenType = "delay", frameIndex = 22 }
		}
	}
	local leftLittleManAnimation = FlashAnimBuilder:sharedInstance():buildTimeLineAction(leftLittleManAnimInfo)

	local middleLittleManAnimInfo = {
		secondPerFrame = 1/24,
		object = {
			node		= middleLittleMan,
			deltaScaleX	= 1,
			deltaScaleY	= 1,
			originalScaleX	= 1,
			originalScaleY	= 1,
		},

		keyFrames = {
			{ tweenType = "normal", frameIndex = 1,		x = 14.9, 	y = 7 + 0, 	sx = 1, sy = 1 },
			{ tweenType = "normal", frameIndex = 5,		x = 14.9, 	y = 7 + -6, 	sx = 1, sy = 0.856 },
			{ tweenType = "normal", frameIndex = 7,		x = 14.9, 	y = 7 + 15.50, 	sx = 1, sy = 1 },
			{ tweenType = "normal", frameIndex = 11,	x = 14.9, 	y = 7 + 4.0, 	sx = 1, sy = 1 },
			{ tweenType = "normal", frameIndex = 13,	x = 14.9, 	y = 7 + -12, 	sx = 1, sy = 0.712 },
			{ tweenType = "static", frameIndex = 15,	x = 14.9, 	y = 7 + 0, 	sx = 1, sy = 1},
			{ tweenType = "delay", frameIndex = 22 } 
		}
	}
	local middleLittleManAnimation = FlashAnimBuilder:sharedInstance():buildTimeLineAction(middleLittleManAnimInfo)

	local rightLittleManAnimInfo = {
		secondPerFrame = 1/24,
		object = {
			node		= rightLittleMan,
			deltaScaleX	= 1,
			deltaScaleY	= 1,
			originalScaleX	= 1,
			originalScaleY	= 1,
		},

		keyFrames = {
			{ tweenType = "normal", frameIndex = 1, x = 36.65, y = -8, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 3, x = 36.65, y = -8, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 7, x = 36.65, y = -13, sx = 0.8, sy = 0.679 },
			{ tweenType = "normal", frameIndex = 9, x = 36.65, y = 10 + 7.25, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 13, x = 36.65, y = -4.25, sx = 0.8, sy = 0.8 },
			{ tweenType = "normal", frameIndex = 15, x = 36.65, y = -19.50, sx = 0.8, sy = 0.521 },
			{ tweenType = "static", frameIndex = 17, x = 36.65, y = -8, sx = 0.8, sy = 0.8 },
			{ tweenType = "delay", frameIndex = 22 }
		}
	}
	local rightLittleManAnimation = FlashAnimBuilder:sharedInstance():buildTimeLineAction(rightLittleManAnimInfo)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(leftLittleManAnimation)
	actionArray:addObject(middleLittleManAnimation)
	actionArray:addObject(rightLittleManAnimation)

	-- Spawn
	local spawn = CCSpawn:create(actionArray)
	return spawn
end

function GetMoreButton:create(ui, ...)
	assert(ui)
	assert(#{...} == 0)

	local newGetMoreButton = GetMoreButton.new()
	newGetMoreButton:init(ui)
	return newGetMoreButton
end

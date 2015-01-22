require "zoo.panel.component.startGamePanel.StartGameButton"

BeginRecallGameButton = class(StartGameButton)

function BeginRecallGameButton:init(ui)
	self.ui = ui
	self.background = self.ui:getChildByName("btnWithoutShadow"):getChildByName("bg")
	StartGameButton.init(self, ui)
end


function BeginRecallGameButton:createAnimation()
	local startButton = self.ui 

	local btnWithoutShadow = self.background
	local function __onButtonTouchBegin( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(200)
		end
	end
	local function __onButtonTouchEnd( evt )
		if btnWithoutShadow and not btnWithoutShadow.isDisposed then
			btnWithoutShadow:setOpacity(255)
		end
	end
	startButton:addEventListener(DisplayEvents.kTouchBegin, __onButtonTouchBegin)
	startButton:addEventListener(DisplayEvents.kTouchEnd, __onButtonTouchEnd)
end

function BeginRecallGameButton:setColorMode( colorMode, force )
	if self.colorMode ~= colorMode or force then
		self.colorMode = colorMode
		local background = self.background
		if background and background.refCocosObj then
			if colorMode == kGroupButtonColorMode.green then background:clearAdjustColorShader()
			elseif colorMode == kGroupButtonColorMode.orange then
				--background:setHsv(301.42, 1.2336, 1.4941)
				background:adjustColor(kColorOrangeConfig[1],kColorOrangeConfig[2],kColorOrangeConfig[3],kColorOrangeConfig[4])
				background:applyAdjustColorShader()
			elseif colorMode == kGroupButtonColorMode.blue then
				--background:setHsv(103.968, 0.97315, 1.23361)
				background:adjustColor(kColorBlueConfig[1],kColorBlueConfig[2],kColorBlueConfig[3],kColorBlueConfig[4])
				background:applyAdjustColorShader()
			elseif colorMode == kGroupButtonColorMode.grey then
				background:adjustColor(kColorGreyConfig[1],kColorGreyConfig[2],kColorGreyConfig[3],kColorGreyConfig[4])
				background:applyAdjustColorShader()
			end
		end
	end
end

function BeginRecallGameButton:showScaleAnimation()
	local animations = CCArray:create()
	animations:addObject(CCEaseSineOut:create(CCScaleBy:create(0.2, 1.1)))
	animations:addObject(CCEaseSineOut:create(CCScaleBy:create(0.4, 0.9)))
	animations:addObject(CCEaseSineOut:create(CCScaleBy:create(0.2, 1.1)))
	animations:addObject(CCEaseSineOut:create(CCScaleBy:create(0.4, 0.9)))
	animations:addObject(CCEaseSineOut:create(CCScaleBy:create(0.2, 1.1)))
	animations:addObject(CCEaseSineOut:create(CCScaleBy:create(0.4, 0.9)))
	self.ui:runAction(CCSequence:create(animations))
end

function BeginRecallGameButton:create(ui)
	local beginButton = BeginRecallGameButton.new()
	beginButton:init(ui)
	return beginButton
end
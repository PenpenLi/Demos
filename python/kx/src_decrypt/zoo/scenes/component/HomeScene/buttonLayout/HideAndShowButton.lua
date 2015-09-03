
HideAndShowButton = class()

function HideAndShowButton:ctor()
	
end

function HideAndShowButton:init()

end

function HideAndShowButton:ad(eventName, listener, context)
	self:setEnable(true)
	self.ui:addEventListener(eventName, listener, context)
end

function HideAndShowButton:setPosition(pos)
	self.ui:setPosition(pos)	
end

function HideAndShowButton:getGroupBounds()
	return self.ui:getGroupBounds()
end

function HideAndShowButton:setEnable(isEnable)
	if not isEnable then isEnable = false end 
	self.ui:setTouchEnabled(isEnable, 0, true)
	self.ui:setButtonMode(isEnable)
end

function HideAndShowButton:setVisible(isVisible)
	if not isVisible then isVisible = false end
	self.ui:setVisible(isVisible)	
end

function HideAndShowButton:getPositionInWorldSpace()
	return self.ui:getPositionInWorldSpace()
end

function HideAndShowButton:playAni(endCallback)
	local seqArr = CCArray:create()
	seqArr:addObject(CCScaleTo:create(2/24, 0.5, 2))
	seqArr:addObject(CCScaleTo:create(2/24, 1))
	seqArr:addObject(CCScaleTo:create(1/24, 0.8))
	seqArr:addObject(CCScaleTo:create(1/24, 1.1))
	seqArr:addObject(CCScaleTo:create(2/24, 1))
	seqArr:addObject(CCDelayTime:create(2/24))
	seqArr:addObject(CCCallFunc:create(function ()
		if endCallback then 
			endCallback()
		end
	end))
	self.ui:runAction(CCSequence:create(seqArr))
end

-- function HideAndShowButton:playHighlightAnim()
-- 	local buttonWaitDuration = 0.3
-- 	local buttonEnterDuration = 0.5
-- 	local smallScale = 1
-- 	local scale = 1.5
-- 	local receiveAnimeDuration = 0.2
-- 	if not self.bagBtnIcon then 
-- 		self.bagBtn = ResourceManager:sharedInstance():buildGroup('bagButtonIcon')
-- 		self.ui:addChild(self.bagBtn)

-- 		local wrapper = self.bagBtn:getChildByName('wrapper')
-- 		self.bagBtnIcon = wrapper:getChildByName('icon')
-- 		self.bagBtnIcon:setAnchorPoint(ccp(0.5, 0.5))
-- 		local pos = self.bagBtnIcon:getPosition()
-- 		local size = self.bagBtnIcon:getContentSize()
-- 		self.bagBtnIcon:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
-- 		self.bagBtnIcon:setScale(smallScale)
-- 		self.bagBtnIcon:setOpacity(0)
-- 	end

-- 	local waitDelay = CCDelayTime:create(buttonWaitDuration)

-- 	local fadeIn = CCFadeIn:create(buttonEnterDuration)
-- 	local scaleIn = CCScaleTo:create(buttonEnterDuration, scale)
-- 	local a_enter = CCArray:create()
-- 	a_enter:addObject(fadeIn)
-- 	a_enter:addObject(scaleIn)
-- 	local inAnimations = CCEaseExponentialInOut:create(CCSpawn:create(a_enter))

-- 	local function playSoundEffect()
-- 		GamePlayMusicPlayer:playEffect(GameMusicType.kGetRewardProp)	
-- 	end

-- 	-- receive item animation
-- 	local scaleFat = CCEaseSineIn:create(CCScaleTo:create(receiveAnimeDuration*0.3, scale*1.25, scale*0.8))
-- 	local playSound = CCCallFunc:create(playSoundEffect)
-- 	local scaleNormal = CCEaseSineOut:create(CCScaleTo:create(receiveAnimeDuration*0.7, scale, scale))
-- 	local a_receive = CCArray:create()
-- 	a_receive:addObject(scaleFat)
-- 	a_receive:addObject(playSound)
-- 	a_receive:addObject(scaleNormal)
-- 	local rep = CCRepeat:create(CCSequence:create(a_receive), numOfTimes)

-- 	-- exit animation
-- 	local fadeOut = CCFadeOut:create(buttonEnterDuration)
-- 	local scaleOut = CCScaleTo:create(buttonEnterDuration, smallScale)
-- 	local a_exit = CCArray:create()
-- 	a_exit:addObject(fadeOut)
-- 	a_exit:addObject(scaleOut)

-- 	local outAnimations = CCEaseExponentialInOut:create(CCSpawn:create(a_exit))

-- 	local a_buttonAnim = CCArray:create()
-- 	a_buttonAnim:addObject(waitDelay)
-- 	a_buttonAnim:addObject(inAnimations)
-- 	a_buttonAnim:addObject(rep)
-- 	a_buttonAnim:addObject(outAnimations)

-- 	local function removeButton()
-- 		if self.bagBtn then 
-- 			self.bagBtn:removeFromParentAndCleanup(true)
-- 			self.bagBtn = nil
-- 			self.bagBtnIcon = nil
-- 		end
-- 	end
-- 	a_buttonAnim:addObject(CCCallFunc:create(removeButton))

-- 	self.bagBtnIcon:stopAllActions()
-- 	self.bagBtnIcon:runAction(CCSequence:create(a_buttonAnim))
-- end

function HideAndShowButton:getFlyToPosition()
	return self:getPositionInWorldSpace()
end

function HideAndShowButton:getFlyToSize()
	local size = self.ui:getGroupBounds().size
	size.width, size.height = size.width / 2, size.height / 2
	return size
end

function HideAndShowButton:create(ui)
	local btn = HideAndShowButton.new()
	btn.ui = ui
	btn:init()
	return btn
end
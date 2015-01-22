require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

UpdateButton = class(IconButtonBase)


function UpdateButton:create()
	local button = UpdateButton.new()
	button:init()
	return button
end

function UpdateButton:init()

    if _G.useTraditionalChineseRes then 
    	self.ui = ResourceManager:sharedInstance():buildGroup("updateButtonIcon_ZH_TW") 
    else
    	self.ui = ResourceManager:sharedInstance():buildGroup('updateButtonIcon')
    end
    IconButtonBase.init(self, self.ui)

    self.ui:setTouchEnabled(true)
    self.ui:setButtonMode(true)

    self.up = self.ui:getChildByName('up')
    self.up:setAnchorPoint(ccp(0.5,0))

    self.up:runAction(self:buildAnimation())
end

function UpdateButton:buildAnimation()
	local arr = CCArray:createWithCapacity(4)

	arr:addObject(CCScaleTo:create(5 / 24,1.1,0.88))
	arr:addObject(CCSpawn:createWithTwoActions(
		CCMoveBy:create(5 / 24,ccp(0,4)),
		CCScaleTo:create(5 / 24,1.0,1.0)
	))
	arr:addObject(CCMoveBy:create(15 / 24,ccp(0,8)))
	arr:addObject(CCMoveBy:create(15 / 24,ccp(0,-12)))

	return CCRepeatForever:create(CCSequence:create(arr))
end

require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

UpdateButton = class(IconButtonBase)


function UpdateButton:create()
	local button = UpdateButton.new()
	button:init()
	return button
end

function UpdateButton:init()

    self.ui = ResourceManager:sharedInstance():buildGroup('updateButtonIcon')
    IconButtonBase.init(self, self.ui)

    self.up = self.ui:getChildByName("up")
    self.up.posX = self.up:getPositionX()
    self.up.posY = self.up:getPositionY()

    self.reward = self.ui:getChildByName("rewardIcon")

    local rewards = nil
    if UserManager:getInstance().updateInfo then
    	rewards = UserManager:getInstance().updateInfo.rewards
    end

    self.reward:setVisible(type(rewards) == "table" and #rewards > 0)
    self:startUpAnimation()

    self.text = self.ui:getChildByName("text")
    self.text:setAnchorPoint(ccp(0.5,1))
    self.text:setPositionX(self.wrapper:getGroupBounds():getMidX())
    self:setText()
end

function UpdateButton:setText(status, percentage)
	if status == "ready" then
		self.text:setText(Localization:getInstance():getText("new.version.button.ready"))
		self:stopUpAnimation()

	elseif status == "ing" then
		self.text:setText(Localization:getInstance():getText("new.version.button.processing", {percent = tostring(percentage)}))
	else
		--立即更新
		self.text:setText(Localization:getInstance():getText("new.version.icon"))
	end
end

function UpdateButton:startUpAnimation()
	local arr = CCArray:createWithCapacity(2)

	arr:addObject(CCMoveBy:create(10 / 24,ccp(0,9)))
	arr:addObject(CCMoveBy:create(10 / 24,ccp(0,-9)))

	self.up:setPositionXY(self.up.posX,self.up.posY)
	self.up:runAction(CCRepeatForever:create(CCSequence:create(arr)))
end

function UpdateButton:stopUpAnimation()
	self.up:stopAllActions()
	self.up:setPositionXY(self.up.posX,self.up.posY)
end

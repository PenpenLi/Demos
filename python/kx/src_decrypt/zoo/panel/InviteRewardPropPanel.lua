require "zoo.panel.basePanel.BasePanel"

InviteRewardPropPanel = class(BasePanel)

function InviteRewardPropPanel:getReward()
	local function onSuccess(evt)
		if type(evt.data) ~= "table" or type(evt.data.rewardItems) ~= "table" then return end
		local itemId, num = evt.data.rewardItems[1].itemId, evt.data.rewardItems[1].num
		if itemId == 2 then
			local user = UserManager:getInstance():getUserRef()
			user:setCoin(user:getCoin() + num)
		elseif itemId == 14 then
			local user = UserManager:getInstance():getUserRef()
			user:setCash(user:getCash() + num)
		else UserManager:getInstance():addUserPropNumber(itemId, num) end
		UserManager:getInstance():setUserRewardBit(3, true)
		if NetworkConfig.writeLocalDataStorage then Localhost:getInstance():flushCurrentUserData()
		else print("Did not write user data to the device.") end
		panel = InviteRewardPropPanel:create(itemId, num)
		panel:popout()
	end
	local http = GetRewardsHttp.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:load(3)
end

function InviteRewardPropPanel:create(propId, num)
	if type(propId) ~= "number" or type(num) ~= "number" then return end
	local panel = InviteRewardPropPanel.new()
	panel:_init(propId, num)
	return panel
end

function InviteRewardPropPanel:_init(propId, num)
	self:loadRequiredResource(PanelConfigFiles.invite_friend_reward_panel)
	local ui = self.builder:buildGroup("InviteRewardPropPanel")
	self:init(ui)
	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()

	local text = ui:getChildByName("text")
	local button = ui:getChildByName("button")
	local propBg = ui:getChildByName("propBg")
	local propNum = ui:getChildByName("propNum")
	local propPh = ui:getChildByName("propPh")
	button = GroupButtonBase:create(button)

	text:setString(Localization:getInstance():getText("恭喜您首次成功邀请好友，获得20风车币奖励！")) -- TODO: localization
	button:setString(Localization:getInstance():getText("确认")) -- TODO: localization
	propPh:setVisible(false)
	local sprite
	if propId == 2 then
		sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
		sprite:setScale(0.6)
	elseif propId == 14 then
		sprite = Sprite:createWithSpriteFrameName("wheel0000")
		sprite:setAnchorPoint(ccp(0, 1))
		sprite:setScale(1.5)
	else
		sprite = ResourceManager:sharedInstance():buildItemGroup(propId)
	end
	if type(sprite) ~= "nil" then
		sprite:setPositionXY(propPh:getPositionX(), propPh:getPositionY())
		local index = ui:getChildIndex(propPh)
		ui:addChildAt(sprite, index)
	end

	local charWidth = 40
	local charHeight = 40
	local charInterval = 20
	local fntFile = "fnt/target_amount.fnt"
	local position = propNum:getPosition()
	local newLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	newLabel:setAnchorPoint(ccp(0,1))
	newLabel:setString("x"..tostring(num))
	local size = newLabel:getContentSize()
	local rcSize = propBg:getGroupBounds().size
	newLabel:setPositionX(propBg:getPositionX() + rcSize.width - size.width + 10)
	newLabel:setPositionY(propNum:getPositionY())
	ui:addChild(newLabel)
	propNum:removeFromParentAndCleanup(true)

	local function onButton()
		local scene = HomeScene:sharedInstance()
		if not scene then return end
		scene:checkDataChange()
		if propId == 2 then
			local config = {updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
			local position = sprite:getPosition()
			local wPosition = sprite:getParent():convertToWorldSpace(ccp(position.x, position.y))
			anim.sprites:setPosition(ccp(wPosition.x + 59, wPosition.y - 77))
			anim.sprites:setScale(0.6 * self:getScale())
			scene:addChild(anim.sprites)
			anim:play()
		elseif propId == 14 then
			if num > 10 then num = 10 end
			local config = {number = num, updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
			local position = sprite:getPosition()
			local size = sprite:getGroupBounds().size
			local wPosition = sprite:getParent():convertToWorldSpace(ccp(position.x + size.width / 4, position.y - size.height / 4))
			local size = sprite:getGroupBounds().size
			for k, v2 in ipairs(anim.sprites) do
				v2:setPosition(ccp(wPosition.x - size.width / 3 + 10, wPosition.y + size.height / 3 - 10))
				v2:setScaleX(sprite:getScaleX() * self:getScale())
				v2:setScaleY(sprite:getScaleY() * self:getScale())
				scene:addChild(v2)
			end
			anim:play()
		else
			if num > 10 then num = 10 end
			local config = {propId = propId, number = num, updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
			local position = sprite:getPosition()
			local size = sprite:getGroupBounds().size
			local wPosition = sprite:getParent():convertToWorldSpace(ccp(position.x + size.width / 8, position.y - size.height / 8))
			for k, v2 in ipairs(anim.sprites) do
				v2:setPosition(ccp(wPosition.x - 10, wPosition.y + 10))
				v2:setScaleX(sprite:getScaleX() * self:getScale())
				v2:setScaleY(sprite:getScaleY() * self:getScale())
				scene:addChild(v2)
			end
			anim:play()
		end
		PopoutManager:sharedInstance():remove(self)
	end
	button:addEventListener(DisplayEvents.kTouchTap, onButton)
end

function InviteRewardPropPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
end
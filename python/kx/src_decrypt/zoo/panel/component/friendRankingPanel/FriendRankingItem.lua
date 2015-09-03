
FriendRankingItem = class(VerticalTileItem)

function FriendRankingItem:create()
	local instance = FriendRankingItem.new()
	instance:loadRequiredResource(PanelConfigFiles.friend_ranking_panel)
	instance:init()
	return instance

end


function FriendRankingItem:ctor()
	self.name = 'FriendRankingItem'
	self.debugTag = 0
end

function FriendRankingItem:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end


function FriendRankingItem:init()
	local ui = self.builder:buildGroup('friendRankingPanelItem')--ResourceManager:sharedInstance():buildGroup('friendRankingPanelItem')

	VerticalTileItem.init(self,ui)

	self.golden = ui:getChildByName('goldenCrown')
	self.silver  = ui:getChildByName('silverCrown')
	self.bronze = ui:getChildByName('bronzeCrown')
	self.normal = ui:getChildByName('normal')

	self.greySend = ui:getChildByName('greySendBtn')
	self.greySend:setOpacity(150)
	self.normalSend = ui:getChildByName('normalSendBtn')

	self.star = ui:getChildByName('star')
	-- self.starLabel = ui:getChildByName('starLabel')
	self.starLabel = TextField:createWithUIAdjustment(ui:getChildByName('starLabelSize'), ui:getChildByName('starLabel'))
	ui:addChild(self.starLabel)
	self.nameLabel = ui:getChildByName('usernameLabel')
	self.levelLabel = ui:getChildByName('levelLabel')
	-- self.rankLabel = ui:getChildByName('rankLabel')
	self.rankLabel = TextField:createWithUIAdjustment(ui:getChildByName('rankLabelSize'), ui:getChildByName('rankLabel'))
	ui:addChild(self.rankLabel)

	self.avatar = ui:getChildByName('avatar')

	self.selectedIcon = ui:getChildByName('selectedIcon')
	self.selectBtn = ui:getChildByName('selectBtn')
	self.bgNormal = ui:getChildByName('bgNormal')
	self.bgSelected = ui:getChildByName('bgSelected')
	self.bgMyself = ui:getChildByName('bgMyself')

	self.normalSend:ad(DisplayEvents.kTouchTap, function(event) self:onSendBtnTap(event) end)
	-- self.selectedIcon:ad(DisplayEvents.kTouchTap, function(event) self:onSelectedIconTap(event) end)
	self.selectBtn:ad(DisplayEvents.kTouchTap, function(event) self:onSelectBtnTap(event) end)

	self:setContent(ui)
end

function FriendRankingItem:setData(data)
	self.user = data
	self.isSnsFriend = FriendManager.getInstance():isSnsFriend(data.uid)

	local username = HeDisplayUtil:urlDecode(data.name or '')

	if not username or username == "" then 
		username = 'ID: '..data.uid
	end

	local headUrl = data.headUrl
	-- fix: if is myself, look for headUrl elsewhere
	if tonumber(data.uid) == tonumber(UserManager:getInstance().user.uid) then
		headUrl = UserManager:getInstance().profile.headUrl
	end
	-- end fix
	if not headUrl or headUrl == '' then

		headUrl = 1
	end

	local level = data:getTopLevelId()
	if not level or level == '' then 
		level = 1
	end

	local star = data:getTotalStar()
	if not star then
		star = 0
	end

	self.nameLabel:setString(username)
	self.starLabel:setString(star)
	self.levelLabel:setString(Localization:getInstance():getText('level.number.label.txt', {level_number = level}))

	local function onImageLoadFinishCallback(head)
		if self.isDisposed then return end ---  prevent from crashes
		local position = self.avatar:getPosition()
		head:setAnchorPoint(ccp(-0.5, 0.5))
		head:setPosition(ccp(position.x, position.y))

		-- calc scale
		local tarWidth = self.avatar:getGroupBounds().size.width
		local realWidth = head:getGroupBounds().size.width
		local scale = tarWidth / realWidth * 1.52
		head:setScale(scale)

		self.avatar:getParent():addChild(head)
		-- self.avatar:setVisible(false)
		self.avatar:removeFromParentAndCleanup(true)
		self.avatar = head
	end
	HeadImageLoader:create(tonumber(self.uid), headUrl, onImageLoadFinishCallback)

	self:exitSelectingMode()
end

function FriendRankingItem:setRank(rank)
	if self.isDisposed then return end
	assert(type(rank) == 'number')
	assert(rank > 0)


	self.golden:setVisible(rank == 1)
	self.silver:setVisible(rank == 2)
	self.bronze:setVisible(rank == 3)
	self.normal:setVisible(rank > 3)

	self.rankLabel:setString(rank)
end

function FriendRankingItem:setIsMyself()
	self.nameLabel:setString('我')
	self.bgSelected:setVisible(false)
	self.bgNormal:setVisible(false)
	self.bgMyself:setVisible(true)
	self.enterSelectingMode = function()
		print('FriendRankingItem:setIsMyself enterSelectingMode') 
		-- self.star:setVisible(false)
		-- self.starLabel:setVisible(false)
		self.star:setVisible(true)
		self.starLabel:setVisible(true)
		self:showSendButton(false)
		self.star:setPositionX(self.star:getPositionX() - 75)
		self.starLabel:setPositionX(self.starLabel:getPositionX() - 75)
	end
	self.exitSelectingMode = function() 
		print('FriendRankingItem:setIsMyself exitSelectingMode')
		self.star:setVisible(true)		
		self.starLabel:setVisible(true)		
		self:showSendButton(false)
		self.star:setPositionX(self.star:getPositionX() + 75)
		self.starLabel:setPositionX(self.starLabel:getPositionX() + 75)
	end
	self.setSelected = function () end

	self.selectedIcon:setVisible(false)
	self.selectBtn:setVisible(false)
	self.selectBtn:setTouchEnabled(false)
	self.normalSend:setVisible(false)
	self.greySend:setVisible(false)

end

function FriendRankingItem:setSelected(selected)
	if self.isDisposed then return end
	self.selected = selected
	self.selectedIcon:setVisible(selected)
	self.bgSelected:setVisible(selected)
	self.bgNormal:setVisible(not selected)
end

function FriendRankingItem:setSelectEnable( isEnable )
	local disableBox = self.selectBtn:getChildByName("disableBox")
	local enableBox = self.selectBtn:getChildByName("enableBox")
	if isEnable then
		disableBox:setVisible(false)
		enableBox:setVisible(true)
	else
		disableBox:setVisible(true)
		enableBox:setVisible(false)
	end
end

function FriendRankingItem:enterSelectingMode()
	if self.isDisposed then return end
	-- print 'enterSelectingMode'
	-- self.star:setVisible(false)
	-- self.starLabel:setVisible(false)

	if self.isSnsFriend then
		self:setSelectEnable(false)
	else
		self:setSelectEnable(true)
	end

	self.star:setVisible(true)
	self.starLabel:setVisible(true)
	self:showSendButton(false)
	self.selectBtn:setVisible(true)
	self.selectBtn:setButtonMode(true)
	self.selectBtn:setTouchEnabled(true, 5, true)
	self:setSelected(false)
	self.star:setPositionX(self.star:getPositionX() - 75)
	self.starLabel:setPositionX(self.starLabel:getPositionX() - 75)
end

function FriendRankingItem:exitSelectingMode()
	if self.isDisposed then return end
	-- print('exitSelectingMode')
	self.star:setVisible(true)
	self.starLabel:setVisible(true)
	self:showSendButton(true)
	self:setSelected(false)
	self.selectBtn:setVisible(false)
	self.selectBtn:setButtonMode(false)
	self.selectBtn:setTouchEnabled(false)
	self.star:setPositionX(self.star:getPositionX() + 75)
	self.starLabel:setPositionX(self.starLabel:getPositionX() + 75)
	
end

function FriendRankingItem:showSendButton(doShow)
	if self.isDisposed then return end

-- temp hack: for hiding the send buttons forever
	doShow = false
	if doShow then
		if self:canSend() then
			self.greySend:setVisible(false)
			self.normalSend:setVisible(true)
			self.normalSend:setTouchEnabled(true, 5, true)
			self.normalSend:setButtonMode(true)
		else
			self.greySend:setVisible(true)
			self.normalSend:setVisible(false)
			self.normalSend:setTouchEnabled(false)
			self.normalSend:setButtonMode(false)
		end
	else
		self.greySend:setVisible(false)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false, 5, false)
	end

end

function FriendRankingItem:canSend()
	if self.user then 
		return FreegiftManager:sharedInstance():canSendTo(tonumber(self.user.uid))
	else 
		return false
	end
end

function FriendRankingItem:getUser()
	return self.user
end

function FriendRankingItem:enableSend()
	if self.isBusy then return end
	if not self.isDisposed then
		self:stopLoading()
		self.greySend:setVisible(false)
		self.normalSend:setVisible(true)
		self.normalSend:setTouchEnabled(true, 5, true)
		self.normalSend:setButtonMode(true)
	end
end

function FriendRankingItem:hideSend()
	if not self.isDisposed then
		self.greySend:setVisible(false)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false)
		self.normalSend:setButtonMode(false)
	end
end

function FriendRankingItem:disableSend()
	if self.isBusy then return end
	if not self.isDisposed then
		self:stopLoading()
		self.greySend:setVisible(true)
		self.normalSend:setVisible(false)
		self.normalSend:setTouchEnabled(false)
		self.normalSend:setButtonMode(false)
	end
end

function FriendRankingItem:onSendBtnTap(event)
	if self.isBusy then return end
	self.isBusy = true
	self:hideSend()
	self:playLoading()

	local function success(data)
		print 'success'
		self.isBusy = false
		if not self.isDisposed then
			self:disableSend()
		end
		if self.synchronizer then
			self.synchronizer:onSendSucceeded(self)
		end
	end

	local function fail(err)
		print ' fail'
		self.isBusy = false
		if self.isDisposed then
			self:enableSend()
		end
		if self.synchronizer then
			self.synchronizer:onSendFailed(self)
		end
		local err_code = tonumber(err.data)
		if err_code then
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..err.data))
		end
	end
	

	FreegiftManager:sharedInstance():sendGiftTo(tonumber(self.user.uid), success, fail)

	if self.synchronizer then
		self.synchronizer:onSendDispatched(self)
	end
end

function FriendRankingItem:onSelectedIconTap(event)
	self:setSelected(false)
end

function FriendRankingItem:onSelectBtnTap(event)
	if not self.selected then 
		if self.isSnsFriend then
			local platform = ""
			if _G.sns_token and _G.sns_token.authorType then
				platform = PlatformConfig:getPlatformNameLocalization(_G.sns_token.authorType)
			end
			CommonTip:showTip(Localization:getInstance():getText("add.friend.panel.delete.platform.friend", {platform = platform}))
		else
			self.selected  = true
			self:setSelected(true)
		end
	else 
		self.selected = false
		self:setSelected(false)
	end
end

function FriendRankingItem:dispose()
	if self.synchronizer then 
		self.synchronizer:unregister(self) 
		self.synchronizer = nil
	end
	CocosObject.dispose(self)
	-- print ('FriendRankingItem:dispose', self:getArrayIndex())
end

function FriendRankingItem:playLoading()
	if self.isDisposed then return end
print 'playLoading'
	local container = Sprite:createEmpty()
	local back = Sprite:createWithSpriteFrameName("loading_ico_circle instance 10000")	
	local icon = Sprite:createWithSpriteFrameName("loading_ico_turn instance 10000")
	container:setCascadeOpacityEnabled(true)
	back:setCascadeOpacityEnabled(true)
	icon:setCascadeOpacityEnabled(true)

	container:setOpacity(0)
	container:addChild(back)
	container:addChild(icon)
	container.icon = icon
	container:setVisible(true)
	container:runAction(CCFadeIn:create(0.2))
	icon:runAction(CCRepeatForever:create(CCRotateBy:create(0.5, 180)))
	local pos = self.selectBtn:getPosition()
	container:setPosition(ccp(pos.x + 30, pos.y - 18))
	self.selectBtn:getParent():addChild(container)
	self.loadingAnim = container

end

function FriendRankingItem:stopLoading()
	if self.isDisposed then return end
-- print 'stopLoading'
	if self.loadingAnim and not self.loadingAnim.isDisposed then
		self.loadingAnim:stopAllActions()
		self.loadingAnim.icon:stopAllActions()
		self.loadingAnim:removeFromParentAndCleanup(true)
		self.loadingAnim = nil
	end
end

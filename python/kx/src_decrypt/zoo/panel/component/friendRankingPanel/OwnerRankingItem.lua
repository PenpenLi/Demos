OwnerRankingItem = class(FriendRankingItem)

function OwnerRankingItem:create()
	local instance = OwnerRankingItem.new()
	instance:loadRequiredResource(PanelConfigFiles.friend_ranking_panel)
	instance:init()
	return instance
end

function OwnerRankingItem:ctor()
	self.name = "OwnerRankingItem"
	self.itemExtendHeight = 610
	self.manager = PersonalCenterManager
end

function OwnerRankingItem:unloadRequiredResource()
end

function OwnerRankingItem:init()
	FriendRankingItem.init(self)
	self:initContent()
end

function OwnerRankingItem:initContent()
	self:setIsMyself()
	-- UserManager:getInstance().user.name = "tao.zeng"
    --打点用

	self.itemContent = self.builder:buildGroup('owner_item_content')
	self.ui:addChildAt(self.itemContent, 1)
	self:setHeight(119)
	
	self.itemContentIndex = self.ui:getChildIndex(self.itemContent)
	self.itemContent:removeFromParentAndCleanup(false)
	self.itemContent:setPositionY(self.ui:getChildByName('bgNormal'):getPositionY() - 95)

	-- InterfaceBuilder:createWithContentsOfFile("ui/add_friend_panel.json")

	local btnSendCard = ButtonIconsetBase:create(self.itemContent:getChildByName('btnSendCard'))
	self.btnSendCard = btnSendCard
	btnSendCard:setString(localize('my.card.btn2'))
	btnSendCard:setColorMode(kGroupButtonColorMode.blue)
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		btnSendCard:setIconByFrameName("nnn_mitalk0000", true)
	else
		btnSendCard:setIconByFrameName("nnn_wechat0000", true)
	end
	btnSendCard:ad(DisplayEvents.kTouchTap, function() 
			self:sendCard()
		end)
	if PlatformConfig:isPlatform(PlatformNameEnum.kJJ) then
		self.btnSendCard:setVisible(false)
	end

	self.sendCardVisible = self.btnSendCard:isVisible()

--	这是 消消乐号
	local idLabel =  self.itemContent:getChildByName("txt_game_id")
	local indexOfId = self.itemContent:getChildIndex(idLabel)
	idLabel:setText(UserManager.getInstance().inviteCode)

--  这是 ‘我的消消乐号：’ 这行字
	local idTextLabel =  self.itemContent:getChildByName("lbl_game_id")
	local indexOfIdText = self.itemContent:getChildIndex(idTextLabel)
	idTextLabel:setVisible(false)

    local bmIdTextLabel = LabelBMMonospaceFont:create(36, 36, 25, "fnt/nametag.fnt")
    bmIdTextLabel:setAnchorPoint(ccp(0, 1))
    bmIdTextLabel:setString(localize("my.card.panel.text2").."：")
    bmIdTextLabel:setPositionXY(idTextLabel:getPositionX(), idLabel:getPositionY())
    self.itemContent:addChildAt(bmIdTextLabel, indexOfIdText)

    idLabel:setAnchorPointWhileStayOriginalPosition(ccp(0, 0.5))
    idLabel:setScale(1.2)


	self.resizeQRCode = self:addQRCode()
	self:addUserHead()
end

function OwnerRankingItem:setData(data)
	self.user = data
	self.profile = UserManager:getInstance().profile

	self:refreshUserInfo(data)
	self:refreshProfile(self.profile)

	self:initRanking()
	self:initAchievementIcon()
end

function OwnerRankingItem:addUserHead()
	local head_rect = self.itemContent:getChildByName("user_head")
	local user = UserManager.getInstance().profile
	
	function onLoaded(userHead)
		local position = head_rect:getPosition()
		local head_size = head_rect:getGroupBounds().size
		local img_size = userHead:getGroupBounds().size
		userHead:setScaleX(head_size.width/img_size.width)
		userHead:setScaleY(head_size.height/img_size.height)
		userHead:setPosition(ccp(position.x + head_size.width/2, position.y - head_size.height/2))
		self.itemContent:addChild(userHead)
		self.headImage = userHead
		head_rect:removeFromParentAndCleanup(true)
		head_rect:dispose()
		self:adjustHeadImage()

	end
	HeadImageLoader:create(user.uid, user.headUrl, onLoaded)
end

function OwnerRankingItem:addQRCode()
	local code = self.itemContent:getChildByName("qr_code")
	code:setVisible(false)
	local size = code:getGroupBounds().size
	local sprite = CocosObject.new(QRManager:generatorQRNode(QRCodePostPanel:getQRCodeURL(), size.width, 1, ccc4(74, 175, 23, 255)))
	self.qrCode = sprite
	local sSize = sprite:getContentSize()
	local layer = Layer:create()
	self.layer = layer
	sprite:setScaleX(size.width / sSize.width)
	sprite:setScaleY(-size.height / sSize.height) -- original and correct scaleY of image is smaller than zero.
	sprite:setPositionXY(-sSize.width / 2 * sprite:getScaleX(), -sSize.height / 4 * sprite:getScaleY())
	layer:setPositionX(code:getPositionX() + size.width / 2)
	layer:setPositionY(code:getPositionY() - size.height / 2 + sSize.height / 4)
	layer:addChild(sprite)
	layer.extended = false
	local touchLayer = nil
	local originX, originY = layer:getPositionX(), layer:getPositionY()
	local destX, destY = layer:getPositionX(), layer:getPositionY() -10
	local originScale, destScale = 1, 1.8
	local function resizeQRCode(event, isExtend)
		if isExtend == nil then
			layer.extended = not layer.extended
		else
			layer.extended = isExtend
		end
		if layer.extended then
			layer:setScale(destScale)
			layer:setPositionXY(destX, destY)
			if not touchLayer then
				touchLayer = Layer:create()
				local size = Director:sharedDirector():getWinSize()
				touchLayer:setContentSize(CCSizeMake(size.width / self:getScale(), size.height / self:getScale()))
				touchLayer:setAnchorPoint(ccp(0, 1))
				touchLayer:ignoreAnchorPointForPosition(false)
				touchLayer:setPositionXY(-self:getPositionX(), -self:getPositionY())
				touchLayer:setTouchEnabled(true, 1, true)
				touchLayer:addEventListener(DisplayEvents.kTouchTap, resizeQRCode)
				self.ui:addChild(touchLayer)
			end
			self.btnSendCard:setVisible(false)
		else
			layer:setScale(originScale)
			layer:setPositionXY(originX, originY)
			if touchLayer then
				touchLayer:removeFromParentAndCleanup(true)
				touchLayer = nil
			end
			self.btnSendCard:setVisible(self.sendCardVisible)
		end
	end
	layer:setTouchEnabled(true)
	layer:addEventListener(DisplayEvents.kTouchTap, resizeQRCode)
	self.itemContent:addChild(layer)
	return resizeQRCode
end

function OwnerRankingItem:adjustHeadImage()
	local code = self.itemContent:getChildByName("qr_code")
	local size = code:getGroupBounds().size
	self.headImage:removeFromParentAndCleanup(false)
	self.headImage:setPositionXY(
		self.qrCode:getPositionX() + size.width/2, 
		self.qrCode:getPositionY() - size.height/2
	)
	self.layer:addChild(self.headImage)
end

function OwnerRankingItem:sendCard()
    local function cb()
        self.btnSendCard:setEnabled(true)
    end
    setTimeOut(cb, 3)
    self.btnSendCard:setEnabled(false)
    PersonalCenterManager:sendBusinessCard(cb, cb, cb)
end

function OwnerRankingItem:setSelected(selected)
	if self.isDisposed then return end
end

function OwnerRankingItem:onItemTapped()
	if self.beforeToggleCallback then
		self.beforeToggleCallback(self)
	end

	if self.itemContent:getParent() then
		self.itemContent:removeFromParentAndCleanup(false)
		self:setHeight(119)
		self.friendRankingPanel:fold()
		self.resizeQRCode(nil, false)
	else
		self.ui:addChildAt(self.itemContent, self.itemContentIndex)
		self:setHeight(self.itemExtendHeight)
		self:adjustAskSendButton()

		if self.friendRankingPanel.expandItemIndex == nil or self.friendRankingPanel.expandItemIndex > self.index then
			if self:getPositionInWorldSpace().y < 700 then
				local offsetY = -self:getPositionY() - 119*3 - 50
				offsetY = math.max(0, offsetY)
				self.view:gotoPositionY(offsetY)
			end
		else
			if self:getPositionInWorldSpace().y < 700 then
				local offsetY = -self:getPositionY() - 119*3 - self.itemExtendHeight + 119 - 50
				offsetY = math.max(0, offsetY)
				self.view:gotoPositionY(offsetY)
			end
		end

		self.friendRankingPanel:expandItem(self.index)
	end

	if self.afterToggleCallback then
		self.afterToggleCallback()
	end

	if not self.itemContent:getParent() then --extended
		self:foldItem()
	else
		self:extendItem()
	end
end

function OwnerRankingItem:extendItem()
end

function OwnerRankingItem:foldItem()
	self.itemContent:removeFromParentAndCleanup(false)
	self.resizeQRCode(nil, false)
	self:setHeight(119)
end

function OwnerRankingItem:enterSelectingMode()
	if self.isDisposed then return end
	-- print('FriendRankingItem:setIsMyself enterSelectingMode') 
	-- self.star:setVisible(false)
	-- self.starLabel:setVisible(false)
	self.star:setVisible(true)
	self:showSendButton(false)
end

function OwnerRankingItem:exitSelectingMode()
	if self.isDisposed then return end
	-- print('FriendRankingItem:setIsMyself exitSelectingMode')
	self.star:setVisible(true)			
	self:showSendButton(false)
end

function OwnerRankingItem:setIsMyself()
	self.nameLabel:setString('我')
	self.bgSelected:setVisible(false)
	self.bgNormal:setVisible(false)
	self.bgMyself:setVisible(true)

	self.selectedIcon:setVisible(false)
	self.selectBtn:setVisible(false)
	self.selectBtn:setTouchEnabled(false)
	self.normalSend:setVisible(false)
	self.greySend:setVisible(false)
end

function OwnerRankingItem:initAchievementIcon()
	FriendRankingItem.initAchievementIcon(self)
	self.iconAchievement:setTouchEnabled(true, 0, true)
	self.iconAchievement:ad(DisplayEvents.kTouchTap, 
			function()
				local AchievementPanel = require 'zoo.PersonalCenter.AchievementPanel'
				panel = AchievementPanel:create(PersonalCenterManager)
				panel.parentPanel = self.parentPanel
				panel:popout()
				DcUtil:UserTrack({category='my_card', sub_category="my_card_click_achievement"}, true)
			end
		)
end
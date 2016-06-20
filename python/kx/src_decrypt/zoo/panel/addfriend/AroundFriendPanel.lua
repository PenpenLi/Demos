local AroundFriendPanel = class(BasePanel)

function AroundFriendPanel:create()
	local panel = AroundFriendPanel.new()
	panel:loadRequiredResource("ui/add_friend_panel.json")
	panel:init()

	return panel
end

function AroundFriendPanel:init()
	self.ui = self:buildInterfaceGroup("AroundFriendPanel")
    BasePanel.init(self, self.ui)

    self.addFriendPanelLogic = AddFriendPanelLogic:create()
    self.addFriendPanelLogic:startUpdateLocation()
    
    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(282, 64)
    self.title:setString(localize("add.friend.panel.tag.recommend"))

    self:initCloseButton()
    self:initContent()
end

function AroundFriendPanel:initContent()
	self:_tabRecommend_init(self.ui:getChildByName("content"))
end

------------------------------------------
-- TabRecommend
------------------------------------------
function AroundFriendPanel:_tabRecommend_init(ui)
	-- get & create controls
	self.tabRecommend = {}
	self.tabRecommend.ui = ui
	self.tabRecommend.load = ui:getChildByName("img_load")
	ui:getChildByName("_bg"):setVisible(false)
	local pos = self.tabRecommend.load:getPosition()
	local size = self.tabRecommend.load:getGroupBounds().size
	self.tabRecommend.load:setAnchorPoint(ccp(0.48, 0.52))
	self.tabRecommend.load:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
	self.tabRecommend.load:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
	self.tabRecommend.noUser = ui:getChildByName("lbl_noUser")
	self.tabRecommend.noUser:setString(Localization:getInstance():getText("add.friend.panel.recommend.no.user"))
	self.tabRecommend.noUser:setVisible(false)
	self.tabRecommend.refresh = ui:getChildByName("btn_refresh")
	self.tabRecommend.refresh:setVisible(false)
	self.tabRecommend.refresh.text = self.tabRecommend.refresh:getChildByName("lbl_text")
	local fullWidth = ui:getChildByName("_bg"):getGroupBounds().size.width / self:getScale()
	size = self.tabRecommend.refresh:getGroupBounds().size
	size = {width = size.width / self:getScale(), height = size.height / self:getScale()}
	self.tabRecommend.listBasePos = {x = (fullWidth - size.width * 2) / 3, y = self.tabRecommend.refresh:getPosition().y}
	self.tabRecommend.listIndexPos = {x = self.tabRecommend.listBasePos.x + size.width, y = size.height + 5}
	self.tabRecommend.listContent = {}

	-- set strings
	self.tabRecommend.refresh.text:setString(Localization:getInstance():getText("add.friend.panel.recommend.refresh"))

	-- add event listeners
	local function onRefreshTapped()
		if RequireNetworkAlert:popout() then
			self.tabRecommend.load:setVisible(true)
			for i = 1, #self.tabRecommend.listContent do
				self.tabRecommend.listContent[1]:removeFromParentAndCleanup(true)
				table.remove(self.tabRecommend.listContent, 1)
			end
			self.tabRecommend.refresh:setVisible(false)
			self.tabRecommend.noUser:setVisible(false)
			self:_tabRecommend_loadList()
		end
	end
	self.tabRecommend.refresh:setTouchEnabled(true)
	self.tabRecommend.refresh:addEventListener(DisplayEvents.kTouchTap, onRefreshTapped)

	self.tabRecommend.hide = function()
		self.tabRecommend.ui:setVisible(false)
		for i = 1, #self.tabRecommend.listContent do
			self.tabRecommend.listContent[1]:removeFromParentAndCleanup(true)
			table.remove(self.tabRecommend.listContent, 1)
		end
		self.tabRecommend.refresh:setVisible(false)
	end
	self.tabRecommend.expand = function()
		self:_tabRecommend_loadList()
		self.tabRecommend.ui:setVisible(true)
	end
end

function AroundFriendPanel:_tabRecommend_loadList()
	local function onSuccess(data, context)
		if self.isDisposed then return end
		if data.num == 0 then
			self.tabRecommend.noUser:setVisible(true)
		else self:_tabRecommend_showList(data.data, data.num) end
		self.tabRecommend.load:setVisible(false)

		--
		DcUtil:addFriendSearch(data.num)
	end
	local function onFail(err, context)
		if self.isDisposed  then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
		self.tabRecommend.load:setVisible(false)
		if __WP8 and err == 1016 then
			LocationManager:GetInstance():GotoSettingIfNecessary()
		end
	end
	self.tabRecommend.noUser:setVisible(false)
	self.tabRecommend.load:setVisible(true)
	self.addFriendPanelLogic:getRecommendFriend(onSuccess, onFail, self.tabStatus)
end

function AroundFriendPanel:_tabRecommend_showList(data, num)
	if self.isDisposed then return end
	local count = 1
	while data[count] do
		local elem = self:_tabRecommend_createFriend(data[count])
		elem:setPosition(ccp(self.tabRecommend.listBasePos.x, self.tabRecommend.listBasePos.y - self.tabRecommend.listIndexPos.y * (count - 1) / 2))
		self.tabRecommend.ui:addChild(elem)
		table.insert(self.tabRecommend.listContent, elem)
		if data[count + 1] then
			local elem = self:_tabRecommend_createFriend(data[count + 1])
			elem:setPosition(ccp(self.tabRecommend.listBasePos.x + self.tabRecommend.listIndexPos.x, self.tabRecommend.listBasePos.y - self.tabRecommend.listIndexPos.y * (count - 1) / 2))
			self.tabRecommend.ui:addChild(elem)
			table.insert(self.tabRecommend.listContent, elem)
		else
			count = count - 1
		end
		count = count + 2
	end
	if num > 10 then
		local posX = 0
		if count / 2 ~= math.floor(count / 2) then posX = self.tabRecommend.listBasePos.x
		else posX = self.tabRecommend.listBasePos.x + self.tabRecommend.listIndexPos.x end
		self.tabRecommend.refresh:setPosition(ccp(posX, self.tabRecommend.listBasePos.y - self.tabRecommend.listIndexPos.y * math.floor((count - 1) / 2)))
		self.tabRecommend.refresh:setVisible(true)
	else
		self:updateBGSize(num)
	end
end

local baseHeight = 235
local heightList = {baseHeight, baseHeight, baseHeight + 107, baseHeight + 107 *2, baseHeight + 107 *3}
function AroundFriendPanel:updateBGSize(profileCount)

	local rows = math.floor((profileCount+1)/2)
	local curHeight = heightList[rows]

	local bg1 = self.ui:getChildByName("bg1")
	local bg2 = self.ui:getChildByName("bg2")

	local size = bg1:getGroupBounds().size
	bg1:setPreferredSize(CCSizeMake(size.width, curHeight + 102))

	local size2 = bg2:getGroupBounds().size
	bg2:setPreferredSize(CCSizeMake(size2.width, curHeight))

	self:setPositionY(self:getPositionY() - (649 - (curHeight + 102))/2)
end

function AroundFriendPanel:_tabRecommend_addFriend(uid, target)
	local function onSuccess(data, context)
		local status = context.status
		DcUtil:addFiendNear()
		if self.isDisposed then return end
		local target = context.target
		if not target or target.isDisposed then return end
		target.imgLoad:setVisible(false)
		target.labelSent:setVisible(true)
		target.bgSent:setVisible(true)
		target.bgNormal:setVisible(false)
	end
	local function onFail(err, context)
		local status = context.status
		if self.isDisposed  then return end
		local target = context.target
		if target and not target.isDisposed then
			target:setTouchEnabled(true)
			target.iconAdd:setVisible(true)
			target.imgLoad:setVisible(false)
		end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
	end
	target:setTouchEnabled(false)
	self.addFriendPanelLogic:sendRecommendFriendMessage(uid, onSuccess, onFail, {target = target, status = self.tabStatus})
end

function AroundFriendPanel:_tabRecommend_createFriend(data)
	local elem = self:buildInterfaceGroup("AddFriendPanelRecommendItem")
	elem.bgNormal = elem:getChildByName("bg_normal")
	elem.bgSent = elem:getChildByName("bg_sent")
	elem.bgSent:setVisible(false)
	elem.labelSent = elem:getChildByName("lbl_sent")
	elem.labelSent:setString(Localization:getInstance():getText("add.friend.panel.message.sent"))
	elem.labelSent:setVisible(false)
	elem.iconAdd = elem:getChildByName("icn_add")
	elem.userLevel = elem:getChildByName("lbl_userLevel")
	elem.userName = elem:getChildByName("lbl_userName")
	elem.userHead = elem:getChildByName("img_userImg")
	elem.imgLoad = elem:getChildByName("img_load")
	local pos = elem.imgLoad:getPosition()
	local size = elem.imgLoad:getGroupBounds().size
	elem.imgLoad:setAnchorPoint(ccp(0.5, 0.5))
	elem.imgLoad:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
	elem.imgLoad:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
	elem.imgLoad:setVisible(false)

	local name = HeDisplayUtil:urlDecode(data.userName)
	if name and string.len(name) > 0 then elem.userName:setString(name)
	else elem.userName:setString(Localization:getInstance():getText("add.friend.panel.no.user.name"))end
	if data.userLevel then
		elem.userLevel:setString(Localization:getInstance():getText("add.friend.panel.user.info.level", {n = data.userLevel}))
	end
	local userHead = HeadImageLoader:create(data.uid, data.headUrl)
	if userHead then
		local position = elem.userHead:getPosition()
		userHead:setAnchorPoint(ccp(-0.5, 0.5))
		userHead:setScale(0.65)
		userHead:setPosition(ccp(position.x, position.y))
		elem.userHead:getParent():addChild(userHead)
		elem.userHead:removeFromParentAndCleanup(true)
	end

	elem:setTouchEnabled(true)
	local function onTouched()
		if RequireNetworkAlert:popout() then
			elem.imgLoad:setVisible(true)
			elem.iconAdd:setVisible(false)
			self:_tabRecommend_addFriend(data.uid, elem)
		end
	end
	elem:addEventListener(DisplayEvents.kTouchTap, onTouched)

	return elem
end

function AroundFriendPanel:initCloseButton()
	self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
        end)
end

function AroundFriendPanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function AroundFriendPanel:popout()
	self:setPositionForPopoutManager()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)

	self.tabRecommend:expand()
end

function AroundFriendPanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function AroundFriendPanel:onCloseBtnTapped()
	self.tabRecommend:hide()
	PopoutManager:sharedInstance():remove(self, true)
end

return AroundFriendPanel
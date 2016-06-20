

local ChoosePhoneUserPanel = class(BasePanel)

function ChoosePhoneUserPanel:create(profiles)
	local panel = ChoosePhoneUserPanel.new()
	panel:loadRequiredResource("ui/add_friend_panel.json")
	panel:init(profiles)

	return panel
end

function ChoosePhoneUserPanel:init(profiles)
	self.ui = self:buildInterfaceGroup("ChoosePhoneUserPanel")
    BasePanel.init(self, self.ui)

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(286, 64)
    self.title:setString(localize("add.friend.panel.add.phone"))

    self.profiles = profiles
    self:initCloseButton()
    self:initContent()
end

function ChoosePhoneUserPanel:initContent()
	self.listBg = self.ui:getChildByName("content")
	self.listSize = self.listBg:getGroupBounds().size
	self.listPos = ccp(self.listBg:getPositionX(), self.listBg:getPositionY())
	self.listHeight = self.listSize.height
	self.listWidth = self.listSize.width
	self.listBg:removeFromParentAndCleanup(false)

	self:buildGridLayout()
end

local function createChooseFriendList(onTileItemTouch, minWidth, minHeight, view, profiles)

	local container = GridLayout:create()
	container:setWidth(minWidth)
	container:setColumn(2)
	container:setItemSize(CCSizeMake(275, 95))
	container:setColumnMargin(25)
	container:setRowMargin(11.8)

	for _, v in ipairs(profiles) do
		local layoutItem = require("zoo.panel.addfriend.ChoosePhoneItem"):create(v, onTileItemTouch)
		layoutItem:setParentView(view)
		container:addItem(layoutItem, false)
	end

	return container
end

function ChoosePhoneUserPanel:buildGridLayout()

	local function onTileItemTouch(item)
		if item then
		end
	end

	self.numberOfFriends = #self.profiles
	if self.numberOfFriends > 10 then --need to be scrollable
		self.scrollable = VerticalScrollable:create(self.listWidth, self.listHeight, true, false)
		self.content = createChooseFriendList(onTileItemTouch, self.listWidth, self.listHeight, self.scrollable, self.profiles)

		self.scrollable:setContent(self.content)
		self.scrollable:setPositionXY(self.listPos.x, self.listPos.y)
		self.ui:addChild(self.scrollable)
	else
		self.content = createChooseFriendList(onTileItemTouch, self.listWidth, self.listHeight, self.ui, self.profiles)
		self.content:setPositionXY(self.listPos.x, self.listPos.y)
		self.ui:addChild(self.content)

		self:updateBGSize(self.numberOfFriends)
	end
end

function ChoosePhoneUserPanel:appendItems(items4Append)
	for _, v in ipairs(items4Append) do
		local layoutItem = require("zoo.panel.addfriend.ChoosePhoneItem"):create(v, nil)
		layoutItem:setParentView(self.scrollable)
		self.content:addItem(layoutItem, false)
	end

	if self.scrollable.content then
		self.scrollable:updateScrollableHeight()
	end
end

local baseHeight = 235
local heightList = {baseHeight, baseHeight, baseHeight + 107, baseHeight + 107 *2, baseHeight + 107 *3}
function ChoosePhoneUserPanel:updateBGSize(profileCount)

	local rows = math.floor((profileCount+1)/2)
	local curHeight = heightList[rows]

	local bg1 = self.ui:getChildByName("bg1")
	local bg2 = self.ui:getChildByName("bg2")

	local size = bg1:getGroupBounds().size
	bg1:setPreferredSize(CCSizeMake(size.width, curHeight + 102))

	local size2 = bg2:getGroupBounds().size
	bg2:setPreferredSize(CCSizeMake(size2.width, curHeight))
end

function ChoosePhoneUserPanel:initCloseButton()
	self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
        end)
end

function ChoosePhoneUserPanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

local loadFriendsLogic = require("zoo.panel.addfriend.LoadFriendsLogic"):create()

function ChoosePhoneUserPanel:loadRemaining()
	local remainingUids = loadFriendsLogic:getRemainingUids()
	local function onSuccess(items4Append)
		self.isLoadingRemaining = false
		if self.isDisposed or #remainingUids == 0  then
			return
		end

		self:appendItems(items4Append)
	end

	local function onCancel()
		self.isLoadingRemaining = false
	end

	local function onError()
		self.isLoadingRemaining = false
	end
	
	if not self.isDisposed and #remainingUids > 0 and not self.isLoadingRemaining then
		loadFriendsLogic:loadProfilesByUids(remainingUids, onSuccess)
		self.isLoadingRemaining = true
	end
end

function ChoosePhoneUserPanel:popout()
	self:setPositionForPopoutManager()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)

	if self.scrollable then
		self.scrollable:addEventListener(ScrollableEvents.kEndMoving, function()
				print("on scroll end!!!!!!!!!!!!!")
				self:loadRemaining()
			end)
	end
end

function ChoosePhoneUserPanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function ChoosePhoneUserPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

return ChoosePhoneUserPanel
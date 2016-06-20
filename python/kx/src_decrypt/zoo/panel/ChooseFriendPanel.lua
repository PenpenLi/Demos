require "hecore.ui.PopoutManager"
require "hecore.ui.ScrollView"

require "zoo.panel.basePanel.BasePanel"
require "zoo.net.Http"

-------------------------------------------------------------------------
--  Class include: ChooseFriendItem, ChooseFriendPanel
-------------------------------------------------------------------------

--
-- ChooseFriendItem ---------------------------------------------------------
--

local LIMIT = 16
ChooseFriendItem = class(CocosObject)
function ChooseFriendItem:create(inviteIconMode, onTileItemTouch, userId)
	local builder = InterfaceBuilder:create(PanelConfigFiles.AskForEnergyPanel)
	local ui = builder:buildGroup("img/invite_friend_avatar")
	local item = ChooseFriendItem.new(CCNode:create())
	local function onItemTouchInside( evt )
        if onTileItemTouch ~= nil then 
            if item.isSelected then
                item:select(not item.isSelected)
            else
                local ret = onTileItemTouch(item) 
                if ret then
                    item:select(not item.isSelected)
                end 
            end           
        end
    end
	item:buildUI(ui, inviteIconMode, userId)
	ui:setTouchEnabled(true)
	ui:ad(DisplayEvents.kTouchTap, onItemTouchInside)
	return item
end

function ChooseFriendItem:buildUI(ui, inviteIconMode, userId)
	self.inviteIconMode = inviteIconMode
	self.userId = userId
	local selectedIcon = ui:getChildByName("selected_ico")
	local avatar_ico = ui:getChildByName("avatar_ico")
	local invite_ico = ui:getChildByName("invite_ico")
	local normal = ui:getChildByName("normal")
	local selected = ui:getChildByName("selected")
	
	self.nameLabel = ui:getChildByName("name")
	self.selectedIcon = selectedIcon
	self.selectedBG = selected
	self.normalBG = normal
	self:addChild(ui)

	if inviteIconMode then
		selected:setVisible(false)
		normal:setVisible(false)
		selectedIcon:setVisible(false)
		avatar_ico:setVisible(false)
		self.nameLabel:setString(Localization:getInstance():getText("message.center.send.invite"))
		self.nameLabel:setColor(ccc3(255,255,255))
		invite_ico:setPosition(ccp(5, -5))
	else
		selected:setVisible(false)
		normal:setVisible(true)
		selectedIcon:setVisible(false)
		invite_ico:setVisible(false)
		self:select(false)

		local friendRef	= FriendManager.getInstance().friends[tostring(userId)]
		if friendRef and friendRef.name and string.len(friendRef.name) > 0 then self.nameLabel:setString(HeDisplayUtil:urlDecode(friendRef.name))
		else self.nameLabel:setString("ID:"..tostring(userId)) end
		if friendRef then
			--local clippingPos = avatar_ico:getPosition()
			local frameSize = avatar_ico:getContentSize()
			local function onImageLoadFinishCallback(clipping)
				if not ui or ui.isDisposed then return end
				
				local clippingSize = clipping:getContentSize()
				local scale = frameSize.width/clippingSize.width
				local scaleFactor = scale*0.83;
				clipping:setScale(scaleFactor)
				clipping:setPosition(ccp(frameSize.width/2-4, frameSize.height/2+3))
				avatar_ico:addChild(clipping);
			end
			HeadImageLoader:create(friendRef.uid, friendRef.headUrl, onImageLoadFinishCallback)
		end
	end
end

function ChooseFriendItem:select( val )
	if self.inviteIconMode then return end

	self.isSelected = val
	if val then
		self.selectedBG:setVisible(true)
		self.selectedIcon:setVisible(true)
		self.normalBG:setVisible(false)
	else
		self.selectedIcon:setVisible(false)
		self.selectedBG:setVisible(false)
		self.normalBG:setVisible(true)
	end
end

function ChooseFriendItem:setUserName( name )
	self.nameLabel:setString(tostring(name))
end

local function createChooseFriendList(onTileItemTouch, minWidth, minHeight, exceptIds, view, shareNotilist)
	local friend = FriendManager.getInstance().friends
	if shareNotilist then 
		friend = shareNotilist
	end

	--print("friends", table.tostring(friend))
	local friendList = {}
	local function have(id) for k, v in ipairs(exceptIds) do if v == id then return true end end end
	for i,v in pairs(friend) do
		if __IOS_FB then -- facebook必须要有snsId来向好友发送request
			if v.snsId and not have(v.uid) then table.insert(friendList, {uid=v.uid, invite=false}) end
		else
			if not have(v.uid) then table.insert(friendList, {uid=v.uid, invite=false}) end
		end
		-- table.insert(friendList, {uid=v.uid, invite=false})
	end	
	-- table.insert(friendList, {invite=true})
	local container = GridLayout:create()
	container:setWidth(minWidth)
	container:setItemSize({width = 145, height = 170})
	container:setColumn(4)
	for k, v in ipairs(friendList) do
		local askItem = ChooseFriendItem:create(v.invite, onTileItemTouch, v.uid)
		local layoutItem = ItemInClippingNode:create()
		layoutItem:setContent(askItem)
		layoutItem:setParentView(view)
		container:addItem(layoutItem, false)
		if shareNotilist then 
			askItem:select(true)
		end
	end

	container.getSelectedFriendID = function ( self )
		local result = {}
		local items = self:getItems()
		for k, v in ipairs(items) do
			local item = v:getContent()
			if item.isSelected and item.userId then
				table.insert(result, item.userId)
			end
		end
		return result
	end
	return container, #friendList
end

--
-- ChooseFriendPanel ---------------------------------------------------------
--
ChooseFriendPanel = class(BasePanel)

function ChooseFriendPanel:create(onConfirmCallback, exceptIds)
	local panel = ChooseFriendPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.AskForEnergyPanel)
	if panel:init(onConfirmCallback, exceptIds) then
		print("return true, panel should been shown")
		return panel
	else
		print("return false, panel's been destroyed")
		panel = nil
		return nil
	end
end

function ChooseFriendPanel:init(onConfirmCallback, exceptIds)
	self.exceptIds = exceptIds
	-- 初始化视图
	self.ui = self:buildInterfaceGroup("ChooseFriendPanel")
	BasePanel.init(self, self.ui)
	local vSize = CCDirector:sharedDirector():getVisibleSize()
	local panelSize = self.ui:getGroupBounds().size
	local scaleX = vSize.width / panelSize.width
	local scaleY = vSize.height / panelSize.height
	if scaleX > scaleY then scaleX = scaleY end
	print("panelSize",scaleX)
	self.ui:setScale(scaleX)
	-- self:setPosition(ccp(self:getHCenterInScreenX(), 0))
	self:setPositionForPopoutManager()

	-- 获取控件
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.captain = self.ui:getChildByName("captain")
	self.btnAdd = self.ui:getChildByName("btnAdd")
	self.btnAdd = ButtonIconsetBase:create(self.btnAdd) 
	
	self.btnAdd:setString(Localization:getInstance():getText("message.center.send.request"))
	self.ui:getChildByName("avatar"):removeFromParentAndCleanup(true)

	-- 替换标题
	local charWidth = 65
	local charHeight = 65
	local charInterval = 57
	local fntFile = "fnt/caption.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/caption.fnt" end
	local position = self.captain:getPosition()
	self.newCaptain = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.newCaptain:setAnchorPoint(ccp(0,1))
	self.newCaptain:setString(Localization:getInstance():getText("message.center.select.friends"))
	self.newCaptain:setPosition(ccp(position.x, position.y))
	self:addChild(self.newCaptain)
	self.newCaptain:setToParentCenterHorizontal()
	self.captain:removeFromParentAndCleanup(true)

	local listBg = self.ui:getChildByName("Layer 2")
	local listSize = listBg:getContentSize()
	local listPos = listBg:getPosition()
	local listHeight = listSize.height - 30

	self.listBg = listBg
	self.listSize = listSize
	self.listPos = listPos
	self.listHeight = listHeight	

	self:buildGridLayout()

	-- 添加事件监听
	local function onCloseTapped()
		self:onKeyBackClicked()
	end
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:ad(DisplayEvents.kTouchTap, onCloseTapped)

	local function onBtnAddTapped()
		local selectedFriendsID = self.content:getSelectedFriendID()
		if onConfirmCallback ~= nil then onConfirmCallback(selectedFriendsID) end
	end
	self.btnAdd:addEventListener(DisplayEvents.kTouchTap, onBtnAddTapped)

	self:selectAll(LIMIT)

	return true
end

function ChooseFriendPanel:buildGridLayout()

	local function onTileItemTouch(item)
		if item and item.inviteIconMode then
			if __IOS_FB then
				if ReachabilityUtil.getInstance():isNetworkAvailable() then 
					SnsProxy:inviteFriends(nil)
				else
					CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
				end
			else
				--local panel = AddFriendPanel:create(ccp(0,0))
				local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(ccp(0,0))
				-- panel:popout()
				--if panel then panel:popout() end
			end
		end
		return self:onItemSelectChange()
	end

	self.scrollable = VerticalScrollable:create(630, self.listHeight, true, false)
	local content, numberOfFriends = createChooseFriendList(onTileItemTouch, 630, self.listHeight, self.exceptIds, self.scrollable, self.shareNotiList)
	self.content = content
	self.numberOfFriends = numberOfFriends
	if numberOfFriends > 0 then
		self.scrollable:setContent(self.content)
		self.scrollable:setPositionXY(self.listPos.x, self.listPos.y - 15)
		self.ui:addChild(self.scrollable)
	else
		self.scrollable:dispose()
		self.content:dispose()
		self.listBg:removeFromParentAndCleanup(true)
		self.btnAdd:setVisible(false)
		local group = self.builder:buildGroup("AskForEnergyPanel_zero_friend")
		local bg = group:getChildByName("bg")
		local size = bg:getGroupBounds().size
		size = {width = size.width, height = size.height}
		local panelSize = self.ui:getGroupBounds().size
		group:setPositionXY((panelSize.width - size.width) / 2 - 1, -(panelSize.height - size.height) / 2 + 40)
		self.ui:addChild(group)
		group:getChildByName("text1"):setString(Localization:getInstance():getText("request.message.panel.zero.unlock.tip"))
		group:getChildByName("text2"):setString(Localization:getInstance():getText("request.message.panel.zero.friend.text"))
		group:getChildByName("dscText1"):setString(Localization:getInstance():getText("request.message.panel.zero.friend.dsc1"))
		group:getChildByName("dscText2"):setString(Localization:getInstance():getText("request.message.panel.zero.friend.dsc2"))
		local btn = group:getChildByName("btn")
		btn = GroupButtonBase:create(btn)
		btn:setString(Localization:getInstance():getText("request.message.panel.zero.friend.button"))
		local function onButton()
			local btnPos = btn:getPosition()
			local position = group:convertToWorldSpace(ccp(btnPos.x, btnPos.y))
			local function endCallback()
				self:onKeyBackClicked()
			end

			local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(position, endCallback)
			-- panel:popout()

			--local panel = AddFriendPanel:create(position, endCallback)
			--if panel then
				--panel:popout()
			--end
		end
		btn:addEventListener(DisplayEvents.kTouchTap, onButton)
	end
end

function ChooseFriendPanel:onKeyBackClicked()
	PopoutManager:sharedInstance():remove(self, true)
end

function ChooseFriendPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
end

function ChooseFriendPanel:onItemSelectChange()
    if self.content and not self.content.isDisposed then
        local selectedFriendsID = self.content:getSelectedFriendID()
        
        print('#selectedFriendsID', #selectedFriendsID)
        if #selectedFriendsID >= LIMIT then
            CommonTip:showTip(localize('ask.friend.limit'), 'negative')
            return false
        end
    end
    return true
end

function ChooseFriendPanel:selectAll(limit)
	if self.isDisposed  then return end
	local items = self.content:getItems()
	local count = #items
	local maxIndex
	if count >= limit then
		maxIndex = limit
	else
		maxIndex = count
	end
	for index = 1, maxIndex do
		local item = items[index]:getContent()
		if item then
			item:select(true)
		end
	end
end

function ChooseFriendPanel:refreshFriendItems()
	if self.scrollable and not self.scrollable.isDisposed then
		self.scrollable:removeFromParentAndCleanup(true)
	end
	self:buildGridLayout()
end


function ChooseFriendPanel:popoutPanel(cloudId, curAreaFriendIds, onRequestSuccess, onRequestFail)
	local panel = nil
	-- On Friend Choosed
	local function onFriendChoose(friendIds)
		DcUtil:UserTrack({category = 'friend', sub_category = 'push_button_unlock'})

		local function onSuccess(evt)
			print("onSuccess Called !")
			DcUtil:requestUnLockCloud(cloudId ,#friendIds)
			local tipKey	= "unlock.cloud.panel.request.friend.success"
			local tipValue	= Localization:getInstance():getText(tipKey)
			CommonTip:showTip(tipValue, "positive")



			if onRequestSuccess then onRequestSuccess(friendIds) end
			if panel and not panel.isDisposed then
				if friendIds then
					for k, v in pairs(friendIds) do
						table.insert(panel.exceptIds, v)
					end
				end
				panel:refreshFriendItems()
				panel:selectAll(LIMIT)
			end
		end

		local function onFail(errCode)
			print("onFail Called !")

			local tipKey	= "error.tip."..tostring(errCode)
			local tipValue	= Localization:getInstance():getText(tipKey)
			CommonTip:showTip(tipValue, "negative")
			if onRequestFail then onRequestFail(errCode) end
		end

		if not friendIds or #friendIds == 0 then
			CommonTip:showTip(Localization:getInstance():getText("unlock.cloud.panel.request.friend.noselect"), "negative")
			return
		end

		local logic = UnlockLevelAreaLogic:create(cloudId)
		logic:setOnSuccessCallback(onSuccess)
		logic:setOnFailCallback(onFail)
		if __IOS_FB then
			if SnsProxy:isShareAvailable() then
				local callback = {
					onSuccess = function(result)
						logic:start(UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP, friendIds)
						DcUtil:logSendRequest("request",result.id,"request_uplock_area_help")
					end,
					onError = function(err)
						print("failed")
					end
				}

				local profile = UserManager.getInstance().profile
				local userName = ""
				if profile and profile:haveName() then
					userName = profile:getDisplayName()
				end
				
				local reqTitle = Localization:getInstance():getText("facebook.request.unlock.title", {user=userName})
				local reqMessage = Localization:getInstance():getText("facebook.request.unlock.message", {user=userName})
				
				local snsIds = FriendManager.getInstance():getFriendsSnsIdByUid(friendIds)
				SnsProxy:sendRequest(snsIds, reqTitle, reqMessage, false, FBRequestObject.ULOCK_AREA_HELP, callback)
			end
		else
			logic:start(UnlockLevelAreaLogicUnlockType.REQUEST_FRIEND_TO_HELP, friendIds)
		end	
	end

	local exceptIds
	if curAreaFriendIds then
		exceptIds = table.clone(curAreaFriendIds, true)
	else
		exceptIds = {}
	end
	panel = ChooseFriendPanel:create(onFriendChoose, exceptIds)
	panel:popout()
end
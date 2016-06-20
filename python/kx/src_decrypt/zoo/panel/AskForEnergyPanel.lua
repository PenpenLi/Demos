require "hecore.ui.PopoutManager"
require "hecore.ui.ScrollView"

require "zoo.panel.basePanel.BasePanel"
require "zoo.net.Http"

-------------------------------------------------------------------------
--  Class include: AskForEnergyItem, AskForEnergyPanel
-------------------------------------------------------------------------

--
-- AskForEnergyItem ---------------------------------------------------------
--

local LIMIT = 12

AskForEnergyItem = class(CocosObject)
function AskForEnergyItem:create(inviteIconMode, onTileItemTouch, userId)
	local builder = InterfaceBuilder:create(PanelConfigFiles.AskForEnergyPanel)
	local ui = builder:buildGroup("img/invite_friend_avatar")

	local item = AskForEnergyItem.new(CCNode:create())
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

function AskForEnergyItem:buildUI(ui, inviteIconMode, userId)
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
			-- local framePos = avatar_ico:getPosition()
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

function AskForEnergyItem:select( val )
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

function AskForEnergyItem:setUserName( name )
	self.nameLabel:setString(tostring(name))
end

local function createChooseFriendList(onTileItemTouch, minWidth, minHeight, view)
	-- local friend = FriendManager.getInstance().friends
	--print("friends", table.tostring(friend))
	local friend = FreegiftManager:sharedInstance():getCanGiveFriends()
	print(#friend)
	local friendList = {}
	if __IOS_FB then -- facebook版只需要有snsId的好友，否则无法指定好友发送request
		local appFriends = FriendManager.getInstance().friends or {}
		local appFriend = nil
		for i,v in pairs(friend) do
			appFriend = appFriends[v.friendUid]
			if appFriend and appFriend.snsId then
				table.insert(friendList, {uid=v.friendUid, invite=false})
			end
		end
	else
		for i,v in pairs(friend) do
			table.insert(friendList, {uid=v.friendUid, invite=false})
		end
	end
	-- -- table.insert(friendList, {invite=true})
	local container = GridLayout:create()
	container:setWidth(minWidth)
	container:setItemSize({width = 145, height = 170})
	container:setColumn(4)
	for k, v in ipairs(friendList) do
		local askItem = AskForEnergyItem:create(v.invite, onTileItemTouch, v.uid)
		local layoutItem = ItemInClippingNode:create()
		layoutItem:setContent(askItem)
		layoutItem:setParentView(view)
		container:addItem(layoutItem, false)
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
-- AskForEnergyPanel ---------------------------------------------------------
--
AskForEnergyPanel = class(BasePanel)
local rewardItemId = 10013
function AskForEnergyPanel:create(onConfirmCallback)
	local panel = AskForEnergyPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.AskForEnergyPanel)
	if panel:init(onConfirmCallback) then
		print("return true, panel should been shown")
		return panel
	else
		print("return false, panel's been destroyed")
		panel = nil
		return nil
	end
end

function AskForEnergyPanel:loadRequiredResource( panelConfigFile )
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:createWithContentsOfFile(panelConfigFile)
end

function AskForEnergyPanel:init(onConfirmCallback)
	-- 初始化视图
	local wSize = CCDirector:sharedDirector():getWinSize()
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	self.ui = self:buildInterfaceGroup("AskForEnergyPanel") 
	BasePanel.init(self, self.ui)
	
	self:setPositionForPopoutManager()

	-- 获取控件
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.captain = self.ui:getChildByName("captain")
	self.selectText = self.ui:getChildByName("select")
	self.commentText = self.ui:getChildByName("comment")
	self.sentText = self.ui:getChildByName("sent")
	self.btnAdd = self.ui:getChildByName("btnAdd")
	self.otherBtnPos = self.ui:getChildByName("otherBtnPos")
	self.sentIcon = self.ui:getChildByName("sentIcon")
	self.btnAdd = ButtonIconsetBase:create(self.btnAdd) 
	-- local askItemIcon = ResourceManager:sharedInstance():getItemResNameFromGoodsId(12)
	local iconBuilder = InterfaceBuilder:create(PanelConfigFiles.properties)
	local askItemIcon1 = iconBuilder:buildGroup('Prop_'..rewardItemId)
	local askItemIcon1Sprite = askItemIcon1:getChildByName('sprite')
	askItemIcon1Sprite:removeFromParentAndCleanup(false)
	askItemIcon1:dispose()
	self.btnAdd:setIcon(askItemIcon1Sprite)
	local askItemIcon = ResourceManager:sharedInstance():buildItemSprite(rewardItemId)
	local pos = self.sentIcon:getPosition()
	askItemIcon:setPosition(ccp(pos.x, pos.y))
	self.ui:addChild(askItemIcon)
	-- self.sentIcon:removeFromParentAndCleanup(true)
	self.sentIcon:setVisible(false)
	self.sentIcon = askItemIcon
	
	self.btnAdd:setString(Localization:getInstance():getText("message.center.panel.ask.energy.btn"))
	self.ui:getChildByName("avatar"):removeFromParentAndCleanup(true)
	-- self.ui:getChildByName("avatar"):setVisible(false)
	self.selectText:setString(Localization:getInstance():getText("message.center.panel.ask.energy.desc"))
	self.commentText:setString(Localization:getInstance():getText("message.center.panel.ask.energy.comment"))
	self.sentText:setString(Localization:getInstance():getText("message.center.panel.ask.energy.count"))


	-- 全选功能不再有
	self.all_select_txt = self.ui:getChildByName('all_select_txt')
	self.select_mark = self.ui:getChildByName('select_mark')
	self.select_mark:setVisible(false)
	self.allSelected = false
	self.select_all_btn = self.ui:getChildByName('select_all_btn')
	self.select_all_btn:getChildByName('hit_area'):setVisible(false)
	self.select_all_btn:setTouchEnabled(false)
	self.select_all_btn:setVisible(false)
	self.all_select_txt:setVisible(false)


	local tab = UserManager:getInstance():getWantIds()
	local count = #tab
	if __IOS_FB or count > 0 then -- facebook没有额外的奖励
		self.sentIcon:setVisible(false)
		self.sentText:setVisible(false)
	else
		local pos = self.otherBtnPos:getPosition()
		self.btnAdd:setPosition(ccp(pos.x, pos.y))
	end
	-- self.otherBtnPos:removeFromParentAndCleanup(true)
	self.otherBtnPos:setVisible(false)

	-- 替换标题
	local charWidth = 65
	local charHeight = 65
	local charInterval = 57
	local fntFile = "fnt/caption.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/caption.fnt" end
	local position = self.captain:getPosition()
	self.newCaptain = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.newCaptain:setAnchorPoint(ccp(0,1))
	self.newCaptain:setString(Localization:getInstance():getText("message.center.panel.ask.energy.captain"))
	self.newCaptain:setPosition(ccp(position.x, position.y))
	self:addChild(self.newCaptain)
	self.newCaptain:setToParentCenterHorizontal()
	self.captain:setVisible(false)

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
		--print("selectedFriendsID", table.tostring(selectedFriendsID))
		
		if #selectedFriendsID == 0 then 
			CommonTip:showTip(Localization:getInstance():getText('unlock.cloud.panel.request.friend.noselect'), 'negative', nil)
		else
			if onConfirmCallback ~= nil then onConfirmCallback(selectedFriendsID) end
		end
	end
	self.btnAdd:ad(DisplayEvents.kTouchTap, onBtnAddTapped)

	if not PlatformConfig:isPlatform(PlatformNameEnum.kJinliPre) then
		self:selectAll(LIMIT)
	end

	self:updateBtnAddShow()
	return true
end

function AskForEnergyPanel:updateBtnAddShow()
	local tab = UserManager:getInstance():getWantIds()
	if #tab < 1 then 
		if self.btnAdd then 
			if self.btnAdd.icon then 
				self.btnAdd.icon:setVisible(true)
			end
			if self.btnAdd.label then 
				self.btnAdd.label:setPosition(ccp(-58.52, 45.2))
			end
		end
	else
		if self.btnAdd then 
			if self.btnAdd.icon then 
				self.btnAdd.icon:setVisible(false)
			end
			if self.btnAdd.label then 
				self.btnAdd.label:setPosition(ccp(-101.52, 45.2))
			end
		end
	end
end

function AskForEnergyPanel:buildGridLayout()
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
	local content, numberOfFriends = createChooseFriendList(onTileItemTouch, 630, self.listHeight, self.scrollable)--Sprite:create("materials/logo.png")
	self.content = content
	self.numberOfFriends = numberOfFriends
	if numberOfFriends > 0 then
		self.scrollable:setContent(content)
		self.scrollable:setPositionXY(self.listPos.x + 18, self.listPos.y - 15)
		self.ui:addChild(self.scrollable)
	else
		self.scrollable:dispose()
		self.content:dispose()
		self.listBg:removeFromParentAndCleanup(true)
		self.selectText:setVisible(false)
		self.commentText:setVisible(false)
		self.sentIcon:setVisible(false)
		self.sentText:setVisible(false)
		self.btnAdd:setVisible(false)
		local group = self.builder:buildGroup("AskForEnergyPanel_zero_friend")
		local bg = group:getChildByName("bg")
		local size = bg:getGroupBounds().size
		size = {width = size.width, height = size.height}
		local panelSize = self.ui:getGroupBounds().size
		group:setPositionXY((panelSize.width - size.width) / 2 - 1, -(panelSize.height - size.height) / 2 + 20)
		self.ui:addChild(group)
		group:getChildByName("text1"):setString(Localization:getInstance():getText("request.message.panel.zero.friend.tip2"))
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

			local panel = require("zoo.panel.addfriend.NewAddFriendPanel"):create(position,endCallback)
			-- panel:popout()
			--local panel = AddFriendPanel:create(position,endCallback)
			--if panel then
				--panel:popout()
			--end
		end
		btn:addEventListener(DisplayEvents.kTouchTap, onButton)
	end
end

function AskForEnergyPanel:refreshFriendItems()
	if self.scrollable and not self.scrollable.isDisposed then
		self.scrollable:removeFromParentAndCleanup(true)
	end
	self:buildGridLayout(self.listHeight)
end

function AskForEnergyPanel:onKeyBackClicked()
	PopoutManager:sharedInstance():remove(self, true)
end

function AskForEnergyPanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
end


function AskForEnergyPanel:onItemSelectChange()
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

function AskForEnergyPanel:selectAll(limit)
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

-- 新方法：减少一些代码冗余
function AskForEnergyPanel:popoutPanel(onRequestSuccess, onRequestFail)
	local level = UserManager:getInstance().user:getTopLevelId()
    local meta = MetaManager:getInstance():getFreegift(level)
    local function onUpdateFriend(result, evt)
        if result == "success" then
        	local panel = nil
            local function confirmAskFriend(selectedFriendsID)
            	DcUtil:UserTrack({category = 'friend', sub_category = 'push_button_energy'})
	            local todayWants = UserManager:getInstance():getWantIds()
			    local todayWantsCount = #todayWants
			    if panel and not panel.isDisposed then
			    	panel.btnAdd:setEnabled(false)
			    end
                if #selectedFriendsID > 0 then
                    local function onSuccess()
                        DcUtil:requestEnergy(#selectedFriendsID,level)
                        CommonTip:showTip(Localization:getInstance():getText("energy.panel.ask.energy.success"), "positive")
                        if onRequestSuccess then onRequestSuccess(selectedFriendsID) end
                        if panel and not panel.isDisposed then
                        	if todayWants and todayWantsCount < 1 then
	                        	local home = HomeScene:sharedInstance()
		                        local sprite = home:createFlyToBagAnimation(rewardItemId, 1)
					            local size = panel.sentIcon:getGroupBounds().size
					            local pos = panel.sentIcon:getPosition()
					            local parent = panel.sentIcon:getParent()
					            pos = parent:convertToWorldSpace(ccp(pos.x, pos.y))
					            sprite:setPosition(ccp(pos.x, pos.y))
					            sprite:playFlyToAnim(false, false)
					            panel.sentIcon:setVisible(false)
					            panel.sentText:setVisible(false)
					            todayWantsCount = #todayWants
					        end

                        	panel:refreshFriendItems()
                        	panel:selectAll(LIMIT)
                        	panel:updateBtnAddShow()
                        	panel.btnAdd:setEnabled(true)
                        end
                    end
                    local function onFail(evt)
                        CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative")
                        if onRequestFail then onRequestFail(evt) end
                    end
                    FreegiftManager:sharedInstance():requestGift(selectedFriendsID, meta.itemId, onSuccess, onFail)
                end
            end
            panel = AskForEnergyPanel:create(confirmAskFriend)
            if panel then panel:popout() end
        else
            local message = ''
            local err_code = tonumber(evt.data)
            if err_code then message = Localization:getInstance():getText("error.tip."..err_code) end
            CommonTip:showTip(message, "negative")
        end
    end
    FreegiftManager:sharedInstance():updateFriendInfos(true, onUpdateFriend)
end
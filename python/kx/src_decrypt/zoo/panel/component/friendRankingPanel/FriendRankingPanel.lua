require 'zoo.panel.component.common.VerticalScrollable'
require 'zoo.panel.component.common.VerticalTileLayout'
require 'zoo.panel.component.common.VerticalTileItem'
require 'zoo.panel.component.friendRankingPanel.FriendRankingItem'



FriendRankingPanel = class(BasePanel)

local panel = nil

function createFriendRankingPanel()
	local size = Director:sharedDirector():getVisibleSize()
	if panel then return panel end
	panel = FriendRankingPanel:create(size.width, size.height)


	return panel
end



function FriendRankingPanel:create(width, height)
	local instance = FriendRankingPanel.new()
	instance:loadRequiredResource(PanelConfigFiles.friend_ranking_panel)
	instance:init(width, height)
	return instance
end

function FriendRankingPanel:init(width, height)
	
	self.name = 'FriendRankingPanel'
	-- self.debugTag = 1
	
	self.width = width
	self.height = height


	self.items = {}



	local ui = self:buildInterfaceGroup('friendRankingPanel')--ResourceManager:sharedInstance():buildGroup('friendRankingPanel')
	BasePanel.init(self, ui)

	local sourceSize = ui:getGroupBounds().size

	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	self.panelTitle:setString(Localization:getInstance():getText("friend.ranking.panel.title"))
	-- local title = ui:getChildByName('title')
	-- title:setString(Localization:getInstance():getText('friend.ranking.panel.title'))
	-- title:setColor(ccc3(213, 171,107))
	-- title:setFontSize(40)
	-- local title2 = TextField:createCopy(title)
	-- title2:setColor(ccc3(168,115,46))
	-- title2:setPositionY(title2:getPositionY()+1)
	-- title:getParent():addChildAt(title2, title:getZOrder()-2)

	-- auto height fitting to the screen
	local viewReplacer = ui:getChildByName('view')
	viewReplacer:setVisible(false)
	local viewPosition = viewReplacer:getPosition()
	local viewSize = viewReplacer:getGroupBounds().size
	local viewBgHeight = self.height - 250
	local viewWidth = viewSize.width
	local viewHeight = viewBgHeight - 30

	local viewBg = ui:getChildByName('viewBg')
	-- local viewBgHeight = viewHeight + 25
	local viewBgSize = viewBg:getGroupBounds().size
	viewBg:setPreferredSize(CCSizeMake(viewBgSize.width, viewBgHeight))

	local view = VerticalScrollable:create(viewWidth, viewHeight)
	view:setPosition(ccp(viewPosition.x, viewPosition.y))

	viewReplacer:getParent():addChild(view)
	viewReplacer:removeFromParentAndCleanup(true)
	
	self.view = view

	local itemContainer = VerticalTileLayout:create(viewWidth)
	self.view:setContent(itemContainer)
	self.itemContainer = itemContainer

	self.addFriendBtn = GroupButtonBase:create(ui:getChildByName('addFriendBtn'))
	self.enterDeleteModeBtn  = GroupButtonBase:create(ui:getChildByName('deleteBtn'))
	self.confirmDeleteBtn = GroupButtonBase:create(ui:getChildByName('confirmBtn'))
	self.cancelBtn = GroupButtonBase:create(ui:getChildByName('cancelBtn'))


	--positioning the buttons
	local sourceLeftPos = self.addFriendBtn:getPosition()
	local sourceRightPos = self.enterDeleteModeBtn:getPosition()
	local leftDestX = sourceLeftPos.x
	local leftDestY = -(self.height - (sourceSize.height + sourceLeftPos.y))
	local rightDestX = sourceRightPos.x
	local rightDestY = -(self.height - (sourceSize.height + sourceRightPos.y))
	self.addFriendBtn:setPosition(ccp(leftDestX, leftDestY))
	self.confirmDeleteBtn:setPosition(ccp(leftDestX, leftDestY))
	self.enterDeleteModeBtn:setPosition(ccp(rightDestX, rightDestY))
	self.cancelBtn:setPosition(ccp(rightDestX, rightDestY))

	self.addFriendBtn:setColorMode(kGroupButtonColorMode.green)
	self.addFriendBtn:setString(Localization:getInstance():getText("friend.ranking.panel.button.add"))

	self.enterDeleteModeBtn:setColorMode(kGroupButtonColorMode.orange)
	self.enterDeleteModeBtn:setString(Localization:getInstance():getText("friend.ranking.panel.button.delete"))

	self.confirmDeleteBtn:setColorMode(kGroupButtonColorMode.orange)
	self.confirmDeleteBtn:setString(Localization:getInstance():getText("friend.ranking.panel.button.confirm"))

	self.cancelBtn:setColorMode(kGroupButtonColorMode.green)
	self.cancelBtn:setString(Localization:getInstance():getText("friend.ranking.panel.button.cancel"))



	self.addFriendBtn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onAddFriendBtnTap(event) end)
	self.enterDeleteModeBtn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onEnterDeleteModeBtnTap(event) end)
	self.confirmDeleteBtn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onConfirmBtnTap(event) end)
	self.cancelBtn:addEventListener(DisplayEvents.kTouchTap, function(event) self:onCancelBtnTap(event) end)

	local closeBtn = ui:getChildByName('closeBtn')
	closeBtn:ad(DisplayEvents.kTouchTap, function(event) self:onCloseBtnTapped(event) end)
	closeBtn:setButtonMode(true)
	closeBtn:setTouchEnabled(true, 0, true)

	-- gradient BG
	local bg = ui:getChildByName('bg')
	local gradient = LayerGradient:create()
	gradient:setStartColor(ccc3(255, 216, 119))
	gradient:setEndColor(ccc3(247, 187, 129))
	gradient:setStartOpacity(255)
	gradient:setEndOpacity(255)
	gradient:setContentSize(CCSizeMake(self.width, self.height))
	gradient:setPosition(ccp(0, -self.height))
	bg:getParent():addChildAt(gradient, bg:getZOrder())
	bg:removeFromParentAndCleanup(true) -- bg now is useless


	self:exitDeleteMode()

	self.tasksWaiting = 0
	self.synchronizer = Synchronizer.new(self)

end

function FriendRankingPanel:onAddFriendBtnTap(event)
	-- print 'onAddFriendBtnTap'
	if __IOS_FB then
		SnsProxy:inviteFriends(nil)
	else
		local btnPosInNode = self.addFriendBtn:getPosition()
		local posInWorld = self.addFriendBtn.groupNode:getParent():convertToWorldSpace(ccp(btnPosInNode.x, btnPosInNode.y))
		local panel = AddFriendPanel:create(posInWorld)
		--if panel then panel:popout() end
	end
end

function FriendRankingPanel:onEnterDeleteModeBtnTap(event)
	-- print 'onEnterDeleteModeBtnTap'
	if self:isBusy() then return end
	self:enterDeleteMode()
end

function FriendRankingPanel:onConfirmBtnTap(event)
	-- print 'onConfirmBtnTap'
	if self:isBusy() then return end

	local notSelectedItems = {}
	local selectedIds = {}
	

	for k, v in pairs(self.items) do 
		if v.selected then
			table.insert(selectedIds, v:getUser().uid)
		else 
			table.insert(notSelectedItems, v)
		end
	end

	if #selectedIds == 0 then return end
	
	self:p()

	local function onSuccess(data)
		-- print('onSuccess')
		self:v()
		if self.isDisposed then return end
		for k, v in pairs(self.items) do
			if v.selected then
				DcUtil:delete(v:getUser().uid)
				self.itemContainer:removeItemAt(v:getArrayIndex(), true)
			end
		end

		self.view:updateScrollableHeight()

		self.items = notSelectedItems
		self:exitDeleteMode()

		for k, v in pairs(self.items) do 
			v:setRank(k)
		end
	end

	local function onFail(data)
		--print('onFail')
		self:v()
		local err_code = tonumber(data.data)
		if err_code then
			local msg = Localization:getInstance():getText('error.tip.'..err_code)
			CommonTip:showTip(msg, 'negative', nil)
		end
	end

	local http = DeleteFriendHttp.new()
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load(selectedIds)
end

function FriendRankingPanel:onCancelBtnTap(event)
	--print 'onCancelBtnTap'
	if self:isBusy() then return end
	self:exitDeleteMode()
end

function FriendRankingPanel:setData(friendList)
	if self:isBusy() then return end

	if friendList and type(friendList) == 'table' then

		-- add lock
		self:p()

		self:removeAllItems()

		local myself = UserManager:getInstance().user


		self.friendList = friendList
		-- add myself to the list

		table.insert(self.friendList, myself)


		
		self:sortDataByRanking()
		
		local curIndex = 1
		local itemsPerBatch = 3
		local numOfItems = #self.friendList
		--print('numOfItems', numOfItems)
		local scheduler = Director:sharedDirector():getScheduler()
		self.schedId_setData = nil

		local function addItems()
			if self.isDisposed then return end
			--print ('addItems')
			if curIndex > numOfItems then 
				--print ('over')
				--print('curIndex', curIndex)
				-- release lock
				self:v()

				if #self.friendList == 1 then 
					self.enterDeleteModeBtn:setEnabled(false)
				end

				if self.schedId_setData then
				--print 'inside' 
					scheduler:unscheduleScriptEntry(self.schedId_setData)
					self.schedId_setData = nil
				end
			else
				--print ('curIndex', curIndex)
				local itemList = {}
				for i=curIndex, curIndex + itemsPerBatch do 
					if curIndex > numOfItems then break end

					local itemData = self.friendList[curIndex]
					if not itemData then return end

					local item = FriendRankingItem:create()
					item:setData(itemData)
					item:setRank(curIndex)
					item:setHeight(90) -- hack: fix the headImage bounding box issue
					table.insert(self.items, item)

					-- if it's me...
					if itemData.uid == UserManager:getInstance().user.uid then
						--print('myself')
						item:setIsMyself()
					end

					-- self.itemContainer:addItem(item)

					-- add item to synchronizer
					self.synchronizer:register(item)

					-- perform layout
					table.insert(itemList, item)
					

					-- index++
					curIndex = curIndex + 1
				end
				self.itemContainer:addItemBatch(itemList)
				self.view:updateScrollableHeight()
				self.itemContainer:__layout()
			end
		end
		if self.schedId_setData == nil then 
			self.schedId_setData = scheduler:scheduleScriptFunc(addItems, 10/60, false)
		end
	end
end

function FriendRankingPanel:removeAllItems()
	self.itemContainer:removeAllItems()
	self.friendList = nil
	self.items = {}
end

function FriendRankingPanel:enterDeleteMode()
	self.addFriendBtn:setEnabled(false)
	self.addFriendBtn:setVisible(false)
	self.enterDeleteModeBtn:setEnabled(false)
	self.enterDeleteModeBtn:setVisible(false)

	self.confirmDeleteBtn:setEnabled(true)
	self.confirmDeleteBtn:setVisible(true)
	self.cancelBtn:setEnabled(true)
	self.cancelBtn:setVisible(true)

	for k, v in pairs(self.items) do
		v:enterSelectingMode()
		v:setSelected(false)
	end
end

function FriendRankingPanel:exitDeleteMode()
	self.addFriendBtn:setEnabled(true)
	self.addFriendBtn:setVisible(true)
	self.enterDeleteModeBtn:setEnabled(true)
	self.enterDeleteModeBtn:setVisible(true)

	self.confirmDeleteBtn:setEnabled(false)
	self.confirmDeleteBtn:setVisible(false)
	self.cancelBtn:setEnabled(false)
	self.cancelBtn:setVisible(false)

	for k, v in pairs(self.items) do
		v:setSelected(false)
		v:exitSelectingMode()
	end
end

function FriendRankingPanel:sortDataByRanking()
	local function rankHigher(u1, u2)
		if u1:getTotalStar() == u2:getTotalStar() then 
			if u1:getTopLevelId() == u2:getTopLevelId() then
				if u1:getCoin() == u2:getCoin() then
					return u1.uid < u2.uid
				else 
					return u1:getCoin() > u2:getCoin()
				end
			else 
				return u1:getTopLevelId() > u2:getTopLevelId()
			end
		else
			return u1:getTotalStar() > u2:getTotalStar()
		end
	end
	if self.friendList and type(self.friendList) == 'table' then
		table.sort(self.friendList, rankHigher)
	end
end


function FriendRankingPanel:dispose()
	self.items = {}
	self.synchronizer = nil
	CocosObject.dispose(self)
end

function FriendRankingPanel:onCloseBtnTapped()
	--print('onCloseBtnTapped')
	if self.privateScene then
		-- if false and #self.items > 100 then 
		-- 	print ('low device')
		-- 	__panel:removeFromParentAndCleanup(false)
		-- else 
		-- 	__panel:removeFromParentAndCleanup(true)
		-- 	__panel = nil
		-- end
		Director:sharedDirector():popScene()
		self.allowBackKeyTap = false
		self.privateScene = nil
	end

	panel = nil

	local home = HomeScene:sharedInstance()
	if home then home:updateFriends() end
end

function FriendRankingPanel:popout()

	if not self.privateScene then
		self.privateScene = Scene:create()
		self.privateScene.onKeyBackClicked = function ()
			--print('onKeyBackClicked')
			if not self.isDisposed then
				self:onCloseBtnTapped()
			end
		end
		self.privateScene.onApplicationHandleOpenURL = function (scene, launchURL)
			if launchURL and string.len(launchURL) > 0 then
				local res = UrlParser:parseUrlScheme(launchURL)
				if not res.method or string.lower(res.method) ~= "addfriend" then return end
				if res.para and res.para.invitecode and res.para.uid then
					local function onSuccess()
						local homeScene = HomeScene:sharedInstance()
						homeScene:checkDataChange()
						if homeScene.coinButton and not homeScene.coinButton.isDisposed then
							homeScene.coinButton:updateView()
						end
						CommonTip:showTip(Localization:getInstance():getText("url.scheme.add.friend"), "positive")
					end

					local function receiveReward()
						local logic = InvitedAndRewardLogic:create(false)
						logic:start(res.para.invitecode, res.para.uid, onSuccess)
					end
					RequireNetworkAlert:callFuncWithLogged(receiveReward, nil, kRequireNetworkAlertAnimation.kNoAnimation)
				end
			end
		end
	end
	local drt = Director:sharedDirector()
	drt:pushScene(self.privateScene)

	local vo = drt:getVisibleOrigin()
	local vs = drt:getVisibleSize()
	self:setPosition(ccp(vo.x, vo.y + vs.height))
	self.privateScene:addChild(self)

	--print('#self.items', #self.items)
	if #self.items == 0 then
		local friends = FriendManager:getInstance().friends
		local data = {}
		for k, v in pairs(friends) do
			-- fix: in case that myself is in friends table, do not insert
			-- unfix: ignore this issue for the moment
			-- if tonumber(v.uid) ~= tonumber(UserManager:getInstance().user.uid) then
				table.insert(data, v)
			-- end
		end
		self:setData(data)
	end

	local function __check()
		RequireNetworkAlert:popout(nil, kRequireNetworkAlertAnimation.kDefault)
	end
	self.privateScene:runAction(
	                  CCSequence:createWithTwoActions(
	                   CCDelayTime:create(3/60),
	                   CCCallFunc:create(__check)
	                                                  )
	                            )

end


function FriendRankingPanel:p()
	self.tasksWaiting = self.tasksWaiting + 1
	if self:isBusy() then
		self.enterDeleteModeBtn:setEnabled(false)
	end
	-- self:playAnimation()
end

function FriendRankingPanel:v()
	self.tasksWaiting = self.tasksWaiting - 1
	if not self:isBusy() then
		self.enterDeleteModeBtn:setEnabled(true)
	end
	-- self:stopAnimation()
end

function FriendRankingPanel:playAnimation()
	local scene = self.privateScene

	if scene and self:isBusy() and not self.animation then
		--print ('playAnimation')
		self.animation = CountDownAnimation:createSyncAnimation(scene)--CountDownAnimation:createNetworkAnimation(scene, nil)\
		local pos = self.enterDeleteModeBtn:getPosition()
		pos = self.enterDeleteModeBtn:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
		pos = scene:convertToNodeSpace(ccp(pos.x, pos.y))
		self.animation:setPosition(ccp(pos.x - 120, pos.y- 5 ))
	end

end

function FriendRankingPanel:stopAnimation()
	local scene = self.privateScene
	if scene and not self:isBusy() and self.animation then
		self.animation:removeFromParentAndCleanup(true)
		self.animation = nil
	end
end

function FriendRankingPanel:isBusy()
	return self.tasksWaiting > 0
end



Synchronizer = class()

function Synchronizer:ctor(panel)
	self.panel = panel
	self.observedObjects = {}
	self.waitingCount = 0
end

function Synchronizer:register(object)
	if object then
		self.observedObjects[object] = object
		object.synchronizer = self
	end
end

function Synchronizer:unregister(object)
	if object and self.observedObjects[object] then
		self.observedObjects[object] = nil
		object.synchronizer = nil
	end
end

function Synchronizer:onSendDispatched(object)
	self.panel:p()

	local canSendMore = FreegiftManager:sharedInstance():canSendMore()
	if not canSendMore then 
		for k, v in pairs(self.observedObjects) do
			v:disableSend()
		end
	end	
end

function Synchronizer:onSendSucceeded(object)
	self.panel:v()
end

function Synchronizer:onSendFailed(object)
	self.panel:v()

	local canSendMore = FreegiftManager:sharedInstance():canSendMore()
	if canSendMore then 
		for k, v in pairs(self.observedObjects) do
			if v and not v.isDisposed and v:canSend() then
				v:enableSend()
			end
		end
	else
		for k, v in pairs(self.observedObjects) do
			if v and not v.isDisposed then
				v:disableSend()
			end
		end
	end
end

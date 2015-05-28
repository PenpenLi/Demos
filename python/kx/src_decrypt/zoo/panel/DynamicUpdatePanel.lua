require "hecore.ui.PopoutManager"

DynamicUpdatePanel = class(BasePanel)

local lastCheckUpdateTime = 0
local currentPanel = nil
local function parseDynamicNameValuePair( item, target )
	if item ~= nil and item ~= "" then
		local list = string.split(item, ":")
		if list and #list == 2 then
			target[list[1]] = list[2]
		end
	end
end
local function parseDynamicUserData( userdata )
	local result = {}
	if userdata ~= nil and userdata ~= "" then
		local list = string.split(userdata, ";")
		if list and #list > 0 then
			for i,v in ipairs(list) do
				parseDynamicNameValuePair( v, result )
			end
		else
			parseDynamicNameValuePair( userdata, result )
		end
	end
	return result
end
local function onResourcePrompt( data )
	local function onCancelLoad() data.resultHandler(0) end
	local function onConfirmLoad() data.resultHandler(1) end
	--local needsize = data.status.needDownloadSize
	local needsize = 0
	local userdata = nil
	if data and data.status then 
		needsize = data.status.needDownloadSize or 0 
		userdata = data.status.userdata 
	end

	print("onResourcePrompt:"..tostring(needsize))
	local config = parseDynamicUserData(userdata)
	local force = false
	if config and config["force"] == "1" then force = true end
	print("require silent dynamic loading"..table.tostring(config))

	-- 以updateinfo.type为准 
	-- if needsize > 0 then
		local button = HomeScene:sharedInstance().updateVersionButton
		local panel = DynamicUpdatePanel:create(onConfirmLoad, onCancelLoad, needsize,force)
		if button and not button.isDisposed then
			button.wrapper:setTouchEnabled(false)
		end
		panel:popout()
		return panel
	-- else data.resultHandler(0) end
	-- return nil
end

function DynamicUpdatePanel:onCheckDynamicUpdate(isAutoPopout)
	-- local now = os.time()
	-- local kMinTime = 10 * 60 * 1000 -- each 10 minutes check new update.
	local scene = Director:sharedDirector():getRunningScene()
	-- local user = UserManager.getInstance().user
	-- if user and user:getTopLevelId() < 20 then return end
	if not NewVersionUtil:hasDynamicUpdate() then 
		return 
	end
	
	-- if scene and now - lastCheckUpdateTime > kMinTime and currentPanel == nil then
	-- 	lastCheckUpdateTime = now
	if scene then
		local function onResourceLoaderCallback( event, data )
			print("event:", event, table.tostring(data))
			if event == ResCallbackEvent.onPrompt then currentPanel = onResourcePrompt(data)
			elseif event == ResCallbackEvent.onSuccess then 
				if currentPanel then 
					currentPanel:onSuccess() 
				end
			elseif event == ResCallbackEvent.onProcess then
				local progress = 0
		    	if data.totalSize > 0 then progress = data.curSize / data.totalSize end
		    	if currentPanel then currentPanel:setProgress(progress) end
		    elseif event == ResCallbackEvent.onError then 
		    	if data.errorCode == 2014 then 
		    		he_log_info("load required res cancel")

		    	elseif not isAutoPopout then 
		    		--这两种情况走不到 onPrompt,导致没弹面板
			    	if data.item == "static_settings" or data.item == "static_config" then
			    		
			    		CommonTip:showTip(Localization:getInstance():getText("new.version.dynamic.settingfile.error"), "negative")		    		
			    	elseif data.errorCode == 2015 then --没有文件可以下载,已经是最新版本

			    		CommonTip:showTip(Localization:getInstance():getText("new.version.dynamic.isnew.error"), "negative")	

						UserManager.getInstance().updateInfo = nil
						local updateVersionButton = HomeScene:sharedInstance().updateVersionButton
						if updateVersionButton then 
							updateVersionButton:removeFromParentAndCleanup(true)
							HomeScene:sharedInstance().updateVersionButton = nil
						end
					else
				    	if currentPanel then currentPanel:onSuccess(data.errorCode) end
				    	he_log_warning("load required res error, errorCode: " .. tostring(data.errorCode) .. ", item: " .. tostring(data.item))
					end
			    else
			    	if currentPanel then currentPanel:onSuccess(data.errorCode) end
			    	he_log_warning("load required res error, errorCode: " .. tostring(data.errorCode) .. ", item: " .. tostring(data.item))
			    end
			end
		end
		if scene:is(HomeScene) then ResourceLoader.loadRequiredResWithPrompt(onResourceLoaderCallback) end
	end
end

function DynamicUpdatePanel:create(onConfirmLoad, onCancelLoad, needsize,force)
	local item = DynamicUpdatePanel.new()
	item:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	item:buildUI(onConfirmLoad, onCancelLoad, needsize,force)
	return item
end

function DynamicUpdatePanel:buildUI(onConfirmLoad, onCancelLoad, needsize,requireMustLoad)
	local ui = self:buildInterfaceGroup("DynamicUpdatePanel")--ResourceManager:sharedInstance():buildGroup("DynamicUpdatePanel")
	self.ui = ui
	BasePanel.init(self, self.ui)
	local wSize = CCDirector:sharedDirector():getWinSize()
	local winSize = CCDirector:sharedDirector():getVisibleSize()

	local bg = ui:getChildByName("_yellowBg")
	local bg1 = ui:getChildByName("_yellowBg1")
	local animal = ui:getChildByName("ani")
	local title = ui:getChildByName("title")
	local label = ui:getChildByName("label")
	local closeBtn = ui:getChildByName("close")
	local confirm = GroupButtonBase:create(ui:getChildByName("confirm"))
	local label1 = ui:getChildByName("label1")
	local item1 = ui:getChildByName("item1")
	local progress = ui:getChildByName("progress")
	local pgtxt = ui:getChildByName("pgtxt")
	local tip = ui:getChildByName("tip")
	self.bg = bg
	self.bg1 = bg1
	self.animal = animal
	self.label = label
	self.tip = tip
	self.pgtxt = pgtxt
	self.title = title
	self.closeBtn = closeBtn
	self.confirm = confirm

	title:setText(Localization:getInstance():getText("new.version.dynamic.title"))
	title:setPositionX((bg:getGroupBounds().size.width - title:getContentSize().width) / 2)

	local rewards = UserManager:getInstance().updateInfo.rewards
	if type(rewards) ~= "table" then rewards = {} end

	local actualHeight = 0
	self.items = {}
	if #rewards == 0 then
		item1:removeFromParentAndCleanup(true)
		local dimension = label:getDimensions()
		label:setDimensions(CCSizeMake(dimension.width, 0))
		label:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		actualHeight = label:getPositionY() - label:getContentSize().height - 50
	elseif #rewards == 1 then
		animal:setVisible(false)
		local dimension = label1:getDimensions()
		label1:setDimensions(CCSizeMake(dimension.width, 0))
		label1:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		local cSize = label1:getContentSize()
		local newItem = self:buildItem(rewards[1].itemId, rewards[1].num)
		newItem:setPositionXY(item1:getPositionX(), item1:getPositionY())
		ui:addChildAt(newItem, ui:getChildIndex(item1))
		item1:removeFromParentAndCleanup(true)
		item1 = newItem
		table.insert(self.items, newItem)
		local iSize = item1:getGroupBounds().size
		if cSize.height > iSize.height then
			actualHeight = label1:getPositionY() - cSize.height - 20
		else
			actualHeight = label1:getPositionY() - iSize.height - 20
		end
		self.label = label1
	else
		animal:setVisible(false)
		local dimension = label:getDimensions()
		label:setDimensions(CCSizeMake(dimension.width, 0))
		label:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		actualHeight = label:getPositionY() - label:getContentSize().height - 20
		local iSize = item1:getGroupBounds().size
		local items = {}
		for k, v in ipairs(rewards) do
			table.insert(items, self:buildItem(v.itemId, v.num))
		end
		local bgSize = bg:getGroupBounds().size
		local originX = (bgSize.width - iSize.width * #rewards - 30 * (#rewards + 1)) / 2
		for k, v in ipairs(items) do
			v:setPositionXY(originX + iSize.width * (k - 1) + 30 * k, actualHeight)
			ui:addChildAt(v, ui:getChildIndex(item1))
			table.insert(self.items, v)
		end
		actualHeight = actualHeight - iSize.height - 20
		item1:removeFromParentAndCleanup(true)
	end

	local bSize = confirm:getGroupBounds().size
	confirm:setPositionY(actualHeight - bSize.height / 2)
	progress:setPositionY(actualHeight - 5)
	actualHeight = actualHeight - bSize.height - 20
	self.pgtxt:setPositionY(progress:getPositionY() - 8)
	self.progress = HomeSceneItemProgressBar:create(progress, 0, 100)
	self.progress:setVisible(false)
	self.pgtxt:setVisible(false)
	local dimension = tip:getDimensions()
	tip:setDimensions(CCSizeMake(dimension.width, 0))
	local updSize = math.floor(needsize/1024/102.4) / 10
	if updSize < 0.1 then updSize = 0.1 end
	tip:setString(Localization:getInstance():getText("new.version.dynamic.tip.text",{ n = updSize }))
	tip:setPositionY(actualHeight)
	actualHeight = actualHeight - tip:getContentSize().height - 20
	local bg1Size = bg1:getPreferredSize()
	bg1:setPreferredSize(CCSizeMake(bg1Size.width, bg1:getPositionY() - actualHeight))
	animal:setPositionY(bg1:getPositionY() - bg1:getPreferredSize().height + animal:getGroupBounds().size.height)
	local bgSize = bg:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(bgSize.width, bg1:getPositionX() - bg1:getPositionY() + bg1:getPreferredSize().height))
	confirm:setString(Localization:getInstance():getText("update.mew.vision.panel.yes"))
	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigion = Director:sharedDirector():getVisibleOrigin()
	self:setPositionX((vSize.width - bgSize.width * self:getScale()) / 2 + vOrigion.x)

	self:refreshLayout(true)

	local function onCloseTapped() 
		if onCancelLoad ~= nil then onCancelLoad() end
		self:remove() 

		local updateVersionButton = HomeScene:sharedInstance().updateVersionButton
		if updateVersionButton and not NewVersionUtil:hasDynamicUpdate() then 
			updateVersionButton:removeFromParentAndCleanup(true)
			HomeScene:sharedInstance().updateVersionButton = nil
		end
	end
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	local function onCloseButtonTapped(evt)
		DcUtil:UserTrack({ category='Ui', sub_category='click_download', t=1})
		onCloseTapped(evt)
	end
	closeBtn:ad(DisplayEvents.kTouchTap, onCloseButtonTapped)

	self.succeedFlag = 0
	local function onConfirmTouch( evt )  
		if self.succeedFlag == 1 then 
			if __ANDROID then luajava.bindClass("com.happyelements.android.ApplicationHelper"):restart()
			else Director.sharedDirector():exitGame() end
		elseif self.succeedFlag == 0 then
			self.succeedFlag = -1
			local rewards = UserManager:getInstance().updateInfo.rewards
			if type(rewards) ~= "table" then rewards = {} end
			if #rewards == 1 then
				label1:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label"))
				tip:setString(Localization:getInstance():getText("new.version.dynamic.downloading.tip"))
			elseif #rewards > 0 then
				label:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label"))
				tip:setString(Localization:getInstance():getText("new.version.dynamic.downloading.tip"))
			else
				label:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label.zero"))
				tip:setString(Localization:getInstance():getText("new.version.dynamic.downloading.tip.zero"))
			end
			self.allowBackKeyTap = false
			confirm:setVisible(false)
			animal:setVisible(false)
			self.progress:setVisible(true)
			self.pgtxt:setVisible(true)
			self.closeBtn:setVisible(false)
			if onConfirmLoad ~= nil then onConfirmLoad() end
		elseif self.succeedFlag == 2 then onCloseTapped() end
	end

	local function onConfirmButtonTouch(evt)
		DcUtil:UserTrack({ category='Ui', sub_category='click_download', t=2})
		onConfirmTouch(evt)
	end
	confirm:ad(DisplayEvents.kTouchTap, onConfirmButtonTouch)
	-- 已经没内容下载了
	if needsize == 0 then
		onConfirmTouch()
	end

	if requireMustLoad then
		closeBtn:setVisible(false)
		closeBtn:rma()
	end
end
function DynamicUpdatePanel:refreshLayout(immediate)
	if self.isDisposed then return end
	local actualHeight = 0
	local dimension = self.label:getDimensions()
	self.label:setDimensions(CCSizeMake(dimension.width, 0))
	if #self.items == 0 then
		local cSize = self.label:getContentSize()
		cSize = {width = cSize.width, height = cSize.height}
		if __IOS then
			local dimension = self.label:getDimensions()
			self.label:setDimensions(CCSizeMake(dimension.width, cSize.height + 15))
			cSize.height = cSize.height + 15
		end
		actualHeight = self.label:getPositionY() - cSize.height - 50
	elseif #self.items == 1 then
		local cSize = self.label:getContentSize()
		cSize = {width = cSize.width, height = cSize.height}
		if __IOS then
			local dimension = self.label:getDimensions()
			self.label:setDimensions(CCSizeMake(dimension.width, cSize.height + 15))
			cSize.height = cSize.height + 15
		end
		local iSize = self.items[1].contentSize
		if cSize.height > iSize.height then
			actualHeight = self.label:getPositionY() - cSize.height - 20
		else
			actualHeight = self.label:getPositionY() - iSize.height - 20
		end
	else
		local cSize = self.label:getContentSize()
		cSize = {width = cSize.width, height = cSize.height}
		if __IOS then
			local dimension = self.label:getDimensions()
			self.label:setDimensions(CCSizeMake(dimension.width, cSize.height + 15))
			cSize.height = cSize.height + 15
		end
		actualHeight = self.label:getPositionY() - cSize.height - 20
		iSize = self.items[1].contentSize
		for k, v in ipairs(self.items) do
			v:setPositionY(actualHeight)
		end
		actualHeight = actualHeight - iSize.height - 20
	end

	local selfScale = self:getScale()
	local bSize = self.confirm:getGroupBounds().size
	self.confirm:setPositionY(actualHeight - bSize.height / selfScale / 2)
	self.progress:setPositionY(actualHeight - 5)
	self.pgtxt:setPositionY(actualHeight - 13)
	actualHeight = actualHeight - bSize.height / selfScale - 20
	self.tip:setPositionY(actualHeight)
	actualHeight = actualHeight - self.tip:getContentSize().height - 20
	local bg1Size = self.bg1:getPreferredSize()
	self.bg1:setPreferredSize(CCSizeMake(bg1Size.width, self.bg1:getPositionY() - actualHeight))
	self.animal:setPositionY(self.bg1:getPositionY() - self.bg1:getPreferredSize().height + self.animal:getGroupBounds().size.height / selfScale)
	local bgSize = self.bg:getPreferredSize()
	self.bg:setPreferredSize(CCSizeMake(bgSize.width, self.bg1:getPositionX() - self.bg1:getPositionY() + self.bg1:getPreferredSize().height))
end
function DynamicUpdatePanel:setProgress( porgress )
	if self.isDisposed then return end
	if porgress < 0 then porgress = 0 end
	if porgress > 1 then porgress = 1 end
	local percent = math.floor(porgress * 100)
	local selfScale = self:getScale()
	self.progress:setCurNumber(percent)
	self.pgtxt:setText(tostring(percent)..'%')
	self.pgtxt:setPositionX((self.bg:getGroupBounds().size.width / selfScale - self.pgtxt:getContentSize().width) / 2)

	self:refreshLayout(true)
end
function DynamicUpdatePanel:onSuccess(err)
	if self.isDisposed then return end
	self.progress:setVisible(false)
	self.pgtxt:setVisible(false)
	if err then 
		self.succeedFlag = 2
		self.label:setString(Localization:getInstance():getText("new.version.package.failure.label"))
		self.confirm:setString(Localization:getInstance():getText("button.ok"))
		self.confirm:setVisible(true)

		self:refreshLayout(true)
	else
		self.succeedFlag = 1

		-- 成功去掉updateinfo 信息
		local rewards = UserManager:getInstance().updateInfo.rewards
		if type(rewards) ~= "table" then rewards = {} end
		if __ANDROID then
			if #rewards == 1 then
				self.label:setString(Localization:getInstance():getText("new.version.dynamic.complete.unattended.label"))
				self.tip:setString(Localization:getInstance():getText("new.version.dynamic.complete.unattended.tip"))
			elseif #rewards > 0 then
				self.label:setString(Localization:getInstance():getText("new.version.dynamic.complete.unattended.label"))
				self.tip:setString(Localization:getInstance():getText("new.version.dynamic.complete.unattended.tip"))
			else
				self.label:setString(Localization:getInstance():getText("new.version.dynamic.complete.unattended.label.zero"))
				self.tip:setString(Localization:getInstance():getText("new.version.dynamic.complete.unattended.tip.zero"))
			end
		else
			if #rewards == 1 then
				self.label:setString(Localization:getInstance():getText("new.version.dynamic.complete.label"))
				self.tip:setString(Localization:getInstance():getText("new.version.dynamic.complete.tip"))
			elseif #rewards > 0 then
				self.label:setString(Localization:getInstance():getText("new.version.dynamic.complete.label"))
				self.tip:setString(Localization:getInstance():getText("new.version.dynamic.complete.tip"))
			else
				self.label:setString(Localization:getInstance():getText("new.version.dynamic.complete.label.zero"))
				self.tip:setString(Localization:getInstance():getText("new.version.dynamic.complete.tip.zero"))
			end
		end
		UserManager.getInstance().updateInfo = nil
		self.confirm:setString(Localization:getInstance():getText("update.done.confirm"))
		self.confirm:setVisible(true)

		self:refreshLayout(true)
	end
end
function DynamicUpdatePanel:remove()
	currentPanel = nil
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self, true)
	local button = HomeScene:sharedInstance().updateVersionButton
	if button and not button.isDisposed then
		button.wrapper:setTouchEnabled(true)
	end
end
function DynamicUpdatePanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true
end
function DynamicUpdatePanel:buildItem(itemId, itemNum)
	local ui = self:buildInterfaceGroup("dynamic_update_panel_item")
	local item = ui:getChildByName("item")
	local rect = ui:getChildByName("rect")
	local num = ui:getChildByName("num")
	local bg = ui:getChildByName("bg")

	local tmpSize = bg:getGroupBounds().size
	ui.contentSize = {width = tmpSize.width, height = tmpSize.height}

	local charWidth = 45
	local charHeight = 45
	local charInterval = 24
	local fntFile = "fnt/target_amount.fnt"
	local position = num:getPosition()
	local newLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	newLabel:setAnchorPoint(ccp(0,1))
	if itemNum > 9999 then
		newLabel:setString(tostring(itemNum))
	else
		newLabel:setString("x"..tostring(itemNum))
	end
	local size = newLabel:getContentSize()
	local rcSize = rect:getGroupBounds().size
	local rcPositionX = rect:getPositionX()
	newLabel:setPosition(ccp(rcPositionX + rcSize.width - size.width, position.y))
	ui:addChild(newLabel)
	rect:removeFromParentAndCleanup(true)
	num:removeFromParentAndCleanup(true)

	local position = item:getPosition()
	local sprite
	if itemId == 2 then
		sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
		sprite:setScale(0.8)
		sprite:setPositionX(sprite:getPositionX() + 20)
		sprite:setPositionY(sprite:getPositionY() - 15)
	elseif itemId == 14 then
		sprite = Sprite:createWithSpriteFrameName("wheel0000")
		sprite:setScale(1.5)
		local size = ui:getGroupBounds().size
		sprite:setPosition(ccp(size.width / 2 + 5, -size.height / 2))
	else
		sprite = ResourceManager:sharedInstance():buildItemGroup(itemId)
		sprite:setScale(1.2)
		sprite:setPosition(ccp(position.x, position.y))
	end
	item:removeFromParentAndCleanup(true)
	ui.item = sprite
	ui:addChildAt(sprite, 1)

	return ui
end
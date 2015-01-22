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
			--print("event:", event, table.tostring(data))
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
	local cancel = GroupButtonBase:create(ui:getChildByName("cancel"))
	local tip = ui:getChildByName("tip")
	self.bg = bg
	self.bg1 = bg1
	self.animal = animal
	self.tip = tip
	self.cancel = cancel

	tip:setString(Localization:getInstance():getText("new.version.dynamic.tip.text",{ n =  math.floor(needsize/1024) }))

	label:setString("")
	label:setVisible(false)
	self.label = label
	self.title = title
	self.confirm = confirm
	
	cancel:setColorMode(kGroupButtonColorMode.orange)
	confirm:setColorMode(kGroupButtonColorMode.blue)
	
	--
	local textSize = title:getDimensions()
	local originHeight = textSize.height
	title:setDimensions(CCSizeMake(textSize.width, 0))
	if NewVersionUtil:hasDynamicUpdate() then 
		title:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
	else
		title:setString(Localization:getInstance():getText("update.mew.vision.text", {n="\n"}))
	end
	local actualHeight = title:getContentSize().height
	local deltaHeight = actualHeight - originHeight
	animal:setPositionY(animal:getPositionY() - deltaHeight)
	confirm:setPositionY(confirm:getPositionY() - deltaHeight)
	cancel:setPositionY(cancel:getPositionY() - deltaHeight)
	label:setPositionY(label:getPositionY() - deltaHeight)
	tip:setPositionY(tip:getPositionY() - deltaHeight)
	cancel:setString(Localization:getInstance():getText("update.mew.vision.panel.no"))
	confirm:setString(Localization:getInstance():getText("update.mew.vision.panel.yes"))
	local bgSize = bg:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(bgSize.width, bgSize.height + deltaHeight))
	bgSize = bg1:getPreferredSize()
	bg1:setPreferredSize(CCSizeMake(bgSize.width, bgSize.height + deltaHeight))
	self:setPosition(ccp(self:getHCenterInScreenX(), self:getVCenterInScreenY() - wSize.height))

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

	local function onLaterTapped(evt)
		DcUtil:UserTrack({ category='Ui', sub_category='click_download', t=3})
		onCloseTapped(evt)
	end
	cancel:ad(DisplayEvents.kTouchTap, onLaterTapped)

	self.succeedFlag = 0
	local function onConfirmTouch( evt )  
		if self.succeedFlag == 1 then 
			if __ANDROID then luajava.bindClass("com.happyelements.android.ApplicationHelper"):restart()
			else Director.sharedDirector():exitGame() end
		elseif self.succeedFlag == 0 then
			self.succeedFlag = -1
			cancel:removeFromParentAndCleanup(true)
			self.cancel = nil
			label:setVisible(true)
			confirm:setVisible(false)
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
		cancel:setVisible(false)
		closeBtn:setVisible(false)
		closeBtn:rma()
		cancel:rma()

		local confirmPos = confirm:getPosition()
		confirm:setPositionY(confirmPos.y - 40)
	end
end
function DynamicUpdatePanel:setProgress( porgress )
	if porgress < 0 then porgress = 0 end
	if porgress > 1 then porgress = 1 end
	local percent = math.floor(porgress * 100)
	self.label:setString(tostring(percent) .. "%")
end
function DynamicUpdatePanel:onSuccess(err)
	self.label:setVisible(false)
	local textSize = self.title:getContentSize()
	local originHeight = textSize.height
	if err then 
		self.succeedFlag = 2
		self.title:setString(Localization:getInstance():getText("update.panel.fail.disconnect")) --self.title:setString("Error: (" .. tostring(err) .. ")")
		self.confirm:setString(Localization:getInstance():getText("button.ok"))
		self.confirm:setVisible(true)
	else
		self.succeedFlag = 1

		-- 成功去掉updateinfo 信息
		UserManager.getInstance().updateInfo = nil

		self.title:setString(Localization:getInstance():getText("update.done.text"))
		self.confirm:setString(Localization:getInstance():getText("update.done.confirm"))
		self.confirm:setVisible(true)
	end
	local actualHeight = self.title:getContentSize().height
	local deltaHeight = actualHeight - originHeight
	self.animal:setPositionY(self.animal:getPositionY() - deltaHeight)
	self.confirm:setPositionY(self.confirm:getPositionY() - deltaHeight)
	if self.cancel then
		self.cancel:setPositionY(self.cancel:getPositionY() - deltaHeight)
	end
	self.label:setPositionY(self.label:getPositionY() - deltaHeight)
	self.tip:setPositionY(self.tip:getPositionY() - deltaHeight)
	local bgSize = self.bg:getPreferredSize()
	self.bg:setPreferredSize(CCSizeMake(bgSize.width, bgSize.height + deltaHeight))
	bgSize = self.bg1:getPreferredSize()
	self.bg1:setPreferredSize(CCSizeMake(bgSize.width, bgSize.height + deltaHeight))
	local wSize = Director:sharedDirector():getWinSize()
	self:setPosition(ccp(self:getHCenterInScreenX(), self:getVCenterInScreenY() - wSize.height))
end
function DynamicUpdatePanel:remove()
	currentPanel = nil
	PopoutManager:sharedInstance():remove(self, true)
	local button = HomeScene:sharedInstance().updateVersionButton
	if button and not button.isDisposed then
		button.wrapper:setTouchEnabled(true)
	end
end
function DynamicUpdatePanel:popout()
	PopoutManager:sharedInstance():add(self, true, false)
end

-- function DynamicUpdatePanel:loadRequiredResource( panelConfigFile )
-- 	self.panelConfigFile = panelConfigFile
-- 	self.builder = InterfaceBuilder:create(panelConfigFile)
-- end
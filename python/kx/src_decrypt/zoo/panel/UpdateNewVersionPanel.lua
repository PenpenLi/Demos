require 'zoo.panel.basePanel.BasePanel'
require "zoo.util.NewVersionUtil"
require "zoo.panel.UpdateSJSuccessPanel"

local kRewardQzoneItemID = 10001
local kRewardQzoneItemNum = 2

local staticUrlRoot = "http://downloadapk.manimal.happyelements.cn/"
local isTfApk = DcUtil:getSubPlatform() and string.len(DcUtil:getSubPlatform()) == 2
if isTfApk then
	staticUrlRoot = "http://apk.manimal.happyelements.cn/"
end


--不支持更新的平台
local noSupportPlatforms = {
	PlatformNameEnum.kCMCCMM,
	PlatformNameEnum.kCUCCWO,
	PlatformNameEnum.k189Store,
	PlatformNameEnum.kCMGame,
	PlatformNameEnum.kHEMM,
	PlatformNameEnum.kSogou,
	PlatformNameEnum.kAnZhi,
	PlatformNameEnum.kMobileMM,
}

local downloadProcess = nil

-- 新版本更新!!!
UpdatePageagePanel = class(BasePanel)

function UpdatePageagePanel:create(btnPosInWorldSpace,tip)
	local panel = UpdatePageagePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.update_new_version_panel)
	panel:init(btnPosInWorldSpace,tip) 
	
	return panel
end

function UpdatePageagePanel:dispose()
	if type(downloadProcess) == "table" then
		downloadProcess.refreshCallback = nil
	end
	BasePanel.dispose(self)
end

function UpdatePageagePanel:init(btnPosInWorldSpace,tip)

	tip = tip or tostring(UserManager:getInstance().updateInfo.tips) 

	local version = tostring(UserManager:getInstance().updateInfo.version)
	local t = tostring(UserManager:getInstance().updateInfo.md5)

	self.ui = self:buildInterfaceGroup('update_pageage_panel')
	BasePanel.init(self, self.ui)

	self.btnPosInWorldSpace = btnPosInWorldSpace

	local title = self.ui:getChildByName('title')
	title:setText(Localization:getInstance():getText('new.version.title'))--新版本更新!!!
	local bg = self.ui:getChildByName("bg")
	local size = title:getContentSize()
	title:setPositionX(bg:getGroupBounds().size.width / 2 - size.width / 2)

	local rewards = UserManager:getInstance().updateInfo.rewards
	local blocks = UserManager:getInstance().updateInfo.blocks
	local targets = {}
	if type(rewards) == "table" and #rewards > 0 then
		for k, v in ipairs(rewards) do table.insert(targets, v) end
	elseif type(blocks) == "table" and #blocks > 0 then
		for k, v in ipairs(blocks) do table.insert(targets, v) end
	end

	local animal = self.ui:getChildByName("ani")
	local item1 = self.ui:getChildByName("item1")
	local label = self.ui:getChildByName("label")
	local label1 = self.ui:getChildByName("label1")
	self.item1 = item1
	self.items = {}
	if #targets == 0 then
		self.item1:setVisible(false)
		local dimension = label:getDimensions()
		label:setDimensions(CCSizeMake(dimension.width, 0))
	elseif #targets == 1 then
		animal:setVisible(false)
		local dimension = label1:getDimensions()
		label1:setDimensions(CCSizeMake(dimension.width, 0))
		local cSize = label1:getContentSize()
		local newItem = self:buildItem(targets[1])
		newItem:setPositionXY(item1:getPositionX(), item1:getPositionY())
		self.ui:addChildAt(newItem, self.ui:getChildIndex(item1))
		self.item1:removeFromParentAndCleanup(true)
		self.item1 = newItem
		table.insert(self.items, newItem)
	else
		animal:setVisible(false)
		self.item1:setVisible(false)
		local dimension = label:getDimensions()
		label:setDimensions(CCSizeMake(dimension.width, 0))
		local iSize = item1:getGroupBounds().size
		local items = {}
		for k, v in ipairs(targets) do
			table.insert(items, self:buildItem(v))
		end
		local bgSize = bg:getGroupBounds().size
		local originX = (bgSize.width - iSize.width * #targets - 30 * (#targets + 1)) / 2
		for k, v in ipairs(items) do
			v:setPositionX(originX + iSize.width * (k - 1) + 30 * k)
			self.ui:addChildAt(v, self.ui:getChildIndex(item1))
			table.insert(self.items, v)
		end
	end

	if type(downloadProcess) == "table" and (downloadProcess.status == "ing" or downloadProcess.status == "ready") then
		animal:setVisible(false)
	end
	self.confirm = GroupButtonBase:create(self.ui:getChildByName("confirm"))
	local progress = self.ui:getChildByName("progress")
	self.pgtxt = self.ui:getChildByName("pgtxt")
	self.pgtxt:setPositionY(progress:getPositionY() - 8)
	self.progress = HomeSceneItemProgressBar:create(progress, 0, 100)

	local function onClose()
		self:onCloseBtnTapped()
	end
	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, onClose)

	local function onButton()
		if type(downloadProcess) ~= "table" or downloadProcess.status ~= "ing" and downloadProcess.status ~= "ready" then
			if self:isDownloadSupport() then
				if __ANDROID then
					downloadProcess = {["status"] = "ing", ["percentage"] = 0}
					animal:setVisible(false)
					self:downloadApk(version,t)
				else
					NewVersionUtil:gotoMarket()
				end
			else
				self:onCloseBtnTapped()
			end
			self:refresh()
		elseif downloadProcess.status == "ing" then
			self:onCloseBtnTapped()
		elseif downloadProcess.apkPath then
			local PackageUtils = luajava.bindClass("com.happyelements.android.utils.PackageUtils")
			local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')
			PackageUtils:installApk(MainActivityHolder.ACTIVITY:getContext(),downloadProcess.apkPath)
		else
			self:onCloseBtnTapped()
		end
	end
	self.confirm:addEventListener(DisplayEvents.kTouchTap, onButton)

	if type(downloadProcess) ~= "table" then downloadProcess = {} end
	downloadProcess.refreshCallback = function() self:refresh() end

	self.showHideAnim = IconPanelShowHideAnim:create(self, self.btnPosInWorldSpace)
	self:refresh()
end

function UpdatePageagePanel:refresh()
	if self.isDisposed then return end

	local actualHeight = 0
	local animal = self.ui:getChildByName("ani")
	local label = self.ui:getChildByName("label")
	local label1 = self.ui:getChildByName("label1")
	local tip = self.ui:getChildByName("tip")
	local bg = self.ui:getChildByName("bg")
	local bg1 = self.ui:getChildByName("bg1")

	local dimension = label1:getDimensions()
	label1:setDimensions(CCSizeMake(dimension.width, 0))
	dimension = label:getDimensions()
	label:setDimensions(CCSizeMake(dimension.width, 0))

	if #self.items == 1 then
		if not downloadProcess then
			label1:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		elseif downloadProcess.status == "ing" then
			local rewards = UserManager:getInstance().updateInfo.rewards
			if type(rewards) == "table" and #rewards > 0 then
				label1:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label"))
			else
				label1:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label.zero"))
			end
		elseif downloadProcess.status == "ready" then
			local rewards = UserManager:getInstance().updateInfo.rewards
			if type(rewards) == "table" and #rewards > 0 then
				label1:setString(Localization:getInstance():getText("new.version.package.complete.label"))
			else
				label1:setString(Localization:getInstance():getText("new.version.package.complete.label.zero"))
			end
		else
			label1:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		end
		local cSize = label1:getContentSize()
		cSize = {width = cSize.width, height = cSize.height}
		if __IOS then
			local dimension = label1:getDimensions()
			label1:setDimensions(CCSizeMake(dimension.width, cSize.height + 15))
			cSize.height = cSize.height + 15
		end
		local iSize = self.item1.contentSize
		if cSize.height > iSize.height then
			actualHeight = label1:getPositionY() - cSize.height - 20
		else
			actualHeight = label1:getPositionY() - iSize.height - 20
		end
	else
		if not downloadProcess then
			label:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		elseif downloadProcess.status == "ing" then
			local rewards = UserManager:getInstance().updateInfo.rewards
			if type(rewards) == "table" and #rewards > 0 then
				label:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label"))
			else
				label:setString(Localization:getInstance():getText("new.version.dynamic.downloading.label.zero"))
			end
		elseif downloadProcess.status == "ready" then
			local rewards = UserManager:getInstance().updateInfo.rewards
			if type(rewards) == "table" and #rewards > 0 then
				label:setString(Localization:getInstance():getText("new.version.package.complete.label"))
			else
				label:setString(Localization:getInstance():getText("new.version.package.complete.label.zero"))
			end
		else
			label:setString(string.gsub(tostring(UserManager.getInstance().updateInfo.tips),"\\n","\n"))
		end
		local cSize = label:getContentSize()
		cSize = {width = cSize.width, height = cSize.height}
		if __IOS then
			local dimension = label:getDimensions()
			label:setDimensions(CCSizeMake(dimension.width, cSize.height + 15))
			cSize.height = cSize.height + 15
		end
		if #self.items > 0 then
			actualHeight = label:getPositionY() - cSize.height - 20
			local iSize = self.items[1].contentSize
			for k, v in ipairs(self.items) do v:setPositionY(actualHeight) end
			actualHeight = actualHeight - iSize.height - 20
		else
			actualHeight = label:getPositionY() - cSize.height - 50
		end
	end

	local selfScale = self:getScale()
	local bSize = self.confirm:getGroupBounds().size
	bSize = {width = bSize.width / selfScale, height = bSize.height / selfScale}
	self.confirm:setPositionY(actualHeight - bSize.height / 2)
	if type(downloadProcess) == "table" and downloadProcess.percentage then
		self.progress:setCurNumber(downloadProcess.percentage)
		self.pgtxt:setText(tostring(downloadProcess.percentage)..'%')
	end
	self.progress:setPositionY(actualHeight - 5)
	actualHeight = actualHeight - bSize.height - 20
	self.pgtxt:setPositionX((bg:getGroupBounds().size.width / selfScale - self.pgtxt:getContentSize().width) / 2)
	self.pgtxt:setPositionY(self.progress:getPositionY() - 8)
	if not downloadProcess or downloadProcess.status ~= "ing" and downloadProcess.status ~= "ready" then
		if self:isDownloadSupport() then self.confirm:setString(Localization:getInstance():getText("update.mew.vision.panel.yes"))
		else self.confirm:setString(Localization:getInstance():getText("new.version.done.cancel")) end
		self.confirm:setVisible(true)
		self.progress:setVisible(false)
		self.pgtxt:setVisible(false)
		tip:setString(Localization:getInstance():getText("new.version.package.tip.text"))
	elseif downloadProcess.status == "ing" then
		self.confirm:setString(Localization:getInstance():getText("update.done.doing"))
		self.confirm:setVisible(false)
		self.progress:setVisible(true)
		self.pgtxt:setVisible(true)
		local rewards = UserManager:getInstance().updateInfo.rewards
		if type(rewards) == "table" and #rewards > 0 then
			tip:setString(Localization:getInstance():getText("new.version.dynamic.downloading.tip"))
		else
			tip:setString(Localization:getInstance():getText("new.version.dynamic.downloading.tip.zero"))
		end
	elseif downloadProcess.status == "ready" then
		self.confirm:setString(Localization:getInstance():getText("new.version.package.complete.confirm"))
		self.confirm:setVisible(true)
		self.progress:setVisible(false)
		self.pgtxt:setVisible(false)
		local rewards = UserManager:getInstance().updateInfo.rewards
		if type(rewards) == "table" and #rewards > 0 then
			tip:setString(Localization:getInstance():getText("new.version.package.complete.tip"))
		else
			tip:setString(Localization:getInstance():getText("new.version.package.complete.tip.zero"))
		end
	end
	local tSize = tip:getContentSize()
	tip:setPositionY(actualHeight)
	actualHeight = actualHeight - tSize.height - 20
	local bg1Size = bg1:getPreferredSize()
	bg1:setPreferredSize(CCSizeMake(bg1Size.width, bg1:getPositionY() - actualHeight))
	animal:setPositionY(bg1:getPositionY() - bg1:getPreferredSize().height + animal:getGroupBounds().size.height / selfScale)
	local bgSize = bg:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(bgSize.width, bg1:getPositionX() - bg1:getPositionY() + bg1:getPreferredSize().height))
	local hitArea = self.ui:getChildByName("hit_area")
	bgSize = bg:getGroupBounds().size
	hitArea:setScaleY(bgSize.height / selfScale / hitArea:getContentSize().height)
end

function UpdatePageagePanel:buildItem(elem)
	local ui = self:buildInterfaceGroup("update_new_version_panel_item")
	local item = ui:getChildByName("item")
	local rect = ui:getChildByName("rect")
	local num = ui:getChildByName("num")
	local blockbg = ui:getChildByName("blockbg")
	local rewardbg = ui:getChildByName("rewardbg")
	ui.contentSize = rewardbg:getGroupBounds().size
	ui.contentSize = {width = ui.contentSize.width, height = ui.contentSize.height}

	if type(elem) == "string" then
		ResUtils:getResFromUrls({ staticUrlRoot .. tostring(elem)},function( data )
			if item.isDisposed then 
				return 
			end
		
    		local sprite = Sprite:create(data["realPath"])
    		local itmSize = item:getContentSize()
    		local itemScale = item:getScale()
    		local sprSize = sprite:getGroupBounds().size
    		sprSize = {width = sprSize.width, height = sprSize.height}
    		local scale = itmSize.width * itemScale / sprSize.width
    		if scale > itmSize.height * itemScale / sprSize.height then
    			scale = itmSize.height * itemScale / sprSize.height
    		end
    		sprite:setScale(scale)
    		sprite:setPositionX(item:getPositionX() + itmSize.width * itemScale / 2)
    		sprite:setPositionY(item:getPositionY() - itmSize.height * itemScale / 2)
    		ui:addChild(sprite)
    		item:removeFromParentAndCleanup(true)
    		rect:removeFromParentAndCleanup(true)
    		num:removeFromParentAndCleanup(true)
    		rewardbg:removeFromParentAndCleanup(true)
		end)
		item:setVisible(false)
		rect:setVisible(false)
		num:setVisible(false)
		rewardbg:setVisible(false)
	elseif type(elem) == "table" and elem.itemId and elem.num then
		local charWidth = 45
		local charHeight = 45
		local charInterval = 24
		local fntFile = "fnt/target_amount.fnt"
		local position = num:getPosition()
		local newLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
		newLabel:setAnchorPoint(ccp(0,1))
		if elem.num > 9999 then
			newLabel:setString(tostring(elem.num))
		else
			newLabel:setString("x"..tostring(elem.num))
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
		if elem.itemId == 2 then
			sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
			sprite:setScale(0.8)
			sprite:setPositionX(sprite:getPositionX() + 20)
			sprite:setPositionY(sprite:getPositionY() - 15)
		elseif elem.itemId == 14 then
			sprite = Sprite:createWithSpriteFrameName("wheel0000")
			sprite:setScale(1.5)
			local size = ui:getGroupBounds().size
			sprite:setPosition(ccp(size.width / 2 + 5, -size.height / 2))
		else
			sprite = ResourceManager:sharedInstance():buildItemGroup(elem.itemId)
			sprite:setScale(1.2)
			sprite:setPosition(ccp(position.x, position.y))
		end
		item:removeFromParentAndCleanup(true)
		ui.item = sprite
		ui:addChildAt(sprite, 1)
		blockbg:removeFromParentAndCleanup(true)
	end

	return ui
end

function UpdatePageagePanel:getLpsChannel( ... )
	-- body
	local result = ""
	if StartupConfig:getInstance():getPlatformName() == PlatformNameEnum.kSj then
		local channelId = AndroidPayment.getInstance():getChinaMobileChannelId()
		if channelId and channelId ~= "2200144172" then
			result = "."..channelId
		end
	end
	return result
end

function UpdatePageagePanel:downloadApk(version,t,tryCount)
	
	tryCount = tryCount or 3

	local FileUtils =  luajava.bindClass("com.happyelements.android.utils.FileUtils")
	local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')

	local androidPlatformName = StartupConfig:getInstance():getPlatformName()
	local isMini = StartupConfig:getInstance():getSmallRes() and "mini." or ""
	local lpsChannel = self:getLpsChannel()
	local apkName = _G.packageName .. "." ..isMini.. tostring(version) .. "." .. androidPlatformName ..lpsChannel.. ".apk"
	local apkUrl = staticUrlRoot .. "apk/" .. apkName .. "?t=" .. t --tostring(os.date("%y%m%d%H%M", os.time() or 0))
	if isTfApk then
		apkUrl = apkUrl .. "&source=" .. DcUtil:getSubPlatform()
	end
	local md5Url = apkUrl:gsub("%.apk","%.md5")
	local apkPath = FileUtils:getApkDownloadPath(MainActivityHolder.ACTIVITY:getContext()) .. 	"/" .. apkName

	local homeScene = HomeScene:sharedInstance()

	print(apkName)

	-- local loading = self:getOrbuildLoading()
	if homeScene.updateVersionButton then 
		homeScene.updateVersionButton:setText("ing", 0)
		homeScene.updateVersionButton:setVisible(true)
	end
	local md5 = ""

	local function onSuccess( ... )
		-- if loading then 
		-- 	self:removeLoading()
		-- 	loading = nil
		-- end

		if isTfApk or md5 == HeMathUtils:md5File(apkPath) then 
			-- local PackageUtils = luajava.bindClass("com.happyelements.android.utils.PackageUtils")
			-- PackageUtils:installApk(MainActivityHolder.ACTIVITY:getContext(),apkPath)
			if type(downloadProcess) == "table" then
				downloadProcess.status = "ready"
				downloadProcess.percentage = 0
				downloadProcess.apkPath = apkPath
				if downloadProcess.refreshCallback then
					downloadProcess.refreshCallback()
				else
					homeScene:runAction(CCCallFunc:create(function()
						if not homeScene.updateVersionButton or homeScene.updateVersionButton.isDisposed then return end
						local position = homeScene.updateVersionButton:getPosition()
						local panel = UpdatePageagePanel:create(position)
						if panel then
							local function onClose()
								if not homeScene.updateVersionButton or homeScene.updateVersionButton.isDisposed then return end
								homeScene.updateVersionButton.wrapper:setTouchEnabled(true)
							end
							panel:addEventListener(kPanelEvents.kClose, onClose)
							homeScene.updateVersionButton.wrapper:setTouchEnabled(false)
							panel:popout()
						end
					end))
				end
			end
			if homeScene.updateVersionButton then 
				homeScene.updateVersionButton:setText("ready")
				homeScene.updateVersionButton:setVisible(true)
			end
		else
			HeFileUtils:removeFile(apkPath)
			CommonTip:showTip(Localization:getInstance():getText("new.version.download.error") , "negative")
			if type(downloadProcess) == "table" then
				downloadProcess.status = "error"
				downloadProcess.percentage = 0
				if downloadProcess.refreshCallback then
					downloadProcess.refreshCallback()
				end
			end
			if homeScene.updateVersionButton then 
				homeScene.updateVersionButton:setText()
				homeScene.updateVersionButton:setVisible(true)
			end
		end
	end
	local function onError( code )

		tryCount = tryCount - 1
		if tryCount > 0 then
			self:downloadApk(version,t,tryCount)
		else
			-- if loading then 
			-- 	self:removeLoading()
			-- 	loading = nil
			-- end
			CommonTip:showTip(Localization:getInstance():getText("new.version.download.error") , "negative")
		end

		if homeScene.updateVersionButton then 
			homeScene.updateVersionButton:setText()
			homeScene.updateVersionButton:setVisible(true)
		end

		if type(downloadProcess) == "table" then
			downloadProcess.status = "error"
			downloadProcess.percentage = 0
			if downloadProcess.refreshCallback then
				downloadProcess.refreshCallback()
			end
		end
	end
	local function onProcess(progress,total)
		if homeScene.updateVersionButton then 
			homeScene.updateVersionButton:setText("ing", math.floor(progress * 100 / total))
			homeScene.updateVersionButton:setVisible(true)
		end
		
		if type(downloadProcess) == "table" then
			downloadProcess.status = "ing"
			downloadProcess.percentage = math.floor(progress * 100 / total)
			if downloadProcess.refreshCallback then
				downloadProcess.refreshCallback()
			else
				-- TODO: autopop
			end
		end
	end

	if homeScene.updateVersionButton then 
		homeScene.updateVersionButton:setVisible(true)
	end

	self:requestApkMd5(md5Url,function( m )
		md5 = m
		if md5 == "" then 
			onError(0)
			return
		end

		local downLoadCallfunc = luajava.createProxy("com.happyelements.android.utils.DownloadApkCallback", {
			onSuccess = onSuccess,
			onError = onError,
			onProcess = onProcess	
		})

		local HttpUtil = luajava.bindClass("com.happyelements.android.utils.HttpUtil")
		HttpUtil:downloadApk(apkUrl,apkPath,downLoadCallfunc)
		
	end)
	
	self:onCloseBtnTapped()
end

local cacheMd5 = {}
function UpdatePageagePanel:requestApkMd5( md5Url,callback )

	local key = md5Url:gsub("%?t=.+$","")
	if cacheMd5[key] then
		callback(cacheMd5[key])
		return
	end

    local function onCallback(response)
		if response.httpCode ~= 200 then 
			print("get requestApkMd5 error code:" .. response.body)

			callback("")
		else
			callback(response.body)
			cacheMd5[key] = response.body
		end
    end

	local request = HttpRequest:createGet(md5Url)
  	local connection_timeout = 2

  	if __WP8 then 
    	connection_timeout = 5
  	end

    request:setConnectionTimeoutMs(connection_timeout * 1000)
    request:setTimeoutMs(30 * 1000)

    HttpClient:getInstance():sendRequest(onCallback, request)

end

function UpdatePageagePanel:getOrbuildLoading( ... )
	local homeScene = HomeScene:sharedInstance()

	local loading = homeScene.packageLoading
	if loading then 
		return loading
	end
	if self.isDisposed then 
		return nil
	end

	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()

	loading = self:buildInterfaceGroup("updage_package_loading")
	loading:setPositionX(visibleSize.x)
	loading:setPositionY(visibleSize.height + visibleOrigin.y)
	homeScene:addChild(loading)

	homeScene.packageLoading = loading

	function loading:setPercent( current,total )
		self:getChildByName("text"):setString(Localization:getInstance():getText(
			"new.version.download.progress",
			{
				rate = string.format("%.2fM/%.2fM",current/(1024*1024),total/(1024*1024))
			}
		))	
		local bar = self:getChildByName("bar")
		if total > 0 then 
			bar:setPreferredSize(CCSizeMake(visibleSize.width * current / total,bar:getPreferredSize().height))
		else
			bar:setPreferredSize(CCSizeMake(1,bar:getPreferredSize().height))
		end
		print("current:" .. current .. " total:" .. total)
		print("percent:" .. bar:getContentSize().width)
	end
	loading:setPercent(0,0)

	return loading
end

function UpdatePageagePanel:hasLoading( ... )
	local homeScene = HomeScene:sharedInstance()
	local loading = homeScene.packageLoading

	return loading 
end
function UpdatePageagePanel:removeLoading( ... )
	local homeScene = HomeScene:sharedInstance()
		
	local loading =	homeScene.packageLoading
	if loading then 
		loading:removeFromParentAndCleanup(true)
		homeScene.packageLoading = nil
	end
end

function UpdatePageagePanel:isDownloadSupport( ... )

	if __WIN32 then 
		return false
	end

	if not __ANDROID then 
		return true
	end

  	local androidPlatformName = StartupConfig:getInstance():getPlatformName()

	for i, platform in ipairs(noSupportPlatforms) do
		if platform == androidPlatformName then
	    	return false
		end
	end
	return true
end

function UpdatePageagePanel:popout()

	-- if self:hasLoading() then 
	-- 	self:dispose()
	-- else	
		PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
		local function onFinish()
			self:refresh()
			downloadProcess.refreshCallback = function() self:refresh() end
			self.allowBackKeyTap = true
		end
		downloadProcess.refreshCallback = nil
		self.showHideAnim:playShowAnim(onFinish)
	-- end
end

function UpdatePageagePanel:autoPopout( ... )
	if self:hasLoading() then 
		self:dispose()
	else	
		-- PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
		self:setVisible(false)
		self.popoutShowTransition = function( ... )
			self:setVisible(true)
			local function onFinish() self.allowBackKeyTap = true end
			self.showHideAnim:playShowAnim(onFinish)
		end
		PopoutQueue:sharedInstance():push(self,true,false,function( ... )end)
	end
end

function UpdatePageagePanel:onCloseBtnTapped()
	if self.isClose then 
		return
	end
	self.isClose = true

	local function hidePanelCompleted()
		self:dispatchEvent(Event.new(kPanelEvents.kClose, nil, self))
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
	end
	self.allowBackKeyTap = false
	self.showHideAnim:playHideAnim(hidePanelCompleted)
end

-- 更新成功
UpdateSuccessPanel = class(BasePanel)
local hasPopout = false
function UpdateSuccessPanel:popoutIfNecessary()
	-- 有更新奖励，弹领取面板
	if hasPopout then 
		return
	end
	

	if NewVersionUtil:hasUpdateReward() then -- NewVersionUtil:hasUpdateReward() then
		local rewards = UserManager.getInstance().updateRewards
		local sjRewards = UserManager.getInstance().sjRewards
		local panel
		if sjRewards and #sjRewards > 0 then
			panel = UpdateSJSuccessPanel:create(rewards, sjRewards)
		else
			panel = UpdateSuccessPanel:create(rewards)
		end
		panel:popout()
		hasPopout = true
	end

end

function UpdateSuccessPanel:create(rewards)
	local panel = UpdateSuccessPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.update_new_version_panel)
	panel:init(rewards)

	return panel
end

function UpdateSuccessPanel:init(rewards)
	self.ui = self:buildInterfaceGroup('update_success_panel')
	BasePanel.init(self, self.ui)
	local wSize = CCDirector:sharedDirector():getWinSize()
	local winSize = CCDirector:sharedDirector():getVisibleSize()

	local bg = self.ui:getChildByName("bg")
	local bg1 = self.ui:getChildByName("bg1")
	local title = self.ui:getChildByName("title")
	local label = self.ui:getChildByName("label")
	local confirm = GroupButtonBase:create(self.ui:getChildByName("okBtn"))
	local label1 = self.ui:getChildByName("label1")
	local item1 = self.ui:getChildByName("item1")
	self.bg = bg
	self.bg1 = bg1
	self.label = label
	self.confirm = confirm
	self.items = {}

	title:setText(Localization:getInstance():getText("new.version.title"))
	title:setPositionX((bg:getGroupBounds().size.width - title:getContentSize().width) / 2)

	if type(rewards) ~= "table" then rewards = {} end

	local actualHeight = 0
	if #rewards == 1 then
		local dimension = label1:getDimensions()
		label1:setDimensions(CCSizeMake(dimension.width, 0))
		label1:setString(Localization:getInstance():getText("new.version.success.msg.text"))
		local cSize = label1:getContentSize()
		local newItem = UpdatePageagePanel.buildItem(self, rewards[1])
		newItem:setPositionXY(item1:getPositionX(), item1:getPositionY())
		self.ui:addChildAt(newItem, self.ui:getChildIndex(item1))
		item1:removeFromParentAndCleanup(true)
		item1 = newItem
		newItem.itemId = rewards[1].itemId
		newItem.num = rewards[1].num
		table.insert(self.items, newItem)
		local iSize = item1:getGroupBounds().size
		if cSize.height > iSize.height then
			actualHeight = label1:getPositionY() - cSize.height - 20
		else
			actualHeight = label1:getPositionY() - iSize.height - 20
		end
		self.label = label1
	else
		local dimension = label:getDimensions()
		label:setDimensions(CCSizeMake(dimension.width, 0))
		label:setString(Localization:getInstance():getText("new.version.success.msg.text"))
		actualHeight = label:getPositionY() - label:getContentSize().height - 20
		local iSize = item1:getGroupBounds().size
		local items = {}
		for k, v in ipairs(rewards) do
			local item = UpdatePageagePanel.buildItem(self, v)
			item.itemId = v.itemId
			item.num = v.num
			table.insert(items, item)
			table.insert(self.items, item)
		end
		local bgSize = bg:getGroupBounds().size
		local originX = (bgSize.width - iSize.width * #rewards - 30 * (#rewards + 1)) / 2
		for k, v in ipairs(items) do
			v:setPositionXY(originX + iSize.width * (k - 1) + 30 * k, actualHeight)
			self.ui:addChildAt(v, self.ui:getChildIndex(item1))
		end
		actualHeight = actualHeight - iSize.height - 20
		item1:removeFromParentAndCleanup(true)
	end

	local bSize = confirm:getGroupBounds().size
	confirm:setPositionY(actualHeight - bSize.height / 2)
	actualHeight = actualHeight - bSize.height - 20
	local bg1Size = bg1:getPreferredSize()
	bg1:setPreferredSize(CCSizeMake(bg1Size.width, bg1:getPositionY() - actualHeight))
	local bgSize = bg:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(bgSize.width, bg1:getPositionX() - bg1:getPositionY() + bg1:getPreferredSize().height))
	confirm:setString(Localization:getInstance():getText("new.version.success.get.text"))
	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigion = Director:sharedDirector():getVisibleOrigin()
	self:setPositionX((vSize.width - bgSize.width * self:getScale()) / 2 + vOrigion.x)

	local function onConfirmButtonTouch(evt)
		self:onOkTapped()
	end
	confirm:ad(DisplayEvents.kTouchTap, onConfirmButtonTouch)
end

function UpdateSuccessPanel:popout()
	-- PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
	PopoutQueue:sharedInstance():push(self)
	self.allowBackKeyTap = true
end

function UpdateSuccessPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():removeWithBgFadeOut(self, false)
	self.allowBackKeyTap = false
end

function UpdateSuccessPanel:onOkTapped()

	self.confirm:setEnabled(false)

	local function onSuccess( evt )
		
		for k, v in ipairs(self.items) do
			local config = {number=math.min(v.num,10),updateButton=true}
			local anim = nil
			if v.itemId == 14 then 
				anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
				UserManager:getInstance().user:setCash(UserManager:getInstance().user:getCash() + v.num)
				UserService:getInstance().user:setCash(UserService:getInstance().user:getCash() + v.num)
			elseif v.itemId == 2 then 
				anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
				UserManager:getInstance().user:setCoin(UserManager:getInstance().user:getCoin() + v.num)
				UserService:getInstance().user:setCoin(UserService:getInstance().user:getCoin() + v.num)
			else
				config.propId = v.itemId
				anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
				UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
				UserService:getInstance():addUserPropNumber(v.itemId, v.num)
			end
			
			local sprites = (v.itemId == 2 and {anim.sprites}) or anim.sprites
			for k, v2 in ipairs(sprites) do
				if v.itemId ~= 14 then 
					v2:setAnchorPoint(ccp(0.5,0.5))
				end

				local size = v:getGroupBounds().size
				local position = ccp(v:getPositionX() + size.width / 2, v:getPositionY() - size.height / 2)
				local position = v:getParent():convertToWorldSpace(position)
				v2:setPosition(position)
				Director.sharedDirector():getRunningScene():addChild(v2)
			end

			HomeScene:sharedInstance():checkDataChange()
			anim:play()
		end

		self:onCloseBtnTapped()
	    UserManager.getInstance().updateRewards = nil
	end

	local function onFail( evt ) 
		
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		self:onCloseBtnTapped()

	   	UserManager.getInstance().updateRewards = nil
	end

	local function onCancel(evt)
		self.confirm:setEnabled(true)

	  	UserManager.getInstance().updateRewards = nil
	end

	local http = GetUpdateRewardHttp.new(true)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:ad(Events.kCancel, onCancel)
	http:load()
end
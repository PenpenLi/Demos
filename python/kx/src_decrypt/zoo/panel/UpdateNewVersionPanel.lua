require 'zoo.panel.basePanel.BasePanel'
require "zoo.util.NewVersionUtil"
require "zoo.panel.UpdateSJSuccessPanel"

local kRewardQzoneItemID = 10001
local kRewardQzoneItemNum = 2

local staticUrlRoot = "http://downloadapk.manimal.happyelements.cn/"
--不支持更新的平台
local noSupportPlatforms = {
	PlatformNameEnum.kCMCCMM,
	PlatformNameEnum.kCUCCWO,
	PlatformNameEnum.k189Store,
	PlatformNameEnum.kCMGame,
	PlatformNameEnum.kHEMM,
	PlatformNameEnum.kMobileMM,
}
-- 新版本更新!!!
UpdatePageagePanel = class(BasePanel)

function UpdatePageagePanel:create(btnPosInWorldSpace,tip)
	local panel = UpdatePageagePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.update_new_version_panel)
	panel:init(btnPosInWorldSpace,tip) 
	
	return panel
end

-- function UpdatePageagePanel:checkUpdate()

-- 	-- local panel = UpdatePageagePanel:create()

-- 	-- panel:popout()
-- 	-- CCDirect:sharedInstance():getRunningScene():addChild(panel)

-- 	return true
-- end

-- function NewVersionTipPanel:loadRequiredResource(panelConfigFile)
-- 	self.panelConfigFile = panelConfigFile
-- 	self.builder = InterfaceBuilder:create(panelConfigFile)
-- end

function UpdatePageagePanel:init(btnPosInWorldSpace,tip)

	tip = tip or tostring(UserManager:getInstance().updateInfo.tips) 

	local version = tostring(UserManager:getInstance().updateInfo.version)
	local t = tostring(UserManager:getInstance().updateInfo.md5)

	self.ui = self:buildInterfaceGroup('update_pageage_panel')
	BasePanel.init(self, self.ui)

	self.btnPosInWorldSpace = btnPosInWorldSpace
	self.showHideAnim = IconPanelShowHideAnim:create(self, self.btnPosInWorldSpace)


	local title = self.ui:getChildByName('title')
	title:setString(Localization:getInstance():getText('new.version.title'))--新版本更新!!!

	local tipNode = self.ui:getChildByName("tip")
	local oldTipHeight = tipNode:getContentSize().height
	tipNode:setDimensions(CCSizeMake(tipNode:getDimensions().width,0))
	tipNode:setString(tip)--Localization:getInstance():getText('new.version.tip.bag'))

	local desc1 = self.ui:getChildByName("desc1")

	if self:isDownloadSupport() and __ANDROID then
		local descData = {
			platform = Localization:getInstance():getText("platform." .. StartupConfig:getInstance():getPlatformName()),
			version=_G.bundleVersion,
			version1=version, 
		}
		if StartupConfig:getInstance():getPlatformName() == PlatformNameEnum.kSj then
			desc1:setString(Localization:getInstance():getText("sj.updat.new.version"))
		else
			desc1:setString(Localization:getInstance():getText("new.version.tip.platform",descData))
		end
	else
		local descData = {version=version}
		desc1:setString(Localization:getInstance():getText("new.version.tip.default",descData))		
	end
	local desc2 = self.ui:getChildByName("desc2")
	desc2:setString(Localization:getInstance():getText("new.version.package.tip.text"))

	local downloadBtn = self.ui:getChildByName('downloadBtn')
	local cancelBtn = self.ui:getChildByName('cancelBtn')

	local bg = self.ui:getChildByName("bg")
	local bg2 = self.ui:getChildByName("bg2")
	local bgBounds = bg2:getBounds()

	local itemDic = {
		{ text = "new.version.content.1", value = UserManager:getInstance().updateInfo.blocks or {},},
		{ text = "new.version.content.2", value = UserManager:getInstance().updateInfo.items or {},},
		{ text = "new.version.content.3", value = { UserManager:getInstance().updateInfo.reward } }		
	}
	local addHeight = 0

	for k,v in pairs(itemDic) do
		if #v.value > 0 then 

			local items = self:buildItems(Localization:getInstance():getText(v.text),v.value)
			local itemsBounds = items:getGroupBounds()

			items:setPositionX(bgBounds.size.width/2 - itemsBounds.size.width/2 - 5)
			items:setPositionY(tipNode:boundingBox():getMinY() - 20 - addHeight)

			self.ui:addChild(items)

			addHeight = addHeight + itemsBounds.size.height + 20
		end
	end
	addHeight = addHeight - 160 + tipNode:getContentSize().height - oldTipHeight

	local bgSize = bg:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(bgSize.width,bgSize.height + addHeight))
	bgSize = bg2:getPreferredSize()
	bg2:setPreferredSize(CCSizeMake(bgSize.width,bgSize.height + addHeight))

	desc1:setPositionY(desc1:getPositionY() - addHeight)
	desc2:setPositionY(desc2:getPositionY() - addHeight)
	downloadBtn:setPositionY(downloadBtn:getPositionY() - addHeight)
	cancelBtn:setPositionY(cancelBtn:getPositionY() - addHeight)


	downloadBtn = GroupButtonBase:create(downloadBtn)
	downloadBtn:addEventListener(DisplayEvents.kTouchTap,function(event) 

		if self:isDownloadSupport() then
			if __ANDROID then 
				self:downloadApk(version,t)
			else
				NewVersionUtil:gotoMarket()
			end
		else
			self:onCloseBtnTapped()
		end
	end)

	if self:isDownloadSupport() then 
		downloadBtn:setEnabled(not self:hasLoading())
		downloadBtn:setString("更新游戏")

		cancelBtn = GroupButtonBase:create(cancelBtn)
		cancelBtn:setEnabled(true)
		cancelBtn:setColorMode(kGroupButtonColorMode.orange)
		cancelBtn:setString(Localization:getInstance():getText('new.version.cancal.text')) --'稍后再说'
		cancelBtn:addEventListener(DisplayEvents.kTouchTap,function(event) self:onCloseBtnTapped() end)	
	else
		downloadBtn:setString("关闭")		
		downloadBtn:setPositionX(bgSize.width/2)

		cancelBtn:removeFromParentAndCleanup(true)
	end

	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local uiSize = self.ui:getGroupBounds().size
	if uiSize.height > visibleSize.height then
		self.ui:setScale(visibleSize.height/uiSize.height)
	end
end

function UpdatePageagePanel:buildItems( s,v )
	local items = self:buildInterfaceGroup("update_package_items")
	local size = items:getGroupBounds().size

	local desc = items:getChildByName("desc")
	desc:setString(s)
	desc:setDimensions(CCSizeMake(0,0))
	desc:setAnchorPoint(ccp(0.5,0.5))
	desc:setPositionX(size.width/2)
	desc:setPositionY(desc:getPositionY() - desc:getContentSize().height/2)

	local descBoundingBox = desc:boundingBox()

	local leftDot = items:getChildByName("left.dot")
	leftDot:setAnchorPoint(ccp(1,0.5))
	leftDot:setPosition(ccp(descBoundingBox:getMinX() - 10,descBoundingBox:getMidY()))

	local rightDot = items:getChildByName("right.dot")
	rightDot:setAnchorPoint(ccp(0,0.5))
	rightDot:setPosition(ccp(descBoundingBox:getMaxX(),descBoundingBox:getMidY()))

	for i=1,4 do

		local item = items:getChildByName("item" .. i)
	    local itemSize = item:getGroupBounds().size

		if i > #v then 
			item:setVisible(false)
		else
			item:setPositionX( (i - 0.5) * size.width / #v - itemSize.width/2 )

			if type(v[i]) == "string" then 
				ResUtils:getResFromUrls({ staticUrlRoot .. v[i] },function( data )
					if item.isDisposed then 
						return 
					end
	        		
	        		local sprite = Sprite:create( data["realPath"] )
	        		sprite:setAnchorPoint(ccp(0.5,0.5))
	        		sprite:setPosition(ccp(itemSize.width/2,itemSize.height/2))
	        		item:addChild(sprite)

				end)
			elseif type(v[i]) == "table" and v[i].itemId and v[i].num then

				local image = ResourceManager:sharedInstance():buildItemSprite(v[i].itemId)
				image:setAnchorPoint(ccp(0.5,0.5))
				image:setPosition(ccp(itemSize.width/2,itemSize.height/2))
				item:addChild(image)

				local num = BitmapText:create("x" .. tostring(v[i].num),"fnt/target_amount.fnt")
				num:setAnchorPoint(ccp(1,0))
				num:setPosition(ccp(itemSize.width - 15, 15))
				item:addChild(num)

			end
		end
	end 

	return items
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

	local androidPlarformName = StartupConfig:getInstance():getPlatformName()
	local isMini = StartupConfig:getInstance():getSmallRes() and "mini." or ""
	local lpsChannel = self:getLpsChannel()
	local apkName = _G.packageName .. "." ..isMini.. tostring(version) .. "." .. androidPlarformName ..lpsChannel.. ".apk"
	local apkUrl = staticUrlRoot .. "apk/" .. apkName .. "?t=" .. t --tostring(os.date("%y%m%d%H%M", os.time() or 0))
	local md5Url = apkUrl:gsub("%.apk","%.md5")
	local apkPath = FileUtils:getApkDownloadPath(MainActivityHolder.ACTIVITY:getContext()) .. 	"/" .. apkName

	local homeScene = HomeScene:sharedInstance()

	print(apkName)

	local loading = self:getOrbuildLoading()
	local md5 = ""

	local function onSuccess( ... )
		if loading then 
			self:removeLoading()
			loading = nil
		end
		if homeScene.updateVersionButton then 
			homeScene.updateVersionButton:setVisible(true)
		end

		if md5 == HeMathUtils:md5File(apkPath) then 
			local PackageUtils = luajava.bindClass("com.happyelements.android.utils.PackageUtils")
			PackageUtils:installApk(MainActivityHolder.ACTIVITY:getContext(),apkPath)
		else
			HeFileUtils:removeFile(apkPath)
			CommonTip:showTip(Localization:getInstance():getText("new.version.download.error") , "negative")
		end
	end
	local function onError( code )

		tryCount = tryCount - 1
		if tryCount > 0 then 
			self:downloadApk(version,t,tryCount)
		else
			if loading then 
				self:removeLoading()
				loading = nil
			end
			CommonTip:showTip(Localization:getInstance():getText("new.version.download.error") , "negative")
		end

		if homeScene.updateVersionButton then 
			homeScene.updateVersionButton:setVisible(true)
		end
	end
	local function onProcess(progress,total)
		if loading then 
			loading:setPercent(progress or 0,total or 0)
		end
	end

	if homeScene.updateVersionButton then 
		homeScene.updateVersionButton:setVisible(false)
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
    request:setConnectionTimeoutMs(30 * 1000)
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

  	local androidPlarformName = StartupConfig:getInstance():getPlatformName()

	for i, platform in ipairs(noSupportPlatforms) do
		if platform == androidPlarformName then
	    	return false
		end
	end
	return true
end

function UpdatePageagePanel:popout()

	if self:hasLoading() then 
		self:dispose()
	else	
		PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
		local function onFinish() self.allowBackKeyTap = true end
		self.showHideAnim:playShowAnim(onFinish)
	end
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
		local reward = UserManager.getInstance().updateReward
		local sjRewards = UserManager.getInstance().sjRewards
		-- local reward = {itemId = 10003, num = 1}
		-- -- local sjRewards = {
		-- -- 	{itemId = 10003, num = 5},
		-- -- 	{itemId = 10003, num = 5},
		-- -- 	{itemId = 10003, num = 5},
		-- -- 	{itemId = 10003, num = 5},
		-- -- 	{itemId = 10003, num = 5}
		-- -- }
		local panel
		if sjRewards and #sjRewards > 0 then
			panel = UpdateSJSuccessPanel:create(reward, sjRewards)
		else
			panel = UpdateSuccessPanel:create(reward)
		end
		panel:popout()
		hasPopout = true
	end

end

function UpdateSuccessPanel:create(reward)
	local panel = UpdateSuccessPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.update_new_version_panel)
	panel:init(reward)

	return panel
end

function UpdateSuccessPanel:init(reward)

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()

	self.ui = self:buildInterfaceGroup('update_success_panel')
	BasePanel.init(self, self.ui)

	local msgText = self.ui:getChildByName('msgText')
	--恭喜您更新成功，获得3个精力瓶奖励！
	local itemName = Localization:getInstance():getText("prop.name."..reward.itemId)
	msgText:setString(Localization:getInstance():getText('new.version.success.msg.text',{ n = reward.num,name = itemName }))

	local rewardUI = self.ui:getChildByName("normal_reward")
	local bounds = rewardUI:getGroupBounds()

	local image = ResourceManager:sharedInstance():buildItemSprite(reward.itemId)
	image:setAnchorPoint(ccp(0.5,0.5))
	image:setPosition(ccp(bounds:getMidX(),bounds:getMidY()))
	self.ui:addChild(image)

	local num = BitmapText:create("x" .. tostring(reward.num),"fnt/target_amount.fnt")
	num:setAnchorPoint(ccp(1,0))
	num:setPosition(ccp(bounds:getMaxX() - 15, bounds:getMinY() + 15))
	self.ui:addChild(num)

	self.rewardImage = image
	self.rewardNum = num

	self.okBtn = GroupButtonBase:create(self.ui:getChildByName('okBtn'))
	self.okBtn:setEnabled(true)
	self.okBtn:setString(Localization:getInstance():getText('new.version.success.get.text'))-- '领取'
	self.okBtn:addEventListener(DisplayEvents.kTouchTap,function(event) self:onOkTapped() end)

	local size = self:getGroupBounds().size;

	self:setPositionX(size.width/2 - (visibleOrigin.x + visibleSize.width/2))
	self:setPositionY(size.height/2 - (visibleOrigin.y + visibleSize.height/2))

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

	self.okBtn:setEnabled(false)

	local v = UserManager.getInstance().updateReward
	if v == nil then 
		self:onCloseBtnTapped()		
		return
	end

	local function onSuccess( evt )
		
		local config = { number=math.min(v.num,5),updateButton=true }
		function config.finishCallback( ... )
			self:onCloseBtnTapped()
		end
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
		
		local bounds = self.rewardImage:getGroupBounds()
		local pos = ccp(bounds:getMidX(),bounds:getMidY())
		local sprites = (v.itemId == 2 and {anim.sprites}) or anim.sprites
		for k, v2 in ipairs(sprites) do
			if v.itemId ~= 14 then 
				v2:setAnchorPoint(ccp(0.5,0.5))
			else
				pos = ccp(bounds:getMinX(),bounds:getMaxY())
				v2:setScale(self.rewardImage:getContentSize().width/v2:getContentSize().width)
			end

			v2:setPosition(pos)
			Director.sharedDirector():getRunningScene():addChild(v2)
		end

		self.rewardImage:setVisible(false)
		self.rewardNum:setVisible(false)
		HomeScene:sharedInstance():checkDataChange()
		anim:play()

	    UserManager.getInstance().updateReward = nil
	end

	local function onFail( evt ) 
		
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		self:onCloseBtnTapped()

	   	UserManager.getInstance().updateReward = nil
	end

	local http = GetUpdateRewardHttp.new(true)
	http:ad(Events.kComplete, onSuccess)
	http:ad(Events.kError, onFail)
	http:load()

end
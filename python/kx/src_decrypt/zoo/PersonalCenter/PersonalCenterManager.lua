require "zoo.panel.QRCodePanel"
require "zoo.PersonalCenter.AchievementManager"
require "zoo.panel.AccountPanel"

PersonalCenterManager = {}

local index = 0
local function nextIndex()
	index = index + 1
	return index
end

-- local print = function ( str )
-- 	oldPrint("[PersonalCenter] "..str)
-- end

local medalConfig = {
		{
			id = 1,
			score = 200,
			fastLevel = 8,
		},
		{
			id = 2,
			score = 500,
			fastLevel = 8,
		},
		{
			id = 3,
			score = 800,
			fastLevel = 38,
		},
		{
			id = 4,
			score = 1100,
			fastLevel = 91,
		},
		{
			id = 5,
			score = 1400,
			fastLevel = 136,
		},
		{
			id = 6,
			score = 1700,
			fastLevel = 211,
		},
		{
			id = 7,
			score = 2000,
			fastLevel = 271,
		},
		{
			id = 8,
			score = 2300,
			fastLevel = 360,
		},
		{
			id = 9,
			score = 2600,
			fastLevel = 480,
		},
		{
			id = 10,
			score = 2900,
			fastLevel = 555,
		},
		{
			id = 11,
			score = 3200,
			fastLevel = 634,
		},
		{
			id = 12,
			score = 3500,
			fastLevel = nil,
		},
	}

function PersonalCenterManager:init()
	--个人信息数据索引
	self.AGE 					= nextIndex() --年龄
	self.SEX 					= nextIndex() --性别
	self.CONSTELLATION 			= nextIndex() --星座
	self.HEAD_URL 				= nextIndex() --头像
	self.INVITE_CODE 			= nextIndex() --消消乐号
	self.QR_CODE 				= nextIndex() --二维码内容
	self.STAR 					= nextIndex() --星级
	self.NAME 					= nextIndex() --昵称
	self.PROFILE 				= nextIndex() --用户信息

	self.HEAD_MODIFIABLE 		= nextIndex() --是否允许修改头像
	self.NAME_MODIFIABLE 		= nextIndex() --是否允许修改昵称

	self.POINTS 				= nextIndex() --成就积分
	self.PERCENT_RANK			= nextIndex() --percent 超越全村百分之XX小伙伴
	self.ACHIEVEMENTS			= nextIndex() --成就信息{id, level}
	self.STAR_FRIEND_RANK		= nextIndex() --好友中星级排名
	self.SHOULD_SHOW_ACCBTN		= nextIndex() --是否显示账号按钮
	self.SHOW_ACCBTN_REDDOT		= nextIndex() --是否显示账号按钮的红点
	self.SHOULD_SHOW_CARD_BTN 	= nextIndex() --是否显示发送名片btn

	self.TOTAL_ACHI_LEVEL		= nextIndex() --总的成就等级
	self.ENABLE_CUSTOM_HEAD		= nextIndex() --是否开启自定义头像
	self.SELF_INFO_VISIBLE		= nextIndex() --自身信息是否对好友的可见

	self.IS_TAKE_PHOTO			= nextIndex() --是否在拍照界面

	--存储个人等数据信息
	self.data = {}

	self.constellationType = {
		ARIES 			= 1, --白羊座
		TAURUS 			= 2, --金牛座
		GEMINI			= 3, --双子座
		CANCER			= 4, --巨蟹座
		LEO 			= 5, --狮子座
		VIRGO 			= 6, --处女座
		LIBRA    		= 7, --天秤座
		SCORPIO 		= 8, --天蝎座
		SAGITTARIUS 	= 9, --射手座
		CAPRICORNUS 	= 10, --摩羯座
		AQUARIUS 		= 11, --水瓶座
		PISCES 			= 12, --双鱼座
		INVALID			= 0, --无效
	}

	self.sexType = {
		MAN = 1,
		WOMAN = 2,
		INVALID = 0, --无效
	}

	self.medalConfig = medalConfig

	AchievementManager:registerAchievementNotify(AchievementManager.notifyEvent.ACHIEVEMENT, self, self.updateAchievement)

	self.dataEventFunc = {}
end

function PersonalCenterManager:updateAchievement(achiTable)
	local achiManager = AchievementManager
	
	for id, achi in pairs(achiTable) do
		if achi.achievementType == achiManager.achievementType.TRIGGER then
			local http = TriggerAchievement.new()
            local function onRequestFinish( evt )
            	SyncManager.getInstance():sync(nil, nil, kRequireNetworkAlertAnimation.kNoAnimation)
            end
            http:addEventListener(Events.kComplete, onRequestFinish)
			http:load(achi.id)
		end
	end
end

--不能设置在别处取的数据
function PersonalCenterManager:setData( key, value )
	if key == nil or value == nil then 
		print("[PersonalCenter] error setData nil")
		return 
	end

	if type(value) == "boolean" then
		print("setData key >>> "..key.." value >>> "..(value and "true" or "false"))
	else
		print("setData key >>> "..key.." value >>> "..value)
	end

	local fs = self.dataEventFunc[key]
	if fs ~= nil then
		for _,func in ipairs(fs) do
			func(value)
		end
	end

	if key == self.AGE then
		UserManager:getInstance().profile.age = value
		return
	elseif key == self.SEX then
		UserManager:getInstance().profile.gender = value
		return
	elseif key == self.NAME then
		UserManager:getInstance().profile:setDisplayName(value)
		return
	elseif key == self.CONSTELLATION then
 		UserManager:getInstance().profile.constellation = value
 		return
 	elseif key == self.HEAD_URL then
		UserManager:getInstance().profile.headUrl = value
		return
	elseif key == self.PERCENT_RANK then
		UserManager:getInstance().achievement.pctOfRank = value
		return
	elseif key == self.SELF_INFO_VISIBLE then
		UserManager:getInstance().profile.secret = not value
		self:uploadUserProfile()
		return
	end

	self.data[key] = value
end

--需要的实时数据这里不会存储，而是实时调用方法获取
function PersonalCenterManager:getData( key )
	if self.data[key] then return self.data[key] end

	local value = nil
	if key == self.INVITE_CODE then

		if __IOS_FB then 
			return UserManager.getInstance().user.uid 
		else
			return UserManager:getInstance().inviteCode
		end

	elseif key == self.QR_CODE then
		if UserManager:getInstance().inviteCode == nil then
			return "http://xxl.happyelements.com/?source=spread_profile"
		end
		return QRCodePostPanel:getQRCodeURL()

	elseif key == self.NAME_MODIFIABLE then

		return self:isNicknameUnmodifiable()

	elseif key == self.HEAD_MODIFIABLE then

		return self:isAvatarUnmodifiable()

	elseif key == self.STAR then
		--这里不能存储实时获取的数据，直接返回，每次实时获取
		return UserManager:getInstance():getUserRef():getTotalStar()

	elseif key == self.ACHIEVEMENTS then

		return UserManager:getInstance().achievement.achievements

	elseif key == self.POINTS then

		return UserManager:getInstance().achievement.points

	elseif key == self.PERCENT_RANK then

		return UserManager:getInstance().achievement.pctOfRank

	elseif key == self.PROFILE then

		return UserManager:getInstance().profile

	elseif key == self.AGE then

		return UserManager:getInstance().profile.age

	elseif key == self.SEX then

		return UserManager:getInstance().profile.gender

	elseif key == self.NAME then

		return UserManager:getInstance().profile:getDisplayName()

	elseif key == self.CONSTELLATION then

		return UserManager:getInstance().profile.constellation

	elseif key == self.HEAD_URL then

		return UserManager:getInstance().profile.headUrl

	elseif key == self.SHOULD_SHOW_ACCBTN then

		return self:shouldShowAccountBtn()

	elseif key == self.SHOW_ACCBTN_REDDOT then

		return not self:hasAccountBinded()

	elseif key == self.SHOULD_SHOW_CARD_BTN then

		return self:shouldShowBusinessCardBtn()

	elseif key == self.TOTAL_ACHI_LEVEL then

		return self:getTotalAchiLevel()

	elseif key == self.ENABLE_CUSTOM_HEAD then

		return self:isEnbaleCustonHead()

	elseif key == self.SELF_INFO_VISIBLE then

		return not UserManager:getInstance().profile.secret

	end

	self.data[key] = value

	return value
end

function PersonalCenterManager:isNicknameUnmodifiable()
    if not kUserLogin then
        return true
    end

    if _G.sns_token then
    	local authType = SnsProxy:getAuthorizeType()
    	if authType == PlatformAuthEnum.kPhone then
    		return false
    	end
    end

    if __IOS and _G.sns_token then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
    elseif __ANDROID and _G.sns_token then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
            or authType == PlatformAuthEnum.kWeibo
            or authType == PlatformAuthEnum.kMI
            or authType == PlatformAuthEnum.kWDJ
            or authType == PlatformAuthEnum.k360
    end

    return false
end

function PersonalCenterManager:isAvatarUnmodifiable()
    if not kUserLogin then
        return true
    end

    if _G.sns_token then
    	local authType = SnsProxy:getAuthorizeType()
    	if authType == PlatformAuthEnum.kPhone then
    		return false
    	end
    end

    if __IOS and _G.sns_token then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
    elseif __ANDROID and _G.sns_token then
        local authType = SnsProxy:getAuthorizeType()
        return authType == PlatformAuthEnum.kQQ
            or authType == PlatformAuthEnum.kWeibo
            or authType == PlatformAuthEnum.kMI
    end

    return false
end

function PersonalCenterManager:shouldShowAccountBtn()
	if PlatformConfig.authConfig == PlatformAuthEnum.kGuest then
        return false
    end
    return true
end

function PersonalCenterManager:getTotalAchiLevel()
	local score = AchievementManager:getTotalScore()
	for achiLevel,config in ipairs(self.medalConfig) do
		if score < config.score then
			return achiLevel - 1
		end
	end
	return #self.medalConfig
end

function PersonalCenterManager:hasAccountBinded()
    return UserManager.getInstance().profile:isPhoneBound() or UserManager.getInstance().profile:isSNSBound()
end

function PersonalCenterManager:sortDataByRanking(friendList)
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
	if friendList and type(friendList) == 'table' then
		table.sort(friendList, rankHigher)
	end
end

function PersonalCenterManager:requireData()
	local friends = FriendManager:getInstance().friends
	local friendList = {}
	for k, v in pairs(friends) do
		table.insert(friendList, v)
	end
	local myself = UserManager:getInstance().user
	table.insert(friendList, myself)

	self:sortDataByRanking(friendList)

	local starRank = 0
	for index,friend in ipairs(friendList) do
		if myself == friend then
			starRank = index
			break
		end
	end

	self:setData(self.STAR_FRIEND_RANK, starRank)

	local function onSend()
	end

	local function onErrorTip()
	end
	RequireNetworkAlert:callFuncWithLogged(onSend,onErrorTip,kRequireNetworkAlertAnimation.kNoAnimation, kRequireNetworkAlertTipType.kNoTip)


	--pctOfRank
	local function onRequestError(evt)
    	--do nothing
    end

    local function onRequestFinish(evt)
    	local pctOfRank = evt.data.pctOfRank
    	self:setData(self.PERCENT_RANK, pctOfRank)
    end

    local star = self:getData(self.STAR)

    if self.data.preStar == nil or (self.data.preStar and self.data.preStar < star) then
		local http = GetPctOfRank.new()
		http:addEventListener(Events.kComplete, onRequestFinish)
	    http:addEventListener(Events.kError, onRequestError)
		http:load(star)
	end

	self.data.preStar = star
end

function PersonalCenterManager:uploadUserProfile(authorizeType)
    local profile = UserManager.getInstance().profile
    local http = UpdateProfileHttp.new()

    if _G.sns_token then
    	if authorizeType == nil then
        	authorizeType = SnsProxy:getAuthorizeType()
        end
        local snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
        local snsName = profile:getSnsUsername(authorizeType)

        http:load(profile.name, profile.headUrl,snsPlatform,HeDisplayUtil:urlEncode(snsName))
    else
        http:load(profile.name, profile.headUrl)
    end
end

function PersonalCenterManager:shouldShowBusinessCardBtn()
	return not PlatformConfig:isJJPlatform()
end

function PersonalCenterManager:isEnbaleCustonHead()
	local isPhoneLogin = SnsProxy:getAuthorizeType() == PlatformAuthEnum.kPhone
	if not isPhoneLogin or __WP8 then return false end
	local selfPhotoFeature = MaintenanceManager:getInstance():isEnabled("SelfPhotoFeature")
	return selfPhotoFeature or false
end

function PersonalCenterManager:getLinkUrl()
	local profile = UserManager.getInstance().profile
	local uid = UserManager:getInstance().uid
	local inviteCode = UserManager:getInstance().inviteCode
	local platformName = StartupConfig:getInstance():getPlatformName()
	local pctOfRank = self:getData(self.PERCENT_RANK)
	local secret = profile.secret
	local achiString = self:getAchiString()

	local link = NetworkConfig.dynamicHost..
							"new_card_qr_code.jsp?uid="..tostring(uid)..
							"&invitecode="..tostring(inviteCode)..
							"&name="..profile.name..
							"&headurl="..profile.headUrl..
							"&pct="..pctOfRank..
							"&pid="..tostring(platformName)..
							"&secret="..tostring(secret)..
							"&level="..tostring(UserManager.getInstance().user:getTopLevelId())..
							"&achi="..achiString

	if PlatformConfig:isPlatform(PlatformNameEnum.k360) then
		link = link.."&package=android_360"
	end
	if PlatformConfig:isPlatform(PlatformNameEnum.kQQ) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_CENTER) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_MARKET) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_JINSHAN) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_BROWSER) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_ZONE) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_VIDEO) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_NEWS) or
		PlatformConfig:isPlatform(PlatformNameEnum.kYYB_QQ) then
		link = link.."&isyyb=1"
	else
		link = link.."&isyyb=0"
	end

	print('link', link)
	
	return link
end

function PersonalCenterManager:sendBusinessCard(onSuccess, onError, onCancel)
	local function onErrorTip()
		if self:getData(self.INVITE_CODE) then
			CommonTip:showNetworkAlert()
		else
			CommonTip:showTip(localize("my.card.send.error.tip1"),"negative",nil, 3)
		end
		
		onError()
	end

	local function onSend()
		if self:getData(self.INVITE_CODE) == nil then
			onErrorTip()
			return
		end
		self:_sendBusinessCard(onSuccess, onError, onCancel)
	end

	RequireNetworkAlert:callFuncWithLogged(onSend,onErrorTip, nil, kRequireNetworkAlertTipType.kNoTip)
end

function PersonalCenterManager:_sendBusinessCard(onSuccess, onError, onCancel)
	DcUtil:UserTrack({category='my_card', sub_category="my_card_click_send"}, true)

	local profile = UserManager.getInstance().profile
	local function onImageLoadFinishCallback(clipping)
		local shareLink = self:getLinkUrl()

		local title = "我的专属名片"
		local message = "2016，和我一起消除所有烦恼，开心消消乐！"

		local thumb
		if clipping.isSns ~= true then
			math.randomseed(os.time())
			local finIndex = math.random(6)
			thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/sharethumb"..tostring(finIndex)..".png")
		else
			thumb = CCFileUtils:sharedFileUtils():fullPathForFilename(clipping.headPath)
		end

		local shareCallback = {
			onSuccess = function(result)
				DcUtil:UserTrack({category='my_card', sub_category="my_card_send_success"}, true)
				if onSuccess then onSuccess(result) end
				CommonTip:showTip(localize("my.card.send.success.tips"), "positive")
			end,
			onError = function(errCode, errMsg)
				if onError then onError(errCode, errMsg) end
				CommonTip:showTip(localize("my.card.send.fail.tips"), "negative")
			end,
			onCancel = function()
				if onCancel then onCancel() end
				CommonTip:showTip(localize("my.card.send.cancel.tips"), "negative")
			end,
		}

		if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
			SnsUtil.sendInviteMessage(PlatformShareEnum.kMiTalk, shareCallback)
		else
			SnsUtil.sendLinkMessage(PlatformShareEnum.kWechat, title, message, thumb, shareLink, false, shareCallback)
		end
    end
    HeadImageLoader:create(nil, profile.headUrl, onImageLoadFinishCallback)
end

function PersonalCenterManager:onKeyBackClicked()
	local function onClose()
		local photoManager = luajava.bindClass("com.happyelements.android.photo.PhotoManager"):get()
		if photoManager then
			photoManager:onKeyBackClicked()
		end
		self:setData(self.IS_TAKE_PHOTO, false)
		if self.panel == nil then
			self:showPersonalCenterPanel()
			self.panel.avatarSelectGroup:onAvatarTouch()
		else
			self.panel.avatarSelectGroup:onAvatarTouch()
		end
	end

	pcall(onClose)
end

function PersonalCenterManager:reigsterDataEvent(key, func)
	local fs = self.dataEventFunc[key]
	if fs == nil then
		self.dataEventFunc[key] = {}
	end

	table.insert(self.dataEventFunc[key], func)
end

function PersonalCenterManager:unreigsterDataEvent( key )
	--TODO:
	self.dataEventFunc[key] = nil
end

function PersonalCenterManager:showPersonalCenterPanel()
	self:requireData()

	local PersonalCenterPanel = require "zoo.PersonalCenter.PersonalCenterPanel"
	self.panel = PersonalCenterPanel:create(self)
	self.panel:popout()
end

function PersonalCenterManager:getAchiString()
	local achi = table.clone(UserManager.getInstance().achievement.achievements, true)

	achi = table.filter(
			achi, 
			function(item)
				return item.level > 0
			end
		)
	
	table.sort(
		achi, 
		function(a, b)
			local configA = AchievementManager:getConfig(a.id)
			local configB = AchievementManager:getConfig(b.id)
			if configA and configB then
				return configA.priority < configB.priority
			else
				return false
			end
		end
	)

	local nums = math.min(5, #achi)
	local achiCodes = {}
	for i=1, nums do
		achiCodes[#achiCodes + 1] = achi[i].id * 1000 + achi[i].level
	end

	local achiString = ''
	for i=1, nums-1 do
		achiString = achiString..achiCodes[i]..','
	end
	if nums > 0 then
		achiString = achiString..achiCodes[nums]
	end
	return achiString
end

PersonalCenterManager:init()
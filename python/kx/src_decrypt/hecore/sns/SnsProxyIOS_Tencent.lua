require "hecore.sns.SnsCallbackEvent"

SnsProxy = {profile = {}}

local proxy = TencentOpenApiManager:getInstance()

function SnsProxy:isLogin()
	if not __IOS_QQ then return false end
	print("SnsProxy:isLogin")
    local lastLoginUser = Localhost.getInstance():getLastLoginUserConfig()
    if not lastLoginUser then
        return false
    end

    local userData = Localhost.getInstance():readUserDataByUserID(lastLoginUser.uid)
    if userData and userData.openId then
        return proxy:isLogin()
    end
    return false
end

function SnsProxy:changeAccount( callback )
	SnsProxy:login(callback)
end

function SnsProxy:setAuthorizeType(authorType)
	self.authorType = authorType
end

function SnsProxy:getAuthorizeType()
	if self.authorType then
		return self.authorType
	else
		return PlatformConfig.authConfig
	end
end

function SnsProxy:login(callback)
	waxClass{"LoginCallback",NSObject,protocols={"SimpleCallbackDelegate"}}
	function LoginCallback:onSuccess(result)
		print("LoginCallback:onSuccess:"..table.tostring(result))
		local token = {openId = result.openId, accessToken = result.accessToken}
		if self.callback then self.callback(SnsCallbackEvent.onSuccess,token) end
	end
	function LoginCallback:onFailed(result)
		print("LoginCallback:onFailed")
		if self.callback then self.callback(SnsCallbackEvent.onError,result) end
	end
	function LoginCallback:onCancel()
		print("LoginCallback:onCancel")
		if self.callback then self.callback(SnsCallbackEvent.onCancel) end
	end

	local loginCallback = LoginCallback:init()
	loginCallback.callback = callback

	proxy:login(loginCallback)
end

function SnsProxy:logout(callback)
	waxClass{"LogoutCallback",NSObject,protocols={"SimpleCallbackDelegate"}}
	function LogoutCallback:onSuccess(result)
		print("LogoutCallback:onSuccess")
		if self.callback then callback.onSuccess(result) end
	end
	function LogoutCallback:onFailed(result)
		print("LogoutCallback:onFailed")
		if self.callback then callback.onFailed(result) end
	end
	function LogoutCallback:onCancel()
		print("LogoutCallback:onCancel")
		if self.callback then callback.onCancel() end
	end

	local logoutCallback = LogoutCallback:init()
	logoutCallback.callback = callback

	proxy:logout(logoutCallback)
end

function SnsProxy:getUserProfile(successCallback,errorCallback,cancelCallback)
	if proxy:isLogin() then
		waxClass{"GetUserProfileCallback",NSObject,protocols={"SimpleCallbackDelegate"}}
		function GetUserProfileCallback:onSuccess(result)
			print("GetUserProfileCallback:onSuccess:"..table.tostring(result))
			SnsProxy.profile = {nick=result.nickname , name=result.nickname , headUrl=result.figureurl_qq_1}
			-- UserManager.getInstance().profile.nick = result.nickname 
			-- UserManager.getInstance().profile.headUrl = result.figureurl_qq_2 -- 1.12版本暂不使用QQ头像
			if self.successCallback then self.successCallback(result) end
		end
		function GetUserProfileCallback:onFailed(result)
			print("GetUserProfileCallback:onFailed")
			if self.errorCallback then self.errorCallback(result) end
		end
		function GetUserProfileCallback:onCancel()
			print("GetUserProfileCallback:onCancel")
			if self.cancelCallback then self.cancelCallback() end
		end

		local mCallback = GetUserProfileCallback:init()
		mCallback.successCallback = successCallback
		mCallback.errorCallback = errorCallback
		mCallback.cancelCallback = cancelCallback

		proxy:getUserProfile(mCallback)
	else
		if cancelCallback then cancelCallback() end
	end
end

function waxCallback(callback)
	waxClass{"SimpleCallbackDelegate",NSObject,protocols={"SimpleCallbackDelegate"}}
	function SimpleCallbackDelegate:onSuccess(result)
		print("callback:onSuccess:"..table.tostring(result))
		if self.successCallback then self.successCallback(result) end
	end
	function SimpleCallbackDelegate:onFailed(result)
		print("callback:onFailed")
		if self.errorCallback then self.errorCallback(result) end
	end
	function SimpleCallbackDelegate:onCancel()
		print("callback:onCancel")
		if self.cancelCallback then self.cancelCallback() end
	end
	local mCallback = SimpleCallbackDelegate:init()
	mCallback.callback = callback;
	return mCallback
end

function SnsProxy:inviteFriends(callback)
end

function SnsProxy:syncSnsFriend()
	if not SnsProxy:isLogin() then
		return
	end
	local accInfo = proxy:getUserAccountInfo()
	if not accInfo or not accInfo.openId or not accInfo.accessToken then
		return
	end

	local function onRequestError(evt)
		print("syncSnsFriend onPreQzoneError callback")
	end

	local function onRequestFinish(evt)
		print("syncSnsFriend onRequestFinish callback")
		FriendManager.getInstance().lastSyncTime = os.time()
		HomeScene:sharedInstance().worldScene:buildFriendPicture()
	end

	local http = SyncSnsFriendHttp.new()
    http:addEventListener(Events.kComplete, onRequestFinish)
    http:addEventListener(Events.kError, onRequestError)
    http:load(nil, accInfo.openId, accInfo.accessToken)
end

function SnsProxy:shareImageToQQ( title, text, linkUrl, thumbUrl, callback )
    proxy:shareWithImage_thumb_title_text_callback(linkUrl, thumbUrl, title, text, waxCallback(callback))
end

--
-- UrlSchemeSDK_iOS ---------------------------------------------------------
--
-- initialize
local instanceiOS = nil
UrlSchemeSDK_iOS = {}

function UrlSchemeSDK_iOS.getInstance()
	if not instanceiOS then
		instanceiOS = UrlSchemeSDK_iOS;
		print("=========================Startup UrlSchemeSDK_iOS============================");
	end
	return instanceiOS;
end

function UrlSchemeSDK_iOS:getCurrentURL()
	return AppController:getCurrentURL()
end


--
-- UrlSchemeSDK_Android ---------------------------------------------------------
--
-- initialize
local instanceAndroid = nil
UrlSchemeSDK_Android = {}

function UrlSchemeSDK_Android.getInstance()
	if not instanceAndroid then
		instanceAndroid = UrlSchemeSDK_Android;
	end
	return instanceAndroid
end

function UrlSchemeSDK_Android:getCurrentURL()
	local notificationUtil = luajava.bindClass("com.happyelements.hellolua.share.NotificationUtil")
	if notificationUtil and notificationUtil.kMainActivity then return notificationUtil.kMainActivity:getUrlString() end
	return nil
end

--
-- UrlSchemeSDK ---------------------------------------------------------
--
UrlSchemeSDK = class()
function UrlSchemeSDK:ctor()
	if __IOS then
		self.sdk = UrlSchemeSDK_iOS:getInstance()
	end	

	if __ANDROID then
		self.sdk = UrlSchemeSDK_Android:getInstance()
	end
end

function UrlSchemeSDK:getCurrentURL()
	if self.sdk then return self.sdk:getCurrentURL() end
	return nil
end
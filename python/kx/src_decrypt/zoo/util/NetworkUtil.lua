
require "zoo.util.ReachabilityUtil"

NetworkUtil = {}

function NetworkUtil:isEnableWIFI( ... )

	if __ANDROID then

		local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')
		local Context = luajava.bindClass("android.content.Context")
		local ConnectivityManager = luajava.bindClass("android.net.ConnectivityManager")

		local connectMgr = MainActivityHolder.ACTIVITY:getContext():getSystemService(Context.CONNECTIVITY_SERVICE)

		local networkInfo = connectMgr:getActiveNetworkInfo()
		if networkInfo == nil then 
			return false
		end

		return networkInfo:getType() == ConnectivityManager.TYPE_WIFI
	end

	if __IOS then

		return ReachabilityUtil.getInstance():isEnableWIFI()
	end

	if __WIN32 then

		return false
	end


	return false
end
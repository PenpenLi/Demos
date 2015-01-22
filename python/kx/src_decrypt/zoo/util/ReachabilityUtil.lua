-------------------------------------------------------------------------
--  Class include: ReachabilityUtil
-------------------------------------------------------------------------

require "hecore.class"

local instance = nil
ReachabilityUtil = {reachability=nil}

function ReachabilityUtil.getInstance()
	if not instance then
		instance = ReachabilityUtil
	end
	return instance;
end

function ReachabilityUtil:available()
	if __IOS then return true 
	else return false end
end

function ReachabilityUtil:isNetworkAvailable()
	if NetworkConfig.noNetworkMode then return false end

	if __IOS then
		local reachability = Reachability:reachabilityForInternetConnection()
		local status = reachability:currentReachabilityStatus()
		print("currentReachabilityStatus", status)
		return status ~= 0
	end
	
	return true
end

function ReachabilityUtil:isEnableWIFI()
	return Reachability:reachabilityForLocalWiFi():currentReachabilityStatus() ~= 0
end

function ReachabilityUtil:isEnable3G()
	return Reachability:reachabilityForInternetConnection():currentReachabilityStatus() ~= 0
end

local androidReachability = nil
function ReachabilityUtil:isNetworkReachable()
	if __IOS then
		local reachability = Reachability:reachabilityWithHostName("www.apple.com")
		local status = reachability:currentReachabilityStatus()
		print("isNetworkReachable:currentReachabilityStatus:" .. tostring(status))
		return status == 1 or status == 2
	else
		-- if not androidReachability then
		-- 	androidReachability = luajava.bindClass("com.happyelements.android.utils.ReachabilityUtil")
		-- end
		-- if androidReachability then
		-- 	return androidReachability:reachabilityWithHostName("www.baidu.com")
		-- end
		return true
	end
end





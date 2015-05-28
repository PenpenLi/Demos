-- 为了测试修改成测试服务器
-- local dynamicHost = "http://well.happyelements.net/promotion/";
-- local dynamicHost = "http://10.130.136.95/"; -- 柴智的机器
local dynamicHost = "http://10.130.137.97/";
-- local dynamicHost = "http://10.130.136.89/";
-- local dynamicHost = "http://10.130.148.156:8080/";
-- local dynamicHost = "http://animalmobile.happyelements.cn/";
-- local dynamicHost = "http://mobile.app100718846.twsapp.com/";
if __IOS_FB then
	dynamicHost = "http://animal.he-games.com/" -- IOS_FB线上
 	-- dynamicHost = "http://10.130.148.156:8080/";
	-- dynamicHost = "http://10.130.136.136:80/";
	-- dynamicHost = "http://10.130.136.29:8011/"; -- IOS_FB DEV
end

if not StartupConfig:getInstance():isLocalDevelopMode() then -- release 版本
	dynamicHost = StartupConfig:getInstance():getDynamicHost()
end

if __WP8 then
	dynamicHost = StartupConfig:getInstance():getDynamicHost()
end

NetworkConfig = {
	alwaysShowCG = false,
	noNetworkMode = false,
	useLocalServer = true,
	showDebugButtonInPreloading = false,
	mockQzoneSk = nil, --"mobile3",
	writeLocalDataStorage = true,  --for test, all local HTTP serverce do not write data to player device.
	redirectURL = dynamicHost .. "redirect.jsp",
	rpcURL = dynamicHost .. "protocol",--"http://well.happyelements.net/animal-mobile/protocol",
	registerURL = dynamicHost .. "reg",--"http://well.happyelements.net/animal-mobile/reg",
	maintenanceURL = dynamicHost .. "config",
	appstoreURL = "itms-apps://itunes.apple.com/app/id791532221",
	dynamicHost = dynamicHost,
}

-- "http://well.happyelements.net/protocol", --"http://10.130.136.29/protocol?uid=" .. tostring(uid),

--http://10.130.137.97/config?name=static
--http://animalmobile.happyelements.cn/config?name=static
--http://10.130.137.97/ciservice/projects/com.happyelements.1OSAnimal/1.1.248/HelloLua.ipa
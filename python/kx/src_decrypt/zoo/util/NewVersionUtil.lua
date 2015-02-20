
require "zoo.panel.RequireNetworkAlert"
require "zoo.config.NetworkConfig"

NewVersionUtil = {}

function NewVersionUtil:gotoMarket()
	if RequireNetworkAlert:popout() then

		if __WP8 then 
			Wp8Utils:GotoMarket() 
			return 
		end

		if __ANDROID then

			local url = nil
			local updateInfo = UserManager:getInstance().updateInfo
			if updateInfo and updateInfo.updateUrl and updateInfo.updateUrl ~= "" then 
				url = updateInfo.updateUrl
			end

			local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')
			local Intent = luajava.bindClass('android.content.Intent')
			local Uri =  luajava.bindClass('android.net.Uri') 

			local intent = luajava.newInstance('android.content.Intent')
			intent:setAction(Intent.ACTION_VIEW);

			if url then 
				intent:setData(Uri:parse(url))
			else
				intent:setData(Uri:parse('market://details?id=' .. _G.packageName))
			end
			-- if marketUrls[platformName] then
			-- 	intent:setData(Uri:parse(marketUrls[platformName]))
			-- else
			-- 	intent:setData(Uri:parse('market://details?id=' .. _G.packageName))
			-- end

			local context = MainActivityHolder.ACTIVITY:getContext()
			context:startActivity(intent)

		end

		if __IOS then
			
			local deviceType = MetaInfo:getInstance():getMachineType() or ""
		    local systemVersion = AppController:getSystemVersion() or 7
			local nsURL = nil
		    if string.find(deviceType, "iPad") and (systemVersion >= 6 and systemVersion < 7) then
				nsURL = NSURL:URLWithString("itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=791532221")
		    else
				nsURL = NSURL:URLWithString("itms-apps://itunes.apple.com/app/id791532221")
		    end
			UIApplication:sharedApplication():openURL(nsURL)

		end

	end

end


-- 有更新版本，包含大包跟动态更新
function NewVersionUtil:hasNewVersion()
	-- 0：不需要更新；1：大版本更新；2：动态更新
	
	return NewVersionUtil.hasDynamicUpdate(self) or NewVersionUtil.hasPackageUpdate(self)
end

function NewVersionUtil:hasDynamicUpdate()
	if PrepackageUtil:isPreNoNetWork() or _G.isPrePackageCannotShowUpdatePanel then return false end
	
	if not UserManager.getInstance().updateInfo  then
		return false
	end

	if not UserManager.getInstance().updateInfo.tips then
		return false
	end

	if UserManager.getInstance().user:getTopLevelId() < 20 and not __WP8 then
		return false
	end

	return UserManager.getInstance().updateInfo.type == 2
end

function NewVersionUtil:hasPackageUpdate()
	if _G.isPrePackageCannotShowUpdatePanel or PrepackageUtil:isPreNoNetWork() or _G.isPrePackageCannotShowUpdatePanel then return false end
	
	if not UserManager.getInstance().updateInfo then
		return false
	end

	if not UserManager.getInstance().updateInfo.tips then
		return false
	end
	
	if UserManager.getInstance().user:getTopLevelId() < 20 and not __WP8 then
		return false
	end

	return UserManager.getInstance().updateInfo.type == 1
end

function NewVersionUtil:hasUpdateReward()
	
	if UserManager.getInstance().user:getTopLevelId() < 20 and not __WP8 then
		return false
	end

	local result = false
	local reward = UserManager.getInstance().updateReward
	if reward and reward.num and reward.itemId then
		result = true
	end

	if NewVersionUtil:hasSJReward() then
		result = true
	end

	return result
end

function NewVersionUtil:hasSJReward( )
	-- body
	local result = false
	local sjRewards = UserManager.getInstance().sjRewards
	if sjRewards and #sjRewards > 0 then
		result = true
	end
	return result
end

function NewVersionUtil:cacheUpdateInfo()


	if NewVersionUtil.hasNewVersion(self) then 
		local updateInfo = UserManager.getInstance().updateInfo	
		local key = "game.updateInfo" .. "." .. ResourceLoader.getCurVersion() .. "." .. _G.bundleVersion		
	-- self.updateInfo = {
	-- 	type = 1,
	-- 	Reward = {
	-- 		itemId = 10013,
	-- 		num = 3
	-- 	},
	-- 	tips = 'test'
	-- }
		local content = nil
		if updateInfo.Reward then 
			content = tostring(updateInfo.type) .. ";" .. tostring(updateInfo.Reward.itemId) .. ";" .. tostring(updateInfo.Reward.num)
		else
			content = tostring(updateInfo.type)
		end
		print(key .. '  ' .. content)

		CCUserDefault:sharedUserDefault():setStringForKey(key,content)

	end
end

function NewVersionUtil:readCacheUpdateInfo()

	local key = "game.updateInfo" .. "." .. ResourceLoader.getCurVersion() .. "." .. _G.bundleVersion
	print(key)
	local cacheUpdateInfo = CCUserDefault:sharedUserDefault():getStringForKey(key)

	if cacheUpdateInfo and cacheUpdateInfo ~= "" then 
		local t = cacheUpdateInfo:split(';')
		if #t ~= 3 and #t ~= 1 then
			return 
		end

		local updateInfo = { }
		updateInfo.type = tonumber(t[1])

		if #t == 3 then 
			updateInfo.Reward = {}
			updateInfo.Reward.itemId = tonumber(t[2])
			updateInfo.Reward.num = tonumber(t[3])
		end
		updateInfo.tips = CCUserDefault:sharedUserDefault():getStringForKey("game.updateInfo.tips")
		
		UserManager.getInstance().updateInfo = updateInfo

	end
	
end

function NewVersionUtil:showUnlockCloudTip( level  )
	-- body
	if level > 0 then
		local tip = Localization:getInstance():getText("sj.update.finish.unlock")
		local function yesCallback( ... )
			-- body
			local function onSendUnlockMsgSuccess( ... )
				-- body
				local user =  UserService:getInstance().user
				local minLevelId = user:getTopLevelId() + 1
				user:setTopLevelId(minLevelId)
				local lockedClouds = HomeScene:sharedInstance().worldScene.lockedClouds
				for k, v in pairs(lockedClouds) do 
					if v.id == level then
						v:unlockCloud()
					end
				end
			end
			local logic = UnlockLevelAreaLogic:create(level)
			logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
			logic:start(UnlockLevelAreaLogicUnlockType.USE_DOWN_NEW_APK, {})
		end
		local text = {
			tip = Localization:getInstance():getText("sj.update.finish.unlock"),
			yes = Localization:getInstance():getText("button.ok"),
		}
		CommonTipWithBtn:showTip(text, "positive", yesCallback, nil, nil, true)
	end
end


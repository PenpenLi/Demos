
ToPlatformPayCommand=class(Command);

function ToPlatformPayCommand:ctor()
	self.class=ToPlatformPayCommand;
end

function ToPlatformPayCommand:execute(notification)

	-- sharedTextAnimateReward():animateStartByString("充值暂未开放");
	if GameData.limitedClickCount > 0 then
		sharedTextAnimateReward():animateStartByString("操作频繁");
		return
	end

	GameData.limitedClickCount = 1

	local loopFunction
	local function localFun()
		if loopFunction then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
		end

		GameData.limitedClickCount = 0
	end

	loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 1, false)	
	
	local dataTable = notification.data
	log("---------ToPlatformPayCommand====")
	local userProxy = self:retrieveProxy(UserProxy.name)
	local generalListProxy = self:retrieveProxy(GeneralListProxy.name)

	if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN
	or GameData.platFormID == GameConfig.PLATFORM_CODE_WAN 
	or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI
	then
		sharedTextAnimateReward():animateStartByString("暂未开放充值");
	else
		local productID = dataTable.id
		local price = dataTable.rmb
		local productName = dataTable.rmb.."元套餐"
		local userName = userProxy.userName
		local jasonStr = '{"product_id":'..productID..', "product_count":'..dataTable.recharge..', "server_id":'..GameData.ServerId..',"zone_id":'.."1"..',"platform":'..GameData.platFormID..',"role_id":'..userProxy.userId..'}'

		local payStr = productID.."#"..productName.."#"..userName.."#"..price.."#"..jasonStr
		log("payStr=="..payStr)
		platformPay(payStr)
	end
	
end
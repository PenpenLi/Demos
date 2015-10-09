-- gsp interface

local function initGspUtils()
	local platform4Invoke_package_name="com.happyelements.langyabang.Platform4Invoke";
	platformInvoke=luajava.bindClass(platform4Invoke_package_name);
end

-- 是否是新用户
local function userIsNew()
	local passWord4WAN = GameData.local_account;
	if not passWord4WAN or ""==passWord4WAN then
		return true;
	end
	return false;
end

-- 官方登录
local function lanLogin()
	
	hecDC(2,30)

	if userIsNew() then
		local use_key = MetaInfo:getInstance():getMacAddress() .. os.time();
		saveLocalInfo("account",use_key)
		saveLocalInfo("passWord","0")
	end

	GameData.userAccount = GameData.local_account .. "#" .. "0";
	GameData.userPassword = GameData.local_passWord;
	
	Facade.getInstance():sendNotification(PreloadSceneNotification.new(PreloadSceneNotifications.SERVER_COMMAND));

	local loopFunction
	local function localFun()

		if loopFunction then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
		end

		Director:sharedDirector():replaceScene(gamestartPreloadingMeidator:getViewComponent());
	end

	loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0, false)

end

-- login
function login()
	log("GameData.platFormID====="..GameData.platFormID)
	if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
		if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN then -- 研发版
			lanLogin()
		elseif GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then --官方android
			initGspUtils()
			officalLogin()
		elseif GameData.platFormID == GameConfig.PLATFORM_CODE_360 then --360
			initGspUtils()
			if GameData.connectType == 0 then
				platformInvoke:platformLogin()
			end
		else  -- 其他的Android
			initGspUtils()
			platformInvoke:platformLogin()			
		end
	elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then
		
		if not platformInvoke then platformInvoke = PlatformUtil(); end

		if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE 
		or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_BASE
		or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI
		then -- 官方IOS
			officalLogin();
		else -- 其他ios 越狱平台统一走一个接口
			platformInvoke:loginIn();
		end		
	else
		lanLogin()
	end	
end

-- login success
function loginSuccess(userID,session,userName)

	if GameData.platFormID == GameConfig.PLATFORM_CODE_IQIYI then
		local tokenTable = StringUtils:lua_string_split(session,"|");
		if tokenTable[1] and tokenTable[2] then
			GameData.userAccount = userID .. "#" .. tokenTable[1] .. "#" .. tokenTable[2]
		end
	elseif GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO  then
		local tokenTable = StringUtils:lua_string_split(session,"&");
		if tokenTable[1] and tokenTable[2] then
			local tokenTable1 = StringUtils:lua_string_split(tokenTable[1],"=");
			local tokenTable2 = StringUtils:lua_string_split(tokenTable[2],"=");
			GameData.userAccount = userID .. "#" .. tokenTable1[2] .. "#" .. tokenTable2[2]
		end		
	else
		GameData.userAccount = userID .. "#" .. session
	end

	log("GameData.userAccount ======== "..GameData.userAccount)

	
	hecDC(2,30)

	deLogin(GameData.userAccount)
	deSetAccountType(GameData.platFormID)

	Facade.getInstance():sendNotification(PreloadSceneNotification.new(PreloadSceneNotifications.SERVER_COMMAND));	

	local loopFunction
	local function localFun()

		if loopFunction then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
		end

		Director:sharedDirector():replaceScene(gamestartPreloadingMeidator:getViewComponent());

	end

	loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0, false)

end

-- login faile
function loginFaile()
	log("loginFaile------0")
	local function closeGame()
		Director:sharedDirector():endGame();
	end 
	
	local function tryConnect()
		login();
	end

	if GameData.reLoginCount > 1 then 
		local textTable = {}
		textTable[1] = "重试";
		textTable[2] = "退出";
		local tips = CommonPopup.new();
		tips:initialize("登录失败,请重试",self,tryConnect,nil,closeGame,nil,nil,textTable,false,true,3);
		
		Director:sharedDirector():replaceScene(gamestartPreloadingMeidator:getViewComponent());

		local loopFunction
		local function localFun()
			
			GameData.reLoginCount = 0

			if loopFunction then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
			end

			local scene = Director.sharedDirector():getRunningScene();	
			if scene then
				scene:addChild(tips);
			end	
		end

		loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0, false)

	else

		log("reloginTimer------0")
		
		GameData.reLoginCount = GameData.reLoginCount + 1
		
		log("GameData.reLoginCount=="..GameData.reLoginCount)

		local reloginTimer
		local function reloginFunc()
			if reloginTimer then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(reloginTimer)
			end			
			tryConnect()
		end

		reloginTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(reloginFunc, 1, false)	

	end
end

-- logout
function logout()

	if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
		if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN
		or GameData.platFormID == GameConfig.PLATFORM_CODE_WAN
		then -- 研发版
			logoutSuccess(GameConfig.CONNECT_TYPE_2)
		elseif GameData.platFormID == GameConfig.PLATFORM_CODE_360 then	-- 360
			platformInvoke:platformLogout()
			logoutSuccess(GameConfig.CONNECT_TYPE_2)
		else  -- 其他的
			platformInvoke:platformLogout()
		end
	elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then

		if not platformInvoke then platformInvoke = PlatformUtil(); end

		if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE 
		or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_BASE
		or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI
		then -- 官方IOS和测试版
			logoutSuccess(GameConfig.CONNECT_TYPE_2)
		else -- 其他统一走一个接口
			platformInvoke:loginOut();
		end		
	else
		logoutSuccess(GameConfig.CONNECT_TYPE_2)
	end	
end

-- logoutSuccess
function logoutSuccess(connectType)
	log("---logoutSuccess")

	deLogout()

	if connectType == nil  then
		connectType = GameConfig.CONNECT_TYPE_2
	end

	-- 清理mvc		
	gameStart:stop()
	-- 清理全局性的数据

	if gameSceneIns then

		if gameSceneIns.parent then
			gameSceneIns.parent:removeChild(gameSceneIns);
		end
	end

	gameSceneIns = nil
	GameVar:dispose()

	if  BetterEquipManager then
		BetterEquipManager.betterEquips={}
	end

	if ParticleSystem then 
		ParticleSystem:dispose()
	end

	if ScreenShake then
		ScreenShake:dispose()
	end
	if ScreenScale then
		ScreenScale:dispose()
	end
	local scene = Director.sharedDirector():getRunningScene();
	if scene then
		if scene.name == GameConfig.MAIN_SCENE then
			if sharedMainLayerManager() then
				sharedMainLayerManager():disposeMainLayerManager()
			end
		elseif scene.name == GameConfig.BATTLE_SCENE then
			if sharedBattleLayerManager() then
				sharedBattleLayerManager():disposeBattleLayerManager()
			end
		end
		if sharedTextAnimateReward() then
			sharedTextAnimateReward():disposeTextAnimateReward()
		end		
	end

	disposeAllScheduler()

	GameData.connectType = connectType
	
	GameData.isConnect = false

	GameData.clickRedDotArr = {};
	GameData.hasRedDotArr = {};
	
	BitmapCacher:dispose()

	package.loaded["RunGame"] = nil
	local loaded = require ("RunGame");
	if loaded then
	  RunGameStart();
	end		
end

-- logoutFaile
function logoutFaile()
	sharedTextAnimateReward():animateStartByString("注销失败");
end

-- pay
function platformPay(param)
	local data=StringUtils:lua_string_split(param,"#");
	local productID = data[1]
	local productName = data[2]
	local userName = data[3]
	local price = tonumber(data[4])
	local appUserID = GameData.platFormUserId .. "#" .. GameData.ServerId
	local jasonStr = data[5]

	GameData.payPrice = price

	if GameData.platFormID == GameConfig.PLATFORM_CODE_MI then
		platformInvoke:callPay(productID,productName,price,userName,appUserID,GameData.serverName,jasonStr);
	else
		platformInvoke:callPay(productID,productName,price,userName,appUserID,jasonStr);
	end

end

-- pay result
function paySuccess(orderId)
	log("------paySuccess")
	if GameData.platFormID ~= GameConfig.PLATFORM_CODE_UC then
		sharedTextAnimateReward():animateStartByString("支付成功");
	end

	dePaymentSuccess(orderId.."","",tonumber(GameData.payPrice),"CNY","平台支付SDK")
end

function payFaile()
	log("------payFaile")
	sharedTextAnimateReward():animateStartByString("支付失败");
end

function payAbort(orderId)
	log("------payAbort")
	sharedTextAnimateReward():animateStartByString("取消支付");
end

function payPending(orderId)
	log("$$$$$$$$$--payPending==="..orderId)
end

-- jira
function callJira()
	platformInvoke:callJira()
end

-- setGameUserIdForGSP
function setGameUserIdForGSP(userId)
	log("gsputil--1-"..userId)
	platformInvoke:setGameUserIdForGSP(userId)
	log("gsputil--2-"..userId)
end
--新手完成成就调用
function recordAchievement()
	if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then
		platformInvoke:recordAchievement();
	end
end
--GameCenter玩家等级提交
function recordScore(level)
	if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then
		platformInvoke:recordScore(level);
	end
end

function bindInviteCodeSuccess(statusCode, responseData)
	uninitializeSmallLoading();

	local JSON1 = require("core.net.JSON");
	local jsonData = JSON1:decode(responseData);
	local returnFlag = tonumber(jsonData.code)
	log("returnFlag====="..returnFlag)
	if 0 == returnFlag then
		if inputTips then
			inputTips.parent:removeChild(inputTips)
		end		
		sharedTextAnimateReward():animateStartByString("验证成功!");
		Handler_2_11.new():sendTo2_1(GameData.platFormID,GameData.ServerId);
	elseif returnFlag == 15 then
		sharedTextAnimateReward():animateStartByString("激活码不存在!");
	elseif returnFlag == 16 then
		sharedTextAnimateReward():animateStartByString("激活码已经被使用!");
	end
end
function bindInviteCodeError()
	uninitializeSmallLoading();
	sharedTextAnimateReward():animateStartByString("邀请码验证错误!");
end

-- 目前只是360 uc iqiyi 返回登陆
function exitGame()
	platformInvoke:platformExit();
end

-- -- 退出游戏
-- function endGame()
-- 	Director:sharedDirector():endGame();
-- end

-- String severId,String roleId,String roleName,String roleLevel,String zoneId,String zoneName,String extendString
function platformCreateRole(severId,roleId,roleName,roleLevel)

	if not platformInvoke then
		log("platformInvoke == nil")
		return
	end

	log("GameData.platFormID=="..GameData.platFormID)
	if GameData.platFormID == GameConfig.PLATFORM_CODE_IQIYI then
		log("platformCreateRole--severId,roleId,roleName,roleLevel=1=" .. severId .."--".. roleId .."--".. roleName .."--".. roleLevel)
		platformInvoke:platformCreateRole(severId .. "",roleId .. "",roleName .. "",roleLevel .. "");
		log("platformCreateRole--severId,roleId,roleName,roleLevel=2=" .. severId .."--".. roleId .."--".. roleName .."--".. roleLevel)
	end
	
end

-- String severId,String roleId,String roleName,String roleLevel,String zoneId,String zoneName,String extendString
function platformEnterGame(severId,roleId,roleName,roleLevel)
	
	if not platformInvoke then
	log("platformInvoke == nil")
		return
	end

	log("GameData.platFormID=="..GameData.platFormID)
	if GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO 
	or GameData.platFormID == GameConfig.PLATFORM_CODE_IQIYI
	or GameData.platFormID == GameConfig.PLATFORM_CODE_YJ
	then
		log("platformEnterGame -- severId,roleId,roleName,roleLevel=1=" .. severId .."--".. roleId .."--".. roleName .."--".. roleLevel)
		platformInvoke:platformEnterGame(severId .. "",roleId .. "",roleName .. "",roleLevel .. "");
		log("platformEnterGame -- severId,roleId,roleName,roleLevel=2=" .. severId .."--".. roleId .."--".. roleName .."--".. roleLevel)
	end
end
-- --  取得所在大区编号
-- function getZoneId()
-- 	if  GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then -- 1区
-- 		return 1
-- 	elseif  GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_HUAWEI
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_ZZ
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_VIVO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_LENOVO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_JINLI
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_COOLPAD
-- 	then
-- 		return 2
-- 	elseif  GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_HUAWEI
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_ZZ
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_VIVO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_LENOVO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_JINLI
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_COOLPAD
-- 	then
-- 		return 3
-- 	elseif  GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_HUAWEI
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_ZZ
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_VIVO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_LENOVO
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_JINLI
-- 		 or GameData.platFormID == GameConfig.PLATFORM_CODE_COOLPAD
-- 	then
-- 		return 4			
-- 	end
-- end


------------------------- dataeye interface   -------------------------
local function isDataEyeDCPlat()
	
	if  GameData.platFormID == GameConfig.PLATFORM_CODE_360
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_HUAWEI
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_ZZ
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_VIVO
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_LENOVO
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_JINLI
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_COOLPAD
		then
		return true
	else
		return false
	end

end

function deLogin(userID)
	if isDataEyeDCPlat() then
		platformInvoke:dataeyeLogin(userID);
	end
end

function deLogout()
	if isDataEyeDCPlat() then
		platformInvoke:dataeyeLogout();	
	end
end
function deSetAccountType(userType)
	if isDataEyeDCPlat() then
		platformInvoke:setAccountType(tonumber(userType));
	end
end
function deSetGender(gender)
	if isDataEyeDCPlat() then
		platformInvoke:setGender(gender);
	end
end
function deSetAge(age)
	if isDataEyeDCPlat() then
		platformInvoke:setAge(age);
	end
end
function deSetGameServer(server)
	if isDataEyeDCPlat() then
		platformInvoke:setGameServer(server);
	end	
end
function deSetLevel(level)
	if isDataEyeDCPlat() then
		platformInvoke:setLevel(level);
	end	
end
function deAddTag(tag,subTag)
	if isDataEyeDCPlat() then
		platformInvoke:addTag(tag,subTag);
	end
end
function deRemoveTag(tag,subTag)
	if isDataEyeDCPlat() then
		platformInvoke:removeTag(tag,subTag);
	end
end
function dePaymentSuccess(orderId,iapId,currencyAmount,currencyType ,paymentType)
	if isDataEyeDCPlat() then
		platformInvoke:paymentSuccess(orderId,iapId,currencyAmount,currencyType ,paymentType);
	end
end
------------------------- dataeye interface   -------------------------
recvTable = {}
sendTable = {}
function myadd(x, y)
    return x + y
end
local tryCount = 0;
local receive3_32ScheID=nil;
function sendMessage(mainCommand, subCommand, messTable)
	
	if GameData.isConnect then
		sendTable = messTable;
		sendLuaTable(mainCommand, subCommand);
		return true
	end
	log("GameData.is not Connect")
	return false

end

function recvMessage(mainCommand, subCommand)
	localTime = CommonUtils:getOSTime();
	GameData.heartHitCount = 0;
	hasHit = false;

	if (mainCommand > 10000) then
		mainCommand = 100 + mainCommand % 10000
	else
		mainCommand = mainCommand % 1000
	end
	local commandName = "main.controller.handler.Handler_" .. mainCommand .. "_" .. subCommand;
	-- log("commandName=="..commandName)
	if commandName ~= "main.controller.handler.Handler_7_9" then
		package.loaded[commandName] = nil
		require(commandName);
	end
end

function connectTo(ip, port, bma, uouttime)
	
	
	return connectSocket(ip, port,false);
end

local localTime = 0
local heartHitFunctionID = nil;

local function heartHitBack()

	log("zhangke ---- 5")

	local scene = Director.sharedDirector():getRunningScene();
	-- 客户端演算不需要加菊花
	local battleProxy = Facade.getInstance():retrieveProxy(BattleProxy.name)
	if scene.name and scene.name == GameConfig.BATTLE_SCENE and battleProxy:isClietCalculate() then
		log("test--1")
	else
		log("test--2")
		initializeSmallLoading(SmallLoadingConifg.TYPE_2);
		log("test--3")
	end

	local connectBoo = connectTo(GameData.serverAdd,8081);

	if connectBoo then 
		log("zhangke ---- 6")
		tryCount = 0;
	    GameData.isConnect = true		

		if nil ~= heartHitFunctionID then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(heartHitFunctionID);
			heartHitFunctionID = nil;
		end
		
		if GameData.userID and GameData.userID ~= "" then
			sendMessage(2,14,{UserId=GameData.userID});	
				
		end

		if scene then
			if scene.name == GameConfig.MAIN_SCENE then
				-- if userProxy.sceneType == GameConfig.SCENE_TYPE_2 and userProxy.state == GameConfig.STATE_TYPE_2 then
				-- 	sendMessage(3, 38, {UserId=userProxy:getUserID()})
				-- end
				if FamilyNotification then
					Facade.getInstance():sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_CLOSE));
				end
				if HeroHouseNotification then
					Facade.getInstance():sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROTEAMSUB_CLOSE));
				end
			elseif scene.name == GameConfig.BATTLE_SCENE then
			   local battleProxy = Facade.getInstance():retrieveProxy(BattleProxy.name)
			   if not battleProxy:isClietCalculate() then -- 服务器端演算的话
			   		sendMessage(3, 39, {UserId=GameData.userID, BattleId = battleProxy.battleId})
			   end 
			else
				log("---- scene name is not main and battle");
			end
		else
			log("---- scene is nil");
		end

		cleanTag();
	else
		tryCount = tryCount + 1;
		log("zhangke ---- 7")
		if tryCount >= 3 then
			-- 关闭游戏
			local function closeGame()
				Director:sharedDirector():endGame();
			end 

			log("zhangke ---- 8")
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(heartHitFunctionID);  
			uninitializeSmallLoading();

			local textTable = {}
			textTable[1] = "重连";
			textTable[2] = "退出";
			local tips=CommonPopup.new();
			tips:initialize("亲！网络不好哦，换个地方试试?",self,tryConnect,nil,closeGame,nil,nil,textTable,nil,true,3);
			log("zhangke ---- 1")
			commonAddToScene(tips, true)

			cleanTag();
		end
	end
end
function cleanTag()
	if StrengthenProxy then
        local strengthenProxy = Facade.getInstance():retrieveProxy(StrengthenProxy.name);
        if strengthenProxy then
	        strengthenProxy.Qianghua_Bool = nil;
	        strengthenProxy.Dazao_Bool = nil;
	        strengthenProxy.Xi_Lian = nil;
	    end
    end

    if HeroHouseProxy then
        local heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
        if heroHouseProxy then
	        heroHouseProxy.Jinengshengji_Bool = nil;
	        heroHouseProxy.Shengji_Bool = nil;

	        heroHouseProxy.Shengxing_Bool = nil;
	        heroHouseProxy.Jinjie_Bool = nil;

	        heroHouseProxy.Yuanfen_Jinjie_Bool = nil;
	    end
    end
end
-- function removeReceive3_32ScheID()
-- 	if receive3_32ScheID then
-- 		Director:sharedDirector():getScheduler():unscheduleScriptEntry(receive3_32ScheID);
-- 		receive3_32ScheID=nil;
-- 	end
-- end
function tryConnect()
	tryCount = 0;
	heartHitBack();

	if not GameData.isConnect then
		log("zhangke ---- 9")
		heartHitFunctionID = Director:sharedDirector():getScheduler():scheduleScriptFunc(heartHitBack, 3, false)	
	end
end
local localTrytoConnectId = nil;
function ExitSocketFunction()

	log("ExitSocketFunction")

	-- 通讯中断时的逻辑处理
	require "main.controller.command.common.SocketCloseCommand";
	SocketCloseCommand.new():execute()


	if GameData.isConnect and not GameData.isConnecting then
		GameData.isConnect = false			
		GameData.isConnecting = true
		if GameData.userID and GameData.userID ~= "" then
			local function localTrytoConnect()
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(localTrytoConnectId);
				tryConnect()
			end
			localTrytoConnectId=Director:sharedDirector():getScheduler():scheduleScriptFunc(localTrytoConnect, 0.5, false);
			
		else
			logoutSuccess(GameConfig.CONNECT_TYPE_0)
		end
	else
		log("GameData.isConnect Exception")
		if GameData.isConnect then
			log("GameData.isConnect is true")
		else
			log("GameData.isConnect is false")
		end
		if GameData.isConnecting then
			log("GameData.isConnecting is true")
		else
			log("GameData.isConnecting is false")
		end
		-- logoutSuccess(GameConfig.CONNECT_TYPE_0)
	end
end

function sendFirstMessageToServer()
	require "core.utils.StringUtils";

	hecDC(2,40)

	if GameData.userPassword == "" then
		GameData.userPassword = 0
	end

	log("--------sendMessage(2,11)")
	log("GameData.platFormID=" .. GameData.platFormID)
	log("GameData.userAccount=".. GameData.userAccount)
	log("GameData.userPassword=".. GameData.userPassword)

	local platFormType = "none"
	local platFormID = getPlatformID4DC()
	if platFormID == GameConfig.PLATFORM_CODE_LAN then 
		platFormType = "lan_test"
	elseif platFormID == GameConfig.PLATFORM_CODE_WAN then 
		platFormType = "he"
	elseif platFormID == GameConfig.PLATFORM_CODE_MI then 
		platFormType = "xiaomi"
	elseif platFormID == GameConfig.PLATFORM_CODE_360 then 
		platFormType = "360"
	elseif platFormID == GameConfig.PLATFORM_CODE_UC then 
		platFormType = "uc"
	elseif platFormID == GameConfig.PLATFORM_CODE_BAIDU then 
		platFormType = "baidu"
	elseif platFormID == GameConfig.PLATFORM_CODE_HUAWEI then 
		platFormType = "huawei"
	elseif platFormID == GameConfig.PLATFORM_CODE_OPPO then 
		platFormType = "oppo"
	elseif platFormID == GameConfig.PLATFORM_CODE_IQIYI then 
		platFormType = "pps"
	elseif platFormID == GameConfig.PLATFORM_CODE_YINGYONGBAO then 
		platFormType = "yingyongbao"				
	elseif platFormID == GameConfig.PLATFORM_CODE_ZZ then 
		platFormType = "zhangzong"
	elseif platFormID == GameConfig.PLATFORM_CODE_YJ then 
		platFormType = "yijie"
	elseif platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then 	   
		platFormType = "apple"
	elseif platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI then		
	    platFormType = "he"	 

	elseif platFormID == GameConfig.PLATFORM_CODE_VIVO then		
	    platFormType = "vivo"	 
	elseif platFormID == GameConfig.PLATFORM_CODE_LENOVO then		
	    platFormType = "lenovo"	 
	elseif platFormID == GameConfig.PLATFORM_CODE_JINLI then		
	    platFormType = "jinli"	 
	elseif platFormID == GameConfig.PLATFORM_CODE_COOLPAD then		
	    platFormType = "coolpad"	 	    	    	    	    


	end

	local dcParamStr =  "install_key="..GameData.install_key
	                .."&mac="..GameData.mac
	                .."&udid="..GameData.udid
	                .."&gameversion="..clientgameVersion
	                .."&clienttype="..GameData.clienttype
	                .."&clientversion="..GameData.clientversion
	                .."&channel_id="..""
	                .."&networktype="..GameData.networktype
	                .."&clientpixel="..GameData.clientpixel
	                .."&serial_number="..GameData.serial_number
	                .."&android_id="..GameData.android_id
	                .."&google_aid="..GameData.google_aid                    
	                .."&location=".."cn"
	                .."&src="..platFormType
	                .."&equipment="..GameData.equipment
	                .."&carrier="..GameData.carrier
	                .."&idfa="..GameData.idfa
	                .."&simulator="..GameData.simulator
	                .."&WifiMac="..GameData.wifiMac
	                .."&BootTime="..GameData.kernelTaskStartTime

	log("DCParamStr="..dcParamStr)

	sendMessage(2,11,{PlatformId = GameData.platFormID,
					  Key = GameData.userAccount,
					  Pwd = GameData.userPassword,
					  DCParamStr = dcParamStr});
end


require "core.controls.CommonPopup"
require "core.utils.StringUtils"
require "core.utils.CommonUtil"
require "core.controls.CommonSmallLoading"

local bIsInAction = false;
local platform4Invoke;
local service4WAN;
local platform4Invoke_package_name="com.happyelements.xiawang.Platform4Invoke";

local s_bind=GameConfig.HTTP_IP .. "bind?";
--注册
local s_sign=GameConfig.HTTP_IP .. "register?";
--修改密码
local s_pwd_change=GameConfig.HTTP_IP .. "reset?";
--帐号创建
local s_account_transform=GameConfig.HTTP_IP .. "createaccount?";

local function get_s_bind(key, account, pwd)
	log("1:" .. key);
	log("2:" .. account);
	log("3:" .. pwd);
	return s_bind .. "key=" .. key .. "&account=" .. account .. "&pwd=" .. pwd .."&sig=" .. getMD5();
end
local function get_s_sign(account, pwd)
	-- log("1:" .. key);
	log("2:" .. account);
	log("3:" .. pwd);
	-- log("4:" .. pwd2);
	return s_sign .. "&account=" .. account .. "&pwd=" .. pwd .."&sig=" .. getMD5();
end
local function get_s_pwd_change(account, pwd, pwd2)
	log("1:" .. account);
	log("2:" .. pwd);
	log("3:" .. pwd2);
	return s_pwd_change .. "account=" .. account .. "&pwd=" .. pwd .. "&pwd2=" .. pwd2 .."&sig=" .. getMD5();
end
local function get_account_transform(account)
	-- log("1:" .. key);
	log("2:" .. account);
	-- log("3:" .. pwd);
	return s_account_transform .. "&account=" .. account .."&sig=" .. getMD5();
end

local function onWANRefreshInfo(statusCode, responseData, call)
  log("---------------------onWANRefreshInfo--------------------");
  uninitializeSmallLoading();
  if 200~=statusCode or not responseData or ""==responseData then
	onWANHTTPError();
	return;
  end
  log(responseData);
  local JSON = require("core.net.JSON");
  local data = JSON:decode(responseData);
  if 0==tonumber(data.code) then
  	saveLocalInfo("account",data.account);
  	saveLocalInfo("passWord",data.pwd);
  	
	GameData.userAccount = data.account;
	GameData.userPassword = data.pwd;
	call();

	-- local function account_transform_success(statusCode1, responseData1)
	-- 	uninitializeSmallLoading();
	-- 	if 200~=statusCode1 or not responseData1 or ""==responseData1 then
	-- 		onWANHTTPError();
	-- 		WANLoginFail();
	-- 		return;
 --  		end
 --  		log(responseData1);
 --  		local JSON1 = require("core.net.JSON");
 --  		local data1 = JSON1:decode(responseData1);
 --  		if 0 == tonumber(data1.code) then
 --  			GameData.userAccount = data1.account  .. "#" .. "0";
	-- 		GameData.userPassword = data1.pwd;
	-- 		call();
 --  		else
 --  			WANPopSharedTextAnimateReward(tonumber(data1.code));
 --  			Facade.getInstance():retrieveMediator(OfficialServerMediator.name):onWanError();
 --  			WANLoginFail();
 --  		end
 --  		WANDisposeService();
	-- end
	WANDisposeService();
	-- WANAccountTransform(account_transform_success);
  else
  	WANPopSharedTextAnimateReward(tonumber(data.code));
  	Facade.getInstance():retrieveMediator(OfficialServerMediator.name):onWanError();
  	WANDisposeService();
  end
end

function WANAccountTransform(onSuccessCall, account)
	local user_account="0";
	local pwd="0";
	local str="";

	user_account = GameData.local_account;
	pwd = GameData.local_passWord;

	str = get_account_transform(user_account,pwd);

  	service4WAN = HttpService.new();
  	log(str);
  	service4WAN:setUrl(str);
  	service4WAN:setResponseCallback(onSuccessCall);
  	service4WAN:setErrorCallback(onWANHTTPError);
  	service4WAN:send();
  	initializeSmallLoading();
end

--lUid uid
--sSessionId sessionId
--登录成功
function WANLoginSucc()
	local function account_transform_success(statusCode1, responseData1)
		uninitializeSmallLoading();
		if 200~=statusCode1 or not responseData1 or ""==responseData1 then
			onWANHTTPError();
			WANLoginFail();
			return;
  		end
  		log(responseData1);
  		local JSON1 = require("core.net.JSON");
  		local data1 = JSON1:decode(responseData1);
  		if 0==tonumber(data1.code) then
			
			Facade.getInstance():sendNotification(PreloadSceneNotification.new(PreloadSceneNotifications.SERVER_COMMAND));

			local loopFunction
			local function localFun()

				if loopFunction then
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
				end

				Director:sharedDirector():replaceScene(gamestartPreloadingMeidator:getViewComponent());

			end

			loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0, false)
				
  		else
  			WANPopSharedTextAnimateReward(tonumber(data1.code));
  			-- Facade.getInstance():retrieveMediator(OfficialServerMediator.name):onWanError();
  			WANLoginFail();
  		end
  		WANDisposeService();
	end
	WANDisposeService();
	WANAccountTransform(account_transform_success);	
end

--登录失败
function WANLoginFail()
	--bIsInAction = false;
	local function closeGame()
		Director:sharedDirector():endGame();
	end 
	
	local function tryConnect()
		WANLogin();
	end
	local textTable = {}
	textTable[1] = "重连";
	textTable[2] = "退出";
	local tips=CommonPopup.new();
	tips:initialize("登录失败,是否退出游戏?",self,tryConnect,nil,closeGame,nil,nil,textTable);

	local scene = Director.sharedDirector():getRunningScene();	
	if scene then
		scene:addChild(tips);
	end
end

--登录官方版
function officalLogin()
	log("---------------------WANLogin--------------------");
	
	hecDC(2,30)

	if WANGetIsNew() then


		if GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI then
			hecDC(7)
		end
			
		local userkey = GameData.udid --MetaInfo:getInstance():getMacAddress() .. os.time();

		GameData.userAccount = userkey;
		GameData.userPassword = "0";

		saveLocalInfo("account",userkey)
		saveLocalInfo("passWord","0")

		WANLoginSucc();
	else
		GameData.userAccount = GameData.local_account;
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
end

--绑定
function onWANBindAccountCall(statusCode, responseData)
	local function call()
		sharedTextAnimateReward():animateStartByString("绑定成功~");
		Facade.getInstance():retrieveMediator(OfficialServerMediator.name):refreshBindComplete();
	end
	onWANRefreshInfo(statusCode,responseData,call);
end

function WANBindAccount(account, pwd)
	local str=get_s_bind(GameData.local_account,account,pwd);

  	service4WAN = HttpService.new();
  	service4WAN:setUrl(str);
  	service4WAN:setResponseCallback(onWANBindAccountCall);
  	service4WAN:setErrorCallback(onWANHTTPError);
  	service4WAN:send();
  	initializeSmallLoading();
end

-- function onWANCheckAccountCall(statusCode, responseData)
-- 	local function call()
-- 		Facade.getInstance():retrieveMediator(OfficialServerMediator.name):refreshCheckAccountComplete();
-- 	end
-- 	onWANRefreshInfo(statusCode,responseData,call);
-- end

function saveAccount(account, pwd)
  	saveLocalInfo("account",account);
  	saveLocalInfo("passWord",pwd);
	GameData.userAccount = account;
	GameData.userPassword = pwd;  	
end

function onWANChangePWDCall(statusCode, responseData)
	local function call()
		sharedTextAnimateReward():animateStartByString("修改密码成功~");
		Facade.getInstance():retrieveMediator(OfficialServerMediator.name):refreshChangeComplete();
	end
	onWANRefreshInfo(statusCode,responseData,call);
end

function WANChangePWD(pwd, pwd2)
	local str=get_s_pwd_change(GameData.local_account,pwd,pwd2);

  	service4WAN = HttpService.new();
  	service4WAN:setUrl(str);
  	service4WAN:setResponseCallback(onWANChangePWDCall);
  	service4WAN:setErrorCallback(onWANHTTPError);
  	service4WAN:send();
  	initializeSmallLoading();
end

function onWANSignCall(statusCode, responseData)
	local function call()
		sharedTextAnimateReward():animateStartByString("注册帐号成功~");
		Facade.getInstance():retrieveMediator(OfficialServerMediator.name):refreshSignComplete();
	end
	onWANRefreshInfo(statusCode,responseData,call);
end

function WANSign(account, pwd, pwd2)
	-- local use_key=MetaInfo:getInstance():getMacAddress() .. os.time();
	local str=get_s_sign(account,pwd);
	
	-- saveLocalInfo("key",use_key);
	-- GameData.userKey = use_key;

  	service4WAN = HttpService.new();
  	service4WAN:setUrl(str);
  	service4WAN:setResponseCallback(onWANSignCall);
  	service4WAN:setErrorCallback(onWANHTTPError);
  	service4WAN:send();
  	initializeSmallLoading();
end

function onWANHTTPError()
	uninitializeSmallLoading();
	if service4WAN then
  		service4WAN:dispose();
  		service4WAN=nil;
  	end
	sharedTextAnimateReward():animateStartByString("服务器连接失败，请稍后重试！");
end

function WANPopSharedTextAnimateReward(code)
	local error_s={ "key错误~",
  				    "账号不存在~",
  				    "账号已经绑定过了~",
  				    "原密码不能为空~",
  				    "密码不能为空~",
  				    "当前密码，新密码一样~",
  				    "账号空~",
  				    "2次密码不一致~",
  				    "key已经存在~",
  				    "此账号已经被注册过了~",
  				    "出错了~",
  				    "当前密码错误~",
  				    "验证不过",
  				    "账号错误",
  				    "激活码不存在",
  				    "激活码已经被使用",
				    "该账号已绑定过验证码",
				    "账号格式不对",
				    "密码格式不对",
					"要绑定的账号不存在",
					};

  	if error_s[tonumber(code)] then
  		sharedTextAnimateReward():animateStartByString(error_s[tonumber(code)]);
  	else
  		sharedTextAnimateReward():animateStartByString(tonumber(code));
  	end
end

function WANDisposeService()
  if service4WAN then
  	service4WAN:dispose();
  	service4WAN=nil;
  end
end

-- 判断是否绑定过
function WANGetHasValidAccount()
	local passWord = GameData.local_passWord;
	log("passWord======"..passWord)
	if passWord == "0" then
		return false
	end
	return true
end

-- 根据是否存在本地文件判断是否是新号
function WANGetIsNew()
	local account = GameData.local_account;
	local password = GameData.local_passWord;

	if account == nil or account == "" 
	or password == nil or password == "" then
		return true;
	end
	return false;
end

function WANCallGM()
	platform4Invoke:callNewVersionJira();
end

function SetPlatform4InvokePackageName(packageName)
	platform4Invoke_package_name=packageName;
end

-- 设备平台常量
CC_PLATFORM_IOS  = 1
CC_PLATFORM_ANDROID =2
CC_PLATFORM_WIN32 = 3
-- CC_PLATFORM_MARMALADE  = 4
-- CC_PLATFORM_LINUX  =  5
-- CC_PLATFORM_BADA   =   6
-- CC_PLATFORM_BLACKBERRY =  7
-- CC_PLATFORM_MAC  = 8

------------------------------------------------------------

-- 发行平台常量
-- 1 内网开发
-- 2 外网/官方
-- 3 小米
-- 4 360
-- 5 UC
-- 6 91
-- 7 oppo
-- 8 百度
-- 9 豌豆荚
-- 11 google

-- 100 apple
-- 101 91越狱
-- 102 xy越狱
-- 103 ios debug
-- 104 ky越狱
PlatformConfig = {

  -- 平台编号
  -- android
  -- 0  self debug
  -- 1  lan
  -- 2  0--wan/ 1--official/ 2--android test
  -- 3  xiaomi
  -- 4  360
  -- 5  uc
  -- 6  baidu
  -- 7  huawei
  -- 8  oppo
  -- 9  iqiyi
  -- 10 yingyongbao
  -- 11 zhangzong
  -- 12 易接
  -- 13 vivo
  -- 14 联想
  -- 15 金立
  -- 16 酷派   
    
  PLATFORM_CODE_DEBUG = "0";
  PLATFORM_CODE_LAN = "1";
  PLATFORM_CODE_WAN = "2";
  PLATFORM_CODE_MI = "3";
  PLATFORM_CODE_360 = "4";
  PLATFORM_CODE_UC = "5";
  PLATFORM_CODE_BAIDU = "6";
  PLATFORM_CODE_HUAWEI = "7";
  PLATFORM_CODE_OPPO = "8";
  PLATFORM_CODE_IQIYI = "9"; 
  PLATFORM_CODE_YINGYONGBAO = "10";
  PLATFORM_CODE_ZZ = "11";
  PLATFORM_CODE_YJ = "12";
  PLATFORM_CODE_VIVO = "13";
  PLATFORM_CODE_LENOVO = "14";        
  PLATFORM_CODE_JINLI = "15";
  PLATFORM_CODE_COOLPAD = "16";    

  -- ios
  -- 100 appstore
  -- 101 ios 91
  -- 102 ios xy
  -- 103 ios debug
  -- 104 ios ky
  -- 105 ios tongbutui

  PLATFORM_CODE_IOS_APPLE = "100";
  PLATFORM_CODE_IOS_91 = "101";
  PLATFORM_CODE_IOS_XY = "102";
  PLATFORM_CODE_IOS_BASE = "103";
  PLATFORM_CODE_IOS_KY = "104";
  PLATFORM_CODE_IOS_TONGBUTUI = "105";

  -- lan
  -- LAN_NAME = "lan";
  LAN_PACK_NAME = "com.happyelements.yanhuang";
  LAN_URL = "http://10.130.133.248/langyabang_lan/config_version.xml";

  -- wan chanalid == 0
  WAN_PACK_NAME = "com.happyelements.langyabang";
  WAN_URL = "http://static.yanhuang.happyelements.cn/langyabang_wan/config_version.xml";
  -- qa android chanalid == 2
  QA_URL = "http://10.130.133.248/langyabang_qa_android/config_version.xml";


  -- android officail  chanalid == 1
  HE_URL = "http://10.130.133.248/lyb_official/config_version.xml";  
  XIAOMI_URL = "http://static.yanhuang.happyelements.cn/lyb_mi/config_version.xml";
  QIHOO_URL = "http://static.yanhuang.happyelements.cn/lyb_qihoo/config_version.xml";
  UC_URL = "http://static.yanhuang.happyelements.cn/lyb_uc/config_version.xml";
  BAIDU_URL = "http://static.yanhuang.happyelements.cn/lyb_baidu/config_version.xml";
  HUAWEI_URL = "http://static.yanhuang.happyelements.cn/lyb_huawei/config_version.xml";
  OPPO_URL = "http://static.yanhuang.happyelements.cn/lyb_oppo/config_version.xml";
  IQIYI_URL = "http://static.yanhuang.happyelements.cn/lyb_iqiyi/config_version.xml";
  YINGYONGBAO_URL = "http://10.130.133.248/lyb_yingyongbao/config_version.xml";
  ZZ_URL = "http://static.yanhuang.happyelements.cn/lyb_zz/config_version.xml";
  YJ_URL = "http://10.130.133.248/lyb_yj/config_version.xml";

  VIVO_URL = "http://10.130.133.248/lyb_vivo/config_version.xml";
  LENOVO_URL = "http://10.130.133.248/lyb_lenovo/config_version.xml";
  JINLI_URL = "http://10.130.133.248/lyb_jinli/config_version.xml";
  COOLPAD_URL = "http://10.130.133.248/lyb_coolpad/config_version.xml";

  -- 广告渠道
  IOS_TONGBUTUI_URL = "http://static.yanhuang.happyelements.cn/lyb_ios_tongbutui/config_version.xml";

  -- ios 64
  IOS_APPLE_URL = "http://static.yanhuang.happyelements.cn/lyb_ios_apple/config_version.xml";
  
  -- ios ky 91
  IOS_KY_URL = "http://static.yanhuang.happyelements.cn/branch_ios_ky/config_version.xml";    
};

-- local
local remoteStaticServer = nil;
-- local checkUpdateScriptEntry = nil;
local isMainApplicationInitialized = false;
local xmlSimple = nil;
local button = nil;
local versionCode
local platFormType
local xml = require("xmlSimple").newParser()

-- globel
isLogoFinished = false
clientgameVersion = 1 -- 客户端资源版本
userInfoSaver = nil; --android类UserInfoSaver
kResourceEnvironment = {kDebugLocal = 1, kDebugOnline=2, kReleaseQzone=3};

function getLanguageTranslated(content)
  --  if versionCode == "11"  then
  --   -- if content == "正在用力重连中.." then
  --   --   return "正在用力重連中.."
  --   -- elseif content == "同步资源错误,请检查网络状况后重试.." then
  --   --   return "同步資源錯誤,請檢查網絡狀況後重試.."
  --   -- elseif content == "同步资源错误,点击屏幕重试.." then
  --   --   return "同步資源錯誤,點擊屏幕重試.."
  --   -- elseif content == "文件错误，请重新更新..."  then
  --   --   return "文件錯誤，請重新更新..."
  --   -- elseif content == "更新" then
  --   --   return "更新"
  --   -- elseif content == "退出" then
  --   --   return "退出"
  --   -- elseif content == "主淫,发现有新内容,我们去appStore更新吧?" then
  --   --   return "主淫,發現有新內容,我們去appStore更新吧?"
  --   -- elseif content == "主淫，发现有新内容(" then
  --   --   return "主淫，發現有新內容("
  --   -- elseif content == "M),更新吧?" then
  --   --   return "M),更新吧?"
  --   -- elseif content == "正在检查版本信息，请稍候..." then
  --   --   return "正在檢查版本信息，請稍候..."
  --   -- else
  --   --   return content
  --   -- end
  -- else
  --   return content
  -- end
  return content
end

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end    

local function findLocalConfigResourcePath()
  local assetPath = CCFileUtils:fullPathFromRelativePath("src", false);
  local pathArr = assetPath:split("/");
  table.remove(pathArr);

  local resourcePath = table.concat(pathArr, "/") .. "/resource";

  if kCurrentResourceEnvironment == kResourceEnvironment.kDebugLocal then
    table.remove(pathArr);
  end

  table.insert(pathArr, "static");
  table.insert(pathArr, "main_config.xml");

  local configPath = table.concat(pathArr, "/");
  return resourcePath, configPath;
end

local function syncResource()
  local resourcePath, configPath = findLocalConfigResourcePath(resourcePath);
  if kCurrentResourceEnvironment ~= kResourceEnvironment.kDebugLocal and not isRemote then
    configPath = remoteStaticServer;
  end
  local sized = "1280"..".".."720";
  --log
  log("sync dict: "..resourcePath.." ; "..configPath.." ; "..sized);
  
  ResManager:getInstance():setResolution(sized);
  ResManager:getInstance():setWritePath(resourcePath);

  -- 分包处理 暂时不用
  -- if userInfoSaver and platFormType == CC_PLATFORM_ANDROID then
  --   if userInfoSaver:getString("DOWN_LOAD_GIFT_SIGN2") == "2" then
  --     ResManager:getInstance():SetForceDLoadFlag(true)
  --   end
  -- else
  --   -- ResManager:getInstance():SetForceDLoadFlag(true);
  -- end
  log("zhangke---5----"..CommonUtils:getOSTime())
  ResManager:getInstance():sync(configPath, downUrl, "checkResourceCallBack",clientgameVersion);
end

local function loadMainApplication()
	local isApkUpgrading = ResManager:getInstance():isCheckApkUpgrading();
	if isMainApplicationInitialized or isApkUpgrading then
		return
	end;
	local loaded = require ("RunGame");
	isMainApplicationInitialized = true;

	if loaded then
    --这个方法在RunGame.lua里面
    StartInit();
	else
		updateLoadingLabel(getLanguageTranslated("文件错误，请重新更新..."));
	end
end

--HTTP callback.
function onLatestConfigLoad(responsePacket)
  log("zhangke---3----"..CommonUtils:getOSTime())
  local requestID = responsePacket.request.pParam.num;
  if responsePacket.succeed then
    if xml then
      local configFileContent = responsePacket.responseBuf;
      configFileContent = string.sub(configFileContent,1,responsePacket.buffLen);
      local ret = xml:ParseXmlText(configFileContent);
      local apk, staticConfigURL, staticDebugURL, staticConfigFile = nil, nil, nil, nil;
      local configTab = ret.config;

      if configTab then
        apk = configTab["@apk"];
        apkVersion = configTab["@apkVersion"];
        clientgameVersion = configTab["@version"];


        if apkVersion ~= MetaInfo:getInstance():getApkVersion() then
          he_log_info("Current Version Is:" .. MetaInfo:getInstance():getApkVersion() .. " New Version Is:" .. apkVersion);
        end

        staticConfigURL = configTab["@url"];
        staticDebugURL = configTab["@debug"];
        local debugmode = configTab["@debugmode"];
        if debugmode == "1" or kCurrentResourceEnvironment == kResourceEnvironment.kDebugOnline then 
          staticConfigURL = staticDebugURL;
        end

        local subconfigs = configTab.subconfig;
        if subconfigs then
          local fileName = subconfigs["@file"];
          if fileName then
              staticConfigFile = fileName;
          else
            local defaultConfigFile;
            for i, subconfig in ipairs(subconfigs) do
              local versionName = subconfig["@versionName"];
              if not versionName then
                defaultConfigFile = subconfig["@file"];
              elseif tostring(versionName) == MetaInfo:getInstance():getApkVersion() then
                staticConfigFile = subconfig["@file"];
                break;
              end
            end
            if not staticConfigFile then
              staticConfigFile = defaultConfigFile;
            end
          end
        else
          staticConfigFile = configTab.item["@file"];
        end
      end

      log("apk name: " .. MetaInfo:getInstance():getApkVersion())
      log("lua name: " .. staticConfigFile)

      if staticConfigURL and staticConfigFile then
        if system.set then 
          system.set("luaVersion", staticConfigFile) 
        end
        remoteStaticServer = staticConfigURL .. staticConfigFile;
        log("get latest online resource config:" .. remoteStaticServer);

        -- checkUpdateScriptEntry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkUpdatedFiles,0.05,false);
        log("zhangke---4----"..CommonUtils:getOSTime())
        syncResource();
      else
        log("test---1")
        updateLoadingLabel(getLanguageTranslated("获取资源错误,请点击屏幕任意位置重试.."));
        onLogoFinished()
      end
    else
      log("test---2")
      updateLoadingLabel(getLanguageTranslated("获取资源错误,请点击屏幕任意位置重试.."));
      button:setVisible(true);
      onLogoFinished()
    end
  else
    log("test---3")
    updateLoadingLabel(getLanguageTranslated("获取资源错误,请点击屏幕任意位置重试.."));
    button:setVisible(true);
    onLogoFinished()
  end
end

local function preloadGame()
  if kCurrentResourceEnvironment == kResourceEnvironment.kDebugLocal then
    -- checkUpdateScriptEntry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkUpdatedFiles,0.05,false);
    syncResource();
  else
    local staticConfigServer = ""
    if versionCode == PlatformConfig.PLATFORM_CODE_LAN then -- 内网
      staticConfigServer = PlatformConfig.LAN_URL;	
    elseif versionCode == PlatformConfig.PLATFORM_CODE_WAN then -- 官方
      local channel_id = CommonUtils:getChannelID()
      if channel_id == "0" then -- 给人看的版本
        staticConfigServer = PlatformConfig.WAN_URL
      elseif channel_id == "1" then -- officail 
        staticConfigServer = PlatformConfig.HE_URL
      elseif channel_id == "2" then -- android test
        staticConfigServer = PlatformConfig.QA_URL  
      end
    elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_APPLE then -- mac
      staticConfigServer = PlatformConfig.IOS_APPLE_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_BASE then
      return loadMainApplication();

    elseif versionCode == PlatformConfig.PLATFORM_CODE_MI then
      staticConfigServer = PlatformConfig.XIAOMI_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_360 then
      staticConfigServer = PlatformConfig.QIHOO_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_UC then      
       staticConfigServer = PlatformConfig.UC_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_BAIDU then      
       staticConfigServer = PlatformConfig.BAIDU_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_HUAWEI then      
       staticConfigServer = PlatformConfig.HUAWEI_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_OPPO then      
       staticConfigServer = PlatformConfig.OPPO_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_IQIYI then      
       staticConfigServer = PlatformConfig.IQIYI_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_YINGYONGBAO then      
       staticConfigServer = PlatformConfig.YINGYONGBAO_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_ZZ then      
       staticConfigServer = PlatformConfig.ZZ_URL;
    elseif versionCode == PlatformConfig.PLATFORM_CODE_YJ then      
       staticConfigServer = PlatformConfig.YJ_URL; 
    elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_TONGBUTUI then      
       staticConfigServer = PlatformConfig.IOS_TONGBUTUI_URL;   
  
    elseif versionCode == PlatformConfig.PLATFORM_CODE_VIVO then      
      staticConfigServer = PlatformConfig.VIVO_URL; 
    elseif versionCode == PlatformConfig.PLATFORM_CODE_LENOVO then      
      staticConfigServer = PlatformConfig.LENOVO_URL; 
    elseif versionCode == PlatformConfig.PLATFORM_CODE_JINLI then      
      staticConfigServer = PlatformConfig.JINLI_URL; 
    elseif versionCode == PlatformConfig.PLATFORM_CODE_COOLPAD then      
      staticConfigServer = PlatformConfig.COOLPAD_URL; 

    end

    log("staticConfigServer---------"..staticConfigServer)
    log("zhangke---2----"..CommonUtils:getOSTime())

    -- 请求config_version.xml
    HttpRequestManager:sharedInstance():SendGetRequest(staticConfigServer, 2, "onLatestConfigLoad");
  end
end

local function onTouchButton(eventType, x, y)
  if button and button:isVisible() and eventType == CCTOUCHBEGAN then 
    updateLoadingLabel(getLanguageTranslated("正在用力重连中.."));
    button:setVisible(false);
    preloadGame();
  end
  return false;
end

function dcNullCallBack1()

end

-- android 版本记录本地信息
local function initInterface()
	if platFormType == CC_PLATFORM_WIN32 then 
		return
	end

	if platFormType == CC_PLATFORM_ANDROID then
		local packageDir = PlatformConfig.WAN_PACK_NAME;
		if versionCode == PlatformConfig.PLATFORM_CODE_LAN then
			packageDir = PlatformConfig.LAN_PACK_NAME;
		else
			log("versionCode === "..versionCode);
		end  	
		-- 取得本地写的信息
		userInfoSaver = luajava.newInstance(packageDir..".UserInfoSaver");

	elseif platFormType == CC_PLATFORM_IOS then
		userInfoSaver = UserInfoSaver();
		if not userInfoSaver then
			log("____________userInfoSaver  create error!______________")
		end
		userInfoSaver:getString("aa");
		return
	end
end

local function requestServerData()

  local service = CCHttpService:create();
  service:retain();
  local function onAllServerConfigLoaded(statusCode, responseData)
    if responseData then
        local JSON = require("core.net.JSON");
        local serverListData = JSON:decode(responseData).data;
        requestServersTable = serverListData.area01.servers;
    else
      log("responseData====nil")
      service:send();
    end
  end    

  local server_url="http://partition.cn.happyelements.com/queryAllServerConfig?app_id=7800109651";
  service:setUrl(server_url);
  service:setResponseScriptCallback(onAllServerConfigLoaded);
  service:send();
end

local function main()

	-- 初始化android和ios的全局接口
	initInterface();
  
  -- http取得服务器列表数据
  requestServerData();

	if versionCode == PlatformConfig.PLATFORM_CODE_LAN then
		CCDirector:sharedDirector():setDisplayStats(false);
	else
		CCDirector:sharedDirector():setDisplayStats(false);
	end

	isMainApplicationInitialized = false;

	button = buildMainLoadingScene(preloadGame, loadMainApplication);
	button:registerScriptTouchHandler(onTouchButton, false, 0, true);

end

----------------------------------- now excute main -----------------------------------

package.loaded["main_scene"] = nil
require "SystemContext"
require "luaJavaConvert"
require "main_scene"

log("startup---------1");
log("zhangke---0----"..CommonUtils:getOSTime())
if jit and jit.off then 
    he_log_info("jit off")
    jit.off() 
end

versionCode = CommonUtils:getVersionCode()
platFormType = CommonUtils:getCurrentPlatform()

if platFormType == CC_PLATFORM_WIN32 then
  kCurrentResourceEnvironment = kResourceEnvironment.kDebugLocal;
else
  kCurrentResourceEnvironment = kResourceEnvironment.kReleaseQzone;
end

if type(log) ~= "function" then
  log = function(msg) end 
end;

MainForRestart = main;

main();

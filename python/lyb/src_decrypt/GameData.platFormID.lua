require "core.utils.Scheduler";
require "core.utils.StringUtils";
require "core.display.ccTypes"
require "main.config.GameConfig";
require "main.GameStart";
require "main.managers.GameData";
require "core.display.Director";
require "main.common.Dc"
require "core.utils.Tweenlite";
require "core.utils.EffectUtils";
require "core.utils.Global";
require "core.utils.ComponentUtils";
require "core.controls.IconContainer"
require "core.utils.GspUtils"
require "main.controller.command.scriptCartoon.BattleScript"
require "core.net.HttpService";
require "main.common.platformUtils.WANUtil"

GameData.platFormID = CommonUtils:getVersionCode();

-- 初始化excel生成的table的父容器 避免_G过于臃肿
ExcelLua = ExcelLua and ExcelLua or {};
MapLua = MapLua and MapLua or {};
gameStart = nil;
ManorLua = ManorLua and ManorLua or {};
WarLua = WarLua and WarLua or {};

function StartInit()

	GameData.osTime_m = CommonUtils:getOSTime();
    -- 调用c++解析消息对照表
	StartInitXml();
end

-- c++ call start game
function RunGameStart()
	
	log("zhangke---10----"..CommonUtils:getOSTime())
	-- 取得底层的数据,记下来传给服务器端
	-- 取得系统时间毫秒级的 打点用
	if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
		-- 取得设备内存大小,留作日后做缓存策略用
		local totalMemory = MetaInfo:getInstance():getTotalMemory()-- 总内存
		local availMemory = MetaInfo:getInstance():getAvailMemory()-- 可用内存
		if totalMemory then
			log("totalMemory ==  ".. totalMemory)
		end
		if availMemory then
			log("availMemory ==  ".. availMemory)
		end

		GameData.totalMemory = totalMemory
		GameData.availMemory = availMemory

		log("test---------1")
		GameData.install_key = MetaInfo:getInstance():getInstallKey()
		log("GameData.install_key=="..GameData.install_key)
		GameData.mac = MetaInfo:getInstance():getMacAddress()
		log("GameData.mac=="..GameData.mac)
		GameData.udid = MetaInfo:getInstance():getAndroidId()
		log("GameData.udid=="..GameData.udid)
		GameData.clienttype = string.gsub(MetaInfo:getInstance():getMachineType(),"%s","")
		log("test---------5"..GameData.clienttype)
		GameData.clientversion = MetaInfo:getInstance():getOsVersion()
		log("test---------6"..GameData.clientversion)
		GameData.clientpixel = MetaInfo:getInstance():getResolution();
		log("test---------7"..GameData.clientpixel)
		GameData.networktype = MetaInfo:getInstance():getSimNetworkType()
		log("test---------8"..GameData.networktype)
		-- if MetaInfo:getInstance():isRoot() then
		-- 	GameData.equipment = "crack";
		-- else
		-- 	GameData.equipment = "nocrack";
		-- end
		GameData.equipment = "nocrack";
		
		log("test---------9"..GameData.equipment)
		GameData.carrier = MetaInfo:getInstance():getNetOperatorName();
		log("test---------10"..GameData.carrier)
		if MetaInfo:getInstance():getIsAndroidEmulator() then
			GameData.simulator = "1";
		else
			GameData.simulator = "0";
		end
		log("test---------11"..GameData.simulator)
		-- 这3个android特有
		GameData.serial_number = MetaInfo:getInstance():getDeviceSerialNumber();	
		log("test---------12"..GameData.serial_number)
		GameData.android_id = MetaInfo:getInstance():getAndroidId();
		log("test---------13"..GameData.android_id)
		GameData.google_aid = MetaInfo:getInstance():getAndroidId();
		log("test---------14"..GameData.google_aid)

	elseif CommonUtils:getCurrentPlatform() == CC_PLATFORM_IOS then

		-- 取得设备内存大小,留作日后做缓存策略用
		local totalMemory = MetaInfo:getInstance():getTotalMemory()-- 总内存
		local availMemory = MetaInfo:getInstance():getAvailMemory()-- 可用内存
		if totalMemory then
			log("totalMemory ==  ".. totalMemory)
		end
		if availMemory then
			log("availMemory ==  ".. availMemory)
		end
		
		GameData.totalMemory = totalMemory
		GameData.availMemory = availMemory

		metaInfo = MetaInfoUtil();
		GameData.install_key = metaInfo:getInstallKey();
		GameData.mac = metaInfo:getMacAddress();
		GameData.udid = metaInfo:getUdid();
		log("GameData.udid=="..GameData.udid)
		GameData.clienttype = string.gsub(metaInfo:getMachineType(),"%s","");
		GameData.clientversion = metaInfo:getOsVersion();
		GameData.clientpixel = metaInfo:getResolution();
		GameData.networktype = metaInfo:getSimNetworkType();
		if metaInfo:isJailBroken()==1 then
			GameData.equipment = "crack";
		else
			GameData.equipment = "nocrack"
		end
		GameData.carrier = metaInfo:getCarrier();
		if metaInfo:getSimulator()==1 then
			GameData.simulator = "1";
		else
			GameData.simulator = "0";
		end		

		-- ios特有		
		GameData.idfa = metaInfo:getIDFA();
		GameData.wifiMac = metaInfo:getWifiMac();
		GameData.kernelTaskStartTime = metaInfo:getKernelTaskStartTime();
	end

	GameData.channel_id = CommonUtils:getChannelID()

	log("GameData.channel_id==="..GameData.channel_id)

	-- local dcstr = "GameData.install_key="..GameData.install_key
	-- 			.."&GameData.mac="..GameData.mac
	-- 			.."&GameData.udid="..GameData.udid
	-- 			.."&GameData.clienttype="..GameData.clienttype
	-- 			.."&GameData.clientversion="..GameData.clientversion
	-- 			.."&GameData.clientpixel="..GameData.clientpixel
	-- 			.."&GameData.networktype="..GameData.networktype
	-- 			.."&GameData.equipment="..GameData.equipment
	-- 			.."&GameData.carrier="..GameData.carrier
	-- 			.."&GameData.simulator="..GameData.simulator
	-- 			.."&GameData.serial_number="..GameData.serial_number
	-- 			.."&GameData.android_id="..GameData.android_id
	-- 			.."&GameData.google_aid="..GameData.google_aid
	--			.."&GameData.idfa="..GameData.idfa
	-- log("dc--"..dcstr)

    -- 根据设备宽高定位主界面4个角的位置
    local winSize = Director:sharedDirector():getWinSize();
    GameData.uiOffsetX = (winSize.width - GameConfig.STAGE_WIDTH) / 2
    GameData.uiOffsetY = (winSize.height - GameConfig.STAGE_HEIGHT) / 2

    log("winSize.width==="..winSize.width)
    log("winSize.height==="..winSize.height)
    log("GameData.gameUIScaleRate==="..GameData.gameUIScaleRate)
    log("GameData.uiOffsetX======="..GameData.uiOffsetX)
    log("GameData.uiOffsetY======="..GameData.uiOffsetY)  

    -- 读本地文件的设置信息
	if not GameData.local_account then
		GameData.local_account = getLocalInfo("account")
	end
	if not GameData.local_passWord then
		GameData.local_passWord = getLocalInfo("passWord")
	end
	if not GameData.local_serverId then
		GameData.local_serverId = getLocalInfo("serverId")
	end
	if not GameData.local_serverId2 then
		GameData.local_serverId2 = getLocalInfo("serverId2")
	end
	if not GameData.local_serverId3 then
		GameData.local_serverId3 = getLocalInfo("serverId3")
	end
	if not GameData.local_serverId4 then
		GameData.local_serverId4 = getLocalInfo("serverId4")
	end
	if not GameData.local_autoButton then
		GameData.local_autoButton  = getLocalInfo("autoButton")
	end

	-- 进游戏的音乐
	if not GameData.local_sound then
		GameData.local_sound = getLocalInfo("sound")		
		if GameData.local_sound == "0" then
			GameData.isMusicOn = false
		else
			GameData.isMusicOn = true
		end	
	end

	log("gameStart-----zhangke-----2")
	
	hecDC(2,10)
	
    -- 进入游戏
	gameStart = GameStart.new();
	gameStart:initialize();
	gameStart:start();

end
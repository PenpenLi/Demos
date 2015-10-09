
-- function dcNullCallBack()
-- 	log("-------dc-------")
-- end

function getPlatformID4DC()
	local id=GameData.platFormId4Dc and GameData.platFormId4Dc or GameData.platFormID;
	return id % 100000 .. ""
end

-- 全局打点函数
-- dcType ：2加载打点5号点，3,101行为点, 4更新打点, 5新手引导，6战场
-- stepCount加载步数；只有类型2有效
-- subFunctionType 101 行为点
function hecDC(dcType,stepCount,subFunctionType,extensionTable)

	if CommonUtils:getCurrentPlatform() == CC_PLATFORM_WIN32
	then--or GameData.platFormID == GameConfig.PLATFORM_CODE_LAN 测试要测打点
		return;
	end

	local testDcIP = "http://58.83.216.73/restapi.php?"--"http://da.happyelements.com/restapi.php?"
	local officialDcIP = "http://log.dc.cn.happyelements.com/restapi.php?"
	local dcIP = officialDcIP --testDcIP

	local language = MetaInfo:getInstance():getLanguage()
	local ipAddress = MetaInfo:getInstance():getLocalIpAddress()
	local apkVersion = clientgameVersion--MetaInfo:getInstance():getApkVersion()
	local osTime_m = CommonUtils:getOSTime();
	
	local intervalTime = osTime_m - GameData.osTime_m
	-- GameData.osTime_m = osTime_m
	
	local osTime = os.date("%Y%m%d%H%M%S", os.time());

	local timeZone = MetaInfo:getInstance():getTimeZone()

	local prodName = "langyabang_androidcn_prod"
		
	local platFormType = ""
	local platFormID = getPlatformID4DC()
	if platFormID == GameConfig.PLATFORM_CODE_LAN then 
		platFormType = "lan_test"
		dcIP = testDcIP
	elseif platFormID == GameConfig.PLATFORM_CODE_WAN then 
		prodName = "langyabang_androidcn_prod"
		platFormType = "he"
	elseif platFormID == GameConfig.PLATFORM_CODE_MI then 
		prodName = "langyabang_androidiqiyi_prod"
		platFormType = "xiaomi"
	elseif platFormID == GameConfig.PLATFORM_CODE_360 then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "360"
	elseif platFormID == GameConfig.PLATFORM_CODE_UC then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "uc"
	elseif platFormID == GameConfig.PLATFORM_CODE_BAIDU then 
		prodName = "langyabang_androidiqiyi_prod"
		platFormType = "baidu"
	elseif platFormID == GameConfig.PLATFORM_CODE_HUAWEI then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "huawei"
	elseif platFormID == GameConfig.PLATFORM_CODE_OPPO then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "oppo"
	elseif platFormID == GameConfig.PLATFORM_CODE_IQIYI then 
		prodName = "langyabang_androidiqiyi_prod"
		platFormType = "pps"
	elseif platFormID == GameConfig.PLATFORM_CODE_YINGYONGBAO then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "yingyongbao"				
	elseif platFormID == GameConfig.PLATFORM_CODE_ZZ then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "zhangzong"
	elseif platFormID == GameConfig.PLATFORM_CODE_YJ then 
		prodName = "langyabang_androidzhangzong_prod"
		platFormType = "yijie"

	elseif platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then 	   
		prodName = "langyabang_ioscn_prod"
		platFormType = "apple"

	-- elseif platFormID == GameConfig.PLATFORM_CODE_IOS_91 then
	-- 	prodName = "langyabang_ioszhangzong_prod"
	-- 	platFormType = "91"
	-- elseif platFormID == GameConfig.PLATFORM_CODE_IOS_XY then		
	-- 	prodName = "langyabang_ioszhangzong_prod"
	--     platFormType = "xy"
	-- elseif platFormID == GameConfig.PLATFORM_CODE_IOS_KY then		
	-- 	prodName = "langyabang_ioszhangzong_prod"
	--     platFormType = "ky"
	elseif platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI then		
		prodName = "langyabang_ioszhangzong_prod"
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

	local serverUserID = 12345
	if GameData.platFormUserId ~= 0 then
		serverUserID = GameData.ServerId .. "_" .. GameData.platFormID .. "_" .. GameData.platFormUserId
	end

	local roleID = GameData.ServerId .. "_" .. GameData.userID

	local contentStr

	if dcType == 1 then

	elseif dcType == 2 then

		local isNewUser
		if GameData.userState == 0 then
			isNewUser = 1
		else
			isNewUser = 0
		end

		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=5&partition=1&install_key="..GameData.install_key
					.."&_user_id="..serverUserID
					.."&lang="..language
					.."&ip="..ipAddress
					.."&udid="..GameData.udid
					.."&gameversion="..apkVersion
					.."&clienttype="..GameData.clienttype
					.."&clientversion="..GameData.clientversion
					.."&time_zone=".. timeZone
					.."&time="..osTime
					.."&platform="..platFormType
					.."&viral_id="..serverUserID.."_"..osTime
					.."&is_new="..isNewUser
					.."&interval="..intervalTime
					.."&step="..stepCount
					.."&server="..GameData.ServerId
					.."&role_id="..roleID;

	elseif dcType == 3 then
    	local extensionStr = ""
	    if extensionTable then
	    	for ek,ev in pairs(extensionTable) do
				extensionStr = extensionStr .. "&"..ek.."="..ev
	    	end
	    end
		
		log("extensionStr=="..extensionStr)
		print("extensionStr", extensionStr)
	    local mainType = ""
	    local subType=""
		if stepCount == 1 then
			mainType = "jiazaizhuanhua"
			subType = "jiazai_pass"   		            
	    elseif stepCount == 2 then
			mainType = "bag"
			if subFunctionType == 1 then
				subType = "bag_open" 
			elseif subFunctionType == 2 then
				subType = "bag_baowu" 
			elseif subFunctionType == 3 then
				subType = "bag_cailiao" 
			elseif subFunctionType == 4 then
				subType = "bag_suipian" 
			elseif subFunctionType == 5 then
				subType = "bag_hunshi" 
			end
	    elseif stepCount == 4 then
			mainType = "heroku"
			if subFunctionType == 1 then
				subType = "heroku_open" 
			elseif subFunctionType == 2 then
				subType = "heroku_sort" 
			elseif subFunctionType == 3 then
				subType = "heroku_juese" 
			elseif subFunctionType == 4 then
				subType = "heroku_qianghua" 
			elseif subFunctionType == 5 then	
				subType = "heroku_skill"
			elseif subFunctionType == 6 then	
				subType = "heroku_yuanfen"
			elseif subFunctionType == 7 then	
				subType = "heroku_info"				
			end
	    elseif stepCount == 5 then
			mainType = "langyaling"
			if subFunctionType == 1 then
				subType = "langyaling_open" 			
			end			
	    elseif stepCount == 6 then
			mainType = "shili"
			if subFunctionType == 1 then
				subType = "shili_open" 	
			end		
	    elseif stepCount == 7 then
			mainType = "chaotang"
			if subFunctionType == 1 then
				subType = "chaotang_open" 
			elseif subFunctionType == 2 then
				subType = "chaotang_choosechaochen" 				
			end
	    elseif stepCount == 8 then
			mainType = "shiguozhengzhan"
			if subFunctionType == 1 then
				subType = "shiguo_open" 
			elseif subFunctionType == 2 then
				subType = "shiguo_restart" 				
			end	
	    elseif stepCount == 9 then
			mainType = "langyabaoku"
			if subFunctionType == 1 then
				subType = "langya_open" 
			elseif subFunctionType == 2 then
				subType = "langya_choosedonggong" 
			elseif subFunctionType == 3 then
				subType = "langya_choosemufu" 			
			end	
	    elseif stepCount == 10 then
			mainType = "guanzhi"
			if subFunctionType == 1 then
				subType = "guanzhi_open" 			
			end
	    elseif stepCount == 11 then
			mainType = "langyabang"
			if subFunctionType == 1 then
				subType = "langyabang_open" 
			elseif subFunctionType == 2 then
				subType = "langyabang_checklist" 
			elseif subFunctionType == 3 then
				subType = "langyabang_check" 			
			end	
	    elseif stepCount == 12 then
			mainType = "mail"
			if subFunctionType == 1 then
				subType = "mail_open" 		
			end	
	    elseif stepCount == 13 then
			mainType = "luoshu"
			if subFunctionType == 1 then
				subType = "luoshu_open" 		
			end	
	    elseif stepCount == 14 then
			mainType = "yunzhongge"
			if subFunctionType == 1 then
				subType = "yunzhongge_open" 
			elseif subFunctionType == 2 then
				subType = "yunzhongge_xianshi" 			
			end	
	    elseif stepCount == 15 then
			mainType = "qianzhuang"
			if subFunctionType == 1 then
				subType = "qianzhuang_open" 			
			end	
	    elseif stepCount == 16 then
			mainType = "biwu"
			if subFunctionType == 1 then
				subType = "biwu_open" 
			elseif subFunctionType == 2 then
				subType = "biwu_check" 
			elseif subFunctionType == 3 then
				subType = "biwu_refresh" 	
			elseif subFunctionType == 4 then
				subType = "biwu_result" 
			elseif subFunctionType == 5 then
				subType = "biwu_info" 
			elseif subFunctionType == 6 then
				subType = "biwu_defight" 
			end	
	    elseif stepCount == 17 then
			mainType = "chongzhi"
			if subFunctionType == 1 then
				subType = "chongzhi_buy" 		
			end	
	    elseif stepCount == 18 then
			mainType = "leijiqiandao"
			if subFunctionType == 1 then
				subType = "leijiqiandao_open" 		
			end	
	    elseif stepCount == 19 then
			mainType = "activity"
			if subFunctionType == 1 then
				subType = "activity_open" 	
			elseif subFunctionType == 2 then
				subType = "activity_openlevel" 		
			end	
	    elseif stepCount == 20 then
			mainType = "huangcheng"
			if subFunctionType == 1 then
				subType = "huangcheng_open" 	
			elseif subFunctionType == 2 then
				subType = "huangcheng_buy" 		
			end																						        
		elseif stepCount == 21 then
			mainType = "wuxing"
			if subFunctionType == 1 then
				subType = "wuxing_open" 	
			end
		elseif stepCount == 22 then
			mainType = "renwu"
			if subFunctionType == 1 then
				subType = "renwu_open" 	
			elseif subFunctionType == 2 then
				subType = "renwu_mubiao" 	
			elseif subFunctionType == 3 then
				subType = "renwu_richang" 	
			end
		elseif stepCount == 23 then
			mainType = "bangpaichuangjian"
			if subFunctionType == 1 then
				subType = "bangpai_open" 	
			elseif subFunctionType == 2 then
				subType = "bangpai_build" 	
			elseif subFunctionType == 3 then
				subType = "bangpai_yinliangbuild" 	
			elseif subFunctionType == 4 then
				subType = "bangpai_yuanbaobuild"
			elseif subFunctionType == 5 then
				subType = "bangpai_apply"
			end
		elseif stepCount == 24 then
			mainType = "bangpaiyongbing"
			if subFunctionType == 1 then
				subType = "yongbing_send" 	
			elseif subFunctionType == 2 then
				subType = "yongbing_back" 	
			elseif subFunctionType == 3 then
				subType = "yongbing_use" 	
			end
		elseif stepCount == 25 then
			mainType = "bangpaijiuyan"
			if subFunctionType == 1 then
				subType = "jiuyan_conduct" 	
			elseif subFunctionType == 2 then
				subType = "jiuyan_open" 	
			elseif subFunctionType == 3 then
				subType = "jiuyan_join" 
			elseif subFunctionType == 4 then
				subType = "jiuyan_hot" 
			end
		elseif stepCount == 26 then
			mainType = "bangpaichangjing"
			if subFunctionType == 1 then
				subType = "guanli_open" 	
			elseif subFunctionType == 2 then
				subType = "jiuyan_open" 	
			elseif subFunctionType == 3 then
				subType = "yongbing_open" 
			elseif subFunctionType == 4 then
				subType = "shangdian_open" 
			elseif subFunctionType == 5 then
				subType = "gonggao_open" 
			elseif subFunctionType == 6 then
				subType = "gonggao_pass" 
			elseif subFunctionType == 7 then
				subType = "changjing_open" 
			end
		elseif stepCount == 27 then
			mainType = "xunbao"
			if subFunctionType == 1 then
				subType = "xunbao_open" 	
			elseif subFunctionType == 2 then
				subType = "xunbao_reroll" 	
			elseif subFunctionType == 3 then
				subType = "xunbao_chest" 
			elseif subFunctionType == 4 then
				subType = "xunbao_pass" 
			end	
		elseif stepCount == 28 then--天相
			mainType = "tianxiang"
			if subFunctionType == 1 then
				subType = "tianxiang_open" 	
			elseif subFunctionType == 2 then
				subType = "tianxiang_light" 	
			end	
		elseif stepCount == 29 then--幻化
			mainType = "huanhua"
			if subFunctionType == 1 then
				subType = "huanhua_open" 	
			elseif subFunctionType == 2 then
				subType = "huanhua_success" 	
			end
		elseif stepCount == 30 then--英雄志
			mainType = "yingxiongzhi"
			if subFunctionType == 1 then
				subType = "yingxiongzhi_open" 	
			elseif subFunctionType == 2 then
				subType = "yingxiongzhi_killed" 	
			elseif subFunctionType == 3 then
				subType = "yingxiongzhi_cartoon" 	
			end					
		end			
		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=101&partition=1&install_key="..GameData.install_key
					.."&category="..mainType
					.."&sub_category="..subType
					.."&_user_id="..serverUserID
					.."&lang="..language
					.."&ip="..ipAddress
					.."&udid="..GameData.udid
					.."&gameversion="..apkVersion
					.."&clienttype="..GameData.clienttype
					.."&clientversion="..GameData.clientversion
					.."&time_zone=".. timeZone 
					.."&time="..osTime
					.."&platform="..platFormType
					-- .."&interval="..intervalTime
					.."&server="..GameData.ServerId
					.."&role_id="..roleID
					..extensionStr;	

	elseif 4 == dcType then
		
		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=12&partition=1&install_key="..GameData.install_key
					.."&_user_id="..serverUserID
					.."&lang="..language
					.."&ip="..ipAddress
					.."&gameversion="..apkVersion
					.."&clienttype="..GameData.clienttype
					.."&clientversion="..GameData.clientversion
					.."&platform="..platFormType
					.."&server="..GameData.ServerId
					.."&udid=" .. GameData.udid
				    .."&catecory=" .. "start"
				    .."&gameversion1=" .. apkVersion
				    .."&gameversion2=" .. apkVersion
				    .."&interval=" .. "0"
				    .."&role_id="..roleID;

		if GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then
			local channel_id = CommonUtils:getChannelID()
			if channel_id ~= "0" then
				contentStr = contentStr .. "&channel_id="..channel_id;
			end
		end
	elseif 5 == dcType then
		mainType = ""
		subType = ""
		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=15&partition=1&install_key="..GameData.install_key
					.."&category="..mainType
					.."&sub_category="..subType
					.."&_user_id="..serverUserID
					.."&lang="..language
					.."&ip="..ipAddress
					.."&udid="..GameData.udid
					.."&gameversion="..apkVersion
					.."&clienttype="..GameData.clienttype
					.."&clientversion="..GameData.clientversion
					.."&time_zone=".. timeZone 
					.."&time="..osTime
					.."&platform="..platFormType
					.."&interval="..intervalTime
					.."&server="..GameData.ServerId
					.."&role_id="..roleID
					.."&step="..stepCount
	elseif 6 == dcType then
    	local extensionStr = ""
	    if extensionTable then
	    	for ek,ev in pairs(extensionTable) do
				extensionStr = extensionStr .. "&"..ek.."="..ev
	    	end
	    end
		mainType = "zhanchang"
		subType = ""
		if stepCount == 1 then
			subType = "startfight"
		elseif stepCount == 2 then
			subType = "endfight"
		elseif stepCount == 3 then
			subType = "tiaoguo"
		end
		
		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=98&partition=1&install_key="..GameData.install_key
					.."&category="..mainType
					.."&sub_category="..subType
					.."&_user_id="..serverUserID
					.."&lang="..language
					.."&ip="..ipAddress
					.."&udid="..GameData.udid
					.."&gameversion="..apkVersion
					.."&clienttype="..GameData.clienttype
					.."&clientversion="..GameData.clientversion
					.."&time_zone=".. timeZone 
					.."&time="..osTime
					.."&platform="..platFormType
					.."&interval="..intervalTime
					.."&server="..GameData.ServerId
					.."&role_id="..roleID
					..extensionStr
	elseif dcType == 7 then -- 渠道标识点 激活

		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=7&partition=1&install_key="..GameData.install_key
					.."&_user_id="..serverUserID
					.."&mac="..GameData.mac
					.."&ip="..ipAddress
					.."&udid="..GameData.udid
					.."&platform="..platFormType
					.."&android_id="..GameData.android_id
					.."&idfa="..GameData.idfa
					.."&serial_number="..GameData.serial_number
					.."&ios_udid="..GameData.udid
					.."&channel_id="..GameData.channel_id
					.."&Google_aid="..GameData.google_aid;
	elseif dcType == 8 then -- 渠道标识点 注册

		contentStr = "_uniq_key="..prodName
					.."&location=cn&_ac_type=6&partition=1&install_key="..GameData.install_key
					.."&_user_id="..serverUserID
					.."&mac="..GameData.mac
					.."&ip="..ipAddress
					.."&udid="..GameData.udid
					.."&platform="..platFormType
					.."&android_id="..GameData.android_id
					.."&idfa="..GameData.idfa
					.."&serial_number="..GameData.serial_number
					.."&ios_udid="..GameData.udid
					.."&channel_id="..GameData.channel_id
					.."&Google_aid="..GameData.google_aid;					

	end

	if contentStr then
		local dcStr;
		dcStr = dcIP..contentStr
		if dcType ~= 3 then
			log("dcStr-------------"..dcStr)
		end
		-- HttpRequestManager:sharedInstance():SendGetRequest(dcStr,2,"dcNullCallBack");

		local function onSuccessCall(statusCode1, responseData1)
			log("dc -- success")
			log(responseData1)
			log(statusCode1.."")
		end
		local function onErrorCall()
			log("dc -- error")
		end

	  	local dcHttp = HttpService.new();
	  	dcHttp:setUrl(dcStr);
	  	dcHttp:setRequestType(kHttpPost)
	  	dcHttp:setResponseCallback(onSuccessCall);
	  	dcHttp:setErrorCallback(onErrorCall);
	  	dcHttp:send();

	end
end


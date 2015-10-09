local _tipsLabel = nil;
local bar = nil;
local _loadingBarWidth;
local originalCrabPositionX;
local mainScene
local mainSceneLayer
local _loadMainApplication
local _loadingBG
local _winSize
local logo
local platformLogo
local button
local logcompleteBoo = false

function updateLoadingLabel(labelString)
	local _str = labelString.."";
	if _tipsLabel then 
		_tipsLabel:setString(_str)
	end
end

function updateLoadingProgress(v)
  v = v or 0;
  local percent = v;
  if v <= 0.000001 then percent = 0 end;
  if v >= 1.0 then percent = 1 end;
	
  if bar then
	local textureRect = bar:getTextureRect();
	local transformedWidth = percent * _loadingBarWidth;
	textureRect = CCRectMake(textureRect.origin.x, textureRect.origin.y, transformedWidth, textureRect.size.height);
	bar:setTextureRect(textureRect, false, textureRect.size);
	  
	_loadingBG:setVisible(true)    
	bar:setVisible(true)  
  end    
end

function buildProgressBar()

	if _loadingBG and bar then
		return
	end

	_loadingBG = CCSprite:create("embed/loading_bg.png");
	_loadingBG:setAnchorPoint(ccp(0,0));
	local sizeBg = _loadingBG:getContentSize();
	_loadingBG:setPosition(ccp((_winSize.width - sizeBg.width) / 2,60));
	mainScene:addChild(_loadingBG);

	bar = CCSprite:create("embed/loading_bar.png");
	bar:setAnchorPoint(ccp(0,0));
	local sizeBar = bar:getContentSize();	
	bar:setPosition(ccp((_winSize.width - sizeBar.width) / 2,60));
	mainScene:addChild(bar);

	_loadingBarWidth = sizeBar.width;
	
	updateLoadingProgress(0)
		
	_loadingBG:setVisible(false)
	bar:setVisible(false)

end

function onLogoFinished()
	-- 进入游戏场景前的音乐
	-- SimpleAudioEngine:sharedEngine():playBackgroundMusic(fullPath("resource/music/4.mp3",true), true);
	if CommonUtils:getCurrentPlatform() ~= CC_PLATFORM_IOS then
		if logo then
			logo:setVisible(false)
		end
		if platformLogo then
			platformLogo:setVisible(false)
		end
	end

end

-- 整包更新
function fullPackUpdate(version)

	log("fullPackUpdate ---- 1")

	if version then
		log("version======"..version)
	end

	local function getInGame()


		log("fullPackUpdate ---- 2")

		onLogoFinished()

		local tipsBg = CCSprite:create("embed/tipsBg.png");
		tipsBg:setAnchorPoint(ccp(0,0));
		local sizeBg = tipsBg:getContentSize();
		tipsBg:setPosition(ccp((_winSize.width - sizeBg.width) / 2,(_winSize.height - sizeBg.height) / 2));
		mainScene:addChild(tipsBg);	

		local cancelBtn = CCSprite:create("embed/cancelBtn.png");
		cancelBtn:setAnchorPoint(ccp(0, 0));
		local cancelBtnBg = cancelBtn:getContentSize();

		local confirmBtn = CCSprite:create("embed/confirmBtn.png");
		confirmBtn:setAnchorPoint(ccp(0, 0));
		local confirmBtnBg = confirmBtn:getContentSize();

		-- 添加到两个层上
		local touchLayer1 = CCLayerColor:create(ccc4(255,255,255,0), 158, 60);
		touchLayer1:setAnchorPoint(ccp(0, 0));
		touchLayer1:setPosition(ccp(_winSize.width / 2 - 220,_winSize.height / 2 - 155));
		mainScene:addChild(touchLayer1);

		local touchLayer2 = CCLayerColor:create(ccc4(255,255,255,0), 158, 60);
		touchLayer2:setAnchorPoint(ccp(0, 0));
		touchLayer2:setPosition(ccp(_winSize.width / 2 + 30,_winSize.height / 2 - 155));
		mainScene:addChild(touchLayer2);

		touchLayer1:addChild(cancelBtn)
		touchLayer2:addChild(confirmBtn)
		touchLayer1:setTouchEnabled(true);

		local updateText = CCLabelTTF:create(getLanguageTranslated("主淫,发现有新内容,我们去更新吧?"), "Verdana",24,CCSizeMake(390,150));
		updateText:setAnchorPoint(ccp(0, 0));
		updateText:setColor(ccc3(0,0,0))
		updateText:setPosition(ccp(_winSize.width / 2 - 200,_winSize.height / 2 - 50));
		mainScene:addChild(updateText);

		local function onClickConfirmBtn(eventType,position)
			local x = position[1]
			local y = position[2]
			local touchLayer1PosX = touchLayer1:getPositionX()
			local touchLayer1PosY = touchLayer1:getPositionY()
			local touchLayer2PosX = touchLayer2:getPositionX()
			local touchLayer2PosY = touchLayer2:getPositionY()

			-- 取消更新即退出游戏
			if x > touchLayer1PosX and x < touchLayer1PosX + cancelBtnBg.width and y > touchLayer1PosY and y < touchLayer1PosY + cancelBtnBg.height then 
				CCDirector:sharedDirector():endToLua();
			end

			-- 更新补丁
			if x > touchLayer2PosX and x < touchLayer2PosX + confirmBtnBg.width and y > touchLayer2PosY and y < touchLayer2PosY + confirmBtnBg.height then 

				if _tipsLabel then
					_tipsLabel:setVisible(true)
				end

				local downUrl = "http://lybgame.com/"
				local versionCode = CommonUtils:getVersionCode()

				-------------------- android ----------------------
				if versionCode == PlatformConfig.PLATFORM_CODE_DEBUG
				or versionCode == PlatformConfig.PLATFORM_CODE_LAN
				then -- 内网
					local urlForDown = "http://10.130.133.248/langyabang_lan/packs/apks_full"
					local versionForDown = version .. ""
					downloadFullApk(urlForDown,versionForDown)				
				elseif versionCode == PlatformConfig.PLATFORM_CODE_WAN then
					local urlForDown = "http://static.yanhuang.happyelements.cn/langyabang_wan/packs/apks_full"
	      
					local channel_id = CommonUtils:getChannelID()
					if channel_id == "0" then -- 给人看的版本
					urlForDown = "http://static.yanhuang.happyelements.cn/langyabang_wan/packs/apks_full"
					elseif channel_id == "1" then -- officail 
					urlForDown = "http://static.yanhuang.happyelements.cn/langyabang_wan/packs/apks_full"
					elseif channel_id == "2" then -- android test
					urlForDown = "http://10.130.133.248/langyabang_qa_android/packs/apks_full" 
					end

					local versionForDown = version .. ""
					downloadFullApk(urlForDown,versionForDown)				
				elseif versionCode == PlatformConfig.PLATFORM_CODE_MI then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_360 then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_UC then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_BAIDU then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_HUAWEI then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_OPPO then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IQIYI then
					downUrl = "http://lybgame.com/"
				elseif versionCode == PlatformConfig.PLATFORM_CODE_YINGYONGBAO then
					downUrl = "http://lybgame.com/"	
				elseif versionCode == PlatformConfig.PLATFORM_CODE_ZZ then
					downUrl = "http://lybgame.com/"
				-------------------- android ---------------------
									
				-------------------- ios -------------------------
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_APPLE then				
					-- downUrl = ""
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_BASE then
					-- downUrl = ""
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_91 then
					-- downUrl = ""
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_XY then
					-- downUrl = ""
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_KY then
					-- downUrl = ""
				elseif versionCode == PlatformConfig.PLATFORM_CODE_IOS_TONGBUTUI then				
					-- downUrl = ""
				-------------------- ios -------------------------

				end

				log("full pack downUrl======="..downUrl)
				if versionCode == PlatformConfig.PLATFORM_CODE_DEBUG
				or versionCode == PlatformConfig.PLATFORM_CODE_LAN
				or versionCode == PlatformConfig.PLATFORM_CODE_WAN
				then -- 内网

				else
					-- 打开平台的下载页
					openLuaUrl(downUrl)
				end

				_loadingBG:setVisible(false)
				tipsBg:setVisible(false)
				updateText:setVisible(false)
				touchLayer1:setVisible(false)
				touchLayer2:setVisible(false)
				
				touchLayer1:setTouchEnabled(false)
				
				touchLayer1:unregisterScriptTouchHandler();			
				touchLayer2:unregisterScriptTouchHandler();	
			end
		end	 

		touchLayer1:registerScriptTouchHandler(onClickConfirmBtn, false, 0, true);
	end
	local updateTimer
	local function updateTimerFunc()
		if logcompleteBoo then
			log("--checking--resource-- done")
			if updateTimer then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimer);  
			end
			getInGame()
		else
			log("--checking--resource--")
		end
	end

    updateTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimerFunc, 0.1, false)	
end

-- 检查更新资源后的回调
function checkResourceCallBack()
	log("---checkResourceCallBack---"..CommonUtils:getOSTime())
	local function getInGame()
		log("zhangke---6----"..CommonUtils:getOSTime())

		if _tipsLabel then
			_tipsLabel:setVisible(false)
		end

		local _allByte = ResManager:getInstance():getAllBytes()
		local _allDownloadByte = ResManager:getInstance():getAllDownLoadBytes()
		local updateFileSize = _allByte - _allDownloadByte;
		
		log("updateFileSize===--"..updateFileSize)
		log("ResManager:getInstance():getAllBytes()===--".._allByte)
		log("ResManager:getInstance():getAllDownLoadBytes()===--".._allDownloadByte)
			
	    -- 如果需要直接更新而不需要选择，开始下面这段，注释上面if end后面那段
		if updateFileSize > 0 then
			onLogoFinished()
			log("MetaInfo:getInstance():getWifiState()===-- "..MetaInfo:getInstance():getWifiState())
			log("updateFileSize===-- "..updateFileSize)
			-- wifi 环境下低于1000k的更新包直接下载，不再提示玩家
			if MetaInfo:getInstance():getWifiState() == 1 or updateFileSize < 1000000 then
				if _tipsLabel then
					_tipsLabel:setVisible(true)
				end
				ResManager:getInstance():downLoadResource2();
				_loadingBG:setVisible(false)
		
				-- 检查更新进度条
				local _checkUpdateScriptEntry = nil;
				local function checkUpdatedFiles(dt)
				  local isUpdateCompleted = ResManager:getInstance():isUpdateCompleted();
				  -- 下载完成
				  if isUpdateCompleted == KUpdateSucceed then
				    -- TODO 静态资源加载完成 
			    	updateLoadingProgress(1);
				    _loadMainApplication();
				    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_checkUpdateScriptEntry);
				  elseif isUpdateCompleted == KUpdateUnZip then
				    -- 更新进度条
				    updateLoadingProgress(1);
			      	updateLoadingLabel(getLanguageTranslated("解压中.."));
				  else
				    local getAllDownLoadBytes = ResManager:getInstance():getAllDownLoadBytes() or 0;
				    local getAllBytes = ResManager:getInstance():getAllBytes() or 0;

				    local percent = getAllDownLoadBytes/getAllBytes;
				    percent = percent or 0;
				    if tostring(percent) == "nan" then
				      percent = 0
				    end;
				    local formated = math.floor(percent * 10000) / 10000;

				    -- 更新进度条
				    updateLoadingProgress(formated);

				    if formated then
				      formated = formated * 100;
				      if formated ~= 0 then
				        -- 更新进度值
				        updateLoadingLabel(formated.."%");  
				      end
				    end
				  log("ResManager:getInstance():getUpdateState()=="..ResManager:getInstance():getUpdateState())
				    if ResManager:getInstance():getUpdateState() == 1 then 
				      CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_checkUpdateScriptEntry);
				      updateLoadingLabel(getLanguageTranslated("同步资源错误,点击屏幕重试.."));
				      button:setVisible(true);
				      he_log_error("[404] loading error."..ResManager:getInstance():getCurrentDownloadFileName());
				    end
				  end
				end		
				
				_checkUpdateScriptEntry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkUpdatedFiles,0.05,false);			

			else

				local tipsBg = CCSprite:create("embed/tipsBg.png");
				tipsBg:setAnchorPoint(ccp(0,0));
				local sizeBg = tipsBg:getContentSize();
				tipsBg:setPosition(ccp((_winSize.width - sizeBg.width) / 2,(_winSize.height - sizeBg.height) / 2));
				mainScene:addChild(tipsBg);	
				
				local cancelBtn = CCSprite:create("embed/cancelBtn.png");
				cancelBtn:setAnchorPoint(ccp(0, 0));
				local cancelBtnBg = cancelBtn:getContentSize();

				local confirmBtn = CCSprite:create("embed/confirmBtn.png");
				confirmBtn:setAnchorPoint(ccp(0, 0));
				local confirmBtnBg = confirmBtn:getContentSize();

				-- 添加到两个层上
				local touchLayer1 = CCLayerColor:create(ccc4(255,255,255,0), 158, 60);
				touchLayer1:setAnchorPoint(ccp(0, 0));
				touchLayer1:setPosition(ccp(_winSize.width / 2 - 220,_winSize.height / 2 - 155));
				mainScene:addChild(touchLayer1);

				local touchLayer2 = CCLayerColor:create(ccc4(255,255,255,0), 158, 60);
				touchLayer2:setAnchorPoint(ccp(0, 0));
				touchLayer2:setPosition(ccp(_winSize.width / 2 + 30,_winSize.height / 2 - 155));
				mainScene:addChild(touchLayer2);

				touchLayer1:addChild(cancelBtn)
				touchLayer2:addChild(confirmBtn)

				touchLayer1:setTouchEnabled(true);
				
				local downLoadSize_M = updateFileSize / 1024 / 1024
				downLoadSize_M = downLoadSize_M - downLoadSize_M % 0.01
				local updateText = CCLabelTTF:create(getLanguageTranslated("主淫，发现有新内容(").. downLoadSize_M ..getLanguageTranslated("M),更新吧?"), "Verdana", 24,CCSizeMake(390,150));
				updateText:setAnchorPoint(ccp(0, 0));
				updateText:setColor(ccc3(0,0,0))
				updateText:setPosition(ccp(_winSize.width / 2 - 200,_winSize.height / 2 - 50));
				mainScene:addChild(updateText);

				local function onClickConfirmBtn(eventType,position)
					local x = position[1]
					local y = position[2]
					
					local touchLayer1PosX = touchLayer1:getPositionX()
					local touchLayer1PosY = touchLayer1:getPositionY()
					local touchLayer2PosX = touchLayer2:getPositionX()
					local touchLayer2PosY = touchLayer2:getPositionY()
			
					-- 取消更新即退出游戏
					if x > touchLayer1PosX and x < touchLayer1PosX + cancelBtnBg.width and y > touchLayer1PosY and y < touchLayer1PosY + cancelBtnBg.height then 
						CCDirector:sharedDirector():endToLua();
					end

					-- 更新补丁
					if x > touchLayer2PosX and x < touchLayer2PosX + confirmBtnBg.width and y > touchLayer2PosY and y < touchLayer2PosY + confirmBtnBg.height then 
	
						if _tipsLabel then
							_tipsLabel:setVisible(true)
						end

						ResManager:getInstance():downLoadResource2();
						
						_loadingBG:setVisible(false)
						tipsBg:setVisible(false)
						updateText:setVisible(false)
						touchLayer1:setVisible(false)
						touchLayer2:setVisible(false)
						
						touchLayer1:setTouchEnabled(false)
						
						touchLayer1:unregisterScriptTouchHandler();			
						touchLayer2:unregisterScriptTouchHandler();	

						-- 检查更新进度条
						local _checkUpdateScriptEntry = nil;
						local function checkUpdatedFiles(dt)
						  local isUpdateCompleted = ResManager:getInstance():isUpdateCompleted();
						  -- 下载完成
						  if isUpdateCompleted == KUpdateSucceed then
						    -- TODO 静态资源加载完成 
					    	updateLoadingProgress(1);
						    _loadMainApplication();
						    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_checkUpdateScriptEntry);
	  				  	  elseif isUpdateCompleted == KUpdateUnZip then
						    -- 更新进度条
						    updateLoadingProgress(1);
					      	updateLoadingLabel(getLanguageTranslated("解压中.."));
						  else
						    local getAllDownLoadBytes = ResManager:getInstance():getAllDownLoadBytes() or 0;
						    local getAllBytes = ResManager:getInstance():getAllBytes() or 0;

						    local percent = getAllDownLoadBytes/getAllBytes;
						    percent = percent or 0;
						    if tostring(percent) == "nan" then
						      percent = 0
						    end;
						    local formated = math.floor(percent * 10000) / 10000;

						    -- 更新进度条
						    updateLoadingProgress(formated);

						    if formated then
						      formated = formated * 100;
						      if formated ~= 0 then
						        -- 更新进度值
						        updateLoadingLabel(formated.."%");  
						      end
						    end
						  log("ResManager:getInstance():getUpdateState()=="..ResManager:getInstance():getUpdateState())
						    if ResManager:getInstance():getUpdateState() == 1 then 
						      CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_checkUpdateScriptEntry);
						      updateLoadingLabel(getLanguageTranslated("同步资源错误,点击屏幕重试.."));
						      button:setVisible(true);
						      he_log_error("[404] loading error."..ResManager:getInstance():getCurrentDownloadFileName());
						    end
						  end
						end		
						
						_checkUpdateScriptEntry = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkUpdatedFiles,0.05,false);			
					end
				end	 

				touchLayer1:registerScriptTouchHandler(onClickConfirmBtn, false, 0, true);
			end
		else
			_loadMainApplication();
		end
	end
	local updateTimer
	local function updateTimerFunc()
		if logcompleteBoo then
			log("--checking--resource-- done")
			if updateTimer then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(updateTimer);  
			end
			getInGame()
		else
			log("--checking--resource--")
		end
	end

    updateTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimerFunc, 0.1, false)

end

function buildMainLoadingScene(onLogoAnimationFinished, loadMainApplication)

  	_loadMainApplication = loadMainApplication
  	--add a loading icon, replace engine's startup mainScene
  	_winSize = CCDirector:sharedDirector():getWinSize()

	mainScene = CCScene:create();
	mainScene:setAnchorPoint(ccp(0,0));

	_tipsLabel = CCLabelTTF:create(getLanguageTranslated("正在检查版本信息，请稍候..."), "Verdana", 20);
	_tipsLabel:setAnchorPoint(ccp(0.5, 0));
	_tipsLabel:setColor(ccc3(255,255,255))
	_tipsLabel:setPosition(ccp(_winSize.width/2, 25));
	mainScene:addChild(_tipsLabel);
	_tipsLabel:setVisible(false)

	local function afterLogo()

		if CommonUtils:getCurrentPlatform() ~= CC_PLATFORM_IOS then
			logo:setVisible(false)
		end

		buildProgressBar()

		_tipsLabel:setVisible(true)

		logcompleteBoo = true

	end

	local function logoAction()

		local loading = CCSprite:create("embed/loading_screen.jpg");
		loading:setAnchorPoint(ccp(0.5,0.5));
		loading:setPosition(ccp(_winSize.width/2,_winSize.height/2));
		loading:setScale(CommonUtils:getGameUIScaleRate())

		mainScene:addChild(loading);

	    -- if CommonUtils:getVersionCode() ~= "100" then
			logo = CCSprite:create("embed/happyelements.jpg");
			logo:setAnchorPoint(ccp(0.5, 0.5));
			logo:setPosition(ccp(_winSize.width / 2, _winSize.height / 2));  
			logo:setScale(CommonUtils:getGameUIScaleRate())
			mainScene:addChild(logo);	

			-- local _logScheduler
			local logoActions = CCArray:create();
			if CommonUtils:getVersionCode() == PlatformConfig.PLATFORM_CODE_BAIDU then
				logoActions:addObject(CCDelayTime:create(3));
			else
				logoActions:addObject(CCDelayTime:create(1.5));
			end

			logoActions:addObject(CCFadeOut:create(0.8,0.8));
			logoActions:addObject(CCCallFunc:create(afterLogo));
			logo:runAction(CCSequence:create(logoActions));
		-- else
		-- 	afterLogo()
		-- end		
	end

	if CommonUtils:getVersionCode() == "4" then
		platformLogo = CCSprite:create("embed/platform.png");
		platformLogo:setAnchorPoint(ccp(0.5, 0.5));
		platformLogo:setPosition(ccp(_winSize.width / 2, _winSize.height / 2));  
		platformLogo:setScale(CommonUtils:getGameUIScaleRate())
		mainScene:addChild(platformLogo);	

		-- local _logScheduler
		local logoActions1 = CCArray:create();
		logoActions1:addObject(CCDelayTime:create(0.7));
		logoActions1:addObject(CCFadeOut:create(0.8,0.8));
		logoActions1:addObject(CCCallFunc:create(logoAction));
		platformLogo:runAction(CCSequence:create(logoActions1));		
	else
		logoAction()
	end

	button = CCLayerColor:create(ccc4(255,255,255,0), _winSize.width, _winSize.height);
	button:setPosition(ccp((_winSize.width - 1280)/2,(_winSize.height - 720)/2));
	mainScene:addChild(button);

	button:setTouchEnabled(true);
	button:setVisible(false);

	CCDirector:sharedDirector():runWithScene(mainScene);	

	-- 检查更新进度条
	local _delayLoadTimer = nil;
	local function _delayLoadFunction()

		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_delayLoadTimer);

	    if CommonUtils:getCurrentPlatform() == CC_PLATFORM_ANDROID then
	      luaDeployAssets();
	    end

		if kCurrentResourceEnvironment ~= kResourceEnvironment.kDebugLocal then
			onLogoAnimationFinished()
		else -- win32
			_loadMainApplication();
		end	
	end		
	
	_delayLoadTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(_delayLoadFunction,0.05,false);


	--------------------------------

	-- -- -- test begin
	-- fullPackUpdate()  
	-- buildProgressBar()
	-- updateLoadingProgress(0.5)
	-- -- -- test end

	return button;
end
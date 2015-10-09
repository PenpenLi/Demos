require "core.net.SocketManager"
require "main.model.UserProxy"
require "main.config.GameConfig";
require "main.config.FunctionConfig";
require "main.config.CountControlConfig";
require "main.config.TutorConfig";
require "main.managers.GameData";
require "main.view.preloadScene.PreloadSceneMediator";
require "core.utils.CommonUtil"
require "core.utils.MusicUtils"
require "core.display.Director";
require "main.controller.command.load.LoadSceneCompleteCommand";
require "main.controller.command.load.BeginLoadingSceneCommand";
require "main.controller.notification.LoadingNotification";
require "main.controller.notification.PreloadSceneNotification";
require "main.controller.command.preloadScene.PreloadSceneToSendLoadCommand";
require "main.controller.command.preloadScene.PreloadSceneToServerCommand";
require "main.controller.command.preloadScene.PreloadSceneCloseCommand";
require "resource.image.arts.arts";
require "main.common.CommonExcel";
require "core.controls.CommonPopup"
require "main.config.SmallLoadingConifg"
require "main.config.PopupMessageConstConfig"
require "main.common.UiBackGroundLayer"
require "main.config.StaticArtsConfig"

GameStartCommand = class(MacroCommand);

function GameStartCommand:ctor()
	self.class = GameStartCommand;
end

function GameStartCommand:execute()
	
	local userProxy=UserProxy.new();
	self:registerProxy(userProxy:getProxyName(),userProxy);

	local preLoadSceneMediator = self:retrieveMediator(PreloadSceneMediator.name)
	if preLoadSceneMediator == nil then

		preLoadSceneMediator = PreloadSceneMediator.new();
		self:registerMediator(preLoadSceneMediator:getMediatorName(),preLoadSceneMediator);
		self:registerCommand(PreloadSceneNotifications.SERVER_COMMAND,PreloadSceneToServerCommand);
		self:registerCommand(PreloadSceneNotifications.SCENE_CLOSE_COMMAND,PreloadSceneCloseCommand);
		
		if GameData.connectType == 0 or GameData.connectType == 2 then
			log("zhangke---11----"..CommonUtils:getOSTime())
		
			gamestartPreloadingMeidator = preLoadSceneMediator

			GameData.currentSceneIndex = 1

			local loopFunction
			local function localFun()

				if loopFunction then
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
				end

				hecDC(2,20)
				login()

			end
			
			loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0.1, false)
			
		elseif GameData.connectType == 1 or GameData.connectType == 3 then --断线重连/被踢下线
			if GameData.serverIsOpen == "1" then
				local isExecuteNow = nil;--下一次执行connect的时候才去连,这是由于HeSocket::mainThreadReceiveData被反订阅的同一帧里面再订阅无效的原因
				local function connect()
					if not isExecuteNow then
						isExecuteNow = true
						return;
					end
					local connectBoo = connectTo(GameData.serverAdd,8081,true);
					if(connectBoo) then
						GameData.isConnecting = true
						GameData.isConnect = true
						if nil ~= self.heartHitFunctionID then
							Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.heartHitFunctionID);  
							uninitializeSmallLoading();
						end

						-- sendMessage(1,5);
						sendFirstMessageToServer()

						local mapSceneData = {}
    					mapSceneData["sceneType"] = GameConfig.SCENE_TYPE_1
						local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};

						self:addSubCommand(BeginLoadingSceneCommand)
						self:complete(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))
						GameData.heartHitCount = 0
						-- GameData.isPopQuitPanel = false
						Director:sharedDirector():replaceScene(preLoadSceneMediator:getViewComponent());
						GameData.currentSceneIndex = 1
					end
					return connectBoo;
				end

				if not GameData.isConnect then
					self.heartHitFunctionID = Director:sharedDirector():getScheduler():scheduleScriptFunc(connect, 0, false)
					initializeSmallLoading();
				end
			end
		-- elseif GameData.connectType == 2	 then
		-- 	GameData.isPopQuitPanel = false
		-- 	Director:sharedDirector():replaceScene(preLoadSceneMediator:getViewComponent());
		-- 	GameData.currentSceneIndex = 1
		end
		--load
		self:registerCommand(LoadingNotifications.BEGIN_LOADING_SCENE, BeginLoadingSceneCommand);
		self:registerCommand(LoadingNotifications.LOAD_SCENE_COMPLETE, LoadSceneCompleteCommand);  
	end	
	CommonKeypadDelegate:getInstance():registerKeypadDispatcher("onRunGameKeypadCallback");  
	CommonUtils:registerGround("onRunGameGround");  

	-- 切换场景时需要做的事
	GameData.isPopQuitPanel = false	
end

-- 响应手机按键
function onRunGameKeypadCallback()
	log("zhangke------onRunGameKeypadCallback-------0")
	if onRunGameKeypadBackClose() then
		return;
	end

	if GameData.isPopQuitPanel then
       return;
	end

    -- 平台特殊需求  走自己的返回界面
    -- 360 iqiyi uc
	if GameData.platFormID == GameConfig.PLATFORM_CODE_360
	or GameData.platFormID == GameConfig.PLATFORM_CODE_IQIYI
	or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
	 then
		exitGame()
		return
	end

	local quitStr = StringUtils:getString4Popup(PopupMessageConstConfig.ID_230)
	local text_table = StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_230)
	
	local function closeGame()
		Director:sharedDirector():endGame();
	end

	local function returnGame()
		GameData.isPopQuitPanel = false
	end	
			
	GameData.isPopQuitPanel = true
	local tips=CommonPopup.new();
	tips:initialize(quitStr,self,closeGame,nil,returnGame,nil,nil,text_table,nil,true,3);
	commonAddToScene(tips, true)
end

function onRunGameKeypadBackClose()
	if HaoyouYingxiongkuLayer then
		if HaoyouYingxiongkuLayer:clean() then
			return true;
		end
	end
	if PlayerInfoPopup then
		if PlayerInfoPopup:clean() then
			return true;
		end
	end
	if CommonTips then
		CommonTips:removeTip();
	end
	if TipNotification then
		Facade:getInstance():sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND));
	end
	if CommonPopup then
		local len = table.getn(CommonPopup.commonPopupArr);
		if 0 < len then
			CommonPopup.commonPopupArr[len]:onSmallCloseButtonTap(nil);
			return true;
		end
	end
	if isNeedRemoveMainScript() then
		return true
	end
	if LayerManager and GameVar.tutorStage == TutorConfig.STAGE_99999 then
		local len = table.getn(LayerManager.layerKeyBackables);
		if 0 < len then
			local layerKeyBackable = LayerManager.layerKeyBackables[len];
			layerKeyBackable:closeUI(nil);
			return true;
		end
	end
	return false;
end

-- 监听home键返回
function onRunGameGround(flag)
    
	-- false 说明是从home键返回的
	-- true 说明是进入home键
	if flag then
		MusicUtils:pause()
	else
		log("onRunGameGround---1")

		if GameData.isMusicOn then
			MusicUtils:resume()
		end	

		local loopFunction
		local function localFun()

			if loopFunction then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopFunction)
			end

			if not GameData.isConnect then
				log("onRunGameGround---2")
			else
				log("onRunGameGround---3")
				if not GameData.isConnecting then
					log("onRunGameGround---4")
					-- 向服务器端
					if GameData.userID and GameData.userID ~= "" then
						log("onRunGameGround---5")
					    if CommonUtils:getCurrentPlatform() ~= CC_PLATFORM_WIN32 then
							sendMessage(2,14,{UserId=GameData.userID});
						end
					else -- 否则返回登录界面
						-- log("onRunGameGround---6")
						-- logoutSuccess(GameConfig.CONNECT_TYPE_0)
					end
				end
			end
		end
		
		loopFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 0.5, false)

	end
end
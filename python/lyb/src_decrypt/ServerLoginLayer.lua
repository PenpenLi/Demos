
ServerLoginLayer=class(Layer);

function ServerLoginLayer:ctor()
	self.class=ServerLoginLayer;
end

function ServerLoginLayer:dispose()
  	self:removeAllEventListeners();
  	self:removeChildren();
	ServerLoginLayer.superclass.dispose(self);
	self:removeCacheHandleTimer()
	self.armature:dispose()
	self.armature= nil;
end

function ServerLoginLayer:initialize(popUp)
	if self.popUp then return;end;
	self:initLayer();
	self.popUp = popUp;
	local skeleton = self.popUp.skeleton

	local armature=skeleton:buildArmature("serverLogin_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	-- local backImage = Image.new()
	-- backImage:loadByArtID(StaticArtsConfig.BACKGROUD_COMMON_BG)
	-- self:addChildAt(backImage,0)
	-- backImage.touchEnabled=true;
	-- backImage.touchChildren=true;

	local armature_d=armature.display;
	self:addChild(armature_d);
	self.armature_d = armature_d;

	local selectButton=armature_d:getChildByName("login_select_button");
	local selectButtonP = convertBone2LB4Button(selectButton);
	armature_d:removeChild(selectButton);

	local beginGameButton = armature_d:getChildByName("common_big_blue_button");
	local beginGameButtonP = convertBone2LB4Button(beginGameButton);
	armature_d:removeChild(beginGameButton);
	
	local login_server_bg = armature_d:getChildByName("login_server_bg");	
	login_server_bg:addEventListener(DisplayEvents.kTouchTap,self.selectButtonHandler,self);

	local officialButtonData = armature:findChildArmature("back_button"):getBone("common_blue_button").textData;

	local selectButton = CommonButton.new();
	selectButton:initialize("login_select_button_normal","login_select_button_down",CommonButtonTouchable.DISABLE,skeleton);
	selectButton:setPosition(selectButtonP);
	self:addChild(selectButton);
	self.selectButton=selectButton;

	local interButton = CommonButton.new();
	interButton:initialize("commonButtons/common_big_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
	interButton:setPosition(beginGameButtonP);
	self:addChild(interButton);
	self.interButton=interButton;
	self.interButton:addEventListener(DisplayEvents.kTouchTap,self.popUp.interButtonHandler,self.popUp);

	self.beginGamePic = armature_d:getChildByName("common_copy_begin_game");
	local contentSize = self.beginGamePic:getContentSize()
	self.beginGamePic:setAnchorPoint(CCPointMake(0.5, 0.5));
	self.beginGamePic:setPositionXY(self.beginGamePic:getPositionX() + contentSize.width / 2, self.beginGamePic:getPositionY() - contentSize.height / 2);
	self.beginGamePic.touchEnabled = false;
    self.beginGamePic.touchChildren = false;
	self:addChild(self.beginGamePic);
	self.interButton:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
	armature_d:removeChild(self.beginGamePic);


	local text_data = armature:getBone("login_server_text").textData;
	self.serverText = createTextFieldWithTextData(text_data,"");
	self.serverText.touchEnabled = false
	self:addChild(self.serverText);

	text_data = armature:getBone("login_state_text").textData;
	self.stateText = createTextFieldWithTextData(text_data,"");
	self.stateText.touchEnabled = false
	self:addChild(self.stateText);

	-- local baziTextData = armature:getBone("bazizhenyanLabel").textData;
	-- local baziText = createTextFieldWithTextData(baziTextData,"抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防上当受骗。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。");
	-- baziText:setPositionXY(8,5)
	-- self:addChild(baziText);

	local back_button=armature_d:getChildByName("back_button");
	armature_d:removeChild(back_button);

	-- 
	if GameData.platFormID == GameConfig.PLATFORM_CODE_WAN
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_LAN
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_BASE
	 or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI	 
	 then
		local back_button = CommonButton.new();
		back_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
		back_button:initializeBMText("账号管理","anniutuzi");
		back_button:setPosition(ccp(30,30));
		self:addChild(back_button);
		self.back_button=back_button;
		self.back_button:addEventListener(DisplayEvents.kTouchTap,self.popUp.backButtonHandler,self.popUp);
	
	end
end

function ServerLoginLayer:onTipsBegin(event)
	event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);

	self.beginGamePic:setScale(0.9);
end
function ServerLoginLayer:onTipsEnd(event)
	self.beginGamePic:setScale(1);
end

function ServerLoginLayer:setLoginServer()
	local serverData,bool = self.popUp:getMyServerData()
	self:refreshLoginServer(serverData,bool)
end

function ServerLoginLayer:refreshLoginServer(serverData,bool)
	self.serverText:setString(serverData.name)
	
	GameData.serverName = serverData.name

	if serverData.isOpen == "1" then
		if bool then
			self.stateText:setString(self.popUp:getServerState(serverData.state))
			local color = CommonUtils:ccc3FromUInt(getColorByQuality(self.popUp:getcolorNumber(serverData.state)));
		    self.stateText:setColor(color);
		else
			self.stateText:setString(self.popUp:getServerTags(serverData.tags))
		end
	elseif serverData.isOpen == "0" then
		self.stateText:setString(self.popUp:getServerState(serverData.isOpen))
		local color = CommonUtils:ccc3FromUInt(getColorByQuality(self.popUp:getcolorNumber(serverData.isOpen)));
	    self.stateText:setColor(color);
	end
	self.popUp:setTempServerData(serverData)
end

function ServerLoginLayer:selectButtonHandler()

	if GameData.isMusicOn then
		MusicUtils:playEffect(7,false);
	end  

	local webPlatForm = false
	if   GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_91  --IOS越狱平台 -- adroid平台
      or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_XY
      or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_KY
      or (GameData.platFormID == GameConfig.PLATFORM_CODE_WAN 
      		and CommonUtils:getChannelID() == "1") then

		if requestServersTable == nil then 
			webPlatForm = true
		end
	end

	if webPlatForm then
		sharedTextAnimateReward():animateStartByString("正在刷新服务器列表");
		return
	else
		require "main.view.serverScene.ui.ServerListLayer";
		local serverListLayer = ServerListLayer.new();
		serverListLayer:initialize(self.popUp);
		self.popUp.serverListLayer = serverListLayer
		self.popUp:addChild(serverListLayer);
		--self:interButtonVisible(false)		
	end
end

function ServerLoginLayer:interButtonVisible(bool)

  self.interButton:setVisible(bool)
  self.back_button:setVisible(bool);

end

function ServerLoginLayer:removeCacheHandleTimer()
    if self.cacheHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.cacheHandle);
        self.cacheHandle = nil
    end
end
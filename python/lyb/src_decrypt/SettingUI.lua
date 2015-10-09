
SettingUI = class(Layer)

function SettingUI:ctor()
	self.class = SettingUI

end

function SettingUI:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	SettingUI.superclass.dispose(self);

	BitmapCacher:removeUnused();
end
function SettingUI:initialize(context)
	self.context = context;
    self:initLayer();
    self:onDataInit()
    self:onUIInit()
end
function SettingUI:onDataInit()
  	local proxyRetriever  = ProxyRetriever.new();
	self.storyLineProxy = proxyRetriever:retrieveProxy(StoryLineProxy.name)
	self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
	self.userProxy=proxyRetriever:retrieveProxy(UserProxy.name);
	self.heroHouseProxy=proxyRetriever:retrieveProxy(HeroHouseProxy.name);
	self.openFunctionProxy = proxyRetriever:retrieveProxy(OpenFunctionProxy.name)
	self.bagProxy = proxyRetriever:retrieveProxy(BagProxy.name);
	self.skeleton = getSkeletonByName("operate_ui");

end	
function SettingUI:onUIInit()

	local armature = self.skeleton:buildArmature("setting_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	self:addChild(self.armature.display);

	local armature_d=armature.display;
	self.armature_d = armature_d;

	self.mainSize = Director:sharedDirector():getWinSize()


	self:setContentSize(self.mainSize)


	local layerColor1 = LayerColor.new();
	layerColor1:initLayer();
	layerColor1:changeWidthAndHeight(self.mainSize.width, self.mainSize.height);
	layerColor1:setColor(ccc3(0,0,0));
	layerColor1:setOpacity(200);
	layerColor1:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)
	layerColor1:addEventListener(DisplayEvents.kTouchTap, self.onLayerColor, self);

	self:addChildAt(layerColor1,0)   


	self.gmButton = self.armature.display:getChildByName("gmButton");

	SingleButton:create(self.gmButton, nil, 0);
	self.gmButton:addEventListener(DisplayEvents.kTouchTap, self.onGMButton, self);
	self.gmButton:setAnchorPoint(ccp(0.5,0.5))

	self.returnLoginButton = self.armature.display:getChildByName("returnLoginButton");
	SingleButton:create(self.returnLoginButton, nil, 0);
	self.returnLoginButton:addEventListener(DisplayEvents.kTouchTap, self.onReturnLoginButton, self);
	self.returnLoginButton:setAnchorPoint(ccp(0.5,0.5))



	self.fobbidenButton = self.armature.display:getChildByName("fobbidenButton");
	self.fobbidenButton:setVisible(false)
	self.fobbidenButton.touchEnabled = false;

	self.soundButton = self.armature.display:getChildByName("soundButton");
	SingleButton:create(self.soundButton, nil, 0);
	self.soundButton:addEventListener(DisplayEvents.kTouchTap, self.onSoundButton, self);
	self.soundButton:setAnchorPoint(ccp(0.5,0.5))

	self.weixin_bg = self.armature.display:getChildByName("weixin_bg");
	SingleButton:create(self.weixin_bg, nil, 0);
	self.weixin_bg:addEventListener(DisplayEvents.kTouchTap, self.onWeixin, self);
	self.weixin_bg:setAnchorPoint(ccp(0.5,0.5))

	self.weibo_bg = self.armature.display:getChildByName("weibo_bg");
	SingleButton:create(self.weibo_bg, nil, 0);
	self.weibo_bg:addEventListener(DisplayEvents.kTouchTap, self.onWeibo, self);
	self.weibo_bg:setAnchorPoint(ccp(0.5,0.5))

	self.guanwang_bg = self.armature.display:getChildByName("guanwang_bg");
	SingleButton:create(self.guanwang_bg, nil, 0);
	self.guanwang_bg:addEventListener(DisplayEvents.kTouchTap, self.onGuanWang, self);
	self.guanwang_bg:setAnchorPoint(ccp(0.5,0.5))


    self.tipContent_txt=TextField.new(CCLabelTTF:create("点击任意位置关闭",FontConstConfig.OUR_FONT,26));
    self.tipContent_txt.touchEnabled = false;
    self.tipContent_txt:setPositionXY(550,175);
    self:addChild(self.tipContent_txt);

	self:setData()
end

function SettingUI:onLayerColor(event)
	self.parent:removeChild(self)
end
function SettingUI:onWeixin(event)
    sharedTextAnimateReward():animateStartByString("功能尚未开启~");
	print("onWeixin")
end

function SettingUI:onWeibo(event)
	sharedTextAnimateReward():animateStartByString("功能尚未开启~");
	print("onWeibo")
end

function SettingUI:onClickGMButton(event)
	print("onClickGMButton")
end

function SettingUI:onSoundButton( event )
	print("onSoundButton")
	if GameData.isMusicOn then
		GameData.isMusicOn = false
		self.fobbidenButton:setVisible(true)
		MusicUtils:stop(true);
		saveLocalInfo("sound","0");	
	else
		GameData.isMusicOn = true
		self.fobbidenButton:setVisible(false)
		if 1 == self.storyLineProxy:getStrongPointState(10001011) then
			MusicUtils:play(1003,GameData.isMusicOn);
		else
			MusicUtils:play(1002,GameData.isMusicOn);
		end

		saveLocalInfo("sound","1");	
	end

end
function SettingUI:onGMButton( event )
	print("onGMButton")
	if GameData.platFormID ~= GameConfig.PLATFORM_CODE_LAN then
		callJira();
	end
end
function SettingUI:onGuanWang( event )
	print("onGuanWang")
    openUrl("http://lybgame.com/home/main/")
end
function SettingUI:setData()
	if GameData.isMusicOn then
		self.fobbidenButton:setVisible(false)
	else
		self.fobbidenButton:setVisible(true)
	end	
end

function SettingUI:onUIClose()
  print("onUIClose")
  self:dispatchEvent(Event.new("REMOVE_OPERATION",nil,self));
end
function SettingUI:onReturnLoginButton(event)

	-- add by mohai.wu 停开服七天的时间倒计时
	local proxyRetriever  = ProxyRetriever.new();
	local huodongProxy = proxyRetriever:retrieveProxy(HuoDongProxy.name);
	huodongProxy:stopHuodongTimer();

	MusicUtils:playEffect(7,false)
	
	logout()


end

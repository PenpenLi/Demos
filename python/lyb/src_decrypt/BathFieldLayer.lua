require "main.view.family.bathField.ui.BathFieldRender"

BathFieldLayer=class(Layer);

function BathFieldLayer:ctor()
	self.class=BathFieldLayer;
	self.defaultPosTbl = {};
	self.posTbl = {};
	self.playerInfos = {};
	self.placeTbl = {};	--记录哪些位置已经有人,主要作用是去重
	self.skeleton = nil;
	self.timer = nil;	--用于控制刷频频率
	self.delayTime = 10;	--暂定的发送间隔

	self.const_Image_bg = 2732;--仙人浴底背景1280x720
end

function BathFieldLayer:dispose()
	self:disposeTimer();
	self.armature:dispose();
	self:removeAllEventListeners();
	self:removeChildren();
	BathFieldLayer.superclass.dispose(self);
end

function BathFieldLayer:initialize(skeleton,userCurrencyProxy)
	self:initLayer();
	self.userCurrencyProxy = userCurrencyProxy;
	self.skeleton = skeleton;

	

	local armature=self.skeleton:buildArmature("main_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	local armature_d=armature.display;
	self:addChild(armature_d);
	self.armature_d = armature_d;
	
	-- add ui back
	AddUIBackGround(self,StaticArtsConfig.BATH_FIELD);
	
	self.touchChildren = true;
	self.touchEnabled = true;

	local renderStr = "render_"
	for i=1,8 do
		local renderDO = armature:getBone(renderStr..i):getDisplay();
		self.posTbl[i] = ccp(renderDO:getPosition().x,renderDO:getPosition().y);
		self.defaultPosTbl[i] = ccp(renderDO:getPosition().x,renderDO:getPosition().y);
		armature_d:removeChild(renderDO);
	end
	
	local totalTbl = analysisTotalTable("Jiazu_Wenquanjiangli");

	local count = 0;
	for k,v in pairs(totalTbl)do
		count = count + 1;
	end


	local textData = armature:getBone("background").textData;
	-- local text = analysis("Jiazu_Huodong",3,"information");
	local descText = createTextFieldWithTextData(textData,"人数满四人即可完成沐浴。每天沐浴次数不限，只有前4次可以获得奖励，\n每次获得体力50点。消耗50000银两可以“邀请美女”共浴。");
	armature_d:addChild(descText);

	local closeButton = armature:getBone("common_copy_close_button"):getDisplay();
	local closeButtonPos = convertBone2LB4Button(closeButton);
	armature_d:removeChild(closeButton);
	closeButton = CommonButton.new();
	closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	closeButton:setPosition(closeButtonPos);
	closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
	self:addChild(closeButton);
	
	local leftButton = armature:getBone("leftButton"):getDisplay();
	self.leftButtonPos = convertBone2LB4Button(leftButton);
	armature_d:removeChild(leftButton);
	local rightButton = armature:getBone("rightButton"):getDisplay();
	self.rightButtonPos = convertBone2LB4Button(rightButton);
	armature_d:removeChild(rightButton);
	
	self:updateAttendButton();

  	AddUIFrame(self);
end


function BathFieldLayer:onCloseButtonTap(event)
	self:dispatchEvent(Event.new("BATHFIELD_CLOSE",nil,self));
end

function BathFieldLayer:onTapSummonBeauty(event)
	-- print("onTapSummonBeauty");
	local function onConfirm()
		self:dispatchEvent(Event.new("SummonBeauty"));
		self:setTouchStatus(false);
	end
	if self.userCurrencyProxy:getSilver() >= 50000 then
		local castTip = CommonPopup.new();
		castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_159),self,onConfirm,_,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_159));
		self:addChild(castTip);
	else
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
	end

end

function BathFieldLayer:onTapSummonLittleBuddy(event)
	-- print("onTapSummonLittleBuddy");
	if not self.timer then
		self.timer=RefreshTime.new();
		self.timer:initTime(self.delayTime,_,_);
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_169));
		local sendTbl = {};
		sendTbl.UserName = self.playerInfo.UserName;
		sendTbl.MainType = ConstConfig.MAIN_TYPE_CHAT;
		sendTbl.SubType = ConstConfig.SUB_TYPE_FACTION;
		sendTbl.ChatContentArray = {};
		sendTbl.ChatContentArray[1] = {};
		sendTbl.ChatContentArray[1].Type = 1;
		sendTbl.ChatContentArray[1].ParamStr1 = "F1FF00";
		sendTbl.ChatContentArray[1].ParamStr2 = "";
		sendTbl.ChatContentArray[1].ParamStr3 = "";

		local defaultContent
		if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
			defaultContent = getLuaCodeTranslated("我正在仙人温泉沐浴，小伙伴们快来参加啊。")
		else
			defaultContent = "我正在仙人温泉沐浴，小伙伴们快来参加啊。"
		end
		sendTbl.ChatContentArray[1].ParamStr4 = defaultContent;
		self:dispatchEvent(Event.new("SummonLittleBuddy",sendTbl));
	else
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_170));
		if 0 >= self.timer:getTotalTime() then
			self:disposeTimer();
		end
	end
end

function BathFieldLayer:disposeTimer()
	if self.timer then
		self.timer:dispose();
		self.timer = nil;
	end
end


function BathFieldLayer:updatePlayers(otherPlayerInfos,playerInfo)
	self.playerInfos = otherPlayerInfos;
	self.playerInfo = playerInfo;
	for k,v in pairs(otherPlayerInfos) do
		if not self.placeTbl[v.BathroomId] then
			local render = BathFieldRender.new();
			if v.UserName == playerInfo.UserName then
				render:initialize(self.skeleton,v,true);
				self:updateButtonStatus();
			else
				render:initialize(self.skeleton,v,false);
			end
			render:setPosition(self:getRandomPos());
			self.armature_d:addChild(render);
			self.placeTbl[v.BathroomId] = render;
		end
	end
end

function BathFieldLayer:attendPool(evt)
	-- local function confirm()
		self:dispatchEvent(Event.new("INTO_BATH_POOL"));
	-- end
	-- local currentTili = self.userCurrencyProxy:getTili();
	-- local maxTili = analysis("Xishuhuizong_Xishubiao",49,"constant");	--VIP0体力上限
	-- if currentTili >= maxTili then
	-- 	local commonPopup=CommonPopup.new();
	-- 	commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_175),self,confirm,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_175));
	-- 	self:addChild(commonPopup);
	-- elseif currentTili >= maxTili/2 then
	-- 	local commonPopup=CommonPopup.new();
	-- 	commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_174),self,confirm,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_174));
	-- 	self:addChild(commonPopup);
	-- else
	-- 	confirm();
	-- end
end


function BathFieldLayer:getRandomPos()
	math.randomseed(os.time());
	math.random();
	math.random();
	math.random();
	local returnPos
	while not returnPos do
		local temp = math.random(8);
		if self.posTbl[temp] then
			returnPos = ccp(self.posTbl[temp].x,self.posTbl[temp].y);
			self.posTbl[temp] = nil;
			break;
		end
	end
	return returnPos;
end

function BathFieldLayer:setTouchStatus(bool)
	self.armature_d.touchChildren = bool;
end

function BathFieldLayer:updateButtonStatus()
	self.attendButton:removeAllEventListeners();
	self.armature_d:removeChild(self.attendButton);
	self.attendButton = nil;



	self.leftButton = CommonButton.new();
	local leftTextData = self.armature:findChildArmature("leftButton"):getBone("common_copy_bluelonground_button").textData;
	self.leftButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	self.leftButton:initializeText(leftTextData,"召集伙伴");
	self.leftButton:setPosition(self.leftButtonPos);
	self.leftButton:addEventListener(DisplayEvents.kTouchTap,self.onTapSummonLittleBuddy,self);
	self.armature_d:addChild(self.leftButton);
	
	
	self.rightButton = CommonButton.new();
	local rightTextData = self.armature:findChildArmature("rightButton"):getBone("common_copy_bluelonground_button").textData;
  self.rightButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  self.rightButton:initializeText(rightTextData,"邀请美女");
  self.rightButton:setPosition(self.rightButtonPos);
	self.rightButton:addEventListener(DisplayEvents.kTouchTap,self.onTapSummonBeauty,self);
	self.armature_d:addChild(self.rightButton);
end

function BathFieldLayer:onResault(gain)
	-- local function confirm()
	-- 	self:sendNotification(ActivityNotification.new(ActivityNotifications.GETREWARD,22));
	-- end
	for k,v in pairs(self.placeTbl)do
		self.armature_d:removeChild(v);
		self.placeTbl[k] = nil;
	end

	self.posTbl = copyTable(self.defaultPosTbl);
	if gain > 0 then
		local commonPopup=CommonPopup.new();
		commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_161,{gain}),self,_,_,nil,nil,true);
		self:addChild(commonPopup);
	else
		local commonPopup=CommonPopup.new();
		commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_190),self,_,_,nil,nil,true);
		self:addChild(commonPopup);
	end
	self:updateAttendButton();
end

function BathFieldLayer:updateAttendButton()
	if self.leftButton and self.rightButton then
		self.leftButton:removeAllEventListeners();
		self.armature_d:removeChild(self.leftButton);
		self.leftButton = nil;
		self.rightButton:removeAllEventListeners();
		self.armature_d:removeChild(self.rightButton);
		self.rightButton = nil;
	end
	if not self.attendButton then
		self.attendButton = CommonButton.new();
		local rightTextData = self.armature:findChildArmature("rightButton"):getBone("common_copy_bluelonground_button").textData;
	  self.attendButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	  self.attendButton:initializeText(rightTextData,"进入浴池");
	  self.attendButton:setPositionXY(self.rightButtonPos.x/2+self.leftButtonPos.x/2,self.rightButtonPos.y);
		self.attendButton:addEventListener(DisplayEvents.kTouchTap,self.attendPool,self);
		self.armature_d:addChild(self.attendButton);
	end
end
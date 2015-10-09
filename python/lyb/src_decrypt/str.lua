require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

local function makeNameStr(name)
	local str = "";
    local _count = -1;
    while (-1-string.len(name)) < _count do
		str = str .. string.sub(name, -2 + _count, _count) .. "\n";
		_count = -3 + _count;
    end
    return str;
end

TreasuryPopup=class(LayerPopableDirect);
function TreasuryPopup:ctor()
  self.class=TreasuryPopup;
  
end
local heroHouseProxy;
function TreasuryPopup:dispose()
	heroHouseProxy = nil;
	self:disposeLTime();
	self:disposeRTime();
	TreasuryPopup.superclass.dispose(self);
end

function TreasuryPopup:initialize()
  heroHouseProxy = nil;
  self.skeleton=nil;
  self.userProxy = nil;
  self.countProxy = nil;
  self.openProxy = nil;
end
function TreasuryPopup:onDataInit()
	self.skeleton = getSkeletonByName("treasury_ui");
	local layerPopableData = LayerPopableData.new();
	layerPopableData:setHasUIBackground(true);
	layerPopableData:setHasUIFrame(false);
	layerPopableData:setPreUIData(StaticArtsConfig.LOADING_UI,nil,true);
	layerPopableData:setShowCurrency(true);
	layerPopableData:setArmatureInitParam(self.skeleton,"treasury_ui");
	self:setLayerPopableData(layerPopableData);
	self.countProxy = self:retrieveProxy(CountControlProxy.name);
	self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	-- setFactionCurrencyVisible(true);
end
function TreasuryPopup:onPrePop()
	self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT)); 
	self.armature_d = self.armature.display;
	self.dggsBtnA = self.armature:findChildArmature("dggsBtn")
	self.dggsBtnA_d = self.dggsBtnA.display;
	--self.dggsBtnA_d:setAnchorPoint(ccp(0.5,0.5));
	self.dggsBtnA_d:setScale(0.7);
	self.dggsBtnA_d:addEventListener(DisplayEvents.kTouchTap,self.selectLBtn,self);
	self.lCountTF = generateText(self.dggsBtnA_d,self.dggsBtnA,"countTF","111");
	local textData = self.dggsBtnA:getBone("nameTF").textData;
	local datas = analysisByName("Shili_Langyashilian","type",1);
	local name = "";
	for k,v in pairs(datas) do
		name = makeNameStr(v.name1);
		break;
	end

	-- local askd=self.armature.display:getChildByName("common_copy_ask_button");
	-- local ask_pos=convertBone2LB4Button(askd);
	-- self.armature.display:removeChild(askd);

	-- self.askBtn = CommonButton.new();
	-- self.askBtn:initialize("commonButtons/common_ask_button_normal","commonButtons/common_ask_button_down",CommonButtonTouchable.BUTTON);
	-- self.askBtn:setPositionXY(ask_pos.x,ask_pos.y + GameData.uiOffsetY);
	-- self.askBtn:addEventListener(DisplayEvents.kTouchTap,self.onShowTip,self);
	-- self.armature.display:addChild(self.askBtn);

	-- local closeBtn = self.armature.display:getChildByName("common_copy_close_button")
	-- local close_pos=convertBone2LB4Button(closeBtn);
	-- closeBtn:setVisible(false);
	-- --armature.display:removeChild(closeButton);

	-- local closeButton=CommonButton.new();
	-- closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	-- closeButton:setPositionXY(close_pos.x,close_pos.y + GameData.uiOffsetY);
	-- closeButton:addEventListener(DisplayEvents.kTouchTap,self.closeUI,self);
	-- self.armature.display:addChild(closeButton);

	self.askBtn = Button.new(self.armature:findChildArmature("common_copy_ask_button"),false,"");
	self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
	-- local pos = self.askBtn:getPosition();
	-- self.askBtn:setPositionXY(pos.x,pos.y+GameData.uiOffsetY);
	-- local closeBtn = self.armature.display:getChildByName("common_copy_close_button")
	-- closeBtn:setPositionY(closeBtn:getPositionY()+GameData.uiOffsetY);
	self.lNameTF = BitmapTextField.new(name,"anniutuzi");
	self.dggsBtnA_d:addChild(self.lNameTF);
	local lTB = self.dggsBtnA_d:getChildByName("common_copy_huaWen2");
	lTB:setScale(0.7);
	self.lNameTF:setPositionXY(textData.x,textData.y);
	self.leftListTmp = self.armature_d:getChildByName("leftListTmp");
	self.leftListTmp:setAnchorPoint(ccp(0.5,1));
	self.CDLTF = generateText(self.armature_d,self.armature,"CDLTF","");
	self.costTF = generateText(self.armature_d,self.armature,"costTF","花费"..analysis("Xishuhuizong_Xishubiao",1045,"constant").."元宝");
	self.lRsetBtn =  Button.new(self.armature:findChildArmature("common_copy_small_orange_button"),false,"重置");
	self.lRsetBtn:addEventListener(Events.kStart,self.onClickLRsetBtn,self);
	self.lBL = self.armature_d:getChildByName("lBL");
	self.lBL:setScale(2)
	Tweenlite:rotateForever(self.lBL,20,true)
	self.lRsetBtn:setVisible(false);
	self.costTF:setVisible(false);

	self.mfjjBtnA = self.armature:findChildArmature("mfjjBtn")
	self.mfjjBtnA_d = self.mfjjBtnA.display;
	--self.mfjjBtnA_d:setAnchorPoint(ccp(0.5,0.5));
	self.mfjjBtnA_d:setScale(0.7);
	self.mfjjBtnA_d:addEventListener(DisplayEvents.kTouchTap,self.selectRBtn,self);
	self.rCountTF = generateText(self.mfjjBtnA_d,self.mfjjBtnA,"countTF","222");
	local textData = self.mfjjBtnA:getBone("nameTF").textData;
	datas = analysisByName("Shili_Langyashilian","type",2);
	name = "";
	for k,v in pairs(datas) do
		name = makeNameStr(v.name1);
		break;
	end
	self.rNameTF = BitmapTextField.new(name,"anniutuzi");
	self.mfjjBtnA_d:addChild(self.rNameTF);
	local rTB = self.mfjjBtnA_d:getChildByName("common_copy_huaWen2");
	rTB:setScale(0.7);
	self.rNameTF:setPositionXY(textData.x,textData.y);
	self.rightListTmp = self.armature_d:getChildByName("rightListTmp");
	self.rightListTmp:setAnchorPoint(ccp(0.5,1));
	self.CDRTF = generateText(self.armature_d,self.armature,"CDRTF","");
	self.cost1TF = generateText(self.armature_d,self.armature,"cost1TF","花费"..analysis("Xishuhuizong_Xishubiao",1045,"constant").."元宝");
	self.rRsetBtn =  Button.new(self.armature:findChildArmature("common_copy_small_orange_button_1"),false,"重置");
	self.rRsetBtn:addEventListener(Events.kStart,self.onClickRRsetBtn,self);
	self.rBL = self.armature_d:getChildByName("rBL");
	self.rBL:setScale(2)
	Tweenlite:rotateForever(self.rBL,20,true)
	self.rRsetBtn:setVisible(false);
	self.cost1TF:setVisible(false);
	self.lBL:setVisible(false)
	self.rBL:setVisible(false)

	self.lineDown = self.armature_d:getChildByName("common_copy_line_down");
	self.lineDown.sprite:setFlipX(true);
	self.bgTmp = self.armature_d:getChildByName("bgTmp");
	local bg = LayerColorBackGround:getCustomBackGround(GameConfig.STAGE_WIDTH, 300, 200);
	self.bgTmp:addChild(bg);

	self:refreshCountData()
	sendMessage(19,1);
	hecDC(3,9,1);
end
function TreasuryPopup:onShowTip()
	local text=analysis("Tishi_Guizemiaoshu",9,"txt");
	TipsUtil:showTips(self.askBtn,text,500,nil,50);
end
function TreasuryPopup:onClickLRsetBtn()
	local userGold = self.userCurrencyProxy:getGold();
	local needGold = analysis("Xishuhuizong_Xishubiao",1045,"constant")
	if tonumber(needGold)>tonumber(userGold) then
    	sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
    	return;
    end
	sendMessage(3,7,{TimerType="2_1"});
end
function TreasuryPopup:onClickRRsetBtn()
	local userGold = self.userCurrencyProxy:getGold();
	local needGold= analysis("Xishuhuizong_Xishubiao",1045,"constant")
	if tonumber(needGold)>tonumber(userGold) then
    	sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
    	return;
    end
	sendMessage(3,7,{TimerType="2_2"});
end
function TreasuryPopup:selectLBtn()
	local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
	if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_38) then
		sharedTextAnimateReward():animateStartByString(analysis("Tishi_Tishineirong",1015,"captions"));
		return;
	end
	if self.LCount<=0 then return end;
	MusicUtils:playEffect(8,false);
	Tweenlite:scale(self.dggsBtnA_d,0.1,1,1,255);
	Tweenlite:scale(self.mfjjBtnA_d,0.1,0.7,0.7,255);
	self:setRenderData(self.leftListTmp,1);
	self.leftListTmp:setVisible(true)
	self.leftListTmp:setScale(0.01);
	Tweenlite:scale(self.leftListTmp,0.2,1,1,255);
	self.leftListTmp:setScale(1);
	self.rightListTmp:setVisible(false)
	self.lBL:setVisible(true)
	self.rBL:setVisible(false)
	if GameVar.tutorStage == TutorConfig.STAGE_1024 then
		openTutorUI({x=72, y=72, width = 120, height = 120, alpha = 125});
	end
end
function TreasuryPopup:selectRBtn()
	local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
	if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) then
		sharedTextAnimateReward():animateStartByString(analysis("Tishi_Tishineirong",1016,"captions"));
		return;
	end
	if self.RCount<=0 then return end;
	MusicUtils:playEffect(8,false);
	Tweenlite:scale(self.dggsBtnA_d,0.1,0.7,0.7,255);
	Tweenlite:scale(self.mfjjBtnA_d,0.1,1,1,255);
	self:setRenderData(self.rightListTmp,2);
	self.rightListTmp:setVisible(true)
	self.rightListTmp:setScale(0.01);
	Tweenlite:scale(self.rightListTmp,0.2,1,1,255);
	self.rightListTmp:setScale(1);
	self.leftListTmp:setVisible(false)
	self.lBL:setVisible(false)
	self.rBL:setVisible(true)
	
end
local function sortFun(a, b) return a.level<b.level end
function TreasuryPopup:setRenderData(sp,type)
	sp:removeChildren();
	local datas = analysisByName("Shili_Langyashilian","type",type);
	local dataArr = {};
	for k,v in pairs(datas) do
		table.insert(dataArr,v);
	end
	local idx = 0;
	table.sort( dataArr, sortFun);
	local tw = #dataArr*0.5;
	for k,v in pairs(dataArr) do
		local render = TreasuryRender.new(self.skeleton,self);
		render:setData(v);
		local render_d = render:getDisplay()
		sp:addChild(render_d);
		local x = (k-1-tw)*(render:renderWidth()+40)+20;
		render_d:setPositionXY(x,-300);
	end
	
end


function TreasuryPopup:refreshCountData()
	local count,ttlCount = self.countProxy:getRemainCountByID(CountControlConfig.TreasuryCount,1);
	self.lCountTF:setString("今日次数："..count.."/"..ttlCount);
	self.LCount = count;
	local count1,ttlCount1 = self.countProxy:getRemainCountByID(CountControlConfig.TreasuryCount,2);
	self.rCountTF:setString("今日次数："..count1.."/"..ttlCount1);
	self.RCount = count1;
end

function TreasuryPopup:setLTime(time)
	self:disposeLTime();
	local function onRestBtn()
		self.CDLTF:setString("");
		self.lRsetBtn:setVisible(false);
		self.costTF:setVisible(false);
		self.dggsBtnA_d.touchEnabled=true;
   		self.dggsBtnA_d.touchChildren=true;
	end
	if time<=0 then
		return onRestBtn();
	end
	local function cdTimeFun()
		if self.cdTimeLListener.totalTime <= 0 then
			self:disposeLTime();
			onRestBtn();
		else
			self.CDLTF:setString("冷却："..self.cdTimeLListener:getTimeStr());
			self.lRsetBtn:setVisible(true);
			self.costTF:setVisible(true);
		end
	end
	self.dggsBtnA_d.touchEnabled=false;
	self.dggsBtnA_d.touchChildren=false;
	self.cdTimeLListener = RefreshTime.new();
	self.cdTimeLListener:initTime(time, cdTimeFun, nil, 3);
	Tweenlite:scale(self.dggsBtnA_d,0.1,0.7,0.7,255);
	self.leftListTmp:setVisible(false)
	self.lBL:setVisible(false)
	cdTimeFun();
end
function TreasuryPopup:setRTime(time)
	self:disposeRTime();
	local function onRestBtn()
		self.CDRTF:setString("")
		self.rRsetBtn:setVisible(false);
		self.cost1TF:setVisible(false);
		self.mfjjBtnA_d.touchEnabled=true;
   		self.mfjjBtnA_d.touchChildren=true;
	end
	if time<=0 then
		return onRestBtn();
	end
	local function cdTimeFun()
		if self.cdTimeRListener.totalTime <= 0 then
			self:disposeRTime();
			onRestBtn();
		else
			self.CDRTF:setString("冷却："..self.cdTimeRListener:getTimeStr());
			self.rRsetBtn:setVisible(true);
			self.cost1TF:setVisible(true);
		end
	end
	self.mfjjBtnA_d.touchEnabled=false;
	self.mfjjBtnA_d.touchChildren=false;
	self.cdTimeRListener = RefreshTime.new();
	self.cdTimeRListener:initTime(time, cdTimeFun, nil, 3);
	Tweenlite:scale(self.mfjjBtnA_d,0.1,0.7,0.7,255);
	self.rightListTmp:setVisible(false)
	self.rBL:setVisible(false)
	cdTimeFun();
end
function TreasuryPopup:disposeLTime()
    if self.cdTimeLListener ~= nil then
        self.cdTimeLListener:dispose();
        self.cdTimeLListener = nil;
    end
end
function TreasuryPopup:disposeRTime()
    if self.cdTimeRListener ~= nil then
        self.cdTimeRListener:dispose();
        self.cdTimeRListener=nil;
    end
end
function TreasuryPopup:onTutorShow(type)
	if tonumber(type) == 1 then
		self.LCount = self.LCount or 1;
	else
		self.RCount = self.RCount or 1;
	end
	self:refreshRemainSeconds(type,0)
end
function TreasuryPopup:refreshRemainSeconds(type,value)
	if tonumber(type) == 1 then
		if self.LCount>0 then self:setLTime(tonumber(value)); end
		self.LTime = value;
	elseif tonumber(type) == 2 then
		if self.RCount >0 then self:setRTime(tonumber(value)); end
		self.RTime = value;
	end
	if self.RTime and self.LTime then
		local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
		if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) and self.RCount>0 and self.RTime<=0 then
			self:selectRBtn();
		elseif openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_38) and self.LCount>0 and self.LTime<=0 then
			self:selectLBtn();
		end
	end
end

function TreasuryPopup:onUIInit()
  CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
 end
function TreasuryPopup:onRequestedData()

end
function TreasuryPopup:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end

TreasuryRender=class(EventDispatcher);
function TreasuryRender:ctor(skeleton,parent)
	self.parent = parent;
	self.skeleton = skeleton;
	self:buildRender();
	self:initUI();
end
function TreasuryRender:buildRender()
  self.armature=self.skeleton:buildArmature("render_ui");
  self.armature.animation:gotoAndPlay("f1");
  self.armature:updateBonesZ();
  self.armature:update();
  self.armature_d=self.armature.display;
end
function TreasuryRender:getDisplay()
	return self.armature_d;
end
function TreasuryRender:renderWidth()
	return self.bg_m:getContentSize().width;
end
function TreasuryRender:initUI()
  	self.bg_m = self.armature_d:getChildByName("bg_m");
	self.bg_j = self.armature_d:getChildByName("bg_j");
	self.bg_m:addEventListener(DisplayEvents.kTouchTap,self.onClickRender,self);
	self.bg_j:addEventListener(DisplayEvents.kTouchTap,self.onClickRender,self);
	local lv = generateText(self.armature_d,self.armature,"lv","等级");
	lv.touchEnabled=false;
   	lv.touchChildren=false;
	self.lvTF = generateText(self.armature_d,self.armature,"lvTF","9");
	self.lvTF.touchEnabled=false;
   	self.lvTF.touchChildren=false;
	self.enable = self.armature_d:getChildByName("enable");
	self.enable:setScale(0.7);
	self.enable:setPositionY(self.enable:getPositionY()-20);
	--self.armature_d:removeChild(self.enable);
	self.armature_d:setChildIndex(self.enable,1000);
	self.enable.touchEnabled=false;
   	self.enable.touchChildren=false;
end
function TreasuryRender:setData(data)
	self.data = data;

    local userProxy=self.parent:retrieveProxy(UserProxy.name);

	local userLvl = userProxy:getLevel()
	if userLvl<data.level then
		self.enable:setVisible(true);
		self.bg_m.touchEnabled=false;
   		self.bg_m.touchChildren=false;
   		self.bg_j.touchEnabled=false;
   		self.bg_j.touchChildren=false;
	else
		self.enable:setVisible(false);
		self.bg_m.touchEnabled=true;
	   	self.bg_m.touchChildren=true;
	   	self.bg_j.touchEnabled=true;
	   	self.bg_j.touchChildren=true;
	end
	self.lvTF:setString(data.level);
	if self.data.type == 1 then
		self.bg_m:setVisible(true);
		self.bg_j:setVisible(false);
	elseif self.data.type == 2 then
		self.bg_m:setVisible(false);
		self.bg_j:setVisible(true);
	end
end
function TreasuryRender:onClickRender(event,render)
	MusicUtils:playEffect(8,false);
	if GameVar.tutorStage == TutorConfig.STAGE_1024 or GameVar.tutorStage == TutorConfig.STAGE_1028 then
	   if GameVar.tutorStage == TutorConfig.STAGE_1028 then
       	 hecDC(5, 102803)
       end
	   sendServerTutorMsg({})
	   closeTutorUI();
	end
  	-- setFactionCurrencyVisible(false)
	self.parent:dispatchEvent(Event.new(MainSceneNotifications.TO_HEROTEAMSUB,{context = self, onEnter = self.onEnterButtonTapByOther,funcType = "Treasury"},self));
end

function TreasuryRender:onEnterButtonTapByOther()
	if self.data.type == 1 then
		hecDC(3,9,2,{guanqiaID=self.data.battleId});
	elseif self.data.type == 2 then
		hecDC(3,9,3,{guanqiaID=self.data.battleId});
	end
	sendMessage(19,2,{ID=self.data.id});

	if GameVar.tutorStage == TutorConfig.STAGE_1028 then
   	 	hecDC(5, 102803)
    	sendServerTutorMsg({BooleanValue = 0})--Stage = GameVar.tutorStage, Step = 101008, 
	end
end
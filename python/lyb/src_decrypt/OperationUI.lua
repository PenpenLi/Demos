require "main.view.mainScene.operation.ui.render.OperationRender";
OperationUI = class(LayerPopableDirect)

function OperationUI:ctor()
	self.class = OperationUI
end

function OperationUI:dispose()
	self:removeAllEventListeners();
	self:removeChildren();

	--setButtonGroupVisible(true)
	OperationUI.superclass.dispose(self);

	BitmapCacher:removeUnused();
end
function OperationUI:onDataInit()

	self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
	self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
	self.userProxy=self:retrieveProxy(UserProxy.name);
	self.heroHouseProxy=self:retrieveProxy(HeroHouseProxy.name);
	self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
	self.bagProxy = self:retrieveProxy(BagProxy.name);
	self.zhenfaProxy = self:retrieveProxy(ZhenFaProxy.name);
	self.operationProxy = self:retrieveProxy(OperationProxy.name);

	self.skeleton = getSkeletonByName("operate_ui");


	self.layerPopableData=LayerPopableData.new();
	self.layerPopableData:setHasUIBackground(true)
	self.layerPopableData:setHasUIFrame(true)
	self.layerPopableData:setArmatureInitParam(self.skeleton,"main")
	self:setLayerPopableData(self.layerPopableData)
end	
function OperationUI:onUIInit()

	local armature=self.armature;
	local armature_d=armature.display;
	self.armature_d = armature_d;

    self:initLayer();
	local winSize = Director:sharedDirector():getWinSize()


	local artId1 = getCurrentBgArtId();
    self.bgImage = Image.new();
    self.bgImage:loadByArtID(artId1);
    self:addChildAt(self.bgImage, 0)
    local yPos = -GameData.uiOffsetY
	if GameVar.mapHeight - winSize.height > 30 then
		yPos = -GameData.uiOffsetY - 30
	end
	self.bgImage:setPositionXY(-GameData.uiOffsetX, yPos);


    self.bgImage2 = Image.new();
    self.bgImage2:loadByArtID(304);
    self.armature_d:addChildAt(self.bgImage2,1)
	self.bgImage2:setPositionXY(96, 50);


	self:setContentSize(makeSize(1280, 720))

	local uiSize = armature_d:getGroupBounds(false).size
	local offsetX,offsetY = (winSize.width - 1280) / 2,(winSize.height - 720) / 2

	-- 统一半透层
	local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
	backHalfAlphaLayer:setPositionXY(-1 * offsetX, -1 * offsetY - 10)
	self:addChildAt(backHalfAlphaLayer,0)		

	print("uiSize.width,height",uiSize.width,uiSize.height)

    self.userNameTextBone = self.armature:getBone("userNameText")
	self.userNameText = createTextFieldWithTextData(self.userNameTextBone.textData,self.userProxy.userName);
	self.userNameText.touchEnabled = false;
	armature_d:addChild(self.userNameText)

    self.levelTextBone = self.armature:getBone("levelText")
	self.levelText = createTextFieldWithTextData(self.levelTextBone.textData,"Lv." .. self.userProxy:getLevel());
	self.levelText.touchEnabled = false;
	armature_d:addChild(self.levelText)


    self.IDText_descBone = self.armature:getBone("IDText_desc")
	self.IDText_desc = createTextFieldWithTextData(self.IDText_descBone.textData,"ID：");
	self.IDText_desc.touchEnabled = false;
	armature_d:addChild(self.IDText_desc)


    self.IDTextBone = self.armature:getBone("IDText")
	self.IDText = createTextFieldWithTextData(self.IDTextBone.textData,self.userProxy.userId + analysis("Xishuhuizong_Xishubiao",1092,"constant"));
	self.IDText.touchEnabled = false;
	armature_d:addChild(self.IDText)

    self.guanzhiText_descBone = self.armature:getBone("guanzhiText_desc")
	self.guanzhiText_desc = createTextFieldWithTextData(self.guanzhiText_descBone.textData,"官职：");
	self.guanzhiText_desc.touchEnabled = false;
	armature_d:addChild(self.guanzhiText_desc)

	local nobility = analysis("Shili_Guanzhi",self.userProxy.nobility,"title")

    self.guanzhiTextBone = self.armature:getBone("guanzhiText")
	self.guanzhiText = createTextFieldWithTextData(self.guanzhiTextBone.textData,nobility);
	self.guanzhiText.touchEnabled = false;
	armature_d:addChild(self.guanzhiText)


    self.bangpaiText_descBone = self.armature:getBone("bangpaiText_desc")
	self.bangpaiText_desc = createTextFieldWithTextData(self.bangpaiText_descBone.textData,"帮派：");
	self.bangpaiText_desc.touchEnabled = false;
	armature_d:addChild(self.bangpaiText_desc)

	local name = self.userProxy.familyName;
	if self.userProxy.familyName == "" then
		name = "无"
	end
    self.bangpaiTextBone = self.armature:getBone("bangpaiText")
	self.bangpaiText = createTextFieldWithTextData(self.bangpaiTextBone.textData,name);
	self.bangpaiText.touchEnabled = false;
	armature_d:addChild(self.bangpaiText)
	
    self.exp_descbBone = self.armature:getBone("exp_descb")
  	self.exp_descbText = createTextFieldWithTextData(self.exp_descbBone.textData,"");
	self.exp_descbText.touchEnabled = false;
	armature_d:addChild(self.exp_descbText)


	local huanhuaButton = self.armature:getBone("huanhuaButton"):getDisplay()
	local fetch_buttonPos = convertBone2LB4Button(huanhuaButton);
	huanhuaButton.parent:removeChild(huanhuaButton)

	huanhuaButton = CommonButton.new();
	huanhuaButton:initialize("common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
	huanhuaButton:setPosition(fetch_buttonPos);
	huanhuaButton:addEventListener(DisplayEvents.kTouchTap,self.onHuanHuaTap,self);
	armature_d:addChild(huanhuaButton);
	self.huanhuaButton = huanhuaButton;
	huanhuaButton:initializeBMText("幻化","anniutuzi");

	local changeNameButton = self.armature:getBone("changeNameButton"):getDisplay()
	local fetch_buttonPos = convertBone2LB4Button(changeNameButton);
	changeNameButton.parent:removeChild(changeNameButton)

	changeNameButton = CommonButton.new();
	changeNameButton:initialize("common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
	changeNameButton:setPosition(fetch_buttonPos);
	changeNameButton:addEventListener(DisplayEvents.kTouchTap,self.onClickChangeName,self);
	armature_d:addChild(changeNameButton);
	self.changeNameButton = changeNameButton;
	changeNameButton:initializeBMText("改名","anniutuzi");


	self.shezhi = self.armature.display:getChildByName("shezhi");

	SingleButton:create(self.shezhi, nil, 0);
	self.shezhi:addEventListener(DisplayEvents.kTouchTap, self.onSheZhiTap, self);
	self.shezhi:setAnchorPoint(ccp(0.5,0.5))


	local render1=armature_d:getChildByName("render1");
	local render2=armature_d:getChildByName("render2");
	--self.render_pos=convertBone2LB4Button(render1)
	self.render_pos=convertBone2LB(render1)
	self.render_width=render1:getContentSize().width
	self.render_height=render1:getPositionY()-render2:getPositionY()

	self.list_x = self.render_pos.x;
	self.list_y = self.render_pos.y + render1:getContentSize().height;

	armature_d:removeChild(render1);
	armature_d:removeChild(render2);

	self:refreshMainRole()

	self:refreshList();

	self:refreshVip()

	self:refreshProgressBar()

end
function OperationUI:refreshMainRole()
  if self.mainRole then
    self.armature_d:removeChild(self.mainRole)
    self.mainRole = nil;
  end

  local huanHuaPo = analysis("Zhujiao_Huanhua", self.userProxy.transforId) 
  self.mainRole = getCompositeRole(huanHuaPo.body)


  self.mainRole:setPositionXY(276,255)
  self:addRoleShadow(self.mainRole)
  self.armature_d:addChild(self.mainRole)

end
function OperationUI:addRoleShadow(role)
    local roleShadow = Image.new()
    roleShadow:loadByArtID(StaticArtsConfig.IMAGE_HERO_SHADOW)
    roleShadow:setAnchorPoint(CCPointMake(0.5,0.5));
    role.roleShadow = roleShadow
    role:addChildAt(roleShadow, 0);
    roleShadow.touchChildren = false;
    roleShadow.touchEnabled = false;
end
function OperationUI:refreshList()

  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(476, 73);
  self.listScrollViewLayer:setViewSize(makeSize(699, 118*4));
  self.listScrollViewLayer:setItemSize(makeSize(699, 118));
  self.listScrollViewLayer:setDirection(kCCScrollViewDirectionVertical);
  self.listScrollViewLayer.touchEnabled=true;
  self.listScrollViewLayer.touchChildren=true
  self.armature_d:addChild(self.listScrollViewLayer)

  local totaltab=analysisTotalTableArray("Zhujiao_Zhujiaojiemiangongneng");
  for k, v in ipairs(totaltab)do
  	if self.openFunctionProxy:checkIsOpenFunction(v.id2) then
	  	local render = OperationRender.new();
	  	render:initialize(self, v);
	  	self.listScrollViewLayer:addItem(render)
	end
  end
end
function OperationUI:refreshName()
	self.userNameText:setString(self.userProxy.userName)
	if self.inputTips and self.inputTips.parent then
		self.inputTips.parent:removeChild(self.inputTips);
	end
end
function OperationUI:onClickChangeName()

	self.changeNameButton:setScale(1)
	
	MusicUtils:playEffect(7,false)

	local itemCount = self.bagProxy:getItemNum(1015001)
	local desText = '<content><font color="#67190E">使用</font><font color="#fc00ff">改名卡x1</font><font color="#67190E">就可以修改名字了</font>'
	if itemCount == 0 then
		desText = '<content><font color="#67190E">花费100元宝购买并使用</font><font color="#fc00ff">改名卡x1</font><font color="#67190E">就可以修改名字了</font>'
	end

	require "core.controls.CommonInput";
	self.inputTips = CommonInput.new();
	local function sendToServer()
		local inputName = self.inputTips.inputText:getString()
	    local nameLength = CommonUtils:calcCharCount(inputName);
	    if nameLength == 0 then
	        sharedTextAnimateReward():animateStartByString("请取个名字~");
	        return
	    elseif nameLength > 6 then
	        sharedTextAnimateReward():animateStartByString("名字不能超过6个字~");
	        return
	    end

		if itemCount == 0 then
			if self.userCurrencyProxy:getGold() < 100 then
				sharedTextAnimateReward():animateStartByString("元宝不足!");
				self:dispatchEvent(Event.new("TO_VIP"));	
				return;
			end
		end

		log("inputName===="..inputName)
		-- self.inputTips:removePopup()
		sendMessage(3,41,{UserName = inputName})
	end
	self.inputTips:initialize("输入你的新名字吧",desText,self,sendToServer,nil,nil,nil,true,nil,true,true,nil);
	
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.inputTips)
end

function OperationUI:refreshProgressBar()
	local common_copy_blue_progress_bar = self.armature:getBone("common_copy_blue_progress_bar"):getDisplay()
	common_copy_blue_progress_bar:setScaleX(0.65)

  local progressBar = self.armature:findChildArmature("common_copy_blue_progress_bar");
  self.progressBar = ProgressBar.new(progressBar, "common_blue_progress_bar_fg");
  self.progressBar:setProgress(0.5);

  if analysisHas("Zhujiao_Zhujiaoshengji", 1+self.userProxy.level) then
  	local totalExp = analysis("Zhujiao_Zhujiaoshengji", 1+self.userProxy.level,"exp")
  	self.progressBar:setProgress(self.userProxy.experience / totalExp); 
  	self.exp_descbText:setString("经验：".. self.userProxy.experience .. "/" .. totalExp);
  else
  	self.progressBar:setProgress(1); 	
  	self.exp_descbText:setString("经验：".. self.userProxy.experience .. "/" .. self.userProxy.experience);
  end
end

function OperationUI:refreshVip()
	if not self.privilegeText_desc then
	    local privilegeText_descBone = self.armature:getBone("privilegeText_desc")
	  	self.privilegeText_desc = createTextFieldWithTextData(privilegeText_descBone.textData,"特权：");
		self.privilegeText_desc.touchEnabled = false;
		self.armature_d:addChild(self.privilegeText_desc)
	end
	if not self.privilegeText then
		self.privilegeTextBone = self.armature:getBone("privilegeText")
	  	self.privilegeText = createTextFieldWithTextData(self.privilegeTextBone.textData,"VIP" .. self.userProxy.vipLevel);
		self.privilegeText.touchEnabled = false;
		self.armature_d:addChild(self.privilegeText)
	else
		self.privilegeText:setString("VIP" .. self.userProxy.vipLevel)
	end
end

function OperationUI:onSheZhiTap(event)
    MusicUtils:playEffect(7,false)
	require "main.view.mainScene.operation.ui.SettingUI";
	self.settingUI = SettingUI.new();
	self.settingUI:initialize(self);
	self:addChild(self.settingUI);
end

function OperationUI:onHuanHuaTap(event)
	sendMessage(3, 43)
	self:dispatchEvent(Event.new("TO_HUANHUA", nil, self))
end


function OperationUI:onButtonGo(functionid)

  self:dispatchEvent(Event.new("ON_OPEN_FUNCTION",{functionid = functionid},self));
end
function OperationUI:onUIClose()
  print("onUIClose")
  self:dispatchEvent(Event.new("REMOVE_OPERATION",nil,self));
end

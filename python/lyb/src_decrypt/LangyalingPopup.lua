-- 琅琊令UI

LangyalingPopup=class(LayerPopableDirect);

-- 点击类型
local _yingxionglingPrice = 0
local _langyalingPrice = 0
local _langyalingPrice10 = 0
local _huobiName1 = ""
local _huobiName2 = ""

function LangyalingPopup:ctor()
  self.class=LangyalingPopup;
end

function LangyalingPopup:dispose()
	--setButtonGroupVisible(true)
	LangyalingPopup.superclass.dispose(self);
	self.disPoseArmature1:dispose()
end
function LangyalingPopup:onDataInit()

	self.bagProxy = self:retrieveProxy(BagProxy.name);
	self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);

	local layerPopableData = LayerPopableData.new();
	layerPopableData:setHasUIBackground(true);
	layerPopableData:setHasUIFrame(true);
	layerPopableData:setPreUIData(StaticArtsConfig.LOADING_UI,nil,true)
	self:setLayerPopableData(layerPopableData);
end

function LangyalingPopup:onPrePop()
	--骨骼
	self.skeleton = SkeletonFactory.new();
	self.skeleton:parseDataFromFile("langyaling_ui");  
	local armature = self.skeleton:buildArmature("langyaling_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.disPoseArmature1 = armature
	self:addChild(armature.display);
	
	self:setContentSize(CCSizeMake(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT))

	local yinbiShowGroup = armature.animation.armature:getBone("yinbiShowGroup"):getDisplay()
	local yinbiRollGroup = armature.animation.armature:getBone("yinbiRollGroup"):getDisplay()
	local jinbiShowGroup = armature.animation.armature:getBone("jinbiShowGroup"):getDisplay()
	local jinbiRollGroup = armature.animation.armature:getBone("jinbiRollGroup"):getDisplay()

	-- local closeButton = Button.new(armature:findChildArmature("common_close_button"), false);
	-- closeButton:addEventListener(Events.kStart, self.closeUI, self);
  
	local closeButton=armature.display:getChildByName("common_close_button");
	local close_pos=convertBone2LB4Button(closeButton);
	armature.display:removeChild(closeButton);

	local closeButton=CommonButton.new();
	closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	closeButton:setPositionXY(close_pos.x,close_pos.y + GameData.uiOffsetY);
	closeButton:addEventListener(DisplayEvents.kTouchTap,self.closeUI,self);
	armature.display:addChild(closeButton);

	-- 银币1
    local movieClip1 = MovieClip.new();
    movieClip1:initFromFile("langyaling_ui", "yinbiShowGroup");
    movieClip1:gotoAndPlay("f1");
    movieClip1:update();

    self.yinbiShowGroup = Layer.new()
    self.yinbiShowGroup:initLayer()
    self.yinbiShowGroup:addChild(movieClip1.layer)
    self.yinbiShowGroup:setPosition(yinbiShowGroup:getPosition())
    self.yinbiShowGroup:setContentSize(CCSizeMake(290,560))
    self.yinbiShowGroup:setAnchorPoint(CCPointMake(0.5, 0))    
    self:addChild(self.yinbiShowGroup);
	movieClip1.layer:addEventListener(DisplayEvents.kTouchTap, self.onClickYinbiShowGroup, self);

	-- 显示内容
	-- local desc_textBone1 = movieClip1.armature:getBone("desc_text")
	-- local cost_textBone1 = movieClip1.armature:getBone("cost_text")
	local itemImageBone1 = movieClip1.armature:getBone("itemImage")
	self.cost_text0Bone1 = movieClip1.armature:getBone("cost_text0")
	self.effectYinbi = movieClip1.armature:getBone("effect"):getDisplay()
	self.movieClip1 = movieClip1
	-- local getText1 = createTextFieldWithTextData(desc_textBone1.textData,"1-5      英雄")
	-- local imageText1 = createTextFieldWithTextData(cost_textBone1.textData,"消耗      x1")
	local imageText1 = generateText(self.yinbiShowGroup,movieClip1.armature,"cost_text","消耗          ",true,ccc3(0,0,0),2);

	local itemImage1 = Image.new()
	itemImage1:loadByArtID(StaticArtsConfig.IMAGE_YINGXIONGLING)
	itemImage1:setPosition(itemImageBone1:getDisplay():getPosition())
	itemImage1:setScale(0.7)

	-- getText1.touchEnabled = false
	imageText1.touchEnabled = false
	itemImage1.touchEnabled = false

	-- self.yinbiShowGroup:addChild(getText1)
	-- self.yinbiShowGroup:addChild(imageText1)
	self.yinbiShowGroup:addChild(itemImage1)

	-- 银币2
    local movieClip2 = MovieClip.new();
    movieClip2:initFromFile("langyaling_ui", "yinbiRollGroup");
    movieClip2:gotoAndPlay("f1");
    movieClip2:update();

    self.yinbiRollGroup = Layer.new()
    self.yinbiRollGroup:initLayer()  
    self.yinbiRollGroup:addChild(movieClip2.layer)
    self.yinbiRollGroup:setPosition(yinbiRollGroup:getPosition())
    self.yinbiRollGroup:setContentSize(CCSizeMake(290,560))
    self.yinbiRollGroup:setAnchorPoint(CCPointMake(0.5, 0))      
    self:addChild(self.yinbiRollGroup);
	self.yinbiRollGroup:setVisible(false)
	movieClip2.layer:addEventListener(DisplayEvents.kTouchTap, self.onClickYinbiRollGroup, self);

	-- 显示内容
	local common_blue_button_1 = movieClip2.armature:findChildArmature("common_blue_button")
    local yinbiOneButton = CommonButton.new();
    yinbiOneButton:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    yinbiOneButton:initializeBMText("召一次","anniutuzi");
    yinbiOneButton:setPosition(convertBone2LB4Button(common_blue_button_1.display));
    yinbiOneButton:addEventListener(DisplayEvents.kTouchTap,self.onClickYinbiOneButton,self);
    self.yinbiRollGroup:addChild(yinbiOneButton);
    -- movieClip2.layer:removeChild(common_blue_button_1.display)
    common_blue_button_1.display:setVisible(false)

	local common_blue_button_10 = movieClip2.armature:findChildArmature("common_red_button")
    local yinbiTenButton = CommonButton.new();
    yinbiTenButton:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
    yinbiTenButton:initializeBMText("召十次","anniutuzi");
    yinbiTenButton:setPosition(convertBone2LB4Button(common_blue_button_10.display));
    yinbiTenButton:addEventListener(DisplayEvents.kTouchTap,self.onClickYinbiTenButton,self);
    self.yinbiRollGroup:addChild(yinbiTenButton);
    -- movieClip2.layer:removeChild(common_blue_button_10.display)    
    common_blue_button_10.display:setVisible(false)

	local cost_text_1Bone = movieClip2.armature:getBone("cost_text_1")
	local cost_text_10Bone = movieClip2.armature:getBone("cost_text_10")
	local itemImage_1Bone = movieClip2.armature:getBone("itemImage_1")
	local itemImage_10Bone = movieClip2.armature:getBone("itemImage_10")
	self.desc_textBone2 = movieClip2.armature:getBone("desc_text")

	self.effectYinbi1 = movieClip2.armature:getBone("effect1"):getDisplay()
	self.effectYinbi10 = movieClip2.armature:getBone("effect2"):getDisplay()
	self.yinbiRollGroup:addChild(self.effectYinbi1)
	self.yinbiRollGroup:addChild(self.effectYinbi10)


	local cost_text_3_1 = createTextFieldWithTextData(cost_text_1Bone.textData,"消耗           x1")
	local cost_text_3_10 = createTextFieldWithTextData(cost_text_10Bone.textData,"消耗           x10")

	local itemImage3_1 = Image.new()
	itemImage3_1:loadByArtID(StaticArtsConfig.IMAGE_YINGXIONGLING)
	itemImage3_1:setPosition(itemImage_1Bone:getDisplay():getPosition())
	itemImage3_1:setScale(0.7)
	local itemImage3_10 = Image.new()
	itemImage3_10:loadByArtID(StaticArtsConfig.IMAGE_YINGXIONGLING)
	itemImage3_10:setPosition(itemImage_10Bone:getDisplay():getPosition())
	itemImage3_10:setScale(0.7)

	cost_text_3_1.touchEnabled = false
	cost_text_3_10.touchEnabled = false
	itemImage3_1.touchEnabled = false
	itemImage3_10.touchEnabled = false
	self.yinbiRollGroup:addChild(cost_text_3_1)
	self.yinbiRollGroup:addChild(cost_text_3_10)
	self.yinbiRollGroup:addChild(itemImage3_1)
	self.yinbiRollGroup:addChild(itemImage3_10)
	
	-- 金币1
    local movieClip3 = MovieClip.new();
    movieClip3:initFromFile("langyaling_ui", "jinbiShowGroup");
    movieClip3:gotoAndPlay("f1");
    movieClip3:update();

    self.jinbiShowGroup = Layer.new()
    self.jinbiShowGroup:initLayer()
    self.jinbiShowGroup:setContentSize(CCSizeMake(290,560))
    self.jinbiShowGroup:setAnchorPoint(CCPointMake(0.5, 0))
    self.jinbiShowGroup:addChild(movieClip3.layer)
    self.jinbiShowGroup:setPosition(jinbiShowGroup:getPosition())
    self:addChild(self.jinbiShowGroup);
	movieClip3.layer:addEventListener(DisplayEvents.kTouchTap, self.onClickJinbiShowGroup, self);

	self.movieClip3 = movieClip3
	-- 显示内容
	-- local desc_textBone3 = movieClip3.armature:getBone("desc_text")
	-- local cost_textBone3 = movieClip3.armature:getBone("cost_text")
	local itemImageBone3 = movieClip3.armature:getBone("itemImage")
	-- self.cost_text0Bone3 = movieClip3.armature:getBone("cost_text0")
	self.effectJinbi = movieClip3.armature:getBone("effect"):getDisplay()

	-- local getText3 = createTextFieldWithTextData(desc_textBone3.textData,"3-5      英雄")
	-- local imageText3 = createTextFieldWithTextData(cost_textBone3.textData,"消耗      x1")
	local imageText3 = generateText(self.jinbiShowGroup,movieClip3.armature,"cost_text","消耗          ",true,ccc3(0,0,0),2);

	local itemImage3 = Image.new()
	itemImage3:loadByArtID(StaticArtsConfig.IMAGE_LANGYANLING)
	itemImage3:setPosition(itemImageBone3:getDisplay():getPosition())
	itemImage3:setScale(0.55)

	-- getText3.touchEnabled = false
	imageText3.touchEnabled = false
	itemImage3.touchEnabled = false

	-- self.jinbiShowGroup:addChild(getText3)
	-- self.jinbiShowGroup:addChild(imageText3)
	self.jinbiShowGroup:addChild(itemImage3)

	-- 金币2
    local movieClip4 = MovieClip.new();
    movieClip4:initFromFile("langyaling_ui", "jinbiRollGroup");
    movieClip4:gotoAndPlay("f1");
    movieClip4:update();

    self.jinbiRollGroup = Layer.new()
    self.jinbiRollGroup:initLayer()
    self.jinbiRollGroup:setContentSize(CCSizeMake(290,560))
    self.jinbiRollGroup:setAnchorPoint(CCPointMake(0.5, 0))    
    self.jinbiRollGroup:addChild(movieClip4.layer)
    self.jinbiRollGroup:setPosition(jinbiRollGroup:getPosition())
    self:addChild(self.jinbiRollGroup);
	self.jinbiRollGroup:setVisible(false)
	movieClip4.layer:addEventListener(DisplayEvents.kTouchTap, self.onClickJinbiRollGroup, self);

	-- 显示内容
	local common_blue_button_1 = movieClip4.armature:findChildArmature("common_blue_button")
    local yinbiOneButton = CommonButton.new();
    yinbiOneButton:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    yinbiOneButton:initializeBMText("召一次","anniutuzi");
    yinbiOneButton:setPosition(convertBone2LB4Button(common_blue_button_1.display));
    yinbiOneButton:addEventListener(DisplayEvents.kTouchTap,self.onClickJinbiOneButton,self);
    self.jinbiRollGroup:addChild(yinbiOneButton);
    -- movieClip4.layer:removeChild(common_blue_button_1.display)
    common_blue_button_1.display:setVisible(false)

	local common_blue_button_10 = movieClip4.armature:findChildArmature("common_red_button")
    local yinbiTenButton = CommonButton.new();
    yinbiTenButton:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
    yinbiTenButton:initializeBMText("召十次","anniutuzi");
    yinbiTenButton:setPosition(convertBone2LB4Button(common_blue_button_10.display));
    yinbiTenButton:addEventListener(DisplayEvents.kTouchTap,self.onClickJinbiTenButton,self);
    self.jinbiRollGroup:addChild(yinbiTenButton);
    -- movieClip4.layer:removeChild(common_blue_button_10.display)    
    common_blue_button_10.display:setVisible(false)

	local cost_text_1Bone = movieClip4.armature:getBone("cost_text_1")
	local cost_text_10Bone = movieClip4.armature:getBone("cost_text_10")
	local itemImage_1Bone = movieClip4.armature:getBone("itemImage_1")
	local itemImage_10Bone = movieClip4.armature:getBone("itemImage_10")
	self.desc_textBone4 = movieClip4.armature:getBone("desc_text")
	local desc_text_1Bone = movieClip4.armature:getBone("desc_text_1")
	-- local desc_text_2Bone = movieClip4.armature:getBone("desc_text_2")
	-- local desc_text_3Bone = movieClip4.armature:getBone("desc_text_3")

	self.effectJinbi1 = movieClip4.armature:getBone("effect1"):getDisplay()
	self.effectJinbi10 = movieClip4.armature:getBone("effect2"):getDisplay()
	self.jinbiRollGroup:addChild(self.effectJinbi1)
	self.jinbiRollGroup:addChild(self.effectJinbi10)

	local cost_text_3_1 = createTextFieldWithTextData(cost_text_1Bone.textData,"消耗           x1")
	local cost_text_3_10 = createTextFieldWithTextData(cost_text_10Bone.textData,"消耗           x10")
	local desc_text_3 = createTextFieldWithTextData(desc_text_1Bone.textData,"至少得1个蓝色品质英雄")

	local itemImage3_1 = Image.new()
	itemImage3_1:loadByArtID(StaticArtsConfig.IMAGE_LANGYANLING)
	itemImage3_1:setPosition(itemImage_1Bone:getDisplay():getPosition())
	itemImage3_1:setScale(0.55)
	local itemImage3_10 = Image.new()
	itemImage3_10:loadByArtID(StaticArtsConfig.IMAGE_LANGYANLING)
	itemImage3_10:setPosition(itemImage_10Bone:getDisplay():getPosition())
	itemImage3_10:setScale(0.55)

	cost_text_3_1.touchEnabled = false
	cost_text_3_10.touchEnabled = false
	itemImage3_1.touchEnabled = false
	itemImage3_10.touchEnabled = false
	-- desc_text_1.touchEnabled = false
	-- desc_text_2.touchEnabled = false
	desc_text_3.touchEnabled = false
	self.jinbiRollGroup:addChild(cost_text_3_1)
	self.jinbiRollGroup:addChild(cost_text_3_10)
	self.jinbiRollGroup:addChild(itemImage3_1)
	self.jinbiRollGroup:addChild(itemImage3_10)
	-- self.jinbiRollGroup:addChild(desc_text_1)
	-- self.jinbiRollGroup:addChild(desc_text_2)
	self.jinbiRollGroup:addChild(desc_text_3)

    -- local text_data = armature.animation.armature:getBone("wanfaText").textData;
    -- local s='<content><font color="#FFFFFF" link="1" ref="1">说明</font></content>';
    -- self.wanFaText = RichLabelTTF.new(s, FontConstConfig.OUR_FONT, text_data.size,  CCSizeMake(text_data.width, 0), kCCTextAlignmentCenter);

    -- self.wanFaText:addEventListener(DisplayEvents.kTouchBegin,self.on_WanFa_Tap,self);
    -- self.wanFaText:setPositionXY(text_data.x, text_data.y);
    -- self.wanFaText.touchChildren = true;
    -- self.wanFaText.touchEnabled = true;
    -- self:addChild(self.wanFaText);

	-- self.askBtn = Button.new(armature:findChildArmature("ask_btn"),false,"");
	-- self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);

	self.askButton = armature.display:getChildByName("ask_btn");
	SingleButton:create(self.askButton);	
	local askPos = self.askButton:getPosition()
	self.askButton:setPositionXY(askPos.x,askPos.y + GameData.uiOffsetY)
	self.askButton:addEventListener(DisplayEvents.kTouchTap, self.onShowTip, self);  	

    local movieClip5 = MovieClip.new();
    movieClip5:initFromFile("langyaling_ui", "wanfa_ui");
    movieClip5:gotoAndPlay("f1");
    movieClip5:update();

 --    self.wanfaLayer = Layer.new()
 --    self.wanfaLayer:initLayer()
 --    self.wanfaLayer:addChild(movieClip5.layer)

 --    local text_data_2 = movieClip5.armature:getBone("wanfanDes").textData;
 --    -- local wanfaText = "英雄令获取方法:\n商店出售\n活动奖励\n关卡掉落\n\n琅琊令获取方法:\n商店出售\n活动奖励\n目标任务中产出\n十国征战有几率开出"
 --    local wanfaText = analysis("Tishi_Guizemiaoshu",1,"txt");
 --    self.desText = createTextFieldWithTextData(text_data_2,wanfaText);
 --    self.wanfaLayer:addChild(self.desText);
 --    self:addChild(self.wanfaLayer)
	
	-- local wanfa_ui = armature.animation.armature:getBone("wanfa_ui"):getDisplay();    
	-- self.wanfaLayer:setPositionXY(wanfa_ui:getPositionX(),wanfa_ui:getPositionY() - 245)
	-- self.wanfaLayer:setVisible(false)

    local movieClip6 = MovieClip.new();
    movieClip6:initFromFile("langyaling_ui", "gold_tips");
    movieClip6:gotoAndPlay("f1");
    movieClip6:update();
    self.goldLayer = Layer.new()
    self.goldLayer:initLayer()
    self.goldLayer:addChild(movieClip6.layer)

    local text_data_2 = movieClip6.armature:getBone("wanfanDes").textData;
    self.desGoldText = createTextFieldWithTextData(text_data_2,"");
    self.goldLayer:addChild(self.desGoldText);
    self:addChild(self.goldLayer)
	
	local gold_ui = armature.animation.armature:getBone("gold_ui"):getDisplay();    
	self.goldLayer:setPositionXY(gold_ui:getPositionX(),gold_ui:getPositionY() - 60)
	self.goldLayer:setVisible(false)

    local movieClip7 = MovieClip.new();
    movieClip7:initFromFile("langyaling_ui", "sliver_tips");
    movieClip7:gotoAndPlay("f1");
    movieClip7:update();
    self.sliverLayer = Layer.new()
    self.sliverLayer:initLayer()
    self.sliverLayer:addChild(movieClip7.layer)

    local text_data_2 = movieClip7.armature:getBone("wanfanDes").textData;
    self.desSliverText = createTextFieldWithTextData(text_data_2,"");
    self.sliverLayer:addChild(self.desSliverText);
    self:addChild(self.sliverLayer)
	
	local sliver_ui = armature.animation.armature:getBone("sliver_ui"):getDisplay();    
	self.sliverLayer:setPositionXY(sliver_ui:getPositionX(),sliver_ui:getPositionY() - 60)
	self.sliverLayer:setVisible(false)	

	self:addEventListener(DisplayEvents.kTouchBegin,self.onClickUI,self);

	-- 货币
	local huobiGroupBone = armature:findChildArmature("huobiGroup")
	local huobiGroupDO = armature.animation.armature:getBone("huobiGroup"):getDisplay()
	local huobiPos = huobiGroupDO:getPosition()
	huobiGroupDO:setPositionXY(huobiPos.x,huobiPos.y + GameData.uiOffsetY)

	local yinliangTextBone = huobiGroupBone:getBone("yinliangText")
	local yuanbaoTextBone = huobiGroupBone:getBone("yuanbaoText")
	local yingxionglingTextBone = huobiGroupBone:getBone("yingxionglingText")
	local langyalingTextBone = huobiGroupBone:getBone("langyalingText")
	local yingxionglingImageDO = huobiGroupBone:getBone("yingxionglingImage"):getDisplay()
	local langyalingImageDO = huobiGroupBone:getBone("langyalingImage"):getDisplay()

	self.common_add_bg1DO = huobiGroupBone:getBone("common_add_bg1"):getDisplay()
	self.common_add_bg2DO = huobiGroupBone:getBone("common_add_bg2"):getDisplay()
	local bantou_bg1DO = huobiGroupBone:getBone("bantou_bg1"):getDisplay()
	local bantou_bg2DO = huobiGroupBone:getBone("bantou_bg2"):getDisplay()		

	self.common_add_bg1DO:addEventListener(DisplayEvents.kTouchBegin,self.onClickBg1,self);
	self.common_add_bg2DO:addEventListener(DisplayEvents.kTouchBegin,self.onClickBg2,self);

	self.common_add_bg1DO:addEventListener(DisplayEvents.kTouchEnd,self.onClickEndBg1,self);
	self.common_add_bg2DO:addEventListener(DisplayEvents.kTouchEnd,self.onClickEndBg2,self);

	bantou_bg1DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBantouBg1,self);
	bantou_bg2DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBantouBg2,self);

	self.yinliangText = createTextFieldWithTextData(yinliangTextBone.textData,"")
	self.yuanbaoText = createTextFieldWithTextData(yuanbaoTextBone.textData,"")
	self.yinliangText.touchEnabled = false
	self.yuanbaoText.touchEnabled = false
	self.yingxionglingText = createTextFieldWithTextData(yingxionglingTextBone.textData,self.bagProxy:getItemNum(1009002).."")
	self.langyalingText = createTextFieldWithTextData(langyalingTextBone.textData,self.bagProxy:getItemNum(1009001).."")

	local yingxionglingImage = Image.new()
	yingxionglingImage:loadByArtID(StaticArtsConfig.IMAGE_YINGXIONGLING)
	yingxionglingImage:setPosition(yingxionglingImageDO:getPosition())
	yingxionglingImage:setScale(0.6)

	local langyalingImage = Image.new()
	langyalingImage:loadByArtID(StaticArtsConfig.IMAGE_LANGYANLING)
	langyalingImage:setPosition(langyalingImageDO:getPosition())
	langyalingImage:setScale(0.5)

	huobiGroupDO:addChild(self.yinliangText)
	huobiGroupDO:addChild(self.yuanbaoText)
	huobiGroupDO:addChild(self.yingxionglingText)
	huobiGroupDO:addChild(self.langyalingText)
	huobiGroupDO:addChild(yingxionglingImage)
	huobiGroupDO:addChild(langyalingImage)

	self:refreshItemText()

	-- 打点
	local extensionTable = {}
	extensionTable["langyalingnum"] = self.bagProxy:getItemNum(1009001)
	extensionTable["yingxionglingnum"] = self.bagProxy:getItemNum(1009002)
	extensionTable["gamecoin1"] = self.userCurrencyProxy:getGold()
	extensionTable["gamecoin2"] = self.userCurrencyProxy:getSilver()
	extensionTable["yinghunnum"] = #self.heroHouseProxy:getGeneralArray()
	
	hecDC(3,5,1,extensionTable)	

	-- visible red dot
	if not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_12] and GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_12] then
		GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_12] = true
		self:dispatchEvent(Event.new("TO_REFRESH_REDDOT"));	
	end
end

function LangyalingPopup:onClickUI(event)
	-- if self.wanfaLayer:isVisible() then
	-- 	self.wanfaLayer:setVisible(false)
	-- end
	if self.goldLayer:isVisible() then
		self.goldLayer:setVisible(false)
	end
	if self.sliverLayer:isVisible() then
		self.sliverLayer:setVisible(false)
	end
end

function LangyalingPopup:onShowTip(event)
	local functionStr = analysis("Tishi_Guizemiaoshu",1,"txt");
	TipsUtil:showTips(event.target,functionStr,nil,0);
end

function LangyalingPopup:onClickBg1()
	self.common_add_bg1DO:setScale(0.9)
	MusicUtils:playEffect(7,false);
end
function LangyalingPopup:onClickEndBg1()
	self.common_add_bg1DO:setScale(1)
    self:dispatchEvent(Event.new("TO_DIANJINSHOU"));	
end

function LangyalingPopup:onClickEndBg2()
	self.common_add_bg2DO:setScale(1)
	self:dispatchEvent(Event.new("TO_VIP"));
end

function LangyalingPopup:onClickBg2()
	self.common_add_bg2DO:setScale(0.9)
	MusicUtils:playEffect(7,false);
end

function LangyalingPopup:onClickBantouBg1()

	self.desSliverText:setString("银两:"..self.userCurrencyProxy:getSilver())
	self.sliverLayer:setVisible(true)    
end

function LangyalingPopup:onClickBantouBg2()
	self.desGoldText:setString("元宝:"..self.userCurrencyProxy:getGold())
	self.goldLayer:setVisible(true)    
end

--  刷新道具
function LangyalingPopup:refreshItemText()

	local yingxionglingCountText = ""
	local yingxionglingCount = self.bagProxy:getItemNum(1009002)
	if self.leftText1 then
		self.leftText1:setString("剩余 "..yingxionglingCount.." 个")
	else
		-- self.leftText1 = createTextFieldWithTextData(self.cost_text0Bone1.textData,"剩余 "..yingxionglingCount.." 个")
		-- self.leftText1 = generateText(self.yinbiShowGroup,self.movieClip1.armature,"cost_text0","剩余 "..yingxionglingCount.." 个",true,ccc3(0,0,0),2);
	end
	
	if yingxionglingCount == 0 then
		yingxionglingCountText = "无英雄令,点击直接买"
		self.effectYinbi:setVisible(false)
		self.effectYinbi1:setVisible(false)
		self.effectYinbi10:setVisible(false)
	else
		if yingxionglingCount < 10 then
			self.effectYinbi10:setVisible(false)
		end
		yingxionglingCountText = "剩余 "..yingxionglingCount.." 个"
		-- self.yinbiShowGroup:addChild(self.leftText1)
		self.leftText1 = generateText(self.yinbiShowGroup,self.movieClip1.armature,"cost_text0","剩余 "..yingxionglingCount.." 个",true,ccc3(0,0,0),2);		
	end
	if self.leftText2 then
		self.leftText2:setString(yingxionglingCountText)
	else
		self.leftText2 = createTextFieldWithTextData(self.desc_textBone2.textData,yingxionglingCountText)	
	end
	
	self.leftText2.touchEnabled = false	
	self.yinbiRollGroup:addChild(self.leftText2)	

	local langyalingCountText = ""
	local langyalingCount = self.bagProxy:getItemNum(1009001)
	if self.leftText3 then
		self.leftText3:setString("剩余 "..langyalingCount.." 个")
	else
		-- self.leftText3 = createTextFieldWithTextData(self.cost_text0Bone3.textData,"剩余 "..langyalingCount.." 个")

		-- self.leftText3 = generateText(self.jinbiShowGroup,self.movieClip3.armature,"cost_text0","剩余 "..langyalingCount.." 个",true,ccc3(0,0,0),2);
	end	
	
	if langyalingCount == 0 then
		langyalingCountText = "无琅琊令,点击直接买"
		self.effectJinbi:setVisible(false)
		self.effectJinbi1:setVisible(false)
		self.effectJinbi10:setVisible(false)	
	else
		langyalingCountText = "剩余 "..langyalingCount.." 个"
		-- self.jinbiShowGroup:addChild(self.leftText3)
		self.leftText3 = generateText(self.jinbiShowGroup,self.movieClip3.armature,"cost_text0","剩余 "..langyalingCount.." 个",true,ccc3(0,0,0),2);		
		if langyalingCount < 10 then
			self.effectJinbi10:setVisible(false)
		end		
	end
	if self.leftText4 then
		self.leftText4:setString(langyalingCountText)
	else
		self.leftText4 = createTextFieldWithTextData(self.desc_textBone4.textData,langyalingCountText)		
	end	
	
	self.leftText4.touchEnabled = false	
	self.jinbiRollGroup:addChild(self.leftText4)	

	-- 琅琊令 英雄令价格
	local langyalingTable = analysisByName("Shangdian_Shangdianwupin","itemid",1009001)
	local yingxionglingTable = analysisByName("Shangdian_Shangdianwupin","itemid",1009002)
	if yingxionglingTable then
		for k,v in pairs(yingxionglingTable) do
			if v.type == 3 then
				_yingxionglingPrice = v.price
				if v.money == 2 then 
					_huobiName1 = "银两"
				elseif v.money == 3 then
					_huobiName1 = "元宝"
				end
			end
		end
	end

	if langyalingTable then
		for k,v in pairs(langyalingTable) do
			if v.count == 1 and v.type == 3 then
				_langyalingPrice = v.price
				if v.money == 2 then 
					_huobiName2 = "银两"
				elseif v.money == 3 then
					_huobiName2 = "元宝"
				end				
			end
			if v.count == 10 and v.type == 3 then
				_langyalingPrice10 = v.price
				if v.money == 2 then 
					_huobiName2 = "银两"
				elseif v.money == 3 then
					_huobiName2 = "元宝"
				end				
			end
		end
	end

	self.yingxionglingText:setString(yingxionglingCount)
	self.langyalingText:setString(langyalingCount)
	self:refreshCurrency()

end
function LangyalingPopup:refreshCurrency()
	local silverText = self.userCurrencyProxy:getSilver()
	if silverText >= 1000000 then
		silverText = math.floor(silverText / 10000) .."万"
	end	

	self.yinliangText:setString(silverText)

	local goldText = self.userCurrencyProxy:getGold()
	if goldText >= 1000000 then
		goldText = math.floor(goldText / 10000) .."万"
	end
	self.yuanbaoText:setString(goldText)

	if self.cardsLayer then
		self.cardsLayer:refreshCurrency()
	end
end

function LangyalingPopup:sendMessageToServer()
	
	if self.cardsLayer == nil then
		require "main.view.langyaling.ui.LangyalingCardsLayer";
		self.cardsLayer = LangyalingCardsLayer.new(self)
		self.cardsLayer:initLayer()	
	end
	
	if not self.cardsLayer.isPopupLayer then
		self.cardsLayer.isPopupLayer = true
		sendMessage(6,3,{ByteType = self.clickType,Count = self.buyCount})
	end

end

-- 统一popup
function LangyalingPopup:onLangyalingCommonPopup(count)
	
	local animationStr = ""
	local eventStr = ""
	local tipsStr = ""
	local cannotBuyBoo = true

	if self.clickType == 1 then
		if self.buyCount == 1 then
			tipsStr = "英雄令不足，是否花费" .. _yingxionglingPrice .. _huobiName1 .. "直接购买?"
			cannotBuyBoo = self.userCurrencyProxy:getSilver() < _yingxionglingPrice
		elseif self.buyCount == 10 then
			tipsStr = "英雄令不足，是否花费" .. _yingxionglingPrice * 10 ..  _huobiName1 .. "直接购买?"	
			cannotBuyBoo = self.userCurrencyProxy:getSilver() < _yingxionglingPrice * 10		
		end
		animationStr = "亲~银两不足了哦！"
		eventStr = "TO_DIANJINSHOU"
		
	elseif self.clickType == 2 then
		if self.buyCount == 1 then
			tipsStr = "琅琊令不足，是否花费" .. _langyalingPrice ..  _huobiName2 .. "直接购买?"
			cannotBuyBoo = self.userCurrencyProxy:getGold() < _langyalingPrice	
		elseif self.buyCount == 10 then
			tipsStr = "琅琊令不足，是否花费" .. _langyalingPrice10 ..  _huobiName2 .. "直接购买?"	
			cannotBuyBoo = self.userCurrencyProxy:getGold() < _langyalingPrice10			
		end
		animationStr = StringUtils:getString4Popup(PopupMessageConstConfig.ID_514)
		eventStr = "TO_VIP"
	end

	local function yesToBuy()
		if cannotBuyBoo then
			sharedTextAnimateReward():animateStartByString(animationStr);
			self:dispatchEvent(Event.new(eventStr));	
		else
			self:sendMessageToServer()
		end
	end
	local function noToBuy()
		
	end

	local tips=CommonPopup.new();
	tips:initialize(tipsStr,self,yesToBuy,nil,noToBuy,nil,nil,nil,nil,true);
	tips:setPositionXY(GameData.uiOffsetX * -1,GameData.uiOffsetY * -1)
	self:addChild(tips)
end

function LangyalingPopup:onClickYinbiOneButton(event)
	self.clickType = 1
	self.buyCount = 1
	
	local isBagFull = self.bagProxy:getBagIsFull()
	if isBagFull then
		sharedTextAnimateReward():animateStartByString("背包已满,请清理后再召唤");
		return
	end

	local yingxionglingCount = self.bagProxy:getItemNum(1009002)
	if yingxionglingCount == 0 then
		self:onLangyalingCommonPopup(yingxionglingCount)
	else
		self:sendMessageToServer()
	end
	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
		openTutorUI({x=680, y=250, width = 2, height = 2, alpha = 125, delay = 1.8, fullScreenTouchable = true});
    	sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100311, BooleanValue = 0})
    end
end
function LangyalingPopup:onClickYinbiTenButton(event)
	self.clickType = 1
	self.buyCount = 10
	
	local isBagFull = self.bagProxy:getBagIsFull()
	if isBagFull then
		sharedTextAnimateReward():animateStartByString("背包已满,请清理后再召唤");
		return
	end

	local yingxionglingCount = self.bagProxy:getItemNum(1009002)
	if yingxionglingCount < 10 then
		self:onLangyalingCommonPopup(yingxionglingCount)
	else
		self:sendMessageToServer()
	end
end
function LangyalingPopup:onClickJinbiOneButton(event)
	self.clickType = 2
	self.buyCount = 1

	local isBagFull = self.bagProxy:getBagIsFull()
	if isBagFull then
		sharedTextAnimateReward():animateStartByString("背包已满,请清理后再召唤");
		return
	end

	local langyalingCount = self.bagProxy:getItemNum(1009001)
	if langyalingCount < 1 then
		self:onLangyalingCommonPopup(langyalingCount)
	else
		self:sendMessageToServer()
	end
	if GameVar.tutorStage == TutorConfig.STAGE_1003 then

		openTutorUI({x=680, y=250, width = 2, height = 2, alpha = 125, delay = 1.8, fullScreenTouchable = true});
    	sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100305, BooleanValue = 0})
    	print("onClickJinbiOneButton")
    end
end
function LangyalingPopup:onClickJinbiTenButton(event)
	self.clickType = 2
	self.buyCount = 10

	local isBagFull = self.bagProxy:getBagIsFull()
	if isBagFull then
		sharedTextAnimateReward():animateStartByString("背包已满,请清理后再召唤");
		return
	end
		
	local langyalingCount = self.bagProxy:getItemNum(1009001)
	if langyalingCount < 10 then
		self:onLangyalingCommonPopup(langyalingCount)
	else
		self:sendMessageToServer()
	end
end

function LangyalingPopup:onClickYinbiShowGroup()
	-- Director:sharedDirector():setProjection(kCCDirectorProjection3D);
	-- local function _backFun()
	-- 	-- Director:sharedDirector():setProjection(kCCDirectorProjectionDefault);
	-- 	self.yinbiShowGroup:setVisible(false)
	-- 	self.yinbiRollGroup:setVisible(true)
	-- 	-- Tweenlite:removeFlip(self.yinbiShowGroup,0);
	-- end

	Tweenlite:CardFlip(self.yinbiShowGroup,self.yinbiRollGroup,0.3)
	
	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
    	openTutorUI({x=294, y=473, width = 190, height = 60, alpha = 125});
    end

	-- Tweenlite:flip(self.yinbiShowGroup,0.5,180,_backFun);

end

function LangyalingPopup:onClickYinbiRollGroup()
	Tweenlite:CardFlip(self.yinbiRollGroup,self.yinbiShowGroup,0.3)
	-- Director:sharedDirector():setProjection(kCCDirectorProjection3D);
	-- local function _backFun()
	-- 	Director:sharedDirector():setProjection(kCCDirectorProjectionDefault);
	-- 	self.yinbiShowGroup:setVisible(true)
	-- 	self.yinbiRollGroup:setVisible(false)
	-- 	Tweenlite:removeFlip(self.yinbiRollGroup,0);

	-- end

	-- Tweenlite:flip(self.yinbiRollGroup,0.5,180,_backFun);
end


function LangyalingPopup:onClickJinbiShowGroup()
	Tweenlite:CardFlip(self.jinbiShowGroup,self.jinbiRollGroup,0.3)
	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
    	openTutorUI({x=809, y=473, width = 165, height = 64, alpha = 125});
    end
	-- Director:sharedDirector():setProjection(kCCDirectorProjection3D);
	-- local function _backFun()
	-- 	Director:sharedDirector():setProjection(kCCDirectorProjectionDefault);
	-- 	self.jinbiShowGroup:setVisible(false)
	-- 	self.jinbiRollGroup:setVisible(true)
	-- 	Tweenlite:removeFlip(self.jinbiShowGroup,0);
	-- end

	-- Tweenlite:flip(self.jinbiShowGroup,0.5,180,_backFun);
end

function LangyalingPopup:onClickJinbiRollGroup()
	Tweenlite:CardFlip(self.jinbiRollGroup,self.jinbiShowGroup,0.3)

	-- Director:sharedDirector():setProjection(kCCDirectorProjection3D);
	-- local function _backFun()
	-- 	Director:sharedDirector():setProjection(kCCDirectorProjectionDefault);
	-- 	self.jinbiRollGroup:setVisible(false)
	-- 	self.jinbiShowGroup:setVisible(true)
	-- 	Tweenlite:removeFlip(self.jinbiRollGroup,0);
	-- end

	-- Tweenlite:flip(self.jinbiRollGroup,0.5,180,_backFun);
end

-- 弹选中部分
function LangyalingPopup:popClickLayer(cardArray)
	-- self:removeCardsLayer()

	self:addChild(self.cardsLayer)
	self.cardsLayer:popClickLayer(cardArray)
	self:refreshItemText()
end

function LangyalingPopup:removeCardsLayer()
	if self.cardsLayer then
		self:removeChild(self.cardsLayer)
		self.cardsLayer = nil
	end
end

function LangyalingPopup:onPreUIClose()
  
end

function LangyalingPopup:onUIClose()
  self:dispatchEvent(Event.new(LangyalingNotifications.CLOSE_UI_LANGYALING,nil,self));
end


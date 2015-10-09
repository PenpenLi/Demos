HarmoniousUI = class();

function HarmoniousUI:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("harmonious_ui");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self:initUI();
	self.personImg = nil;
end
function HarmoniousUI:getUI()
	return self.armature_d;
end
function HarmoniousUI:initUI()
	-- local commonReturnButton = self.armature_d:getChildByName("common_copy_return_button");
	-- local commonReturnButtonP = convertBone2LB4Button(commonReturnButton);
	-- self.armature_d:removeChild(commonReturnButton);	
	-- local returnButton = CommonButton.new();
	-- returnButton:initialize("common_return_button_normal","common_return_button_down",CommonButtonTouchable.BUTTON);
	-- returnButton:setPosition(commonReturnButtonP);
	-- self.armature_d:addChild(returnButton);
	-- returnButton:addEventListener(DisplayEvents.kTouchTap,self.onReturn,self);
	-- returnButton:setVisible(false);
	-- self.returnBtn = returnButton;

	self.ttlNameTF = generateText(self.armature_d,self.armature,"ttlNameTF","");
	self.infoTF = generateText(self.armature_d,self.armature,"infoTF","");
	self.itemInfoTF = generateText(self.armature_d,self.armature,"itemInfoTF","索要物品：");
	self.itemTF = generateText(self.armature_d,self.armature,"itemTF","");
	--local infoTFTD = self.armature:getBone("infoTF").textData;
	--self.infoTF = createMultiColoredLabelWithTextData(infoTFTD,"");
	--self.armature_d:addChild(self.infoTF);
	--self.infoTF:setPositionY(self.infoTF:getPositionY()+40);
	-- self.smileImg = self.armature_d:getChildByName("smileImg");
	-- self.simpleImg = self.armature_d:getChildByName("simpleImg");
	-- self.angerImg = self.armature_d:getChildByName("angerImg");
	self.personImgTmp = self.armature_d:getChildByName("personImgTmp");
	self.personImgTmp.touchEnabled=false;
   	self.personImgTmp.touchChildren=false;

	local userLvl = self.parent.userProxy:getLevel();
	local needLvl = tonumber(analysis("Xishuhuizong_Xishubiao",1099,"constant"))
	if not userLvl or userLvl<needLvl then 
   		local text_data={x=600,y=100,width=0,height=0,size=22,alignment=0,color=0xebc07d};
		local tishi = createTextFieldWithTextData(text_data,"(主角"..needLvl.."级之前不免疫哦)");
		self.armature_d:addChild(tishi);
	end

	self.proBtn = Button.new(self.armature:findChildArmature("component_HL_button_1"),false,"武力威慑");
	self.proBtn:addEventListener(Events.kStart,self.onClickOppBtn,self);
	self.briBtn = Button.new(self.armature:findChildArmature("component_HL_button"),false,"武力威慑");
	self.briBtn:addEventListener(Events.kStart,self.onClickBriBtn,self);
	self.oppBtn = Button.new(self.armature:findChildArmature("component_ZD_button"),false,"武力威慑");
	self.oppBtn:addEventListener(Events.kStart,self.onClickOppBtn,self);
	self:makeFace(5);
	self.bgImg = Sprite.new(CCSprite:create(artData[StaticArtsConfig.BACKGROUD_MEETING_BG].source));
	self.bgImg:setAnchorPoint(ccp(0.5,0.5));
	self.bgImg:setPositionXY(GameConfig.STAGE_WIDTH*0.5,GameConfig.STAGE_HEIGHT*0.5+GameData.uiOffsetY);
	self.armature_d:addChildAt(self.bgImg,0);
	self.bgImg:addEventListener(DisplayEvents.kTouchTap,self.backToMeeting,self);
	self.armature_d:setPositionY(-GameData.uiOffsetY);
	-- self:initBackGround();
end
function HarmoniousUI:onShowDlg(baseData,severData,userCurrencyProxy)
	self.userCurrencyProxy = userCurrencyProxy;
	self.userSilver = userCurrencyProxy:getSilver();
	self.show = true;
	self.baseData = baseData;
	self.severData = severData;
	local personVo = analysis("Juqing_JuqingNPC", baseData.faceid)
	self.personImg = Sprite.new(CCSprite:create(artData[personVo.bustName].source));
	self.personImg.sprite:setFlipX(personVo.fangxiang==0);
	self.personImgTmp:addChild(self.personImg);
	self.personImg:setAnchorPoint(ccp(1,0));
	self.ttlNameTF:setString(baseData.name);
	local gongId = self.baseData.isStandPoint and 1289 or 1290;
	self.gongImg = getImageByArtId(gongId)
	self.armature_d:addChildAt(self.gongImg,100);
	self.gongImg:setPositionXY(480,100)
	self:makeFace(severData.State);
end
function HarmoniousUI:makeFace(type)
	-- self.smileImg:setVisible(type == 1);
	-- self.simpleImg:setVisible(type == 2 or type == 3 or type == 5);
	-- self.angerImg:setVisible(type == 4 or type == 6);
	self.proBtn:setVisible(true);
	self.briBtn:setVisible(true);
	self.oppBtn:setVisible(true);
	self.needCop = nil;
	self.itemTF:setVisible(false);
	self.itemInfoTF:setVisible(false);
	if type == 1 then
		self.proBtn:setVisible(false);
		self.briBtn:setVisible(false);
		self.oppBtn:setVisible(false);
		--self.infoTF:setString("<content><font color='#ffffff'>"..self.baseData.favor.."</font></content>");
		self.infoTF:setString(self.baseData.favor);
	elseif type == 2 then
		self.oppBtn:setVisible(false);
		self.proBtn:setLable(self.baseData.probability_button);
		self.briBtn:setLable(self.baseData.bribery_button);
		local vo =  analysis("Shili_Chaotangzhengbianhuiluku",self.severData.Param);
		local itemVo = analysis("Daoju_Daojubiao",vo.itemID);
		self.infoTF:setString(self.baseData.neutral);
		self.itemTF:setString(itemVo.name.."×"..vo.number);
		local color = CommonUtils:ccc3FromUInt(getColorByQuality(itemVo.color));
		self.itemTF:setColor(color);
		--local str = StringUtils:stuff_string_replace(self.baseData.bribery,"@","</font><font color='"..color.."'>"..itemVo.name.."</font><font color='#ffffff'>",1);
		--str = StringUtils:stuff_string_replace(str,"#","X"..vo.number,1);
		--self.infoTF:setString("<content><font color='#ffffff'>"..str.."</font></content>");
		self.itemTF:setVisible(true);
		self.itemInfoTF:setVisible(true);
		self.needCop = vo.number;
	elseif type == 3 then
		self.proBtn:setVisible(false);
		self.briBtn:setVisible(false);
		self.oppBtn:setLable(self.baseData.oppose_button);
		--self.infoTF:setString("<content><font color='#ffffff'>"..self.baseData.oppose.."</font></content>");
		self.infoTF:setString(self.baseData.oppose);
	else
		self.proBtn:setVisible(false);
		self.briBtn:setVisible(false);
		self.oppBtn:setVisible(false);
		--self.infoTF:setString("<content><font color='#ffffff'>败将又来做什么！！！</font></content>");
		self.infoTF:setString("败将又来做什么！！！");
	end
	
end

function HarmoniousUI:onConfirm()
	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=555, y=35, width = 168, height = 65, alpha = 125});
    end
end

function HarmoniousUI:onClickBriBtn()
	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=655, y=210, width = 190, height = 60, alpha = 125});
    end

	if tonumber(self.needCop)>tonumber(self.userCurrencyProxy:getSilver()) then
		self.parent:dispatchEvent(Event.new("TO_DIANJINSHOU",nil,self));
		local str =analysis("Tishi_Tishineirong",1008,"captions");
		sharedTextAnimateReward():animateStartByString(str);
		return;
	end
	local vo =  analysis("Shili_Chaotangzhengbianhuiluku",self.severData.Param);
	local itemVo = analysis("Daoju_Daojubiao",vo.itemID);
	self.infoTF:setString(self.baseData.bribery);
	self.itemTF:setString(itemVo.name.."×"..vo.number);
	local commonPopup=CommonPopup.new();
	commonPopup:initialize("你将"..itemVo.name.."×"..vo.number.."送给"..self.baseData.name..",他将同意你的提案。",self,self.onBriConfirm,nil,nil,nil,nil,{"确认","取消"},nil,true,false);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
	commonPopup:setPositionY(-GameData.uiOffsetY);
end
function HarmoniousUI:onBriConfirm()
	local commonPopup=CommonPopup.new();
	commonPopup:initialize(self.baseData.name.."转变了态度,同意你的提案！",self,self.onConfirm,nil,nil,nil,true,nil,nil,true);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
	commonPopup:setPositionY(-GameData.uiOffsetY);
	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=545, y=210, width = 190, height = 60, alpha = 125});
    end
	sendMessage(19,11,{ID=self.baseData.id,Type=1});
	self:backToMeeting();
end
function HarmoniousUI:onClickOppBtn()
	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=656, y=210, width = 190, height = 60, alpha = 125});
    end
	self.parent:dispatchEvent(Event.new("to_Meeting_Team",{context = self, onEnter = self.onReturn,onClose = self.refreshByOther,funcType = "Meeting"},self));
	setFactionCurrencyVisible(false)
end
function HarmoniousUI:refreshByOther()
	setFactionCurrencyVisible(true)
end
function HarmoniousUI:backToMeeting()
	self.isCanClick = nil;
	self.show = false;
	if self.personImg then
		self.personImgTmp:removeChild(self.personImg);
		self.armature_d:removeChild(self.gongImg);
		self.personImg = nil;
		self.gongImg = nil
	end
	self.baseData =nil;
	self.parent:onCloseHarmoniousUI();
end
function HarmoniousUI:onReturn()
	sendMessage(19,11,{ID=self.baseData.id,Type=2});
	self:backToMeeting()
end
function HarmoniousUI:isShow()
	return self.show;
end
function HarmoniousUI:initBackGround()
	local winSize = Director:sharedDirector():getWinSize()
	local backHalfAlphaLayer = LayerColorBackGround:getCustomBackGround(winSize.width, winSize.height, 200);
	--backHalfAlphaLayer:setPositionXY(-2,-winSize.height-4);
	self.armature_d:addChildAt(backHalfAlphaLayer,0)
	backHalfAlphaLayer:addEventListener(DisplayEvents.kTouchTap,self.backToMeeting,self);

end
function HarmoniousUI:dispose()
	self.skeleton = nil;
	self.parent = nil;
	self.armature:dispose();
end
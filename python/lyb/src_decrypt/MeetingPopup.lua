require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";
require "main.view.meeting.ui.ChooseProposalUI";
require "main.view.meeting.ui.VoteUI";
require "main.view.meeting.ui.HarmoniousUI";
require "main.view.meeting.ui.ResultUI";
MeetingPopup=class(LayerPopableDirect);
function MeetingPopup:ctor()
	self.class=MeetingPopup;
end

function MeetingPopup:dispose()
	for i=1,12 do
		self.officerArr[i]:dispose();
		if self.platFormType == CC_PLATFORM_IOS then
			BitmapCacher:deleteTextureLua(self.officerArr[i].url);
		end
		self.officerArr[i] = nil;
	end
	if self.voteUIMger then
		self.voteUIMger:dispose();
	end
	if self.chooseProposalUIMger then
		self.chooseProposalUIMger:dispose();
	end
	if self.harmoniousUIMger then
		--sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.harmoniousUI);
		--self.harmoniousUI:cleanup();
		self.harmoniousUIMger:dispose();
	end
	if self.resultUIMger then
		self.resultUIMger:dispose();
	end
	MeetingPopup.superclass.dispose(self);
end

function MeetingPopup:initialize()
	self.skeleton=nil;
	self.chooseProposalUI = nil;
	self.voteUI = nil;
	self.harmoniousUI = nil;
	self.resultUI = nil;
	self.officerArr = nil;
	self.platFormType = nil;
end
function MeetingPopup:onDataInit()
	-- local proxyRetriever=ProxyRetriever.new();
	self.userProxy = self:retrieveProxy(UserProxy.name);
	self.countProxy = self:retrieveProxy(CountControlProxy.name);
	self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	self.userImgID = analysis("Zhujiao_Huanhua",self.userProxy.transforId,"art");
	self.skeleton = getSkeletonByName("meeting_ui");
	self.platFormType = CommonUtils:getCurrentPlatform()

	local layerPopableData = LayerPopableData.new();
	layerPopableData:setHasUIBackground(true);
	layerPopableData:setHasUIFrame(true);
	layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_MEETING_BG,nil,true,2);
	layerPopableData:setArmatureInitParam(self.skeleton,"meeting_ui");
	self:setLayerPopableData(layerPopableData);
	setFactionCurrencyVisible(true);
end


function MeetingPopup:initialize()
  -- self:initLayer();

  
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end

function MeetingPopup:onPrePop()
	local size=Director:sharedDirector():getWinSize();
	self:changeWidthAndHeight(size.width,size.height);
	self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT)); 

	self.armature_d = self.armature.display;
	self.askBtn = Button.new(self.armature:findChildArmature("common_copy_ask_button"),false,"");
	self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
	self.returnBtn = self.armature_d:getChildByName("common_copy_close_button");
	-- local pos = self.askBtn:getPosition();
	-- self.askBtn:setPositionXY(pos.x,pos.y+GameData.uiOffsetY);
	-- self.returnBtn:setPositionY(self.returnBtn:getPositionY()+GameData.uiOffsetY);
	self.xztaBtn_d = Button.new(self.armature:findChildArmature("common_copy_blue_button"),false,"选择提案",true);
	self.xztaBtn_d:addEventListener(Events.kStart,self.onShowChooseProposal, self);
	--local text='<content><font color="#00FF00" ref="1">查看说明</font></content>';
  	--local text_data={x=40,y=600,width=130,height=38,size=30,alignment=2};
  	--self.text_instruction=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  	--self.text_instruction:addEventListener(DisplayEvents.kTouchTap,self.onShowTip,self);
  	--self.armature_d:addChild(self.text_instruction);
	self.officerArr = {};
	for i=1,12 do
		table.insert(self.officerArr, PersonRender.new(self.armature:findChildArmature("person_"..i),i,self));
	end
	self.officeLvTTF = generateText(self.armature_d,self.armature,"officeLvTTF","",true);
	self.countTF = generateText(self.armature_d,self.armature,"countTF","",true);
	self.pageTmp = self.armature_d:getChildByName("pageTmp");
	self.armature_d:setChildIndex(self.pageTmp,1000);
	sendMessage(19,9);
end
function MeetingPopup:onShowTip()
	local text=analysis("Tishi_Guizemiaoshu",6,"txt");
	TipsUtil:showTips(self.askBtn,text,500,nil,50);
end
function MeetingPopup:onUIInit()
	CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
end
function MeetingPopup:onChooseProposal(data)
	self.chooseData = data;
	self.xztaBtn_d:setVisible(false);
end
function MeetingPopup:setState(state)
	self.state = state;
	self.officeLvTTF:setString("");
	self.countTF:setString("");
	self.countTF:setVisible(false);
	local estr = {};
	if state == 1 then
		self.xztaBtn_d:setVisible(true);
		self.officeLvTTF:setString("上朝！选择提案向圣上进谏吧!");
		local count,ttlCount = self.countProxy:getRemainCountByID(CountControlConfig.CHAOTANGZHENGBIAN,CountControlConfig.Parameter_0)
		self.countTF:setString("剩余次数："..count.."/"..ttlCount);
		self.countTF:setVisible(true);
	elseif state == 2 then
		self:onChooseProposal(self.proposalData[1]);
		self.officeLvTTF:setString("选择反对或中立的官员可扭转局势");
		self:onShowVoteUI()
	elseif state == 3 then--success
		self:onChooseProposal(self.proposalData[1]);
	elseif state == 4 then
		self:onChooseProposal(self.proposalData[1]);
	end
	if self.chooseData and self.chooseData.ID then
		estr = {ID=self.chooseData.ID};
	end
	hecDC(3,7,1,estr);
end

function MeetingPopup:setProposal(IDParamArray)
	self.proposalData = IDParamArray;
end
function MeetingPopup:setOfficerState(IDStateParamArray)
	local stateCountArr = {[1]=0,[2]=0,[3]=0};
	local faceState = 0;
	if self.state >= 3 then 
		faceState = 6;
	end
	for k,v in pairs(IDStateParamArray) do
		self.officerArr[k]:setState(0);
		stateCountArr[v.State] = stateCountArr[v.State]+1;
	end
	local ra = analysis("Xishuhuizong_Xishubiao",1024,"constant");
	ra = 1-ra/100000;
	local rate = (stateCountArr[1]+stateCountArr[2]*ra)/(stateCountArr[1]+stateCountArr[2]+stateCountArr[3]);
	if self.state < 3 then 
		for k,v in pairs(IDStateParamArray) do
			self.officerArr[k]:setState(v.State+faceState,v);
		end
		self.voteUIMger:updateRatio(rate);
	elseif self.needShowResult then
		self:onShowResultUI(self.state == 3,rate,self.chooseData)
	else
		self.officeLvTTF:setString("今日已下朝，明日请早！");
	end
end

function MeetingPopup:onRequestedData()

end

function MeetingPopup:onUIClose()
	if self.harmoniousUIMger then
		self:onCloseHarmoniousUI();
	end
	if self.resultUIMger then
		self:onCloseResultUI();
	end

	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
	      openTutorUI({x=955, y=370, width = 200, height = 200, alpha = 84});
    end
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end

function MeetingPopup:onClickPerson(data,severData)
	if self.isShowHarmoniousUI then return end
	if self.state == 2 and (not self.harmoniousUIMger or not self.harmoniousUIMger:isShow()) then
		hecDC(3,7,2,{chaochenname=data.name});
		self.returnBtn:setVisible(false);
		self:onShowHarmoniousUI(data,severData);
	end
end
function MeetingPopup:onVote()
	self.needShowResult = true;
	--self.resultUI:onShowDlg();
end
function MeetingPopup:resetReturnBtn()
	self.returnBtn:setVisible(true);
end

--ChooseProposalUI
function MeetingPopup:getChooseProposalUI()
	if not self.chooseProposalUIMger then
		self.chooseProposalUIMger = ChooseProposalUI.new(self.skeleton,self);
		self.chooseProposalUI = self.chooseProposalUIMger:getUI();
	end
	return self.chooseProposalUI;
end
function MeetingPopup:onShowChooseProposal()
	self.returnBtn:setVisible(false);
	self.pageTmp:addChild(self:getChooseProposalUI());
	self.chooseProposalUIMger:onOpenDlg(self.proposalData);
    if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=950, y=306, width = 118, height = 118, alpha = 125});
    end
end
function MeetingPopup:onCloseChooseProposal()
	self:resetReturnBtn()
	self.pageTmp:removeChild(self.chooseProposalUI,false);
end
--VoteUI
function MeetingPopup:getVoteUI()
	if not self.voteUIMger then
		self.voteUIMger = VoteUI.new(self.skeleton,self);
		self.voteUI = self.voteUIMger:getUI();
	end
	return self.voteUI;
end
function MeetingPopup:onShowVoteUI()
	--self.returnBtn:setVisible(false);
	self.pageTmp:addChild(self:getVoteUI());
	self.voteUIMger:onShowDlg(self.chooseData);
end
function MeetingPopup:onCloseVoteUI()
	--self:resetReturnBtn()
	self.pageTmp:removeChild(self.voteUI,false);
end

--HarmoniousUI
function MeetingPopup:getHarmoniousUI()
	if not self.harmoniousUIMger then
		self.harmoniousUIMger = HarmoniousUI.new(self.skeleton,self);
		self.harmoniousUI = self.harmoniousUIMger:getUI();
		--sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.harmoniousUI);
	end
	return self.harmoniousUI;
end
function MeetingPopup:onShowHarmoniousUI(data,severData)
	self.isShowHarmoniousUI = true;
	local userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
	self.returnBtn:setVisible(false);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self:getHarmoniousUI());
	--self:getHarmoniousUI():setVisible(true);
	self.harmoniousUIMger:onShowDlg(data,severData,userCurrencyProxy);
end
function MeetingPopup:onCloseHarmoniousUI()
	self:resetReturnBtn()
	--if self.platFormType == CC_PLATFORM_IOS then
	--	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.harmoniousUI,false);
		--BitmapCacher:removeUnused();
	--else
		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.harmoniousUI);
		self.harmoniousUIMger:dispose();
		self.harmoniousUIMger = nil;
		self.harmoniousUI = nil;
		--BitmapCacher:removeUnused();
	--end
	BitmapCacher:removeUnused();
	Tweenlite:delayCall(self, 0.5, function ()
		self.isShowHarmoniousUI = nil;
	end);
end
--ResultUI
function MeetingPopup:getResultUI()
	if not self.resultUIMger then
		self.resultUIMger = ResultUI.new(self.skeleton,self);
		self.resultUI = self.resultUIMger:getUI();
	end
	return self.resultUI;
end
function MeetingPopup:onShowResultUI(isSuccess,rate,data)
	self.returnBtn:setVisible(false);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self:getResultUI());
	self.resultUIMger:onShowDlg(isSuccess,rate,data);
end
function MeetingPopup:onCloseResultUI()
	self:resetReturnBtn()
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.resultUI);
	self.resultUIMger:dispose();
	self.resultUIMger = nil;
	self.resultUI = nil;
	--self:onUIClose();


	local count,ttlCount = self.countProxy:getRemainCountByID(CountControlConfig.CHAOTANGZHENGBIAN,CountControlConfig.Parameter_0)
	if count>0 then--这是以前的逻辑 if count>0 and GameVar.tutorStage ~= TutorConfig.STAGE_1012 then
		sendMessage(19,9);
	else
		self:closeUI()
	end
end

PersonRender = class()

function PersonRender:ctor(armature,id,parent)
	self.parent = parent;
	self.armature = armature;
	self.armature_d = armature.display;
	self.data = analysis("Shili_Chaotangzhengbianchaochen",id);
	self:init();
	self:makePerson(self.data.bodyid);
	self.person:changeFaceDirect(id==3 or id==4 or id==7 or id==8 or id==11 or id==12);
	self.data.isStandPoint = self.person:getChangeFace()--站在左边还是右边
	self:setState(0);
end
function PersonRender:init()
	self.angerImg = self.armature_d:getChildByName("angerImg");
	self.angerImg:setPositionY(self.angerImg:getPositionY()-40);
	self.simpleImg = self.armature_d:getChildByName("simpleImg");
	self.simpleImg:setPositionY(self.simpleImg:getPositionY()-40);
	self.smileImg = self.armature_d:getChildByName("smileImg");
	self.smileImg:setPositionY(self.smileImg:getPositionY()-40);
	self.opposeImg = self.armature_d:getChildByName("opposeImg");
	self.agreeImg = self.armature_d:getChildByName("agreeImg");
	self.personTmp = self.armature_d:getChildByName("personTmp");
	self.armature_d:addEventListener(DisplayEvents.kTouchTap, self.onClickPerson, self);
end
function PersonRender:makePerson(bodyid)
	self.person,self.url = getMeetingOfficer(bodyid);
	self.personTmp:addChild(self.person);
	self.person:setPositionY(40);
	self.person:addTouchEventListener(DisplayEvents.kTouchTap, self.onClickPerson, self);
end
function PersonRender:setState(state,data)
	self.severData = data;
	self.angerImg:setVisible(state == 3);
	self.simpleImg:setVisible(state == 2);
	self.smileImg:setVisible(state == 1);
	self.opposeImg:setVisible(false);--state == 10 or state == 6 or state == 5);
	self.agreeImg:setVisible(false);--state == 7);
end
function PersonRender:onClickPerson()
	if GameVar.tutorStage == TutorConfig.STAGE_1012 and not self.parent.cliclPersonTutor then
      openTutorUI({x=881, y=39-GameData.uiOffsetY, width = 190, height = 60, alpha = 125});
      self.parent.cliclPersonTutor = true;
    end
	self.parent:onClickPerson(self.data,self.severData);

end
function PersonRender:dispose()
	self.parent = nil;
	self.armature = nil;
	self.armature_d = nil;
	self.personTmp:removeChildren();
	self.person = nil;
end

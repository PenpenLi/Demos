ChooseProposalUI = class();
function ChooseProposalUI:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("choose_proposal_ui");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self:initUI();
end
function ChooseProposalUI:getUI()
	return self.armature_d;
end

function ChooseProposalUI:initUI()
	local closeButton=self.armature_d:getChildByName("common_copy_close_button");
	local closeButton_pos = convertBone2LB4Button(closeButton);
	self.armature_d:removeChild(closeButton);
	closeButton=CommonButton.new();
	closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	closeButton:setPosition(closeButton_pos);
	closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
	self.armature_d:addChild(closeButton);
	self.button_close=closeButton;

	self.personImgTmp = self.armature_d:getChildByName("personImgTmp");
	local sex = analysis("Zhujiao_Zhujiaozhiye",self.parent.userProxy:getCareer(),"sex")
	local imgId = analysis("Zhujiao_Zhujiaozhiye",self.parent.userProxy:getCareer(),"art1")
	self.personImg = Sprite.new(CCSprite:create(artData[imgId].source));
	--self.personImg = Sprite.new(CCSprite:create(artData[self.parent.userImgID].source));
	self.personImg.sprite:setFlipX(true);
	self.personImgTmp:addChild(self.personImg);
	self.personImg:setScale(0.7);
	local textData = self.armature:getBone("ttlNameTF").textData;
	self.ttlNameTF = BitmapTextField.new("选择提案","anniutuzi");
	self.armature_d:addChild(self.ttlNameTF);
	self.ttlNameTF:setPositionXY(textData.x-30,textData.y-2);
	--generateText(self.armature_d,self.armature,"ttlNameTF","选择提案");
	self.render_1 = self:genRender(self.armature:findChildArmature("proposal_1"))
	self.render_2 = self:genRender(self.armature:findChildArmature("proposal_2"))
end
function ChooseProposalUI:onOpenDlg(dataArr)
	self:setRender(self.render_1,dataArr[1]);
	self:setRender(self.render_2,dataArr[2]);
	--TODO
end
function ChooseProposalUI:genRender(armature)
	local render = {};
	render.armature = armature;
	render.armature_d = armature.display;

	-- local ttlNameTFTextData = armature:getBone("ttlNameTF").textData;
	-- render.ttlNameTFSk = createTextFieldWithTextData(ttlNameTFTextData,"",true);
	-- render.armature_d:addChild(render.ttlNameTFSk);
	-- render.ttlNameTFSk:setPositionY(render.ttlNameTFSk:getPositionY()-3);
	-- render.ttlNameTFSk:setPositionX(render.ttlNameTFSk:getPositionX()-1);
	-- render.ttlNameTF = createMultiColoredLabelWithTextData(ttlNameTFTextData,"");
	-- render.armature_d:addChild(render.ttlNameTF);

	render.ttlNameTF = generateText(render.armature_d,armature,"ttlNameTF","",true);
	render.infoTF = generateText(render.armature_d,armature,"infoTF","");

	-- local rewardTFTextData = armature:getBone("rewardTF").textData;
	-- render.rewardTFSk = createTextFieldWithTextData(rewardTFTextData,"",true);
	-- render.armature_d:addChild(render.rewardTFSk);
	-- render.rewardTFSk:setPositionY(render.rewardTFSk:getPositionY()-3);
	-- render.rewardTFSk:setPositionX(render.rewardTFSk:getPositionX()-1);
	-- render.rewardTF = createMultiColoredLabelWithTextData(rewardTFTextData,"");
	-- render.armature_d:addChild(render.rewardTF);
	render.rewardTF = generateText(render.armature_d,armature,"rewardTF","提案通过奖励：");
	-- local rewardPTFTextData = armature:getBone("rewardPTF").textData;
	-- render.rewardPTFSk = createTextFieldWithTextData(rewardPTFTextData,"",true);
	-- render.armature_d:addChild(render.rewardPTFSk);
	-- render.rewardPTFSk:setPositionY(render.rewardPTFSk:getPositionY()-3);
	-- render.rewardPTFSk:setPositionX(render.rewardPTFSk:getPositionX()-1);
	-- render.rewardPTF = createMultiColoredLabelWithTextData(rewardPTFTextData,"");
	-- render.armature_d:addChild(render.rewardPTF);

	--render.rewardPTF = generateText(render.armature_d,armature,"rewardPTF","");

	render.img1 = render.armature_d:getChildByName("img1");
	render.rewd1 = generateText(render.armature_d,armature,"rew1TF","");
	render.img2 = render.armature_d:getChildByName("img2");
	render.rewd2 = generateText(render.armature_d,armature,"rew2TF","");

	render.button_d = render.armature_d:getChildByName("btn");
	render.button =SingleButton:create(render.button_d,function ()
		self:onClickProposal(render);
	end);
	--render.button_d:addEventListener(DisplayEvents.kTouchTap, self.onClickProposal, self,render);
	return render;
end
function ChooseProposalUI:setRender(render,data)
	render.data = data;
	render.proposalData = analysis("Shili_Chaotangzhengbiantian",data.ID);
	render.proRewardData = analysis("Shili_Chaotangzhengbianjiangliku",data.Param);
	-- local color = getColorByQuality(render.proposalData.coloer,true);
	-- render.ttlNameTFSk:setString(render.proposalData.name);
	-- render.ttlNameTF:setString("<content><font color='"..color.."'>"..render.proposalData.name.."</font></content>");
	render.ttlNameTF:setString(render.proposalData.name);
	render.ttlNameTF:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(render.proposalData.coloer)))
	render.infoTF:setString(render.proposalData.content);
	
	-- color = getColorByQuality(itemVo.color,true);
	-- render.rewardTFSk:setString("奖励：声望X"..render.proposalData.gift.." "..itemVo.name.."X"..render.proRewardData.number);
	-- render.rewardTF:setString("<content><font color='#FFFFFF'>奖励：</font><font color='#9900FF'>声望</font><font color='#FFFFFF'>X"..render.proposalData.gift.."</font><font color='"..color.."'> "..itemVo.name.."</font><font color='#FFFFFF'>X"..render.proRewardData.number.."</font></content>");
	-- render.rewardPTFSk:setString("完美提案奖励：声望X"..analysis("Xishuhuizong_Xishubiao",1027,"constant"));
	-- render.rewardPTF:setString("<content><font color='#FFFFFF'>完美提案奖励：</font><font color='#9900FF'>声望</font><font color='#FFFFFF'>X"..analysis("Xishuhuizong_Xishubiao",1027,"constant").."</font></content>");
	local itemVo = analysis("Daoju_Daojubiao",7);
	local img = Sprite.new(CCSprite:create(artData[itemVo.art].source));
	img:setScale(0.5);
	render.img1:addChild(img);
	render.rewd1:setString(itemVo.name.."X"..render.proposalData.gift);
	itemVo = analysis("Daoju_Daojubiao",render.proRewardData.itemID);
	img = Sprite.new(CCSprite:create(artData[itemVo.art].source));
	img:setScale(0.5);
	render.img2:addChild(img);
	render.rewd2:setString(itemVo.name.."X"..render.proRewardData.number);
end

function ChooseProposalUI:onClickProposal(render)
	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
		openTutorUI({x=327, y=235, width = 78, height = 100, alpha = 125});
		sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 101216, BooleanValue = 0})
    end
	sendMessage(19,10,{ID=render.data.ID});
	self.parent:onChooseProposal(render.data);
	self:onCloseButtonTap();
end
function ChooseProposalUI:onCloseButtonTap()
	self.parent:onCloseChooseProposal();
end
function ChooseProposalUI:dispose()
	self.render_1.img1:removeChildren();
	self.render_1.img2:removeChildren();
	self.render_1.button:dispose();
	self.render_1 = nil;
	self.render_2.img1:removeChildren();
	self.render_2.img2:removeChildren();
	self.render_2.button:dispose();
	self.render_2 = nil;
	self.skeleton = nil;
	self.parent = nil;
	self.armature:dispose();
end
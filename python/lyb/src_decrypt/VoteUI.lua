VoteUI=class()

function VoteUI:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("vote_ui");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self:initUI();
end
function VoteUI:getUI()
	return self.armature_d;
end
function VoteUI:initUI()
	-- self.ttlNameTF = generateText(self.armature_d,self.armature,"ttlNameTF","");
	-- self.rewardTF = generateText(self.armature_d,self.armature,"rewardTF","");
	local rewardTFTextData = self.armature:getBone("rewardTF").textData;
	self.rewardTF = createMultiColoredLabelWithTextData(rewardTFTextData,"");
	self.armature_d:addChild(self.rewardTF);

	local rewardPTFTextData = self.armature:getBone("rewardPTF").textData;
	self.rewardPTF = createMultiColoredLabelWithTextData(rewardPTFTextData,"");
	self.armature_d:addChild(self.rewardPTF);


	self.infoTF = generateText(self.armature_d,self.armature,"infoTF","",true);

	self.btn = Button.new(self.armature:findChildArmature("common_copy_blue_button"),false,"表决",true);
	self.btn:addEventListener(Events.kStart,self.onClickVote,self);
end
function VoteUI:onShowDlg(data)
	self.data = data;
	self.proposalData = analysis("Shili_Chaotangzhengbiantian",data.ID);
	self.proRewardData = analysis("Shili_Chaotangzhengbianjiangliku",data.Param);
	-- self.ttlNameTF:setString(self.proposalData.name);
	--local color = getColorByQuality(self.proposalData.coloer,true);
	--self.ttlNameTFSk:setString(self.proposalData.name);
	--self.ttlNameTF:setString("<content><font color='"..color.."'>"..self.proposalData.name.."</font></content>");
	--self.rewardTF:setString(self.proposalData.content);
	local itemVo = analysis("Daoju_Daojubiao",self.proRewardData.itemID);
	local color = getColorByQuality(itemVo.color,true);
	--self.rewardTF:setString("奖励：声望X"..self.proposalData.gift.." "..itemVo.name.."X"..self.proRewardData.number);
	--self.rewardPTF:setString("完美提案奖励：声望X"..analysis("Xishuhuizong_Xishubiao",1027,"constant"));
	--self.rewardTFSk:setString("奖励：声望X"..self.proposalData.gift.." "..itemVo.name.."X"..self.proRewardData.number);
	self.rewardTF:setString("<content><font color='#FFFFFF'>表决成功奖励：</font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..self.proposalData.gift.."</font><font color='"..color.."'> "..itemVo.name.."</font><font color='#FFFFFF'>X"..self.proRewardData.number.."</font></content>");
	--self.rewardPTFSk:setString("完美提案奖励：声望X"..analysis("Xishuhuizong_Xishubiao",1027,"constant"));
	self.rewardPTF:setString("<content><font color='#FFFFFF'>100%支持额外奖励：</font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..analysis("Xishuhuizong_Xishubiao",1027,"constant").."</font></content>");
end
function VoteUI:updateRatio(rate)
	self.rate = math.ceil(rate*100);
	self.infoTF:setString("目前表决成功率："..self.rate.."%");
end
function VoteUI:onClickVote()
	if self.rate<100 then
		local commonPopup=CommonPopup.new();
		commonPopup:initialize("现在还没达到100%通过率哦，完美通过会获得额外奖励，真的表决吗？",self,self.onBriConfirm,nil,nil,nil,nil,{"确认","取消"},nil,true,false);
		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
		commonPopup:setPositionY(-GameData.uiOffsetY);
	else
		self:onBriConfirm();
	end
end
function VoteUI:onBriConfirm()
	sendMessage(19,12);
	self.parent:onCloseVoteUI();
	self.parent:onVote();

   if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=578, y=134, width = 170, height = 65, alpha = 125, delay = 1});
   end

end
function VoteUI:dispose()
	self.skeleton = nil;
	self.parent = nil;
	self.armature:dispose();
end
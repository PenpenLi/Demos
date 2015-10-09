
local ItemRender = class();
function ItemRender:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("itemRender");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self:initUI();
end
function ItemRender:initUI()
	self.start1 = self.armature_d:getChildByName("start1");
	self.start2 = self.armature_d:getChildByName("start2");
	self.start3 = self.armature_d:getChildByName("start3");
	self.start4 = self.armature_d:getChildByName("start4");
	self.start5 = self.armature_d:getChildByName("start5");
	self.start1:setVisible(false);
	self.start2:setVisible(false);
	self.start3:setVisible(false);
	self.start4:setVisible(false);
	self.start5:setVisible(false);
	self.ewaiImg = self.armature_d:getChildByName("ewaiImg");
	self.starW = self.start1:getContentSize().width;
	self.countTF = generateText(self.armature_d,self.armature,"countTF","",true);
	self.nameTF = generateText(self.armature_d,self.armature,"nameTF","",true);
	self.edge = self.armature_d:getChildByName("edge");
	self.img = self.armature_d:getChildByName("img");
	self.effectTmp = self.armature_d:getChildByName("effectTmp");
end
function ItemRender:getUI()
	return self.armature_d;
end
function ItemRender:setData(data)
	local daojuPO = analysis("Daoju_Daojubiao",data.ItemId);
	self.itemImage = BagItem.new(); 
    self.itemImage:initialize({ItemId = tonumber(data.ItemId), Count = 1,ttlC = data.Count});
    self.itemImage:setBackgroundVisible(true)
    self.itemImage.touchEnabled=true
    self.itemImage.touchChildren=true
	self.img:addChild(self.itemImage);
	self.nameTF:setString(daojuPO.name);
	self.ewaiImg:setVisible(data.isEwai);
	local color = CommonUtils:ccc3FromUInt(getColorByQuality(daojuPO.color));
	self.nameTF:setColor(color);
	if tonumber(data.Count)>1 then
		self.countTF:setString(data.Count);
	end

end
function ItemRender:playEffectXX()
	local boneCartoon1 = BoneCartoon.new()
    local function callBack()
        self.effectTmp:removeChild(boneCartoon1)
    end
	boneCartoon1:create("1397",1,callBack);
   	self.effectTmp:addChild(boneCartoon1);
end
function ItemRender:dispose()
	self.img:removeChild(self.itemImage);
	self.parent = nil;
	self.skeleton = nil;
	self.armature:dispose();
end



ResultUI = class();

function ResultUI:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("result_ui");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self:initUI();
end
function ResultUI:getUI()
	return self.armature_d;
end
function ResultUI:initUI()
	self.proposalFailImg = self.armature_d:getChildByName("proposalFailImg");
	self.proposalSuccImg = self.armature_d:getChildByName("proposalSuccImg");
	self.proposalPerfImg = self.armature_d:getChildByName("proposalPerfImg");
	self.ttl1TF =  generateText(self.armature_d,self.armature,"ttlTTF","");
	local color = CommonUtils:ccc3FromUInt(getColorByQuality(5));
   	self.ttl1TF:setColor(color);
	--local jlTextData = self.armature:getBone("jiangliTTF").textData;
	--self.ttl2TF = createMultiColoredLabelWithTextData(jlTextData,"");
	--self.armature_d:addChild(self.ttl2TF);
	--local jlpTextData = self.armature:getBone("jiangliPTTF").textData;
	--self.ttl3TF = createMultiColoredLabelWithTextData(jlpTextData,"");
	--self.armature_d:addChild(self.ttl3TF);
	self.ttl3TF =  generateText(self.armature_d,self.armature,"jiangliPTTF","");
	color = CommonUtils:ccc3FromUInt(0xff0000);
   	self.ttl3TF:setColor(color);
	self.yuanPan = self.armature_d:getChildByName("yuanhuan");
	self.itemTmp = self.armature_d:getChildByName("itemTmp");

	local winSize = Director:sharedDirector():getWinSize()
	self.bgImg = LayerColorBackGround:getCustomBackGround(winSize.width, winSize.height, 0);
	self.bgImg:setPositionY(-GameData.uiOffsetY);
	self.armature_d:addChildAt(self.bgImg,0)

	self.armature_d:setVisible(false);

  	self.close_btn=Button.new(self.armature:findChildArmature("common_copy_blue_button"),false,"确定",true);
    self.close_btn:addEventListener(Events.kStart,self.onCloseUI,self);
end
function ResultUI:onShowDlg(isSuccess,rate,data)
	self.armature_d:setVisible(true);
	self.proposalFailImg:setVisible(false);
	self.proposalSuccImg:setVisible(false);
	self.proposalPerfImg:setVisible(false);
	self.ttl1TF:setVisible(false);
	--self.ttl2TF:setVisible(false);
	self.ttl3TF:setVisible(false);
	self.close_btn:setVisible(false);
	--local twoColorNum = isSuccess and 2 or 6;
    --local color = CommonUtils:ccc3FromUInt(getColorByQuality(twoColorNum));
   	--self.ttl1TF:setColor(color);

    self.proposalData = analysis("Shili_Chaotangzhengbiantian",data.ID);
	self.proRewardData = analysis("Shili_Chaotangzhengbianjiangliku",data.Param);
	local itemVo = analysis("Daoju_Daojubiao",self.proRewardData.itemID);
	local color = getColorByQuality(itemVo.color,true);
    rate = math.ceil(rate*100);
	if isSuccess then
		if rate>99 then
			self.ttl1TF:setString("众臣拥护，卿真可为国之砥柱！");
			--self.ttl2TF:setString("<content><font color='#FFFFFF'>特赐奖励：</font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..self.proposalData.gift.."</font><font color='"..color.."'> "..itemVo.name.."</font><font color='#FFFFFF'>X"..self.proRewardData.number.."</font></content>");
			--self.ttl3TF:setString("<content><font color='#FFFFFF'>朕心大喜，特另赐：</font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..analysis("Xishuhuizong_Xishubiao",1027,"constant").."</font></content>");
			self.items = {{ItemId=7,Count=self.proposalData.gift},{ItemId=self.proRewardData.itemID,Count=self.proRewardData.number},{ItemId=7,Count=analysis("Xishuhuizong_Xishubiao",1027,"constant"),isEwai=true}};
			self.proposalImg = self.proposalPerfImg;
		else
			self.ttl1TF:setString("于朕天下，得臣如卿，朕心甚安");
			--self.ttl2TF:setString("<content><font color='#FFFFFF'>特赐奖励：</font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..self.proposalData.gift.."</font><font color='"..color.."'> "..itemVo.name.."</font><font color='#FFFFFF'>X"..self.proRewardData.number.."</font></content>");
			--self.ttl3TF:setString("<content><font color='#FFFFFF'>小提示：如果朝臣全部赞成将获得 </font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..analysis("Xishuhuizong_Xishubiao",1027,"constant").."</font></content>");
			self.items = {{ItemId=7,Count=self.proposalData.gift},{ItemId=self.proRewardData.itemID,Count=self.proRewardData.number}};
			self.proposalImg = self.proposalSuccImg;
		end
	else
		self.items = nil;
		self.ttl1TF:setString("得民心者，方可得天下");
		self.ttl3TF:setString('表决成功率为'..rate..'%，陛下驳回了你的提案。');
		--self.ttl3TF:setString("<content><font color='#FFFFFF'>朝臣全部赞成得赐</font><font color='#ff4cf0'>声望</font><font color='#FFFFFF'>X"..analysis("Xishuhuizong_Xishubiao",1027,"constant").." ，望卿勤勉</font></content>");
		self.proposalImg = self.proposalFailImg;
	end
	self:onShowEffect();
	
end
function ResultUI:setItemData(items)
	local count = table.getn(items)*0.5+0.5;
	self.itemArr = {};
	for i,v in ipairs(items) do
		local itemRender = ItemRender.new(self.skeleton,self);
		local render_d = itemRender:getUI();
		self.itemTmp:addChild(render_d);
		render_d:setPositionX((i-count)*120);
		--render_d:setAnchorPoint(ccp(0.5,0.5));
		render_d:setVisible(false);
		itemRender:setData(v);
		itemRender.itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);
		table.insert( self.itemArr, itemRender );
		local function delayCallFun()
			render_d:setVisible(true);
			render_d:setScale(0.1);
			itemRender:playEffectXX();
			Tweenlite:rotateScale(render_d,0.3,360,255,1,nil,true);
		end
		Tweenlite:delayCall(render_d,i*0.3,delayCallFun);
	end
end
function ResultUI:onItemTip(event)
	if event.target.userItem.ItemId<100 then
		local name = analysis("Daoju_Daojubiao",event.target.userItem.ItemId,"name");
		name = name.." X"..event.target.userItem.ttlC;
		TipsUtil:showTips(event.target,name,nil,nil,10);
	else
		self.parent:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self))
	end
end
function ResultUI:onShowEffect()
	self.yuanPan:setScale(2);
	self.yuanPan:setOpacity(0);
	local function onTlScl1Over()
		self.ttl1TF:setVisible(true);
		--self.ttl2TF:setVisible(true);
		self.ttl3TF:setVisible(true);
		if self.items then
			self:setItemData(self.items)
		end
		Tweenlite:delayCall(self.proposalImg,0.2,function ()
			self.close_btn:setVisible(true);
		end);
	end
    local function onTlSclOver()
    	Tweenlite:rotateForever(self.yuanPan,30,true);
    	self.proposalImg:setVisible(true);
    	self.proposalImg:setScale(2);
		self.proposalImg:setOpacity(0);
		Tweenlite:scale(self.proposalImg,0.2,1,1,255,onTlScl1Over,false,EaseType.CCEaseExponentialIn);
    end
    local function onTlToOver()
		Tweenlite:scale(self.yuanPan,0.2,2,2,255,onTlSclOver);
    end
    Tweenlite:to(self.bgImg,0.3,0,0,185,onTlToOver,true);
end
function ResultUI:onCloseUI()
	if GameVar.tutorStage == TutorConfig.STAGE_1012 then
      openTutorUI({x=1204, y=640, width = 80, height = 80, alpha = 84});
    end
	self.parent:onCloseResultUI();
end
function ResultUI:onClose()
	self.armature_d:setVisible(false);
end
function ResultUI:dispose()
	if self.itemArr then
		for i,v in ipairs(self.itemArr) do
			v:dispose();
		end
	end
	self.itemArr = nil;
	self.skeleton = nil;
	self.parent = nil;
	self.armature:dispose();
end
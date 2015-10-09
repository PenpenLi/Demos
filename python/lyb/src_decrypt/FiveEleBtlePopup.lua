require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

FiveEleBtlePopup=class(LayerPopableDirect);
function FiveEleBtlePopup:ctor()
  self.class=FiveEleBtlePopup;
end

function FiveEleBtlePopup:dispose()
	self.clipper:removeChildren();
	for i=2,6 do
		self["render_"..i]:dispose();
	end
	self.blRender_1:dispose();
	self.blRender_2:dispose();
	FiveEleBtlePopup.superclass.dispose(self);
end

function FiveEleBtlePopup:initialize()
  	self.skeleton=nil;
  	self.countProxy = nil;
end
function FiveEleBtlePopup:onDataInit()
	self.countProxy = self:retrieveProxy(CountControlProxy.name);
	self.skeleton = getSkeletonByName("fiveElements_ui");
	local layerPopableData = LayerPopableData.new();
	layerPopableData:setHasUIBackground(true);
	layerPopableData:setHasUIFrame(true);
	layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_STORYLINE,nil,true);
	layerPopableData:setArmatureInitParam(self.skeleton,"fiveElements_ui");
	layerPopableData:setShowCurrency(true);
	self:setLayerPopableData(layerPopableData);
end


function FiveEleBtlePopup:initialize()
  -- self:initLayer();

  
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end

function FiveEleBtlePopup:onPrePop()
 	self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT)); 
	self.armature_d = self.armature.display;

	self.nameTF = BitmapTextField.new("五行幻境","anniutuzi");
	local ttlTFC = self.armature_d:getChildByName("ttlTF");
	ttlTFC:addChild(self.nameTF);
	generateText(self.armature_d,self.armature,"countTF","剩余次数：",true);
	self.countTmp = self.armature.display:getChildByName("countTmp");
	self.countTF = CartoonNum.new();
	self.countTF:initLayer();
	self.countTF:setData(0,"common_number",30);
	self.countTmp:addChild(self.countTF);
	self.askBtn = Button.new(self.armature:findChildArmature("common_copy_ask_button"),false,"");
	self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
	self.rRsetBtn = Button.new(self.armature:findChildArmature("common_copy_small_blue_button"),false,"购买",true);
	self.rRsetBtn:addEventListener(Events.kStart,self.clickAddBtn,self);
	self.rRsetBtn:setVisible(false);
	self.renderTmp = self.armature_d:getChildByName("itemTmp");

 	local tempCCSprite = CCSprite:create();
    local tempSprite = Sprite.new(tempCCSprite);
	self.clipper = ClippingNode.new(tempSprite);
	self.clipper:setAlphaThreshold(0.0);
	self.clipper:setContentSize(makeSize(1010,500));
	self.renderTmp:addChild(self.clipper);

	self.blRender_2 = BlRender.new(self.skeleton,self);
	self.clipper:addChild(self.blRender_2:getDisplay());
	self.blRender_1 = BlRender.new(self.skeleton,self);
	self.clipper:addChild(self.blRender_1:getDisplay());
	local blr1_d = self.blRender_1:getDisplay();
	blr1_d:setVisible(false);
	local blr2_d = self.blRender_2:getDisplay();
	blr2_d:setVisible(false);
	sendMessage(7,61);
	hecDC(3,21,1);
	--for i=2,6 do
	--	local render = FrRender.new(self.skeleton,self);
	--	local render_d = render:getDisplay();
	--	self.clipper:addChild(render:getDisplay());
	--	render:setData(i,true);
	--	self.renderW = (render:renderWidth()+20)
	--	render_d:setPositionX(self.renderW*(i-2));
	--	render_d:addEventListener(DisplayEvents.kTouchTap,self.onClickRender,self,i);
	--	self["render_"..i] = render;
	--end
end
function FiveEleBtlePopup:refreshCountData()
	local count,ttlCount = self.countProxy:getRemainCountByID(CountControlConfig.FiveEleBattleCount);
	self.countTF:setData(count,"common_number",30);
	local userProxy=self:retrieveProxy(UserProxy.name);
	local vipLv = userProxy.vipLevel;
	local CaddC = analysis("Huiyuan_Huiyuantequan",12,"vip" .. vipLv);
	for i=vipLv+1,userProxy.vipLevelMax do
		local CaddN = analysis("Huiyuan_Huiyuantequan",12,"vip" .. i);
		if CaddN>CaddC then
			self.nextVipLv = i;
			break;
		end
	end
	self.rRsetBtn:setVisible(count == 0 and (self.countProxy:getRemainLimitedCountByID(CountControlConfig.FiveEleBattleCount)>0 or self.nextVipLv));

end
function FiveEleBtlePopup:onShowTip()
	local text=analysis("Tishi_Guizemiaoshu",12,"txt");
	TipsUtil:showTips(self.askBtn,text,500,nil,50);
end
function FiveEleBtlePopup:clickAddBtn()
	local canAddCount = self.countProxy:getRemainLimitedCountByID(CountControlConfig.FiveEleBattleCount);
	local commonPopup=CommonPopup.new();
	if canAddCount == 0 then
		commonPopup:initialize("达到VIP"..self.nextVipLv.."可以再购买次数",self,self.onShowVip,nil,nil,nil,false,{"充值","取消"},nil,true);
    	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(commonPopup);
		return;
	end
	local needGold = self.countProxy:getAddCountNeedGold(CountControlConfig.FiveEleBattleCount);
    commonPopup:initialize("确定想要花费"..needGold.."元宝购买次数吗?",self,self.onAddCount,nil,nil,nil,false,nil,nil,true);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(commonPopup);
end
function FiveEleBtlePopup:onShowVip()
	self:dispatchEvent(Event.new("ON_SHOW_VIP"));
end
function FiveEleBtlePopup:onAddCount()
	local needGold = self.countProxy:getAddCountNeedGold(CountControlConfig.FiveEleBattleCount);
	local currencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	if needGold<= currencyProxy:getGold() then
		sendMessage(3,9,{CountControlType=CountControlConfig.FiveEleBattleCount,CountControlParam=0});
	else
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
	end
end
function FiveEleBtlePopup:onMakeList(IdArr)
	self:refreshCountData();
	local openArr = {};
	for k,v in pairs(IdArr) do
		openArr[v.ID] = true;
	end
	for i=2,6 do
		if openArr[i] then
			sendMessage(6,13,{Type=i+6});
		end
		local render = FrRender.new(self.skeleton,self);
		local render_d = render:getDisplay();
		self.clipper:addChild(render_d);
		render:setData(i,openArr[i]);
		self.renderW = (render:renderWidth()+20)
		render_d:setPositionX(self.renderW*(i-2));
		if openArr[i] then
			render_d:addEventListener(DisplayEvents.kTouchTap,self.onClickRender,self,i);
		end
		self["render_"..i] = render;
	end
end
function FiveEleBtlePopup:onClickRender(event,idx)
	if self.isClickRender then return end;
	self.isClickRender = true; 
	local function callBack()
		for i=2,6 do
			local render = self["render_"..i];
			local render_d = render:getDisplay();
			local posIdx = i;
			render_d:setPositionX(1);
			render_d:setPositionX(self.renderW*(i-2));
			if idx == 5 then
				if posIdx<=5 then
					Tweenlite:to(render_d,0.15,-self.renderW,0,0,nil,true);
				else
					Tweenlite:to(render_d,0.15,self.renderW,0,0,nil,true);
				end
			elseif idx == 6 then
				Tweenlite:to(render_d,0.3,-self.renderW*2,0,0,nil,true);
			elseif	posIdx>idx then
				Tweenlite:to(render_d,0.3,self.renderW*2,0,0,nil,true)
			end
		end
		local blr1_d = self.blRender_1:getDisplay();
		blr1_d:setVisible(true);
		local blr2_d = self.blRender_2:getDisplay();
		blr2_d:setVisible(true);
		blr1_d:setPositionX(1);
		blr1_d:setPositionX(self.renderW*(idx-2));
		blr2_d:setPositionX(1);
		blr2_d:setPositionX(self.renderW*(idx-2));
		
		if idx == 5 then
			Tweenlite:to(blr2_d,0.15,self.renderW,0,0,nil,true)
		elseif idx == 6 then
			Tweenlite:to(blr1_d,0.15,-self.renderW,0,0,nil,true)
		else
			Tweenlite:to(blr1_d,0.15,self.renderW,0,0,nil,true)
			Tweenlite:to(blr2_d,0.3,self.renderW*2,0,0,nil,true)
		end
		Tweenlite:delayCall(self.armature_d, 0.3, function ()
			self.isClickRender = nil; 
		end);
	end
	if self.selectIdx then
		for i=2,6 do
			local render = self["render_"..i];
			local render_d = render:getDisplay();
			if self.selectIdx == 5 then
				if i<=5 then
					Tweenlite:to(render_d,0.05,self.renderW,0,0,nil,true);
				else
					Tweenlite:to(render_d,0.05,-self.renderW,0,0,nil,true);
				end
			elseif self.selectIdx == 6 then
				Tweenlite:to(render_d,0.1,self.renderW*2,0,0,nil,true);
			elseif	i>self.selectIdx then
				Tweenlite:to(render_d,0.1,-self.renderW*2,0,0,nil,true)
			end
		end
		local blr1_d = self.blRender_1:getDisplay();
		blr1_d:setVisible(false);
		local blr2_d = self.blRender_2:getDisplay();
		blr2_d:setVisible(false);
		if self.selectIdx ~= idx then
			Tweenlite:delayCall(self.armature_d, 0.1, callBack);
		else
			Tweenlite:delayCall(self.armature_d, 0.1, function ()
				self.isClickRender = nil; 
			end);
			
			self.selectIdx = nil;
			return;
		end
	else
		callBack();
	end
	local data1 =analysisByUnionKey("Wuxingzhandou_Wuxingguanka",{"type","degree"},idx.."_1");
	local data2 =analysisByUnionKey("Wuxingzhandou_Wuxingguanka",{"type","degree"},idx.."_2");
	self.selectIdx = idx;
	self.blRender_1:setData(data1);
	self.blRender_2:setData(data2);


end
function FiveEleBtlePopup:onUIInit()
  --CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
end

function FiveEleBtlePopup:onRequestedData()

end

function FiveEleBtlePopup:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end

FrRender=class(EventDispatcher);
function FrRender:ctor(skeleton,parent)
	self.parent = parent;
	self.skeleton = skeleton;
	self:buildRender();
	self:initUI();
end
function FrRender:buildRender()
  self.armature=self.skeleton:buildArmature("renderFr_ui");
  self.armature.animation:gotoAndPlay("f1");
  self.armature:updateBonesZ();
  self.armature:update();
  self.armature_d=self.armature.display;
end
function FrRender:getDisplay()
	return self.armature_d;
end
function FrRender:renderWidth()
	return self.bg:getContentSize().width;
end
function FrRender:initUI()
	self.bg = self.armature_d:getChildByName("common_copy_item_bg_5");
	local yuan = self.armature_d:getChildByName("common_copy_huaWenImg");
	yuan:setScale(0.8);
	self.enableImg = self.armature_d:getChildByName("enableImg");
	self.stageTF = generateText(self.armature_d,self.armature,"stateTF","进\n行\n中\n…");
	self.stageTF:setVisible(false);
	generateText(self.armature_d,self.armature,"battleTF","关卡属性");
	generateText(self.armature_d,self.armature,"restrainTF","克制属性");

	self.sx_2 = self.armature_d:getChildByName("sx_2");
	self.sx_2:setVisible(false);
	self.sx_3 = self.armature_d:getChildByName("sx_3");
	self.sx_3:setVisible(false);
	self.sx_4 = self.armature_d:getChildByName("sx_4");
	self.sx_4:setVisible(false);
	self.sx_5 = self.armature_d:getChildByName("sx_5");
	self.sx_5:setVisible(false);
	self.sx_6 = self.armature_d:getChildByName("sx_6");
	self.sx_6:setVisible(false);

	self.sx_1_2 = self.armature_d:getChildByName("common_copy_shuxing_2");
	self.sx_1_2:setVisible(false);
	self.sx_1_3 = self.armature_d:getChildByName("common_copy_shuxing_3");
	self.sx_1_3:setVisible(false);
	self.sx_1_4 = self.armature_d:getChildByName("common_copy_shuxing_4");
	self.sx_1_4:setVisible(false);
	self.sx_1_5 = self.armature_d:getChildByName("common_copy_shuxing_5");
	self.sx_1_5:setVisible(false);
	self.sx_1_6 = self.armature_d:getChildByName("common_copy_shuxing_6");
	self.sx_1_6:setVisible(false);

	self.sx_2_2 = self.armature_d:getChildByName("common_copy_shuxing_2_1");
	self.sx_2_2:setVisible(false);
	self.sx_2_2:setScale(0.4);
	self.sx_2_2:setPositionY(110);
	self.sx_2_3 = self.armature_d:getChildByName("common_copy_shuxing_3_1");
	self.sx_2_3:setVisible(false);
	self.sx_2_3:setScale(0.4);
	self.sx_2_3:setPositionY(110);
	self.sx_2_4 = self.armature_d:getChildByName("common_copy_shuxing_4_1");
	self.sx_2_4:setVisible(false);
	self.sx_2_4:setScale(0.4);
	self.sx_2_4:setPositionY(110);
	self.sx_2_5 = self.armature_d:getChildByName("common_copy_shuxing_5_1");
	self.sx_2_5:setVisible(false);
	self.sx_2_5:setScale(0.4);
	self.sx_2_5:setPositionY(110);
	self.sx_2_6 = self.armature_d:getChildByName("common_copy_shuxing_6_1");
	self.sx_2_6:setVisible(false);
	self.sx_2_6:setScale(0.4);
	self.sx_2_6:setPositionY(110);

	self.sx_3_2 = self.armature_d:getChildByName("common_copy_shuxing_2_2");
	self.sx_3_2:setVisible(false);
	self.sx_3_2:setScale(0.4);
	self.sx_3_3 = self.armature_d:getChildByName("common_copy_shuxing_3_2");
	self.sx_3_3:setVisible(false);
	self.sx_3_3:setScale(0.4);
	self.sx_3_4 = self.armature_d:getChildByName("common_copy_shuxing_4_2");
	self.sx_3_4:setVisible(false);
	self.sx_3_4:setScale(0.4);
	self.sx_3_5 = self.armature_d:getChildByName("common_copy_shuxing_5_2");
	self.sx_3_5:setVisible(false);
	self.sx_3_5:setScale(0.4);
	self.sx_3_6 = self.armature_d:getChildByName("common_copy_shuxing_6_2");
	self.sx_3_6:setVisible(false);
	self.sx_3_6:setScale(0.4);
end
function FrRender:setData(stage,enable)
	self["sx_"..stage]:setVisible(true);
	self["sx_1_"..stage]:setVisible(true);
	local arr = {1,5,2,6,4,3};
	self["sx_2_"..arr[stage]]:setVisible(true);
	self["sx_3_"..stage]:setVisible(true);
	self.stageTF:setVisible(enable);
	self.enableImg:setVisible(not enable);
end
function FrRender:dispose()
	self.parent = nil;
	self.armature:dispose();
end

BlRender=class(EventDispatcher);
function BlRender:ctor(skeleton,parent)
	self.parent = parent;
	self.skeleton = skeleton;
	self:buildRender();
	self:initUI();
end
function BlRender:buildRender()
  self.armature=self.skeleton:buildArmature("renderBl_ui");
  self.armature.animation:gotoAndPlay("f1");
  self.armature:updateBonesZ();
  self.armature:update();
  self.armature_d=self.armature.display;
end
function BlRender:getDisplay()
	return self.armature_d;
end
function BlRender:renderWidth()
	return self.bg:getContentSize().width;
end
function BlRender:initUI()
	local tiliBg = self.armature_d:getChildByName("common_copy_tili_bg");
	tiliBg:setVisible(false);
	self.bg = self.armature_d:getChildByName("bg");
	self.easy = self.armature_d:getChildByName("easy");
	self.hard = self.armature_d:getChildByName("hard");
	self.nameTF = BitmapTextField.new("落\n掉\n卡\n关","anniutuzi");
	local ttlTFC = self.armature_d:getChildByName("ttlTF");
	ttlTFC:addChild(self.nameTF);
	self.itemTmp = self.armature_d:getChildByName("itemTmp");
	-- self.tiTF = generateText(self.armature_d,self.armature,"tiTF","0",true);
	self.battleBtn = Button.new(self.armature:findChildArmature("common_copy_small_blue_button"),false,"战斗",true);
	self.battleBtn:addEventListener(Events.kStart,self.clickBtn,self);
end
function BlRender:clickBtn()
	self.parent:dispatchEvent(Event.new(MainSceneNotifications.TO_HEROTEAMSUB,{context = self, onEnter = self.onEnterButtonTapByOther,FEType=self.data.type,funcType = "FiveEleBattle",ZhanChangWuXing = self.data.type},self));
end
function BlRender:onEnterButtonTapByOther()
	if GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
	   sendServerTutorMsg({})
	end
	sendMessage(7,62,{ID=self.data.id});
end
function BlRender:setData(data)
	self.itemTmp:removeChildren();
	self.data = data;
	self.easy:setVisible(data.degree==1);
	self.hard:setVisible(data.degree==2);
	-- self.tiTF:setString(data.cost);
	local itemArr = StringUtils:lua_string_split(data.award,",");
	local idx = 0;
	for k,v in pairs(itemArr) do
		local bagItem=BagItem.new();
	    bagItem:initialize({ItemId = tonumber(v), Count = 1});
	    bagItem:setPositionXY(5,106*idx);
	    bagItem.touchEnabled=true;
	    bagItem.touchChildren=true;
	    bagItem:setBackgroundVisible(true);
	    bagItem:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
	    self.itemTmp:addChild(bagItem);
	    idx=idx+1;
	end
	
end
function BlRender:onTap(event)
	self.parent:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self));
end
function BlRender:dispose()
	self.parent = nil;
	self.armature:dispose();
end
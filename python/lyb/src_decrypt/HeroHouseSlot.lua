require "core.controls.page.CommonSlot"

HeroHouseSlot=class(CommonSlot);

function HeroHouseSlot:ctor()
  self.class=HeroHouseSlot;
  self.beginX = 0;
  self.endX = 0;
  self.init = false;
end

function HeroHouseSlot:dispose()
	HeroHouseSlot.superclass.dispose(self);
	self.armature:dispose();
end

-- 创建实例
function HeroHouseSlot:create(context,onCardTap,isLook)	
	local item = HeroHouseSlot.new();
	item:initialize();
	item.context = context;
	item.onCardTap = onCardTap;
	item.isLook = isLook;

	return item;
end

function HeroHouseSlot:initialize()
	--GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
	self:initLayer();
	local skeleton = getSkeletonByName("hero_house_ui");
	self.skeleton = skeleton;

	local armature = skeleton:buildArmature("heroCardRender");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	self:addChild(self.armature.display);

	-- self.cardCon = self.armature.display:getChildByName("cardCon");
	-- self.carrerImg = self.armature.display:getChildByName("carrerImg");
	-- self.gridImg = self.armature.display:getChildByName("gridImg");
	-- self.nameBg = self.armature.display:getChildByName("nameBg");
	-- self.lvImg = self.armature.display:getChildByName("lvImg");
	-- self.armature.display.touchEnabled = true;
	-- self.armature.display.touchChildren = true;

	-- self.carrerImg_pos = convertBone2LB(self.armature.display:getChildByName("carrerImg"));
	-- self.armature.display:removeChild(self.armature.display:getChildByName("carrerImg"));

	self.progressBar_img = self.armature:findChildArmature("progress_bar");
  	self.progressBar = ProgressBar.new(self.progressBar_img, "common_blue_progress_bar_fg");
  	self.progressBar_img.display:setScaleX(0.3002);
  	self.progressBar_img.display:setScaleY(0.7);
  	self.progressBar:setProgress(0);

  	local text="魂石";
    self.name_descb=createTextFieldWithTextData(armature:getBone("name_descb").textData,text);
    self.armature.display:addChild(self.name_descb);

	text="";
	self.progress_descb=createTextFieldWithTextData(armature:getBone("progress_descb").textData,text);
	self.armature.display:addChild(self.progress_descb);

	text="";
	self.level_descb=createTextFieldWithTextData(armature:getBone("level_descb").textData,text);
	self.armature.display:addChild(self.level_descb);

	self.stars_empty = {};
	self.stars = {};
	for i=1,5 do
		local star_empty = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star_empty");
	    star_empty:setScale(0.33);
	    star_empty:setPositionXY(26 * ( -1 + i ) + 33, 38);
	    self.armature.display:addChild(star_empty);
	    self.stars_empty[i] = star_empty;

	    local star_img = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
	    star_img:setScale(0.33);
	    star_img:setPositionXY(26 * ( -1 + i ) + 34, 38);
	    self.armature.display:addChild(star_img);
	    self.stars[i] = star_img;
	end

	self.armature.display:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self);
	self.armature.display:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self);
end

function HeroHouseSlot:onTapBegin(event)
  	self.beginX = event.globalPosition.x;
end
function HeroHouseSlot:onTapEnd(event)
	self.endX = event.globalPosition.x;
	if math.abs(self.beginX - self.endX) < 10 then
		if 0~=self.items.GeneralId then
			TimeCUtil:star()
  			self.onCardTap(self.context,self.items,self);
  		else
  			self:onJihuo();
  		end
	end;

end

function HeroHouseSlot:onJihuo()
	local function onConfirm()
		initializeSmallLoading();
		self.context.JihuoCache = self.items.ConfigId;
		self.context.pageView:setMoveEnabled(false);
		sendMessage(6,18,{ConfigId = self.items.ConfigId});
		for k,v in pairs(self.context.pageViewData) do
			if self.items.ConfigId == v.ConfigId then
				self.context.JihuoCachePosID = k;
				break;
			end
		end
		self.context.JihuoCachePosID = self.context.JihuoCachePosID;
		self.context.JihuoCacheID = self.items.ConfigId;
	    if GameVar.tutorStage == TutorConfig.STAGE_1006 then
     		openTutorUI({x=434 , y=31, width = 434, height = 666, alpha = 125, delay = 1});
	    	sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100607, BooleanValue = 0})
	      -- openTutorUI(GameVar.lastTutorData);
		end

	end
	local function onTrack()
		self.context:dispatchEvent(Event.new(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND,{itemId=self.items.ItemId, count = self.items.Count, totalCount = self.items.MaxCount},self));
		-- self.context.pageView:setMoveEnabled(true);
	end
	local function onCancle()
		self.context.pageView:setMoveEnabled(true);
	end
	if self.items.Count >= self.items.MaxCount then
		-- local popup = CommonPopup.new();
  -- 		popup:initialize("确定使用" .. self.items.MaxCount .. "个" .. analysis("Daoju_Daojubiao",self.items.ItemId,"name") .. "激活英雄吗?",nil,onConfirm);
		-- self.context.parent:addChild(popup);
		onConfirm();
	else
		onTrack();
		-- local popup = CommonPopup.new();
  -- 		popup:initialize("魂石不足呢,要去获取吗?",nil,onTrack,nil,onCancle,nil,nil,nil,nil,nil,CommonPopupCloseButtonPram.CANCLE);
		-- self.context.parent:addChild(popup);
		self.context.pageView:setMoveEnabled(false);
	end
end

-- 设置slot的数据(子类重写该方法)
function HeroHouseSlot:setSlotData(items)
	self.items = items;

	for k,v in pairs(self.stars) do
		self.stars_empty[k]:setVisible(false);
		self.stars[k]:setVisible(false);
	end
	if self.card_img then
		self.armature.display:removeChild(self.card_img);
		self.card_img = nil;
	end
	if self.wuxing_img then
		self.armature.display:removeChild(self.wuxing_img);
		self.wuxing_img = nil;
	end
	if self.name_img then
		self.armature.display:removeChild(self.name_img);
		self.name_img = nil;
	end
	if self.yanse_img then
		self.armature.display:removeChild(self.yanse_img);
		self.yanse_img = nil;
	end
	if self.yanse_line then
		self.armature.display:removeChild(self.yanse_line);
		self.yanse_line = nil;
	end

	local itemsData = analysis("Kapai_Kapaiku", items.ConfigId);

	local star = itemsData.star;
  	local hero_star = 0==self.items.GeneralId and 0 or self.items.StarLevel;
  	for k,v in pairs(self.stars) do
  		self.stars_empty[6-k]:setVisible(star >= k);
  		self.stars[6-k]:setVisible(hero_star >= k);
  	end

	self.card_img=Image.new();
	self.card_img:loadByArtID(itemsData.art2);
	self.card_img:setPositionXY(30,100);
	self.armature.display:addChildAt(self.card_img,0);

	self.wuxing_img = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..itemsData.job);
	self.wuxing_img:setScaleX(45/107);
	self.wuxing_img:setScaleY(45/107);
	self.wuxing_img:setPositionXY(13,512);
	self.armature.display:addChild(self.wuxing_img);

	local name = itemsData.name;
	local str = "";
    local _count = -1;
    while (-1-string.len(name)) < _count do
      str = str .. string.sub(name, -2 + _count, _count) .. "\n";
      _count = -3 + _count;
    end

    self.name_img=BitmapTextField.new(str,"yingxiongmingzi");
    local size = self.name_img:getContentSize();
    self.name_img:setPositionXY(25,505 - size.height);
    self.armature.display:addChild(self.name_img);


    if 0 == self.items.GeneralId then
    	self.armature.display:getChildByName("kejihuo_img"):setVisible(tonumber(self.items.Count) >= tonumber(self.items.MaxCount));
    	self.armature.display:getChildByName("hero_card_mask"):setVisible(true);
    	self.name_descb:setVisible(true);
    	self.progress_descb:setString(self.items.Count .. "/" .. self.items.MaxCount);
    	self.progress_descb:setVisible(true);
    	self.progressBar:setProgress(self.items.Count/self.items.MaxCount);
    	self.progressBar_img.display:setVisible(true);
    else
    	self.armature.display:getChildByName("kejihuo_img"):setVisible(false);
    	self.armature.display:getChildByName("hero_card_mask"):setVisible(false);
    	self.name_descb:setVisible(false);
    	self.progress_descb:setVisible(false);
    	self.progressBar_img.display:setVisible(false);
    end

    self.level_descb:setString("等级 " .. self.items.Level);

    local simple_grade = getSimpleGrade(self.items.Grade);
    self.yanse_line = self.skeleton:getBoneTextureDisplay("simple_grade_line_" .. simple_grade);
    self.yanse_line:setScaleX(0.95);
    self.yanse_line:setPositionXY(29,143);
    self.armature.display:addChild(self.yanse_line);

    self.yanse_img = self.skeleton:getBoneTextureDisplay("simple_grade_" .. simple_grade);
    self.armature.display:addChild(self.yanse_img);

    local textField=TextField.new(CCLabelTTF:create(getGradeName(self.items.Grade),FontConstConfig.OUR_FONT,26));
    textField:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(getSimpleGrade(self.items.Grade))));
    textField:setPositionXY(30,-2);
    self.yanse_img:addChild(textField);
    self.yanse_img:setPositionXY(-self.yanse_img:getGroupBounds().size.width+155,145);

	-- if self.color_img then
	-- 	self.color_img.parent:removeChild(self.color_img);
	-- 	self.color_img = nil;
	-- end

	-- self.armature.display:setVisible(true);
	-- if self.holder then
	-- 	self:removeChild(self.holder);
	-- 	self.holder = nil;
	-- end

	-- if self.items.Holder then
	-- 	self.armature.display:setVisible(false);
	-- 	self.holder = self.skeleton:getBoneTextureDisplay("holder_" .. self.items.Holder);
	-- 	self:addChild(self.holder);
	-- 	return;
	-- end

	-- local itemsData = analysis("Kapai_Kapaiku", items.ConfigId);--卡牌库
	-- local itemsDataMainGeneral;
	-- if 1 == self.items.IsMainGeneral then
	-- 	itemsDataMainGeneral = analysis("Zhujiao_Zhujiaozhiye", items.ConfigId);
	-- end
	-- if items.Grade == 0 then
	-- 	items.Grade = 1;
	-- end;
	-- print(items.Grade,"-->>>>");
	-- local tempGridImg = CommonSkeleton:getBoneTextureDisplay(getFrameNameByGrade(items.Grade));
	-- if self.init then
	-- 	if self.card then
	-- 		self.cardCon:removeChild(self.card);
	-- 		self.card = nil;
	-- 	end
	-- 	self.card = getImageByArtId(not itemsDataMainGeneral and itemsData.art2 or itemsDataMainGeneral.art2)
	-- 	self.card:setPositionY(-self.card:getContentSize().height);
	-- 	self.cardCon:addChild(self.card);
	-- 	self.card.touchEnabled = true;
	-- 	self.card.touchChildren = true;

	-- 	self.tarGridImg2 = CommonSkeleton:getBoneTexture9Display(getFrameNameByGrade(items.Grade),false,
	-- 		152/tempGridImg:getContentSize().width,480/tempGridImg:getContentSize().height);
	-- 	updateImg(self.armature,self.tarGridImg,self.tarGridImg2,0);
	-- 	self.tarGridImg = self.tarGridImg2;
		
	-- 	if self.tarCarrer then
	-- 		self.armature.display:removeChild(self.tarCarrer);
	-- 		self.tarCarrer = nil;
	-- 	end
	-- 	local tarCarrer = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..(not itemsDataMainGeneral and itemsData.wuXing or itemsDataMainGeneral.wuXing));
	-- 	tarCarrer:setScaleX(55/107);
	-- 	tarCarrer:setScaleY(54/107);
	-- 	tarCarrer:setPosition(self.carrerImg_pos);
	-- 	self.armature.display:addChild(tarCarrer);
	-- 	self.tarCarrer = tarCarrer;

	-- 	self.lvTF:setString(""..items.Level);
	-- 	self.nameTF:setString(""..(not itemsDataMainGeneral and itemsData.name or "主角"));--self.context.userProxy:getUserName()
	-- 	self.nameTF:setPositionY(self.nameTF.textData.height-self.nameTF:getContentSize().height+self.nameTF.textData.y);
	-- else
	-- 	self.card = getImageByArtId(not itemsDataMainGeneral and itemsData.art2 or itemsDataMainGeneral.art2)
	-- 	self.card:setPositionY(-self.card:getContentSize().height);
	-- 	self.cardCon:addChild(self.card);
	-- 	self.card.touchEnabled = true;
	-- 	self.card.touchChildren = true;

	-- 	self.tarGridImg = CommonSkeleton:getBoneTexture9Display(getFrameNameByGrade(items.Grade),false,
	-- 		152/tempGridImg:getContentSize().width,480/tempGridImg:getContentSize().height);
	-- 	updateImg(self.armature,self.gridImg,self.tarGridImg,480);

	-- 	local tarCarrer = CommonSkeleton:getBoneTextureDisplay("commonImages/common_shuxing_"..(not itemsDataMainGeneral and itemsData.wuXing or itemsDataMainGeneral.wuXing));
	-- 	tarCarrer:setScaleX(55/107);
	-- 	tarCarrer:setScaleY(54/107);
	-- 	tarCarrer:setPosition(self.carrerImg_pos);
	-- 	self.armature.display:addChild(tarCarrer);
	-- 	self.tarCarrer = tarCarrer;

	-- 	self.lvTF = generateText(self,self.armature,"lvTF",""..items.Level,true,ccc3(0,0,0),2);--server
	-- 	--self.nameTF = generateText(self.armature.display,self.armature,"nameTF",(not itemsDataMainGeneral and itemsData.name or self.context.userProxy:getUserName()));--server
	-- 	self.nameTF = createAutosizeMultiColoredLabelWithTextData(self.armature:getBone("nameTF").textData,(not itemsDataMainGeneral and itemsData.name or "主角"));--self.context.userProxy:getUserName()
	-- 	self.armature.display:addChild(self.nameTF);
	-- 	self.nameTF:setPositionY(self.nameTF.textData.height-self.nameTF:getContentSize().height+self.nameTF.textData.y);
	-- end;
	-- -- updateStar(self.armature,1 == self.items.IsMainGeneral and 0 or itemsData.star);
	-- local star = 1 == self.items.IsMainGeneral and 5 or analysis("Kapai_Kapaiku", self.items.ConfigId, "star");
 --  	local hero_star = self.items.StarLevel;
 --  	for k,v in pairs(self.stars) do
 --  		self.stars_empty[k]:setVisible(star >= k);
 --  		self.stars[k]:setVisible(hero_star >= k);
 --  	end

	-- self.armature.display:getChildByName("play_img"):setVisible(1 == self.items.IsPlay);
	-- self.armature.display:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self);
	-- self.armature.display:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self);
	-- self.init = true;

	-- self.color_img = self.skeleton:getBoneTextureDisplay("color_" .. self.items.Grade);
	-- if self.color_img then
	-- 	local color_size = self.color_img:getContentSize();
	-- 	self.color_img.touchEnabled = false;
	-- 	self.color_img:setScale(0.8);
	-- 	self.color_img:setPositionXY(60,40);
	-- 	self.armature.display:addChildAt(self.color_img,5);
	-- end

	-- self:refreshCardSelectImg();
	if self.isLook then
		self.armature.display:getChildByName("effect"):setVisible(false);
		self.touchEnabled = false;
		self.touchChildren = false;
	else
		self:refreshRedDot();
	end
end

function HeroHouseSlot:refreshRedDot()
	if not self.items then
		self.armature.display:getChildByName("effect"):setVisible(false);
		return;
	end
	local data = self.context.heroHouseProxy:getHongdianData(self.items.GeneralId);
	-- print("HeroHouseSlot:refreshRedDot->",data.BetterEquip,data.Levelable,data.Gradeable,data.StarLevelable,data.Skillable);
	-- data.BetterEquip
	
	-- log("?????????????????????---" .. self.items.ConfigId);

	-- 	if data.Levelable then log("???????????????????????Levelable"); end
	-- 	    if data.Gradeable then log("???????????????????????Gradeable"); end
	-- 	    if data.StarLevelable then log("???????????????????????StarLevelable"); end
	-- 	    if data.Skillable then log("???????????????????????Skillable"); end
	if data.BetterEquip
    or data.Gradeable
    or data.StarLevelable
    or data.Skillable
    or data.Levelable
    or data.BetterJinjieEquip
    or data.Yuanfenable then
    -- log("?????????????????????---endtrue");
      self.armature.display:getChildByName("effect"):setVisible(true);
      return;
    end
    -- log("?????????????????????---endfalse");
    self.armature.display:getChildByName("effect"):setVisible(false);
end

--卡牌选择界面使用
function HeroHouseSlot:refreshCardSelectImg()
	local hasChosen = false;
	if self.context.chooseItems then
		for k,v in pairs(self.context.chooseItems) do
			if self.items.GeneralId == v.GeneralId then
				hasChosen = true;
				break;
			end
		end
		if hasChosen then
			if not self.selectImg then
				self.selectImg = self.context.skeleton:getCommonBoneTextureDisplay("commonImages/common_xuanzhong_img");
				self.selectImg.touchEnabled = false;
				self.selectImg:setPositionXY(13,120);
				self:addChild(self.selectImg);
			end
		else
			if self.selectImg then
				self:removeChild(self.selectImg);
				self.selectImg = nil;
			end
		end
	end
end
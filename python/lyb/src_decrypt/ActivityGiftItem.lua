ActivityGiftItem = class(Layer)

function ActivityGiftItem:ctor()
	self.class = ActivityGiftItem;
	self.skeleton = nil;
	self.giftInfo = nil;
	self.ID = 0;
	self.removeable = true;
	self.gained = false;
	self.sort = nil;
	self.stateForSort = nil;--只有两个值1或2.排序用的。1是可领，2是不可领。
	self.CONST_ABLE = 1;
	self.CONST_UNABLE = 2;
end

function ActivityGiftItem:dispose()
	self:disposeTimer();
	self:removeAllEventListeners();
	self:removeChildren();
  	ActivityGiftItem.superclass.dispose(self);
  	self.armature:dispose()
end

function ActivityGiftItem:initializeUI(skeleton,context,giftInfo,ID)
	self.skeleton = skeleton;
	self.context = context;
	self.giftInfo = giftInfo;
	
	self.ID = ID;


	if 0~=self.giftInfo.ConfigId then
		local jiangliPo = analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId);
		self.removeable = 0== jiangliPo.need;
		if self.giftInfo.ConfigId then
			self.sort = jiangliPo.sort;
		else
			self.sort = 2;
		end
    else
    	self.sort = 100;
	end
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!self.sort", self.sort)
	
	self:initLayer();
	
	local armature=skeleton:buildArmature("baoxiangPanel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);
	
	local gridHolder = self.armature:getBone("gridHolder"):getDisplay();
	local gridPos = gridHolder:getPosition();
	gridPos.x = gridPos.x + gridHolder:getGroupBounds().size.width/2;
	gridPos.y = gridPos.y - gridHolder:getGroupBounds().size.height/2;
	self.gridPos = gridPos;
	
	local nameTextData = copyTable(self.armature:getBone("gridHolder").textData);
	self.armature.display:removeChild(gridHolder);	
	
	self.timeState3 = self.armature:getBone("timeState3"):getDisplay();
	self.timeState3:setVisible(false);	
	self.timeState4 = self.armature:getBone("timeState4"):getDisplay();
	self.timeState4:setVisible(false);
	
	
	
	if nil == giftInfo.ConfigId then
		giftInfo.ConfigId = 1;
	end

	if 0 == giftInfo.ConfigId then
		giftInfo.ConfigId = 2;
	end

	local grid = Image.new();
	grid:loadByArtID(analysis("Huodongbiao_Xitongjiangli",giftInfo.ConfigId,"art"));
	grid:setAnchorPoint(ccp(0.5,0.5));
	grid:setPosition(gridPos);
	self.armature.display:addChild(grid);
	self.grid = grid;

	local name = analysis("Huodongbiao_Xitongjiangli",giftInfo.ConfigId,"name");
	local textField = TextField.new(CCLabelTTF:create(name,FontConstConfig.OUR_FONT,22));
	textField.sprite:setColor(ccc3(255,108,0));
	textField:setPositionXY((grid:getContentSize().width-textField:getContentSize().width)/2, 0-textField:getContentSize().height);
	grid:addChild(textField);

	
	self.button = self.armature:getBone("button"):getDisplay();
	local ButtonData=self.armature:findChildArmature("button"):getBone("common_copy_blueround_button").textData; 
  local buttonPos=convertBone2LB4Button(self.button);
  self.armature.display:removeChild(self.button);
	self.button=CommonButton.new();
  self.button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.button:initializeText(ButtonData,"领取");
	self.button:setPosition(buttonPos);
  self.button:addEventListener(DisplayEvents.kTouchTap,self.onClickbutton,self);
  self.armature.display:addChild(self.button);
	

	-- if nil ~= ID then
		self:updateTimer();
	-- end
	
	local decriptionTextData = self.armature:getBone("background").textData;
	local text = analysis("Huodongbiao_Xitongjiangli",giftInfo.ConfigId,"type");
	-- text = StringUtils:lua_string_split(text,"#");
	textField = createTextFieldWithTextData(decriptionTextData,text);
	self.armature.display:addChildAt(textField,5);

end

function ActivityGiftItem:setPlace(place)
	self.place = place;
end

function ActivityGiftItem:updateTimer(remainSeconds)
	if nil ~= remainSeconds then
		self.giftInfo.remainSeconds = remainSeconds;
		if remainSeconds ~= 0 then
			self.stateForSort = self.CONST_UNABLE;
		else
			self.stateForSort = self.CONST_ABLE;
		end
	end
	if nil ~= self.giftInfo.remainSeconds then
		self:setRemainSecond();
		if self.giftInfo.remainSeconds ~= 0 then
			self.stateForSort = self.CONST_UNABLE;
		else
			self.stateForSort = self.CONST_ABLE;
		end
	end
	
	if nil == self.giftInfo.remainSeconds then
		self:setState();
	end
end

function ActivityGiftItem:setRemainSecond()
	local time = self.giftInfo.remainSeconds;
	local function cdTimeFun()
		if self.cdTimeListener.totalTime <= 0 then
			-- self.cdTimeListener:dispose();
			-- self.button:setVisible(true);
			-- self.button:refreshText("领取");
			-- self:removeChild(self.timerText);
			-- self.timerText = nil;
			sendMessage(23,1)
			self:disposeTimer();
		else
			self.timerText:setString(self.cdTimeListener:getTimeStr());
		end
	end
	if time == 0 then
		self.button:setVisible(true);
		self.button:refreshText("领取");
		self:removeChild(self.timerText);
		self.timerText = nil;
		self:disposeTimer();
	else 
		self.button:setVisible(false);
		if nil == self.timerText then
			self.timerText = TextField.new(CCLabelTTF:create("获取中...",FontConstConfig.OUR_FONT,"20"));
			self:addChild(self.timerText);
			self.timerText:setPositionXY(self.button:getPositionX()+(self.button:getGroupBounds().size.width-self.timerText:getGroupBounds().size.width)/2, self.button:getPositionY()+(self.button:getGroupBounds().size.height-self.timerText:getGroupBounds().size.height)/2);
		end
		if self.cdTimeListener == nil then
			self.cdTimeListener = RefreshTime.new();
			self.cdTimeListener:initTime(time, cdTimeFun, nil, 2);
		end
	end
end

function ActivityGiftItem:disposeTimer()  
	if nil ~= self.cdTimeListener then
		self.cdTimeListener:dispose();
		self.cdTimeListener = nil;
	end 
end

function ActivityGiftItem:setState(State)
	if State then 
		self.giftInfo.State = State 
	else

	end
	local state = self.giftInfo.State;
	if 1 == state then	--可领取
		self.button:setVisible(true);
		self.timeState3:setVisible(false);
		self.timeState4:setVisible(false);
		self.stateForSort = self.CONST_ABLE;
	elseif 2 == state then	--已领
		self.button:setVisible(false);
		if 0 ~= analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId,"art1") then
			self.armature.display:removeChild(self.grid);
			self.grid = nil;
			self.grid = Image.new();
			self.grid:loadByArtID(analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId,"art1"));
			self.armature.display:addChild(self.grid);
			self.grid:setAnchorPoint(ccp(0.5,0.5));
			self.grid:setPosition(self.gridPos);
			local name = analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId,"name");
			local textField = TextField.new(CCLabelTTF:create(name,FontConstConfig.OUR_FONT,22));
			textField.sprite:setColor(ccc3(255,108,0));
			textField:setPositionXY((self.grid:getContentSize().width-textField:getContentSize().width)/2, 0-textField:getContentSize().height);
			self.grid:addChild(textField);
		end

		local DO = self.skeleton:getCommonBoneTextureDisplay("common_has_receive");
		DO:setPosition(self.button:getPosition());
		self.armature.display:addChild(DO);
		self.timeState3:setVisible(false);
		self.timeState4:setVisible(false);
		self.stateForSort = self.CONST_UNABLE;
	elseif 3 == state then	--时间未到
		self.button:setVisible(false);
		self.timeState3:setVisible(true);
		self.timeState4:setVisible(false);
		self.stateForSort = self.CONST_UNABLE;
	elseif 4 == state then	--错过
		self.button:setVisible(false);
		self.timeState3:setVisible(false);
		self.timeState4:setVisible(true);
		self.stateForSort = self.CONST_UNABLE;
	else
		self.stateForSort = self.CONST_ABLE;
	end
end

function ActivityGiftItem:getState()
	return self.giftInfo.State
end

function ActivityGiftItem:onClickbutton(event)
	-- print("ActivityGiftItem:getReward:",self.ID);
	-- if self.context.bagProxy:getBagIsFull(self.context.itemUseQueueProxy) then
	-- 	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_177));
	-- 	return;
	-- else
		self.context:dispatchEvent(Event.new("getReward",{ID = self.ID, place = self.place, ConfigId = self.giftInfo.ConfigId},self));
	-- end
end

function ActivityGiftItem:gain()
	if not self.gained then
		if not self.removeable then
			if 0 ~= analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId,"art1") then
				self.armature.display:removeChild(self.grid);
				self.grid = nil;
				self.grid = Image.new();
				self.grid:loadByArtID(analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId,"art1"));
				self.armature.display:addChild(self.grid);
				self.grid:setAnchorPoint(ccp(0.5,0.5));
				self.grid:setPosition(self.gridPos);

				local name = analysis("Huodongbiao_Xitongjiangli",self.giftInfo.ConfigId,"name");
				local textField = TextField.new(CCLabelTTF:create(name,FontConstConfig.OUR_FONT,22));
				textField.sprite:setColor(ccc3(255,108,0));
				textField:setPositionXY((self.grid:getContentSize().width-textField:getContentSize().width)/2, 0-textField:getContentSize().height);
				self.grid:addChild(textField);
			end
			local DO = self.skeleton:getCommonBoneTextureDisplay("common_has_receive");
			local pos = self.button:getPosition();
			DO:setPositionXY(pos.x+7,pos.y-7);
			self.button:removeAllEventListeners();
			self.armature.display:removeChild(self.button);
			self.button = nil;
			self.armature.display:addChild(DO);
		else
			self.parent:removeChild(self);
		end
		self.gained = true;
	end
end

function ActivityGiftItem:getGiftConfigID()
	return self.giftInfo.ConfigId;
end

function ActivityGiftItem:getBagItem(id)
	local bagItem=BagItem.new();
    bagItem:initialize({UserItemId=0,ItemId=id,Count=1,IsBanding=0,IsUsing=0,Place=0});
    return bagItem;
end
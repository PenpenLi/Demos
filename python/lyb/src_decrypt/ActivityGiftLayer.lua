require "main.view.activity.ui.activityGift.ActivityGiftItem";

ActivityGiftLayer=class(TouchLayer);

function ActivityGiftLayer:ctor()
  self.class=ActivityGiftLayer;
	self.allRewardTable = {};
	self.count = 0;
	self.place = 1;
end

function ActivityGiftLayer:dispose()
	activitySelf = nil;
	self:removeAllEventListeners();
	self:removeChildren();
	ActivityGiftLayer.superclass.dispose(self);
	self.armature:dispose()
end

function ActivityGiftLayer:initialize(skeleton,parent_container,bagProxy,itemUseQueueProxy)
	self.skeleton=skeleton;
	self.bagProxy=bagProxy;
	self.itemUseQueueProxy=itemUseQueueProxy;
	self.parent_container=parent_container;
	self.const_scroll_item_num=4;
	self.scroll_items={};
	
	
	self:initLayer();
	local armature=skeleton:buildArmature("activity_gift_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	self:addChild(self.armature.display);
	-- self.armature.display:removeChild(self.armature:getBone("activity_ui_bg"):getDisplay());
	
	local placeHolder_1 = self.armature:getBone("placeHolder_1"):getDisplay();
	self.itemPos = placeHolder_1:getPosition();
	self.itemPos.y = self.itemPos.y - placeHolder_1:getGroupBounds().size.height;
	local placeHolder_2 = self.armature:getBone("placeHolder_2"):getDisplay();
	self.itemSkew = placeHolder_2:getPositionX() - self.itemPos.x;
	self.galleryViewSize = makeSize(3*self.itemSkew, placeHolder_1:getGroupBounds().size.height);
	self.armature.display:removeChild(placeHolder_1);
	self.armature.display:removeChild(placeHolder_2);
	
	
	self.scroll_item_size=makeSize(705,120);
	self.scroll_item_pos=self.armature.display:getChildByName("common_copy_button_bg"):getPosition();
	-- self:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
	
	--item
	self.scroll_item_layer=ListScrollViewLayer.new();
	self.scroll_item_layer:initLayer();
	self.scroll_item_layer:setPositionXY(self.scroll_item_pos.x,self.scroll_item_pos.y-self.const_scroll_item_num*self.scroll_item_size.height);
	self.scroll_item_layer:setViewSize(makeSize(self.scroll_item_size.width,
										self.const_scroll_item_num*self.scroll_item_size.height));
	self.scroll_item_layer:setItemSize(self.scroll_item_size);
	self.armature.display:addChild(self.scroll_item_layer);
	
	self.itemLayer = Layer.new();
	self.itemLayer:initLayer();
	self.armature.display:addChild(self.itemLayer);
	
	self.leftButton = self.armature:getBone("leftButton"):getDisplay();
	local leftPos=convertBone2LB4Button(self.leftButton);
	self.armature.display:removeChild(self.leftButton);
	self.leftButton=CommonButton.new();
	self.leftButton:initialize("common_left_button_normal","common_left_button_down",CommonButtonTouchable.BUTTON);
	self.leftButton:setPosition(leftPos);
	self.leftButton:addEventListener(DisplayEvents.kTouchTap,self.onClickLeftButton,self);
	self:addChild(self.leftButton);
	self.leftButton:setVisible(false);
	
	self.rightButton = self.armature:getBone("rightButton"):getDisplay();
	local rightPos=convertBone2LB4Button(self.rightButton);
	self.armature.display:removeChild(self.rightButton);
	self.rightButton=CommonButton.new();
	self.rightButton:initialize("common_right_button_normal","common_right_button_down",CommonButtonTouchable.BUTTON);
	self.rightButton:setPosition(rightPos);
	self.rightButton:addEventListener(DisplayEvents.kTouchTap,self.onClickRightButton,self);
	self:addChild(self.rightButton);

	self.allGainButton = self.armature:getBone("allGainButton"):getDisplay();
	local pos=convertBone2LB4Button(self.allGainButton);
	self.armature.display:removeChild(self.allGainButton);
	self.allGainButton=CommonButton.new();
	self.allGainButton:initialize("common_greenlongroundbutton_normal","common_greenlongroundbutton_down",CommonButtonTouchable.BUTTON);
	self.allGainButton:setPosition(pos);
	self.allGainButton:addEventListener(DisplayEvents.kTouchTap,self.onAllGainButtonTap,self);
	local ButtonData=self.armature:findChildArmature("allGainButton"):getBone("common_greenlongroundbutton").textData; 
	self.allGainButton:initializeText(ButtonData, "一键领取");
	self:addChild(self.allGainButton);
	
	self:addEventListener("getReward",self.getReward,self);

	-- self.parent_container:dispatchEvent(Event.new(ActivityNotifications.LEVEL_GIFT_REQUEST_DATA,nil,self.parent_container));
	initializeSmallLoading();
	sendMessage(23, 1);
	
	activitySelf = self;
	-- recvTable["GiftArray"] = {{ConfigId=15,State=4},{ConfigId=16,State=1}}
	-- recvMessage(1023,3);
end

function ActivityGiftLayer:onAllGainButtonTap(event)
  print("onAllGainButtonTap");
  if (connectBoo) then
  	initializeSmallLoading();
  	sendMessage(23 ,4);
  end
end

function ActivityGiftLayer:initScrollView()
	-- print("count:"..self.count)
	if nil == self.scrollView then
		self.scrollView=GalleryViewLayer.new();
		self.scrollView:initLayer();
		self.scrollView:setContainerSize(self.galleryViewSize);
		self.scrollView:setViewSize(self.galleryViewSize);
		self.scrollView:setDirection(kCCDirectionHorizontal);
		self.scrollView:setPosition(self.itemPos);
		self.scrollView:addFlipPageCompleteHandler(self.onFlipCompleteHandler);
		self.armature.display:addChild(self.scrollView);
	end
	self.scrollView:setMaxPage(math.ceil(self.count/3));
	if self.count < 4 then
		-- self.leftButton:setVisible(false);
		self.rightButton:setVisible(false);
	else
		-- self.leftButton:setVisible(true);
		self.rightButton:setVisible(true);
	end
	-- for i = 1,6 do 
		-- local layer = ActivityGiftItem.new();
		-- layer:initializeUI(self.skeleton);
		-- layer:setPositionXY(self.itemSkew*(i-1),self.galleryViewSize.height);
		-- self.scrollView:addContent(layer);
	-- end
end
function ActivityGiftLayer:getOnlieRewardItem()
	for k,v in pairs(self.allRewardTable)do
		if v.giftInfo.ConfigId == 1 then
			return v;
		end
	end
	return nil;
end
function ActivityGiftLayer:refreshRewardData(rewardTable, timerRewardTable, retainTable)
	uninitializeSmallLoading();
	--处理在线礼包
	--[[if nil ~= next(timerRewardTable) then
		if nil == self.allRewardTable[0] then
			if 0 == timerRewardTable.itemId then
				-- self.scrollView:removeChild(self.allRewardTable[0]);
			else
				local layer = ActivityGiftItem.new();
				layer:initializeUI(self.skeleton, self, timerRewardTable, 0);
				self.allRewardTable[0] = layer;
			end
		else
			if 0 == timerRewardTable.itemId then	--约定此值为0说明所有的倒计时礼包都领取过了
				self.scrollView:removeChild(self.allRewardTable[0]);
			else
				self.allRewardTable[0]:updateTimer(timerRewardTable.remainSeconds);
			end
		end
	end]]
    
    
	if nil ~= next(timerRewardTable) then
		local onlieReward = self:getOnlieRewardItem();
		if nil == onlieReward then
			if 0 ~= timerRewardTable.itemId then
				local layer = ActivityGiftItem.new();
				layer:initializeUI(self.skeleton, self, timerRewardTable, 0);
				table.insert(self.allRewardTable, layer);
			end
		else
			if 0 == timerRewardTable.itemId then	--约定此值为0说明所有的倒计时礼包都领取过了
				Utils:remove(self.allRewardTable, onlieReward);
				self.scrollView:removeChild(onlieReward);
			else
				onlieReward:updateTimer(timerRewardTable.remainSeconds);
			end
		end
	end
	--处理领取后消失的礼包
	for k,v in pairs(rewardTable)do
		if nil == self.allRewardTable[v.ID] then
			local layer = ActivityGiftItem.new();
			layer:initializeUI(self.skeleton, self, v, v.ID);
			self.allRewardTable[v.ID] = layer;
			-- print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", v.ID)
		end
	end
	--处理领取后保留在面板上的礼包
	for k,v in pairs(retainTable)do
		local has = false;
		local location = 0;
		for k_i,v_i in pairs(self.allRewardTable)do
			if v.ConfigId == v_i:getGiftConfigID() then
				has = true;
				location = k_i;
			end
		end
		local layer = ActivityGiftItem.new();
		if v.BooleanValue and not has then
			layer:initializeUI(self.skeleton, self, {ConfigId = v.ConfigId, remainSeconds = 0});
			table.insert(self.allRewardTable,layer);
			if not v.CanTake then
				layer:gain();
			end
		elseif v.BooleanValue and has then
			if not v.CanTake then
				self.allRewardTable[location]:gain();
			end
		end
		if v.State and not has then
			layer:initializeUI(self.skeleton, self, v, -1);
			table.insert(self.allRewardTable,layer);
		elseif has then
			if self.allRewardTable[location]:getState() then
				self.allRewardTable[location]:setState(v.State);
			end
		end
	end
	
	local sortTable = {};
	for k,v in pairs(self.allRewardTable)do
		-- print("#########################################self.allRewardTable", k)
		table.insert(sortTable, v);
	end
	local function sortFun(a, b)
		if a.stateForSort < b.stateForSort then
			return true;
		elseif a.stateForSort > b.stateForSort then
			return false;
		elseif a.stateForSort == b.stateForSort then
			if a.sort < b.sort then
				return true;
			elseif a.sort > b.sort then
				return false
			else
				return false;
			end
		else
			return false;
		end
	end   
	table.sort(sortTable, sortFun)

	self.count = #sortTable;
	for k,v in ipairs(sortTable)do
		-- print("*******************************************************sort,", k, v.giftInfo.ConfigId, v.stateForSort,v.sort)
		if nil == v.isAdd then	--记录这个宝箱是否被添加过
			self:initScrollView();
			self.scrollView:addContent(v);
			v.isAdd = true;
			v:setPlace(self.place);
			v:setPositionXY(self.itemSkew*(self.place-1), self.galleryViewSize.height);
			self.place = self.place + 1;
		end
	end
	
	self:initScrollView();
end

function ActivityGiftLayer:gainReward(ID)
	-- local removable = 1==analysis("Huodongbiao_Xitongjiangli",self.allRewardTable[ID].giftInfo.ConfigId,"need");
	uninitializeSmallLoading();
	if nil ~= ID then
		for k, v in pairs(self.allRewardTable) do
			if v.ID == ID then
				v:gain();
				break;
			end
		end
	elseif self.currentClickPlace then
		for k, v in pairs(self.allRewardTable) do
			if v.place == self.currentClickPlace then
				v:gain();
				break;
			end
		end
	end
end

function ActivityGiftLayer:getReward(event)
	-- print("ActivityGiftLayer:getReward:"..event.data);
	local bool = analysis("Huodongbiao_Xitongjiangli",event.data.ConfigId,"bag");
	if 1 == bool then
		if self.bagProxy:getBagIsFull(self.itemUseQueueProxy) then
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_177));
			self.parent_container:dispatchEvent(Event.new("toBag"));
		else
			self.currentClickPlace = event.data.place;
			self.parent_container:dispatchEvent(Event.new("getReward",event.data.ID,self));
			initializeSmallLoading()
		end
	else
		self.currentClickPlace = event.data.place;
		self.parent_container:dispatchEvent(Event.new("getReward",event.data.ID,self));
		initializeSmallLoading()
	end
end

function ActivityGiftLayer:onClickLeftButton(event)
	if self.scrollView then
		self.scrollView:setPage(self.scrollView:getCurrentPage()-1,true);
	end
end

function ActivityGiftLayer:onClickRightButton(event)
	if self.scrollView then
		self.scrollView:setPage(self.scrollView:getCurrentPage()+1,true);
	end
end
	
function ActivityGiftLayer:onFlipCompleteHandler()
	local page = activitySelf.scrollView:getCurrentPage();
	local maxPage = activitySelf.scrollView:getCurrentPage();
	-- print(page,maxPage)
	if 1 == page then
		activitySelf.leftButton:setVisible(false);
	else
		activitySelf.leftButton:setVisible(true);
	end
	if math.ceil(activitySelf.count/3) == page then
		activitySelf.rightButton:setVisible(false);
	else
		activitySelf.rightButton:setVisible(true);
	end
	
end
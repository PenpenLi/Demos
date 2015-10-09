require "core.controls.ScrollSelectButton";
BatchUseUI = class(LayerColor)

function BatchUseUI:ctor()
	self.class = BatchUseUI
	self.defaultInfo = nil;
end

function BatchUseUI:dispose()
	self:removeAllEventListeners();
	if self.armature then
		self.armature:dispose();
	end
	self:removeChildren();
	BatchUseUI.superclass.dispose(self);
end

--typeID : 1-使用 2-出售 3-购买 4-捐献银两 5-捐献道具 6-道具合成 7-购买次数
--buttonStrTbl : 1-rightButtonStr 2-leftButtonStr
--1==typeID
--itemInfo={ItemId=,MaxCount=}  左上->使用物品:物品名称  右上->空
--2==typeID
--itemInfo={ItemId=,MaxCount=}  左上->出售物品:物品名称  右上->出售价格:价格(实时计算)
--4==typeID
--itemInfo={ItemId=,MaxCount=}  左上->剩余银两:数量(实时计算)  右上->获得贡献值:数量(实时计算 有公式)
--5==typeID
--itemInfo={ItemId=,MaxCount=}  左上->捐献道具:道具名称  右上->空
--6==typeID
--itemInfo={ItemId=,MaxCount=}  左上->合成物品:物品名称  右上->空
--7==typeID
--itemInfo={ItemId=,MaxCount=}  左上->系统:xxxx  右上->购回价格:xxx
--9扫荡

function BatchUseUI:initialize(skeleton,context,itemInfo,buttonStrTbl,onConfirm,onCancel,typeID,userCurrencyProxy)
	self.defaultInfo = copyTable(itemInfo);

	self.itemInfo = itemInfo;
	self.context = context;
	self.onConfirm = onConfirm;
	self.onCancel = onCancel;
	self.typeID = typeID;
	self.userCurrencyProxy = userCurrencyProxy;
	if not buttonStrTbl then
		buttonStrTbl = {"确认","取消"};
	end
	
	self:initLayer();
	local armature= skeleton:buildArmature("main_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	local armature_d=armature.display;
	self:addChild(armature_d);


	local size=Director:sharedDirector():getWinSize();
	self:setContentSize(makeSize(size.width,size.height))
	-- local parentWidth = 800;
	-- local parentHeight = 480;
	-- local width = armature_d:getGroupBounds().size.width;
	-- local height = armature_d:getGroupBounds().size.height;
	-- armature_d:setPositionXY((parentWidth-width)/2,(parentHeight-height)/2);
	
	-- local halfAlpha = CommonSkeleton:getBoneTextureDisplay("common_blackHalfAlpha_bg");
	-- halfAlpha.touchEnabled = true;
	-- halfAlpha.touchChildren = true;
	self:setColor(ccc3(0,0,0));
	self:setOpacity(0);
	self.touchChildren = true;
	self.touchEnabled = true;
	
	local background = armature:getBone("scrollSelectPanelHolder"):getDisplay();
	-- local selectorBG = armature:getBone("selectorBG"):getDisplay();
	local viewSize = background:getGroupBounds().size;
	viewSize.width = viewSize.width - 30;
	viewSize.height = viewSize.height*2/5;
	local itemSize = makeSize(viewSize.width/5,viewSize.height);
	-- local itemSize = makeSize(viewSize.width/5,selectorBG:getGroupBounds().size.height);
	armature_d:removeChild(selectorBG);
	
	local itemTextData = copyTable(armature:getBone("itemTextData").textData);
	local itemDescTextData = copyTable(armature:getBone("itemDescTextData").textData);


	

	print("itemInfo.specialType", itemInfo,itemInfo.specialType)

	--todo ,itemInfo.specialType不知从哪里里的，暂时注销

	--if itemInfo.specialType then
	if true then
		self.itemName = analysis("Daoju_Daojubiao",itemInfo.ItemId,"name");
	else
		self.itemName = nil;
	end
	local itemText,itemDescText;

	if 3 == typeID or 2 == typeID or 1 == typeID then
		itemText = createTextFieldWithTextData(itemTextData,"物品名称:");
		itemDescText = createTextFieldWithTextData(itemDescTextData,self.itemName);	
	elseif 4 == typeID then
		itemText = createTextFieldWithTextData(itemTextData,"我的银两:");
		itemDescText = createTextFieldWithTextData(itemDescTextData,self.userCurrencyProxy:getSilver());	
	elseif 5 == typeID then
		itemDescTextData.x = itemDescTextData.x - 35;
		itemText = createTextFieldWithTextData(itemTextData,"道具:");
		itemDescText = createTextFieldWithTextData(itemDescTextData,self.itemName);	
	elseif 6 == typeID then
		itemText = createTextFieldWithTextData(itemTextData,"目标物品:");
		local tarItemId = analysis("Daoju_Daojubiao",itemInfo.ItemId,"parameter3");
		self.simpleCount = tonumber(StringUtils:lua_string_split(analysis("Daoju_Hecheng",tarItemId,"need"),",")[2]);
		self.itemName = analysis("Daoju_Daojubiao",tarItemId,"name");
		itemDescText = createTextFieldWithTextData(itemDescTextData,self.itemName);
	elseif 7==typeID then
		itemText = createTextFieldWithTextData(itemTextData,"目标系统:");
		itemDescText = createTextFieldWithTextData(itemDescTextData,self.itemInfo.name);	
	elseif 9==typeID then
		itemText = createTextFieldWithTextData(itemTextData, itemInfo.StrongPointName);
		itemDescText = createTextFieldWithTextData(itemDescTextData, "");	
	end
	armature_d:addChild(itemText);
	armature_d:addChild(itemDescText);
	self.itemDescText = itemDescText;

	self.img_red = armature_d:getChildByName("img_red");
	self.img_red:setOpacity(125);
	
	local selectTextData = armature:getBone("selectTextData").textData;
	local selectDescTextData = armature:getBone("selectDescTextData").textData;
	if 4 == typeID then
		local selectText = createTextFieldWithTextData(selectTextData,"银两捐献单位(万)");	
		armature_d:addChild(selectText);
	elseif 6 == typeID then
		local selectText = createTextFieldWithTextData(selectTextData,"合成数量:");	
		armature_d:addChild(selectText);
	elseif 7 == typeID then
		local selectText = createTextFieldWithTextData(selectTextData,"选择次数:");	
		armature_d:addChild(selectText);
	elseif 8 == typeID then

    elseif 9==typeID then
    
		local selectText = createTextFieldWithTextData(selectTextData,"选择次数:");	
		armature_d:addChild(selectText);
	else

    
		local selectText = createTextFieldWithTextData(selectTextData,"选择数量:");	
		armature_d:addChild(selectText);
	end
	
	local priceTextData = copyTable(armature:getBone("priceTextData").textData);
	local priceDescTextData = copyTable(armature:getBone("priceDescTextData").textData);
	local priceText
	if 3 == typeID then
		priceText = createTextFieldWithTextData(priceTextData,"物品价格:");
		priceDescTextData.x = priceDescTextData.x - 15;
	elseif 2 == typeID then
		--背包使用
		priceText = createTextFieldWithTextData(priceTextData,"出售价格:");
	elseif 1 == typeID then
		priceText = createTextFieldWithTextData(priceTextData," ");
		priceText:setVisible(false);
	elseif 4 == typeID then
		--家族捐献
		-- self.selectDescText = createTextFieldWithTextData(selectDescTextData,"1W");
		-- armature_d:addChild(self.selectDescText);
		priceTextData.x = priceTextData.x + 129;
		priceDescTextData.x = priceDescTextData.x +129+27;
		priceText = createTextFieldWithTextData(priceTextData,"我可得贡献值:");
	elseif 5 == typeID then
		--家族任务捐献
		--priceTextData.x = priceTextData.x + priceDescTextData.width/4;
		--priceDescTextData.x = priceDescTextData.x + priceDescTextData.width/3 +5;
		priceTextData.x = priceTextData.x;
		priceDescTextData.x = priceDescTextData.x+30;
		priceText = createTextFieldWithTextData(priceTextData,"捐献即得贡献:");
	elseif 6 == typeID then
		--背包合成
		priceTextData.y = priceTextData.y - 200;
		priceTextData.x = selectTextData.x;
		priceDescTextData.x = selectTextData.x + 100;
		priceDescTextData.y = priceDescTextData.y - 200;

		-- priceTextData.y = priceTextData.y;
		-- priceTextData.x = selectTextData.x;
		-- priceDescTextData.x = selectTextData.x + priceTextData.width/2；
		-- priceDescTextData.y = priceDescTextData.y - 175;

		priceText = createTextFieldWithTextData(priceTextData,"合成价格:");
	elseif 7 == typeID then
		priceText = createTextFieldWithTextData(priceTextData,"购回价格:");
		priceDescTextData.x = priceDescTextData.x - 15;
	elseif 9 == typeID then
		priceText = createTextFieldWithTextData(priceTextData,"");
		priceDescTextData.x = priceDescTextData.x - 15;
	end
	armature_d:addChild(priceText);
	
	
	self.priceDescText = createTextFieldWithTextData(priceDescTextData,"1");
	armature_d:addChild(self.priceDescText);

	if 9 == typeID then
		self.priceDescText:setVisible(false);
	end
	
	local count = math.min((itemInfo.MaxCount or 30),99);	--写死ing
	--local count = math.min(itemInfo.MaxCount,30);	--写死ing
	local userCount = 999;
	local totalLeftCount = 999999;

	if itemInfo.UserCount  and itemInfo.UserMaxCount then
		if itemInfo.UserCount > 0 and itemInfo.UserMaxCount > 0 then
			userCount = itemInfo.UserCount;
		end
	end
	if itemInfo.TotalCount and itemInfo.TotalLeftCount then
		if itemInfo.TotalCount > 0 and itemInfo.TotalLeftCount > 0 then
			totalLeftCount = itemInfo.TotalLeftCount;
		end
	end
	count = math.min(count, totalLeftCount, userCount);
	self.maxCount = count;
	if 3 == self.typeID or 6 == self.typeID or 7==self.typeID then
		if 3 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue.."元宝");
		elseif 2 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue.."银两");
		elseif 7 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue.."声望");
		elseif 10 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue.."家族贡献");
		elseif 11 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue.."积分");
		end
	elseif 2 == self.typeID then
		local singlePrice = analysis("Daoju_Daojubiao",self.itemInfo.ItemId,"price");
		self.priceDescText:setString(singlePrice.."银两");
	elseif 1 == self.typeID then
		self.priceDescText:setVisible(false);
	elseif 4 == self.typeID then
		self.priceDescText:setString("1");
	elseif 5 == self.typeID then
		self.simpleValue = analysis("Jiazu_Jiazurenwu",self.itemInfo.FamilyTaskID,"contribute");
		self.priceDescText:setString(self.simpleValue);
	end
	
	self.scrollSelect = ScrollSelectButton.new();
	self.scrollSelect:initialize(itemSize,viewSize,count);
	self.scrollSelect:setPositionXY(15,50);
	background:addChild(self.scrollSelect);
	for i = 1,count do
		local number1,number2
		local l1 = Layer.new();
		l1:initLayer();
		-- l1:setAnchorPoint(ccp(0.5,0.5));
		l1:setContentSize(makeSize(itemSize.width,itemSize.height));
		if i < 10 then
			number1 = CommonSkeleton:getBoneTextureDisplay("common_number_"..0);
			number2 = CommonSkeleton:getBoneTextureDisplay("common_number_"..i);
			l1:addChild(number2);
			l1:addChild(number1);
		else
			number1 = CommonSkeleton:getBoneTextureDisplay("common_number_"..math.floor(i/10));
			number2 = CommonSkeleton:getBoneTextureDisplay("common_number_"..i%10);
			l1:addChild(number2);
			l1:addChild(number1);
		end
		number1:setPositionX((itemSize.width-number1:getGroupBounds().size.width-number2:getGroupBounds().size.width/2)/2)
		number1:setPositionY(number1:getGroupBounds().size.height);
		number2:setPositionXY(number1:getPositionX()+number1:getGroupBounds().size.width,number1:getPositionY());
		self.scrollSelect:addItem(l1);
	end
	self.scrollSelect:addPadding();
	
	self.scrollSelect:setMovingHandler(self,self.setTextInfo);
	local leftButton = armature:getBone("leftButton");
	local leftPos = convertBone2LB4Button(leftButton:getDisplay());
	armature_d:removeChild(leftButton:getDisplay());
	if buttonStrTbl[2] then
		local leftTextData = armature:findChildArmature("leftButton"):getBone("common_blueround_button").textData;
		leftButton = CommonButton.new();
		leftButton:initialize("common_greenroundbutton_normal","common_greenroundbutton_down",CommonButtonTouchable.BUTTON);
		leftButton:initializeText(leftTextData,buttonStrTbl[2]);
		leftButton:setPosition(leftPos);
		-- if onCancel then
		leftButton:addEventListener(DisplayEvents.kTouchTap,self.onTapCancelButton,self);
		-- end
		armature_d:addChild(leftButton);
	end
	
	local rightButton = armature:getBone("rightButton");
	local rightTextData = armature:findChildArmature("rightButton"):getBone("common_blueround_button").textData;
	local rightPos = convertBone2LB4Button(rightButton:getDisplay());
	-- if not onCancel then
	-- 	rightPos.x = (rightPos.x+leftPos.x)/2;
	-- end
	armature_d:removeChild(rightButton:getDisplay());
	rightButton = CommonButton.new();
  	rightButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  	rightButton:initializeText(rightTextData,buttonStrTbl[1]);
  	rightButton:setPosition(rightPos);
	-- if onConfirm then
	rightButton:addEventListener(DisplayEvents.kTouchTap,self.onTapConfirmButton,self);
	-- end
	armature_d:addChild(rightButton);
	
	if 3 == typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		local str='<content><font color="#00FF00" ref="1">购买最大值</font></content>';
		local text = createAutosizeMultiColoredLabelWithTextData(maxIconTextData,str);
		text:setPositionXY(maxIconTextData.x, maxIconTextData.y);
		text:addEventListener(DisplayEvents.kTouchTap,self.onTapBuyMax,self);
		self:addChild(text);
	elseif 2 == typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		local str='<content><font color="#00FF00" ref="1">出售最大值</font></content>';
		local text = createAutosizeMultiColoredLabelWithTextData(maxIconTextData,str);
		text:setPositionXY(maxIconTextData.x, maxIconTextData.y);
		text:addEventListener(DisplayEvents.kTouchTap,self.onTapMax,self);
		self:addChild(text);
	elseif 1 == typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		local str='<content><font color="#00FF00" ref="1">使用最大值</font></content>';
		local text = createAutosizeMultiColoredLabelWithTextData(maxIconTextData,str);
		text:setPositionXY(maxIconTextData.x, maxIconTextData.y);
		text:addEventListener(DisplayEvents.kTouchTap,self.onTapMax,self);
		self:addChild(text);
		self:onTapMax();
	elseif 4 == typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		maxIconTextData.y = maxIconTextData.y - 2 - 75;
		maxIconTextData.x = priceTextData.x;
		self.noteText = createMultiColoredLabelWithTextData(maxIconTextData,"<content><font color='#E1D2A0'>家族可得资金: </font><font color='#00FF00'>50</font><content>");
		self:addChild(self.noteText);
		self:onTapMax();
	elseif 5 == typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		maxIconTextData.y = maxIconTextData.y - 2;
		maxIconTextData.x = maxIconTextData.x - priceTextData.width*0.15;
		local gainTable = analysis("Jiazu_Jiazurenwu",self.itemInfo.FamilyTaskID,"gift");
		--gainTable = StringUtils:lua_string_split(gainTable,",");
		gainTable={1,gainTable};
		self.gainTypeText = analysis("Daoju_Daojubiao",tonumber(gainTable[1]),"name");
		local count = analysis("Jiazu_Jiazurenwu",self.itemInfo.FamilyTaskID,"number");
		self.simpleGainValue = analysis("Jiazu_Jiazurenwu",self.itemInfo.FamilyTaskID,"exp");
		self.noteText = createMultiColoredLabelWithTextData(maxIconTextData,"<content><font color='#E1D2A0'>"..self.gainTypeText..":</font><font color='#00FF00'>"..self.simpleGainValue.."</font><content>");
		self:addChild(self.noteText);
		self:onTapMax();
	elseif 6 == typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		maxIconTextData.y = priceTextData.y;
		maxIconTextData.x = priceTextData.x + 350;
		self.noteText = createMultiColoredLabelWithTextData(maxIconTextData,"<content><font color='#E1D2A0'>合成需要: </font><font color='#FFFFFF'>"..self.itemName.."(</font><font color='#00FF00'>"..self.itemInfo.totalCount.."/"..self.simpleCount.."</font><font color='FFFFFF'>)个</font><content>");
		self:addChild(self.noteText);
		self:onTapMax();
	elseif 7==typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		local str='<content><font color="#00FF00" ref="1">最大次数</font></content>';
		local text = createAutosizeMultiColoredLabelWithTextData(maxIconTextData,str);
		text:setPositionXY(maxIconTextData.x, maxIconTextData.y);
		text:addEventListener(DisplayEvents.kTouchTap,self.onTapMax,self);
		self:addChild(text);
		self:onTapMax();
	elseif 9==typeID then
		local maxIconTextData = copyTable(armature:getBone("maxIconTextData").textData);
		local str='<content><font color="#00FF00" ref="1">扫荡最大值</font></content>';
		local text = createAutosizeMultiColoredLabelWithTextData(maxIconTextData,str);
		text:setPositionXY(maxIconTextData.x, maxIconTextData.y);
		text:addEventListener(DisplayEvents.kTouchTap,self.onTapMax,self);
		self:addChild(text);

	end

	-- if background.parent then
	-- 	background.parent:removeChild(background,false);
	-- 	background.parent:addChild(background);
	-- end

	--common_copy_close_button
	local closeButton=armature_d:getChildByName("common_copy_close_button");
	local closeButton_pos = convertBone2LB4Button(closeButton);
	armature_d:removeChild(closeButton);
	closeButton=CommonButton.new();
	closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	closeButton:setPosition(closeButton_pos);
	closeButton:addEventListener(DisplayEvents.kTouchTap,self.onTapCancelButton,self);
	self:addChild(closeButton);
	self.closeButton=closeButton;
end

function BatchUseUI:setTextInfo(target,count)


	--print("BatchUseUI:setTextInfo>>>:",target,count,self.typeID,self.itemInfo.CostType)

	-- print("setTextInfo",target,count)
	local count = count or self.scrollSelect:getSelect();
	if 3 == self.typeID then
		if 3 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."元宝");
		elseif 2 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."银两");
		elseif 7 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."声望");
		elseif 10 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."家族贡献");
		elseif 11 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."积分");
		end
	elseif 2 == self.typeID then
		local singlePrice = analysis("Daoju_Daojubiao",self.itemInfo.ItemId,"price");
		self.priceDescText:setString(singlePrice*count.."银两");
	elseif 1 == self.typeID then

	elseif 5 == self.typeID then
		self.priceDescText:setString(count*self.simpleValue);
		self.noteText:setString("<content><font color='#E1D2A0'>"..self.gainTypeText..":</font><font color='#00FF00'>"..self.simpleGainValue*count.."</font><content>");
	elseif 4 == self.typeID then
		-- self.selectDescText:setString(count.."W");
		--10000银两:1贡献
		self.priceDescText:setString(count);
		-- self.itemDescText:setString(self.userCurrencyProxy:getSilver()-count*10000);

		self.noteText:setString("<content><font color='#E1D2A0'>获得家族资金:</font><font color='#00FF00'>"..count.."</font><content>")
	elseif 6 == self.typeID then
		if 3 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."元宝");
		elseif 2 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."银两");
		elseif 7 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."声望");
		elseif 11 == self.itemInfo.CostType then
			self.priceDescText:setString(self.itemInfo.CostValue*count.."积分")
		end
		self.noteText:setString("<content><font color='#E1D2A0'>合成需要: </font><font color='#FFFFFF'>"..self.itemName.."(</font><font color='#00FF00'>"..self.itemInfo.totalCount.."/"..count*self.simpleCount.."</font><font color='#FFFFFF'>)个</font><content>");
	elseif 7==self.typeID then
		self.priceDescText:setString(self.itemInfo.CostValue*count.."元宝");
	elseif 8==self.typeID then
		self.priceDescText:setString("");
	end
	self.itemInfo.Count = count;
end

function BatchUseUI:onRemovePopup(event)
	self.parent:removeChild(self);
end

function BatchUseUI:onTapConfirmButton(event)
  if self.onConfirm then
		self:setTextInfo();
    self.onConfirm(self.context,self.itemInfo);
  end
	self:onRemovePopup();
end

function BatchUseUI:onTapCancelButton(event)
  if self.onCancel then
    self.onCancel(self.context);
  end
  self.itemInfo = copyTable(self.defaultInfo);
	self:onRemovePopup();
end

function BatchUseUI:onTapBuyMax(event)
	-- log("onTapBuyMax");
	local money
	if 3 == self.itemInfo.CostType then
		money = self.userCurrencyProxy:getGold();
	elseif 2 == self.itemInfo.CostType then
		money = self.userCurrencyProxy:getSilver();
	elseif 7 == self.itemInfo.CostType then
		money = self.userCurrencyProxy:getPrestige();
	elseif 10 == self.itemInfo.CostType then
		money = self.userCurrencyProxy:getFamilyContribute();
	elseif 11 == self.itemInfo.CostType then
		money = self.userCurrencyProxy:getGeneralEmployScore();
	end
	local count 
	if money then
		count = math.floor(money/self.itemInfo.CostValue);
		count = math.min(count, self.maxCount);
		log(money..","..count);
		if self.itemInfo.MaxCount then 
			if count > self.itemInfo.MaxCount then
				count = self.itemInfo.MaxCount;
			end
		end
	else
		count = self.itemInfo.MaxCount
	end
	if count > 30 then
		count = 30;
	elseif count > 0 then
	elseif count < 1 then
		count = 1;
	else
		if 3 == self.itemInfo.CostType then
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
			return;
		elseif 2 == self.itemInfo.CostType then
			sharedTextAnimateReward():animateStartByString("亲~银两不足了哦！");
			return;
		elseif 7 == self.itemInfo.CostType then
			sharedTextAnimateReward():animateStartByString("亲~声望不足了哦！");
			return;
		elseif 10 == self.itemInfo.CostType then
			sharedTextAnimateReward():animateStartByString("亲~家族贡献不足了哦！");
			return;
		elseif 11 == self.itemInfo.CostType then
			sharedTextAnimateReward():animateStartByString("亲~积分不足了哦！");
			return;
		end
	end
	self.itemInfo.Count = count;
	-- log(count);
	self.scrollSelect:scrollToItemByIndex(count-1,true);
	if count < 30 then 
		sharedTextAnimateReward():animateStartByString("只能买这么多了呢~");
	end
	-- self:setTextInfo(_,count);
end

function BatchUseUI:onTapMax(evt)
	self.itemInfo.Count = self.maxCount;
	-- log(count);
	self.scrollSelect:scrollToItemByIndex(self.maxCount-1,true);
end

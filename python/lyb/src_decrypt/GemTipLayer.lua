require "main.common.batchUse.BatchUseUI"

GemTipLayer=class(Layer);

function GemTipLayer:dispose()
  if nil ~= self.grid_over and self.grid_over.parent then
    self.grid_over.parent:removeChild(self.grid_over);
  end
	if self.armature then
		self.armature:dispose();
	end
  self:removeAllEventListeners();
  self:removeChildren();
	GemTipLayer.superclass.dispose(self);
end

function GemTipLayer:getItemData()
  return self.itemData;
end

--intialize UI
function GemTipLayer:initialize(skeleton, context, tapItem, leftButtonInfo, rightButtonInfo, item, activeInfo, effectProxy, userCurrencyProxy, hideAllButton)
  self:initLayer();
	self.context = context;
	self.effectProxy = effectProxy;
	self.userCurrencyProxy = userCurrencyProxy;
	self.hideAllButton = hideAllButton;
  
  local armature=skeleton:buildArmature("gemTips_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
	self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(self.armature_d);
  self.tapItem=tapItem;
  self.item=item;
  self.activeCounts = activeInfo and activeInfo.activeCounts or nil;
  self.actived = activeInfo and activeInfo.actived or nil;
	self.itemData = self.tapItem.userItem;
    
  --宝石名字
  local text_data=armature:getBone("gem_name").textData;
  local name=analysis("Daoju_Daojubiao",self.itemData.ItemId,"name");
  local quality=analysis("Daoju_Daojubiao",self.itemData.ItemId,"color");

  local text='<content><font color="' .. getColorByQuality(quality,true) .. '">' .. name .. '</font>';--<font color="#FFFFFF"> ' .. level .. '</font></content>';
  local gem_name=createMultiColoredLabelWithTextData(text_data,text);
  self:addChild(gem_name);

  --tapItem
  local pos=armature_d:getChildByName("common_copy_grid"):getPosition();
	pos.x = pos.x + 7;
	pos.y = 8 + pos.y - tapItem:getGroupBounds().size.height;
	armature_d:addChild(self.tapItem);
	self.tapItem:setPosition(pos);
  
  --类型标签
  text_data=armature:getBone("gem_type").textData;
  local gem_type=createTextFieldWithTextData(text_data,"类型");
  self:addChild(gem_type);

  --类型描述
  text_data=armature:getBone("gem_type_descb").textData;
	local tpye = analysis("Wujiang_Wujiangshuxing",analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "attribute"),"name");
  local gem_type_descb=createTextFieldWithTextData(text_data,tpye.."宝石");
  self:addChild(gem_type_descb);

	
	--叠加标签
	text_data=armature:getBone("gem_num").textData;
	local gem_num=createTextFieldWithTextData(text_data,"叠加");
	self:addChild(gem_num);
		
	--叠加描述
	text_data=armature:getBone("gem_num_descb").textData;
	text_data=copyTable(text_data);
	text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"overlap");
	local gem_num_descb = nil;
 	if nil ~= self.itemData.Count then 
		gem_num_descb = createTextFieldWithTextData(text_data, self.itemData.Count.."/"..text);
	else
		gem_num_descb = createTextFieldWithTextData(text_data, text);
	end
	self:addChild(gem_num_descb);
  
  --来源标签
  text_data=armature:getBone("gem_from").textData;
  local gem_from=createTextFieldWithTextData(text_data,"来源");
  self:addChild(gem_from);
  
  --来源描述
  text_data=armature:getBone("gem_from_descrb").textData;
  local occupation=analysis("Daoju_Daojubiao",self.itemData.ItemId,"origin");
  local gem_from_descrb=createTextFieldWithTextData(text_data,occupation);
  self:addChild(gem_from_descrb);
  
	--属性说明
  self:addPropScroll(skeleton,armature);
  
  --物品说明
  text_data=armature:getBone("gem_specification").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"function");
  local gem_specification=createTextFieldWithTextData(text_data,text);
  self:addChild(gem_specification);

	if not self.hideAllButton then  
		self.grid_over=skeleton:getCommonBoneTextureDisplay("common_grid_over");
	  local size=self.item:getChildAt(0):getContentSize();
	  local over_size=self.grid_over:getContentSize();
	  self.grid_over:setPositionXY((size.width-over_size.width)/2,(size.height-over_size.height)/2);
	  self.item:addChild(self.grid_over);

	  --左边按钮
	  local leftButton=armature_d:getChildByName("common_copy_blueround_button_1");
	  local left_pos=convertBone2LB4Button(leftButton);
	  armature_d:removeChild(leftButton);
		leftButton=CommonButton.new();
		leftButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
	  leftButton:initializeText(armature:findChildArmature("common_copy_blueround_button_1"):getBone("common_copy_blueround_button").textData,leftButtonInfo.text);
		if nil == leftButtonInfo.onTap then
			leftButtonInfo.onTap = self.onSellButtonTap;
			leftButton:addEventListener(DisplayEvents.kTouchTap,leftButtonInfo.onTap,self,self.tapItem);
		else
			leftButton:addEventListener(DisplayEvents.kTouchTap,leftButtonInfo.onTap,self.context,self.tapItem);
		end
		leftButton:setPosition(left_pos);
		self:addChild(leftButton);
	  
		--右边按钮
		local rightButton=armature_d:getChildByName("common_copy_blueround_button");
		local right_pos=convertBone2LB4Button(rightButton);
		armature_d:removeChild(rightButton);
		local nextLvGem = analysis("Zhuangbeibaoshi_Baoshi",self.itemData.ItemId,"stor");
		-- print(nextLvGem);
		if nil == rightButtonInfo or 0 == nextLvGem then
			leftButton:setPositionX(math.floor((right_pos.x+left_pos.x)/2));
		elseif nil ~= rightButtonInfo then
			rightButton=CommonButton.new();
			rightButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
			rightButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,rightButtonInfo.text);
			if nil == rightButtonInfo.onTap then 
				rightButtonInfo.onTap = self.onGemMerge;
				rightButton:addEventListener(DisplayEvents.kTouchTap,rightButtonInfo.onTap,self,self.tapItem);
			else
				rightButton:addEventListener(DisplayEvents.kTouchTap,rightButtonInfo.onTap,self.context,self.tapItem);
			end
			rightButton:setPosition(right_pos);
			self:addChild(rightButton);
			if not self.item:getSyntheticableByCount() then 
				rightButton:setGray(true);
			end
		end
	  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
	else
		local rightButton=armature_d:getChildByName("common_copy_blueround_button");
		armature_d:removeChild(rightButton);
		local leftButton=armature_d:getChildByName("common_copy_blueround_button_1");
		armature_d:removeChild(leftButton);
  end
end

--prop_scroll
function GemTipLayer:addPropScroll(skeleton, armature)
	local propType = analysis("Wujiang_Wujiangshuxing",analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "attribute"),"name");
	local propValue;
	if 12070 == math.floor(self.itemData.ItemId/100) then
		propValue = math.floor(analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "add"));
	elseif 12071 == math.floor(self.itemData.ItemId/100) then
		propValue = math.floor(analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "percentage") / 1000) .. "% ";
	end
  --附加
  local prop_add_green_data=armature:getBone("gem_prop_add_green").textData;
  local prop_add_yellow_data=armature:getBone("gem_prop_add_yellow").textData;
  
  local prop_scroll=ListScrollViewLayer.new();
	prop_scroll:initLayer();

	prop_scroll:setPositionXY(prop_add_green_data.x,prop_add_green_data.y);
	prop_scroll:setViewSize(makeSize(prop_add_green_data.width,prop_add_green_data.height));
  prop_scroll:setContentSize(makeSize(prop_add_green_data.width,prop_add_green_data.height));
	prop_scroll:setItemSize(makeSize(prop_add_yellow_data.width,prop_add_yellow_data.height));
  
  prop_add_yellow_data.x=0;
  prop_add_yellow_data.y=0;

  prop_add_yellow_data.color=14799520;

  local textField=createMultiColoredLabelWithTextData(prop_add_yellow_data,'<content><font color="#00FF00">镶嵌后: </font><font color="#E1D2A0">'..propType .. ' +' .. propValue..'</font></content>');
	textField.touchEnabled=false;
	prop_scroll:addItem(textField);

  if nil ~= self.activeCounts then
		local text = "<content><font color='#E1D2A0'>符文连接效果：</font>"
		local typeID = self.itemData.ItemId%1000
		if self.activeCounts > 0 and typeID < 100 then
			text = text..'<font color="#FF6C00">宝石属性提升'.. math.floor(analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "rune")/1000 * self.activeCounts) .. '% </font></content>';
		elseif self.activeCounts > 0 and typeID > 100 then
			text = text..'<font color="#FF6C00">'.. propType .. ' +' .. math.floor(analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "rune")/1000 * self.activeCounts) .. '% </font></content>';
		else
			text = text.."<font color='#5b5b5b'>未用符文连接</font></content>"
		end
		local textField=createMultiColoredLabelWithTextData(prop_add_yellow_data,text);
		textField.touchEnabled=false;
		prop_scroll:addItem(textField);
	end

	if nil ~= self.actived then
		local activeNum = 0;
		for i = 3,self.actived do
			activeNum = activeNum + analysis("Zhuangbeibaoshi_Fuzhen",i,"xiaoguo")/1000;
		end
		local text = "<content><font color='#E1D2A0'>符阵提升效果：</font>"
		if self.actived > 0 then
			text = text..'<font color="#FF6C00">宝石属性提升'.. activeNum .. '% </font></content>';
		else
			text = text.."<font color='#5b5b5b'>符阵未激活</font></content>"
		end

		local textField=createMultiColoredLabelWithTextData(prop_add_yellow_data,text);
		textField.touchEnabled=false;
		prop_scroll:addItem(textField);
	end
	
	self:addChild(prop_scroll);
end

function GemTipLayer:onSelfTap(event)
  self.parent.popup_boolean=true;
end

--出售
function GemTipLayer:onSellButtonTap(event)
  if 3<analysis("Daoju_Daojubiao",self.itemData.ItemId,"color") then
  	if self.item:getIsConfirm4Sell() then
      local a=CommonPopup.new();
      a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_196),self,self.toBatchUseUI,1,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_196));
      self.parent:addChild(a);
      return;
    end
    self:toBatchUseUI(1);
    return;
  end
  local a=CommonPopup.new();
  a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_16),self,self.toBatchUseUI,1,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_16));
  self.parent:addChild(a);
end

function GemTipLayer:sell()
  self.context:dispatchEvent(Event.new("bagItemSell",self.itemData,self.context));
  self:onCloseButtonTap(event);
end

--1 == typeID 出售
--2 == typeID 合成
function GemTipLayer:toBatchUseUI(typeID)
	if 1 == typeID then
		if self.itemData.Count == 1 then
			self:sell();
			return;
		end
		local batchUseUI = BatchUseUI.new();
		self.itemData.MaxCount = self.itemData.Count;
	  batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,self.itemData,{"出售","取消"},self.sell,nil,2);
	  self.parent.parent:addChild(batchUseUI);
	  self:onCloseButtonTap();
	elseif 2 == typeID then
		if self.item.bagProxy:getItemNum(self.itemData.ItemId) < self.countNeed*2 then
			self.itemData.Count = 1;
			self:merge();
			return;
		end
		self.itemData.totalCount = self.item.bagProxy:getItemNum(self.itemData.ItemId);
		local batchUseUI = BatchUseUI.new();
		-- self.itemData.MaxCount = self.itemData.Count;
	  batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,self.itemData,{"合成","取消"},self.merge,nil,6);
	  self.parent.parent:addChild(batchUseUI);
	  self:onCloseButtonTap();
	end
end

--合成
function GemTipLayer:onGemMerge(event)
	-- local sendTable = {UserItemId = self.itemData.UserItemId,Place = self.itemData.Place};
	-- local sendTable = {Place = self.itemData.Place,Count = 1};
	-- local countNeed = analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "number");
	local tarGemId = analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
	local needStr = analysis("Daoju_Hecheng",tarGemId,"need");
	local needTable = StringUtils:lua_string_split(needStr,",");
	self.countNeed = tonumber(needTable[2]);
	if not self.item:getSyntheticableByCount() then 
		sharedTextAnimateReward():animateStartByString("合成材料不足!需要"..self.countNeed.."个,已有"..self.item.bagProxy:getItemNum(self.itemData.ItemId).."个");
		return;
	end
	if self.item.bagProxy:getBagIsFull(self.parent.itemUseQueueProxy) then
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_15));
		return;
	end
	----------------------货币消耗判断--------------------------------
	local costStr = analysis("Daoju_Hecheng",tarGemId,"yinliang");
	local tbl = StringUtils:lua_string_split(costStr,",");
	local cost = tonumber(tbl[2]);
	local userCurrency = 0;
	if 2 == tonumber(tbl[1]) then 
		userCurrency = self.userCurrencyProxy:getSilver();
		if userCurrency < cost then
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
			return;
		end
	elseif 3 == tonumber(tbl[1]) then
		userCurrency = self.userCurrencyProxy:getGold();
		if userCurrency < cost then
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_18));
			return;
		end
	elseif 7 == tonumber(tbl[1]) then
		userCurrency = self.userCurrencyProxy:getPrestige();
		if userCurrency < cost then
			-- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_18));
			sharedTextAnimateReward():animateStartByString("亲~声望不足了哦！");
			return;
		end
	end

	------------------------------------------------------------------
	-- print(self.itemData.Place);
	-- function onConfirm()
	-- 	sendMessage(9,11,sendTable);
	-- 	self:onCloseButtonTap();
	-- end
	-- self.itemData.Count = self.item.bagProxy:getItemNum(self.itemData.ItemId);
	local maxCountByCount = math.floor(self.item.bagProxy:getItemNum(self.itemData.ItemId)/self.countNeed);
	local maxCountByCurrency = math.floor(userCurrency/cost);
	self.itemData.CostValue = cost;
	self.itemData.CostType = tonumber(tbl[1]);
	self.itemData.MaxCount = math.min(maxCountByCount,maxCountByCurrency);
	self:toBatchUseUI(2);
end

--移除
function GemTipLayer:onCloseButtonTap(event)
  self.context:removeItemTap();
end

function GemTipLayer:merge()
	local sendTable = {Place = self.itemData.Place,Count = self.itemData.Count};
	sendMessage(9,11,sendTable);
	initializeSmallLoading();
	self:onCloseButtonTap();
end
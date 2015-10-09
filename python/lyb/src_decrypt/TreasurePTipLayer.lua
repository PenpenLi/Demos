TreasurePTipLayer=class(Layer);

function TreasurePTipLayer:dispose()
  if nil ~= self.grid_over and self.grid_over.parent then
    self.grid_over.parent:removeChild(self.grid_over);
  end
	if self.armature then
		self.armature:dispose();
	end
  self:removeAllEventListeners();
  self:removeChildren();
	TreasurePTipLayer.superclass.dispose(self);
end

function TreasurePTipLayer:getItemData()
  return self.itemData;
end

--intialize UI
function TreasurePTipLayer:initialize(skeleton,tapItem,item,effectProxy,itemUseQueueProxy,userCurrencyProxy)
	self:initLayer();

	local armature=skeleton:buildArmature("detail_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature4dispose=armature;
	local armature_d=armature.display;
	self.effectProxy = effectProxy
	self.itemUseQueueProxy = itemUseQueueProxy;
	self.userCurrencyProxy = userCurrencyProxy;

	--出售
	local sellButton=armature_d:getChildByName("common_copy_blueround_button_1");
	local sell_pos=convertBone2LB4Button(sellButton);--equipButton:getPosition();
	armature_d:removeChild(sellButton);

	--使用
	local equipButton=armature_d:getChildByName("common_copy_blueround_button");
	local equip_pos=convertBone2LB4Button(equipButton);--equipButton:getPosition();
	armature_d:removeChild(equipButton);


	self:addChild(armature_d);
	self.tapItem=tapItem;
	self.item=item;
	self.itemData=tapItem:getItemData();
	self.isPetEgg=BagConstConfig.USE_ID_11==self.tapItem:getUseID();
	self.isSynthetic=self.tapItem:getSyntheticable();

	if self.isSynthetic then
	self.syntheticItemID=analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
	self.min=analysis("Daoju_Hecheng",self.syntheticItemID,"need");
	self.min=StringUtils:stuff_string_split(self.min);
	self.min=self.min[1];
	end

	--item
	local grid=armature_d:getChildByName("common_copy_grid");
	local pos=convertBone2LB(grid);--;grid:getPosition();
	pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
	pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
	self.tapItem:setPosition(pos);
	self:addChild(self.tapItem);


	--bag_item_name
	local text_data=armature:getBone("bag_item_name").textData;
	local text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"name");
	local color=analysis("Daoju_Daojubiao",self.itemData.ItemId,"color");
	local bag_item_name=createTextFieldWithQualityID(color,text_data,text);
	self:addChild(bag_item_name);

	--bag_item_category_name
	text_data=armature:getBone("bag_item_category_name").textData;
	local bag_item_category_name=createTextFieldWithTextData(text_data,"类型");
	self:addChild(bag_item_category_name);

	--bag_item_category_descb
	text_data=armature:getBone("bag_item_category_descb").textData;
	text=analysis("Daoju_Daojufenlei",self.tapItem:getCategoryID(),"function");
	local bag_item_category_descb=createTextFieldWithTextData(text_data,text);
	self:addChild(bag_item_category_descb);

	--bag_item_overlay
	text_data=armature:getBone("bag_item_overlay").textData;
	local bag_item_overlay=createTextFieldWithTextData(text_data,"叠加");
	self:addChild(bag_item_overlay);

	--bag_item_overlay_descrb
	text_data=armature:getBone("bag_item_overlay_descrb").textData;
	text=tapItem:getItemData().Count .. "/" .. analysis("Daoju_Daojubiao",self.itemData.ItemId,"overlap");
	if 0==text then
	text="不可叠加";
	end
	local bag_item_overlay_descrb=createTextFieldWithTextData(text_data,text);
	self:addChild(bag_item_overlay_descrb);

	--bag_item_output
	text_data=armature:getBone("bag_item_output").textData;
	local bag_item_output=createTextFieldWithTextData(text_data,"产出");
	self:addChild(bag_item_output);

	--bag_item_output_descb
	text_data=armature:getBone("bag_item_output_descb").textData;
	text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"origin");
	local bag_item_output_descb=createTextFieldWithTextData(text_data,text);
	self:addChild(bag_item_output_descb);

	--bag_item_specification
	text_data=armature:getBone("bag_item_specification").textData;
	text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"function");
	local bag_item_specification=createTextFieldWithTextData(text_data,"说明：" .. text);
	self:addChild(bag_item_specification);

	sellButton=CommonButton.new();
	sellButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
	sellButton:initializeText(armature:findChildArmature("common_copy_blueround_button_1"):getBone("common_copy_blueround_button").textData,"出售");
	sellButton:setPosition(sell_pos);
	sellButton:addEventListener(DisplayEvents.kTouchTap,self.onSellButtonTap,self);
	self:addChild(sellButton);

	equipButton=CommonButton.new();
	equipButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
	equipButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"合成");
	--if tapItem:isTreasure() then
	  equipButton:setPosition(equip_pos);
	--else
	  --equipButton:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),equip_pos.y);
	--end
	equipButton:addEventListener(DisplayEvents.kTouchTap,self.onGemMerge,self);
	self:addChild(equipButton);

	self.grid_over=skeleton:getCommonBoneTextureDisplay("common_grid_over");
	local size=item:getChildAt(0):getContentSize();
	local over_size=self.grid_over:getContentSize();
	self.grid_over:setPositionXY((size.width-over_size.width)/2,(size.height-over_size.height)/2);
	item:addChild(self.grid_over);
	self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

--prop_scroll
function TreasurePTipLayer:addPropScroll(skeleton, armature)
	local propType = analysis("Wujiang_Wujiangshuxing",analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "attribute"),"name");
	local propValue;
	if 12070 == math.floor(self.itemData.ItemId/100) then
		propValue = analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "add");
	elseif 12071 == math.floor(self.itemData.ItemId/100) then
		propValue = (analysis("Zhuangbeibaoshi_Baoshi", self.itemData.ItemId, "percentage") / 1000) .. "% ";
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
	self:addChild(prop_scroll);
end

function TreasurePTipLayer:onSelfTap(event)
  self.parent.popup_boolean=true;
end

--出售
function TreasurePTipLayer:onSellButtonTap(event)
      local a=CommonPopup.new();
      a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_196),self,self.sell,nil,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_196));
      sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(a);
end

function TreasurePTipLayer:sell()
  if 1==self.item:getItemData().Count then
    self:sellConfirm({Count=1});
    self:onCloseButtonTap();
  else
    local batchUseUI=BatchUseUI.new();
    batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=self.item:getItemData().Count},{"出售","取消"},self.sellConfirm,nil,2);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(batchUseUI);
  end
end

function TreasurePTipLayer:sellConfirm(data)
  self.parent:dispatchEvent(Event.new("bagItemSell",{UserItemId=self.itemData.UserItemId,Count=data.Count},self.parent));
  self:onCloseButtonTap(event);
end

--合成
function TreasurePTipLayer:onGemMerge(event)
	local sendTable = {Place = self.itemData.Place, Count = 1};
	local parameter3 = analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
	local need = analysis("Daoju_Hecheng",parameter3,"need")
	local min = StringUtils:lua_string_split(need, ",")
	if not self.item:getSyntheticableByCount() then 
		sharedTextAnimateReward():animateStartByString("合成材料不足!需要"..min[2].."个,已有"..self.item.bagProxy:getItemNum(self.itemData.ItemId).."个");
		return;
	end
	local costStr = "2,0"--analysis("Daoju_Hecheng",parameter3,"yinliang");
    local tbl = StringUtils:lua_string_split(costStr,",");
    local cost = tonumber(tbl[2]);
    local costType = tonumber(tbl[1]);
    local userCurrency = self.userCurrencyProxy:getSilver();
      local maxcountByCount = math.floor(self.item.bagProxy:getItemNum(self.itemData.ItemId)/tonumber(min[2]));
      local maxcountByCurrency = 0==cost and maxcountByCount or math.floor(userCurrency/cost);
      local maxcount = math.min(maxcountByCurrency,maxcountByCount);
      if maxcount < 2 then
        local a=CommonPopup.new();
        a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_112,{tonumber(min[2]),tonumber(min[1]),1,self.syntheticItemID}),self,self.onSynthetic,{Count = 1},nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_112),true);
        sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(a);
      else
        local batchUseUI=BatchUseUI.new();
        local totalCount = self.item.bagProxy:getItemNum(self.itemData.ItemId)
	    batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=maxcount, CostValue = cost, CostType = costType, totalCount = totalCount},{"合成","取消"},self.onSynthetic,nil,6);
	    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(batchUseUI);
      end
end

function TreasurePTipLayer:onSynthetic(data)
  if not self.item.bagProxy:hasEnoughPlace4Item(self.itemUseQueueProxy,self.syntheticItemID,1) then
    sharedTextAnimateReward():animateStartByString("包包空间不足哦~先去清理一下吧!");
    return;
  end
  local data={Place=self.itemData.Place, Count = data.Count};
  self.parent:dispatchEvent(Event.new("bagPropSynthetic",data,self.parent));
  self:onCloseButtonTap();
end

--移除
function TreasurePTipLayer:onCloseButtonTap(event)
  if self.parent then
    self.parent:removeItemTap();
  end
end

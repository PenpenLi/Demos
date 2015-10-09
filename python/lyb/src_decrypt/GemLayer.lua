require "main.view.bag.ui.bagPopup.EquipDetailLayer"
require "main.view.strengthen.ui.strengthenPopup.GemTipLayer"
require "main.view.strengthen.ui.strengthenPopup.GemBag"
require "main.view.strengthen.ui.strengthenPopup.GemItem"

GemLayer=class(Layer);

function GemLayer:ctor()
	self.class=GemLayer;
	

	self.skeleton = nil;
	self.context = nil;
	self.equipmentInfoProxy = nil;
	self.bagProxy = nil;
	self.generalListProxy = nil;
	self.userProxy = nil;
	
	self.itemListViewPos = {};
	self.items= {};
	self.item_select = nil;
	self.gemGrids = {};
	self.gemGridPanel = {};
	self.grayLineTable = {};
	self.lineEffectTable = {};
	self.gridEffectTable = {};
	
	self.runeGrids = {};
	self.runePosTable = {};
	self.runeEffectPosTable = {};
	-- self.item_select.runeLv = 3;
	
	self.itemDetailLayer = nil;
	self.gemDetailLayer = nil;
	self.upgradeTipLayer = nil;
	self.buttonAndTypeTextLayer = nil;
	self.gemIconLayer = nil;
	self.gemBag = nil;
	self.popup_boolean = true;
end

function GemLayer:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	GemLayer.superclass.dispose(self);
	BitmapCacher:deleteTextureLua("resource/image/arts/P1492.lua");
	BitmapCacher:deleteTextureLua("resource/image/arts/P1570.lua");
	BitmapCacher:deleteTextureLua("resource/image/arts/P1571.lua");
	BitmapCacher:deleteTextureLua("resource/image/arts/P1573.lua");
	BitmapCacher:deleteTextureLua("resource/image/arts/P1575.lua");
	BitmapCacher:deleteTextureLua("resource/image/arts/P1576.lua");
	BitmapCacher:deleteTextureLua("resource/image/arts/P1577.lua");
	if self.armature then
		self.armature:dispose();
	end
	if self.tipArmatrue then
		self.tipArmatrue:dispose();
	end
	if self.tmpArmature then
		self.tmpArmature:dispose()
	end
	gemLayerSelf = nil;
end


function GemLayer:initializeUI(skeleton, context, equipmentInfoProxy, bagProxy, generalListProxy, userProxy, userCurrencyProxy)
	
	self.skeleton = skeleton;
	self.context = context;
	self.equipmentInfoProxy = equipmentInfoProxy;
	self.bagProxy = bagProxy;
	self.generalListProxy = generalListProxy;
	self.userProxy = userProxy;
	self.userCurrencyProxy = userCurrencyProxy;
	
	self:initLayer();
	gemLayerSelf = self;
	local armature=skeleton:buildArmature("strengthen_gem");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
	self.armature = armature;
	self.armatureDisplay = armature.display;

	self.small_bg_strengthen=Image.new();
  	self.small_bg_strengthen:loadByArtID(StaticArtsConfig.STRENGTHEN_GEM);
  	self.small_bg_strengthen:setPosition(ccp(403,38));
  	self.armatureDisplay:addChildAt(self.small_bg_strengthen,3);
	
	self.buttonAndTypeTextLayer = Layer.new();
	self.buttonAndTypeTextLayer:initLayer();
	self.armatureDisplay:addChild(self.buttonAndTypeTextLayer);	
	
	self.gemIconLayer = Layer.new();
	self.gemIconLayer:initLayer();
	self.armatureDisplay:addChild(self.gemIconLayer);

	self.specialLock = armature:getBone("specialPosLock"):getDisplay();
	self.specialLock.touchEnabled = false;
	local itemDO1 = armature:getBone("item_1"):getDisplay();
	local itemDO2 = armature:getBone("item_2"):getDisplay();
	-- local gemPanel = armature:getBone("gemPanel"):getDisplay();

	
	self.itemListViewPos.x, self.itemListViewPos.y = self.context.strengthen_ui_scroll_item_pos.x,self.context.strengthen_ui_scroll_item_pos.y-self.context.const_scroll_num*self.context.item_skew_y;
	self.itemListViewItemWidth = itemDO1:getContentSize().width;
	self.itemListViewItemHeight = itemDO2:getPositionY() - itemDO1:getPositionY();
	self.itemListViewWidth = itemDO1:getContentSize().width;
	self.itemListViewHeight = self.context.const_scroll_num*self.context.item_skew_y;
	
	local runeTypeText = armature:getBone("runeTypeText"):getDisplay();
	local upgradeButtonDO = armature:getBone("upgradeButton"):getDisplay();
	
	self.upgradeButton = CommonButton.new();
  self.upgradeButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	local pos = convertBone2LB4Button(upgradeButtonDO)
	self.upgradeButton:setPosition(pos);
	self.upgradeButton:addEventListener(DisplayEvents.kTouchTap,self.onClickUpgrade,self);
	self.buttonAndTypeTextLayer:addChild(self.upgradeButton);
	local upgrade_button_img=self.armatureDisplay:getChildByName("upgrade_button_img");
	upgrade_button_img.touchEnabled=false;
	self.buttonAndTypeTextLayer:addChild(upgrade_button_img);
	
	-- local chosedItemDO = armature:getBone("chosedItem"):getDisplay();
	-- self.chosedItemTextData = armature:getBone("chosedItem").textData;
	-- self.chosedItemPos = chosedItemDO:getPosition();
	-- self.chosedItemPos.y = self.chosedItemPos.y - chosedItemDO:getContentSize().height;
	
	local tmpStr = "gemIcon_"
	for i = 1,7 do 
		local gemGridDO = armature:getBone(tmpStr..i):getDisplay();
		gemGridDO:addEventListener(DisplayEvents.kTouchTap,self.openGemBag,self);
		gemGridDO.place = i;
		-- gemGridDO.sprite:setAnchorPoint(ccp(0.5,0.5));
		-- gemGridDO.pos = gemGridDO:getPosition();
		-- gemGridDO.pos.x = gemGridDO.pos.x;
		-- gemGridDO.pos.y = gemGridDO.pos.y - gemGridDO:getContentSize().height;
		table.insert(self.gemGridPanel,gemGridDO);
		local textData = armature:getBone(tmpStr..i).textData;
		local text = "镶嵌"
		local textField = createTextFieldWithTextData(textData,text);
		textField.touchEnabled = false;
		gemGridDO.text = textField;
		self.armatureDisplay:addChild(textField);
		if i > 3 then 
			gemGridDO:setVisible(false);
			gemGridDO.text:setVisible(false);
		end
	end
	
	tmpStr = "line_"
	for i = 1,6 do 
		local lineDO = armature:getBone(tmpStr..i):getDisplay();
		lineDO.pos = i;
		table.insert(self.grayLineTable,lineDO);
		lineDO:setVisible(false);
		lineDO.touchEnabled = false;
	end	
	
	tmpStr = "rune_"
	for i = 1,3 do 
		local runeDO = armature:getBone(tmpStr..i):getDisplay();
		local pos = runeDO:getPosition();
		pos.y = pos.y - runeDO:getContentSize().height;
		table.insert(self.runePosTable,pos);
		self.armatureDisplay:removeChild(runeDO);
	end
	self.runePosTable[4] = self.runePosTable[1];
	self.runePosTable[5] = self.runePosTable[3];
	self.runePosTable[6] = self.runePosTable[2];
	
	local runeTypeDO = armature:getBone("runeTypeText"):getDisplay();
	self.runeTypePos = runeTypeDO:getPosition();
	self.runeTypePos.y = self.runeTypePos.y - 45;
	
	armature.display:removeChild(itemDO1);
	armature.display:removeChild(itemDO2);
	-- armature.display:removeChild(runeTypeText);
	armature.display:removeChild(upgradeButtonDO);
	armature.display:removeChild(chosedItemDO);
	armature.display:removeChild(runeTypeDO);
	-- armature.display:removeChild(gemPanel);
	--common_panel_bg
  armature.display:removeChild(armature.display:getChildByName("common_panel_bg"));
  armature.display:removeChild(armature.display:getChildByName("gemPanel"));
	
	self.context:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
	
	self:addChild(self.armatureDisplay);
	
	self:itemListViewInitialize();
	

	
end


function GemLayer:itemListViewInitialize()
	self.itemListView = ListScrollViewLayer.new();
  self.itemListView:initLayer();
  self.itemListView:setItemSize(makeSize(self.itemListViewItemWidth, self.itemListViewItemHeight));
  self.itemListView:setViewSize(makeSize(self.itemListViewWidth, self.itemListViewHeight));
	-- print("self.itemListViewWidth:"..self.itemListViewWidth)
	-- print("self.itemListViewHeight:"..self.itemListViewHeight)
  self.itemListView:setPositionXY(self.itemListViewPos.x, self.itemListViewPos.y);
	-- print("self.itemListViewPos.x:"..self.itemListViewPos.x)
	-- print("self.itemListViewPos.y:"..self.itemListViewPos.y)
	self:addChild(self.itemListView)
	
	local b=self.equipmentInfoProxy:getData();
	if nil == b then 
		self.upgradeButton:removeAllEventListeners();
		self.buttonAndTypeTextLayer:removeChild(self.upgradeButton);
		self.upgradeButton = nil;
		self:updatePanel();
		return 
	end;
	for k,v in pairs(b) do
    local equipmentItemID=self.bagProxy:getItemData(v.UserEquipmentId).ItemId;
    if nil==isForge or (isForge and analysisHas("Zhuangbei_Zhuangbeidazao",equipmentItemID)) then
      local strengthenItem=StrengthenItem.new();
      strengthenItem:initialize(self.skeleton,self,self.onItemTap,v,self.bagProxy:getItemData(v.UserEquipmentId),self.equipmentInfoProxy,self.bagProxy);
			strengthenItem.bagItem.touchChildren = true;
			strengthenItem.bagItem.touchEnabled = true;
			-- strengthenItem.bagItem:addEventListener(DisplayEvents.kTouchTap,self.onTapItemIcon,self);
			table.insert(self.items,strengthenItem);
    end
  end
	
	local function sfunc(a, b)
		if 1==a:getIsEquipped() and 0==b:getIsEquipped() then
			return true;
		elseif 0==a:getIsEquipped() and 1==b:getIsEquipped() then
			return false;
		else
			local aq=analysis("Zhuangbei_Zhuangbeibiao",a:getBagItemData().ItemId,"quality");
			local bq=analysis("Zhuangbei_Zhuangbeibiao",b:getBagItemData().ItemId,"quality");
			if aq<bq then
				return true;
			elseif aq>bq then
				return false;
			end
			local as=a:getStrengthLevel();
			local bs=b:getStrengthLevel();
			if as>bs then
				return true;
			elseif as<bs then
				return false;
			end
			local la=analysis("Daoju_Daojufenlei",a:getBagItem():getCategoryID(),"sequence");
    		local lb=analysis("Daoju_Daojufenlei",b:getBagItem():getCategoryID(),"sequence");
    		if la<lb then
      			return true;
    		elseif la>lb then
      			return false;
    		end
			return false;
		end
	end
	
	table.sort(self.items,sfunc);
	local layer = nil;
	local item = nil;
	for k,v in pairs(self.items) do 
		layer = TouchLayer.new();
		layer:initLayer();
		layer:changeWidthAndHeight(self.itemListViewItemWidth,self.itemListViewItemHeight);
		layer:addChild(v);
		self.itemListView:addItem(layer);
		if nil==item then
      item=v;
    end
	end
	if item then 
		self:onItemTap(item);
	end
end

--装备宝石
function GemLayer:onGemEquip(event,gemTarget)
	-- print("onGemEquip")
	-- print("UserEquipmentId:"..self.item_select.equipmentInfo.UserEquipmentId)
	-- print("gemTarget.place:"..gemTarget.place)
	-- print("UserItemId:"..gemTarget.userItem.UserItemId)
	if not self:gemUsableCheck(gemTarget.propId,gemTarget.place) then
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_86));
		return;
	end
	
	local sendTable = {UserEquipmentId=self.item_select.equipmentInfo.UserEquipmentId,
							Place = gemTarget.place,
							UserItemId = gemTarget.userItem.UserItemId};
	sendMessage(10,9,sendTable);
	self.gemGridPanel[gemTarget.place].touchEnabled = false;
	self.gemGridPanel[gemTarget.place].text:setVisible(false);
	self:onSelfTap();
	

	-- local function confirm()
		-- sendMessage(10,9,sendTable);
		-- self.gemGridPanel[gemTarget.place].touchEnabled = false;
		-- self.gemGridPanel[gemTarget.place].text:setVisible(false);
		-- self:onSelfTap();
	-- end
	-- local function cancel(page)
		-- self:onSelfTap();
		-- self:onClickUpgrade(_,page);
	-- end
	-- local propId = analysis("Zhuangbeibaoshi_Baoshi",gemTarget.userItem.ItemId,"attribute");
	-- local isMatch = false;
	-- local page = 1;
	-- if gemTarget.place < 4 then
		-- self.item_select.normalGemPropTable[propId]=propId;
		-- isMatch = self:runeCombinationUpgradeCheck(3);
		-- self.item_select.normalGemPropTable[propId]=nil;
	-- else
		-- self.item_select.advancedGemPropTable[propId]=propId;
		-- isMatch = self:runeCombinationUpgradeCheck(gemTarget.place-1);
		-- self.item_select.advancedGemPropTable[propId]=nil;
		-- page = gemTarget.plac - 1;
	-- end
	-- if not isMatch then
		-- local castTip = CommonPopup.new();
		-- castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_74),self,confirm,_,cancel,page,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_74));
		-- self:addChild(castTip);
		-- return;
	-- end
end

--宝石移除
function GemLayer:onGemRemove(event,gemTarget)
	local sendTable = {UserEquipmentId=self.item_select.equipmentInfo.UserEquipmentId,
							Place = gemTarget.place,
							UserItemId = 0}
	self:onSelfTap();
	-- sendMessage(10,9,sendTable);
	local function confirm()
		local cost = analysis("Zhuangbeibaoshi_Baoshi",self.gemGrids[gemTarget.place].userItem.ItemId,"money");
		--银两检查
		if self.userCurrencyProxy:getSilver() < cost then
			-- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_81));
			local function openMijiUI()
				self.context:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=FunctionConfig.FUNCTION_ID_103,TYPE_ID=MijiConfig.SILVER},self.context));
			end
			local castTip = CommonPopup.new();
			castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_81),self,openMijiUI,_,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_81),false);
			sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(castTip);
			return;
		end
		sendMessage(10,9,sendTable);
		initializeSmallLoading();
	end

	if self.item_select.runeLv < 4 then
		local cost = analysis("Zhuangbeibaoshi_Baoshi",self.gemGrids[gemTarget.place].userItem.ItemId,"money");
		local castTip = CommonPopup.new();
		local str = StringUtils:getString4Popup(PopupMessageConstConfig.ID_254,{cost});
		local buttonStr = StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_254);
		castTip:initialize(str,self,confirm,_,_,_,_,buttonStr,_);
		self:addChild(castTip);
	else
		local cost = analysis("Zhuangbeibaoshi_Baoshi",self.gemGrids[gemTarget.place].userItem.ItemId,"money");
		local castTip = CommonPopup.new();
		local str = StringUtils:getString4Popup(PopupMessageConstConfig.ID_255,{cost});
		local buttonStr = StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_255);
		castTip:initialize(str,self,confirm,_,_,_,_,buttonStr,_);
		self:addChild(castTip);
	end
	
end
local function playEffect()
	-- print("playEffect");
	-- print(nil==effect);
	gemLayerSelf:addChild(gemLayerSelf.effect);
	gemLayerSelf.runeIcon:setVisible(false);
end
local function removeEffect()
	-- print("removeEffect");
	-- print(nil==effect);
	gemLayerSelf:removeChild(gemLayerSelf.effect);
	gemLayerSelf.touchChildren = true;
end
local function sendmsg()
	sendMessage(10,10,gemLayerSelf.sendTable);
end
--使用符文监听
function GemLayer:onTapRuneIcon(event,desPos)
	local sendTable = {UserEquipmentId = self.item_select.equipmentInfo.UserEquipmentId, 
											ID = desPos};
	gemLayerSelf.runeIcon = event.target;
	local function confirm()
		gemLayerSelf.touchChildren = false;
		gemLayerSelf.grayLineTable[desPos]:setVisible(false);
		local pos = gemLayerSelf.runeEffectPosTable[desPos];
		-- local pos = gemLayerSelf.runeIcon :getPosition();
		-- pos.x = pos.x + gemLayerSelf.runeIcon:getContentSize().width/2;
		-- pos.y = pos.y + gemLayerSelf.runeIcon:getContentSize().height/2;
		local effect = cartoonPlayer("1492",pos.x,pos.y,1,removeEffect);
		gemLayerSelf.effect = effect;

		local ccArray = CCArray:create();
		ccArray:addObject(CCCallFunc:create(playEffect));
		ccArray:addObject(CCDelayTime:create(0.5));
		-- ccArray:addObject(CCCallFunc:create(removeEffect));
		gemLayerSelf.sendTable = sendTable;
		ccArray:addObject(CCCallFunc:create(sendmsg));
		gemLayerSelf:runAction(CCSequence:create(ccArray));
		
	end
	if nil == self.runePlaceTable then 
		self:initGemPlaceTableAndRunePlaceTable();
	end
	local gemPlaceStr = self.runePlaceTable[desPos].line;
	local gemPlaceTable = StringUtils:lua_string_split(gemPlaceStr,",");
	local gemItem1 = self.gemGrids[tonumber(gemPlaceTable[1])].userItem.ItemId;
	local gemItem2 = self.gemGrids[tonumber(gemPlaceTable[2])].userItem.ItemId;
	local castTip = CommonPopup.new();
	castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_75,{1208000+desPos,gemItem1,gemItem2}),self,confirm,_,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_75),true);
	self:addChild(castTip);
end

function GemLayer:onTapGrayRuneIcon(event,itemId)
	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_85,{itemId}));
end

--符阵升级
function GemLayer:upgradeRuneCombinationType(event)
	local afford = false;
	local costStr = analysis("Zhuangbeibaoshi_Fuzhen",self.item_select.runeLv,"money");
	local costTable = StringUtils:lua_string_split(costStr,",");
	local gold = self.userCurrencyProxy:getGold() or 0;
	local cost = tonumber(costTable[2]) or 0;
	if gold >= cost then
		afford = true;
	end
	if not afford then
		-- 元宝不足
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_76));
		return;
	end

	local isActived = self:runeCombinationUpgradeCheck(self.item_select.runeLv);
	if isActived then
		local sendTable = {UserEquipmentId = self.item_select.equipmentInfo.UserEquipmentId};
		local function confirm()
			sendMessage(10,12,sendTable);
			self:onSelfTap();
		end
		if 3 == self.item_select.runeLv then
			local castTip = CommonPopup.new();
			castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_79,{cost,3}),self,confirm,_,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_79),true);
			self:addChild(castTip);
			return;
		else
			local castTip = CommonPopup.new();
			castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_87,{cost,3}),self,confirm,_,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_87),true);
			self:addChild(castTip);
			return;
		end;
		-- print(sendTable.UserEquipmentId)
		-- sendMessage(10,12,sendTable);
		-- self:onSelfTap();
	elseif not self:gemCountCheck(self.item_select.runeLv) then
		--宝石数量不够
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_214));
		return;
	elseif false == isActived and not self:GemCombinationCheck(self.item_select.runeLv) then
		-- 符阵组合不对
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_77));
		return;
	elseif self.item_select.runeLv ~= self:lineCheck(self.item_select.runeLv) then
		-- 符文未全连接
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_78));
		return;
	end
end

--空镶嵌位点击监听
function GemLayer:openGemBag(event)
	self:onSelfTap();
	-- print(event.target.place);
	if event.target.place > 3 then
		if 4 == event.target.place and not self:runeCombinationUpgradeCheck(event.target.place - 1) then 
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_84,{analysis("Zhuangbeibaoshi_Fuzhen",event.target.place - 1,"name")}));
			return
		elseif 4 < event.target.place and not self:runeCombinationUpgradeCheck(event.target.place - 2) then 
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_84,{analysis("Zhuangbeibaoshi_Fuzhen",event.target.place - 2,"name")}));
			return
		end
	end
	if nil ~= self.gemBag then
		self:removeChild(self.gemBag);
		self.gemBag=nil;
	end
	self.gemBag=GemBag.new();
	self.itemListView:setMoveEnabled(false);
  self.gemBag:initialize(self.skeleton,self,self.onGemEquip,event.target.place,self.bagProxy);
  local pos = makePoint(self.itemListViewPos.x, self.itemListViewPos.y);
	if self.gemBag then
		self.gemBag:setPosition(pos);
		self:addChild(self.gemBag);
		self.popup_boolean = true;
	end

	
end

--宝石盘上宝石点击监听
function GemLayer:onTapGemIcon(event)
	self:onSelfTap();
	if nil ~= self.gemDetailLayer then
		self:removeChild(self.gemDetailLayer);
		self.gemDetailLayer=nil;
	end
	self.gemDetailLayer=GemTipLayer.new();
	local targeClone = event.target:clone();
	targeClone:removeAllEventListeners();
	self.itemListView:setMoveEnabled(false);
	-- self.itemIcon.touchChildren = false;
	local leftButtonInfo = {onTap = self.onGemRemove, text = "卸下"}
	local rightButtonInfo = nil;
	if nil == self.gemPlaceTable then
		self:initGemPlaceTableAndRunePlaceTable();
	end
	local linePlaceStr = self.gemPlaceTable[event.target.place].line;
	local linePlaceTable = StringUtils:lua_string_split(linePlaceStr,",");
	local activeInfo = {};
	activeInfo.activeCounts = 0;
	for k,v in pairs(linePlaceTable)do
		if self.lineEffectTable[tonumber(v)] then
			activeInfo.activeCounts = activeInfo.activeCounts +1;
		end
	end
	activeInfo.actived = self:getCurrentActivedLv();
	if event.target.place > 3 then 
		activeInfo.actived = nil;
	end

  self.gemDetailLayer:initialize(self.skeleton,self,targeClone,leftButtonInfo,rightButtonInfo,event.target,activeInfo);
  local pos = makePoint((GameConfig.STAGE_WIDTH - self.gemDetailLayer.armature_d:getChildAt(1):getContentSize().width)/2 * GameData.gameUIScaleRate, self.itemListViewPos.y);
	self.gemDetailLayer:setPosition(pos);
  self:addChild(self.gemDetailLayer);
	self.popup_boolean = true;
end

--右侧装备图标点击监听
function GemLayer:onTapItemIcon(event)
	-- print("GemLayer:onTapItemIcon")
	self.itemDetailLayer=EquipDetailLayer.new();
	local targeClone = event.target:clone();
	targeClone:removeAllEventListeners();
	self.itemListView:setMoveEnabled(false);
  self.itemDetailLayer:initialize(self.bagProxy:getSkeleton(), targeClone, event.target, false);
  local pos = makePoint(self.itemListViewPos.x, self.itemListViewPos.y);
	self.itemDetailLayer:setPosition(pos);
  self:addChild(self.itemDetailLayer);
	self.popup_boolean = true;
end

--左侧listView点击监听
function GemLayer:onItemTap(item)
	print("GemLayer:onItemTap")
 
  if nil ~= self.itemDetailLayer then 
		return;
  end 

  if self.item_select then
    self.item_select:selectItem(false);
  end
  self.item_select=item;
  self.item_select:selectItem(true);
  self:updatePanel();
end

function GemLayer:onSelfTap(event)
	if self.popup_boolean then
    self.popup_boolean=false;
    return;
  end
  if nil ~= self.itemDetailLayer then 
		self:removeChild(self.itemDetailLayer);
		self.itemDetailLayer=nil;
		self.itemListView:setMoveEnabled(true);
		-- self.popup_boolean = true;
  end  
	if nil ~= self.gemDetailLayer then 
		self:removeChild(self.gemDetailLayer);
		self.gemDetailLayer=nil;
		self.itemListView:setMoveEnabled(true);
		-- self.itemIcon.touchChildren = true;
		-- self.popup_boolean = true;
  end
	if nil ~= self.gemBag then 
		self:removeChild(self.gemBag);
		self.gemBag=nil;
		self.itemListView:setMoveEnabled(true);
		-- self.popup_boolean = true;
  end
	if nil ~= self.upgradeTipLayer then 
		self.tipArmatrue:dispose();
		self.tipArmatrue = nil;
		self:removeChild(self.upgradeTipLayer);
		self.upgradeTipLayer=nil;
		self.itemListView:setMoveEnabled(true);
		-- self.popup_boolean = true;
  end
  self.popup_boolean=false;
end

--右侧界面刷新
function GemLayer:updatePanel()
  if nil == self.item_select then
		for k,v in pairs(self.gemGridPanel)do
			v:removeAllEventListeners();
			self.armatureDisplay:removeChild(v);
			self.armatureDisplay:removeChild(v.text);
			-- v = nil;
		end
		self.gemGridPanel = nil;
    return;
  end
	
	local bagItemData = self.item_select:getBagItemData();
	
	--装备图标
	-- if self.itemIcon then
    -- self.armatureDisplay:removeChild(self.itemIcon);
		-- self.itemIcon = nil;
  -- end
  -- self.itemIcon=BagItem.new();
  -- self.itemIcon:initialize(bagItemData);
  -- self.itemIcon:setPositionXY(self.chosedItemPos.x, self.chosedItemPos.y);
	-- self.itemIcon:addEventListener(DisplayEvents.kTouchTap,self.onTapItemIcon,self);
	-- self.itemIcon.touchEnabled = true
	-- self.itemIcon.touchChildren = true
	-- print(self.itemIcon.touchEnabled)
	-- print(self.itemIcon.touchChildren)
  -- self.armatureDisplay:addChild(self.itemIcon);
	
	
	--装备名字
	-- if self.itemName then
    -- self.armatureDisplay:removeChild(self.itemName);
		-- self.itemName = nil;
  -- end
  -- local text=analysis("Zhuangbei_Zhuangbeibiao",bagItemData.ItemId,"name");
  -- local quality=analysis("Zhuangbei_Zhuangbeibiao",bagItemData.ItemId,"quality");
  -- self.itemName=createTextFieldWithQualityID(quality,self.chosedItemTextData,text);
  -- self.armatureDisplay:addChild(self.itemName);
	
	--装备上宝石属性table
	self.item_select.normalGemPropTable = {}
	self.item_select.advancedGemPropTable = {}
	
	self:updateGemPanel(self.item_select.equipmentInfo)
	  
end

--重置宝石盘
function GemLayer:resetGemPanel()
	self.item_select.runeLv = 3;
	for k,v in pairs(self.gemGrids) do
		v:removeAllEventListeners();
		self.gemIconLayer:removeChild(v);
		v = nil;
	end
	self.gemGrids = nil;
	self.gemGrids = {};
	
	for k,v in pairs(self.lineEffectTable)do
		self.buttonAndTypeTextLayer:removeChild(v);
		v = nil;
	end
	self.lineEffectTable = nil;
	self.lineEffectTable = {};
	
	for k,v in pairs(self.gridEffectTable)do
		self.gemIconLayer:removeChild(v);
		-- print("removeEffect:"..k);
		v = nil;
	end
	self.gridEffectTable = nil;
	self.gridEffectTable = {};
	
	for k,v in pairs(self.gemGridPanel)do
		if k < 4 then
			v:setVisible(true);
			v.text:setVisible(true);
		else
			v:setVisible(false);
			v.text:setVisible(false);
		end
		v.touchEnabled = true;
	end
	
	for k,v in pairs(self.grayLineTable)do
		v:setVisible(false);
	end
	
	for k,v in pairs(self.runeGrids)do
		v:removeAllEventListeners();
		self.gemIconLayer:removeChild(v);
		v = nil;
	end
	self.specialLock:setVisible(true);
end

local function playFunc1()
	gemLayerSelf.touchChildren = false;
	gemLayerSelf.gemIconLayer:addChild(gemLayerSelf.activeEffect);
	-- print("activeEffect")
end
local function removePlayFunc()
	gemLayerSelf.gemIconLayer:removeChild(gemLayerSelf.activeEffect);
	gemLayerSelf.activeEffect = nil;
	gemLayerSelf.touchChildren = true;
end

local function playFunc2()
	gemLayerSelf.touchChildren = false;
	gemLayerSelf:addChild(gemLayerSelf.specialPosEffect);
	-- print("specialPosEffect")
end
local function afterPlayFunc()
	gemLayerSelf:removeChild(gemLayerSelf.specialPosEffect);
	gemLayerSelf.specialPosEffect = nil;
	gemLayerSelf.gemGridPanel[4]:setVisible(true);
	gemLayerSelf.gemGridPanel[4].text:setVisible(nil == gemLayerSelf.gemGrids[4]);
	gemLayerSelf.gemGridPanel[4].touchEnabled = nil == gemLayerSelf.gemGrids[4];
	if gemLayerSelf.gemGrids[4] then
		gemLayerSelf.gemGrids[4]:setVisible(true);
	end
	gemLayerSelf.touchChildren = true;
end
function GemLayer:updateGemPanel(itemData)
	-- print("updateGemPanel")
	-- print(nil == itemData.HoleArray);
	uninitializeSmallLoading();
	self:resetGemPanel();
	-- print("GemGridPanel.pos.x:"..self.gemGridPanel[1]:getPositionX());
	--Modify itemData.HoleArray, using Place as index
	local tbl = {}
	for k,v in pairs(itemData.HoleArray) do
		tbl[v.Place] = v;
	end
	itemData.HoleArray = tbl;
	for k,v in pairs(itemData.HoleArray)do
		if nil ~= v and nil ~= next(v) then
			-- print("v.Place:"..v.Place);
			-- print("v.ItemId:"..v.ItemId);
			--4 < v.Place  to confirm runeLv
			if 4 < v.Place then
				self.item_select.runeLv = self.item_select.runeLv + 1;
			end
			if 0 ~= v.ItemId then
				self:setGemIcon(v);				
			elseif 0 == v.ItemId then
				self.gemGridPanel[v.Place]:setVisible(true);
				self.gemGridPanel[v.Place].text:setVisible(true);
				self.gemGridPanel[v.Place].touchEnabled = true;
			end
		end
	end
	
	for k,v in pairs(itemData.LineArray) do
		if nil ~= v and nil ~= next(v) then
			self:setLineEffectAndGridEffect(v.ID);
		end
	end
	
	if self:runeUsableCheck(itemData.HoleArray) then 
		self:setRune(itemData.HoleArray);
	end
		
	--update self.gemBag when it is opened
	if self.gemBag then
		local targetPlace = self.gemBag.tapTargetPos;
		self:onSelfTap()
		self:removeChild(self.gemBag);
		self.gemBag=nil;
		self.gemBag=GemBag.new();
		self.itemListView:setMoveEnabled(false);
		self.gemBag:initialize(self.skeleton,self,self.onGemEquip,targetPlace,self.bagProxy);
		local pos = makePoint(self.itemListViewPos.x, self.itemListViewPos.y);
		self.gemBag:setPosition(pos);
		self:addChild(self.gemBag);
	end
	
	-- print(self:runeCombinationUpgradeCheck(self.item_select.runeLv));
	if self.item_select.runeLv > 3 then
		for k,v in pairs(self.lineEffectTable)do
			if 4 > v.id then
				v:setVisible(false);
			end
		end
	end
	
	local centerPos = self.gemGridPanel[4]:getPosition();
	centerPos.x = centerPos.x + self.gemGridPanel[4]:getContentSize().width/2;
	centerPos.y = centerPos.y - self.gemGridPanel[4]:getContentSize().height/2;
	
	-- for gemGrids[4] 
	-- print(nil == self.gemGrids[4]);
	local ccArray = CCArray:create();
	-- print("lv3Check:")print(self:runeCombinationUpgradeCheck(3));

	print("runeCombinationUpgradeCheck",self:runeCombinationUpgradeCheck(self.item_select.runeLv))
	if self:runeCombinationUpgradeCheck(self.item_select.runeLv) then
		gemLayerSelf.activeEffect = cartoonPlayer("1570",centerPos.x,centerPos.y,1);
		
		ccArray:addObject(CCCallFunc:create(playFunc1));
		ccArray:addObject(CCDelayTime:create(1));
		ccArray:addObject(CCCallFunc:create(removePlayFunc));
		self:runAction(CCSequence:create(ccArray));
	end
	
	if self:runeCombinationUpgradeCheck(3) then
		if self.gemGrids[4] then
			self.gemGrids[4]:setVisible(true);
		end
		self.gemGridPanel[4]:setVisible(true);
		self.gemGridPanel[4].text:setVisible(nil==self.gemGrids[4]);
		self.gemGridPanel[4].touchEnabled = nil == self.gemGrids[4];
		self.specialLock:setVisible(false);
		if 3 == self.item_select.runeLv then
			if self.gemGrids[4] then
				self.gemGrids[4]:setVisible(false);
			end
			self.gemGridPanel[4]:setVisible(false);
			self.gemGridPanel[4].text:setVisible(false);
			self.gemGridPanel[4].touchEnabled = nil == self.gemGrids[4];
			self.specialLock:setVisible(false);
			gemLayerSelf.specialPosEffect = cartoonPlayer("1575",centerPos.x,centerPos.y,1);
			-- self:addChild(cartoonPlayer("1575_1001",makePoint(300,300),1));
			
			ccArray:addObject(CCCallFunc:create(playFunc2));
			ccArray:addObject(CCDelayTime:create(1));
			ccArray:addObject(CCCallFunc:create(afterPlayFunc));
			self:runAction(CCSequence:create(ccArray));
		end 
	end
	


  local image = Image.new();
	image:load(artData[analysis("Zhuangbeibaoshi_Fuzhen",self.item_select.runeLv,"artid1")].source);
	image:setPosition(self.runeTypePos);
	if nil == self.runeType or self.runeType.lv ~= self.item_select.runeLv then 
		self.buttonAndTypeTextLayer:removeChild(self.runeType);
		self.runeType = nil;
		self.buttonAndTypeTextLayer:addChild(image);
		self.runeType = image;
		self.upgradeButton:setVisible(true);
	end
	
end

function GemLayer:setGemIcon(gemInfo)

	local gemIcon=GemItem.new();
  gemIcon:initialize(gemInfo.ItemId,true,self.bagProxy);
	local pos = self.gemGridPanel[gemInfo.Place]:getPosition();
	-- print("gemGridPanel.pos.x:"..pos.x)
	-- print("width:"..gemIcon:getChildAt(1):getContentSize().width);
	pos.x = pos.x + (self.gemGridPanel[gemInfo.Place]:getContentSize().width - gemIcon:getChildAt(0):getContentSize().width)/2;
	pos.y = pos.y + (self.gemGridPanel[gemInfo.Place]:getContentSize().height - gemIcon:getChildAt(0):getContentSize().height)/2 - self.gemGridPanel[gemInfo.Place]:getContentSize().height;
	gemIcon:setPosition(pos);
	gemIcon:addEventListener(DisplayEvents.kTouchTap,self.onTapGemIcon,self);
	local place = self.gemGridPanel[gemInfo.Place].place;
	local userItem = {ItemId = gemInfo.ItemId};
	gemIcon.userItem = userItem;
	gemIcon.place = place;

	self.gemGridPanel[gemInfo.Place].touchEnabled = false;
	self.gemGridPanel[gemInfo.Place]:setVisible(true);
	self.gemGridPanel[gemInfo.Place].text:setVisible(false);

  self.gemIconLayer:addChild(gemIcon);
	self.gemGrids[gemInfo.Place] = gemIcon;
	local propId = analysis("Zhuangbeibaoshi_Baoshi",gemInfo.ItemId,"attribute");
	if gemInfo.Place > 3 then
		self.item_select.advancedGemPropTable[propId] = propId;
	else
		self.item_select.normalGemPropTable[propId] = propId;
	end
end

function GemLayer:setLineEffectAndGridEffect(id)

	self:initGemPlaceTableAndRunePlaceTable();
	
	--lineEffect
	local lineEffect = nil;
	local srcX1,srcY1;
	local srcX2,srcY2;
	local desX,desY;
	
	-- print("x:"..pos.x)
	-- print("y:"..pos.y)
	
	if 3 < id then
		lineEffect = cartoonPlayer("1571", 0,0, 0);
		srcX1,srcY1 = self.gemGridPanel[4]:getPositionX(), self.gemGridPanel[4]:getPositionY();
	else
		lineEffect = cartoonPlayer("1577",0,0,0);
		srcX1,srcY1 = self.gemGridPanel[id]:getPositionX(), self.gemGridPanel[id]:getPositionY();
	end

	
	srcX2,srcY2 = self.gemGridPanel[id+1]:getPositionX(), self.gemGridPanel[id+1]:getPositionY();
	if 3 == id then 
		srcX2,srcY2 = self.gemGridPanel[1]:getPositionX(), self.gemGridPanel[1]:getPositionY();
	end
	
	
	-----------------------------------------------------
	--计算得出的角度值均有几度的偏差,故选择使用常量值替换
	-- local a = (srcX2 - srcX1)*0+(srcY2 - srcY1)*1;
	-- local b = math.sqrt((srcX2 - srcX1)*(srcX2 - srcX1)+(srcY2 - srcY1)*(srcY2 - srcY1));
	-- local rotation = math.deg(math.acos(a/b));
	-----------------------------------------------------
	
	
	local pos = makePoint((srcX2+srcX1)/2+self.gemGridPanel[id]:getContentSize().width/2,
												(srcY2+srcY1)/2-self.gemGridPanel[id]:getContentSize().height/2);

	
	local rotation = {300,180,60,30,150,270};
	-- print(lineEffect.sprite.rotation);
	lineEffect.sprite.rotation = lineEffect.sprite.rotation + rotation[id];
	lineEffect:setPosition(pos);
	
	self.buttonAndTypeTextLayer:addChild(lineEffect);
	self.lineEffectTable[id] = lineEffect;
	self.lineEffectTable[id].id = id;

	--gridEffect
	if nil == self.lineEffectTable[id] then
		return;
	end
	local placeStr = self.runePlaceTable[id].line;
	local gemPlaceTable = StringUtils:lua_string_split(placeStr,",");
	local gridEffect1,gridEffect2;
	local pos1 = self.gemGridPanel[tonumber(gemPlaceTable[1])]:getPosition();
	pos1.x = pos1.x + self.gemGridPanel[tonumber(gemPlaceTable[1])]:getContentSize().width/2;
	pos1.y = pos1.y - self.gemGridPanel[tonumber(gemPlaceTable[1])]:getContentSize().height/2;
	local pos2 = self.gemGridPanel[tonumber(gemPlaceTable[2])]:getPosition();
	pos2.x = pos2.x + self.gemGridPanel[tonumber(gemPlaceTable[2])]:getContentSize().width/2;
	pos2.y = pos2.y - self.gemGridPanel[tonumber(gemPlaceTable[2])]:getContentSize().height/2;
	
	if 3 < id then
		if nil == self.gridEffectTable[tonumber(gemPlaceTable[1])] then
			gridEffect1	= cartoonPlayer("1576",pos1.x,pos1.y,0);
			self.gridEffectTable[tonumber(gemPlaceTable[1])] = gridEffect1;
			gridEffect1.touchEnabled = false;
			self.gemIconLayer:addChild(gridEffect1);
		end
		if nil == self.gridEffectTable[tonumber(gemPlaceTable[2])] then
			gridEffect2	= cartoonPlayer("1576",pos2.x,pos2.y,0);
			self.gridEffectTable[tonumber(gemPlaceTable[2])] = gridEffect2;
			gridEffect2.touchEnabled = false;
			self.gemIconLayer:addChild(gridEffect2);
		end
	else
		if nil == self.gridEffectTable[tonumber(gemPlaceTable[1])] then
			gridEffect1	= cartoonPlayer("1573",pos1.x,pos1.y,0);
			self.gridEffectTable[tonumber(gemPlaceTable[1])] = gridEffect1;
			gridEffect1.touchEnabled = false;
			self.gemIconLayer:addChild(gridEffect1);
		end
		if nil == self.gridEffectTable[tonumber(gemPlaceTable[2])] then
			gridEffect2	= cartoonPlayer("1573",pos2.x,pos2.y,0);
			self.gridEffectTable[tonumber(gemPlaceTable[2])] = gridEffect2;
			gridEffect2.touchEnabled = false;
			self.gemIconLayer:addChild(gridEffect2);
		end
	end
end

function GemLayer:setRune(HoleArray)
	local tbl = {}
	tbl = analysis("Zhuangbeibaoshi_Fuwen");
	local label = tbl[1];
	local runeTypeTable = {};
	for k,v in pairs(tbl)do
		if k == 1 then 
		
		else
			local tmp = {}
			for i,j in pairs(label)do
				tmp[j] = v[i]
			end
			runeTypeTable[tmp["id"]] = tmp;
		end
	end
	
	for k,v in pairs(self.runePlaceTable)do
		local placeStr = v.line;
		local placeTable = StringUtils:lua_string_split(placeStr,",");
		-- print("k:"..k);
		-- print(self:runeCombinationUpgradeCheck(3));
		if k > 3 and false == self:runeCombinationUpgradeCheck(3) then
			break;
		end
		if nil ~= HoleArray[tonumber(placeTable[1])] and 0 ~= HoleArray[tonumber(placeTable[1])].ItemId 
				and nil ~= HoleArray[tonumber(placeTable[2])] and 0 ~= HoleArray[tonumber(placeTable[2])].ItemId then
			local image = Image.new();
			local runeInfo = analysisByName("Zhuangbeibaoshi_Fuwen","place",v.location);
			image:load(artData[runeInfo[next(runeInfo)].artid].source);
			image:addEventListener(DisplayEvents.kTouchTap,self.onTapRuneIcon,self,v.location)
			if not self:runeGainCheck(runeInfo[next(runeInfo)].id) then
				-- image = Sprite.new(getGraySprite(image.sprite,image.x,image.y));
				image:removeAllEventListeners();
				image = Sprite.new(getGraySprite(image.sprite,image.x,image.y));
				image:addEventListener(DisplayEvents.kTouchTap,self.onTapGrayRuneIcon,self,runeInfo[next(runeInfo)].id);
			end
			image:setPosition(self.runePosTable[k]);
			self.runeEffectPosTable[k] = ccp(self.runePosTable[k].x+image:getContentSize().width/2+ 10,self.runePosTable[k].y+image:getContentSize().height/2);
			image:setPositionX(self.runePosTable[k].x + 10);
			-- image:setScale(0.8);
			
			self.gemIconLayer:addChild(image);
			self.runeGrids[k] = image;
			self.grayLineTable[k]:setVisible(true);
		end
	end
	
	for k,v in pairs(self.lineEffectTable)do
		if self.runeGrids[v.id] then 
			self.runeGrids[v.id]:removeAllEventListeners();
			self.gemIconLayer:removeChild(self.runeGrids[v.id]);
			self.runeGrids[v.id] = nil;
			self.grayLineTable[v.id]:setVisible(false);
		end
	end
end

function GemLayer:gemUsableCheck(propId,place)
	if place < 4 and nil ~= self.item_select.normalGemPropTable[propId] then 
		return false;
	elseif place > 3 and nil ~= self.item_select.advancedGemPropTable[propId] then 
		return false;
	end
	return true;
end

function GemLayer:runeUsableCheck(HoleArray)
	local count = 0;
	for k,v in pairs(HoleArray)do
		count = count + 1;
	end

	if 1 < count then 
		if nil == self.runePlaceTable and nil == self.gemPlaceTable then 
			self:initGemPlaceTableAndRunePlaceTable();
		end
		for k,v in pairs(self.runePlaceTable)do
			local placeStr = v.line;
			local placeTable = StringUtils:lua_string_split(placeStr,",");
			if nil ~= HoleArray[tonumber(placeTable[1])] and nil ~= HoleArray[tonumber(placeTable[2])] then
				return true;
			end
		end
	end
	
	return false;
end

function GemLayer:runeGainCheck(itemId)
	-- print("itemId:"..itemId)
	for k,v in pairs(self.bagProxy:getData())do
		if itemId == v.ItemId then
			return true;
		end
	end
	return false;
end

--符阵升级检查
function GemLayer:runeCombinationUpgradeCheck(runeLv)
	-- local combinationTable = analysis("Zhuangbeibaoshi_Fuzhen",runeLv);
	-- local combinationStr = "combination";
	-- local propStr = nil;
	-- local resault = false;
	-- for i=1,3 do
	-- 	-- print("combinationStr"..i);
	-- 	propStr = combinationTable[combinationStr..i];
	-- 	local propTbl = StringUtils:lua_string_split(propStr,",");
	-- 	for k,v in pairs(propTbl)do
	-- 		-- print("propTbl.v:"..v);
	-- 		if runeLv < 4 and nil ~= self.item_select.normalGemPropTable[tonumber(v)] then
	-- 			resault = true;
	-- 		elseif runeLv > 3 and nil ~= self.item_select.advancedGemPropTable[tonumber(v)] then
	-- 			resault = true;
	-- 		else
	-- 			resault = false;
	-- 			break;
	-- 		end
	-- 	end
	local resault = self:GemCombinationCheck(runeLv);
		if resault then 
			--lineCheck
			local count = self:lineCheck(runeLv);
			if runeLv ~= count then 
				resault = false;
			end
			-- if 6 == runeLv then 
			-- 	-- sharedTextAnimateReward():animateStartByString("已经是最高级符阵");
			-- 	return;
			-- end
			return resault;
		end
	-- end
	-- print("propStr:"..propStr);
	return resault;
end

function GemLayer:GemCombinationCheck(runeLv)
	local combinationTable = analysis("Zhuangbeibaoshi_Fuzhen",runeLv);
	local combinationStr = "combination";
	local propStr = nil;
	local resault = true;
	for i=1,3 do
		resault = true;
		-- print("combinationStr"..i);
		propStr = combinationTable[combinationStr..i];
		local propTbl = StringUtils:lua_string_split(propStr,",");
		for k,v in pairs(propTbl)do
			-- print("propTbl.v:"..v);
			if runeLv < 4 and nil ~= self.item_select.normalGemPropTable[tonumber(v)] then
				resault = resault and true;
			elseif runeLv > 3 and nil ~= self.item_select.advancedGemPropTable[tonumber(v)] then
				resault = resault and true;
			else
				resault = resault and false;
				break;
			end
		end
		-- print("check resault:",resault);
		if resault then 
			return resault;
		end
	end
	-- print(resault);
	return resault;
end

function GemLayer:lineCheck(runeLv)
	--lineCheck
	local count = 0;
	for i=1,runeLv do
		if nil ~= self.lineEffectTable[i] then 
			count = count + 1;
		end
	end
	return count;
end

function GemLayer:getCurrentActivedLv()
	local currentActivedLv = 0;
	for i = 3,self.item_select.runeLv do
		if self:GemCombinationCheck(i) and i == self:lineCheck(i) then
			currentActivedLv = i;
		end
	end
	return currentActivedLv;
end

function GemLayer:initGemPlaceTableAndRunePlaceTable()
	local tbl = {}
	tbl = analysis("Zhuangbeibaoshi_Weizhihexian");
	local label = tbl[1];
	self.gemPlaceTable = {};
	self.runePlaceTable = {};
	for k,v in pairs(tbl)do
		if k == 1 then 
		
		elseif k ~= 1 and 1 == v[5] then
			local tmp = {}
			for i,j in pairs(label)do
				tmp[j] = v[i]
			end
			self.gemPlaceTable[tmp["location"]] = tmp;
		elseif k ~= 1 and 2 == v[5] then 
			local tmp = {}
			for i,j in pairs(label)do
				tmp[j] = v[i]
			end
			self.runePlaceTable[tmp["location"]] = tmp;
		end
	end
end


function GemLayer:gemCountCheck(runeLv)
	local full = true;
	local lv = 3
	if 3 == runeLv then
		
	else
		lv = runeLv + 1;
	end
	for i = 1,lv do
		if self.gemGrids[i] then
			if self.gemGrids[i].userItem then
				full = full and true;
			else
				full = full and false;
			end
		else
			full = full and false;
		end
	end
	return full;
end


--符阵升级tipLayer
function GemLayer:onClickUpgrade(event,page)
	-- log("begin:"..CommonUtils:getOSTime());
	initializeSmallLoading();
	if nil == self.item_select then 
		uninitializeSmallLoading();
		return 
	end;
	local function onTap()
		self.popup_boolean=true;
	end
	self:onSelfTap();
	self.itemListView:setMoveEnabled(false);
	if nil ~= self.upgradeTipLayer then 
		self.upgradeTipLayer:removeAllEventListeners();
		self:removeChild(self.upgradeTipLayer);
		self.upgradeTipLayer = nil;
	end
	self.popup_boolean = true;
	self.upgradeTipLayer = Layer.new();
	self.upgradeTipLayer:initLayer();
	local armature = self.skeleton:buildArmature("runeUpgradeTip");
	armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
	self.tipArmatrue = armature;
	self.upgradeTipLayer:addChild(armature.display);
	
	
	local gem_prop_add_red = armature:getBone("gem_prop_add_red").textData;
	local tbl = analysis("Zhuangbeibaoshi_Fuzhen");
	local runeCount = 0;
	for k,v in pairs(tbl)do
		if 1 ~= k then 
			runeCount = runeCount + 1;
		end
	end
	self.upgradeTipLayer.runeCount = runeCount;
	local runeFormationPanelContainerSize = makeSize(gem_prop_add_red.width * runeCount, gem_prop_add_red.height);
	-- local runeFormationPanelContainerSize = makeSize(800 * runeCount, 480);
	local runeFormationPanelViewSize = makeSize(gem_prop_add_red.width, gem_prop_add_red.height);
	-- local runeFormationPanelViewSize = makeSize(800, 480);

	
	
  --翻页
	local runeFormationPanelDO = armature:getBone("runeFormationPanel"):getDisplay();
	armature.display:removeChild(runeFormationPanelDO);
	
  local scrollView=GalleryViewLayer.new();
  scrollView:initLayer();
  scrollView:setContainerSize(runeFormationPanelContainerSize);
  scrollView:setViewSize(runeFormationPanelViewSize);
  scrollView:setMaxPage(runeCount);
  scrollView:setDirection(kCCScrollViewDirectionHorizontal);
  scrollView:setPositionXY(gem_prop_add_red.x , gem_prop_add_red.y)-- - gem_prop_add_red.height);
	
	-- print("scrollView.y :"..scrollView:getPositionY());
	-- print("gem_prop_add_red.height :"..gem_prop_add_red.height);

  -- scrollView:setPositionXY(100,100);
  self.upgradeTipLayer:addChild(scrollView);


  local function toNext(event)
		local currentPage = scrollView:getCurrentPage();
		scrollView:setPage(currentPage+1,true);
	end	
	
	local function toPrevious(event)
		local currentPage = scrollView:getCurrentPage();
		scrollView:setPage(currentPage-1,true);
	end


	local leftButtonDO = armature:getBone("leftButton"):getDisplay();
	local pos = convertBone2LB4Button(leftButtonDO);
	armature.display:removeChild(leftButtonDO);
	self.upgradeTipLayer.leftButton = CommonButton.new();
	self.upgradeTipLayer.leftButton:initialize("common_left_button_normal","common_left_button_down",CommonButtonTouchable.BUTTON);
  self.upgradeTipLayer.leftButton:addEventListener(DisplayEvents.kTouchTap,toPrevious,self);
  self.upgradeTipLayer.leftButton:setPosition(pos);
  self.upgradeTipLayer:addChild(self.upgradeTipLayer.leftButton);
	
	local rightButtonDO = armature:getBone("rightButton"):getDisplay();
	local pos = convertBone2LB4Button(rightButtonDO);
	armature.display:removeChild(rightButtonDO);
	self.upgradeTipLayer.rightButton = CommonButton.new();
	self.upgradeTipLayer.rightButton:initialize("common_right_button_normal","common_right_button_down",CommonButtonTouchable.BUTTON);
  self.upgradeTipLayer.rightButton:addEventListener(DisplayEvents.kTouchTap,toNext,self);
  self.upgradeTipLayer.rightButton:setPosition(pos);
	self.upgradeTipLayer:addChild(self.upgradeTipLayer.rightButton);

  local function pageCheck()
  	if 1 == scrollView:getCurrentPage() then
  		self.upgradeTipLayer.leftButton:setVisible(false);
  	elseif runeCount == scrollView:getCurrentPage() then
  		self.upgradeTipLayer.rightButton:setVisible(false);
  	else
  		self.upgradeTipLayer.leftButton:setVisible(true);
  		self.upgradeTipLayer.rightButton:setVisible(true);
  	end
  end
	scrollView:addFlipPageCompleteHandler(pageCheck);


	scrollView:setPage(self.item_select.runeLv-2,false);
	if nil ~= page then
		scrollView:setPage(page,false);
	end
	

	
  --描述
  for index = 1,runeCount do
		local layer = TouchLayer.new();
		layer:initLayer();
		local tmpArmature = self.skeleton:buildArmature("runeFormationPanel");
		tmpArmature.animation:gotoAndPlay("f1");
		tmpArmature:updateBonesZ();
		tmpArmature:update();
		self.tmpArmature = tmpArmature;
		layer:addChild(tmpArmature.display);
	
		---------------------------------------------------------------------------------------------
		-- [[local equipmentQuality = analysis("Zhuangbei_Zhuangbeibiao",self.item_select:getBagItemData().ItemId,"quality");
		-- local equipmentLv = analysis("Zhuangbei_Zhuangbeibiao",self.item_select:getBagItemData().ItemId,"lv");
		-- print("equipmentQuality:"..equipmentQuality);
		-- print("equipmentLv:"..equipmentLv);
		-- local num = math.pow(index-1,2)/math.pow((equipmentQuality*0.2),0.5)/100+0.2;
		-- (符阵-3)^0.5/(装备品质*0.2)^0.5*(装备佩戴等级^0.35)/100+0.006
		--new by jiasq (符阵-3)^2/(装备品质*0.2)^0.5*(装备佩戴等级^0.0)/100+0.2						
		-- print("num:"..num);
		-- if 1 == index then 
			-- num = 2/math.pow((equipmentQuality*0.2),0.5)*(math.pow(equipmentLv,0.67))/100+0.022;
			-- num = 0.2/math.pow((equipmentQuality*0.03),0.75)*(math.pow(equipmentLv,0.45))/100+0.2;
			--	2/(装备品质*0.2)^0.5*(装备佩戴等级^0.67)/100+0.022
			--	0.2/(装备品质*0.1)^0.75*(装备佩戴等级^0.7)/100+0.017
			--new  by jiasq 0.2/(装备品质*0.03)^0.75*(装备佩戴等级^0.45)/100+0.2
			-- print("num:"..num);
		-- end
		-- num = num * 1000;
		-- local dotPos = string.find(num,"[.]",1);
		-- local tmpStr = 0+string.sub(num,dotPos+2,dotPos+2);
		-- if tmpStr > 4 then
		-- 	num = num + 0.1;
		-- end
		-- num = math.floor(num+0.5)/10;
		-- print("Num:"..num);
		-- local text = '<content><font color="#E1D2A0">';]]
		---------------------------------------------------------------------------------------------

		-- 改为读表 
		local num = analysis("Zhuangbeibaoshi_Fuzhen",index+2,"xiaoguo")/1000;

		local line_1_textData=tmpArmature:getBone("line_1").textData;
		line_1_textData.alignment='left';
		line_1_textData.width = 0;
		line_1_textData.height = 0;
		local line_1 = '<content><font color="#00FF00">';
		local upgradePercatage = num;
		-- local upgradePercatage = string.sub(num,1,dotPos+1);
		-- print("upgradePercatage:"..upgradePercatage);
		-- text = text.."激活效果: 宝石属性提升 ";
		line_1 = line_1..'激活效果: </font><font color="#E1D2A0"> 宝石属性提升 </font>';
		-- text = text..tostring(upgradePercatage).."% \r";
		line_1 = line_1..'<font color="#00FF00">'..tostring(upgradePercatage)..'% </font></content>';
		local textField = createMultiColoredLabelWithTextData(line_1_textData,line_1);
		tmpArmature.display:addChild(textField);
		
		-- text = text.."激活条件: 以下任意组合 用 符文连接 \r";
		local line_2_textData=tmpArmature:getBone("line_2").textData;
		line_2_textData.alignment='left';
		line_2_textData.width = 0;
		line_2_textData.height = 0;
		local line_2 = '<content><font color="#00FF00">激活条件: </font><font color="#FFFF00">以下任意组合 </font><font color="#E1D2A0">用 </font><font color="FFFF00">符文连接</font><content>';
		local textField = createMultiColoredLabelWithTextData(line_2_textData,line_2);
		tmpArmature.display:addChild(textField);
		
		local constChar = {"一","二","三"}
		
		
		local propStr = nil;
		local lineStr = "line_"
		for i=1,3 do
			local combinationTable = analysis("Zhuangbeibaoshi_Fuzhen",index+2);
			local combinationStr = "combination";
			propStr = combinationTable[combinationStr..i];
			-- print(propStr)
			local propTbl = StringUtils:lua_string_split(propStr,",");
			local propType = "<content><font color='#E1D2A0'>组合"..constChar[i].." : ".."</font>";
			if 3 == index+2 then
				for k,v in pairs(propTbl)do
					-- print("k,v:",k..","..v)
					
					local colorText = '<font color="#FFFF00">';
					if nil == self.item_select.normalGemPropTable[tonumber(v)]then
						colorText = '<font color="#5B5B5B">';
					end
					propType = propType ..colorText.. analysis("Wujiang_Wujiangshuxing",tonumber(v),"name").."宝石</font>";
					if #propTbl ~= k then 
						propType = propType.."<font color='#E1D2A0'>+</font>";
					end
				end
			else
				local tbl = analysis("Zhuangbeibaoshi_Baoshi");
				local advancedGemTable = {};
				local label = tbl[1];
				for k,v in pairs(tbl)do
					if 1 == k then
						
					elseif v[1] > 1207100 then
						local gemInfo = {};
						for i,j in pairs(v)do
							gemInfo[label[i]] = j;
						end
						advancedGemTable[gemInfo["attribute"]] = gemInfo;
					end
				end
				for k,v in pairs(propTbl)do
					-- print("k,v:",k..","..v)
					local colorText = '<font color="#FFFF00">';
					if nil == self.item_select.advancedGemPropTable[tonumber(v)] then
						colorText = '<font color="#5B5B5B">';
					end
					propType = propType ..colorText.. advancedGemTable[tonumber(v)].name .. "</font>";
					if #propTbl ~= k then 
						propType = propType.."<font color='#E1D2A0'>+</font>";
					end
				end
			end
			
			propType = propType.."</content>";
			-- print("i:"..i);
			local textData = tmpArmature:getBone(lineStr..(i+2)).textData;
			textData.alignment = 'left';
			textData.width = 0;
			textData.height = 0;
			-- print("begin",CommonUtils:getOSTime());
			local textField = createMultiColoredLabelWithTextData(textData,propType);
			tmpArmature.display:addChild(textField);
			-- print("end",CommonUtils:getOSTime());
		end
		
		-- text = text .. '</font></content>';
	-- prop_scroll:setPositionY(runeFormationPanelViewSize.height);
	-- self.upgradeTipLayer.scrollView:addContent(prop_scroll);
	-- self.upgradeTipLayer:addChild(prop_scroll);
	
	

		-- layer.sprite:setColor(ccc3(255,255,255));
		-- local prop_add_yellow_data=tmpArmature:getBone("line_5").textData;
		-- print("tmpArmature.display.x:"..tmpArmature.display:getPositionX());
		-- print("layer.y:"..layer:getPositionY());
		layer:setContentSize(runeFormationPanelViewSize);
		layer:setPositionXY(runeFormationPanelViewSize.width*(index-1), gem_prop_add_red.height);
		
		-- print("runeFormationPanelViewSize.height:"..runeFormationPanelViewSize.height);
		-- local textField = createMultiColoredLabelWithTextData(prop_add_yellow_data,text);
		-- tmpArmature.display:addChild(textField);
		
		
		--符阵小图标
		local currencyTypeDO = tmpArmature:getBone("beforeUpgradeIcon"):getDisplay();
		local currencyPos = currencyTypeDO:getPosition();
		-- print("currencyTypeDO.y"..currencyTypeDO:getPositionY());
		currencyPos.y = currencyPos.y - currencyTypeDO:getContentSize().height;

		local currentType = Image.new();
		currentType:load(artData[analysis("Zhuangbeibaoshi_Fuzhen",index+2,"artid")].source);
		currencyPos.x = currencyPos.x - (currentType:getContentSize().width - currencyTypeDO:getContentSize().width)/2;
		currentType:setPosition(currencyPos);
		tmpArmature.display:addChild(currentType);
		tmpArmature.display:removeChild(currencyTypeDO);
		
		local text = analysis("Zhuangbeibaoshi_Fuzhen",index+2,"name");
		local nameText = TextField.new(CCLabelTTF:create(text,GameConfig.DEFAULT_FONT_NAME,20));
		nameText:setPositionXY(currentType:getPositionX(), currentType:getPositionY()-nameText:getContentSize().height);
		nameText:setColor(CommonUtils:ccc3FromUInt("16739328"));
		tmpArmature.display:addChild(nameText);
		
		--激活图标
		local activedDO = tmpArmature:getBone("actived"):getDisplay();
		local notActivedDO = tmpArmature:getBone("notActived"):getDisplay();
		
		activedDO:setVisible(false);
		notActivedDO:setVisible(false);
		

		
		local actived = self:runeCombinationUpgradeCheck(self.item_select.runeLv);
		-- print("actived:"..actived);
		if 1 == index and self:runeCombinationUpgradeCheck(3) then
			activedDO:setVisible(true);
			layer:addChild(activedDO);
		elseif self.item_select.runeLv == index+2 and actived then
			activedDO:setVisible(true);
			layer:addChild(activedDO);
		elseif 6 == index+2 and nil == actived then
			activedDO:setVisible(true);
			layer:addChild(activedDO);
		elseif self.item_select.runeLv == index+2 and false == actived then
			notActivedDO:setVisible(true);
			layer:addChild(notActivedDO);
		elseif 1 == index and not self:runeCombinationUpgradeCheck(3) then
			notActivedDO:setVisible(true);
			layer:addChild(notActivedDO);
		end
		
		scrollView:addContent(layer);
	end
	
	--按钮
  local leftButton=armature.display:getChildByName("common_copy_bluelonground_button");
  local left_pos=convertBone2LB4Button(leftButton);
  armature.display:removeChild(leftButton);
	leftButton=CommonButton.new();
	leftButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  leftButton:initializeText(armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_bluelonground_button").textData,"提升符阵");
	leftButton:addEventListener(DisplayEvents.kTouchTap,self.upgradeRuneCombinationType,self);
	leftButton:setPosition(left_pos);
	self.upgradeTipLayer:addChild(leftButton);
	
	if 6 == self.item_select.runeLv then
		local textField = TextField.new(CCLabelTTF:create("已经是最高级符阵了哦!",GameConfig.DEFAULT_FONT_NAME,25));
		textField:setPositionXY(leftButton:getPositionX()-(textField:getContentSize().width-leftButton:getChildAt(0):getContentSize().width)/2, leftButton:getPositionY()+textField:getContentSize().height/2);
		textField:setColor(CommonUtils:ccc3FromUInt("65280"));
		self.upgradeTipLayer:removeChild(leftButton);
		leftButton:removeAllEventListeners();
		leftButton = nil;
		self.upgradeTipLayer:addChild(textField);
	end
  
	--右边按钮
	-- local rightButton=armature.display:getChildByName("common_copy_blueround_button");
	-- local right_pos=convertBone2LB4Button(rightButton);
	-- armature.display:removeChild(rightButton);
	-- rightButton=CommonButton.new();
	-- rightButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
	-- rightButton:initializeText(armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData,"取消");
	-- rightButton:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
	-- rightButton:setPosition(right_pos);
	-- self.upgradeTipLayer:addChild(rightButton);
	
	-- armature.display:removeChild(armature:getBone("common_copy_blackHalfAlpha_bg"):getDisplay());


	self:addChild(self.upgradeTipLayer);
	self.upgradeTipLayer:addEventListener(DisplayEvents.kTouchTap,onTap,self);
	uninitializeSmallLoading();
	-- log("end:"..CommonUtils:getOSTime());
end
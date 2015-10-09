require "main.common.CommonExcel";
require "main.view.bag.ui.bagPopup.BagItem";
require "main.common.batchUse.BatchUseUI"
require "core.controls.page.CommonSlot"

ShopSlot=class(CommonSlot);

function ShopSlot:ctor()
  self.class=ShopSlot;
end

function ShopSlot:dispose()
  self:removeAllEventListeners();
  ShopSlot.superclass.dispose(self);
  self.removeArmature:dispose()
end

-- 创建实例
function ShopSlot:create(shopItemPo, context, onOpenChargeUI, onShopItemTap, onBuyItem, onOpenFunctionUI, useType)	
	self.shopItemPo = shopItemPo;
	self.context = context;
	self.onOpenChargeUI = onOpenChargeUI;
	self.onShopItemTap = onShopItemTap;
	self.onBuyItem = onBuyItem;
	self.onOpenFunctionUI = onOpenFunctionUI;

	local item = ShopSlot.new();
	item.useType = useType;
	item:initLayer();

	return item;
end

function ShopSlot:initialize()
	

	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@function ShopSlot:initialize()")

	local skeleton = self.context.shopProxy:getSkeleton();
	local armature= skeleton:buildArmature("shop_render");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.removeArmature = armature;
	local armature_d=armature.display;
	self:addChild(armature_d);

	self.itemPo = analysis("Daoju_Daojubiao", self.shopItemPo.itemid);

	local grid = armature_d:getChildByName("common_copy_grid");
	self.itemImage = BagItem.new(); 
	self.itemImage:initialize({ItemId = self.shopItemPo.itemid, Count = 1});
	local gridPos = convertBone2LB(grid);

	self.itemImage:setPositionXY(gridPos.x + ConstConfig.CONST_GRID_ITEM_SKEW_X, gridPos.y + ConstConfig.CONST_GRID_ITEM_SKEW_Y);
	self.itemImage:addEventListener(DisplayEvents.kTouchTap, self.onTap, self);  
	self.itemImage.touchEnabled = true;
	self.itemImage.touchChildren = true;
	self:addChild(self.itemImage);
  


  	local itemNameTextData = armature:getBone("itemName").textData;
  	self.itemName = createTextFieldWithTextData(itemNameTextData, self.itemPo.name);
	local color = analysis("Daoju_Daojubiao", self.shopItemPo.itemid,"color");
	self.itemName:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(color)));
  	self:addChild(self.itemName);


	local priceTextData = armature:getBone("price").textData;
	self.price = createTextFieldWithTextData(priceTextData, self:getPrice());
	self:addChild(self.price);

	local text_familyContributeTextData = armature:getBone("text_familyContribute").textData;
	self.text_familyContribute = createTextFieldWithTextData(text_familyContributeTextData, "贡献");
	self:addChild(self.text_familyContribute);
	self.text_familyContribute:setVisible(false);
	self.text_familyContribute.touchEnabled = false;

	self.hotTag = armature_d:getChildByName("hot_bg");
	self.hotTag:setVisible(false);

	self.common_copy_gold_bg = armature_d:getChildByName("common_copy_gold_bg");
	self.common_copy_gold_bg:setScale(5/6);
	self.common_copy_gold_bg.touchEnabled = false;

	self.prestige_bg1 = armature_d:getChildByName("prestige_bg1");
	self.prestige_bg1.touchEnabled = false;
	self.common_copy_silver_bg = armature_d:getChildByName("common_copy_silver_bg");
	self.common_copy_silver_bg.touchEnabled = false;
	self.price.touchEnabled = false;
	self.img_generalEmployScore = armature_d:getChildByName("img_generalEmployScore");
	self.img_generalEmployScore:setVisible(false);
	self.img_generalEmployScore.touchEnabled = false;


	self.not_enough = createTextFieldWithTextData(armature:getBone("not_enough").textData, "");
	self:addChild(self.not_enough);


	local rankLevelTextData = copyTable(armature:getBone("rankLevel").textData);

	local currencyIcon;
	if 2 == self.shopItemPo.money then
		
	
	elseif 3 == self.shopItemPo.money then
		armature_d:removeChild(armature_d:getChildByName("common_copy_silver_bg"));
		armature_d:removeChild(armature_d:getChildByName("prestige_bg1"));
	
	elseif 7 == self.shopItemPo.money then
		armature_d:removeChild(armature_d:getChildByName("common_copy_gold_bg"));
		armature_d:removeChild(armature_d:getChildByName("common_copy_silver_bg"));

		currencyIcon = armature_d:getChildByName("prestige_bg1")
		-- currencyIcon:setPosition(armature_d:getChildByName("common_copy_gold_bg"):getPosition());
		currencyIcon:setPositionX(currencyIcon:getPositionX()-currencyIcon:getGroupBounds().size.width/2);
		currencyIcon:setPositionY(currencyIcon:getPositionY()+1);
	end
	
	self:updatePriceColor();
	
	if 0 == self.shopItemPo.term and 12 ~= self.shopItemPo.money then
		if 10==self.shopItemPo.money then
		else
			if not self.shopItemPo.TotalCount and not self.shopItemPo.TotalMaxCount then
				-- currencyIcon:setPositionX((currencyIcon:getPositionX()+rankTextData.x)/2);
				-- self.price:setPositionX((self.price:getPositionX()+rankLevelTextData.x)/2);
			end
		end
	elseif 12 == self.shopItemPo.money then
    -- currencyIcon:setPositionX((currencyIcon:getPositionX()+rankTextData.x)/2);
    -- self.price:setPositionX(currencyIcon:getPositionX()+currencyIcon:getContentSize().width-20);
	else
		
		local rankLevelText = analysis("Wujiang_Juewei",self.shopItemPo.term,"title");
		self.rankLevel = createTextFieldWithTextData(rankLevelTextData,rankLevelText);
		local rank = self.context.userProxy:getNobility();
		if rank < self.shopItemPo.term then
			self.rankLevel:setColor(ccc3(255,0,0));
		end
		self:addChild(self.rankLevel);
	end
  
	--common_copy_bluelonground2_button
	local button=armature_d:getChildByName("common_copy_bluelonground2_button");
	local button_pos=convertBone2LB4Button(button);
	armature_d:removeChild(button);
 
	self.common_copy_bluelonground2_button=CommonButton.new();
	self.common_copy_bluelonground2_button:initialize("common_bluelonground2_button_normal","common_bluelonground2_button_down",CommonButtonTouchable.BUTTON);
	self.common_copy_bluelonground2_button:setPosition(button_pos);
	self.common_copy_bluelonground2_button:initializeText(armature:findChildArmature("common_copy_bluelonground2_button"):getBone("common_copy_bluelonground2_button").textData,"");
	armature_d:addChildAt(self.common_copy_bluelonground2_button,2);
 	self.common_copy_bluelonground2_button:addEventListener(DisplayEvents.kTouchTap, self.onButtonTap, self);

 	if 10 == self.shopItemPo.money and 16 == self.context.curIndex then --商店类型16的才添加占领判断
  		self.common_copy_bluelonground_button:setGray(not self:getBuyable());
  	end
end

-- 设置slot的数据(子类重写该方法)
function ShopSlot:setSlotData(item)
	
	self.shopItemPo = item;

	if not item then
		self:removeSlotData();
		return;
	end

	if not self.removeArmature then
		self:initialize();
	end
end

function ShopSlot:onButtonTap(event)
	if event.globalPosition.x < 16 or event.globalPosition.x > 1070 then
		return;
	end

  if 2 == self.shopItemPo.money then
  	if self.shopItemPo.price > self.context.userCurrencyProxy:getSilver() then

  		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_39));
  	-- 		local function openMijiUI()
  	-- 			    self.onOpenFunctionUI(self.context, MijiConfig.SILVER)
			-- 		--self:dispatchEvent(Event.new("OPEN_FUNCTION",MijiConfig.SILVER,self));
			-- end
			-- local castTip = CommonPopup.new();
			-- castTip:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_39),self,openMijiUI,_,_,_,_,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_39),false);
			-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(castTip);
  		--sharedTextAnimateReward():animateStartByString("亲~银两不足了哦！");
			return;
  	end
  	if self.totalLeftCount then
  		if self.totalLeftCount < 1 then
  			sharedTextAnimateReward():animateStartByString("亲~商品已经卖完了哦！");
  			return;
  		end
  	end
  	if self.leftCount then
  		if self.leftCount < 1 then
  			sharedTextAnimateReward():animateStartByString("亲~您的购买次数已经用完哦！");
  			return;
  		end
  	end
  elseif 3 == self.shopItemPo.money then
		if self.shopItemPo.price > self.context.userCurrencyProxy:getGold() then
  		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
  		self.onOpenChargeUI(self.context);
			return;
  	end
  	if self.totalLeftCount then
  		if self.totalLeftCount < 1 then
  			sharedTextAnimateReward():animateStartByString("亲~商品已经卖完了哦！");
  			return;
  		end
  	end
  	if self.leftCount then
  		if self.leftCount < 1 then
  			sharedTextAnimateReward():animateStartByString("亲~您的购买次数已经用完哦！");
  			return;
  		end
  	end
  elseif 7 == self.shopItemPo.money then
  		local rank = self.context.userProxy:getNobility();
		if rank < self.shopItemPo.term then
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_106));
			return;
		elseif self.shopItemPo.price > self.context.userCurrencyProxy:getPrestige() then
  			sharedTextAnimateReward():animateStartByString("亲~声望不足了哦！");
			return;
  		end
  end

	if self.batchUseUI then 
		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.batchUseUI);
		self.batchUseUI = nil;
	end

	if self.context.bagProxy:getBagIsFull(self.context.itemUseQueueProxy) and 11 ~= self.shopItemPo.money then
		sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_8));
		self.context:dispatchEvent(Event.new("TO_AUTO_GUIDE",FunctionConfig.FUNCTION_ID_21,self));
		return;
	elseif 11 == self.shopItemPo.money and self.context.bagProxy:isDebrisFull() then
		sharedTextAnimateReward():animateStartByString("碎片已经装不下咯，英魂吞噬碎片可以得经验哟！");
		return
	end
	
	local overlap = analysis("Daoju_Daojubiao",self.shopItemPo.itemid,"overlap");

	if 100 < self.shopItemPo.itemid and self.shopItemPo.itemid < 1000 then --购买英魂
		self.shopItemPo.Count = 1;
		self:confirm();
	elseif 1 == overlap and 1 == self.context.bagProxy:getBagLeftPlaceCount(self.context.itemUseQueueProxy) then
		self.shopItemPo.Count = 1;
		self:confirm();	
	else
		if (self.shopItemPo.UserCount and self.shopItemPo.UserMaxCount) 
			or (self.shopItemPo.TotalLeftCount and self.shopItemPo.UserMaxCount) then
			if self.shopItemPo.UserCount == 1 and self.shopItemPo.UserMaxCount > 0 then
				self.shopItemPo.Count = 1;
				self:confirm();
				return
			elseif self.shopItemPo.TotalLeftCount == 1 and self.shopItemPo.UserMaxCount > 0 then
				self.shopItemPo.Count = 1;
				self:confirm();
				return
			end
		end
		self.parent.parent.parent.parent.scrollView:setMoveEnabled(false);
		self.batchUseUI = BatchUseUI.new();
		self.shopItemPo.ItemId = self.shopItemPo.itemid;
		self.shopItemPo.Count = 1;
		self.shopItemPo.CostValue = self.shopItemPo.price;
		self.shopItemPo.CostType = self.shopItemPo.money;
		self.shopItemPo.specialType = 1;
		if 1 == overlap then --不可叠加,要根据背包的容量限制购买个数
			self.shopItemPo.MaxCount = math.min(self.context.bagProxy:getBagLeftPlaceCount(self.context.itemUseQueueProxy),30);
		end
		if 11 == self.shopItemPo.money then
			local jifenCount = math.floor(self.context.userCurrencyProxy:getGeneralEmployScore() / self.shopItemPo.price)
			if jifenCount > 30 then
				self.shopItemPo.MaxCount = 30
			else
				self.shopItemPo.MaxCount = jifenCount
			end
		end
		if self.buyCount then
			self.shopItemPo.Count = self.buyCount
			self.shopItemPo.MaxCount = self.buyCount
		end

	    if self.itemPo.functionID == 1 then-- 装备
	        self.shopItemPo.Count = 1
			self.shopItemPo.MaxCount = 1

	    end
		self.batchUseUI:initialize(self.context.effectProxy:getBatchUseSkeleton(),self,self.shopItemPo,{"购买","取消"},self.confirm,self.cancel,3,self.context.userCurrencyProxy);
		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.batchUseUI);

	    if self.buyCount then
			self.batchUseUI:onTapMax();
		end
		return;
	end
	
end
-- function ShopSlot:onAlertByEquip()
-- 	if self.shopItemPo.price < self.context.prestige then
--         local function openMijiUI()
--           self.context:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID = FunctionConfig.FUNCTION_ID_103,TYPE_ID = MijiConfig.PRESTIGE},self.context));
--         end

--         local castTip = CommonPopup.new();
--         castTip:initialize("骚年,声望好像不够哦~去秘籍里找找怎么提升声望吧~",self.context,openMijiUI,_,_,_,_,{"秘籍","取消"},false);
--         sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(castTip);
--         self.context:touchEnable(true);
--   		print("onAlertByEquip")
--   	else

--   	end
-- end
function ShopSlot:onTap(event)
  self.onShopItemTap(self.context, self.shopItemPo.itemid)
end

function ShopSlot:getItemID()
  return self.shopItemPo.itemid;
end

function ShopSlot:getPrice()

	return self.shopItemPo.price;
end

function ShopSlot:confirm()
	-- print("confirm",self.shopItemPo.itemid,self.shopItemPo.Count)
	self.parent.parent.parent.parent.scrollView:setMoveEnabled(true);
	self.touchChildren = false;

	if self.shopItemPo.TotalLeftCount and self.shopItemPo.TotalCount then
		if self.shopItemPo.TotalLeftCount > 0 and self.shopItemPo.TotalCount > 0 then
			self.totalLeftCount = self.shopItemPo.TotalLeftCount - self.shopItemPo.Count;
			self.shopItemPo.TotalLeftCount = self.totalLeftCount
			if self.totalLeftCount < 1 then
				self.totalLeftText:setColor(ccc3(255,0,0));
			end
			self.totalLeftText:setString(" "..self.totalLeftCount);
		end
	end
  self.onBuyItem(self.context, self.shopItemPo, self)
  --local shopBuyEvent = Event.new("ShopBuyButtonTap", self.shopItemPo, self);
  --self:dispatchEvent(shopBuyEvent); 
end

function ShopSlot:cancel()
	self.parent.parent.parent.parent.scrollView:setMoveEnabled(true);
end

function ShopSlot:updatePriceColor()
	self.price:setColor(ccc3(255,255,255));
  if 2 == self.shopItemPo.money then
  	if self.shopItemPo.price > self.context.userCurrencyProxy:getSilver() then
  		self.price:setColor(ccc3(255,0,0));
			return;
  	end
  elseif 3 == self.shopItemPo.money then
		if self.shopItemPo.price > self.context.userCurrencyProxy:getGold() then
  		self.price:setColor(ccc3(255,0,0));
			return;
  	end
  elseif 7 == self.shopItemPo.money then
		if self.shopItemPo.price > self.context.userCurrencyProxy:getPrestige() then
  		self.price:setColor(ccc3(255,0,0));
			return;
  	end

  end
end

function ShopSlot:getBuyable()
	if not self.Lingdizhanbaoming then
		self.Lingdizhanbaoming = analysisTotalTable("Jiazu_Lingdizhanbaoming");
	end
	if self.context.notification and self.context.notification.IDArray then
		for k,v in pairs(self.context.notification.IDArray) do
			local s=self.Lingdizhanbaoming["key"..v.ID]["mall"];
			s=StringUtils:lua_string_split(s,",");
			for k_,v_ in pairs(s) do
				if tonumber(v_)==self.shopItemPo.itemid then
					return true;
				end
			end
		end
	end
	return false;
end

function ShopSlot:getPossessionName()
	if not self.Lingdizhanbaoming then
		self.Lingdizhanbaoming = analysisTotalTable("Jiazu_Lingdizhanbaoming");
	end
	local a=0;
	while 5>a do
		a=1+a;
		local s=self.Lingdizhanbaoming["key"..a]["mall"];
		s=StringUtils:lua_string_split(s,",");
		for k,v in pairs(s) do
			if tonumber(v)==self.shopItemPo.itemid then
				return self.Lingdizhanbaoming["key"..a]["name"];
			end
		end
	end
	return "";
end

function ShopSlot:setHotTag(bool)
	if bool then
		self.hotTag:setVisible(bool)
	else
		self.hotTag:setVisible(false);
	end
end

function ShopSlot:setSelect()
    if not self.itemEffect then
    	local size = self.itemImage.frame_bg:getContentSize()
    	print("@@@@@@@@@@@@@size.width", size.width)
		self.itemEffect = cartoonPlayer("367",size.width/2 -7, size.height/2-7, 0, nil, 1);
		self.itemImage:addChild(self.itemEffect);
	end
end

function ShopSlot:setBuyCount(count)
   self.buyCount = count
end
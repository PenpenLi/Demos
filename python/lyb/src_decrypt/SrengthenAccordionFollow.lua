SrengthenAccordionFollow=class(Layer);

local itemSlotSelected = nil;

function SrengthenAccordionFollow:ctor()
  self.class=SrengthenAccordionFollow;
end

function SrengthenAccordionFollow:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  SrengthenAccordionFollow.superclass.dispose(self);
  self.armature:dispose();
  SrengthenAccordionFollow:cleanCache();
end

function SrengthenAccordionFollow:initialize(context, generalID)
	self.context = context;
  self.generalID = generalID;
  self.skeleton = self.context.skeleton;
	self:initLayer();
  self.bagItems = {};
  self.redDotsTabBTN = {};
  
  local armature=self.skeleton:buildArmature("name_item_follow");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self.armature.display:setPositionX(2);
  self:addChild(self.armature.display);
end

function SrengthenAccordionFollow:initBag()
  if self.isInitBag then
    return;
  end
  self.isInitBag = true;
  for i=1,6 do
    self:addBagItem(i);
  end
  self:refreshRedDot();
end

function SrengthenAccordionFollow:addBagItem(place)
  if self.bagItems[place] then
    self.armature.display:removeChild(self.bagItems[place]);
    self.bagItems[place] = nil;
  end
  if self.redDotsTabBTN[place] then
    self.armature.display:removeChild(self.redDotsTabBTN[place]);
    self.redDotsTabBTN[place] = nil;
  end
  local poss = {{0,117},{0,0},{123,117},{246,117},{123,0},{246,0}};
  local skew = {23,13};
  local data = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.generalID,place);
  local bagItem = BagItem.new();
  bagItem:initialize(data,true);
  bagItem:setBackgroundVisible(true);
  bagItem.touchEnabled = true;
  bagItem.touchChildren = true;
  bagItem:setPositionXY(skew[1]+poss[place][1],skew[2]+poss[place][2]);
  self.armature.display:addChild(bagItem);
  bagItem:addEventListener(DisplayEvents.kTouchTap,self.onScrollItemTap,self,bagItem);
  self.bagItems[place] = bagItem;

  local redDot = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
  redDot.name = "effect";
  redDot.touchEnabled = false;
  redDot.touchChildren = false;
  redDot:setPositionXY(75+bagItem:getPositionX(),75+bagItem:getPositionY());
  redDot:setVisible(false);
  self.armature.display:addChild(redDot);
  self.redDotsTabBTN[place]=redDot;

  --self:refreshFGOnTabByPlace(place);
end

function SrengthenAccordionFollow:refreshFGOnTab()
  -- if not self.isInitBag then
  --   return;
  -- end
  -- for i=1,6 do
  --   self:refreshFGOnTabByPlace(i);
  -- end
end

function SrengthenAccordionFollow:getLevelIsEnough(place)
  local data = self.context.equipmentInfoProxy:getEquipInfoByHeroIDAndPlace(self.generalID,place);
  local wuxing = analysis("Kapai_Kapaiku",self.context.heroHouseProxy:getGeneralData(self.generalID).ConfigId,"wuXing");
  local jinjie_data = analysis2key("Zhuangbei_Zhuangbeijinjiebiao","wuxing",wuxing,"equipmentId",data.ItemId);
  local level_need = jinjie_data.require;
  local bagItem = self.bagItems[place];
  return data.StrengthenLevel >= level_need;
end

function SrengthenAccordionFollow:refreshFGOnTabByPlace(place)
  -- local bagItem = self.bagItems[place];
  -- if not self:getLevelIsEnough(place) and self.context.panels[2] and self.context.panels[2]:isVisible() then
  --   if not bagItem.level_is_enough_fg then
  --     bagItem.level_is_enough_fg = SrengthenBagItemLevelIsNotEnough.new();
  --     bagItem.level_is_enough_fg:initialize(self.context);
  --     bagItem.level_is_enough_fg:setPositionXY(-8,100);
  --     bagItem.grid_over_layer:addChild(bagItem.level_is_enough_fg);
  --   end
  --   bagItem.level_is_enough_fg:setVisible(true);
  --   bagItem.touchEnabled = false;
  --   bagItem.touchChildren = false;
  -- elseif bagItem.level_is_enough_fg then
  --   bagItem.level_is_enough_fg:setVisible(false);
  --   bagItem.touchEnabled = true;
  --   bagItem.touchChildren = true;
  -- end
end

function SrengthenAccordionFollow:onScrollItemTap(event, bagItem)
  if itemSlotSelected then
    self:setSelected(false, itemSlotSelected);
  end
  itemSlotSelected = bagItem;
  self:setSelected(true, itemSlotSelected);

  self.context.onBagItemTap(self.context,event,itemSlotSelected);
end

function SrengthenAccordionFollow:getBagItem()
  return itemSlotSelected;
end

function SrengthenAccordionFollow:setSelected(bool, bagItem)
  if not bagItem then
    return;
  end
  if bool then
    bagItem.grid_over = self.skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_over");
    bagItem.grid_over:setPositionXY(-11,-11);
    bagItem.grid_over_layer:addChild(bagItem.grid_over);
  else
    if bagItem.grid_over and not bagItem.grid_over.isDisposed then
      bagItem.grid_over_layer:removeChild(bagItem.grid_over);
      bagItem.grid_over = nil;
    end
  end
end

function SrengthenAccordionFollow:refreshByStrengthen(itemId)
  local bool;
  local place = analysis("Zhuangbei_Zhuangbeipeizhibiao",itemId,"place");
  if itemSlotSelected == self.bagItems[place] then
    bool = true;
    if itemSlotSelected then
      self:setSelected(false, itemSlotSelected);
    end
    itemSlotSelected = nil;
  end
  self:addBagItem(place);
  if bool then
    self:onScrollItemTap(nil,self.bagItems[place]);
  end
  self:refreshRedDot();
end

function SrengthenAccordionFollow:refreshByJinjie(itemId)
  self:refreshByStrengthen(itemId);
end

function SrengthenAccordionFollow:cleanCache()
  itemSlotSelected = nil;
end

function SrengthenAccordionFollow:refreshRedDot()
  local hongdianData = self.context.heroHouseProxy:getHongdianData(self.generalID);
  local bool;
  if 1 == self.context.selected_button_num then
    bool = hongdianData.BetterEquip;
  elseif 2 == self.context.selected_button_num then
    bool = hongdianData.BetterJinjieEquip;
  end
  if bool then
    for k,v in pairs(self.redDotsTabBTN) do
      v:setVisible(1==bool[k]);
    end
  else
    for k,v in pairs(self.redDotsTabBTN) do
      v:setVisible(false);
    end
  end
end




SrengthenBagItemLevelIsNotEnough=class(Layer);

function SrengthenBagItemLevelIsNotEnough:ctor()
  self.class=SrengthenBagItemLevelIsNotEnough;
end

function SrengthenBagItemLevelIsNotEnough:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  SrengthenBagItemLevelIsNotEnough.superclass.dispose(self);
  self.armature:dispose();
end

function SrengthenBagItemLevelIsNotEnough:initialize(context)
  self.context = context;
  self.skeleton = self.context.skeleton;
  self:initLayer();

  local armature=self.skeleton:buildArmature("level_is_not_enough");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  local descb_1=createTextFieldWithTextData(self.armature:getBone("descb_1").textData,"强化等级");
  self.armature.display:addChild(descb_1);

  local descb_2=createTextFieldWithTextData(self.armature:getBone("descb_2").textData,"不足");
  self.armature.display:addChild(descb_2);
end
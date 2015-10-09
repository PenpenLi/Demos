SrengthenAccordionItem=class(Layer);

function SrengthenAccordionItem:ctor()
  self.class=SrengthenAccordionItem;
end

function SrengthenAccordionItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  SrengthenAccordionItem.superclass.dispose(self);
  self.armature:dispose();
end

function SrengthenAccordionItem:initialize(context, generalID)
	self.context = context;
  self.generalID = generalID;
  self.skeleton = self.context.skeleton;
	self:initLayer();
  
  local armature=self.skeleton:buildArmature("name_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  self:addEventListener(DisplayEvents.kTouchTap,self.context.onScrollItemTap,self.context,self);

  local generalData = self.context.heroHouseProxy:getGeneralData(generalID);
  self.name_item_bg=createTextFieldWithTextData(self.armature:getBone("name_item_bg").textData,1==generalData.IsMainGeneral and self.context.userProxy:getUserName() or analysis("Kapai_Kapaiku",generalData.ConfigId,"name"));
  self.armature.display:addChild(self.name_item_bg);

  self.level_descb = CartoonNum.new();
  self.level_descb:initLayer();
  self.level_descb:setData(generalData.Level,"common_number",40);
  self.level_descb:setScale(0.7);
  self.level_descb:setPositionXY(310,20);
  self.armature.display:addChild(self.level_descb);
end

function SrengthenAccordionItem:refreshOn6_2()
  local generalData = self.context.heroHouseProxy:getGeneralData(self.generalID);
  self.level_descb:setData(generalData.Level,"common_number",40);
end

function SrengthenAccordionItem:refreshRedDot()
  local hongdianData = self.context.heroHouseProxy:getHongdianData(self.generalID);
  local bool;
  if 1 == self.context.selected_button_num then
    bool = hongdianData.BetterEquip;
  elseif 2 == self.context.selected_button_num then
    bool = hongdianData.BetterJinjieEquip;
  end
  if bool then
    if not self.redDot then
      self.redDot = CommonSkeleton:getBoneTextureDisplay("commonImages/common_redIcon");
      self.redDot.name = "effect";
      self.redDot:setPositionXY(363,46);
      self.armature.display:addChild(self.redDot);
    end
    self.redDot:setVisible(true);
  else
    if self.redDot then
      self.redDot:setVisible(false);
    end
  end
end
PeibingKapaiPopupChosenItem=class(TouchLayer);

function PeibingKapaiPopupChosenItem:ctor()
  self.class=PeibingKapaiPopupChosenItem;
end

function PeibingKapaiPopupChosenItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  PeibingKapaiPopupChosenItem.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function PeibingKapaiPopupChosenItem:initialize(context, id)
  self:initLayer();
  self.context=context;
  self.id = id;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("chosen_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local grid = CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
  grid:setScale(0.6);
  grid:setPositionXY(20,13);
  self:addChild(grid);

  local bg = Image.new();
  bg:loadByArtID(analysis("Jinengkapai_Jinengkapai",self.id,"XTid"));
  bg:setScale(0.6);
  bg:setPositionXY(24,18);
  self:addChild(bg);

  self.right_list_bg=createTextFieldWithTextData(self.armature4dispose:getBone("right_list_bg").textData,"已选卡牌");
  self.armature4dispose.display:addChild(self.right_list_bg);
end
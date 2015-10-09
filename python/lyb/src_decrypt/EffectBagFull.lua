--

EffectBagFull=class(Layer);

function EffectBagFull:ctor()
  self.class=EffectBagFull;
end

function EffectBagFull:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	EffectBagFull.superclass.dispose(self);
end

function EffectBagFull:initialize()
  self:initLayer();
  self.touchEnabled=false;
  self.touchChildren=false;

  --骨骼
  local armature=CommonSkeleton:buildArmature("common_pannel_tip");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature.display;
  self:addChild(self.armature);

  self.num_descb=createTextFieldWithTextData(armature:getBone("pannel_tip_bg").textData,"满");
  self:addChild(self.num_descb);
end
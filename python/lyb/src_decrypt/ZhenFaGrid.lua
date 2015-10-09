
ZhenFaGrid=class(TouchLayer);

function ZhenFaGrid:ctor()
  self.class=ZhenFaGrid;
end

function ZhenFaGrid:dispose()
  self:removeAllEventListeners();
  ZhenFaGrid.superclass.dispose(self);
end

function ZhenFaGrid:initialize(context)

  self.context = context
  self:initLayer();
  self.skeleton = context.skeleton


  local armature=self.skeleton:buildArmature("grid");
  self.armature = armature;
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(self.armature_d)

end



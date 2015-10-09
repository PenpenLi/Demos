
AmassFortunesCardItem=class(TouchLayer);

function AmassFortunesCardItem:ctor()
  self.class=AmassFortunesCardItem;
  self.numValue = nil;
end

function AmassFortunesCardItem:dispose()
  self:removeAllEventListeners();
	self:removeChildren();
  AmassFortunesCardItem.superclass.dispose(self);
  self.removeArmature:dispose()
end

function AmassFortunesCardItem:initialize(skeleton, id)
  self:initLayer();
  self.skeleton=skeleton;
  --骨骼
  local armature=skeleton:buildArmature("amass_fortunes_card");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self:setTouchEnabled(false);

  self.numValue = id;
  --numText
  local text_data=armature:getBone("num").textData;
  self.numText=createTextFieldWithTextData(text_data, id);
  self.armature:addChild(self.numText);

end

function AmassFortunesCardItem:setData(value)
  self.numValue = value;
  self.numText:setString(value);
end

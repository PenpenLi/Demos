require "core.controls.Image";
require "main.common.CommonExcel";
require "core.display.DisplayNode";

CurrencyDetailLayer=class(Layer);

function CurrencyDetailLayer:ctor()
  self.class=CurrencyDetailLayer;
end

function CurrencyDetailLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  CurrencyDetailLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function CurrencyDetailLayer:initialize(skeleton, str)
  self:initLayer();

  local armature=skeleton:buildArmature("currency_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local numberData=armature:getBone("bag_item_name").textData;
  self.currency_num=createTextFieldWithTextData(numberData,str);
  self.armature:addChild(self.currency_num);
end
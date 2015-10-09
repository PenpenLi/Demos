require "core.controls.Image";
require "main.common.CommonExcel";
require "core.display.DisplayNode";

CurrencyItem=class(Layer);

function CurrencyItem:ctor()
  self.class=CurrencyItem;
end

function CurrencyItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  CurrencyItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function CurrencyItem:initialize(skeleton, textData, num)
  self:initLayer();

  local armature=skeleton:buildArmature("currency_bg_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local numberData=armature:getBone("currency_bg").textData;
  self.currency_num=createTextFieldWithTextData(numberData,num);
  self.armature:addChild(self.currency_num);
end

function CurrencyItem:setString(str)
  self.currency_num:setString(str);
end
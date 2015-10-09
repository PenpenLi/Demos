require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

PeerageLayer=class(Layer);

function PeerageLayer:ctor()
  self.class=PeerageLayer;
end

function PeerageLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PeerageLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function PeerageLayer:initialize(skeleton, context, userCurrencyProxy, userProxy)
  self:initLayer();
  self.skeleton=skeleton;
  self.context=context;
  self.userCurrencyProxy=userCurrencyProxy;
  self.userProxy=userProxy;
  self.const_item_num=5;
  
  local armature=skeleton:buildArmature("peerage_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local viewSize=self.skeleton:getBoneTextureDisplay("peerage_item_bg"):getContentSize();

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(self.armature:getChildByName("scroll_pos"):getPosition());
  self.item_layer:setViewSize(makeSize(viewSize.width,
                                       self.const_item_num*viewSize.height));
  self.item_layer:setItemSize(viewSize);
  self.armature:addChild(self.item_layer);

  local a=2;
  while analysisHas("Wujiang_Juewei",a) do
    local item=PeerageItem.new();
    item:initialize(self.skeleton,self,self.userCurrencyProxy,a);
    -- item.touchEnabled=false;
    -- item.touchChildren=false;
    self.item_layer:addItem(item);
    a=1+a;
  end

  --peerage_descb
  local text="声望: " .. self.userCurrencyProxy:getPrestige();
  local text_data=armature:getBone("peerage_descb").textData;
  local peerage_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(peerage_descb);

  --common_copy_bluelonground_button
  local common_copy_bluelonground_button=self.armature:getChildByName("common_copy_bluelonground_button");
  local common_copy_bluelonground_button_pos=convertBone2LB4Button(common_copy_bluelonground_button);
  self.armature:removeChild(common_copy_bluelonground_button);

  --common_copy_bluelonground_button
  common_copy_bluelonground_button=CommonButton.new();
  common_copy_bluelonground_button:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  common_copy_bluelonground_button:initializeText(armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_copy_bluelonground_button").textData,"声望商城");
  common_copy_bluelonground_button:setPosition(common_copy_bluelonground_button_pos);
  common_copy_bluelonground_button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
  self:addChild(common_copy_bluelonground_button);
  
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  self:addEventListener("UPGRADE_PEERAGE",self.upgradePeerage,self);
end

function PeerageLayer:onSelfTap(event)
  self.parent.popup_boolean=true;
end

function PeerageLayer:onButtonTap(event)
  self.parent:dispatchEvent(Event.new("openPrestigeShop", {tabID = 6}, self));
end

function PeerageLayer:upgradePeerage(evt)
  self.context:dispatchEvent(Event.new("UPGRADE_PEERAGE",evt.data));
end
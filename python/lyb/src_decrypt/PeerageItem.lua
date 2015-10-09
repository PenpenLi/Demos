require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

PeerageItem=class(Layer);

function PeerageItem:ctor()
  self.class=PeerageItem;
end

function PeerageItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PeerageItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function PeerageItem:initialize(skeleton, context, userCurrencyProxy, id)
  self:initLayer();
  self.context = context;
  
  local armature=skeleton:buildArmature("peerage_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self.touchEnabled = true;
  self.touchChildren = true;

  local peerage_name_pos=self.armature:getChildByName("peerage_name"):getPosition();
  local peerage_state_pos=self.armature:getChildByName("peerage_state"):getPosition();
  local item_size=self.armature:getChildByName("peerage_item_bg"):getContentSize();

  local a=Image.new();
  a:loadByArtID(analysis("Wujiang_Juewei",id,"artid"));
  a:setPositionXY(peerage_name_pos.x,item_size.height/2-a:getContentSize().height/2);
  self.armature:addChild(a);

  --peerage_descb
  local text=analysis("Wujiang_Juewei",id,"prestige");
  local text_data=armature:getBone("peerage_descb").textData;
  local peerage_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(peerage_descb);

  -- print(id,self.context.userProxy:getNobility())
  if id > self.context.userProxy:getNobility() then 
    if analysis("Wujiang_Juewei",id,"prestige")<=userCurrencyProxy:getPrestige() and id == self.context.userProxy:getNobility() +1 then
      local button = CommonButton.new();
      button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
      button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
      local textData = skeleton:buildCommonArmature("common_blueround_button",true):getBone("common_blueround_button").textData
      button:initializeText(textData,"提升");
      button:setPositionXY(peerage_state_pos.x,peerage_state_pos.y/2);
      self.armature:addChild(button);
    else
      local peerage_state=skeleton:getBoneTextureDisplay("peerage_state_1");
      peerage_state:setPositionXY(peerage_state_pos.x,item_size.height/2-peerage_state:getContentSize().height/2);
      self.armature:addChild(peerage_state);
    end
  elseif id <= self.context.userProxy:getNobility() then
    local peerage_state=skeleton:getBoneTextureDisplay("peerage_state_2");
    peerage_state:setPositionXY(peerage_state_pos.x,item_size.height/2-peerage_state:getContentSize().height/2);
    self.armature:addChild(peerage_state);
  end
end

function PeerageItem:onButtonTap(evt)
  evt.target.touchChildren = false;
  self.context:dispatchEvent(Event.new("UPGRADE_PEERAGE",self.id));
end
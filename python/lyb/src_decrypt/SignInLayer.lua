--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.activity.ui.SignInLayerItem";

SignInLayer=class(TouchLayer);

function SignInLayer:ctor()
  self.class=SignInLayer;
end

function SignInLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	SignInLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function SignInLayer:initialize(skeleton, activityProxy, countControlProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.countControlProxy=countControlProxy;
  self.parent_container=parent_container;
  self.request=nil;
  self.items={};
  self.finished_imgs={};
  self.boxes={};
  self.service={};
  self.box_effects={};
  self.touch_layers={};
  
  --骨骼
  local armature=skeleton:buildArmature("sign_in_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self.armature:removeChildAt(1);
  self:addChild(self.armature);

  local text="1月刷1次，每天可以翻1张牌，每一排全部翻开有额外奖励哟";
  local textField=createTextFieldWithTextData(armature:getBone("descb").textData,text);
  self.armature:addChild(textField);

  local a=0;
  while 4>a do
    a=1+a;
    local box=self.armature:getChildByName("common_copy_box_close_" .. a);
    --box:addEventListener(DisplayEvents.kTouchBegin,self.onBoxBegin,self);
    --box:addEventListener(DisplayEvents.kTouchEnd,self.onBoxEnd,self);
    box:addEventListener(DisplayEvents.kTouchTap,self.onBoxTap,self,a);
    table.insert(self.boxes,box);

    local box_finished=self.skeleton:getCommonBoneTextureDisplay("common_box_open");
    box_finished:setPosition(convertBone2LB(box));
    box_finished:setVisible(false);
    box_finished:addEventListener(DisplayEvents.kTouchTap,self.onOpenBoxTap,self,a);
    self.armature:addChild(box_finished);
    table.insert(self.finished_imgs,box_finished);

    local effect=cartoonPlayer(EffectConstConfig.SING_IN_BOX,0,0,0,nil,0.7);
    effect.touchEnabled=false;
    effect.touchChildren=false;
    effect:setPositionXY(28+box:getPositionX(),-32+box:getPositionY());
    effect:setVisible(false);
    self.armature:addChild(effect);
    table.insert(self.box_effects,effect);

    local layer=LayerColor.new();
    layer:initLayer();
    layer:changeWidthAndHeight(60,60);
    layer:setColor(ccc3(0,0,0));
    layer:setOpacity(1);
    layer:setPosition(convertBone2LB(box));
    layer:setVisible(false);
    layer:addEventListener(DisplayEvents.kTouchTap,self.onBoxTap,self,a);
    self.armature:addChild(layer);
    table.insert(self.touch_layers,layer);
  end

  a=0;
  local b={"壹","贰","叁","肆"};
  while 4>a do
    a=1+a;
    local text=b[a] .. "行全开";
    local text_data=armature:getBone("common_copy_box_close_" .. a).textData;
    local text_field=createTextFieldWithTextData(text_data,text,true);
    self.armature:addChild(text_field);
  end

  a=0;
  while 28>a do
    a=1+a;
    local item=SignInLayerItem.new();
    item:initialize(self.skeleton,self.activityProxy,self.countControlProxy,self.armature:getChildByName("small_card_" .. a),a,self.parent_container);
    self.armature:addChild(item);
    table.insert(self.items,item);
  end

  self.parent_container:dispatchEvent(Event.new(ActivityNotifications.SIGN_IN_REQUEST_DATA,self.parent_container));
  initializeSmallLoading();
end

function SignInLayer:onBoxBegin(event)
  for k,v in pairs(self.boxes) do
    if event.target==v then
      --[[self.currency=AdaptableTip.new();
      self.currency:initialize(analysis("Huodongbiao_Qiandaolibao",k,"itemId") .. "," .. 1,event.globalPosition);
      self.parent_container:addChild(self.currency);]]
      return;
    end
  end
end

function SignInLayer:onBoxEnd(event)
  if self.currency then
    --self.currency.parent:removeChild(self.currency);
    --self.currency=nil;
  end
end

function SignInLayer:onBoxTap(event, k)
  --[[if 1==self.countControlProxy:getCurrentCountByID(CountControlConfig.SIGN_IN,k) then
  sharedTextAnimateReward():animateStartByString("已经领取过了哦 !");
  elseif not self.activityProxy:getFetchableByRow(k) then
  local c={"壹","贰","叁","肆"};
  sharedTextAnimateReward():animateStartByString("第" .. c[k] .. "行木有全开哦 !");]]
  if 1==self.countControlProxy:getCurrentCountByID(CountControlConfig.SIGN_IN,k) or not self.activityProxy:getFetchableByRow(k) then
    local currency=AdaptableTip.new();
    currency:initialize(analysis("Huodongbiao_Qiandaolibao",k,"itemId") .. "," .. 1,event.globalPosition);
    self.parent_container:addChild(currency);
  else
    if self.parent_container:getIsBagFull(1) then
      return;
    end
    if self.service[k] then
      return;
    end
    self.service[k]=true;
    self.parent_container:dispatchEvent(Event.new(ActivityNotifications.SIGN_IN_GET_ROW_BONUS,{ID=k},self.parent_container));
  end
end

function SignInLayer:onOpenBoxTap(event)
  sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_69));
end

--移除
function SignInLayer:onCloseButtonTap(event)
  
end

function SignInLayer:refresh()
  uninitializeSmallLoading();
  for k,v in pairs(self.finished_imgs) do
    if 1==self.countControlProxy:getCurrentCountByID(CountControlConfig.SIGN_IN,k) then
      self.boxes[k]:setVisible(false);
      self.box_effects[k]:setVisible(false);
      self.touch_layers[k]:setVisible(false);
      v:setVisible(true);
    elseif self.activityProxy:getFetchableByRow(k) then
      self.boxes[k]:setVisible(false);
      self.box_effects[k]:setVisible(true);
      self.touch_layers[k]:setVisible(true);
      v:setVisible(false);
    else
      self.boxes[k]:setVisible(true);
      self.box_effects[k]:setVisible(false);
      self.touch_layers[k]:setVisible(false);
      v:setVisible(false);
    end
  end
  for k,v in pairs(self.items) do
    v:refresh(self.request);
  end
  self.request=true;
end
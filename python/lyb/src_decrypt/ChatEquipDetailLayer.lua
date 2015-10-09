--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.ui.bagPopup.EquipDetailLayer";

ChatEquipDetailLayer=class(Layer);

function ChatEquipDetailLayer:ctor()
  self.class=ChatEquipDetailLayer;
end

function ChatEquipDetailLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ChatEquipDetailLayer.superclass.dispose(self);
end

function ChatEquipDetailLayer:initialize(skeleton, lookUpEquipmentData, context, func)
  self:initLayer();
  self.context=context;
  self.func=func;
  local tipBg=LayerColorBackGround:getBackGround();
  tipBg:setPositionXY(-1 * GameData.uiOffsetX,-1 * GameData.uiOffsetY);
  tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(tipBg);
  local item=BagItem.new();
  item:initialize({GeneralId=lookUpEquipmentData.GeneralId,ItemId=lookUpEquipmentData.ItemId,Count=1,IsBanding=0,IsUsing=0,Place=0});
  local layer=EquipDetailLayer.new();
  layer:initialize(skeleton,item,false,lookUpEquipmentData);
  local size=Director:sharedDirector():getWinSize();
  local popupSize=layer.armature4dispose.display:getChildByName("common_background_1"):getContentSize();
  layer:setPositionXY(math.floor((size.width-popupSize.width)/2 - GameData.uiOffsetX),math.floor((size.height-popupSize.height)/2 - GameData.uiOffsetY));
  self:addChild(layer);
end

function ChatEquipDetailLayer:closeTip(event)
  if self.func then
    self.func(self.context);
  end
  if self.parent then
    self.parent:removeChild(self);
  end
end
--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-10

	yanchuan.xie@happyelements.com
]]

require "main.common.effectdisplay.EffectFigure";
require "main.common.effectdisplay.TextureScaleEffect";

MarkEffectLayer=class(Layer);

function MarkEffectLayer:ctor()
  self.class=MarkEffectLayer;
end

function MarkEffectLayer:dispose()
  self:stopAllActions();
  self:removeAllEventListeners();
  self:removeChildren();
  MarkEffectLayer.superclass.dispose(self);
  self.removeArmature:dispose();
end

function MarkEffectLayer:initialize(effectProxy, mark, markIncrease)
  self:initLayer();
  self.effectProxy=effectProxy;
  self.mark=mark;
  self.markIncrease=markIncrease;
  self.touchEnabled=false;
  self.touchChildren=false;

  local armature=self.effectProxy:getMarkSkeleton():buildArmature("effect_mark_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local mark=Layer.new();
  mark:initLayer();
  local t={};
  local s=tostring(self.mark);
  local n=0;
  local w=150;
  local scale=1.5--0.82;
  while n<string.len(s) do
    n=1+n;
    local sprite=self.effectProxy:getBasicSkeleton():getCommonBoneTextureDisplay("common_number_" .. string.sub(s,n,n));
    table.insert(t,sprite);
  end
  for k,v in pairs(t) do
    v:setScale(scale);
    v:setPositionX(w);
    w=scale*v:getContentSize().width+w;
    mark:addChild(v);
  end
  mark:setPositionXY(200,18);
  self:addChild(mark);

  local function cbf()
    self:onSelfTap();
  end

  local function actioncbf()
    local array=CCArray:create();
    array:addObject(CCDelayTime:create(0.5));
    array:addObject(CCEaseOut:create(CCMoveBy:create(0.3,makePoint(0,400)),0.3));
    array:addObject(CCCallFunc:create(cbf));
    self:runAction(CCSequence:create(array));
  end

  local increase_mark=EffectFigure.new();
  increase_mark:initialize(self.effectProxy,2,self.markIncrease,nil,actioncbf,true,false);
  --increase_mark:setScale(scale);
  increase_mark:setPositionXY(210+w,18);
  self:addChild(increase_mark);
  increase_mark:start();

  local armature_size=self:getGroupBounds().size;
  local size=Director:sharedDirector():getWinSize();
  self:setPositionXY((size.width-GameData.gameUIScaleRate*armature_size.width)/2,size.height-GameData.gameUIScaleRate*armature_size.height);
end

function MarkEffectLayer:onSelfTap(event)
  if self.callFunction then
    self.callFunction(self.context);
  end
  if self.parent then
    self.parent:removeChild(self);
  end
end
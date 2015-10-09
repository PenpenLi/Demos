--
-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- Create date: 2013-3-1

-- yanchuan.xie@happyelements.com


require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.utils.LayerColorBackGround";
require "core.skeleton.SkeletonFactory";
require "main.config.EffectConstConfig";
require "main.config.MainConfig";

CommonSmallLoading=class(Layer);

function CommonSmallLoading:ctor()
  self.class=CommonSmallLoading;
end

function CommonSmallLoading:dispose()
  self:removeChildren();
	self:removeAllEventListeners();
	CommonSmallLoading.superclass.dispose(self);
end

function CommonSmallLoading:initialize(id, key)
  self:initLayer();
  self.key = key;
  if nil==id or 1>id then
    id=1;
  end
  local text4load=9999==id and "" or analysis("Tishi_Loadingwenzi",id,"text");

  local armature=CommonSkeleton:buildArmature("common_small_loading");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature.display;
  self:addChild(self.armature);
  self.armature:removeChild(self.armature:getChildByName("common_blackHalfAlpha_bg"));
  self.armature:addChild(LayerColorBackGround:getTransBackGround());

  local text=createTextFieldWithTextData(armature:getBone("common_blackHalfAlpha_bg").textData,text4load, true);
  text.touchChildren=false;
  text.touchEnabled=false;
  self.armature:addChild(text);
	local width = text:getGroupBounds().size.width;
	local x = (Director.sharedDirector():getWinSize().width - width)/2;
	text:setPositionX(x);
  --local effect=cartoonPlayer(EffectConstConfig.SMALL_LOADING,self.armature:getChildByName("effect"):getPosition(),0);
  local size=Director:sharedDirector():getWinSize();
  local effect=cartoonPlayer(EffectConstConfig.SMALL_LOADING,size.width*0.5,size.height*0.5,0);
  effect.touchChildren=false;
  effect.touchEnabled=false;
  self.armature:addChild(effect);

  -- self:changeWidthAndHeight(size.width,size.height);
  -- self:setScale(GameData.gameUIScaleRate)
  commonAddToScene(self)
  -- self:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY)   
	-- local scene = Director.sharedDirector():getRunningScene();
	-- if scene then
	-- 	scene:addChild(self);
	-- end
end

function CommonSmallLoading:uninitialize(key)
  if self.parent and self.key == key then
    self.parent:removeChild(self);
  end
end
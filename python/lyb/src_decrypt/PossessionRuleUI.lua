--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-24

	yanchuan.xie@happyelements.com
]]

require "core.utils.CommonUtil";

PossessionRuleUI=class(Layer);

function PossessionRuleUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionRuleUI.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

--intialize UI
function PossessionRuleUI:initialize(skeleton)
  self:initLayer();
  self.tipBg=LayerColorBackGround:getTransBackGround();
  self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(self.tipBg);
  
  --骨骼
  local armature=skeleton:buildArmature("rule_pop");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text=analysis("Tishi_Guizemiaoshu",2,"txt");
  local text_data=armature:getBone("descb").textData;
  text_data.y = text_data.y;
  self.descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  self.armature:setPositionXY(30,130);
  self:addChild(self.armature);
end

function PossessionRuleUI:closeTip(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end
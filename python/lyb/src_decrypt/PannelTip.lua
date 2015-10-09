--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

PannelTip=class(Layer);

function PannelTip:ctor()
  self.class=PannelTip;
end

function PannelTip:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PannelTip.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function PannelTip:initialize(skeleton)
  self:initLayer();
  self.skeleton=skeleton;
  self.num=0;
  self.touchEnabled=false;
  self.touchChildren=false;

  --骨骼
  local armature=skeleton:buildArmature("pannel_tip");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.num_descb=createTextFieldWithTextData(armature:getBone("pannel_tip_bg").textData,self.num);
  self:addChild(self.num_descb);
  self:setVisible(false);
end

function PannelTip:onMsg(num)
  if nil==num then num=1; end
  self:setNum(num+self.num);
end

function PannelTip:onTap()
  self:setNum(0);
end

function PannelTip:refresh()
  self.num_descb:setString(99<self.num and "..." or self.num);
  self:setVisible(0~=self.num);
end

function PannelTip:getNum()
  return self.num;
end

function PannelTip:setNum(num)
  if 0>num then
    num=0;
  end
  self.num=num;
  self:refresh();
end
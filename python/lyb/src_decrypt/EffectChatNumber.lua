--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

EffectChatNumber=class(Layer);

function EffectChatNumber:ctor()
  self.class=EffectChatNumber;
end

function EffectChatNumber:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	EffectChatNumber.superclass.dispose(self);
end

function EffectChatNumber:initialize()
  self:initLayer();
  self.num=0;
  self.touchEnabled=false;
  self.touchChildren=false;

  --骨骼
  local armature=CommonSkeleton:buildArmature("common_pannel_tip");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature.display;
  self:addChild(self.armature);

  self.num_descb=createTextFieldWithTextData(armature:getBone("pannel_tip_bg").textData,self.num);
  self:addChild(self.num_descb);
  self:onTap();
end

function EffectChatNumber:onTap()
  self:setNum(0);
end

function EffectChatNumber:refresh()
  self:setNum(1+self.num);
end

function EffectChatNumber:setNumberDescb()
  self.num_descb:setString(5<self.num and "5.." or self.num);
  self:setVisible(0~=self.num);
end

function EffectChatNumber:getNum()
  return self.num;
end

function EffectChatNumber:setNum(num)
  if 0>num then
    num=0;
  end
  self.num=num;
  self:setNumberDescb();
end
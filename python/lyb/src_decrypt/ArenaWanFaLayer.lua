
ArenaWanFaLayer=class(Layer);

function ArenaWanFaLayer:ctor()
    self.class=ArenaWanFaLayer;
end

function ArenaWanFaLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ArenaWanFaLayer.superclass.dispose(self);
end

--intialize UI
function ArenaWanFaLayer:initialize(popUp)
    if self.popUp then return end;
    self.popUp = popUp;
      self:initLayer();
      local armature=popUp.skeleton:buildArmature("wanfa_ui");
      self.armature = armature;
      armature.animation:gotoAndPlay("f1");
      armature:updateBonesZ();
      armature:update();

      local armature_d=armature.display;
      self:addChild(armature_d);
      self.armature_d = armature_d;

      local bigBackground = LayerColorBackGround:getBackGround();
      self:addChild(bigBackground);
      bigBackground:setAlpha(255);
      bigBackground:addEventListener(DisplayEvents.kTouchTap,self.onCloseTap,self);

    local text_data = self.armature:getBone("des_text").textData;
    self.desText = createTextFieldWithTextData(text_data,"1、每次历史最高排名提高都会获得一定的元宝奖励。\n\n2、每天21：00会根据当前的排名发放排名奖励。\n\n3、奖励请通过邮件领取。\n\n4、VIP3及以上可以购买更多的挑战次数。\n\n5、VIP3及以上可以花费元宝清除挑战冷却时间。");
    self:addChild(self.desText);
end

function ArenaWanFaLayer:onCloseTap(event)
  -- print("vvvv")
    self.popUp.arenaLayer:removeWanfaLayer()
end

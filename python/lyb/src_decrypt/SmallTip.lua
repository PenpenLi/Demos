
SmallTip=class(Layer);

function SmallTip:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	SmallTip.superclass.dispose(self);

  BitmapCacher:removeUnused();
end


--intialize UI
function SmallTip:initialize(item_str, position, tipBgName,tipSize)--designated，tip显示的内容是指定的。
  self:initLayer();
  self.tipBg=LayerColorBackGround:getOpacityBackGround();
  self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self.tipBg:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY);
  self:addChild(self.tipBg);
  local a;
  local s = '<content><font color="#e1d2a0">' .. item_str .. '</font></content>';
  local n="commonBackgroundScalables/common_background_1";

  s = '<content><font color="#e1d2a0">' .. item_str .. '</font></content>';
  if tipBgName then
    n=tipBgName;
  else
    n="commonBackgroundScalables/common_background_1";
  end

  if not tipSize then
    tipSize = makeSize(270,90);
  end

  local tip= CommonSkeleton:getBoneTexture9DisplayBySize("commonBackgroundScalables/common_background_1",nil,tipSize);
  tip.touchEnabled=false;
  tip.touchChildren=false;

  local ret=createMultiColoredLabelWithTextData({x=0,y=0,width=tipSize.width,height=-5+tipSize.height,lineType="single line",size=24,alignment=kCCTextAlignmentCenter,space=0,textType="static"},s);
  local retSize=ret:getContentSize();
  ret:setPositionY(-3+(tipSize.height-retSize.height)/2);

  tip:addChild(ret);
  tip:setPosition(getTipPosition(tip,position));
  self:addChild(tip);
end

function SmallTip:closeTip(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end
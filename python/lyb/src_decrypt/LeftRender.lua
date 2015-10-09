
LeftRender=class(TouchLayer);

function LeftRender:ctor()
  self.class=LeftRender;
end

function LeftRender:dispose()
  self:removeAllEventListeners();
  LeftRender.superclass.dispose(self);
end

function LeftRender:initialize(context,img,id,booleanValue)
  self.id=id
  self.name=name
  self.context=context
  self:initLayer();
  self.skeleton = context.skeleton

  local armature=self.skeleton:buildArmature("leftrender");
  self.armature = armature;
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  local armature_d=armature.display;

  self.frame=context.skeleton:getBoneTextureDisplay("frame")
  print("------------------------self.frame", self.frame);
  self:addChild(self.frame)
  self.frame.touchEnabled = false;
  self.frame:setVisible(false)
  

  self.reddot=armature_d:getChildByName("reddot");
  self.reddot:setAnchorPoint(ccp(0.5, 0.5))
  self.reddot:setPosition(ccp(14, 147))
  self:addChild(self.reddot)
  self.reddot.touchEnabled = false;

  if booleanValue == 1 then
    self.reddot:setVisible(true)
  else
    self.reddot:setVisible(false)
  end
  

  self.img=Image.new()
  self.img:loadByArtID(img)
  self:addChildAt(self.img,0)
  self:setContentSize(makeSize(162,162));
  self.touchEnabled = true;
  self.touchChildren = true;
  self:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self);
end
function LeftRender:onTapBegin(event)
  self.tapitembegin=event.globalPosition
  self:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self);
end
function LeftRender:onTapEnd(event)
  if self.tapitembegin and (math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
  self.context.channel=self.id
  sendMessage(29,2,{ID=self.id})
  print("LeftRender:onTapEnd self.id", self.id)
  end
end

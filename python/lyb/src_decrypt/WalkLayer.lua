
WalkLayer = class(Layer);

function WalkLayer:ctor()
  self.class = WalkLayer;
end

function WalkLayer:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	WalkLayer.superclass.dispose(self);
end

function WalkLayer:onInit()    
  self:initLayer();

end


function WalkLayer:addEffect(artId)    
  local xPos, yPos
  if artId == StaticArtsConfig.MAIN_SCENE_BACK_BG_4 then
    xPos, yPos = 624, 459
    self.dengLongEffect = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_DENGLONG_BUTTON, xPos, yPos, 0)
    self:addChild(self.dengLongEffect)

    xPos, yPos = 949, 319
    self.shuiWenEffect = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_SHUIWEN_BUTTON, xPos, yPos, 0)
    self:addChild(self.shuiWenEffect)

  end

end

function WalkLayer:clean()
  self:removeChildren();
end

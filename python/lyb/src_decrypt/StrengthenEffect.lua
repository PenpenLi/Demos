require "main.common.effectdisplay.TextureScaleEffect";

StrengthenEffect=class();

function StrengthenEffect:ctor()
  self.class=StrengthenEffect;
end

function StrengthenEffect:initialize(id, parent, pos)
  local texture = Image.new();
  texture:loadByArtID(id);
  texture:setAnchorPoint(ccp(0.5,0.5));
  texture:setScaleX(5);
  texture:setPosition(pos);
  parent:addChild(texture);

  local function onEnd()
    parent:removeChild(texture);
  end

  local function callfunc()
    parent:removeChild(self.scale_effect);
    self.scale_effect = nil;

    local array = CCArray:create();
    array:addObject(CCDelayTime:create(0.3));
    array:addObject(CCCallFunc:create(onEnd));
    texture:runAction(CCSequence:create(array));
  end

  local function onSequenceEnd()
    -- texture:setVisible(false);

    local texture2 = Image.new();
    texture2:loadByArtID(id);
    texture2:setOpacity(125);

    self.scale_effect = TextureScaleEffect.new();
    self.scale_effect:initialize(texture2,5);
    self.scale_effect:setPosition(pos);
    parent:addChild(self.scale_effect);
    self.scale_effect:start(0.3,1,0,nil,callfunc);
  end

  local sequenceArray = CCArray:create();
  sequenceArray:addObject(CCEaseSineOut:create(CCScaleTo:create(0.2, 1, 1)));
  sequenceArray:addObject(CCDelayTime:create(0.1));
  sequenceArray:addObject(CCCallFunc:create(onSequenceEnd));
  texture:runAction(CCSequence:create(sequenceArray));
end
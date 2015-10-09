
require "core.utils.class";
require "core.events.EventDispatcher";
require "core.display.DisplayNode";

Common9GridSprite=class(DisplayNode);

function Common9GridSprite:ctor(sprite)
  self.class = Sprite;
  self.sprite = sprite;

  self.pivotX = 0;
  self.pivotY = 0;
  
  if self.sprite then
    self.sprite:retain();
    self.sprite:setAnchorPoint(CCPointMake(0,0));
  end
end

function Common9GridSprite:disposeSprite()
  if self.list then
    for i, v in ipairs(self.list) do v:dispose() end;
    self.list = nil;
  end

  if self.sprite then
    self.sprite:release();
    self.sprite = nil;
  end
  self:cleanSelf();
end

function Common9GridSprite:dispose()
  self:disposeSprite();
end

function Common9GridSprite:setContentSize(size)
  self.sprite:setContentSize(size);
end
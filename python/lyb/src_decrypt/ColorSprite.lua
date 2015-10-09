
ColorSprite = class(Sprite);
function ColorSprite:ctor(sprite)
	self.class = ColorSprite;

    self.sprite = sprite;
	self.hitArea = nil; --not supported

	self.pivotX = 0;
	self.pivotY = 0;
	
    if self.sprite then
        self.sprite:retain();
        self.sprite:setAnchorPoint(CCPointMake(0,0));
    end
end


function ColorSprite:setHighLight(bool)
	self.sprite:setHighLight(bool);
end


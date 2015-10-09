require "core.utils.class"
require "core.events.EventDispatcher"
require "core.display.DisplayNode"

Sprite = class(DisplayNode);
function Sprite:ctor(sprite)
	self.class = Sprite;

    self.sprite = sprite;
	self.hitArea = nil; --not supported

	self.pivotX = 0;
	self.pivotY = 0;
	
    if self.sprite then
        self.sprite:retain();
        self.sprite:setAnchorPoint(CCPointMake(0,0));
    end
end
--cleanup默认不传表示清除纹理，传入false表示不清除纹理
function Sprite:disposeSprite(isCleanup)
	if self.list then
		for i, v in ipairs(self.list) do v:dispose() end;
		self.list = nil;
	end

    if self.sprite and isCleanup then
        --self.sprite:cleanup(); -- stop all actions? nor sure if it needed.
        self.sprite:release();
        self.sprite = nil;
    end

	self.hitArea = nil;

	self:cleanSelf();
end
--cleanup默认不传表示清除纹理，传入false表示不清除纹理
function Sprite:dispose(cleanup)
    local isCleanup = true;
    if cleanup ~= nil then isCleanup = cleanup end;
	self:disposeSprite(isCleanup);
end
function Sprite:toString()
	return string.format("Sprite [%s]", self.name and self.name or "nil");
end

function Sprite:changeCCSprite(sprite)
    if self.sprite == sprite then return end;

    self:__dirtyDisplayNode();
    
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
    self.sprite = sprite;
    if self.sprite then
        self.sprite:retain();
    end
    self:updatePivot();
end

--
-- public props ---------------------------------------------------------
--
--ccBlendFunc
function Sprite:getBlendFunc() return self.sprite:getBlendFunc() end
function Sprite:setBlendFunc(v) self.sprite:setBlendFunc(v) end	

--ccColor3B
function Sprite:getColor() return self.sprite:getColor() end
function Sprite:setColor(v) self.sprite:setColor(v) end
function Sprite:isOpacityModifyRGB() return self.sprite:isOpacityModifyRGB() end
function Sprite:setOpacityModifyRGB(v) self.sprite:setOpacityModifyRGB(v) end


--CCSpriteFrame
function Sprite:isFrameDisplayed(v) return self.sprite:isFrameDisplayed(v) end
function Sprite:setDisplayFrame(v) self.sprite:setDisplayFrame(v) end
function Sprite:displayFrame() return self.sprite:displayFrame() end
function Sprite:setUserData(v) self.sprite:setUserData(v) end

--CCRect
function Sprite:setTextureRect(v) self.sprite:setTextureRect(v) end
function Sprite:getTextureRect() return self.sprite:getTextureRect() end
--CCRect rect, bool rotated, CCSize size
function Sprite:setTextureRect2(rect, rotated, size) self.sprite:setTextureRect(rect, rotated, size) end

-- only for CCSpriteExt
-- void setTransformMatrix(CCAffineTransform trasformMatrix);
function Sprite:setTransformMatrix(v) self.sprite:setTransformMatrix(v) end;
function Sprite:setActionManager(v) self.sprite:setActionManager(v) end;
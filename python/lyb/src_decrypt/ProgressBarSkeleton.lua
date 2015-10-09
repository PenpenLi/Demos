
ProgressBarSkeleton = class(DisplayNode);
function ProgressBarSkeleton:ctor(skeleton, textureName)
    self.bone  = skeleton:getBoneTextureDisplay(textureName)
    self.originalRect = self.bone:getTextureRect()
    self.sprite = self.bone.sprite
    self.sprite:retain();
    self.sprite:setAnchorPoint(CCPointMake(0, 0));
    self.touchEnabled = false;
    self.touchChildren = false;
end

function ProgressBarSkeleton:dispose()
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
    ProgressBarSkeleton.superclass.dispose(self);
end

function ProgressBarSkeleton:updateLayout(flag)
    local transformedWidth = self.percent * self.originalRect.size.width;
    local textureRect = nil
    if flag == "right" then
        textureRect = CCRectMake(self.originalRect.origin.x + self.originalRect.size.width - transformedWidth, self.originalRect.origin.y, transformedWidth, self.originalRect.size.height)
    elseif flag == "top" then
        local transformedHeight = self.percent * self.originalRect.size.height;
        textureRect = CCRectMake(self.originalRect.origin.x, self.originalRect.origin.y, self.originalRect.size.width, transformedHeight)
    else
        textureRect = CCRectMake(self.originalRect.origin.x, self.originalRect.origin.y, transformedWidth, self.originalRect.size.height)
    end
    
    self.bone.sprite:setTextureRect(textureRect,false,textureRect.size);
end

function ProgressBarSkeleton:getProgress() return self.percent end
function ProgressBarSkeleton:setProgress(v,flag)
    local v_ = v;
    if v <= 0.000001 then v_ = 0 end;
    if v >= 1.0 then v_ = 1 end;
 
    if self.percent ~= v_ then
        self.percent = v_;
        self:updateLayout(flag);
    end
end


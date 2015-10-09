require "core.utils.class"
require "core.events.EventDispatcher"


ProgressBar = class(EventDispatcher);
function ProgressBar:ctor(armature, progressBoneName)
	self.class = Button;
    self.armature = armature;
    self.percent = 1;
    self.originalRect = DisplayBounds.new(); -- {0,0,0,0}
    self.progressBone = nil;
    self.oldPositionX = 0
    
    local progressBoneName_ = progressBoneName or "pro_up";
    self.progressBone = armature:getBone(progressBoneName_);
    if self.progressBone then
        local display = self.progressBone:getDisplay();
        local bounds = display:getContentSize();
        
        self.oldPositionX = display:getPositionX()
        self.oldPositionY = display:getPositionY()
        
        local textureRect = display:getTextureRect();
        self.oldOriginX = textureRect.origin.x
        self.oldOriginY = textureRect.origin.y
        self.originalRect.width = bounds.width;
        self.originalRect.height = bounds.height;
    end 
    
end

function ProgressBar:dispose()
    bone.bone = nil;
	self:removeSelf();
end

function ProgressBar:setBarColor(color)
    self.progressBone:getDisplay():setColor(ccc3(color, color, color));
end

function ProgressBar:updateLayout(flag)
    if self.progressBone then
        local display = self.progressBone:getDisplay();
        local textureRect = display:getTextureRect();
        local transformedWidth = self.percent * self.originalRect.width;
        
        if (flag == "right") then
          textureRect = CCRectMake(self.oldOriginX + self.originalRect.width - transformedWidth, textureRect.origin.y, transformedWidth,self.originalRect.height)
          display:setPositionXY(self.oldPositionX + self.originalRect.width - transformedWidth,self.oldPositionY)
        elseif  flag == "top" then
            local transformedHeight = self.percent * self.originalRect.height;
            textureRect = CCRectMake(textureRect.origin.x, self.oldOriginY + self.originalRect.height - transformedHeight, self.originalRect.width, transformedHeight)
            display:setPositionXY(self.oldPositionX,self.oldPositionY - self.originalRect.height + transformedHeight)
        else
          textureRect = CCRectMake(textureRect.origin.x, textureRect.origin.y, transformedWidth, self.originalRect.height)
        end
        
        display:setTextureRect2(textureRect,false,textureRect.size);
    end 
end

function ProgressBar:getProgress() return self.percent end
function ProgressBar:setProgress(v,flag)
    local v_ = v;
    if v <= 0.000001 then v_ = 0 end;
    if v >= 1.0 then v_ = 1 end;
 
    if self.percent ~= v_ then
        self.percent = v_;
        self:updateLayout(flag);
    end
end


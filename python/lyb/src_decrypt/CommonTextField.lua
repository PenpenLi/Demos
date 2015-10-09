require "core.display.Sprite"

CommonTextField = class(Sprite);
function CommonTextField:ctor(sprite, isSupportTextChange)
    --super
    self.isSupportTextChange = true;
    if isSupportTextChange ~= nil then self.isSupportTextChange = isSupportTextChange end;
    
    self.textData = nil;
    self.string = nil;
    self.stroke = nil;
    self.strokeColor = nil;
end

function CommonTextField:getString()
    if not self.isSupportTextChange then return end;
    return self.string;
end
function CommonTextField:setString(v, force)
    if not self.isSupportTextChange then return end;
    if self.string==v and not force then return end;
    local par=self.parent;
    local pos=self:getPosition();
    local idx;
    if par then
        idx=par:getChildIndex(self);
        par:removeChild(self,false);
    end
    if self.string~=v then
        self.string=v;
        self:changeCCSprite(CCLabelTTF:create(self.string,FontConstConfig.OUR_FONT,self.textData.size,CCSizeMake(self.textData.width,self.textData.height),self.textData.alignment));
        self.sprite:setColor(CommonUtils:ccc3FromUInt(self.textData.color));
    end
    if self.stroke then
        self:changeCCSprite(addLabelStroke1(self.sprite,1.0,self.strokeColor,75));
    end
    self:setPosition(pos);
    if par then
        par:addChildAt(self,idx);
    end
end

function CommonTextField:setStroke(bool, strokeColor)
    if self.stroke==bool and self.strokeColor==strokeColor then return; end
    self.stroke=bool;
    self.strokeColor=strokeColor;
    self:setString(self.string,true);
end
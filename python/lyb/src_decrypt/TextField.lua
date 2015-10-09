require "core.utils.class"
require "core.display.Sprite"


TextField = class(Sprite);
function TextField:ctor(sprite, isSupportTextChange)
    --super
    self.isSupportTextChange = true;
    if isSupportTextChange ~= nil then self.isSupportTextChange = isSupportTextChange end;
    
    self.textData = nil;
    self.string = nil;
    self.orignialPosition = nil;
	if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
        if sprite then
            if sprite.getString then
                local v = sprite:getString()
                local returnValue

                returnValue = getLuaCodeTranslated(v)


                if returnValue then
                     self.sprite:setString(returnValue);
                end
            elseif sprite.getLabel then
                local v = sprite:getLabel():getString()
                local returnValue

                returnValue = getLuaCodeTranslated(v)


                if returnValue then
                     self.sprite:setString(returnValue);
                end
            end
        end
    end
end

function TextField:getString()
    if not self.isSupportTextChange then return end;
    return self.sprite:getString();
end
function TextField:setString(v, data)
    if not self.isSupportTextChange then return end;

    local returnValue
    if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
        returnValue = getLuaCodeTranslated(v)
       
    end

    if returnValue then
        v = returnValue
    end

    if self.string ~= v then
        self.string = v;
        if v then
            self.sprite:setString(v);
        else
            log("String can not be nil")
           -- error("String can not be nil")
        end
    end
    self.data=data;
end

--CCTextAlignment {kCCTextAlignmentLeft, kCCTextAlignmentCenter, kCCTextAlignmentRight}
function TextField:getHorizontalAlignment() 
    if not self.isSupportTextChange then return end;
    return self.sprite:getHorizontalAlignment(); 
end
function TextField:setHorizontalAlignment(v) 
    if not self.isSupportTextChange then return end;
    self.sprite:setHorizontalAlignment(v);
end

--CCVerticalTextAlignment {kCCVerticalTextAlignmentTop,kCCVerticalTextAlignmentCenter,kCCVerticalTextAlignmentBottom}
function TextField:getVerticalAlignment() 
    if not self.isSupportTextChange then return end;
    return self.sprite:getVerticalAlignment() 
end
function TextField:setVerticalAlignment(v) 
    if not self.isSupportTextChange then return end;
    self.sprite:setVerticalAlignment(v);
end

--CCSize
function TextField:getDimensions() 
    if not self.isSupportTextChange then return end;
    return self.sprite:getDimensions(); 
end
function TextField:setDimensions(v) 
    if not self.isSupportTextChange then return end;
    self.sprite:setDimensions(v);
end

function TextField:getFontSize() 
    if not self.isSupportTextChange then return end;
    return self.sprite:getFontSize();
end
function TextField:setFontSize(v) 
    if not self.isSupportTextChange then return end;
    self.sprite:setFontSize(v);
end

function TextField:getFontName() 
    if not self.isSupportTextChange then return end;
    return self.sprite:getFontName(); 
end
function TextField:setFontName(v) 
    if not self.isSupportTextChange then return end;
    self.sprite:setFontName(v); 
end

function TextField:ajustAlignment()
    local textSize = self:getContentSize();
    local textPosition = self:getPosition();
    local x__ = textPosition.x;
    local y__ = textPosition.y;
    
    if not self.orignialPosition then 
        self.orignialPosition = {x=x__, y=y__};
    else 
        x__ = self.orignialPosition.x;
        y__ = self.orignialPosition.y;
    end
    
    if self.textData.alignment == kCCTextAlignmentRight then
        --right
        self:setPositionX(x__ + self.textData.width - textSize.width);
    elseif self.textData.alignment == kCCTextAlignmentCenter then
        --center
        self:setPositionX(x__ + (self.textData.width - textSize.width) * 0.5);
    end
    
    self:setPositionY(y__ + (self.textData.height - textSize.height) * 0.5);
end


function addLabelStroke1(label, strokeSize, strokeColor, opacity)
    local layer = CCLayer:create();
    layer:setAnchorPoint(ccp(0,0));
    local stroke = CommonUtils:createStroke(label, strokeSize, strokeColor, opacity);
    layer:addChild(stroke);
    layer:addChild(label);
    return layer;
end

function addLabelStroke2(label, strokeColor1, strokeWith1,strokeColor2, strokeWith2)
    local layer = CCLayer:create();
    layer:setAnchorPoint(ccp(0,0));
    local stroke1 = CommonUtils:createStroke(label,strokeWith1, strokeColor1);
    local stroke2 = CommonUtils:createStroke(label,strokeWith2+strokeWith1, strokeColor2);
    layer:addChild(stroke2);
    layer:addChild(stroke1);
    layer:addChild(label);
    return layer;
end
function addLabelStroke3(label, strokeColor1, strokeWith1,strokeColor2, strokeWith2,strokeColor3, strokeWith3)
    local layer = CCLayer:create();
    layer:setAnchorPoint(ccp(0,0));
    local stroke1 = CommonUtils:createStroke(label,strokeWith1, strokeColor1);
    local stroke2 = CommonUtils:createStroke(label,strokeWith2+strokeWith1, strokeColor2);
    local stroke3 = CommonUtils:createStroke(label,strokeWith2+strokeWith1+strokeWith3, strokeColor3);
    layer:addChild(stroke3);
    layer:addChild(stroke2);
    layer:addChild(stroke1);
    layer:addChild(label);
    return layer;
end

function TextField:setGray(bool)
	if bool then
		if not self.usedColor then 
			self.usedColor = self.sprite:getColor();
			self.usedColor = ccc3(self.usedColor.r,self.usedColor.g,self.usedColor.b);
		end
		-- print(bool,self.usedColor.r,self.usedColor.g,self.usedColor.b)
		self.sprite:setColor(ccc3(125,125,125));
	else
		-- print(bool,self.usedColor.r,self.usedColor.g,self.usedColor.b)
		self.sprite:setColor(ccc3(self.usedColor.r,self.usedColor.g,self.usedColor.b));
	end
end

function TextField:getColor()
	local returnColor = self.sprite:getColor();
	-- print(returnColor.r,returnColor.g,returnColor.b)
	returnColor = ccc3(returnColor.r,returnColor.g,returnColor.b);
	return returnColor;
end

-- function TextField:setColor(colorValue)
--     if self.sprite then
--         self.sprite:setColor(colorValue);
--     end
-- end

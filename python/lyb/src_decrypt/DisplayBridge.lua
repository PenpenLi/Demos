require "core.display.Sprite"

-- initialize
--Provides an interface for display classes that can be used in this skeleton animation system.
DisplayBridge = class(Object);

function DisplayBridge:ctor()
	-- Sprite
	self.display = nil; --Indicates the original display object relative to specific display engine.
	self.textfield = nil;
	self.class = DisplayBridge;
end

function DisplayBridge:toString()
	return "DisplayBridge";
end

function DisplayBridge:dispose()
    if self.textfield then
        self.textfield:dispose();
        self.textfield = nil;
    end
    
	self.display = nil;
	self:removeSelf();
end

function DisplayBridge:getTextField() return self.textfield end

-- add a CCLabelTTF or other text display object. DisplayBridge will hold textfield's life cycle.
function DisplayBridge:setTextField(textfield, isAddChildToParent)
    if self.textfield == textfield then return end;
   
    local parent = nil;
    if self.textfield then
        parent = self.textfield:getParent();
        if parent then parent:removeChild(self.textfield, true) end;
        self.textfield:dispose();
        self.textfield = nil;
    end
    
    self.textfield = textfield;
    
    local isAddChildToParentNow = true;
    if isAddChildToParent ~= nil then isAddChildToParentNow = isAddChildToParent end;
    
    if isAddChildToParentNow then
        parent = self.display:getParent();
        if self.textfield and parent then
            parent:addChild(self.textfield);
        end
    end    
end

function DisplayBridge:setTextFieldSprite(ccsp, isAddChildToParent)
    if not self.textfield then return end;
    self.textfield:changeCCSprite(ccsp);
    local isAddChildToParentNow = false;
    if isAddChildToParent ~= nil then isAddChildToParentNow = isAddChildToParent end;
    
    if isAddChildToParentNow then
        parent = self.display:getParent();
        if self.textfield and parent then
            parent:addChild(self.textfield);
        end
    end
end

function DisplayBridge:setDisplay(value)
	if self.display == value then return end;

	local index = -1;
	local parent = nil;
	if self.display then
		parent = self.display:getParent();

		if parent then
			index = parent:getChildIndex(self.display);
		end

		self:removeDisplay(false);
	end
	self.display = value;

	if index < 0 then self:addDisplay(parent)
	else self:addDisplay(parent, index) end;
end

function DisplayBridge:updateNode(node, force)
	local dp = self.display;
	
    local px = node.x;
	local py = node.y;
	
    local sx = node.scaleX;
	local sy = node.scaleY;
	
	local kx = node.skewX;
	local ky = node.skewY;
	
	--[[
	if kx == 0 and ky == 180 then
	    sx = sx * -1;
	end	
	if ky == 0 and kx == 180 then
	    sy = sy * -1;
	end
	]]
	if "hit_area"==node.name then
	if sx == sy then
	    dp:setScale(sx, force);
	else
	    dp:setScaleX(sx, force);
	    dp:setScaleY(sy, force);
	end
	end
	--[[
    if kx ~= 0 and kx == ky then
        dp:setRotation(kx * -1, force);
	end
    ]]
    dp:setSkewX(kx, force);
    dp:setSkewY(ky, force);
	dp:setPositionXY(px, py, force);
end

--Adds the original display object to another display object.
function DisplayBridge:addDisplay(container, index)
	local i = index or -1;
	if container and self.display then
		if i < 0 then
			container:addChild(self.display);
		else
			container:addChildAt(self.display, i); --container.addChildAt(_display, Math.min(index, container.numChildren));
		end
	end
end

--remove the original display object from its parent.
function DisplayBridge:removeDisplay(cleanup)
	local isCleanup = true;
	if cleanup ~= nil then isCleanup = cleanup end;

	if self.display then
		local parent = self.display:getParent(); -- Sprite
		if parent then
			parent:removeChild(self.display, isCleanup);
		end
	end
end

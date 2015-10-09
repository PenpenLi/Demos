require "core.skeleton.Nodes"
require "core.skeleton.BoneData"
require "core.skeleton.Tween"
require "core.skeleton.Armature"
require "core.skeleton.DisplayBridge"
require "core.events.EventDispatcher"

-- initialize
--A object representing a single joint in an armature. It controls the transform of displays in it.
Bone = class(EventDispatcher);
function Bone:ctor(displayBridge)  
    self.displayBridge = displayBridge; -- of <DisplayBridge, CCSprite, etc, ...>,  
	self.tween = Tween.new(self);  -- of <Tween>
	
	self.name = nil; --The name of the Armature.
	self.userData = nil; --An object that can contain any extra data.

	self.origin = BoneData.new(); -- of <BoneData>
	self.globalZ = 0;
		
	self.children = {}; -- of <Bone>

	self.displayList = {};
	self.displayIndex = -1;
	self.displayVisible = false;
	
	self.textData = nil;
	self.visible = true;
	
	self.armature = nil; -- of <Armature>,  The armature holding this bone.
	self.parent = nil; -- of <Bone>,  Indicates the bone that contains this bone.

	self.class = Bone;
end

function Bone:toString()
	return "Bone";
end

function Bone:setParent(parent)
	local ancestor = parent;
	while ancestor and ancestor ~= self do
		ancestor = ancestor.parent;
	end

	if ancestor == self then
		error("An Bone cannot be added as a child to itself or one of its children (or children's children, etc.)");
	else
		self.parent = parent;
	end
end

function Bone:dispose()
    if self.children then
        for k, v in pairs(self.children) do
		    v:dispose();
	    end
	    self.children = nil;
    end
	if self.displayList then
        for k, v in pairs(self.displayList) do v:dispose() end;
        self.displayList = nil;
    end
    if self.displayBridge then
    	if self.displayBridge.display then
	    	self.displayBridge.display:dispose();
	    	self.displayBridge.display = nil
    	end
        self.displayBridge:dispose();
        self.displayBridge = nil;
    end
    
	self:setParent(nil);
	
	if self.tween then 
        self.tween:dispose() 
    end;

	self.userData = nil;
	self.origin = nil;
	
	self.tween = nil;
	self.armature = nil;
	self.parent = nil;
  
	self:removeSelf();
end
-- public methods

--The sub-armature of this bone.

function Bone:getChildArmature()
    local arm = self.displayList[self.displayIndex];
    if arm then
        if arm:is(Armature) then return arm end;
    end
    return nil;
end

-- Indicates the display object belonging to this bone.
function Bone:getDisplay()
	return self.displayBridge.display;
end

function Bone:setDisplay(value)
	if self.displayBridge.display == value then return end;

	self.displayList[self.displayIndex] = value;

	local display_ = value;

	if value and value:is(Armature) then
		display_ = value.display;
	end

	if display_ then display_.name = self.name end;

	self.displayBridge:setDisplay(display_);
end

function Bone:changeDisplay(displayIndex)
	local di = displayIndex or 1;
	if di < 0 then
		if self.displayVisible then
			-- hide it.
			self.displayVisible = false;
			self.displayBridge:removeDisplay(false);
		end
	else
		if not self.displayVisible then
			-- show
			self.displayVisible = true;
			if self.armature then
				self.displayBridge:addDisplay(self.armature.display, self.globalZ);
				self.armature.bonesIndexChanged = true;
			end
		end

		if self.displayIndex ~= di then
			self.displayIndex = di;
			--change display
			self:setDisplay(self.displayList[di]);
		end
	end
end

--Updates the state of the bone.
function Bone:update(force)
	--self.tween:update();

	local currentDisplay = self.displayBridge.display;
	local visiable = currentDisplay and self.displayVisible;
	if visiable then
        self.displayBridge:updateNode(self.origin, force);
        local childArmature = self:getChildArmature();
        if childArmature then childArmature:update(force) end;
    end

	--after update, child number meight changed.
	numberOfChild = table.getn(self.children);
	if numberOfChild > 0 then			
		for idx, kvc in pairs(self.children) do
			kvc:update();
		end
	end
end

function Bone:contains(child)
	for k, v in pairs(self.children) do
		if v == child then return true end;
	end
	return false;
end

function Bone:removeChild(child)
	local pos = -1;
	for i, v in ipairs(self.children) do
		if v == child then
			pos = i;
			break;
		end
	end

	if i ~= -1 then
		if self.armature then
			self.armature:removeFromBones(child);
		end
		child:setParent(nil);
		table.remove(self.children, pos);
	end
end

function Bone:removeFromParent()
	if self.parent then
		self.parent:removeChild(self);
	end
end

function Bone:addChild(child)
	local l = table.getn(self.children);
	local valid = true;
	if l > 0 then
        local cons = self:contains(child);
        valid = not cons;
    end

	if valid then
		child:removeFromParent();
		table.insert(self.children, child);
		child:setParent(self);

		if self.armature then
			self.armature:addToBones(child);
		end
	end
end

function Bone:isVisible() return self.visible end
function Bone:setVisible(v)
    if self.visible ~= v then
        self.visible = v;
        local sp = self:getDisplay();
        if sp then sp:setVisible(v) end;
    end
end

function Bone:hitTestPoint(globalPosition)
    if table.getn(self.displayList) > 0 then
        local display_ = self.displayList[1]; -- of sprite
        return display_:hitTestPoint(globalPosition, false, false);
    end 
    return false;
end

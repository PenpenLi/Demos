-------------------------------------------------------------------------
--  Class include: BoneData, DisplayData
-------------------------------------------------------------------------


require "core.skeleton.Nodes"

--
-- BoneData ---------------------------------------------------------
--

-- members
BoneData = class(SkeletonNode);

-- initialize
function BoneData:ctor()
	self.name = nil;
	self.parent = nil;
	self.textData = nil;
	self.displayList = {}; -- of <DisplayData>

	self.class = BoneData;
end
function BoneData:toString()
	return string.format("BoneData[name=%s, parent=%s, length=%d]",
	self.name and self.name or "nil",
	self.parent and self.parent or "nil", self:getDisplayLength());
end

-- public methods
function BoneData:dump()
	print(self:toNodeString());

	for k, v in pairs(self.displayList) do
		print("--", v:toString());
	end
end
function BoneData:toNodeString()
	return string.format("BoneData name=%s[x=%.2f,y=%.2f,z=%.2f,scaleX=%.2f,scaleY=%.2f,skewX=%.2f,skewY=%.2f]",
	self.name and self.name or "nil",
	self.x, self.y, self.z,
	self.scaleX, self.scaleY,
	self.skewX, self.skewY);
end

function BoneData:getDisplayLength()
	return table.getn(self.displayList);
end

function BoneData:dispose()
	self.displayList = nil;
	self.textData = nil;
	self:removeSelf();
end


function BoneData:copyBoneData(node)
	self:copyNode(node);

	self.name = node.name;
	self.parent = node.parent;
end

function BoneData:getDisplayDataAt(index)
	return self.displayList[index];
end


--
-- DisplayData ---------------------------------------------------------
--

-- initialize
DisplayData = class(Object);
function DisplayData:ctor()
	self.isArmature = false;
	self.name = nil;

	self.class = DisplayData;
end
function DisplayData:toString()
	return string.format("DisplayData[%s, %s]",
	self.name and self.name or "nil",
	self.isArmature and "true" or "false");
end
function DisplayData:dispose()
	self.name = nil;
	self:removeSelf();
end

-------------------------------------------------------------------------
--  Class include: SkeletonNode, TweenNode, TextData, FrameData
-------------------------------------------------------------------------


require "core.display.TextField"
require "core.display.ClippingNode"

--
-- SkeletonNode ---------------------------------------------------------
--

-- initialize
SkeletonNode = class(Object);
function SkeletonNode:ctor(x,y,z,scaleX,scaleY,skewX,skewY)
	self.x = x or 0;
	self.y = y or 0;
	self.z = z or 0;
	self.scaleX = scaleX or 1;
	self.scaleY = scaleY or 1;
	self.skewX = skewX or 0;
	self.skewY = skewY or 0;

	self.class = SkeletonNode;
end

function SkeletonNode:toString()
	return string.format("[x=%.2f,y=%.2f,z=%.2f,scaleX=%.2f,scaleY=%.2f,skewX=%.2f,skewY=%.2f]",
	self.x, self.y, self.z,
	self.scaleX, self.scaleY,
	self.skewX, self.skewY);
end

-- public methods
function SkeletonNode:getRotation()
	return self.skewY;
end

function SkeletonNode:setRotation(r)
	self.skewX = r;
	self.skewY = r;
end

function SkeletonNode:copyNode(node)
	self.x = node.x;
	self.y = node.y;
	self.z = node.z;
	self.scaleX = node.scaleX;
	self.scaleY = node.scaleY;
	self.skewX = node.skewX;
	self.skewY = node.skewY;
end


function SkeletonNode:getRealScaleX()
    if self.skewX == 0 and self.skewY == 180 then
	    return self.scaleX * -1;
	end	
	return self.scaleX;
end

function SkeletonNode:getRealScaleY()
    if self.skewX == 180 and self.skewY == 0 then
	    return self.scaleY * -1;
	end	
	return self.scaleY;
end

function SkeletonNode:getRealRotation()
    return self.skewX * -1;
    --[[
    if self.skewX ~= 0 and self.skewY == self.skewX then
	    return self.skewX;
	end
	return 0;
	]]
end

--
-- TweenNode ---------------------------------------------------------
--

-- initialize
TweenNode = class(SkeletonNode);
function TweenNode:ctor()
	self.tweenRotate = 0;

	self.class = TweenNode;
end

-- public methods
function TweenNode:subtract(from, to)
	self.x = to.x - from.x;
	self.y = to.y - from.y;
	self.scaleX = to.scaleX - from.scaleX;
	self.scaleY = to.scaleY - from.scaleY;
	self.skewX = to.skewX - from.skewX;
	self.skewY = to.skewY - from.skewY;

	local pi2 = math.pi * 2;

	self.skewX = self.skewX % pi2;
	self.skewY = self.skewY % pi2;

	--skewX
	if self.skewX > math.pi then
		self.skewX = self.skewX - pi2;
	end

	if self.skewX < -math.pi then
		self.skewX = self.skewX + pi2;
	end

	--skewY
	if self.skewY > math.pi then
		self.skewY = self.skewY - pi2;
	end

	if self.skewY < -math.pi then
		self.skewY = self.skewY + pi2;
	end

	--TweenNode
	if (self:is(TweenNode)) and (to.tweenRotate ~= 0) then
		self.skewX = self.skewX + to.tweenRotate + pi2;
		self.skewY = self.skewY + to.tweenRotate + pi2;
	end

end


--
-- TextData ---------------------------------------------------------
--

-- initialize
TextData = class();
function TextData:ctor()
    self.x = 0;
    self.y = 0;
	self.width = 0;
	self.height = 0;
	self.color = 0;
	self.size = 12;
	self.lineType = nil;
	self.textType = nil;
	self.alignment = nil;
    self.letterSpacing = nil;
	self.class = nil;
end

function TextData:toString()
	return string.format(" width=%d,height=%d, size=%d, alignment=%s",self.width,self.height,self.size,
	self.alignment and self.alignment or "nil");
end

--
-- FrameData ---------------------------------------------------------
--

-- initialize
FrameData = class(TweenNode);
function FrameData:ctor()
	self.duration = 1;
	self.tweenEasing = 0;
	self.displayIndex = 1;
	self.visible = true;
	self.movement = nil;
	self.event = nil;

	self.class = FrameData;
end

function FrameData:toString()
	local baseString = string.format("FrameData [x=%.2f,y=%.2f,z=%.2f,scaleX=%.2f,scaleY=%.2f,skewX=%.2f,skewY=%.2f]",
	self.x, self.y, self.z,
	self.scaleX, self.scaleY,
	self.skewX, self.skewY);

	local frameString = string.format(" duration=%.2f,tweenEasing=%.2f, tweenRotate=%.2f, displayIndex=%.2f,movement=%s,event=%s",
	self.duration,
	self.tweenEasing and self.tweenEasing or 0,
	self.tweenRotate and self.tweenRotate or 0,
	self.displayIndex,
	self.movement and self.movement or "nil",
	self.event and self.event or "nil");
	return baseString..frameString;
end
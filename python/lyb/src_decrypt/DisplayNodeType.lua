-------------------------------------------------------------------------
--  Class include: DisplayBounds, DisplayNode, TouchResult[internal use only]
-------------------------------------------------------------------------

require "core.utils.class"
require "core.events.EventDispatcher"

DisplayNodeType = {kLayer = 1, kScene = 2, kRootLayer = 3, kOthers = 4}
local kHitAreaObjectName = "hit_area";
local kHitAreaObjectTag = -100;
--
-- DisplayBounds ---------------------------------------------------------
--
DisplayBounds = class();
function DisplayBounds:ctor(x,y,w,h)
    self.x = x or 0;
    self.y = y or 0;
    self.width = w or 0;
    self.height = h or 0;    
end

function DisplayBounds:toRect()
    return CCRectMake(self.x,self.y, self.width, self.height);
end

function DisplayBounds:toString()
	return string.format("DisplayBounds [x=%d,y=%d,w=%d,h=%d]", self.x, self.y, self.width, self.height);
end

function DisplayBounds:mergeBound(b)
	local minX, minY, maxX, maxY = self.x, self.y, self.x + self.width, self.y + self.height;
    local vx, vy, vw, vh = b.x, b.y, b.x + b.width, b.y + b.height;           
    if vx < minX then minX = vx end;
    if vy < minY then minY = vy end;
    if vw > maxX then maxX = vw end;
    if vh > maxY then maxY = vh end;
    self.x, self.y, self.width, self.height = minX, minY, maxX - minX, maxY - minY;
end

function DisplayBounds:mergeBounds(list)
	local minX, minY, maxX, maxY = self.x, self.y, self.x + self.width, self.y + self.height;
    for i, v in ipairs(list) do
        local vx, vy, vw, vh = v.x, v.y, v.x + v.width, v.y + v.height;       
        if vx < minX then minX = vx end;
        if vy < minY then minY = vy end;
        if vw > maxX then maxX = vw end;
        if vh > maxY then maxY = vh end;
    end
    self.x, self.y, self.width, self.height = minX, minY, maxX - minX, maxY - minY;
end

kZeroDisplayBound = DisplayBounds.new(0,0,1,1);

--
-- DisplayNode ---------------------------------------------------------
--

DisplayNode = class(EventDispatcher);
function DisplayNode:ctor(sprite)
	self.class = DisplayNode;
    self.sprite = sprite;
    self.parent = nil;
    
	self.x = 0;
	self.y = 0;
	self.scaleX = 1;
	self.scaleY = 1;
	self.skewX = 0;
	self.skewY = 0;
	self.rotation = 0;
	self.opacity = 1;
	self.visible = true;
	self.nodeType = DisplayNodeType.kOthers; --for faster compare then class:is();

    self.anchorX = 0;
	self.anchorY = 0;
	
    self.touchEnabled = true;
    self.touchChildren = true;
    
	self.index = 0; -- [0 - getNumOfChildren]
	self.list = {};
	self.name = nil;

    self.bounds = nil;
    self.isDisposed = false;
    
    self.computeGroupBoundsFunc = nil;
    
    self.__touchHelper = 0;
    
end
function DisplayNode:toString()
	return string.format("DisplayNode [%s]", self.name and self.name or "nil");
end

function DisplayNode:cleanSelf()
    --print("cleanSelf");
	if self.list then
		for i, v in ipairs(self.list) do 
      v:dispose() 
    end;
		self.list = nil;
	end
	--[[
	if self.name == "panel_star_light" then
	    print("remove",self.name);
	end
]]
	self.sprite = nil;
	self.name = nil;
	self.parent = nil;
	self.bounds = nil;
	self.computeGroupBoundsFunc = nil;
	
	self.isDisposed = true;
	self:removeSelf();
end

function DisplayNode:dispose()
    self:cleanSelf();
end

function DisplayNode:__dirtyDisplayNode()
    self.bounds = nil;
end

local _updatePivotPoint = nil;
function DisplayNode:updatePivot()
	if self.sprite then 
		if not _updatePivotPoint then
			_updatePivotPoint = CCPoint:new(0, 0);
		end
		_updatePivotPoint.x = self.anchorX;
		_updatePivotPoint.y = self.anchorY;
		self.sprite:setAnchorPoint(_updatePivotPoint) 
	end;
end

--
-- public props ---------------------------------------------------------
--
function DisplayNode:isRunning() return self.sprite:isRunning() end
function DisplayNode:getCCParent() return self.sprite:getParent() end
function DisplayNode:getZOrder() return self.sprite:getZOrder() end
function DisplayNode:getNumOfChildren() return table.getn(self.list) end;
function DisplayNode:getChildren() return self.list end;

function DisplayNode:getRotation() return self.sprite:getRotation() end
function DisplayNode:setRotation(v, force)
    if force or (self.rotation ~= v) then
        self.rotation = v;
        self.sprite:setRotation(v);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getScale() return self.sprite:getScale() end
function DisplayNode:setScale(v, force) 
    if (force or (self.scaleX ~= v)) and self.sprite then
        self.scaleX = v;
        self.sprite:setScale(v);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getScaleX() return self.sprite:getScaleX() end
function DisplayNode:setScaleX(v, force)
    if force or (self.scaleX ~= v) then
        self.scaleX = v;
        if self.sprite then
        	self.sprite:setScaleX(v);
        end
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getScaleY() return self.sprite:getScaleY() end
function DisplayNode:setScaleY(v, force)
    if force or (self.scaleY ~= v) then
        self.scaleY = v;
        self.sprite:setScaleY(v);
        self:__dirtyDisplayNode();
    end
end

--CCPoint
function DisplayNode:getPosition() return self.sprite:getPositionLua() end
function DisplayNode:setPosition(v) self.sprite:setPosition(v) end
function DisplayNode:setPositionXY(x, y, force)
    if force or (self.x ~= x or self.y ~= y) then
        self.x = x;
        self.y = y;
        self.sprite:setPosition(x, y);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getPositionX() 
    if self.sprite then
        return self.sprite:getPositionX() 
    end
    return nil
end
function DisplayNode:setPositionX(v)
    if self.x ~= v then
        self.x = v;
        self.sprite:setPositionX(v);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getPositionY() 
	if self.sprite then
		return self.sprite:getPositionY() 
    end
    return nil
end
function DisplayNode:setPositionY(v,force)
    if force or self.y ~= v then
        self.y = v;
        self.sprite:setPositionY(v);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getSkewX() return self.sprite:getSkewX() end
function DisplayNode:setSkewX(v)
    if self.skewX ~= v then
        self.skewX = v;
        self.sprite:setSkewX(v);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getSkewY() return self.sprite:getSkewY() end
function DisplayNode:setSkewY(v)
    if self.skewY ~= v then
        self.skewY = v;
        self.sprite:setSkewY(v);
        self:__dirtyDisplayNode();
    end
end

function DisplayNode:getOpacity() return self.sprite:getOpacity() end
function DisplayNode:setOpacity(v)
    if self.opacity ~= v then
        self.opacity = v;
        self.sprite:setOpacity(v);
    end
end

function DisplayNode:getAlpha() return self.sprite:getOpacity()/255 end
function DisplayNode:setAlpha(v)  
    local v_ = math.floor(v * 255 + 0.5); --round
    if self.opacity ~= v_ then
        self.opacity = v_;
        self.sprite:setOpacity(v_);
    end
end

function DisplayNode:isVisible() return self.sprite:isVisible() end
function DisplayNode:setVisible(v, force)
    if self.visible ~= v or force then
        self.visible = v;
        if self.sprite then
        	self.sprite:setVisible(v);
        end
    end
end

--void*
function DisplayNode:getUserData() return self.sprite:getUserData() end
function DisplayNode:setUserData(v) self.sprite:setUserData(v) end

--CCPoint
function DisplayNode:getAnchorPoint() return self.sprite:getAnchorPoint() end
function DisplayNode:setAnchorPoint(v) self.sprite:setAnchorPoint(v) end

function DisplayNode:isIgnoreAnchorPointForPosition() return self.sprite:isIgnoreAnchorPointForPosition() end
function DisplayNode:ignoreAnchorPointForPosition(v) self.sprite:ignoreAnchorPointForPosition(v) end

-- [CCSize]The untransformed size of the node.
-- The contentSize remains the same no matter the node is scaled or rotated.
-- All nodes has a size. Layer and Scene has the same size of the screen.
function DisplayNode:getContentSize() return self.sprite:getContentSize() end
function DisplayNode:setContentSize(v) 
    self.sprite:setContentSize(v) 
end

--int
function DisplayNode:getTag() return self.sprite:getTag() end
function DisplayNode:setTag(v) self.sprite:setTag(v) end

--CCRect
function DisplayNode:boundingBox() return self.sprite:boundingBox() end


--
-- public methods of actions ---------------------------------------------------------
--

function DisplayNode:cleanup() self.sprite:cleanup() end
function DisplayNode:draw() self.sprite:draw() end
function DisplayNode:visit() self.sprite:visit() end
function DisplayNode:transform() self.sprite:transform() end
function DisplayNode:scheduleUpdate() self.sprite:scheduleUpdate() end
function DisplayNode:unscheduleUpdate() self.sprite:unscheduleUpdate() end

--CCAction
function DisplayNode:runAction(v) return self.sprite:runAction(v) end
function DisplayNode:stopAllActions() self.sprite:stopAllActions() end
function DisplayNode:stopAction(v) self.sprite:stopAction(v) end
function DisplayNode:stopActionByTag(v) self.sprite:stopActionByTag(v) end
function DisplayNode:getActionByTag(v) return self.sprite:getActionByTag(v) end
function DisplayNode:numberOfRunningActions() return self.sprite:numberOfRunningActions() end

--CCAffineTransform
function DisplayNode:nodeToParentTransform() return self.sprite:nodeToParentTransform() end
function DisplayNode:parentToNodeTransform() return self.sprite:parentToNodeTransform() end
function DisplayNode:nodeToWorldTransform() return self.sprite:nodeToWorldTransform() end
function DisplayNode:worldToNodeTransform() return self.sprite:worldToNodeTransform() end

--CCPoint
function DisplayNode:convertToNodeSpace(v) 
	--v = CCPoint(v.x * GameData.gameMetaScaleRate,v.y * GameData.gameMetaScaleRate)
	return self.sprite:convertToNodeSpace(v) 
end
function DisplayNode:convertToWorldSpace(v) return self.sprite:convertToWorldSpace(v) end
function DisplayNode:convertToNodeSpaceAR(v) return self.sprite:convertToNodeSpaceAR(v) end
function DisplayNode:convertToWorldSpaceAR(v) return self.sprite:convertToWorldSpaceAR(v) end
function DisplayNode:convertTouchToNodeSpace(v) return self.sprite:convertTouchToNodeSpace(v) end
function DisplayNode:convertTouchToNodeSpaceAR(v) return self.sprite:convertTouchToNodeSpaceAR(v) end

--
-- public methods of display ---------------------------------------------------------
--

function DisplayNode:contains(child)
    if not child then return false end;

	for i, v in ipairs(self.list) do
		if v == child then return true end;
	end
	return false;
end

function DisplayNode:getParent()
    return self.parent;
end

function DisplayNode:addChild(child)
    if self.list then
        local i = table.getn(self.list);
	    self:addChildAt(child, i);
    end
end

-- index: [0 - getNumOfChildren]
function DisplayNode:addChildAt(child, index)
    if not child or not child.sprite then return end;
	local valid = self:contains(child);
	if valid then return end;
  
  local preParent = child:getParent();
  if preParent then
    preParent:removeChild(child, false);
  end
	local compare = child.sprite;
	
	if child.name == kHitAreaObjectName then 
        self.sprite:addChild(compare, index, kHitAreaObjectTag);
    else
        self.sprite:addChild(compare, index);
    end
		
  self:addChildToDisplayList(child, index);  
end

-- 将子显示对象添加到显示列表（用于事件调度）
function DisplayNode:addChildToDisplayList(child, index)
	-- 插入数组
	local oldIndex = table.getn(self.list);

	table.insert(self.list, index + 1, child);
	child.parent = self;
	child:__dirtyDisplayNode();

	-- 更新索引
	for i,v in ipairs(self.list) do
		v.index = i - 1;
	end

	if index ~= oldIndex then
		self:updateIndex();
	end
end

function DisplayNode:containsCCSprite(ccChild)
	if not ccChild then return false end;
	local compare = ccChild;

	local list = self.sprite:getChildren();
	local numOfChildren = self.sprite:getChildrenCount();
	local length = numOfChildren - 1;

	if numOfChildren <= 0 then return false;
	elseif numOfChildren == 1 then return list:objectAtIndex(0) == compare;
	elseif numOfChildren > 1 then
		for i = 0, length do
			if list:objectAtIndex(i) == compare then return true end;
		end
	end
	return false;
end

function DisplayNode:getChildByName(childName)
	for i, v in ipairs(self.list) do
		if v.name == childName then return v end;
	end
	return nil;
end

-- index: [0 - getNumOfChildren]
function DisplayNode:getChildAt(index)
	local length = table.getn(self.list);
	if index < 0 or index >= length then return nil end;
	return self.list[index+1];
end

-- index: [0 - getNumOfChildren]
function DisplayNode:getCCChildAt(index)
	local list = self.sprite:getChildren();
	local numOfChildren = self.sprite:getChildrenCount();
	local length = numOfChildren - 1;

	if index >= numOfChildren or numOfChildren <= 0 then return nil end;

	return list:objectAtIndex(i);
end

-- index: [0 - getNumOfChildren], -1 means not found.
function DisplayNode:getChildIndex(child)
	if not child then return -1 end;

	for i, v in ipairs(self.list) do
		if v == child then return i - 1 end;
	end

	return -1;
end

function DisplayNode:removeFromParentAndCleanup(cleanup)
    local isCleanup = true;
	if cleanup ~= nil then isCleanup = cleanup end;
	if self.sprite then self.sprite:removeFromParentAndCleanup(isCleanup) end;
	self.parent = nil;
end

-- default: cleanup = true;
function DisplayNode:removeChild(child, cleanup)
	if not child then return end;
	local isCleanup = true;
	if cleanup ~= nil then isCleanup = cleanup end;

	--clean cocos2d
	local compare = child.sprite;
	if not compare then return end;
	if not self.sprite then return end;

	self.sprite:removeChild(compare, isCleanup);

	local cd = 0;
	for i, v in ipairs(self.list) do
		if v == child then cd = i end;
	end

	self:removeChildFromDisplayList(cd, isCleanup);
end

-- 从显示列表中移除显示对象
-- unsigned int index — 列表项索引
-- bool cleanup — 是否销毁对象
function DisplayNode:removeChildFromDisplayList(index, cleanup)
	if index > 0 then
		local child = table.remove(self.list, index);
		child.parent = nil;
		child:__dirtyDisplayNode();

		for i, v in ipairs(self.list) do
			v.index = i - 1;
		end

		if cleanup then
			child:dispose();
		end
	end
end

-- index: [0 - getNumOfChildren]
function DisplayNode:removeChildAt(index, cleanup)
	local child = self:getChildAt(index);
	local isCleanup = true;
	if cleanup ~= nil then isCleanup = cleanup end;

	if child then self:removeChild(child, isCleanup) end;
end
--cleanup默认不传表示清除纹理，传入false表示不清除纹理
function DisplayNode:removeChildren(cleanup)
    local isCleanup = true;
	if cleanup ~= nil then isCleanup = cleanup end;
	self.sprite:removeAllChildrenWithCleanup(true);
    for i, v in ipairs(self.list) do v:dispose(isCleanup) end;
    self.list = {};
end

function DisplayNode:updateIndex()
	local dp = self.sprite;
	for i, v in ipairs(self.list) do
		if v.sprite then dp:reorderChild(v.sprite, v.index) end;
	end
end

local function sortOnIndex(a, b) return a.index < b.index end
function DisplayNode:setChildIndex(child, index)
	local valid = self:contains(child);
	if (not valid) or (child.index == index) then return end;

	for i, v in ipairs(self.list) do
		local cd = i - 1;
		if (cd >= index) and (v ~= child) then
			v.index = v.index + 1;
			if v.sprite then
			 self.sprite:reorderChild(v.sprite, v.index)
			end;
		end
	end
	child.index = index;

	table.sort(self.list, sortOnIndex)
	self:updateIndex();
end

function DisplayNode:swapChildren(child1, child2)
	local child1Index = self:getChildIndex(child1);
	local child2Index = self:getChildIndex(child2);
	if child1Index >= 0 and child2Index >= 0 then
		child1.index = child2Index;
		child2.index = child1Index;

		local sp = self.sprite;
		if child1.sprite then	
		  sp:reorderChild(child1.sprite, child1.index) 
		end
		if child2.sprite then
		 sp:reorderChild(child2.sprite, child2.index)
		end
		self.list[child2Index+1] = child1
		self.list[child1Index+1] = child2
	end
end

function DisplayNode:swapChildrenAt(child1, child2)
	local c1 = self:getChildAt(child1);
	local c2 = self:getChildAt(child2);
	if c1 and c2 then self:swapChildren(c1, c2) end;
end

function DisplayNode:pause()
	self.sprite:onExit()
end

function DisplayNode:resume()
	self.sprite:onEnter()
end
--
-- public methods of display ---------------------------------------------------------
--

-- TODO: add rotation, skew factors. improved with matrix.
function DisplayNode:getBounds(useCacheBounds, rootSprite)
    return CommonUtils:getNodeBounds(self.sprite, rootSprite);
end
function DisplayNode:getGroupBounds(useCacheBounds, rootSprite)
    return CommonUtils:getNodeGroupBounds(self.sprite, rootSprite, kHitAreaObjectTag);
end
function DisplayNode:hitTestPoint(worldPosition, useCacheBounds, useGroupTest)
    local isUseGroupTest = false;
    if useGroupTest ~= nil then isUseGroupTest = useGroupTest end;
    -- log("self.sprite:getPositionX()========="..self.sprite:getPositionX())
    -- log("self.sprite:getPositionY()========="..self.sprite:getPositionY())
    -- log("self.sprite:width========="..self.sprite:getGroupBounds().size.width)
    -- log("self.sprite:height========="..self.sprite:getGroupBounds().size.height)    
    -- log("worldPosition.x======="..worldPosition.x)
    -- log("worldPosition.y======="..worldPosition.y)    
    return CommonUtils:hitTestPoint(self.sprite, worldPosition, isUseGroupTest, kHitAreaObjectTag);
end
--[[
function DisplayNode:getBounds(useCacheBounds)
    local isUseCacheBounds = false;
    if useCacheBounds ~= nil then isUseCacheBounds = useCacheBounds end;
    if isUseCacheBounds and self.bounds then return self.bounds end;
    
    local p = self.sprite:getPositionLua();
    local s = self.sprite:getContentSize();
    local sx = math.abs(self.sprite:getScaleX());
    local sy = math.abs(self.sprite:getScaleY());
    
    local rx, ry, rw, rh = p.x, p.y, s.width * sx, s.height * sy;
    
    local parent_ = self:getParent();
    while parent_ do
        sx = math.abs(parent_:getScaleX());
        sy = math.abs(parent_:getScaleY());
        p = parent_:getPosition();
        
        rx = p.x + rx * sx;
        ry = p.y + ry * sy;
        rw = rw * sx;
        rh = rh * sy;
        parent_ = parent_:getParent();
    end
    local ret = DisplayBounds.new(rx, ry, rw, rh);
    return ret;
end

--by default, if we found a child named "hit_area", we use that child's bounds instead of compute all children's group bounds.
function DisplayNode:getGroupBounds(useCacheBounds)
    local isUseCacheBounds = false;
    if useCacheBounds ~= nil then isUseCacheBounds = useCacheBounds end;
    if isUseCacheBounds and self.bounds then return self.bounds end;
    
    if not self.sprite then return kZeroDisplayBound end;
        
   
    local debug = false;
    if self.name == "start level panel layer" then
        debug = true;
    end
   
    if self.computeGroupBoundsFunc then return self.computeGroupBoundsFunc(self) end;
    
    local computedBounds = self:getBounds();
    if self:getNumOfChildren() <= 0 then
        self.bounds = computedBounds;
        return self.bounds;
    else
        local hitAreaChild = self:getChildByName("hit_area");
        if hitAreaChild then
            return hitAreaChild:getBounds(false);
        end
        
        local minX, minY, maxX, maxY = computedBounds.x, computedBounds.y, computedBounds.x + computedBounds.width, computedBounds.y + computedBounds.height;
        --if debug then print("before",self.name, minX, minY, maxX - minX, maxY - minY) end;
        for i, v in ipairs(self.list) do            
            --local childBounds = v:getBounds();
            local childBounds = v:getGroupBounds(useCacheBounds);
            local vx, vy, vw, vh = childBounds.x, childBounds.y, childBounds.x + childBounds.width, childBounds.y + childBounds.height;
           
            if vx < minX then minX = vx end;
            if vy < minY then minY = vy end;
            if vw > maxX then maxX = vw end;
            if vh > maxY then maxY = vh end;
           -- if debug then print(v.name, vx, vy, vw, vh) end;
        end
        
        self.bounds = DisplayBounds.new(minX, minY, maxX - minX, maxY - minY);
        --if debug then print("after",self.name, minX, minY, maxX - minX, maxY - minY) end;
        return self.bounds;
    end
end

function DisplayNode:hitTestPoint(worldPosition, useCacheBounds, useGroupTest)
    local isUseCacheBounds, isUseGroupTest = false, false;
    if useCacheBounds ~= nil then isUseCacheBounds = useCacheBounds end;
    if useGroupTest ~= nil then isUseGroupTest = useGroupTest end;
    
    local bounds_ = nil;
    if isUseGroupTest then
        bounds_ = self:getGroupBounds(isUseCacheBounds);
    else
        bounds_ = self:getBounds(isUseCacheBounds);
    end
    
    local rect_ = bounds_:toRect();
    local parent_ = self:getParent();
    
    if rect_ and parent_ then
        local ret = rect_:containsPoint(worldPosition);
        return ret;
    end
    return false;
end
]]

function DisplayNode:__getObjectUnderPointForTouch(worldPosition, objectList, useCacheBounds, depth)
    if not objectList then return end;
    
    local numberOfChildren = self:getNumOfChildren();
    local invalid = (not self.touchChildren) or (numberOfChildren <= 0);
    if invalid then return end;
    
    local isUseCacheBounds = false;
    if useCacheBounds ~= nil then isUseCacheBounds = useCacheBounds end;
   
    local currentDepth = 0;
    if not depth then 
        depth = {0};
    else
        currentDepth = depth[1];
        currentDepth = currentDepth + 1;
        depth[1] = currentDepth;
    end
    
    for i = numberOfChildren, 1, -1 do
        local v = self.list[i];
        local ignoredItem = (v.nodeType == 1 and not v.visible);
        local isHit = false;
        if not ignoredItem then 
             isHit = v:hitTestPoint(worldPosition, isUseCacheBounds, true);
        end

        if isHit then  --use group hit test
            if v.touchEnabled then 
                table.insert(objectList, TouchResult.new(v, currentDepth));
            end
            if v.touchChildren then
               v:__getObjectUnderPointForTouch(worldPosition, objectList, useCacheBounds, depth);
            end
        end
    end
end
function DisplayNode:create()
  return DisplayNode.new(CCSprite:create())
end
--
-- TouchResult ---------------------------------------------------------
--
TouchResult = class();
function TouchResult:ctor(sprite, depth)
    self.sprite = sprite;
    self.root = nil;
    self.depth = depth or 0;
    self.computeIndex = self.depth * 1000 + self.sprite.index;
    
    self.__linked = false;
end

function TouchResult:computeRoot(rootLayer, stopParent)    
    self.root = self.sprite;
    
    local parent = self.sprite:getParent();
    while parent and parent ~= rootLayer and parent ~= stopParent do
        if parent ~= rootLayer and parent ~= stopParent then self.root = parent end;
        parent = parent:getParent();
    end    
end

function TouchResult:isAncestor(compare)
    if not compare then return false end;
    
    local parent = compare.sprite:getParent();
    while parent do
        if parent == self.sprite then return true end;
        parent = parent:getParent();
    end 
    
    return false;  
end
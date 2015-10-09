-------------------------------------------------------------------------
--  Class include: Layer, RootLayer, TouchLayer, LayerColor, LayerGradient
-------------------------------------------------------------------------


require "core.utils.class"
require "core.display.DisplayNode"
require "core.display.Sprite"

--
-- Layer ---------------------------------------------------------
--
-- NOTICE! DO remember call initLayer after ctor;
-- because sub-class need to override layer initialization but we can not call member functions in ctor.

Layer = class(DisplayNode);
function Layer:ctor()
	self.class = Layer;
	self.nodeType = DisplayNodeType.kLayer;
	self.isLayerInitialized = false;
end

local g_LayerAnchorPosition = nil;
function transLayerAnchor(_x, _y)
    if not g_LayerAnchorPosition then
        g_LayerAnchorPosition = CCPoint:new(0, 0);
    end
    g_LayerAnchorPosition.x = _x;
    g_LayerAnchorPosition.y = _y;
    return g_LayerAnchorPosition
end

local g_LayerContentSize = nil;
function transLayerContentSize(_w, _h)
    if not g_LayerContentSize then
        g_LayerContentSize = CCSizeMake(0, 0);
    end
    g_LayerContentSize.width = _w;
    g_LayerContentSize.height = _h;
    return g_LayerContentSize
end

function Layer:initLayer()
    if not self.isLayerInitialized then
        self.isLayerInitialized = true;
        local ccLayer = CCLayer:create();
	    self.sprite = ccLayer;

        if self.sprite then
            self.sprite:retain();
            self.sprite:setAnchorPoint(transLayerAnchor(0,0));
            self.sprite:setContentSize(transLayerContentSize(1,1));
            --self.sprite:ignoreAnchorPointForPosition(true);
        end
    end
end

function Layer:dispose()	
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
	self:cleanSelf();

end
function Layer:toString()
	return string.format("Layer [%s]", self.name and self.name or "nil");
end

function Layer:isTouchEnabled() 
    return self.sprite:isTouchEnabled() 
end

function Layer:changeAnchorPoint(_x, _y)
    self.sprite:setAnchorPoint(transLayerAnchor(_x,_y));
end

function Layer:getAnchorPoint()
    return self.sprite:getAnchorPoint()
end

function Layer:setAnchorPoint(anchorPoint)
    return self.sprite:setAnchorPoint(anchorPoint)
end

function Layer:setTouchEnabled(v) 
    self.touchEnabled = v;
    self.touchChildren = v;
    self.sprite:setTouchEnabled(v) 
end

-- 设置是否允许子对象响应触摸事件
-- bool enabled — 是否允许触摸标识
function Layer:setTouchChildren(enabled)
	self.touchChildren = enabled;
end

function Layer:isAccelerometerEnabled() return self.sprite:isAccelerometerEnabled() end;
function Layer:setAccelerometerEnabled(v) self.sprite:setAccelerometerEnabled(v) end;

function Layer:isKeypadEnabled() return self.sprite:isKeypadEnabled() end;
function Layer:setKeypadEnabled(v) self.sprite:setKeypadEnabled(v) end;

--[[
func(eventType, x, y) where eventType = 
    CCTOUCHBEGAN,
    CCTOUCHMOVED,
    CCTOUCHENDED,
    CCTOUCHCANCELLED,
]]
-- WARNING: use touch events by scene 1st. use unregisterScriptTouchHandler/registerScriptTouchHandler carefully.
function Layer:unregisterScriptTouchHandler() return self.sprite:unregisterScriptTouchHandler() end;
function Layer:registerScriptTouchHandler(func, bIsMultiTouches, nPriority, bSwallowsTouches)
    local isMultiTouches = false;
    local priority = nPriority or 0;
    local swallowsTouches = false;
    if bIsMultiTouches ~= nil then isMultiTouches = bIsMultiTouches end;
    if bSwallowsTouches ~= nil then swallowsTouches = bSwallowsTouches end;
    self.sprite:registerScriptTouchHandler(func, isMultiTouches, priority, swallowsTouches) 
end


--
-- RootLayer ---------------------------------------------------------
--

RootLayer = class(Layer);
function RootLayer:ctor()
	self.class = RootLayer;
	self.name = "root";
end

local function sortOnComputedIndex(a, b) return a.computeIndex < b.computeIndex end
local function sortOnDepth(a, b) return a.depth < b.depth end

local function removeAncestorObject(parentRemovedObject)
    local haveLinkedItems = false;
    for i, v in ipairs(parentRemovedObject) do
        for j, k in ipairs(parentRemovedObject) do
            if v ~= k and v:isAncestor(k) then v.__linked = true; haveLinkedItems = true; end;
        end
    end
    if haveLinkedItems then
        local ret = {};
            for i, v in ipairs(parentRemovedObject) do
                if not v.__linked then table.insert(ret, v) end;
            end
        return ret;
    else
        return parentRemovedObject;
    end
end

local function computeTouchedObject(parentRemovedObject, rootLayer)
    -- trick of Lowest Common Ancestor probles. we do not use any of LCA algorithms 
    -- more discuss at http://en.wikipedia.org/wiki/Lowest_common_ancestor
    -- also: http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=lowestCommonAncestor
    
    if table.getn(parentRemovedObject) > 1 then
        local commonRoot = parentRemovedObject[1].root;
        local haveSameRoot = true;
        for i, v in ipairs(parentRemovedObject) do
            if v.root ~= commonRoot then 
                haveSameRoot = false;
                break;
            end;
        end
        
        --have same root, need compute root again.
        if haveSameRoot then
            for i, v in ipairs(parentRemovedObject) do v:computeRoot(commonRoot,rootLayer) end;
        end
    end
    
    local ret = {};
    
    local maxIndex = -1;
    for i, v in ipairs(parentRemovedObject) do
        if v.root and v.root.index > maxIndex then maxIndex = v.root.index end;
    end
    if maxIndex ~= -1 then
        for i, v in ipairs(parentRemovedObject) do
            if v.root and v.root.index == maxIndex then table.insert(ret, v) end;
        end
    end
    
    return ret;
end

--height if display tree(parent level): max 10 (1 for scene, 1 for root layer)
function RootLayer:getObjectUnderPointForTouch(worldPosition)
    self:getGroupBounds(false); --cache group bounds.
        
    --use group bounds to cache all object that hit the touch position
    local allHitObject = {};
    local parentRemovedObject = {};
     
    self:__getObjectUnderPointForTouch(worldPosition, allHitObject, true, {0});
    table.sort(allHitObject, sortOnComputedIndex);
    
    for i, v in ipairs(allHitObject) do
        if v.sprite:hitTestPoint(worldPosition, false, false) then
            table.insert(parentRemovedObject, v);
            v:computeRoot(self, self);
            v.__linked = false;
        end
    end
    
    local length = 0;
    length = table.getn(parentRemovedObject);
    if length > 1 then
        --remove object that heve linked by child-parent.
        parentRemovedObject = removeAncestorObject(parentRemovedObject);
    end
    
    parentRemovedObject = computeTouchedObject(parentRemovedObject, self);
    local times = 0;
    length = table.getn(parentRemovedObject);
    while length > 1 and times < 12 do
        parentRemovedObject = computeTouchedObject(parentRemovedObject, self);
        length = table.getn(parentRemovedObject);
        times = times + 1;
    end 
    
    local ret = {};
    length = table.getn(parentRemovedObject);
    if length > 0 then
        local finalObj = parentRemovedObject[1];
        table.insert(ret, finalObj.sprite);
        
        local parent_ = finalObj.sprite:getParent();
        while parent_ and parent_ ~= self do
            if parent_ ~= self then table.insert(ret, parent_) end;
            parent_ = parent_:getParent();
        end    
    end
        
    return ret;
end

--
-- TouchLayer ---------------------------------------------------------
--

TouchLayer = class(Layer);
function TouchLayer:ctor()
	self.class = TouchLayer;
	self.width = 0;
	self.height = 0;
end

function TouchLayer:changeWidthAndHeight(w, h)
    if self.width ~= w or self.height ~= h then
        self.width = w;
        self.height = h;
        --self.sprite:changeWidthAndHeight(w, h);
        self:setContentSize(transLayerContentSize(w, h));
    end
end

--可以从中间放缩
ScaleLayer = class(Layer);
function ScaleLayer:ctor()
    self.class = ScaleLayer;
end

function ScaleLayer:initScaleAnimation()
    local size = self:getGroupBounds().size
    self:changeAnchorPoint(size.width/2,size.height/2)
    local scaleNum = (size.width + size.height) > 300 and 1.05 or 1.1
    self:addEventListener(DisplayEvents.kTouchBegin,self.scaleToLittle,self,scaleNum);
end

function ScaleLayer:scaleToLittle(event,scaleNum)
    self:setScale(scaleNum)
    self:addEventListener(DisplayEvents.kTouchEnd,self.scaleToBig,self);
end

function ScaleLayer:scaleToBig()
    self:setScale(1)
end

--
-- LayerColor ---------------------------------------------------------
--

LayerColor = class(Layer);
function LayerColor:ctor()
	self.class = LayerColor;
	self.width = 0;
	self.height = 0;
end
function LayerColor:initLayer()
    if not self.isLayerInitialized then
        self.isLayerInitialized = true;
        local ccLayer = CCLayerColor:create(ccc4(0,0,0,255));
        self.sprite = ccLayer;

        if self.sprite then
            self.sprite:retain();
            self.sprite:setAnchorPoint(CCPointMake(0,0));
            self.sprite:ignoreAnchorPointForPosition(true);
        end
    end
end

function LayerColor:getOpacity() return self.sprite:getOpacity() end;
function LayerColor:setOpacity(v) self.sprite:setOpacity(v) end;

--ccColor3B
function LayerColor:getColor() return self.sprite:getColor() end;
function LayerColor:setColor(v) self.sprite:setColor(v) end;

function LayerColor:getOpacity() return self.sprite:getOpacity() end;
function LayerColor:setOpacity(v) self.sprite:setOpacity(v) end;
--ccBlendFunc
function LayerColor:getBlendFunc() return self.sprite:getBlendFunc() end;
function LayerColor:setBlendFunc(v) self.sprite:setBlendFunc(v) end;

function LayerColor:isOpacityModifyRGB() return self.sprite:isOpacityModifyRGB() end;
function LayerColor:setOpacityModifyRGB(v) self.sprite:setOpacityModifyRGB(v) end;

function LayerColor:changeWidth(v)
    if self.width ~= v then
        if v >= 0 then
            self.width = v;
            self.sprite:changeWidth(v);
        else
            error("width < 0")
        end
    end
end
function LayerColor:changeHeight(v)
    if self.height ~= v then
        if v >= 0 then
            self.height = v;
            self.sprite:changeHeight(v);
        else
            error("height < 0")
        end
    end
end
function LayerColor:changeWidthAndHeight(w, h)
    if self.width ~= w or self.height ~= h then
        if w >=0 and h >= 0 then
            self.width = w;
            self.height = h;
            self.sprite:changeWidthAndHeight(w, h);
        else
            error("width or height < 0")
        end
    end
end


--
-- LayerGradient ---------------------------------------------------------
--

LayerGradient = class(LayerColor);
function LayerGradient:ctor()
	self.class = LayerGradient;
end
function LayerGradient:initLayer()
    if not self.isLayerInitialized then
        self.isLayerInitialized = true;
        local ccLayer = CCLayerGradient:create(ccc4(0,0,0,0),ccc4(0,0,0,0));
        self.sprite = ccLayer;

        if self.sprite then
            self.sprite:retain();
            self.sprite:setAnchorPoint(CCPointMake(0,0));
            self.sprite:ignoreAnchorPointForPosition(true);
        end
    end
end
--ccColor3B
function LayerGradient:getStartColor() return self.sprite:getStartColor() end;
function LayerGradient:setStartColor(v) self.sprite:setStartColor(v) end;
--ccColor3B
function LayerGradient:getEndColor() return self.sprite:getEndColor() end;
function LayerGradient:setEndColor(v) self.sprite:setEndColor(v) end;
--GLubyte
function LayerGradient:getStartOpacity() return self.sprite:getStartOpacity() end;
function LayerGradient:setStartOpacity(v) self.sprite:setStartOpacity(v) end;
--GLubyte
function LayerGradient:getEndOpacity() return self.sprite:getEndOpacity() end;
function LayerGradient:setEndOpacity(v) self.sprite:setEndOpacity(v) end;
--CCPoint
function LayerGradient:getVector() return self.sprite:getVector() end;
function LayerGradient:setVector(v) self.sprite:setVector(v) end;

function LayerGradient:isCompressedInterpolation() return self.sprite:isCompressedInterpolation() end;
function LayerGradient:setCompressedInterpolation(v) self.sprite:setCompressedInterpolation(v) end;
require "core.display.DisplayNode"
require "core.display.Layer"
require "core.display.MovieClip"
require "core.controls.BasePanel"
require "core.events.DisplayEvent"
require "main.config.GameVar"
require "core.utils.BoneCartoon"

--
-- Scene ---------------------------------------------------------
--

local debugTouchEvent = false;

-- NOTICE! DO remember call initScene after ctor;
-- because we can not call member functions in ctor.

local kPopoutOpacity = 255*0.3;
kSceneAnimationTime = 0.5;

Scene = class(DisplayNode);
function Scene:ctor()
	self.class = Scene;
	self.nodeType = DisplayNodeType.kScene;

	local ccScene = CCScene:create();
	self.sprite = ccScene;
	
	--only cclayer can handle touch via registerScriptTouchHandler.
	self.rootLayer = nil;
	self.isSceneInitialized = false;
	self.touchEnabled = false;
	
	self.userInterfaceLayer = nil;
	self.popoutLayer = nil;
	self.popouts = {};
	--self.__needEnableTouchWhenEnter = false;

    local winSize = Director:sharedDirector():getWinSize();
	self.screenWidth = winSize.width;
	self.screenHeight = winSize.height;

    GameVar.screenWidth = winSize.width; 
    GameVar.screenHeight = winSize.height; 

	
	if self.sprite then
        self.sprite:retain();
        self.sprite:setAnchorPoint(CCPointMake(0,0));
        self.sprite:ignoreAnchorPointForPosition(true);
    end
end

function Scene:initScene(enableTouch)
    local isTouchEnable = true;
    if enableTouch ~= nil then isTouchEnable = enableTouch end;
    
    if not self.isSceneInitialized then
        self.isSceneInitialized = true;
        local winSize = Director:sharedDirector():getWinSize();
        
        self.rootLayer = RootLayer.new(); --scene's root layer is a RootLayer class
        self.rootLayer:initLayer();
	    self:superAddChild(self.rootLayer);
	    
	    self.userInterfaceLayer = Layer.new();
	    self.userInterfaceLayer:initLayer();
	    self.userInterfaceLayer.name = "userInterfaceLayer";
	    self:addChild(self.userInterfaceLayer);
	    
	    self.popoutLayer = LayerColor.new();
	    self.popoutLayer:initLayer();
	    self.popoutLayer:setColor(ccc3(0,0,0));
        self.popoutLayer:setOpacity(kPopoutOpacity);
        self.popoutLayer:changeWidthAndHeight(winSize.width, winSize.height);
	    self.popoutLayer.name = "popoutLayer";
	    self.popoutLayer:setVisible(false);
	    self:addChild(self.popoutLayer);
    end
    
    self:setTouchEnabled(isTouchEnable);
    
    self:onInit();
end

function Scene:onInit()end
function Scene:onEnter()end
function Scene:onExit()end
function Scene:onUpdate(dt)
    self:updatePopoutLayers(dt);
end

function Scene:updatePopoutLayers(dt)
    local popoutLists = self.popouts;
    if popoutLists then
        local length = table.getn(popoutLists);
        if length > 0 then popoutLists[length]:onUpdate(dt) end;
    end
    --local length = table.getn(popoutLists);
    --if length > 0 then popoutLists[length]:onUpdate(dt) end;
    --for i, v in ipairs(popoutLists) do v:update(dt) end;
end

function Scene:disposeScene()
    if self.popouts then 
        for k, v in pairs(self.popouts) do v:dispose() end;
    end
    
    if self.sprite then 
        self.sprite:release()

    end
    
    if self.userInterfaceLayer then self.userInterfaceLayer:dispose() end;
    if self.popoutLayer then self.popoutLayer:dispose() end;
    if self.rootLayer then self.rootLayer:dispose() end;
    
    self.sprite = nil;
    
    self.popouts = nil;
    self.popoutLayer = nil;
    self.userInterfaceLayer = nil;
    
    self.rootLayer = nil;
    
	self:cleanSelf();
end

function Scene:dispose()
	self:disposeScene();
end

local function indexOf(table, item)
    local idx = -1;
    if table and item then
        for i, v in ipairs(table) do
            if v == item then 
                idx= i;
                break;
            end
        end
    end
    return idx;
end


--
-- public control -------------------
--

function Scene:getNumOfChildren() 
    return self.rootLayer:getNumOfChildren() 
end

function Scene:superAddChild(child)
    local i = table.getn(self.list);
	self:superAddChildAt(child, i);
end
-- index: [0 - getNumOfChildren]
function Scene:superAddChildAt(child, index)
    if not child or not child.sprite then return end;
	local i = indexOf(self.list, child);
	if i == -1 then
	    local compare = child.sprite;
        self.sprite:addChild(compare, index); --ccScene

        table.insert(self.list, index+1, child);
        child.parent = self;

        --update index
        for i, v in ipairs(self.list) do v.index = i-1 end;
	end
end

-- default: cleanup = true;
function Scene:superRemoveChild(child, cleanup)
	if not child then return end;
	local isCleanup = true;
	if cleanup ~= nil then isCleanup = cleanup end;

	--clean cocos2d
	local compare = child.sprite;
	if not compare then return end;
	self.sprite:removeChild(compare, isCleanup);

	local cd = 0;
	for i, v in ipairs(self.list) do
		if v == child then cd = i end;
	end

	--clean self list
	if cd > 0 then
		table.remove(self.list, cd);
		child.parent = nil;
		for i, v in ipairs(self.list) do v.index = i-1 end;
	end

	if(isCleanup) then child:dispose() end;
end

function Scene:addChild(child)
    if not child then return end;
    self.rootLayer:addChild(child);
end

-- index: [0 - getNumOfChildren]
function Scene:addChildAt(child, index)
    if not child then return end;
    self.rootLayer:addChildAt(child, index);
end

function Scene:contains(child) 
    if not child then return end;
    return self.rootLayer:contains(child);  
end

function Scene:containsCCSprite(ccChild)return false end;
function Scene:getCCChildAt(index) return nil end;

-- index: [0 - getNumOfChildren], return MovieClip if true.
function Scene:getChildAt(index) 
    return self.rootLayer:getChildAt(index);
end

-- index: [0 - getNumOfChildren], -1 means not found.
function Scene:getChildIndex(child) 
    return self.rootLayer:getChildIndex(child)       
end

function Scene:removeFromParentAndCleanup(cleanup) end;

-- default: cleanup = true;
function Scene:removeChild(child, cleanup)
	if not child then return end;
    self.rootLayer:removeChild(child, cleanup);
end

function Scene:removeChildren(cleanup)
    self.rootLayer:removeChildren(cleanup);
end

--
-- index control -------------------
--

function Scene:updateIndex()
	self.rootLayer:updateIndex();
end

function Scene:setChildIndex(child, index)
	if not child then return end;
	self.rootLayer:setChildIndex(child, index);
end

function Scene:swapChildren(child1, child2) end
function Scene:swapChildrenAt(child1, child2) end
function Scene:swapChildrenAt(child1, child2)

end
--
-- touch control -------------------
--
local touchBeginObject = nil;

local function onTouchRootBegin(rootLayer, objectList, worldPosition)
    for i, v in ipairs(objectList) do 
        --debug print
        if debugTouchEvent then print(" [debug touch begin]", worldPosition.x, worldPosition.y, v:toString()) end;
        
        if v:hasEventListenerByName(DisplayEvents.kTouchBegin) then
            local evt = DisplayEvent.new(DisplayEvents.kTouchBegin, v, worldPosition);
            v:dispatchEvent(evt);

            if not evt.propagation then break end;
        end
    end
end
local function onTouchRootMoved(rootLayer, objectList, worldPosition)  
    for i, v in ipairs(touchBeginObject) do v.__touchHelper = 0 end;
  
    for i, v in ipairs(objectList) do 
        local evt = nil;
        local idx = indexOf(touchBeginObject, v);
        if idx == -1 then
            --debug print, new object
            if debugTouchEvent then print(" [debug touch over]", worldPosition.x, worldPosition.y, v:toString()) end;
            evt = DisplayEvent.new(DisplayEvents.kTouchOver, v, worldPosition);            
        else
            --debug print, object already insert when touch begin
            if debugTouchEvent then print(" [debug touch moved]", worldPosition.x, worldPosition.y, v:toString()) end;
            evt = DisplayEvent.new(DisplayEvents.kTouchMove, v, worldPosition);
            v.__touchHelper = 1;
        end
        
        if v:hasEventListenerByName(evt.name) then            
            v:dispatchEvent(evt);
            if not evt.propagation then break end;
        end        
    end
    
    local objectAfterMove = {};
    for i, v in ipairs(touchBeginObject) do
        if v.__touchHelper == 1 then
            table.insert(objectAfterMove, v);
        else
            --end of the touch event
            if debugTouchEvent then print(" [debug touch out]", worldPosition.x, worldPosition.y, v:toString()) end;
            local evtTouchOut = DisplayEvent.new(DisplayEvents.kTouchOut, v, worldPosition);
            if v:hasEventListenerByName(evtTouchOut.name) then            
                v:dispatchEvent(evtTouchOut);
                if not evtTouchOut.propagation then break end;
            end   
            
            if debugTouchEvent then print(" [debug touch end]", worldPosition.x, worldPosition.y, v:toString()) end;
            local evtTouchEnd = DisplayEvent.new(DisplayEvents.kTouchEnd, v, worldPosition);
            if v:hasEventListenerByName(evtTouchEnd.name) then            
                v:dispatchEvent(evtTouchEnd);
                if not evtTouchEnd.propagation then break end;
            end 
        end
    end
    touchBeginObject = objectAfterMove;
end
local function onTouchRootEnd(rootLayer, objectList, worldPosition)
    for i, v in ipairs(touchBeginObject) do v.__touchHelper = 0 end;
    
    for i, v in ipairs(objectList) do         
        local idx = indexOf(touchBeginObject, v);
        if idx ~= -1 then v.__touchHelper = 1 end;
        
        --debu print.
        if debugTouchEvent then print(" [debug touch end]", worldPosition.x, worldPosition.y, v:toString()) end;
        local evtTouchEnd = DisplayEvent.new(DisplayEvents.kTouchEnd, v, worldPosition);
        if v:hasEventListenerByName(evtTouchEnd.name) then            
            v:dispatchEvent(evtTouchEnd);
            if not evtTouchEnd.propagation then break end;
        end
    end
    
    for i, v in ipairs(touchBeginObject) do 
        if v.__touchHelper == 1 then
            --debug print.
            if debugTouchEvent then print(" [debug touch tap]", worldPosition.x, worldPosition.y, v:toString()) end;
            local evtTouchTap = DisplayEvent.new(DisplayEvents.kTouchTap, v, worldPosition);
            if v:hasEventListenerByName(evtTouchTap.name) then            
                v:dispatchEvent(evtTouchTap);
                if not evtTouchTap.propagation then break end;
            end
        end 
    end

    touchBeginObject = nil;
end
local function onTouchRootCancelled(rootLayer, objectList, worldPosition)
    for i, v in ipairs(objectList) do  
        --debu print.
        if debugTouchEvent then print(" [debug touch end]", worldPosition.x, worldPosition.y, v:toString()) end;
        local evtTouchEnd = DisplayEvent.new(DisplayEvents.kTouchEnd, v, worldPosition);
        if v:hasEventListenerByName(evtTouchEnd.name) then            
            v:dispatchEvent(evtTouchEnd);
            if not evtTouchEnd.propagation then break end;
        end
    end
    
    touchBeginObject = nil;
end

local g_worldTouchPosition = nil;
function transWorldPosition(_x, _y)
    if not g_worldTouchPosition then
        g_worldTouchPosition = CCPoint:new(0, 0);
    end
    g_worldTouchPosition.x = _x;
    g_worldTouchPosition.y = _y;
    return g_worldTouchPosition
end

local function onTouchRootLayer(eventType, x, y)
    -- log("x======@@@@"..x)
    -- log("y======@@@@"..y)    

    local winsize = CCDirector:sharedDirector():getWinSize()

    local scene = Director.sharedDirector():getRunningScene();    
    if scene and scene.touchEnabled then
        local rootLayer_ = scene.rootLayer;
        if rootLayer_ then

            local worldPosition = transWorldPosition(x, y);
            local objectList = nil;
            
            if eventType == CCTOUCHBEGAN then
                
                if scene.name ~= GameConfig.BATTLE_SCENE then
                    local boneCartoon = BoneCartoon.new()
                    local function _callBack()
                        scene:removeChild(boneCartoon)
                    end
                    boneCartoon:create(StaticArtsConfig.BONE_EFFECT_901,1,_callBack);
                    boneCartoon:setMyBlendFunc()
                    boneCartoon:setPositionXY(worldPosition.x,worldPosition.y)
                    scene:addChild(boneCartoon);
                else
                    -- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
                end
                objectList = rootLayer_:getObjectUnderPointForTouch(worldPosition);
                if table.getn(objectList) > 0 then
                    touchBeginObject = objectList;
                    onTouchRootBegin(rootLayer_, objectList, worldPosition);                    
                    return true;
                else 
                    touchBeginObject = nil;
                    return false;
                end
            else
                if touchBeginObject and table.getn(touchBeginObject) > 0 then
                    objectList = rootLayer_:getObjectUnderPointForTouch(worldPosition);
                    if eventType == CCTOUCHMOVED then onTouchRootMoved(rootLayer_, objectList, worldPosition);
                    elseif eventType == CCTOUCHENDED then onTouchRootEnd(rootLayer_, objectList, worldPosition);
                    elseif eventType == CCTOUCHCANCELLED then onTouchRootCancelled(rootLayer_, objectList, worldPosition) end;
                end
            end
        end
    end

end

function Scene:isTouchEnabled()
    return self.touchEnabled;
end
function Scene:setTouchEnabled(v)
    if self.touchEnabled ~= v then
        if self.touchEnabled then self.rootLayer:unregisterScriptTouchHandler() end;
        
        self.touchEnabled = v;
        self.rootLayer:setTouchEnabled(v);
        
        if self.touchEnabled then self.rootLayer:registerScriptTouchHandler(onTouchRootLayer, false, 0, true) end;
    end
end

--
-- popout control -------------------
--
function Scene:addPopout(popout, center)
    if not popout then return end;
    if popout:is(BasePanel) then   
        local popoutLayer = self.popoutLayer;
        popoutLayer:addChild(popout.movieClip.layer);
        popout.rootScene = self;
        popout:onEnter();
        
        if not popoutLayer:isVisible() then
            popoutLayer:setVisible(true);
            popoutLayer:stopAllActions();
            popoutLayer:setOpacity(0);
            popoutLayer:runAction(CCFadeTo:create(0.4, kPopoutOpacity));
        end
        
        table.insert(self.popouts, popout);
    end    
end
function Scene:removePopout(popout)
    if not popout then return end;
    if popout:is(BasePanel) then
        local popoutLayer = self.popoutLayer;
        popout:stopAllActions();
        popoutLayer:removeChild(popout.movieClip.layer);
        
        local pid_ = indexOf(self.popouts, popout);
        if pid_ ~= -1 then table.remove(self.popouts, pid_) end;
        
        popout:dispose();
        
        if popoutLayer:getNumOfChildren() > 0 then
            popoutLayer:setVisible(true);
        else
            popoutLayer:setVisible(false);
            --popoutLayer.visible = false;
            --popoutLayer:stopAllActions();
            --popoutLayer:runAction(CCSequence:createWithTwoActions(CCFadeTo:create(0.3, 0), CCHide:create()));
        end
        
    end  
end
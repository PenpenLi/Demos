-------------------------------------------------------------------------
--  Class include: MovieClip, BatchLayer
-------------------------------------------------------------------------

require "core.events.EventDispatcher"
require "core.display.Layer"
require "core.skeleton.SkeletonFactory"

--
-- BatchLayer ---------------------------------------------------------
--

BatchLayer = class(Layer);
function BatchLayer:ctor()
	self.class = BatchLayer;
end

-- function BatchLayer:initLayer() end

function BatchLayer:initBatchLayer(skeleton)
    if not self.isLayerInitialized then
        self.isLayerInitialized = true;
	    self.sprite = skeleton and skeleton:generateBatchNode() or CommonSkeleton:generateBatchNode();

        if self.sprite then
            self.sprite:retain();
            self.sprite:setAnchorPoint(CCPointMake(0,0));
            --self.sprite:ignoreAnchorPointForPosition(true);
        end
    end
end

function BatchLayer:initImageLayer(imageUrl)
    self.sprite = CCSpriteBatchNode:create(imageUrl);
    if self.sprite then
        self.sprite:retain();
        self.sprite:setAnchorPoint(CCPointMake(0,0));
        --self.sprite:ignoreAnchorPointForPosition(true);
    end
end

--
-- MovieClip ---------------------------------------------------------
--

MovieClip = class(EventDispatcher);
function MovieClip:ctor()
	self.class = MovieClip;
    self.armature = nil;    
    self.index = 0;
    self.factory = nil;
    
    local layer = Layer.new();    
    layer:initLayer();
    layer.name = "MovieClip Root";
        
    self.layer = layer;
end

function MovieClip:dispose()
    if self.armature then
        self.armature:dispose();
        self.armature = nil;
    end
    if self.factory then
        self.factory:dispose();
        self.factory = nil;
    end
    
    if self.layer then
        self.layer:dispose();
        self.layer = nil;
    end
    
	self:removeSelf();
end

function MovieClip:update(force)
    self.armature:update(force);
end

function MovieClip:setLayer(l)
    if self.layer then
        self.layer:dispose();
        self.layer = nil;
    end
    self.layer = l; 
end

--by default, animation use batch node, UI components use normal scene graph.
function MovieClip:initFromFile(fileName, mainArmatureName, batchMode)
    local isGenerateAnimationMode = false;
    if animationMode ~= nil then isGenerateAnimationMode = animationMode end;
    
    local isBatchMode = false;
    if batchMode ~= nil then isBatchMode = batchMode end;
    
    self.factory = SkeletonFactory.new(); --ui factory
    
    local x = os.clock();
    self.factory:parseDataFromFile(fileName);
    local y = os.clock();
    --print(string.format("parse elapsed time : %.2f\n", y - x));
    x = y;
    
    self.armature = self.factory:buildArmature(mainArmatureName);
    y = os.clock();
    --print(string.format("build elapsed time : %.2f\n", y - x));
    
    if isBatchMode then
        --change animation to batch mode
        local batchNode = self.factory:generateBatchNode();
        local batchLayer = BatchLayer.new();
        batchLayer:initBatchLayer(batchNode);
        self:setLayer(batchLayer);
    end
    
    local armatureClip = self.armature.display;
    self.layer:addChild(armatureClip);
    self.layer.name = "MovieClip Batch Root";
end

function MovieClip:stop()
    if self.armature then   
        self.armature.animation:stop();
    end
end

function MovieClip:gotoAndPlay(frameName, loop)
    if self.armature then   
        self.armature.animation:gotoAndPlay(frameName, loop);
        self.armature:updateBonesZ();
        return true;
    end
    return false;
end

function MovieClip:findChildArmature(childName)
    return self.armature:findChildArmature(childName);
end

function MovieClip:initTextFieldWithString(boneName, string, fontName, isAltas, isFillAltasColor, customLabelBuilderFunc)
    return self.armature:initTextFieldWithString(boneName, string, fontName, isAltas, isFillAltasColor, customLabelBuilderFunc);
end

function MovieClip:disableTouch()
    if self.layer then 
        self.layer.touchEnabled = false;
        self.layer.touchChildren = false;
    end
end
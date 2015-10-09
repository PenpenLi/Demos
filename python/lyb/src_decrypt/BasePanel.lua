require "core.events.EventDispatcher"
require "core.events.DisplayEvent"
require "core.display.Layer"

BasePanel = class(EventDispatcher);
local staticPanelID = 0;
local createdPanelList = {};

function getPanelByID(panelID)
    return createdPanelList[panelID];
end

local function onClosePanelButtonTap(evt)
    local panel = evt.context;
    if panel then panel:closePanel() end;
end

function BasePanel:ctor()
	self.class = BasePanel;
    self.movieClip = nil;
    self.rootScene = nil;
    self.isDarkBackground = true;
    self.isCenterPanel = true;
    self.disableBackTouch = true;
    
    self.content = nil;
    
    local winSize = Director:sharedDirector():getWinSize();
    self.touchMask = TouchLayer.new();
    self.touchMask:initLayer();
    self.touchMask:changeWidthAndHeight(winSize.width, winSize.height);
    
    self.animationDir = 0;
    self._isPanelInitialized = false;
    
    self.panelID = staticPanelID;
    createdPanelList[self.panelID] = self;
    staticPanelID = staticPanelID + 1;
end

function BasePanel:disposePanel()
    if self.closeButton then self.closeButton:dispose() end;  -- button.dispose will remove all events.
    
    self.closeButton = nil;
    self.titleText = nil;
    
    self.rootScene = nil;
    
    --self.hitArea = nil;
    
    createdPanelList[self.panelID] = nil;
    
    if self.movieClip  then self.movieClip:dispose() end;
    self.movieClip = nil;
    
	self:removeSelf();
end

function BasePanel:dispose()
	self:disposePanel();
end

function BasePanel:initPanel(darkBackground, center, disableBackTouch)
    self.isDarkBackground = true;
    self.isCenterPanel = true;
    self.disableBackTouch = true;
    
    if darkBackground ~= nil then self.isDarkBackground = darkBackground end;
    if center ~= nil then self.isCenterPanel = center end;
    if disableBackTouch ~= nil then self.disableBackTouch = disableBackTouch end;
    
    if not self._isPanelInitialized then
        self._isPanelInitialized = true;
        self:onInit();
        
        if self.movieClip then
            self.movieClip.layer:setTag(self.panelID);
            self.closeButton = Button.new(self.movieClip.armature:getBone("panel_close_button"));
            self.closeButton:addEventListener(Events.kStart, onClosePanelButtonTap, self);
    
            self:buildTitleText();
            
            --[[
            self.hitArea = self.movieClip.armature:getBone("hit_area");
            if self.hitArea then self.hitArea:setVisible(false) end; 
            ]]
        end
        
        self:endInit();
    end    
end

function BasePanel:buildTitleText()
    self.titleText = self.movieClip:initTextFieldWithString("panel_close_button", "Level 1", TextFonts.kNormalNumber);
end

function BasePanel:onInit()
end
function BasePanel:endInit()
end

function BasePanel:onEnter()
    self:onResize();
    
    if self.animationDir == 0 then 
        self:movedInFromLeft();
    elseif self.animationDir == 1 then 
        self:movedInFromTop();
    else
        self:onUpdateContent();
    end
end

function BasePanel:onUpdate(dt)
end

function BasePanel:closePanel()
    --if self.movieClip then self.movieClip:disableTouch() end;
    if self.movieClip then self.movieClip.layer:addChild(self.touchMask) end;
    if self.animationDir == 0 then 
        self:movedOutToRight();
    elseif self.animationDir == 1 then 
        self:movedOutToTop();
    else
        self:onClose();
    end
end

function BasePanel:onClose()
    if self.rootScene then
        if self:hasEventListenerByName(Events.kClose) then
            local evt = Event.new(Events.kClose, nil, self);
            self:dispatchEvent(evt);
        end
        self.rootScene:removePopout(self);
    end
end

function BasePanel:onResize()
    if self.movieClip and self.isCenterPanel then
        local bounds = self.movieClip.layer:getGroupBounds(false).size;
        --[[if self.hitArea then 
            bounds = self.hitArea:getDisplay():getGroupBounds(false).size;
        else
            bounds = 
        end]]
        
        local winSize = Director:sharedDirector():getWinSize();
        local px = (winSize.width - bounds.width) * 0.5;
        local py = (winSize.height - bounds.height) * 0.5;
        self.movieClip.layer:setPositionXY(px, py);
    end
end

function BasePanel:onUpdateContent()
end
function BasePanel:stopAllActions()
    if self.movieClip then
        self.movieClip.layer:stopAllActions();
    end
end

local function onPanelEnterAnimationFinished(sender)
    if not sender then return end;
    local pid = sender:getTag();
    local panel = createdPanelList[pid];
    if panel then
        panel:onUpdateContent();
    end
end
local function onPanelExitAnimationFinished(sender)
    if not sender then return end;
    local pid = sender:getTag();
    local panel = createdPanelList[pid];
    if panel then
        panel:onClose();
    end
end

function BasePanel:movedInFromLeft()
    if self.movieClip then
        local actionTime = 0.6;
        local winSize = Director:sharedDirector():getWinSize();
        local actionTarget = self.movieClip.layer;
        local pos = self.movieClip.layer:getPosition();
        
        local moveTo = CCMoveTo:create(actionTime, ccp(pos.x, pos.y));
        --local rotateBy = CCRotateBy:create(actionTime, 4);
        --local ease = CCEaseBackOut:create(CCSpawn:createWithTwoActions(moveTo, rotateBy));
        local ease = CCEaseBackOut:create(moveTo);
        --actionTarget:setRotation(-4);
        actionTarget:setPositionXY(pos.x - winSize.width, pos.y);
        
        actionTarget:stopAllActions();
        actionTarget:runAction(CCSequence:createWithTwoActions(ease, CCCallFuncN:create(onPanelEnterAnimationFinished)));
    end
end
function BasePanel:movedOutToRight()
    if self.movieClip then
        local actionTime = 0.6;
        local winSize = Director:sharedDirector():getWinSize();
        local actionTarget = self.movieClip.layer;
        local pos = self.movieClip.layer:getPosition();
        
        local moveTo = CCMoveTo:create(actionTime, ccp(winSize.width+100, pos.y));
        --local rotateBy = CCRotateBy:create(actionTime, 4);
        --local ease = CCEaseBackIn:create(CCSpawn:createWithTwoActions(moveTo, rotateBy));
        local ease = CCEaseBackIn:create(moveTo);
        
        actionTarget:stopAllActions();
        actionTarget:runAction(CCSequence:createWithTwoActions(ease, CCCallFuncN:create(onPanelExitAnimationFinished)));
    end
end

function BasePanel:movedInFromTop()
    if self.movieClip then
        local pos = self.movieClip.layer:getPosition();
        local moveTo = CCMoveTo:create(0.4, ccp(pos.x, pos.y));
        local ease = CCEaseBackOut:create(moveTo);
        self.movieClip.layer:setPositionXY(pos.x, pos.y - 150);
        
        self.movieClip.layer:stopAllActions();
        self.movieClip.layer:runAction(CCSequence:createWithTwoActions(ease, CCCallFuncN:create(onPanelEnterAnimationFinished)));
    end
end

function BasePanel:movedOutToTop()
    if self.movieClip then
        local pos = self.movieClip.layer:getPosition();
        local moveTo = CCMoveTo:create(0.4, ccp(pos.x, pos.y-150));
        local ease = CCEaseBackIn:create(moveTo);
        
        self.movieClip.layer:stopAllActions();
        self.movieClip.layer:runAction(CCSequence:createWithTwoActions(ease, CCCallFuncN:create(onPanelExitAnimationFinished)));
    end
end
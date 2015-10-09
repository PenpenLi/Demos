-------------------------------------------------------------------------
--  Class include: Switcher, Button
-------------------------------------------------------------------------

require "core.events.EventDispatcher"
require "core.events.DisplayEvent"
require "core.display.Layer"
require "core.display.TextField"

--
-- Switcher ---------------------------------------------------------
--
Switcher = class();
function Switcher:ctor(armature, name1, name2, secondSelected)
    self.itemA = armature:getBone(name1);
    self.itemB = armature:getBone(name2);
    
    if secondSelected then
        if self.itemA then self.itemA:getDisplay():setVisible(false) end;
        if self.itemB then self.itemB:getDisplay():setVisible(true) end;        
    else
        if self.itemA then self.itemA:getDisplay():setVisible(true) end;
        if self.itemB then self.itemB:getDisplay():setVisible(false) end;
    end
end

function Switcher:select(secondSelected)
    if secondSelected then
        if self.itemA then self.itemA:getDisplay():setVisible(false) end;
        if self.itemB then self.itemB:getDisplay():setVisible(true) end;        
    else
        if self.itemA then self.itemA:getDisplay():setVisible(true) end;
        if self.itemB then self.itemB:getDisplay():setVisible(false) end;
    end
end


ButtonLabelNames = {kNormal = "normal", kTouch = "touch", kDisabled = "disable"}

--
-- Button ---------------------------------------------------------
--

local function onButtonTap(button, evt)
    if not button then return end;
    if button.enabled == false then 
        return 
    end
    if button:hasEventListenerByName(Events.kStart) then
        local evt = Event.new(Events.kStart, nil, button);
        button:dispatchEvent(evt);
        MusicUtils:playEffect(8,false);
    end
end
local function onButtonTouchBegin(button, evt)
    if button then
        if button.enabled == false then 
            return 
        end
        local display_ = button:getDisplay();
        local target_ = button:getAnimationTarget();
        target_:setColor(ccc3(200,200,200));
        if display_:getScale()>0.9 then
            target_:setPositionX(target_:getPositionX()+button.btn_dw);
            target_:setPositionY(target_:getPositionY()+button.btn_dh);
            -- if button.scaleAnimation then display_:setScale(0.9) end;
            display_:setScale(0.9)
        end
          -- if button.isBone then
            
          -- else
          --   button.bone.animation:gotoAndPlay(ButtonLabelNames.kTouch);
          --   button.bone:update();
          -- end
    end
end
local function onButtonTouchEnd(button, evt)
    if button then
        if button.enabled == false then 
            return 
        end
        local display_ = button:getDisplay();
        local target_ = button:getAnimationTarget();
        target_:setColor(ccc3(255,255,255));
        if display_:getScale()<1 then
            display_:setScale(1);
            target_:setPositionX(target_:getPositionX()-button.btn_dw);
            target_:setPositionY(target_:getPositionY()-button.btn_dh);
        end
        if button.isBone then
            
        else
          button.bone.animation:gotoAndPlay(ButtonLabelNames.kNormal);
          button.bone:update();
        end
    end
end

local function initButton(button)
    if button.bone then
        local display_ = nil;
        if button.isBone then
            display_ = button.bone:getDisplay();
        else
             --armature
            --local hitArea = button.bone:getBone("hit_area");
            --if hitArea then hitArea:setVisible(false) end;
            display_ = button.bone.display;
        end
        
        if display_ then
            display_:addEventListener(DisplayEvents.kTouchTap, onButtonTap, button);
            display_:addEventListener(DisplayEvents.kTouchBegin, onButtonTouchBegin, button);
            display_:addEventListener(DisplayEvents.kTouchEnd, onButtonTouchEnd, button);
        end


    end
end

Button = class(EventDispatcher);
function Button:ctor(bone, scaleAnimation,str,isBMT)
	self.class = Button;
	self.bone = bone;
    self.isBMT = isBMT;
    local btn_d = self:getDisplay():getChildAt(0);
    if btn_d then
        self.btnBoneName = btn_d.name;
        self.btn_width = btn_d:getContentSize().width;
        self.btn_height = btn_d:getContentSize().height;
        self.btn_dw = btn_d:getContentSize().width*0.05;
        self.btn_dh = -btn_d:getContentSize().height*0.05;
        -- btn_d:setAnchorPoint(CCPointMake(0.5, 0.5))
        -- btn_d:setPositionXY(self.btn_width / 2, -1 * btn_d:getContentSize().height / 2)
    end
	self.isBone = bone:is(Bone);
	
	self.scaleAnimation = true;
	if scaleAnimation ~= nil then self.scaleAnimation = scaleAnimation end;
	
    initButton(self);
    if self.btnBoneName then
        if isBMT then
            self.label = self.bone:initTextFieldWithString(self.btnBoneName,str and str or "","anniutuzi",true);
            local bm_size = self.label:getContentSize();
            self.label:setPositionXY((self.btn_width-bm_size.width)/2,(self.btn_height-bm_size.height)/2-self.btn_height);

            -- self.label:setAnchorPoint(CCPointMake(0.5, 0.5))
            -- self.label:setPositionXY(bm_size.width / 2, -1 * bm_size.height / 2)

        else
            self.label = self.bone:initTextFieldWithString(self.btnBoneName,str and str or "",nil,nil,nil,nil,true);
        end 
        if self.label then
            self.touchEnabled = false;
            self.touchChildren = false;
        end
    else
        self.label = nil;
    end
end

function Button:disposeButton()
    if self.bone then
        local display_ = self:getDisplay();
        if display_ then display_:removeAllEventListeners() end;
        self.bone = nil;
    end
    
    self:removeAllEventListeners();
    self.label = nil;
	self:removeSelf();
end

function Button:dispose()
    self:disposeButton();
end
function Button:buildLabel(textFieldBuilderFunc)
    self.label = textFieldBuilderFunc(self.bone);
    if self.label then
        self.touchEnabled = false;
        self.touchChildren = false;
    end
end
function Button:setLable(str)
    if self.label then
        self.label:setString(str);
        if self.isBMT then
            local bm_size = self.label:getContentSize();
            self.label:setPositionX((self.btn_width-bm_size.width)/2);
        end
    end
end

function Button:getDisplay()
    local display_ = nil;
    if self.isBone then
        display_ = self.bone:getDisplay();
    else
        display_ = self.bone.display; --armature
    end
    return display_;
end
function Button:getParent()
    local display_ = self:getDisplay();
    return display_:getParent();
end
function Button:getPosition()
    local display_ = self:getDisplay();
    return display_:getPosition();
end
function Button:getAnimationTarget()
    local display_ = nil;
    if self.isBone then
        display_ = self.bone:getDisplay();
    else
        local buttonBone = self.bone:getBone("button");
        if buttonBone then
            display_ = buttonBone:getDisplay();
        else
            display_ = self.bone.display; --armature
        end
    end
    return display_;
end

function Button:movedInFromBottom(delayTime)
    local display_ = self:getDisplay();
    if display_ then
        display_:setVisible(false);
        local pos = display_:getPosition();
        local moveTo = CCMoveTo:create(0.35, pos);
        local ease = CCEaseBackOut:create(moveTo);
        
        local sequenceArray = CCArray:create();
        sequenceArray:addObject(CCDelayTime:create(delayTime));
        sequenceArray:addObject(CCShow:create());
        sequenceArray:addObject(ease);
        
        display_:setPositionXY(pos.x, pos.y + 50, true);
        display_:stopAllActions();
        display_:runAction(CCSequence:create(sequenceArray));
    end
end

function Button:movedInFromLeft(delayTime)
    local display_ = self:getDisplay();
    if display_ then
        local pos = display_:getPosition();
        local moveTo = CCMoveTo:create(0.4, pos);
        local ease = CCEaseBackOut:create(moveTo);
        
        display_:setPositionXY(pos.x - 100, pos.y, true);
        display_:stopAllActions();
        
        delayTime = delayTime or 0;
        if delayTime > 0 then
            display_:setVisible(false);
            local sequenceArray = CCArray:create();
            sequenceArray:addObject(CCDelayTime:create(delayTime));
            sequenceArray:addObject(CCShow:create());
            sequenceArray:addObject(ease);
            display_:runAction(CCSequence:create(sequenceArray));
        else
            display_:runAction(ease);
        end
    end
end

function Button:setEnabled(enable)
    local display_ = self:getAnimationTarget();
    display_.touchEnabled = enable;
    display_.touchChildren = enable;
    if not self.enableSprite then
        local cr = display_:getChildByName(self.btnBoneName);
        local textureRect = cr:getTextureRect();
        local anP = cr:getAnchorPoint();
        self.enableSprite = Sprite.new(getGraySprite(cr.sprite,textureRect.origin.x,textureRect.origin.y,true));
        self.enableSprite:setAnchorPoint(anP);
    end
    if enable then
        self.bone.animation:gotoAndPlay(ButtonLabelNames.kNormal);
        self.bone:update();
        display_:removeChild(self.enableSprite,true);
        self.enableSprite = nil;
    else
        self.bone.animation:gotoAndPlay(ButtonLabelNames.kDisabled);
        self.bone:update();
        display_:addChildAt( self.enableSprite,1);
    end
end

function Button:setVisible(bool)
    local display_ = self:getDisplay();
    if display_ then
        display_:setVisible(bool);
    end
end
function Button:setPositionXY(x,y)
    local display_ = self:getDisplay();
    if display_ then
        display_:setPositionXY(x,y);
    end
end
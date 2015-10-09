require "core.skeleton.Nodes"
require "core.skeleton.MovementData"

-- A core object that can control the animation state of a bone
-- initialize
Tween = class(Object);

function Tween:ctor(bone)
    self.bone = bone;
	
	self.movementBoneData = nil; -- of <MovementBoneData>
	self.currentKeyFrame = nil; -- of <FrameData>
	self.nextKeyFrame = nil; -- of <FrameData>
	
	self.isComplete = true; --Indicates whether the animation is completed
	self.isPause = false; --Indicates whether the animation is paused
	
	self.totalSeconds = 0; -- by seconds
	self.numFrames = 0;
	self.loop = false;
	
	self.class = Tween;
end

function Tween:toString()
	return "Tween";
end

function Tween:dispose()
	self.bone = nil;
	
	self.movementBoneData = nil;
	self.currentKeyFrame = nil;
	self.nextKeyFrame = nil;
	
	self:removeSelf();
end

--Indicates whether the animation is playing
function Tween:getIsPlaying()
	return (not self.isComplete) and (not self.isPause);
end

function Tween:stop()
	self.isPause = true;
	local display_ = self.bone:getDisplay();
    if display_ and display_.sprite then
        display_:stopAllActions();
    end
	
	--stop children
	local childArmature = self.bone:getChildArmature();
	if childArmature then childArmature.animation:stop() end;
end

function Tween:play()
	if not self.movementBoneData then return end;
	if self.isPause then
		if self.isComplete then
			self.isComplete = false;
		end
		self.isPause = false;
	else
		if self.isComplete then self:gotoAndPlay(self.movementBoneData) end;
	end
end

local function tweenFrameBetween(currentFrameData, nextFrameData, beforeFrameData, sequenceArray, eachActionTime, isFirstFrame)
    local frameActionList = {};
    local duration = currentFrameData.duration or 1;
    if duration < 1 then duration = 1 end; 
    
    if duration > 1 then 
        eachActionTime = eachActionTime * duration;
    end
    
    -- visible
    local toggle = nil;
    local hided = false;
    if isFirstFrame then
        if not currentFrameData.visible then 
            toggle = CCHide:create();
            hided = true;
        end
    else
        if beforeFrameData and currentFrameData.visible ~= beforeFrameData.visible then
            if currentFrameData.visible then
                toggle = CCShow:create();
            else
                toggle = CCHide:create();
                hided = true;
            end
        end
    end
    if toggle then table.insert(frameActionList, toggle) end;
    
    if hided then 
        sequenceArray:addObject(CCDelayTime:create(eachActionTime));
    else
        --position
        if nextFrameData.x ~= currentFrameData.x or nextFrameData.y ~= currentFrameData.y then
            local moveTo = CCMoveTo:create(eachActionTime, ccp(nextFrameData.x, nextFrameData.y));
            table.insert(frameActionList, moveTo);
        end
        
        --scale
        if nextFrameData:getRealScaleX() ~= currentFrameData:getRealScaleX() or nextFrameData:getRealScaleY() ~= currentFrameData:getRealScaleY() then
            local scaleTo = CCScaleTo:create(eachActionTime, nextFrameData:getRealScaleX(), nextFrameData:getRealScaleY());
            table.insert(frameActionList, scaleTo);
        end
        
        --rotation
        
        local nextRotation, currentRotation = nextFrameData:getRealRotation(), currentFrameData:getRealRotation();
        if nextRotation ~= currentRotation then
            --static CCRotateBy* create(float duration, float fDeltaAngle);
            local rotateBy = CCRotateTo:create(eachActionTime, nextRotation);
            table.insert(frameActionList, rotateBy);
        end
        
        --[[
        if nextFrameData.skewX ~= currentFrameData.skewX or nextFrameData.skewY ~= currentFrameData.skewY then
            local skewBy = CCSkewTo:create(eachActionTime, currentFrameData.skewX, currentFrameData.skewY);
            table.insert(frameActionList, skewBy);
        end
        ]]
    end
    
    if table.getn(frameActionList) > 0 then
        local spawnArray = CCArray:create();
        for spi, spv in ipairs(frameActionList) do spawnArray:addObject(spv) end;
        local spawn = CCSpawn:create(spawnArray);
        sequenceArray:addObject(spawn);
    else
        local delay = CCDelayTime:create(eachActionTime);
        sequenceArray:addObject(delay);
    end
end

function Tween:buildAnimationAction(loop)    
    local frameList = self.movementBoneData.frameList;
    local delayTime = self.movementBoneData.delay;
    local length = self.numFrames;
    local eachActionTime = self.totalSeconds / self.numFrames;
    local sequenceArray = CCArray:create();
    
    if delayTime > 0.001 then
        --local delayAction = CCDelayTime:create(eachActionTime);
        --sequenceArray:addObject(delayAction);
    end
    
    for i, v in ipairs(frameList) do
        local isFirstFrame = i==1;
        if i < length then
            tweenFrameBetween(v, frameList[i+1], frameList[i-1], sequenceArray, eachActionTime, isFirstFrame);
        else
            if self.loop then
                tweenFrameBetween(v, frameList[1], frameList[i-1], sequenceArray, eachActionTime, isFirstFrame);
            end
        end
    end
    
    local sequence = CCSequence:create(sequenceArray);
    local actionResult = sequence;
    if self.loop then
        repeatForever = CCRepeatForever:create(sequence);
        actionResult = repeatForever;
    end
    
    return actionResult;
end

function Tween:gotoAndPlay(animation, loop, totoalFrames)
	if animation:is(MovementBoneData) then
		self.movementBoneData = animation;
	else
		self.movementBoneData = nil;
	end
	if not self.movementBoneData then return end;

	self.currentKeyFrame = nil;
	self.nextKeyFrame = nil;

	--super
	self.isComplete = false;
	self.isPause = false;
	
	local isLoop = true;
    if loop ~= nil then isLoop = loop end;
    self.loop = isLoop;
	
	local animationFps = Director:sharedDirector().resourceAnimationFPS;
	local gameFPS = Director:sharedDirector().gameFPS;
	local fpsScale = 1; --gameFPS/animationFps;
	local movementBoneFrameList = self.movementBoneData.frameList;
	self.numFrames = table.getn(movementBoneFrameList);
	self.nextKeyFrame = movementBoneFrameList[1]; -- lua table start from 1.
	self.totalSeconds = totoalFrames * fpsScale/gameFPS;
	
	--update
	self:updateHandler();
end

--[[
function Tween:update()
	if self.isComplete or self.isPause then return end;
	self:updateHandler();
end
]]

function Tween:updateHandler()
	self.currentKeyFrame = self.nextKeyFrame;
	self.isComplete = true;

	if self.currentKeyFrame then
		
		local visible = self.currentKeyFrame.visible;
		local di = self.currentKeyFrame.displayIndex;
		if di >= 0 then
			if self.bone.globalZ ~= self.currentKeyFrame.z then
				self.bone.globalZ = self.currentKeyFrame.z;
				if self.bone.armature then self.bone.armature.bonesIndexChanged = true end;
			end
		end

		self.bone:changeDisplay(di);
		local display_ = self.bone:getDisplay();
		if display_ and display_.sprite and self.numFrames > 1 and self.totalSeconds > 0.00001 then
		    --aniumat position, scale, rotation, visible
	        local act = self:buildAnimationAction(self.loop);
	        display_:stopAllActions();
	        display_:runAction(act);
	    else
	        --with out tween animation, set visible direct.
		    if display_ then display_:setVisible(visible) end;
		end
		
		if self.currentKeyFrame.movement then
			local arm = self.bone:getChildArmature();
			if arm then
				arm.animation:gotoAndPlay(self.currentKeyFrame.movement);
			end
		end
		
		self.currentKeyFrame = nil;
	end
end
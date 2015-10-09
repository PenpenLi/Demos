--require "skeleton.Matrix2D"
require "core.skeleton.Nodes"
require "core.skeleton.BoneData"
require "core.skeleton.MovementData"
require "core.skeleton.TextureAtlasData"
require "core.skeleton.SkeletonData"

-- initialize
SkeletonAndTextureAtlasData = class();

function SkeletonAndTextureAtlasData:ctor()
	self.skeletonData = nil;
	self.textureAtlasData = nil;
	self.class = nil;
end

function SkeletonAndTextureAtlasData:dispose()
	self.skeletonData = nil;
	self.textureAtlasData = nil;
end

function SkeletonAndTextureAtlasData:toString()
	return "SkeletonAndTextureAtlasData";
end

-- search node
local function getBoneConfigFromTableByName(src, name)
	if not name then
		return nil;
	end

	for k, v in pairs(src) do
		if v.name == name then
			return v;
		end
	end

	return nil;
end
--parse

local function parseBoneData(src, parent, boneData)
	if not boneData then
		boneData = BoneData.new();
	end

	boneData.name = src.name;
	boneData.x = src.x;
	boneData.y = src.y;
	boneData.skewX = src.kx;
	boneData.skewY = src.ky;
	boneData.scaleX = src.cx;
	boneData.scaleY = src.cy;
	boneData.z = src.z;
		
	if src.text then
	    local text = src.text;
	    local textData = TextData.new();
		textData.x = text.x;
	    textData.y = text.y;
	    textData.width = text.w;
	    textData.height = text.h;
	    textData.color = tonumber(text.color, 16);
	    textData.size = text.size;
	    textData.lineType = text.lineType;
	    textData.textType = text.textType;
	    local alignment = kCCTextAlignmentLeft;
	    if text.alignment == "center" then
            alignment = kCCTextAlignmentCenter;
        elseif text.alignment == "right" then
            alignment = kCCTextAlignmentRight;
        end
	    textData.alignment = alignment; --kCCTextAlignmentLeft, kCCTextAlignmentCenter, kCCTextAlignmentRight
        textData.letterSpacing = text.letterSpacing;
        boneData.textData = textData;
	end

	local displayList = src.d;
	for k, v in pairs(displayList) do
		local isArmature = v.isArmature or 0;
		local displayData = DisplayData.new();
		displayData.name = v.name;
		displayData.isArmature = (isArmature == 1);
		table.insert(boneData.displayList, displayData);
	end

	if parent then
		boneData.parent = parent.name;
	end

	return boneData;
end

local function parseAramtureData(src)
	local armature = src;
	local aramtureData = ArmatureData.new();
	aramtureData.name = armature.name;
	local bones = armature.bones;

	for k, v in pairs(bones) do
		local boneName = v.name;
		local parentName = v.parent;
		local parent = getBoneConfigFromTableByName(bones, parentName);
		local boneData = aramtureData:getBoneData(boneName);
		boneData = parseBoneData(v, parent, boneData);
		aramtureData:addBoneData(boneData);
	end

	aramtureData:updateBoneList();

	return aramtureData;
end

local function parseFrameData(src, parent, boneData, frameData)
	if not frameData then
		frameData = FrameData.new();
	end

	frameData.x = src.x;
	frameData.y = src.y;
	
	frameData.visible = true;--(src.vi == 1);

	frameData.skewX = src.kx;
	frameData.skewY = src.ky;

	frameData.z = src.z;
	frameData.duration = src.dr;
	frameData.displayIndex = src.di + 1;

	frameData.tweenEasing = src.twe;
	frameData.tweenRotate = src.twr;
	frameData.movement = src.mv;
	frameData.event = src.evt;

	frameData.scaleX = src.cx;
	frameData.scaleY = src.cy;

	return frameData;
end

local function parseMovementBoneData(src, parent, boneData, movementBoneData)
	if not movementBoneData then
		movementBoneData = MovementBoneData.new();
	end
	movementBoneData.name = src.name;
	movementBoneData.duration = 0;

	local scale = src.sc or 0;
	local delay = src.dl or 0;
	movementBoneData:setValues(scale, delay);

	local parentTotalDuration = 0;
	local currentDuration = 0;
	local parentFrameList = nil;
	local i = 1;
	local parentLength = 0;
	if parent then
		parentFrameList = parent.f;
		parentLength = table.getn(parentFrameList)+1;
	end

	local totalDuration = 0;
	local frames = src.f;
	local parentFrame = nil;
	for k, v in ipairs(frames) do
		if parent and parentFrameList then
			local checkTotalDuration = true;
			while i < parentLength and checkTotalDuration do
				parentFrame = parentFrameList[i];
				parentTotalDuration = parentTotalDuration + currentDuration;
				currentDuration = parentFrame.dr or 0;
				i = i+1;
				checkTotalDuration = (totalDuration < parentTotalDuration) or (totalDuration >= (parentTotalDuration + currentDuration));
				if not parentFrame then checkTotalDuration = true end;
			end
		end
		local frameData = parseFrameData(v, parentFrame, boneData, nil);
		table.insert(movementBoneData.frameList, frameData);
		movementBoneData.duration = movementBoneData.duration + frameData.duration;
		totalDuration = totalDuration + frameData.duration;
	end

	return movementBoneData;
end

local function parseMovementData(src, armatureData, movementData)
	if not movementData then
		movementData = MovementData.new();
	end
	movementData.name = src.name;

	local duration = src.dr or 1;
	local durationTo = src.to or 0;
	local durationTween = src.twdr or 0;
	local loop = src.lp or 0;
	local tweenEasing = src.twe;
	movementData:setValues(duration, durationTo, durationTween, loop==1, tweenEasing);

	local bones = src.b;
	for k, v in pairs(bones) do
		local boneName = v.name;
		local boneData = armatureData:getBoneData(boneName);
		local parent = getBoneConfigFromTableByName(bones, boneData.parent);
		local movementBoneData = movementData:getMovementBoneData(boneName);
		movementBoneData = parseMovementBoneData(v, parent, boneData, movementBoneData);
		movementData:addMovementBoneData(movementBoneData);
	end

	--todo: movement frame not implemented as bubble animation do not need it.

	return movementData;
end

local function parseAnimationData(src, skeletonData)
	local animationName = src.name;
	local animationData = skeletonData:getAnimationData(animationName);
	if not animationData then
		animationData = AnimationData.new();
		animationData.name = animationName;
	end

	local aramtureData = skeletonData:getArmatureData(animationName);

	local movements = src.mov;
	for k, v in pairs(movements) do
		local movementName = v.name;
		local movementData = animationData:getMovementData(movementName);
		movementData = parseMovementData(v, aramtureData, movementData);
		animationData:addMovementData(movementData);
	end

	return animationData;
end


function SkeletonAndTextureAtlasData:parseSkeletonData(config)
	local skeletonData = SkeletonData.new();
	skeletonData.name = config.name; -- ignore frameRate, version check.
	local armatures = config.armatures;

	for k, v in pairs(armatures) do
		local aramtureData = parseAramtureData(v);
		skeletonData:addArmatureData(aramtureData);

	end

	local animations = config.animations;
	for k, v in pairs(animations) do
		local animationData = parseAnimationData(v, skeletonData);
		skeletonData:addAnimationData(animationData);
	end

	self.skeletonData = skeletonData;
	return skeletonData;
end

function SkeletonAndTextureAtlasData:parseTextureAtlasData(config)
	local textureAtlasData = TextureAtlasData.new();
	textureAtlasData.name = config.name;
	textureAtlasData.width = config.width;
	textureAtlasData.height = config.height;

	local subTextureList = config.s;
	for i, v in ipairs(subTextureList) do
		local subTextureData = SubTextureData.new();
		subTextureData.name = v.name;
		subTextureData.x = v.x or 0;
		subTextureData.y = v.y or 0;
		subTextureData.width = v.width or 0;
		subTextureData.height = v.height or 0;
		subTextureData.pivotX = v.px or 0;
		subTextureData.pivotY = v.py or 0;
		subTextureData:updateAnchor();
		textureAtlasData:addSubTextureData(subTextureData);
	end

	self.textureAtlasData = textureAtlasData;
	return textureAtlasData;
end

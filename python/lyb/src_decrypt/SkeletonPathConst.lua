require "core.display.Sprite"
require "core.events.EventDispatcher"

require "core.skeleton.Nodes"
require "core.skeleton.SkeletonAndTextureAtlasData"
require "core.skeleton.DisplayBridge"

require "core.skeleton.Tween"
require "core.skeleton.Bone"
require "core.skeleton.Armature"
require "core.controls.Common9GridSprite"
require "main.config.SizeDefine4Sprite9ridConfig";

SkeletonPathConst = {
	kTextureResourcePath = "resource/image/ui/",
	kTextureImageExtention = "_output/texture.png",
  
	kTextureConfigResourcePath = "resource.image.ui.",
	kTextureConfigExtention = "_output.texture",
	kTextureAnimationExtention = "_output.skeleton"
}

kCommonUINamePrefix = "common_";
kCommonUINameCopyPrefix = "common_copy_";

CommonSkeletonPathConst="common_ui";
CommonSkeleton=nil;

CommonPanelSkeletonPathConst="common_panel_ui";
CommonPanelSkeleton=nil;

local skeletonConfigMap = {};


function loadCommonUIAssets()
	CommonSkeleton = SkeletonFactory.new();
	CommonSkeleton:parseDataFromFile(CommonSkeletonPathConst);
end

function loadCommonUIPanelAssets()
	CommonPanelSkeleton = SkeletonFactory.new();
	CommonPanelSkeleton:parseDataFromFile(CommonPanelSkeletonPathConst);
end

function clearCachedSkeletonConfig()
    for k, v in pairs(skeletonConfigMap) do
        v:dispose();
    end
    skeletonConfigMap = {};
end

-- initialize
SkeletonFactory = class(EventDispatcher);
function SkeletonFactory:ctor()
	self.skeletonData = nil; -- of <SkeletonData>, A set of armature datas and animation datas
	self.textureAtlasData = nil; -- of <TextureAtlasData>, A set of texture datas

	self.class = SkeletonFactory;
end

function SkeletonFactory:toString()
	return string.format("SkeletonFactory");
end

function SkeletonFactory:dispose()
	self.skeletonData = nil;
	self.textureAtlasData = nil;

	self:removeSelf();
end

-- public methods
function SkeletonFactory:parseData(tableSkeletonData, tableTextureAtlasData)
	local sat = SkeletonAndTextureAtlasData.new();
	sat:parseSkeletonData(tableSkeletonData);
	self.skeletonData = sat.skeletonData;
	self.textureAtlasData = sat:parseTextureAtlasData(tableTextureAtlasData);
	--sat:dispose();
	return sat;
end

function SkeletonFactory:getTextureFileName(name)
	-- if name == "heroPicture_ui" then
	-- 	return SkeletonPathConst.kTextureResourcePath..name.."_output/texture.pvr.ccz";
	-- else
		return SkeletonPathConst.kTextureResourcePath..name..SkeletonPathConst.kTextureImageExtention;
	-- end
end

function SkeletonFactory:parseDataFromFile(fileName)
    local cachedList = skeletonConfigMap[fileName];    
    if cachedList then
        local cachedSkeletonAndTextureAtlasData = cachedList[1]
        self.skeletonData = cachedSkeletonAndTextureAtlasData.skeletonData;
	    self.textureAtlasData = cachedSkeletonAndTextureAtlasData:parseTextureAtlasData(cachedList[2]);
    else
        local tableSkeletonFile = SkeletonPathConst.kTextureConfigResourcePath..fileName..SkeletonPathConst.kTextureAnimationExtention;
        local tableTextureAtlasFile = SkeletonPathConst.kTextureConfigResourcePath..fileName..SkeletonPathConst.kTextureConfigExtention;
        --package.loaded["a.b"] = nil
        local tableSkeletonData = require(tableSkeletonFile)
        local tableTextureAtlasData = require(tableTextureAtlasFile)
        if tableSkeletonData and tableTextureAtlasData then
            local sat = self:parseData(tableSkeletonData, tableTextureAtlasData);
            cachedList = {sat, tableTextureAtlasData};
            skeletonConfigMap[fileName] = cachedList;
        end
    end
end

--generation

function SkeletonFactory:generateArmature()
	local rect = CCRectMake(0,0,1,1);
	local fileName = self:getTextureFileName(self.textureAtlasData.name);
	local texture = CCTextureCache:sharedTextureCache():addImage(fileName);
	local frame = CCSpriteFrame:createWithTexture(texture, rect);
	local spriteExt = CCSprite:createWithSpriteFrame(frame);
	
	local display = Sprite.new(spriteExt);
	local armature = Armature.new(display);
	return armature;
end

function SkeletonFactory:generateBone()
	local display = DisplayBridge.new();
	local bone = Bone.new(display);
	return bone;
end

function SkeletonFactory:generateBatchNode()
    local fileName = self:getTextureFileName(self.textureAtlasData.name);
    local batch = CCSpriteBatchNode:create(fileName);
    return batch;
end

function SkeletonFactory:getTexture(textureAtlasData, fullName)
	local subTextureData = textureAtlasData:getSubTextureData(fullName);
	if subTextureData then
		local rect = CCRectMake(subTextureData.x,subTextureData.y,subTextureData.width,subTextureData.height);
		local fileName = self:getTextureFileName(textureAtlasData.name);
		local texture = CCTextureCache:sharedTextureCache():addImage(fileName);
		local frame = CCSpriteFrame:createWithTexture(texture, rect);
		return CCSprite:createWithSpriteFrame(frame);
	end
	return nil;
end

function SkeletonFactory:getTextureDisplay(textureAtlasData, fullName, left_top_boolean)

	local subTextureData = textureAtlasData:getSubTextureData(fullName);
	if subTextureData then
		local rect = CCRectMake(subTextureData.x,subTextureData.y,subTextureData.width,subTextureData.height);
		local fileName = self:getTextureFileName(textureAtlasData.name);
		local texture = CCTextureCache:sharedTextureCache():addImage(fileName);
		local frame = CCSpriteFrame:createWithTexture(texture, rect);
		local spriteExt = CCSprite:createWithSpriteFrame(frame);
		local sprite = Sprite.new(spriteExt);
		sprite.pivotX = subTextureData.pivotX;
		sprite.pivotY = left_top_boolean and subTextureData.pivotY or 0;
		sprite.anchorX = subTextureData.anchorX;
		sprite.anchorY = left_top_boolean and subTextureData.anchorY or 0;
		sprite:updatePivot();

		return sprite;
	end
	return nil; 
end

function SkeletonFactory:getTexture9Grid(textureAtlasData, fullName, sx, sy)


	local subTextureData = textureAtlasData:getSubTextureData(fullName);
	if subTextureData then
		local rect = CCRectMake(subTextureData.x,subTextureData.y,subTextureData.width,subTextureData.height);
		local fileName = self:getTextureFileName(textureAtlasData.name);
		local texture = CCTextureCache:sharedTextureCache():addImage(fileName);
		local frame = CCSpriteFrame:createWithTexture(texture, rect);
		local rectCap = CCRectMake(-0.5+subTextureData.x+subTextureData.width/2,-0.5+subTextureData.y+subTextureData.height/2,1,1);
		local sprite = CCScale9Sprite:createWithSpriteFrame(frame, rectCap);
		if sx and sy then
			sprite:setContentSize(CCSizeMake(sx*subTextureData.width,sy*subTextureData.height));
		end
		return sprite;
	end
	return nil;
end

function SkeletonFactory:getTexture9Display(textureAtlasData, fullName, left_top_boolean, sx, sy)
	local subTextureData = textureAtlasData:getSubTextureData(fullName);
	if subTextureData then
		local rect = CCRectMake(subTextureData.x,subTextureData.y,subTextureData.width,subTextureData.height);
		local fileName = self:getTextureFileName(textureAtlasData.name);
		local texture = CCTextureCache:sharedTextureCache():addImage(fileName);
		local frame = CCSpriteFrame:createWithTexture(texture, rect);
		local rectCap = CCRectMake(-0.5+subTextureData.x+subTextureData.width/2,-0.5+subTextureData.y+subTextureData.height/2,1,1);
		local spriteExt = CCScale9Sprite:createWithSpriteFrame(frame, rectCap);
		local sprite = Common9GridSprite.new(spriteExt);
		sprite.pivotX = subTextureData.pivotX;
		sprite.pivotY = left_top_boolean and subTextureData.pivotY or 0;
		sprite.anchorX = subTextureData.anchorX;
		sprite.anchorY = left_top_boolean and subTextureData.anchorY or 0;
		sprite:updatePivot();
		if sx and sy then
			sprite:setContentSize(CCSizeMake(sx*subTextureData.width,sy*subTextureData.height));
		end
		return sprite;
	end
	return nil;
end

function SkeletonFactory:buildCommonArmature(armatureName)
  return CommonSkeleton:buildArmature(armatureName);
end

function SkeletonFactory:getBoneTexture(textureName)
	return self:getTexture(self.textureAtlasData, textureName);
end

function SkeletonFactory:getBoneTextureDisplay(textureName, left_top_boolean)
	return self:getTextureDisplay(self.textureAtlasData, textureName, left_top_boolean);
end

function SkeletonFactory:getBoneTexture9Display(textureName, left_top_boolean, sx, sy)
	return self:getTexture9Display(self.textureAtlasData, textureName, left_top_boolean, sx, sy);
end

function SkeletonFactory:getBoneTexture9DisplayBySize(textureName, left_top_boolean, size)
	local subTextureData = self.textureAtlasData:getSubTextureData(textureName);
	if subTextureData then
		return self:getBoneTexture9Display(textureName, left_top_boolean, size.width/subTextureData.width, size.height/subTextureData.height);
	end
	return nil;
end

function SkeletonFactory:getCommonBoneTexture(textureName)
	local texture = CommonSkeleton:getTexture(CommonSkeleton.textureAtlasData, textureName);
	if not texture then
		texture = CommonPanelSkeleton:getTexture(CommonPanelSkeleton.textureAtlasData, textureName);
	end
	return texture;
end

function SkeletonFactory:getCommonBoneTextureDisplay(textureName, left_top_boolean)
	local display = CommonSkeleton:getTextureDisplay(CommonSkeleton.textureAtlasData, textureName, left_top_boolean);
	if not display then
		display = CommonPanelSkeleton:getTextureDisplay(CommonPanelSkeleton.textureAtlasData, textureName, left_top_boolean);
	end
	return display;
end

function SkeletonFactory:getCommonBoneTexture9Display(textureName, left_top_boolean, sx, sy)
	local display = CommonSkeleton:getTexture9Display(CommonSkeleton.textureAtlasData, textureName, left_top_boolean, sx, sy);
	if not display then
		display = CommonPanelSkeleton:getTexture9Display(CommonPanelSkeleton.textureAtlasData, textureName, left_top_boolean, sx, sy);
	end
	return display;
end

function SkeletonFactory:getCommonBoneTexture9DisplayBySize(textureName, left_top_boolean, size)
	local subTextureData = CommonSkeleton.textureAtlasData:getSubTextureData(textureName);
	if not subTextureData then
		subTextureData = CommonPanelSkeleton.textureAtlasData:getSubTextureData(textureName);
	end
	if subTextureData then
		return self:getCommonBoneTexture9Display(textureName, left_top_boolean, size.width/subTextureData.width, size.height/subTextureData.height);
	end
	return nil;
end

function SkeletonFactory:buildBone(boneData)
	local display = nil;
	local bone = self:generateBone();
	bone.origin:copyBoneData(boneData);
	bone.name = boneData.name;
	bone.textData = boneData.textData;
   
	local length = boneData:getDisplayLength();
	local list = boneData.displayList;
	for i = length, 1, -1 do
		local displayData = list[i]; --getDisplayDataAt
		bone:changeDisplay(i);

		if displayData.isArmature then
			local childArmature = self:buildArmature(displayData.name);
			childArmature.animation:play();
			bone:setDisplay(childArmature);
		else
			local isCommonUI, startIndex = string.find(displayData.name, kCommonUINameCopyPrefix);
			if isCommonUI ~= nil then
				local textureName = string.sub(displayData.name, 1, -1+isCommonUI) .. kCommonUINamePrefix .. string.sub(displayData.name, startIndex + 1, -1);
				if (1~=boneData.scaleX or 1~=boneData.scaleY) and "hit_area"~=boneData.name then
					display = self:getCommonBoneTexture9Display(textureName,true,boneData.scaleX,boneData.scaleY);
				else
					display = self:getCommonBoneTextureDisplay(textureName,true);
				end
			else
				if (1~=boneData.scaleX or 1~=boneData.scaleY) and "hit_area"~=boneData.name then
					display = self:getBoneTexture9Display(displayData.name,true,boneData.scaleX,boneData.scaleY);
				else
					display = self:getBoneTextureDisplay(displayData.name,true);
				end
			end

			if display then
				bone:setDisplay(display);
				display.name = bone.name;
			else
			 --    log("displayData.name:"..displayData.name)
			 --    log("bone.name:"..bone.name)
				-- log("Bone is nil");
			end
		end
    end
    return bone;
end

function SkeletonFactory:findFinalArmatureName(armatureName)
    local data = self.skeletonData;
    local armatureData = data:getArmatureData(armatureName);
    if armatureData then 
        return armatureName;
    else
        for k,v in pairs(data.armatureDatas) do
		    local find = string.find(v.name, armatureName);
		    if find ~= nil then
		        return v.name;
		    end
	    end
    end
    return nil;
end

function SkeletonFactory:buildArmature(armatureName)
    armatureName = self:findFinalArmatureName(armatureName);
	local armatureData = self.skeletonData:getArmatureData(armatureName);
	if not armatureData then return nil end;

	local animationData = self.skeletonData:getAnimationData(armatureName);
	local armature = self:generateArmature();
	armature.name = armatureName;
	armature.animation:setData(animationData);
	armature.display.name = armatureName;

	local boneList = armatureData.boneList;
	for i, v in ipairs(boneList) do
		local boneData = armatureData:getBoneData(v);
		local bone = self:buildBone(boneData);

		-- 
		if bone then
			armature:addBone(bone, boneData.parent);
		else
			error("Bone is nil");
		end
	end
	--armature:update();
	return armature;
end

loadCommonUIAssets();
loadCommonUIPanelAssets();
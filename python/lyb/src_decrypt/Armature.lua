require "core.skeleton.Animation"
require "core.events.EventDispatcher"

-- initialize
-- The core object of a skeleton animation system.
-- It contains the root display object, the animation which can the change playback state and all sub-bones.
Armature = class(EventDispatcher);
--display:Represents the root display object for all sub-bones.
function Armature:ctor(display)
	self.name = nil; --The name of the Armature.
	self.userData = nil; --An object that can contain any extra data.

	self.animation = Animation.new(self);  --An object can change the playback state of the armature.
	self.display = display; --a display object which is dependent on specific display engine.

	self.bonesIndexChanged = false;
	self.boneDepthList = {}; -- of <Bone>
	self.rootBoneList = {}; -- of <Bone>

	self.class = Armature;
end
function Armature:toString()
	return "Armature";
end

function Armature:dispose()
    if self.rootBoneList then
        for k, v in pairs(self.rootBoneList) do
		    v:dispose();
	    end
    end
	
	if self.animation then
	    self.animation:dispose();
	    self.animation = nil;
	end	
	if self.display then
		self.display:dispose()
		self.display = nil
	end
	self.boneDepthList = nil;
	self.rootBoneList = nil;
	self:removeSelf();
end

local function sortBoneDepthList(a, b)
	return a.globalZ < b.globalZ;
end

--Sorts the display objects by z value.
function Armature:updateBonesZ()
	table.sort(self.boneDepthList, sortBoneDepthList);
	local list = self.boneDepthList;
	for i, v in ipairs(list) do
		if v then
			v.displayBridge:removeDisplay(false);
		end
	end
	for i, v in ipairs(list) do
		if v and v.displayVisible then
			v.displayBridge:addDisplay(self.display);
		end
	end
	self.bonesIndexChanged = false;
end

-- Updates the state of the armature. Should be called every frame manually.
function Armature:update(force)
	for k, v in pairs(self.rootBoneList) do
		v:update(force);
		if v.name == "hit_area" then
		    v:setVisible(false)
			v.touchEnabled = false
		end		
	end
	--self.animation:update();

	if self.bonesIndexChanged then self:updateBonesZ() end;
end

--Gets a bone by name.
function Armature:getBone(name)
	if not name then return nil end;
	for k, v in pairs(self.boneDepthList) do
		if v.name == name then return v end;
	end
	return nil;
end

--Gets a bone by display.
function Armature:getBoneByDisplay(display)
	if not display then return nil end;
	for k, v in pairs(self.boneDepthList) do
		if v:getDisplay() == display then return v end;
	end
	return nil;
end

function Armature:addToBones(bone, root)
	if not bone then return end;

	local isRoot = root or false;
	local boneIndex = -1;
	-- depth
	for i, v in ipairs(self.boneDepthList) do
		if v == bone then
			boneIndex = i;
			break;
		end
	end
	if boneIndex == -1 then table.insert(self.boneDepthList, bone) end;

	--root
	boneIndex = -1;
	for i, v in ipairs(self.rootBoneList) do
		if v == bone then
			boneIndex = i;
			break;
		end
	end

	if isRoot then
		if boneIndex == -1 then table.insert(self.rootBoneList, bone) end;
	else
		if boneIndex ~= -1 then table.remove(self.rootBoneList, boneIndex) end;
	end

	bone.armature = self;
	bone.displayBridge:addDisplay(self.display, bone.globalZ);

	--add children to bone
	local boneChildren = bone.children;
	for k, v in pairs(boneChildren) do
		self:addToBones(v, false);
	end
end

function Armature:addBone(bone, parentName)
	local boneParent = self:getBone(parentName);
	if boneParent then
		boneParent:addChild(bone);
	else
		bone:removeFromParent();
		self:addToBones(bone, true);
	end
end

function Armature:removeFromBones(bone)
	if not bone then return end;
	local boneIndex = -1;
	-- depth
	for i, v in ipairs(self.boneDepthList) do
		if v == bone then
			boneIndex = i;
			break;
		end
	end
	if boneIndex ~= -1 then table.remove(self.boneDepthList, boneIndex) end;

	--root
	boneIndex = -1;
	for i, v in ipairs(self.rootBoneList) do
		if v == bone then
			boneIndex = i;
			break;
		end
	end
	if boneIndex ~= -1 then table.remove(self.rootBoneList, boneIndex) end;

	bone.armature = nil;
	bone.displayBridge:removeDisplay();

	--remove all bone's children
	local boneChildren = bone.children;
	for k, v in pairs(boneChildren) do
		self:removeFromBones(v);
	end

end

function Armature:removeBone(boneName)
	local bone = self:getBone(boneName);
	if bone then
		if bone.parent then
			bone:removeFromParent();
		else
			self:removeFromBones(bone);
		end
	end
end

--
function Armature:findChildArmature(childName)
    local bone_ = self:getBone(childName);
    if bone_ then
        if table.getn(bone_.displayList) > 0 then
            for i, v in ipairs(bone_.displayList) do
                if v:is(Armature) then return v end;
            end
        end
    end
   
    return nil;
end

--text
local function createTextFieldWithTextData(textData, string, fontName, isAltas, isFillAltasColor, customLabelBuilderFunc,stroke_bool, strokeColor, stroke_size)
    local text = textData;
    if text then
        string = string or "";
        fontName = fontName or FontConstConfig.OUR_FONT;
        if string ~= "" and GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then--
	        local translatedStr = getLuaCodeTranslated(string)
	        if translatedStr then
	          string = translatedStr
	        end
	    end
        local label = nil;
        local isSupportTextChange = true;
        if customLabelBuilderFunc ~= nil then
            label, isSupportTextChange = customLabelBuilderFunc(textData, string, fontName, isAltas, isFillAltasColor);
        else
            if isAltas then
            	fontName = "resource/image/ui/bmfonts_output/" .. fontName .. ".fnt";
                label = CCLabelBMFont:create(string, fontName, text.width, text.alignment);
            else
            	if stroke_bool then
			        local sc=strokeColor and strokeColor or ccc3(0,0,0);
			        local ss=stroke_size and stroke_size or 2;
			        label = CCLabelTTFStroke:create(string, fontName, text.size, ss, sc, CCSizeMake(text.width, text.height), text.alignment,kCCVerticalTextAlignmentCenter);
			     else
			        label = CCLabelTTF:create(string, fontName, text.size, CCSizeMake(text.width, text.height), text.alignment);
			     end
            end
        end
                
        local ret = TextField.new(label, isSupportTextChange);
        ret.textData = text;
        ret:setPositionXY(text.x, text.y);
        
        if customLabelBuilderFunc == nil then
            if not isAltas or (isAltas and isFillAltasColor) then
                local color = CommonUtils:ccc3FromUInt(text.color);
                ret:setColor(color);
            end
        end
        return ret;
    end
    return nil
end

function Armature:initTextFieldWithString(boneName, string, fontName, isAltas, isFillAltasColor, customLabelBuilderFunc,stroke_bool, strokeColor, stroke_size)
    local fontName=fontName or "resource/font/Microsoft YaHei.ttf";
  	local isAltas=isAltas or false;
  	local isFillAltasColor=isFillAltasColor or nil;
  	local customLabelBuilderFunc=customLabelBuilderFunc or nil;
    local bone_ = self:getBone(boneName);
    if bone_ and bone_.textData then 
        local textfield = createTextFieldWithTextData(bone_.textData, string, fontName, isAltas, isFillAltasColor, customLabelBuilderFunc,stroke_bool, strokeColor, stroke_size);
        if textfield then 
            bone_.displayBridge:setTextField(textfield, true); --init and addChild
            textfield.name = boneName.." text";
            return textfield;
        end
    end
    return nil
end
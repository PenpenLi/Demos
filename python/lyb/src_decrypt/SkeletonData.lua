-------------------------------------------------------------------------
--  Class include: SkeletonData, AnimationData, ArmatureData
-------------------------------------------------------------------------
--
-- SkeletonData ---------------------------------------------------------
--
-- initialize
SkeletonData = class(Object);

function SkeletonData:ctor()
	self.name = nil;
	self.armatureList = {}; -- of <String>
	self.animationList = {}; -- of <String>

	self.class = SkeletonData;

	self.armatureDatas = {};
	self.animationDatas = {};
end

function SkeletonData:dispose()
	for k,v in pairs(self.armatureDatas) do
		v:dispose();
	end
	for k,v in pairs(self.animationDatas) do
		v:dispose();
	end

	self.armatureList = nil;
	self.animationList = nil;
	self.armatureDatas = nil;
	self.animationDatas = nil;

	self:removeSelf();
end

function SkeletonData:toString()
	if self.armatureList then
		return string.format("SkeletonData [%s, Armature=%d, Animation=%d]",self.name and self.name or "nil",
		self:getTotalArmatures(), self:getTotalAnimation());
	else
		return "SkeletonData [nil]";
	end
end

-- public methods
function SkeletonData:dump()
	self:dumpArmatures();
	self:dumpAnimations();
end

function SkeletonData:dumpArmatures()
	for k, v in pairs(self.armatureDatas) do
		print("dumpArmatures", k, v);
		v:dump();
	end
end
function SkeletonData:dumpAnimations()
	for k, v in pairs(self.animationDatas) do
		print("dumpAnimations", k, v);
	end
end

function SkeletonData:getTotalArmatures()
	return table.getn(self.armatureList);
end

function SkeletonData:getTotalAnimation()
	return table.getn(self.animationList);
end

function SkeletonData:getArmatureData(name)
	if name and self.armatureDatas then
		return self.armatureDatas[name];
	end
	return nil;
end

function SkeletonData:getAramtureDataAt(index)
	local i = index or 0;
	if self.armatureList and self.armatureDatas then
		local aramtureName = self.armatureList[i];
		if aramtureName then
			return self.armatureDatas[aramtureName];
		end
	end
	return nil;
end

function SkeletonData:getAnimationData(name)
	if name and self.animationDatas then
		return self.animationDatas[name];
	end
	return nil;
end


function SkeletonData:getAnimationDataAt(index)
	local i = index or 0;
	if self.animationList and self.animationDatas then
		local animationName = self.animationList[i];
		if animationName then
			return self.animationDatas[animationName];
		end
	end
	return nil;
end

function SkeletonData:addArmatureData(data)
	local aramtureName = data.name;
	if aramtureName then
		self.armatureDatas[aramtureName] = data;
	end

	local notFound = true;
	for i,v in ipairs(self.armatureList) do
		if v == aramtureName then
			notFound = false;
			break;
		end
	end

	if notFound then
		table.insert(self.armatureList, aramtureName);
	end

end


function SkeletonData:addAnimationData(data)
	local animationName = data.name;
	if animationName then
		self.animationDatas[animationName] = data;
	end

	local notFound = true;
	for i,v in ipairs(self.animationList) do
		if v == animationName then
			notFound = false;
			break;
		end
	end

	if notFound then
		table.insert(self.animationList, animationName);
	end

end

--
-- AnimationData ---------------------------------------------------------
--

-- initialize
AnimationData = class(Object);
function AnimationData:ctor()
	self.name = nil;
	self.movementList = {}; -- of <String>

	self.class = AnimationData;

	self.movementDatas = {};  -- of <MovementData>
end

function AnimationData:dispose()
	for k,v in pairs(self.movementDatas) do
		v:dispose();
	end

	self.movementList = nil;
	self.movementDatas = nil;
	self:removeSelf();
end

function AnimationData:toString()
	if self.movementList then
		return string.format("AnimationData [%s, Movements=%d]",self.name and self.name or "nil", self:getTotalMovements());
	else
		return "AnimationData [nil]";
	end
end

-- public methods
function AnimationData:dump()
	print("\ndump AnimationData");
	for k, v in pairs(self.movementDatas) do
		print("[AnimationData]", k, v);
	end
end

function AnimationData:getTotalMovements()
	return table.getn(self.movementList);
end

function AnimationData:getMovementData(name)
	return self.movementDatas[name]; --MovementData
end

function AnimationData:getMovementDataAt(index)
	local movementName = self.movementList[index];
	if movementName then
		return self.movementDatas[movementName]; --MovementData
	end
	return nil;
end

function AnimationData:addMovementData(data)
	local movementName = data.name;
	if movementName then
		self.movementDatas[movementName] = data;
	end

	local notFound = true;
	for i,v in ipairs(self.movementList) do
		if v == movementName then
			notFound = false;
			break;
		end
	end

	if notFound then
		table.insert(self.movementList, movementName);
	end

end

--
-- ArmatureData ---------------------------------------------------------
--

-- initialize
ArmatureData = class(Object);
function ArmatureData:ctor()
	self.name = nil;
	self.boneList = nil;

	self.class = ArmatureData;

	self.boneData = {};-- of <BoneData>
end

function ArmatureData:dispose()
	for k,v in pairs(self.boneData) do
		v:dispose();
	end

	self.boneList = nil;
	self.boneData = nil;
	self:removeSelf();
end

function ArmatureData:toString()
	if self.boneList then
		return string.format("ArmatureData [%s, Bones=%d]",self.name and self.name or "nil", self:getTotalBones());
	else
		return "ArmatureData [nil]";
	end
end

function ArmatureData:dump()
	print("\ndump ArmatureData");
	for k, v in pairs(self.boneData) do
		print("[ArmatureData]", k, v);
	end
end

-- public methods
function ArmatureData:getTotalBones()
	return table.getn(self.boneList);
end

function ArmatureData:getBoneData(name)
	return self.boneData[name]; --BoneData
end

function ArmatureData:getBoneDataAt(index)
	local boneName = self.boneList[index];
	if boneName then
		return self.boneData[boneName]; --BoneData
	end
	return nil;
end

function ArmatureData:addBoneData(data)
	local boneName = data.name;
	self.boneData[boneName] = data;
end

local function sortBoneList(a, b)
	return a.depth < b.depth;
end

function ArmatureData:updateBoneList()
	local i = 1;
	local list = {};
	for k,v in pairs(self.boneData) do
		local depth = 0;
		local parentData = v;
		while parentData do
			depth = depth+1;
			parentData = self.boneData[parentData.parent];
		end

		list[i] = {depth=depth,boneName=k};
		i = i+1;
	end

    table.sort(list, sortBoneList);
	--[[
	print("before sort------\n");
	for idx,bv in ipairs(list) do
		print("before", bv.boneName, bv.depth);
	end

	

	print("after sort------\n");
	for idx,bv in ipairs(list) do
		print("after", bv.boneName, bv.depth);
	end
	]]

	self.boneList = {};
	local selfBoneList = self.boneList;
	for idx,bv in ipairs(list) do
		selfBoneList[idx] = bv.boneName;
	end

	--[[
	print("done------\n");
	for idx,bv in ipairs(selfBoneList) do
		print("done", bv)
	end
	]]
end



-- ArmatureEvents const defined in he.core/dragonbones/events/EventData.cpp file
ArmatureEvents = {
	START = "start",
	COMPLETE = "complete",
	LOOP_COMPLETE = "loopComplete",
}

--
-- ArmatureNode ---------------------------------------------------------
--
ArmatureNode = class(CocosObject)

function ArmatureNode:create( armatureName )
	local db = DBCCFactory:getInstance():buildArmatureNode(armatureName)
	if db then
		local ret = ArmatureNode.new(db)
		-------------------------------------------------- 
		-- eventType 	: string
		-- evtData 		: see also dragonbones/events/EventData.h
		-------------------------------------------------- 
		local function eventHandler(eventType, evtData)
			if ret:hn(eventType) then ret:dp(Event.new(eventType, evtData, ret)) end
		end
		db:registerArmatureEventListener(eventHandler, ArmatureEvents.START)
		db:registerArmatureEventListener(eventHandler, ArmatureEvents.COMPLETE)
		db:registerArmatureEventListener(eventHandler, ArmatureEvents.LOOP_COMPLETE)
		return ret
	end
end

function ArmatureNode:getAnimationList()
	if not self.animNameList then
		local aniList = self.refCocosObj:getAnimationList()
		local len = aniList:count()
		local result = {}
		for i = 0, len - 1 do
			local animName = tolua.cast(aniList:objectAtIndex(i), "CCString"):getCString()
			table.insert(result, animName)
		end
		self.animNameList = result
	end
	return self.animNameList
end

function ArmatureNode:getAnimation() return self.refCocosObj:getAnimation() end

------------------------------------------------------------------------------------------------
-- params:
-- @animationName 	skeleton.xml中定义的animationName
-- @playTimes 		0: 循环播放; 大于1的数字: 具体的播放次数; 小于1的数字: 使用skeleton.xml中定义的播放次数
-- @duration		播放一次动画时长，单位为秒(s)，如果设置了循环播放，则每轮循环耗时均为duration
-- 剩下的几个参数存在感太低，其实是懒得写，详情参考Animation.cpp中的定义
------------------------------------------------------------------------------------------------
function ArmatureNode:play( animationName, playTimes, duration, fadeInTime, layer, group, fadeOutMode, displayControl, pauseFadeOut, pauseFadeIn )
	fadeInTime = fadeInTime or -1
	duration = duration or -1 
	playTimes = playTimes or -1
	layer = layer or 0
	group = group or ""
	fadeOutMode = fadeOutMode or "sameLayerAndGroup"
	displayControl = displayControl or true
	pauseFadeOut = pauseFadeOut or true
	pauseFadeIn = pauseFadeIn or true
	self:getAnimation():gotoAndPlay(animationName, fadeInTime, duration, playTimes, layer, group, fadeOutMode, displayControl, pauseFadeOut, pauseFadeIn)
end

function ArmatureNode:playByIndex( animationIndex, playTimes, duration, fadeInTime, layer, group, fadeOutMode, displayControl, pauseFadeOut, pauseFadeIn )
	local animNameList = self:getAnimationList()
	local animationName = animNameList[animationIndex + 1]
	if animationName then
		self:play(animationName, playTimes, duration, fadeInTime, layer, group, fadeOutMode, displayControl, pauseFadeOut, pauseFadeIn)
	end
end

function ArmatureNode:gotoAndStop( animationName, time, normalizedTime, fadeInTime, duration )
	normalizedTime = normalizedTime or -1
    fadeInTime = fadeInTime or 0
    duration = duration or -1
	self:getAnimation():gotoAndStop(animationName, time, normalizedTime, fadeInTime, duration)
end

function ArmatureNode:gotoAndStopByIndex( animationIndex, time, normalizedTime, fadeInTime, duration )
	local animNameList = self:getAnimationList()
	local animationName = animNameList[animationIndex + 1]
	if animationName then
		self:gotoAndStop(animationName, time, normalizedTime, fadeInTime, duration)
	end
end

function ArmatureNode:setAnimationScale( animationScale )
	local animation = self:getAnimation()
	if animation then animation:setTimeScale(animationScale) end
end

function ArmatureNode:pause()
	local animation = self:getAnimation()
	if animation then animation:stop() end
end

function ArmatureNode:resume()
	local animation = self:getAnimation()
	if animation then animation:play() end
end

function ArmatureNode:stop()
	local animation = self:getAnimation()
	if animation then animation:stop() end
end

function ArmatureNode:update(passTime)
	self:getAnimation():advanceTime(passTime)
end

function ArmatureNode:getCurrentTime()
	if self:getAnimation():getLastAnimationState() then
		return self:getAnimation():getLastAnimationState():getCurrentTime()
	else
		return 0
	end
end

function ArmatureNode:getTotalTime()
	if self:getAnimation():getLastAnimationState() then
		return self:getAnimation():getLastAnimationState():getTotalTime()
	else
		return 0
	end
end

function ArmatureNode:getSlot(slotName)
	return self.refCocosObj:getCCSlot(slotName)
end

ArmatureFactory = {}

--------------------------------------------------------------------
-- @path			directory path of skeleton animation
-- @skeletonName	define in skeleton.xml, such as <dragonBones name="skeletonName" frameRate="24" version="2.3">
-- @textureName		define in texture.xml such as <TextureAtlas name="textureName" imagePath="texture.png">
--------------------------------------------------------------------
function ArmatureFactory:add(path, skeletonName, textureName)
	print("ArmatureFactory load:", path)
	local skeName = skeletonName or ""
	local texName = textureName or skeletonName 
	DBCCFactory:getInstance():loadDragonBonesData(path .. "/skeleton.xml", skeletonName)
	DBCCFactory:getInstance():loadTextureAtlas(path .. "/texture.xml", texName)
end

function ArmatureFactory:getTextureDisplay(frameName)
	local node = DBCCFactory:getInstance():getTextureDisplay(frameName)
	node = tolua.cast(node, "CCSprite")
	return node
end


--------------------------------------------------------------------
-- @skeletonName	define in skeleton.xml, such as <dragonBones name="skeletonName" frameRate="24" version="2.3">
-- @textureName		define in texture.xml such as <TextureAtlas name="textureName" imagePath="texture.png">
--------------------------------------------------------------------
function ArmatureFactory:remove(skeletonName, textureName)
	local skeName = skeletonName or ""
	local texName = textureName or skeletonName 
	DBCCFactory:getInstance():removeDragonBonesData(skeName)
	DBCCFactory:getInstance():removeTextureAtlas(texName)
end
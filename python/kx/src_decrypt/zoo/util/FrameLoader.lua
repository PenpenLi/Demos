require "hecore.EventDispatcher"
require "hecore.ui.LayoutBuilder"

kFrameLoaderType = {
	json = ".json",
	plist = ".plist",
	xml = ".xml",
	zip = ".zip",
	mp3 = ".mp3",
	sfx = ".sfx",
	png = ".png",
	jpg = ".jpg",
	pvr = ".pvr",
	skeleton = ".skeleton"
}
FrameLoader = class(EventDispatcher)

function FrameLoader:ctor()
	self.list = {}
	self.loading = false
	self.loaded = 0
end

function FrameLoader:add( resource, type )
	table.insert(self.list, {resource, type})
end

function FrameLoader:load()
	if #self.list < 1 then 
		self:onLoaderCompleted()
		return
	end

	local funcId = nil
	local context = self
	local function onFrameLoaderTick()
		context:syncLoad()
		context.loaded = context.loaded + 1
		if context.loaded > #context.list then
			if funcId ~= nil then CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(funcId) end
			context:onLoaderCompleted()
		end
	end

	if self.loading then
		print("ERROR: alread loading")
	else
		self.loading = true
		self.loaded = 1
		funcId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onFrameLoaderTick)
	end
end

function FrameLoader:loadPngOnly( filePath, noCacheTexture )
  local prefix = string.split(filePath, ".")[1]
    local realPngPath = filePath
    if __use_small_res then  
      realPngPath = prefix .. "@2x.png"
    end
    local sprite = Sprite:create(realPngPath)
    if noCacheTexture then
    	CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename(realPngPath))
    end
    return sprite
end

function FrameLoader:loadImageWithPlist( filePath )
	local prefix = string.split(filePath, ".")[1]
	local pngPath = prefix..".png"
	local pf = ResourceConfigPixelFormat[filePath]
	if pf ~= nil then
		SpriteUtil:setTexturePixelFormat(pngPath, pf)
		print("setTexturePixelFormat:", pngPath, pf)
	end
	--print(string.format("loading plist: %s %s", filePath, pngPath))
	SpriteUtil:addSpriteFramesWithFile(filePath, pngPath)
end

------------------------
--force = true 时删除CCSpriteFrameCache中的内容，慎用
----------------------
function FrameLoader:unloadImageWithPlists( plists, force )
	for i,filePath in ipairs(plists) do
		local prefix = string.split(filePath, ".")[1]
		local pngPath = prefix..".png"
		local realPngPath = SpriteUtil:getRealResourceName( pngPath )
		SpriteUtil:removeLoadedPlist( filePath )
		if not __WP8 then
			CCTextureCache:sharedTextureCache():removeTextureForKey(CCFileUtils:sharedFileUtils():fullPathForFilename(realPngPath))
			if force then
				local realPlistPath = SpriteUtil:getRealResourceName(filePath)
				CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(realPlistPath)
			end
		else
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
		end
	end
end

function FrameLoader:loadArmature( resourceSrc )
	if ResourceArmaturePixelFormat[resourceSrc] ~= nil then
	    CCTexture2D:setDefaultAlphaPixelFormat(ResourceArmaturePixelFormat[resourceSrc])
	end

	if __use_small_res then
		ArmatureFactory:add(resourceSrc.."@2x/texture.png", resourceSrc.."@2x/texture.xml", resourceSrc.."@2x/skeleton.xml")
	else
		ArmatureFactory:add(resourceSrc.."/texture.png", resourceSrc.."/texture.xml", resourceSrc.."/skeleton.xml")
	end

	CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
end

function FrameLoader:syncLoad()
	local res = self.list[self.loaded]
	if res then
		local resourceSrc = res[1]
		local resourceType = res[2]
		
		if resourceType == kFrameLoaderType.plist then
			self:loadImageWithPlist(resourceSrc)
		elseif resourceType == kFrameLoaderType.json then			
			--print("loading json:", resourceSrc)
			LayoutBuilder:createWithContentsOfFile(resourceSrc)
		elseif resourceType == kFrameLoaderType.skeleton then
			FrameLoader:loadArmature( resourceSrc )
		elseif resourceType == kFrameLoaderType.mp3 then
			SimpleAudioEngine:sharedEngine():preloadBackgroundMusic(resourceSrc)
		elseif resourceType == kFrameLoaderType.sfx then
			--print(resourceSrc)
			SimpleAudioEngine:sharedEngine():preloadEffect(resourceSrc)
		end
	end
	if self:hasEventListenerByName(Events.kProgress) then
        self:dispatchEvent(Event.new(Events.kProgress, self))
    end 
    
end

function FrameLoader:getLength()
	return #self.list
end

function FrameLoader:onLoaderCompleted()
	if self:hasEventListenerByName(Events.kComplete) then
        self:dispatchEvent(Event.new(Events.kComplete, self))
    end 
end
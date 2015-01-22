require "zoo.util.ResUtils"
HeadImageLoader = class(CocosObject)

function HeadImageLoader:ctor()
	self.list = {}
	self.itemLoadCompleteCallback = nil
end

function HeadImageLoader:create(userId, headImageUrl,onImageLoadFinishCallback)
	-- print("HeadImageLoader:create")
	local container = HeadImageLoader.new(CCNode:create())
	container:initialize(userId, headImageUrl,onImageLoadFinishCallback)
	return container
end

function HeadImageLoader:initialize(userId, headImageUrl, onImageLoadFinishCallback)
	headImageUrl = headImageUrl or "0"
	self.headImageUrl = tostring(headImageUrl)
	self.userId = userId
	if string.find(self.headImageUrl, "http://") ~= nil or string.find(self.headImageUrl, "https://") ~= nil then   
	    local function onCallBack(data)        
	    	if self.isDisposed then return end
	        local sprite = Sprite:create( data["realPath"] )
	        if sprite.refCocosObj then
		        local size = sprite:getContentSize()
		        sprite:setScaleX(100 / size.width)
		        sprite:setScaleY(100 / size.height)
	        end
	        local container = Sprite:createEmpty()
	        container:addChild(sprite)
	        container:setAnchorPoint(ccp(0, 0))
	        container:setContentSize(CCSizeMake(100, 100))
	        self:createHeadWithSprite(container)
	    	if onImageLoadFinishCallback then onImageLoadFinishCallback(self) end
	    end
	    ResUtils:getResFromUrls({self.headImageUrl},onCallBack)
	else
		imageID = self.headImageUrl
		local kMaxHeadImages = UserManager.getInstance().kMaxHeadImages
		local headImage = tonumber(imageID)
		if headImage == nil then headImage = 0 end
		if headImage < 0 then headImage = 0 end
		if headImage > kMaxHeadImages then headImage = kMaxHeadImages end
		local sprite = Sprite:createWithSpriteFrameName("h"..tostring(headImage))
		sprite:setContentSize(CCSizeMake(100, 100))
		self:createHeadWithSprite(sprite)
		if onImageLoadFinishCallback then onImageLoadFinishCallback(self) end
	end
end

function HeadImageLoader:createHeadWithSprite(sprite)
	if self.isDisposed then return end
	local contentSize = sprite:getContentSize()
	self:addChild(sprite)
	self:setContentSize(CCSizeMake(contentSize.width, contentSize.height))
end

-- function HeadImageLoader:createFrameImage( imageID )
-- 	local kMaxHeadImages = UserManager.getInstance().kMaxHeadImages
-- 	local headImage = tonumber(imageID)
-- 	if headImage == nil then headImage = 0 end
-- 	if headImage < 0 then headImage = 0 end
-- 	if headImage > kMaxHeadImages then headImage = kMaxHeadImages end

-- 	if __ANDROID then -- for some andorid devices can't display right while nested clipping node exists
-- 		local sprite = Sprite:createWithSpriteFrameName("h"..tostring(headImage))
-- 		sprite:setScale(1.02)
-- 		local contentSize = sprite:getContentSize()
-- 		sprite:setPosition(ccp(contentSize.width / 2, contentSize.height / 2))
-- 		local headMask = CCSprite:createWithSpriteFrameName("head_image_mask0000")
-- 		headMask:setPosition(ccp(contentSize.width / 2, contentSize.height / 2))
-- 		local blend = ccBlendFunc()
-- 		blend.src = GL_ZERO
-- 		blend.dst = GL_SRC_ALPHA
-- 		headMask:setBlendFunc(blend)
-- 		local mix = CCRenderTexture:create(contentSize.width, contentSize.height)
-- 		mix:begin()
-- 		sprite:visit()
-- 		headMask:visit()
-- 		mix:endToLua()

-- 		sprite:dispose()

-- 		local obj = CocosObject.new(mix)
-- 		local finalLayer = Layer:create()
-- 		finalLayer:ignoreAnchorPointForPosition(false)
-- 		finalLayer:setAnchorPoint(ccp(0, 1))
-- 		finalLayer:addChild(obj)
-- 		self:addChild(finalLayer)
-- 		self:setContentSize(CCSizeMake(contentSize.width, contentSize.height))
-- 	else -- else, IOS and PC
-- 		local sprite = Sprite:createWithSpriteFrameName("h"..tostring(headImage))
-- 		sprite:setScale(1.02)
-- 		local contentSize = sprite:getContentSize()
-- 		local clipping = ClippingNode.new(CCClippingNode:create(CCSprite:createWithSpriteFrameName("head_image_mask0000")))
-- 		clipping:setAlphaThreshold(0.1)
-- 		if sprite then 
-- 			clipping:addChild(sprite) 
-- 			sprite:dispose()
-- 		end
-- 		self:addChild(clipping)
-- 		self:setContentSize(CCSizeMake(contentSize.width, contentSize.height))
-- 	end
-- end

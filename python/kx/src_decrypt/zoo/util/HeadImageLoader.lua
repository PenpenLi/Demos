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
	        self.headSprite = sprite
	        self.headPath = data["realPath"]
	        self.isSns = true
	    	if onImageLoadFinishCallback then onImageLoadFinishCallback(self) end
	    end
	    ResUtils:getResFromUrls({self.headImageUrl},onCallBack)
	elseif string.find(self.headImageUrl, "head") ~= nil then
		if self.isDisposed then return end
        local sprite = Sprite:create( self.headImageUrl )
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
        self.headSprite = sprite
        self.headPath = self.headImageUrl
        if onImageLoadFinishCallback then onImageLoadFinishCallback(self) end
	else
		self.headPath = self.headImageUrl
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
	self.headSprite = sprite
	self:setContentSize(CCSizeMake(contentSize.width, contentSize.height))
end

function HeadImageLoader:getHeadTextureAndRect()
	return self.headSprite:getTexture(), self.headSprite:getTextureRect()
end

--take head photo
HeadPhotoTaker = {}

local win32_test_index = 0

local function GetWin32Path()
	win32_test_index = win32_test_index + 1
	return "F:\\picTest\\"..win32_test_index..".png"
end

function HeadPhotoTaker:takePicture(cb)
	local function _takePicture()
		if __ANDROID then
			self:androidTakePicture(cb)
		elseif __IOS then
			self:iosTakePicture(cb)
		elseif __WIN32 then
			cb.onSuccess(GetWin32Path())
		end
	end
	
	pcall(_takePicture)
end

function HeadPhotoTaker:iosTakePicture( cb )
	waxClass{"PhotoCallbackImpl",NSObject,protocols={"PhotoCallback"}}
	function PhotoCallbackImpl:onSuccess(path)
		if cb then cb.onSuccess(path) end
	end

	function PhotoCallbackImpl:onError_msg(code, errMsg)
		if cb then cb.onError(code, errMsg) end
	end

	function PhotoCallbackImpl:onCancel()
		if cb then cb.onCancel() end
	end

	PhotoController:takePicture(PhotoCallbackImpl:init())
end

function HeadPhotoTaker:androidTakePicture( cb )
	local photoManager = luajava.bindClass("com.happyelements.android.photo.PhotoManager"):get()
    
    local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
            onSuccess = function (result)
                if cb then cb.onSuccess(result) end
            end,
            onError = function (code, errMsg)
               if cb then cb.onError(code, errMsg) end
            end,
            onCancel = function ()
               if cb then cb.onCancel() end
            end
        });

    photoManager:takePicture(callback)
end

function HeadPhotoTaker:selectPicture( cb )
	local function _selectPicture()
		if __ANDROID then
			self:androidSelectPicture(cb)
		elseif __IOS then
			self:iosSelectPicture(cb)
		elseif __WIN32 then
			cb.onSuccess(GetWin32Path())
		end
	end
	
	pcall(_selectPicture)
end

function HeadPhotoTaker:iosSelectPicture( cb )
	waxClass{"PhotoCallbackImpl",NSObject,protocols={"PhotoCallback"}}
	function PhotoCallbackImpl:onSuccess(path)
		if cb then cb.onSuccess(path) end
	end

	function PhotoCallbackImpl:onError_msg(code, errMsg)
		if cb then cb.onError(code, errMsg) end
	end

	function PhotoCallbackImpl:onCancel()
		if cb then cb.onCancel() end
	end

	PhotoController:selectPicture(PhotoCallbackImpl:init())
end

function HeadPhotoTaker:androidSelectPicture( cb )
	local photoManager = luajava.bindClass("com.happyelements.android.photo.PhotoManager"):get()
    
    local callback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
            onSuccess = function (result)
                if cb then cb.onSuccess(result) end
            end,
            onError = function (code, errMsg)
               if cb then cb.onError(code, errMsg) end
            end,
            onCancel = function ()
               if cb then cb.onCancel() end
            end
        });

    photoManager:selectPicture(callback)
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

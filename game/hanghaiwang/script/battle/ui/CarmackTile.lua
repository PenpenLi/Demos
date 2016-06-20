
require "script/battle/BATTLE_CLASS_NAME"
require (BATTLE_CLASS_NAME.class)
-- 卡马克转轴图像tile
local CarmackTile = class("CarmackTile",function () return CCSprite:create() end)
 
	------------------ properties ----------------------
	CarmackTile.index 			= nil
	CarmackTile.imageURL 		= nil
	CarmackTile.viewRec 		= nil
	CarmackTile.image 			= nil
	CarmackTile.isShow			= nil
	CarmackTile.bgScale			= nil
	CarmackTile.tWidth 			= nil
	CarmackTile.tHeight			= nil
	CarmackTile.py 				= nil
 	CarmackTile.maxScale 		= nil
	------------------ functions -----------------------
	function CarmackTile:ctor( ind ,imgURL)
		self.index 			= ind
		self.imageURL 		= imgURL
		-- self.bgScale 		= scale
	 	self.maxScale 		= math.max(g_fScaleX,g_fScaleY)
		self.py 			= 0
		self.isShow 		= false
		self.tWidth 		= 640 * self.maxScale
		self.tHeight 		= 240 * self.maxScale --g_fScaleY

		self.viewRec 		= CCRectMake(0, self:getY(),self.tWidth ,self.tHeight )
		self:setScale(self.maxScale)
		-- self:setScaleY(self.maxScale)
		self:setAnchorPoint(ccp(0.5, 0))
		Logger.debug("CarmackTile g_fScaleX:" .. g_fScaleX .. " self.g_fScaleY:" .. g_fScaleY .. " self.maxScale:" .. self.maxScale)
		-- if(tonumber(self.maxScale) > 1.0) then
			-- 240 * (self.maxScale - 1)/2
			self:setPositionX(g_winSize.width/2)
		-- end
		--print("CarmackTile:ctor:",0, self:getY(),self.tWidth ,self.tHeight)
	end
 
	function CarmackTile:show( ... )
		if(not self.isShow) then
			 -- --print("1")
			 self:setVisible(true)
			 -- --print("2")
			 -- self:releaseImage(self.imageURL)
			

			 -- 保存原来的格式
			 local originalFormat = CCTexture2D:defaultAlphaPixelFormat()
			 CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGB565)

			 CCTextureCache:sharedTextureCache():addImage(self.imageURL)
			 local texture1 = CCTextureCache:sharedTextureCache():textureForKey(self.imageURL)
			 self:setTexture(texture1)
		 	 self:setTextureRect(CCRectMake(0,0,640,240))
		 	 self:setPositionY(self:getY())
 			--  self:setAnchorPoint(ccp(0, 0))
			 -- self.image = CCSprite:create(self.imageURL) 
			 -- self.image:setAnchorPoint(ccp(0, 0))
			 -- self:addChild(self.image)
			 self.isShow = true

			 CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
			  -- --print("7")
		end
	end
	function CarmackTile:getY( ... )
		return (self.index)* 240 * self.maxScale + self.py
	end
	function CarmackTile:unShow( ... )
		self:setVisible(false)
		if(self.isShow) then
			-- self:releaseImage()
			self.isShow = false
			-- self:removeFromParentAndCleanup(true)

			local texture = self:getTexture()
			self:setTexture(nil)
			if(texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end

			
		end
	end

	function CarmackTile:releaseImage( ... )
		if(self.image) then
			local texture = self.image:getTexture()
			if(texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
			self.image:removeFromParentAndCleanup(true)
			self.image = nil
		end
	end
	function CarmackTile:moveBy( dy )
		self.py = self.py + dy
		-- --print("CarmackTile:",self.index,self:getPositionY())
		self:setPositionY(self:getPositionY() + dy)
		self.viewRec 		= CCRectMake(0,self:getY(), self.tWidth, self.tHeight)
		-- --print("CarmackTile:",self.index,0,self:getPositionY(), self.tWidth, self.tHeight)
	end
	function CarmackTile:releaseUI( ... )
		self:unShow()
	end

return CarmackTile




-- require "script/battle/BATTLE_CLASS_NAME"
-- require (BATTLE_CLASS_NAME.class)
-- 卡马克转轴图像tile
local CarmackXTile = class("CarmackXTile",function () return CCSprite:create() end)
 
	------------------ properties ----------------------
	CarmackXTile.index 				= nil
	CarmackXTile.imageURL 			= nil
	CarmackXTile.viewRec 			= nil
	CarmackXTile.image 				= nil
	CarmackXTile.isShow				= nil
	CarmackXTile.tWidth 			= nil
	CarmackXTile.tHeight			= nil
	CarmackXTile.px 				= nil -- 当前x轴改变量
 	
 	CarmackXTile.configData 		= nil -- CarmackXScrollConfigData
	------------------ functions -----------------------
	function CarmackXTile:ctor( ind ,config,imgURL , imgW, imgH)
		assert(ind)
		assert(config)

		self.configData  	= config

		self.index 			= ind
		self.imageURL 		= config:getTileImageURL(ind)

		self.tWidth 		= config:tilewidth()
		self.tHeight 		= config:tileHeight() --g_fScaleY

		self.px 			= 0
		self.isShow 		= false


		self:refreshRect()
		-- self.viewRec 		= CCRectMake(self:getX(),0, self.tWidth, self.tHeight )
		-- self:setScaleX(self.configData.scale * g_fScaleY)
		self:setScale(self.configData.scale) --* math.max(g_fScaleY,g_fScaleX)
		self:setAnchorPoint(ccp(0, 0))

		
		

		Logger.debug("CarmackXTile g_fScaleX:" .. g_fScaleX .. " self.g_fScaleY:" .. g_fScaleY)
		
		--print("CarmackXTile:ctor:",0, self:getX(),self.tWidth ,self.tHeight)
	end
 	function CarmackXTile:unloadSource( ... )
 		local texture = self:getTexture()
		self:setTexture(nil)
		if(texture) then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
		end
 	end

 	function CarmackXTile:loadSource( ... )


 		 local texture1 = CCTextureCache:sharedTextureCache():textureForKey(self.imageURL)
 		 if(texture1 == nil) then
 		 	require "script/battle/load/ImagesAysncLoadManager"
			ImagesAysncLoadManager.load({self.imageURL})
	 		--  -- 保存原来的格式
			 -- local originalFormat = CCTexture2D:defaultAlphaPixelFormat()
			 -- CCTexture2D:setDefaultAlphaPixelFormat(self.configData.pixFormat)

			 -- CCTextureCache:sharedTextureCache():addImage(self.imageURL)
			 -- local texture1 = CCTextureCache:sharedTextureCache():textureForKey(self.imageURL)
			 -- self:setTexture(texture1)
		 	--  self:setTextureRect(CCRectMake(0,0,self.configData.tWidth,self.configData.tHeight))
		 	--  CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
		 end
 	end


	function CarmackXTile:show( ... )
		if(not self.isShow) then
			 -- --print("1")
			 self:setVisible(true)
			 -- --print("2")
			 -- self:releaseImage(self.imageURL)
			
			 if(self:getTexture() ~= nil) then
			 	self:loadSource()
			 end
			 -- -- 保存原来的格式
			 -- local originalFormat = CCTexture2D:defaultAlphaPixelFormat()
			 -- CCTexture2D:setDefaultAlphaPixelFormat(self.configData.pixFormat)

			 -- CCTextureCache:sharedTextureCache():addImage(self.imageURL)
			 -- local texture1 = CCTextureCache:sharedTextureCache():textureForKey(self.imageURL)
			 -- self:setTexture(texture1)
		 	--  self:setTextureRect(CCRectMake(0,0,self.configData.tWidth,self.configData.tHeight))
		 	 self:setPositionX(self:getX())
		 	 -- self:setPositionX((self.index)* self.tWidth)
 			--  self:setAnchorPoint(ccp(0, 0))
			 -- self.image = CCSprite:create(self.imageURL) 
			 -- self.image:setAnchorPoint(ccp(0, 0))
			 -- self:addChild(self.image)
			 self.isShow = true

			 -- CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
			  -- --print("7")
		end
	end

	function CarmackXTile:getX( ... )
		return (self.index)* self.tWidth * self.configData.scale + self.px
	end

	function CarmackXTile:unShow( ... )
		self:setVisible(false)
		if(self.isShow) then
			-- self:releaseImage()
			self.isShow = false
			-- self:removeFromParentAndCleanup(true)

			-- local texture = self:getTexture()
			-- self:setTexture(nil)
			-- if(texture) then
			-- 	CCTextureCache:sharedTextureCache():removeTexture(texture)
			-- end

			
		end
	end


	function CarmackXTile:refreshRect( ... )
		if(self.viewRec == nil) then
			self.viewRec 		= CCRectMake(self:getX(),0, self.tWidth, self.tHeight)
		else
			self.viewRec 		= CCRectMake(self:getX(),0, self.tWidth, self.tHeight)
			-- self.viewRec:setRect(self:getX(),0, self.tWidth, self.tHeight)
		end-- --print("CarmackXTile:",self.index,0,self:getPositionY(), self.tWidth, self.tHeight)
	end

	function CarmackXTile:releaseImage( ... )
		if(self.image) then
			local texture = self.image:getTexture()
			if(texture) then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
			self.image:removeFromParentAndCleanup(true)
			self.image = nil
		end
	end
	function CarmackXTile:moveBy( dx )
		self.px = self.px + dx
		-- --print("CarmackXTile:",self.index,self:getPositionY())
		self:setPositionX(self:getPositionX() + dx)
		self:refreshRect()
	end
	function CarmackXTile:releaseUI( ... )
		self:unShow()
		self:unloadSource()
	end

return CarmackXTile

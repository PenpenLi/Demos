
-- require (BATTLE_CLASS_NAME.class)
-- 卡马克转轴图像
local CarmackScrollImage = class("CarmackScrollImage",function () return CCSprite:create() end)


		------------------ properties ----------------------
		CarmackScrollImage.tileStyle 		= nil -- 位图类型
		CarmackScrollImage.tileNum 			= nil -- 总数
		CarmackScrollImage.py  				= nil -- y轴滚动距离
		CarmackScrollImage.viewRec   		= nil -- 可视范围
 
		CarmackScrollImage.tiles 			= nil
	 	CarmackScrollImage.imgDesignHeight  = 960
	 	-- CarmackScrollImage.imgScaleY 			= nil
		------------------ functions -----------------------
		function CarmackScrollImage:create( imgStyle , startY)
			-- --print("CarmackScrollImage:create",imgStyle," g_fBgScaleRatio:",g_fBgScaleRatio)
			-- --print("CarmackScrollImage:g_winSize",g_winSize.width,g_winSize.height)
			self.tileStyle 		= imgStyle
			-- print("-- CarmackScrollImage:create ",self.tileStyle)
			-- print("dot:",string.find(self.tileStyle,"%."))
			local dotIndex = string.find(self.tileStyle,"%.")
			if(dotIndex ~= nil and dotIndex> 0) then
				self.tileStyle = string.sub(self.tileStyle,1,dotIndex - 1)
			end
			local winSize = CCDirector:sharedDirector():getWinSize()
			-- self.imageScale = winSize.width/640
			-- Logger.debug("CarmackScrollImage scale:" .. self.imageScale)
			-- 获取tilenum
			self.tileNum 		= 10

			-- self.imgScaleY 		= g_winSize.height/self.imgDesignHeight
			-- self.scrollPy 		= 0

			self.tiles  		= {}
			self.py 			= 0
			local scene = CCDirector:sharedDirector():getRunningScene()
			
 			self.viewRec = CCRectMake(
										  0,0,
										  g_winSize.width,
										  g_winSize.height
									  )
 			-- self.bgRealScale 					= self.size.width/640
 			-- 开发时间太紧,目前是生成所有tile
 			-- [todo] 改为只有6个实例
			for i=0,self.tileNum - 1 do
				table.insert(self.tiles,require("script/battle/ui/CarmackTile.lua").new(i,self:getTileImageURL(i)))
				-- self.tiles[i + 1]:setPositionY(i * 240)
				self:checkTileView(self.tiles[i + 1])
				self:addChild(self.tiles[i + 1])
			end
 			


		end	
		
		-- function CarmackScrollImage:moveBy( dy )
		-- 	self:setPositionY(self:getPositionY() + dy)
		-- end
		-- 滚动改变: 目前因为只有背景跳转调用了,这里的跳转值实际上已经包含了缩放
		function CarmackScrollImage:scrollPy( dy )
			self.py = self.py + dy 
			-- --print("								")
			-- --print("view:",0,g_winSize.height,
										  -- g_winSize.width,
										  -- g_winSize.height)
			for k,tile in ipairs(self.tiles) do
				tile:moveBy(dy)
				self:checkTileView(tile)
			end
			-- --print("								")
		end
		-- 滚动到: 目前因为只有背景跳转调用了,这里的跳转值实际上已经包含了缩放
		function CarmackScrollImage:scrollPyTo( value )
			
			for k,tile in ipairs(self.tiles) do
				tile:moveBy(value  - self.py )
				self:checkTileView(tile)
			end
			self.py = value
		end

		function CarmackScrollImage:checkTileView(tile)
			-- --print("check view:",tile.viewRec,self.viewRec)
			if(tile.viewRec:intersectsRect(self.viewRec)) then
				-- --print("show:",tile.index)
				tile:show()

			else
				-- --print("unshow",tile.index)
				tile:unShow()
				-- tile:removeFromParentAndCleanup(false)
				-- self:removeChild(tile)
			end
		end	

		function CarmackScrollImage:getTileImageURL( index )
			-- if(g_system_type == kBT_PLATFORM_ANDROID and file_exists( "images/battle/bg/" .. self.tileStyle .. "_" .. index .. ".pkm" )) then
			-- 	return "images/battle/bg/" .. self.tileStyle .. "_" .. index .. ".pkm"
			-- else
				return "images/battle/bg/" .. self.tileStyle .. "_" .. index .. ".jpg"
			-- end
			-- --print("url:","images/battle/bg/" .. self.tileStyle .. "_" .. index .. ".jpg")
			
			-- return BattleURLManager.BATTLE_IMG_BG_PATH + self.tileStyle .. "_" .. index .. ".jpg"
		end

		function CarmackScrollImage:releaseUI()
			for k,tile in ipairs(self.tiles) do
				 
				tile:releaseUI()
			end
			self.tiles = {}
			self:removeFromParentAndCleanup(true)
		end
return CarmackScrollImage
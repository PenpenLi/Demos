-- x轴横向滚动




-- require (BATTLE_CLASS_NAME.class)
-- 卡马克转轴图像
local CarmarkXScrollImage = class("CarmarkXScrollImage",function () return CCNode:create() end)


		------------------ properties ----------------------
		CarmarkXScrollImage.tileStyle 		 = nil -- 位图类型
		CarmarkXScrollImage.tileNum 		 = nil -- 总数
		CarmarkXScrollImage.px  			 = nil -- x轴滚动距离
		CarmarkXScrollImage.viewRec   		 = nil -- 可视范围
 
		CarmarkXScrollImage.tiles 			 = nil -- tile 列表
	 	CarmarkXScrollImage.configData 		 = nil -- carmack config data

	 	-- CarmarkXScrollImage.imgScaleY 			= nil
		------------------ functions -----------------------
		function CarmarkXScrollImage:create( configData )
			-- --print("CarmarkXScrollImage:create",imgStyle," g_fBgScaleRatio:",g_fBgScaleRatio)
			-- --print("CarmarkXScrollImage:g_winSize",g_winSize.width,g_winSize.height)
			self:setAnchorPoint(ccp(0, 0))

			assert(configData,"CarmarkXScrollImage:create->configData is nil ")

			self.px 			= 0
			self.tiles  		= {}
			self.configData 	= configData
			-- local scene = CCDirector:sharedDirector():getRunningScene()
			
 			self.viewRec = CCRectMake(
										  0,0,
										  g_winSize.width,
										  g_winSize.height
									  )

 			self.cacheView = CCRectMake(
										  - 4 * configData.tWidth,0,
										  g_winSize.width + 4 * configData.tWidth,
										  g_winSize.height 
									  ) 
 			self.myScale = self.configData.tHeight/g_winSize.height
 		 	-- 生成tile容器,注意这里的tile实例化后并没有加载贴图,要调用show()才开始加载
			for i=0,self.configData.tileNum - 1 do
				--ind ,imgURL , imgW, imgH
				table.insert(self.tiles,
							-- 			script/battle/ui/CarmackXScroll
							 require("script/battle/ui/CarmackXScroll/CarmackXTile").new(i,self.configData))
				-- self.tiles[i + 1]:setPositionY(i * 240)
				self:checkTileView(self.tiles[i + 1])
				self:addChild(self.tiles[i + 1])
			end
 			
			-- self:addChild(CCSprite:create("images/copy/world/word1/1.jpg"))

		end	
		
		-- function CarmarkXScrollImage:moveBy( dy )
		-- 	self:setPositionY(self:getPositionY() + dy)
		-- end

		function CarmarkXScrollImage:scrolldx( dx )
			self.px = self.px + dx * g_fScaleX
			for k,tile in ipairs(self.tiles) do
				tile:moveBy(dx)
				self:checkTileView(tile)
			end
			-- --print("								")
		end

		function CarmarkXScrollImage:scrolPercentTo( value )
			-- if(value)
			local xTo = value/100 * self.configData.imagesTotalWidth
			self:scrollPxTo(xTo)
		end

		function CarmarkXScrollImage:scrollPxTo( value )
			
			for k,tile in ipairs(self.tiles) do
				tile:moveBy(value * g_fScaleX - self.px )
				self:checkTileView(tile)
			end
			self.px = value
		end

		function CarmarkXScrollImage:checkTileView(tile)
			-- --print("check view:",tile.viewRec,self.viewRec)
			if(tile.viewRec:intersectsRect(self.viewRec)) then
				print("-- show:",tile.index)
				tile:show()

			else
				-- --print("unshow",tile.index)
				tile:unShow()
				-- tile:removeFromParentAndCleanup(false)
				-- self:removeChild(tile)
			end

			if(not tile.viewRec:intersectsRect(self.cacheView)) then
				-- tile:unloadSource()
			else
				tile:loadSource()
			end

		end	
 

		function CarmarkXScrollImage:releaseUI()
			for k,tile in ipairs(self.tiles) do
				 
				tile:releaseUI()
			end
			self.tiles = {}
			self:removeFromParentAndCleanup(true)
		end
return CarmarkXScrollImage
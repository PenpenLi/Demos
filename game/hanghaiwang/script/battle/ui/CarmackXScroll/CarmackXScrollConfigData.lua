-- 卡马特横向滚动配置文件


-- 世界地图
-- imgURL 		= "images/copy/world"
-- imgStyleName = "world_map"
-- tileHeight  	= 1136
-- tileWidth  	= 213
-- format     	= jpg
local CarmackXScrollConfigData = class("CarmackXScrollConfigData")
 
 
	------------------ properties ----------------------
	-- CarmackXScrollConfigData.imgStyleName 				= nil -- 图片类型名
	-- CarmackXScrollConfigData.tileNum					= nil -- 总图片数
	-- CarmackXScrollConfigData.imgURL 					= nil -- 图片url
	-- CarmackXScrollConfigData.tHeight 					= nil -- tile height
	-- CarmackXScrollConfigData.tWidth 					= nil -- tile width
	-- CarmackXScrollConfigData.format						= nil -- 图片格式


	CarmackXScrollConfigData.imgStyleName 				= "world_map" -- 图片类型名
	CarmackXScrollConfigData.tileNum					= 20 -- 总图片数
	CarmackXScrollConfigData.imgURL 					= "images/copy/world/" -- 图片url
	CarmackXScrollConfigData.tHeight 					= 1136 -- tile height
	CarmackXScrollConfigData.tWidth 					= 213 -- tile width
	CarmackXScrollConfigData.format						= ".jpg" -- 图片格式
	CarmackXScrollConfigData.imagesTotalWidth 			= 213 * 20
	CarmackXScrollConfigData.scale 						= g_winSize.height/1136
	CarmackXScrollConfigData.pixFormat 					= kCCTexture2DPixelFormat_RGB565



	-- CarmackXScrollConfigData.imagesTotalWidth			= nil -- 所有图片拼接起来后宽度
	------------------ functions -----------------------
	

	function CarmackXScrollConfigData:toFogConfig( ... )
			self.imgStyleName 				= "world_map_fog" -- 图片类型名
			self.tileNum					= 20 -- 总图片数
			self.imgURL 					= "images/copy/world/" -- 图片url
			self.tHeight 					= 1136 -- tile height
			self.tWidth 					= 183 -- tile width
			self.format						= ".png" -- 图片格式
			self.imagesTotalWidth 			= 183 * 20
			self.scale 						= g_winSize.height/1136

			self.pixFormat 					= kCCTexture2DPixelFormat_RGBA4444
	end


	function CarmackXScrollConfigData:reset( styleName,num,path,tWidth,tHeight )
		self.imgStyleName 	= styleName
		self.tileNum  		= num
		self.imgURL 		= path
		self.tWidth 		= tWidth
		self.tHeight 		= tHeight

		self.imagesTotalWidth = self.tileNum * self.tileWidth
		self.scale 			= g_winSize.height/self.tHeight
	end


	function CarmackXScrollConfigData:getTileImageURL( index ,check)
		local url = tostring(self.imgURL) .. self.imgStyleName .. "_" .. index .. self.format
		if(check == true or check == nil ) then
			assert(file_exists(url),"图片不存在:" .. url)
		end
		return url
	end

	function CarmackXScrollConfigData:tileHeight( ... )
		return self.tHeight * g_fScaleY
	end

	function CarmackXScrollConfigData:tilewidth( ... )
		return self.tWidth * g_fScaleY
	end


return CarmackXScrollConfigData


-- 虚拟SpriteFramer
-- 目前只支持左对齐
require (BATTLE_CLASS_NAME.class)
local BattleVisualSpriteFrameContaner = class("BattleVisualSpriteFrameContaner")
  
 	------------------ properties ----------------------
 	BattleVisualSpriteFrameContaner.imageURL 			= nil -- spriteFrame的图片URL(用于加载)
 	BattleVisualSpriteFrameContaner.plistURL  			= nil -- spriteFrame的plist的url(用于加载)
 	BattleVisualSpriteFrameContaner.space 				= nil -- 间隔
 	BattleVisualSpriteFrameContaner.parent 				= nil -- 父级容器
 	BattleVisualSpriteFrameContaner.visible				= nil -- 是否可见
 	BattleVisualSpriteFrameContaner.position 			= nil -- 位置
 	BattleVisualSpriteFrameContaner.framePreName 		= nil -- spriteFrame前置名称,用于合成帧数据
 	BattleVisualSpriteFrameContaner.hasIni				= nil -- 是否初始化
 	BattleVisualSpriteFrameContaner.value 				= nil
 	BattleVisualSpriteFrameContaner.keyMap 				= nil -- 值转换(例如 "/" 可以转换成英文)
 	BattleVisualSpriteFrameContaner.children 			= nil 
 	BattleVisualSpriteFrameContaner.childrenNum 		= nil 
 	BattleVisualSpriteFrameContaner.frameCache			= nil -- CCSpriteFrameCache引用
 	BattleVisualSpriteFrameContaner.centerStyle 		= nil -- 居中
 	BattleVisualSpriteFrameContaner.totalWidth 			= nil
 	BattleVisualSpriteFrameContaner.scale 				= nil -- 缩放
 	BattleVisualSpriteFrameContaner.opacity 			= nil -- 透明度
 	BattleVisualSpriteFrameContaner.positions 			= nil
 	BattleVisualSpriteFrameContaner.size 				= nil
 	------------------ functions -----------------------
 	
 	function BattleVisualSpriteFrameContaner:ctor( ... )
 		self.position 			= {0,0}
 		self.space 				= 0
 		self.scale 				= 1
 		self.opacity 			= 1
 		self.visible 			= true
 		self.hasIni 			= false
 		self.keyMap				= {}
 		self.keyMap["/"] 		= "slash" -- 特殊转换
 		self.children 			= {}
 		self.childrenNum 		= 0
 		self.frameCache 		= CCSpriteFrameCache:sharedSpriteFrameCache()
 		self.centerStyle 		= false
 		self.totalWidth 		= 0
 		self.size 				= {width=0,height=0}
 	end


 	function BattleVisualSpriteFrameContaner:setCenterStyle( value )
 		if(self.centerStyle ~= value) then
 			self.centerStyle = value
 			self:refreshPosition()
 		end
 	end
 	function BattleVisualSpriteFrameContaner:iniWithSimple( parent , preName )
		assert(parent,"参数错误 BattleVisualSpriteFrameContaner:iniWithSimple ->parent is nil")
 	 	assert(preName,"参数错误 BattleVisualSpriteFrameContaner:iniWithSimple ->preName is nil")

 	 	self.parent 		= parent
 		self.framePreName 	= preName
 		self.hasIni 		= true
 	end
 	function BattleVisualSpriteFrameContaner:ini(parent,imageURL,plistURL,preName )
 		assert(parent,"参数错误 BattleVisualSpriteFrameContaner:ini ->parent is nil")
 		assert(not tolua.isnull(parent),"参数错误 BattleVisualSpriteFrameContaner:ini ->parent is nil in memory")
 		assert(imageURL,"参数错误 BattleVisualSpriteFrameContaner:ini ->imageURL is nil")
 		assert(plistURL,"参数错误 BattleVisualSpriteFrameContaner:ini ->plistURL is nil")
 		assert(preName,"参数错误 BattleVisualSpriteFrameContaner:ini ->preName is nil")
		assert(file_exists(imageURL),"ioError BattleVisualSpriteFrameContaner:ini ->imageURL is not existes" .. " " .. imageURL)
 		assert(file_exists(plistURL),"ioError BattleVisualSpriteFrameContaner:ini ->plistURL is not existes"  .. " " .. plistURL)
 		
 		self.parent 		= parent
 		self.imageURL 		= imageURL
 		self.plistURL 		= plistURL
 		self.framePreName 	= preName
 		-- Logger.debug("==CCSpriteBatchNumber texturePath:" .. tostring(texturePath))
  -- 		local imgIns = CCTextureCache:sharedTextureCache():textureForKey(imageURL)
		-- if(imgIns == nil) then
		-- 	-- Logger.debug("==CCSpriteBatchNumber imgIns is nil,we call addSpriteFramesWithFile")
		-- 	self.frameCache:addSpriteFramesWithFile(self.plistURL)
		-- end
  		
  		self.hasIni 		= true
 	end

 	function BattleVisualSpriteFrameContaner:setVisible( value )
 		if(self.visible ~= value) then
 			self.visible = value
 			for k,v in pairs(self.children) do
 				v:setVisible(value)
 			end
 		end
 	end

 	function BattleVisualSpriteFrameContaner:setPosition( x,y )
 		if(x ~= self.position[1] or y ~= self.position[2]) then
 			self.position[1] = x
 			self.position[2] = y
 			self:refreshPosition()
 		end
 	end
 	function BattleVisualSpriteFrameContaner:getPositionX( ... )
 		return self.position[1]
 	end

 	function BattleVisualSpriteFrameContaner:getPositionY( ... )
 		return self.position[2]
 	end

 	function BattleVisualSpriteFrameContaner:getPosition()
 		return ccp(self.position[1],self.position[2])
 	end
 	
 	function BattleVisualSpriteFrameContaner:setOpacity( value )
 		if(self.opacity ~= value and value) then
 			self.opacity = value
 			for k,frameSprite in pairs(self.children or {}) do
				frameSprite:setOpacity(self.opacity)
	 		end
 		end
 	end

 	function BattleVisualSpriteFrameContaner:getOpacity( )
 		return self.opacity
 	end

 	function BattleVisualSpriteFrameContaner:runAction( data )
 		if(self.hasIni and data and self.parent and not tolua.isnull(self.parent)) then
 			for k,sprite in pairs(self.children or {}) do
 				sprite:stopAllActions()
 				sprite:runAction(data)
 			end
 		end
 	end
 	function BattleVisualSpriteFrameContaner:setScale( value )
 		if(self.scale ~= value and value) then
 			self.scale = value
 			for k,frameSprite in pairs(self.children or {}) do
				frameSprite:setScale(self.scale)
	 		end
 			self:refreshPosition()
 		end

 	end

 	function BattleVisualSpriteFrameContaner:setAnchorPoint( ccp_ap )
 		for k,frameSprite in pairs(self.children or {}) do
				frameSprite:setAnchorPoint(ccp_ap)
	 		end
 	end
 	
 	function BattleVisualSpriteFrameContaner:getScale( )
 		return self.scale
 	end

 	function BattleVisualSpriteFrameContaner:refreshPosition()
 		local xStart = self.position[1]
 		local dx = 0
 		-- print("--- self.totalWidth",self.totalWidth)
 		if(self.centerStyle) then
 			dx = -self.totalWidth * self.scale/2
 			xStart = self.position[1] + dx
 		end
 		for k,frameSprite in pairs(self.children or {}) do
			frameSprite:setPosition(xStart,self.position[2])
    	  	local frameSpriteWidth = frameSprite:getContentSize().width
    	  	xStart = xStart + frameSpriteWidth * self.scale + self.space
 		end
 	end

 	function BattleVisualSpriteFrameContaner:getVisible( ... )
 		return self.visible
 	end
 	
 	function BattleVisualSpriteFrameContaner:getParent( )
 		return self.parent
 	end



 	function BattleVisualSpriteFrameContaner:setString( valueString)
 		if(self.hasIni and self.value ~= valueString and self.parent and not tolua.isnull(self.parent)) then
 	
 				self.value = valueString
 				self:removeAllChildren()
 				-- local xStart = position[1]
				
				valueString = "" .. valueString
				-- Logger.debug("=== setString:" .. valueString)
			 	for i=1, #valueString do
			 		local singleChar 	= string.char(string.byte(valueString,i))
			 		local reflect 		= self.keyMap[singleChar] or singleChar
			 		local frameName  	= self.framePreName .. "" .. reflect .. ".png"
			 		-- local frameData  	= self.frameCache:spriteFrameByName(frameName)
			 		-- assert(frameData,"spriteFrame不存在:" .. frameName)
			 		local frameSprite 	=  ObjectTool.getFrameSprite(frameName)
			 		assert(frameSprite,"spriteFrame不存在:" .. frameName)
			 		frameSprite:setAnchorPoint(CCP_ZERO)
			 		self.parent:addChild(frameSprite)
		    	  	table.insert(self.children,frameSprite)
		    	  	self.totalWidth = self.totalWidth + frameSprite:getContentSize().width + self.space
		    	  	self.size.height = math.max(self.size.height,frameSprite:getContentSize().width)
		    	  	self.size.width = self.totalWidth
			 	end
 
			 	self:refreshPosition()
 		end
 	end

 	function BattleVisualSpriteFrameContaner:getString()
	  	return self.value
 	end



 	function BattleVisualSpriteFrameContaner:removeAllChildren( ... )
 		
 		for k,v in pairs(self.children or {}) do
 			ObjectTool.removeObject(v)
 		end
 		self.children = {}
 	end


 	function BattleVisualSpriteFrameContaner:release( ... )
 		self:removeAllChildren()
 		self.parent = nil
 	end

 	function BattleVisualSpriteFrameContaner:removeFromParentAndCleanup(...)
 		self:release()
 	end



return BattleVisualSpriteFrameContaner

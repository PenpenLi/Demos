



-- 战斗中图片文字
require (BATTLE_CLASS_NAME.class)
local BattleWordsContainer = class("BattleWordsContainer",function ( ... )
	return CCSpriteBatchNode:create( BATTLE_CONST.ALL_WORDS_TEXTURE )
end)
  
 	------------------ properties ----------------------
 	BattleWordsContainer.imageURL 			= nil -- spriteFrame的图片URL(用于加载)
 	BattleWordsContainer.plistURL  			= nil -- spriteFrame的plist的url(用于加载)
 	BattleWordsContainer.space 				= nil -- 间隔
 	-- BattleWordsContainer.parent 				= nil -- 父级容器
 	-- BattleWordsContainer.visible				= nil -- 是否可见
 	-- BattleWordsContainer.position 			= nil -- 位置
 	BattleWordsContainer.framePreName 		= nil -- spriteFrame前置名称,用于合成帧数据
 	-- BattleWordsContainer.hasIni				= nil -- 是否初始化
 	BattleWordsContainer.value 				= nil
 	BattleWordsContainer.keyMap 				= nil -- 值转换(例如 "/" 可以转换成英文)
 	BattleWordsContainer.childrenList 			= nil 
 	BattleWordsContainer.childrenNum 		= nil 
 	BattleWordsContainer.frameCache			= nil -- CCSpriteFrameCache引用
 	BattleWordsContainer.centerStyle 		= nil -- 居中
 	BattleWordsContainer.totalWidth 			= nil
 	BattleWordsContainer.maxHeight 				= nil
 	BattleWordsContainer.CCP_XZERO 				= ccp(0,0.5)
 	BattleWordsContainer.frameMap 				= nil
 	-- BattleWordsContainer.scale 				= nil -- 缩放
 	-- BattleWordsContainer.opacity 			= nil -- 透明度
 	-- BattleWordsContainer.positions 			= nil
 	-- BattleWordsContainer.size 				= nil
 	------------------ functions -----------------------
 	
 	function BattleWordsContainer:ctor( ... )
 		-- self.position 			= {0,0}
 		self.space 				= 0
 		-- self.scale 				= 1
 		-- self.opacity 			= 1
 		-- self.visible 			= true
 		-- self.hasIni 			= false
 		self.keyMap				= {}
 		self.keyMap["/"] 		= "slash" -- 特殊转换
 		self.childrenList 			= {}
 		-- self.childrenNum 		= 0
 		self.frameCache 		= CCSpriteFrameCache:sharedSpriteFrameCache()
 		self.centerStyle 		= false
 		self.totalWidth 		= 0
 		self.maxHeight 			= 0
 		-- self.size 				= {width=0,height=0}
 		self.imageURL = BATTLE_CONST.ALL_WORDS_TEXTURE
 		self.plistURL = BATTLE_CONST.ALL_WORDS_PLIST
 		self.frameMap = {}
 	end


 	function BattleWordsContainer:setCenterStyle( value )
 		if(self.centerStyle ~= value) then
 			self.centerStyle = value
 			self:refreshPosition()
 		end
 	end
 
 
  
 	function BattleWordsContainer:setCenterStyle( value )
 		if(self.centerStyle ~= value) then
 			self.centerStyle = value
 			self:refreshPosition()
 		end
 	end

 	function BattleWordsContainer:refreshPosition()
 		local xStart = 0
 		local dx = 0
 		local size = self:getContentSize()
 		local scalexx = 1--self:getScale()
 		-- print("--- self.totalWidth",self.totalWidth)
 		if(self.centerStyle) then
 			dx = -self.totalWidth * 1/2
 			xStart = dx
 		end
 		for k,frameSprite in pairs(self.childrenList or {}) do
			frameSprite:setPosition(xStart,0)
			-- print("==== next postion:",xStart)
    	  	-- local frameSpriteWidth = frameSprite:getContentSize().width
    	  	-- 因为是居中 所以下个坐标点= 前一个宽/2 + 当前宽/2
    	  	-- if(k > 1) then
    	  	-- 	xStart = xStart + self.childrenWidths[k-1]/2 + self.childrenWidths[k]/2 + self.space
    	  	-- else 
    	  	-- 	if(self.childrenWidths[k + 1]) then
    	  	-- 		xStart = xStart + frameSpriteWidth/2 + self.childrenWidths[k + 1]/2 + self.space
    	  	-- 	else
    	  	-- 		xStart = xStart + frameSpriteWidth + self.space
    	  	-- 	end
    	  	-- end
    	  	-- xStart = xStart + frameSpriteWidth + self.space
    	  	xStart = xStart + self.childrenWidths[k] + self.space
    	  	-- print("-- BattleWordsContainer:",k,xStart)
 		end
 		-- print("-- BattleWordsContainer complete")
 	end

 	function BattleWordsContainer:setString( valueString ,preName)
 		self.framePreName 	= preName
 		-- if(self.hasIni and self.value ~= valueString and self.parent and not tolua.isnull(self.parent)) then
 		if(self.value ~= valueString) then
 	
 				self.value = valueString
 				
 				-- local ani = tolua.cast(self,"CCNode")
 				-- ani:removeAllChildren()

 				self:releaseUI()

 				-- local xStart = position[1]
				
				valueString = "" .. valueString
				-- Logger.debug("=== setString:" .. valueString)
			 	for i=1, #valueString do
			 		local singleChar 	= string.char(string.byte(valueString,i))
			 		local reflect 		= self.keyMap[singleChar] or singleChar
			 		local frameName  	= self.framePreName .. "" .. reflect .. ".png"
			 		-- local frameData  	= self.frameCache:spriteFrameByName(frameName)
			 		local frameSprite = ObjectTool.getFrameSprite(frameName)

			 		self.frameMap[frameName] = frameSprite
					frameSprite:setAnchorPoint(self.CCP_XZERO)
		    	  	self:addChild(frameSprite)
		    	  	table.insert(self.childrenList,frameSprite)
		    	  	self.totalWidth = self.totalWidth + frameSprite:getContentSize().width + self.space
		    	  	table.insert(self.childrenWidths,frameSprite:getContentSize().width)
		    	  	self.maxHeight = math.max(self.maxHeight,frameSprite:getContentSize().height)
		    	  	-- self.size.height = math.max(self.size.height,frameSprite:getContentSize().width)
		    	  	-- self.size.width = self.totalWidth
			 	end
 
			 	self:refreshPosition()
 		end
 	end

 	function BattleWordsContainer:getString()
	  	return self.value
 	end

 	function BattleWordsContainer:releaseUI( ... )
 		
 		for i,v in pairs(self.frameMap or {}) do
 			-- print("-- BattleWordsContainer:releaseUI",i,v)
 			-- ObjectSharePool.addObject(v,i)
 			ObjectTool.removeObject(v)
 		end

 		self.childrenList = {}
		self.childrenWidths = {}
		self.frameMap = {}
 	end
 	-- function BattleWordsContainer:release( ... )
 	-- 	-- local ani = tolua.cast(self,"CCNode")
 	-- 	-- 		ani:removeAllChildren()
 	-- 	self:removeAllChildrenWithCleanup(true)
 	-- 	self.parent = nil
 	-- 	self.frameCache = nil
 	-- end
 	


return BattleWordsContainer

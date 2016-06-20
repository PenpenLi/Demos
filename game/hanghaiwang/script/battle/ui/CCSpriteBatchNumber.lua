


local CCSpriteBatchNumber = class("CCSpriteBatchNumber")
   
  	------------------ properties ----------------------
  	CCSpriteBatchNumber.container 			= nil
  	CCSpriteBatchNumber.value 				= nil
  	CCSpriteBatchNumber.style 				= nil

  
  	------------------ functions -----------------------
  	function CCSpriteBatchNumber:release()
  		if(self.container) then
  			self.container:removeFromParentAndCleanup(true)
  			self.container = nil
  		end
  	end

  	function CCSpriteBatchNumber:create(plistPath,texturePath,value,style,useSign)
  		Logger.debug("plistPath:".. plistPath .. " texturePath" .. texturePath .. " value:" .. value .. " style:" .. style)
  		local sign  = ""
  		-- useSign = true
  		if(useSign == nil or useSign == false) then
  			useSign = ""
  		else
  			if(tonumber(value) > 0 ) then 
  				useSign = "+"
  			else
  				useSign = ""
  			end
  		end

  -- 		local plistCache = CCSpriteFrameCache:sharedSpriteFrameCache()

  -- 		-- Logger.debug("==CCSpriteBatchNumber texturePath:" .. tostring(texturePath))
  -- 		local imgIns = CCTextureCache:sharedTextureCache():textureForKey(texturePath)
		-- if(imgIns == nil) then
		-- 	-- Logger.debug("==CCSpriteBatchNumber imgIns is nil,we call addSpriteFramesWithFile")
		-- 	plistCache:addSpriteFramesWithFile(plistPath)
		-- end

  		
  		
  		 if(value and value ~= "" and style) then
	  		 	if(self.container == nil ) then
	  		 		-- self.container = CCSprite:create()
	  		 		self.container = CCSpriteBatchNode:create(texturePath)
	  		 		self.container:setAnchorPoint(ccp(0, 0.5));
				    -- self.container:setCascadeOpacityEnabled(true);
	  		 	end
	  		 	local valueString = useSign .. value
	  		 	-- local cache 	  = CCSpriteFrameCache:sharedSpriteFrameCache()

	  		 	local xStart 	  = 0-- #valueString * (numberWidth)/2
	  		 	 -- --print("CCSpriteBatchNumber xStart:",xStart)
				local centerMap 	= {}
	  		 	for i=1, #valueString do
	  		 	
	  		 		local singleChar 	= string.char(string.byte(valueString,i))
	  		 		local frameName  	= style .. "_" .. singleChar .. ".png"
	  		 		Logger.debug("frameName:".. frameName)
	  		 		-- local frameData  	= cache:spriteFrameByName(frameName)
	  		 		--  if(singleChar == nil or frameData == nil) then error("CCSpriteBatchNumber can't find :" .. frameName) end -- if end
	  		 		 
	  		 		 local frameSprite 	= ObjectTool.getFrameSprite(frameName)
	  		 		   
	  		 		       -- frameSprite:setDisplayFrame(frameData)
				           frameSprite:setAnchorPoint(ccp(0, 0.5))
				           -- frameSprite:setCascadeOpacityEnabled(true)

				          frameSprite:setPosition(xStart,0)
				          local frameSpriteWidth = frameSprite:getContentSize().width
				          xStart = xStart + frameSpriteWidth
 						   -- table.insert(centerMap,function( x )
				      --      	frameSprite:setPosition(x,0)
				      --      	return frameSpriteWidth
				      --      end)
				    	  self.container:addChild(frameSprite)
	  		 	end
	  		 	local left 		= -xStart/2
	  		 	-- local xx		= 0
	  		 	-- for i,v in ipairs(centerMap) do
	  		 	-- 	 xx = xx + v(left + xx)
	  		 	-- end
	  		 	local childList = self.container:getChildren()
	  		 	local num  		= childList:count()
	  		 	local xx		= 0
	  		 	for i=1,num  do
	  		 		local target = tolua.cast(childList:objectAtIndex(i - 1),"CCSprite")
	  		 		target:setPosition(left + xx ,0)
	  		 		xx = xx + target:getContentSize().width
	  		 	end
  		 end
  	end
return CCSpriteBatchNumber 

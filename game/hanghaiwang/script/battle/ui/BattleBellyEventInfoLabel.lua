-- 贝里活动信息标签


require (BATTLE_CLASS_NAME.class)
local BattleBellyEventInfoLabel = class("BattleBellyEventInfoLabel",function () return CCNode:create() end)
 
	------------------ properties ----------------------
	BattleBellyEventInfoLabel.propertyNameLabel 	= nil
	BattleBellyEventInfoLabel.propertyValueLabel 	= nil
	BattleBellyEventInfoLabel.propertyBack			= nil
	------------------ functions -----------------------
	

	function BattleBellyEventInfoLabel:ctor()
		self:createUI()
	end

	function BattleBellyEventInfoLabel:reset( pname )
		assert(pname,"BattleBellyEventInfoLabel:reset->pname is nil")
		-- assert(pvalue,"BattleBellyEventInfoLabel:reset->pvalue is nil")
		self.propertyNameLabel:setString(pname)
		-- self.propertyValueLabel:setString("")
		self:refreshPositionAndSize()
	end

	function BattleBellyEventInfoLabel:setValue( value )
		if(self.propertyValueLabel) then
			self.propertyValueLabel:setString(tostring(value))
		end
	end

	function BattleBellyEventInfoLabel:createUI()
		self:removeUI()

		-- 背景
		self.propertyBack = CCScale9Sprite:create(BATTLE_CONST.TIP_TEXTURE_URL)
		-- self.propertyBack:setCapInsets(CCRectMake(self.propertyBack:getContentSize().width/2 - 2,self.propertyBack:getContentSize().height/2 -2 ,1,1))
		self.propertyBack:setCapInsets(CCRectMake(10,10 ,1,1))
		self.propertyBack:setContentSize(CCSizeMake(150,46))
		self.propertyBack:setAnchorPoint(ccp(0,0.5))
		self:addChild(self.propertyBack)

		-- label
		self.propertyNameLabel = CCLabelTTF:create(tostring(""),g_sFontPangWa,24)
 		self.propertyNameLabel:setFontFillColor(ccc3(255,255,255))
 		self.propertyNameLabel:setAnchorPoint(ccp(0,0.5))
 		self.propertyNameLabel:enableStroke(ccc3(0,0,0),2)
 		self.propertyNameLabel:enableShadow(CCSizeMake(2, -2), 255, 0)

		self.propertyValueLabel = CCLabelTTF:create(tostring(""),g_sFontPangWa,24)
 		self.propertyValueLabel:setFontFillColor(ccc3(255,255,255))
 		self.propertyValueLabel:setAnchorPoint(ccp(0,0.5))
 		self.propertyValueLabel:enableStroke(ccc3(0,0,0),2)
 		self.propertyValueLabel:enableShadow(CCSizeMake(2, -2), 255, 0)

 		self:addChild(self.propertyNameLabel)
 		self:addChild(self.propertyValueLabel)


 		self.propertyNameLabel:setPosition(10,0)
 		self.propertyValueLabel:setPosition(self.propertyNameLabel:getContentSize().width + 10,0)

	end


	-- 设置属性名label的颜色
	function BattleBellyEventInfoLabel:setNameColor( r,g,b )
		if(self.propertyNameLabel) then
			r = r or 0
			g = g or 0
			b = b or 0
			self.propertyNameLabel:setFontFillColor(ccc3(r,g,b))
		end
	end


	-- 设置赋值label的颜色
	function BattleBellyEventInfoLabel:setValueColor( r,g,b )
		if(self.propertyValueLabel) then
			r = r or 0
			g = g or 0
			b = b or 0
			self.propertyValueLabel:setFontFillColor(ccc3(r,g,b))
		end
	end

	function BattleBellyEventInfoLabel:refreshPositionAndSize( ... )
	
		if(self.propertyValueLabel and 
		   self.propertyNameLabel) then
		  
		   self.propertyValueLabel:setPosition(self.propertyNameLabel:getContentSize().width + 10,0)
		   if(self.propertyBack) then
		   	  self.propertyBack:setContentSize(CCSizeMake(self.propertyNameLabel:getContentSize().width + 140,46))
		   end
		end



	end

	function BattleBellyEventInfoLabel:removeUI( ... )
		ObjectTool.removeObject(self.propertyNameLabel)
		ObjectTool.removeObject(self.propertyValueLabel)
		ObjectTool.removeObject(self.propertyBack)
		self.propertyValueLabel 	= nil
		self.propertyValueName 		= nil
		self.propertyBack 			= nil
	end

	function BattleBellyEventInfoLabel:dispose( ... )
		self:removeUI()
	end
	-- self.container = CCScale9Sprite:create(BATTLE_CONST.TIP_TEXTURE_URL)
	-- 		self.container:setCapInsets(CCRectMake(self.container:getContentSize().width/2 - 2,self.container:getContentSize().height/2 -2 ,2,2))
	-- 		self.container:setContentSize(CCSizeMake(g_winSize.width,46))
	-- 		-- 生成label
	-- 		local label = CCLabelTTF:create(tostring(words),g_sFontPangWa,24)
	--  		label:setFontFillColor(ccc3(255,255,255))
	--  		label:setAnchorPoint(CCP_HALF)
	--  		label:enableStroke(ccc3(0,0,0),2)
	--  		label:enableShadow(CCSizeMake(2, -2), 255, 0)
	--  		self.container:addChild(label)
	--  		label:setPositionX(self.container:getContentSize().width/2)
	--  		label:setPositionY(self.container:getContentSize().height/2)
	

return BattleBellyEventInfoLabel
require "hecore.display.CocosObject"
require "hecore.display.Layer"
require "hecore.display.Sprite"
require "hecore.display.TextField"

TextUtil = class()



RichTextField = class(Layer);

function RichTextField:ctor()
	Layer.ctor(self)
end

function RichTextField:create( fontName , fontSize , hInterval , vInterval , hAlignment, vAlignment , warpWidth )
	
	if not fontName then fontName = "微软雅黑" end
	if not fontSize then fontSize = 26 end
	if not hInterval then hInterval = 0 end
	if not vInterval then vInterval = 15 end
	if not hAlignment then hAlignment = "bottom" end
	if not vAlignment then vAlignment = "left" end
	if not warpWidth then warpWidth = 0 end

	local text = RichTextField.new()
	text.fontName = fontName
	text.fontSize = fontSize
	text.hInterval = hInterval
	text.vInterval = vInterval
	text.hAlignment = hAlignment
	text.vAlignment = vAlignment
	text.warpWidth = warpWidth

	text:init()

	return text
end

function RichTextField:init()
	Layer.initLayer(self)
	self.partList = {}
	self.rowList = {}
	self.bodyContainer = Layer:create()
	self:addChild(self.bodyContainer)
end

function RichTextField:addBitmapText(text , scale , font , color , hInterval)
	if not text then assert(text) return end

	if not scale then scale = 1 end
	if not font then font = "Bradley Hand ITC" end
	if not color then color = ccc4(255,255,255,255) end
	if not hInterval then hInterval = self.hInterval end

	if #self.rowList == 0 then
		local layer = Layer:create() 
		table.insert( self.rowList , layer )
		self.bodyContainer:addChild( layer )
	end

	local container = self.rowList[#self.rowList]

	local bitmapText = BitmapText:create( text , getGlobalDynamicFontMap(font) , -1, kCCTextAlignmentLeft)
	local sourceHeight = bitmapText:getGroupBounds().size.height
	bitmapText:setScale(scale)
	bitmapText:setColor(color)

	local size1 = container:getGroupBounds().size
	local size2 = bitmapText:getGroupBounds().size
	local size3 = self.bodyContainer:getGroupBounds().size

	if self.warpWidth > 0 then
		if size1.width + size2.width + hInterval > self.warpWidth then

			local newLayer = Layer:create() 
			table.insert( self.rowList , newLayer )
			newLayer:setPositionY( (size3.height + self.vInterval) * -1 )
			self.bodyContainer:addChild( newLayer )
			container = newLayer

			bitmapText:setPositionX( size2.width / 2 )
		else
			bitmapText:setPositionX( size1.width + (size2.width / 2) + hInterval )
		end
	else
		bitmapText:setPositionX( size1.width + (size2.width / 2) + hInterval )
	end
	
	local fixY = 0
	if scale > 1 then 
		fixY = -10 *  (scale - 1)
	end

	if self.hAlignment == "bottom" then
		bitmapText:setPositionY( (size2.height / 2) + fixY )
	elseif self.hAlignment == "top" then
		bitmapText:setPositionY( (size2.height / -2) + fixY )
	elseif self.hAlignment == "center" then
		--do nothing is just center
	end

	container:addChild(bitmapText)
end

function RichTextField:addView(view , hInterval , viewRect)
	if not view then assert(view) return end

	if not hInterval then hInterval = self.hInterval end

	if #self.rowList == 0 then
		local layer = Layer:create() 
		table.insert( self.rowList , layer )
		self.bodyContainer:addChild( layer )
	end

	local container = self.rowList[#self.rowList]

	local size1 = container:getGroupBounds().size
	local size2 = view:getGroupBounds().size
	local origin = view:getGroupBounds().origin
	if viewRect then
		size2 = { width = viewRect.width , height = viewRect.height }
		origin = { x = viewRect.x , y = viewRect.y }
	end
	local size3 = self.bodyContainer:getGroupBounds().size

	local viewContainer = LayerColor:create()
	viewContainer:changeWidthAndHeight( size2.width , size2.height )
	viewContainer:setOpacity(0)
	view:setPositionX( origin.x * -1 )
	view:setPositionY( origin.y * -1 )

	viewContainer:addChild(view)

	if self.warpWidth > 0 then
		if size1.width + size2.width + hInterval > self.warpWidth then

			local newLayer = Layer:create() 
			table.insert( self.rowList , newLayer )
			newLayer:setPositionY( (size3.height + self.vInterval) * -1 )
			self.bodyContainer:addChild( newLayer )
			container = newLayer

			viewContainer:setPositionX( 0 )
		else
			viewContainer:setPositionX( size1.width + hInterval )
		end
	else
		viewContainer:setPositionX( size1.width + hInterval )
	end

	local fixY = 0

	if self.hAlignment == "bottom" then
		viewContainer:setPositionY( fixY )
	elseif self.hAlignment == "top" then
		viewContainer:setPositionY( (size2.height * -1) + fixY )
	elseif self.hAlignment == "center" then
		--do nothing is just center
	end

	--viewContainer:setPositionY( (size2.height / 2) + fixY )
	container:addChild(viewContainer)
end
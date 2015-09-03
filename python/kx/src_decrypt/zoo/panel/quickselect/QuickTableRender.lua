QuickTableRender = class(CocosObject)

local minScale = 0.8
local maxScale = 1
function QuickTableRender:create( width, height, data )
	-- body
	local sp = CCSprite:createWithSpriteFrameName("bg_render0000")
	local s = QuickTableRender.new(sp)
	s:init(width, height, data)
	return s
end
function QuickTableRender:ctor( )
	-- body

end

function QuickTableRender:init( width, height, data )
	-- body
	self.width = width
	self.height = height
	self.data = data
	local contentSize = self:getContentSize()
	if self.data.isUnlock then
		self:addStarsArea()
	else
		local lock = Sprite:createWithSpriteFrameName("star_area_lock0000")
		local x = contentSize.width * 0.85
		local y = contentSize.height / 2
		lock:setPosition(ccp(x, y))
		self:addChild(lock)

	end

	self:addLevelArea()

	local fg = Sprite:createWithSpriteFrameName("fg_render0000")
	fg:setPosition(ccp(contentSize.width/2, contentSize.height/2))
	self.fg = fg
	self:addChild(fg)

	self:setScale(minScale)
end

local function createFontSprite( key, fontType )
	-- body
	local str = fontType == 1 and "star_fnt_" or "level_fnt_"
	local sprite = Sprite:createWithSpriteFrameName(str..key.."0000")
	return sprite
end

function QuickTableRender:addStarsArea( ... )
	-- body
	local str = "star_bg_red0000"
	if self.data.star_amount >= self.data.total_amount then
		str = "star_bg_green0000"
	end

	local star_bg = Sprite:createWithSpriteFrameName(str)
	local contentSize = self:getContentSize()
	x = contentSize.width * 0.87
	y = contentSize.height/2
	star_bg:setPosition(ccp(x,y))
	self:addChild(star_bg)

	local star = Sprite:createWithSpriteFrameName("star_icon_level0000")
	star:setScale(0.73)
	local star_bg_size = star_bg:getContentSize()
	x = x - star_bg_size.width/2 + 10
	star:setPosition(ccp(x,y))
	self:addChild(star)

	local keyList = {
		math.floor(self.data.star_amount / 10 ), 
		self.data.star_amount % 10, 
		"to",
		math.floor(self.data.total_amount / 10), 
		self.data.total_amount % 10
	}
	x = x + star_bg_size.width / 9
	for k = 1, #keyList do 
		local key = keyList[k]
		local sp = createFontSprite(key, 1)
		x = x + sp:getContentSize().width/2
		sp:setPosition(ccp(x,y))
		self:addChild(sp)
	end
end

function QuickTableRender:addLevelArea( ... )
	-- body
	local minLevel = (self.data.index - 1) * 15 + 1
	local maxLevel = self.data.index * 15
	local keyList = {
		"di",
		math.floor(minLevel / 100),
		math.floor((minLevel % 100) / 10),
		math.floor((minLevel % 100) % 10),
		"to",
		math.floor(maxLevel / 100),
		math.floor((maxLevel % 100) / 10),
		math.floor((maxLevel % 100) % 10),
		"guan",
	}

	local x = self:getContentSize().width / 4
	local y = self:getContentSize().height / 2
	for k = 1 , #keyList do 
		local key = keyList[k]
		local sp = createFontSprite(key, 0)
		if k == #keyList then
			x = x + 2 * sp:getContentSize().width / 3
		end
		sp:setPosition(ccp(x, y))
		if k < #keyList - 1 then
			x = x + 2 * sp:getContentSize().width / 3
		end
		self:addChild(sp)
	end

	local str = "area_icon_"..self.data.index.."0000"
	local icon
	if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(str) then
		icon = Sprite:createWithSpriteFrameName(str)
		self:addChild(icon)
		local x = self:getContentSize().width / 8
		icon:setPosition(ccp(x,y))
	end

	self.icon = icon
end

function QuickTableRender:hideIcon( ... )
	-- body
	if self.icon then
		self.icon:setVisible(false)
	end
end
function QuickTableRender:changeScale( value )
	-- body
	self:setScale(value)
	if self.icon then
		self.icon:setVisible(true)
	end
	local alpha = value - minScale
	self.fg:setAlpha( maxScale - alpha * 5)
end


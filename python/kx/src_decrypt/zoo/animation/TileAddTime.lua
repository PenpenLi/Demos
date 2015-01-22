TileAddTime = class(CocosObject)

local kCharacterAnimationTime = 1/30

function TileAddTime:create(colortype, addTime)
	local node = TileAddTime.new(CCNode:create())
	node.name = "addTime"

	print("----------------------TileAddTime:create:", addTime)
	addTime = addTime or 5

	local mainSprite = CocosObject:create()
	local str_temp = string.format("StaticItem%02d.png", colortype)
	local animal = Sprite:createWithSpriteFrameName(str_temp)
	mainSprite:addChild(animal)

	local timeIcon = Sprite:createWithSpriteFrameName(string.format("add_time_%d.png", addTime))
	timeIcon:setPosition(ccp(25, -25))
	mainSprite:addChild(timeIcon)

	local plusIcon = Sprite:createWithSpriteFrameName("add_time_plus.png")
	plusIcon:setPosition(ccp(8, -27))
	mainSprite:addChild(plusIcon)

	node.mainSprite = mainSprite
	node:addChild(mainSprite)

	return node
end

function TileAddTime:createAddTimeIcon(addTime)
	local node = CocosObject:create()
	local timeIcon = Sprite:createWithSpriteFrameName(string.format("add_time_%d.png", addTime))
	timeIcon:setPosition(ccp(25, -25))
	node:addChild(timeIcon)
	
	local plusIcon = Sprite:createWithSpriteFrameName("add_time_plus.png")
	plusIcon:setPosition(ccp(8, -27))
	node:addChild(plusIcon)

	return node
end
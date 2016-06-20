require "zoo.props.PropListContainer"
require "zoo.props.RightPropListController"
require "zoo.props.AutumnPropListItem"

RightPropList = class(PropListContainer)

function RightPropList:create(propListAnimation, size)
	local node = RightPropList.new(CCNode:create())
	PropListContainer.init(node, propListAnimation, size)
	node:_init()
	node:_buildUI()
	return node
end

function RightPropList:_init()
  	self:setController(RightPropListController:create(self))
end

function RightPropList:dispose()
	PropListContainer.dispose(self)
end

function RightPropList:_buildUI()
	local propsListView = ResourceManager:sharedInstance():buildGroup("spring_item_container")
  	local targetSize = propsListView:getGroupBounds().size
  	propsListView:setContentSize(CCSizeMake(targetSize.width, targetSize.height))
  	propsListView:setPosition(ccp(0, targetSize.height-60))
	self.propsListView = propsListView

	local itemHolder = self.propsListView:getChildByName("item")
	local size = itemHolder:getGroupBounds().size
	local pos = itemHolder:getPosition()
	local zOrder = itemHolder:getZOrder()
	local centerPos = ccp(pos.x + size.width / 2, pos.y - size.height / 2 - 2)
	itemHolder:removeFromParentAndCleanup(true)

	self.itemCenter = centerPos
	self.itemRadius = math.max(size.width/2, size.height/2)

	self.content:addChild(propsListView)
	local springItem = AutumnPropListItem:create(self.propListAnimation)
	self.springItem = springItem
	springItem:setPosition(centerPos)
	propsListView:addChildAt(springItem, zOrder)
end

function RightPropList:findSpringItem()
	return self.springItem
end

function RightPropList:foundHitItem(evt)
	local localPos = self.propsListView:convertToNodeSpace(evt.globalPosition)
	local dx = localPos.x - self.itemCenter.x
	local dy = localPos.y - self.itemCenter.y
	if (dx * dx + dy * dy) < self.itemRadius * self.itemRadius then
		return self.springItem
	end
	return nil
end

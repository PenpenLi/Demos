
BatchLayerGallery = class(ClippingNode)


function BatchLayerGallery:ctor()
	self.class=BatchLayerGallery;
	self.itemIndex = 1;	--当前索引
	self.count = 1;	--总个数
	
	self.pos = nil;	--当前偏移位置
	self.groupLayer = nil;
	self.layerList = {};
	
	self.upperScale = 1.3;	--放大比例
	
	self.currentItem = nil;
	
	self.itemSize = nil;
	self.viewSize = nil;
end

function BatchLayerGallery:dispose()
	self:stopAllActions();
	self:removeAllEventListeners();
	self:removeChildren();
	BatchLayerGallery.superclass.dispose(self);
	BitmapCacher:removeUnused();
end

function BatchLayerGallery:initialize(context,itemSize,viewSize)
	-- self:initLayer();
	self.context = context;
	self.viewSize = viewSize;
	self.itemSize = itemSize;

	-- self.sprite:setContentSize(CCRectMake(0 ,0, viewSize.width, viewSize.height));
	
	self:setAlphaThreshold(0.0);
	self:setContentSize(viewSize);
	
	local mask = self:getMask();
	mask.touchChildren = false;
	mask.touchEnabled = false;
	
	self.groupLayer = Layer.new();
	self.groupLayer:initLayer();
	-- self.groupLayer:setPositionY(self.itemSize.height*(self.upperScale-1)/3);
	self:addChild(self.groupLayer);
	self.groupLayer:addEventListener(DisplayEvents.kTouchBegin,self.onMoveBegin,self);
	local layer = Layer.new();
	layer:initLayer();
	self.groupLayer:addChild(layer);
	self.pos = self.groupLayer:getPosition();
	layer:setContentSize(itemSize);
	self.layerList[1] = layer;

end

function BatchLayerGallery:addLayer(item)
	if not item then return end;
	item:setContentSize(self.itemSize);
	item:setPositionX(self.itemSize.width*self.count);
	-- item:setPositionY(self.itemSize.height*(self.upperScale-1)/2);
	self.count = self.count+1;
	self.layerList[self.count] = item;
	-- item.touchEnabled = false;
	-- item.touchChildren = false;
	item:setAnchorPoint(ccp(0.5,0.5));
	self.groupLayer:addChild(item);
	if not self.currentItem then
		self.currentItem = item;
		item:setScale(self.upperScale);
		self.itemIndex = 2;
	end
end

function BatchLayerGallery:getChooseItem()
	return self.currentItem;
end

function BatchLayerGallery:onMoveBegin(event)
	self.beginPos = ccp(event.globalPosition.x,event.globalPosition.y)
	self:addEventListener(DisplayEvents.kTouchMove,self.onMove,self);
	self:addEventListener(DisplayEvents.kTouchEnd,self.onMoveEnd,self);
end

function BatchLayerGallery:onMove(event)
	-- print("onMove")
	local x,y = event.globalPosition.x,event.globalPosition.y;
	local direction = x - self.beginPos.x;
	if 20<direction then 
		self.direction = "right";
	elseif direction<0-20 then
		self.direction = "left";
	end
end

function BatchLayerGallery:onMoveEnd(event)
	print("onMoveEnd",self.direction,self.itemIndex)
	self:removeEventListener(DisplayEvents.kTouchMove,self.onMove);
	self:removeEventListener(DisplayEvents.kTouchEnd,self.onMoveEnd);
	if not self.direction then return end
	if "left" == self.direction and self.count == self.itemIndex then 
		self.moving = false;
		return 
	end;
	if "right" == self.direction and 2 == self.itemIndex then 
		self.moving = false;
		return 
	end;
	self.groupLayer:removeEventListener(DisplayEvents.kTouchBegin,self.onMoveBegin);
	if "right" == self.direction then
		self:batchAction(self.itemIndex-1);
	elseif "left" == self.direction then
		self:batchAction(self.itemIndex+1);
	end
	
end

function BatchLayerGallery:getItemByIndex(itemIndex)
	if not itemIndex or itemIndex < 1 or itemIndex > self. count then return end;
	return self.layerList[itemIndex];
end

--item1	:还原
--item2 :放大
function BatchLayerGallery:itemZoomAction(item1,item2)
	if nil == item1 or nil == item1.sprite then 
	
	else
		local zoomDownAction = CCScaleTo:create(0.3,1);
		item1:runAction(zoomDownAction);
	end
	if nil == item2 or nil == item2.sprite then 
	
	else
		local zoomUpAction = CCScaleTo:create(0.3,self.upperScale);
		item2:runAction(zoomUpAction);
	end
end

function BatchLayerGallery:groupMoveAction(desPos)
	if not desPos then return end;
	local ccArray = CCArray:create();
	ccArray:addObject(CCMoveTo:create(0.3,desPos));
	local function afterMoving()
		self.groupLayer:addEventListener(DisplayEvents.kTouchBegin,self.onMoveBegin,self);
		self.moving = false;
	end
	ccArray:addObject(CCCallFunc:create(afterMoving));
	self.groupLayer:runAction(CCSequence:create(ccArray));
end

function BatchLayerGallery:batchAction(itemIndex)
	if not itemIndex or itemIndex < 1 or itemIndex > self. count then 
		self.groupLayer:addEventListener(DisplayEvents.kTouchBegin,self.onMoveBegin,self);
		self.moving = false;
		return 
	end;
	local nextItem = nil;
	if "right" == self.direction then
		nextItem = self:getItemByIndex(itemIndex);
		self:itemZoomAction(self.currentItem,nextItem);
		self:groupMoveAction(ccp(self.groupLayer:getPosition().x+self.itemSize.width,self.pos.y));
	elseif "left" == self.direction then
		nextItem = self:getItemByIndex(itemIndex);
		self:itemZoomAction(self.currentItem,nextItem);
		self:groupMoveAction(ccp(self.groupLayer:getPosition().x-self.itemSize.width,self.pos.y));
	end
	self.itemIndex = itemIndex;
	self.currentItem = nextItem;
	self:dispatchEvent(Event.new("moveComplete"));
	self.direction = nil;
end

function BatchLayerGallery:toNextItem()
	if not self.moving then
		print("moveRight")
		self.moving = true;
		self.direction = "right";
		self:onMoveEnd();
	end
end

function BatchLayerGallery:toPrivousItem()
	if not self.moving then
		print("moveLeft")
		self.moving = true;
		self.direction = "left";
		self:onMoveEnd();
	end
end

function BatchLayerGallery:setFlipCompleteHandler(func)
	if func then
		self:addEventListener("moveComplete",func,self.context);
	end
end

function BatchLayerGallery:getCurrentIndex()
	return self.itemIndex - 1;
end

function BatchLayerGallery:scrollToItemByIndex(itemIndex)
	-- print(self.itemIndex,itemIndex)
	itemIndex = itemIndex + 1;
	if itemIndex > self.itemIndex then
		nextItem = self:getItemByIndex(itemIndex);
		self:itemZoomAction(self.currentItem,nextItem);
		self:groupMoveAction(ccp(self.groupLayer:getPosition().x-self.itemSize.width*(itemIndex-2),self.pos.y));
	elseif itemIndex < self.itemIndex then
		nextItem = self:getItemByIndex(itemIndex);
		self:itemZoomAction(self.currentItem,nextItem);
		self:groupMoveAction(ccp(self.groupLayer:getPosition().x+self.itemSize.width*(itemIndex-2),self.pos.y));
	end
	self.itemIndex = itemIndex;
	self.currentItem = nextItem;
	self:dispatchEvent(Event.new("moveComplete"));
end
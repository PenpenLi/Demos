

require "core.display.Layer"
require "core.controls.ListScrollViewLayer"

ScrollSelectButton = class(Layer);

function ScrollSelectButton:ctor()
	self.class = ScrollSelectButton;
	self.nodeType = DisplayNodeType.kOthers;
	self.items = {};
	self.isInitialized = false;
	self.curItem = nil;
end

function ScrollSelectButton:dispose()
	-- self:removeAllItems();
	self:removeAllEventListeners();
	self:removeChildren();
	ScrollSelectButton.superclass.dispose(self);
end

function ScrollSelectButton:setDiyData(diyData)
	self.diyData = diyData;
end
--CCSize itemSize:width,height
--CCSize viewSize:width,height
--int itemCount
--int scale
--int direction:kCCScrollViewDirectionHorizontal/kCCScrollViewDirectionVertical (水平/垂直)
function ScrollSelectButton:initialize(itemSize, viewSize, itemCount, scale, direction)
	self.isInitialized = true;
	self:initLayer();
	self.itemCount = itemCount;
	
	if not scale then
		scale = 1.5;
	end
	if not direction then
		direction = kCCScrollViewDirectionHorizontal;
	end
	self.itemSize = itemSize;
	self.viewSize = viewSize;
	self.direction = direction;
	self.scale = scale;

	
	self.backgroundLayer = Layer.new();
	self.backgroundLayer:initLayer();
	self.backgroundLayer:setContentSize(viewSize);
	self:addChild(self.backgroundLayer);
	
	if not self.listScrollView then
		self.listScrollView = ListScrollViewLayer.new();
		self.listScrollView:initLayer();
		-- self.listScrollView:setViewSize(viewSize);
		-- self.listScrollView:setItemSize(itemSize);
		self.listScrollView:setDirection(direction);
		self.backgroundLayer:addChild(self.listScrollView);
	end
	
	if kCCScrollViewDirectionHorizontal == direction then
		self.listScrollView:setViewSize(makeSize(viewSize.width, itemSize.height*scale));
		self.listScrollView:setItemSize(makeSize(itemSize.width, itemSize.height*scale));	
		self.skewY = itemSize.height*(scale-1)/2;
		self.skewX = (viewSize.width-itemSize.width)/2-1;
	else
		self.listScrollView:setViewSize(makeSize(itemSize.width*scale, viewSize.height));
		-- self.listScrollView:setItemSize(makeSize(itemSize.width*scale, itemSize.height));
		self.skewX = itemSize.width*(scale-1)/2;
		self.skewY = (viewSize.height-itemSize.height)/2;
	end

	--需要在listView前后添加填充的空Layer以保证选项最边缘也在放大区域内
	-- if kCCScrollViewDirectionHorizontal == direction then
		-- self.paddingCount = math.ceil((viewSize.width - itemSize.width)/itemSize.width/2);
	-- else
		-- self.paddingCount = math.ceil((viewSize.height - itemSize.height)/itemSize.height/2);
	-- end
	self.paddingCount = 2;
	self:addPadding();
	
	local function scrollHandle()
		-- local pos = self.listScrollView:getContentOffset();
		-- if kCCScrollViewDirectionHorizontal == direction then
		-- 	pos.x = pos.x *scale;
		-- 	self.upList:setContentOffset(pos,true);	
		-- else
		-- 	pos.y = pos.y *scale;
		-- 	self.upList:setContentOffset(pos,true);	
		-- end
		if self.curItem then 
			self.curItem:setAnchorPoint(ccp(0,0));
			self.curItem:setScale(1);
		end
		local item = self.listScrollView.sprite:getItemByIndex(self:getSelect()+1);

		local anchorPoint
		if self.diyData and self.diyData.anchorPoint then
			anchorPoint = self.diyData.anchorPoint;
		else
			anchorPoint = ccp(0.25,0.25);
		end
		item:setAnchorPoint(anchorPoint);
		item:setScale(self.scale);
		self.curItem = item;
		-- print(item:getContentSize().width,item:getContentSize().height,self:getSelect());

		self:dispatchEvent(Event.new("moving"));
	end
	self.listScrollView:setAnimateScrollFunction(scrollHandle);
	self.listScrollView:enableScrollFocusLocation(true,0.5,0.5);
	
	
end

function ScrollSelectButton:addItem(item, touchenable)
	if not touchenable then
		touchenable = false;
	end
	item.touchEnabled = touchenable;
	item.touchChildren = touchenable;
	-- self.listScrollView:setItemSize(item1:getGroupBounds().size);
	self.listScrollView:addItem(item);
end

--填充
function ScrollSelectButton:addPadding()
	for i=1,self.paddingCount do
		local downPadding = Layer.new();
		downPadding:initLayer();
		self.listScrollView:addItem(downPadding);
	end
	-- self:listScrollViewHandle();
end

function ScrollSelectButton:removeAllItems(cleanup)
	self.listScrollView:removeAllItems(cleanup);
end

function ScrollSelectButton:listScrollViewHandle()
	local pos = self.listScrollView:getContentOffset();
	local downPos = {};
	if kCCScrollViewDirectionHorizontal == self.direction then
		-- pos.x = pos.x - self.skewX + self.paddingCount*self.itemSize.width;
		local r = pos.x/self.itemSize.width%1;
		if r > 0.5 then
			r = math.ceil(pos.x/self.itemSize.width);
		else
			r = math.floor(pos.x/self.itemSize.width);
		end
		local xOffset = 0;
		if self.diyData and self.diyData.xOffset then
			xOffset = self.diyData.xOffset
		end
		
		local yOffset = 0;
		if self.diyData and self.diyData.yOffset then
			yOffset = self.diyData.yOffset
		end
		downPos.y = pos.y + yOffset;
		downPos.x = self.itemSize.width*r + xOffset;
	else
		-- pos.y = pos.y - self.skewY + self.paddingCount*self.itemSize.height;
		local r = pos.y/self.itemSize.height%1;
		if r > 0.5 then
			r = math.ceil(pos.y/self.itemSize.height);
		else
			r = math.floor(pos.y/self.itemSize.height);
		end

		downPos.y = self.itemSize.height*r;
	end
	downPos = ccp(downPos.x, downPos.y);
	self.listScrollView:setContentOffset(downPos,true);	
end

function ScrollSelectButton:getSelect()
	local pos = self.listScrollView:getContentOffset();
	local r;
	if kCCScrollViewDirectionHorizontal == self.direction then
		r = (pos.x)/self.itemSize.width;
	else
		r = (pos.y)/self.itemSize.height;
	end
	-- print(0-r+self.paddingCount-1);
	r = 0-r+self.paddingCount-1;
	if r%1 > 0.5 then
		r = math.ceil(r);
	else
		r = math.floor(r);
	end
	if r < 1  then
		r = 1;
	elseif r > self.itemCount then
		r = self.itemCount
	end
	-- print(r)
	return r;
end

function ScrollSelectButton:setMovingHandler(context,func)
	if context then
		self:addEventListener("moving",func,context);
	end
end

function ScrollSelectButton:scrollToItemByIndex(index)
	-- log(index);
	if not index then return end;
	-- self.listScrollView:scrollToItemByIndex(index,true);
	local pos = self.listScrollView:getContentOffset();
	if kCCScrollViewDirectionHorizontal == self.direction then
		pos.x = 0 - self.itemSize.width*index
	else
		-- pos.y = posy
	end
	self.listScrollView:setContentOffset(pos,true)
end

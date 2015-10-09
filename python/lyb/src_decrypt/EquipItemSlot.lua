require "core.controls.page.CommonSlot"

EquipItemSlot=class(CommonSlot);

function EquipItemSlot:ctor()
  self.class=EquipItemSlot;
  self.beginX = 0;
  self.endX = 0;
end

function EquipItemSlot:dispose()

end

-- 创建实例
function EquipItemSlot:create(context,items,onCardTap)	
	self.context = context;
	self.onCardTap = onCardTap;
	self.items = items;
	local item = EquipItemSlot.new();
	item:initialize(items);

	return item;
end

function EquipItemSlot:initialize(items)
	self:initLayer();
	self.items = items;

	local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_equipe_bg");
	self:addChild(bg);

	self:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self);
	self:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self);
end

-- 设置slot的数据(子类重写该方法)
function EquipItemSlot:setSlotData(items)
	self.items = items;
	if self.bagItem then
		self:removeChild(self.bagItem);
		self.bagItem = nil;
	end
	local data = items;
	if data then
		data = copyTable(data);
		self.bagItem=BagItem.new();
		self.bagItem:initialize(data,false,self.context.bagProxy);
		self.bagItem:setPositionXY(ConstConfig.CONST_GRID_ITEM_SKEW_X,ConstConfig.CONST_GRID_ITEM_SKEW_Y);
		self:addChild(self.bagItem);

	end

end

function EquipItemSlot:onTapBegin(event)
  	self.beginX = event.globalPosition.x;
end
function EquipItemSlot:onTapEnd(event)
	self.endX = event.globalPosition.x;
	if math.abs(self.beginX - self.endX) < 10 then
  		self.onCardTap(self.context,self.items,self.bagItem);
	end;

end
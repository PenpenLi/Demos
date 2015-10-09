

require "core.controls.ListScrollViewLayer"

SelectListScrollViewLayer = class(ListScrollViewLayer);

-- 构造函数
function SelectListScrollViewLayer:ctor()
	self.class = SelectListScrollViewLayer;
	self.nodeType = DisplayNodeType.kOthers;
end

-- 初始化层对象
function SelectListScrollViewLayer:initLayer()
	if not self.initialized then
		self.sprite = CCSelectListScrollView:create();

		if self.sprite then
			self.sprite:retain();
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;
	end
end

-- 销毁对象
function SelectListScrollViewLayer:dispose()
	SelectListScrollViewLayer.superclass.dispose(self);
end

function SelectListScrollViewLayer:setSelectItemScale(scale)
	if self.sprite then
		self.sprite:setSelectItemScale(scale)
	end
end


function SelectListScrollViewLayer:setSelectScaleRect(rect)
	if self.sprite then
		self.sprite:setSelectScaleRect(rect)
	end
end

function SelectListScrollViewLayer:setSelectAnchorPoint(anchorPoint)
	if self.sprite then
		self.sprite:setSelectAnchorPoint(anchorPoint)
	end
end

function SelectListScrollViewLayer:registerScrollEndHandler(handler)
	if self.sprite then
		self.sprite:registerScrollEndHandler(handler)
	end
end

function SelectListScrollViewLayer:getSelectIndex()
	if self.sprite then
		return self.sprite:getSelectIndex()
	end
end

function SelectListScrollViewLayer:setSelectItemByIndex(nIndex)
	if self.sprite then
		return self.sprite:setSelectItemByIndex(nIndex)
	end
end


require "core.display.Layer"

MoveLayer = class(Layer);

-- 构造函数
function MoveLayer:ctor()
	self.class = MoveLayer;
	self.nodeType = DisplayNodeType.kOthers;
end

-- 初始化翻页滑动层
function MoveLayer:initLayer()
	if not self.initialized then
		self.sprite = CCMoveLayer:create();

		if self.sprite then
			self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;
	end
end

function MoveLayer:registerBeginScriptHandler(nHandler)
	self.sprite:registerBeginScriptHandler(nHandler);
end

function MoveLayer:registerEndScriptHandler(nHandler)
	self.sprite:registerEndScriptHandler(nHandler);
end

function MoveLayer:registerScriptHandler(nHandler)
	self.sprite:registerScriptHandler(nHandler);
end

function MoveLayer:setMoveState(bool)
	self.sprite:setMoveState(bool);
end

-- 销毁对象
function MoveLayer:dispose()
	self.sprite:removeAllChildrenWithCleanup(true);
	MoveLayer.superclass.dispose(self);
end
--=======================================
-- 遮罩显示对象
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  ClippingNode.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/22
-- descrip:   对Cocos2d-x中自定义的CCClippingPane类封装
--=======================================

ClippingNode = class(DisplayNode);

-- 构造函数
function ClippingNode:ctor(mask)
	self.class = ClippingNode;
	self.mask = mask;

	if self.mask ~= nil then
		self.sprite = CCClippingPane:create(self.mask.sprite);
	end

	if self.sprite then
		self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
		self.sprite:setAnchorPoint(makePoint(0, 0));
	end
end

-- 销毁对象
function ClippingNode:dispose()
	ClippingNode.superclass.dispose(self);
	self.mask = nil;
end

-- 获取模板
-- return CCNode — 模板显示对象
function ClippingNode:getStencil()
	--return self.sprite:getStencil();
end

-- 设置模板
-- CCNode stencil — 显示模板
function ClippingNode:setStencil(stencil)
	self.sprite:setStencil(stencil);
end

-- 获取遮罩
-- return DisplayNode — lua显示对象
function ClippingNode:getMask()
	return self.mask;
end

-- 设置遮罩
-- DisplayNode maskClip — 遮罩对象
function ClippingNode:setMask(maskClip)
	self.mask = maskClip;
	--self:setStencil(maskClip.sprite);
end

-- 设置反转
-- bool inverted — 标识
function ClippingNode:setInverted(inverted)
	--self.sprite:setInverted(inverted);
end

-- 设置透明度
-- float alpha — 透明度
function ClippingNode:setAlphaThreshold(alpha)
	--self.sprite:setAlphaThreshold(alpha);
end
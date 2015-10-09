--=======================================
-- 遮罩显示对象
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  ClippingNodeMask.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/22
-- descrip:   对Cocos2d-x中自定义的CCClippingNode类封装
--=======================================

ClippingNodeMask = class(DisplayNode);

-- 构造函数
function ClippingNodeMask:ctor(mask)
	self.class = ClippingNodeMask;
	self.mask = mask;

	if self.mask ~= nil then
		self.sprite = CCClippingNode:create(self.mask.sprite);
	end

	if self.sprite then
		self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
		self.sprite:setAnchorPoint(makePoint(0, 0));
	end
end

-- 销毁对象
function ClippingNodeMask:dispose()
	ClippingNodeMask.superclass.dispose(self);
	self.mask = nil;
end

-- 获取模板
-- return CCNode — 模板显示对象
function ClippingNodeMask:getStencil()
	return self.sprite:getStencil();
end

-- 设置模板
-- CCNode stencil — 显示模板
function ClippingNodeMask:setStencil(stencil)
	self.sprite:setStencil(stencil);
end

-- 获取遮罩
-- return DisplayNode — lua显示对象
function ClippingNodeMask:getMask()
	return self.mask;
end

-- 设置遮罩
-- DisplayNode maskClip — 遮罩对象
function ClippingNodeMask:setMask(maskClip)
	self.mask = maskClip;
	self:setStencil(maskClip.sprite);
end

-- 设置反转
-- bool inverted — 标识
function ClippingNodeMask:setInverted(inverted)
	self.sprite:setInverted(inverted);
end

-- 设置透明度
-- float alpha — 透明度
function ClippingNodeMask:setAlphaThreshold(alpha)
	self.sprite:setAlphaThreshold(alpha);
end
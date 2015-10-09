--=======================================
-- 图像组件
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  Image.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/01/30
-- descrip:   对Cocos2d-x添加图片的相关操作封装并形成组件
--=======================================

require "core.display.DisplayNode"

Image = class(DisplayNode);

-- 构造函数
function Image:ctor()
	self.sprite = nil;

	-- 默认允许触摸操作
	self.touchEnabled = true;
    self.touchChildren = true;
end

-- 加载图片
-- string pszFileName — 图片路径
-- display.DisplayBounds bounds — 显示矩形Lua封装
function Image:load(pszFileName, bounds)
	self.pszFileNameTest = pszFileName

	if bounds and bounds:isClass(DisplayBounds) then
		-- 矩形区域存在时，则按区域显示图片
		self.sprite = CCSprite:create(pszFileName, bounds:toRect());
	else
		-- 矩形区域不存在时，则按图片默认尺寸显示图片
		self.sprite = CCSprite:create(pszFileName);
	end
	
	self.sprite:retain();
	self.sprite:setAnchorPoint(CCPointMake(0, 0));
	--log("-------add image----end----"..pszFileName)
end

-- 只输入artid即可
function Image:loadByArtID(artID, bounds)
	if nil ==  artID then
		error("artID is nil")
	elseif nil == artData[artID] then
		error("artID:" .. artID .. "is not exist")
	else
		self:load(artData[artID].source,bounds)
	end
end

-- 销毁图片组件方法
function Image:dispose()
	-- print("-------dispose image--------"..self.pszFileNameTest)
	if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
	-- 调用父类的dispose方法
	Image.superclass.dispose(self);
end
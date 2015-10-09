--=======================================
-- 多颜色文本Lua封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  MultiColoredLabel.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/03
-- descrip:   对Cocos2d-x中自定义的CCMutilColoredLabel类封装
--=======================================

require "core.display.DisplayNode"

MultiColoredLabel = class(DisplayNode);

-- 构造函数
function MultiColoredLabel:ctor(string, fontName, fontSize, textFieldSize, alignment)
	self.class = MultiColoredLabel;
	self.string = string;
	self.fontName = fontName;
	self.fontSize = fontSize;
    self.textFieldSize = textFieldSize or CCSizeMake(0, 0)
    self.alignment = alignment or kCCTextAlignmentLeft;
    if self.string then
		local returnValue
		if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
			returnValue = getLuaCodeTranslated(self.string)
		   
		end

		if returnValue then
			self.string = returnValue
		end
		self.sprite = CCMultiColoredLabelTTF:create(self.string, self.fontName, self.fontSize, self.textFieldSize, self.alignment );
    else
    	error("String can not be nil(MultiColoredLabel:ctor)")
    end
	if self.sprite then
		self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
		self.sprite:setAnchorPoint(makePoint(0, 0));
	end
end

-- 销毁对象
function MultiColoredLabel:dispose()
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
	MultiColoredLabel.superclass.dispose(self);
	self.string = nil;
	self.fontName = nil;
	self.fontSize = nil;
end

-- 设置字符串
-- string text — 字符串
function MultiColoredLabel:setString(text)

	if text then
		local returnValue
		if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
			returnValue = getLuaCodeTranslated(text)
		   
		end
		if returnValue then
			text = returnValue
		end
		self.sprite:setString(text);
	else
        error("String can not be nil")
    end
end

-- 获取字符串
-- return string — 字符串
function MultiColoredLabel:getString()
	return self.sprite:getString();
end

-- 设置链接回调
function MultiColoredLabel:setLinkFunctionHandle(handle)
	self.sprite:setLinkFunctionHandle(handle);
end
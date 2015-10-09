--=======================================
-- 多颜色文本Lua封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  RichLabelTTF.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/03
-- descrip:   对Cocos2d-x中自定义的CCMutilColoredLabel类封装
--=======================================

require "core.display.DisplayNode"

RichLabelTTF = class(DisplayNode);

-- 构造函数
function RichLabelTTF:ctor(string, fontName, fontSize, textFieldSize, alignment)
	self.class = RichLabelTTF;
	self.string = string;
	self.fontName = fontName;
	self.fontSize = fontSize;
    self.textFieldSize = textFieldSize or CCSizeMake(0, 0)
    self.alignment = alignment or kCCTextAlignmentLeft;
	
	local returnValue
	if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
		returnValue = getLuaCodeTranslated(self.string)
	end

	if returnValue then
		self.string = returnValue
	end
	self.sprite = CCRichLabelTTF:create(self.string, self.fontName, self.fontSize, self.textFieldSize, self.alignment );

	if self.sprite then
		self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
		self.sprite:setAnchorPoint(makePoint(0, 0));
	end
end

function RichLabelTTF:initialize()
	local function cb(event)
		self.sprite:notifyTouching(true,event.globalPosition.x+GameData.uiOffsetX,event.globalPosition.y + GameData.uiOffsetY);
	end
	local function cb_1(event)
		self.sprite:notifyTouching(false,event.globalPosition.x+GameData.uiOffsetX,event.globalPosition.y+GameData.uiOffsetY);
	end
	self:addEventListener(DisplayEvents.kTouchBegin,cb);
	self:addEventListener(DisplayEvents.kTouchEnd,cb_1);
end

-- 销毁对象
function RichLabelTTF:dispose()
    if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
	RichLabelTTF.superclass.dispose(self);
	self.string = nil;
	self.fontName = nil;
	self.fontSize = nil;
end

-- 设置字符串
-- string text — 字符串
function RichLabelTTF:setString(text)
    local returnValue
    if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
        returnValue = getLuaCodeTranslated(text)
       print("text:", text)
    end

    if returnValue then
        text = returnValue
    end
	self.sprite:setString(text);
end

-- 获取字符串
-- return string — 字符串
function RichLabelTTF:getString()
	return self.sprite:getString();
end

-- 设置链接回调
function RichLabelTTF:setLinkFunctionHandle(handle)
	self.sprite:setLinkFunctionHandle(handle);
end

function RichLabelTTF:setWordAutoWrap(bool, size)
	self.sprite:setWordAutoWrap(bool,size);
end

function RichLabelTTF:setLineGapHeight(h)
	self.sprite:setLineGapHeight(h);
end

function RichLabelTTF:setAutoMaxContentSize(bool)
	self.sprite:setAutoMaxContentSize(bool);
end

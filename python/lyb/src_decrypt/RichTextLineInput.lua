--=======================================
-- 文本输入Lua封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  RichTextLineInput.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/03
-- descrip:   对Cocos2d-x中自定义的CCRichTextLineInputTTF类封装
--=======================================

require "core.display.DisplayNode"

RichTextLineInput = class(DisplayNode);

-- 构造函数
function RichTextLineInput:ctor(placeholder, fontSize, dimensions, cursorActionDurarion, fontName)
	self.class = RichTextLineInput;

	if nil==dimensions then
		dimensions=makeSize(300,80);
	end

	if nil== cursorActionDurarion then
		cursorActionDurarion=0.75;
	end

	if nil==fontName then
		fontName="resource/font/Microsoft YaHei.ttf";
	end

	if placeholder == nil then
		placeholder = "Please Input Text...";
	else
	   local returnValue
		if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
			returnValue = getLuaCodeTranslated(placeholder)
			print("placeholder:", placeholder)
		end

	    if returnValue then
	        placeholder = returnValue
	    end
	end

	if fontSize == nil then
		fontSize=25;
	end

	self.sprite = CCRichTextLineInputTTF:textFieldWithPlaceHolder(placeholder, fontName, fontSize, dimensions, cursorActionDurarion);

	if self.sprite then
		self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
		self.sprite:setAnchorPoint(makePoint(0, 0));
	end
end

function RichTextLineInput:initialize()
	local function cb(event)
		self.sprite:notifyTouching(true,event.globalPosition.x,event.globalPosition.y);
	end
	local function cb_1(event)
		self.sprite:notifyTouching(false,event.globalPosition.x,event.globalPosition.y);
	end
	self:addEventListener(DisplayEvents.kTouchBegin,cb);
	self:addEventListener(DisplayEvents.kTouchEnd,cb_1);
end

-- 销毁对象
function RichTextLineInput:dispose()
	if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
	RichTextLineInput.superclass.dispose(self);
end

-- 获取输入文本内容
-- return string — 文本内容
function RichTextLineInput:getInputText()
	return self.sprite:getInputText();
end

-- 设置输入的文本内容
-- string text — 文本内容
function RichTextLineInput:setInputText(text)
	    local returnValue
    if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
        returnValue = getLuaCodeTranslated(text)
       print("text:", text)
    end

    if returnValue then
        text = returnValue
    end
	self.sprite:setInputText(text);
end

-- 设置最大输入字符数
-- int length — 字符数
function RichTextLineInput:setMaxChars(length)
	self.sprite:setMaxChars(length);
end

-- 获取字符的真实数量（按字节）
-- return int — 字符数
function RichTextLineInput:getRealCharCount()
	return self.sprite:getRealCharCount();
end

-- 获取字符数量
-- retun int — 字符数
function RichTextLineInput:getCharCount()
	return self.sprite:getCharCount();
end

-- 设置文本颜色
-- ccColor3B color — 文本颜色
function RichTextLineInput:setColor(color)
	self.sprite:setColor(color);
end

-- 打开输入法
function RichTextLineInput:openIME()
	self.sprite:openIME();
end

-- 关闭输入法
function RichTextLineInput:closeIME()
	self.sprite:closeIME();
end

-- 字体
-- return string — 字体名称
function RichTextLineInput:getFontName()
	return self.sprite:getFontName();
end

-- 字号
-- return string — 字号
function RichTextLineInput:getFontSize()
	return self.sprite:getFontSize();
end

-- 添加输入法打开回调方法
-- function handler — 回调方法
function RichTextLineInput:addIMEOpenHandler(handler)
	self.sprite:addIMEOpenScriptHandler(handler);
end

-- 添加输入法关闭回调方法
-- function handler — 回调方法
function RichTextLineInput:addIMECloseHandler(handler)
	self.sprite:addIMECloseScriptHandler(handler);
end

-- 添加输入字符回调方法
-- function handler — 回调方法
function RichTextLineInput:addInsertHandler(handler)
	self.sprite:addInsertScriptHandler(handler);
end

-- 添加删除字符回调方法
-- function handler — 回调方法
function RichTextLineInput:addDeleteHandler(handler)
	self.sprite:addDeleteScriptHandler(handler);
end

function RichTextLineInput:appendInputText(text)
	self.sprite:appendInputText(text);
end

function RichTextLineInput:deleteBackward()
	self.sprite:deleteBackward();
end

function RichTextLineInput:setSingleline(bool)
	self.sprite:setSingleline(bool);
end

function RichTextLineInput:isSoftKeyboardAppendingMode()
	return self.sprite:isSoftKeyboardAppendingMode();
end

function RichTextLineInput:setSoftKeyboardAppendingMode(bool)
	self.sprite:setSoftKeyboardAppendingMode(bool);
end

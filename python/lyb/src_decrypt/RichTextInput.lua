--=======================================
-- 文本输入Lua封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  RichTextInput.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/03
-- descrip:   对Cocos2d-x中自定义的CCRichTextLineInputTTF类封装
--=======================================
require "core.display.DisplayNode"
require "core.display.ccTypes"

RichTextInput = class(DisplayNode);

-- 构造函数
function RichTextInput:ctor(placeholder, fontSize, dimensions, cursorActionDurarion, fontName)
	self.class = RichTextInput;

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

-- 销毁对象
function RichTextInput:dispose()
	if self.sprite then
        self.sprite:release();
        self.sprite = nil;
    end
	RichTextInput.superclass.dispose(self);
end

-- 获取输入文本内容
-- return string — 文本内容
function RichTextInput:getInputText()
	return self.sprite:getInputText();
end
function RichTextInput:setString(text)

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
-- 设置输入的文本内容
-- string text — 文本内容
function RichTextInput:setInputText(text)
	self.sprite:setInputText(text);
end

function RichTextInput:getString()
  return self.sprite:getInputText();
end
-- 设置最大输入字符数
-- int length — 字符数
function RichTextInput:setMaxChars(length)
	self.sprite:setMaxChars(length);
end

-- 设置文本颜色
-- ccColor3B color — 文本颜色
function RichTextInput:setColor(color)
	self.sprite:setColor(color);
end

-- 打开输入法
function RichTextInput:openIME()
	self.sprite:openIME();
end

-- 关闭输入法
function RichTextInput:closeIME()
	self.sprite:closeIME();
end

-- 添加输入法打开回调方法
-- function handler — 回调方法
function RichTextInput:addIMEOpenHandler(handler)
	self.sprite:addIMEOpenScriptHandler(handler);
end

-- 添加输入法关闭回调方法
-- function handler — 回调方法
function RichTextInput:addIMECloseHandler(handler)
	self.sprite:addIMECloseScriptHandler(handler);
end

function RichTextInput:appendInputText(text)
	self.sprite:appendInputText(text);
end

function RichTextInput:deleteBackward()
	self.sprite:deleteBackward();
end

function RichTextInput:setSingleline(bool)
	self.sprite:setSingleline(bool);
end

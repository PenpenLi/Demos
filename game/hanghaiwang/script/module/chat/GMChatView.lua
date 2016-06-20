-- FileName: GMChatView.lua
-- Author: menghao
-- Date: 2014-06-09
-- Purpose: GM聊天view


module("GMChatView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

-- local m_imgSend
local m_imgLook

-- local m_tfdBtnSend
-- local m_tfdBtnLook

local m_laySend
local m_layLook


local m_cbxAsk
local m_cbxBug
local m_cbxComplain
local m_cbxAdvice
local m_imgInput
local m_btnSend

local talkEditBox


-- local m_btnClose	-- 查看问题
local m_lsvInfo
local m_layInfo

local m_tfdName
local m_imgBg
local m_tfdInfo
local m_tfdGMName
local m_imgGMBg
local m_tfdGMInfo


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_curCbx


function getText( ... )
	return talkEditBox:getText()
end


function setText( str )
	talkEditBox:setText(str)
end


function setEditBoxTouchEnabled( bValue )
	talkEditBox:setTouchEnabled(bValue)
end


function showSend( ... )
	m_UIMain.BTN_SEND_Q:setFocused(true)
	m_UIMain.BTN_LOOKUP_Q:setFocused(false)

	m_UIMain.LAY_SENQ_Q:setEnabled(true)
	m_UIMain.LAY_SENQ_Q:setVisible(true)
	m_UIMain.LAY_LOOKUP_Q:setEnabled(false)
	m_UIMain.LAY_LOOKUP_Q:setVisible(false)
	talkEditBox:setTouchEnabled(true)
	m_imgLook:setEnabled(false)
end


function showLook( ... )
	m_UIMain.BTN_SEND_Q:setFocused(false)
	m_UIMain.BTN_LOOKUP_Q:setFocused(true)

	m_UIMain.LAY_SENQ_Q:setEnabled(false)
	m_UIMain.LAY_SENQ_Q:setVisible(false)
	m_UIMain.LAY_LOOKUP_Q:setEnabled(true)
	m_UIMain.LAY_LOOKUP_Q:setVisible(true)
	talkEditBox:setTouchEnabled(false)
	m_imgLook:setEnabled(true)
end


function getclassType( ... )
	local tbCheckBox = { m_cbxBug, m_cbxComplain, m_cbxAdvice, m_cbxAsk }
	for i=1,#tbCheckBox do
		if tbCheckBox[i] == m_curCbx then
			return i
		end
	end
end


function resetListView( ... )
	m_lsvInfo:removeAllItems()
end

-- 添加一项问题
function addChatInfo( color, strName, strQuestion, strAnswer )
	local lsvSize = m_lsvInfo:getSize()
	-- 玩家名字
	local labelName = UIHelper.createUILabel(strName, g_FontInfo.name, 22, color)
	labelName:setAnchorPoint(ccp(0, 0.5))
	labelName:setPosition(ccp(16, 0))

	local imgNameBg = ImageView:create()
	imgNameBg:setAnchorPoint(ccp(0, 0.5))
	imgNameBg:setScale9Enabled(true)
	imgNameBg:setSize(CCSizeMake(lsvSize.width, 36))
	imgNameBg:addChild(labelName)
	m_lsvInfo:pushBackCustomItem(imgNameBg)

	-- 玩家问题 #835014
	local labelQuestion = UIHelper.createUILabel(strQuestion, g_FontInfo.name, 20, ccc3( 0x83, 0x50, 0x14))
	labelQuestion:ignoreContentAdaptWithSize(false)

	-- local maxWidth = 506 * g_fScaleX

	local maxWidth = 0.63 * g_winSize.width
	local maxWidthBg = maxWidth + 32

	if labelQuestion:getContentSize().width > maxWidth then
		local lable_height = math.ceil(labelQuestion:getContentSize().width / maxWidth) * labelQuestion:getContentSize().height + 18
		labelQuestion:setSize(CCSizeMake(maxWidth, lable_height))
		bg_height = labelQuestion:getContentSize().height + 60 -- 加上上下边距之和40
	else
		bg_height = 40
		labelQuestion:setSize(CCSizeMake(maxWidth, labelQuestion:getContentSize().height))
	end


	local imgHeight = bg_height > 95 and bg_height or 95
	local imgWidth = maxWidthBg > 205 and maxWidthBg or 205
	local imgQuestionBg = ImageView:create()
	imgQuestionBg:loadTexture("ui/chat_question.png")
	imgQuestionBg:setAnchorPoint(ccp(0, 0))
	imgQuestionBg:setScale9Enabled(true)
	imgQuestionBg:setCapInsets(CCRectMake(72,40,1,1))
	imgQuestionBg:setSize(CCSizeMake(imgWidth, imgHeight))
	imgQuestionBg:addChild(labelQuestion)
	imgQuestionBg:setPosition(ccp(16,0))
	-- m_lsvInfo:pushBackCustomItem(imgQuestionBg)
	labelQuestion:setAnchorPoint(ccp(0, 1))
	labelQuestion:setPosition(ccp(16, imgHeight-30))

	local lay = Layout:create()
	lay:setSize(CCSizeMake(lsvSize.width,imgHeight))
	lay:addChild(imgQuestionBg)
	m_lsvInfo:pushBackCustomItem(lay)

	-- GM名字
	local labelGMName = UIHelper.createUILabel(m_i18n[2820], g_FontInfo.name, 22, ccc3( 0x00, 0xb2, 0xb9))
	labelGMName:setAnchorPoint(ccp(0, 0.5))
	labelGMName:setPosition(ccp(16, 0))
	labelGMName:setColor(ccc3(0,0x62,0x0c))

	local imgGMNameBg = ImageView:create()
	imgGMNameBg:setAnchorPoint(ccp(0, 0.5))
	imgGMNameBg:setScale9Enabled(true)
	imgGMNameBg:setSize(CCSizeMake(lsvSize.width, 36))
	imgGMNameBg:addChild(labelGMName)
	m_lsvInfo:pushBackCustomItem(imgGMNameBg)

	-- GM回答
	local labelAnswer = UIHelper.createUILabel(strAnswer, g_FontInfo.name, 20, ccc3( 0x83, 0x50, 0x14))
	labelAnswer:ignoreContentAdaptWithSize(false)
	if labelAnswer:getContentSize().width > maxWidth then
		local lable_height = math.ceil(labelAnswer:getContentSize().width / maxWidth) * labelAnswer:getContentSize().height + 18
		labelAnswer:setSize(CCSizeMake(maxWidth, lable_height))
		bg_height = labelAnswer:getContentSize().height + 60 -- 加上上下边距之和40
	else
		bg_height = 40
		labelAnswer:setSize(CCSizeMake(maxWidth, labelAnswer:getContentSize().height))
	end

	local imgHeight = bg_height > 95 and bg_height or 95
	local imgWidth = maxWidthBg > 205 and maxWidthBg or 205
	local imgAnswer = ImageView:create()
	imgAnswer:loadTexture("ui/chat_question.png")
	imgAnswer:setAnchorPoint(ccp(0, 0))
	imgAnswer:setScale9Enabled(true)
	imgAnswer:setSize(CCSizeMake(imgWidth, imgHeight))
	imgAnswer:addChild(labelAnswer)
	imgAnswer:setCapInsets(CCRectMake(72,40,1,1))
	imgAnswer:setPosition(ccp(16, 0))
	-- m_lsvInfo:pushBackCustomItem(imgAnswer)
	labelAnswer:setAnchorPoint(ccp(0, 1))
	labelAnswer:setPosition(ccp(16,imgHeight-30 ))

	local lay = Layout:create()
	lay:setSize(CCSizeMake(lsvSize.width,imgHeight))
	lay:addChild(imgAnswer)
	m_lsvInfo:pushBackCustomItem(lay)

end


local function init(...)

end


function destroy(...)
	package.loaded["GMChatView"] = nil
end


function moduleName()
	return "GMChatView"
end

function create( tbEventListener )
	m_UIMain = g_fnLoadUI("ui/chat_gm.json")
	m_imgLook = m_fnGetWidget(m_UIMain, "IMG_LOOKUP_Q")
	m_laySend = m_fnGetWidget(m_UIMain, "LAY_SEND_Q")
	m_layLook = m_fnGetWidget(m_UIMain, "LAY_LOOKUP_Q")
	m_cbxAsk = m_fnGetWidget(m_UIMain, "CBX_ASK")
	m_cbxBug = m_fnGetWidget(m_UIMain, "CBX_BUG")
	m_cbxComplain = m_fnGetWidget(m_UIMain, "CBX_COMPLAIN")
	m_cbxAdvice = m_fnGetWidget(m_UIMain, "CBX_ADVICE")
	m_imgInput = m_fnGetWidget(m_UIMain, "IMG_INPUT_Q")
	m_btnSend = m_fnGetWidget(m_UIMain, "BTN_SEND")

	m_UIMain.BTN_SEND_Q:setTitleText(m_i18n[2812])
	m_UIMain.BTN_SEND_Q:setTouchEnabled(true)
	m_UIMain.BTN_SEND_Q:addTouchEventListener(tbEventListener.onSubmit)

	m_UIMain.BTN_LOOKUP_Q:setTitleText(m_i18n[2819])
	m_UIMain.BTN_LOOKUP_Q:setTouchEnabled(true)
	m_UIMain.BTN_LOOKUP_Q:addTouchEventListener(tbEventListener.onLook)
	local tfd = m_UIMain.BTN_LOOKUP_Q:getTitleTTF()
	tfd:setScaleX(-1)  --水平翻转

	local function onCheckBox( sender, eventType )
		if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
			if (m_curCbx ~= sender) then
				m_curCbx:setSelectedState(false)
				m_curCbx = sender
			end
		end
		if (eventType == CHECKBOX_STATE_EVENT_UNSELECTED) then
			if (m_curCbx == sender) then
				sender:setSelectedState(true)
			end
		end
	end

	m_cbxAsk:setSelectedState(true)
	m_curCbx = m_cbxAsk
	m_cbxAsk:addEventListenerCheckBox(onCheckBox)
	m_cbxBug:addEventListenerCheckBox(onCheckBox)
	m_cbxComplain:addEventListenerCheckBox(onCheckBox)
	m_cbxAdvice:addEventListenerCheckBox(onCheckBox)

	local size = m_imgInput:getSize()
	talkEditBox = UIHelper.createEditBox(CCSizeMake(size.width-20,size.height-20), "images/base/potential/input_name_bg1.png", true)
	talkEditBox:setPlaceHolder(m_i18n[2806])
	talkEditBox:setPlaceholderFontColor(ccc3( 0xcc, 0xa3, 0x57))

	talkEditBox:setMaxLength(200)
	talkEditBox:setReturnType(kKeyboardReturnTypeDone)
	talkEditBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	talkEditBox:setFontColor(ccc3( 0x6d, 0x4c, 0x2d ))

	m_imgInput:addNode(talkEditBox)

	m_btnSend:addTouchEventListener(tbEventListener.onSend)
	UIHelper.titleShadow(m_btnSend, m_i18n[2159])

	------------------------- look --------------------------

	m_lsvInfo = m_fnGetWidget(m_UIMain, "LSV_INFO")
	m_layInfo = m_fnGetWidget(m_UIMain, "LAY_INFO")
	m_tfdName = m_fnGetWidget(m_UIMain, "TFD_PLAYER_NAME")
	m_imgBg = m_fnGetWidget(m_UIMain, "IMG_PLAYER_BG")
	m_tfdInfo = m_fnGetWidget(m_UIMain, "TFD_PLAYER_INFO")
	m_tfdGMName = m_fnGetWidget(m_UIMain, "TFD_GM_NAME")
	m_imgGMBg = m_fnGetWidget(m_UIMain, "IMG_GM_BG")
	m_tfdGMInfo = m_fnGetWidget(m_UIMain, "TFD_GM_INFO")


	UIHelper.initListView(m_lsvInfo)

	showSend()

	return m_UIMain
end


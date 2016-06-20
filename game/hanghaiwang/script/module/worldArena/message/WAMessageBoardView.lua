-- FileName: WAMessageBoardView.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

WAMessageBoardView = class("WAMessageBoardView")

-- UI控件引用变量 --

-- 模块局部变量 --
local _fnGetWidget = g_fnGetWidgetByName
local _i18nString = gi18nString

function WAMessageBoardView:refreshView()
	self.msgInput:setText("")
	self.msgInput:setPlaceHolder(_i18nString(3660))		-- "留言内容：最多可以输入60字"
	self:initListView()
end

function WAMessageBoardView:initListView( ... )
	local msgList = WAMessageBoardModel.getMsgInfo()
	local myMsgNum = WAMessageBoardModel.getMyMsgNum()
	local function updateCellByIdex( lsv, idx )
		local tbData = msgList[idx+1]
		local cell = lsv:getItem(idx).item
		logger:debug({tbData_print_lsgLsv = tbData})

		local myMark = "2"
		local thierMark = "1"
		local myHeadIcon = _fnGetWidget(cell, "LAY_PHOTO"..myMark)
		local thierHeadIcon = _fnGetWidget(cell, "LAY_PHOTO"..thierMark)

		local myMsgTime = _fnGetWidget(cell, "TFD_TIME"..myMark)
		local thierMsgTime = _fnGetWidget(cell, "TFD_TIME"..thierMark)

		local myMsgCont = _fnGetWidget(cell, "img_content_bg"..myMark)
		local thierMsgCont = _fnGetWidget(cell, "img_content_bg"..thierMark)

		local myServerId = UserModel.getServerId()
		local myPid = UserModel.getPid()

		local isMyMsg = (tbData.server_id..tbData.pid == myServerId..myPid)
		myHeadIcon:setVisible(isMyMsg)
		myMsgTime:setVisible(isMyMsg)
		myMsgCont:setVisible(isMyMsg)
		thierHeadIcon:setVisible(not isMyMsg)
		thierMsgTime:setVisible(not isMyMsg)
		thierMsgCont:setVisible(not isMyMsg)

		local headColor = UserModel.getPotentialColor({htid = tbData.figure})
		local icon = HeroUtil.createHeroIconBtnByHtid(tonumber(tbData.figure))

		local tbMsgTime = TimeUtil.getServerDateTime( tonumber(tbData.msg_time) )
		local dateStr = tbMsgTime.year.."-"..tbMsgTime.month.."-"..tbMsgTime.day
		local timeStr = tbMsgTime.hour..":"..tbMsgTime.min..":"..tbMsgTime.sec

		local richStr = tbData.uname .. "  " ..  "|" ..  tbData.msg 
		local tbRichTextColor = {
			{color = headColor},
			{color = ccc3(0x82,0x57,0x00)},
		}

		if (isMyMsg) then
			myHeadIcon:removeChildByTag(988,true)
			icon:setPosition(ccp(myHeadIcon:getContentSize().width*0.5, myHeadIcon:getContentSize().height*0.5))
			myHeadIcon:addChild(icon,0,988)
			myHeadIcon.TFD_SERVER_NUM:setText("S."..tbData.server_id)
			myHeadIcon.TFD_SERVER_NUM:setColor(headColor)

			myMsgTime:setText(dateStr.." "..timeStr)

			local layMsgs = myMsgCont.LAY_NEWS

			layMsgs:setLayoutType(LAYOUT_RELATIVE)
			local textInfo = {richStr,tbRichTextColor}
			local richText = BTRichText.create(textInfo, nil, nil)
			richText:setSize(layMsgs:getSize())
			layMsgs:removeChildByTag(1231,true)
			richText:setAnchorPoint(ccp(0,1))
			richText:visit()
			local textHeight = richText:getTextHeight()
			local img_content_bg = myMsgCont
			if (textHeight > layMsgs:getSize().height) then
				img_content_bg:setSize(CCSizeMake(img_content_bg:getSize().width ,textHeight + 20))
			end
			richText:setSize(layMsgs:getSize())
			layMsgs:addChild(richText,0,1231)
		else
			thierHeadIcon:removeChildByTag(988,true)
			icon:setPosition(ccp(thierHeadIcon:getContentSize().width*0.5, thierHeadIcon:getContentSize().height*0.5))
			thierHeadIcon:addChild(icon,0,988)
			thierHeadIcon.TFD_SERVER_NUM:setText("S."..tbData.server_id)
			myHeadIcon.TFD_SERVER_NUM:setColor(headColor)

			thierMsgTime:setText(dateStr.." "..timeStr)

			local layMsgs = thierMsgCont.LAY_NEWS

			layMsgs:setLayoutType(LAYOUT_RELATIVE)
			local textInfo = {richStr,tbRichTextColor}
			local richText = BTRichText.create(textInfo, nil, nil)
			richText:setSize(layMsgs:getSize())
			layMsgs:removeChildByTag(1231,true)
			richText:setAnchorPoint(ccp(0,1))
			richText:visit()
			local textHeight = richText:getTextHeight()
			local img_content_bg = thierMsgCont
			if (textHeight > layMsgs:getSize().height) then
				img_content_bg:setSize(CCSizeMake(img_content_bg:getSize().width ,textHeight + 20))
			end
			richText:setSize(layMsgs:getSize())
			layMsgs:addChild(richText,0,1231)
		end
	end
	UIHelper.reloadListView(self.listView,#msgList,updateCellByIdex,#msgList-1)

	self.layMain.tfd_today_num:setText(WAMessageBoardModel.getStillCanMsgNum())
end

function WAMessageBoardView:addBtnEvent( ... )
	self.layMain.BTN_CLOSE:addTouchEventListener(WAMessageBoardCtrl.getBtnFunByName("onReturn"))
	self.layMain.BTN_LEAVE_MESSAGE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local nState = WAUtil.getCurState()
			if (nState and nState ~= WAUtil.WA_STATE.attack and nState ~= WAUtil.WA_STATE.reward) then
				ShowNotice.showShellInfo(_i18nString(6605))		-- 本活动已结束，谢谢参与！
				return
			end

			local leavingText = self.msgInput:getText()

			local leaveTimes = WAMessageBoardModel.getStillCanMsgNum()
			local _,messageLength = getStringLength(leavingText)
			if (messageLength <= 0) then			
				ShowNotice.showShellInfo(_i18nString(3661))		-- 先输入内容后再发布啊
			elseif (messageLength > 60) then
				ShowNotice.showShellInfo(_i18nString(3670)) 	-- 留言数字要小于60字啊
			elseif (leaveTimes <= 0) then
				ShowNotice.showShellInfo(_i18nString(3669))		-- 今日留言次数已用完了
			else
				WAMessageBoardModel.setLeavingMsg(leavingText)
				local funLeavintMsg = WAMessageBoardCtrl.getBtnFunByName("onLeaveMsg")
				funLeavintMsg()
			end
		end
	end)
end

function WAMessageBoardView:createMessageEditBox( ... )
	self.editBoxBg = self.layMain.IMG_TYPE
	local size = self.editBoxBg:getSize()
	self.msgInput = UIHelper.createEditBox(CCSizeMake(size.width, size.height),"images/base/potential/input_name_bg1.png",false)
	self.msgInput:setFontColor(ccc3(0x82, 0x57, 0x00))
	self.msgInput:setPlaceHolder(_i18nString(3660)) 				-- "留言内容：最多可以输入60字",
	self.msgInput:setMaxLength(60)
	self.msgInput:setFontName(g_sFontCuYuan)
	self.msgInput:setPlaceholderFontColor(ccc3(0x82, 0x57, 0x00))
	self.msgInput:setReturnType(kKeyboardReturnTypeDone)
	self.msgInput:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	self.editBoxBg:addNode(self.msgInput)
end

function WAMessageBoardView:init(...)
	self.layMain = nil
end

function WAMessageBoardView:destroy(...)
	package.loaded["WAMessageBoardView"] = nil
end

function WAMessageBoardView:moduleName()
    return "WAMessageBoardView"
end

function WAMessageBoardView:ctor( ... )
	self:init()
	self.layMain = g_fnLoadUI("ui/peak_message.json")
end

function WAMessageBoardView:create()
	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			self.layMain = nil
		end,
		function()
		end
	)
	self.listView = self.layMain.LSV_MESSAGE
	self.listView:setClippingEnabled(true)
	UIHelper.initListViewCell(self.listView)

	UIHelper.titleShadow( self.layMain.BTN_CLOSE )
	UIHelper.titleShadow( self.layMain.BTN_LEAVE_MESSAGE )

	self:createMessageEditBox()
	self:addBtnEvent()
	self:initListView()

	return self.layMain	
end

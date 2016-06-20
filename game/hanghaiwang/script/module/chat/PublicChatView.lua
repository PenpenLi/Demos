-- FileName: PublicChatView.lua
-- Author: menghao
-- Date: 2015-5-6
-- Purpose: 世界、私人、联盟 公用的聊天界面


module("PublicChatView", package.seeall)


require "script/module/chat/ChatInfoCell"


-- UI控件引用变量 --
local _UIMain


-- 模块局部变量 --
local _editBoxText
local _editBoxName

local _strUname
local _nCurChatType   --当前聊天类型 1  world.;  2 private ; 3 union ; 4 GM
local _i18n = gi18n


local _selfCell   --自己发言的view
local _otherCell  --别人发言的view

local m_initState = false

function destroy(...)
	package.loaded["PublicChatView"] = nil
end


function moduleName()
	return "PublicChatView"
end


local function createEditBoxText( ... )
	_editBoxText = UIHelper.createEditBox(_UIMain.IMG_INPUT:getSize(), nil, false)
	_editBoxText:setAnchorPoint(ccp(0, 0.5))
	_editBoxText:setPlaceHolder(gi18n[2806])
	_editBoxText:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
	_editBoxText:setMaxLength(40)
	_editBoxText:setReturnType(kKeyboardReturnTypeDone)
	_editBoxText:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	_editBoxText:setFontColor(ccc3(0x47,0x47,0x48))

	_editBoxText:setEnabled(false)
	_editBoxText:setTouchEnabled(false)

	_UIMain.IMG_INPUT:addNode(_editBoxText)
end


local function createEditBoxName()
	_editBoxName = UIHelper.createEditBox(_UIMain.IMG_INPUT_NAME:getSize(), nil, false)
	_editBoxName:setAnchorPoint(ccp(0, 0.5))
	_editBoxName:setPlaceHolder("")
	_editBoxName:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
	_editBoxName:setMaxLength(13)
	_editBoxName:setReturnType(kKeyboardReturnTypeDone)
	_editBoxName:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	_editBoxName:setFontColor(ccc3(0x47,0x47,0x48))

	local function editboxEventHandler(eventType, sender)
		if eventType == "began" then
			local x,y = sender:getPosition()
			sender:setPosition(ccp(x,y))
		end
		if eventType == "return" then
			local str = sender:getText()
			_strUname = str

			UIHelper.clearTouchStat()
		end
	end
	_editBoxName:registerScriptEditBoxHandler(editboxEventHandler)

	_editBoxName:setText(_strUname)

	_UIMain.IMG_INPUT_NAME:addNode(_editBoxName)
end


function getName( ... )
	if (not _editBoxName) then
		return nil
	end
	return _editBoxName:getText()
end


function setText( str )
	_editBoxText:setText(str)
end


function setEditBoxTouchEnabled( bValue )
	if (_editBoxName) then
		_editBoxName:setTouchEnabled(bValue)
	end
	if (_editBoxText) then
		_editBoxText:setTouchEnabled(bValue)
	end
end


-- 更新未读信息相关
function upUnread( nUnread )
	local img_lock = nil
	if (_nCurChatType == 2) then 
		local lay = _UIMain.LAY_PRIVATE
		img_lock = lay.IMG_LOCK
	else 
		local lay = _UIMain.LAY_PUBLIC
		img_lock = lay.IMG_LOCK
	end 

	if (nUnread > 0) then
		img_lock:setEnabled(true)
		img_lock:setVisible(true)
		img_lock.TFD_READ:setText(_i18n[2842] .. nUnread) -- "未读消息："
	else
		img_lock:setEnabled(false)
		img_lock:setVisible(false)
	end
end


local function lsvJumpToBottom( ... )
	performWithDelay(_UIMain.LSV_CONTENT, function ( ... )
		_UIMain.LSV_CONTENT:jumpToBottom()
	end, 1 / 60)
end

-- 添加聊天内容 当前lisview滑动到最下层，添加新的cell，重置坐标
function addNewChatCell( chatInfo )

	local tbChatInfos = ChatModel.getChatCache()
	local contentH = _UIMain.LSV_CONTENT:getSize().height
	local innerHeight =  _UIMain.LSV_CONTENT:getInnerContainerSize().height
	local offset = _UIMain.LSV_CONTENT:getContentOffset()

	if (innerHeight <= contentH) then 
		 UIHelper.reloadListView(_UIMain.LSV_CONTENT,#tbChatInfos,updateCellByIndex)
		 ChatModel.setUnreadNum(0)
	elseif (innerHeight - offset < 50) then  --重新设定坐标
		 UIHelper.reloadListView(_UIMain.LSV_CONTENT,#tbChatInfos,updateCellByIndex,ccp(0,0)) 
		 ChatModel.setUnreadNum(0)
	elseif (innerHeight - offset >=50) then   --不重新设坐标
		UIHelper.reloadListView(_UIMain.LSV_CONTENT,#tbChatInfos,updateCellByIndex)
		ChatModel.addUnreadNum()
	end 
end


-------------------------------优化listView-------------------------------

-- listView执行reload，用于语音翻译结果出来后，更新单个cell有问题。改为更新整个listview
function updateListView( ... )
	local tbChatInfos = ChatModel.getChatCache()
	UIHelper.reloadListView(_UIMain.LSV_CONTENT,#tbChatInfos,updateCellByIndex)
end



-- 用于语音延时翻译改变cell的大小，调用list的 updateSizeAndPosition
function updateListSizeAndPos( ... )
	local pos = _UIMain.LSV_CONTENT:getJumpOffset()
	_UIMain.LSV_CONTENT:updateSizeAndPosition()
	_UIMain.LSV_CONTENT:setJumpOffset(pos)
end


function updateCellByIndex(lsv,idx)
	local tbChatInfos = ChatModel.getChatCache()
	local chatInfo = tbChatInfos[idx+1]
	chatInfo.id = idx+1
	local cell = lsv:getItem(idx)
	local realCell = cell.item

	if (tonumber(chatInfo.sender_uid)==UserModel.getUserUid()  ) then 
		cell:removeAllChildrenWithCleanup(true)
		local newCell = _selfCell:clone()
		cell:addChild(newCell)		
		local size = newCell:getSize()
		cell:setSize(size)
		newCell:setPosition(ccp(0,0))
		realCell = newCell
	end 

	ChatInfoCell.refreashCell(realCell,chatInfo,cell)
	local size = realCell:getSize()
	cell:setSize(size)

	local pos = lsv:getJumpOffset()
	lsv:updateSizeAndPosition()
	lsv:setJumpOffset(pos)

end 


-- 根据当前聊天数据缓存更新聊天的lsv
function upChatLsv( ... )
	local tbChatInfos = ChatModel.getChatCache()
	UIHelper.reloadListView(_UIMain.LSV_CONTENT,#tbChatInfos,updateCellByIndex,ccp(0,0),true)

	_UIMain.LSV_CONTENT:addEventListenerScrollView(
		function (sender, ScrollviewEventType)
			if (ScrollviewEventType == SCROLLVIEW_EVENT_BOUNCE_BOTTOM) then
				ChatModel.setUnreadNum(0)
			end
			if (ScrollviewEventType == SCROLLVIEW_EVENT_SCROLL_TO_BOTTOM) then 
				ChatModel.setUnreadNum(0)
			end 
		end
	)

	_UIMain.LSV_CONTENT:setBounceEnabled(true)
end


local function setLayPrivate( nChatType )
	if (nChatType ~= 2) then
		_UIMain.LAY_PRIVATE:setEnabled(false)
		_editBoxName = nil
	else
		_UIMain.tfd_dui:setText(_i18n[2808]) --  "对"
		_UIMain.tfd_talk:setText(_i18n[2809]) --  "说"

		createEditBoxName()

		-- 如果跳到私聊,更新小红点
		g_redPoint.chat.num = 0
		g_redPoint.chat.visible = false
		ChatView.upRedPoint()
		MainShip.upChatRedPoint()
	end
end


local function setLayKeyborad( nChatType )
	_UIMain.LAY_KEYBORAD:setEnabled(false)
	-- _UIMain.TFD_LIMIT:setText("最多输入40字")

	UIHelper.titleShadow(_UIMain.BTN_SEND, gi18n[2159])
	_UIMain.BTN_SEND:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local strText = _editBoxText:getText()
			logger:debug({strText = strText})

			--------------长度限定40个utf8-－－－－－－－－－－
			local utf8Len = ChatUtil.getUTF8StrLen(strText)
		 	if (utf8Len>40) then 
		 		strText = ChatUtil.cutStringByUTF8(strText,40)
		 	end  
		 	---------------------------------------------
			if (nChatType == 1) then
				ChatUtil.sendWorld(strText)
			elseif (nChatType == 2) then
				ChatUtil.sendPrivate(strText)
			elseif (nChatType == 3) then
				ChatUtil.sendUnion(strText)
			end
		end
	end)

	_UIMain.BTN_AUDIO:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			_UIMain.LAY_KEYBORAD:setEnabled(false)
			_editBoxText:setEnabled(false)
			_editBoxText:setTouchEnabled(false)
			_UIMain.LAY_AUDIO:setEnabled(true)
		end
	end)
end


function setLayAudio( ... )
	_UIMain.LAY_AUDIO:setEnabled(true)

	_UIMain.BTN_KEYBOARD:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			_UIMain.LAY_KEYBORAD:setEnabled(true)
			-- _UIMain.TFD_LIMIT:setEnabled(false)
			_editBoxText:setEnabled(true)
			_editBoxText:setTouchEnabled(true)
			_UIMain.LAY_AUDIO:setEnabled(false)
		end
	end)

	-- UIHelper.titleShadow(_UIMain.BTN_TALK, "按住说话")

	_UIMain.LAY_JUDGE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_BEGAN) then
			local dbInfo = DB_Chat_interface.getDataById(1)
			local tbData = lua_string_split(dbInfo.chat_cd,'|')
			local chatvip = tbData[1]

			if (not RecordUtil.getInitResult()) then 
				RecordUtil.initRecord()
				m_initState = false
				return true
			elseif (ChatModel.getCurTab()==1 and dbInfo.lv_require and tonumber(UserModel.getUserInfo().level) < dbInfo.lv_require) then
				ShowNotice.showShellInfo(gi18n[2830] .. dbInfo.lv_require)
				m_initState = false
				return true
			elseif (ChatModel.getCurTab()==1 and tonumber(UserModel.getUserInfo().vip) < tonumber(chatvip) and ChatUtil.getCDTime() > 0) then
				ShowNotice.showShellInfo(gi18n[2851])
				m_initState = false
				return true
			else 
				m_initState = true
			end 

			if (not RecordUtil.checkRecordPermission()) then
				logger:debug("checkRecordPermission  false")
				return false
			end
			ChatCtrl.beganRecorder()
			_UIMain.BTN_TALK:setTitleText(_i18n[2843])    --"松开发送"
			return true
		elseif (eventType == TOUCH_EVENT_MOVED) then
			if (m_initState) then 
				ChatCtrl.movedRecorder(sender:isFocused())
			end 
		elseif (eventType == TOUCH_EVENT_ENDED) then
			if (m_initState) then 
				ChatCtrl.endRecorder()
			end 
			_UIMain.BTN_TALK:setTitleText(_i18n[2844])  --"按住说话"
		elseif (eventType == TOUCH_EVENT_CANCELED) then
			if (m_initState) then 
				ChatCtrl.cancelRecorder()
			end 
			_UIMain.BTN_TALK:setTitleText(_i18n[2844])  --"按住说话"
		end
	end)

	createEditBoxText()
end




--私聊： 一直按住录音按键（当前麦克风窗口存在情况下），上次的语音发送弹出一层提示面板，遮挡_UIMain。
-- 造成 _UIMain.LAY_JUDGE 接收不了触摸结束方法,无法结束当前录音和去掉麦克风窗口。
-- 这种情况手动添加取消方法
function  autoCancelRecorder( ... )
	ChatCtrl.cancelRecorder()
	_UIMain.BTN_TALK:setTitleText(_i18n[2844])  --"按住说话"
end


function releaseCell( ... )
	if (_selfCell) then 
		_selfCell:release()
		_selfCell = nil
	end 
	if (_otherCell) then 
		_otherCell:release()
		_otherCell = nil
	end 
end

function create( nChatType, strUserName )
	_strUname = strUserName or _strUname
	_nCurChatType = nChatType
	_UIMain = g_fnLoadUI("ui/chat_main.json")
	ChatModel.setUnreadNum(0)

	local img_dialog_vip0 = _UIMain.LSV_CONTENT.LAY_CONTENT1.IMG_DIALOG_VIP0
	ChatInfoCell.setOriginalImgSize(img_dialog_vip0:getSize())

	_selfCell = _UIMain.LSV_CONTENT.LAY_CONTENT1:clone()
	_selfCell:retain()

	_otherCell = _UIMain.LSV_CONTENT.LAY_CONTENT2:clone()
	_otherCell:retain()

	_UIMain.LSV_CONTENT:removeAllItems()
	UIHelper.initListViewCell( _UIMain.LSV_CONTENT,_otherCell,nil,nil)
	upChatLsv() 				-- 将cell添加到ListView

	setLayPrivate(nChatType) 	-- 私聊相关
	setLayKeyborad(nChatType) 	-- 键盘输入相关
	setLayAudio() 				-- 语音输入相关

	_UIMain.LAY_PUBLIC:setVisible(nChatType~=2 and true or false)

	UIHelper.registExitAndEnterCall(_UIMain, function ( ... )
		PublicChatView.releaseCell()
	end)
	return _UIMain
end


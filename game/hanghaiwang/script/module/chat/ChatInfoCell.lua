-- FileName: ChatInfoCell.lua
-- Author: menghao
-- Date: 2014-06-08
-- Purpose: 聊天cell


module("ChatInfoCell", package.seeall)


require "script/module/chat/ChatCommunicationCtrl"
require "script/module/mail/MailService"


-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local nChatTag = 1990
local nLabelTag = 16623
local nHeadTag = 16624
local nRichLabelTag=16625


local tbOriCellSize  --cell 原始大小
local tbOriImgSize  --  IMG_DIALOG_VIP0 的原始大小

-- 设置IMG_DIALOG_VIP0控件的原始大小，用于每次cell复用调整大小。
function setOriginalImgSize( size )
	tbOriImgSize = {}
	tbOriImgSize.width = size.width
	tbOriImgSize.height = size.height

	tbOriCellSize = {}
	tbOriCellSize.width = 640
	tbOriCellSize.height = 148
end


-- 播放录音
function playRecorder( tag, btn, aid )
	logger:debug("＝＝＝＝＝语音 准备播放")
	AudioHelper.stopMusic()
	RecordUtil.playRecordBy(aid, overPlayRecorder)
end


-- 播放结束
function overPlayRecorder(aTag, aStopType)
	logger:debug(aTag)
	logger:debug(aStopType)
	logger:debug("＝＝＝＝＝语音 播放结束")
	-- 获取录音成功
	if (tonumber(aTag) == 1) then
		-- -1 播放出错  0 播放完成 1 主动停止 2 播放下一个
		if (aStopType == -1) then
			AudioHelper.resumeMusic()
		elseif (aStopType == 0) then
			AudioHelper.resumeMusic()
		elseif (aStopType == 1) then
			AudioHelper.resumeMusic()
		elseif (aStopType == 2) then

		end
	else
		AudioHelper.resumeMusic()
	end
end




--[[desc:调整cell子控件坐标
    return: 是否有返回值，返回值说明  
—]]
local function resetCell( cell,label ,uid,isAudio)
	local namey = cell.LAY_FIT_AUDIO:getSize().height-25
	local namex = 25
	local labelx = namex + cell.TFD_SELF_NAME:getContentSize().width + 10
	local labely = namey
	cell.TFD_SELF_NAME:setAnchorPoint(ccp(0,1))
	if (label) then 
		label:setAnchorPoint(ccp(0,1))
	end 
	
	if tonumber(uid) == UserModel.getUserUid() then
		namex = cell.LAY_FIT_AUDIO:getSize().width-25
		labelx = namex - cell.TFD_SELF_NAME:getContentSize().width - 10
		cell.TFD_SELF_NAME:setAnchorPoint(ccp(1,1))
		if (label) then 
			label:setAnchorPoint(ccp(1,1))
		end 
	end  
	
	cell.TFD_SELF_NAME:setPosition(ccp(namex,namey))
	-- cell.TFD_SELF_NAME:setPositionType(POSITION_ABSOLUTE)
	if (label) then 
		label:setPosition(ccp(labelx,labely))
	end 
	
	if (isAudio) then
		cell.IMG_TALK1:setPosition(ccp(labelx,labely-cell.TFD_SELF_NAME:getContentSize().height/2))
		cell.TFD_AUDIO_CONTENT:setPosition(ccp(namex,namey-40))
		cell.TFD_TIME1:setPositionY(labely-cell.TFD_SELF_NAME:getContentSize().height/2)
	end 

end 



-- 语音聊天获取文本
function getRecordRext( i,audioID)
	RecordUtil.getSvrRecordTextById(audioID, function ( p_status, text_arr, audio_data )
		if (ChatModel.getCurTab()~=0) then  --防止请求回来已经离开了聊天页面
			if( p_status~=0 )then
				return
			end
			if(table.isEmpty(text_arr) and i >= 5)then
				ChatModel.addAudioTextBy(audioID, "")
				return
			end
			if( text_arr.asr == nil or text_arr.asr == "" )then
				if (i >= 5) then
					ChatModel.addAudioTextBy(audioID, "")
				end
				return
			else
				ChatModel.addAudioTextBy(audioID, text_arr.asr)
			end

			PublicChatView.updateListView()
		end 
	end)
end



--[[desc:语音翻译绘制
    isRefreash：是否需要刷新list
    return: 是否有返回值，返回值说明  
—]]
function setRecordText(cell,text,bgInfo,uid)	
	local label = m_fnGetWidget(cell, "TFD_AUDIO_CONTENT")
	local btn = m_fnGetWidget(cell, "IMG_DIALOG_VIP0")
	text = text or  " "
	label:ignoreContentAdaptWithSize(true) 
	label:setText(text)
	local bgImgSize = tbOriImgSize
	bgInfo.lable_width_max = bgImgSize.width-50 
	local tSize = label:getContentSize()

	if(tSize.width  > bgInfo.bgimg_width_max-50 ) then 
	   --长度超过对话框最大，换行
		local labelW = btn:getSize().width-40
		local labelHeight = math.ceil(tSize.width/labelW) * 25
		btn:setSize(CCSizeMake(bgInfo.bgimg_width_max, bgImgSize.height+labelHeight))

  		label:ignoreContentAdaptWithSize(false)   --允许自动换行
	elseif (tSize.width > bgInfo.lable_width_max) then
	 -- 对话框长度增大，一行文字
		btn:setSize( CCSizeMake(bgInfo.bgimg_width_max, bgImgSize.height+25))
	else
		btn:setSize( CCSizeMake(bgImgSize.width, bgImgSize.height+25))
	end 

	local h = btn:getSize().height+50 > tbOriImgSize.height and btn:getSize().height+50 or tbOriImgSize.height
	cell:setSize(CCSizeMake(cell:getSize().width,h))
	resetCell(cell,nil,uid,true)
end


local function init(...)

end


function destroy(...)
	package.loaded["ChatInfoCell"] = nil
end


function moduleName()
	return "ChatInfoCell"
end


local function createNext( fightRet,tbRecordData )
	-- 解析战斗串获得战斗评价
	local amf3_obj = Base64.decodeWithZip(fightRet)
	local lua_obj = amf3.decode(amf3_obj)

	local tbData = {}

	tbData.uid2 = lua_obj.team2.uid
	tbData.playerName2 = lua_obj.team2.name
	tbData.fightForce2 = lua_obj.team2.fightForce
	tbData.isPlayer2 = lua_obj.team2.isPlayer   --区分玩家和npc的标志（true ｜ false）兼容分享战报
	if (tbData.isPlayer2 == false) then 
		tbData.fightForce2 = nil   --npc屏蔽战斗力显示
		local db_army = DB_Army.getDataById(tbData.playerName2)
		local db_stronghold = DB_Stronghold.getDataById(db_army.fort_id)
		tbData.playerName2 = db_stronghold.name
	end 	


	tbData.uid = lua_obj.team1.uid
	tbData.playerName = lua_obj.team1.name
	tbData.fightForce = lua_obj.team1.fightForce
	tbData.brid = lua_obj.brid
	tbData.isPlayer1 = lua_obj.team1.isPlayer   --区分玩家和npc的标志（true ｜ false） 兼容分享战报
	if (tbData.isPlayer1 == false) then 
		tbData.fightForce = nil
		local db_army = DB_Army.getDataById(tbData.playerName)
		local db_stronghold = DB_Stronghold.getDataById(db_army.fort_id)
		tbData.playerName = db_stronghold.name
	end 	

	require "script/battle/BattleModule"
	local fnCallBack = function ( ... )
	end
	--modified zhangjunwu 区分是邮件战报还是聊天战报
	require "script/module/mail/ReplayWinCtrl"
	tbData.type = MailData.ReplayType.KTypeChatBattle


	if (#tbRecordData==1) then   --旧版本邮件战报发送来的
		BattleModule.PlayNormalRecord(fightRet,fnCallBack,tbData,true)
	elseif (tonumber(tbRecordData[2])==1) then   --新版本分享战报
		BattleModule.playSingleReplay(fightRet,fnCallBack,tbData,tonumber(tbRecordData[3]))
	else
		BattleModule.playCopyStyleReplay(fightRet,fnCallBack,tbData,tonumber(tbRecordData[3]) ,tonumber(tbRecordData[4]),tonumber(tbRecordData[5]),tonumber(tbRecordData[6]))
	end 

end


local bgInfo = {
	text_color = ccc3(0x20, 0x20, 0x20),        -- 文字颜色
	bg_width_min = 90,                          -- 背景最小宽度
	single_line_height = 67,                    -- 只有一行时的高度
	lable_width_max = 390 ,                  -- 文字最大宽度
	bgimg_width_max = 0.63 * g_winSize.width  --对话框对打宽度 0.63*屏宽
}


-- 头像点击,玩家自己弹出信息面板，其它玩家弹出私聊小窗
local function callbackSelfHead( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()

		local tbData = sender.tbData
		if (tonumber(tbData.sender_uid) == UserModel.getUserUid()) then 
			local callback = function ( ... )
				PublicChatView.setEditBoxTouchEnabled(true)
			end
			PublicChatView.setEditBoxTouchEnabled(false)
			require "script/module/main/PlayerInfoView"
			local playerInfo = PlayerInfoView:new(callback)
			local layPlayerInfo = playerInfo:create()
			if (layPlayerInfo) then
				LayerManager.addLayout(layPlayerInfo)
			end
		else 
			require "script/module/chat/ChatCommunicationCtrl"
			local layCommunication = ChatCommunicationCtrl.create({
				sender_uid = tbData.sender_uid, sender_uname = tbData.sender_uname, sender_fight = tbData.sender_fight, sender_level = tbData.sender_level, figure = tbData.figure})
			LayerManager.addLayout(layCommunication)
		end 
	end
end


-- 战报初始化
local function initBattleMsgCell(cell,tbData,bgImgSize,tfdNameSize)

	logger:debug(" 聊天战报数据 ")
	logger:debug(tbData)

	local labelChat = cell.TFD_KEYBOARD_CONTENT
	local tfdSelfName = cell.TFD_SELF_NAME
	local imgDialogV0 = cell.IMG_DIALOG_VIP0

	local battle_report_info = ChatUtil.getTable(tbData.message_text)

	logger:debug(battle_report_info)

	local strMessage = ""
	local tbStr = ""
	local richOpt = {}

	if (tonumber(battle_report_info[4]) == ChatCellType.battleReport) then 
		strMessage = battle_report_info[5] .. "【".. battle_report_info[1] .. " VS " .. battle_report_info[2] .."】" .. "【" .. gi18n[2807] .."】"
		tbStr = {battle_report_info[5] ,"【".. battle_report_info[1], " VS ",battle_report_info[2] .."】","12"}
		richOpt = { 
						{color ={r=0,g=0,b=0},font=fontname,size=fontSize},
						{color ={r=0,g=0,b=0},font=fontname,size=fontSize},
						{color={r=0xc6,g=0x0f,b=0x0f},font=fontname,size=fontSize},
						{color={r=0,g=9,b=0},font=fontname,size=fontSize},
						{img_btn=true,normalImg="images/common/newspaper_n.png",selectedImg="images/common/newspaper_h.png"},
				 	}
	else 
		strMessage = "【".. battle_report_info[1] .. " VS " .. battle_report_info[2] .."】" .. "【" .. gi18n[2807] .."】"
		tbStr = {"【".. battle_report_info[1], " VS ",battle_report_info[2] .."】","12"}
		richOpt = { 
						{color ={r=0,g=0,b=0},font=fontname,size=fontSize},
						{color={r=0xc6,g=0x0f,b=0x0f},font=fontname,size=fontSize},
						{color={r=0,g=9,b=0},font=fontname,size=fontSize},
						{img_btn=true,normalImg="images/common/newspaper_n.png",selectedImg="images/common/newspaper_h.png"},
				 	}
	end  


	local richStr = UIHelper.concatString(tbStr)
	local fontname = labelChat:getFontName()
	local fontSize = labelChat:getFontSize()
	local battleRichInfo = {richStr,richOpt}

	-- 战报的回调
	local battleFunc = function ( tag,sender )
		AudioHelper.playCommonEffect()
		local tbRecordData = lua_string_split(battle_report_info[3],'|')
		MailService.getRecord(tbRecordData[1],function (data  )
			createNext(data,tbRecordData)
		end)
	end

	---设置聊天内容
	labelChat:setText(strMessage)
	local tSize = labelChat:getContentSize()
	labelChat:setVisible(false)

	-- 加上图片的尺寸
	tSize.width = tSize.width+150
	tSize.height = tSize.height>30 and 30 or tSize.height

	cell.LAY_FIT_AUDIO:removeChildByTag(nRichLabelTag,true)
	cell.LAY_FIT_AUDIO:removeChildByTag(nLabelTag,true) 

	local richText = BTRichText.create(battleRichInfo, nil, nil)
	cell.LAY_FIT_AUDIO:setLayoutType(LAYOUT_ABSOLUTE)   --设成绝对布局，子控件setPosition生效
	cell.LAY_FIT_AUDIO:addChild(richText)
	richText:setTag(nRichLabelTag)
	BTRichText.addTouchEventHandler({tag=101,handler=battleFunc})
	
	local totalLen = tSize.width + tfdSelfName:getContentSize().width+50
	if(totalLen > bgInfo.bgimg_width_max ) then 
		local labelW = bgInfo.bgimg_width_max - tfdSelfName:getContentSize().width - 50
		local labelHeight = math.ceil(tSize.width / labelW) * 25
		richText:setSize(CCSizeMake(labelW,labelHeight))
		imgDialogV0:setSize( CCSizeMake(bgInfo.bgimg_width_max, bgImgSize.height+labelHeight-30 ))
	elseif (totalLen > bgImgSize.width) then 
		imgDialogV0:setSize(CCSizeMake(bgInfo.bgimg_width_max, bgImgSize.height))
		richText:setSize(tSize)
	else
		 imgDialogV0:setSize(CCSizeMake(tbOriImgSize.width,tbOriImgSize.height))
	end 

	resetCell(cell,richText,tbData.sender_uid,false)

end

local function initAudioMsgCell( cell,tbData,bgImgSize,tfdNameSize,fcell )
	local labelChat = cell.TFD_KEYBOARD_CONTENT
	local tfdSelfName = cell.TFD_SELF_NAME
	local imgDialogV0 = cell.IMG_DIALOG_VIP0
	local tfdTime1 = cell.TFD_TIME1

	cell.LAY_FIT_AUDIO:removeChildByTag(nRichLabelTag,true)   --富文本处理
	cell.LAY_FIT_AUDIO:removeChildByTag(nLabelTag,true)   


	local temp_arr = ChatUtil.getTable(tbData.message_text)
	local aid = temp_arr[1]
	local aSec = tonumber(temp_arr[2])
	tfdTime1:setText(math.floor(aSec/1000) .. " \" ")

	local b_length = (bgInfo.lable_width_max + 50)/(20*1000) *aSec
	if(b_length < (bgInfo.lable_width_max + 50)/(20*1000) *6000)then
		b_length = (bgInfo.lable_width_max + 50)/(20*1000) *6000
	end

	if(b_length> (bgInfo.lable_width_max + 50))then
		b_length = (bgInfo.lable_width_max + 50)
	end

	-- 语音文字
	local a_text = ChatModel.getAudioTextBy(aid)
	local b_height = 70
	local v_menu_length = 0
	if(a_text)then
		strMessage = a_text
	else
		strMessage = ""
	end
	imgDialogV0:setTouchEnabled(true)
	imgDialogV0:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			playRecorder(1, sender, aid)
		end
	end)

	local actionGetAudioText
	local i = 1
	local a_text = ChatModel.getAudioTextBy(aid)
	
	if (a_text ) then
		setRecordText(cell,a_text,bgInfo,sender_uid)
	else 
		actionGetAudioText = schedule(imgDialogV0, function ( ... )
			local a_text = ChatModel.getAudioTextBy(aid)
			if (a_text) then
				imgDialogV0:stopAction(actionGetAudioText)
				return
			end
			getRecordRext(i,aid)
			i = i + 1
		end, 2)

		-- 如果延时获取语音，复用的cell需要先还原坐标和size，
		cell:setSize(CCSizeMake(tbOriCellSize.width,tbOriCellSize.height))
		imgDialogV0:setSize(CCSizeMake(tbOriImgSize.width,tbOriImgSize.height))

		resetCell(cell,nil,tbData.sender_uid,true)
	end 

end

local function initComMsgCell(cell,tbData,bgImgSize,tfdNameSize,strMessage)
	local labelChat = cell.TFD_KEYBOARD_CONTENT
	local tfdSelfName = cell.TFD_SELF_NAME
	local imgDialogV0 = cell.IMG_DIALOG_VIP0

	labelChat:ignoreContentAdaptWithSize(true) 
	local strMessage = tbData.message_text
	labelChat:setText(strMessage)
	local tSize = labelChat:getContentSize()
	labelChat:setVisible(false)

	cell.LAY_FIT_AUDIO:setLayoutType(LAYOUT_ABSOLUTE)   --设成绝对布局，子控件setPosition生效
	local fontname = labelChat:getFontName()
	local fontSize = labelChat:getFontSize()
	local fontColor = labelChat:getColor()
	
	local nHangPart = fontSize + 6

	local label = cell.LAY_FIT_AUDIO:getChildByTag(nLabelTag) 
	cell.LAY_FIT_AUDIO:removeChildByTag(nRichLabelTag,true)   --富文本处理
	if (not label) then 
		label = UIHelper.createUILabel(strMessage,fontname,fontSize,fontColor,nil,kCCTextAlignmentLeft,kCCVerticalTextAlignmentTop)
		cell.LAY_FIT_AUDIO:addChild(label)	
		label:setTag(nLabelTag)
	else
		label:ignoreContentAdaptWithSize(true)
		label:setText(strMessage)
	end  

	local totalLen = tSize.width + tfdSelfName:getContentSize().width+50
	if(totalLen > bgInfo.bgimg_width_max ) then 
		local labelW = bgInfo.bgimg_width_max - tfdSelfName:getContentSize().width - 50
		local labelHeight = math.ceil(tSize.width / labelW) * nHangPart
		label:ignoreContentAdaptWithSize(false)   --允许自动换行
		label:setSize(CCSizeMake(labelW,labelHeight))
		imgDialogV0:setSize(CCSizeMake(bgInfo.bgimg_width_max, bgImgSize.height+labelHeight-nHangPart)) 
	elseif (totalLen > bgImgSize.width) then 
		imgDialogV0:setSize(CCSizeMake(bgInfo.bgimg_width_max, bgImgSize.height))
	else
		imgDialogV0:setSize(CCSizeMake(tbOriImgSize.width,tbOriImgSize.height))
	end 

	resetCell(cell,label,tbData.sender_uid,false)
end



-- 刷新传进来的cell     2015.12.10
function refreashCell( cell ,tbData,fcell)
	local cellSize = cell:getSize()
	local btnSelf = m_fnGetWidget(cell, "BTN_SELF")
	local tfdSelfName = m_fnGetWidget(cell, "TFD_SELF_NAME")
	local imgDialogV0 = m_fnGetWidget(cell, "IMG_DIALOG_VIP0")
	local imgTalk1 = m_fnGetWidget(cell, "IMG_TALK1")
	local tfdTime1 = m_fnGetWidget(cell, "TFD_TIME1")
	local imgPresident1 = m_fnGetWidget(cell, "IMG_PRESIDENT1")
	local imgVice1 = m_fnGetWidget(cell, "IMG_VICE1")
	local tfd_keyboard_content = m_fnGetWidget(cell, "TFD_KEYBOARD_CONTENT") 
	local tfd_audio_content = m_fnGetWidget(cell, "TFD_AUDIO_CONTENT") 

	tfd_keyboard_content:setText("")
	tfd_audio_content:setText("")

	imgDialogV0:setVisible(true)
	imgDialogV0:setEnabled(true)
	imgDialogV0:setTouchEnabled(false)


	if (tbData.channel == "101") then
		imgPresident1:setEnabled(tonumber(tbData.guild_status)==1 and true or false)
		imgVice1:setEnabled(tonumber(tbData.guild_status)==2 and true or false)
	else
		imgPresident1:setEnabled(false)
		imgVice1:setEnabled(false)
	end

	btnSelf:removeChildByTag(nHeadTag,true)
	local heroIcon = HeroUtil.createHeroIconBtnByHtid(tbData.figure, nil, callbackSelfHead)
	heroIcon.tbData = tbData
	btnSelf:addChild(heroIcon)
	heroIcon:setTag(nHeadTag)


	UIHelper.labelEffect(tfdSelfName, tbData.sender_uname)
	cell.IMG_VIP:setVisible(tonumber(tbData.sender_vip) > 1)
	tfdSelfName:setColor(UserModel.getPotentialColor({htid = tbData.figure})) -- zhangqi, 2015-07-28

	-- 计算文本显示长度
	local bgImgSize = imgDialogV0:getSize()   --背景框 ！！！ 复用 tbOriImgSize
	local tfdNameSize = tfdSelfName:getContentSize()  --姓名尺寸
	local maxWidth = bgImgSize.width-tfdNameSize.width-50
	bgInfo.lable_width_max = maxWidth
	
	imgTalk1:setEnabled(false)
	tfdTime1:setEnabled(false)

	-- 如果是战报
	if (ChatUtil.isBattleMsg(tbData.message_text)) then
		initBattleMsgCell(cell,tbData,tbOriImgSize,tfdNameSize)
	elseif (ChatUtil.isAudioMsg(tbData.message_text)) then
		initAudioMsgCell(cell,tbData,tbOriImgSize,tfdNameSize,fcell)
		imgTalk1:setEnabled(true)
		tfdTime1:setEnabled(true)
	else  
		initComMsgCell(cell,tbData,tbOriImgSize,tfdNameSize)
	end


	local h = imgDialogV0:getSize().height+50 > tbOriCellSize.height and imgDialogV0:getSize().height+50 or tbOriCellSize.height
	cell:setSize(CCSizeMake(cellSize.width,h))

	local btnPosy = cell:getSize().height-cell.BTN_SELF:getSize().height/2-20
	cell.BTN_SELF:setPositionY(btnPosy)
	cell.IMG_DIALOG_VIP0:setPositionY(btnPosy+cell.BTN_SELF:getSize().height/2)

end







-- function create( type, tbData, index, callbackHead, callbackLookReport )
-- 	-- liweidong retain内存泄漏
-- 	-- if (not g_UIForClone) then
-- 	g_UIForClone = g_fnLoadUI("ui/chat_main.json")
-- 		-- g_UIForClone:retain()
-- 	-- end

-- 	local cell = nil
-- 	-- 发言的是否为玩家自己
-- 	if tonumber(tbData.sender_uid) == UserModel.getUserUid() then
-- 		local layRight = m_fnGetWidget(g_UIForClone, "LAY_CONTENT1")
-- 		cell = layRight:clone()
-- 	else
-- 		local layLeft = m_fnGetWidget(g_UIForClone, "LAY_CONTENT2")
-- 		cell = layLeft:clone()
-- 	end 

-- 	local cellSize = cell:getSize()
-- 	local btnSelf = m_fnGetWidget(cell, "BTN_SELF")
-- 	local tfdSelfName = m_fnGetWidget(cell, "TFD_SELF_NAME")
-- 	local imgDialogV0 = m_fnGetWidget(cell, "IMG_DIALOG_VIP0")
-- 	local imgTalk1 = m_fnGetWidget(cell, "IMG_TALK1")
-- 	local tfdTime1 = m_fnGetWidget(cell, "TFD_TIME1")
-- 	local imgPresident1 = m_fnGetWidget(cell, "IMG_PRESIDENT1")
-- 	local imgVice1 = m_fnGetWidget(cell, "IMG_VICE1")
-- 	local tfd_keyboard_content = m_fnGetWidget(cell, "TFD_KEYBOARD_CONTENT") 
-- 	local tfd_audio_content = m_fnGetWidget(cell, "TFD_AUDIO_CONTENT") 

-- 	tfd_keyboard_content:setText("")
-- 	tfd_audio_content:setText("")

-- 	imgDialogV0:setVisible(true)
-- 	imgDialogV0:setEnabled(true)

-- 	if (tbData.channel == "101") then
-- 		if (tbData.guild_status ~= "1") then
-- 			imgPresident1:setEnabled(false)
-- 		end
-- 		if (tbData.guild_status ~= "2") then
-- 			imgVice1:setEnabled(false)
-- 		end
-- 	else
-- 		imgPresident1:setEnabled(false)
-- 		imgVice1:setEnabled(false)
-- 	end

-- 	local heroIcon = HeroUtil.createHeroIconBtnByHtid(tbData.figure, nil, callbackSelfHead)
-- 	heroIcon.tbData = tbData
-- 	btnSelf:addChild(heroIcon)
-- 	UIHelper.labelEffect(tfdSelfName, tbData.sender_uname)
-- 	cell.IMG_VIP:setVisible(tonumber(tbData.sender_vip) > 0)
-- 	tfdSelfName:setColor(UserModel.getPotentialColor({htid = tbData.figure})) -- zhangqi, 2015-07-28

-- 	-- 计算文本显示长度
-- 	local bgImgSize = imgDialogV0:getSize()   --背景框
-- 	local tfdNameSize = tfdSelfName:getContentSize()  --姓名尺寸
-- 	local maxWidth = bgImgSize.width-tfdNameSize.width-50
-- 	bgInfo.lable_width_max = maxWidth
	
-- 	imgTalk1:setEnabled(false)
-- 	tfdTime1:setEnabled(false)

-- 	-- 如果是战报
-- 	if isBattleMsg(tbData.message_text) then
-- 		initBattleMsgCell(cell,tbData,bgImgSize,tfdNameSize)
-- 	elseif (isAudioMsg(tbData.message_text)) then
-- 		initAudioMsgCell(cell,tbData,bgImgSize,tfdNameSize)
-- 		imgTalk1:setEnabled(true)
-- 		tfdTime1:setEnabled(true)
-- 	else  
-- 		initComMsgCell(cell,tbData,bgImgSize,tfdNameSize)
-- 	end

-- 	cell:setSize(CCSizeMake(cellSize.width,imgDialogV0:getSize().height > 180 and imgDialogV0:getSize().height or 180))

-- 	return cell
-- end


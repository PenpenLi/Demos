-- FileName: WARecordView.lua
-- Author: Xufei
-- Date: 2015-2-22
-- Purpose: 海盗激斗 对战记录
--[[TODO List]]

WARecordView = class("WARecordView")

-- UI控件引用变量 --

-- 模块局部变量 --
local RICH_TEXT_TAG = 116556
local FONT_SIZE = 22
local _fnGetWidget = g_fnGetWidgetByName
local _i18nString = gi18nString

function WARecordView:showRecordAsMyRecord( recordInfo )
	local function updateCellByIdex( lsv, idx )
		local record = recordInfo[idx+1]
		local listCell = lsv:getItem(idx).item

		local myRecordCell = listCell.BTN_MY_RECORD
		listCell.BTN_SERIES_RECORD:setVisible(false)
		listCell.BTN_SERIES_RECORD:setEnabled(false)
		myRecordCell:setVisible(true)
		myRecordCell:setEnabled(true)
		local tbRecordTime = TimeUtil.getServerDateTime( tonumber(record.attack_time) )
		myRecordCell.TFD_DATE:setText(tbRecordTime.year.."-"..tbRecordTime.month.."-"..tbRecordTime.day)
		myRecordCell.TFD_TIME:setText(tbRecordTime.hour..":"..tbRecordTime.min..":"..tbRecordTime.sec)
		logger:debug({tbRecordTime_showRecordAsMyRecord=tbRecordTime})
		myRecordCell.IMG_FIGHT_WIN:setVisible(
			(record.iImAttacker and tonumber(record.result)==1) or 
			((not record.iImAttacker) and tonumber(record.result)==0)
		)
		myRecordCell.IMG_FIGHT_LOSE:setVisible(
			(record.iImAttacker and tonumber(record.result)==0) or 
			((not record.iImAttacker) and tonumber(record.result)==1)
		)

		local my = "你"
		local attack = "挑战"
		local attackRes1 = "并轻松击败了你"
		local attackRes2 = "但被你轻松击败了"
		local attackRes3 = "并轻松击败了对手"
		local attackRes4 = "可惜挑战失败了"
		local yourRank = "你的海盗激斗排名"
		local rankUp = "升至"
		local rankDown = "降至"
		local lastPos = "最后一名"
		local seeRecord = "［查看战报］"
		local richText
		if (record.iImAttacker) then 														-- 我攻击别人
			local enemyName = "S."..record.defender_server_id.." "..record.defender_uname
			local enemyColor = UserModel.getPotentialColor({htid = record.defender_figure})
			local tbStr
			local richOpt

			local resultRank = math.min(tonumber(record.defender_rank), tonumber(record.defender_rank))
			if (tonumber(record.result)==1) then 			-- 赢了
				local desc = self.desc.YOU_WIN_OTHER
				tbStr = {	
					desc.descTable[1],						-- 你挑战
					enemyName,								
					desc.descTable[2]..resultRank,			-- ，并轻松击败了对手，你的海盗激斗排名升至
					_i18nString(2167),
				}
				richOpt = {
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{color = enemyColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{btn = true, font = g_sFontPangWa,size = 22,color = g_QulityColor[3]},
				}
			else 											-- 输了
				local desc = self.desc.YOU_LOS_OTHER
				tbStr = {	
					desc.descTable[1],
					enemyName,
					desc.descTable[2],
					_i18nString(2167),
				}
				richOpt = {
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{color = enemyColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{btn = true, font = g_sFontPangWa,size = 22,color = g_QulityColor[3]},
				}
			end
			local richStr = UIHelper.concatString(tbStr)
			local textInfo = {richStr,richOpt}
			richText = BTRichText.create(textInfo, nil, nil)
		else 																		-- 别人攻击我
			local enemyName = "S."..record.attacker_server_id.." "..record.attacker_uname
			local enemyColor = UserModel.getPotentialColor({htid = record.attacker_figure})
			local tbStr
			local richOpt
			if (tonumber(record.result)==1) then 			-- 赢了
				local desc = self.desc.OTHER_WIN_YOU
				tbStr = {	
					enemyName,
					desc.descTable[2],
				}
				richOpt = {
					{color = enemyColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
				}
			else 											-- 输了
				local desc = self.desc.OTHER_LOS_YOU
				tbStr = {	
					enemyName,
					desc.descTable[2],
					_i18nString(2167),
				}
				richOpt = {
					{color = enemyColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{btn = true, font = g_sFontPangWa,size = 22,color = g_QulityColor[3]},
				}
			end
			local richStr = UIHelper.concatString(tbStr)
			local textInfo = {richStr,richOpt}
			richText = BTRichText.create(textInfo, nil, nil)
		end

		local layContent = myRecordCell.LAY_DETAIL
		richText:setSize(layContent:getSize())
		richText:setAnchorPoint(ccp(0,0))
		richText:setPosition(ccp(0,0))
		layContent:removeAllChildrenWithCleanup(true)
		layContent:addChild(richText, 10, RICH_TEXT_TAG)

		-- layContent:setTouchEnabled(true)
		-- layContent:addTouchEventListener(function ( sender, eventType )
		-- 	if (eventType == TOUCH_EVENT_ENDED) then
		-- 		AudioHelper.playCommonEffect()
		-- 		local fnSeeRecord = WARecordCtrl.getBtnFunByName("onRecord")
		-- 		fnSeeRecord(record)
		-- 	end
		-- end)
		local battleFunc = function ( tag,sender )
			AudioHelper.playCommonEffect()
			local fnSeeRecord = WARecordCtrl.getBtnFunByName("onRecord")
			fnSeeRecord(record)
		end

		BTRichText.addTouchEventHandler({tag=7891,handler=battleFunc})
	end

	UIHelper.reloadListView(self.listView,#recordInfo,updateCellByIdex, 0)
end

function WARecordView:showContinuousRecord( recordInfo )
	local function updateCellByIdex( lsv, idx )
		local value = recordInfo[idx+1]
		local record = value.data
		local listCell = lsv:getItem(idx).item

		local contiRecordCell = listCell.BTN_SERIES_RECORD
		listCell.BTN_MY_RECORD:setVisible(false)
		listCell.BTN_MY_RECORD:setEnabled(false)
		contiRecordCell:setVisible(true)
		contiRecordCell:setEnabled(true)
		local tbRecordTime = TimeUtil.getServerDateTime( tonumber(record.attack_time) )
		contiRecordCell.TFD_DATE:setText(tbRecordTime.year.."-"..tbRecordTime.month.."-"..tbRecordTime.day)
		contiRecordCell.TFD_TIME:setText(tbRecordTime.hour..":"..tbRecordTime.min..":"..tbRecordTime.sec)
		logger:debug({tbRecordTime_showContinuousRecord=tbRecordTime})
		
		local kill = "击败"
		local achieveConti = "达成%s连杀！快来个人阻止他吧！"
		local stopConti = "%s的%s连杀被终结！听说你很强？"
		local seeRecord = "［查看战报］"
		local richText
		if (value.state == "continuous") then 													-- 是连胜纪录，且一定是攻方胜
			local desc = self.desc.CONTINUOUS_KO
			local attackerName = "S."..record.attacker_server_id.." "..record.attacker_uname
			local defenderName = "S."..record.defender_server_id.." "..record.defender_uname

			local attackerColor = UserModel.getPotentialColor({htid = record.attacker_figure})
			local defenderColor = UserModel.getPotentialColor({htid = record.defender_figure})
			
			local contiKillTimes = record.attacker_conti
			local tbStr = {	
				attackerName,
				desc.descTable[2],
				defenderName,
				string.format(desc.descTable[3],contiKillTimes),
				_i18nString(2167),
			}
			richOpt = {
				{color = attackerColor, font = g_sFontName, size = FONT_SIZE},
				{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
				{color = defenderColor, font = g_sFontName, size = FONT_SIZE},
				{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
				{btn = true, font = g_sFontPangWa,size = 22,color = g_QulityColor[3]},
			}
			local richStr = UIHelper.concatString(tbStr)
			local textInfo = {richStr,richOpt}
			richText = BTRichText.create(textInfo, nil, nil)
		elseif (value.state == "terminal") then 												-- 是终结纪录
			if (tonumber(record.result)==1) then 												-- 是攻方胜
				local desc = self.desc.TERMINATE_CON
				local attackerName = "S."..record.attacker_server_id.." "..record.attacker_uname
				local defenderName = "S."..record.defender_server_id.." "..record.defender_uname

				local attackerColor = UserModel.getPotentialColor({htid = record.attacker_figure})
				local defenderColor = UserModel.getPotentialColor({htid = record.defender_figure})

				local stopContiNum = record.attacker_terminal_conti
				tbStr = {	
					attackerName,
					desc.descTable[2],
					defenderName,
					desc.descTable[3],
					defenderName,
					string.format(desc.descTable[4],stopContiNum),
					_i18nString(2167),
				}
				richOpt = {
					{color = attackerColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{color = defenderColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{color = defenderColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{btn = true, font = g_sFontPangWa,size = 22,color = g_QulityColor[3]},
				}
				local richStr = UIHelper.concatString(tbStr)
				local textInfo = {richStr,richOpt}
				richText = BTRichText.create(textInfo, nil, nil)
			else 																				-- 是守方胜
				local desc = self.desc.TERMINATE_CON
				local attackerName = "S."..record.attacker_server_id.." "..record.attacker_uname
				local defenderName = "S."..record.defender_server_id.." "..record.defender_uname

				local attackerColor = UserModel.getPotentialColor({htid = record.attacker_figure})
				local defenderColor = UserModel.getPotentialColor({htid = record.defender_figure})

				local stopContiNum = record.defender_terminal_conti
				tbStr = {	
					defenderName,
					desc.descTable[2],
					attackerName,
					desc.descTable[3],
					attackerName,
					string.format(desc.descTable[4],stopContiNum),
					_i18nString(2167),
				}
				richOpt = {
					{color = defenderColor, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{color = attackerName, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{color = attackerName, font = g_sFontName, size = FONT_SIZE},
					{color = {r=0x7f,g=0x5f,b=0x20}, font = g_sFontName, size = FONT_SIZE},
					{btn = true, font = g_sFontPangWa,size = 22,color = g_QulityColor[3]},
				}
				local richStr = UIHelper.concatString(tbStr)
				local textInfo = {richStr,richOpt}
				richText = BTRichText.create(textInfo, nil, nil)
			end
		end
		local layContent = contiRecordCell.LAY_DETAIL
		richText:setSize(layContent:getSize())
		richText:setAnchorPoint(ccp(0,0))
		richText:setPosition(ccp(0,0))
		layContent:removeAllChildrenWithCleanup(true)
		layContent:addChild(richText, 10, RICH_TEXT_TAG)

		-- layContent:setTouchEnabled(true)
		-- layContent:addTouchEventListener(function ( sender, eventType )
		-- 	if (eventType == TOUCH_EVENT_ENDED) then
		-- 		AudioHelper.playCommonEffect()
		-- 		local fnSeeRecord = WARecordCtrl.getBtnFunByName("onRecord")
		-- 		fnSeeRecord(record)
		-- 	end
		-- end)

		local battleFunc = function ( tag,sender )
			AudioHelper.playCommonEffect()
			local fnSeeRecord = WARecordCtrl.getBtnFunByName("onRecord")
			fnSeeRecord(record)
		end
		BTRichText.addTouchEventHandler({tag=7891,handler=battleFunc})
	end
	UIHelper.reloadListView(self.listView,#recordInfo,updateCellByIdex, 0)
end

function WARecordView:showRecord( ... )
	local recordInfo = WARecordModel.getNowTabInfo()
	local tabNum = WARecordModel.getTabNum()
	for i = 1, 2 do
		local btnTab = _fnGetWidget(self.layMain, "BTN_RECORD"..i)
		btnTab:setFocused(i == tonumber(tabNum))
		btnTab:setTouchEnabled(i ~= tonumber(tabNum))
		btnTab:setTag(i)
		btnTab:addTouchEventListener(WARecordCtrl.getBtnFunByName("onChooseTab"))
	end

	-- self.listView:removeAllItems()
	if (tonumber(tabNum)==1) then
		self:showContinuousRecord(recordInfo)
	elseif (tonumber(tabNum)==2) then
		self:showRecordAsMyRecord(recordInfo)
	end
	-- self.listView:jumpToPercentVertical(0)
	-- UIHelper.setSliding( self.listView )
end

function WARecordView:setBtnEvent( ... )
	self.layMain.BTN_CLOSE:addTouchEventListener(WARecordCtrl.getBtnFunByName("onClose"))
	self.layMain.BTN_CONFIRM:addTouchEventListener(WARecordCtrl.getBtnFunByName("onConfirm"))	
end

function WARecordView:init(...)
	self.layMain = nil
end

function WARecordView:destroy(...)
	package.loaded["WARecordView"] = nil
end

function WARecordView:moduleName()
    return "WARecordView"
end

function WARecordView:ctor( ... )
	self:init()
	self.layMain = g_fnLoadUI("ui/fight_record.json")
end

function WARecordView:create(...)
	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			self.layMain = nil
		end,
		function()
		end
	)
	self.listView = self.layMain.LSV_LIST
	UIHelper.initListViewCell(self.listView)

	UIHelper.titleShadow( self.layMain.BTN_CONFIRM )
	
	self.desc = WARecordModel.getDesStr()

	self:showRecord()
	self:setBtnEvent()
	return self.layMain	
end

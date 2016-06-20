-- FileName: WAUtil.lua
-- Author: huxiaozhou
-- Date: 2016-02-17
-- Purpose: 巅峰对决工具类
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WAUtil", package.seeall)

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString

-- 回血类型， 贝里回血 金币回血
WA_RESET_HP = {SILVER=1 ,GOLD=2,}

-- 报名前， 报名中， 分房间， 战斗， 发奖， 结束
WA_STATE = {before_signup=1, signup=2, range_room=3, attack=4,reward=5, ended=6,}



--[[
	@des 	: 得到倒计时显示描述
			分组时间（活动关闭状态，玩家看不到）
			报名时间（此时前端显示：距离报名结束：00:00:00）
			分房间时间（此时前端显示：距离活动开始：00:00:00）
			比赛时间（此时前端显示：距离活动结束：00:00:00）
			比赛结束发奖展示排行（此时前端短时：活动已结束）
--]]
function getTimeDesStr(  )
	--TODO
	local curTime = TimeUtil.getSvrTimeByOffset()
	local signEndTime = WorldArenaModel.getSignUpEndTime()
	local atkStartTime = WorldArenaModel.getAttackStartTime()
	local atkEndTime = WorldArenaModel.getAttackEndTime()
	local rewardEndTime = WorldArenaModel.getWorldArenaEndTime()
	local nCurState = getCurState()
	local descStr = ""
	local timeStr = ""
	if( nCurState == WA_STATE.signup)then
		-- 距离报名结束
		timeStr = TimeUtil.getTimeString(signEndTime - curTime)
		descStr = m_i18n[8123] 
	elseif( nCurState == WA_STATE.range_room)then
		-- 距离活动开始
		timeStr = TimeUtil.getTimeString(atkStartTime - curTime)
		descStr = m_i18n[8124] 
	elseif( nCurState == WA_STATE.attack)then
		-- 距离活动结束
		logger:debug("WA_STATE.attack = " .. atkEndTime - curTime)
		timeStr = TimeUtil.getTimeString(atkEndTime - curTime)
		descStr = m_i18n[8127]
	elseif( nCurState == WA_STATE.reward )then
		-- 正在发奖
		logger:debug("WA_STATE.reward = " .. rewardEndTime - curTime)
		timeStr = TimeUtil.getTimeString(rewardEndTime - curTime)
		descStr = m_i18n[8125]

	elseif (nCurState == WA_STATE.ended) then
		logger:debug("WA_STATE.ended")
		logger:debug("WA_STATE.reward = " .. rewardEndTime - curTime)
		timeStr = TimeUtil.getTimeString(rewardEndTime - curTime)
		descStr = m_i18n[8125]
	else
		error("error time")
	end
	logger:debug({timeStr = timeStr, descStr = descStr})

	return descStr, timeStr
end

function getDes(  )
	local nCurState = getCurState()
	local bSignUp =  (WorldArenaModel.getMySignUpTime() == 0) -- 如果未报名
	local descStr = " "
	if( nCurState == WA_STATE.signup)then
		descStr = gi18nString(8101,WorldArenaModel.getworldArenaNeedLv())
	elseif( nCurState == WA_STATE.range_room)then
		if bSignUp then
			descStr = m_i18n[8103]
		else
			descStr = m_i18n[8102]
		end
	elseif( nCurState == WA_STATE.attack)then
		if bSignUp then
			descStr = m_i18n[8104]
		end
	elseif( nCurState == WA_STATE.reward or nCurState == WA_STATE.ended )then
		-- 活动结束
		descStr = m_i18n[8105]
	else
		error("error time")
	end
	return descStr
end


-- 获取当前的状态
function getCurState(  )
	local curTime = TimeUtil.getSvrTimeByOffset(0)
	local signStartTime = WorldArenaModel.getSignUpStartTime()
	local signEndTime = WorldArenaModel.getSignUpEndTime()
	local atkStartTime = WorldArenaModel.getAttackStartTime()
	local atkEndTime = WorldArenaModel.getAttackEndTime()
	local rewardEndTime = WorldArenaModel.getWorldArenaEndTime()
	local nState = WA_STATE.before_signup
	if curTime  <= signStartTime then
		nState = WA_STATE.before_signup
	elseif( curTime <signEndTime )then
		nState = WA_STATE.signup
	elseif( curTime > signEndTime  and curTime <= atkStartTime)then
		nState = WA_STATE.range_room
	elseif( curTime >atkStartTime  and curTime < atkEndTime)then
		nState = WA_STATE.attack
	elseif( curTime >= atkEndTime and curTime <=rewardEndTime)then
		nState = WA_STATE.reward
	else
		nState = WA_STATE.ended
	end
	return nState
end

--[[
 * 玩家连杀，击杀，终结连杀达到一定次数	push.worldarena.broadcast
 * array
 * {
 * 		attacker_name
 		attacker_figure
 * 		attacker_server_name
 * 		defender_name
 		defender_figure
 * 		defender_server_name
 * 		kill_num
 * 		conti_num
 * 		term_num
 * }
 */
--]]
require "db/DB_Paomadeng"
local _arrDb = {}
local function getDbPaomadeng(  )
	for index=1,3 do
		local subArr = DB_Paomadeng.getArrDataByField("type",index)
		_arrDb[index] = subArr
	end
end

local function getDbData(tData)
	local configDb = {}
	local tb = {tData.conti_num or 0,  tData.term_num or 0, tData.kill_num or 0,}
	logger:debug({getDbData = tb})
	for i,v in ipairs(tb) do
		for _,db in ipairs(_arrDb[i]) do
			if tonumber(db.num) == tonumber(v) then
				table.insert(configDb,db.id)
			end
		end
	end
	logger:debug({configDb = configDb})
	return configDb
end

function getBroardcastContent(tData)
	if table.isEmpty(_arrDb) then
		getDbPaomadeng()
	end
	local configDb = getDbData(tData)
	local tRichText = {}
	for i,id in ipairs(configDb) do
		local dbData = DB_Paomadeng.getDataById(id)
		local tTxt = {}
		local strTxt = ""
		local colors = {}
		if tonumber(dbData.type)==1 then
			tTxt = {tData.attacker_name, "连推", tData.conti_num, dbData.desc}
	 		strTxt = string.format("%s连推%s%s", tData.attacker_name, tData.conti_num, dbData.desc)
			colors = {UserModel.getPotentialColor({htid = tData.attacker_figure}), ccc3(255, 255, 255), ccc3(0x4d, 0xec, 0x15), ccc3(255, 255, 255)}
		elseif tonumber(dbData.type)==2 then
			tTxt = {tData.attacker_name, "终结了", tData.defender_name,"的", tData.term_num, dbData.desc}
	 		strTxt = string.format("%s终结了%s的%s%s", tData.attacker_name, tData.defender_name, tData.term_num, dbData.desc)
			colors = {UserModel.getPotentialColor({htid = tData.attacker_figure}), ccc3(255, 255, 255), UserModel.getPotentialColor({htid = tData.defender_figure}),ccc3(255, 255, 255), ccc3(0x4d, 0xec, 0x15), ccc3(255, 255, 255)}
		elseif tonumber(dbData.type)==3 then
			tTxt = {tData.attacker_name, "击杀了", tData.kill_num, dbData.desc}
	 		strTxt = string.format("%s击杀了%s%s", tData.attacker_name, tData.kill_num, dbData.desc)
			colors = {UserModel.getPotentialColor({htid = tData.attacker_figure}), ccc3(255, 255, 255), ccc3(0x4d, 0xec, 0x15), ccc3(255, 255, 255)}	
		end
		------- 创建富文本 --------
		local tbColor = {}
		for k,v in pairs(colors) do
			local data = {color = v, font = g_sFontCuYuan, size = 20}
			table.insert(tbColor, data)
		end

	 	-- 用于获取width
	 	local label = CCLabelTTF:create(strTxt, g_sFontCuYuan, 20)
	 	-- 数据源
	 	local richStr =  UIHelper.concatString(tTxt)
	 	local textInfo = {richStr, tbColor}

	 	local richText = BTRichText.create(textInfo, nil, nil)
	 	richText:setSize(label:getContentSize())
	 	richText:setAnchorPoint(ccp(0, 0.5))
	 	richText:retain()
	 	table.insert(tRichText, richText)
	end
	return tRichText
end

-- 绑定按钮事件
function bindingBtnFun(widget, func )
	widget:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			func()
		end
	end)
end

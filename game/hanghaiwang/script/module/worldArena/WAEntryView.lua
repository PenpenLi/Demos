-- FileName: WAEntryView.lua
-- Author: huxiaozhou
-- Date: 2016-02-17
-- Purpose: 入口
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WAEntryView", package.seeall)

-- UI控件引用变量 --
local _mainWidget = nil
-- 模块局部变量 --

local m_i18n = gi18n
local m_i18nString 	= gi18nString
local _tGetWAInfo = {signup=false, range_room=false, attack=false,reward=false, ended=false,} -- 表示是否重新拉取过信息



local json = "ui/peak_enroll.json"
local function init(...)
	_tGetWAInfo = {signup=false, range_room=false, attack=false,reward=false, ended=false,}
	initStage()
end

function destroy(...)
	package.loaded["WAEntryView"] = nil
end

function moduleName()
    return "WAEntryView"
end

function create(...)
	_mainWidget = g_fnLoadUI(json)
	_mainWidget:setSize(g_winSize)
	_mainWidget.img_bg:setScale(g_fScaleX)
	init()
	bingdingAllEvt()
	updateAllState()
	loadAll()

	UIHelper.registExitAndEnterCall(_mainWidget, function (  )
		GlobalScheduler.removeCallback("WAloadPublic")
		GlobalScheduler.removeCallback("WAUPFMTCD")
		GlobalScheduler.removeCallback("WASCHEDULE")
		GlobalNotify.removeObserver("END_BATTLE", "WAENTRY_END_BATTLE")
	end, function (  )
		AudioHelper.playMusic("audio/bgm/copy1.mp3", true)
		GlobalNotify.addObserver("END_BATTLE",function (  )
			AudioHelper.playMusic("audio/bgm/copy1.mp3", true)
		end, false, "WAENTRY_END_BATTLE")
		GlobalScheduler.addCallback("WASCHEDULE", scheduleUpdate)
	end)
	LayerManager.changeModule(_mainWidget, moduleName(), {1}, true)
end

function scheduleUpdate(  )
	local nState = WAUtil.getCurState()
	logger:debug({nState = nState})
	logger:debug({_tGetWAInfo = _tGetWAInfo})
	if nState == WAUtil.WA_STATE.range_room then -- 分房间阶段
		if _tGetWAInfo.signup then
			_tGetWAInfo.signup = false
			preGetWAInfo()
		end
	elseif nState == WAUtil.WA_STATE.attack then
		if _tGetWAInfo.range_room then
			_tGetWAInfo.range_room = false
			preGetWAInfo()
		end
	elseif nState == WAUtil.WA_STATE.reward then
		if _tGetWAInfo.attack then
			_tGetWAInfo.attack = false
			preGetWAInfo()
		end
	end
end


function preGetWAInfo( )
	WAService.getWorldArenaInfo(function ( tData )
		WorldArenaModel.setWorldArenaInfo(tData)
		initStage()
		loadAll()
		updateAllState()
	end)
end

-- 绑定所有按钮事件
function bingdingAllEvt(  )
	WAUtil.bindingBtnFun(_mainWidget.BTN_EXPLAIN, WAEntryCtrl.onHelp) -- 帮助说明
	WAUtil.bindingBtnFun(_mainWidget.BTN_PREVIEW, WAEntryCtrl.onPreViewRewards) -- 奖励预览
	WAUtil.bindingBtnFun(_mainWidget.BTN_MESSAGE, WAEntryCtrl.onMsg) -- 留言
	WAUtil.bindingBtnFun(_mainWidget.BTN_CLOSE, WAEntryCtrl.onBack) -- 返回

	WAUtil.bindingBtnFun(_mainWidget.LAY_ENROLL.BTN_SIGNUP, WAEntryCtrl.onSignUp) -- 报名
	WAUtil.bindingBtnFun(_mainWidget.LAY_ENROLL.BTN_UPDATE, WAEntryCtrl.onUpdateFmt) -- 更新阵容

	WAUtil.bindingBtnFun(_mainWidget.LAY_NOSIGN.BTN_RANK, WAEntryCtrl.onRank) -- 排行榜
	WAUtil.bindingBtnFun(_mainWidget.LAY_NOSIGN.BTN_BET, WAEntryCtrl.onBet) -- 押注	
	WAUtil.bindingBtnFun(_mainWidget.LAY_NOSIGN.BTN_RECORD, WAEntryCtrl.onRecord) -- 对战记录

end

-- 公用界面
function loadPublic(  )
	local function updateLabel( )
		local des, timeStr = WAUtil.getTimeDesStr()
		logger:debug({des = des, timeStr = timeStr})
		_mainWidget.LAY_PUBLIC.LAY_COUNTDOWN.tfd_desc:setText(des)
		_mainWidget.LAY_PUBLIC.LAY_COUNTDOWN.TFD_TIME:setText(timeStr)
	end
	updateLabel()
	

	GlobalScheduler.removeCallback("WAloadPublic")
	GlobalScheduler.addCallback("WAloadPublic", updateLabel)

	_mainWidget.LAY_PUBLIC.tfd_shuoming:setText(WAUtil.getDes())

	UIHelper.labelNewStroke(_mainWidget.LAY_PUBLIC.LAY_COUNTDOWN.tfd_desc, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(_mainWidget.LAY_PUBLIC.LAY_COUNTDOWN.TFD_TIME, ccc3(0x28, 0x00, 0x00))
	UIHelper.labelNewStroke(_mainWidget.LAY_PUBLIC.tfd_shuoming, ccc3(0x28, 0x00, 0x00))


end

-- 报名,更新阵容界面
function loadEnroll(  )
	local nState = WAUtil.getCurState()
	local layEnRoll = _mainWidget.LAY_ENROLL
	if nState == WAUtil.WA_STATE.signup or nState == WAUtil.WA_STATE.range_room then
		layEnRoll:setEnabled(true)
		local bSignUp =  (WorldArenaModel.getMySignUpTime() == 0) -- 如果未报名
		layEnRoll.BTN_SIGNUP:setEnabled(bSignUp)
		layEnRoll.BTN_UPDATE:setEnabled(not bSignUp)
		layEnRoll.img_already_enroll:setEnabled(not bSignUp)
		local layCd = layEnRoll.LAY_CD
		layCd:setEnabled(not bSignUp)
		layCd.tfd_desc:setText("冷却时间：")
		UIHelper.labelNewStroke(layCd.tfd_desc, ccc3(0x28, 0x00, 0x00))
		UIHelper.labelNewStroke(layCd.TFD_TIME, ccc3(0x28, 0x00, 0x00))
		function updateCD(  )
			local lastUpdateTime = WorldArenaModel.getlastUpdateFightForceTime() 
			local updateCD = WorldArenaModel.getUpdateFightForceCD() -- 1000 
			local curTime = TimeUtil.getSvrTimeByOffset()
			local nextUpTime = lastUpdateTime + updateCD
			if( nextUpTime > curTime )then
				layCd.TFD_TIME:setText(TimeUtil.getTimeString(nextUpTime - curTime))
			else
				layCd:setEnabled(false)
			end
		end
		updateCD()
		GlobalScheduler.removeCallback("WAUPFMTCD")
		GlobalScheduler.addCallback("WAUPFMTCD", updateCD)
		if nState == WAUtil.WA_STATE.range_room and bSignUp then
			layEnRoll:setEnabled(false)
		end
	else
		layEnRoll:setEnabled(false)
	end
	
end

function loadAll(  )
	loadPublic()
	loadEnroll()
end

-- 根据当前的时间段 更新显示的layout 
function updateAllState(  )
	_mainWidget.LAY_ENROLL:setEnabled(false)
	_mainWidget.LAY_NOSIGN:setEnabled(false)

	_mainWidget.LAY_NOSIGN.BTN_RANK:setEnabled(true)
	_mainWidget.LAY_NOSIGN.BTN_BET:setEnabled(true)
	_mainWidget.LAY_NOSIGN.BTN_RECORD:setEnabled(true)


	local bSignUp =  (WorldArenaModel.getMySignUpTime() == 0) -- 如果未报名
	logger:debug({bSignUp = bSignUp})
	local nState = WAUtil.getCurState()
	logger:debug({nState = nState})
	_mainWidget.BTN_MESSAGE:setEnabled(false)
	if nState == WAUtil.WA_STATE.signup then -- 报名阶段
		_mainWidget.LAY_ENROLL:setEnabled(true)
	elseif nState == WAUtil.WA_STATE.range_room then -- 分房间阶段
		_mainWidget.LAY_NOSIGN:setEnabled(bSignUp)
		_mainWidget.LAY_NOSIGN.img_nosign:setEnabled(bSignUp)
		_mainWidget.LAY_ENROLL:setEnabled(not bSignUp)
		_mainWidget.LAY_NOSIGN.BTN_RANK:setEnabled(not bSignUp)
		_mainWidget.LAY_NOSIGN.BTN_BET:setEnabled(not bSignUp)
		_mainWidget.LAY_NOSIGN.BTN_RECORD:setEnabled(not bSignUp)
	elseif nState == WAUtil.WA_STATE.attack then -- 战斗阶段
		_mainWidget.BTN_MESSAGE:setEnabled(true)
		if bSignUp then
			_mainWidget.LAY_NOSIGN:setEnabled(bSignUp)
			_mainWidget.LAY_ENROLL:setEnabled(not bSignUp)
			_mainWidget.LAY_NOSIGN.img_nosign:setEnabled(bSignUp)
		else
			WAMainCtrl.create()
		end
	elseif nState == WAUtil.WA_STATE.reward then  -- 发奖阶段
		_mainWidget.BTN_MESSAGE:setEnabled(true)
		_mainWidget.LAY_NOSIGN:setEnabled(true)
		_mainWidget.LAY_NOSIGN.img_nosign:setEnabled(bSignUp)
	end
end

-- 初始化当前阶段
function initStage( ... )
	local nState = WAUtil.getCurState()
	logger:debug({nState = nState})
	if nState == WAUtil.WA_STATE.signup then -- 报名阶段
		_tGetWAInfo.signup = true
	elseif nState == WAUtil.WA_STATE.range_room then -- 分房间阶段
		_tGetWAInfo.range_room=true
	elseif nState == WAUtil.WA_STATE.attack then -- 战斗阶段
		_tGetWAInfo.attack=true
	elseif nState == WAUtil.WA_STATE.reward then  -- 发奖阶段
		_tGetWAInfo.reward=true
	end
end

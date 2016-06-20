-- FileName: WAEntryCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-02-05
-- Purpose: 
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WAEntryCtrl", package.seeall)
require "script/module/worldArena/WAEntryView"
require "script/module/worldArena/WorldArenaModel"
require "script/module/worldArena/WAUtil"
require "script/module/worldArena/WAMainCtrl"
require "script/module/worldArena/WAService"


-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["WAEntryCtrl"] = nil
end

function moduleName()
    return "WAEntryCtrl"
end

-- 返回
function onBack(  )
	AudioHelper.playBackEffect()
	MainScene.homeCallback()
end

-- 奖励预览
function onPreViewRewards(  )
	AudioHelper.playSpecialEffect("dianji_fubenbaoxiang.mp3")
	logger:debug("onPreViewRewards")
	WARewardCtrl.create()
end

-- 帮助 说明
function onHelp(  )
	AudioHelper.playBtnEffect("renwu.mp3")
	logger:debug("onHelp")
	local helpViewIns = WAIntro:new()
	LayerManager.addLayout(helpViewIns:create())
end

-- 报名
function onSignUp(  )
	AudioHelper.playBtnEffect("anniu_haizeijidou.mp3")
	--判断报名时间
	local curTime = TimeUtil.getSvrTimeByOffset(0)
	local signUpStartTime = WorldArenaModel.getSignUpStartTime()
	local signUpEndTime = WorldArenaModel.getSignUpEndTime()
	if( curTime < signUpStartTime )then
		ShowNotice.showShellInfo("未到报名时间")
		return
	end

	--判断等级是否可以开启巅峰对决
	local needLv = WorldArenaModel.getworldArenaNeedLv()
	if needLv > UserModel.getAvatarLevel() then
		local str = string.format("%s级才可以参加海盗激斗，请努力升级吧！", needLv)
		ShowNotice.showShellInfo(str)
		return 
	end

	WAService.signUp(function ( sign_time )
		WorldArenaModel.setMySignUpTime(sign_time)
		ShowNotice.showShellInfo("报名成功")
		WAEntryView.loadAll()
	end)
end

-- 更新阵容信息
function onUpdateFmt(  )
	--是否有cd
	AudioHelper.playCommonEffect()
	local lastUpdateTime = WorldArenaModel.getlastUpdateFightForceTime()
	local updateCD = WorldArenaModel.getUpdateFightForceCD()
	local curTime = TimeUtil.getSvrTimeByOffset()
	if( lastUpdateTime + updateCD >= curTime )then
		ShowNotice.showShellInfo("处于冷却时间中，无法更新信息")
		return
	end

	WAService.updateFmt(function ( updateFmtTime )
		WorldArenaModel.setlastUpdateFightForceTime(updateFmtTime)
		ShowNotice.showShellInfo("更新信息成功")
		WAEntryView.loadAll()
	end)
end

-- 排行榜
function onRank(  )
	logger:debug("onRank")
	AudioHelper.playMainUIEffect()
	local nState = WAUtil.getCurState()
	if nState == WAUtil.WA_STATE.ended then
		ShowNotice.showShellInfo("活动已结束")
		return 
	end
	if not WorldArenaModel.getNoSignPlayerCanOpt() then
		ShowNotice.showShellInfo(m_i18nString(8128, WorldArenaModel.getNoSignPlayerLevel()))
		return 
	end
	WAService.getRankList( function ( rankInfo )
		WARankCtrl.create(rankInfo)
	end )
end

-- 对战记录
function onRecord(  )
	logger:debug("onRecord")
	AudioHelper.playBtnEffect("renwu.mp3")
	local nState = WAUtil.getCurState()
	if nState == WAUtil.WA_STATE.ended then
		ShowNotice.showShellInfo("活动已结束")
		return 
	end
	if not WorldArenaModel.getNoSignPlayerCanOpt() then
		ShowNotice.showShellInfo(m_i18nString(8128, WorldArenaModel.getNoSignPlayerLevel()))
		return 
	end
	WAService.getRecordList( function ( recordInfo )
		WARecordCtrl.create(recordInfo)
	end )
end

-- 押注
function onBet(  )
	logger:debug("onBet")
	AudioHelper.playBtnEffect("buttonbuy.mp3")
	local nState = WAUtil.getCurState()
	if nState == WAUtil.WA_STATE.ended then
		ShowNotice.showShellInfo("活动已结束")
		return 
	end
	if not WorldArenaModel.getNoSignPlayerCanOpt() then
		ShowNotice.showShellInfo(m_i18nString(8128, WorldArenaModel.getNoSignPlayerLevel()))
		return 
	end
	local nState = WAUtil.getCurState()
	if (nState == WAUtil.WA_STATE.attack) or (nState == WAUtil.WA_STATE.reward) then
		WAService.getBetList( function ( betInfo )
			WABetCtrl.create(betInfo)
		end )
	end
end

-- 留言
function onMsg(  )
	AudioHelper.playInfoEffect()
	local nState = WAUtil.getCurState()
	if nState == WAUtil.WA_STATE.ended then
		ShowNotice.showShellInfo("活动已结束")
		return 
	end
	if not WorldArenaModel.getNoSignPlayerCanOpt() then
		ShowNotice.showShellInfo(m_i18nString(8128, WorldArenaModel.getNoSignPlayerLevel()))
		return 
	end
	logger:debug("onMsg")

	local nState = WAUtil.getCurState()
	if (nState == WAUtil.WA_STATE.attack) or (nState == WAUtil.WA_STATE.reward) then
		WAService.getMsg(function ( msgInfo )
			WAMessageBoardCtrl.create(msgInfo)
		end)
	end
end

function create( )
	
	WAService.getWorldArenaInfo(function ( tData )
		WorldArenaModel.setWorldArenaInfo(tData)
		local nState = WAUtil.getCurState()
		if nState == WAUtil.WA_STATE.attack and not (WorldArenaModel.getMySignUpTime() == 0) then
			WAMainCtrl.create()
		else
			WAEntryView.create()
		end
	end)
end

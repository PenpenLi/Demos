-- FileName: MineConst.lua
-- Author: huxiaozhou
-- Date: 2015-05-29
-- Purpose:资源矿定义的一些常量

module("MineConst", package.seeall)

-- 资源矿信息界面显示类型
MineInfoType = {
	MINE_NONE = 1, 	-- 空矿
	MINE_SELF = 2, 	-- 玩家自己矿
	MINE_OTHER = 3, 	-- 其他人得矿,
	MINE_SELF_GOLD = 4, -- 自己的金矿
	MINE_OTHER_GOLD = 5, -- 别人的金矿
	MINE_NONE_GOLD = 6,  -- 空得金矿
	MINE_SELF_GOURD = 7,  -- 自己协助的矿
}

--  矿的信息面板 一些事件
MineEvent = {
	GRAB_PIT = "GRAB_PIT", 							-- 抢矿
	GRAB_PIT_GOLD = "GRAB_PIT_GOLD",				-- 金币抢矿
	ROB_GUARD = "ROB_GUARD", 						-- 抢协助军
	GIVEUP_PIT = "GIVEUP_PIT", 						-- 放弃矿
	ABANDON_ASSIST_PIT = "ABANDON_ASSIST_PIT",		-- 放弃某矿协助军
	ASSIST_PIT = "ASSIST_PIT", 						-- 协助某个矿坑
	CAPTURE_PIT = "CAPTURE_PIT",					-- 占领无人占领的矿坑 会打守卫资源矿的NPC
	DELAY_PIT_DUETIME = "DELAY_PIT_DUETIME"			-- 矿坑延期
}

MineBattleEvt = {
	MINE_BEGIN_BATTLE = "MINE_BEGIN_BATTLE", 	-- 通知进入资源矿战斗
	MINE_END_BATTLE   = "MINE_END_BATTLE" 		-- 通知结束资源矿战斗

}
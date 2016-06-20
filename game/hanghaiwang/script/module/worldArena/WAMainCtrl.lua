-- FileName: WAMainCtrl.lua
-- Author: huxiaozhou
-- Date: 2016-02-17
-- Purpose: 巅峰对决 战斗界面控制
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WAMainCtrl", package.seeall)
require "script/module/worldArena/WAMainView"
require "script/module/worldArena/WASecMenu"
require "script/module/worldArena/WABatchBuyAtkTimes"

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString


local function init(...)

end

function destroy(...)
	package.loaded["WAMainCtrl"] = nil
end

function moduleName()
    return "WAMainCtrl"
end

function onSecMenu(  )
	WAMainView.updateSecMenuBtnByType(1)
	WASecMenu.create()
end

-- 返回
function onBack(  )
	AudioHelper.playBackEffect()
	MainScene.homeCallback()
end

-- 购买攻击次数
function onBuyAtkTimes(  )
	AudioHelper.playCommonEffect()
	local tArgs = {}
	tArgs.onSure = function ( num )

		-- 1.攻击时间结束
		local curTime = TimeUtil.getSvrTimeByOffset(0)
		local atkEndTime = WorldArenaModel.getAttackEndTime()
		if( curTime >= atkEndTime )then
			ShowNotice.showShellInfo("已经不在战斗阶段")
			AudioHelper.playCommonEffect()
			return
		end

		-- 金币不足
		local needGold = WorldArenaModel.getBuyAtkNumCost(num)
		if UserModel.getGoldNumber() < tonumber(needGold) then
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			AudioHelper.playCommonEffect()
			return
		end

		-- 最大次数限制
		local maxNum = WorldArenaModel.getBuyAtkMaxNum()
		-- 已购买次数
		local haveBuyNum = WorldArenaModel.getHaveBuyAtkNum()
		if(haveBuyNum >= maxNum)then
			ShowNotice.showShellInfo("已经达到最大购买次数")
			AudioHelper.playCommonEffect()
			return
		end

		local requestCallback = function( retData )
			LayerManager.removeLayout()
			-- 剩余次数
			WorldArenaModel.setAtkNum(retData)
			-- 已购买次数
			WorldArenaModel.setHaveBuyAtkNum(haveBuyNum + num)
			-- 扣除金币
			UserModel.addGoldNumber(-needGold)
			ShowNotice.showShellInfo("购买挑战次数成功")
			WAMainView.updateBottom()
		end
		AudioHelper.playBtnEffect("buttonbuy.mp3")
		WAService.buyAtkNum(num,requestCallback)
	end
	tArgs.canBuyNum = WorldArenaModel.getBuyAtkMaxNum() - WorldArenaModel.getHaveBuyAtkNum()
	local view = WABatchBuyAtkTimes:new():create(tArgs)
	LayerManager.addLayout(view)
end

-- 回血 分金币回血 银币回血 string $type 取值如下：'1'银币重置/'2'金币重置
-- 策划增加需求 在回血的同时 更新阵容
function resetHp( type )
	logger:debug("resetHp : " .. type)
	AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
	if not WAMainView.getCanRestHp() then
		ShowNotice.showShellInfo(m_i18n[8122])
		return 
	end

	if tonumber(type) == 1 then
		if(WorldArenaModel.getNextResetCostBySilver() > UserModel.getSilverNumber()) then
			PublicInfoCtrl.createItemDropInfoViewByTid(60406, nil, true) -- 贝里掉落界面
			ShowNotice.showShellInfo("贝里不足")
			return
		end
	else
		if(UserModel.getGoldNumber()< WorldArenaModel.getNextResetCostByGold()) then
	  		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			return
		end
	end


	WAService.reset(type, function (tData)
		logger:debug({tData = tData})
		if tonumber(type) == 1 then
			WorldArenaModel.setHaveResetNumBySilver(WorldArenaModel.getHaveResetNumBySilver()+1)
			UserModel.addSilverNumber(-WorldArenaModel.getNextResetCostBySilver())
		else
			WorldArenaModel.setHaveResetNumByGold(WorldArenaModel.getHaveResetNumByGold()+1)
			UserModel.addGoldNumber(-WorldArenaModel.getNextResetCostByGold())
		end
		ShowNotice.showShellInfo("血量已回满，快去战斗吧")
		WAMainView.resetMyShip(tData)
	end)
end

-- 更新阵容信息
function onUpdateFmt(  )
	
end

-- 处理战斗结算面板
local isWin = nil

function showBattleResult( tRetData, player, tMyInfo, cur_conti_num, index)
	   	-- 正常可打
	   	logger:debug({player = player})
	   	logger:debug({tMyInfo = tMyInfo})
	   	logger:debug({cur_conti_num = cur_conti_num})
    	if(tRetData.ret == "ok")then
    		-- 战斗胜负判断
		   
		    if( tRetData.appraisal ~= "E" and tRetData.appraisal ~= "F" )then
		        isWin = true
		    else
		        isWin = false
		    end

		   local function updateUIAndFireAction(  )
		    	logger:debug({isWin_updateUIAndFireAction = isWin})
		    	if isWin then
		    		-- 先播放动画特效
		    		WAMainView.playFireEffect(index)
		    	else
		    		WAMainView.loadAll() -- 更新UI
		    	end
		    end
		    local tbBattleResultData = {}
		    tbBattleResultData.reward = tRetData.reward
		    tbBattleResultData.contiKill = tRetData.cur_conti_num
		    tbBattleResultData.preContiKill = cur_conti_num
		    tbBattleResultData.oppoPlayer = player
		    tbBattleResultData.myPlayer = tMyInfo
		    tbBattleResultData.callBack = updateUIAndFireAction
	    	if( WorldArenaModel.getSkipData())then
	    		local battleResultView = nil
	    		if isWin then 
	    			-- 胜利结算
	    			logger:debug("enterIsWin")
	    			battleResultView = WABattleWinCtrl.create(tbBattleResultData, nil, 1)
	    		else
	    			-- 失败结算
	    			logger:debug("enterIsLose")
	    			battleResultView = WABattleLoseCtrl.create(tbBattleResultData, nil, 1)
	    		end
	    		LayerManager.addLayout(battleResultView)
	    	else
	    		WAMainView.stopEffect()
	    		require "script/battle/BattleModule"
	    		local fightRet = tRetData.fightRet -- 战斗串
	    		BattleModule.playWABattleRecord(fightRet, function (  )
	    			
	    		end, tbBattleResultData)
	    	end
	    else
	    	
		end
end

-- 攻击某个玩家  服务器id  pid  是否跳过
function onAtk( player, tMyInfo, index)
	logger:debug("onAtk onAtk")
	local skip = WorldArenaModel.getSkipData()
	serverId = player.server_id
	pid = player.pid
	logger:debug({serverId = serverId, pid = pid, skip = skip})
	-- 1.攻击时间结束
	local curTime = TimeUtil.getSvrTimeByOffset(0)
	local atkEndTime = WorldArenaModel.getAttackEndTime()
	if( curTime >= atkEndTime )then
		ShowNotice.showShellInfo("活动已结束")
		return
	end
	-- 2.挑战次数
	local subAtkNum = WorldArenaModel.getAtkNum()
	if( subAtkNum <= 0 )then
		-- 您的剩余挑战次数不足，无法挑战。是否购买挑战次数？
		local alert = UIHelper.createCommonDlg("您的剩余挑战次数不足，无法挑战。是否购买挑战次数？", nil, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				LayerManager.removeLayout("WAATKALERT")
				onBuyAtkTimes()
			end
		end)
		alert:setName("WAATKALERT")
		LayerManager.addLayout(alert) 
		return
	end

	-- 3.挑战cd中
	if( WorldArenaModel.getAtkCD() > 0)then
		ShowNotice.showShellInfo("挑战CD中")
		return
	end
	local nSkip = 0
	if skip then
		nSkip = 1
	end

	WAService.attack(serverId, pid, nSkip, function ( tRetData )
		if(tRetData.ret == "out_range")then
			-- 排名发生变化
			ShowNotice.showShellInfo("对方排名发生变化")
		end

		if(tRetData.ret == "protect")then
			-- 在保护时间内
			ShowNotice.showShellInfo("对方在保护cd中")
		end
		local cur_conti_num = WorldArenaModel.getMyCurContiNum()
		-- 更新数据
		WorldArenaModel.updateWorldArenaInfo(tRetData)

		if tRetData.ret == "out_range" or  tRetData.ret == "protect" then
			WAMainView.loadAll() -- 更新UI
			return
		end

		if tRetData.ret == "ok" then
			showBattleResult(tRetData, player, tMyInfo, cur_conti_num,index)
		end
		
	end)
end

function create(...)
	WAMainView.create()
end

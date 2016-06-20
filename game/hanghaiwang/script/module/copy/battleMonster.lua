-- FileName: battleMonster.lua
-- Author: xianghuiZhang
-- Date: 2014-04-02
-- Purpose: 普通副本开始战斗前确认界面

module("battleMonster", package.seeall)

require "script/module/copy/copyData"
require "script/module/copy/fightMore"
require "script/module/public/ItemUtil"
require "db/DB_Stronghold"
require "script/network/Network"
require "script/model/user/UserModel"

-- UI控件引用变量 --
local copyWithLayer -- 普通战斗结算界面
local confirmBtn --确认按钮

-- 模块局部变量 --
local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local baseArmyId --进入的据点id
local baseItemInfo --进入的据点数据
local netItemInfo --网络返回的单个副本数据

local strAttkNum --剩余挑战次数
local nCostEnergy  --需要消耗体力值
local nStarNum --当前据点难度星数
local rewardKey --据点掉落物品key

local ndropCount = 5 --掉落总数量
local m_nMAXATKNUM = 10 -- 最多可以战10次, zhangqi, 2014-04-12 go
local tbScheduler = {} -- 模块用到的所有计时器
local copyDifficulty=1 --副本难度

-- ui文件名称 --
local copyWithDrop1 = "ui/copy_monster1_with_drop.json"
local copyWithDrop2 = "ui/copy_monster2_with_drop.json"
local copyWithDrop3 = "ui/copy_monster3_with_drop.json"

local copyWithoutDrop1 = "ui/copy_monster1_without_drop.json"
local copyWithoutDrop2 = "ui/copy_monster2_without_drop.json"
local copyWithoutDrop3 = "ui/copy_monster3_without_drop.json"

function moduleName()
	return "battleMonster"
end

--把控件绘制成灰色
local function fnGrayStar( tbWidget )
	for _,v in pairs(tbWidget) do
		UIHelper.setWidgetGray(v,true)
	end
end

--获取ui资源名称
local function fnGetUIName( ... )
	local dropName = "ui/copy_nodrop.json"
	rewardKey = "reward_item_id_simple"
	if (copyDifficulty==2) then
		rewardKey = "reward_item_id_normal"
	end
	if (copyDifficulty==3) then
		rewardKey = "reward_item_id_hard"
	end
	if (baseItemInfo[rewardKey] ~=nil) then
		dropName = "ui/copy_drop.json"
	end
	nStarNum = 3
	return dropName
end

-- 获取网络返回的攻打状态
local function fnGetAttStaus( infoId )
	local status = nil
	local vaInfo = netItemInfo.va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if ((tonumber(k) == tonumber(infoId)) and v[tostring(copyDifficulty)] and v[tostring(copyDifficulty)].status) then
			status = v[tostring(copyDifficulty)].status
		end
	end
	return status
end

-- 根据挑战难度获取当前消耗体力值
local function fnGetDepEnergy( hardLevel )
	local power = 0
	local stateNum = tonumber(hardLevel)
	if (stateNum >= 4 and baseItemInfo.cost_energy_hard ~= nil) then
		power = baseItemInfo.cost_energy_hard
	elseif (stateNum >= 3 and baseItemInfo.cost_energy_normal ~= nil) then
		power = baseItemInfo.cost_energy_normal
	else
		power = baseItemInfo.cost_energy_simple
	end
	return tonumber(power)
end

-- 根据战斗类型进行战斗,传入战斗等级，npc战为0级
local function fnToAttackArmy( hardLevel,firstBattle)
	logger:debug("copy hardLevel require ========="..hardLevel)
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		-- ShowNotice.showShellInfo("背包已满,请整理背包")
		return
	end

	--体力判断
	if (fnGetDepEnergy(hardLevel) <= UserModel.getEnergyValue()) then
		if (hardLevel ~= 0) then
			LayerManager.removeLayout() -- 如果不是NPC战会弹出战斗前面板，需要先remove掉
		end

		PreRequest.setIsCanShowAchieveTip(false) -- 设置如果有成就完成就不提示


		require "script/battle/BattleModule"
		
		BattleModule.playCopyStyleBattle(netItemInfo.copy_id, baseArmyId, hardLevel, getOneBattleCallback, COPY_TYPE_NORMAL ,firstBattle)
	else
		require "script/module/copy/copyUsePills"
		LayerManager.addLayout(copyUsePills.create())
	end
end

-- 初始函数，加载UI资源文件
function create( baseId,netInfo,difficulty)
	require "script/module/copy/copyWin"
	copyWin.battalCopyType=1 --战斗类型为普通副本

	logger:debug("battle Mosnster create fun vars===>>>>")
	logger:debug(baseId)
	logger:debug(netInfo)
	logger:debug(difficulty)
	logger:debug("battle Mosnster create fun vars===<<<<<")
	baseArmyId = baseId
	netItemInfo = netInfo
	copyDifficulty=tonumber(difficulty)
	baseItemInfo = DB_Stronghold.getDataById(baseArmyId)

	local attStatus = fnGetAttStaus(baseArmyId)
	--判断是否需要npc战，是则直接进入战斗
	if(tonumber(attStatus) <= 2 and baseItemInfo.npc_army_num_simple ~= nil and difficulty==1) then
		local firstBattle = tonumber(baseId)==1001 and true or false --是否是第一场战斗 并且是npc战
		fnToAttackArmy(0,firstBattle)
		return nil
	else
		logger:debug("json file: %s", fnGetUIName())
		copyWithLayer = g_fnLoadUI(fnGetUIName())
		if (copyWithLayer) then
			setUII18n(copyWithLayer)
			init()
		end
	end

	UIHelper.registExitAndEnterCall(copyWithLayer, function ( ... )
		copyWithLayer = nil
	end)

	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function()
					if (copyWithLayer) then
						init()
					end
				end,
				true
			)
	copyWithLayer.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playStrategy()
				local baseDb = DB_Stronghold.getDataById(baseId)
				local baseName = baseDb.name
				tbData={
			        type=1,-- 类型 普通副本＝1，精英副本＝2，觉醒副本＝3，深海＝4，世界boss＝5,
			        name = baseName, --据点名称（世界boss传boss名称，深海传当前层：第xx层）,
			        param1 = baseDb.copy_id, --普通副本，精英副本，觉醒副本传副本ID；深海传当前层数，世界boss传boss ID
			        param2 = baseId, --普通副本，觉醒副本传据点id ，其他模块不用传
			        param3 = difficulty, --普通副本 传据点难度，其他不需要
			        callback1 = nil,--攻略页面点查看战报时调用，可传nil，,   (用于世界boss处理音乐)
			        callback2 = nil, --查看战报战斗播放结束，结算面板关闭时调用，可传nil, (用于世界boss处理音乐)
			    }
				StrategyCtrl.create( tbData )
			end)
	return copyWithLayer
end
--国际化
function setUII18n(base)
	--TODO
	base.tfd_switch:setText(m_i18n[1370])
	base.tfd_limit:setText(m_i18n[1303])
	base.tfd_power:setText(m_i18n[4311])
	base.tfd_pass_reward:setText(m_i18n[5959])
end
--取消计时器
local function fnUnscheduler( ... )
	for _, sc in ipairs(tbScheduler) do
		if (sc and sc > 0) then
			logger:debug("fnUnscheduler: sc = %d", sc)
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(sc)
			sc = nil
		end
	end
end

--确认点击
local function onBackReurn( sender, eventType )
	logger:debug("zhangqi back")
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		fnUnscheduler()
		LayerManager.removeLayout()
	end
end

-- 获取攻打后的信息
function fnGetAttedInfo( infoId )
	logger:debug("==============fn get Atted =="..infoId)
	logger:debug(netItemInfo)
	local status = 0
	local attackNum = nil
	local star = 0
	local vaInfo = netItemInfo.va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if ((tonumber(k) == tonumber(infoId)) and v[tostring(copyDifficulty)]) then
			if (v[tostring(copyDifficulty)].status) then
				status = tonumber(v[tostring(copyDifficulty)].status)
			end
			if (v[tostring(copyDifficulty)].can_atk_num ~= nil) then
				attackNum = tonumber(v[tostring(copyDifficulty)].can_atk_num)
			end
			if (v[tostring(copyDifficulty)].score) then
				star = tonumber(v[tostring(copyDifficulty)].score)
			end
		end
	end

	if (attackNum == nil) then
		local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
		logger:debug("get attack num===")
		logger:debug(baseItemInfo.fight_times)
		logger:debug(baseItemInfo)
		logger:debug(fightTimes)
		logger:debug(copyDifficulty)
		attackNum = tonumber(fightTimes[tonumber(copyDifficulty)])
		logger:debug(attackNum)
	end
	return status,attackNum,star
end

-- 获取攻打后的信息 --伙伴掉落调用
function fnGetAttedInfoForYing( infoId ,va_copy_info,m_difficult)
	local difficult=tonumber(m_difficult)
	if (difficult==3) then
		if (not SwitchModel.getSwitchOpenState(ksSwitchHellCopy)) then
			return 0,0,0
		end
	end
	local status = 0
	local attackNum = nil
	local star = 0
	local vaInfo = va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if ((tonumber(k) == tonumber(infoId)) and v[tostring(difficult)]) then
			if (v[tostring(difficult)].status) then
				status = tonumber(v[tostring(difficult)].status)
			end
			if (v[tostring(difficult)].can_atk_num ~= nil) then
				attackNum = tonumber(v[tostring(difficult)].can_atk_num)
			end
			if (v[tostring(difficult)].score) then
				star = tonumber(v[tostring(difficult)].score)
			end
		end
	end

	if (attackNum == nil) then
		baseItemInfo = DB_Stronghold.getDataById(infoId)
		local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
		attackNum = tonumber(fightTimes[m_difficult])
	end
	return status,attackNum,star
end
-- 根据当前挑战难度获取当前消耗体力值
local function fnGetDepPower( state )
	local power = 0
	local stateNum = tonumber(state)
	if (stateNum >= 4 and baseItemInfo.cost_energy_hard ~= nil) then
		power = baseItemInfo.cost_energy_hard
	elseif (stateNum >= 3 and baseItemInfo.cost_energy_normal ~= nil) then
		power = baseItemInfo.cost_energy_normal
	else
		power = baseItemInfo.cost_energy_simple
	end
	return tonumber(power)
end

-- 获取怪物头像背景框
local function fnGetMonsterBorder( ... )
	local imgBorder
	--local copyItemFIle = "db/cxmlLua/copy_" .. netItemInfo.copy_id
	local copyItemFIle = "db/cxmlLua/copy_" .. netItemInfo.copy_id.."_"..copyDifficulty -- 引入全局变量 copy
	require(copyItemFIle)
	local normalTable = copy.models.normal
	for i,values in pairs(normalTable) do
		local armyId = values.looks.look.armyID
		local modelUrl = values.looks.look.modelURL
		if (tonumber(armyId) == tonumber(baseArmyId) and modelUrl ~= nil) then
			local nimgModel = lua_string_split(modelUrl,".swf")
			imgBorder = nimgModel[1]
		end
	end
	return imgBorder
end

-- 显示顶部信息中的星数
local function fnTopInfoStar( baseStar )
	local star1 = nil
	local star2 = nil
	local star3 = nil
	local baseStaus = 2+baseStar
	print("baseStausbaseStaus"..baseStaus.."nStarNum"..nStarNum)
	if(nStarNum > 2) then
		star3 = m_fnGetWidget(copyWithLayer, "IMG_STAR3", "ImageView")
	end
	if(nStarNum > 1) then
		star2 = m_fnGetWidget(copyWithLayer, "IMG_STAR2", "ImageView")
	end
	if(nStarNum > 0) then
		star1 = m_fnGetWidget(copyWithLayer, "IMG_STAR1", "ImageView")
	end

	local tbStarArr = {}
	if(star3) then
		if(baseStaus < 3) then
			table.insert(tbStarArr,star1)
			table.insert(tbStarArr,star2)
			table.insert(tbStarArr,star3)
		elseif(baseStaus < 4) then
			table.insert(tbStarArr,star2)
			table.insert(tbStarArr,star3)
		elseif(baseStaus < 5) then
			table.insert(tbStarArr,star3)
		end
	elseif(star2) then
		if(baseStaus < 3) then
			table.insert(tbStarArr,star1)
			table.insert(tbStarArr,star2)
		elseif(baseStaus < 4) then
			table.insert(tbStarArr,star2)
		end
	else
		if(baseStaus < 3) then
			table.insert(tbStarArr,star1)
		end
	end
	fnGrayStar(tbStarArr)
end

--更新挑战次数widget
local function fnShowBattleNum( attkNum )
	strAttkNum = attkNum
	local limitNum = m_fnGetWidget(copyWithLayer, "TFD_LIMIT_NUM", "Label")
	local limitNum2 = m_fnGetWidget(copyWithLayer, "TFD_LIMIT_NUM2")
	local limitNumCout = m_fnGetWidget(copyWithLayer, "TFD_LIMIT_NUM3")
	if  (limitNum) then
		UIHelper.labelStroke(limitNum)
		UIHelper.labelStroke(limitNum2)
		UIHelper.labelStroke(limitNumCout)
		limitNum:setText(strAttkNum .. "")
		local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
		limitNumCout:setText(fightTimes[copyDifficulty] .. "")
		if (tonumber(strAttkNum) <= 0) then
			limitNum:setColor(ccc3(0xd5,0x41,0x00))
		else
			limitNum:setColor(ccc3(0x00,0x93,0x11))
		end
	end
end

-- 顶部副本信息
local function fnTopCopyInfo( ... )
	local baseStaus,baseAttNum,baseStar = fnGetAttedInfo(baseArmyId) --获取据点信息
	local copyName = m_fnGetWidget(copyWithLayer, "TFD_NAME", "Label")
	if  (copyName) then
		copyName:setText(baseItemInfo.name)
		UIHelper.labelStroke(copyName)
		--UIHelper.labelShadow(copyName,CCSizeMake(4,-4))
	end

	--怪物头像设置
	local strimgBod = fnGetMonsterBorder()
	local copyFrame = m_fnGetWidget(copyWithLayer, "IMG_FRAME", "ImageView")
	copyFrame:setPositionType(POSITION_ABSOLUTE)
	if  (copyFrame and strimgBod ~= nil) then
		copyFrame:loadTexture(armyBorderPath..strimgBod..".png")
		if (tonumber(strimgBod)==1) then
			copyFrame:setPosition(ccp(0, -10))
		elseif  (tonumber(strimgBod)==2) then
			copyFrame:setPosition(ccp(0, -5))
		else
			copyFrame:setPosition(ccp(0, 1))
		end
	end

	local copyHeaderIcon = m_fnGetWidget(copyWithLayer, "IMG_HEAD", "ImageView")
	if  (copyHeaderIcon) then
		copyHeaderIcon:loadTexture(HeroheadPath..baseItemInfo.icon)
	end

	--显示星数
	fnTopInfoStar(baseStar)

	--挑战次数
	fnShowBattleNum(baseAttNum)

	--消耗体力
	nCostEnergy = fnGetDepPower(baseStaus)
	local powerNum = m_fnGetWidget(copyWithLayer, "TFD_POWER_NUM", "Label")
	if  (powerNum) then
		UIHelper.labelStroke(powerNum)
		powerNum:setText(nCostEnergy.."")
	end

end


--获取当前据点的重置次数
local function fnGetResetNum( ... )
	local resetNum = 0
	local vaInfo = netItemInfo.va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if (tonumber(k) == tonumber(baseArmyId)) then
			resetNum = v[""..copyDifficulty].reset_num==nil and 0 or tonumber(v[""..copyDifficulty].reset_num)
		end
	end
	logger:debug("reset battle time====="..resetNum)
	return resetNum;
end

--获取当前重置战斗次数花费的金币数量
local function fbResetFitGold( ... )
	local golds = 0
	require "db/DB_Normal_config"
	local dbNormalConfig = DB_Normal_config.getDataById(1)
	if (dbNormalConfig.clearFightTimesCost ~= nil) then
		local costGoldArr = lua_string_split(dbNormalConfig.clearFightTimesCost,"|")
		local resetNum = fnGetResetNum()
		print("resetNum"..resetNum)
		golds = tonumber(costGoldArr[1])
		if(resetNum > 0) then
			local maxCostGold = tonumber(costGoldArr[3])
			local curCost = resetNum * tonumber(costGoldArr[2]) + golds
			if (curCost < maxCostGold) then
				golds = curCost
			else
				golds = maxCostGold
			end
		end
	end

	return golds
end

--重置战斗次数
local function fnNoBattleNum( ... )
	local onRestTime = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (strAttkNum <= 0) then
				goldResetNum()
			else
				LayerManager.removeLayout()
				AudioHelper.playCommonEffect()
			end
		end
	end

	local layTip = g_fnLoadUI("ui/copy_buytimes.json")

	local i18n_reset1 = m_fnGetWidget(layTip, "tfd_can")
	i18n_reset1:setText(m_i18n[1376]) -- 2015-10-09

	local i18n_reset2 = m_fnGetWidget(layTip, "TFD_TIP_CONFIRM")
	i18n_reset2:setText(m_i18n[1335])

	local costGold = fbResetFitGold()
	local labGold = m_fnGetWidget(layTip, "TFD_TIP_INFO") -- 2015-10-09
	labGold:setText(costGold)

	local btnClose = m_fnGetWidget(layTip, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local btnCancel = m_fnGetWidget(layTip, "BTN_CANCEL")
	btnCancel:addTouchEventListener(UIHelper.onClose)
	UIHelper.titleShadow(btnCancel)

	local confirm = m_fnGetWidget(layTip, "BTN_ENSURE")
	confirm:addTouchEventListener(onRestTime)
	UIHelper.titleShadow(confirm)

	LayerManager.addLayout(layTip)

end

--传送战斗数据
local function goAttack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- AudioHelper.playCommonEffect()
		AudioHelper.playBtnEffect("start_fight.mp3") --进入战斗音效
		--战斗次数判断
		require "script/module/guide/GuideCtrl"
		require "script/module/guide/GuideCopy2BoxView"
	    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 20) then
	       GuideCtrl.setPersistenceGuide("copy2Box","end")
	       GuideCtrl.removeGuide()
	    end
			GuideCtrl.removeGuideView()
			if (strAttkNum > 0) then
				fnUnscheduler() -- 注销连战CD的定时器
				fnToAttackArmy(tonumber(copyDifficulty))
			else
				fnNoBattleNum()
			end
		end
end

-------------------------------消除cd
--关闭cd界面
local function fnCloseCdLayout( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.removeLayout()
		AudioHelper.playBackEffect()
	end
end

--获取当前清除cd花费的金币数量
local function fbGetClearGold( ... )
	local golds = 0
	require "db/DB_Normal_config"
	local dbNormalConfig = DB_Normal_config.getDataById(1)
	if (dbNormalConfig.clearFightCdCost ~= nil) then
		local costGoldArr = lua_string_split(dbNormalConfig.clearFightCdCost,"|")
		local sweepNum = DataCache.getClearSweepNum()
		golds = tonumber(costGoldArr[1])
		if(sweepNum > 0) then
			local maxCostGold = tonumber(costGoldArr[3])
			local curCost = sweepNum * tonumber(costGoldArr[2]) + golds
			if (curCost < maxCostGold) then
				golds = curCost
			else
				golds = maxCostGold
			end
		end
	end

	return golds
end

--去消除cd
local function fnGotoClear( sender, eventType  )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (UserModel.getGoldNumber() >= fbGetClearGold()) then
			requestClearCd()
		else
			--ShowNotice.showShellInfo(gi18n[1336])
			local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
		end
	end
end

--消除cd界面
local function fnClearCdLayer( ... )

	local clearCdLayout = g_fnLoadUI("ui/copy_buycd.json")
	local costGold = fbGetClearGold()
	local lbGold = m_fnGetWidget(clearCdLayout, "LABN_TIP_INFO")
	lbGold:setStringValue(costGold)

	local btnClose = m_fnGetWidget(clearCdLayout, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local btnCancel = m_fnGetWidget(clearCdLayout, "BTN_CANCEL")
	btnCancel:addTouchEventListener(UIHelper.onClose)
	UIHelper.titleShadow(btnCancel)

	local confirm = m_fnGetWidget(clearCdLayout, "BTN_ENSURE")
	confirm:addTouchEventListener(fnGotoClear)
	UIHelper.titleShadow(confirm)

	LayerManager.addLayout(clearCdLayout)
end

--消除cd值
local function fngoClearCd( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		print("touchedddddddd")
		if (UserModel.getVipLevel() >= 5) then
			fnClearCdLayer()
		else
			print("touchedddddddd222")
			ShowNotice.showShellInfo(gi18n[1941])
		end
	end
end

--开始10次战斗数据
local function goTenAttack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		local nDegree = sender:getTag() -- 难度等级
		local nAtkNum = sender.attackNum -- 连续攻击次数
		--[[
            缺背包满的判断
            缺CD
        ]]
        -- 判断等级限制
		if (UserModel.getHeroLevel() < 20) then --25级扫荡
			ShowNotice.showShellInfo(gi18n[1370])
			return
		end
		local baseStaus,baseAttNum,baseStar = fnGetAttedInfo(baseArmyId) --获取据点信息
		if (tonumber(baseStar)<3) then  --未通关时(baseStaus < 3) 改为未获得三星 (tonumber(baseStar)>=3)
			ShowNotice.showShellInfo(gi18n[1942])
			return
		end

		local tbUserInfo = UserModel.getUserInfo()
		-- 检查体力是否足够
		if (tonumber(tbUserInfo.execution) < (nAtkNum * nCostEnergy)) then
			require "script/module/copy/copyUsePills"
			LayerManager.addLayout(copyUsePills.create())
			--logger:debug("体力不足")
			-- 缺行动力的处理，吃体力丹等等
			return
		end
		-- 检查背包是否已满
		if (ItemUtil.isBagFull(true)) then
			--logger:debug("背包已满")
			-- ShowNotice.showShellInfo("背包已满")
			-- 背包整理的处理
			return
		end

		LayerManager.removeLayout() --liweidong 注册了OnExit方法，但没能把copyWithLayer置成空。放到前面
		copyWithLayer=nil  

		-- AudioHelper.playCommonEffect() 
		logger:debug("goTenAttack: baseLv = " .. nDegree)
		-- zhangqi, 2014-04-12
		-- array sweep (int $copyId, int $baseId, int $baseLv, int $num)
		local tbDebug = {netItemInfo.copy_id, baseItemInfo.id, nDegree, nAtkNum}
		logger:debug(tbDebug)

		require "script/module/switch/SwitchCtrl"
  		SwitchCtrl.postBattleNotification("BEGIN_BATTLE")
  		

		local args = Network.argsHandler(netItemInfo.copy_id, baseItemInfo.id, nDegree, nAtkNum)
		RequestCenter.copy_sweep(function ( cbFlag, dictData, bRet )
			logger:debug(dictData)
			if (bRet) then
				local attkNumEd = - tonumber(nAtkNum)
				print("attkNumEd"..attkNumEd)
				DataCache.addDefeatNumByCopyAndFort( netItemInfo.copy_id, baseArmyId, attkNumEd ,copyDifficulty) --剩余攻打次数
				DataCache.setSweepCoolTime(dictData.ret.sweepcd)
				local dlg = fightMore.create(baseItemInfo.id, nDegree, dictData.ret)
				local sc  = UIHelper.getAutoReleaseScheduler(dlg, fnCdNoBattle)
				table.insert(tbScheduler, sc)
				LayerManager.addLayout(dlg)
				--logger:debug("有没有升级")
				logger:debug(fightMore.isLevelUp())
				if (fightMore.isLevelUp()) then
					-- menghao
					--require "script/module/copy/copyData"
					require "script/module/public/GlobalNotify"
					GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,createTreasureNotice(dictData.ret.extra_rewardRet))
				end
			end
		end,
		args)
		
	end
end

--更新从无挑战次数变为有挑战次数后得界面
local function fnUpdateNoBattle( ... )
	for i=1,1 do
		local layHard = m_fnGetWidget(copyWithLayer, "LAY_HARD"..i)
		local attack10Btn = m_fnGetWidget(layHard, "BTN_ATTACK10"..i)
		if (attack10Btn:isEnabled()) then
			local attack10Title = m_fnGetWidget(attack10Btn, "TFD_ATTACK10".. i, "Label")
			local attack10Cd = m_fnGetWidget(attack10Btn, "TFD_CD".. i, "Label")
			if  (attack10Title and attack10Cd) then
				attack10Cd:setVisible(false)
				attack10Title:setVisible(true)
				attack10Btn:addTouchEventListener(goTenAttack)
			end
		end
	end
end

--连战冷却时间
function fnCdNoBattle( ... )
	if (not copyWithLayer) then -- zhangqi, 20140517, 添加据点信息面板是否存在的判断，避免定时器刷新连战CD找不到对象
		logger:debug("fnCdNoBattle, copyWithLayer not exist")
		return
	end
	logger:debug("copywithLayer:")
	logger:debug(copyWithLayer)
	if (DataCache.getSweepCoolTime() > tonumber(TimeUtil.getSvrTimeByOffset())) then
		local time_str = TimeUtil.getTimeString(DataCache.getSweepCoolTime() - TimeUtil.getSvrTimeByOffset() )
		for i=1,1 do
			local layHard = m_fnGetWidget(copyWithLayer, "LAY_HARD"..i)
			local attack10Btn = m_fnGetWidget(layHard, "BTN_ATTACK10"..i)
			if (attack10Btn:isEnabled()) then
				local attack10Title = m_fnGetWidget(attack10Btn, "TFD_ATTACK10".. i, "Label")
				local attack10Cd = m_fnGetWidget(attack10Btn, "TFD_CD".. i, "Label")
				if (DataCache.getSweepCoolTime() - TimeUtil.getSvrTimeByOffset() > 0) then
					if  (attack10Cd and attack10Title) then
						attack10Cd:setText(gi18n[1311].."\n"..time_str)
						attack10Cd:setVisible(true)
						attack10Btn:addTouchEventListener(fngoClearCd)
						attack10Title:setVisible(false)
					end
				end
			end
		end
	else
		fnUpdateNoBattle()
		fnUnscheduler()
	end
end

--处理通关条件
local function fnClearance( copyHardLayer,kv )
	local getMoney = m_fnGetWidget(copyWithLayer, "TFD_NUM_MONEY"..kv)
	-- local getCard = m_fnGetWidget(copyWithLayer, "LABN_CARD_NUM")

	if (getMoney) then
		local strTerms = lua_string_split(baseItemInfo.get_star_id, ",")
		local strTerm
		local strMoney
		-- local strCard
		local strExp
		
		if (copyDifficulty == 1) then
			local term = lua_string_split(strTerms[1], "|")
			strTerm=term[1]

			strMoney = baseItemInfo.coin_simple
			-- strCard = baseItemInfo.simple_exp_card
			strExp = baseItemInfo.exp_simple
		elseif (copyDifficulty == 2) then
			local term = lua_string_split(strTerms[2], "|")
			strTerm=term[1]

			strMoney = baseItemInfo.coin_normal
			-- strCard = baseItemInfo.normal_exp_card
			strExp = baseItemInfo.exp_normal
		elseif (copyDifficulty == 3) then
			local term = lua_string_split(strTerms[3], "|")
			strTerm=term[1]

			strMoney = baseItemInfo.coin_hard
			-- strCard = baseItemInfo.hard_exp_card
			strExp = baseItemInfo.exp_hard
		end
		if (getMoney ~= nil) then
			getMoney:setText(math.floor(strMoney*OutputMultiplyUtil.getMultiplyRateNum(copyDifficulty==1 and 9 or 10)/10000))
			-- getCard:setStringValue(lua_string_split(strCard, "|")[2])
			copyWithLayer.TFD_EXP_NUM:setText(math.floor(strExp*UserModel.getHeroLevel()*OutputMultiplyUtil.getMultiplyRateNum(copyDifficulty==1 and 9 or 10)/10000))

			-- local star2 = m_fnGetWidget(copyWithLayer, "IMG_CONDITION2")
			-- star2:setVisible(false)
			-- local star3 = m_fnGetWidget(copyWithLayer, "IMG_CONDITION3")
			-- star3:setVisible(false)
			-- local star4 = m_fnGetWidget(copyWithLayer, "IMG_CONDITION4")
			-- star4:setVisible(false)

			-- require "db/DB_Get_star"
			-- local getStarDb = DB_Get_star.getDataById(strTerm)
			-- local starn = m_fnGetWidget(copyWithLayer, "IMG_CONDITION"..getStarDb.type)
			-- -- starn:setVisible(true)
		end

	end
end

--根据难度等级进行攻击
local function fnAttackInfo( ... )
	local baseStaus,baseAttNum,baseStar = fnGetAttedInfo(baseArmyId) --获取据点信息
	for i=1,1 do
		--用户操作是否战斗
		local layHard = m_fnGetWidget(copyWithLayer, "LAY_HARD"..i, "Layout")
		local attackBtn = m_fnGetWidget(layHard, "BTN_ATTACK"..i, "Button")
		if  (attackBtn) then
			attackBtn:setTag(copyDifficulty)
			attackBtn:addTouchEventListener(goAttack)
			UIHelper.titleShadow(attackBtn,gi18n[1308])
		end

		--难度星数与10次攻击
		--local attackStar = m_fnGetWidget(layHard, "IMG_STAR"..i, "ImageView")

		local attack10Btn = m_fnGetWidget(layHard, "BTN_ATTACK10"..i, "Button")
		if  (attack10Btn) then

			local blShowAtt10 = false
			if (baseStaus >= 3) then
				blShowAtt10 = true
			end

			if (UserModel.getHeroLevel() < 20) then --25级扫荡
				attack10Btn:setBright(false)
				local sweepGold = m_fnGetWidget(layHard, "IMG_SWEEP_GOLD_BG")
				sweepGold:setVisible(false)
				attack10Btn:addTouchEventListener(goTenAttack)
				local attack10Cd = m_fnGetWidget(attack10Btn, "TFD_CD".. i, "Label")
				attack10Cd:setVisible(false)
				local labAtk10Title = m_fnGetWidget(attack10Btn, "TFD_ATTACK10" .. i, "Label") 
				UIHelper.labelShadow(labAtk10Title)
			else
				local switchImg = m_fnGetWidget(layHard, "IMG_SWITCH")
				switchImg:setVisible(false)
				
				local imgGoldBg = m_fnGetWidget(layHard, "IMG_SWEEP_GOLD_BG")

				local imgGold = m_fnGetWidget(layHard, "img_gold")
				local tfdClearNum = m_fnGetWidget(layHard, "LABN_CLEAR_NUM"..i)

				if (baseAttNum ~= 0) then
					-- zhangqi, 2014-04-12, 给战多次按钮添加可攻击次数的信息
					local labAtk10Title = m_fnGetWidget(attack10Btn, "TFD_ATTACK10" .. i, "Label")  -- 临时处理，需要改UI中的命名
					logger:debug("baseAttNum = ".. tostring(baseAttNum))
					local nCurAtkNum = baseAttNum > m_nMAXATKNUM and m_nMAXATKNUM or baseAttNum
					logger:debug("baseAttNum = ".. baseAttNum .. " nCurAtkNum = " .. nCurAtkNum)
					labAtk10Title:setText(string.format(gi18n[1307],nCurAtkNum))
					UIHelper.labelShadow(labAtk10Title)
					attack10Btn.attackNum = nCurAtkNum
					attack10Btn:setTag(copyDifficulty)

					if (DataCache.getSweepCoolTime() > tonumber(TimeUtil.getSvrTimeByOffset()) and blShowAtt10) then
						local time_str = TimeUtil.getTimeString(DataCache.getSweepCoolTime() - TimeUtil.getSvrTimeByOffset() )
						local attack10Cd = m_fnGetWidget(attack10Btn, "TFD_CD".. i, "Label")
						labAtk10Title:setVisible(false)
						attack10Cd:setVisible(true)
						imgGold:setVisible(true)
						tfdClearNum:setVisible(true)
						attack10Cd:setText(gi18n[1311].."\n"..time_str)
						tfdClearNum:setStringValue(""..fbGetClearGold())
						attack10Btn:addTouchEventListener(fngoClearCd)

						local sc = UIHelper.getAutoReleaseScheduler(copyWithLayer, fnCdNoBattle)
						table.insert(tbScheduler, sc)
						logger:debug("sc = %d", sc)
						imgGoldBg:setVisible(true)
					else
						-- tfdClearNum:setVisible(false)
						-- imgGold:setVisible(false)
						imgGoldBg:setVisible(false)
						attack10Btn:addTouchEventListener(goTenAttack)
						local attack10Cd = m_fnGetWidget(attack10Btn, "TFD_CD".. i, "Label")
						attack10Cd:setVisible(false)
					end
				else
					imgGoldBg:setVisible(false)
					local attack10Cd = m_fnGetWidget(attack10Btn, "TFD_CD".. i, "Label")
					attack10Cd:setVisible(false)
					local labAtk10Title = m_fnGetWidget(attack10Btn, "TFD_ATTACK10" .. i, "Label")
					labAtk10Title:setText(gi18n[1943])
					UIHelper.labelShadow(labAtk10Title)
					attack10Btn:addTouchEventListener(function( sender, eventType )
							if (eventType ~= TOUCH_EVENT_ENDED) then
								return
							end
							AudioHelper.playCommonEffect()
							fnNoBattleNum()
						end
						)
				end
			end

		end

		--通关条件
		fnClearance(layHard,i)

	end

end

--掉落预览
local function fnDropPreview( ... )
	if (baseItemInfo[rewardKey] ~= nil) then
		local tfdDrop = m_fnGetWidget(copyWithLayer, "tfd_drop")
		tfdDrop:setText(gi18n[1305])
		--UIHelper.labelShadow(tfdDrop)
		local _,otherRewardIds = OutputMultiplyUtil.getAdditionalDrop()
		local dropIdArr = lua_string_split(baseItemInfo[rewardKey],",")
		if (otherRewardIds) then
			for _,id in ipairs(otherRewardIds) do
				dropIdArr[#dropIdArr+1] = id
			end
		end
		-- local reward = RewardUtil.parseRewards(baseItemInfo[rewardKey])
		local cm,cd = math.modf(#dropIdArr/ndropCount)
		local cellCount = cm+(cd>0 and 1 or 0)
		local allCount = #dropIdArr
		if (cellCount>1) then
			copyWithLayer.img_num_reward:setSize(CCSizeMake(copyWithLayer.img_num_reward:getSize().width,copyWithLayer.img_num_reward:getSize().height+copyWithLayer.LSV_DROP:getSize().height))
			copyWithLayer.img_bg:setSize(CCSizeMake(copyWithLayer.img_bg:getSize().width,copyWithLayer.img_bg:getSize().height+copyWithLayer.LSV_DROP:getSize().height))
			copyWithLayer.LSV_DROP:setSize(CCSizeMake(copyWithLayer.LSV_DROP:getSize().width,copyWithLayer.LSV_DROP:getSize().height*2))
		end
		UIHelper.initListView(copyWithLayer.LSV_DROP)
		UIHelper.initListWithNumAndCell(copyWithLayer.LSV_DROP,cellCount)

		for idx=1,cellCount do
			local cell = copyWithLayer.LSV_DROP:getItem(idx-1)
			-- for i=1,ndropCount do
			-- 	local layDrop = m_fnGetWidget(cell, "LAY_DROP"..i, "Layout")
			-- 	local itemIdx = (idx-1)*ndropCount+i
			-- 	if (itemIdx<=allCount) then
			-- 		local layImage = m_fnGetWidget(layDrop, "IMG_"..i, "ImageView")
			-- 		layImage:addChild(reward[itemIdx].icon)
			-- 		local goodsTitle = m_fnGetWidget(layDrop, "TFD_NAME_"..i, "Label")
			-- 		goodsTitle:setText(reward[itemIdx].name)
			-- 		local color =  g_QulityColor[tonumber(reward[itemIdx].quality)]
			-- 		if(color ~= nil) then
			-- 			goodsTitle:setColor(color)
			-- 		end
			-- 	else
			-- 		layDrop:setVisible(false)
			-- 	end 
			-- end

			for n=1,ndropCount do
				local i = (idx-1)*ndropCount+n
				local layDrop = m_fnGetWidget(cell, "LAY_DROP"..n, "Layout")
				if(i <= #dropIdArr) then
					local dropIds = lua_string_split(dropIdArr[i],"|")
					if (dropIds[1] ~= nil) then
						local layImage = m_fnGetWidget(layDrop, "IMG_"..n, "ImageView")
						local soulItem,soulInfo = ItemUtil.createBtnByTemplateId(dropIds[1],
														function ( sender,eventType )
															if (eventType == TOUCH_EVENT_ENDED) then
																PublicInfoCtrl.createItemInfoViewByTid(tonumber(dropIds[1]))
															end
														end)
						soulItem:setTag(i)
						layImage:addChild(soulItem)
						local goodsTitle = m_fnGetWidget(layDrop, "TFD_NAME_"..n, "Label")
						if (goodsTitle) then
							UIHelper.labelEffect(goodsTitle,soulInfo.name)
							if (soulInfo.quality ~= nil) then
								local color =  g_QulityColor[tonumber(soulInfo.quality)]
								if(color ~= nil) then
									goodsTitle:setColor(color)
								end
							end
						end
					end
				else
					layDrop:setVisible(false)
				end
			end
		end
	end
end

-- 初始加载配置数据
function init( ... )
	--关闭按钮
	local closeBtn = m_fnGetWidget(copyWithLayer, "BTN_CLOSE")
	if  (closeBtn) then
		closeBtn:addTouchEventListener(onBackReurn)
	end

	fnTopCopyInfo() --显示据点头部信息

	fnDropPreview()-- 据点掉落预览

	fnAttackInfo()-- 根据难度等级进行攻击

	-- TODO 新手引导
	if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 10) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createPartnerAdvGuide(11)
	end

	require "script/module/guide/GuideFiveLevelGiftView"
	if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 15) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createkFiveLevelGiftGuide(16)
	end

	require "script/module/guide/GuideCopyBoxView"
    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 12) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopyBoxGuide(13)
    end

	require "script/module/guide/GuideCopy2BoxView"
    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 19) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopy2BoxGuide(20)
    end

end

--晚12点重置次数与时间
function resetNightConfig( ... )
	if (baseArmyId ~= nil and copyWithLayer) then
		init()
	end
end

function checkGuideBox(  )
	logger:debug("checkGuideBox checkGuideBox" )
	logger:debug("isFirstPassCopy_1_4 = %s", getFirstPasscopy4())
	logger:debug("isFirstPassCopy_1_5 = %s", getFirstPasscopy5())
		-- 领取副本 宝箱 奖励
	require "script/module/guide/GuideModel"		
	if (getFirstPasscopy4()) then
		require "script/module/guide/GuideCtrl"
		GuideModel.setGuideClass(ksGuideCopyBox)
		GuideCtrl.createCopyBoxGuide(1)
		GuideCtrl.setPersistenceGuide("copyBox","3")
		setFirstPasscopy4(false)
	end

	if (getFirstPasscopy5()) then
		require "script/module/guide/GuideCtrl"
		GuideModel.setGuideClass(ksGuideCopy2Box)
		GuideCtrl.createCopy2BoxGuide(1)
		GuideCtrl.setPersistenceGuide("copy2Box","3")
		setFirstPasscopy5(false)

	end
end


-----------数据请求返回处理
--[[
    @desc   战斗一次的回调
    @para   void
    @return void
--]]
--特殊情况下是否显示剧情对话，升级面板跳转到其他模块时不显示据点胜利对话 liweidong
local _showTalkInfoStauts = true
function getShowTalkInfoStauts()
	return _showTalkInfoStauts
end
function setShowTalkInfoStauts(status)
	_showTalkInfoStauts = status
end
function getOneBattleCallback( tbNewCopyBase, blisWin, tbextraReward )
	logger:debug({tbNewCopyBase = tbNewCopyBase})
	if(blisWin) then
		local baseStaus,baseAttNum = fnGetAttedInfo(baseArmyId) --获取据点信息
		require "script/module/talk/TalkCtrl"
		if (baseItemInfo.victor_dialog_id ~= nil and baseStaus < 3 and tonumber(itemCopy.copyDifficulty)==1 and getShowTalkInfoStauts()) then
			require "script/module/switch/SwitchCtrl"
			--liweidong 当打完某个据点后如果有对话 对话完之后再初始化据点列表，包括开启新副本动画等
			TalkCtrl.create(baseItemInfo.victor_dialog_id)
			TalkCtrl.setCallbackFunction(function()
											logger:debug("SwitchCtrl.setSwitchView()")
											resetCopyResult(tbNewCopyBase)
											logger:debug("SwitchCtrl.setSwitchView()")
											checkGuideBox()
											logger:debug("SwitchCtrl.setSwitchView()")
											SwitchCtrl.setSwitchView()
											end)
			SwitchCtrl.setSwitchViewByTalk()

		else
			resetCopyResult(tbNewCopyBase)
			checkGuideBox()
		end
	else
		require "script/module/talk/TalkCtrl"
		if (baseItemInfo.fail_dialog_id ~= nil) then
			TalkCtrl.create(baseItemInfo.fail_dialog_id)
		end
	end
end

--更新金币重置挑战次数后的数据处理
local function fnUpdateNetData( ... )
	local dataCopyList = DataCache.getReomteNormalCopyData()
	if (dataCopyList ~= nil) then
		local itemData = dataCopyList[tostring(netItemInfo.copy_id)]
		logger:debug(itemData)
		if (itemData ~= nil) then
			netItemInfo = itemData
		end
	end
end

--重置挑战次数回调
local function resetAtkNumCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		local costGold = fbResetFitGold()
		UserModel.addGoldNumber(-costGold)
		local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
		local fight_times = tonumber(fightTimes[copyDifficulty])

		local vaInfo = netItemInfo.va_copy_info.baselv_info[""..baseArmyId]
		if (vaInfo[tostring(copyDifficulty)].can_atk_num ~= nil) then
			vaInfo[tostring(copyDifficulty)].can_atk_num=fight_times
		end
		if (vaInfo[tostring(copyDifficulty)].reset_num ~= nil) then
			vaInfo[tostring(copyDifficulty)].reset_num=tonumber(vaInfo[tostring(copyDifficulty)].reset_num)+1
		else
			vaInfo[tostring(copyDifficulty)].reset_num=1
		end
		
		fnShowBattleNum(fight_times) --更新战斗次数界面
		fnUpdateNetData() --更新相关重置后的数据
		fnAttackInfo() --更新战斗难度界面
		LayerManager.removeLayout()
		ShowNotice.showShellInfo(gi18n[1944])
	end
end

--金币重置挑战次数
function goldResetNum()
	local costGold = fbResetFitGold()
	local userInfo = UserModel.getUserInfo()
	if(UserModel.getGoldNumber() >= costGold)then
		local args = Network.argsHandler(baseArmyId,copyDifficulty)
		print("_baseid_baseid_baseid", baseArmyId)
		RequestCenter.resetAtkNum(resetAtkNumCallback, args)
		AudioHelper.playBtnEffect("buttonbuy.mp3")
	else
		-- ShowNotice.showShellInfo(gi18n[1336])
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
		AudioHelper.playCommonEffect()
	end
end

--消除cd请求回调
local function clearCdCallback( cbFlag, dictData, bRet )
	if(bRet)then
		UserModel.addGoldNumber(- fbGetClearGold())
		DataCache.setSweepCoolTime(0)
		local sweepNum = DataCache.getClearSweepNum() + 1
		DataCache.setClearSweepNum(sweepNum)
		fnCdNoBattle()
		fnAttackInfo()
		LayerManager.removeLayout()
		ShowNotice.showShellInfo(gi18n[1945])
	end
end

--消除cd请求
function requestClearCd( ... )
	RequestCenter.clear_sweepCd(clearCdCallback)
end


-- 析构函数，释放纹理资源
function destroy( ... )

end

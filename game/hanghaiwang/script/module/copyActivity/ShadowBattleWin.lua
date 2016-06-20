-- FileName: ShadowBattleWin.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("ShadowBattleWin", package.seeall)

-- UI控件引用变量 --
local layMain=nil
-- 模块局部变量 --
local aCopyId=nil --副本id
local copyDifficult=nil --副本难度
local rewardItemId=nil --当前影子id
local rewardItemNum=nil--当前影子数量
local isAddExp=false --是否已经增加经验
local rewardExp=0  --记录奖励的经验，播放完特效再增加
local m_fnGetWidget =  g_fnGetWidgetByName
local m_i18n = gi18n
SchedulerType = {
	Silver_Scheduler = 1,
	Soul_Scheduler = 2,
	Exp_Scheduler = 3,
	ExpBar_Scheduler = 4
}
local m_bLvUpdated = nil
local labSilverNum
local labExpNum
local m_tbReward = nil
local  m_updateSoulTimeScheduler = nil
local  m_updateSilverTimeScheduler = nil
local  m_updateExpTimeScheduler = nil
local m_updateExpBarTimeScheduler = nil
local animationTime = 1.3
local m_expChangeNumber = 0
local m_nCount 		= 0  			--用来记录什么时候开始加经验  ==2de 时候开始加经验，弹升级面板
local m_nCurExp = 0

function destroy(...)
	package.loaded["ShadowBattleWin"] = nil
end

function moduleName()
    return "ShadowBattleWin"
end

-- 初始加载配置数据
function init( ... )
end
--当前界面是否显示
function isShow()
	return layMain and true or false
end
function addFanKa2Animation( open_card )
	local m_animationPath = "images/effect/fanka"
	local  fanka2Animation = UIHelper.createArmatureNode({
		filePath =m_animationPath .. "/fanka_02.ExportJson",
		-- plistPath = m_animationPath .. "/fanka_020.plist",
		-- imagePath = m_animationPath .. "/fanka_020.pvr",
		animationName = "fanka_02",
		loop = 1,
	-- fnMovementCall = animationCallBack,
	})
	fanka2Animation:setPosition(open_card:getSize().width/2, open_card:getSize().height / 2)
	
	fanka2Animation:setTag(102)
	open_card:addNode(fanka2Animation)
end
function addFanKa1Animation( open_card )
	open_card:removeChildByTag(100, true)
	open_card:removeNodeByTag(101)
	open_card:removeNodeByTag(102)
	local nameBg= m_fnGetWidget(layMain, "img_reward_namebg1")
	nameBg:setVisible(false)

	local function animationCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			addFanKa2Animation(open_card)
			local btnItem, tbInfo = ItemUtil.createBtnByTemplateIdAndNumber(rewardItemId, rewardItemNum,function ( sender,eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						PublicInfoCtrl.createItemInfoViewByTid(rewardItemId, rewardItemNum)
					end
				end)
			btnItem:setPosition(ccp(open_card:getSize().width/2, open_card:getSize().height / 2))
			open_card:addChild(btnItem,3,100)
			nameBg:setVisible(true)
			local nameLab= m_fnGetWidget(layMain, "TFD_ITEM1")
			nameLab:setText(tbInfo.name)
			if (tbInfo.quality ~= nil) then
				local color =  g_QulityColor2[tonumber(tbInfo.quality)]
				if(color ~= nil) then
					nameLab:setColor(color)
				end
			end
			addExpAfterCardAndExp()
		end
	end
	local m_animationPath = "images/effect/fanka"
	local  fanka1Animation = UIHelper.createArmatureNode({
		filePath =m_animationPath .. "/fanka_01.ExportJson",
		-- plistPath = m_animationPath .. "/fanka_010.plist",
		-- imagePath = m_animationPath .. "/fanka_010.pvr",
		animationName = "fanka_01",
		loop = 0,
		fnMovementCall = animationCallBack,
	})
	
	fanka1Animation:setPosition(open_card:getSize().width/2, open_card:getSize().height / 2)
	fanka1Animation:setTag(101)
	open_card:addNode(fanka1Animation)
end
function changeFanKaAnimation(  )
	local open_card = m_fnGetWidget(layMain, "LAY_CARD1")
	open_card:removeChildByTag(100, true)
	open_card:removeNodeByTag(200)
	local nameBg= m_fnGetWidget(layMain, "img_reward_namebg1")
	nameBg:setVisible(false)

	local function animationCallBack() --( armature,movementType,movementID )
		-- if(movementType == 1) then
		local btnItem, tbInfo = ItemUtil.createBtnByTemplateIdAndNumber(rewardItemId, rewardItemNum,function ( sender,eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemInfoViewByTid(rewardItemId, rewardItemNum)
				end
			end)
		btnItem:setPosition(ccp(open_card:getSize().width/2, open_card:getSize().height / 2))
		open_card:addChild(btnItem,3,100)
		nameBg:setVisible(true)
		local nameLab= m_fnGetWidget(layMain, "TFD_ITEM1")
		nameLab:setText(tbInfo.name)
		if (tbInfo.quality ~= nil) then
			local color =  g_QulityColor2[tonumber(tbInfo.quality)]
			if(color ~= nil) then
				nameLab:setColor(color)
			end
		end
		-- end
	end
	local m_animationPath = "images/effect/fanka"
	local  fanka1Animation = UIHelper.createArmatureNode({
		filePath =m_animationPath .. "/card_refresh_13.ExportJson",
		animationName = "card_refresh",
		loop = 0,
		--fnMovementCall = animationCallBack,
		fnFrameCall=function(bone, frameEventName, originFrameIndex, currentFrameIndex)
				if (frameEventName == "1") then
					animationCallBack()
				end
			end,
		fnMovementCall = function()
				ShowNotice.showShellInfo(m_i18n[3213]) --TODO"更换成功"
			end
		,
	})
	
	fanka1Animation:setPosition(open_card:getSize().width/2, open_card:getSize().height / 2)
	fanka1Animation:setTag(200)
	open_card:addNode(fanka1Animation)
end
function updateUI()
	local labGold = m_fnGetWidget(layMain, "TFD_GOLD_NUM")
	labGold:setText(MainCopyModel.getBuyChangeRewardGold(aCopyId))
end
--[[desc: 根据奖励的经验值更新结算面板的相应信息
    barWidget: 经验条控件
    labWidget: 经验条上经验值控件
    nAddExp: 奖励的经验值
	expString:经验条上的数值
    nPercent:百分比
    return: 2个结果，1是增加经验后是否升级，2是增加经验后的当前级别 
—]]


function create( copyId ,difficult, nBaseId, nDegree, tbReward)
	logger:debug({battletbReward=tbReward})
	local m_expChangeNumber = 0
	m_nCount 		= 0
	m_nCurExp = UserModel.getUserInfo().exp_num
	isAddExp=false
	aCopyId=copyId
	copyDifficult=difficult
	for key,val in pairs(tbReward.cur_drop_item) do
		rewardItemId=key
		rewardItemNum=val
	end
	MainCopyModel.initBuyChangeRewardTimes()
	init()
	m_tbReward = tbReward
	layMain = g_fnLoadUI("ui/acopy_new_win.json")
	if (layMain) then
		UIHelper.registExitAndEnterCall(layMain,
				function()
					AudioHelper.resetAudioState()  
					layMain=nil
					stopAllScheduler()
				end,
				function()
				end
			) 
		--动画完成之前添加屏蔽层
		local layoutShield = Layout:create()
		layoutShield:setTouchEnabled(true)
		layoutShield:setSize(g_winSize)
		layMain:addChild(layoutShield, 100, 999)

		UIHelper.labelNewStroke( layMain.LOAD_EXP.TFD_EXP, ccc3(0,0,0), 2 )
		UIHelper.labelNewStroke( layMain.TFD_ITEM1, ccc3(0,0,0), 2 )
		
		require "db/DB_Stronghold"
		local tbHold = DB_Stronghold.getDataById(nBaseId) --据点信息

		-- 怪物小队名称
		local labTeamName = m_fnGetWidget(layMain, "TFD_STRONGHOLD")
		labTeamName:setText(tbHold.name)

		labSilverNum = m_fnGetWidget(layMain, "TFD_MONEY")
		labSilverNum:setText("0") --("+" ..tbReward.silver)
		UserModel.addSilverNumber(tonumber(tbReward.silver))

		labExpNum = layMain.LAY_EFFECT2.TFD_EXP -- m_fnGetWidget(layMain, "TFD_EXP")
		labExpNum:setText("0") --("+" ..tbReward.exp)

		-- 等级
		local userLevel = UserModel.getUserInfo().level
		local maxUserLevel = UserModel.getUserMaxLevel()
		layMain.TFD_LV:setText(userLevel .. "级") --TODO
		layMain.IMG_MAX:setEnabled(false)
		-- if(tonumber(userLevel) >= maxUserLevel) then
		-- 	layMain.IMG_MAX:setEnabled(true)
		-- end
		rewardExp = tbReward.exp

		-- 经验条
		local nLevel = 0 -- 新等级
		local expString = ""
		local nPercent = 0 -- 经验进度

		m_bLvUpdated, nLevel, expString,nPercent = fnSetExp(layMain.LOAD_EXP, layMain.LOAD_EXP.TFD_EXP, tonumber(tbReward.exp or 0))
		--影藏物品名称
		local nameBg= m_fnGetWidget(layMain, "img_reward_namebg1")
		nameBg:setVisible(false)
		--领取奖励
		local btnConfirm = m_fnGetWidget(layMain, "BTN_CONFIRM1")
		btnConfirm:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				-- AudioHelper.playCommonEffect()
				-- AudioHelper.playSceneMusic("fight_easy.mp3")  
				-- AudioHelper.playMainMusic()
				AudioHelper.playBtnEffect("tansuo02.mp3")
				--访问刷新接口
				local arr = CCArray:create()
				arr:addObject(CCInteger:create(aCopyId))
				arr:addObject(CCInteger:create(copyDifficult))
				RequestCenter.getchangeActivityDropGet(function(cbFlag, dictData, bRet)
						if(dictData.ret~=nil and dictData.err=="ok")then
							LoginHelper.reloginState(false) --注销断线返回登陆 领取掉落影子的请求返回后调，清除状态
							local itemObj = ItemUtil.getItemById(rewardItemId)
							ShowNotice.showShellInfo(string.format(m_i18n[4379],itemObj.name)) --TODO "恭喜您获得%s影子"
							EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)

						end
					end,arr)
				
			end
		end)

		local function afterAnim()
			local layItem = m_fnGetWidget(layMain, "LAY_CARD1")
			addFanKa1Animation(layItem)
		end
		--更换奖励
		local btnChange = m_fnGetWidget(layMain, "BTN_CHANGE")
		layMain.TFD_CHANGE:setText("更换影子") --TODO
		UIHelper.labelNewStroke( layMain.TFD_CHANGE, ccc3(0x00,0x00,0x00), 2 )
		layMain.TFD_REWARD:setText("奖励物品") --TODO
		UIHelper.labelNewStroke( layMain.TFD_REWARD, ccc3(0x49,0x00,0x00), 3 )
		btnChange:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				-- AudioHelper.playCommonEffect()
				AudioHelper.playBtnEffect("buttonbuy.mp3")
				local needGold = MainCopyModel.getBuyChangeRewardGold(aCopyId)
				if (needGold ~= nil) then
					if(UserModel.getGoldNumber() >= needGold ) then
						--访问刷新接口
						local arr = CCArray:create()
						arr:addObject(CCInteger:create(aCopyId))
						arr:addObject(CCInteger:create(copyDifficult))
						RequestCenter.changeActivityDropGet(function(cbFlag, dictData, bRet)
								--设置按钮不可点击，防止多次点击多花金币
								btnChange:setTouchEnabled(false)
								performWithDelay(btnChange,function()
										btnChange:setTouchEnabled(true)
									end,1.0
									)
								if(dictData.ret~=nil and dictData.err=="ok")then
									UserModel.addGoldNumber(-needGold)
									MainCopyModel.addBuyChangeRewardTimes()
									for key,val in pairs(dictData.ret) do
										rewardItemId=key
										rewardItemNum=val
									end
									updateUI()
									changeFanKaAnimation()
								end
							end,arr)
					else
						--ShowNotice.showShellInfo(gi18n[1950])
						local noGoldAlert = UIHelper.createNoGoldAlertDlg()
						LayerManager.addLayout(noGoldAlert)

					end
				end
				
			end
		end)
		layMain.LAY_EFFECT1:setVisible(false)
		layMain.LAY_EFFECT2:setVisible(false)
		local tbWidgets = {layMain.LAY_EFFECT1,layMain.LAY_EFFECT2 }
		--战斗胜利动画
		local IMG_TITLE= m_fnGetWidget(layMain, "IMG_TITLE")
		local IMG_RAINBOW= m_fnGetWidget(layMain, "IMG_RAINBOW")
		local winAnimation = EffBattleWin:new({imgTitle = IMG_TITLE, imgRainBow = IMG_RAINBOW,callback=function()
					palyPropertyEffect(tbWidgets,function()
							beginAddReward()
							local actionArr = CCArray:create()
							actionArr:addObject(CCDelayTime:create(0.2))
							actionArr:addObject(CCCallFunc:create(function ( ... )
									afterAnim()
								end)
								)
							layMain:runAction(CCSequence:create(actionArr))
						end)
				end
			})
		--更新ui
		updateUI()
		--发送战报
		layMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
					if (eventType ~= TOUCH_EVENT_ENDED) then
						return
					end
					AudioHelper.playSendReport()
					local modName,baseName
					-- local baseDb = DB_Stronghold.getDataById(nBaseId)
					-- modName = gi18n[7808] --"日常副本"
					-- baseName = baseDb.name

					local db=DB_Activitycopy.getDataById(aCopyId)
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					modName = db.name --gi18n[7820] --"日常副本"
					baseName = baseDb.name
					
					UIHelper.sendBattleReport(BattleState.getBattleBrid( ),modName,baseName)
				end)
	end
	--播放背景音乐
	require "script/module/config/AudioHelper"
	AudioHelper.playMusic("audio/bgm/sheng.mp3",false)
	return layMain
end

--设置用户达到顶级之后的经验条显示
local function setMaxLevelUI( ... )
	if (layMain) then
		-- 等级
		local userLevel = UserModel.getUserInfo().level
		local maxUserLevel = UserModel.getUserMaxLevel()

		layMain.TFD_LV:setText(userLevel .. m_i18n[3643]) --TODO

		if(tonumber(userLevel) >= maxUserLevel) then
			layMain.LOAD_EXP.TFD_EXP:setVisible(false)

			layMain.LOAD_EXP.IMG_MAX:setEnabled(true)
			layMain.LOAD_EXP:setPercent(100)
		end
	end
end
function fnSetExp( barWidget, labWidget, nAddExp)

	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
	local nNewExpNum = (nExpNum + nAddExp)%nLevelUpExp -- 得到当前显示的经验值分子
	local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp; -- 获得经验后是否升级
	logger:debug("old level = " .. nCurLevel)
	nCurLevel = bLvUp and (nCurLevel + 1) or nCurLevel
	logger:debug("new level = " .. nCurLevel)
	nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 重新计算下一等级需要的经验值，作为分母

	-- UIHelper.labelAddStroke(labWidget, nNewExpNum .. "/" .. nLevelUpExp

	local expString = nNewExpNum .. "/" .. nLevelUpExp
	labWidget:setText(expString)
	local nPercent = intPercent(nNewExpNum, nLevelUpExp)
	barWidget:setPercent((nPercent > 100) and 100 or nPercent)

	return bLvUp, nCurLevel,expString,nPercent
end
--开始播放奖励相关特效果
function beginAddReward()
	--开始数字 翻滚计时器
	startScheduler(SchedulerType.Silver_Scheduler)
	startScheduler(SchedulerType.Exp_Scheduler)
	startScheduler(SchedulerType.ExpBar_Scheduler)
end

-- 根据类型启动scheduler （贝里 经验石 经验）
function startScheduler(schedulerType)
	if(m_updateSilverTimeScheduler == nil and schedulerType == SchedulerType.Silver_Scheduler) then
		m_updateSilverTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateSilverNumber,0.0, false)
	end

	if(m_updateExpTimeScheduler == nil and schedulerType == SchedulerType.Exp_Scheduler) then
		m_updateExpTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateExpNumber,0.0, false)
	end
	if(m_updateExpBarTimeScheduler == nil and schedulerType == SchedulerType.ExpBar_Scheduler) then
		m_updateExpBarTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateExpLine,0.0, false)
	end
end


-- -- 根据类型停止scheduler （贝里 经验石 经验）
function stopScheduler(schedulerType)
	if(m_updateSilverTimeScheduler and schedulerType == SchedulerType.Silver_Scheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateSilverTimeScheduler)
		m_updateSilverTimeScheduler = nil
	end

	if(m_updateExpTimeScheduler and schedulerType == SchedulerType.Exp_Scheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateExpTimeScheduler)
		m_updateExpTimeScheduler = nil
	end
	-- logger:debug(m_updateExpBarTimeScheduler .. ":schedulerType" .. schedulerType)
	if(m_updateExpBarTimeScheduler and schedulerType == SchedulerType.ExpBar_Scheduler)then
		logger:debug("stop expBarScheduler")
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateExpBarTimeScheduler)
		m_updateExpBarTimeScheduler = nil

		-- UserModel.addExpValue(tonumber(m_tbReward.exp or 0),"dobattle")
		addExpAfterCardAndExp(1)
		setMaxLevelUI()
	end
end

--更新贝里
function updateSilverNumber()
	--labSilverNum:setText(tostring(m_tbReward.silver or 0))
	local number = tonumber(labSilverNum:getStringValue())
	local silveNumber = tonumber(m_tbReward.silver)
	if(number ~= nil and number < silveNumber)then
		number = number + math.ceil(silveNumber/animationTime/30)
		labSilverNum:setText(tostring(number))
	else

		stopScheduler(SchedulerType.Silver_Scheduler)
		labSilverNum:setText(tostring(silveNumber))

		-- if ((not m_updateExpTimeScheduler) and (not m_updateSilverTimeScheduler)
		-- 	and (not m_updateSoulTimeScheduler) and (not m_updateExpBarTimeScheduler)) then
		-- 	layMain:setTouchEnabled(true)
		-- 	-- btnShare:setTouchEnabled(true)
		-- end
	end
end
--更新jingyan
function updateExpNumber()
	--labExpNum:setText(tostring(tbReward.exp or 0))
	local number = tonumber(labExpNum:getStringValue())
	local expNumber = tonumber(m_tbReward.exp)
	if(number ~= nil and number < expNumber)then
		number = number + math.ceil(expNumber/animationTime/30)
		labExpNum:setText(tostring(number))
	else

		stopScheduler(SchedulerType.Exp_Scheduler)
		labExpNum:setText(tostring(expNumber))

		-- if ((not m_updateExpTimeScheduler) and (not m_updateSilverTimeScheduler)
		-- 	and (not m_updateSoulTimeScheduler) and (not m_updateExpBarTimeScheduler)) then
		-- 	layMain:setTouchEnabled(true)
		-- 	-- btnShare:setTouchEnabled(true)
		-- end
	end
end
--暂停所有计时器，
function stopAllScheduler( ... )
	stopScheduler(SchedulerType.Exp_Scheduler)
	stopScheduler(SchedulerType.Silver_Scheduler)
	stopScheduler(SchedulerType.ExpBar_Scheduler)
end
function updateExpLine()
	local expNumber = tonumber(m_tbReward.exp)

	if(m_expChangeNumber < expNumber and expNumber > 0) then

		local tbUserInfo = UserModel.getUserInfo()
		local tUpExp = DB_Level_up_exp.getDataById(2)
		local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
		local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
		local nExpNum = tonumber(m_nCurExp) -- 当前的经验值

		m_expChangeNumber  =  m_expChangeNumber + expNumber/animationTime/30
		m_expChangeNumber = (m_expChangeNumber > expNumber) and expNumber or m_expChangeNumber

		local nNewExpNum = (nExpNum + m_expChangeNumber)
		local bLvUp = (nExpNum + m_expChangeNumber) >= nLevelUpExp; -- 获得经验后是否升级


		nCurLevel = bLvUp and (nCurLevel + 1) or nCurLevel
		if(bLvUp == true) then
			nNewExpNum = nNewExpNum - tUpExp["lv_" .. nCurLevel]
			layMain.TFD_LV:setText(nCurLevel .. m_i18n[3643]) --TODO
		end

		nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 重新计算下一等级需要的经验值，作为分母

		--最高级别
		local maxLevel  = UserModel.getUserMaxLevel()
		if(nCurLevel >= maxLevel) then
			nNewExpNum = 0
			m_expChangeNumber = expNumber
			--stopScheduler(SchedulerType.ExpBar_Scheduler)
		end

		--去掉小数点
		nNewExpNum =  math.floor(nNewExpNum)

		local expString = nNewExpNum .. "/" .. nLevelUpExp
		layMain.LOAD_EXP.TFD_EXP:setText(expString)

		local nPercent = nNewExpNum / nLevelUpExp * 100
		layMain.LOAD_EXP:setPercent((nPercent > 100) and 100 or nPercent)

	else
		stopScheduler(SchedulerType.ExpBar_Scheduler)
	end

end


--只有在翻牌结束并且经验计时器都走完了之后才会执行升级逻辑
function addExpAfterCardAndExp(addtype)
	m_nCount = m_nCount + 1
	if (addtype==1) then
		--增加经验
		if (not isAddExp) then
			isAddExp=true
			
			--增加经验并判断升级
			if (not UserModel.hasReachedMaxLevel()) then
				local nAddExp=tonumber(rewardExp or 0)

				local tbUserInfo = UserModel.getUserInfo()
				local tUpExp = DB_Level_up_exp.getDataById(2)
				local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
				local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
				local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
				local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp; -- 获得经验后是否升级
				if (bLvUp) then
					performWithDelay(layMain,function()
								require "script/module/public/GlobalNotify"
								GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,createTreasureNotice(BattleMainData.extra_rewardRet))
							end,
							0)
				end
				UserModel.addExpValue(nAddExp,"dobattle") --OutputMultiplyUtil.getDailyCopyRateNum(aCopyId)/10000
			end
			
		end
	end
	if(m_nCount >= 2) then
		layMain:removeChildByTag(999, true) --删除屏蔽层
	end
end

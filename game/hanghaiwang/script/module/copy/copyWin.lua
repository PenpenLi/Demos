-- FileName: copyWin.lua
-- Author: xianghuiZhang
-- Date: 2014-04-02
-- Purpose: 显示战斗后的结算模块
--[[ TODO List
1）升级时的特效以及面板的冲突，升级有单独的面板
2）顶部背光动画和“战斗胜利”标题打字特效
3）奖励数值翻动增加特效和经验条延长的动画
4）是否获得副本得分的逻辑判断，需要和策划确认UI
]]

module("copyWin", package.seeall)

require "script/GlobalVars"
require "script/utils/LuaUtil"
require "script/model/utils/HeroUtil"
require "script/module/copy/copyTreasure"
require "script/model/user/UserModel"
require "script/module/public/UIHelper"
require "script/module/public/EffectHelper"
require "db/DB_Level_up_exp"
-- UI控件引用变量 --
local layMain -- 普通战斗结算界面
local labTeamName -- 怪物小队名称 "TFD_NAME"


-- local laySimple -- 简单类型&星级 "LAY_HARD1"
-- local layNormal -- 普通类型星级 "LAY_HARD2"
-- local layHard -- 难度类型星级 "LAY_HARD3"
-- local layDegree -- 3种难度类型的引用变量

local labSilverNum -- 贝里数量 "TFD_MONEY_NUM"
local labSoulNum -- 将魂数量 "TFD_SOUL_NUM"
local labExpNum -- 经验数 "TFD_EXP_NUM"
local labLevel -- 等级数 "TFD_LV"
local barExp -- 经验条 "LOAD_EXP_BAR"
local labExp -- 经验条上数值 "TFD_EXP"
local labnExp --经验提上的数值分子
local labnExpDom --经验条上的数值分母
local img_slant  -- 经验条上分子和分母中间的斜杠
local IMG_MAX    --最大等级的图片
local lsvDrop -- 战利品ListView -- "LSV_TOTAL"
local layDrop -- 战利品列表的默认cell "LAY_DROP"
local layDrop1 -- 默认cell的左起第一个战利品占位layout "LAY_DROP1", 第二、三个最后的数字是2，3

local btnConfirm -- 确定按钮 "BTN_CONFIRM"
local btnShare -- 分享按钮 "BTN_SHARE"

local labTxtSilver -- 获得贝里提示，"tfd_money"
local labTxtSoul -- "tfd_soul"
local labTxtExp -- "tfd_exp"

local  m_updateSoulTimeScheduler = nil
local  m_updateSilverTimeScheduler = nil
local  m_updateExpTimeScheduler = nil
local m_updateExpBarTimeScheduler = nil

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local fnSetExp -- 设置经验值，经验条
local fnFillItemList -- 创建奖励物品列表
local fnSetStar -- 设置达成的难度星数
local tbDegreeStr = {"simple", "normal", "hard"}
local m_ROWITEM = 4 -- 掉落物品每行3个
local m_tbCopyStat -- 本次战斗结束的副本状态
local m_arAni1      -- 动画1
local m_arAni2      -- 动画2
local m_bLvUpdated = false -- 主角是否升级
local m_tbReward = nil
local animationTime = 0.3
local m_expChangeNumber = 0
local m_nCurExp = 0

local m_nItemIndex = 0
local m_tbDropItem = {}
local m_nCount 		= 0  			--用来记录什么时候开始加经验  ==2de 时候开始加经验，弹升级面板

SchedulerType = {
	Silver_Scheduler = 1,
	Soul_Scheduler = 2,
	Exp_Scheduler = 3,
	ExpBar_Scheduler = 4
}

isHaveTreasure = false --是否有天降宝物
local firstHellReward = false --首次通关
battalCopyType =1 --战斗类型 1为普通副本 2为精英副本 3为活动副本 4奇遇战斗

function moduleName()
	return "copyWin"
end

-- 初始加载配置数据
function init( ... )
	m_expChangeNumber = 0
	m_bLvUpdated = false
	m_nCurExp = 0

	m_tbDropItem = {}
	m_nItemIndex = 0
	m_nCount = 0
end
--设置用户达到顶级之后的经验条显示
local function setMaxLevelUI( ... )
	if (layMain) then
		-- 等级
		local userLevel = UserModel.getUserInfo().level
		local maxUserLevel = UserModel.getUserMaxLevel()

		labLevel = m_fnGetWidget(layMain,"TFD_LV")
		labLevel:setText(m_i18nString(4366, userLevel))

		if(tonumber(userLevel) >= maxUserLevel) then
			labnExp:setEnabled(false)

			IMG_MAX:setEnabled(true)
			barExp:setPercent(100)
		end
	end
end

--[[desc: liweidong 创建结果结算页面之前 判断是否需要显示天降宝物
    arg1: 和create参数相同
    return:  widget对象 
—]]
function showResult(nBaseId, nDegree, bScored, tbReward, tbCopyStat, sAppraise  )
	-- logger:debug("copy result ==============")
	-- logger:debug("copy degree=========="..nDegree)
	-- print("table n:" ..#(BattleMainData.extra_rewardRet))
	-- logger:debug(BattleMainData.extra_rewardRet)
	-- logger:debug("=======")
	-- logger:debug(tbReward)
	-- logger:debug(tbCopyStat)

	
	--炼狱副本首次通关
	-- logger:debug({BattleMainDatahell_reward=BattleMainData.hell_reward})
	-- if (BattleMainData.hell_reward and table.count(BattleMainData.hell_reward)>0) then
	-- if (firstHellReward) then --(tbReward.hell_reward==1) then	
	-- 	-- local baseItemInfo = DB_Stronghold.getDataById(nBaseId)
	-- 	local rewards = baseItemInfo.nightmare_first_reward
	-- 	local goodsTemp = RewardUtil.parseRewards(rewards,true)

	-- 	local layout = UIHelper.createRewardDlg(goodsTemp,function()
	-- 			LayerManager.removeLayout()
	-- 			local win = create( nBaseId, nDegree, bScored, tbReward, tbCopyStat, sAppraise )
	-- 			LayerManager.addLayout(win)
	-- 		end)
	-- 	layout.img_title_reward:loadTexture("images/copy/title_first_pass.png")
	-- 	return layout
	-- end
	return create( nBaseId, nDegree, bScored, tbReward, tbCopyStat, sAppraise )

end

--[[desc: 创建普通副本和精英副本战斗胜利结算面板
    nBaseId: 据点id
    nDegree: 难易程度
    bScored: 是否获得副本得分
    tbReward: table, doBattle接口返回结果的reward字段值
    tbCopyStat: table, 后端返回战斗结果里的 newcopyorbase 字段
    sAppraise: string, 战斗评价，2014-07-07，add by zhangqi
    return: widget对象
—]]
function create( nBaseId, nDegree, bScored, tbReward, tbCopyStat, sAppraise )

	--判断是否有宝物
	local num = 0
	if (BattleMainData.extra_rewardRet) then
		for _,v in pairs(BattleMainData.extra_rewardRet) do
			num=num+1
		end
	end
	if (num==0) then
		isHaveTreasure=false
	else
		isHaveTreasure=true
	end

	if (isHaveTreasure) then   --需要在结算面板中把天降宝物获得的奖励提前修改，因为可能不走天降宝物界面
		---[[修改天降宝物获得的数值奖励
		local treasureData = BattleMainData.extra_rewardRet
		local tmp = treasureData.silver and UserModel.addSilverNumber(tonumber(treasureData.silver))
		--]]
	end
	firstHellReward = false
	local baseItemInfo = DB_Stronghold.getDataById(nBaseId)
	if (battalCopyType==1 and tonumber(nDegree)==3) then
		itemCopyModel.subBellBattleTimes()
		local copyId = baseItemInfo.copy_id

		local curWorldData = DataCache.getNormalCopyData()
		local itemData=curWorldData.copy_list[""..copyId]
		local base = itemData.va_copy_info.baselv_info[tostring(nBaseId)]
		if (base~=nil and base["3"] and base["3"].status) then
			local status =tonumber(base["3"].status)
			if (status<3) then
				firstHellReward = true
			end
		end
	end
	
	logger:debug(tbReward)
	logger:debug(tbCopyStat)

	init()

	logger:debug("sAppraise = %s, nBaseId = %d, nDegree = %d", sAppraise, nBaseId, nDegree)
	m_tbReward = tbReward
	--用于保存用户的经验值
	m_nCurExp = UserModel.getUserInfo().exp_num

	if (battalCopyType==2 or battalCopyType==3 or battalCopyType==4) then
		layMain = g_fnLoadUI("ui/copy_win_elite.json")
	else
		layMain = g_fnLoadUI("ui/copy_win.json")
	end

	if (layMain) then
		m_tbCopyStat = tbCopyStat

		--影藏跳动背景
		-- local imgMoneybg = m_fnGetWidget(layMain, "img_money_bg")
		-- imgMoneybg:setVisible(false)
		-- local imgLevelbg = m_fnGetWidget(layMain, "img_lv_bg")
		-- imgLevelbg:setVisible(false)
		-- local pressLb = m_fnGetWidget(layMain, "tfd_press")
		-- pressLb:setVisible(false)
		-- 绑定确定按钮事件
		-- btnConfirm = m_fnGetWidget(layMain, "BTN_CONFIRM")
		-- --btnConfirm:setTouchEnabled(false)
		layMain:setTouchEnabled(false)
		-- UIHelper.titleShadow(btnConfirm, m_i18n[1029])
		layMain:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				-- AudioHelper.resetAudioState() --还原战斗前音乐状态
				AudioHelper.playCommonEffect()

				if (firstHellReward) then --(tbReward.hell_reward==1) then
					LayerManager.removeLayout()
					local baseItemInfo = DB_Stronghold.getDataById(nBaseId)
					local rewards = baseItemInfo.nightmare_first_reward
					local goodsTemp = RewardUtil.parseRewards(rewards,true)

					local layout = UIHelper.createRewardDlg(goodsTemp,function()
							if (isHaveTreasure) then
								LayerManager.removeLayout() --移除结算面板 发送通知到战斗后，让战斗移除天降宝物
								CCTextureCache:sharedTextureCache():removeUnusedTextures()
								BattleLayerManager.battleBaseLayer:getParent():setVisible(false)
								LayerManager.showItemHolder()
								local callback = function()
									EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
									require "script/module/copy/itemCopy"
									itemCopy.playCopyAudio() 
								end
								local treasureReward = copyTreasure.create(callback,BattleMainData.extra_rewardRet)
								LayerManager.addLayout(treasureReward)
							else
								logger:debug("EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)")
								SwitchCtrl.postBattleNotification("END_BATTLE") --  add by huxiaozhou 应大嘴需求增加
								EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
								if (battalCopyType ==1) then
									require "script/module/copy/itemCopy"
									itemCopy.playCopyAudio()
								elseif (battalCopyType==3 or battalCopyType==2) then   --日常副本音乐修改需求
									-- AudioHelper.playSceneMusic("fight_easy.mp3")
									AudioHelper.playMainMusic()
								else 
									AudioHelper.playMainMusic()
								end
							end
						end)
					layout.img_title_reward:loadTexture("images/copy/title_first_pass.png")
					LayerManager.addLayoutNoScale(layout)
				else
					logger:debug("isHaveTreasure = %s", isHaveTreasure)
					if (isHaveTreasure) then
						LayerManager.removeLayout() --移除结算面板 发送通知到战斗后，让战斗移除天降宝物
						CCTextureCache:sharedTextureCache():removeUnusedTextures()
						BattleLayerManager.battleBaseLayer:getParent():setVisible(false)
						LayerManager.showItemHolder()
						local callback = function()
							EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
							require "script/module/copy/itemCopy"
							itemCopy.playCopyAudio() 
						end
						local treasureReward = copyTreasure.create(callback,BattleMainData.extra_rewardRet)
						LayerManager.addLayout(treasureReward)
					else
						logger:debug("EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)")
						SwitchCtrl.postBattleNotification("END_BATTLE") --  add by huxiaozhou 应大嘴需求增加
						EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
						if (battalCopyType ==1) then
							require "script/module/copy/itemCopy"
							itemCopy.playCopyAudio()
						elseif (battalCopyType==3 or battalCopyType==2) then   --日常副本音乐修改需求
							-- AudioHelper.playSceneMusic("fight_easy.mp3")
							AudioHelper.playMainMusic()
						else 
							AudioHelper.playMainMusic()
						end
					end
				end
			end
		end)

		-- btnShare = m_fnGetWidget(layMain, "BTN_SHARE") -- [1333] = "分享",
		-- btnShare:setTouchEnabled(false)
		-- UIHelper.titleShadow(btnShare, m_i18n[1333])

		require "db/DB_Stronghold"
		local tbHold = DB_Stronghold.getDataById(nBaseId) --据点信息

		-- 怪物小队名称
		labTeamName = m_fnGetWidget(layMain, "TFD_NAME")
		labTeamName:setText(tbHold.name)
		UIHelper.labelNewStroke( labTeamName, ccc3(0x80,0x00,0x00), 3 )
		--UIHelper.labelNewStroke( labTeamName, ccc3(0xf9,0xde,0xb5), 2 )
		--UIHelper.labelShadow(labTeamName, CCSizeMake(4, -4))
		--UIHelper.labelStroke(labTeamName)

		local i18nReward = m_fnGetWidget(layMain, "tfd_reward") -- [1330] = "获得战利品",
		-- UIHelper.labelAddStroke(i18nReward, m_i18n[1330])
		UIHelper.labelNewStroke( i18nReward, ccc3(0x49,0x00,0x00), 3 )
		-- 怪物小队难度及星数
		fnSetStar(tbHold, nDegree, bScored)

		labSilverNum = m_fnGetWidget(layMain, "TFD_MONEY_NUM")
		labSilverNum:setText(tostring(0))

		-- 经验
		labExpNum = m_fnGetWidget(layMain, "TFD_EXP_NUM")
		labExpNum:setText(0)

		-- 等级
		local userLevel = UserModel.getUserInfo().level
		labLevel = m_fnGetWidget(layMain, "TFD_LV")
		labLevel:setText(m_i18nString(4366, userLevel))

		-- 经验条
		local nLevel = 0 -- 新等级
		local expString = ""
		local nPercent = 0 -- 经验进度
		barExp = m_fnGetWidget(layMain, "LOAD_EXP_BAR")
		--labExp = m_fnGetWidget(layMain, "TFD_EXP")
		labnExp = m_fnGetWidget(barExp,"TFD_EXP")
		UIHelper.labelNewStroke( labnExp, ccc3(0x28,0x00,0x00), 2 )
		-- labnExp = m_fnGetWidget(layMain,"LABN_EXP1")
		-- labnExpDom = m_fnGetWidget(layMain,"LABN_EXP2")
		-- img_slant  = m_fnGetWidget(layMain,"img_slant")
		IMG_MAX = m_fnGetWidget(layMain,"IMG_MAX")
		IMG_MAX:setEnabled(false)
		-- ,nNewExpNum,nLevelUpExp,nPercent
		m_bLvUpdated, nLevel, expString,nPercent = fnSetExp(barExp, labExp, tonumber(tbReward.exp or 0))
		setExpBaseLine()

		-- 战斗力
		local labFight = m_fnGetWidget(layMain, "tfd_zhandouli")
		--UIHelper.labelNewStroke( labFight, ccc3(0xff,0xcd,0x75), 2 )
		local labnFightNum = m_fnGetWidget(layMain, "TFD_ZHANDOULI_NUM")
		labnFightNum:setText(tostring(UserModel.getFightForceValue()))

		--修改缓存信息
		UserModel.addSilverNumber(tonumber(tbReward.silver or 0))
		local levelStr = tbDegreeStr[nDegree] or tbDegreeStr[1]
		local costEnegy = (nDegree == 0) and 0 or (tbHold["cost_energy_" .. levelStr] or 0) --策划确认NPC战(难度为0)不扣体力
		if (battalCopyType~=3 and battalCopyType~=4) then
			if (battalCopyType==2) then --精英副本
				UserModel.addEnergyValue(-1*tonumber(battleEliteMonster.getEliteConstEnergy())) -- 减少体力
			else --普通副本
				UserModel.addEnergyValue(-1*tonumber(costEnegy)) -- 减少体力
			end
		end
		-- 获得武将和物品
		lsvDrop = m_fnGetWidget(layMain, "LSV_TOTAL")
		lsvDrop:setTouchEnabled(false)
		layDrop = m_fnGetWidget(lsvDrop, "LAY_DROP")
		fnFillItemList(tbReward.hero, tbReward.item) -- 填充武将或物品列表

		local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_continue.ExportJson",
			animationName = "fadein_continue",
			loop = 1,
		})
		armature2:setAnchorPoint(ccp(layMain.IMG_FADEIN_EFFECT:getAnchorPoint().x, layMain.IMG_FADEIN_EFFECT:getAnchorPoint().y))
		armature2:setPosition(ccp(layMain.IMG_FADEIN_EFFECT:getPositionX(), layMain.IMG_FADEIN_EFFECT:getPositionY()))
		layMain:addNode(armature2)
		
	end

	-- add by huxiaozhou 2014-11-26  成就系统新成就达成延时处理关闭结算面板后弹出
	UIHelper.registExitAndEnterCall(layMain, function ( ... )
												stopAllScheduler()
												layMain = nil
											 end,
											 function ( ... )
												logger:debug("copyWin onenter")
												if (not isHaveTreasure) then
													PreRequest.setIsCanShowAchieveTip(true)
												end
											 end)
	
	--liweidong 结算面板增加屏蔽层，当动画结束后才可点击
	performWithDelay(layMain,function()
					local layout = Layout:create()
					layout:setName("copy_result_layout")
					LayerManager.addLayoutNoScale(layout)
				end,
				0.01)
	--播放背景音乐
	require "script/module/config/AudioHelper"
	AudioHelper.playEffect("audio/bgm/sheng.mp3",false)
	--发送战报
	-- if (battalCopyType==4) then
	-- 	layMain.BTN_REPORT:setTouchEnabled(false)
	-- end

	local tbname = { gi18n[7821],gi18n[7822],gi18n[7823] }   -- 副本简单级  副本困难级  副本炼狱级

	layMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playSendReport()
				-- nDegree
				local modName,baseName
				if (battalCopyType==1) then
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					local copyDb = DB_Copy.getDataById(baseDb.copy_id)
					modName = tbname[nDegree<1 and 1 or nDegree] .. copyDb.name
					baseName = baseDb.name
				end
				if (battalCopyType==2) then
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					modName = gi18n[7809] --"精英副本"
					baseName = baseDb.name
				end
				if (battalCopyType==3) then
					local db=DB_Activitycopy.getDataById(ChanglageMonster.getCopyId())
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					modName = db.name --gi18n[7808] --"日常副本"
					baseName = baseDb.name
				end
				if (battalCopyType==4) then
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					modName = gi18n[7820] --"奇遇战斗"
					baseName = baseDb.name
				end
				UIHelper.sendBattleReport(BattleState.getBattleBrid( ),modName,baseName)
			end)
	return layMain
end -- end for create

-- 析构函数，释放纹理资源
function destroy( ... )
-- body
end

function checkUpgrade( ... )
	if (m_bLvUpdated) then -- 如果升级播放升级特效，显示升级信息面板
		logger:debug("level updated !")
		-- require "script/module/public/GlobalNotify"
		-- GlobalNotify.postNotify(GlobalNotify.LEVEL_UP)
	end
end

--只有在翻牌结束并且经验计时器都走完了之后才会执行升级逻辑
local function addExpAfterCardAndExp(addtype)
	m_nCount = m_nCount + 1
	if (addtype==1) then
		UserModel.addExpValue(tonumber(m_tbReward.exp or 0),"dobattle")
		setMaxLevelUI()
	end
	if(m_nCount >= 2) then
		LayerManager.removeLayoutByName("copy_result_layout")
		if (battalCopyType==4) then
			LayerManager.addUILayer()
			performWithDelay(layMain,function()
					LayerManager.removeUILayer()
				end,
				1.0)
		end
		if(m_bLvUpdated) then
			performWithDelay(layMain,function()
					require "script/module/public/GlobalNotify"
					GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,createTreasureNotice(BattleMainData.extra_rewardRet))
				end,
				0.1)
			
		end	

		layMain:setTouchEnabled(true)
		-- layMain:setEnabled(true)
		-- btnShare:setTouchEnabled(true)
	end
end
--翻牌关键帧的逻辑调用（关键帧之后破防下一个item的动画
local function playNextFrameEffect( bone, frameEventName, originFrameIndex, currentFrameIndex)

	    if (frameEventName == "1") then 
	    	-- AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
	    	--if(m_nItemIndex <= #m_tbDropItem) then
	    		--掉落物品名字
		    	local labName  =  m_tbDropItem[m_nItemIndex].labName
		    	labName:setEnabled(true)
		    	--掉落物品的标识（伙伴碎片，装备碎片）
		    	local imgFlag = m_tbDropItem[m_nItemIndex].imgFlag	
		    	if(imgFlag) then
		    		imgFlag:setVisible(true)
		    	end
		    	local btnItem = m_tbDropItem[m_nItemIndex].btnItem
		    	btnItem:setTouchEnabled(true)
		    	m_nItemIndex = m_nItemIndex + 1
		   -- end

	    	if(m_nItemIndex == 1) then
				-- local effectNode = m_tbDropItem[m_nItemIndex].effectNode
				-- effectNode:getAnimation():play("win_drop", -1, -1, 0)

				--  local itemImage =  m_tbDropItem[m_nItemIndex].btnItem
				-- -- effectNode:getAnimation():setSpeedScale(0.051)
   	-- 			 effectNode:getBone("win_drop_3"):addDisplay(itemImage, 0) -- 替换 关键帧
 				addExpAfterCardAndExp()
	    	else
	    			logger:debug("掉落物品的动画波到最后一个了")
	    			-- addExpAfterCardAndExp()
				
	    	end

	    end
end
--开始播放翻牌动画
function startPlayDropItemEffect( ... )

	if(table.isEmpty(m_tbDropItem)) then
		--都会掉经验卡牌，所以理论上不会走一下逻辑
		-- if(m_bLvUpdated) then
		-- 	--require "script/module/copy/copyData"
		-- 	require "script/module/public/GlobalNotify"
		-- 	GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,createTreasureNotice(BattleMainData.extra_rewardRet))
		-- end

		layMain:setTouchEnabled(true)
		-- btnShare:setTouchEnabled(true)
		return 
	end
	-- AudioHelper.playSpecialEffect("texiao_fanpai_wupin.mp3")
	m_nItemIndex = 1

	for i,v in ipairs(m_tbDropItem) do
		local firstEffectNode = m_tbDropItem[i].effectNode
		firstEffectNode:getAnimation():play("win_drop", -1, -1, 0)
		local itemImage =  m_tbDropItem[i].btnItem
	    firstEffectNode:getBone("win_drop_3"):addDisplay(itemImage, 0) -- 替换 

	end
	AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
	addExpAfterCardAndExp()
end
--添加默认的卡牌背面动画
local function addCardEffect( effectItemBg )

    local tbParams = {
					filePath  = "images/effect/battle_result/win_drop.ExportJson",
					animationName = "win_drop", 
					fnFrameCall = playNextFrameEffect,            
                    }


    local effectNode = UIHelper.createArmatureNode(tbParams)

    effectItemBg:addNode(effectNode)
    effectNode:getAnimation():gotoAndPause(1)
    return effectNode
end

--[[desc: 用掉落武将信息和物品信息填充战利品列表
    tbHero: array, 武将信息
    tbItem: array, 物品信息
    return:   
—]]
fnFillItemList = function ( tbHero, tbItem )
	require "script/module/public/PublicInfoCtrl"

	local tbHtids = {}
	--排序 1宝物
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isTreasure) then
			if (v.num==nil) then
				v.num=tonumber(v.item_num)
			end
			table.insert(tbHtids, {tid = v.item_template_id, num = v.num})
			table.remove(tbItem,_)
		end
	end
	--排序 2宝物碎片
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isTreasureFragment) then
			if (v.num==nil) then
				v.num=tonumber(v.item_num)
			end
			table.insert(tbHtids, {tid = v.item_template_id, num = v.num})
			table.remove(tbItem,_)
		end
	end
	--排序 3装备
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isArm) then
			if (v.num==nil) then
				v.num=tonumber(v.item_num)
			end
			table.insert(tbHtids, {tid = v.item_template_id, num = v.num})
			table.remove(tbItem,_)
		end
	end
	--排序 4装备碎片
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isFragment) then
			if (v.num==nil) then
				v.num=tonumber(v.item_num)
			end
			table.insert(tbHtids, {tid = v.item_template_id, num = v.num})
			table.remove(tbItem,_)
		end
	end
	--排序 5影子
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isHeroFragment) then
			if (v.num==nil) then
				v.num=tonumber(v.item_num)
			end
			table.insert(tbHtids, {tid = v.item_template_id, num = v.num})
			table.remove(tbItem,_)
		end
	end

	-- 没有封装武将头像按钮的方法，暂时不处理掉落武将的情况
	for _, v in ipairs(tbHero or {}) do
		-- table.insert(tbHtids, {htid = v.htid})
		if (v.num==nil) then
			v.num=tonumber(v.item_num)
		end
		table.insert(tbHtids, {tid = v.htid, num = v.num}) -- zhangqi, 2014-07-10, 伙伴唯一性需求保证掉落的只会是影子（伙伴碎片），属于物品
	end



	for _, v in ipairs(tbItem or {}) do
		if (v.num==nil) then
			v.num=tonumber(v.item_num)
		end
		table.insert(tbHtids, {tid = v.item_template_id, num = v.num})
	end
	logger:debug(tbHtids)

	local nHtidCount = #tbHtids
	local nRowCount = math.floor(nHtidCount/m_ROWITEM) + (nHtidCount%m_ROWITEM > 0 and 1 or 0)
	lsvDrop:setTouchEnabled(nRowCount > 1) -- 超过1行列表允许滑动
	logger:debug("nHtidCount = %d, nRowCount = %d", nHtidCount, nRowCount)

	m_tbDropItem = nil
	m_tbDropItem = {}

	UIHelper.initListView(lsvDrop)
	local cell
	for i = 0, nRowCount - 1 do -- 从 0 开始，方便tbHtids的一维索引变二维
		lsvDrop:pushBackDefaultItem()
		cell = lsvDrop:getItem(i)  -- cell 索引从 0 开始

		for j = 1, m_ROWITEM do
			local tbTid = tbHtids[j+i*m_ROWITEM]
			if (tbTid) then
				logger:debug("i = %d, j = %d, htid = %d", i, j, tonumber(tbTid.htid) or tonumber(tbTid.tid))
				local layItem = m_fnGetWidget(cell, "LAY_DROP" .. j)
				local tbInfo, btnItem
				if (tbTid.htid) then -- 是hero
						btnItem, tbInfo = HeroUtil.createHeroIconBtnByHtid(tbTid.htid,function ( sender,eventType )
							if (eventType == TOUCH_EVENT_ENDED) then
								PublicInfoCtrl.createItemInfoViewByTid(tonumber(tbTid.htid),tbTid.num)
							end
						end
						,tbTid.num)
					layItem:setTag(tonumber(tbTid.htid))

				else
					btnItem, tbInfo = ItemUtil.createBtnByTemplateIdAndNumber(tbTid.tid, tbTid.num,function ( sender,eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							PublicInfoCtrl.createItemInfoViewByTid(tonumber(tbTid.tid),tbTid.num)
						end
					end)
					layItem:setTag(tonumber(tbTid.tid))
				end

				--临时注释掉 功能还要加上
				-- if (tbInfo.isTreasureFragment) then
				-- 	--装备和宝物碎片tip移动到右上角
				-- 	local frag = btnItem:getChildByTag(10)
				-- 	frag:removeFromParentAndCleanup(true)
				-- 	local imgLight = ImageView:create()
				-- 	imgLight:loadTexture("images/copy/tip/tip_treasure.png")
				-- 	imgLight:setPosition(ccp(btnItem:getContentSize().width/2, 36))
				-- 	btnItem:addChild(imgLight, 10,10)
				-- end
				-- if (tbInfo.isFragment) then
				-- 	--装备和宝物碎片tip移动到右上角
				-- 	local frag = btnItem:getChildByTag(10)
				-- 	frag:removeFromParentAndCleanup(true)
				-- 	local imgLight = ImageView:create()
				-- 	imgLight:loadTexture("images/copy/tip/tip_equipment.png")
				-- 	imgLight:setPosition(ccp(btnItem:getContentSize().width/2, 36))
				-- 	btnItem:addChild(imgLight, 10,10)
				-- end
				-- if (tbInfo.isTreasure) then
				-- 	--装备和宝物碎片tip移动到右上角
				-- 	-- local frag = btnItem:getChildByTag(10)
				-- 	-- frag:removeFromParentAndCleanup(true)
				-- 	local imgLight = ImageView:create()
				-- 	imgLight:loadTexture("images/copy/tip/tip_treasure.png")
				-- 	imgLight:setPosition(ccp(btnItem:getContentSize().width/2, 36))
				-- 	btnItem:addChild(imgLight, 10,10)
				-- end
				-- if (tbInfo.isArm) then
				-- 	--装备和宝物碎片tip移动到右上角
				-- 	-- local frag = btnItem:getChildByTag(10)
				-- 	-- frag:removeFromParentAndCleanup(true)
				-- 	local imgLight = ImageView:create()
				-- 	imgLight:loadTexture("images/copy/tip/tip_equipment.png")
				-- 	imgLight:setPosition(ccp(btnItem:getContentSize().width/2, 36))
				-- 	btnItem:addChild(imgLight, 10,10)
				-- end
				

				local imgDef = m_fnGetWidget(layItem, "IMG_" .. j)
				imgDef:addChild(btnItem)

				btnItem:setTouchEnabled(false)

				local labName = m_fnGetWidget(layItem, "TFD_NAME_" .. j)
				labName:setText(tbInfo.name)
				UIHelper.labelNewStroke( labName, ccc3(0x28,0x00,0x00), 2 )

				-- UIHelper.labelEffect(labName, tbInfo.name)

				labName:setEnabled(false)

				--显示背面卡牌
				local effectNode = addCardEffect(imgDef)
				
				local tbData = {}
				tbData.labName = labName
				tbData.btnItem = btnItem
				tbData.effectNode = effectNode

				local imgFlag = nil 
				imgFlag = btnItem:getChildByTag(10)
				if(imgFlag) then
					imgFlag:setVisible(false)
					tbData.imgFlag = imgFlag
				end

				table.insert(m_tbDropItem,tbData)

				logger:debug(tbInfo)
				if (tbInfo.quality ~= nil) then
					local color =  g_QulityColor2[tonumber(tbInfo.quality)]
					if(color ~= nil) then
						labName:setColor(color)
					end
				end
			else
				local layItem = m_fnGetWidget(cell, "LAY_DROP" .. j)
				layItem:setEnabled(false)
			end
		end
	end
end

--[[desc: 根据奖励的经验值更新结算面板的相应信息
    barWidget: 经验条控件
    labWidget: 经验条上经验值控件
    nAddExp: 奖励的经验值
	expString:经验条上的数值
    nPercent:百分比
    return: 2个结果，1是增加经验后是否升级，2是增加经验后的当前级别 
—]]
fnSetExp = function( barWidget, labWidget, nAddExp)

	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
	local nNewExpNum = (nExpNum + nAddExp)%nLevelUpExp -- 得到当前显示的经验值分子
	logger:debug("lastExp = " .. nExpNum .. " addExp = " .. nAddExp .. " nextExp = " .. nLevelUpExp .. " newExp = " .. nNewExpNum)

	local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp; -- 获得经验后是否升级
	logger:debug("old level = " .. nCurLevel)
	nCurLevel = bLvUp and (nCurLevel + 1) or nCurLevel
	logger:debug("new level = " .. nCurLevel)
	nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 重新计算下一等级需要的经验值，作为分母

	--UIHelper.labelAddStroke(labWidget, nNewExpNum .. "/" .. nLevelUpExp)
	local expString = nNewExpNum .. "/" .. nLevelUpExp
	local nPercent = intPercent(nNewExpNum, nLevelUpExp)
	--barWidget:setPercent((nPercent > 100) and 100 or nPercent)

	return bLvUp, nCurLevel,expString,nPercent
end

--[[desc: 根据据点id返回当前已通关的难度程度
    nBaseId: 某个据点id
    nCopyId: 据点所在副本id
    return: number, 1，通关简单；2，普通；3，困难
—]]
local function getBasePassStat(nBaseId, nCopyId,curDegree,bScored)
	if (battalCopyType==2 or battalCopyType==3 or battalCopyType==4) then --精英副本隐藏得星
		return 0 --return tonumber(bScored)
	end
	logger:debug("normal battle copy return=========")
	logger:debug(m_tbCopyStat)
	if (m_tbCopyStat[""..nCopyId] and m_tbCopyStat[""..nCopyId].va_copy_info and m_tbCopyStat[""..nCopyId].va_copy_info.baselv_info[""..nBaseId] and m_tbCopyStat[""..nCopyId].va_copy_info.baselv_info[""..nBaseId][""..curDegree]) then
		return m_tbCopyStat[""..nCopyId].va_copy_info.baselv_info[""..nBaseId][""..curDegree].score
	else
		return 0
	end
	
	--return 0 -- 数据异常默认没有通过
end
--开始播放奖励相关特效果
local function beginAddReward()
	--开始数字 翻滚计时器
	startScheduler(SchedulerType.Silver_Scheduler)
	startScheduler(SchedulerType.Exp_Scheduler)
	startScheduler(SchedulerType.ExpBar_Scheduler)
	-- -- menghao 战斗评价动画
	local actionArr = CCArray:create()
	if(not table.isEmpty(m_tbDropItem)) then
		
		actionArr:addObject(CCDelayTime:create(0.2))
		--zhangjunwu 战斗评价结束之后开始播放掉落物品的翻牌特效 2014-11-19
		actionArr:addObject(CCCallFunc:create(function ( ... )
			startPlayDropItemEffect()
		end))
	end
	if (actionArr:count()>0) then
		layMain:runAction(CCSequence:create(actionArr))
	end
end
--[[desc: 根据据点难度和通关难度确定星级的显示
    tbBaseInfo: 当前据点信息
    nBaseDegree: 本次战斗的难易程度
    bScored: 是否获得副本得分
    return: 是否有返回值，返回值说明
—]]
fnSetStar = function ( tbBaseInfo, nBaseDegree, bScored )
	local nMaxDegree = 3 

	local curDegree = (nBaseDegree == 0) and 1 or nBaseDegree -- 当前难度，如果是NPC战，难度按简单

	local nPassStar = tonumber(getBasePassStat(tbBaseInfo.id, tbBaseInfo.copy_id ,curDegree,bScored))

	local strHardName = "LAY_HARD" .. nMaxDegree
	local layStar = m_fnGetWidget(layMain, strHardName)
	layStar:setVisible(true) -- 应该显示的星星容器

	

	--添加特效
	local IMG_RAINBOW = m_fnGetWidget(layMain,"IMG_RAINBOW")
	local IMG_TITLE = m_fnGetWidget(layMain,"IMG_TITLE_EFFECT")

	layMain.LAY_EFFECT1:setVisible(false)
	local tbWidgets = {layMain.LAY_EFFECT1}
	local function onCallback()
		palyPropertyEffect(tbWidgets,beginAddReward)
	end

	local imgStar1 = m_fnGetWidget(layStar, "IMG_STAR" .. nMaxDegree .."_" .. 1)
	local imgStar2 = m_fnGetWidget(layStar, "IMG_STAR" .. nMaxDegree .."_" .. 2)
	local imgStar3 = m_fnGetWidget(layStar, "IMG_STAR" .. nMaxDegree .."_" .. 3)
	local tbStarsArr={}
	if (nPassStar<=1) then
		tbStarsArr[1]=imgStar1
		tbStarsArr[2]=imgStar2
		tbStarsArr[3]=imgStar3
	else
		tbStarsArr[1]=imgStar1
		tbStarsArr[2]=imgStar2
		tbStarsArr[3]=imgStar3
	end
	performWithDelay(layMain,function()
			local winAnimation = EffBattleWin:new({imgTitle = IMG_TITLE, titleEffectType = (battalCopyType==4 and 1 or nil) , imgRainBow = IMG_RAINBOW,tbStars=tbStarsArr,starLv=nPassStar,callback=onCallback})
		end,0.1)

	if (battalCopyType==2 or battalCopyType==3 or battalCopyType==4) then --精英副本 活动 奇遇 隐藏得星
		layStar:setEnabled(false)
		layStar:setVisible(false)
		return
	end

	--点击得星显示
	-- zhangqi, 2015-10-09
	local function showImgReach( layRoot, idx )
		local imgReach = m_fnGetWidget(layRoot, "IMG_REACH" .. idx)
		imgReach:setEnabled(true)

		local imgNoReach = m_fnGetWidget(layRoot, "IMG_NOREACH" .. idx)
		imgNoReach:setEnabled(false)
	end

	layStar:setTouchEnabled(true)
	layStar:addTouchEventListener(function( sender, eventType )
			if (eventType ~= TOUCH_EVENT_ENDED) then
				return
			end
			AudioHelper.playCommonEffect() 
			local starLayout = g_fnLoadUI("ui/copy_get_star.json")
			local strTerms = lua_string_split(tbBaseInfo.get_star_id, ",")

			local term = lua_string_split(strTerms[tonumber(curDegree)], "|")

			for i=1,3 do
				local starStatusLb = m_fnGetWidget(starLayout, "TFD_STAR" .. i)
				require "db/DB_Get_star"
				local getStarDb = DB_Get_star.getDataById(term[i])
				starStatusLb:setText(i.."."..getStarDb.description)

				-- zhangqi, 2015-10-09, 初始化隐藏已达成图片
				local imgReach = m_fnGetWidget(starLayout, "IMG_REACH" .. i)
				imgReach:setEnabled(false)
			end
			for i=1,nPassStar do
				local starStatusLb = m_fnGetWidget(starLayout, "TFD_STAR" .. i)
				local starAshImg = m_fnGetWidget(starLayout, "IMG_STAR_ASH" .. i)
				starAshImg:setVisible(false)

				-- zhangqi, 2015-10-09, 显示已达成图片
				showImgReach(starLayout, i)
			end
			local function closeStar( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()
					LayerManager.removeLayout()
				end
			end
			local closeBtn = m_fnGetWidget(starLayout, "BTN_CLOSE")
			closeBtn:addTouchEventListener(closeStar)
			local sureBtn = m_fnGetWidget(starLayout, "BTN_ENSURE")
			sureBtn:addTouchEventListener(closeStar)
			UIHelper.titleShadow(sureBtn)
			
			LayerManager.addLayout(starLayout)
		end
		)

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

		if ((not m_updateExpTimeScheduler) and (not m_updateSilverTimeScheduler)
			and (not m_updateSoulTimeScheduler) and (not m_updateExpBarTimeScheduler)) then
			layMain:setTouchEnabled(true)
			-- btnShare:setTouchEnabled(true)
		end
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

		if ((not m_updateExpTimeScheduler) and (not m_updateSilverTimeScheduler)
			and (not m_updateSoulTimeScheduler) and (not m_updateExpBarTimeScheduler)) then
			layMain:setTouchEnabled(true)
			-- btnShare:setTouchEnabled(true)
		end
	end
end
--暂停所有计时器，
function stopAllScheduler( ... )
	stopScheduler(SchedulerType.Exp_Scheduler)
	stopScheduler(SchedulerType.Silver_Scheduler)
	stopScheduler(SchedulerType.ExpBar_Scheduler)
end
function setExpBaseLine()
	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(m_nCurExp) -- 当前的经验值

	labnExp:setText(nExpNum .. "/" ..nLevelUpExp)
	-- labnExp:setStringValue(nExpNum)
	-- labnExpDom:setStringValue(nLevelUpExp)

	local nPercent = nExpNum / nLevelUpExp * 100
	barExp:setPercent((nPercent > 100) and 100 or nPercent)
end
function updateExpLine()
	--print("updateExpLine!")
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
		-- logger:debug("lastExp = " .. nExpNum .. " addExp = " .. m_expChangeNumber .. " nextExp = " .. nLevelUpExp .. " newExp = " .. nNewExpNum)

		local bLvUp = (nExpNum + m_expChangeNumber) >= nLevelUpExp; -- 获得经验后是否升级


		nCurLevel = bLvUp and (nCurLevel + 1) or nCurLevel
		if(bLvUp == true) then
			nNewExpNum = nNewExpNum - tUpExp["lv_" .. nCurLevel]
			labLevel:setText(m_i18nString(4366, nCurLevel))
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
		labnExp:setText(expString)
		-- labnExpDom:setStringValue(nLevelUpExp)

		local nPercent = nNewExpNum / nLevelUpExp * 100
		barExp:setPercent((nPercent > 100) and 100 or nPercent)

	else
		stopScheduler(SchedulerType.ExpBar_Scheduler)

		if ((not m_updateExpTimeScheduler) and (not m_updateSilverTimeScheduler)
			and (not m_updateSoulTimeScheduler) and (not m_updateExpBarTimeScheduler)) then
			layMain:setTouchEnabled(true)
			-- btnShare:setTouchEnabled(true)
		end
	end

end

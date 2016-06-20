-- FileName: MainShip.lua
-- Author: zhangqi
-- Date: 2014-03-25
-- Purpose: 主页显示的主船模块，包括二级菜单按钮和各种活动按钮

module("MainShip", package.seeall)

require "script/GlobalVars"
require "script/utils/LuaUtil"
require "script/module/public/ShowNotice"
require "script/module/switch/SwitchModel"
require "script/module/main/SecondMenuView"
-- UI控件引用变量 --
local widgetRoot -- 主背景UI的根层容器
local layMask  -- "LAY_MASK", 屏蔽下层触摸的层容器
local imgCircle -- "IMG_CIRCLE", 所有二级按钮的父级图片

local m_ArmTipPartner --伙伴按钮上的动画 
local m_btnReward -- 奖励中心按钮


-- 模块局部变量 --
local jsonMain = "ui/home_main.json"
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n

local m_changeBgScheduler 		-- menghao 更新背景图片位置定时器
local m_onlineRewardScheduler 	-- menghao 更新在线奖励时间定时器
local m_TAG_ONLINE = 333 -- 在线奖励特效的tag
local m_fnOnlineRewardUpdater -- 在线奖励对话框刷新方法
local m_FLAG_ONLINEREWARD = "OnlineReward_reGetTime" -- 在线奖励注册通知标记名称

-- zhangqi, 2014-12-30, 记录是否显示船头上的叹号提示
--（占卜屋和好友有红点提示时各做一次处理，zb = true, fd = true, 反之为false）
local m_boatTipFlag

local tbRedPoint = {} -- 存放有红点动画的 红点动画
local tbSecondButton = nil  --用于二级菜单
local tbSecondPos = nil --用于二级菜单
local m_secBubbleLayTag = 4456210 --聊天气泡滑动进来的label


-- 模块局部函数 --
local tBtnWorldPos = {}
--激活二级菜单按钮事件
local function onMainEnter(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		--------------------------- new guide begin ---------------------------
		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideTrainView"
		if (GuideModel.getGuideClass() == ksGuideDestiny and GuideTrainView.guideStep == 1) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createTrainGuide(2)
		end

		require "script/module/guide/GuideAstrologyView"
		if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 1) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createAstrologyGuide(2)
		end

		require "script/module/guide/GuideRebornView"
		if (GuideModel.getGuideClass() == ksGuideReborn  and GuideRebornView.guideStep == 1) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createRebornGuide(2)
		end

		--------------------------- new guide end ---------------------------------
		logger:debug("onMainEnter trigger 1")
		logger:debug("imgCircle type " .. type(imgCircle))
	end
end

-- 主背景按钮事件 --
-- 伙伴
local function onHero( sender, eventType )
	require "script/module/partner/MainPartner" --利用按下按钮没有放弹起时的碎片时间 liweidong
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		logger:debug("btn.name : " .. sender:getName())
	
		TimeUtil.timeStart("load partner bag")
		require "script/module/partner/MainPartner"
		local layPartner = MainPartner.create()
		TimeUtil.timeEnd("load partner bag")
		if (layPartner) then
			logger:debug("layPartner not nil")
			TimeUtil.timeStart("change partner bag")
			LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3}, true)
			TimeUtil.timeEnd("change partner bag")
			TimeUtil.timeStart("add infor partner bag")
			PlayerPanel.addForPartnerStrength()
			TimeUtil.timeEnd("add infor partner bag")
		end
	end
end
-- 装备
-- local function onEquip( sender, eventType )
-- 	if (eventType == TOUCH_EVENT_ENDED) then
-- 		AudioHelper.playMainUIEffect()

-- 		logger:debug("btn.name : " .. sender:getName())
-- 		-- LayerManager.addLoading()
-- 		require "script/module/equipment/MainEquipmentCtrl"
-- 		local layEquipment = MainEquipmentCtrl.create()
-- 		if layEquipment then
-- 			LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
-- 			PlayerPanel.addForPartnerStrength()
-- 		end
-- 	end
-- end
-- 联盟按钮事件
local function onPirate( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()

		if (SwitchModel.getSwitchOpenState(ksSwitchGuild,true)) then
			require "script/module/guild/GuildDataModel"
			require "script/module/guild/MainGuildCtrl"
			MainGuildCtrl.create()
		end
	end
end
-- 聊天
local function onChat( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		logger:debug("btn.name : " .. sender:getName())
		require "script/module/chat/ChatCtrl"
		local layChat = ChatCtrl.create()
	end
end

--每日任务
function onDailyTask(sender,eventType)
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("renwu.mp3")
		if (SwitchModel.getSwitchOpenState(ksSwitchEveryDayTask,true)) then
			require "script/module/achieve/MainAchieveCtrl"
			MainAchieveCtrl.create()
		end
	end
end

--分解屋
function onResolve( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("anniu_huishou.mp3") -- 2015-12-29
		
		if (SwitchModel.getSwitchOpenState( ksSwitchResolve,true)) then
			require "script/module/resolve/MainRecoveryCtrl"
			TimeUtil.timeStart("MainRecoveryCtrl.create")
			local layResolve = MainRecoveryCtrl.create()
			TimeUtil.timeEnd("MainRecoveryCtrl.create")
			if (layResolve) then
				LayerManager.changeModule(layResolve, MainRecoveryCtrl.moduleName(), {1,3}, true)
				PlayerPanel.addForPublic()
			end
		end
	end
end
-- 宴会大厅
function onRestarant( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainMenuBtn()
		ShowNotice.showShellInfo(m_i18n[1366])
	end
end


-- zhangqi, 2014-08-08, 刷新伙伴和装备按钮的红点
-- zhangqi, 2015-10-09, 删除装备背包按钮的处理代码
function updateBagPoint( sBtnName ) -- "BTN_HERO"
	require "script/module/partner/PartnerTransUtil"
	if (widgetRoot) then
		if (sBtnName == "BTN_HERO") then
			local partner = g_redPoint.partner.getvisible()

			if (m_ArmTipPartner==nil and partner==1) then
				m_ArmTipPartner = UIHelper.createArmatureNode({
					filePath = "images/effect/newhero/new.ExportJson",
					animationName = "new",
				})
				m_ArmTipPartner:setAnchorPoint(ccp(0.2,-0.3))
				local btn=m_fnGetWidget(widgetRoot,"BTN_HERO")
				btn:addNode(m_ArmTipPartner)
				return
			else
				if m_ArmTipPartner then
					m_ArmTipPartner:removeFromParentAndCleanup(true)
					m_ArmTipPartner=nil
				end
			end

			require "script/module/partner/HeroSortUtil"
			local imgTipPartner = m_fnGetWidget(widgetRoot,"IMG_TIP_PARTNER") -- 伙伴按钮上的红点
			if ((partner~=1 and HeroSortUtil.getFuseSoulNum() > 0) or PartnerTransUtil.getIsHaveHroAdvanced()) then
				imgTipPartner:removeAllNodes()
				imgTipPartner:addNode(UIHelper.createRedTipAnimination())
			else
				imgTipPartner:removeAllNodes()
			end
		end
	end
end

--加入波纹效果
local function buttonRippleAnimation( )
	local rewardCenter = UIHelper.createArmatureNode({
		filePath =  "images/main/bowen/bowen.ExportJson",
		animationName = "bowen",
		loop = 1,
		fnMovementCall = nil,
	})
	return rewardCenter
end
--统一添加主背景按钮事件的方法
-- zhangqi, 2015-10-09, 删除装备背包按钮，替换为分解屋按钮，主船按钮移到二级菜单代替分解屋原来的位置
local fnAddEventToButtons = function ( ... )
	local tbBtnName = { "BTN_HERO", "BTN_RESOLVE","BTN_HAIZEITUAN", "BTN_CHAT",
		"BTN_JINGCAI_ACT","BTN_REWARD_CENTER","BTN_DAYTASK","BTN_SHOP_TOTAL","BTN_RECHARGE","BTN_FIRST_RECHARGE","BTN_RECHARGE_0", "BTN_PIRATE"
	}
	local tbEvents = { onHero, onResolve, onPirate, onChat,
		onWonderfulActivity,onRewardCenter,onDailyTask,onShopTotal,onIAP,onFirstGift,OnRank, onWorldArena,
	}

	for i, v in ipairs(tbBtnName) do
		local btn = m_fnGetWidget(widgetRoot, v)
		if (btn) then
			btn:addTouchEventListener(tbEvents[i])
		end
	end

	m_btnReward = m_fnGetWidget(widgetRoot, "BTN_REWARD_CENTER")
end

--addBy wangming 20150122
--[[desc:判断是否有签到的红点
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnCheckRegistrationTip( ... )
	require "script/model/DataCache"
	local signInfo = DataCache.getNorSignCurInfo()
	if(not signInfo) then
		return false
	end
	if(tonumber(signInfo.sign_num) > tonumber(signInfo.reward_num)) then
		return true
	end
	require "script/module/registration/MainRegistrationCtrl"
	local pReward = MainRegistrationCtrl.fnGetTodayReward()
	if(not pReward ) then
		return false
	end
	local pBei = tonumber(pReward[4]) or 0
	if(pBei <= 0) then
		return false
	end
	local pLast = tonumber(signInfo.last_vip) or 0
	local pL = tonumber(pReward[3]) or 0
	local mVip =  tonumber(UserModel.getVipLevel()) or 0
	local isGetVip = pL <= pLast and pL <= mVip
	if(not isGetVip) then
		return true
	end
	return false
end

--回收系统红点提示
local function updateRecoveryRedPoint(  )
	require "script/module/resolve/ResolveModel"
	local bVis = ResolveModel.getRecoveryRedPoint()
	logger:debug(bVis)
	if tbRedPoint.recovery == nil then
		if (bVis) then
			tbRedPoint.recovery = UIHelper.createRedTipAnimination()

			local btnResolove = m_fnGetWidget(widgetRoot, "BTN_RESOLVE") --所有商店
			local imgTipResolve = btnResolove.IMG_TIP_RESOLVE--取到红圈
			imgTipResolve:addNode(tbRedPoint.recovery)
		end
	else
		if (not bVis) then
			tbRedPoint.recovery:removeFromParentAndCleanup(true)
			tbRedPoint.recovery = nil
		end
	end
end


local function updateGuildRedPoint( ) -- 联盟
	require "script/module/guild/GuildUtil"
	if (GuildUtil.isShowTip()==true) then
		if tbRedPoint.guild == nil then
			tbRedPoint.guild = UIHelper.createRedTipAnimination()
			local imgTipUnion = m_fnGetWidget(widgetRoot, "IMG_TIP_UNION") -- 联盟按钮上的红点
			imgTipUnion:addNode(tbRedPoint.guild)
		end
	else
		if tbRedPoint.guild ~= nil then
			tbRedPoint.guild:removeFromParentAndCleanup(true)
			tbRedPoint.guild = nil
		end
	end
end

local function updateWonderfulActRedPoint(  ) -- 精彩活动
	require "script/module/wonderfulActivity/WonderfulActModel"
	local bVis = WonderfulActModel.hasTipInActive()
	if tbRedPoint.wonderful == nil then
		if (bVis) then
			tbRedPoint.wonderful = UIHelper.createRedTipAnimination()
			local btnWondAct = m_fnGetWidget(widgetRoot, "BTN_JINGCAI_ACT") --精彩活动按钮
			local imgTipAct = m_fnGetWidget(btnWondAct, "IMG_TIP_ACT") --取到红圈
			imgTipAct:addNode(tbRedPoint.wonderful)
		end
	else
		if (not bVis) then
			tbRedPoint.wonderful:removeFromParentAndCleanup(true)
			tbRedPoint.wonderful = nil
		end
	end
end


local function updateAllShopRedPoint(  )
	require "script/module/allShop/AllShopData"
	local bVis = AllShopData.getIsShowRedTip()
	if tbRedPoint.allShop == nil then
		if (bVis) then
			tbRedPoint.allShop = UIHelper.createRedTipAnimination()
			local btnAllShop = m_fnGetWidget(widgetRoot, "BTN_SHOP_TOTAL") --所有商店
			local imgTipAct = btnAllShop.IMG_TIP_SHOP_TOTAL--取到红圈
			imgTipAct:addNode(tbRedPoint.allShop)
		end
	else
		if (not bVis) then
			tbRedPoint.allShop:removeFromParentAndCleanup(true)
			tbRedPoint.allShop = nil
		end
	end
end

local function updateFirstGiftRedPoint(  )
	local bVis = FirstGiftData.isShowFirstGifts()
	widgetRoot.BTN_FIRST_RECHARGE:setEnabled(bVis)
	widgetRoot.BTN_RECHARGE:setEnabled(not bVis)
	local bRed = FirstGiftData.getShowRedPoint()
	if tbRedPoint.firstGift == nil then
		if (bRed) then
			tbRedPoint.firstGift = UIHelper.createRedTipAnimination()
			local btnFirst = m_fnGetWidget(widgetRoot, "BTN_FIRST_RECHARGE") --首充
			local imgTipAct = btnFirst.IMG_FIRST_TIP--取到红圈
			imgTipAct:addNode(tbRedPoint.firstGift)
		end
	else
		if (not bRed) then
			tbRedPoint.firstGift:removeFromParentAndCleanup(true)
			tbRedPoint.firstGift = nil
		end
	end
	-- AppStore审核
  	if (Platform.isAppleReview()) then
  		widgetRoot.BTN_FIRST_RECHARGE:setVisible(false)
  		widgetRoot.BTN_FIRST_RECHARGE:setEnabled(false)
  	end
end

local function updateRewardCenterRedPoint(  )
	require "script/module/rewardCenter/RewardCenterModel" --奖励中心
	if DataCache.getRewardCenterStatus() and RewardCenterModel.getIsHasUnTimeOut() and m_btnReward then
		m_btnReward:setEnabled(true)
		if tbRedPoint.rewardCenter == nil then
			tbRedPoint.rewardCenter = buttonRippleAnimation()
			m_btnReward:addNode(tbRedPoint.rewardCenter)
		end
	elseif((RewardCenterModel.getRewardCount()<=0  or not RewardCenterModel.getIsHasUnTimeOut()) and m_btnReward) then --奖励中心
		m_btnReward:setEnabled(false)
	else
		if m_btnReward then
			m_btnReward:setEnabled(true)
			if tbRedPoint.rewardCenter == nil then
				tbRedPoint.rewardCenter = buttonRippleAnimation()
				m_btnReward:addNode(tbRedPoint.rewardCenter)
			end
		end
	end
end
		

local function updateAchieveTaskRedPonit(  ) --  检测 每日任务 上的小红点
	require "script/module/achieve/AchieveModel"
	require "script/module/dailyTask/MainDailyTaskData"
	if (tbRedPoint.taskPoint == nil) then
		if (AchieveModel.getTotalUnRewardNum() ~= 0 or tonumber(MainDailyTaskData.getRewardAbleNum()) ~= 0) then
			local btnTask = m_fnGetWidget(widgetRoot, "BTN_DAYTASK") -- 每日任务按钮
			local imgTipLevel = m_fnGetWidget(btnTask, "IMG_TIP_LEVEL")
			tbRedPoint.taskPoint = UIHelper.createRedTipAnimination()
			imgTipLevel:addNode(tbRedPoint.taskPoint)
		end
	else
		if AchieveModel.getTotalUnRewardNum() == 0
			and tonumber(MainDailyTaskData.getRewardAbleNum()) == 0 then
			tbRedPoint.taskPoint:removeFromParentAndCleanup(true)
			tbRedPoint.taskPoint = nil
		end
	end
end
		
-- 更新显示那个跨服活动
local function updateWARedPoint( )
	if WorldArenaModel.isShowBtn() then
		widgetRoot.BTN_PIRATE:setEnabled(true)
	else
		widgetRoot.BTN_PIRATE:setEnabled(false)
	end
end


function checkTipOnBtn(  )
	if (widgetRoot and LayerManager.curModuleName() == moduleName()) then
		updateFirstGiftRedPoint()
		updateAllShopRedPoint()
		updateGuildRedPoint()
		updateWonderfulActRedPoint()
		updateRewardCenterRedPoint()
		updateAchieveTaskRedPonit()
		updateWARedPoint()
		updateOpenServerCountdown()
	end
end

-- 巅峰对决
require "script/module/worldArena/WAEntryCtrl"
function onWorldArena(sender,eventType)
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("anniu_haizeijidou.mp3")
		WAEntryCtrl.create()
	end
end


--奖励中心
function onRewardCenter(sender,eventType)
	require "script/module/rewardCenter/MainRewardCenterCtrl"
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("jianglizhongxin.mp3")
		MainRewardCenterCtrl.create()
	end
end

-- 商店整合
function onShopTotal( sender,eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		require "script/module/allShop/AllShopCtrl"
		tBtnWorldPos.allShopPos = sender:convertToWorldSpace(ccp(0,0))
		local view = AllShopCtrl.create()
		LayerManager.addCommonLayout({wigLayout = view, scale = true, animation = true,startPos = sender:convertToWorldSpace(ccp(0,0))})
	end
end

-- 充值
function onIAP( sender,eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		LayerManager.addLayout(IAPCtrl.create())
	end
end

-- 首充礼包
function onFirstGift( sender,eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		local act = MainWonderfulActCtrl.create("firstGift")
		LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
	end
end

-- 排行榜
function OnRank( sender,eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		require "script/module/rank/MainRankCtrl"
		MainRankCtrl.create()
	end
end

-- 精彩活动
function onWonderfulActivity( sender,eventType )
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		require "script/module/wonderfulActivity/MainWonderfulActCtrl"
		local act = MainWonderfulActCtrl.create()
		LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
	end
end

--线上活动按钮事件
local function onActivity( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()

		local wgBtn = tolua.cast(sender, "Widget")
		logger:debug(wgBtn:getName() .. " on touched")
	end
end

-- 控制台
local function createCmdBtn( parent )
	local btn = Button:create()
	btn:loadTextureNormal("images/arena/king_photo_bg_1.png")

	btn:setTitleText("控制台")
	btn:setTitleFontSize(g_FontInfo.size)
	btn:setTitleColor(ccc3(0x00,0x00,0x00))

	local ship = m_fnGetWidget(widgetRoot, "LAY_SHIP")
	local shipSize = ship:getSize()

	btn:setPosition(ccp(shipSize.width - btn:getSize().width/2, shipSize.height/2 - 70))

	btn:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			local totalMem = collectgarbage("count")
			logger:debug("totalMem = " .. totalMem/1024 .. " MB")

			local cmdBtn = ship:getChildByTag(99999)
			local cmdEdit = ship:getNodeByTag(99998)
			if (cmdBtn and cmdEdit) then
				logger:debug(" cmdEdit exist, remove")
				ship:removeChildByTag(99999, true)
				ship:removeNodeByTag(99998)
			else
				logger:debug("create cmdEdit")
				require "script/consoleExe/ConsolePirate"
				ConsolePirate.create(ship)
			end
		end
	end)
	logger:debug("create cmdBtn end")
	ship:addChild(btn)
end

-- 清缓存
local function createClearBtn( parent )
	local btn = Button:create()
	btn:loadTextureNormal("images/arena/king_photo_bg_1.png")

	btn:setTitleText("清缓存")
	btn:setTitleFontSize(g_FontInfo.size)
	btn:setTitleColor(ccc3(0x00,0x00,0x00))

	local ship = m_fnGetWidget(widgetRoot, "LAY_SHIP")
	local shipSize = ship:getSize()

	btn:setPosition(ccp(shipSize.width - btn:getSize().width/2, shipSize.height/2 + 70))

	btn:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			Util.removeCacheDir()
		end
	end)
	ship:addChild(btn)
end

-- menghao 背景图片滚动
local function createBackground( ... )
	local layRoot = m_fnGetWidget(widgetRoot, "LAY_ROOT")

	local imgWave1 = m_fnGetWidget(widgetRoot, "IMG_WAVE1")
	local imgWave2 = m_fnGetWidget(widgetRoot, "IMG_WAVE2")
	local imgCloud1 = m_fnGetWidget(widgetRoot, "IMG_CLOUD1")
	local imgCloud2 = m_fnGetWidget(widgetRoot, "IMG_CLOUD2")
	local imgIsland = m_fnGetWidget(widgetRoot, "IMG_ISLAND")

	---[[
	local imgWaveCopy2 = imgWave1:clone()
	layRoot:addChild(imgWaveCopy2)

	local imgWaveCopy = imgWave2:clone()
	layRoot:addChild(imgWaveCopy)

	local imgCloud1Copy = imgCloud1:clone()
	layRoot:addChild(imgCloud1Copy)

	local imgCloud2Copy = imgCloud2:clone()
	layRoot:addChild(imgCloud2Copy)

	local imgIslandCopy = imgIsland:clone()
	layRoot:addChild(imgIslandCopy)
	--]]
	local posXWave = imgWave2:getPositionX()
	local posXWave2 = imgWave1:getPositionX()
	local posXCloud1 = imgCloud1:getPositionX()
	local posXCloud2 = imgCloud2:getPositionX()
	local posXIsland = imgIsland:getPositionX()
	local function updateUI( ... )
		imgWave2:setPositionX(imgWave2:getPositionX() - 0.6)
		imgWaveCopy:setPositionX(imgWave2:getPositionX() + imgWave2:getSize().width - 2)

		imgWave1:setPositionX(imgWave1:getPositionX() + 0.7)
		imgWaveCopy2:setPositionX(imgWave1:getPositionX() - imgWave1:getSize().width + 2)

		imgCloud1:setPositionX(imgCloud1:getPositionX() + 0.4)
		imgCloud1Copy:setPositionX(imgCloud1:getPositionX() - imgCloud1:getSize().width + 2)

		imgCloud2:setPositionX(imgCloud2:getPositionX() + 0.2)
		imgCloud2Copy:setPositionX(imgCloud2:getPositionX() - imgCloud2:getSize().width + 2)

		imgIsland:setPositionX(imgIsland:getPositionX() + 0.55)
		imgIslandCopy:setPositionX(imgIsland:getPositionX() - imgIsland:getSize().width + 2)

		if imgWave2:getPositionX() < posXWave - imgWave2:getSize().width then
			imgWave2:setPositionX(posXWave)
			imgWaveCopy:setPositionX(posXWave + imgWave2:getSize().width - 2)
		end
		if imgWave1:getPositionX() > posXWave + imgWave1:getSize().width then
			imgWave1:setPositionX(posXWave2)
			imgWaveCopy2:setPositionX(posXWave2 - imgWave1:getSize().width + 2)
		end
		if imgCloud1:getPositionX() > posXCloud1 + imgCloud1:getSize().width then
			imgCloud1:setPositionX(posXCloud1)
			imgCloud1Copy:setPositionX(posXCloud1 - imgCloud1:getSize().width + 2)
		end
		if imgCloud2:getPositionX() > posXCloud2 + imgCloud2:getSize().width then
			imgCloud2:setPositionX(posXCloud2)
			imgCloud2Copy:setPositionX(posXCloud2 - imgCloud2:getSize().width + 2)
		end
		if imgIsland:getPositionX() > posXIsland + imgIsland:getSize().width then
			imgIsland:setPositionX(posXIsland)
			imgIslandCopy:setPositionX(posXIsland - imgIsland:getSize().width + 2)
		end
	end

	-- 启动scheduler
	local function startScheduler()
		if (m_changeBgScheduler == nil) then
			m_changeBgScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateUI, 0, false)
		end
		GlobalNotify.addObserver("PUSHCHARGEOK", fnMSG_OPENSERVER_TIP, false, moduleName())
		GlobalNotify.addObserver(OpenServerModel.MSG.CB_MODITY_DATA, fnMSG_OPENSERVER_TIP, false, moduleName())
	end

	-- 停止scheduler
	local function stopScheduler()
		if (m_changeBgScheduler) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_changeBgScheduler)
			m_changeBgScheduler = nil
		end
		GlobalNotify.removeObserver("PUSHCHARGEOK", moduleName())
		GlobalNotify.removeObserver(OpenServerModel.MSG.CB_MODITY_DATA, moduleName())
	end

	UIHelper.registExitAndEnterCall(layRoot, 
		function ()
			stopScheduler()
			removeOnlineRewardObserver() -- zhangqi, 2015-09-10, 退出主界面时注销UI刷新的断网重连通知
			stopOnlineScheduler() -- zhangqi, 2015-12-16,停止UI的刷新定时器
		end, startScheduler)
end

-- 初始函数，加载UI资源文件
function init( ... )
	m_ArmTipPartner = nil
	m_btnReward = nil
	widgetRoot = nil
	tbRedPoint = {}
	m_boatTipFlag = {zb = false, fd = false}

	tbSecondButton = nil
	tbSecondPos = nil
end

-- 析构函数，释放纹理资源
function destroy( ... )
	GlobalScheduler.removeCallback("checkTipOnBtn")
	init()
	package.loaded["MainShip"] = nil
	logger:debug("MainShip destroy")
end

-- 2015-09-10, zhangqi, 在线奖励按钮可领取时状态显示
local function onlineRewardCanGet( ... )
	logger:debug("onlineRewardCanGet")

	local btnOnline = m_fnGetWidget(widgetRoot, "BTN_ONLINE_REWARD")
	local imgRecieve = m_fnGetWidget(widgetRoot, "IMG_CAN_RECIEVE")
	local layTop = m_fnGetWidget(widgetRoot, "LAY_BTN_TOP")

	btnOnline:setVisible(false)
	
	local armatureClock = UIHelper.createArmatureNode({
		filePath = "images/effect/onlineReward/clock.ExportJson",
		animationName = "clock",
	})
	local posX, posY = btnOnline:getPosition()
	armatureClock:setPosition(ccp(posX, posY))
	layTop:addNode(armatureClock, 3, m_TAG_ONLINE)

	local armatureRecieve = UIHelper.createArmatureNode({
		filePath = "images/effect/onlineReward/recieve.ExportJson",
		animationName = "recieve",
	})
	imgRecieve:addNode(armatureRecieve)
	imgRecieve:setEnabled(true)
end

-- 2015-09-10, zhangqi, 在线奖励按钮倒计时状态显示
function onlineRewardCount( ... )
	logger:debug("onlineRewardCount")
	local btnOnline = m_fnGetWidget(widgetRoot, "BTN_ONLINE_REWARD")
	local imgRecieve = m_fnGetWidget(widgetRoot, "IMG_CAN_RECIEVE")
	local layTop = m_fnGetWidget(widgetRoot, "LAY_BTN_TOP")

	if (layTop:getNodeByTag(m_TAG_ONLINE)) then
		layTop:removeNodeByTag(m_TAG_ONLINE)
	end
	imgRecieve:removeAllNodes()

	btnOnline:setVisible(true)
	imgRecieve:setEnabled(false)
end

-- zhangqi, 2015-09-10, 在线奖励按钮状态定时刷新
local function onlineRewardUpdater( ... )
	logger:debug("onlineRewardUpdater")
	
	local leftTime = OnlineRewardCtrl.getFutureTime() - TimeUtil.getSvrTimeByOffset()

	if (leftTime >= 0) then
		local tfdOnlineTime = m_fnGetWidget(widgetRoot, "TFD_ONLINE_TIME")
		tfdOnlineTime:setText(TimeUtil.getTimeString(leftTime))
		if (isFunc(m_fnOnlineRewardUpdater)) then -- 刷新在线奖励对话框UI
			m_fnOnlineRewardUpdater(leftTime)
		end
	else
		stopOnlineScheduler()
		onlineRewardCanGet()
	end
end

-- zhangqi, 2015-09-10, 在线奖励注册断网和重连通知
function onlineRewardObserver( ... )
	logger:debug("onlineRewardObserver")
	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
		startOnlineScheduler() -- 主界面且不可领取时，自动重连成功恢复倒计时UI刷新
	end, nil, m_FLAG_ONLINEREWARD)
	GlobalNotify.addObserver(GlobalNotify.NETWORK_FAILED, function ( ... )
		stopOnlineScheduler() -- 主界面且不可领取时，断线停止倒计时UI刷新
	end, nil, m_FLAG_ONLINEREWARD)
end

-- zhangqi, 2015-09-10, 在线奖励注销断网和重连通知
function removeOnlineRewardObserver( ... )
	GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, m_FLAG_ONLINEREWARD)
	GlobalNotify.removeObserver(GlobalNotify.NETWORK_FAILED, m_FLAG_ONLINEREWARD)
end

-- zhangqi, 2015-09-10, 启动在线奖励倒计时定时器
function startOnlineScheduler()
	logger:debug("startOnlineScheduler")
	if (m_onlineRewardScheduler == nil and widgetRoot) then
		logger:debug("startOnlineScheduler m_onlineRewardScheduler == nil")
		m_onlineRewardScheduler = GlobalScheduler.scheduleFunc(onlineRewardUpdater)
		onlineRewardCount() -- 2015-09-09, 显示倒计时状态
		onlineRewardObserver() -- 注册断线重连的通知
	end
end


-- zhangqi, 2015-09-10, 停止在线奖励倒计时定时器
function stopOnlineScheduler()
	logger:debug("stopOnlineScheduler")
	if (isFunc(m_onlineRewardScheduler)) then
		logger:debug("stopOnlineScheduler m_onlineRewardScheduler")
		m_onlineRewardScheduler()
		m_onlineRewardScheduler = nil
	end
end

--zhangqi, 2015-09-10, 用于领完奖励后删除在线奖励按钮相关所有元素
function removeOnlinRewardIcon( ... )
	local btnOnline = m_fnGetWidget(widgetRoot, "BTN_ONLINE_REWARD")
	btnOnline:removeFromParent()

	local imgRecieve = m_fnGetWidget(widgetRoot, "IMG_CAN_RECIEVE")
	imgRecieve:removeFromParent()

	local layTop = m_fnGetWidget(widgetRoot, "LAY_BTN_TOP")
	layTop:removeNodeByTag(m_TAG_ONLINE) -- 动画没有加在按钮上，需要手动移除
end

-- menghao 0829 设置在线奖励按钮
function setOnlineReward()	
	require "script/module/onlineReward/OnlineRewardCtrl"
	if (OnlineRewardCtrl.gotAll()) then -- 全部领取完后不显示按钮, 2015-12-16
		logger:debug("All of OnlineReward have been got.")
		removeOnlinRewardIcon()
		return
	end

	local tfdOnlineTime = m_fnGetWidget(widgetRoot, "TFD_ONLINE_TIME")
	UIHelper.labelNewStroke(tfdOnlineTime, ccc3( 0x04, 0x1f, 0x41 ))

	local btnOnline = m_fnGetWidget(widgetRoot, "BTN_ONLINE_REWARD")
	btnOnline:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			local layMain = nil
			layMain, m_fnOnlineRewardUpdater = OnlineRewardCtrl.create()
			UIHelper.registExitAndEnterCall(layMain, function ( ... )
				m_fnOnlineRewardUpdater = nil -- 在线奖励对话框关闭后倒计时定时器就不会再刷新对话框UI
			end)
			LayerManager.addLayout(layMain)
		end
	end)

	-- zhangqi, 2015-09-10
	if (OnlineRewardCtrl.canGetStat()) then
		onlineRewardCanGet() -- 显示可领取状态
	else
		onlineRewardUpdater() -- 倒计时中，先刷新计时避免每次界面切换都显示初始的00:00:00
		startOnlineScheduler()
	end
end

--[[desc:刷新可激活提示状态
    arg1: 无
    return: 无
—]]
function refreshShipCanActivate( ... )
	-- lvnanchun 2015-12-21 添加主船系统可激活特效
	local imgShip = widgetRoot.IMG_SHIP
	local preCanActivate = imgShip.IMG_CAN_ACTIVATE:getNodeByTag(10089)
	if (preCanActivate) then
		imgShip.IMG_CAN_ACTIVATE:removeNode(preCanActivate)
	end
	local canActivate = FormationUtil.getActiveEffect()
	if (ShipData.bShipCanActivate()) then
		imgShip.IMG_CAN_ACTIVATE:addNode(canActivate, 10088, 10089)
	end
end

function create( ... )
	init()
	--主背景UI
	widgetRoot = g_fnLoadUI(jsonMain)

	--暂时屏蔽排行榜
	-- widgetRoot.BTN_RECHARGE_0:setEnabled(false)

	local imgSky = m_fnGetWidget(widgetRoot, "IMG_SKY")
	local layShip = m_fnGetWidget(widgetRoot, "LAY_SHIP")
	local imgShip = m_fnGetWidget(widgetRoot, "IMG_SHIP")
	local tbShipPos = ccp(imgShip:getPositionX(),imgShip:getPositionY())
	local tbShipAnchor = ccp(imgShip:getAnchorPoint().x,imgShip:getAnchorPoint().y)

	local aniShip
	if (SwitchModel.getSwitchOpenState( ksSwitchMainShip , false )) then
		require "script/module/ship/ShipData"
		local home_graph = ShipData.getHomeNowShipImageId()
		aniShip = UIHelper.addShipAnimation(layShip,home_graph,tbShipPos,tbShipAnchor,1.0,10086,10087 )
		-- 添加可激活特效
		refreshShipCanActivate()
	else
		aniShip = UIHelper.addShipAnimation(layShip,1,tbShipPos,tbShipAnchor,1.0,10086,10087 )
	end

	-- zhangqi, 2014-12-30, 重新设置zorder在船的动画之上，用于显示主船上的感叹号提示
	imgShip:setZOrder(aniShip:getZOrder() + 10)

	local layBoatTouch = m_fnGetWidget(imgShip, "LAY_ENTER") -- 触摸可弹出二级菜单的层容器
	--layBoatTouch:setEnabled(false) -- zhangqi, 2015-10-26, 临时屏蔽，等新主船合并回主干时就可以删除 LAY_ENTER

	layBoatTouch:setTouchEnabled(true)
	layBoatTouch:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			--onMainEnter(sender, eventType)
			AudioHelper.playBtnEffect("zhuchuan.mp3")
			if (SwitchModel.getSwitchOpenState( ksSwitchMainShip , true )) then
				require "script/module/ship/ShipMainCtrl"
				ShipMainCtrl.create(nil, "main")
			end
		end
	end)
	--探索
	local explorBtn = m_fnGetWidget(widgetRoot, "BTN_EXPLORE")
	explorBtn:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playMainUIEffect()
			require "script/module/copy/MainCopy"
			MainCopy.extraToExploreScene()
		end
	end)
	
	-- 游戏宝典
	widgetRoot.BTN_BOOK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("renwu.mp3")
			if (SwitchModel.getSwitchOpenState( ksSwitchGameBook , true )) then
				GameBookCtrl.create()
			end
		end
	end)
	if (SwitchModel.getSwitchOpenState( ksSwitchGameBook )) then
		widgetRoot.BTN_BOOK:setEnabled(true)
	else
		widgetRoot.BTN_BOOK:setEnabled(false)
	end

	--探索红点
	require "script/module/copy/ExplorMainCtrl"
	ExplorMainCtrl.setExplorRedByBtn(explorBtn)

	-- menghao 鸟的动画
	local aniBird = UIHelper.createArmatureNode({
		filePath = "images/effect/home/zhujiemian_niao.ExportJson",
		animationName = "zhujiemian_niao",
	})
	aniBird:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2 + 85))
	widgetRoot:addNode(aniBird, 3)

	createBackground()

	fnAddEventToButtons()

	-- menghao 0829 在线礼包按钮
	setOnlineReward()



	layMask = m_fnGetWidget(widgetRoot, "LAY_MASK")

	--显示好友红点
	-- updateFriendRedPoint()

	--占卜中心
	-- if (SwitchModel.getSwitchOpenState(ksSwitchStar, false)) then
	-- 	require "script/module/astrology/MainAstrologyModel"
	-- 	MainAstrologyModel.hasRedPoint()
	-- end
	-- logger:debug("占卜需要红点么？")
	-- logger:debug(g_redPoint.diviStar.visible)

	-- local imgTipAstr = m_fnGetWidget(widgetRoot,"IMG_TIP_ASTROLOGY")
	-- imgTipAstr:removeAllNodes()
	-- if (g_redPoint.diviStar.visible) then
	-- 	imgTipAstr:addNode(UIHelper.createRedTipAnimination())
	-- 	m_boatTipFlag.zb = true
	-- else
	-- 	m_boatTipFlag.zb = false
	-- end

	--显示邮件红点
	updateMailRedPoint()
	--回收系统红点
	updateRecoveryRedPoint()
	-- 聊天小红点
	upChatRedPoint()

	updateBagPoint("BTN_HERO") -- zhangqi, 2014-08-08, 根据是否招到新伙伴刷新红点状态
	updateBagPoint("BTN_EQUIP") -- zhangqi, 2014-08-08, 刷新装备按钮红点状态

	-- updateTrainRedPoint() --yn 修炼系统入口红点

	--二级菜单新版本
	fnAddSecMenuBtn()
	updateSecMenuBtnTip()  --yn 二级菜单红点
	updateWARedPoint()

	checkTipOnBtn() -- 每次创建主船场景时先即时刷新一下所有红点状态，避免定时刷新造成时间延迟

	GlobalScheduler.addCallback("checkTipOnBtn", checkTipOnBtn)

	-- 控制台
	if (g_debug_mode and g_tConsolStat.show) then
		logger:debug("add cmdBtn")
		createCmdBtn()
	end

	-- 清缓存按钮
	if (not g_web_env.online) then
		createClearBtn()
	end

	local btnAllShop = m_fnGetWidget(widgetRoot, "BTN_SHOP_TOTAL") --所有商店
	if AllShopData.isShowAllShopBtn() then
		btnAllShop:setEnabled(true)
	else
		btnAllShop:setEnabled(false)
	end

	require "script/module/guide/GuideCtrl"
	GuideCtrl.test()
	require "script/module/guide/GuideTreasView"
	if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 5) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createTreasGuide(6)
	end

	-- 开服狂欢
	require "script/module/newServerReward/OpenServerCtrl"
	widgetRoot.BTN_SEVEN_DAY:setVisible(false)
	widgetRoot.BTN_SEVEN_DAY:setTouchEnabled(false)
	UIHelper.labelNewStroke(widgetRoot.BTN_SEVEN_DAY.TFD_SEVEN_DAY)
	-- 是否显示入口
	if (not OpenServerModel.isClosed()) then
		if (widgetRoot) then
			widgetRoot.BTN_SEVEN_DAY:setVisible(true)
			widgetRoot.BTN_SEVEN_DAY:setTouchEnabled(true)
			-- 红点
			updateDayRewardRed()
			updateOpenServerCountdown()
		end

		widgetRoot.BTN_SEVEN_DAY:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playMainUIEffect()
				OpenServerCtrl.create()
			end
		end)
	end

	local bVis = FirstGiftData.isShowFirstGifts()
	widgetRoot.BTN_FIRST_RECHARGE:setEnabled(bVis)
	widgetRoot.BTN_RECHARGE:setEnabled(not bVis)
	regChatBubbleNotify()
	-- AppStore审核
  	if (Platform.isAppleReview()) then
  		widgetRoot.BTN_FIRST_RECHARGE:setVisible(false)
  		widgetRoot.BTN_FIRST_RECHARGE:setEnabled(false)
  	end

	return widgetRoot
end


-- menghao 更新聊天红点状态
function upChatRedPoint( ... )
	if (widgetRoot) then
		local imgTipChat = m_fnGetWidget(widgetRoot, "IMG_TIP_CHAT")
		if (imgTipChat) then
			logger:debug("chat red var ==")
			logger:debug(g_redPoint.chat.visible)
			if (g_redPoint.chat.visible) then
				imgTipChat:removeAllNodes()
				imgTipChat:addNode(UIHelper.createRedTipAnimination())
			else
				imgTipChat:removeAllNodes()
			end
		end
	end
end


local T_BIRD_BTN_TAG = 111111
local T_BIRD_ANI_TAG = 111112
--显示邮件红点
function updateMailRedPoint( ... )
	if(widgetRoot) then
		local layShip = m_fnGetWidget(widgetRoot, "LAY_SHIP")
		local IMG_SHIP = m_fnGetWidget(widgetRoot, "IMG_SHIP")

		layShip:removeNodeByTag(T_BIRD_ANI_TAG)
		layShip:removeChildByTag(T_BIRD_BTN_TAG,true)
		layShip:removeChildByTag(T_BIRD_BTN_TAG + 1,true)

		if ( g_redPoint.newMail.visible) then

			local binder = CCBattleBoneBinder:create()
			-- binder:setAnchorPoint(ccp(0.5,0.5))
			binder:setCascadeOpacityEnabled(true)

			local aniShip = layShip:getNodeByTag(10086)

			local function fnAddTouchLayer( tbargs )
				local layout  = Layout:create()
				layout:setSize(CCSizeMake(tbargs.nSizeWidth,tbargs.nSizeHeight))
				layout:setTouchEnabled(true)
				layout:setPositionY(tbargs.posY)
				layout:setPositionX(tbargs.posX)
				layShip:addChild(layout,10000,tbargs.tag)

				-- layout:setBackGroundColorType(LAYOUT_COLOR_SOLID) -- 设置单色模式
				-- layout:setBackGroundColor(ccc3(0x00, 0x00, 0x00))
				-- layout:setBackGroundColorOpacity(100)

				layout:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						logger:debug("点击信鸽，进入邮件")
						SecondMenuView.onMail(sender,TOUCH_EVENT_ENDED)
					end
				end)
			end

			local aniBird = UIHelper.createArmatureNode({
				filePath = "images/effect/home/youxiang.ExportJson",
				animationName =  "fly",
				fnMovementCall = function ( sender, MovementEventType , frameEventName)
					if (MovementEventType == 1) then
						sender:getAnimation():play("stand", -1, -1, -1)
						local tbargs = {}
						tbargs.nSizeWidth = 120
						tbargs.nSizeHeight = 130
						tbargs.posY = binder:getPositionY()
						tbargs.posX = binder:getPositionX() - 62
						tbargs.tag = T_BIRD_BTN_TAG
						fnAddTouchLayer(tbargs)
					end
				end
			})


			local animationBone = aniShip:getBone("xingge")
			binder:bindBone(animationBone)
			layShip:addNode(binder,123123,T_BIRD_ANI_TAG)
			--美术给的信鸽特效 和主船的船杆骨骼节点有错位，所以美术给量出了位移差，代码中手动设置位置
			aniBird:setPositionY(- 90)
			aniBird:setPositionX(-132)
			-- aniBird:getAnimation():setSpeedScale(0.451)
			binder:addChild(aniBird)

			local tbargs = {}
			tbargs.nSizeWidth = 160
			tbargs.nSizeHeight = 160
			tbargs.posY = 485
			tbargs.posX = 485 - 92
			tbargs.tag = T_BIRD_BTN_TAG + 1
			fnAddTouchLayer(tbargs)
		end
	end
end


function setRewardCenterBtnEnabled(bEnable)
	require "script/model/DataCache"
	DataCache.setRewardCenterStatus(bEnable)
	if UIHelper.isGood(m_btnReward) then
		m_btnReward:setEnabled(bEnable)
	end
end

function moduleName( ... )
	return "MainShip"
end


-- 开服狂欢红点
require "script/module/newServerReward/OpenServerModel"
function updateDayRewardRed( v )
	if (not widgetRoot.BTN_SEVEN_DAY:isVisible()) then
		return
	end
	local visible = v or OpenServerModel.isShowRed()
	widgetRoot.BTN_SEVEN_DAY.IMG_TIP_SEVEN:setVisible(visible)
	if (visible) then
		widgetRoot.BTN_SEVEN_DAY.IMG_TIP_SEVEN:removeAllNodes()
		widgetRoot.BTN_SEVEN_DAY.IMG_TIP_SEVEN:addNode(UIHelper.createRedTipAnimination())
	else
		widgetRoot.BTN_SEVEN_DAY.IMG_TIP_SEVEN:removeAllNodes()
	end
end

-- 开服7日有推送修改红点
function fnMSG_OPENSERVER_TIP( ... )
	logger:debug("fnMSG_CHARGE_OK")
	updateDayRewardRed()
end


--------------------二级菜单 新版本----------------------

local FRAME_TIME = 1/60

function fnAddSecMenuBtn( ... )
	widgetRoot.BTN_ENTER_UP:setEnabled(true)
	widgetRoot.BTN_ENTER_UP:setVisible(true)

	widgetRoot.BTN_ENTER_UP:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			SecondMenuView.addSecondMenu()
			updateSecMenuBtnByType(1)
			onMainEnter(sender, eventType) 
		end 
	end)

	SecondMenuView.updateSecMenuLayTip()  --更新二级菜单子按钮红点
end

--[[desc: 功能按钮动画
    arg1: type=1 执行打开动画。type＝0 关闭动画
    return: 是否有返回值，返回值说明  
—]]
function updateSecMenuBtnByType( type )
	if (not widgetRoot) then return end

	-- zhangqi,2015-12-28, 将按钮音效从BTN_ENTER_UP事件中移到此处才能保证隐藏子菜单的点击有音效
	AudioHelper.playBtnEffect("anniu_gongneng_zhankai.mp3")

	if (type==1) then 
		widgetRoot.BTN_ENTER_UP:setTouchEnabled(false)
		local delay = CCDelayTime:create(1*FRAME_TIME)
		local rotate1 = CCRotateTo:create(15*FRAME_TIME*18/19,180)
		local rotate11 = CCRotateTo:create(15*FRAME_TIME*1/19,190)
		local rotate2 = CCRotateTo:create(10*FRAME_TIME,180)
		local callback = CCCallFunc:create(function ( ... )
			widgetRoot.BTN_ENTER_UP:setTouchEnabled(true)
		end)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(rotate1)
		array:addObject(rotate11)
		array:addObject(rotate2)
		array:addObject(callback)
		local seq = CCSequence:create(array)
		widgetRoot.BTN_ENTER_UP:runAction(seq)
	else
		widgetRoot.BTN_ENTER_UP:setTouchEnabled(false)
		local delay = CCDelayTime:create(3*FRAME_TIME)
		local rotate1 = CCRotateTo:create(16*FRAME_TIME*18/19,0)
		local rotate11 = CCRotateTo:create(16*FRAME_TIME*1/19,-10)
		local rotate2 = CCRotateTo:create(10*FRAME_TIME,0)
		local callback = CCCallFunc:create(function ( ... )
			widgetRoot.BTN_ENTER_UP:setTouchEnabled(true)
		end)
		local array = CCArray:create()
		array:addObject(delay)
		array:addObject(rotate1)
		array:addObject(rotate11)
		array:addObject(rotate2)
		array:addObject(callback)
		local seq = CCSequence:create(array)
		widgetRoot.BTN_ENTER_UP:runAction(seq)
	end 
end

-- 功能按钮红点
function updateSecMenuBtnTip( ... )
	if (widgetRoot) then 
		if (SecondMenuView.getTipState()) then 
			widgetRoot.IMG_TIP_ENTER_UP:removeAllNodes()
			widgetRoot.IMG_TIP_ENTER_UP:addNode(UIHelper.createRedTipAnimination())
		else
			widgetRoot.IMG_TIP_ENTER_UP:removeAllNodes()
		end 
	end 
end

function getRobBtnWorldPos( ... )
	return tBtnWorldPos
end

function regChatBubbleNotify( ... )
	local img_chat = widgetRoot.IMG_CHAT
	img_chat:setVisible(false)
	GlobalNotify.addObserver(GlobalNotify.CHAT_BUBBLE, function ( ... )
		updateChatBubble()
	end, nil, "CHAT_BUBBLE")
end






-- 更新聊天气泡
function updateChatBubble( ... )
	if (LayerManager.curModuleName()=="MainShip" and widgetRoot) then 
		local chatData = ChatModel.getChatBubbleData()

		if (tonumber(chatData.sender_uid) == tonumber(UserModel.getUserUid()) or ChatModel.getCurTab()~=0) then 
			return 
		end

		local function refreashText( layout ,data)
			-- 2016.1.28  yn 线上报错ChatUtil的isBattleMsg方法为 nil，线下无法复现，不知原因，先添加容错处理
			if (ChatUtil.isBattleMsg and ChatUtil.isBattleMsg(data.message_text)) then 
				local battle_report_info = ChatUtil.getTable(data.message_text)
				local strMessage = "【".. battle_report_info[1] .. " VS " .. battle_report_info[2] .."】"
				layout.TFD_CONTENT:setText(strMessage) 
				layout.TFD_NAME:setText(data.sender_uname .. " ")
				layout:requestDoLayout() --刷新layout
			elseif (ChatUtil.isAudioMsg and ChatUtil.isAudioMsg(data.message_text)) then 
				local temp_arr = ChatUtil.getTable(data.message_text)
				local aid = temp_arr[1]
				layout.TFD_NAME:setText(data.sender_uname .. " ")
				layout.TFD_CONTENT:setText("") 

				local i=0
				local actionId = schedule(layout,function ( ... )
					local a_text = ChatModel.getAudioTextBy(aid)
					if (a_text or i > 5) then 
						layout:stopAction(actionId)
						layout.TFD_CONTENT:setText(a_text) 
						layout:requestDoLayout() --刷新layout
					else 
						ChatUtil.getRecordRext(i,aid)
					end  
					i=i+1
				end,1)	
			else 
				layout.TFD_CONTENT:setText(data.message_text) 
				layout.TFD_NAME:setText(data.sender_uname .. " ")
				layout:requestDoLayout() --刷新layout
			end 
		end


		-- 按钮特效
		local function addChatAni( ... )
			local animation = UIHelper.createArmatureNode({
				filePath = "images/effect/chat/home_chat.ExportJson",
				animationName = "home_chat",
				fnMovementCall = function ( armature,movementType,movementID )
					if(movementType == 1) then
						armature:removeFromParentAndCleanup(true)
						armature = nil
						widgetRoot.BTN_CHAT:setVisible(true)
					end
				end,
				bRetain = true,
			})
				
			widgetRoot.BTN_CHAT:setVisible(false)
			widgetRoot.img_bg_chat:addNode(animation)
			local posx,posy = widgetRoot.BTN_CHAT:getPosition()
			animation:setPosition(ccp(posx,posy))
			animation:setAnchorPoint(ccp(0.5,0.5))
			animation:setZOrder(1)
		end

		-- 背景的消失运动
		local function getBgActionHalf( callback )
			local array = CCArray:create()
			array:addObject(CCDelayTime:create(3))
			array:addObject(CCCallFunc:create(addChatAni))
			array:addObject(CCScaleTo:create(FRAME_TIME*5,1,1.1))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,1,0.5))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,0.2,0.5))
			array:addObject(CCScaleTo:create(FRAME_TIME*5,0,0))
			array:addObject(CCCallFunc:create(function ( ... )
				if (callback) then 
					callback()
				end 
			end))
			local seq = CCSequence:create(array)
			return seq
		end

		-- 背景完整的运动
		local function getBgActionAll( callback )
			local array = CCArray:create()
			array:addObject(CCScaleTo:create(FRAME_TIME*5,0.2,0.5))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,1,0.5))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,1,1.1))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,1,1))
			array:addObject(CCDelayTime:create(3))
			array:addObject(CCCallFunc:create(addChatAni))
			array:addObject(CCScaleTo:create(FRAME_TIME*5,1,1.1))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,1,0.5))
			array:addObject(CCScaleTo:create(FRAME_TIME*6,0.2,0.5))
			array:addObject(CCScaleTo:create(FRAME_TIME*5,0,0))
			array:addObject(CCCallFunc:create(function ( ... )
				if (callback) then 
					callback()
				end 
			end))
			local seq = CCSequence:create(array)
			return seq
		end

		local img_chat = widgetRoot.IMG_CHAT
		local secondLay = img_chat:getChildByTag(m_secBubbleLayTag)

		local function stopLayAction( ... )
			if (img_chat) then 
				img_chat.LAY_FIT:stopAllActions()
			end 
		end

		if (secondLay) then 
			logger:debug("上一个label正在运动中")
			return 
		end 


		local layfit_anum = img_chat.LAY_FIT:numberOfRunningActions()
		if (layfit_anum>0) then 
			logger:debug("label显示中")
			return 
		end 


		-- 背景框运动到一半,第二个label滑动进入，第一个label渐隐
		local img_anum = img_chat:numberOfRunningActions()

		if (img_anum > 0) then   
			img_chat:stopAllActions()
			img_chat:setVisible(true)
			img_chat:setScale(1)
			local bgAction = getBgActionHalf(stopLayAction)
			img_chat:runAction(bgAction)

			local layclone = tolua.cast(img_chat.LAY_FIT:clone(),"Layout")
			local laySize = layclone:getSize()
			secondLay = Layout:create()
			secondLay:setSize(CCSizeMake(laySize.width,laySize.height))
			secondLay:setClippingEnabled(true)
			img_chat:addChild(secondLay,1,m_secBubbleLayTag)
			secondLay:setPosition(ccp(-157,-19))
		
			refreashText(layclone,chatData)
			secondLay:addChild(layclone)
			layclone:setPosition(ccp(180,0))
			layclone:setPositionType(POSITION_ABSOLUTE)
			layclone.TFD_NAME:setOpacity(0)
			layclone.TFD_CONTENT:setOpacity(0)

			UIHelper.widgetFadeTo(layclone,FRAME_TIME*19,255)
			
			local array = CCArray:create()
			array:addObject(CCMoveTo:create(FRAME_TIME*19,ccp(0,0)))
			array:addObject(CCCallFunc:create(function ( ... )
				local name = layclone.TFD_NAME:getStringValue()
				img_chat.LAY_FIT.TFD_NAME:setText(name)
				img_chat.LAY_FIT.TFD_NAME:setOpacity(255)
				local content = layclone.TFD_CONTENT:getStringValue()
				img_chat.LAY_FIT.TFD_CONTENT:setText(content)
				img_chat.LAY_FIT.TFD_CONTENT:setOpacity(255)
				img_chat.LAY_FIT:requestDoLayout()
				img_chat.LAY_FIT:runAction(CCDelayTime:create(1))
				-- img_chat:removeChildByTag(m_secBubbleLayTag,true)
			end))

			array:addObject(CCCallFunc:create(function ( ... )
				img_chat:removeChildByTag(m_secBubbleLayTag,true)
			end))
			local seq = CCSequence:create(array)
			layclone:runAction(seq)

			-- 渐变
			UIHelper.widgetFadeTo(img_chat.LAY_FIT,FRAME_TIME*10,0)
			return 
		end 

		-- 有按钮特效的提示
		img_chat:stopAllActions()
		img_chat.LAY_FIT:stopAllActions()
		refreashText(img_chat.LAY_FIT,chatData)
		img_chat.TFD_NAME:setOpacity(255)
		img_chat.TFD_CONTENT:setOpacity(255)
		img_chat:setVisible(true)
		img_chat:setScale(0)

		img_chat:runAction(getBgActionAll(stopLayAction))
		img_chat.LAY_FIT:runAction(CCDelayTime:create(1))
		addChatAni()
	end 
end

-- 开服狂欢倒计时
function updateOpenServerCountdown( ... )
	widgetRoot.BTN_SEVEN_DAY:setVisible(false)
	widgetRoot.BTN_SEVEN_DAY:setTouchEnabled(false)
	if (OpenServerModel.isClosed()) then
		return
	end
	local now = TimeUtil.getSvrTimeByOffset()
	local closeTime = OpenServerModel.getCloseDay()
	local delta = math.max(closeTime - now, 0)
	widgetRoot.BTN_SEVEN_DAY:setVisible(true)
	widgetRoot.BTN_SEVEN_DAY:setTouchEnabled(true)
	-- 是否小于一天
	if (delta <= 24 * 3600) then
		local timeStr = OpenServerModel.getCountdown(closeTime)
		widgetRoot.BTN_SEVEN_DAY.TFD_SEVEN_DAY:setText(timeStr)
		widgetRoot.BTN_SEVEN_DAY.TFD_SEVEN_DAY:setVisible(true)
	else
		widgetRoot.BTN_SEVEN_DAY.TFD_SEVEN_DAY:setVisible(false)
	end
end


-- FileName: BellyBattleWin.lua
-- Author: liweidong
-- Date: 2015-01-15
-- Purpose: 贝利副本战斗胜利
--[[TODO List]]

module("BellyBattleWin", package.seeall)

-- UI控件引用变量 --
local layoutMain

-- 模块局部变量 --
local m_i18n = gi18n
local c3Stroke = ccc3(0xca, 0x1e, 0x04)

local function init(...)

end

function destroy(...)
	package.loaded["BellyBattleWin"] = nil
end

function moduleName()
    return "BellyBattleWin"
end

-- zhangqi, 2015-10-10, 补国际化
local function init_i18n( layRoot )
	layRoot.tfd_desc:setText(m_i18n[5957])
	UIHelper.labelAddNewStroke(layRoot.TFD_ATTACK_TXT, m_i18n[6037], c3Stroke)
	UIHelper.labelAddNewStroke(layRoot.TFD_BELLY_TXT, m_i18n[1328],c3Stroke)
end
function addArrowAction( node )
	if (not node) then
		return
	end

	local ct = 1.5 -- 渐隐渐现总时长 1.5秒
	local arrAct = CCArray:create()
	arrAct:addObject(CCFadeIn:create(ct/2))
	arrAct:addObject(CCFadeOut:create(ct/2))
	-- arrAct:addObject(CCMoveBy:create(0.05,ccp(0,1)))
	local act = CCRepeatForever:create(CCSequence:create(arrAct))
	node:runAction(act)

end
--[[desc:创建贝利战斗胜利结算面板
    arg1: id,hurt,belly 活动副本id，总伤害值 获得贝利
    return: nil
—]]
function create(id,hurt,belly)
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			) 
		--副本标签
		local mainLayout = g_fnLoadUI("ui/acopy_money_finish.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		init_i18n(mainLayout) -- zhangqi, 2015-10-10, 处理国际化

		function onSureBtn(sender, eventType)
			if (eventType ~= TOUCH_EVENT_ENDED) then
				AudioHelper.resetAudioState()  
				AudioHelper.playBtnEffect("buttonbuy.mp3")
				-- AudioHelper.playCommonEffect()
				require ("script/battle/notification/EventBus")
				EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
				-- AudioHelper.playSceneMusic("fight_easy.mp3")
				AudioHelper.playMainMusic()
			end
		end

		local sureBtn = g_fnGetWidgetByName(layoutMain, "BTN_CONFIRM")
		sureBtn:addTouchEventListener(onSureBtn)
		UIHelper.titleShadow(sureBtn)
		--初始化贝利奖励
		local db=DB_Activitycopy.getDataById(id)
		local rankArr=lua_string_split(db.dps, "|")
		local bellyArr=lua_string_split(db.belly, "|")
		local curRankNum = 0
		local beforRank=900000000
		for i=#rankArr,1,-1 do
			if (tonumber(hurt)<beforRank and tonumber(hurt)>=tonumber(rankArr[i]) ) then
				curRankNum = i
			end
			beforRank= tonumber(rankArr[i])
		end
		--初始化list
		UIHelper.initListView(layoutMain.LSV_PREVIEW)
		UIHelper.initListWithNumAndCell(layoutMain.LSV_PREVIEW,#rankArr)
		for i=#rankArr,1,-1 do
			local realCell = layoutMain.LSV_PREVIEW:getItem(i-1)
			realCell.TFD_RANK:setText(rankArr[i])
			realCell.TFD_GOLD:setText(bellyArr[i]*OutputMultiplyUtil.getDailyCopyRateNum(id)/10000)
			if (i==curRankNum) then
				--高亮当前行
				realCell.TFD_RANK:setColor(ccc3(0xff,0xea,0))
				realCell.TFD_RANK:setFontSize(24)
				realCell.TFD_GOLD:setColor(ccc3(0x32,0xcd,0x32))
				realCell.TFD_GOLD:setFontSize(24)
				realCell.img_bg_rank:setVisible(true)
			else
				realCell.TFD_RANK:setColor(ccc3(0xC3,0x3D,0x02))
				realCell.TFD_RANK:setFontSize(24)
				realCell.TFD_GOLD:setColor(ccc3(0x00,0x62,0x0C))
				realCell.TFD_GOLD:setFontSize(24)
				realCell.img_bg_rank:setVisible(false)
			end
		end
		performWithDelayFrame(layoutMain,function()
				local cell = tolua.cast(layoutMain.LSV_PREVIEW:getItem(curRankNum>0 and (curRankNum-1) or 0),"Widget")
				local posy = -cell:getPositionY()+layoutMain.LSV_PREVIEW:getSize().height-cell:getSize().height-layoutMain.LSV_PREVIEW:getItemsMargin()
				if (posy > 0 ) then
					posy =0
				end
				layoutMain.LSV_PREVIEW:setJumpOffset(ccp(layoutMain.LSV_PREVIEW:getJumpOffset().x,posy))
			end,2)

		--两个箭头
		schedule(layoutMain,function()
				local cellTop = tolua.cast(layoutMain.LSV_PREVIEW:getItem(0),"Widget")
				local cellBottom = tolua.cast(layoutMain.LSV_PREVIEW:getItem(#rankArr-1),"Widget")

				local posList = layoutMain.LSV_PREVIEW:convertToWorldSpace(ccp(0,0))
				local posBcell = cellBottom:convertToWorldSpace(ccp(0,0))
				local posTcell = cellTop:convertToWorldSpace(ccp(0,0))

				if (posTcell.y>posList.y+layoutMain.LSV_PREVIEW:getSize().height) then
					-- layoutMain.IMG_ARROW_UP:setVisible(true)
				else
					layoutMain.IMG_ARROW_UP:setVisible(false)
				end

				if (posBcell.y+cellBottom:getContentSize().height<posList.y) then
					-- layoutMain.IMG_ARROW_DOWN:setVisible(true)
				else
					layoutMain.IMG_ARROW_DOWN:setVisible(false)
				end
			end,0.01)
		layoutMain.IMG_ARROW_DOWN:setVisible(false)
		layoutMain.IMG_ARROW_UP:setVisible(false)
		addArrowAction(layoutMain.IMG_ARROW_UP:getVirtualRenderer())
		performWithDelay(layoutMain,function() --两个一块闪看着太难受
				addArrowAction(layoutMain.IMG_ARROW_DOWN:getVirtualRenderer())
			end,0.1)


		--总伤害值
		local atckNum = g_fnGetWidgetByName(layoutMain, "TFD_ATTACK_NUM")
		UIHelper.labelAddNewStroke(atckNum, hurt, c3Stroke)

		--获得贝利
		local bellyNum = g_fnGetWidgetByName(layoutMain, "TFD_BELLY_NUM")
		UIHelper.labelAddNewStroke(bellyNum, belly, c3Stroke)

		local tfd_dps = g_fnGetWidgetByName(layoutMain, "tfd_dps")
		local tfd_money = g_fnGetWidgetByName(layoutMain, "tfd_money")

		UserModel.addSilverNumber(tonumber(belly))--增加贝利
		MainCopyModel.subBattleTimes(id)  --减少活动副本战斗次数
		UserModel.addEnergyValue(-1*tonumber(db.attack_energy)) -- 减少体力
		local baseId = BellyChanlage.getBaseId()
		local dbBase=DB_Stronghold.getDataById(baseId)
		--增加经验并判断升级
		if (not UserModel.hasReachedMaxLevel()) then
			local nAddExp=dbBase.exp_simple
			local tbUserInfo = UserModel.getUserInfo()
			local tUpExp = DB_Level_up_exp.getDataById(2)
			local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
			local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
			local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
			local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp; -- 获得经验后是否升级
			if (bLvUp) then
				performWithDelay(layoutMain,function()
							require "script/module/public/GlobalNotify"
							GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,createTreasureNotice(BattleMainData.extra_rewardRet))
						end,
						0)
			end
			UserModel.addExpValue(nAddExp*UserModel.getHeroLevel()*OutputMultiplyUtil.getDailyCopyRateNum(id)/10000,"dobattle")
		end

		MainCopyCtrl.updateUI()  --更新UI

		local IMG_TITLE=g_fnGetWidgetByName(layoutMain, "IMG_TITLE")
		local IMG_RAINBOW=g_fnGetWidgetByName(layoutMain, "IMG_RAINBOW")
		local winAnimation = EffBattleWin:new({imgTitle = IMG_TITLE, imgRainBow = IMG_RAINBOW})

		--发送战报
		layoutMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
					if (eventType ~= TOUCH_EVENT_ENDED) then
						return
					end
					AudioHelper.playSendReport()
					local modName,baseName
					local db=DB_Activitycopy.getDataById(id)
					local baseDb = DB_Stronghold.getDataById(baseId)
					modName = db.name --gi18n[7808] --"日常副本"
					baseName = baseDb.name
					UIHelper.sendBattleReport(BattleState.getBattleBrid(),modName,baseName)
				end)
	end
	--播放背景音乐
	require "script/module/config/AudioHelper"
	AudioHelper.playMusic("audio/bgm/sheng.mp3",false)

	return layoutMain
end

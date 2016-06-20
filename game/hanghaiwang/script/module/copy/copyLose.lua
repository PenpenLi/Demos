-- FileName: copyLose.lua
-- Author: zhangqi
-- Date: 2014-04-11
-- Purpose: 战斗失败结算面板
-- Modified:
-- zhangqi, 2014-08-06, 引导按钮去掉宠物，BTN_MINGJIANG事件改成打开阵容

module("copyLose", package.seeall)

require "script/GlobalVars"
require "script/utils/LuaUtil"
require "script/module/public/ShowNotice"
require "script/module/public/EffectHelper"
-- UI控件引用变量 --
local layMain -- 战斗结算界面
local labTeamName -- 小队名称 "TFD_NAME"
local layDgree -- 难度等级统一引用 "LAY_HARD" .. 1[2, 3]
local labTxtTips -- 面板提示信息 "TFD_INFO"
local btnHero -- 武将强化按钮 "BTN_WUJIANG"
local btnEquip -- 装备强化按钮 "BTN_ZHUANGBEI"
local btnKnown -- 培养名将按钮 "BTN_MINGJIANG"
local btnConfirm -- 确认按钮 "BTN_CONFIRM"

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local fnSetStar -- 设置达成的难度星数
local m_tbCopyStat -- 本次战斗结束的副本状态


local function init(...)

end

function destroy(...)
	package.loaded["copyLose"] = nil
end

function moduleName()
	return "copyLose"
end

--[[desc: 创建普通副本和精英副本战斗失败结算面板
    nBaseId: 据点id
    nDegree: 难易程度
    tbCopyStat: table, 后端返回战斗结果里的 newcopyorbase 字段
    sAppraise: string, 战斗评价，2014-08-16，add by zhangqi
    return: widget对象
—]]
function create( nBaseId, nDegree, tbCopyStat, sAppraise )
	logger:debug("nBaseId = %d, nDegree = %d, sAppraise = %s", nBaseId, nDegree, sAppraise or "nil")
	logger:debug(tbCopyStat)

	m_tbCopyStat = tbCopyStat

	layMain = g_fnLoadUI("ui/copy_lose.json")
	-- add by huxiaozhou 2014-11-26  成就系统新成就达成延时处理关闭结算面板后弹出
	UIHelper.registExitAndEnterCall(layMain, nil,function ( ... )
		layMain=nil
		PreRequest.setIsCanShowAchieveTip(true)
	end)

	-- 绑定确定按钮事件 
	-- btnConfirm = m_fnGetWidget(layMain, "BTN_CONFIRM")
	-- UIHelper.titleShadow(btnConfirm, m_i18n[1029])
	local function eventConfirm( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("战斗结束音乐状态恢复")
			AudioHelper.resetAudioState()  --音乐状态恢复到战斗前
			AudioHelper.playCommonEffect()
			require ("script/battle/notification/EventBus")
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
			--liweidong 战斗失败音效结束后无副本音乐，但战斗胜利后副本音乐正常
			if (copyWin.battalCopyType==1) then --精英副本隐藏得星
				require "script/module/copy/itemCopy"
				itemCopy.playCopyAudio()
			elseif (copyWin.battalCopyType==3 or copyWin.battalCopyType==2) then  --日常副本音乐修改需求
				-- AudioHelper.playSceneMusic("fight_easy.mp3")
				AudioHelper.playMainMusic()
			else
				AudioHelper.playMainMusic()
			end
		end
	end
	layMain:setTouchEnabled(true)
	layMain:addTouchEventListener(eventConfirm)
	logger:debug("btnConfirm ok")

	require "db/DB_Stronghold"
	local tbHold = DB_Stronghold.getDataById(nBaseId) --据点信息

	-- 怪物小队名称
	labTeamName = m_fnGetWidget(layMain, "TFD_NAME")
	labTeamName:setText(tbHold.name)
	UIHelper.labelNewStroke( labTeamName, ccc3(0x00,0x00,0x00), 3 )

	labTxtTips = m_fnGetWidget(layMain, "TFD_INFO")
	labTxtTips:setText(gi18nString(1996,""))
	-- 怪物小队难度及星数
	fnSetStar(tbHold, nDegree)

	-- 战斗力
	local labnFightNum = m_fnGetWidget(layMain, "TFD_ZHANDOULI_NUM")
	labnFightNum:setText(tostring(UserModel.getFightForceValue()))
	local labnFightTxt = m_fnGetWidget(layMain, "TFD_ZHANDOULI_TXT")
	--UIHelper.labelNewStroke( labnFightTxt, ccc3(0xff,0xcd,0x75), 2 )


	local lay_btn = layMain.LAY_WITH_REPORT
	layMain.LAY_WITHOUT_REPORT:setEnabled(false)

	if (copyWin.battalCopyType==4 or copyWin.battalCopyType==3) then 
		lay_btn = layMain.LAY_WITHOUT_REPORT 
		layMain.LAY_WITH_REPORT:setEnabled(false)
		layMain.LAY_WITHOUT_REPORT:setEnabled(true)
	end 

	btnHero = m_fnGetWidget(lay_btn, "BTN_WUJIANG")
	btnHero:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			eventConfirm(nil, TOUCH_EVENT_ENDED)
			require "script/module/partner/MainPartner"
			LayerManager.changeModule(MainPartner.create(), MainPartner.moduleName(), {1, 3})
			PlayerPanel.addForPartnerStrength()
			require "script/module/main/MainScene"
			MainScene.changeMenuCircle(1)
		end
	end)

	btnEquip = m_fnGetWidget(lay_btn, "BTN_ZHUANGBEI")
	btnEquip:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			eventConfirm(nil, TOUCH_EVENT_ENDED)
			require "script/module/equipment/MainEquipmentCtrl"
			LayerManager.changeModule(MainEquipmentCtrl.create(), MainEquipmentCtrl.moduleName(), {1, 3})
			PlayerPanel.addForPartnerStrength()
			require "script/module/main/MainScene"
			MainScene.changeMenuCircle(1)
		end
	end)

	btnKnown = m_fnGetWidget(lay_btn, "BTN_MINGJIANG")
	btnKnown:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			eventConfirm(nil, TOUCH_EVENT_ENDED)
			-- require "script/module/main/MainScene"
			-- MainScene.onFormation(nil, TOUCH_EVENT_ENDED)

			require "script/module/switch/SwitchModel"
			if(not SwitchModel.getSwitchOpenState(ksSwitchFormation,true)) then
				return
			end

			require "script/module/formation/MainFormation"
			if (MainFormation.moduleName() ~= LayerManager.curModuleName()) then
				local layFormation = MainFormation.create(0)
				if (layFormation) then
					LayerManager.changeModule(layFormation, MainFormation.moduleName(), {1,3}, true)
				end
				MainScene.updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
			end
		end
	end)

	logger:debug("copyLose ok")
	--特效
	local layout = Layout:create() --屏蔽层
	layout:setTouchEnabled(true)
	layout:setSize(g_winSize)
	layMain:addChild(layout)

	layMain.LAY_EFFECT1:setVisible(false)
	local propertyEffects = {layMain.LAY_EFFECT1}
	local IMG_BG = m_fnGetWidget(layMain,"IMG_TITLE")
	local IMG_TITLE = m_fnGetWidget(layMain,"IMG_TITLE_EFFECT")
	EffBattleLose:new(IMG_BG,IMG_TITLE,function()
			palyPropertyEffect(propertyEffects,function()
					layout:removeFromParent()
				end)
		end)

	local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_continue.ExportJson",
			animationName = "fadein_continue",
			loop = 1,
		})
	armature2:setAnchorPoint(ccp(layMain.IMG_FADEIN_EFFECT:getAnchorPoint().x, layMain.IMG_FADEIN_EFFECT:getAnchorPoint().y))
	armature2:setPosition(ccp(layMain.IMG_FADEIN_EFFECT:getPositionX(), layMain.IMG_FADEIN_EFFECT:getPositionY()))
	layMain:addNode(armature2)
	--播放背景音乐
	require "script/module/config/AudioHelper"
	AudioHelper.playMusic("audio/bgm/bai.mp3",false)
	if (itemCopy.isInItemCopy() and nDegree==3) then --精英副本
		UserModel.addEnergyValue(-1*tonumber(tbHold["cost_energy_hard"])) -- 减少体力
	end
	--发送战报
	if (copyWin.battalCopyType==4) then
		layMain.BTN_REPORT:setTouchEnabled(false)
	end

	local tbname = { gi18n[7821],gi18n[7822],gi18n[7823] }   -- 副本简单级  副本困难级  副本炼狱级

	layMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playSendReport()
				local modName,baseName
				if (copyWin.battalCopyType==1) then
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					local copyDb = DB_Copy.getDataById(baseDb.copy_id)
					modName = tbname[nDegree] .. copyDb.name
					baseName = baseDb.name
				end
				if (copyWin.battalCopyType==2) then
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					modName = gi18n[7809] --"精英副本"
					baseName = baseDb.name
				end
				if (copyWin.battalCopyType==3) then
					local db=DB_Activitycopy.getDataById(ChanglageMonster.getCopyId())
					local baseDb = DB_Stronghold.getDataById(nBaseId)
					modName = db.name --gi18n[7808] --"日常副本"
					baseName = baseDb.name
				end
				UIHelper.sendBattleReport(BattleState.getBattleBrid( ),modName,baseName)
			end)
	-- if (copyWin.battalCopyType==4 or copyWin.battalCopyType==3) then
	-- 	layMain.BTN_LOOKUP_REPORT:setTouchEnabled(false)
	-- end
	if (copyWin.battalCopyType~=4 and copyWin.battalCopyType~=3) then 
		lay_btn.BTN_LOOKUP_REPORT:addTouchEventListener(function( sender, eventType )
					if (eventType ~= TOUCH_EVENT_ENDED) then
						return
					end
					AudioHelper.playStrategy()
					eventConfirm(sender, eventType)
					local copyId,baseName,copyType
					if (copyWin.battalCopyType==1) then
						local baseDb = DB_Stronghold.getDataById(nBaseId)
						copyId = baseDb.copy_id
						baseName = baseDb.name
						copyType = 1
					end
					if (copyWin.battalCopyType==2) then
						local baseDb = DB_Stronghold.getDataById(nBaseId)
						copyId = baseDb.copy_id
						baseName = baseDb.name
						copyType = 2
					end
					tbData={
				        type=copyType,-- 类型 普通副本＝1，精英副本＝2，觉醒副本＝3，深海＝4，世界boss＝5,
				        name = baseName, --据点名称（世界boss传boss名称，深海传当前层：第xx层）,
				        param1 = copyId, --普通副本，精英副本，觉醒副本传副本ID；深海传当前层数，世界boss传boss ID
				        param2 = nBaseId, --普通副本，觉醒副本传据点id ，其他模块不用传
				        param3 = nDegree, --普通副本 传据点难度，其他不需要
				        callback1 = nil,--攻略页面点查看战报时调用，可传nil，,   (用于世界boss处理音乐)
				        callback2 = nil, --查看战报战斗播放结束，结算面板关闭时调用，可传nil, (用于世界boss处理音乐)
				    }
					StrategyCtrl.create( tbData )
				end)
	end 

	
	return layMain
end -- end for create

--[[desc: 根据据点id返回当前已通关的难度程度
    nBaseId: 某个据点id
    nCopyId: 据点所在副本id
    return: number, 1，通关简单；2，普通；3，困难
—]]
local function getBasePassStat(nBaseId, nCopyId,difficult)
	logger:debug("enter getBasePassStat")
	logger:debug(m_tbCopyStat)

	local curNetData = DataCache.getNormalCopyData().copy_list
	if (curNetData[""..nCopyId]
		and curNetData[""..nCopyId].va_copy_info.baselv_info
		and curNetData[""..nCopyId].va_copy_info.baselv_info[""..nBaseId] 
		and curNetData[""..nCopyId].va_copy_info.baselv_info[""..nBaseId][""..difficult] 
		and curNetData[""..nCopyId].va_copy_info.baselv_info[""..nBaseId][""..difficult].score) then
		return tonumber(curNetData[""..nCopyId].va_copy_info.baselv_info[""..nBaseId][""..difficult].score)
	end

	return 0 -- 数据异常默认没有
end

--[[desc: 根据据点难度和通关难度确定星级的显示
    tbBaseInfo: 当前据点信息
    nBaseDegree: 本次战斗的难易程度
    bScored: 是否获得副本得分
    return: 是否有返回值，返回值说明
—]]
fnSetStar = function ( tbBaseInfo, nBaseDegree, bScored )
	print_t(tbBaseInfo)

	local nMaxDegree = 3

	local curDegree = nBaseDegree == 0 and 1 or nBaseDegree -- 当前难度，如果是NPC战，难度按简单

	local nPassStar = getBasePassStat(tbBaseInfo.id, tbBaseInfo.copy_id,curDegree)
	logger:debug("curDegree = %d, nPassStar = %d, nBaseDegree = %d, nMaxDegree = %d", curDegree, nPassStar, nBaseDegree, nMaxDegree)
	local strHardName = "LAY_HARD" .. nMaxDegree
	local layStar = m_fnGetWidget(layMain, strHardName)
	layStar:setVisible(true) -- 应该显示的星星容器

	----得星条件
	-- local star2 = m_fnGetWidget(layMain, "IMG_CONDITION2")
	-- star2:setVisible(false)
	-- local star3 = m_fnGetWidget(layMain, "IMG_CONDITION3")
	-- star3:setVisible(false)
	-- local star4 = m_fnGetWidget(layMain, "IMG_CONDITION4")
	-- star4:setVisible(false)
	
	require "script/module/copy/copyWin"
	if (copyWin.battalCopyType==2 or copyWin.battalCopyType==3 or copyWin.battalCopyType==4) then --精英副本隐藏得星
		layStar:setEnabled(false)
		layStar:setVisible(false)
		return
	end
	-- 根据 nPassStar 的数量将默认的灰星替换成亮星
	for i = 1, nMaxDegree do
		local imgStar = m_fnGetWidget(layStar, "IMG_STAR" .. nMaxDegree .."_" .. i)
		if (i > nPassStar) then
			imgStar:loadTexture("ui/star_big_ash.png")
		else
			imgStar:loadTexture("images/common/star_big_win.png")
		end
	end
	

	local strTerms = lua_string_split(tbBaseInfo.get_star_id, ",")
	local term = lua_string_split(strTerms[tonumber(curDegree)], "|")
	strTerm=term[1]

	require "db/DB_Get_star"
	local getStarDb = DB_Get_star.getDataById(strTerm)
	-- local starn = m_fnGetWidget(layMain, "IMG_CONDITION"..getStarDb.type)
	-- starn:setVisible(true)
end

-- FileName: AwakeWinCtrl.lua
-- Author: LvNanchun
-- Date: 2015-11-17
-- Purpose: function description of module
--[[TODO List]]

module("AwakeWinCtrl", package.seeall)

-- UI variable --

-- module local variable --
local _awakeInstance
local _tbBattleData
-- 每行的图标数目
local ROW_NUM = 4
local _fnGetWidget = g_fnGetWidgetByName

local function init(...)

end

function destroy(...)
    package.loaded["AwakeWinCtrl"] = nil
end

function moduleName()
    return "AwakeWinCtrl"
end

--[[desc:关闭事件
    arg1: 
    return:无
—]]
local fnBtnClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.resetAudioState() --还原战斗前音乐状态
		AudioHelper.playCommonEffect()
		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	end
end

-- 进入界面的回调
local function onEnterCall( ... )
	
end

-- 退出界面的回调
local function onExitCall(  )
	logger:debug("onExitCall")

end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnTouchStar( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		local function showImgReach( layRoot, idx )
			local imgReach = _fnGetWidget(layRoot, "IMG_REACH" .. idx)
			imgReach:setEnabled(true)
	
			local imgNoReach = _fnGetWidget(layRoot, "IMG_NOREACH" .. idx)
			imgNoReach:setEnabled(false)
		end
		local starLayout = g_fnLoadUI("ui/copy_get_star.json")
		local tbBaseInfo = DB_Stronghold.getDataById(_tbBattleData.strongholdId)
		local strTerms = lua_string_split(tbBaseInfo.get_star_id, ",")

		local term = lua_string_split(strTerms[1], "|")

		for i=1,3 do
			local starStatusLb = _fnGetWidget(starLayout, "TFD_STAR" .. i)
			require "db/DB_Get_star"
			local getStarDb = DB_Get_star.getDataById(term[i])
			starStatusLb:setText(i.."."..getStarDb.description)

			-- zhangqi, 2015-10-09, 初始化隐藏已达成图片
			local imgReach = _fnGetWidget(starLayout, "IMG_REACH" .. i)
			imgReach:setEnabled(false)
		end
		for i=1,_tbBattleData.score do
			local starStatusLb = _fnGetWidget(starLayout, "TFD_STAR" .. i)
			local starAshImg = _fnGetWidget(starLayout, "IMG_STAR_ASH" .. i)
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
		local closeBtn = _fnGetWidget(starLayout, "BTN_CLOSE")
		closeBtn:addTouchEventListener(closeStar)
		local sureBtn = _fnGetWidget(starLayout, "BTN_ENSURE")
		sureBtn:addTouchEventListener(closeStar)
		UIHelper.titleShadow(sureBtn)
		
		LayerManager.addLayout(starLayout)
	end
end

--[[desc:发送战报
    arg1: 
    return:
—]]
local function fnBtnSendReport( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playSendReport()
		local modName,baseName
		local baseDb = DB_Stronghold.getDataById(_tbBattleData.strongholdId)
		local copyDb=DB_Disillusion_copy.getDataById(_tbBattleData.copyId)
		modName = copyDb.name --"日常副本"
		baseName = baseDb.name
		UIHelper.sendBattleReport(BattleState.getBattleBrid(),modName,baseName)
	end
end

--[[desc:播放奖励的特效，从战斗力条之后的
    arg1: 无
    return: 无
—]]
local function beginAddReward( ... )
	-- 加贝里
	UserModel.addSilverNumber(_tbBattleData.combineResult.silver)
	-- 构建奖励效果的table
	local tbInfo = {}
	tbInfo.silver = _tbBattleData.combineResult.silver
	tbInfo.exp = _tbBattleData.combineResult.exp
	
	_awakeInstance:playRewardAction( tbInfo )
end

--[[desc:添加卡牌背面动画
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
local function addCardEffect( effectItemBg, playNextFrameEffect )

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

--[[desc:排序函数
    arg1: 
    return: 
—]]
local function fnSortItem( item1, item2 )
	if (item1.dbInfo.affix_type == 1 and item2.dbInfo.affix_type ~= 1) then
		return true
	end
	if (item1.dbInfo.quality < item2.dbInfo.quality) then
		return true
	end
	if (item1.dbInfo.id < item2.dbInfo.id) then
		return true
	end
	return false
end

--[[desc:完善物品信息并排序
    arg1: 物品列表
    return: 完善后的列表
—]]
local function sortDropItems( tbItem )
	-- 完善物品信息
	for k,v in pairs(tbItem) do 
		tbItem[k].dbInfo = ItemUtil.getItemById(v.item_template_id)
		tbItem[k].fnAddEffect = addCardEffect
	end

	logger:debug({tbItem = tbItem})
	-- 暂时先不排序
--	table.sort(tbItem, fnSortItem)

	-- 用占位表填补到4的倍数方便在后面设置listview
	local remainNum = 4 - #tbItem % 4
	for i = 1,remainNum do
		tbItem[#tbItem + 1] = {disable = true}
	end

	return tbItem
end

--[[desc:功能简介
    arg1: 从战斗模块传来的数据，包含以下字段。copyId,strongholdId, combineResult,newcopyorbase
    	combineResult包含以下字段
    	combineResult.exp 				= 0
		combineResult.silver 			= 0
		combineResult.soul 			= 0
		combineResult.hero    			= {}
		combineResult.item 			= {}
		combineResult.cur_drop_item 	= {}
    return: 胜利面板  
—]]
function create( tbBattleData )
--	local tbBattleData = {}
--	tbBattleData.strongholdId = 501001
--	tbBattleData.score = 2
--	tbBattleData.combineResult = {}
--	tbBattleData.combineResult.exp = 200
--	tbBattleData.combineResult.silver = 1000
--
--	tbBattleData.combineResult = {
--		hero = {},
--		exp = 69500,
--		cur_drop_item = {},
--		item = {
--			{
--				num = 3,
--				item_template_id = "811001"
--			},
--			{
--				num = 3,
--				item_template_id = "811002"
--			},
--			{
--				num = 3,
--				item_template_id = "811003"
--			}	
--		},
--			
--		silver = 125,
--		soul = 0
--	}

	-- 将战斗模块传来的数据放在一个全局变量中供函数取用
	_tbBattleData = tbBattleData

	-- 将后端数据给副本模块以获得正确的星数
	copyAwakeModel.addCopyData(tbBattleData.newcopyorbase)

	_tbBattleData.score = tonumber(copyAwakeModel.getHoldStarNumber(tbBattleData.copyId, tbBattleData.strongholdId))

	logger:debug({tbBattleData = tbBattleData})

	-- 获取体力扣体力
	local strongholdInfo = DB_Stronghold.getDataById(tbBattleData.strongholdId)
	local nEnergy = strongholdInfo.cost_energy_simple
	if (nEnergy) then
		UserModel.addEnergyValue(-(tonumber(nEnergy)))
	end

	local userInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(userInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(UserModel.getUserInfo().exp_num) -- 当前的经验值
	logger:debug({_tbBattleData = _tbBattleData})

	local tbCtorInfo = {}
	tbCtorInfo.nowExp = nExpNum
	tbCtorInfo.needExp = nLevelUpExp
	tbCtorInfo.level = nCurLevel
	tbCtorInfo.fightNum = UserModel.getFightForceValue()
	tbCtorInfo.strongHoldName = DB_Stronghold.getDataById(_tbBattleData.strongholdId).name
	tbCtorInfo.score = tonumber(copyAwakeModel.getHoldStarNumber(tbBattleData.copyId, tbBattleData.strongholdId))
	tbCtorInfo.beginAddReward = beginAddReward
	tbCtorInfo.silver = tbBattleData.combineResult.silver
	tbCtorInfo.exp = tbBattleData.combineResult.exp
	tbCtorInfo.reward = sortDropItems(tbBattleData.combineResult.item)
	tbCtorInfo.bUpLevel = (tbCtorInfo.exp + tbCtorInfo.nowExp) > tbCtorInfo.needExp

	_awakeInstance = AwakeWinView:new( tbCtorInfo )

	-- 构造按钮事件table
	local tbBtnFn = {}
	tbBtnFn.close = fnBtnClose
	tbBtnFn.star = fnTouchStar
	tbBtnFn.onExitCall = onExitCall
	tbBtnFn.onEnterCall = onEnterCall
	tbBtnFn.sendReport = fnBtnSendReport

	local awakeView = _awakeInstance:create( tbBtnFn )

	AudioHelper.playMusic("audio/bgm/sheng.mp3",false)

	return awakeView
end


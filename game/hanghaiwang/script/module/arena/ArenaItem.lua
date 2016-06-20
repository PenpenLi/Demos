-- FileName: ArenaItem.lua
-- Author: huxiaozhou
-- Date: 2014-04-00
-- Purpose: 竞技场界面小船 等等



module("ArenaItem", package.seeall)

require "script/module/arena/ArenaData"
require "script/module/public/EffectHelper"

local arena_challenge_json = "ui/arena_challenge.json"
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

m_fnCallBack = nil
local m_boat = nil
local function init(...)
	m_fnCallBack = nil
	m_boat = nil
end

function destroy(...)
	if m_boat then
		m_boat:release()
		m_boat=nil
	end
	
	package.loaded["ArenaItem"] = nil
end

function moduleName()
    return "ArenaItem"
end

function createNext( atkedUid,atk, isNeedReload, isUp, position, flopData, rise, tbChangeInfo)
    	if(atk == nil)then
    		return
    	end
		local function nextCallFun()
			local coin = nil
			local exp = nil
			local prestige = nil
			if(atk.appraisal ~= "E" and atk.appraisal ~= "F")then
				-- 胜利 
				coin,exp,prestige = ArenaData.getCoinAndSoulForWin()
			else
				coin,exp,prestige = ArenaData.getCoinAndSoulForFail()
			end
			-- 加贝里
			UserModel.addSilverNumber(coin, true)
			-- 加声望
			UserModel.addPrestigeNum(prestige, true)
			-- 如果抽取的是抢夺或贝里 加贝里
			if(flopData ~= nil)then
				for k,v in pairs(flopData) do
					if(k == "real")then
						for i,j in pairs(v) do
							if(i == "rob")then
								-- 加贝里
								UserModel.addSilverNumber(tonumber(j), true)
							elseif(i == "silver")then
								-- 加贝里
								UserModel.addSilverNumber(tonumber(j), true)
							elseif(i == "gold")then
								-- 加金币
								UserModel.addGoldNumber(tonumber(j), true)
							end
						end
					end
				end
			end
			
			
			if ArenaData.getTodayChallengeNum() >0 then
				ArenaData.addTodayChallengeNum(-1)
			end
	
			ArenaData.allUserData = ArenaData.getOpponentsData()
			if isUp then
				if rise and rise.gold then
					UserModel.addGoldNumber(rise.gold, true)
				end
				-- ArenaReward.create(rise, position, tbChangeInfo)
			end
		end
		local coin = nil
		local exp = nil
		local prestige = nil
		if(atk.appraisal ~= "E" and atk.appraisal ~= "F")then
			-- 胜利 
			coin,exp,prestige = ArenaData.getCoinAndSoulForWin()
		else
			coin,exp,prestige = ArenaData.getCoinAndSoulForFail()
		end
		local function afterOKcallFun()
			-- nextCallFun()
			if isUp then
				ArenaReward.create(rise, position, tbChangeInfo)
			end
			if isUp then
				ArenaData.setMinPosition(position)
			end
			MainArenaView.reLoadUI()
			updateInfoBar()
		end

		local enemyData = ArenaData.getHeroDataByUid(atkedUid)
		local tb = {}
		tb.challengeUid = atkedUid
		tb.enemyData = enemyData
		tb.atk = atk
		tb.coin = coin
		tb.exp = exp 
		tb.flopData = flopData
		tb.afterOKcallFun = afterOKcallFun
		tb.rise = rise 
		tb.prestige = prestige
		require "script/battle/BattleModule"
		BattleModule.PlayArenaBattle(atk.fightRet,afterOKcallFun,tb)

		m_fnCallBack = afterOKcallFun
		nextCallFun()
end

function levelUpCallback( p_level )
	ArenaData.addTodayChallengeNum(ArenaData.getAddTimesByLevel())-- or 0)
end


function onChallenge(tbInfo, callbackFunc )
 	AudioHelper.playEffect("audio/btn/compete.mp3")
 
 	-- do
 	-- 	ArenaReward.create(rise, position, tbChangeInfo)
 	-- 	return
 	-- end

 	local position, atkedUid = tbInfo.position, tbInfo.uid

	if(ItemUtil.isBagFull() == true )then
		return
	end

	local  hasNumberS = 0
	local cacheInfoS = ItemUtil.getCacheItemInfoBy(60026)
    if( not table.isEmpty(cacheInfoS))then
        hasNumberS = cacheInfoS.item_num
    end

	if( (ArenaData.getTodayChallengeNum())  <= 0 and tonumber(hasNumberS) <=0 )then
		if ArenaData.getMaxBuyTimes() <= ArenaData.getBuyTimesNum() then
			--TODO
			local tbParams = {sTitle = m_i18n[4014],sUnit = m_i18n[2621],sName = m_i18n[2269],nNowBuyNum=ArenaData.getCanBuyNums(),nNextBuyNum=ArenaData.getNextVipCanBuyNums(),}
			local layAlert = UIHelper.createVipBoxDlg(tbParams)
			LayerManager.addLayout(layAlert)
			return
		end
	-- do
		require "script/module/arena/ArenaBuyTimes"
		local buyView = ArenaBuyTimes.create(MainArenaView.updateChallengeTimes)
		LayerManager.addLayout(buyView)
		return
	end

	-- 正在发奖中不能挑战
	if(ArenaData.getAwardTime()- TimeUtil.getSvrTimeByOffset() <= 0)then
		ShowNotice.showShellInfo(m_i18n[2261])
		return
	end


	local tbChangeInfo = {}
	tbChangeInfo.atk = ArenaData.getHeroDataByUid(UserModel.getUserUid())
	tbChangeInfo.def = tbInfo

	logger:debug(tbChangeInfo)
	-- do
 -- 		return
 -- 	end
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			local dataRet = dictData.ret
			if(dataRet.ret == "ok")then
				-- 设置挑战列表数据 不管胜利失败每次都给挑战列表
				ArenaData.setOpponentsData( dataRet.opponents )

				-- 名次是否上升
				local isUp = false
				-- 判断玩家名次是否上升
				if( tonumber(position) < ArenaData.getSelfRanking() )then
					-- 判断战斗是否胜利
					if(dataRet.atk.appraisal ~= "E" and dataRet.atk.appraisal ~= "F")then
						-- 胜利  改变名次
						ArenaData.setSelfRanking( position )
						-- -- 设置挑战列表数据
						isUp = true
					end
				end
				-- UI回调 参数:战斗串
				callbackFunc( atkedUid,dataRet.atk, isNeedReload, isUp, position, dataRet.flop,dataRet.rise ,tbChangeInfo)
			end
			-- 对手位置发生变化，此时对方已经不在自己的挑战列表 
			if(dataRet.ret == "opponents_err")then
				PreRequest.setIsCanShowAchieveTip(true)
				ShowNotice.showShellInfo(m_i18n[2266])
				-- 设置挑战列表数据

				ArenaData.setOpponentsData( dataRet.opponents )
				-- 更新玩家列表UI
				ArenaData.allUserData = ArenaData.getOpponentsData()
				MainArenaView.reLoadUI()

			end

			if dataRet.ret == "position_err" then
				PreRequest.setIsCanShowAchieveTip(true)
				ShowNotice.showShellInfo(m_i18n[2266])
				-- 设置挑战列表数据
			end
			if dataRet.ret == "lock" then
				PreRequest.setIsCanShowAchieveTip(true)
				ShowNotice.showShellInfo(m_i18n[2259])
			end


		end
	end

	PreRequest.setIsCanShowAchieveTip(false)
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(position))
	args:addObject(CCInteger:create(atkedUid))
	RequestCenter.arena_challenge(requestFunc,args)

end

--[[
tbInfo = {
	uname = "",
	rank = "",
	position = "",
	luck = "",
	uid = "",	
}
--]]

function createBoat(tbInfo)
	-- local imgPressPath,imgNomalPath = getShipImage(tbInfo) -- zhangqi, 2015-12-28

	local cloneBtn = m_boat:clone()
	require "script/module/ship/ShipData"
	local ship_figure = ShipData.getShipFigureIdByShipId(tbInfo.ship_figure)
	UIHelper.addShipAnimation( cloneBtn,ship_figure,ccp(0,0),ccp(0.5,0.5),0.4,nil,nil )


	local imgRight = m_fnGetWidget(cloneBtn, "IMG_PLAYER_INFO_RIGHT")
	local imgLeft = m_fnGetWidget(cloneBtn, "IMG_PLAYER_INFO_LEFT")
	local nRight = math.mod(tbInfo.index, 2)
	if nRight == 1 then
		imgLeft:removeFromParent()
	else
		imgRight:removeFromParent()
	end
	local TFD_PLAYER_NAME = m_fnGetWidget(cloneBtn, "TFD_PLAYER_NAME") -- 名字

	-- 判断是否是npc
	local isNpc = nil
	local htid = 0
	if(tonumber(tbInfo.armyId) ~= 0) then
		isNpc = true
		local utid = tonumber(tbInfo.utid)
		local npc_name = ArenaData.getNpcName( tonumber(tbInfo.uid), utid)
		require "db/DB_Monsters"
		htid = DB_Monsters.getDataById(tbInfo.squad[1]).htid
		TFD_PLAYER_NAME:setText(npc_name)
	else
		htid = tbInfo.figure
		TFD_PLAYER_NAME:setText(tbInfo.uname)
	end
	TFD_PLAYER_NAME:setColor(UserModel.getPotentialColor({htid = htid}))

	local LABN_PLAYER_RANK = m_fnGetWidget(cloneBtn, "LABN_PLAYER_RANK") -- 排名
	LABN_PLAYER_RANK:setStringValue(tbInfo.position)


	local IMG_LUCKY = m_fnGetWidget(cloneBtn, "IMG_LUCKY") -- 幸运排名标志
	if(tonumber(tbInfo.luck) == 0) then
		IMG_LUCKY:setEnabled(false)
	else
		IMG_LUCKY:setEnabled(true)
	end

	local i18ntfd_zhandouli = m_fnGetWidget(cloneBtn, "tfd_zhandouli") --战斗力：
	local TFD_PLAYER_ZHANDOULI = m_fnGetWidget(cloneBtn, "TFD_PLAYER_ZHANDOULI")
	TFD_PLAYER_ZHANDOULI:setText(tbInfo.fight_force)


	local IMG_SELF = m_fnGetWidget(cloneBtn, "IMG_SELF")
	if( tonumber(tbInfo.uid) == UserModel.getUserUid()) then
		IMG_SELF:setEnabled(true)
		TFD_PLAYER_ZHANDOULI:setColor(ccc3(0x08, 0x40, 0x00))
		i18ntfd_zhandouli:setColor(ccc3(0x08, 0x40, 0x00))
		if nRight == 1 then
			imgRight:loadTexture("images/arena/arena_bubble_green_right.png")
		else
			imgLeft:loadTexture("images/arena/arena_bubble_green_left.png")
		end
	else
		IMG_SELF:removeFromParent()
	end

	

	cloneBtn:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED)then
			if tonumber(tbInfo.uid) ==  UserModel.getUserUid() then
				ShowNotice.showShellInfo(m_i18n[2240])
				return
			end
			onChallenge(tbInfo,createNext)
		end
	end)

	return cloneBtn
end

function create()
	init()
   local mainWidget = g_fnLoadUI(arena_challenge_json)
	m_boat = m_fnGetWidget(mainWidget, "BTN_PLAYER")
	m_boat:retain()
end

--根据服务器返回的ship_figure字段决定船形象 ，对手为npc的没有这个字段，取默认值1
-- zhangqi, 2015-12-28, 弃用注释
-- function getShipImage( tbInfo )
-- 	if tbInfo.ship_figure then 
-- 		require "script/module/ship/ShipData"
-- 		local ship_figure = ShipData.getShipFigureIdByShipId(tbInfo.ship_figure)
-- 		if ship_figure == 0 then 
-- 			ship_figure = 1
-- 		end
-- 		return "images/others/grab_ship_" .. ship_figure .. "_h.png","images/others/grab_ship_" .. ship_figure .. "_n.png" 
-- 	else 
-- 		return "images/others/grab_ship_1_h.png","images/others/grab_ship_1_n.png"
-- 	end 
-- end


-- FileName: StrategyCtrl.lua
-- Author: yangna
-- Date: 2016-02-04
-- Purpose: 查看攻略
--[[TODO List]]

module("StrategyCtrl", package.seeall)

require "script/module/Strategy/StrategyModel"
require "script/module/Strategy/StrategyView"

-- UI控件引用变量 --

-- 模块局部变量 --
local tbArgs = {}

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_tdData  

local m_curTag = 0

function destroy(...)
	package.loaded["StrategyCtrl"] = nil
end

function moduleName()
    return "StrategyCtrl"
end



local function createNext( fightRet )
	-- 解析战斗串获得战斗评价
	local amf3_obj = Base64.decodeWithZip(fightRet)
	local lua_obj = amf3.decode(amf3_obj)

	local tbData = {}

	tbData.uid2 = lua_obj.team2.uid
	tbData.playerName2 = lua_obj.team2.name
	tbData.fightForce2 = lua_obj.team2.fightForce
	tbData.isPlayer2 = lua_obj.team2.isPlayer   --区分玩家和npc的标志（true ｜ false）

	if (tbData.isPlayer2 == false) then 
		tbData.fightForce2 = nil  --结算面板不显示npc战斗力   －－2016.3.7
		local db_army = DB_Army.getDataById(tbData.playerName2)
		assert(db_army.fort_id, " id= " ..  tbData.playerName2 .. " 的Army表数据，取的fort_id=nil")
		local db_stronghold = DB_Stronghold.getDataById(db_army.fort_id)
		tbData.playerName2 = db_stronghold.name
	end 	

	tbData.uid = lua_obj.team1.uid
	tbData.playerName = lua_obj.team1.name
	tbData.fightForce = lua_obj.team1.fightForce
	tbData.brid = lua_obj.brid
	tbData.isPlayer1 = lua_obj.team1.isPlayer   --区分玩家和npc的标志（true ｜ false）

	if (tbData.isPlayer1 == false) then 
		tbData.fightForce = nil
		local db_army = DB_Army.getDataById(tbData.playerName)
		assert(db_army.fort_id, " id= " ..  tbData.playerName2 .. " 的Army表数据，取的fort_id=nil")
		local db_stronghold = DB_Stronghold.getDataById(db_army.fort_id)
		tbData.playerName = db_stronghold.name
	end 	

	require "script/battle/BattleModule"
	local fnCallBack = function ( ... )
		if (m_tdData.callback2) then 
			m_tdData.callback2()
		end 
	end

	local cellData =  StrategyModel.getStrategyData()[m_curTag]
	logger:debug({
		copy_id = cellData.copy_id,
		base_id = cellData.base_id,
		base_lv = cellData.base_lv,
		})

	tbData.type = MailData.ReplayType.KTypeChatBattle

	if (cellData.base_id and cellData.base_lv) then 
									 --参数 battleString,callback,data,battleType,stronghold,level,battleIndex
		BattleModule.playCopyStyleReplay(fightRet,fnCallBack,tbData,1,cellData.base_id,cellData.base_lv,#cellData.arrBrid)
	else 
		BattleModule.PlayNormalRecord(fightRet,fnCallBack,tbData,true)
	end 				 

end


-- 查看战报
tbArgs.onBattleReport = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (m_tdData.callback1) then 
			m_tdData.callback1()
		end 

		m_curTag = sender:getTag()
		local battleId = sender.brid
		MailService.getRecord(battleId, createNext)
	end
end



-- 头像点击,玩家自己弹出信息面板，其它玩家弹出私聊小窗
tbArgs.onHead = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()

		local tbData = sender.data
		if (tonumber(tbData.uid) == UserModel.getUserUid()) then 
			local playerInfo = PlayerInfoView:new()
			local layPlayerInfo = playerInfo:create()
			if (layPlayerInfo) then
				LayerManager.addLayout(layPlayerInfo)
			end
		else 
			local layCommunication = ChatCommunicationCtrl.create({
				sender_uid = tbData.uid,
				sender_uname = tbData.uname,
				sender_fight = tbData.fight_force,
				sender_level = tbData.level,
				figure = tbData.figure,
				callback = function ( ... )
					-- LayerManager.removeLayoutByName("Strategy_layout")
				end
				})
			LayerManager.addLayout(layCommunication)
		end 
	end
end


local enterStrategy = function ( data )
	StrategyModel.setStrategyData(data)
	local m_layMain = StrategyView.create(m_tdData,tbArgs)
	LayerManager.addLayout(m_layMain)
end


-- 普通副本
local function getNCopyData( tbParam )
	local function call_back( cbFlag, dictData, bRet )
		if(bRet and dictData.err=="ok")then
			local dictDataIsNill = true
			for k,v in pairs(dictData.ret) do
				if (not table.isEmpty(v)) then
					dictDataIsNill = false
				end
			end

			if (dictDataIsNill) then
				ShowNotice.showShellInfo(m_i18n[7817]) --该关卡没有人通关，没有攻略可看哦~
				return
			end

			enterStrategy(dictData.ret)
		end
	end

	local tbArgs = Network.argsHandler(m_tdData.param1,m_tdData.param2,m_tdData.param3)
	RequestCenter.getStrategy_ncopy(call_back,tbArgs)
end

-- 精英副本
local function getECopyData( tbParam )
	local function call_back( cbFlag, dictData, bRet )
		if(bRet and dictData.err=="ok")then
			local dictDataIsNill = true
			for k,v in pairs(dictData.ret) do
				if (not table.isEmpty(v)) then
					dictDataIsNill = false
				end
			end

			if (dictDataIsNill) then
				ShowNotice.showShellInfo(m_i18n[7817]) --该关卡没有人通关，没有攻略可看哦~
				return
			end
			
			enterStrategy(dictData.ret)
		end
	end

	local tbArgs = Network.argsHandler(m_tdData.param1)
	RequestCenter.getStrategy_ecopy(call_back,tbArgs)
end 


-- 觉醒副本
local function getAwakeCopyData(  )
	local function call_back( cbFlag, dictData, bRet )
		if(bRet and dictData.err=="ok")then
			local dictDataIsNill = true
			for k,v in pairs(dictData.ret) do
				if (not table.isEmpty(v)) then
					dictDataIsNill = false
				end
			end

			if (dictDataIsNill) then
				ShowNotice.showShellInfo(m_i18n[7817]) --该关卡没有人通关，没有攻略可看哦~
				return
			end
			
			enterStrategy(dictData.ret)
		end
	end

	local tbArgs = Network.argsHandler(m_tdData.param1,m_tdData.param2)
	RequestCenter.getStrategy_awakecopy(call_back,tbArgs)
end

-- 深海
local function getImpleDowData(  )
	local function call_back( cbFlag, dictData, bRet )
		if(bRet and dictData.err=="ok")then
			local dictDataIsNill = true
			for k,v in pairs(dictData.ret) do
				if (not table.isEmpty(v)) then
					dictDataIsNill = false
				end
			end

			if (dictDataIsNill) then
				ShowNotice.showShellInfo(m_i18n[7817]) --该关卡没有人通关，没有攻略可看哦~
				return
			end

			enterStrategy(dictData.ret)
		end
	end

	local tbArgs = Network.argsHandler(m_tdData.param1)
	RequestCenter.getStrategyInfo_tower(call_back,tbArgs)

end

-- 世界boss
local function getWorldBossData(  )
	local curDBBossId = m_tdData.param1
	local function call_back( cbFlag, dictData, bRet )
		if(bRet and dictData.ret)then
			logger:debug(dictData.ret)
			if (table.isEmpty(dictData.ret)) then
				ShowNotice.showShellInfo(m_i18n[7818])
				return
			end

			enterStrategy(dictData.ret)
		end
	end

	local bossid = tonumber(curDBBossId)  --这里需要boss id
    RequestCenter.getStrategyInfo_boss(call_back,Network.argsHandler(bossid))
end

	

--[[desc:攻略
	tbData={
	    type: 类型 普通副本＝1，精英副本＝2，觉醒副本＝3，深海＝4，世界boss＝5,
		name = 据点名称（世界boss传boss名称，深海传当前层：第xx层）,
		param1 = 普通副本，精英副本，觉醒副本传副本ID；深海传当前层数，世界boss传boss ID
		param2 = 普通副本，觉醒副本传据点id ，其他模块不用传
		param3 = 普通副本 传据点难度，其他不需要
		callback1 = 攻略页面点查看战报时调用，可传nil，,   (用于世界boss处理音乐)
		callback2 = 查看战报战斗播放结束，结算面板关闭时调用，可传nil, (用于世界boss处理音乐)
	}

    return: 是否有返回值，返回值说明  
—]]
function create(tbData)

	m_tdData = tbData
	logger:debug("攻略")
	logger:debug(tbData)

	if (tbData.type == 1) then 
		getNCopyData()
	elseif (tbData.type == 2) then 
		getECopyData()
	elseif (tbData.type == 3) then 
		getAwakeCopyData()
	elseif (tbData.type == 4) then 
		getImpleDowData()
	elseif (tbData.type == 5) then 
		getWorldBossData()
	end 

end

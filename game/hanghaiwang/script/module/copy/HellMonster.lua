-- FileName: HellMonster.lua
-- Author: liweidong
-- Date: 2016-02-17
-- Purpose:  炼狱副本挑战界面
--[[TODO List]]

module("HellMonster", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
-- 模块局部变量 --
local _copyId = nil
local _baseId = nil
local _baseItemInfo = nil --据点信息
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["HellMonster"] = nil
end

function moduleName()
    return "HellMonster"
end


function getAttackInfo()
	local baseItemInfo = DB_Stronghold.getDataById(_baseId)
	local fightTimes=lua_string_split(baseItemInfo.fight_times, "|")
	local maxNum = tonumber(fightTimes[3])

	local curWorldData = DataCache.getNormalCopyData()
	local itemData=curWorldData.copy_list["".._copyId]
	local attackNumInfo = itemData.va_copy_info.baselv_info[tostring(_baseId)]

	local baseInfo = attackNumInfo["3"]
	logger:debug({atknum = baseInfo.can_atk_num})
	if (baseInfo.can_atk_num) then
		return tonumber(baseInfo.can_atk_num),maxNum
	else
		return maxNum,maxNum
	end
end
--更新挑战次数widget
function fnShowBattleNum( )
	local strAttkNum,allNum = getAttackInfo()
	logger:debug({strAttkNum = strAttkNum})
	_layoutMain.TFD_LIMIT_NUM:setText(strAttkNum)
	_layoutMain.TFD_LIMIT_NUM3:setText(allNum)
	if (tonumber(strAttkNum) <= 0) then
		_layoutMain.TFD_LIMIT_NUM:setColor(ccc3(0xd5,0x41,0x00))
	else
		_layoutMain.TFD_LIMIT_NUM:setColor(ccc3(0x00,0x93,0x11))
	end
end

function updateUI()
	if (_layoutMain==nil) then
		return
	end
	fnShowBattleNum()
end
function setUIStyleAndI18n(base)
	-- base.tfd_drop:setText(m_i18n[1305])
	-- base.tfd_power:setText(m_i18n[4311])
	-- base.tfd_pass_reward:setText(m_i18n[5959])--TODO
	-- base.BTN_ATTACK1:setTitleText(m_i18n[1308])
	-- base.tfd_limit:setText("今日挑战次数：") --TODO
	-- -- UIHelper.labelNewStroke( base.TFD_LIMIT_NUM2, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.titleShadow(base.BTN_ATTACK1)
	-- base.tfd_switch:setText(m_i18n[1370])
end

-- 显示顶部信息中的星数
local function fnTopInfoStar()
	local curWorldData = DataCache.getNormalCopyData()
	local itemData=curWorldData.copy_list["".._copyId]
	local getStar = itemData.va_copy_info.baselv_info[tostring(_baseId)]
	local getStarNum= 0 --获得的新数
	if (getStar~=nil and getStar[tostring(3)] and getStar[tostring(3)].score) then
		getStarNum=tonumber(getStar[tostring(3)].score)
	end
	local baseStar = getStarNum
	local star1 = nil
	local star2 = nil
	local star3 = nil
	local nStarNum =3 
	local baseStaus = 2+baseStar
	if(nStarNum > 2) then
		star3 = _layoutMain.IMG_STAR3
	end
	if(nStarNum > 1) then
		star2 = _layoutMain.IMG_STAR2
	end
	if(nStarNum > 0) then
		star1 = _layoutMain.IMG_STAR1
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
	for _,v in pairs(tbStarArr) do
		UIHelper.setWidgetGray(v,true)
	end
end
--掉落预览
function fnDropPreview( ... )
	if (_baseItemInfo["reward_item_id_hard"] ~= nil) then
		
		local _,otherRewardIds = OutputMultiplyUtil.getAdditionalDrop(  )
		local dropIdArr = lua_string_split(_baseItemInfo["reward_item_id_hard"],",")
		if (otherRewardIds) then
			for _,id in ipairs(otherRewardIds) do
				dropIdArr[#dropIdArr+1] = id
			end
		end
		for i=1,5 do
			local layDrop = _layoutMain.LAY_DROP["LAY_DROP"..i]
			if(i <= #dropIdArr) then
				local dropIds = lua_string_split(dropIdArr[i],"|")
				if (dropIds[1] ~= nil) then
					local layImage = layDrop["IMG_"..i]
					local soulItem,soulInfo = ItemUtil.createBtnByTemplateId(dropIds[1],
													function ( sender,eventType )
														if (eventType == TOUCH_EVENT_ENDED) then
															PublicInfoCtrl.createItemInfoViewByTid(tonumber(dropIds[1]))
														end
													end)
					soulItem:setTag(i)
					layImage:addChild(soulItem)
					local goodsTitle = layDrop["TFD_NAME_"..i]
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
	if (_baseItemInfo["nightmare_first_reward"] ~= nil) then
		local goodsTemp = RewardUtil.parseRewards(_baseItemInfo["nightmare_first_reward"])
		for i=1,5 do
			local layDrop = _layoutMain.LAY_DROP_FIRST["LAY_DROP"..i]
			if(i <= #goodsTemp) then
				local layImage = layDrop["IMG_"..i]
				local soulItem = goodsTemp[i].icon
				soulItem:setTag(i)
				layImage:addChild(soulItem)
				local goodsTitle = layDrop["TFD_NAME_"..i]
				if (goodsTitle) then
					UIHelper.labelEffect(goodsTitle,goodsTemp[i].name)
					if (goodsTemp[i].quality ~= nil) then
						local color =  g_QulityColor[tonumber(goodsTemp[i].quality)]
						if(color ~= nil) then
							goodsTitle:setColor(color)
						end
					end
				end
			else
				layDrop:setVisible(false)
			end
		end
	end
end

--初始化UI
function initUI()
	_layoutMain = g_fnLoadUI("ui/copy_drop_hell.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 
	setUIStyleAndI18n(_layoutMain)
	--头像框
	local normalTable = copy.models.normal
	for i,values in pairs(normalTable) do
		local armyId = values.looks.look.armyID
		local modelUrl = values.looks.look.modelURL
		if (tonumber(armyId) == tonumber(_baseItemInfo.id) and modelUrl ~= nil) then
			local nimgModel = lua_string_split(modelUrl,".swf")
			_layoutMain.IMG_FRAME:loadTexture("images/copy/ncopy/fortpotential/"..nimgModel[1]..".png")
			_layoutMain.IMG_FRAME:setPositionType(POSITION_ABSOLUTE)
			if (tonumber(nimgModel[1])==1) then
				_layoutMain.IMG_FRAME:setPosition(ccp(0, -10))
			elseif  (tonumber(nimgModel[1])==2) then
				_layoutMain.IMG_FRAME:setPosition(ccp(0, -5))
			else
				_layoutMain.IMG_FRAME:setPosition(ccp(0, 1))
			end
			break
		end
	end
	--头像
	_layoutMain.IMG_HEAD:loadTexture("images/base/hero/head_icon/".._baseItemInfo.icon)

	_layoutMain.TFD_NAME:setText(_baseItemInfo.name)
	_layoutMain.TFD_POWER_NUM:setText(_baseItemInfo.cost_energy_hard)
	_layoutMain.TFD_NUM_MONEY1:setText(math.floor(_baseItemInfo.coin_hard*OutputMultiplyUtil.getMultiplyRateNum(11)/10000))
	_layoutMain.TFD_EXP_NUM:setText(math.floor(_baseItemInfo.exp_hard*UserModel.getHeroLevel()*OutputMultiplyUtil.getMultiplyRateNum(11)/10000))

	fnDropPreview()
	fnTopInfoStar()

	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_layoutMain.BTN_ATTACK1:addTouchEventListener(
		function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				local attkNum = getAttackInfo()
				if (attkNum > 0) then
					fnToAttackArmy(3)
				else
					ShowNotice.showShellInfo("剩余攻打次数不足") --TODO
				end
			end
		end
		)
	_layoutMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playStrategy()
				local baseDb = DB_Stronghold.getDataById(_baseId)
				local baseName = baseDb.name
				tbData={
			        type=1,-- 类型 普通副本＝1，精英副本＝2，觉醒副本＝3，深海＝4，世界boss＝5,
			        name = baseName, --据点名称（世界boss传boss名称，深海传当前层：第xx层）,
			        param1 = baseDb.copy_id, --普通副本，精英副本，觉醒副本传副本ID；深海传当前层数，世界boss传boss ID
			        param2 = _baseId, --普通副本，觉醒副本传据点id ，其他模块不用传
			        param3 = 3, --普通副本 传据点难度，其他不需要
			        callback1 = nil,--攻略页面点查看战报时调用，可传nil，,   (用于世界boss处理音乐)
			        callback2 = nil, --查看战报战斗播放结束，结算面板关闭时调用，可传nil, (用于世界boss处理音乐)
			    }
				StrategyCtrl.create( tbData )
			end)
	updateUI()
	return _layoutMain
end
-- -- 获取攻打后的信息
-- function fnGetAttedInfo( )
-- 	local status = 0
-- 	local curWorldData = DataCache.getNormalCopyData()
-- 	local itemData=curWorldData.copy_list["".._copyId]
-- 	local attackNumInfo = itemData.va_copy_info.baselv_info[tostring(_baseId)]
-- 	if (attackNumInfo["3"].status) then
-- 		status = tonumber(attackNumInfo["3"].status)
-- 	end
-- 	return status
-- end


function getOneBattleCallback( tbNewCopyBase, blisWin, tbextraReward )
	logger:debug({tbNewCopyBase = tbNewCopyBase})
	if(blisWin) then
		resetCopyResult(tbNewCopyBase)
	end
end
-- 根据战斗类型进行战斗,传入战斗等级，npc战为0级
function fnToAttackArmy( hardLevel,firstBattle)
	logger:debug("copy hardLevel require ========="..hardLevel)
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		return
	end
	if (itemCopyModel.getAtackNum()<=0) then
		LayerManager.removeLayout()
		-- itemCopy.createBuyTimesDialog()
		ShowNotice.showShellInfo(m_i18n[1350]) --TODO
		return
	end
	--体力判断
	if (tonumber(_baseItemInfo.cost_energy_hard)<= UserModel.getEnergyValue()) then
		if (hardLevel ~= 0) then
			LayerManager.removeLayout() -- 如果不是NPC战会弹出战斗前面板，需要先remove掉
		end
		PreRequest.setIsCanShowAchieveTip(false) -- 设置如果有成就完成就不提示
		require "script/battle/BattleModule"
		
		BattleModule.playCopyStyleBattle(_copyId, _baseId, 3, getOneBattleCallback, COPY_TYPE_NORMAL ,firstBattle)
	else
		require "script/module/copy/copyUsePills"
		LayerManager.addLayout(copyUsePills.create())
	end
end
function create(copyId,baseId)
	copyWin.battalCopyType=1 --战斗类型为普通副本
	_copyId = copyId
	_baseId = baseId
	_baseItemInfo = DB_Stronghold.getDataById(_baseId)
	return initUI()
end



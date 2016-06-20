-- FileName: treaForgeCtrl.lua
-- Author: menghao
-- Date: 2014-05-16
-- Purpose: 宝物强化ctrl


module("treaForgeCtrl", package.seeall)


require "script/module/treasure/treaForgeView"
require "script/module/treasure/treaInfoModel"
require "script/module/treasure/treaForgeChooseCtrl"
require "script/module/public/AttribEffectManager"


-- UI控件引用变量 --


-- 模块局部变量 --
local mi18n = gi18n

local m_nSrcType
local m_tbTreaInfo 			-- 宝物信息
local m_tbTreaDb 		-- 宝物配置信息
local tbEventListener = {} 		-- 事件监听表
local m_tbTreaIDs = {} 			-- 选中宝物ID表
local m_tbTreaSelect = {} 		-- 选中宝物信息表
local m_nUpgradeNeedNum = 0 	-- 强化需要的贝里数

local m_nHeroIndex
local m_fnCallback
local m_bForged 		= false --是否有过至少一次强化宝物，如果有过，则需要更新宝物背包的数据

local m_nToMaxNeedExp

local m_tbBefore
local m_tbAfter

-- zhangqi, 2015-09-29, 设置宝物背包列表更新状态
local function updateTreasBag( ... )
	BagModel.setBagUpdateByType(BAG_TYPE_STR.treas)
end

-- 判断一个id在不在 m_tbTreaIDs 中
local function isVInTable( id )
	for k,v in pairs(m_tbTreaIDs) do
		if (v == id) then
			return true
		end
	end
	return false
end


function getTbForMaster( ... )
	return m_tbBefore, m_tbAfter
end


local function getExpPercent( ... )
	local expArr = string.split(m_tbTreaDb.total_upgrade_exp, ",")
	-- local level = tonumber(m_tbTreaInfo.level)
	local level = tonumber(m_tbTreaInfo.va_item_text.treasureLevel)
	local curLevelNeedExp = 0
	for i=1,level do
		local iExp = string.split( expArr[i], "|" )[2]
		curLevelNeedExp = curLevelNeedExp + iExp
	end
	local nextLevelNeedExp = tonumber(string.split( expArr[level + 1], "|" )[2])

	local curMaxLv
	if (m_tbTreaDb.level_interval ~= 0) then
		curMaxLv = math.floor(UserModel.getHeroLevel() / m_tbTreaDb.level_interval)
		if (curMaxLv > m_tbTreaDb.level_limited) then
			curMaxLv = m_tbTreaDb.level_limited
		end
	else
		curMaxLv = m_tbTreaDb.level_limited
	end

	m_nToMaxNeedExp = curLevelNeedExp
	if curMaxLv > level then
		for i=level + 1,curMaxLv do
			local iExp = string.split( expArr[i], "|" )[2]
			m_nToMaxNeedExp = m_nToMaxNeedExp + iExp
		end
	end

	m_nToMaxNeedExp = m_nToMaxNeedExp - m_tbTreaInfo.va_item_text.treasureExp

	return math.floor((m_tbTreaInfo.va_item_text.treasureExp - curLevelNeedExp) / nextLevelNeedExp * 100)

end


local function getAddLevel( addExp )
	local expArr = string.split(m_tbTreaDb.total_upgrade_exp, ",")
	local iNeedTotalExp = 0
	for i=1,#expArr do
		local iExp = string.split(expArr[i], "|")[2]
		iNeedTotalExp = iNeedTotalExp + iExp
		-- if m_tbTreaInfo.exp + addExp < iNeedTotalExp then
		-- 	return i - m_tbTreaInfo.level - 1, 100 - math.ceil((iNeedTotalExp - m_tbTreaInfo.exp - addExp) / iExp * 100)
		-- end
		local treaExp = m_tbTreaInfo.va_item_text.treasureExp
		-- if m_tbTreaInfo.exp + addExp < iNeedTotalExp then
		-- 	return i - m_tbTreaInfo.level - 1, 100 - math.ceil((iNeedTotalExp - m_tbTreaInfo.exp - addExp) / iExp * 100)
		-- end
		if treaExp + addExp < iNeedTotalExp then
			return i - m_tbTreaInfo.va_item_text.treasureLevel - 1, 100 - math.ceil((iNeedTotalExp - treaExp - addExp) / iExp * 100)
		end
	end
end


-- 更新贝里和经验数
local function refreshSliverAndExp( ... )
	local totalExp = 0
	for k,v in pairs(m_tbTreaIDs) do
		-- local treaData = treaInfoModel.getSimpleTreaInfo(v).treaData -- 2015-06-15
		-- 线上报错 treaForgeCtrl.lua"]:121: attempt to index local 'treaData' (a nil value)
		-- treaForgeCtrl.lua"]:121: in function 'refreshSliverAndExp
		-- reaForgeCtrl.lua"]:169: in function 'setSelectedTreas
		local treaData = treaInfoModel.fnGetTreasNetData(v) -- 2015-06-15
		local exp = tonumber(treaData.va_item_text.treasureExp) + tonumber(treaData.itemDesc.base_exp_arr)
		totalExp = totalExp + exp
	end
	local upgradeCostArr = string.split(m_tbTreaDb.upgrade_cost_arr, ",")
	-- local base = tonumber((string.split(upgradeCostArr[m_tbTreaInfo.level + 1], "|"))[2])
	local base = tonumber((string.split(upgradeCostArr[m_tbTreaInfo.va_item_text.treasureLevel + 1], "|"))[2])

	m_nUpgradeNeedNum = totalExp * base

	local addLevel, expPercent = getAddLevel(totalExp)

	local tbAddNum = {}
	for i = 1,5 do
		local increase_attrI = m_tbTreaDb["increase_attr" .. i]
		if increase_attrI then
			local increaseNum = (string.split(increase_attrI, "|"))[2] * tonumber(addLevel)
			local increaseID = (string.split(increase_attrI, "|"))[1]
			local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(increaseID, increaseNum)

			table.insert(tbAddNum, displayNum)
		end
	end

	treaForgeView.updateSliverAndExpDisplay(totalExp, m_nUpgradeNeedNum)
	if tonumber(totalExp) > 0 then
		-- treaForgeView.showFade(addLevel, expPercent, tbAddNum, m_tbTreaInfo.level, m_tbTreaInfo.expPercent)
		treaForgeView.showFade(addLevel, expPercent, tbAddNum, m_tbTreaInfo.va_item_text.treasureLevel, m_tbTreaInfo.expPercent)

	end
end


-- 设置选取的宝物
function setSelectedTreas( tbTreaID )
	m_tbTreaIDs = {}
	m_tbTreaSelect = {}

	m_tbTreaIDs = tbTreaID
	if m_tbTreaIDs then
		local tbTreasureList = DataCache.getBagInfo().treas
		for k, v in pairs(tbTreasureList) do
			local id = v.item_id
			if (isVInTable(id)) then
				table.insert(m_tbTreaSelect, v)
			end
		end
	end
	treaForgeView.updateUIForAddTreas(m_tbTreaSelect)
	refreshSliverAndExp()
end


local function init(...)
	m_bForged = false
	m_tbTreaIDs = {}
	m_tbTreaSelect = {}
	m_nUpgradeNeedNum = 0
	m_fnCallback = nil
end


function destroy(...)
	package.loaded["treaForgeCtrl"] = nil
end


function moduleName()
	return "treaForgeCtrl"
end


-- 强化回调
function reinforceCallback( cbFlag, dictData, bRet )
	if (bRet) then
		m_bForged = true

		local result_treas = dictData.ret
		local addLv = 0
		if(not table.isEmpty(result_treas))then
			-- addLv = tonumber(result_treas.va_item_text.treasureLevel) - tonumber(m_tbTreaInfo.level)
			addLv = tonumber(result_treas.va_item_text.treasureLevel) - tonumber(m_tbTreaInfo.va_item_text.treasureLevel)

			local t_text = {}
			for i = 1,5 do
				local increase_attrI = m_tbTreaDb["increase_attr" .. i]
				if increase_attrI then
					local increaseNum = (string.split(increase_attrI, "|"))[2] * tonumber(addLv)
					local increaseID = (string.split(increase_attrI, "|"))[1]
					local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(increaseID, increaseNum)

					local affixDesc = DB_Affix.getDataById(tonumber(increaseID))
					if increaseNum > 0 then
						table.insert(t_text, {
							txt = affixDesc.displayName, num = increaseNum, displayNumType = affixDesc.type
						})
					end
				end
			end

			local forgeUnlock = m_tbTreaInfo.forgeUnlock

			-- local tbInfoTemp = HeroModel.getHeroByHid(m_tbTreaInfo.treaData.equip_hid)
			local tbInfoTemp = HeroModel.getHeroByHid(m_tbTreaInfo.equip_hid)

			m_tbBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(tbInfoTemp)
			-- 穿在身上的
			-- if(m_tbTreaInfo.treaData.equip_hid and tonumber(m_tbTreaInfo.treaData.equip_hid)>0 )then
			if(m_tbTreaInfo.equip_hid and tonumber(m_tbTreaInfo.equip_hid)>0 )then

				-- local tbTreas = HeroModel.getHeroByHid(m_tbTreaInfo.treaData.equip_hid).equip.treasure
				local tbTreas = HeroModel.getHeroByHid(m_tbTreaInfo.equip_hid).equip.treasure

				local pos = nil
				for k,v in pairs(tbTreas) do
					-- if (tonumber(v.item_id) == tonumber(m_tbTreaInfo.treaData.item_id)) then
					if (tonumber(v.item_id) == tonumber(m_tbTreaInfo.item_id)) then

						pos = k
						break
					end
				end
				-- HeroModel.addTreasLevelOnHerosBy( m_tbTreaInfo.treaData.equip_hid, pos, addLv, result_treas.va_item_text.treasureExp )
				HeroModel.addTreasLevelOnHerosBy( m_tbTreaInfo.equip_hid, pos, addLv, result_treas.va_item_text.treasureExp )

			else -- 背包中的
				-- DataCache.changeTreasReinforceBy(m_tbTreaInfo.treaData.item_id, addLv, result_treas.va_item_text.treasureExp)
				DataCache.changeTreasReinforceBy(m_tbTreaInfo.item_id, addLv, result_treas.va_item_text.treasureExp)
				-- 强化后推送红点背包，在伙伴身上穿的不用推送
				ItemUtil.pushitemCallback(result_treas, 2)
			end

			-- tbInfoTemp = HeroModel.getHeroByHid(m_tbTreaInfo.treaData.equip_hid)
			tbInfoTemp = HeroModel.getHeroByHid(m_tbTreaInfo.equip_hid)

			m_tbAfter = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(tbInfoTemp)

			m_tbTreaIDs = {}
			m_tbTreaSelect = {}

			-- local itemId = m_tbTreaInfo.treaData.item_id
			-- zhangqi, 刷新强化后的宝物信息
			-- m_tbTreaInfo = treaInfoModel.getSimpleTreaInfo(itemId) -- zhangqi, 2015-06-15
			m_tbTreaInfo = treaInfoModel.fnGetTreasNetData(m_tbTreaInfo.item_id)
			-- m_tbTreaDb = m_tbTreaInfo.treaData.dbData
			m_tbTreaDb = m_tbTreaInfo.itemDesc
			m_tbTreaInfo.property = treaInfoModel.fnGetTreaProperty(m_tbTreaDb.id,m_tbTreaInfo.va_item_text.treasureLevel)

			m_tbTreaInfo.expPercent = getExpPercent()
			
			-- 播放动画时加屏蔽层
			local layout = Layout:create()
			layout:setName("layForShield")
			LayerManager.addLayout(layout)

			-- UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
			-- UserModel.addSilverNumber(-m_nUpgradeNeedNum)
			local  resetForceValueHid = m_tbTreaInfo.equip_hid
			logger:debug({resetForceValueHid = m_tbTreaInfo})
			logger:debug({resetForceValueHid = m_nUpgradeNeedNum})

			if(m_tbTreaInfo.equip_hid and tonumber(m_tbTreaInfo.equip_hid)>0 )then
				local updataInfo = {[resetForceValueHid] = {HeroFightUtil.FORCEVALUEPART.UNION ,
															 HeroFightUtil.FORCEVALUEPART.TREASURE,
															 HeroFightUtil.FORCEVALUEPART.MASTER,
															 },}
				UserModel.setInfoChanged(true)
				UserModel.updateFightValue(updataInfo)
			end
		    UserModel.addSilverNumber(-m_nUpgradeNeedNum)

			treaForgeView.showAnimation(tonumber(addLv), t_text, function ( ... )

				treaForgeView.updateUIByTreaInfo(m_tbTreaInfo, tonumber(addLv))
			end)
		end
	end
end


-- button事件表赋值
tbEventListener.onClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		-- zhangjunwu, 2014-10-24, 注册UI被remove的回调，判断是否有过至少一次强化成功，来判断是否需要更新宝物背包的数据
		--如果直接点击了 主船等按钮，则无法调用返回按钮的回条
		if (m_bForged) then
			updateTreasBag() --设置宝物背包的更新状态
			m_bForged = false
		end


		if (m_nSrcType == 1) then
			MainTreaBagCtrl.create()
		else
			LayerManager.changeModule(MainFormation.create(m_nHeroIndex), MainFormation.moduleName(), {1,3}, true)
		end
		if m_fnCallback then
			m_fnCallback()
		end
	end
end


tbEventListener.onBack = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		-- -- 移除战斗力提升动画
		-- MainFormationTools.removeFlyText()
		-- zhangjunwu, 2014-10-24, 注册UI被remove的回调，判断是否有过至少一次强化成功，来判断是否需要更新宝物背包的数据
		--如果直接点击了 主船等按钮，则无法调用返回按钮的回条
		if (m_bForged) then
			updateTreasBag() --设置宝物背包的更新状态
			m_bForged = false
		end


		if (m_nSrcType == 1) then
			MainTreaBagCtrl.create()
		else
			LayerManager.changeModule(MainFormation.create(m_nHeroIndex), MainFormation.moduleName(), {1,3}, true)
		end
		if m_fnCallback then
			m_fnCallback()
		end
	end
end


tbEventListener.onForge = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 移除战斗力提升动画
		MainFormationTools.removeFlyText()

		-- 强化有主角等级限制
		local lvNeed = (tonumber(m_tbTreaInfo.va_item_text.treasureLevel) + 1) * m_tbTreaDb.level_interval

		if (UserModel.getHeroLevel() < lvNeed) then
			ShowNotice.showShellInfo(gi18nString(1735, lvNeed))
			return
		end

		if( tonumber(m_tbTreaInfo.va_item_text.treasureLevel) >= m_tbTreaDb.level_limited)then -- 超过最大强化等级
			ShowNotice.showShellInfo(mi18n[1620])
		elseif(m_nUpgradeNeedNum > UserModel.getSilverNumber()) then -- 没钱
			PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
			ShowNotice.showShellInfo(mi18n[1617])
		elseif(table.isEmpty(m_tbTreaIDs))then -- 没选择材料
			ShowNotice.showShellInfo(mi18n[1716])
		else
			local args = CCArray:create()
			local itemId = m_tbTreaInfo.item_id

			args:addObject(CCInteger:create(itemId))
			local t_args = CCArray:create()
			for k,v in pairs(m_tbTreaIDs) do
				t_args:addObject(CCInteger:create(tonumber(v)))
			end
			args:addObject(t_args)
			RequestCenter.forge_upgradeTreas(reinforceCallback,args )
		end
	end
end


tbEventListener.onAutoAdd = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		-- 强化有主角等级限制
		local lvNeed = (tonumber(m_tbTreaInfo.va_item_text.treasureLevel) + 1) * m_tbTreaDb.level_interval

		if (UserModel.getHeroLevel() < lvNeed) then
			ShowNotice.showShellInfo(gi18nString(1735, lvNeed))
			return
		end

		local tbAutoTreaList = treaForgeChooseCtrl.getTreaListData(m_tbTreaInfo.itemDesc.quality, m_tbTreaInfo.item_id,true)

		m_tbTreaIDs = {}
		m_tbTreaSelect = {}

		local treasBeEatExp = 0
		local isFull = false
		if m_nToMaxNeedExp <= 0 then
			isFull = true
		end

		for i=1, 5 do
			if (tbAutoTreaList[i]) then 
			local id = tbAutoTreaList[i].id

			-- local vType = v.itemDesc.type
			-- local mType = m_tbTreaDb.type

			local exp = tonumber(tbAutoTreaList[i].sExp)

			-- 经验宝物，没被添加过，一次最多加5个，类型限制，不是自己,经验不能浪费
			-- if (v.itemDesc.isExpTreasure == 1 and (not isVInTable(id))
			-- 	and num < 5 and (vType == mType or mType == 0 or vType == 0)
			-- 	and (id ~= m_tbTreaInfo.treaData.item_id)) then
				if not isFull then
					table.insert(m_tbTreaIDs, id)
					table.insert(m_tbTreaSelect, tbAutoTreaList[i].orignData)
					-- num = num + 1

					treasBeEatExp = treasBeEatExp + exp
					if treasBeEatExp >= m_nToMaxNeedExp then
						isFull = true
					end
				end
			end
		end

		--[[ 2015.01.24王晓靖说自动添加不添加普通宝物，只加经验宝物   2015.05.19--王晓靖说还是要加普通宝物
		for k, v in pairs(tbTreasureList) do
			local id = v.item_id
			local vType = v.itemDesc.type
			local mType = m_tbTreaDb.type
			local exp = v.va_item_text.treasureExp + v.itemDesc.base_exp_arr
             
            -- 小于被选宝物品质 并且是灰白绿蓝（1-4）  
			if (v.itemDesc.quality <= m_tbTreaDb.quality  and v.itemDesc.quality < 5 and  (not isVInTable(id))
				and num < 5 --and (vType == mType or mType == 0 or vType == 0)
				and (id ~= m_tbTreaInfo.treaData.item_id)) then
				if not isFull then
					table.insert(m_tbTreaIDs, id)
					table.insert(m_tbTreaInfo, v)
					num = num + 1

					treasBeEatExp = treasBeEatExp + exp
					if treasBeEatExp >= m_nToMaxNeedExp then
						isFull = true
					end
				end
			end
		end
		--]]

		if (table.isEmpty(m_tbTreaIDs)) then
			ShowNotice.showShellInfo(mi18n[1736])
		end
		TimeUtil.timeStart("updateUIForAddTreas")
		treaForgeView.updateUIForAddTreas(m_tbTreaSelect)  
		TimeUtil.timeEnd("updateUIForAddTreas")
		TimeUtil.timeStart("refreshSliverAndExp")
		refreshSliverAndExp()
		TimeUtil.timeEnd("refreshSliverAndExp")
	end
end


tbEventListener.onChoose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local layChoose = treaForgeChooseCtrl.create(m_tbTreaIDs, m_tbTreaInfo, m_nToMaxNeedExp)

		LayerManager.addLayoutNoScale(layChoose)
		UIHelper.changepPaomao(layChoose) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
	end
end


function create(treaID, srcType, nHeroIndex, callback)
	if (treaID) then
		init()
		m_nSrcType = srcType
		m_nHeroIndex = nHeroIndex
		m_fnCallback = callback
		m_tbTreaInfo = {}  -- 包含宝物DB信息 和宝物的等级，精炼等级，目前所属英雄等
		m_tbTreaInfo = treaInfoModel.fnGetTreasNetData(treaID)
		m_tbTreaDb = m_tbTreaInfo.itemDesc
		m_tbTreaInfo.forgeUnlock = treaInfoModel.getTreaForgeUnclock(m_tbTreaDb) 

		m_tbTreaInfo.expPercent = getExpPercent()

		local layForge = treaForgeView.create(m_tbTreaInfo, m_nSrcType, tbEventListener)

		-- zhangjunwu, 2014-10-24, 注册UI被remove的回调，判断是否有过至少一次强化成功，来判断是否需要更新宝物背包的数据
		--如果直接点击了 主船等按钮，则无法调用返回按钮的回条
		UIHelper.registExitAndEnterCall(layForge, function ( ... )
			if (m_bForged) then
				updateTreasBag() --设置宝物背包的更新状态
				m_bForged = false
				-- 移除战斗力提升动画
				MainFormationTools.removeFlyText()
				UIHelper.removeArmatureFileCache()  -- 释放动画缓存
			end
		end)
		return layForge
	end
end


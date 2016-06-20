-- FileName: RenascenceChooseCtrl.lua
-- Author: menghao
-- Date: 2014-05-23
-- Purpose: 重生选择列表ctrl


module("RenascenceChooseCtrl", package.seeall)


require "script/module/resolve/RenascenceChooseView"
require "script/module/treasure/treaInfoModel"
require "script/module/public/Cell/HeroCell"
require "script/module/public/Cell/EquipCell"
require "script/module/public/Cell/TreasureCell"


-- UI控件引用变量 --


-- 模块局部变量 --
local mi18n = gi18n

local m_tbSelectedHeroInfo 		-- 选择的英雄信息
local m_tbSelectedEquipInfo 	-- 选择的装备信息
local m_tbSelectedTreaInfo 		-- 选择的宝物信息

local m_tbHerosData 			-- 可重生的英雄信息表
local m_tbEquipsData 			-- 可重生的装备信息表
local m_tbTreasData 			-- 可重生的宝物信息表

local tbCell = {}
local m_nType
local m_curCell
local m_nCurIndex


--过滤武将
local function getCanRebornHerosData()
	local tbHeroesData = {}

	local tAllHeroes = HeroModel.getAllHeroes()

	for k, v in pairs(tAllHeroes) do
		local heroID = v.hid
		local db_hero = DB_Heroes.getDataById(v.htid)
		local canReborn = true
		-- 去除主角, zhangqi, 2015-01-09, 去主角修改不用判断了
		-- if HeroModel.isNecessaryHero(v.htid) then
		-- 	canReborn = false
		-- else

		-- 去除在阵上武将,小伙伴，替补
		local bIsBusy = DataCache.isHeroBusy(heroID)
		logger:debug("bIsBusy = %s" , bIsBusy)
		if  bIsBusy then
			canReborn = false
		end

		-- 强化过的才能重生
		if tonumber(v.level) < 2 then
			canReborn = false
		end
		-- 去掉1至3星及武将
		local nLimitStarLevel = 4
		if db_hero.star_lv < nLimitStarLevel then
			canReborn = false
		end
		-- end

		if (canReborn) then
			local heroInfo = HeroModel.getHeroByHid(heroID)

			local tbData = {}
			tbData.id = heroID
			tbData.name = db_hero.name
			tbData.sign = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
			tbData.icon = { id = v.htid, bHero = true}
			tbData.sLevel = heroInfo.level
			tbData.nStar = db_hero.star_lv
			tbData.nQuality = tonumber(db_hero.star_lv)
			tbData.sQuality = db_hero.heroQuality
			tbData.heroQuality = tbData.sQuality
			tbData.sTransfer = "+" .. heroInfo.evolve_level or 0
			tbData.bSelect = false

			logger:debug(db_hero.name)
			tbData.rebornGoldNeed = (heroInfo.evolve_level + 1) * db_hero.rebirth_basegold

			if tbData.id == m_tbSelectedHeroInfo.id then
				tbData.bSelect = true
				m_tbSelectedHeroInfo.tid = tbData.icon.id
				m_tbSelectedHeroInfo.goldNeed = tbData.rebornGoldNeed
				m_tbSelectedHeroInfo.name = tbData.name
				m_tbSelectedHeroInfo.quality = tbData.nStar
			end

			table.insert( tbHeroesData, tbData)
		end
	end

	local function sort(w1, w2)
		if (w1.nQuality < w2.nQuality) then
			return true
		elseif (w1.nQuality > w2.nQuality) then
			return false
		end
		if tonumber(w1.sLevel) < tonumber(w2.sLevel) then
			return true
		else
			return false
		end
	end

	table.sort(tbHeroesData, sort)

	return tbHeroesData
end

--过滤装备
local function getCanRebornEquipsData()
	local tbEquipsData = {}

	-- 背包中五星以上且强化过的装备才可以重生
	local tbAllBagEquipsInfo = DataCache.getBagInfo().arm
	for k,v in pairs(tbAllBagEquipsInfo) do
		if ((tonumber(v.itemDesc.quality) >= 3) and
			(tonumber(v.va_item_text.armReinforceLevel) > 0 or tonumber(v.va_item_text.armEnchantLevel or 0) > 0)) then
			local tbAttr, tbPLAttr, nScore, tbEquipDbInfo = ItemUtil.getEquipNumerialByIID(v.item_id)

			logger:debug("tbAllBagEquipsInfo")
			logger:debug(v)

			local tbData = {}
			tbData.id = v.item_id
			tbData.level = v.va_item_text.armReinforceLevel
			tbData.starLvl = v.itemDesc.quality
			tbData.nQuality = tonumber(v.itemDesc.quality)
			tbData.quality = nScore
			tbData.name = v.itemDesc.name
			tbData.sign = ItemUtil.getSignTextByItem(v.itemDesc)
			tbData.icon = { id = v.item_template_id, bHero = false }
			tbData.bSelect = false
			tbData.sScore = tonumber(v.itemDesc.base_score)
			tbData.sMagicNum = tonumber(v.va_item_text.armEnchantLevel)

			tbData.type = v.itemDesc.type
			-- 如果是经验装备，显示返还的附魔经验，2015-04-24, zhangqi
			-- 2015-04-24, zhangqi, 修改新的经验装备判断，子类型 type == 5
			if (tonumber(tbData.type) == 5) then
				tbData.sMagicExp = tostring(v.itemDesc.baseEnchantExp  + (v.va_item_text.armEnchantExp or 0))
			else
				tbData.tbAttr = {}
				local strDesc, i = "", 1
				for k, v in pairs(tbAttr) do
					if (v ~= 0) then
						strDesc = strDesc .. g_AttrNameWithoutSign[k] .. " +" .. v .. "\n"
						if (i%3 == 0 ) then
							table.insert(tbData.tbAttr, strDesc)
							strDesc = ""
						end
						i = i + 1
					end
				end
				table.insert(tbData.tbAttr, strDesc)
			end

			tbData.rebornGoldNeed = v.itemDesc.resetCostGold

			if tbData.id == m_tbSelectedEquipInfo.id then
				tbData.bSelect = true
				m_tbSelectedEquipInfo.tid = tbData.icon.id
				m_tbSelectedEquipInfo.goldNeed = tbData.rebornGoldNeed
				m_tbSelectedEquipInfo.name = tbData.name
				m_tbSelectedEquipInfo.quality = tbData.starLvl
			end

			table.insert( tbEquipsData, tbData )
		end
	end

	local function sort(w1, w2)
		if tonumber(w1.level) > tonumber(w2.level) then
			return true
		else
			return false
		end
	end

	table.sort(tbEquipsData, sort)
	return tbEquipsData
end


-- 过滤宝物
function getCanRebornTreasData()
	local tbTreasData = {}

	local bagInfo = DataCache.getBagInfo()

	for k,v in pairs(bagInfo.treas) do
		if (tonumber(v.itemDesc.quality) >= 4) and (v.itemDesc.isExpTreasure == nil) and (v.va_item_text.treasureEvolve ~= nil) then
			if (tonumber(v.va_item_text.treasureEvolve) > 0) or (tonumber(v.va_item_text.treasureLevel) > 0) then
				local tbTreaInfo = treaInfoModel.getSimpleTreaInfo(v.item_id) -- zhangqi, 2015-06-15, 替换开销小的方法
				local tbData = {}
				-- tbData赋值
				tbData.id = v.item_id

				tbData.name = tbTreaInfo.name
				tbData.sign = ItemUtil.getSignTextByItem(v.itemDesc)

				tbData.icon = { id = tbTreaInfo.treaData.item_template_id, bHero = false }
				tbData.sStrongNum = tbTreaInfo.level
				tbData.sRefinNum = tbTreaInfo.treaEvolve[1].lv
				tbData.nQuality = tonumber(tbTreaInfo.quality)
				tbData.sRank = tbTreaInfo.base_score

				local strAttrDesc = ""
				tbData.tbAttr = {}
				-- 添加基础属性信息 add by sunyunpeng 2015.07.10
				for i, v in ipairs(tbTreaInfo.baseProperty or {}) do
					strAttrDesc = strAttrDesc .. v.name .. " +" .. v.value .. "\n"
					if (i%3 == 0 ) then
						table.insert(tbData.tbAttr, strAttrDesc)
						strAttrDesc = ""
					end
				end

				for i, v in ipairs(tbTreaInfo.property or {}) do
					strAttrDesc = strAttrDesc .. v.name .. " +" .. v.value .. "\n"
					if (i%3 == 0 ) then
						table.insert(tbData.tbAttr, strAttrDesc)
						strAttrDesc = ""
					end
				end
				table.insert(tbData.tbAttr, strAttrDesc)

				tbData.rebornGoldNeed = v.itemDesc.rebirthGold

				tbData.bSelect = false

				if tbData.id == m_tbSelectedTreaInfo.id then
					tbData.bSelect = true
					m_tbSelectedTreaInfo.tid = tbData.icon.id
					m_tbSelectedTreaInfo.goldNeed = tbData.rebornGoldNeed
					m_tbSelectedTreaInfo.name = tbData.name
					m_tbSelectedTreaInfo.quality = tbData.nQuality
				end

				table.insert(tbTreasData, tbData)
			end
		end
	end

	local function sort(w1,w2)
		if tonumber(w1.sStrongNum) > tonumber(w2.sStrongNum) then
			return true
		else
			return false
		end
	end

	table.sort(tbTreasData,sort)

	return tbTreasData
end


local function init(...)
	m_curCell = nil
	m_nCurIndex = nil
	m_tbHerosData = getCanRebornHerosData()
	m_tbEquipsData = getCanRebornEquipsData()
	m_tbTreasData = getCanRebornTreasData()
end


function destroy(...)
	package.loaded["RenascenceChooseCtrl"] = nil
end


function moduleName()
	return "RenascenceChooseCtrl"
end


function create( tbRebornHeroInfo)
	m_tbSelectedHeroInfo = {}
	m_tbSelectedEquipInfo = {}
	m_tbSelectedTreaInfo = {}
	m_tbSelectedHeroInfo.id = heroID
	m_tbSelectedEquipInfo.id = equipID
	m_tbSelectedTreaInfo.id = treaID

	init()

	local tbListInfo
	if m_tbSelectedEquipInfo.id then
		m_nType = 2
		tbListInfo = m_tbEquipsData
	elseif m_tbSelectedTreaInfo.id then
		m_nType = 3
		tbListInfo = m_tbTreasData
	else
		m_nType = 1
		tbListInfo = m_tbHerosData
	end


	local tbEventListener = {}

	tbEventListener.onTab1 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nType  ~= 1) then
				m_nType = 1
				if (m_curCell) then
					m_curCell.cbxSelect:setSelectedState(false)
					tbListInfo[m_nCurIndex + 1].bSelect = false
				end
				m_tbSelectedHeroInfo.id = nil
				m_tbSelectedEquipInfo.id = nil
				m_tbSelectedTreaInfo.id = nil
				m_curCell = nil
				m_nCurIndex = nil
				tbListInfo = m_tbHerosData
				RenascenceChooseView.updateTableView(1)
				RenascenceChooseView.updateTxtAndBtn(mi18n[1020], m_nType)
			end
		end
	end

	tbEventListener.onTab2 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nType ~= 2) then
				m_nType = 2
				if m_curCell then
					m_curCell.cbxSelect:setSelectedState(false)
					tbListInfo[m_nCurIndex + 1].bSelect = false
				end
				m_tbSelectedHeroInfo.id = nil
				m_tbSelectedEquipInfo.id = nil
				m_tbSelectedTreaInfo.id = nil
				m_curCell = nil
				m_nCurIndex = nil
				tbListInfo = m_tbEquipsData
				RenascenceChooseView.updateTableView(2)
				RenascenceChooseView.updateTxtAndBtn(mi18n[1522], m_nType)
			end
		end
	end

	tbEventListener.onTab3 = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			sender:setFocused(true)
			if (m_nType ~= 3) then
				m_nType = 3
				if m_curCell then
					m_curCell.cbxSelect:setSelectedState(false)
					tbListInfo[m_nCurIndex + 1].bSelect = false
				end
				m_tbSelectedHeroInfo.id = nil
				m_tbSelectedEquipInfo.id = nil
				m_tbSelectedTreaInfo.id = nil
				m_curCell = nil
				m_nCurIndex = nil
				tbListInfo = m_tbTreasData
				RenascenceChooseView.updateTableView(3)
				RenascenceChooseView.updateTxtAndBtn(mi18n[1713], m_nType)
			end
		end
	end

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
		end
	end

	tbEventListener.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			RenascenceCtrl.changeID(m_tbSelectedHeroInfo, m_tbSelectedEquipInfo, m_tbSelectedTreaInfo)
			LayerManager.removeLayout()
		end
	end

	tbEventListener.tableCellTouched = function ( view, cell )
		AudioHelper.playCommonEffect()

		local index = cell:getIdx()

		local instCell = tbCell[cell]

		local tbData = tbListInfo[index + 1]

		-- 如果点击的是没有选中的
		if (not tbData.bSelect) then
			-- 如果有其他cell被勾选
			if (m_curCell) then
				m_curCell.cbxSelect:setSelectedState(false)
				tbListInfo[m_nCurIndex + 1].bSelect = false
			end
			if (m_nType  == 2) then
				m_tbSelectedEquipInfo.id = tbData.id
				m_tbSelectedEquipInfo.tid = tbData.icon.id
				m_tbSelectedEquipInfo.goldNeed = tbData.rebornGoldNeed
				m_tbSelectedEquipInfo.name = tbData.name
				m_tbSelectedEquipInfo.quality = tbData.starLvl
			elseif m_nType == 1 then
				m_tbSelectedHeroInfo.id = tbData.id
				m_tbSelectedHeroInfo.tid = tbData.icon.id
				m_tbSelectedHeroInfo.goldNeed = tbData.rebornGoldNeed
				m_tbSelectedHeroInfo.name = tbData.name
				m_tbSelectedHeroInfo.quality = tbData.nStar
			else
				m_tbSelectedTreaInfo.id = tbData.id
				m_tbSelectedTreaInfo.tid = tbData.icon.id
				m_tbSelectedTreaInfo.goldNeed = tbData.rebornGoldNeed
				m_tbSelectedTreaInfo.name = tbData.name
				m_tbSelectedTreaInfo.quality = tbData.nQuality
			end
			m_nCurIndex = index
			m_curCell = instCell

			RenascenceChooseView.updateNum(1)
			-- 如果点击的已经选中的
		else
			m_tbSelectedEquipInfo.id = nil
			m_tbSelectedHeroInfo.id = nil
			m_tbSelectedTreaInfo.id = nil
			m_nCurIndex = nil
			m_curCell = nil
			RenascenceChooseView.updateNum(0)
		end
		tbData.bSelect = not tbData.bSelect
		instCell.cbxSelect:setSelectedState(tbData.bSelect)
	end

	tbEventListener.cellSizeForTable = function ( view, idx )
		local sizeCell = g_fnCellSize(CELLTYPE.EQUIP)
		return sizeCell.height, sizeCell.width
	end

	tbEventListener.tableCellAtIndex = function ( view, idx )
		local cell = view:dequeueCell()

		local tbData = tbListInfo[idx + 1]

		if (not cell) then
			local instCell
			if (m_nType == 2) then
				instCell = EquipCell:new()
			elseif m_nType == 1 then
				instCell = PartnerCell:new()
			else
				instCell = TreasureCell:new()
			end

			instCell:init(CELL_USE_TYPE.REBORN)
			instCell:refresh(tbData)
			local tg = instCell:getGroup()

			cell = CCTableViewCell:new()
			cell:addChild(tg, idx, 10)

			if tbData.bSelect == true then
				m_curCell = instCell
				m_nCurIndex = idx
			end

			tbCell[cell] = instCell
		else
			local instCell = tbCell[cell]
			instCell:refresh(tbData)
			if tbData.bSelect == true then
				m_curCell = instCell
				m_nCurIndex = idx
			end
		end

		return cell
	end

	tbEventListener.numberOfCellsInTableView = function ( view )
		return #tbListInfo
	end

	local layMain = RenascenceChooseView.create( tbEventListener, m_tbSelectedHeroInfo.id, m_tbSelectedEquipInfo.id, m_tbSelectedTreaInfo.id)

	LayerManager.setPaomadeng(layMain, 10)
	UIHelper.registExitAndEnterCall(layMain, function ( ... )
		LayerManager.resetPaomadeng()
	end)
	return layMain
end


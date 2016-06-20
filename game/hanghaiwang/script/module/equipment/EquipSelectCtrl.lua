-- FileName: EquipSelectCtrl.lua
-- Author: zhaoqiangjun
-- Date: 2014-06-19
-- Purpose: 装备选择列表ctrl

module("EquipSelectCtrl", package.seeall)

require "script/module/public/Cell/EquipCell"
require "script/module/public/ChooseList"
require "script/module/bag/BagUtil"
require "script/model/hero/HeroModel"
require "script/model/user/UserModel"
require "script/module/formation/MainFormation"
require "script/module/guide/GuideCtrl"

local mItemUtil = ItemUtil
local m_i18n = gi18n
local m_fnGetWidget 	= g_fnGetWidgetByName
local tbCell 			= {}
local m_nSelectedNum 	= 0
local m_tbSelectedID 	= {}
local m_nTotalExp 		= 0
local m_nType
local m_nEquipBeStrongID
local m_armPos
local m_hid
local m_fromHid			= 0
local m_sOldItemId

local m_tbEquipDatas 	= {}

local function changeBagData( ... )

	local bagInfo = DataCache.getRemoteBagInfo()

	local selectedIteminfo = nil
	--在背包中取装备
	if (m_fromHid == 0) then
		for i_gid, treaInfo in pairs(bagInfo.arm) do
			if (treaInfo.item_id == m_sOldItemId) then
				selectedIteminfo = treaInfo
				--在这里更新下背包的八个位置的数据
				mItemUtil.solveBagLackInfo(bagInfo.arm[i_gid], 1)
				
				bagInfo.arm[i_gid] = nil
				DataCache.setBagInfo(bagInfo)
				break
			end
		end
	--在英雄身上
	else
		selectedIteminfo = mItemUtil.getEquipsOnFormationByPosAndHid(m_armPos, m_fromHid)
	end

	local allHeros 			= HeroModel.getAllHeroes()

	-- 之前的装备
	local sHid, sPos 		= tostring(m_hid), tostring(m_armPos)

	require "script/module/formation/MainEquipMasterCtrl"
	local befor = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(allHeros[sHid])

	--对于原来在别人身上的要添加到表中
	local oldArm = allHeros[sHid].equip.arming[sPos]
	if(oldArm and tonumber(oldArm) ~= 0) then
		mItemUtil.pushitemCallback(oldArm, 1)
	end

	if(m_fromHid ~= 0)then
		allHeros[tostring(m_fromHid)].equip.arming[sPos] = "0"
	end
	allHeros[sHid].equip.arming[sPos] = selectedIteminfo -- 更换装备

	UserModel.setInfoChanged(true)
	UserModel.updateFightValue({[sHid] = {HeroFightUtil.FORCEVALUEPART.ARM, HeroFightUtil.FORCEVALUEPART.MASTER}, 
								[m_fromHid] = {HeroFightUtil.FORCEVALUEPART.ARM,  HeroFightUtil.FORCEVALUEPART.MASTER} })


	local pChangeInfo = nil
	if(selectedIteminfo and selectedIteminfo.item_template_id) then
		local pDb = mItemUtil.getItemById(selectedIteminfo.item_template_id)
		local suitID = pDb.jobLimit or nil
		if(suitID) then
			if(not pChangeInfo) then
				pChangeInfo = {}
			end
			if(not pChangeInfo[""..suitID]) then
				pChangeInfo[""..suitID] = { suit = suitID , info = {}}
			end
			local ppTB = {name = pDb.name, quality = pDb.quality}
			table.insert(pChangeInfo[""..suitID].info , ppTB)
		end
	end
	if(pChangeInfo) then
		local armID = {}
		for k,v in pairs(allHeros[sHid].equip.arming) do
			if(v.item_template_id) then
				table.insert(armID,v.item_template_id)
			end
		end
		pChangeInfo.arm = armID
	end

	
	MainFormation.updateHeroEquipment(m_nType)

	require "script/module/formation/MainEquipMasterCtrl"
	local after = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(allHeros[sHid])
	local pStringinfo = MainEquipMasterCtrl.fnGetAllMasterChangeString2(befor,after)
	MainFormation.showFlyQuality(pChangeInfo,pStringinfo)--漂字


	--清空装备背包数据
	require "script/module/equipment/MainEquipmentCtrl"
	MainEquipmentCtrl.cleanArmData()
end

local function onLoadEquipCallBack( cbFlag, dictData, bRet )
	if (bRet) then
		changeBagData()
		LayerManager.removeLayout()
	end
end

local function getHeroNameByHid( herohid )
    local heroInfo  =  HeroModel.getHeroByHid(herohid)
    local htid = heroInfo.htid
    local heroDBInfo = DB_Heroes.getDataById(htid)
    local heroId = heroDBInfo.model_id;

    if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or ((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
        return UserModel.getUserName()
    else
        return heroDBInfo.name
    end
end

-- zhangqi, 2015-11-03, 根据伙伴id和装备htid判断此装备是否可激活加成
local function isCanActiveAddAttr( heroHid, equipHtid)
	local heroInfo  =  HeroModel.getHeroByHid(heroHid)
	require "script/model/utils/HeroUtil"
	local addAttrInfo = HeroUtil.getTidsOfAddtionalAttrEnabled(heroInfo.htid) or {}
	return addAttrInfo[tostring(equipHtid)] or false
end
	

local function solveTheEquipCellInfo( v, tbEquipsData )
	-- 去掉同种类型的装备
	if(v.itemDesc.type ~= m_nType ) then
		return
	end

	local pDb = DB_Item_arm.getDataById(v.item_template_id)
	if (pDb and tonumber(pDb.type) == 5 ) then -- 2015-04-16, zhangqi, 修改新的经验装备判断，子类型 type == 5
		return
	end

	if v.equip_hid then
		if (tonumber(v.equip_hid) == tonumber(m_nEquipBeStrongID)) then
			return
		end
	end

	local sEnchant = nil -- zhangqi, 2015-01-26, 装备附魔等级
    if (EquipFixModel.isEuipCanFixByTid(v.item_template_id) == 1) then
        sEnchant = v.va_item_text.armEnchantLevel or "0" -- 如果后端数据没有附魔字段则默认为 "0"
    end 

	--去掉需要替换装备
	local tbAttr, tbPLAttr, nScore, tbEquipDbInfo = mItemUtil.getEquipNumerialByIID(v.item_id)

	local tbData 	= {}
	tbData.id 		= v.item_id
	tbData.level 	= v.va_item_text.armReinforceLevel
	tbData.starLvl 	= v.itemDesc.quality  -- 星级弃用，zhangqi, 2014-07-24
	tbData.quality 	= nScore
	tbData.sMagicNum = sEnchant -- zhangqi, 添加附魔等级
	tbData.nQuality	= v.itemDesc.quality
	tbData.sScore 	= tostring(v.itemDesc.base_score)
	tbData.name 	= v.itemDesc.name
	tbData.sign = ItemUtil.getSignTextByItem(v.itemDesc)
	tbData.icon 	= { id = v.item_template_id, bHero = false }
	tbData.icon.onTouch = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            require "script/module/equipment/EquipInfoCtrl"
            local layout = EquipInfoCtrl.createForSellEquip(v) -- 只带一个"返回"按钮的装备信息面板
            LayerManager.addLayoutNoScale(layout)
        end
    end
	tbData.bSelect 	= false
    
	local fromHid 	= 0
	if v.equip_hid then
		tbData.owner 	= getHeroNameByHid(v.equip_hid)
		fromHid 	= v.equip_hid
	end

	-- zhangqi, 2015-11-03, 增加判断是否显示可激活加成的字段
	tbData.bActiveAdd = isCanActiveAddAttr(m_tbSelectedID.hid, v.itemDesc.id)

	tbData.onLoad 		= function ( sender, eventType )
		if (eventType 	== TOUCH_EVENT_ENDED) then

			AudioHelper.playClickArmEffect()
			
			m_hid 			= m_nEquipBeStrongID;
			m_armPos 		= m_nType;
			local itemId 	= v.item_id;
			--装备所在伙伴hid：fromHid
			m_sOldItemId 	= itemId
			local args = CCArray:create()
			args:addObject(CCInteger:create(m_hid))
			args:addObject(CCInteger:create(m_armPos))
			args:addObject(CCInteger:create(itemId))
			if tonumber(fromHid) > 0 then
				m_fromHid = fromHid
				args:addObject(CCInteger:create(fromHid))
			else
				m_fromHid = 0
			end
			--点击装备按钮，回调方法
			RequestCenter.hero_addArming(onLoadEquipCallBack, args )
		end
	end

	-- zhangqi, 2014-07-24, 属性值改为2列显示，1列显示3个
	tbData.tbAttr = {}
	-- zhangqi, 2015-12-26, 增加附魔等级和属性的显示
	if (v.itemDesc.canEnchant == 1) then -- 可以附魔
        -- zhangqi, 2015-01-26, 装备附魔等级
        if (EquipFixModel.isEuipCanFixByTid(v.item_template_id) == 1) then
            tbData.sMagicNum = v.va_item_text.armEnchantLevel or "0" -- 如果后端数据没有附魔字段则默认为 "0"
        end
    end

    if (tbData.sMagicNum and tonumber(tbData.sMagicNum) > 0) then
        ItemUtil.addEnchantAttr(v.itemDesc, tbData.sMagicNum, tbAttr, tbData.tbAttr)
    else
        ItemUtil.insertEquipAttr(tbAttr, tbData.tbAttr) -- 一般属性
    end


	tbData.rebornGoldNeed = v.itemDesc.resetCostGold

	table.insert( tbEquipsData, tbData )
end


local function sort(equip_1, equip_2)
	-- logger:debug(w1)
	-- logger:debug("w1 Info.")
	
	local isPre = false

	if( tonumber(equip_1.starLvl) > tonumber(equip_2.starLvl))then
		isPre = true
	elseif(tonumber(equip_1.starLvl) == tonumber(equip_2.starLvl))then
		local t_equip_score_1 = equip_1.quality
		local t_equip_score_2 = equip_2.quality

		if(t_equip_score_1 > t_equip_score_2)then
			isPre = true
		elseif(t_equip_score_1 == t_equip_score_2) then
			if tonumber(equip_1.level) > tonumber(equip_2.level) then
				isPre = true
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end

	return isPre
end

local function solveTheEquipInfo( ... )

	local tbEquipsData = {}

	local tbAllBagEquipsInfo = DataCache.getBagInfo().arm

	for k,v in pairs(tbAllBagEquipsInfo) do
		solveTheEquipCellInfo(v, tbEquipsData)
	end

	table.sort(tbEquipsData, sort)
	return tbEquipsData
end

local function solveTheHeroEquipInfo( ... )

	local tbEquipsData = {}

	local heroEquips = mItemUtil.getEquipsOnFormation()

	for i,v in ipairs(heroEquips) do
		solveTheEquipCellInfo(v, tbEquipsData)
	end

	table.sort(tbEquipsData, sort)
	return tbEquipsData
end

--获取所有的装备
local function getAllOfEquips( ... )

	local heroEquips = solveTheHeroEquipInfo()
	local bagEquips = solveTheEquipInfo()
	local allEquips = {}
	
	--将伙伴身上的装备放到装备列表中
	for i,v in ipairs(bagEquips) do
		table.insert(allEquips, v)
	end

	--将阵上的装备放到装备列表中
	for i,v in ipairs(heroEquips) do
		table.insert(allEquips, v)
	end
	
	return allEquips
end 

local function init(...)
	m_nTotalExp = 0
end


function destroy(...)
	package.loaded["EquipSelectCtrl"] = nil
end


function moduleName()
	return "EquipSelectCtrl"
end


function create( tbSelectedID, equipType, equipID )
	logger:debug({EquipSelectCtrl_tbSelectedID = tbSelectedID, equipType = equipType, equipID = equipID})
	m_nSelectedNum = #tbSelectedID
	m_tbSelectedID = tbSelectedID
	m_nType = equipType
	m_nEquipBeStrongID = equipID

	init()

	GuideCtrl.removeGuideView()
	local tbEquipListInfo = getAllOfEquips()

	local tbEventListener = {}

	tbEventListener.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
		end
	end

	tbEventListener.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end

	local instTableView
	local tbInfo = {}

	tbInfo.sType = CHOOSELIST.LOADEQUIP
	tbInfo.onBack = tbEventListener.onBack
	tbInfo.tbState = {sChoose = m_i18n[1522],sChooseNum = m_nSelectedNum,
		sExp = m_i18n[1060], sExpNum = m_nTotalExp, onOk = tbEventListener.onSure}


	tbInfo.tbView = {}
	tbInfo.tbView.szCell = g_fnCellSize(CELLTYPE.EQUIP)
	tbInfo.tbView.tbDataSource = tbEquipListInfo

	tbInfo.tbView.CellAtIndexCallback = function (tbDat)
		local instCell = EquipCell:new()
		instCell:init(CELL_USE_TYPE.LOAD)
		instCell:refresh(tbDat)
		return instCell
	end

	tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)

		return
	end

	instTableView = ChooseList:new()
	local layMain = instTableView:create(tbInfo)


	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideEquipView"
	if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 2) then
		assert(instTableView.objView ~= nil, "再遇见这个问题找策划， 让策划把装备配上")
		
		local scene = CCDirector:sharedDirector():getRunningScene()
	    performWithDelay(scene, function(...)
	      	instTableView.objView.view:setTouchEnabled(false)
			local cell = instTableView.objView.view:cellAtIndex(0)
			local layCell = instTableView.objView.tbCellMap[cell]
			local pos = layCell.btnLoad:getWorldPosition()
			logger:debug("pos.x = %s pos.y = %s", pos.x, pos.y)
			GuideCtrl.createEquipGuide(3, 0, pos)
	    end, 1/60)
	end


	return layMain
end
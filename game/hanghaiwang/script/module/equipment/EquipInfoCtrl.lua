-- FileName: EquipInfoCtrl.lua
-- Author: zhangqi
-- Date: 2014-05-05
-- Purpose: 创建装备信息面板的控制器模块，提供2个方法分别供阵容模块和装备模块调用，返回不同的UI
-- modified:
	-- zhangqi, 2014-08-27, 增加在他人阵容中查看套装装备的处理，修改关键字 tbAllUse
--[[TODO List]]

module("EquipInfoCtrl", package.seeall)

require "script/model/DataCache"
require "script/module/equipment/EquipInfoViewNew" -- 新版装备信息面板

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_tbAttr -- 当前属性值
local m_tbPLAttr -- 每级属性加成值
local m_nScore -- 品级得分
local m_tbEquipInfo
local m_nSuitId = nil -- 装备或碎片对应装备的套装id, zhangqi, 2014-07-14
-- add by huxiaozhou 2014.05.06
local m_tbEquip

local m_attrName = g_AttrName
local m_attrNameSpaces = g_AttrNameSpaces
local m_curPageNum = -1
local m_equipFrom = g_equipStrengthFrom -- zhangqi, 2015-06-19

local m_type

local function init(...)
	m_type = nil
end

function destroy(...)
	package.loaded["EquipInfoCtrl"] = nil
end

function moduleName()
    return "EquipInfoCtrl"
end

function showEquipInfo( createType, tbInfo, tbBtnEvent, isDrawTip )
	local instanceInfoView = EquipInfoViewNew:new()
	layEquip = instanceInfoView:create(createType, tbInfo, tbBtnEvent, isDrawTip)
	LayerManager.addLayoutNoScale(layEquip)

	UIHelper.changepPaomao(layEquip)
end

local eventBack = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		LayerManager.removeLayout()
	end
end


local function removeArmingCallBack( cbFlag, dictData, bRet  )

	if(dictData.err == "ok")then
		local t_numerial = ItemUtil.getTop2NumeralByIID(tonumber(m_tbEquip.item_id))
		HeroModel.removeEquipFromHeroBy(m_tbEquip.hid, m_tbEquip.pos)

		local mtid = m_tbEquip.item_template_id
		local mDict = DB_Item_arm.getDataById(mtid)
		local mtype = mDict.type

		LayerManager.removeLayout()

		UserModel.setInfoChanged(true)
		local hid = m_tbEquip.hid
		UserModel.updateFightValue({[hid] = {HeroFightUtil.FORCEVALUEPART.ARM, HeroFightUtil.FORCEVALUEPART.MASTER}})

		require "script/module/formation/MainFormation"
		MainFormation.removeHeroEquipment(mtype) -- zhangqi, 2015-06-19, 必须先更新战斗力才有效
		

		MainFormation.showFlyQuality()--漂字

		--清空装备背包数据
		require "script/module/equipment/MainEquipmentCtrl"
		MainEquipmentCtrl.cleanArmData()
	end
end

--[[desc: 更换 和 卸下 按钮的事件回调
    tbBtnEvent:
    nBackPage: 返回阵容页面时需要显示的伙伴页
    return: 是否有返回值，返回值说明
—]]
local function getEquiptbEvenet( tbBtnEvent, tbEquip )
	tbBtnEvent.onChange = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			-- zhaoqiangjun  TODO
			LayerManager.removeLayout()

			require "script/module/equipment/EquipSelectCtrl"
			local tbChangeInfo = {hid = tbEquip.hid, equipType = tbEquip.equipType, heroPage = tbEquip.heroPage}
			local equipList = EquipSelectCtrl.create(tbChangeInfo, tbEquip.equipType, tbEquip.hid)
			LayerManager.addLayoutNoScale(equipList, LayerManager.getModuleRootLayout())
			UIHelper.changepPaomao(equipList) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
		end
	end
	tbBtnEvent.onUnload = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if (ItemUtil.isEquipBagFull(true)) then
				return
			end

			require "script/network/RequestCenter"
			local params = CCArray:create()
    		local item_id_integer = CCInteger:create(tonumber(tbEquip.hid))
    		local pos_integer   = CCInteger:create(tbEquip.pos)
    		params:insertObject(item_id_integer , 0)
    		params:insertObject(pos_integer , 1)
			RequestCenter.hero_removeArming(removeArmingCallBack,params)
		end
	end
	
end

local function alignData(tbInfo,tbAttr,tbPLAttr)
	tbInfo.m_tbAttr = {}
	for key,v_num in pairs(tbAttr) do
	    local descName = m_attrName[key]
	    
	    local descString = ""
	    if (v_num~=0) then
	    	descString = descString .. v_num
	   		 local tb = {}
	    	tb.descName = descName
	    	tb.descString = "+" .. descString
	   		tbInfo.m_tbAttr[#tbInfo.m_tbAttr + 1] = tb
		end
	end

	-- zhangqi, 2015-12-26, m_tbPLAttr完全没用到，先注释
	-- tbInfo.m_tbPLAttr = {}
	-- for key,v_num in pairs(tbPLAttr) do
	--     local descName = m_attrName[key]

	--     local descString = ""
	--     if (v_num~=0) then
	--     	descString = descString .. "+" ..  v_num
	--    		 local tb = {}
	--     	tb.descName = descName
	--     	tb.descString = descString
	--    		tbInfo.m_tbPLAttr[#tbInfo.m_tbPLAttr + 1] = tb
	-- 	end
	-- end
end

-- 根据属性值的类型构造对应的显示方式（包括数值和百分比数值的形式）
local function alignAffixValue( affix, tbTarget, level )
	-- logger:debug({alignAffixValue_affix = affix})

	if (string.find(affix.num, "%%")) then
		local displayNum = affix.realNum / 100 * level
		if(displayNum > math.floor(displayNum))then
			displayNum = string.format("%.1f", displayNum)
		end
		tbTarget.descString = string.format("+%s%%", displayNum)
	else
		tbTarget.descString = string.format("+%d", level * affix.num)
	end
	--logger:debug({alignAffixValue_tbTarget = tbTarget})
end

-- zhangqi, 2016-01-23, 准备装备信息上基础属性和附魔能力的信息
local function alignEnchantAbility( tbInfo, dbEquip )
	if (not dbEquip.addEnchantAffix) then
		return -- 没有配置不算属性
	end

	local function procAddEnchantAffix( str )
		local strAffix = ""
		local ret = {}
		local affix = string.strsplit(str, ",")
		for i, item in ipairs(affix) do
			local af = string.strsplit(item, "|")
			ret[#ret + 1] = af
			strAffix = strAffix .. af[2] .. "|" .. af[3] .. ","
		end

		return string.sub(strAffix, 1, -2), ret
	end
	-- 101222	浪人长刀	0|25|100,1|15|100,2|50|100……
	local attrString, arrAffix = procAddEnchantAffix(dbEquip.addEnchantAffix)
	local tbAffix = ItemUtil.parseAffixString(attrString)
	-- logger:debug({alignEnchantAbility_tbAffix = tbAffix, arrAffix = arrAffix})

	local function genAttr( affix )
		-- logger:debug({genAttr_affix = affix})
			local tb = {}
			tb.descName = affix.name .. ":"

			alignAffixValue(affix, tb, 1) -- 1表示只计算原值
			return tb
	end

	for i, affix in ipairs(arrAffix) do
		local baseLv = tonumber(affix[1])
		if (baseLv == 0) then -- 0级解锁只算基础属性
			tbInfo.m_tbEnchanBase = tbInfo.m_tbEnchanBase or {}
			tbInfo.m_tbEnchanBase[#tbInfo.m_tbEnchanBase + 1] = genAttr(tbAffix[i])
		elseif (baseLv > 0) then -- 大于0级解锁的算附魔能力
			tbInfo.m_tbEnchanBility = tbInfo.m_tbEnchanBility or {}
			tbInfo.m_tbEnchanBility[#tbInfo.m_tbEnchanBility + 1] = genAttr(tbAffix[i])
			tbInfo.m_tbEnchanBility[#tbInfo.m_tbEnchanBility].baseLv = baseLv
			tbInfo.m_tbEnchanBility[#tbInfo.m_tbEnchanBility].bUnlock = tonumber(tbInfo.nEnhanceLv) >= baseLv
		end
	end

	-- logger:debug({alignEnchantAbility_tbInfo = tbInfo})
end

--zhangjunwu 获取附魔属性
-- zhangqi, 2015-12-26, 附魔属性由固定5种变为任意种类，改为由附魔等级计算属性值
-- 将参数 tbEnchantPLAttr 替换为dbEquip，传入装备的配置信息
-- 附魔属性(最多3条)，显示值=装备的附魔等级×每级附魔成长值
local function alignEnchantData(tbInfo, dbEquip)
	-- tbInfo.sCurEnhanceLv = "(+" .. enhanceLv .. ")"
	local _, _, nEnhanceLv = string.find(tbInfo.sCurEnhanceLv, "%(%+(%d+)%)")
	nEnhanceLv = tonumber(nEnhanceLv) -- 当前附魔等级

	-- DB_Item_arm.enchantAffix ("2|21,3|21,21|60")
	local tbAffix = ItemUtil.parseAffixString(dbEquip.enchantAffix)
	--logger:debug({alignEnchantData_tbAffix = tbAffix})
	
	tbInfo.m_tbEnchantAttr = {}
	for i, affix in ipairs(tbAffix) do
		local tb = {}
		tb.descName = affix.name
		
		if (string.find(affix.num, "%%")) then
			local displayNum = affix.realNum / 100 * nEnhanceLv
			if(displayNum > math.floor(displayNum))then
				displayNum = string.format("%.1f", displayNum)
			end
			tb.descString = string.format("+%s%%", displayNum)
		else
			tb.descString = string.format("+%d", nEnhanceLv * affix.num)
		end
		tbInfo.m_tbEnchantAttr[#tbInfo.m_tbEnchantAttr + 1] = tb
	end
end

-- 准备套装加成属性，zhangqi, 2014-07-11
local function addSuitAttr( tbSuit, suitAffix)
	require "db/DB_Affix"

	local tbAttr = {}
	for k, v in pairs(suitAffix) do
		tbAttr[k] = {} -- 每个解锁对应的属性值，k in [2,3,4]
		local tbAffix = string.strsplit(v, ",")
		for i, sAffix in ipairs(tbAffix) do
			local id, value = string.match(sAffix, "(%d+)|(%d+)")
			local attr = {}
			attr.descName, attr.descString = ItemUtil.getAttrNameAndValueDisplay(tonumber(id), value, "+")
			tbAttr[k][i] = attr
		end
	end
	tbSuit.tbAttr = tbAttr
end

-- 准备套装信息，zhangqi, 2014-07-11
local function addSuitInfo( tbInfo, suitId, itid, tbAllUse )

	require "db/DB_Suit"
	local tbSuit = DB_Suit.getDataById(tonumber(suitId))

	local data = {}
	data.name = tbSuit.name -- 套装名称
	data.ids = string.strsplit(tbSuit.suit_items, ",") -- 所有套装装备的item_template_id

	local allUse = {} -- 已穿装备item_template_id
	if (tbInfo.hid) then -- 如果当前显示的装备已经穿戴在hid标志的伙伴身上

		-- 如果 tbAllUse 不为nil，表示查看他人阵容时传入的所有已穿戴装备的信息
		local arrTid = {}
		if (tbAllUse) then
			for k, equip in pairs(tbAllUse) do
				table.insert(arrTid, equip.item_template_id)
			end
		end
		allUse = #arrTid > 0 and arrTid or HeroUtil.getTemplateIdOfEquipByHid(tbInfo.hid) -- 获取此伙伴穿戴的所有装备的item_template_id，array
	end

	local hasCount = 1 -- 已经穿戴的套装装备数量
	local tbGray = {} -- 需要置灰的套装装备 item_template_id
	tbGray[tostring(itid)] = false -- 当前查看装备默认不置灰
	for i, tid in ipairs(data.ids) do
		if (tid ~= tostring(itid)) then
			tbGray[tid] = true  -- 默认置灰
			for i, useId in ipairs(allUse) do
				if (tid == useId) then
					tbGray[tid] = false  -- 套装装备和伙伴身上装备的item_template_id一致，不置灰
					hasCount = hasCount + 1
					break
				end
			end
		end
	end
	data.gray = tbGray
	data.hasCount = hasCount
	tbInfo.suit = data

	local suitAffix = {}
	for i = 1, 3 do -- 目前解锁属性只有 lock_num1 - lock_num3
		local count = tbSuit["lock_num" .. i]
		suitAffix[count] = tbSuit["astAttr" .. i]
	end

	addSuitAttr(tbInfo.suit, suitAffix)
end

-- 装备
local function getEquipShowData( tbEquip, tbAllUse, nlevel)
	--[[
	{
		item_template_id = "103205"
		item_num = "1"
		va_item_text = {
			armReinforceCost = "0"
			armReinforceLevel = "0"
			armEnchantLevel = "0" -- 如果不可附魔则没有这个字段
			}
			
		item_id = "1003979"
		item_time = "1398652874.000000"
	}

		nType: 1, 阵容；2，装备
	    tbInfo: 只包含装备信息相关内容的自定义table, {cardBgPath, name, nQuality, armPath, sScore, sLv, sAttack, sHR, sHurt, sEscap, sLvHR, sLvAttack, sDesc}
	    tbBtnCallBack: 存放功能按钮的回调方法，{onChange, onUnload, onXilian, onReinforce}
	]]
	
	-- m_tbAttr, m_tbPLAttr, m_nScore, m_tbEquipInfo = ItemUtil.getEquipNumerialByIID(tbEquip.item_id)
	-- zhangqi, 2015-21-26, 装备信息界面中，强化属性的部分不应该包括附魔的属性, m_tbAttr 不包括附魔属性
	_, m_tbPLAttr, m_nScore, m_tbEquipInfo, _, m_tbAttr = ItemUtil.getEquipNumerialByIID(tbEquip.item_id)
	local equip = nil
	if (m_tbEquipInfo) then
		equip = m_tbEquipInfo.itemDesc -- 配置表里信息
	else
		require "db/DB_Item_arm"
		equip = DB_Item_arm.getDataById(tbEquip.item_template_id)
		m_tbAttr, m_tbPLAttr = ItemUtil.getEquipNumerialByIID(tonumber(tbEquip.item_template_id),tbEquip)
	end

	local tbInfo = {}
	tbInfo.cardBgPath = "images/item/equipinfo/card/equip_" .. equip.quality .. ".png"
	tbInfo.name = equip.name
	tbInfo.nQuality = equip.quality
	tbInfo.armPath = "images/base/equip/big/" .. equip.icon_big
	tbInfo.sScore = tostring(equip.base_score) -- zhangqi, 2014-07-24, 改成直接读配置表
	tbInfo.nSubType = equip.type -- 2015-04-17, 装备子类型

	local level = tbEquip.va_item_text.armReinforceLevel
	local nextLv = equip.level_limit_ratio * (nlevel or UserModel.getHeroLevel())
	tbInfo.sLv = level .. "/" .. nextLv
	tbInfo.sDesc = equip.desc
	alignData(tbInfo,m_tbAttr,m_tbPLAttr)

	local enhanceLv = tbEquip.va_item_text.armEnchantLevel or 0 -- 2015-04-18, zhangqi, 当前附魔等级, 没有这个字段默认为0
	local nextEnhanceLv = ItemUtil.getMaxEnchatLevel(tbEquip) -- 下一级附魔等级
	tbInfo.sCurEnhanceLv = "(+" .. enhanceLv .. ")"
	tbInfo.sEnhanceLv = enhanceLv .. "/" .. nextEnhanceLv
	tbInfo.nEnhanceLv = tonumber(enhanceLv)
	tbInfo.bCanEnhant = equip.canEnchant == 1 -- 可以附魔

	if (tbInfo.bCanEnhant) then
		alignEnchantData(tbInfo, equip) -- zhangqi, 2015-12-26
		alignEnchantAbility(tbInfo, equip) -- zhangqi, 2016-01-20
	end

	if (tonumber(equip.type) == 5) then -- 如果是经验装备
        tbInfo.sMagicExp = tostring(tbEquip.itemDesc.baseEnchantExp  + (tbEquip.va_item_text.armEnchantExp or 0))
    end

	-- zhangqi, 2014-07-11, 套装信息
	m_nSuitId = equip.jobLimit
	if (m_nSuitId) then
		tbInfo.hid = tbEquip.hid -- 如果是英雄身上的装备，记录hid
		addSuitInfo(tbInfo, m_nSuitId, equip.id, tbAllUse)
	end

  	local tbBtnEvent = {}
	tbBtnEvent.onXilian = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

		    -- require "script/module/equipment/EquipFixModel"
		    -- require "script/module/equipment/EquipFixCtrl"
		    
		    if (not SwitchModel.getSwitchOpenState(ksSwitchEquipFixed,true)) then
		        return
		    end 

		    local tbEuipIds = { item_id = tbEquip.item_id, item_template_id = tbEquip.item_template_id, pos = tonumber(tbEquip.pos)}
		    
		    local isCanFix = EquipFixModel.isEuipCanFixByTid(tbEuipIds.item_template_id)

		    if(tonumber(isCanFix) ==  1) then
		    	LayerManager.removeLayout()
		    	if(m_type == m_equipFrom.CreateType.createTypeEquipList) then
		        	EquipFixCtrl.create(tbEuipIds, m_equipFrom.CreateType.createTypeEquipList)
		        elseif(m_type == m_equipFrom.CreateType.createTypeFormation) then
		        	EquipFixCtrl.create(tbEuipIds, m_equipFrom.CreateType.createTypeFormation,m_curPageNum)
		        end
		    else
		        ShowNotice.showShellInfo(m_i18n[5201])
		    end
		end
	end
	tbBtnEvent.onReinforce = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if(tonumber(m_tbEquipInfo.itemDesc.type) == 5) then -- 2015-04-16, zhangqi, 修改新的经验装备判断，子类型 type == 5
                ShowNotice.showShellInfo(m_i18n[1663])
            else
				LayerManager.removeLayout()
				-- zhangqi, 2015-06-09, 将显示装备强化的逻辑从装备背包模块移入强化模块，避免无谓的模块引用
				require "script/module/equipment/EquipStrengModel"
				local layout = EquipStrengModel.create(tbEquip, nil, m_type)
				LayerManager.addLayoutNoScale(layout, LayerManager.getModuleRootLayout())
				PlayerPanel.addForPartnerStrength()
	 		end
		end
	end

    local equipFragId 
    if (tbEquip.itemDesc) then
    	equipFragId = tbEquip.itemDesc.fragmentId
    else
    	local equipData = DB_Item_arm.getDataById(tonumber(tbEquip.item_template_id))
    	equipFragId = equipData.fragmentId
    end
    --logger:debug({tbEquip=tbEquip})
    --logger:debug({equipFragId=equipFragId})
    

	if (equipFragId)  then
	    tbInfo.onFindDrop = function ( sender, eventType )
	        if (eventType == TOUCH_EVENT_ENDED) then
	            AudioHelper.playCommonEffect()
	            require "script/module/public/FragmentDrop"
	            --logger:debug({tbEquip=tbEquip})

	            local equipFragDb = DB_Item_fragment.getDataById(equipFragId)
	            local tArgs={selectEquip = equipFragDb}
	            equipFragDb.tid = equipFragDb.id
	            require "script/module/equipment/MainEquipmentCtrl"
	            require "script/module/public/DropUtil"
	            local curModuleName = LayerManager.curModuleName()
            	local callFn 
	            if (not tbAllUse) then
					callFn = function ( ... )
						 MainEquipmentCtrl.resumBagCallFn(tbEquip.itemDesc.id,1)
					end
	            else
					callFn = function ( ... )
						 MainEquipmentCtrl.resumBagCallFn(tbEquip.item_template_id,0)
					end
	            end
	            -- DropUtil.insertCallFn(curModuleName,callFn)
	            require "script/module/public/FragmentDrop"
	            local fragmentDrop = FragmentDrop:new()
	            
	            local fragmentDropLayer = fragmentDrop:create(equipFragId,callFn)
	            LayerManager.addLayout(fragmentDropLayer)
	        end
	    end
	end

	return tbInfo, tbBtnEvent

end

-- 装备碎片
local function getEquipFragShowData( tbEquip) 
	local t_numerial, t_numerial_pl  = ItemUtil.getTop2NumeralByTmplID(tbEquip.itemDesc.aimItem)
	--logger:debug({tbEquip=tbEquip})
	require "db/DB_Item_arm"
	local equip = DB_Item_arm.getDataById(tbEquip.itemDesc.aimItem)

	local tbInfo = {}
	tbInfo.cardBgPath = "images/item/equipinfo/card/equip_" .. equip.quality .. ".png"
	tbInfo.name = equip.name
	tbInfo.nQuality = equip.quality
	tbInfo.armPath = "images/base/equip/big/" .. equip.icon_big
	tbInfo.sScore = tostring(equip.base_score)
	tbInfo.nSubType = equip.type -- 2015-04-17, 装备子类型

	local level = 0
	local nextLv = equip.level_limit_ratio * UserModel.getHeroLevel()
	tbInfo.sLv = level .. "/" .. nextLv

	tbInfo.bCanEnhant = equip.canEnchant == 1 -- 可以附魔
	tbInfo.sCurEnhanceLv = "(+0)"
	tbInfo.sEnhanceLv = "0/" .. equip.maxEnchantLV
	tbInfo.nEnhanceLv = 0
	local equipData = {}
	table.hcopy(equip, equipData)
	equipData.va_item_text = {armReinforceLevel = 0}
	equipData.item_template_id = equipData.id

	-- local _, _, _, _, enchantAttr = ItemUtil.getEquipNumerialByIID(-1, equipData)
	if (tbInfo.bCanEnhant) then
		alignEnchantData(tbInfo, equip) -- zhangqi, 2015-12-26
		alignEnchantAbility(tbInfo, equip) -- zhangqi, 2016-01-20
	end

	alignData(tbInfo,t_numerial,t_numerial_pl)
	tbInfo.sDesc = equip.info

	-- zhangqi, 2014-07-14, 套装信息
	m_nSuitId = equip.jobLimit
	if (m_nSuitId) then
		tbInfo.hid = tbEquip.hid -- 如果是英雄身上的装备，记录hid
		addSuitInfo(tbInfo, m_nSuitId, equip.id)
	end

    tbInfo.onFindDrop = function ( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()
            require "script/module/equipment/MainEquipDropCtrl"

            local tbEquiptInfo = MainEquipmentCtrl.getArmFragDataByValue(tbEquip)
            local tArgs={selectEquip = tbEquiptInfo}
            --logger:debug({tbEquiptInfo=tbEquiptInfo})

            require "script/module/public/DropUtil"
        	require "script/module/equipment/MainEquipmentCtrl"
  			local callFn = function ( ... )
				MainEquipmentCtrl.resumBagCallFn(tbEquiptInfo.tid,2)
			end
			local curModuleName = LayerManager.curModuleName()
    		-- DropUtil.insertCallFn(curModuleName,callFn)

            require "script/module/public/FragmentDrop"
        	local fragmentDrop = FragmentDrop:new()
            
        	local fragmentDropLayer = fragmentDrop:create(tbEquiptInfo.tid,callFn)
        	LayerManager.addLayout(fragmentDropLayer)
        end
    end


	return tbInfo
end
--- shop 中装备信息
local function getEquipShopShowData( tbEquip) 
	local t_numerial, t_numerial_pl  = ItemUtil.getTop2NumeralByTmplID(tbEquip.id)
	local equip = tbEquip
	if (not equip.type) then
		equip = DB_Item_arm.getDataById(tbEquip.id)
	end

	local tbInfo = {}
	tbInfo.cardBgPath = "images/item/equipinfo/card/equip_" .. tbEquip.quality .. ".png"
	tbInfo.name = tbEquip.name
	tbInfo.nQuality = tbEquip.quality
	tbInfo.armPath = "images/base/equip/big/" .. tbEquip.icon_big
	tbInfo.sScore = tostring(tbEquip.base_score)
	tbInfo.nSubType = equip.type
	
	local level = 0
	local nextLv = tbEquip.level_limit_ratio * UserModel.getHeroLevel()
	tbInfo.sLv = level .. "/" .. nextLv

	alignData(tbInfo,t_numerial,t_numerial_pl)
	tbInfo.sDesc = tbEquip.desc

	-- zhangqi, 2015-04-22, 只读配置的装备信息附魔属性都为0
	tbInfo.bCanEnhant = tbEquip.canEnchant == 1 -- 可以附魔
	tbInfo.sCurEnhanceLv = "(+0)"
	tbInfo.sEnhanceLv = "0/" .. tbEquip.maxEnchantLV
	tbInfo.nEnhanceLv = 0
	local equipData = {}
	table.hcopy(tbEquip, equipData)
	equipData.va_item_text = {armReinforceLevel = 0}
	equipData.item_template_id = equipData.id

	-- local _, _, _, _, enchantAttr = ItemUtil.getEquipNumerialByIID(-1, equipData)
	if (tbInfo.bCanEnhant) then
		alignEnchantData(tbInfo, equip) -- zhangqi, 2015-12-26
		alignEnchantAbility(tbInfo, equip) -- zhangqi, 2016-01-20
	end

	-- zhangqi, 2014-07-14, 套装信息
	m_nSuitId = tbEquip.jobLimit
	if (m_nSuitId) then
		tbInfo.hid = tbEquip.hid -- 如果是英雄身上的装备，记录hid
		addSuitInfo(tbInfo, m_nSuitId, tbEquip.id)
	end

	if (tonumber(equip.type) == 5) then -- 如果是经验装备 add by yangna
        tbInfo.sMagicExp = tostring(tbEquip.baseEnchantExp)
    end

	return tbInfo
end


-- 装备碎片在商店中显示
local function getEquipFragShopShowData( tbEquip) 
	local t_numerial, t_numerial_pl  = ItemUtil.getTop2NumeralByTmplID(tbEquip.aimItem)

	require "db/DB_Item_arm"
	local equip = DB_Item_arm.getDataById(tbEquip.aimItem)

	local tbInfo = {}
	tbInfo.cardBgPath = "images/item/equipinfo/card/equip_" .. equip.quality .. ".png"
	tbInfo.name = equip.name
	tbInfo.nQuality = equip.quality
	tbInfo.sScore   = tostring(equip.base_score) -- zhangqi, 2014-07-24, 星级改品级
	tbInfo.armPath = "images/base/equip/big/" .. equip.icon_big
	tbInfo.sScore = tostring(equip.base_score)
	tbInfo.nSubType = equip.type
	
	local level = 0
	local nextLv = equip.level_limit_ratio * UserModel.getHeroLevel()
	tbInfo.sLv = level .. "/" .. nextLv

	alignData(tbInfo,t_numerial,t_numerial_pl)
	tbInfo.sDesc = equip.info

	-- zhangqi, 2015-04-22, 只读配置的装备信息附魔属性都为0
	tbInfo.bCanEnhant = equip.canEnchant == 1 -- 可以附魔
	tbInfo.sCurEnhanceLv = "(+0)"
	tbInfo.sEnhanceLv = "0/" .. equip.maxEnchantLV
	tbInfo.nEnhanceLv = 0
	local equipData = {}
	table.hcopy(equip, equipData)
	equipData.va_item_text = {armReinforceLevel = 0}
	equipData.item_template_id = equipData.id

	-- local _, _, _, _, enchantAttr = ItemUtil.getEquipNumerialByIID(-1, equipData)
	if (tbInfo.bCanEnhant) then
		alignEnchantData(tbInfo, equip) -- zhangqi, 2015-12-26
		alignEnchantAbility(tbInfo, equip) -- zhangqi, 2016-01-20
	end

	-- zhangqi, 2014-07-14, 套装信息
	m_nSuitId = equip.jobLimit
	if (m_nSuitId) then
		tbInfo.hid = tbEquip.hid -- 如果是英雄身上的装备，记录hid
		addSuitInfo(tbInfo, m_nSuitId, equip.id)
	end

	return tbInfo
end

-- 阵容中展示装备信息
function createForFormation( tbEquip ,n_curPageNum, isDrawTip)
	m_nSuitId = nil
	m_curPageNum = n_curPageNum
	m_tbEquip = tbEquip
	m_type = m_equipFrom.CreateType.createTypeFormation
	local tbInfo,tbBtnEvent = getEquipShowData(m_tbEquip)
	getEquiptbEvenet(tbBtnEvent, tbEquip)
	
	showEquipInfo(m_equipFrom.CreateType.createTypeFormation, tbInfo, tbBtnEvent, isDrawTip)
end

-- 查看他人阵容中展示装备信息，tbAllUse是一个人物已穿戴的所有装备信息
function createForOtherFormation( tbEquip, tbAllUse, nlevel)
	m_nSuitId = nil

	m_tbEquip = tbEquip
	m_type = m_equipFrom.CreateType.createTypeOtherFormation
	local tbInfo,tbBtnEvent = getEquipShowData(m_tbEquip, tbAllUse, nlevel)
	tbBtnEvent.onReinforce = nil -- 2015-04-20, zhangqi, 将强化和附魔按钮事件置nil，保证UI上不显示按钮
	tbBtnEvent.onXilian = nil
	getEquiptbEvenet(tbBtnEvent, m_tbEquip)
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onFindDrop = tbInfo.onFindDrop

	showEquipInfo(m_equipFrom.CreateType.createTypeSellEquip, tbInfo, tbBtnEvent)
end


-- 装备列表中展示装备信息
function createForEquip( tbEquip )
	m_nSuitId = nil
	m_type = m_equipFrom.CreateType.createTypeEquipList

	local tbInfo,tbBtnEvent = getEquipShowData(tbEquip)
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onFindDrop = tbInfo.onFindDrop
	--logger:debug({tbBtnEvent=tbBtnEvent})
	showEquipInfo(m_equipFrom.CreateType.createTypeEquipList, tbInfo, tbBtnEvent)
end

-- 装备碎片列表中展示装备信息
function createForEquipFrag( tbEquip )
	m_nSuitId = nil

	m_type = m_equipFrom.CreateType.createTypeEquipFragList
	local tbInfo = getEquipFragShowData(tbEquip)
	local tbBtnEvent = {}
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onReinforce = nil -- 2015-04-20, zhangqi, 将强化和附魔按钮事件置nil，保证UI上不显示按钮
	tbBtnEvent.onXilian = nil
	tbBtnEvent.onFindDrop = tbInfo.onFindDrop

	showEquipInfo(m_equipFrom.CreateType.createTypeEquipFragList, tbInfo, tbBtnEvent)
end


-- 装备出售列表中展示装备信息
function createForSellEquip( tbEquip )
	m_nSuitId = nil
	m_type = m_equipFrom.CreateType.createTypeSellEquip

	local tbInfo,tbBtnEvent = getEquipShowData(tbEquip)
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onReinforce = nil -- 2015-04-20, zhangqi, 将强化和附魔按钮事件置nil，保证UI上不显示按钮
	tbBtnEvent.onXilian = nil

	showEquipInfo(m_equipFrom.CreateType.createTypeSellEquip, tbInfo, tbBtnEvent)
end
-- 装备 出售界面
function createSellEquipFrag( tbEquip )
	m_nSuitId = nil
	m_type = m_equipFrom.CreateType.createTypeSellEquipFrag
	local tbInfo = getEquipFragShowData(tbEquip)
	local tbBtnEvent = {}
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onReinforce = nil -- 2015-04-20, zhangqi, 将强化和附魔按钮事件置nil，保证UI上不显示按钮
	tbBtnEvent.onXilian = nil

	showEquipInfo(m_equipFrom.CreateType.createTypeSellEquipFrag, tbInfo, tbBtnEvent)
end

-- shop中展示装备信息
function createForShopEquip( tbEquip )
	m_nSuitId = nil
	m_type = m_equipFrom.CreateType.createTypeSellEquip

	local tbInfo = getEquipShopShowData(tbEquip)
	local tbBtnEvent = {}
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onReinforce = nil -- 2015-04-20, zhangqi, 将强化和附魔按钮事件置nil，保证UI上不显示按钮
	tbBtnEvent.onXilian = nil

	showEquipInfo(m_equipFrom.CreateType.createTypeSellEquipFrag, tbInfo, tbBtnEvent)
end

-- shop中展示装备信息
function createForShopFragEquip( tbEquip )
	m_nSuitId = nil
	m_type = m_equipFrom.CreateType.createTypeSellEquip

	local tbInfo = getEquipFragShopShowData(tbEquip)
	local tbBtnEvent = {}
	tbBtnEvent.onBack = eventBack
	tbBtnEvent.onReinforce = nil -- 2015-04-20, zhangqi, 将强化和附魔按钮事件置nil，保证UI上不显示按钮
	tbBtnEvent.onXilian = nil

	--logger:debug({createForShopFragEquip = tbInfo})

	showEquipInfo(m_equipFrom.CreateType.createTypeSellEquip, tbInfo, tbBtnEvent)
end


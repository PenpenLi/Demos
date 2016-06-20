-- FileName: EquipFixCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-12-08
-- Purpose: 装备附魔 ctrl
--[[TODO List]]

module("EquipFixCtrl", package.seeall)
require "script/module/equipment/EquipFixView"
require "script/module/equipment/MainEquipmentCtrl"
-- UI控件引用变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbEquipInfo = {}
local nBellyReturn  = 0   --附魔材料返还的贝里
local m_i18n = gi18n
local m_i18nString = gi18nString
local bEnchanted 	= false --保存是否附魔过装备，在离开装备强化界面是来判断是否要刷新装备背包的数据
-- 模块局部变量 --
local ccs = g_equipStrengthFrom -- zhangqi, 2015-06-19

local TagLight 			= 11111
local TagCancleBtn 		= 111112

local tBefore = {}
local tAfter = {}

local function init(...)

end

function destroy(...)
	package.loaded["EquipFixCtrl"] = nil
end

function moduleName()
    return "EquipFixCtrl"
end


function getTBBeFore( ... )
	return tBefore
end

function getTBAfter( ... )
	return tAfter
end
--背包的推送之后更新本界面的数据
function enchantFromBagDeleget( ... )
 --    --重置数据
 	TimeUtil.timeStart("enchantFromBagDeleget")
 	EquipFixView.addEnchantAnimation()
	resetData()
	-- --刷新ui
	EquipFixView.initUI()
	TimeUtil.timeEnd("enchantFromBagDeleget")
end


function doCallbackEnchantforce( cbFlag, dictData, bRet)
	logger:debug(bRet)
	if (bRet) then
		-- EquipFixView.addEnchantAnimation()
--更新本地数据
		TimeUtil.timeStart("addEnchantAnimation")
		local isFreeEquip = DataCache.setArmEnchantLevelBy(dictData.ret.item_id, dictData.ret.va_item_text.armEnchantLevel)
		if(isFreeEquip)then
			DataCache.setArmEnchantExpBy(dictData.ret.item_id, dictData.ret.va_item_text.armEnchantExp)
		else
			local hid  = ItemUtil.getEquipInfoFromHeroByItemId(tonumber(dictData.ret.item_id)).hid

			local HtBefore = HeroModel.getHeroByHid(hid)
			tBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(HtBefore)

			HeroModel.setHeroEquipEnchanteLevelBy(hid, dictData.ret.item_id, tonumber( dictData.ret.va_item_text.armEnchantLevel) )
			HeroModel.setHeroEquipEnchantExplBy(hid, dictData.ret.item_id, tonumber(dictData.ret.va_item_text.armEnchantExp) )
			
			local scene = CCDirector:sharedDirector():getRunningScene()
			UserModel.setInfoChanged(true) -- zhangqi, 2014-12-13, 阵上伙伴的装备强化成功后标记需要刷新战斗力
			UserModel.updateFightValue({[hid] = {HeroFightUtil.FORCEVALUEPART.ARM, HeroFightUtil.FORCEVALUEPART.MASTER},})

			local HtAfter = HeroModel.getHeroByHid(hid)
			tAfter = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(HtAfter)

		end
		
		-- EquipFixView.addEnchantAnimation()
		TimeUtil.timeEnd("addEnchantAnimation")
		updateInfoBar() -- 新信息条统一刷新方法

		--刷新外部的的装备信息
		bEnchanted = true
	end
end

function resetData( ... )
	EquipFixModel.init()
	EquipFixModel.setEuipInfo(m_tbEquipInfo)
		
	EquipFixModel.updataFixStuffData()
	
	-- EquipFixModel.getAllQuipInfoForFix()
end

--判断附魔的条件是否满足
local function isEnchantConditionOK()
	local isRet = true 
	local maxEnchantLv = EquipFixModel.getMaxEnchatLevel()
	local cureEnchantLv = EquipFixModel.getEquipEnchatLevel()
	if(cureEnchantLv >= maxEnchantLv) then
		ShowNotice.showShellInfo(m_i18n[5212])
		isRet = false
	end

	--判断附魔类型
	local enchantType = EquipFixModel.getEnchatType()
	local nUserBelly = UserModel.getSilverNumber()
	local nUserGold = UserModel.getGoldNumber()

	if (enchantType == EquipFixModel.E_Belly_Type) then
		local tbSelected = EquipFixModel.getSelectedItemInfo()
		if (#tbSelected <= 0) then
			ShowNotice.showShellInfo(m_i18n[5211])    				-- [5211] = "您还没有选中任何附魔材料",
			isRet = false  
		end

		local bellyCost  = EquipFixModel.getEnchantBellyNum()
		if (bellyCost > nUserBelly) then
			ShowNotice.showShellInfo(m_i18n[5213]) 					-- [5213] = "您的贝里不足，无法附魔" [5214] = "您的金币不足，无法附魔",
			isRet = false  
		end
	elseif(enchantType == EquipFixModel.E_Gold_Type) then
		local goldCost  = EquipFixModel.getEnchantGoldNum()
		if (goldCost > nUserGold) then
			-- ShowNotice.showShellInfo(m_i18n[5214])
			local noGoldAlert = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(noGoldAlert)
			isRet = false  
		end
	end

	return isRet
end 

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function confirmCallBack(bRemoveLayOut)	
	local params = CCArray:create()
	--附魔装备的i_id
	local item_id = CCInteger:create(tonumber(m_tbEquipInfo.item_id))
	params:addObject(item_id)
	--材料的i_id
	local itemIds = CCArray:create()

	local tbSelected = EquipFixModel.getSelectedItemInfo() or {}
	for i = 1,#tbSelected  do
		itemIds:addObject(CCInteger:create(tbSelected[i].item_id))
	end

	params:addObject(itemIds)
	--金币附魔还是贝里附魔
	local enchantType = EquipFixModel.getEnchatType()
	params:addObject(CCInteger:create(enchantType))

	PreRequest.setBagDataChangedDelete(enchantFromBagDeleget)
	LayerManager:addUILoading()
	RequestCenter.forge_enchant( doCallbackEnchantforce , params)

	if(bRemoveLayOut) then
		LayerManager:removeLayout()
	end
end

--取消附魔
local function onCancleEchant( sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager:begainRemoveUILoading()
		LayerManager:removeLayout()
	end 
end

local function enchantLogic()
	logger:debug(nBellyReturn)
	nBellyReturn = 0

	local bCanEnchant = isEnchantConditionOK()
	logger:debug("是否可以附魔%s" , bCanEnchant)
	if (bCanEnchant == true) then
		LayerManager:addUILoading()

		local tbForced ,_nBellyReturn = EquipFixModel.getForcedEquipFromStuff()
		if(#tbForced > 0) then

			nBellyReturn = _nBellyReturn

			logger:debug(nBellyReturn)
			local tbRich = {}
			local tbTip = {}
			table.insert(tbTip, m_i18n[5226])
			local titleColor =   ccc3(0x8a,0x37,0x00)
			table.insert(tbRich,{color = titleColor})

			local name  = ""
			local nQuilty = 3
			local tbEqiup = {}
			for i,v in ipairs(tbForced) do
				table.insert(tbTip, v.name .. ",")
				logger:debug(v.nQuality)
				table.insert(tbRich,{color = g_QulityColor[v.nQuality]})
			end

			table.insert(tbTip,m_i18n[5215])
			table.insert(tbRich,{color = titleColor})			

			local str = UIHelper.concatString(tbTip)
			local richTextInfo = {str,tbRich}

			local layout  = Layout:create()
			layout:setSize(CCSizeMake(460,0))

			local richText = BTRichText.create(richTextInfo, nil, 5)
			richText:setSize(CCSizeMake(380,0))
			richText:setAnchorPoint(ccp(0.5,1.0))
			richText:setPositionX(230)
			richText:setAlignCenter(true)
			layout:addChild(richText)
			richText:visit()

			local textHeight = richText:getTextHeight()
			if(EquipFixModel.m_nExpOverflow > 0 ) then
				textHeight = textHeight + 90 + 10

				local tips = m_i18n[5216] .. tostring(EquipFixModel.m_nExpOverflow) .. m_i18n[5217]
				local expLabel = UIHelper.createUILabel(tips, g_FontInfo.name, 22, titleColor)
				expLabel:ignoreContentAdaptWithSize(false)
				expLabel:setSize(CCSizeMake(380,90))
				layout:addChild(expLabel)
				expLabel:setPositionX(230)
				expLabel:setAnchorPoint(ccp(0.5,0.0))
				expLabel:setPosition(ccp(230,0))
			end

			richText:setPositionY(textHeight )
			layout:setSize(CCSizeMake(460,textHeight))

			local dlg  = UIHelper.createCommonDlg(nil, layout, 
									function ( sender, eventType)
											if (eventType == TOUCH_EVENT_ENDED) then
												confirmCallBack(true)
											end
										
									end,
									2,onCancleEchant)
			LayerManager.addLayout(dlg)
			UIHelper.updateCommonDlgSize(dlg,textHeight)

		else
			confirmCallBack(false)
		end
	else
		logger:debug("不满足附魔的条件")
	end
end
local _scrType = nil
-- 更新装备背包数据
local function updateEquipBag( ... ) 

	if (_scrType == ccs.CreateType.createTypeFormation) then
		if (bEnchanted) then
			require "script/module/formation/MainFormation"               
		    local pos = tonumber(m_tbEquipInfo.pos) or 1   
		    logger:debug(m_tbEquipInfo.pos)                 
		    MainFormation.updateHeroEquipment(pos)                        
		    MainFormation.rememberQuality() --记录属性值, 需要修改属性值
		end
	else
		local delNum = nil
		if (_scrType == ccs.CreateType.createTypeEquipList) then
			delNum = 1
		end

		logger:debug({updateEquipBag_delNum = delNum})

		if (bEnchanted) then
			require "script/module/equipment/MainEquipmentCtrl"
	   		MainEquipmentCtrl.refreshArmAndArmFragList(delNum)
		end
	end

	bEnchanted = false
end

--[[desc:功能简介
    arg1: equipInfo装备属性，srctype 
    return: 是否有返回值，返回值说明  
—]]
function create(equipInfo,scrType,heroPage,callBack)
	_scrType = scrType
	m_tbEquipInfo = equipInfo
	local m_overCallBack = callBack

	resetData()

	local tbBtnEvent = {}
	-- 去其他界面返回重建方法
	tbBtnEvent.reBuildModule = function ( ... )
		require "script/module/public/DropUtil"
		DropUtil.setRebuildModuleFn(function ( ... )
			create(equipInfo,scrType,heroPage,callBack)
		end)
	end

	-- 按钮返回
	tbBtnEvent.onBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
     		TimeUtil.timeStart("EquipFixView.onBack")
			
			if(scrType == ccs.CreateType.createTypeFormation) then
				PlayerPanel.removeCurrentPanel()	
			end

			if (m_overCallBack and type(m_overCallBack) == "function") then
				-- LayerManager.resetPaomadeng() -- zhangqi, 2015-06-26, 先恢复跑马灯的层级再关闭，否则会报错
				m_overCallBack()
				return
			end
			LayerManager.removeLayout()
		end
	end

	local viewEquipFix =  EquipFixView.create(equipInfo,tbBtnEvent)

    UIHelper.registExitAndEnterCall(viewEquipFix, function ( ... )
    	EquipFixView.destroy() -- zhangqi, 2015-06-24
    	EquipFixView.stopAllActions()
    	UIHelper.removeArmatureFileCache()
		LayerManager.resetPaomadeng()
    	-- LayerManager.resetPaomadeng()
        if (bEnchanted) then
        	updateEquipBag()
            bEnchanted = false
        end
    end)

 	LayerManager.addLayoutNoScale(viewEquipFix, LayerManager.getModuleRootLayout())
 	PlayerPanel.removeCurrentPanel()
 	PlayerPanel.addForPartnerStrength()
 	LayerManager.setPaomadeng(viewEquipFix, 10) -- zhangqi, 2015-06-26, 显示跑马灯
end


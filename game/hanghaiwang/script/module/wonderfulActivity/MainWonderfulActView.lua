-- FileName: MainWonderFulActView.lua
-- Author: huxiaozhou
-- Date: 2014-05-19
-- Purpose: function description of module
--[[TODO List]]

module("MainWonderfulActView", package.seeall)
require "script/module/wonderfulActivity/WonderfulActModel"



tbBtn = {}
local m_selectedBtn
local m_imgHL
local m_imgHLPath = "images/wonderfullAct/activity_light.png"
local m_imgBtn = "images/wonderfullAct/activity_frame.png"
-- UI控件引用变量 --

-- 模块局部变量 --
local json = "ui/mystery_list.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_mainWidget 
local m_tbEvent -- 按钮事件
local LSV_LIST 

local sPath = "images/wonderfullAct/"

local tbBtnImg = {
	["supply"] = {["imgN"] = "activity_coke.png", ["name"] = "activity_coke_name.png"}, -- 吃烧鸡

	["castle"] = {["imgN"] = "activity_mystery.png", ["name"] = "activity_mystery_name.png"},  -- 神秘商店

	["buyBox"] = {["imgN"] = "activity_box.png", ["name"] = "activity_box_name.png"},  -- 购买宝箱

	["buyMoney"] = {["imgN"] = "activity_belly.png", ["name"] = "activity_belly_name.png"},  -- 购买贝里

	["registration"] = {["imgN"] = "sign_day_n.png", ["name"] = "activity_sign_name.png"},  -- 签到

	["levelReward"] = {["imgN"] = "activity_level.png", ["name"] = "activity_level_name.png"},  -- 等级礼包

	["accReward"] = {["imgN"] = "btn_open_server_n.png", ["name"] = "activity_server_name.png"},  -- 开服礼包

	["growthfund"] = {["imgN"] = "activity_fund.png", ["name"] = "activity_fund_name.png"},  -- 成长基金

	["shareReward"] = {["imgN"] = "activity_share.png", ["name"] = "activity_share_name.png"},  -- 分享有礼

	["spendAccumulate"] = {["imgN"] = "activity_spending.png", ["name"] = "activity_spending_name.png"},  -- 消费累积

	["rechargeBack"] = {["imgN"] = "activity_recharge.png", ["name"] = "activity_recharge_name.png"},  -- 充值回馈

	["vipcard"] = {["imgN"] = "activity_vip_card.png", ["name"] = "activity_vip_card_name.png"},  -- 月卡

	["firstGift"] = {["imgN"] = "activity_first_recharge.png", ["name"] = "activity_first_recharge_name.png"},  -- 首充

	["vipGift"] = {["imgN"] = "activity_vip.png", ["name"] = "activity_vip_name.png"},  -- vip礼包

	["roulette"] = {["imgN"] = "activity_wheel.png", ["name"] = "activity_wheel_name.png"}, -- 幸运轮盘

	["saleBox"] = {["imgN"] = "activity_salebox.png", ["name"] = "activity_salebox_name.png"},  -- 限时宝箱

	["rechargeBonus"] = {["imgN"] = "activity_hongli.png", ["name"] = "activity_hongli_name.png"},  -- 充值红利

	["challengeWelfare"] = {["imgN"] = "activity_hongli.png", ["name"] = "activity_hongli_name.png"},  -- 挑战福利
	["discountEquip"] = {["imgN"] = "icon_equipment.png", ["name"] = "sale_equipment.png"},  		-- 装备打折
	["discountConch"] = {["imgN"] = "icon_saleconch.png", ["name"] = "sale_conch.png"},  			-- 空岛贝打折
	["discountTreas"] = {["imgN"] = "icon_treasure.png",  ["name"] = "sale_treasure.png"},  		-- 饰品打折
	["discountExcl"]  = {["imgN"] = "icon_exclusive.png", ["name"] = "sale_exclusive.png"},  		-- 宝物打折
	["discountProps"]  = {["imgN"] = "icon_property.png", ["name"] = "sale_property.png"},  		-- 道具打折

	["accLogin"] = {["imgN"] = "activity_hongli.png", ["name"] = "activity_hongli_name.png"},  -- 累计登录

	["staWelShop"] = {["imgN"] = StaticWelfareShopCtrl.getWelActIcon(), ["name"] = StaticWelfareShopCtrl.getWelActNamePic()},

	["dynWelShop"] = {["imgN"] = DynamicWelShopCtrl.getWelActIcon(), ["name"] = DynamicWelShopCtrl.getWelActNamePic()},

	["luxSign"] = {["imgN"] = "activity_sign_charge.png", ["name"] = "activity_sign_charge_name.png"},

	["limitWeal"] = {["imgN"] = "icon_timelimit_welfare.png", ["name"] = "name_timelimit_welfare.png"},
}



local function init(...)
	tbBtn = {}
	m_selectedBtn = nil
	require "script/module/wonderfulActivity/challengeWelfare/ChaWelModel"
	local chawelDb = ChaWelModel.getCurActitveDbInfo()
	if (chawelDb) then
		tbBtnImg.challengeWelfare.imgN = chawelDb.icon
		tbBtnImg.challengeWelfare.name = chawelDb.name
	end

	if (not AccLoginModel.isClosed()) then
		local dbData = AccLoginModel.getDBData()
		tbBtnImg.accLogin.imgN = dbData.icon
		tbBtnImg.accLogin.name = dbData.name
	end

	if (StaticWelfareShopCtrl.getIsActivityOn()) then
		tbBtnImg.staWelShop.imgN = StaticWelfareShopCtrl.getWelActIcon()
		tbBtnImg.staWelShop.name = StaticWelfareShopCtrl.getWelActNamePic()
	end

	if (DynamicWelShopCtrl.getIsActivityOn()) then
		tbBtnImg.dynWelShop.imgN = DynamicWelShopCtrl.getWelActIcon()
		tbBtnImg.dynWelShop.name = DynamicWelShopCtrl.getWelActNamePic()
	end

	if (LimitWelfareModel.isLimitWelfareOpen()) then
		local limitWealIcon = LimitWelfareModel.getIcons()
		tbBtnImg.limitWeal.imgN = limitWealIcon.listIcon
		tbBtnImg.limitWeal.name = limitWealIcon.listName
	end
end

function destroy(...)
	package.loaded["MainWonderfulActView"] = nil
end

function moduleName()
    return "MainWonderfulActView"
end



--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getSelectedBtnTag( )
	if m_selectedBtn then
		return m_selectedBtn:getTag()
	end
	return 1
end


--[[desc:创建页签和背景
    arg1: tbEvent 按钮事件的表
    return: 页签也和背景  
—]]

function btnSelectFunc( localBtn )
	assert(localBtn, "localBtn == nil")
	if m_selectedBtn then
		m_selectedBtn:setFocused(false)
	end
	if localBtn then
		m_selectedBtn = localBtn
		m_selectedBtn:setFocused(true)
	end
	if m_imgHL then
		m_imgHL:removeFromParentAndCleanup(false)
		m_selectedBtn:addChild(m_imgHL)
	end
end

--[[desc:更改等级礼包按钮 红点上的数字
    arg1: 
    return:   
—]]
function btnSelectChangeNum( ... )
	local IMG_TIP = WonderfulActModel.tbBtnActList["levelReward"] 
	local tfdNumber =  g_fnGetWidgetByName(IMG_TIP,"LABN_TIP_EAT")
	logger:debug(type(tfdNumber))
	if (not WonderfulActModel.tbTipVisible["levelReward"]()) then 
		IMG_TIP:setVisible(false)
	else
		tfdNumber:setStringValue(LevelRewardCtrl.getRewardNum())
	end
end

function getCellByIndex( nIdx )
	if LSV_LIST then
		return LSV_LIST:getItem(nIdx-1)
	end
end

function updateLSVPos(sValue)
	local index = 1
	local tbItem = WonderfulActModel.getActList()
	for i,v in ipairs(tbItem or {}) do
		if v == sValue then
			index = i
			break
		end
	end
	local cell = getCellByIndex(index)
	if cell then
		UIHelper.autoSetListOffset(LSV_LIST,cell)
	end
end

--创建按钮
function loadCell( )
	LSV_LIST = m_fnGetWidget(m_mainWidget, "LSV_LIST")

	logger:debug(WonderfulActModel.tbTipVisible)

	require "script/module/public/UIHelper"
	UIHelper.initListView(LSV_LIST)
	local cell, nIdx

	logger:debug(WonderfulActModel.getActList())

	for i,iconIndex in ipairs(WonderfulActModel.getActList()) do
		logger:debug(iconIndex)
		LSV_LIST:pushBackDefaultItem()	
		nIdx = i - 1
    	cell = LSV_LIST:getItem(nIdx)  -- cell 索引从 0 开始
    	local btnIcon = Button:create()
    	btnIcon:setTag(i)
    	cell:addChild(btnIcon)
		btnIcon:setPosition(ccp(cell:getSize().width*.5,cell:getSize().height*.6))

		btnIcon:loadTextureNormal(m_imgBtn)
		btnIcon:loadTexturePressed(m_imgBtn)
		local imgBtn = ImageView:create()
		imgBtn:loadTexture("images/wonderfullAct/activity_frame_bg.png")
		btnIcon:addChild(imgBtn)
		btnIcon:addTouchEventListener(m_tbEvent[iconIndex])

		local icon = ImageView:create()
		icon:loadTexture(sPath .. tbBtnImg[iconIndex].imgN)
		btnIcon:addChild(icon)
		tbBtn[iconIndex] = btnIcon
		local imageName = m_fnGetWidget(cell, "IMG_NAME")
		imageName:loadTexture(sPath .. tbBtnImg[iconIndex].name)
		local IMG_TIP = m_fnGetWidget(cell,"IMG_TIP") -- 小红点
		local tfdNumber =  m_fnGetWidget(IMG_TIP,"LABN_TIP_EAT")
		if (iconIndex == "castle") then
			tfdNumber:setStringValue(MysteryCastleData.getFreeTimes())
		elseif(iconIndex == "supply" ) then
			tfdNumber:setStringValue("1")
			UIHelper.registExitAndEnterCall(tfdNumber, function ( ... )
				GlobalScheduler.removeCallback("supplyRedPoint")
			end, function ( ... )
				GlobalScheduler.addCallback("supplyRedPoint",function (  )
					IMG_TIP:setVisible(WonderfulActModel.tbTipVisible[iconIndex]()) 
				end)
			end)
		elseif(iconIndex == "levelReward" ) then
			logger:debug("123456789")
			tfdNumber:setStringValue(LevelRewardCtrl.getRewardNum())
		elseif(iconIndex == "registration" ) then
			tfdNumber:setStringValue("1")		
		elseif(iconIndex == "accReward" ) then
			tfdNumber:setStringValue(AccSignModel.getCanGotRewardNum())
		elseif(iconIndex == "buyMoney" ) then
			tfdNumber:setStringValue("1")
		elseif(iconIndex == "growthfund" ) then
			tfdNumber:setStringValue(GrowthFundModel.getUnprizedNumByTime() + EveryoneWelfareModel.getNumStillCanReceive())
		elseif(iconIndex == "spendAccumulate") then
			if (SpendAccumulateModel.isInTime()) then
				if (tonumber(SpendAccumulateModel.getNewAniState()) ~= 1) then
					addNewFlgToCell(cell)
					SpendAccumulateModel.setCell(cell)
					IMG_TIP:setEnabled(false)
				else
					if (SpendAccumulateModel.isSpendInfoSentRewardNil()) then
						tfdNumber:setStringValue(SpendAccumulateModel.getCanReceiveNumOnlyByGold())
					else
						tfdNumber:setStringValue(SpendAccumulateModel.getCanReceiveNumInWonderfulAct())
					end
				end
			else
				tfdNumber:setStringValue(SpendAccumulateModel.getCanReceiveNumInWonderfulAct())
			end
		elseif(iconIndex == "rechargeBack") then
			if (RechargeBackModel.isInTime()) then
				if (tonumber(RechargeBackModel.getNewAniState()) ~= 1) then
					addNewFlgToCell(cell)
					RechargeBackModel.setCell(cell)
					IMG_TIP:setEnabled(false)
				else
					if (RechargeBackModel.isRechargeBackinfoSentRewardNil()) then  -- 充过，没拉取过后端，说明进游戏时活动还没开启，但现在开启了
						tfdNumber:setStringValue(RechargeBackModel.getCanReceiveNumOnlyByGold()) -- 显示登录后充值情况下的红点数
					else    -- 充过也拉取过后端，说明早就开启了活动
						tfdNumber:setStringValue(RechargeBackModel.getCanReceiveNumInWonderfulAct())-- 获得红点数
					end
				end
			else
				tfdNumber:setStringValue(RechargeBackModel.getCanReceiveNumInWonderfulAct())
			end
		elseif(iconIndex == "vipcard" ) then
			tfdNumber:setStringValue(VipCardModel.getRedPoint())		
		elseif(iconIndex == "shareReward" ) then
			tfdNumber:setStringValue(ShareModel.getTipsCount())		
		elseif (iconIndex == "vipGift") then
			tfdNumber:setStringValue("1")
		elseif ( iconIndex == "roulette" ) then
			tfdNumber:setStringValue("1")
			RouletteModel.setIconBtn( cell , btnIcon )
			if (tonumber(RouletteModel.getNewAniState()) ~= 1) and not (RouletteModel.bShowRedPoint()) then
				IMG_TIP:setEnabled(false)
				addNewFlgToCell( cell )
			end
		elseif ( iconIndex == "saleBox" ) then
			SaleBoxModel.setIconBtn( cell, btnIcon )
			tfdNumber:setStringValue(SaleBoxModel.nGetRedPointNum())
			if (tonumber(SaleBoxModel.getNewAniState()) ~= 1) then
				IMG_TIP:setEnabled(false)
				addNewFlgToCell( cell )
			end
		elseif(iconIndex == "rechargeBonus" ) then  
			local numRedPoint = RechargeBonusModel.numRedPoint()
			tfdNumber:setStringValue(numRedPoint)
			if (tonumber(numRedPoint)~=0) then
				IMG_TIP:setEnabled(true)
			elseif (tonumber(RechargeBonusModel.getNewAniState()) ~= 1) then
				addNewFlgToCell(cell)
				RechargeBonusModel.setCell(cell)
				IMG_TIP:setEnabled(false)
			else
				IMG_TIP:setEnabled(false)
			end
		elseif(iconIndex == "challengeWelfare" ) then 
			 tfdNumber:setStringValue(ChaWelModel.getRedTipStatus())
			 ChaWelModel.setCell( cell )
			 logger:debug("enter set red tip challengeWelfare")
			 if (tonumber(ChaWelModel.getNewAniState()) ~= 1 and ChaWelModel.getRedTipStatus()<=0) then
				addNewFlgToCell( cell )
			 end
		elseif(iconIndex == "accLogin" ) then
			if (tonumber(AccLoginModel.getNewAniState()) ~= 1) then
				addNewFlgToCell(cell)
				AccLoginModel.setCell(cell)
			end
			tfdNumber:setStringValue(AccLoginModel.getTipCount())
		elseif(iconIndex == "discountProps" or iconIndex == "discountExcl" or iconIndex == "discountTreas" or iconIndex == "discountEquip" or iconIndex == "discountConch") then
			local _name = DiscountData.tbWonderfullName[iconIndex]
			if (tonumber(DiscountData.getDiscountNewAniState(_name)) ~= 1) then
				logger:debug(cell)
				addNewFlgToCell(cell)
				DiscountData.setCellByname(_name,cell)
			end
		elseif(iconIndex == "staWelShop" ) then
			if ( StaticWelfareShopCtrl.getIsActivityOn() ) then
				StaticWelfareShopCtrl.setIconActAndName(icon,imageName)
				if (tonumber(StaticWelfareShopCtrl.getNewAniState()) ~= 1) then
					addNewFlgToCell(cell)
					StaticWelfareShopCtrl.setCell(cell)
				end
				IMG_TIP:setEnabled(false)
			else
				IMG_TIP:setEnabled(false)
			end
		elseif(iconIndex == "dynWelShop") then
			if ( DynamicWelShopCtrl.getIsActivityOn() ) then
				DynamicWelShopCtrl.setIconActAndName(icon,imageName)
				if (tonumber(DynamicWelShopCtrl.getNewAniState()) ~= 1) then
					addNewFlgToCell(cell)
					DynamicWelShopCtrl.setCell(cell)
				end
				IMG_TIP:setEnabled(false)
			else
				IMG_TIP:setEnabled(false)
			end
		elseif (iconIndex == "luxSign") then
			-- 如果有未领取，则显示红点
			-- 如果没有红点，且刚登录，则显示new，注意要IMG_TIP:setEnabled(false)
			local numCanBuy = LuxurySignModel.getCanGetNum()
			if (not LuxurySignModel.isLevelEnough()) then
				IMG_TIP:setEnabled(false)
			elseif ( numCanBuy~=0 ) then
				tfdNumber:setStringValue(numCanBuy)
			elseif (not LuxurySignModel.isLoginLuxurySign()) then
				addNewFlgToCell(cell)
				LuxurySignModel.setCell(cell)
				IMG_TIP:setEnabled(false)
			else
				IMG_TIP:setEnabled(false)
			end	
		elseif (iconIndex == "firstGift") then
			tfdNumber:setStringValue(FirstGiftData.getRedNum())
		elseif (iconIndex == "limitWeal") then
			if (LimitWelfareModel.isLimitWelfareOpen()) then
				LimitWelfareModel.setIconActAndName(icon,imageName)
				if (tonumber(LimitWelfareModel.getNewAniState()) ~= 1) then
					addNewFlgToCell(cell)
					LimitWelfareModel.setCell(cell)
				end
				IMG_TIP:setEnabled(false)
			else
				IMG_TIP:setEnabled(false)
			end
		end

		assert(WonderfulActModel.tbTipVisible[iconIndex]() ~= nil and type(WonderfulActModel.tbTipVisible[iconIndex]()) == "boolean", "iconIndex = " .. iconIndex)

		IMG_TIP:setVisible(WonderfulActModel.tbTipVisible[iconIndex]() or false) 
		WonderfulActModel.tbBtnActList[iconIndex] = IMG_TIP
	end
	logger:debug(WonderfulActModel.tbBtnActList)
end

--[[desc:添加new特效 added by xufei 2015-7-14
    arg1: 
    return: 无
—]]
function addNewFlgToCell( layNew )
	local newFlag = UIHelper.createArmatureNode({
		filePath = "images/effect/newhero/new.ExportJson",
		animationName = "new",
	})
	newFlag:setAnchorPoint(ccp(0.5,0.5))
	layNew:addNode(newFlag)
	newFlag:setTag(100)
	local szlayNew = layNew:getSize()
	newFlag:setPosition(ccp(szlayNew.width / 2 , szlayNew.height))
end

function create(tbEvent)
	m_tbEvent = tbEvent
	init()
	m_mainWidget = g_fnLoadUI(json)
	loadCell()
	m_mainWidget:setSize(g_winSize)
	
	m_imgHL = ImageView:create()
	m_imgHL:retain()
	m_imgHL:loadTexture(m_imgHLPath)

	local img_bg_top = m_fnGetWidget(m_mainWidget,"img_bg_top")
	local img_bg_bottom = m_fnGetWidget(m_mainWidget,"img_bg_bottom")

	--local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	img_bg_top:setScale(g_fScaleX)
	img_bg_bottom:setScale(g_fScaleX)
	UIHelper.registExitAndEnterCall(m_mainWidget, function (  )
		LSV_LIST = nil
		m_imgHL:release()
		m_imgHL = nil
	end)

	return m_mainWidget
end

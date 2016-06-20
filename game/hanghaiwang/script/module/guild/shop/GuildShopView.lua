-- FileName: GuildShopView.lua
-- Author: huxiaozhou
-- Date: 2015-04-03
-- Purpose: 联盟商店
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuildShopView", package.seeall)

-- UI控件引用变量 --
local m_mainWidget
local listview
local m_selectedBtn

local i18nlabTime
local labTime
local i18nDesc

local i18nlabCount
local labCount
local labContri
local _imgNorBg
local _imgLimitBg


-- 模块局部变量 --
local json = "ui/union_shop.json"

local m_fnGetWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI

local m_i18n = gi18n
local m_i18nString = gi18nString

local m_tbEvent
local m_tGoods

local tType = {spe=1, normal=2}
local curType

local function init(...)
	m_mainWidget = nil
	m_selectedBtn = nil
	listview = nil
	GuildDataModel.setIsInGuildFunc(true)
end

function destroy(...)
	init()
	package.loaded["GuildShopView"] = nil
end

function moduleName()
    return "GuildShopView"
end

local function loadUI(  )
	local btnBack = m_fnGetWidget(m_mainWidget, "BTN_BACK")
	btnBack:addTouchEventListener(m_tbEvent.fnClose)
	UIHelper.titleShadow(btnBack,m_i18n[1019])
	local imgBg = m_fnGetWidget(m_mainWidget, "IMG_BG")
	imgBg:setScale(g_fScaleX)
	local img_tab = m_mainWidget.img_tab
	img_tab:setScale(g_fScaleX)
	local i18ntfd_lvup_contribution = m_fnGetWidget(m_mainWidget, "tfd_lvup_contribution")
	i18ntfd_lvup_contribution:setText(m_i18n[3708])
	UIHelper.labelNewStroke(i18ntfd_lvup_contribution, ccc3(0x28,0x00,0x00))

	local LAY_FIT = m_fnGetWidget(m_mainWidget,"LAY_FIT")

	local TFD_CONTRIBUTION_NUM1 = m_fnGetWidget(m_mainWidget, "TFD_CONTRIBUTION_NUM1")
	local _guildInfo = GuildDataModel.getGuildInfo()


	local img_slant = m_fnGetWidget(m_mainWidget, "img_slant")

	local shopNeedExp = GuildUtil.getShopNeedExpByLv(tonumber(_guildInfo.va_info[4].level) + 1)
	local TFD_CONTRIBUTION_NUM2 = m_fnGetWidget(m_mainWidget, "TFD_CONTRIBUTION_NUM2")
	TFD_CONTRIBUTION_NUM2:setText(_guildInfo.curr_exp)
	local tfd_lvmax = m_fnGetWidget(m_mainWidget, "tfd_lvmax")

	UIHelper.labelNewStroke(TFD_CONTRIBUTION_NUM1, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(TFD_CONTRIBUTION_NUM2, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(tfd_lvmax, ccc3(0x28,0x00,0x00))

	if (tonumber(_guildInfo.va_info[4].level) >= tonumber(GuildUtil.getMaxShopLevel())) then 
		TFD_CONTRIBUTION_NUM1:setEnabled(false)
		tfd_lvmax:setEnabled(true)
	else 
		TFD_CONTRIBUTION_NUM1:setText(shopNeedExp)
		tfd_lvmax:setEnabled(false)
	end

	_imgNorBg = m_mainWidget.IMG_NORMAL_BG
	_imgLimitBg = m_mainWidget.IMG_TIME_LIMIT_BG
	_imgNorBg:setEnabled(false)
	_imgLimitBg:setEnabled(true)

	local _sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
	labContri = m_fnGetWidget(m_mainWidget, "TFD_PLAYER_CONTRIBUTION") -- 个人贡献度
	labContri:setText(_sigleGuildInfo.contri_point)
	local tfd_personal = m_fnGetWidget(m_mainWidget, "tfd_owner_contribution")
	tfd_personal:setText(m_i18n[3747])


	UIHelper.labelNewStroke(labContri, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(tfd_personal, ccc3(0x28,0x00,0x00))

	i18nlabTime = m_fnGetWidget(m_mainWidget, "TFD_COUNTDOWN_BUY")
	i18nlabTime:setText(m_i18n[3801])
	labTime = m_fnGetWidget(m_mainWidget, "TFD_COUNTDOWN_BUYTIME")
	i18nDesc = m_fnGetWidget(m_mainWidget, "TFD_COUNTDOWN_INFO") 
	i18nDesc:setText(m_i18n[3802])

	UIHelper.labelNewStroke(i18nlabTime, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(labTime, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(i18nDesc, ccc3(0x28,0x00,0x00))

	i18nlabCount = m_fnGetWidget(m_mainWidget, "TFD_COUNTDOWN_REFRESH")
	i18nlabCount:setText(m_i18n[3805])
	labCount = m_fnGetWidget(m_mainWidget, "TFD_COUNTDOWN_REFRESHTIME")

	UIHelper.labelNewStroke(i18nlabCount, ccc3(0x28,0x00,0x00))
	UIHelper.labelNewStroke(labCount, ccc3(0x28,0x00,0x00))

	local btnSpe = m_fnGetWidget(m_mainWidget, "BTN_TIME_LIMIT")
	btnSpe:setTag(1)
	local btnNorm = m_fnGetWidget(m_mainWidget, "BTN_NORMAL")
	btnNorm:setTag(2)

	btnSpe:addTouchEventListener(m_tbEvent.fnSpe)
	btnNorm:addTouchEventListener(m_tbEvent.fnNormal)

	UIHelper.titleShadow(btnSpe, m_i18n[3803])
	UIHelper.titleShadow(btnNorm, m_i18n[3804]) 
	btnSelectFunc(btnSpe)
	loadLSV()
end


function btnSelectFunc( localBtn )
	if m_selectedBtn then
		m_selectedBtn:setFocused(false)
	end
	if localBtn then
		m_selectedBtn = localBtn
		m_selectedBtn:setFocused(true)
	end
end

function getSelectedBtnTag( )
	if m_selectedBtn then
		return m_selectedBtn:getTag()
	end
	return 1
end

function initTimeLab(  )
	local convertcd = GuildUtil.isShopCD()
	if convertcd ~= false then
		labTime:setText(TimeUtil.getTimeString(convertcd))
	elseif(labTime:isEnabled()) then
		reLoadLSV()
		i18nlabTime:setEnabled(false)
		labTime:setEnabled(false)
		i18nDesc:setEnabled(false)
	end

	local cd = GuildDataModel.getShopRefreshCd()
	if cd <= 0 then
		RequestCenter.guildShop_refreshList(function (cbFlag, dictData, bRet)
			if (dictData.err ~= "ok") then
				return
			end
			GuildDataModel.setSpecialGoodsInfo(dictData.ret.special_goods,dictData.ret.refresh_cd)
			if curType == tType.spe then
				reLoadLSV()
			end
		end)
	end
	local bType = curType == tType.spe
	if bType then
		labCount:setText(TimeUtil.getTimeString(cd))
	end
	i18nlabCount:setEnabled(not bType)
	labCount:setEnabled(not bType)
	_imgNorBg:setEnabled(not bType)
	_imgLimitBg:setEnabled(bType)
end

-- 更新每个cell
local function updateCellByIdex( lsv, idx)
	TimeUtil.timeStart("updateCellByIdex")
	local tbData = m_tGoods[idx+1]
	if not tbData then
		return
	end
	local cell = lsv:getItem(idx)
	local layItem = m_fnGetWidget(cell, "LAY_ITEM")
	layItem:removeChildByTag(1, true)
	logger:debug(tbData)
	local pos = ccp(layItem:getSize().width*.5,layItem:getSize().height*.5)
	local icon, tDbItem = ItemUtil.createBtnByTemplateIdAndNumber(tbData.tid, tbData.num,function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			PublicInfoCtrl.createItemInfoViewByTid(tbData.tid, tbData.num,true)   -- 最后一个参数 设置为true 表示 进阶石，突破石 要显示成掉落
		end
	end)
	layItem:addChild(icon, 0, 1)
	icon:setPosition(pos)

	local TFD_ITEM_NAME = m_fnGetWidget(cell, "TFD_ITEM_NAME")
	TFD_ITEM_NAME:setText(tDbItem.name)

	local color =  g_QulityColor[tonumber(tDbItem.quality)]
	if(color ~= nil) then
		TFD_ITEM_NAME:setColor(color)
	end	

	local tfd_consume = m_fnGetWidget(cell, "tfd_consume") --TODO
	
	local labcostNum = m_fnGetWidget(cell, "TFD_CONSUME_NUM")
	local img_consume_contribute = m_fnGetWidget(cell, "img_consume_contribute")
	if tbData.costContribution then
		img_consume_contribute:setEnabled(true)
		labcostNum:setEnabled(true)
		labcostNum:setText(tbData.costContribution)
	else
		img_consume_contribute:setEnabled(false)
		labcostNum:setEnabled(false)
	end
	

	local labcostGoldNum = m_fnGetWidget(cell, "TFD_CONSUME_NUM_GOLD")
	local img_consume_gold = m_fnGetWidget(cell, "img_consume_gold")
	if tbData.costGold then
		img_consume_gold:setEnabled(true)
		labcostGoldNum:setEnabled(true)
		labcostGoldNum:setText(tbData.costGold)
	else
		img_consume_gold:setEnabled(false)
		labcostGoldNum:setEnabled(false)
	end
	

	local btnBuy = m_fnGetWidget(cell, "BTN_BUY")
	UIHelper.titleShadow(btnBuy, m_i18n[2203])
	btnBuy:addTouchEventListener(m_tbEvent.fnBuy)
	btnBuy:setTag(tbData.id)
	btnBuy:setGray(false)
	btnBuy:setTouchEnabled(true)
	local tfd_remain = m_fnGetWidget(cell, "tfd_remain")
	local labNum = m_fnGetWidget(cell, "TFD_REMAIN_NUM")
	local i18nGe = m_fnGetWidget(cell, "tfd_ge")  
	local lay_fit2 = m_fnGetWidget(cell, "LAY_FIT2")

	local limitType = tonumber(tbData.limitType)
--[[
		1.个人每日限制：个人今日可换xx个
		2.个人总共限制：个人总共可换xx个
		3.联盟每日限制：联盟今日还剩xx个
		4.联盟总共限制：联盟总共还剩xx个
--]]
	local tbBuy = {}
	local goodId = tbData.id
	if curType == tType.spe then
		tbBuy =  GuildDataModel.getSpecialBuyNumById(goodId)
	else
		tbBuy = GuildDataModel.getNorBuyNumById(goodId) 
	end
	

	function setLabEnable(enable)
		lay_fit2:setEnabled(enable)
	end
	setLabEnable(true)

	local shoplevel = GuildDataModel.getShopLevel()

	if limitType == 1 or limitType == 2 then
		local canBuyNum = tbData.personalLimit - tbBuy.num
		if limitType == 1 then
			tfd_remain:setText(m_i18n[3810])
		else
			tfd_remain:setText(m_i18n[3817])
		end
		labNum:setText(canBuyNum)
		i18nGe:setText(m_i18n[2621])
		if canBuyNum == 0 then
			btnBuy:setGray(true)
			btnBuy:setTouchEnabled(false)
			setLabEnable(false)
			btnBuy:setTitleText(m_i18n[3811])
		end

		if(shoplevel < tonumber(tbData.needLegionLevel)) then
			btnBuy:setGray(true)
			btnBuy:setTouchEnabled(false)
			setLabEnable(true)
			btnBuy:setTitleText(m_i18n[3812])
			tfd_remain:setText(m_i18n[3814])
			labNum:setText(tbData.needLegionLevel)
			i18nGe:setText(m_i18n[3809])
		end
	elseif limitType == 3 or limitType == 4 then

		local canBuyNum = tbData.baseNum - tbBuy.sum
		if limitType == 3 then
			tfd_remain:setText(m_i18n[3807]) 
		else
			tfd_remain:setText(m_i18n[3818])
		end
		labNum:setText(canBuyNum)
		i18nGe:setText(m_i18n[1422])

		canBuyNum = tbData.personalLimit - tbBuy.num -- 自己已经兑换完自己应该对应的次数
		if canBuyNum == 0 then
			btnBuy:setGray(true)
			btnBuy:setTouchEnabled(false)
			setLabEnable(false)
			btnBuy:setTitleText(m_i18n[3811])
		end
		canBuyNum = tbData.baseNum - tbBuy.sum -- 联盟总共剩余
		if canBuyNum == 0 then
			btnBuy:setGray(true)
			btnBuy:setTouchEnabled(false)
			setLabEnable(true)
			btnBuy:setTitleText(m_i18n[3812])
		end
		if shoplevel < tonumber(tbData.needLegionLevel) then
			btnBuy:setGray(true)
			btnBuy:setTouchEnabled(false)
			setLabEnable(true)
			btnBuy:setTitleText(m_i18n[3812])
			tfd_remain:setText(m_i18n[3814])
			labNum:setText(tbData.needLegionLevel)
			i18nGe:setText(m_i18n[3809])
		end
	else
		error("no limitType: " .. limitType)
	end

	local convertcd = GuildUtil.isShopCD()
	if convertcd ~= false then
		btnBuy:setGray(true)
		btnBuy:setTouchEnabled(false)
	end
	layItem.IMG_RECOMMAND:setEnabled(curType == tType.spe and tonumber(tbData.recommended) == 1)
	layItem.IMG_RECOMMAND:loadTexture(UIHelper.getGuildShopRecommendType())
	
	

	TimeUtil.timeEnd("updateCellByIdex")
end

-- 初始化LSV
function loadLSV( )
	if curType == tType.spe then
		m_tGoods = GuildUtil.getSpecialGoods()
	elseif curType == tType.normal then
		m_tGoods = GuildUtil.getNormalGoods()
	end
	listview = m_fnGetWidget(m_mainWidget, "LSV_MAIN")

	local cell = m_fnGetWidget(listview, "LAY_CELL")
	local bg = m_fnGetWidget(cell, "img_cell_bg")
	bg:setScale(g_fScaleX)
	cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX , cell:getSize().height * g_fScaleX))

	
	UIHelper.initListViewCell(listview)
	UIHelper.reloadListView(listview,#m_tGoods,updateCellByIdex)
end

--  重新刷新LSV
function reLoadLSV( )
	if curType == tType.spe then
		m_tGoods = GuildUtil.getSpecialGoods()
	elseif curType == tType.normal then
		m_tGoods = GuildUtil.getNormalGoods()
	end
	UIHelper.reloadListView(listview,#m_tGoods,updateCellByIdex)
end

-- 更新显示时间的lab
local function updateGuildShop(  )
	initTimeLab()
end

-- 推送购买的回调 刷新UI 别人买也会推送
local function pushGuildGoods(cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		GuildDataModel.addPushGoodsInfo(dictData.ret)
		reLoadLSV() -- 然后刷新 列表
	end
end

local function re_guild_refreshShop()
	Network.re_rpc(pushGuildGoods, "push.refreshGoods", "push.refreshGoods")
end

local function remove_guild_refreshShop(  )
	Network.remove_re_rpc("push.refreshGoods")
end

function doSchedule(  )
	UIHelper.registExitAndEnterCall(m_mainWidget, function ( )
		remove_guild_refreshShop()
		GlobalScheduler.removeCallback("updateGuildShop")
	end, function (  )
		re_guild_refreshShop()
		GlobalScheduler.addCallback("updateGuildShop", updateGuildShop) 
	end)
end

-- 重新刷新UI
function reLoadUI( nType )
	curType = nType
	reLoadLSV()
	initTimeLab()
	local _sigleGuildInfo = GuildDataModel.getMineSigleGuildInfo()
	labContri:setText(_sigleGuildInfo.contri_point)
end

function create(tbEvent)
	init()
	curType = tType.spe
	m_tbEvent = tbEvent
	m_mainWidget = m_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadUI()
	initTimeLab()
	m_mainWidget:addChild(GuildMenuCtrl.create())
	doSchedule()
	return m_mainWidget
end

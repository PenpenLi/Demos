
-- FileName: BuyPropsView.lua
-- Author: zjw
-- Date: 2014-04-00
-- Purpose: 购买道具和兑换声望的界面
--[[TODO List]]

module("BuyPropsView", package.seeall)
require "script/module/shop/ShopUtil"
require "db/DB_Goods"
-- 模块局部变量 --
local m_tbData                   = nil
local m_goodsData                = nil
local m_nTotlePrice              = nil
local m_nCurNumber               = 1
local m_maxLimitNum              = 9999
local m_nAddOneTag               = 10000    --+1按钮的tag
local m_nAddTenTag               = 10001    --+10按钮的tag
local m_nReduceOneTag            = 10002    -- -1的按钮tag
local m_nReducetenTag            = 10003    -- -10按钮的tag
local m_gColor 					 = g_QulityColor
-- UI控件引用变量 --
local m_jsonforBuyProp           = "ui/shop_buy_item.json"
local m_fnGetWidget              = g_fnGetWidgetByName
local m_i18nString 				 =  gi18nString

local m_btnCancel                = nil       --关闭按钮
local m_btnClose                 = nil       --取消按钮
local m_btnSure                  = nil       --确定按钮

local m_btnAddOne                = nil       -- +
local m_btnAddTen                = nil       -- +10
local m_btnReduceOne             = nil       -- -
local m_btnReduceTen             = nil       -- 10

local m_buyPropMainLay           = nil       --购买主界面
local m_i18nLabTotleOwner        = nil       --共拥有几个
local m_i18nLabBuyInfo           = nil       --请选择购买的数量文本
local m_labTotlePrice            = nil       --总价文本
local m_labNumber                = nil       --选择的道具数量
local m_labPrestigePrice         = nil       --声望总价item
local m_labPropPrice             = nil       --道具总价item

local m_boughtNum = 0
local _tbPrice = {}
local function closeAction()
	LayerManager.removeLayout()
end



-- 某次购买某商品多个
function setPriceInfo()
	local totalPrice = 0
	TimeUtil.timeStart("getPriceByTimes")
	for i = 1,m_maxLimitNum do
		
		 totalPrice  = totalPrice +  ShopUtil.getNeedGoldByGoodsAndTimes(m_tbData.id, i + m_boughtNum)
		_tbPrice[i] = totalPrice
	end
	_tbPrice[m_maxLimitNum + 1] = 99999999
	TimeUtil.timeEnd("getPriceByTimes")
	logger:debug(_tbPrice)
end



local function bCanAddNum(_num)

	local tempTotlePrice = 0
	if(m_tbData.type == 1)then
		--道具


		if(tonumber(m_nCurNumber) >= tonumber(m_maxLimitNum)) then
			ShowNotice.showShellInfo(m_i18nString(4305))
			return false,0
		end

		local totoleNum = m_nCurNumber + _num
		if(totoleNum >= m_maxLimitNum) then
			totoleNum = m_maxLimitNum
		end
		tempTotlePrice = _tbPrice[totoleNum]
		if(tempTotlePrice > UserModel.getGoldNumber()) then
			ShowNotice.showShellInfo(m_i18nString(1980))
			return false, 0
		end

	else
		--兑换声望
		tempTotlePrice = m_tbData.goldNum *(m_nCurNumber + _num)
		if(tonumber(m_nCurNumber) >= tonumber(m_maxLimitNum)) then
			ShowNotice.showShellInfo(m_i18nString(1978))
			return false,0
		end

		if(tonumber(m_nCurNumber) >= tonumber(m_tbData.canBuyNum)) then
			ShowNotice.showShellInfo(m_i18nString(1979))
			return false,0
		end
	end
	return true ,tempTotlePrice
end


-- 改变购买数量
local function onBtnChangeNumberAction( sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		local tag = sender:getTag()
		AudioHelper.playCommonEffect()
		TimeUtil.timeStart("shop btn")
		local tempTotlePrice = 0
		logger:debug("select btn tag is %d",tag)

		if(tag == m_nReducetenTag) then
			-- -10
			m_nCurNumber = m_nCurNumber - 10
		elseif(tag == m_nReduceOneTag) then
			-- -1
			m_nCurNumber = m_nCurNumber - 1
		elseif(tag == m_nAddOneTag) then
			-- +1
			local bCanAdd ,totlePrice = bCanAddNum(1)
			m_nTotlePrice = m_nTotlePrice +  totlePrice
			-- m_nTotlePrice =  totlePrice
			if(bCanAdd ==false) then
				return
			end
			m_nCurNumber = m_nCurNumber + 1
		elseif(tag == m_nAddTenTag) then

			local bCanAdd ,totlePrice = bCanAddNum(10)
			m_nTotlePrice = m_nTotlePrice + totlePrice
			-- m_nTotlePrice =  totlePrice
			if(bCanAdd ==false) then
				return
			end
			-- +10
			m_nCurNumber = m_nCurNumber + 10
		end
		if(m_nCurNumber<=0)then
			m_nCurNumber = 1
		end
		logger:debug(m_maxLimitNum)
		TimeUtil.timeEnd("shop btn")
		if(m_nCurNumber > tonumber(m_tbData.canBuyNum) or m_nCurNumber > m_maxLimitNum) then
			m_nCurNumber = tonumber(m_tbData.canBuyNum) > m_maxLimitNum and m_maxLimitNum or tonumber(m_tbData.canBuyNum)
		end

		m_nCurNumber = m_nCurNumber < 1 and 1 or m_nCurNumber
		--用来记录当前购买的数量
		m_btnSure:setTag(m_nCurNumber)
		-- 总价
		logger:debug(m_nCurNumber)
		if(m_tbData.type == 1)then
			--购买道具
			-- local nTotlePrice = ShopUtil.getNeedGoldByMoreGoods(m_tbData.id, m_boughtNum+1, m_nCurNumber)
			 m_nTotlePrice = _tbPrice[m_nCurNumber]
			-- m_nTotlePrice = m_nTotlePrice + totlePrice
		else
			--兑换声望
			m_nTotlePrice = m_tbData.goldNum * m_nCurNumber
		end
		logger:debug(m_nCurNumber)
		m_labTotlePrice:setText(tostring(m_nTotlePrice))
		-- 个数
		m_labNumber:setText(tostring(m_nCurNumber))


	end
end
-- create 按钮
local function createBtn()
	--X关闭按钮
	m_btnClose = m_fnGetWidget(m_buyPropMainLay,"BTN_SHOP_BUY_ITEM_CLOSE")
	m_btnClose:addTouchEventListener(m_tbData.onClose)
	require "script/module/shop/BuyPropsCtrl"
	--取消按钮
	m_btnCancel = m_fnGetWidget(m_buyPropMainLay,"BTN_SHOP_ITEM_BUY_CANCEL")
	m_btnCancel:addTouchEventListener(m_tbData.onClose)
	UIHelper.titleShadow(m_btnCancel,m_i18nString(1625))
	--确定按钮
	m_btnSure = m_fnGetWidget(m_buyPropMainLay,"BTN_SHOP_ITEM_BUY_SURE")
	m_btnSure:addTouchEventListener(m_tbData.onSure)
	m_btnSure:setTag(m_nCurNumber)
	UIHelper.titleShadow(m_btnSure,m_i18nString(1324))
	--加一
	m_btnAddOne = m_fnGetWidget(m_buyPropMainLay,"BTN_PLAYER_BUY_REDUCE")
	m_btnAddOne:addTouchEventListener(onBtnChangeNumberAction)
	m_btnAddOne:setTag(m_nAddOneTag)
	--加十
	m_btnAddTen = m_fnGetWidget(m_buyPropMainLay,"BTN_PLAYER_BUY_REDUCE_TEN")
	m_btnAddTen:addTouchEventListener(onBtnChangeNumberAction)
	m_btnAddTen:setTag(m_nAddTenTag)
	--减一
	m_btnReduceOne = m_fnGetWidget(m_buyPropMainLay,"BTN_PLAYER_BUY_ADDITION")
	m_btnReduceOne:addTouchEventListener(onBtnChangeNumberAction)
	m_btnReduceOne:setTag(m_nReduceOneTag)
	--减十
	m_btnReduceTen = m_fnGetWidget(m_buyPropMainLay,"BTN_PLAYER_BUY_ADDITION_TEN")
	m_btnReduceTen:addTouchEventListener(onBtnChangeNumberAction)
	m_btnReduceTen:setTag(m_nReducetenTag)
end
--
local function labPriceWithPresitge( ... )
	m_labPrestigePrice:setVisible(true)
	local labPrestigeTitle = m_fnGetWidget(m_labPrestigePrice,"tfd_item_price")
	labPrestigeTitle:setText(m_i18nString(1444) .. ":")

	local imgGold = m_fnGetWidget(m_labPrestigePrice,"img_price_gold")
	imgGold:setEnabled(false)

	local imgPresitge = m_fnGetWidget(m_labPrestigePrice,"img_price_prestige")
	imgPresitge:setEnabled(true)
	m_labTotlePrice = m_fnGetWidget(m_labPrestigePrice,"TFD_PRICE_NUM")
end

--道具总价，价格随数量的增加而递增
local function labPriceWithRiseProps( ... )
	m_labPropPrice:setVisible(true)
	m_labTotlePrice = m_fnGetWidget(m_labPropPrice,"TFD_SHOP_ITEM_PRICE_NUM")
	local i18nLabPriceIllustration = m_fnGetWidget(m_labPropPrice,"TFD_SHOP_ITEM_PRICE_ILLUSTRATION")
	i18nLabPriceIllustration:setText(gi18n[1426])
end

--道具总价，价格不随数量的增加而递增
local function labPriceWithNormalProps( ... )
	m_labPrestigePrice:setVisible(true)

	local labPrestigeTitle = m_fnGetWidget(m_labPrestigePrice,"tfd_item_price")
	labPrestigeTitle:setText(gi18n[1425]) --总价

	local imgPrestige= m_fnGetWidget(m_labPrestigePrice,"img_price_prestige")
	imgPrestige:setVisible(false)
	m_labTotlePrice = m_fnGetWidget(m_labPrestigePrice,"TFD_PRICE_NUM")
end

--初始化ui
local function createLabel(tbInfo)
	logger:debug(tbInfo)
	-- 一共拥有
	m_i18nLabTotleOwner = m_fnGetWidget(m_buyPropMainLay,"TFD_PLAYER_OWN_NUM")
	m_i18nLabTotleOwner:setText(gi18n[1421] .. tbInfo.hasNumber .. gi18n[1422])

	-- 购买提示
	local labPleaseChoose = m_fnGetWidget(m_buyPropMainLay,"tfd_please_choose")
	labPleaseChoose:setText(gi18n[1423])

	local labChooseUtil = m_fnGetWidget(m_buyPropMainLay,"tfd_choose_num")
	labChooseUtil:setText(gi18n[1424])
	--道具名字
	m_i18nLabBuyInfo = m_fnGetWidget(m_buyPropMainLay,"TFD_PLAYER_CHOOSE_BUY_NUM")
	UIHelper.labelEffect( m_i18nLabBuyInfo, tbInfo.propName)
	m_i18nLabBuyInfo:setColor(m_gColor[tonumber(tbInfo.quality)])
	--兑换道具 or 购买道具
	-- local imgTitle = m_fnGetWidget(m_buyPropMainLay,"img_title_prestige")
	local imgTitle1 = m_fnGetWidget(m_buyPropMainLay,"img_title")
	if(tbInfo.type == 1)then
		--m_labTitle:setText("购买道具")
		-- UIHelper.labelEffect(m_labTitle,m_i18nString(1453))
		-- imgTitle:setEnabled(false)
		imgTitle1:setEnabled(true)
	else
		--m_labTitle:setText("兑换道具")
		-- UIHelper.labelEffect(m_labTitle,m_i18nString(1454))
		imgTitle1:setEnabled(false)
		-- imgTitle:setEnabled(true)
	end

	--总价
	m_labPropPrice = m_fnGetWidget(m_buyPropMainLay,"lay_price_num")
	m_labPrestigePrice= m_fnGetWidget(m_buyPropMainLay,"lay_price")
	m_labPropPrice:setVisible(false)
	m_labPrestigePrice:setVisible(false)

	if(tbInfo.type == 1)then
		m_nTotlePrice = ShopUtil.getNeedGoldByGoodsAndTimes( tbInfo.id, ShopUtil.getBuyNumBy(tbInfo.id)+1)

		if(m_tbData.cost_gold_add_siliver == 1) then
			labPriceWithRiseProps()
		else
			labPriceWithNormalProps()
		end
	else
		labPriceWithPresitge()

		m_nTotlePrice = m_tbData.goldNum
		m_labTotlePrice = m_fnGetWidget(m_buyPropMainLay,"TFD_PRICE_NUM")
	end

	m_labTotlePrice:setText(tostring(m_nTotlePrice))

	--选择的购买数量lab
	m_labNumber = m_fnGetWidget(m_buyPropMainLay,"TFD_PLAYER_BUY_NUM")
	logger:debug("m_nCurNumber is %d",m_nCurNumber)
	m_labNumber:setText(m_nCurNumber)

end

local function init(...)
	logger:debug("m_nCurNumber is %d",m_nCurNumber)
	m_nCurNumber = 1
	m_nTotlePrice = nil
	m_tbData = nil
	m_maxLimitNum  = 9999
end

function destroy(...)
	package.loaded["BuyPropsView"] = nil
end

function moduleName()
	return "BuyPropsView"
end

--[[desc:创建选择购买数量的页面
    arg1: 道具的id
    return: 返回购买界面
—]]
function create(tbInfo)
	init()
	m_tbData = tbInfo
	m_boughtNum=  ShopUtil.getBuyNumBy(m_tbData.id)
	m_maxLimitNum = tbInfo.maxLimitNum
	m_buyPropMainLay= g_fnLoadUI(m_jsonforBuyProp)
	--给ui的lab赋值
	createLabel(tbInfo)
	createBtn()
	if(m_tbData.type == 1) then
		setPriceInfo()
	end

	local lay_max = m_fnGetWidget(m_buyPropMainLay,"lay_max")
	lay_max:setEnabled(false)
	return m_buyPropMainLay
end

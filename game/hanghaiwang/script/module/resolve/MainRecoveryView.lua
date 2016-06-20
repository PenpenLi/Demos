-- FileName: MainRecoveryView.lua
-- Author:zhangjunwu
-- Date: 2014-09-21
-- Purpose: 回收系统主模块


module("MainRecoveryView", package.seeall)


require "script/module/resolve/ResolveCtrl"
require "script/module/resolve/ResolveModel"


-- UI控件引用变量 --
local LSV_LIST 
local m_mainWidget 
local m_tbEvent 
local E_PARTNER_INDEX = 1
local N_ADDITEM_NUM  = 5

local TAGANI_1 = 456
local TAGANI_2 = 457
-- 模块局部变量 --
local TagPlas  						= 100 					--闪烁加号的tag
local TagHeadIcon  					= 111					--icon的tag
local TagheadAnimate 				= 122					--添加到icon上的动画tag
local json = "ui/decompose_room_main.json"
local m_fnGetWidget = g_fnGetWidgetByName --读取UI组件方法
local m_tbBtns = {}
local m_i18n = gi18n
local m_i18nString 					=  gi18nString
local TFD_GOLD = nil
--伙伴，影子，装备，，饰品 ,专属宝物
local tbShopLayer = {}
local m_layItemIcon = {}
local m_tbRedImg = {}   	--tab上的红点控件 table

-- local tbShopLayer = {"Partner", "Shadow", "Equipment", "Treasure" ,"Deceration" ,}

local function init(...)
	m_tbBtns = {}
	tbShopLayer = {}
	m_layItemIcon = {}
	tbSelected = {}
	m_tbRedImg = {}
	
end

function getPlusSprite(  )
	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		animationName = "guangzheng_xiao_renwu" ,
		loop = -1,
	})
	return armature4
end

function destroy(...)
	package.loaded["MainRecoveryView"] = nil
end


function moduleName()
	return "MainRecoveryView"
end

local function getPlusSprite(  )
	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		animationName = "guangzheng_xiao_renwu" ,
		loop = -1,
	})
	return armature4
end

--为六个个子加入头像，名字，点击事件
--在播放动画的是时候需要删除+号上的icon ，如果此时背包推送还没有回来，则不能清空tbselelct数据
function createSelectedIcons(_bClean)
	local nTypeRecovery = ResolveModel.getRecoveryType()
	local tbSelected = {}
	if(_bClean) then
		tbSelected = {}
	else
		tbSelected = ResolveModel.getSelectedData()
	end
	 logger:debug(tbSelected)
	 --重生界面
	if(nTypeRecovery == ResolveModel.T_RebornParnter)then
		setRebornIconAndName(tbSelected)
		return 
	end

	logger:debug({tbSelected = tbSelected})
	--如果格子有内容
	for i = 1,N_ADDITEM_NUM do
		local itemName = nil
		local itemNameColor = nil
		local heroFragNum = nil
		local head_icon = nil
		local stritemLV = nil
		if(i <= #tbSelected) then
			stritemLV = tbSelected[i].showLevel
			if(nTypeRecovery == ResolveModel.T_Parnter) then
				itemname = tbSelected[i].name
				itemNameColor = g_QulityColor2[tonumber(tbSelected[i].star_lv)]
				head_icon = HeroUtil.getHeroBodySpriteByHTID(tbSelected[i].htid)
				if(head_icon) then
					head_icon:setScale(0.35)
				end

			elseif(nTypeRecovery == ResolveModel.T_Equip) then
				itemname = tbSelected[i].name
				itemNameColor = g_QulityColor2[tonumber(tbSelected[i].nQuality)]
				local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(tbSelected[i].item_template_id)
				head_icon  = CCSprite:create(tbItem.iconBigPath)
				head_icon:setScale(0.50)

			elseif(nTypeRecovery == ResolveModel.T_Shadow) then
				itemname = tbSelected[i].name
				itemNameColor = g_QulityColor2[tonumber(tbSelected[i].star_lv)]
				heroFragNum = tbSelected[i].item_num
				local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(tbSelected[i].item_template_id)
				head_icon  = CCSprite:create(tbItem.iconBigPath)
				if(head_icon) then
					head_icon:setScale(0.35)
				end

			elseif(nTypeRecovery == ResolveModel.T_Treasure) then

				itemname = tbSelected[i].itemDesc.name
				itemNameColor = g_QulityColor2[tonumber(tbSelected[i].itemDesc.quality)]
				local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(tbSelected[i].item_template_id)
				head_icon  = CCSprite:create(tbItem.iconBigPath)
				if(head_icon) then
					head_icon:setScale(0.50)
				end

			elseif(nTypeRecovery == ResolveModel.T_SPTreasure) then
				itemname = tbSelected[i].itemDesc.name
				itemNameColor = g_QulityColor2[tonumber(tbSelected[i].itemDesc.quality)]
				local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(tbSelected[i].item_template_id)
				head_icon  = CCSprite:create(tbItem.iconBigPath)
				if(head_icon) then
					head_icon:setScale(0.50)
				end
			elseif(nTypeRecovery == ResolveModel.T_SPShipItem) then
				itemname = tbSelected[i].itemDesc.name
				itemNameColor = g_QulityColor2[tonumber(tbSelected[i].itemDesc.quality)]
				local btnIcon,tbItem = ItemUtil.createBtnByTemplateId(tbSelected[i].item_template_id)
				head_icon  = CCSprite:create(tbItem.iconBigPath)
				heroFragNum = tbSelected[i].item_num
				if(head_icon) then
					head_icon:setScale(1.2)
				end
			end
		else

		end
		--更新名字
		setPlusIconName(itemname,itemNameColor,i,heroFragNum,stritemLV)
		setPlusIcon(head_icon,i)
	end
end

--itemname：要分解的物品，宝物，装备名字；
-- itemNameColor:名字颜色；
-- i:位置；
-- heroFragNum为影子个数，只有分解影子的时候才有
function setPlusIconName( itemname,itemNameColor , i , heroFragNum,stritemLV)
	-- logger:debug(itemNameColor)
	--设置影子伙伴个数
	local tfdItemNum = m_layItemIcon[i].TFD_ITEM_NUM
	local tfdItemName = m_layItemIcon[i].TFD_ITEM_NAME
	local TFD_LV = m_layItemIcon[i].TFD_LV
	logger:debug(stritemLV)
	if(stritemLV) then
		-- m_tfdItemNum[i]:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(TFD_LV, "LV." ..stritemLV,ccc3(0x28,0x00,0x00)) -- 名字描边
		TFD_LV:setEnabled(true)
	else
		TFD_LV:setEnabled(false)
	end

	if(heroFragNum) then
		-- m_tfdItemNum[i]:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(tfdItemNum, "X" .. heroFragNum,ccc3(0x28,0x20,0x20)) -- 名字描边
		tfdItemNum:setEnabled(true)
		UIHelper.labelAddNewStroke(tfdItemName, itemname .. m_i18n[1002],ccc3(0x28,0x00,0x00)) -- 名字描边
	else
		tfdItemNum:setEnabled(false)
	end

	if itemNameColor then
		tfdItemName:setEnabled(true)
		tfdItemName:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(tfdItemName, itemname,ccc3(0x28,0x00,0x00)) -- 名字描边
	else
		tfdItemName:setEnabled(false)
	end

	local lay_item = m_layItemIcon[i]
	local lay_name_bg = m_fnGetWidget(lay_item,"lay_name_bg")
	lay_name_bg:requestDoLayout()
end

local function fnSetRebornPriceLabelBy(_rebirth_basegold,envloveLevel)
	if(_rebirth_basegold  > 0) then
		TFD_GOLD:setText("" .._rebirth_basegold * (envloveLevel + 1))
		UIHelper.titleShadow(m_mainWidget.BTN_RENASCENCE, m_i18nString(7159," ") )
		TFD_GOLD:setEnabled(true)
		m_mainWidget.img_gold:setEnabled(true)
	else
		logger:debug("asdfasdf")
		TFD_GOLD:setEnabled(false)
		m_mainWidget.img_gold:setEnabled(false)
		UIHelper.titleShadow(m_mainWidget.BTN_RENASCENCE, m_i18nString(7158," ") )
	end
end

function setRebornIconAndName(_tbSelect)
		--设置影子伙伴个数
	local tfdItemName = m_mainWidget.TFD_HERO_NAME
	local tfdItemLV= m_mainWidget.TFD_HERO_LV
	local tbHeroInfo = _tbSelect
	logger:debug(tbHeroInfo)
	local rebornHeroInfo = tbHeroInfo[1]
	logger:debug(rebornHeroInfo)
	if table.count(_tbSelect) > 0 then
		tfdItemName:setEnabled(true)
		tfdItemLV:setEnabled(true)
		local itemNameColor = g_QulityColor2[tonumber(rebornHeroInfo.nQuality)]
		local itemname = rebornHeroInfo.name
		local showLevel = rebornHeroInfo.showLevel
		tfdItemName:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(tfdItemName, itemname,ccc3(0x28,0x00,0x00)) -- 名字描边

		-- tfdItemLV:setColor(itemNameColor)
		UIHelper.labelAddNewStroke(tfdItemLV, "LV." .. showLevel,ccc3(0x28,0x00,0x00)) -- 等级描边

		local rebirth_basegold = tonumber(rebornHeroInfo.rebirth_basegold )or 0
		local envloveLevel = tonumber(rebornHeroInfo.sTransferValue )or 0
		fnSetRebornPriceLabelBy(rebirth_basegold,envloveLevel)
	else
		tfdItemName:setEnabled(false)
		tfdItemLV:setEnabled(false)
		fnSetRebornPriceLabelBy(0,0)
	end


	local img_border = m_fnGetWidget(m_mainWidget,"img_border_hero" )
	local img_effect = m_fnGetWidget(m_mainWidget,"img_effect_hero" )
	img_border:removeNodeByTag(TagHeadIcon)
	img_border:removeNodeByTag(TAGANI_1)
	img_border:removeNodeByTag(TAGANI_2)
	img_effect:removeNodeByTag(TagPlas)

	if(table.count(tbHeroInfo) > 0 )then

		local head_icon = HeroUtil.getHeroBodySpriteByHTID(rebornHeroInfo.htid)
		head_icon:setScale(0.60)
		head_icon:setPosition(ccp(0,-m_mainWidget.lay_hero:getSize().height / 2 + 20))
		head_icon:setAnchorPoint(ccp(0.5,0.0))
		
		local armature1 = UIHelper.createArmatureNode({
			filePath = "images/effect/resolve/huishou_1.ExportJson",
			animationName = "huishou_1" ,
			loop = -1,
		})

		img_border:addNode(armature1,0,TAGANI_1)
		img_border:addNode(head_icon,0,TagHeadIcon)
		local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/resolve/huishou_2.ExportJson",
			animationName = "huishou_2" ,
			loop = -1,
		})
		armature1:setScale(2.0)
		armature2:setScale(2.0)
		armature2:setPositionY(armature2:getPositionY() + 60)
		img_border:addNode(armature2,0,TAGANI_2)
	else
		--添加+号
		local plusSprite = getPlusSprite()

		plusSprite:setAnchorPoint(ccp(0.5,0.5))
		plusSprite:setPosition(ccp(0,20))
		img_effect:addNode(plusSprite,0,TagPlas)
	end

end

function setPlusIcon( head_icon,i )
	local img_border = m_fnGetWidget(m_layItemIcon[i],"img_border" )
	local img_effect = m_fnGetWidget(m_layItemIcon[i],"img_effect" )
	img_border:removeNodeByTag(TagHeadIcon)
	img_border:removeNodeByTag(TAGANI_1)
	img_border:removeNodeByTag(TAGANI_2)
	img_effect:removeNodeByTag(TagPlas)

	if(head_icon)then
		head_icon:setPosition(ccp(0,-m_layItemIcon[i]:getSize().height / 2 + 30))
		head_icon:setAnchorPoint(ccp(0.5,0.0))
		
		local armature1 = UIHelper.createArmatureNode({
			filePath = "images/effect/resolve/huishou_1.ExportJson",
			animationName = "huishou_1" ,
			loop = -1,
		})
		img_border:addNode(armature1,0,TAGANI_1)
		img_border:addNode(head_icon,0,TagHeadIcon)
		local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/resolve/huishou_2.ExportJson",
			animationName = "huishou_2" ,
			loop = -1,
		})
		armature2:setPositionY(armature2:getPositionY() + 30)
		img_border:addNode(armature2,0,TAGANI_2)
	else
		--添加+号
		local plusSprite = getPlusSprite()
		plusSprite:setAnchorPoint(ccp(0.5,0.5))
		plusSprite:setPosition(ccp(0,20))
		img_effect:addNode(plusSprite,0,TagPlas)
	end
end


--1.BTN_TAB按钮，未选中的按钮颜色为#bf9367，选中的按钮颜色为#ffffff
local titleSelectColor = ccc3(0xff, 0xff, 0xff)
local titleNormalColor = ccc3(0xbf, 0x93, 0x67)
--设置tab按钮的点击状态和显示状态
function setTabBtnStats( _index )
	for i,v in ipairs(m_tbBtns) do
		v:setFocused(i == _index)
		v:setTouchEnabled(not (i == _index))
		ResolveModel.setRecoveryType(_index)
		logger:debug(v:isFocused())
		if(not v:isFocused()) then
			v:setTitleColor(titleNormalColor)
		else
			v:setTitleColor(titleSelectColor)
		end
		
	end
end

--设置商店显示状态和数值控件显示状态
function setShopBtnState( _index )
	-- logger:debug(tbShopLayer)
	 m_mainWidget.lay_decompose:setEnabled(true)
	 m_mainWidget.lay_renascence:setEnabled(true)

	if(_index == ResolveModel.T_RebornParnter) then
		 m_mainWidget.lay_decompose:setEnabled(false)
		 -- m_mainWidget.lay_renascence:setEnabled(true)
		return 
	else
		 -- m_mainWidget.lay_decompose:setEnabled(true)
		 m_mainWidget.lay_renascence:setEnabled(false)
	end


	for i,v in ipairs(tbShopLayer) do
		-- logger:debug(setEnabled)
		if(v ~= "nil") then
			v:setEnabled(false)
			-- v:setVisible(false)
		end
	end

	--huo伙伴和影子冲突
	if(_index == ResolveModel.T_Shadow) then
		tbShopLayer[E_PARTNER_INDEX]:setEnabled(true)
		-- tbShopLayer[E_PARTNER_INDEX]:setVisible(true)
	else
		tbShopLayer[_index]:setEnabled(true)
		-- tbShopLayer[E_PARTNER_INDEX]:setVisible(true)
	end

end

--把自动添加的按钮改为 换一组
function setAddBtnAuto(_autoAdd)
	if(_autoAdd == true) then
		-- UIHelper.titleShadow(m_mainWidget.BTN_ADD, m_i18n[1055])
		m_mainWidget.BTN_ADD:addTouchEventListener(m_tbEvent.onAutoAdd)
		UIHelper.titleShadow(m_mainWidget.BTN_ADD, m_i18n[1055])
	else
		UIHelper.titleShadow(m_mainWidget.BTN_ADD, m_i18n[7113])
		m_mainWidget.BTN_ADD:addTouchEventListener(m_tbEvent.onChange)
	end
end

--g更新tab上的红点

function updateRedImg(  )
	logger:debug("开始更新tab上的红点")
	local nAutoSelectCount = #(ResolveModel.getAutoAddDataByType())
	local nType= ResolveModel.getRecoveryType()
	ResolveModel.m_redPoint[nType].visible = nAutoSelectCount >= 5

	logger:debug(m_tbRedImg)
	for i,v in ipairs(m_tbRedImg) do
    	v:setEnabled(ResolveModel.m_redPoint[i].visible)
	end
end



function scrollPassGetRow( idxRow )
	logger:debug(idxRow)
	if (LSV_LIST) then
		local colGap = LSV_LIST:getItemsMargin() -- 行cell间隔
		local m_szRowCell = LSV_LIST:getItem(1):getSize()
		local passNum = idxRow -1
		logger:debug(passNum)
		local hScrollTo = (m_szRowCell.width + colGap) * passNum

		local szInner = LSV_LIST:getInnerContainerSize()
		local szView = LSV_LIST:getSize()

		local totalHeight = (m_szRowCell.width + colGap) * #(ResolveModel.getRecoveryList())
		LSV_LIST:setInnerContainerSize(CCSizeMake(totalHeight, szInner.height))
		local tempNum = (szInner.width - szView.width) == 0 and hScrollTo or (szInner.width - szView.width)
		local percent = (hScrollTo/(tempNum)) * 100

		 performWithDelay(LSV_LIST, function () 
				LSV_LIST:jumpToPercentHorizontal(percent)
	        end,0.02)
		
	end
end

--创建按钮
function loadTabCell( )
	LSV_LIST = m_fnGetWidget(m_mainWidget, "LSV_TAB")
	UIHelper.initListView(LSV_LIST)
	local cell, nIdx
	for i,iconIndex in ipairs(ResolveModel.getRecoveryList()) do
		LSV_LIST:pushBackDefaultItem()	
		nIdx = i - 1
    	cell = LSV_LIST:getItem(nIdx)  -- cell 索引从 0 开始

    	local btnTab = m_fnGetWidget(cell,"BTN_TAB")
    	btnTab:setTitleText(iconIndex)
    	btnTab:addTouchEventListener(m_tbEvent.onTabBtn)
    	btnTab:setTag(i)

		table.insert(m_tbBtns,btnTab)
    	local redImge = m_fnGetWidget(cell,"IMG_RED")
    	table.insert(m_tbRedImg,redImge)
    	redImge:setEnabled(ResolveModel.m_redPoint[i].visible)
  
	end

	local nTYpe = ResolveModel.getRecoveryType()
	scrollPassGetRow(nTYpe)
	setTabBtnStats(nTYpe)
	setShopBtnState(nTYpe)
	MainRecoveryCtrl.fnGetDataBy(nTYpe)
end

--设置每一页的数值
function setValueByType()
	local lay_mian_hero = m_mainWidget.lay_mian_hero
	local lay_mian_equip = m_mainWidget.lay_mian_equip
	local lay_mian_special = m_mainWidget.lay_mian_special
	local lay_mian_treasure = m_mainWidget.lay_mian_treasure
	local lay_mian_ship = m_mainWidget.lay_mian_ship

	local soulNum = lay_mian_hero.TFD_COIN
	local equipNum = lay_mian_equip.TFD_COIN
	local spNum = lay_mian_special.TFD_COIN
	local treasNum = lay_mian_treasure.TFD_COIN
	local treeNum = lay_mian_ship.TFD_COIN
	local rebornSoulNum = m_mainWidget.lay_renascence.TFD_COIN

	soulNum:setText(UserModel.getJewelNum())
	rebornSoulNum:setText(UserModel.getJewelNum())
	equipNum:setText(UserModel.getImpelDownNum())
	treasNum:setText("" .. ResolveModel.getTreasItemCount())
	spNum:setText(UserModel.getRimeNum())
	treeNum:setText("" .. ResolveModel.getShipItemCount())
end

local function setLebalAndNum(parentLay,sName,sValue)
	local soul = parentLay.tfd_coin_txt
	local soulNum = parentLay.TFD_COIN
	UIHelper.labelAddNewStroke(soul,sName)
	UIHelper.labelAddNewStroke(soulNum,sValue)
end

--初始化tab标签和商店按钮的点击事件
function initShopBtn()
	local lay_mian_hero = m_mainWidget.lay_mian_hero
	table.insert(tbShopLayer , lay_mian_hero)
	--影子
	table.insert(tbShopLayer , "nil")
	table.insert(tbShopLayer , "nil")
	--装备
	local lay_mian_equip = m_mainWidget.lay_mian_equip
	table.insert(tbShopLayer , lay_mian_equip)
	--b宝物是饰品
	local lay_mian_treasure = m_mainWidget.lay_mian_treasure
	-- lay_mian_treasure.BTN_SHOP:removeFromParentAndCleanup(true)
	table.insert(tbShopLayer , lay_mian_treasure)
	--专属专属宝物
	local lay_mian_special = m_mainWidget.lay_mian_special
	table.insert(tbShopLayer , lay_mian_special)

	--主船
	local lay_mian_ship = m_mainWidget.lay_mian_ship
	table.insert(tbShopLayer , lay_mian_ship)
	--重生
	-- table.insert(tbShopLayer , m_mainWidget.lay_renascence)
	--伙伴数值
	setLebalAndNum(lay_mian_hero,m_i18n[2061],UserModel.getJewelNum())
	setLebalAndNum(lay_mian_equip,m_i18n[7115],UserModel.getImpelDownNum())
	setLebalAndNum(lay_mian_treasure,m_i18n[7116],"" .. ResolveModel.getTreasItemCount())
	setLebalAndNum(lay_mian_special,m_i18n[6921] .. ":",UserModel.getRimeNum())
	setLebalAndNum(lay_mian_ship,m_i18n[7145],"" .. ResolveModel.getShipItemCount())
	setLebalAndNum(m_mainWidget.lay_renascence,m_i18n[2061],"" .. UserModel.getJewelNum())


	lay_mian_hero.BTN_SHOP:addTouchEventListener(m_tbEvent.onShop)
	lay_mian_treasure.BTN_SHOP:addTouchEventListener(m_tbEvent.onShop)
	lay_mian_special.BTN_SHOP:addTouchEventListener(m_tbEvent.onShop)
	lay_mian_equip.BTN_SHOP:addTouchEventListener(m_tbEvent.onShop)
	lay_mian_ship.BTN_SHOP:addTouchEventListener(m_tbEvent.onShop)
	m_mainWidget.lay_renascence.BTN_SHOP:addTouchEventListener(m_tbEvent.onShop)

end

--初始化5个加号按钮
function initPlusSprite()
	for i = 1, 5 do
		local itemIcon = m_fnGetWidget(m_mainWidget,"lay_item" .. i)
		m_layItemIcon[i] = itemIcon 

		local img_light = m_fnGetWidget(itemIcon,"img_light" )
		img_light:setTouchEnabled(true)
		img_light:addTouchEventListener(m_tbEvent.onOpenList)

		local BTN_ITEM_BG = m_fnGetWidget(itemIcon,"BTN_ITEM_BG")
		BTN_ITEM_BG:removeFromParentAndCleanup(true)

		itemIcon.TFD_ITEM_NAME:setText("")
		itemIcon.TFD_ITEM_NUM:setEnabled(false)
	end

	local lay_hero = m_fnGetWidget(m_mainWidget,"lay_hero")
	local img_light = m_fnGetWidget(lay_hero,"img_light_hero" )
	img_light:setTouchEnabled(true)
	img_light:addTouchEventListener(m_tbEvent.onOpenList)

	local BTN_HERO_BG = m_fnGetWidget(m_mainWidget,"BTN_HERO_BG")
	BTN_HERO_BG:removeFromParentAndCleanup(true)
end


function fnSetRebornPrice(  )
	
end
--注册按钮点击时间
local function regBtnListener()

	local btnRecovery = m_mainWidget.BTN_DECOMPOSE
	local btnAutoAdd  = m_mainWidget.BTN_ADD
	local BTN_DESC  = m_mainWidget.BTN_DESC
	local BTN_REBORN_DESC  = m_mainWidget.BTN_HELP

	local BTN_RENASCENCE  = m_mainWidget.BTN_RENASCENCE

	UIHelper.titleShadow(BTN_RENASCENCE, m_i18nString(7159," ") )
	UIHelper.titleShadow(btnRecovery, m_i18n[1654])

	TFD_GOLD = m_mainWidget.TFD_GOLD
	TFD_GOLD:setText("0")

	BTN_DESC:addTouchEventListener(m_tbEvent.onExplain)
	BTN_REBORN_DESC:addTouchEventListener(m_tbEvent.onExplain)
	btnRecovery:addTouchEventListener(m_tbEvent.onRecovery)
	BTN_RENASCENCE:addTouchEventListener(m_tbEvent.onReborn)
	setAddBtnAuto(true)
	UIHelper.labelNewStroke(TFD_GOLD)
end

function create(tbEvent)
	m_tbEvent = tbEvent
	init()
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget.lay_renascence:setVisible(true)
	UIHelper.registExitAndEnterCall(m_mainWidget,function ()
		ShakeSenceEff:stopShakeAction()
	end)

	initShopBtn()

	for i,v in ipairs(ResolveModel.ResolveModel.m_redPoint) do
		if(v.call) then
			v.visible = v.call()
		end
	end

	loadTabCell()

	initPlusSprite()
	createSelectedIcons()

	regBtnListener()

	m_layEasyInfo = m_fnGetWidget(m_mainWidget, "lay_easy_information")
	m_imgBG = m_fnGetWidget(m_mainWidget, "img_decompose_room_bg")
	m_imgChain = m_fnGetWidget(m_mainWidget, "img_chain")

	-- 适配
	m_layEasyInfo:setSize(CCSizeMake(m_layEasyInfo:getSize().width * g_fScaleX, m_layEasyInfo:getSize().height * g_fScaleX))
	m_imgBG:setScale(g_fScaleX)
	m_imgChain:setScale(g_fScaleX)


	--------------------------- new guide begin ---------------------------

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideDecomView"
	if (GuideModel.getGuideClass() == ksGuideResolve and GuideDecomView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createDecomGuide(2,nil,function (  )
			GuideCtrl.createDecomGuide(3)
		end)
	end

	require "script/module/guide/GuideRebornView"
	if (GuideModel.getGuideClass() == ksGuideReborn  and GuideRebornView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createRebornGuide(3)
	end

	--------------------------- new guide end ---------------------------------

	return m_mainWidget
end

local m_animationPath = "images/effect/resolve/"
local runningScene = CCDirector:sharedDirector():getRunningScene()
local aniShakeSence = nil

local function fnAddResloveAni(  )
	local  img_decompose_room_bg = m_fnGetWidget(m_mainWidget,"img_decompose_room_bg")
	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/resolve/huishou_4.ExportJson",
		animationName = "huishou_4" ,
		loop = 0,
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == 1) then
					sender:removeFromParentAndCleanup(true)
					ShakeSenceEff:stopShakeAction()
				end
			end,
	})
	img_decompose_room_bg:addNode(armature4,0,TAGANI_1)
	AudioHelper.playSpecialEffect("texiao_huishou.mp3")
end

function showRebornAnimation( callback )
	local nShaked = false
	local nCalled = false
	local function keyFrameFJ1_2CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "1" and nShaked == false) then
			--开始震屏
			nShaked = true
			AudioHelper.playSpecialEffect("texiao_huishou.mp3")
			aniShakeSence = ShakeSenceEff:new(runningScene,0.09,400)
			createSelectedIcons(true)
		end
	end

	local img_border = m_fnGetWidget(m_mainWidget,"img_border_hero" )
	local head_icon = img_border:getNodeByTag(TagHeadIcon)
	if(head_icon)then
		local armature3 = UIHelper.createArmatureNode({
			filePath = m_animationPath .. "huishou_3.ExportJson",
			animationName = "huishou_3",
			loop = 0,
			fnFrameCall = keyFrameFJ1_2CallBack,
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == 1 and nCalled == false) then
					sender:removeFromParentAndCleanup(true)
					callback()
					nCalled = true
				end
			end,
		}
		)
		armature3:setScale(2.0)
		img_border:addNode(armature3,0,TAGANI_2)
	
	end

	fnAddResloveAni()
end


function showAnimation( callback )
	local nShaked = false
	local nCalled = false
	local function keyFrameFJ1_2CallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		logger:debug(frameEventName)
		if (frameEventName == "1" and nShaked == false) then
			--开始震屏
			nShaked = true
			AudioHelper.playSpecialEffect("texiao_huishou.mp3")
			aniShakeSence = ShakeSenceEff:new(runningScene,0.09,400)
			print("shakescen")
			-- logger:debug(aniShakeSence)
			createSelectedIcons(true)
		end
	end

	for i=1,5 do
		local img_border = m_fnGetWidget(m_layItemIcon[i],"img_border" )
		local head_icon = img_border:getNodeByTag(TagHeadIcon)
		if(head_icon)then
			local armature3 = UIHelper.createArmatureNode({
				filePath = m_animationPath .. "huishou_3.ExportJson",
				animationName = "huishou_3",
				loop = 0,
				fnFrameCall = keyFrameFJ1_2CallBack,
				fnMovementCall = function ( sender, MovementEventType , frameEventName)
					if (MovementEventType == 1 and nCalled == false) then
						sender:removeFromParentAndCleanup(true)
						callback()
						nCalled = true
					end
				end,
			}
			)
			img_border:addNode(armature3,0,TAGANI_2)
		
		end
	end
	fnAddResloveAni()
end

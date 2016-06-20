-- FileName: SeniorHeroRecruit.lua
-- Author: menghao
-- Date: 2014-04-29
-- Purpose: 招将界面点神将弹出框


module("SeniorHeroRecruit", package.seeall)


--require "script/module/shop/TenHeroRecruit"


-- UI控件引用变量 --
local m_UIMain

local m_btnClose
local m_btnRecruitOne
local m_btnRecruitTen

local m_tfdTitle
local m_labnRecruitOneCost
local m_imgRecruitOneGold
local m_tfdRecruitFree
local m_labnRecruitTenCost
local m_imgFirstGetFive

local m_layTxt
local m_layTxtZero

local m_tfdRecruitNextZero
local m_tfdRecruitStarZero
local m_tfdRecruitExclamationZero

local m_tfdRecruitAgain
local m_tfdRecruitAgainNum
local m_tfdRecruitNext
local m_tfdRecruitStar
local m_tfdRecruitExclamation

local m_layModelBG
local m_layModelClone
local m_btnPreView

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnAddStroke = UIHelper.labelNewStroke

local mi18n = gi18n

local m_numOfTenRecuit
local m_costGoldOfTen

local m_tbHeroes


-- 招将10次网络回调处理
function fnHandlerOfNetworkRecruitTen(cbFlag, dictData, bRet)
	if bRet then
		-- 减去所消耗金币
		-- DataCache.changeFirstStatus()
		DataCache.changeGoldRecruitSum(m_numOfTenRecuit)
		local  tenCost = RecruitService.getTenCostGold()
		UserModel.addGoldNumber(-tenCost)

		TenHeroRecruit.setAllHeroes(dictData.ret)

		LayerManager.removeLayout()
		TenHeroRecruit.create()
	end
end


-- 招将一次事件
local function onRecruitOne( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		

		require "script/module/guide/GuideCopy2BoxView"
		if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 7) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.removeGuideView()
		end


		local shopInfo = DataCache.getShopCache()
		if (tonumber(shopInfo.seniorFreeNum) > 0) then
			AudioHelper.playCommonEffect()
			local args = Network.argsHandler(0, 1)
			RequestCenter.shop_goldRecruit(RecruitService.seniorRecruitCallback, args)
		else
			-- local db_tavern = DB_Tavern.getDataById(3)
			local nGoldCost = RecruitService.getOneCostGold()
			if (UserModel.getGoldNumber() >= (nGoldCost)) then
				local args = Network.argsHandler(1, 1)
				AudioHelper.playBuyGoods()
				RequestCenter.shop_goldRecruit(RecruitService.seniorRecruitCallback, args)
			else
				AudioHelper.playCommonEffect()
				local layDlg = UIHelper.createNoGoldAlertDlg()
				LayerManager.addLayout(layDlg)
			end
		end
	end
end


-- 招将十次事件
local function onRecruitTen( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local tenCost = RecruitService.getTenCostGold()
		if (UserModel.getGoldNumber() < tenCost) then
			local layDlg = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(layDlg)
			return
		end
		local args = Network.argsHandler(1, m_numOfTenRecuit)
		RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitTen, args)
	end
end


-- 初始化控件
local function initUIWidget( ... )
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_CLOSE")
	m_btnRecruitOne = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_ONE")
	m_btnRecruitTen = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_TEN")

	-- m_tfdTitle = m_fnGetWidget(m_UIMain, "tfd_recruit_senior_hero_title")
	m_labnRecruitOneCost = m_fnGetWidget(m_UIMain, "TFD_RECRUIT_SENIOR_HERO_ONE_COST")
	m_imgRecruitOneGold = m_fnGetWidget(m_UIMain, "img_recruit_senior_hero_one_gold")
	m_tfdRecruitFree = m_fnGetWidget(m_UIMain, "TFD_RECRUIT_FREE")
	m_labnRecruitTenCost = m_fnGetWidget(m_UIMain, "TFD_RECRUIT_SENIOR_HERO_TEN_COST")
	m_imgFirstGetFive = m_fnGetWidget(m_UIMain, "img_first_get")

	m_btnClose:addTouchEventListener(UIHelper.onBack)
	m_btnRecruitOne:addTouchEventListener(onRecruitOne)
	m_btnRecruitTen:addTouchEventListener(onRecruitTen)
	UIHelper.titleShadow(m_btnRecruitOne, mi18n[1448])
	UIHelper.titleShadow(m_btnRecruitTen, mi18n[1449])
	UIHelper.titleShadow(m_btnClose, mi18n[1019])

	local tavernData = DB_Tavern.getDataById(3)
	m_numOfTenRecuit = tonumber(lua_string_split(tavernData.gold_nums, "|")[1])
	m_costGoldOfTen = tonumber(lua_string_split(tavernData.gold_nums, "|")[2])

	-- m_fnAddStroke(m_tfdTitle, mi18n[1433])
	m_tfdRecruitFree:setText(mi18n[1450])

	m_labnRecruitOneCost:setText(tavernData.gold_needed)
	m_labnRecruitTenCost:setText(m_costGoldOfTen)

	local shopInfo = DataCache.getShopCache()
	if( tonumber(shopInfo.seniorFreeNum ) > 0 )then
		m_imgFirstGetFive:setEnabled(false)
	else
		if( tonumber(shopInfo.gold_recruit_num) >= 1)then
			m_imgFirstGetFive:setVisible(false)
		end
	end

	if (tonumber(shopInfo.seniorFreeNum) > 0) then
		m_labnRecruitOneCost:setEnabled(false)
		m_imgRecruitOneGold:setEnabled(false)
	else
		m_tfdRecruitFree:setEnabled(false)
	end



	-- 1223新增武将展示
	m_layModelBG = m_fnGetWidget(m_UIMain, "lay_model_bg")
	local layModel = m_fnGetWidget(m_UIMain, "img_model")

	m_layModelClone = layModel:clone()
	m_layModelClone:retain()
	layModel:removeFromParent()

	m_tbHeroes = DB_Hero_view.getDataById(4).Heroes
	m_tbHeroes = string.gsub(m_tbHeroes, " ", "")
	m_tbHeroes = lua_string_split(m_tbHeroes, ",")
	logger:debug(m_tbHeroes)

	math.randomseed(os.clock())
	for i=1,#m_tbHeroes do
		local n = math.random(1, #m_tbHeroes)
		m_tbHeroes[i], m_tbHeroes[n] = m_tbHeroes[n], m_tbHeroes[i]
	end

	local tfdCan = m_fnGetWidget(m_UIMain, "tfd_can")
	-- local tfdBlue = m_fnGetWidget(m_UIMain, "tfd_blue")
	local tfdSlant1 = m_fnGetWidget(m_UIMain, "tfd_slant_1")
	local tfdSlant2 = m_fnGetWidget(m_UIMain, "tfd_slant_2")
	-- local tfdPurple = m_fnGetWidget(m_UIMain, "tfd_purple")
	local tfdHeroTxt = m_fnGetWidget(m_UIMain, "tfd_hero_txt")
	tfdCan:setText(gi18n[5526])
	-- tfdSlant:setText("、")
	tfdHeroTxt:setText(gi18n[1001])
	m_fnAddStroke(tfdCan)
	m_fnAddStroke(tfdSlant1)
	m_fnAddStroke(tfdSlant2)
	m_fnAddStroke(tfdHeroTxt)

	RecruitService.initMustBePurpleTip(m_UIMain,true)

	addHeroView(1)

	-- 新增预览
	m_btnPreView = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_VIEW")
	m_btnPreView:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			HeroPreview.create(4)
		end
	end)
end


function addHeroView( index )
	local heroIdx = index % #m_tbHeroes
	if (heroIdx == 0) then
		heroIdx = #m_tbHeroes
	end

	local layHero = m_layModelClone:clone()
	local heroLocalInfo = DB_Heroes.getDataById(m_tbHeroes[heroIdx])
	-- local imgHero = ImageView:create()
	-- imgHero:loadTexture("images/base/hero/body_img/" .. heroLocalInfo.body_img_id)
	-- imgHero:setPosition(ccp(0, 0))
	-- imgHero:setAnchorPoint(ccp(0.5,0))
	-- imgHero:setScale(1)
	-- layHero:addChild(imgHero, 1)
	local a = tolua.cast(layHero, "ImageView")
	a:loadTexture("images/base/hero/body_img/" .. heroLocalInfo.body_img_id)

	local imgNameBG = m_fnGetWidget(layHero, "img_name_bg")
	local tfdHeroName = m_fnGetWidget(layHero, "TFD_HERO_NAME")
	tfdHeroName:setText(heroLocalInfo.name)
	tfdHeroName:setColor(g_QulityColor2[heroLocalInfo.potential])
	m_fnAddStroke(tfdHeroName)
	imgNameBG:setZOrder(10)

--你注销的代码里可以加注释：王晓靖让改的···他还说i'm sure···
	-- for i=1,tonumber(heroLocalInfo.potential) do
	-- 	local imgStar = m_fnGetWidget(layHero, "img_star" .. i)
	-- 	local pos = imgStar:getPositionPercent()
	-- 	imgStar:setPositionPercent(ccp(pos.x + 0.06 * (6 - heroLocalInfo.potential), pos.y))
	-- end
	-- for i=tonumber(heroLocalInfo.potential) + 1,6 do
	-- 	local imgStar = m_fnGetWidget(layHero, "img_star" .. i)
	-- 	imgStar:setEnabled(false)
	-- end

	layHero:setPositionType(0)
	layHero:setPosition(ccp(m_layModelBG:getSize().width + 300, layHero:getPositionY()))
	if (index == 1) then
		layHero:setPosition(ccp(m_layModelBG:getSize().width * 0.5 - layHero:getSize().width * 0.5, layHero:getPositionY()))
	end
	m_layModelBG:addChild(layHero)

	local actionArr = CCArray:create()
	if (index ~= 1) then
		actionArr:addObject(CCMoveTo:create(3, ccp(m_layModelBG:getSize().width / 2, layHero:getPositionY())))
	end
	actionArr:addObject(CCCallFunc:create(function ( ... )
		addHeroView(index + 1)
	end))
	actionArr:addObject(CCMoveTo:create(3, ccp(-300, layHero:getPositionY())))
	actionArr:addObject(CCCallFunc:create(function ()
		layHero:removeFromParentAndCleanup(true)
	end))
	layHero:runAction(CCSequence:create(actionArr))
end


-- 初始化
local function init(...)
	initUIWidget()
end


-- 销毁
function destroy(...)
	package.loaded["SeniorHeroRecruit"] = nil
end


-- 模块名
function moduleName()
	return "SeniorHeroRecruit"
end


-- 创建
function create(...)
	m_UIMain = g_fnLoadUI( "ui/shop_recruit_senior_hero.json" )


	-- 背景图
	m_UIMain.img_bg_1:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_1:setSize(CCSizeMake( m_UIMain.img_bg_1:getSize().width * g_fScaleX,m_UIMain.img_bg_1:getSize().height * g_fScaleX))
	m_UIMain.img_bg_2:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_2:setSize(CCSizeMake( m_UIMain.img_bg_2:getSize().width * g_fScaleX,m_UIMain.img_bg_2:getSize().height * g_fScaleX))
	m_UIMain.img_bg_3:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_3:setSize(CCSizeMake( m_UIMain.img_bg_3:getSize().width * g_fScaleX,m_UIMain.img_bg_3:getSize().height * g_fScaleX))
	m_UIMain.lay_bg:updateSizeAndPosition()

	UIHelper.registExitAndEnterCall(m_UIMain,
				function()
					m_layModelClone:release()
					m_UIMain=nil
				end,
				function()
				end
			)

	init()

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 6) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(7)
	end

	require "script/module/guide/GuideFiveLevelGiftView"
	if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 2) then  
	    require "script/module/guide/GuideCtrl"
	    GuideCtrl.createkFiveLevelGiftGuide(3)
	end

	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_o, mi18n[1161], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_orange_zero, mi18n[1161], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_purple, mi18n[1833], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_orange, mi18n[1834], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_purple_zero, mi18n[1833], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_o_zero, mi18n[1834], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_blue, mi18n[1832], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_purple, mi18n[1833], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_orange, mi18n[1834], ccc3(0x28,0x00,0x00))


	-- 福利活动
	local shopInfo = DataCache.getShopCache()
	local 	nRate = OutputMultiplyUtil.getMultiplyRateNum(8)
	local bIsOpen = RecruitService.isShopDiscountOk()
	if(bIsOpen) then
		m_UIMain.img_sale_bg:setVisible(true)

		local tavernData = DB_Tavern.getDataById(3)
		local curPrice ,sTen = RecruitService.getMidRecruitGold()
		m_UIMain.TFD_SALE_ONE:setText(curPrice)
		local nNormalGold =tavernData.gold_needed
		m_UIMain.tfd_sale_1:setText(sTen .. "折")

		local tenDiscountGold,sTen = RecruitService.getTenRecruitDiscountGold()
		m_UIMain.tfd_sale_2:setText(sTen .. "折")
		m_UIMain.TFD_SALE_TEN:setText(tenDiscountGold)

		if(tonumber(shopInfo.seniorFreeNum ) == 0)then
			m_UIMain.img_sale_1:setVisible(true)
			m_UIMain.img_line_1:setVisible(true)
			m_UIMain.TFD_SALE_ONE:setVisible(true)
			m_UIMain.img_sale_one_gold:setVisible(true)
		else

			m_UIMain.img_sale_1:setVisible(false)
			m_UIMain.img_line_1:setVisible(false)
			m_UIMain.TFD_SALE_ONE:setVisible(false)
			m_UIMain.img_sale_one_gold:setVisible(false)
		end


	else
		m_UIMain.img_sale_bg:setVisible(false)
	end

	return m_UIMain
end


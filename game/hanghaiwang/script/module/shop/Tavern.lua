-- FileName: Tavern.lua
-- Author: menghao
-- Date: 2014-04-25
-- Purpose: 商店tab下的酒馆界面


module("Tavern", package.seeall)

require "script/module/shop/RecruitService"
require "script/module/shop/HeroPreview"
require "script/module/shop/SeniorHeroRecruit"
require "db/DB_Tavern_mystery"
require "db/DB_Tavern"


-- UI控件引用变量 --
local m_UIMain 				-- 招将UI

local m_btnGetLowerHero 	-- 招战将按钮
local m_btnGetSeniorHero 	-- 招神将按钮
local m_btnHeroPreview 		-- 招将预览按钮

local m_imgLowerCostBG
local m_tfdNowOwnReward
local m_tfdNowOwnRewardNum	-- 当前拥有招募令数量
local m_tfdCostReward
local m_tfdCostRewardNum
local m_imgLowerFreeBG
local m_tfdLowerFree

local m_tfdSeniorHeroTime	-- 神将免费剩余时间

local m_imgFirstGetFour		-- 首抽得四星
local m_imgFirstGetFive		-- 首抽得五星

local m_imgSeniorCostBg
local m_tfdSeniorCostGold
local m_imgSeniorCostBgFree
local m_tfdSeniorFree


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local mi18n = gi18n
local m_updateTimeScheduler 		-- 更新时间线程
local m_nlowerItemNum 				-- 招募令数量
local m_isLowerFree
local m_nCostNum

-- local isNotUsed_L
-- local isNotUsed_S
-- local isNotUsed_G

-- 招募令招募后更新招募令数量
function updateItemNum( ... )
	m_nlowerItemNum = m_nlowerItemNum - m_nCostNum
	m_tfdNowOwnRewardNum:setText("(" .. m_nlowerItemNum .. ")")
end


function getItemNum( ... )
	return m_nlowerItemNum
end


-- 更新时间
local function updateTime( )
	local shopInfo = DataCache.getShopCache()

	local dbLower = DB_Tavern.getDataById(1)

	local nFreeTime = dbLower.free_times - tonumber(shopInfo.bronze_recruit_free)
	-- 免费次数已用完
	if (nFreeTime <= 0) then
		m_isLowerFree = false
		m_imgLowerFreeBG:setEnabled(false)
		m_imgLowerCostBG:setEnabled(true)

		m_tfdNowOwnReward:setText(mi18n[1465])
		isNotUsed_L = true
	else -- 免费次数没用完
		local nLeftTime = tonumber(shopInfo.bronze_recruit_time) + dbLower.free_time_cd - TimeUtil.getSvrTimeByOffset()
		-- 免费时间到
		if (nLeftTime < 0) then
			m_isLowerFree = true
			-- if (not isNotUsed_L) then
			m_imgLowerFreeBG:setEnabled(true)
			m_imgLowerCostBG:setEnabled(false)

			m_tfdLowerFree:setText(gi18nString(1466, nFreeTime, dbLower.free_times))

			DataCache.setItemFreeNum(1)
			MainShopView.updateTipTavern()
			-- isNotUsed_L = true
			-- end
		else -- 免费时间没到
			m_isLowerFree = false
			m_imgLowerFreeBG:setEnabled(false)
			m_imgLowerCostBG:setEnabled(true)

			m_tfdNowOwnReward:setText(TimeUtil.getTimeString(nLeftTime) .. mi18n[1407])

			-- isNotUsed_L = false
		end
	end

	if(tonumber(shopInfo.seniorFreeNum)<=0) then
		if(shopInfo.goldExpireTime - TimeUtil.getSvrTimeByOffset() <= 0) then
			-- if (not isNotUsed_G) then
			m_imgFirstGetFive:setEnabled(false)

			DataCache.addGoldFreeNum(1)
			MainShopView.updateTipTavern()

			m_imgSeniorCostBg:setEnabled(false)
			m_imgSeniorCostBgFree:setEnabled(true)
			m_tfdSeniorFree:setText(mi18n[1408])

			-- isNotUsed_G = true
			-- end
		else
			if( tonumber(shopInfo.gold_recruit_num) >= 1 or shopInfo.va_shop.fake)then
				m_imgFirstGetFive:setEnabled(false)
			else
				m_imgFirstGetFive:setEnabled(true)
				--shop_tavern画布中，将IMG_FIRST_GET_FIVE隐藏 2015-11-26 10：20
				-- m_imgFirstGetFive:setEnabled(false)
				--又改回去   2015-11-26 10：53
			end

			m_imgSeniorCostBg:setEnabled(true)
			m_imgSeniorCostBgFree:setEnabled(false)
			local time_str = TimeUtil.getTimeString(shopInfo.goldExpireTime - TimeUtil.getSvrTimeByOffset())
			m_tfdSeniorHeroTime:setText(time_str .. mi18n[1407])
			-- isNotUsed_G = false
		end
	end


	if(tonumber(shopInfo.mySteryFreeNum)<=0) then
		if(shopInfo.MysteryExpireTime - TimeUtil.getSvrTimeByOffset() <= 0) then

			DataCache.addMysteryFreeNum(1)
			MainShopView.updateTipTavern()

			m_UIMain.img_mystery_hero_cost_bg:setEnabled(false)
			m_UIMain.img_mys_cost_free:setEnabled(true)
			m_UIMain.TFD_MYS_HERO_FREE:setText(mi18n[1408])

		else
			m_UIMain.img_mystery_hero_cost_bg:setEnabled(true)
			m_UIMain.img_mys_cost_free:setEnabled(false)

			local time_str = TimeUtil.getTimeString(shopInfo.MysteryExpireTime - TimeUtil.getSvrTimeByOffset())
			m_UIMain.tfd_mystery_time:setText(time_str .. mi18n[1407])
			-- isNotUsed_G = false
		end
	end

	-- if(isNotUsed_L and isNotUsed_G and isNotUsed_S) then
	-- stopScheduler()
	-- end
end


-- 启动scheduler
function startScheduler()
	if(m_updateTimeScheduler == nil) then
		m_updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTime, 1, false)
	end
end


-- 停止scheduler
function stopScheduler()
	if(m_updateTimeScheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateTimeScheduler)
		m_updateTimeScheduler = nil
	end
end


-- 百万招募事件响应
function getLowerClicked( fnLessItemCall ,_bNoPlaySound)
	if(_bNoPlaySound == nil) then

		AudioHelper.playSpecialEffect("zhaomu.mp3")
	end
	if(m_nlowerItemNum <= 0 and (not m_isLowerFree))then
		ShowNotice.showShellInfo(mi18n[1409]) -- 没有招募令也没免费次数

	else
		if (m_isLowerFree) then
			m_nCostNum = 0
		else
			m_nCostNum = 1
		end
		RequestCenter.shop_bronzeRecruit(RecruitService.lowerRecruitCallback)
		if(fnLessItemCall)then
			fnLessItemCall()
		end
	end
end

local function onGetLowerHero( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- AudioHelper.playSpecialEffect("zhaomu.mp3")
		-- AudioHelper.playCommonEffect()
		getLowerClicked()
	end
end


-- 亿万招募事件响应
local function onGetSeniorHero( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playSpecialEffect("zhaomu.mp3")
		local laySeniorHeroRecruit = SeniorHeroRecruit.create()
		LayerManager.addLayout(laySeniorHeroRecruit)
	end
end


-- 招将预览事件响应
local function onHeroPreview( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		HeroPreview.create(3)
	end
end
--判断神秘招募是否配置了时间段
local function isOpenMystery( )

	local time = TimeUtil.getSvrTimeByOffset()
	time = tonumber(time)
	local format = "%Y%m%d%H%M%S"
    local pei = tonumber(TimeUtil.getLocalOffsetDate(format,time) ) 

	local tbCount = table.count(DB_Tavern_mystery.Tavern_mystery)

	for i=1,tbCount do
		local mysteryInfo 	= DB_Tavern_mystery.getDataById(i) 
		local endtime 		=   mysteryInfo["end"]
        local start   		=   mysteryInfo.start
        logger:debug(start)
        logger:debug(pei)
        logger:debug(endtime)
        if((pei > tonumber(start))  and  (tonumber(endtime) > pei)) then
        	return true
   		end
	end
	return false
end

local function setMysteryLabel(_shopInfo)
	if( tonumber(_shopInfo.mySteryFreeNum ) > 0 )then
		m_UIMain.img_mystery_hero_cost_bg:setEnabled(false)
		m_UIMain.TFD_MYS_HERO_FREE:setText(mi18n[1408])
	else
		m_UIMain.img_mys_cost_free:setEnabled(false)
		local strTime = TimeUtil.getTimeString(_shopInfo.MysteryExpireTime - TimeUtil.getSvrTimeByOffset())
		m_UIMain.tfd_mystery_time:setText(strTime .. mi18n[1407])

	end
end

-- 初始化UI中的各个控件
local function initUIWidget( )
	-- 准备数据
	local shopInfo = DataCache.getShopCache()
	logger:debug("tavernshopInfo")
	logger:debug(shopInfo)

	-- 四个按钮
	m_btnGetLowerHero = m_fnGetWidget(m_UIMain, "BTN_GET_LOWER_HERO")
	m_btnGetSeniorHero = m_fnGetWidget(m_UIMain, "BTN_GET_SENIOR_HERO")
	m_btnHeroPreview = m_fnGetWidget(m_UIMain, "BTN_HERO_VIEW")

	m_btnGetLowerHero:addTouchEventListener(onGetLowerHero)
	m_btnGetSeniorHero:addTouchEventListener(onGetSeniorHero)
	m_btnHeroPreview:addTouchEventListener(onHeroPreview)

	UIHelper.titleShadow(m_btnHeroPreview, mi18n[1404])

	-- 百万招募
	m_imgLowerCostBG = m_fnGetWidget(m_UIMain, "img_lower_hero_cost_bg")
	m_tfdNowOwnReward = m_fnGetWidget(m_UIMain, "TFD_NOW_OWN_REWARD")
	m_tfdNowOwnRewardNum = m_fnGetWidget(m_UIMain, "TFD_ITEM_NUM")
	m_tfdCostReward = m_fnGetWidget(m_UIMain, "TFD_COST_REWARD")
	m_tfdCostRewardNum = m_fnGetWidget(m_UIMain, "TFD_COST_REWARD_NUM")
	m_imgLowerFreeBG = m_fnGetWidget(m_UIMain, "img_lower_hero_bg_free")
	m_tfdLowerFree = m_fnGetWidget(m_UIMain, "TFD_LOWER_HERO_FREE")

	UIHelper.labelNewStroke(m_tfdNowOwnReward)
	UIHelper.labelNewStroke(m_tfdNowOwnRewardNum)
	UIHelper.labelNewStroke(m_tfdCostReward)
	UIHelper.labelNewStroke(m_tfdCostRewardNum)
	UIHelper.labelNewStroke(m_tfdLowerFree)

	-- m_tfdNowOwnReward:setText(mi18n[1321])
	m_tfdCostReward:setText(mi18n[1405])
	m_tfdCostRewardNum:setText(mi18n[1406])

	local dbLower = DB_Tavern.getDataById(1)
	local itemArr = string.split(dbLower.cost_item, "|")
	m_nlowerItemNum = tonumber(ItemUtil.getCacheItemNumBy(tonumber(itemArr[1])))
	m_tfdNowOwnRewardNum:setText("(" .. m_nlowerItemNum .. ")")

	m_isLowerFree = false
	local nFreeTime = dbLower.free_times - tonumber(shopInfo.bronze_recruit_free)
	if (nFreeTime <= 0) then -- 免费次数已用完
		m_imgLowerFreeBG:setEnabled(false)
		m_tfdNowOwnReward:setText(mi18n[1465])
	else -- 免费次数没用完
		local nLeftTime = tonumber(shopInfo.bronze_recruit_time) + dbLower.free_time_cd - TimeUtil.getSvrTimeByOffset()
		if (nLeftTime < 0) then -- 免费时间到
			m_imgLowerCostBG:setEnabled(false)
			m_tfdLowerFree:setText(gi18nString(1466, nFreeTime, dbLower.free_times))
			m_isLowerFree = true
		else -- 免费时间没到
			m_imgLowerFreeBG:setEnabled(false)
			m_tfdNowOwnReward:setText(TimeUtil.getTimeString(nLeftTime) .. mi18n[1407])
		end
	end



	m_imgFirstGetFive = m_fnGetWidget(m_UIMain, "IMG_FIRST_GET_FIVE")
	m_tfdSeniorHeroTime = m_fnGetWidget(m_UIMain, "TFD_SENIOR_HERO_TIME")
	m_tfdSeniorCostGold = m_fnGetWidget(m_UIMain ,"TFD_SENIOR_HERO_COST_GOLD")
	m_imgSeniorCostBg = m_fnGetWidget(m_UIMain, "img_senior_hero_cost_bg")
	m_imgSeniorCostBgFree = m_fnGetWidget(m_UIMain, "img_senior_hero_cost_bg_free")
	m_tfdSeniorFree = m_fnGetWidget(m_UIMain, "TFD_SENIOR_HERO_FREE")
	UIHelper.labelNewStroke(m_tfdSeniorHeroTime)
	UIHelper.labelNewStroke(m_tfdSeniorCostGold)
	UIHelper.labelNewStroke(m_tfdSeniorFree)

	if( tonumber(shopInfo.seniorFreeNum ) > 0 )then
		m_imgFirstGetFive:setEnabled(false)
		m_imgSeniorCostBg:setEnabled(false)
		m_tfdSeniorFree:setText(mi18n[1408])
	else
		if( tonumber(shopInfo.gold_recruit_num) >= 1 or shopInfo.va_shop.fake)then
			m_imgFirstGetFive:setEnabled(false)
		end
		m_imgSeniorCostBgFree:setEnabled(false)
		local strTime = TimeUtil.getTimeString(shopInfo.goldExpireTime - TimeUtil.getSvrTimeByOffset())
		m_tfdSeniorHeroTime:setText(strTime .. mi18n[1407])
		local dbSenior = DB_Tavern.getDataById(3)
		m_tfdSeniorCostGold:setText(dbSenior.gold_needed)
	end

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideFiveLevelGiftView"
	if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createkFiveLevelGiftGuide(2)
	end
	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 5) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(6)
	end

	require "db/DB_Vip"
	local dbVipInfo = DB_Vip.getDataById(UserModel.getVipLevel())
	-- 如果神秘招募已开启
	local btnGetMysteryHero = m_fnGetWidget(m_UIMain, "BTN_GET_MYSTERY_HERO")
	local bRightTime 		= true --isOpenMystery()
	local bOpenSwitch 		= SwitchModel.getSwitchOpenState(ksSwitchMysteryShop)
	if (tonumber(dbVipInfo.mystical_tavern) == 1 and bRightTime and bOpenSwitch) then
		


		UIHelper.labelNewStroke(m_UIMain.tfd_mystery_time)
		UIHelper.labelNewStroke(m_UIMain.TFD_MYS_HERO_FREE)
		-- UIHelper.labelNewStroke(m_UIMain.m_tfdSeniorFree)

		local nCost = DB_Tavern_mystery.getDataById(1).cost
		local tfdMysCostGold = m_fnGetWidget(m_UIMain, "TFD_MYSTERY_HERO_COST_GOLD")
		UIHelper.labelNewStroke(tfdMysCostGold)
		tfdMysCostGold:setText(nCost)
		btnGetMysteryHero:addTouchEventListener(
			function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					-- AudioHelper.playCommonEffect()
					AudioHelper.playSpecialEffect("zhaomu.mp3")
					RecruitService.getMysClicked()
				end
			end
		)

		setMysteryLabel(shopInfo)
	else
		btnGetMysteryHero:setEnabled(false)
		local imgplace1 = m_fnGetWidget(m_UIMain, "img_place_1")
		local imgplace2 = m_fnGetWidget(m_UIMain, "img_place_2")
		m_btnGetLowerHero:runAction(
			CCPlace:create(
				ccp(imgplace1:getPosition())
			)
		)
		m_btnGetSeniorHero:runAction(
			CCPlace:create(
				ccp(imgplace2:getPosition())
			)
		)
	end
end


function setDiscountUI(  )
	-- 亿万招募免费时间、首抽标识等
	local shopInfo = DataCache.getShopCache()
	local bIsOpen = RecruitService.isShopDiscountOk()
	if(bIsOpen and tonumber(shopInfo.seniorFreeNum ) == 0 ) then
		m_UIMain.img_sale_bg:setVisible(true)

		local curPrice,sTen = RecruitService.getMidRecruitGold()
		m_UIMain.TFD_SALE_GOLD:setText(curPrice)

		local nNormalGold = DB_Tavern.getDataById(3).gold_needed
		m_UIMain.img_sale_bg.TFD_SENIOR_HERO_COST_GOLD:setText(nNormalGold)

		m_UIMain.TFD_SALE_NUM:setText(sTen)
		m_UIMain.img_sale_bg.TFD_SENIOR_HERO_TIME:setVisible(false)
		m_UIMain.TFD_SENIOR_HERO_COST_GOLD:setVisible(false)
		m_UIMain.img_senior_hero_gold:setVisible(false)


		UIHelper.labelNewStroke(m_UIMain.TFD_SALE_GOLD)
		UIHelper.labelNewStroke(m_UIMain.TFD_SALE_NUM)
		UIHelper.labelNewStroke(m_UIMain.img_sale_bg.TFD_SENIOR_HERO_COST_GOLD)
	else
		m_UIMain.img_sale_bg:setVisible(false)
	end
end

local function init(...)
	initUIWidget()
	startScheduler()
	setDiscountUI()
end


function destroy(...)
	package.loaded["Tavern"] = nil
end


function moduleName()
	return "Tavern"
end


function create()
	m_UIMain = g_fnLoadUI("ui/shop_tavern.json")

	init()
	UIHelper.registExitAndEnterCall(m_UIMain, stopScheduler)
	m_UIMain.img_bg:setScale(g_fScaleX)

	local newFlag = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/bar_bg.ExportJson",
		animationName = "bar_bg",
	})
	-- newFlag:setAnchorPoint(ccp(0.0, 0.0))
	newFlag:setPosition(ccp(0,0))
	m_UIMain.img_bg:addNode(newFlag)

	return m_UIMain
end


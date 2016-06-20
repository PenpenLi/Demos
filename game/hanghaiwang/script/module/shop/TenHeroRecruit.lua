-- FileName: TenHeroRecruit.lua
-- Author: menghao
-- Date: 2014-04-30
-- Purpose: 神将十连抽显示


module("TenHeroRecruit", package.seeall)


-- require "script/utils/CardTurnView"


-- UI控件引用变量 --
local m_UIMain = nil

local m_imgBG

local m_btnRecruitOne
local m_btnRecruitTen
local m_btnQuit
local m_btnShare

local m_tfdBeShadow

local m_layRecruitTen

local m_labnOneCostGold
local m_labnTenCostGold

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


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnAddStroke = UIHelper.labelNewStroke

local fnHandlerOfNetworkRecruitOne
local fnHandlerOfNetworkRecruitTen

local mi18n = gi18n
local m_i18nString = gi18nString
local m_numOfTenRecuit
local m_costGoldOfTen

local m_allHeroes
local m_hasShadow
local m_arrObjsCardShow

local m_nNum
local m_callBack

local nProgressTag = 876
local nPreLuckPoint = 0

local function setBtnTouchEnabled( bValue )
	if (m_nNum == 10) then
		m_btnRecruitOne:setTouchEnabled(bValue)
		m_btnRecruitTen:setTouchEnabled(bValue)
		m_btnShare:setTouchEnabled(bValue)
		m_btnQuit:setTouchEnabled(bValue)
	elseif (m_nNum == 6) then
		m_UIMain.BTN_TURE:setTouchEnabled(bValue)
		m_UIMain.BTN_RECRUIT:setTouchEnabled(bValue)
	end
end


-- 四个按钮监听事件
local function onRecruitOne( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		
		local shopInfo = DataCache.getShopCache()
		if (tonumber(shopInfo.seniorFreeNum) > 0) then
			AudioHelper.playCommonEffect()
			local args = Network.argsHandler(0, 1)
			RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitOne, args)
		else
			
			-- local db_tavern = DB_Tavern.getDataById(3)
			local nGoldCost = RecruitService.getOneCostGold()
			if (UserModel.getGoldNumber() >= (nGoldCost)) then
				local args = Network.argsHandler(1, 1)
				AudioHelper.playBuyGoods()
				RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitOne, args)
			else
				AudioHelper.playCommonEffect()
				local layDlg = UIHelper.createNoGoldAlertDlg()
				LayerManager.addLayout(layDlg)
			end
		end
	end
end


local function onRecruitTen( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		-- local db_tavern = DB_Tavern.getDataById(3)
		local tenCost = RecruitService.getTenCostGold()
		
		if (UserModel.getGoldNumber() >= tenCost) then
			local args = Network.argsHandler(1, m_numOfTenRecuit)
			RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitTen, args)
		else
			local layDlg = UIHelper.createNoGoldAlertDlg()
			LayerManager.addLayout(layDlg)
		end
	end
end


local function onQuit( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()

	end
end


local function onShare( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then

	end
end


-- 增加卡牌形象显示
function addHeroCardShow(  )
	
	local tbImgCard = {}
	local imgForCopy = m_fnGetWidget(m_UIMain, "IMG_RECRUIT_CARD_OPP1")
	if m_allHeroes then
		local tbTurnCards = {}
		local tbHeroQualitys = {}
		-- local sIndex = 1
		local function openAllCard( i )
			if (i > m_nNum) then

				--如果是神秘招募，则开始播放进度条的动画和票字动画
				if(m_nNum == 6) then
					setLuckProgress()
				end

				setBtnTouchEnabled(true)
				PreRequest.setIsCanShowAchieveTip(true)
				for i=1,m_nNum do
					local tCardOpp = m_fnGetWidget(m_UIMain, "IMG_RECRUIT_CARD_OPP" .. i)
					tCardOpp:setTouchEnabled(true)
				end
				return
			end
			local db_hero
			if (m_allHeroes[i].iType == 1 or m_allHeroes[i].iType == 2) then
				db_hero = DB_Heroes.getDataById(m_allHeroes[i].tid)
			else
				db_hero = ItemUtil.getItemById(m_allHeroes[i].tid)
				db_hero.potential = db_hero.quality
			end

			local tCardOpp = m_fnGetWidget(m_UIMain, "IMG_RECRUIT_CARD_OPP" .. i)
			local posX, posY = tCardOpp:getPosition()

			local imgCard = tolua.cast(imgForCopy:clone(), "ImageView")
			imgCard:loadTexture("images/base/potential/input_name_bg1.png")
			local imgHeroI = m_fnGetWidget(imgCard, "IMG_RECRUIT_SENIOR_HERO1")

			local imgHeroBG = ImageView:create()
			imgHeroBG:loadTexture("images/common/hero_show/quality/" .. db_hero.potential .. ".png")
			imgHeroI:addChild(imgHeroBG)

			logger:debug({m_allHeroes = m_allHeroes[i]})
			local imgHero = ImageView:create()
			if (m_allHeroes[i].iType == 1 or m_allHeroes[i].iType == 2) then
				imgHero:loadTexture("images/base/hero/body_img/" .. db_hero.body_img_id)
				imgHero:setAnchorPoint(ccp(0.5, 0))
				-- imgHero:setScale(0.35)
				imgHero:setPosition(ccp(0, -imgHeroI:getSize().height / 2))
			else
				imgHero:loadTexture(db_hero.iconBigPath)
				if (db_hero.isHeroFragment) then
					imgHero:setAnchorPoint(ccp(0.5, 0))
					imgHero:setPosition(ccp(0, -imgHeroI:getSize().height / 2))
				end
			end
			imgHeroI:addChild(imgHero)

			-- tbImgCard[i] = imgHeroBG

			local tfdHeroName = m_fnGetWidget(imgCard, "TFD_RECRUIT_HERO_NAME1")
			tfdHeroName:setColor(g_QulityColor2[db_hero.potential])
			if (tonumber(db_hero.potential) >= 5 and (m_allHeroes[i].iType == 1 or m_allHeroes[i].iType == 2)) then
				tbHeroQualitys[i] = true
			else
				tbHeroQualitys[i] = false
			end
			tfdHeroName:setText(db_hero.name)
			m_fnAddStroke(tfdHeroName)
			-- 是不是影子
			local imgBeShadow = m_fnGetWidget(imgCard, "IMG_SHADOW_TIPS_1")
			local tfdShadowNum = m_fnGetWidget(imgCard, "TFD_NUM")
			tfdShadowNum:setText("x" .. m_allHeroes[i].num)
			m_fnAddStroke(tfdShadowNum)
			tfdShadowNum:setZOrder(10000)
			-- local imgNumBG = m_fnGetWidget(imgCard, "img_num_bg_1")
			if (m_allHeroes[i].iType == 2 or db_hero.isSpeTreasureFragment or db_hero.isHeroFragment or db_hero.isTreasureFragment or db_hero.isFragment ) then
				imgBeShadow:setZOrder(1000)
				if (db_hero.isTreasureFragment or db_hero.isFragment or db_hero.isSpeTreasureFragment) then
					imgBeShadow:loadTexture("images/common/recruit_fragment.png")
				end
				if(db_hero.isHeroFragment) then
					imgBeShadow:loadTexture("ui/tips_shadow.png")
				end
			else
				logger:debug("伙伴来了")
				imgBeShadow:setVisible(false)
			end
			--201505026 王晓静说如果招募到的是伙伴的话，不显示这个数字
			if(m_allHeroes[i].iType == 1) then
				logger:debug("伙伴的话删除个数控件")
				tfdShadowNum:setVisible(false)
			end
			tCardOpp:addTouchEventListener(function( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					if (m_allHeroes[i].iType == 1 or m_allHeroes[i].iType == 2) then
						db_hero.hid = m_allHeroes[i].hid
						require "script/module/partner/PartnerInfoCtrl"
				        local pHeroValue = db_hero --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
				        local heroInfo = {htid = db_hero.fragment ,hid = 0,strengthenLevel = 0 ,transLevel = 0,showOnly = true }
				        local tArgs = {}
				        tArgs.heroInfo = heroInfo
				        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
				        LayerManager.addLayoutNoScale(layer)

					else
						PublicInfoCtrl.createItemInfoViewByTid(m_allHeroes[i].tid, m_allHeroes[i].num)
					end
				end
			end)

			-- local turnCard = CardTurnView:create(imgCard , imgCardOpp)
			-- tCardOpp:removeFromParent()
			tCardOpp:setVisible(false)
			local armatureZhaomu2 = UIHelper.createArmatureNode({
				filePath = "images/effect/shop_recruit/zhaomu2.ExportJson",
				animationName = "zhaomu2",
				loop = 0,
				fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					if (frameEventName == "1") then
						if (not tbHeroQualitys[i]) then
							
							openAllCard(i + 1)
						end
						
					elseif(frameEventName == "2") then
						imgCard:setEnabled(true)
					end
				end
			})

			if (m_nNum == 6) then
				armatureZhaomu2:setScale(1.25)
				imgCard:setScale(1.0 / 1.25)
				
			end

			imgCard:setPosition(ccp(0, 0))
			imgCard:setEnabled(true)
			AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
			armatureZhaomu2:getBone("Layer1"):addDisplay(imgCard, 0)
			imgCard:setEnabled(false)
			
			armatureZhaomu2:setPosition(ccp(posX, posY))
			-- armatureZhaomu2:getAnimation():setSpeedScale(0.15)
			-- armatureZhaomu2:getAnimation():setSpeedScale(0.10)

			m_layRecruitTen:addNode(armatureZhaomu2)
			if (tbHeroQualitys[i]) then
				local armatureZhaomu3 = UIHelper.createArmatureNode({
					filePath = "images/effect/shop_recruit/zhaomu3.ExportJson",
					animationName = "zhaomu3",
					loop = 0,
					fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
						if (frameEventName == "2") then
							HeroDisplay.create(m_allHeroes[i], 4, function ( ... )
								openAllCard(i + 1)
							end)
						end
					end,
					fnMovementCall = function ( sender, MovementEventType , frameEventName)
						if (MovementEventType == 1) then
							sender:removeFromParentAndCleanup(true)
						end
					end,
				})
				armatureZhaomu3:setPosition(ccp(posX, posY))
				m_layRecruitTen:addNode(armatureZhaomu3)

				local armatureZhaomu4 = UIHelper.createArmatureNode({
					filePath = "images/effect/shop_recruit/zhaomu4.ExportJson",
					animationName = "zhaomu4",
				-- loop = 0,
				})
				armatureZhaomu4:setPosition(ccp(posX, posY))
				m_layRecruitTen:addNode(armatureZhaomu4)
			end
		end

		openAllCard(1)
	end
end



-- 设置英雄数据
function setAllHeroes( tHeroes)
	logger:debug(tHeroes)
	m_hasShadow = false
	m_allHeroes = {}

	for k, oneInfo in pairs(tHeroes) do
		if (oneInfo.hero) then
			for k,v in pairs(oneInfo.hero) do
				table.insert(m_allHeroes, {tid = tonumber(v), num = 1, iType = 1, hid = tonumber(k)})
			end
		end

		if (oneInfo.heroFrag) then
			for k,v in pairs(oneInfo.heroFrag) do
				local dbHeroFrag = DB_Item_hero_fragment.getDataById(k)
				local htid = tonumber(dbHeroFrag.aimItem)
				local tNum = tonumber(v)
				local _hid = HeroModel.getHidByHtid(htid)
				table.insert(m_allHeroes, {tid = htid, num = tNum, iType = 2, hid = tonumber(_hid)})
				m_hasShadow = true
			end
		end

		if (oneInfo.item) then
			for k,v in pairs(oneInfo.item) do
				table.insert(m_allHeroes, {tid = tonumber(k), num = tonumber(v), iType = 3})
			end
		end

		if (oneInfo.treasFrag) then
			for k,v in pairs(oneInfo.treasFrag) do
				table.insert(m_allHeroes, {tid = tonumber(k), num = tonumber(v), iType = 4})
			end
		end
	end
end


local function preAnimation( ... )
	local layHero1 = m_fnGetWidget(m_UIMain, "img_black_bg1")
	-- local layHero1 = m_fnGetWidget(m_UIMain, "img_black_bg1")
	layHero1:setVisible(false)
	local tbImgCard = {}
	for i=1,m_nNum do
		local imgCard = m_fnGetWidget(m_UIMain, "IMG_RECRUIT_CARD_OPP" .. i)
		tbImgCard[i] = imgCard
	end
	for i=1,m_nNum do
		local acitonArray = CCArray:create()
		acitonArray:addObject(CCDelayTime:create(0.08 * i))
		acitonArray:addObject(CCCallFunc:create(function ( ... )
			tbImgCard[i]:setVisible(true)
			AudioHelper.playTabEffect() -- zhangqi, 2015-12-31, 为了消除重复音效文件换用同效果的另一个音效
		end))
		acitonArray:addObject(CCScaleTo:create(0.078, 1))
		tbImgCard[i]:runAction(CCSequence:create(acitonArray))
		
	end
	local afterArr = CCArray:create()
	afterArr:addObject(CCDelayTime:create(1))
	afterArr:addObject(CCCallFunc:create(function ( ... )
		layHero1:setVisible(true)
		-- layHero1:setZOrder(100)
		addHeroCardShow()

	end))
	m_UIMain:runAction(CCSequence:create(afterArr))
end


-- 初始化UI控件
local function initUIWidget( ... )
	-- 获取控件
	m_tfdBeShadow = m_fnGetWidget(m_UIMain, "tfd_be_shadow")
	UIHelper.labelNewStroke(m_tfdBeShadow,ccc3(0x00,0x00,0x00), 2)

	m_layBeShadow = m_fnGetWidget(m_UIMain, "lay_be_shadow")

	if (m_nNum == 10) then

		m_imgBG = m_fnGetWidget(m_UIMain, "img_top_shop_recruit_senior_hero_ten_bg")

		m_btnRecruitOne = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_ONE")
		m_btnRecruitTen = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_TEN")
		m_btnQuit = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_TEN_EXIT")
		m_btnShare = m_fnGetWidget(m_UIMain, "BTN_RECRUIT_SENIOR_HERO_TEN_SHARE")



		m_layRecruitTen = m_fnGetWidget(m_UIMain, "lay_recruit_senior_hero_ten")

		m_labnOneCostGold = m_fnGetWidget(m_UIMain, "TFD_RECRUIT_SENIOR_HERO_ONE_COST")
		m_labnTenCostGold = m_fnGetWidget(m_UIMain, "TFD_RECRUIT_SENIOR_HERO_TEN_COST")


		local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
		-- m_imgBG:setScale(fScale)

		m_tfdBeShadow:setText(mi18n[1457])
		m_fnAddStroke(m_tfdBeShadow, ccc3(0x00,0x00,0x00), 2)
		-- m_fnAddStroke(m_tfdBeShadow, ccc3(0x00,0x00,0x00), 2)
		m_layBeShadow:setEnabled(m_hasShadow)

		local db_tavern = DB_Tavern.getDataById(3)
		m_numOfTenRecuit = tonumber(lua_string_split(db_tavern.gold_nums, "|")[1])
		m_costGoldOfTen = tonumber(lua_string_split(db_tavern.gold_nums, "|")[2])


		m_labnOneCostGold:setText(db_tavern.gold_needed)
		m_labnTenCostGold:setText(m_costGoldOfTen)

		RecruitService.initMustBePurpleTip(m_UIMain)


		-- 按钮监听
		m_btnRecruitOne:addTouchEventListener(onRecruitOne)
		m_btnRecruitTen:addTouchEventListener(onRecruitTen)
		m_btnQuit:addTouchEventListener(onQuit)
		m_btnShare:addTouchEventListener(onShare)

		UIHelper.titleShadow(m_btnRecruitOne, mi18n[1448])
		UIHelper.titleShadow(m_btnRecruitTen, mi18n[1449])
		UIHelper.titleShadow(m_btnQuit, mi18n[1447])
		UIHelper.titleShadow(m_btnShare, mi18n[1333])
	elseif (m_nNum == 6) then
		m_btnRecruitOne = nil
		m_btnRecruitTen = nil
		m_btnQuit = nil
		m_btnShare = nil

		m_layRecruitTen = m_fnGetWidget(m_UIMain, "lay_recruit")
		m_UIMain.tfd_recruit:setText(mi18n[1474]) --本次招募必得
		m_UIMain.tfd_or:setText(mi18n[1222])  --"或"
		m_UIMain.tfd_hot_hero:setText(mi18n[1475])  --"热点伙伴"
		m_UIMain.tfd_hot_shadow:setText(mi18n[1476])  --"热点伙伴影子"

		m_UIMain.tfd_most:setText(mi18n[4802])  --"每日最多可获得45"
		m_UIMain.TFD_FRAG_NAME:setText(MysRecruitView.getTreasName() .. mi18n[2448])  --"宝物碎片"


		m_UIMain.img_pro_bg:setEnabled(false)

		m_UIMain.lay_mym_txt_1:setEnabled(false)
		m_UIMain.lay_mym_txt_2:setEnabled(false)

		m_UIMain.tfd_recruit_mym_next:setText(m_i18nString(1479))  --[1479] = "本次招募必得",
		m_UIMain.tfd_recruit_mym:setText(m_i18nString(1478))  		--[1478] = "招募必得幸运值，幸运值满后下次招募必得",

		m_UIMain.tfd_own:setText(m_i18nString(1321))  --[1321] = 当前拥有
		m_UIMain.tfd_shadow_num:setText("影子数量:" .. MysRecruitView.getWeekHotHeroNum())  		--[1478] = 影子数量：99

		m_UIMain.tfd_hot_hero_name_next:setText(MysRecruitView.getWeekHotHeroName())  --艾斯
		m_UIMain.tfd_hot_hero_name:setText(MysRecruitView.getWeekHotHeroName())  --艾斯
		m_UIMain.tfd_own_name:setText(MysRecruitView.getWeekHotHeroName())  --艾斯
		m_UIMain.TFD_LUCK:setText("幸运值:")  --艾斯


		UIHelper.labelNewStroke(m_UIMain.tfd_hot_hero_name_next, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_recruit_mym_next, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_recruit_mym, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_hot_hero_name, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.TFD_LUCK, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_own_name, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_own, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_shadow_num, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.TFD_LUCK, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_luck_num_1, ccc3(0x28,0x00,0x00), 2 )
		UIHelper.labelNewStroke(m_UIMain.tfd_luck_num_2, ccc3(0x28,0x00,0x00), 2 )


		local nMaxValue = MysRecruitView.getMaxLuckValue()
		local tbShopInfo = DataCache.getShopCache()
		local nCurLuck = tonumber(tbShopInfo.mystery_recruit_point )
		local  percent2  = nCurLuck / nMaxValue * 100
		percent2 = percent2 > 100 and 100 or percent2

		if(percent2 == 100) then
			m_UIMain.lay_mym_txt_2:setEnabled(true)
		else
			m_UIMain.lay_mym_txt_1:setEnabled(true)
		end





		UIHelper.labelNewStroke(m_UIMain.tfd_hot_shadow,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelNewStroke(m_UIMain.tfd_or,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelNewStroke(m_UIMain.tfd_hot_hero,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelNewStroke(m_UIMain.tfd_recruit,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelNewStroke(m_UIMain.tfd_most,ccc3(0x28,0x00,0x00), 2)
		UIHelper.labelNewStroke(m_UIMain.TFD_FRAG_NAME,ccc3(0x28,0x00,0x00), 2)

		local nCost = DB_Tavern_mystery.getDataById(1).cost
		m_UIMain.TFD_GOLD:setText(nCost)
		UIHelper.labelNewStroke(m_UIMain.TFD_GOLD, ccc3(0x00,0x00,0x00), 2 )

		m_UIMain.BTN_TURE:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
				if (m_callBack) then
					logger:debug({onQuit_m_callBack = m_callBack})
					m_callBack()
				end
			end
		end)
		UIHelper.titleShadow(m_UIMain.BTN_TURE, mi18n[1324])

		m_UIMain.BTN_RECRUIT:addTouchEventListener(MysRecruitCtrl.onRecruit)
		UIHelper.titleShadow(m_UIMain.BTN_RECRUIT, mi18n[5477]) -- "再招1次"

	end


	for i=1,m_nNum do
		local imgCard = m_fnGetWidget(m_UIMain, "IMG_RECRUIT_CARD_OPP" .. i)
		imgCard:setVisible(false)
		imgCard:setScale(1.5)
	end
end


function showAllHero( ... )
	preAnimation()
end


-- 初始化
local function init(...)

	fnHandlerOfNetworkRecruitOne = RecruitService.seniorRecruitCallback
	fnHandlerOfNetworkRecruitTen = SeniorHeroRecruit.fnHandlerOfNetworkRecruitTen

	initUIWidget()
	setBtnTouchEnabled(false)
end


-- 销毁
function destroy(...)
	package.loaded["TenHeroRecruit"] = nil
end


-- 模块名称
function moduleName()
	return "TenHeroRecruit"
end


-- 福利活动相关
local function setDiscountUI(  )
	-- 福利活动
	local shopInfo = DataCache.getShopCache()
 	local bIsOpen = RecruitService.isShopDiscountOk()
	if(bIsOpen ) then
		m_UIMain.lay_sale_bg:setVisible(true)
		local tavernData = DB_Tavern.getDataById(3)

		local curPrice ,sTen= RecruitService.getMidRecruitGold()
		m_UIMain.TFD_SALE_ONE_NUM:setText(curPrice)
		m_UIMain.tfd_sale_1:setText(sTen .. "折")
		
		local tenDiscountGold,sTen1 = RecruitService.getTenRecruitDiscountGold()
		m_UIMain.tfd_sale_2:setText(sTen1 .. "折")
		m_UIMain.TFD_SALE_TEN_NUM:setText(tenDiscountGold)

	else
		m_UIMain.lay_sale_bg:setVisible(false)
	end
end

-- 创建
function create(num,callBack)
		m_UIMain = nil
	m_nNum = num or 10
	m_callBack = callBack

	PreRequest.setIsCanShowAchieveTip(false)
	if (m_nNum == 10) then
		m_UIMain = g_fnLoadUI("ui/shop_recruit_senior_hero_ten.json")

		UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_o, mi18n[1161], ccc3(0x28,0x00,0x00))
		UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_orange_zero, mi18n[1161], ccc3(0x28,0x00,0x00))
		UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_purple, mi18n[1833], ccc3(0x28,0x00,0x00))
		UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_orange, mi18n[1834], ccc3(0x28,0x00,0x00))
		UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_purple_zero, mi18n[1833], ccc3(0x28,0x00,0x00))
		UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_o_zero, mi18n[1834], ccc3(0x28,0x00,0x00))

		setDiscountUI()
	else
		m_UIMain = g_fnLoadUI("ui/mystery_recruit.json")



		UIHelper.registExitAndEnterCall(m_UIMain,
					function()
						stopAllAction()
					end,
					function()
					end
				) 

	end

	-- 背景图
	m_UIMain.img_bg_1:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_1:setSize(CCSizeMake( m_UIMain.img_bg_1:getSize().width * g_fScaleX,m_UIMain.img_bg_1:getSize().height * g_fScaleX))
	m_UIMain.img_bg_2:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_2:setSize(CCSizeMake( m_UIMain.img_bg_2:getSize().width * g_fScaleX,m_UIMain.img_bg_2:getSize().height * g_fScaleX))
	m_UIMain.img_bg_3:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_3:setSize(CCSizeMake( m_UIMain.img_bg_3:getSize().width * g_fScaleX,m_UIMain.img_bg_3:getSize().height * g_fScaleX))
	m_UIMain.lay_bg:updateSizeAndPosition()



	init()

	local armature = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao1.ExportJson",
		animationName = "zhao1_2",
		loop = 0,
		fnMovementCall = function ( sender, MovementEventType , frameEventName)
			if (MovementEventType == 1) then
				sender:removeFromParentAndCleanup(true)
			end
		end,
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if frameEventName == "3" then
				local armatureZhaomu1 = UIHelper.createArmatureNode({
					filePath = "images/effect/shop_recruit/zhaomu1.ExportJson",
					animationName = "zhaomu1",
					loop = 0,
					fnMovementCall = function ( sender, MovementEventType , frameEventName)
						if (MovementEventType == 1) then
							logger:debug("fnMovementCall zhaomu1")
							showAllHero()
							sender:removeFromParentAndCleanup(true)
						end
					end,
				})
				armatureZhaomu1:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2))
				local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
				armatureZhaomu1:setScale(fScale)
				m_UIMain:addNode(armatureZhaomu1)
			end
		end,
	})

	LayerManager.addLayoutNoScale(m_UIMain)
	armature:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2))
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	armature:setScale(fScale)
	-- AudioHelper.playSpecialEffect("texiao_zhaomu01.mp3")
	AudioHelper.playSpecialEffect("texiao_zhaomu_zhao1.mp3")
	m_UIMain:addNode(armature)
end


function flyEndCallback( tipNode )

	tipNode:removeFromParentAndCleanup(true)
	tipNode = nil
end

local animationTime = 0.001
local  m_updateLuckPointScheduler = nil
local nCOunt = 0
--更新贝里
function updateLuckPointNumber()
	local number = tonumber(m_UIMain.tfd_luck_num_1:getStringValue())

	local tbShopInfo = DataCache.getShopCache()
	local nCurLuck = tonumber(tbShopInfo.mystery_recruit_point )

	local silveNumber = tonumber(nCurLuck)
	if(number ~= nil and number < silveNumber)then
		nCOunt= nCOunt + 1
		m_UIMain.tfd_luck_num_1:setScale(1.3)
		logger:debug(animationTime)
		number = number + math.ceil(animationTime)
		m_UIMain.tfd_luck_num_1:setText(tostring(number))
	else
		m_UIMain.tfd_luck_num_1:setScale(1.0)
		stopScheduler()
		m_UIMain.tfd_luck_num_1:setText(tostring(nCurLuck))
		logger:debug(nCOunt)
		-- setBtnTouchEnabled(true)
	end
end


-- 根据类型启动scheduler （贝里 经验石 经验）
function startScheduler()
	if(m_updateLuckPointScheduler == nil) then
		m_updateLuckPointScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateLuckPointNumber,0.0, false)
	end
end


-- -- 根据类型停止scheduler （贝里 经验石 经验）
function stopScheduler()
	if(m_updateLuckPointScheduler)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateLuckPointScheduler)
		m_updateLuckPointScheduler = nil
	end

end



local function fnSetFlyText( n_AddLuckPoint ,nCrit , callbackFunc)
	local m_tbAttrValue = {}

	if(nCrit > 1) then
		local attrInfo = {}
		attrInfo.txt 			= "暴击:X" .. nCrit
		attrInfo.num  			= -1
		attrInfo.displayNumType	=4
		table.insert(m_tbAttrValue,attrInfo)
	end


	if(n_AddLuckPoint > 0) then
		local attrInfo = {}
		attrInfo.txt 			= "幸运值:"
		attrInfo.num  			= n_AddLuckPoint
		attrInfo.displayNumType	=1
		table.insert(m_tbAttrValue,attrInfo)
	end



	if(#m_tbAttrValue > 0) then
		local tfdAttr = {}
		table.insert(tfdAttr,m_UIMain.tfd_luck_num_1)
		table.insert(tfdAttr,m_UIMain.tfd_luck_num_1)
		LevelUpUtil.showFlyText(m_tbAttrValue,callbackFunc, nil, tfdAttr)
	else
		-- setBtnTouchEnabled(true)
	end
end

function stopAllAction(  )
	stopScheduler()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:removeChildByTag(1111, true)
	logger:debug(m_UIMain)
	if(m_UIMain) then
		logger:debug(m_UIMain.LOAD_LUCKY)
		if(m_UIMain.LOAD_LUCKY) then
			local _child = m_UIMain.LOAD_LUCKY:getNodeByTag(nProgressTag)
			if(_child) then
				_child:removeFromParentAndCleanup(true)
			end
		end
	end
end

--设置幸运值进度条
function setLuckProgress(  )
	m_updateLuckPointScheduler = nil
	m_UIMain.img_pro_bg:setEnabled(true)
	local nMaxValue = MysRecruitView.getMaxLuckValue()
	local tbShopInfo = DataCache.getShopCache()
	local nPreCurLuck = nPreLuckPoint
	local nCurLuck = tonumber(tbShopInfo.mystery_recruit_point )
	logger:debug(nCurLuck - nPreCurLuck)
	animationTime = (nCurLuck - nPreCurLuck) / 10

	m_UIMain.tfd_luck_num_1:setText( nPreCurLuck )
	m_UIMain.tfd_luck_num_2:setText("/" .. nMaxValue)

	local  percent1  = nPreCurLuck / nMaxValue * 100
	local  percent2  = nCurLuck / nMaxValue * 100
	percent1 = percent1 > 100 and 100 or percent1
	percent2 = percent2 > 100 and 100 or percent2

    local progressTimer = UIHelper.fnGetProgress("ui/mystical_pro_bg.png")
    m_UIMain.LOAD_LUCKY:addNode(progressTimer)
    progressTimer:setTag(nProgressTag)
    -- progressTimer:setVisible(false)
    logger:debug(percent1)
    logger:debug(percent2)
    progressTimer:setPercentage(percent1)
    if(percent2 < percent1) then
    	progressTimer:setPercentage(percent2)
    end
	
	m_UIMain.LOAD_LUCKY:setPercent(0)


	local nBasePoint = MysRecruitView.getBasePoint()
	local nCrit = (nCurLuck - nPreCurLuck ) / nBasePoint
	local proNode = progressTimer

	if(percent2 < percent1) then
		m_UIMain.tfd_luck_num_1:setText( nCurLuck )
	end

	local function runProGress( ... )
		if(proNode) then
			logger:debug("begain runProGress")
			local array = CCArray:create()
			array:addObject(CCProgressTo:create(1 ,percent2))
			array:addObject(CCCallFunc:create(function( ... )
				MysRecruitCtrl.addProAni(m_UIMain.LOAD_LUCKY,percent2)
						end))
			proNode:runAction(CCSequence:create(array))
			--数字翻滚
			logger:debug(nCurLuck)
			if(nCurLuck == 0) then
				-- m_UIMain.tfd_luck_num_1:setText( nCurLuck )
			else
				-- LevelUpUtil.fnPlayOneNumChangeAni(m_UIMain.tfd_luck_num_1,nCurLuck)
				startScheduler()
			end
		end
	end


	fnSetFlyText(nCurLuck - nPreCurLuck,nCrit,runProGress)
end




function setPreLuckPoint( _nPreLuckPoint)
	nPreLuckPoint = _nPreLuckPoint
end
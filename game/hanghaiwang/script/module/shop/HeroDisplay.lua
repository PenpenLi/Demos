-- FileName: HeroDisplay.lua
-- Author: menghao
-- Date: 2014-04-28
-- Purpose: 招将后显示武将的界面


module("HeroDisplay", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_imgBG

local m_layBeShadow
local m_imgBeShadowBG
local m_tfdBeShadow1
local m_tfdBeShadow2
local m_tfdBeShadowNum

local m_layLowerRecruit
local m_layMediumRecruit
local m_laySeniorRecruit

local m_btnQuit
local m_btnSeeHero
local m_btnRecruitAgain

local m_tfdOwn
local m_tfdLowerRecruitOwnNum
local m_tfdLowerRecruitCost
local m_tfdLowerRecruitCostItem
local m_tfdLowerItemNum

local m_labnSeniorCostGold

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

local m_imgStarBg
local m_imgGetTitle

local m_imgNameBg
local m_tfdHeroName


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnAddStroke = UIHelper.labelNewStroke

local m_fnCallback

local mi18n = gi18n

local m_hid
local m_htid
local m_nFragNum
local m_nItemType

local m_nRecruitType
local m_nlowerItemNum


local m_tbImgStar

local m_isLowerFree
local m_isLowerAgain

local m_aniDone = false


local effectId = nil --武将音效的effcetid

-- 设置按钮触摸
local function setBtnTouchEnabled( bValue )
	m_btnSeeHero:setTouchEnabled(bValue)
	m_btnQuit:setTouchEnabled(bValue)
	if m_btnRecruitAgain then
		m_btnRecruitAgain:setTouchEnabled(bValue)
	end
end


-- 退出按钮回调
local function onQuit( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		-- 如果是碎片装备背包合成，怕界面消失的时候，列表没有刷新完毕，再次点击会出错，m_aniDone 为动画播放完毕的额大概时机，sunyunpeng 2016-01-29
		if (m_nItemType == 6) then
			local equipFragBagRefrshDone = m_fnCallback()
			if (equipFragBagRefrshDone or m_aniDone) then
				LayerManager.removeLayout()
			end
		else
			LayerManager.removeLayout()
			if m_fnCallback then
				m_fnCallback()
			end
		end

		require "script/module/guide/GuideFiveLevelGiftView"
		if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 4) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createkFiveLevelGiftGuide(5)
		end

		require "script/module/guide/GuideCopy2BoxView"
		if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 8) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createCopy2BoxGuide(9)
		end

	end
end


-- 查看英雄按钮回调
local function onSeeHero( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()

		if (m_nItemType == 1 or m_nItemType == 2) then
			local tArgs={selectedHeroes = heroLocalInfo}
			require "script/module/partner/PartnerInfoCtrl"
	        local pHeroValue = heroLocalInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
	        local fragTid = DB_Heroes.getDataById(pHeroValue.id).fragment
	        local heroInfo = {htid = fragTid ,hid = 0 ,strengthenLevel = 0 ,transLevel = 0}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)

		else
			PublicInfoCtrl.createItemInfoViewByTid(m_htid, m_nFragNum)
		end
	end
end


local function fnLessItemCall( ... )
	local layModule = m_fnGetWidget(m_UIMain, "lay_modle")
	layModule:removeAllNodes()
end

-- 继续招募按钮回调
local function onRecruitAgain( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- AudioHelper.playCommonEffect()

		
		local shopInfo = DataCache.getShopCache()
		-- 根据招募类型做判断
		if (m_nRecruitType == 1) then
			m_isLowerAgain = true
			logger:debug("m_isLowerAgain = true")
			Tavern.getLowerClicked(fnLessItemCall,true)
		elseif (m_nRecruitType == 3) then
			if (tonumber(shopInfo.seniorFreeNum) > 0) then
				AudioHelper.playCommonEffect()
				local args = Network.argsHandler(0, 1)
				RequestCenter.shop_goldRecruit(RecruitService.seniorRecruitCallback, args)
			else
				-- local db_tavern = DB_Tavern.getDataById(3)
				local nGoldCost = RecruitService.getOneCostGold()
				if (UserModel.getGoldNumber() >= nGoldCost) then
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
end


-- 星星动画特效显示
local function showAnimation( ... )
	local startIndex = math.floor( ((6 - heroLocalInfo.potential) / 2.0) )
	local endIndex = startIndex + heroLocalInfo.potential - 1
	local ii = startIndex

	local function createXing2( ... )
		local armatureXing2 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/xing2.ExportJson",
			animationName = "xing2",
			loop = 0,
		})
		local pos = m_imgGetTitle:getWorldPosition()
		armatureXing2:setPosition(pos)
		m_UIMain:addNode(armatureXing2)
	end

	local function createXing( ... )
		AudioHelper.playSpecialEffect("zhaojiangxingji.mp3")
		ii = ii + 1
		local armatureXing = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/xing1.ExportJson",
			animationName = "xing1",
			loop = 0,

			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "1" then
					if ii <= endIndex then
						local acitonArray = CCArray:create()
						-- acitonArray:addObject(CCDelayTime:create(1))
						acitonArray:addObject(CCCallFunc:create(function ( ... )
							local armatureNextXing = createXing()
							if ii == endIndex + 1 then
								armatureNextXing:getAnimation():setMovementEventCallFunc(function ( sender, frameEventName )
									if frameEventName == 1 then
										createXing2()
									end
								end)
							end

							-- local x, y = m_tbImgStar[ii]:getPosition()
							-- armatureNextXing:setPosition(ccp(x, y))
							-- m_imgStarBg:addNode(armatureNextXing)
						end))

						m_UIMain:runAction(CCSequence:create(acitonArray))
					end
				end
			end
		})
		return armatureXing
	end
end

-- 福利活动相关
local function setDiscountUI(  )
	
	local bIsOpen = RecruitService.isShopDiscountOk()
	local shopInfo = DataCache.getShopCache()
	if(bIsOpen) then
		m_UIMain.lay_sale_bg:setVisible(true)
		local tavernData = DB_Tavern.getDataById(3)

		local nNormalGold =tavernData.gold_needed

		local nRate = OutputMultiplyUtil.getMultiplyRateNum(8)

		local curPrice = math.floor(nNormalGold * nRate / 10000) 
		logger:debug(curPrice .. "fff" .. nRate)
		m_UIMain.TFD_SALE_GOLD_NUM:setText(curPrice)


		local dd = intPercent(tonumber(curPrice),tonumber(nNormalGold))
		local sTen = dd/10
		m_UIMain.tfd_sale:setText(sTen .. "折")
		
	else
		m_UIMain.lay_sale_bg:setVisible(false)
	end
end

-- 初始化UI控件
local function initUIWidget( ... )
	-- 背景图
	m_UIMain.img_bg_1:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_1:setSize(CCSizeMake( m_UIMain.img_bg_1:getSize().width * g_fScaleX,m_UIMain.img_bg_1:getSize().height * g_fScaleX))
	m_UIMain.img_bg_2:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_2:setSize(CCSizeMake( m_UIMain.img_bg_2:getSize().width * g_fScaleX,m_UIMain.img_bg_2:getSize().height * g_fScaleX))
	m_UIMain.img_bg_3:setSizeType(SIZE_ABSOLUTE)
	m_UIMain.img_bg_3:setSize(CCSizeMake( m_UIMain.img_bg_3:getSize().width * g_fScaleX,m_UIMain.img_bg_3:getSize().height * g_fScaleX))
	m_UIMain.lay_bg:updateSizeAndPosition()

	setDiscountUI()

	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_o, mi18n[1161], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_orange_zero, mi18n[1161], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_purple, mi18n[1833], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_orange, mi18n[1834], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_purple_zero, mi18n[1833], ccc3(0x28,0x00,0x00))
	UIHelper.labelAddNewStroke(m_UIMain.tfd_recruit_o_zero, mi18n[1834], ccc3(0x28,0x00,0x00))
	-- 影子相关
	m_layBeShadow = m_fnGetWidget(m_UIMain, "lay_be_shadow")
	-- m_imgBeShadowBG = m_fnGetWidget(m_UIMain, "img_be_shadow_bg")
	m_tfdBeShadow1 = m_fnGetWidget(m_UIMain, "tfd_be_shadow_1")
	-- m_tfdBeShadow2 = m_fnGetWidget(m_UIMain, "tfd_be_shadow_2")
	m_tfdBeShadowNum = m_fnGetWidget(m_UIMain, "tfd_be_shadow_num")

	if m_nFragNum and m_nItemType == 2 then
		m_tfdBeShadow1:setText(mi18n[1458])
		m_tfdBeShadowNum:setText("X" .. m_nFragNum)
		m_fnAddStroke(m_tfdBeShadow1)
		m_fnAddStroke(m_tfdBeShadowNum)
	else
		m_layBeShadow:setEnabled(false)
	end

	-- 三种层
	m_layLowerRecruit = m_fnGetWidget(m_UIMain, "LAY_LOWER_RECRUIT_HERO")
	m_layMediumRecruit = m_fnGetWidget(m_UIMain, "LAY_MEDIUM_RECRUIT_HERO")
	m_laySeniorRecruit = m_fnGetWidget(m_UIMain, "LAY_SENIOR_RECRUIT_HERO")

	-- 根据招募内容显示不同内容
	if (m_nRecruitType == 1) then
		m_layLowerRecruit:setEnabled(true)
		m_layLowerRecruit:setVisible(true)
		m_layMediumRecruit:setEnabled(false)
		m_laySeniorRecruit:setEnabled(false)

		-- 按钮
		m_btnQuit = m_fnGetWidget(m_UIMain, "BTN_LOWER_RECRUIT_EXIT")
		m_btnSeeHero = m_fnGetWidget(m_UIMain, "BTN_LOWER_RECRUIT_SEE_HERO")
		m_btnRecruitAgain = m_fnGetWidget(m_UIMain, "BTN_LOWER_RECRUIT_HERO_AGAIN")

		m_nlowerItemNum = Tavern.getItemNum()

		m_tfdOwn = m_fnGetWidget(m_UIMain, "tfd_own")
		m_tfdLowerRecruitOwnNum = m_fnGetWidget(m_UIMain, "TFD_LOWER_RECRUIT_OWN_NUM")
		m_tfdLowerRecruitCost = m_fnGetWidget(m_UIMain, "tfd_lower_recruit_cost")
		m_tfdLowerRecruitCostItem = m_fnGetWidget(m_UIMain, "tfd_lower_recruit_cost_item")
		m_tfdLowerItemNum = m_fnGetWidget(m_UIMain, "tfd_item_num")

		m_tfdLowerRecruitOwnNum:setText("")
		m_tfdLowerRecruitCost:setText(mi18n[1405])
		m_tfdLowerRecruitCostItem:setText(mi18n[1406])
		m_tfdLowerItemNum:setText("(" .. m_nlowerItemNum .. ")")

		local function upTimeAndNum( ... )
			local shopInfo = DataCache.getShopCache()
			local dbLower = DB_Tavern.getDataById(1)

			m_isLowerFree = false
			local nFreeTime = dbLower.free_times - tonumber(shopInfo.bronze_recruit_free)
			if (nFreeTime <= 0) then -- 免费次数已用完
				m_tfdOwn:setText(mi18n[1465])

				m_tfdLowerRecruitCost:setEnabled(true)
				m_tfdLowerRecruitCostItem:setEnabled(true)
				m_tfdLowerItemNum:setEnabled(true)
			else -- 免费次数没用完
				local nLeftTime = tonumber(shopInfo.bronze_recruit_time) + dbLower.free_time_cd - TimeUtil.getSvrTimeByOffset()
				if (nLeftTime < 0) then -- 免费时间到
					m_tfdOwn:setText(gi18nString(1466, nFreeTime, dbLower.free_times))
					m_tfdLowerRecruitCost:setEnabled(false)
					m_tfdLowerRecruitCostItem:setEnabled(false)
					m_tfdLowerItemNum:setEnabled(false)

					m_isLowerFree = true
					m_btnRecruitAgain:setGray(false)
				else -- 免费时间没到
					m_tfdLowerRecruitCost:setEnabled(true)
					m_tfdLowerRecruitCostItem:setEnabled(true)
					m_tfdLowerItemNum:setEnabled(true)

					m_tfdOwn:setText(TimeUtil.getTimeString(nLeftTime) .. mi18n[1407])
				end
			end
		end

		upTimeAndNum()
		schedule(m_UIMain, upTimeAndNum, 1)


		--zhangjunwu 2015-12-16
		-- 如果玩家在百万招募界面中，当前无法继续招募，shop_recruit_hero画布中的BTN_LOWER_RECRUIT_HERO_AGAIN控件需要变为置灰状态。
		-- 注：需要改UI请喊王晓靖，例如：添加置灰状态的图片等。
		logger:debug(m_nlowerItemNum)
		if(m_nlowerItemNum <= 0  ) then
			m_btnRecruitAgain:setGray(true)
		end
		m_UIMain.lay_sale_bg:setVisible(false)
		----end zhangjunwu
	elseif (m_nRecruitType == 2 or m_nRecruitType == 4 or m_nRecruitType == 5 or m_nRecruitType == 6) then
		m_layLowerRecruit:setEnabled(false)
		m_layMediumRecruit:setEnabled(true)
		m_layMediumRecruit:setVisible(true)
		m_laySeniorRecruit:setEnabled(false)
		m_UIMain.lay_sale_bg:setVisible(false)
		-- 按钮
		m_btnQuit = m_fnGetWidget(m_UIMain, "BTN_MEDIUM_RECRUIT_EXIT")
		m_btnSeeHero = m_fnGetWidget(m_UIMain, "BTN_MEDIUM_RECRUIT_SEE_HERO")
		if (m_nRecruitType == 4 or m_nRecruitType == 5 or m_nRecruitType == 6) then
			m_btnSeeHero:setEnabled(false)
		end
		m_btnRecruitAgain = nil


	else
		m_layLowerRecruit:setEnabled(false)
		m_layMediumRecruit:setEnabled(false)
		m_laySeniorRecruit:setEnabled(true)
		m_laySeniorRecruit:setVisible(true)

		-- 按钮
		m_btnQuit = m_fnGetWidget(m_UIMain, "BTN_SENIOR_RECRUIT_EXIT")
		m_btnSeeHero = m_fnGetWidget(m_UIMain, "BTN_SENIOR_RECRUIT_SEE_HERO")
		m_btnRecruitAgain = m_fnGetWidget(m_UIMain, "BTN_SENIOR_RECRUIT_HERO_AGAIN")

		m_labnSeniorCostGold = m_fnGetWidget(m_UIMain, "TFD_SENIOR_RECRUIT_COST_GOLD_NUM")
		m_labnSeniorCostGold:setText(DB_Tavern.getDataById(3).gold_needed)

		RecruitService.initMustBePurpleTip(m_UIMain)
	end

	-- 按钮添加监听
	m_btnQuit:addTouchEventListener(onQuit)
	UIHelper.titleShadow(m_btnQuit, mi18n[1447])
	if m_btnRecruitAgain then
		m_btnRecruitAgain:addTouchEventListener(onRecruitAgain)
		UIHelper.titleShadow(m_btnRecruitAgain, mi18n[1446])
	end
	m_btnSeeHero:addTouchEventListener(onSeeHero)
	if ((m_nItemType == 3 or m_nItemType == 4) and (not heroLocalInfo.isHeroFragment)) then
		-- UIHelper.titleShadow(m_btnSeeHero, mi18n[3652])
	else
		-- UIHelper.titleShadow(m_btnSeeHero, mi18n[1445])
	end
	if (m_nRecruitType == 4 or m_nRecruitType == 5 or m_nRecruitType == 6) then
		m_UIMain:addTouchEventListener(onQuit)
	end

	m_imgGetTitle = m_fnGetWidget(m_UIMain, "lay_title_bg")
	m_imgGetTitle:setEnabled(false)


end


local function init(...)
	effectId = nil
	if (m_nItemType == 1 or m_nItemType == 2) then
		heroLocalInfo = DB_Heroes.getDataById(tonumber(m_htid))
		-- add by yucong 抽卡完及时显示羁绊信息
		heroLocalInfo.hid = m_hid
	end
	if (m_nItemType == 3 or m_nItemType == 4 or m_nItemType == 5 or m_nItemType == 6) then
		heroLocalInfo = ItemUtil.getItemById(tonumber(m_htid))
		heroLocalInfo.potential = heroLocalInfo.quality
	end
	initUIWidget()
end


function destroy(...)
	package.loaded["HeroDisplay"] = nil
end


function moduleName()
	return "HeroDisplay"
end

function doScaleShake()
	if(m_UIMain) then
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		ShakeSenceEff:new(runningScene,0.1,4)
	end 
end

--播放武将音效
local function fnPlayHeroSound( )
	if (m_nItemType == 1 or m_nItemType == 2) then
        local soundPath = DB_Heroes.getDataById(heroLocalInfo.id).debut_word
        logger:debug(soundPath)
        if(soundPath) then

        	effectId = AudioHelper.playEffect("audio/heroeffect/" .. soundPath ..".mp3")
        end
	end
end

 function fnPlayTitleAni()
	m_tfdHeroName:setEnabled(false)
	m_imgGetTitle:setEnabled(true)
	local FRAME_TIME = 1/60
	local titleBg = m_tfdHeroName
	titleBg:setEnabled(false)
	titleBg:setScale(6.0)
	local aniTitle = UIHelper.createArmatureNode({
		filePath = "images/effect/shop_recruit/zhao_title.ExportJson",
		animationName = "zhao_title",
		bRetain = true,
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			if frameEventName == "1" then
				m_imgNameBg:setEnabled(true)
				AudioHelper.playSpecialEffect("texiao_renwuwancheng.mp3")
				titleBg:setEnabled(true)
				local array = CCArray:create()
				-- array:addObject(CCDelayTime:create(0.1))
				
				array:addObject(CCScaleTo:create(1 * FRAME_TIME ,6.0))  
				array:addObject(CCScaleTo:create(2 * FRAME_TIME ,0.9))  
				array:addObject(CCScaleTo:create(2 * FRAME_TIME , 1.0))  
				local seq = CCSequence:create(array)
				 -- local imgRender = m_imgGetTitle:getVirtualRenderer()
				titleBg:runAction(seq)
			end
		end


	})
	AudioHelper.playSpecialEffect("texiao_gongxininhuode.mp3")
	-- aniTitle:getAnimation():setSpeedScale(0.15)
	-- newFlag:setAnchorPoint(ccp(0.0, 0.0))
	aniTitle:setPosition(ccp(m_UIMain.lay_title_bg:getSize().width / 2,0))
	m_UIMain.lay_title_bg:addNode(aniTitle)
end

local function fnGroudShakeAni()
	local armatureZhaomu1 = UIHelper.createArmatureNode({
					filePath = "images/effect/shop_recruit/zhao1_2.ExportJson",
					animationName = "zhao1_2",
					fnMovementCall = function ( sender, MovementEventType , frameEventName)
						if (MovementEventType == 1) then
							sender:removeFromParentAndCleanup(true)
						end
					end,
				})
	-- 
	local layModule = m_fnGetWidget(m_UIMain, "lay_modle")
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	armatureZhaomu1:setScale(fScale)
	armatureZhaomu1:setPosition(ccp(layModule:getSize().width / 2, layModule:getSize().height / 2 - 50))

	layModule:addNode(armatureZhaomu1,-10,-10)
	
	doScaleShake()
	fnPlayHeroSound()
end

-- 动画
local function showPreAnimation( ... )
	m_tfdHeroName = m_fnGetWidget(m_UIMain, "TFD_RECRUIT_HERO_NAME")
	local tfdItemNum = m_fnGetWidget(m_UIMain, "TFD_ITEM_NUMBER")
	m_imgNameBg = m_fnGetWidget(m_UIMain, "img_recruit_hero_name_bg")
	m_imgNameBg:setEnabled(false)

	local layModule = m_fnGetWidget(m_UIMain, "lay_modle")

	local function addArmature( armature )
		armature:setPosition(ccp(layModule:getSize().width * 0.5, layModule:getSize().height * 0.5))
		layModule:addNode(armature)
	end

	local function animationEndCall( ... )
		if (heroLocalInfo.isTreasureFragment or heroLocalInfo.isFragment) then
			if (m_nRecruitType == 4) then
			   m_tfdHeroName:setText(heroLocalInfo.name .. gi18n[2448]) -- 碎片
		    end

		elseif (heroLocalInfo.isHeroFragment and not RecruitService.isSpecialShadow(heroLocalInfo.id)) then
			m_tfdHeroName:setText(heroLocalInfo.name .. gi18n[1002])
		else
			local imgFrag = m_fnGetWidget(m_UIMain, "IMG_FRAGMENT")
			imgFrag:setEnabled(false)
			imgFrag:setVisible(false)
			m_tfdHeroName:setText(heroLocalInfo.name)
		end

		if ((m_nItemType == 3 or m_nItemType == 4)) then
			tfdItemNum:setText("X" .. m_nFragNum)
			m_fnAddStroke(tfdItemNum)
		else
			tfdItemNum:setEnabled(false)
			tfdItemNum:setVisible(false)
		end
		m_fnAddStroke(m_tfdHeroName)
		m_tfdHeroName:setColor(g_QulityColor2[heroLocalInfo.potential])
		-- m_imgNameBg:setEnabled(true)
		m_imgNameBg:setZOrder(30)

		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideFiveLevelGiftView"
		if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 3) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createkFiveLevelGiftGuide(4,0)
		end
		require "script/module/guide/GuideCopy2BoxView"
		if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 7) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createCopy2BoxGuide(8)
		end

		setBtnTouchEnabled(true)

		-- showAnimation()
		PreRequest.setIsCanShowAchieveTip(true)
	end

	local function showArmature4( ... )
		local armature4 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhao4.ExportJson",
			loop = 0,
		})
		local bone = armature4:getBone("zhao4_1")
		local ccSkin
		if ((m_nItemType == 1 or m_nItemType == 2)) then
			ccSkin = CCSkin:create("images/base/hero/body_img/" .. heroLocalInfo.body_img_id)
		else
			ccSkin = CCSkin:create(heroLocalInfo.iconBigPath)
		end
		bone:addDisplay(ccSkin, 0)
		armature4:getAnimation():play("zhao4", -1, -1, 0)
		addArmature(armature4)
	end

	local function showArmature11( ... )
		local armature11 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhao1_1.ExportJson",
			loop = 0,
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == 0) then
					-- m_imgStarBg:setEnabled(true)
					m_imgGetTitle:setEnabled(false)
					for i=1,6 do
						-- m_tbImgStar[i]:setEnabled(false)
					end
				elseif (MovementEventType == 1) then
					animationEndCall()
					fnPlayTitleAni()
				end
			end,

			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "1" then
					fnGroudShakeAni()
				end
			end,
		})
		local bone0101 = armature11:getBone("zhao1_1_01_01")
		local filePath
		if ((m_nItemType == 1 or m_nItemType == 2))then
			filePath = "images/base/hero/body_img/" .. heroLocalInfo.body_img_id
		else
			filePath = heroLocalInfo.iconBigPath
		end
		local ccSkin0101 = CCSkin:create(filePath)
		bone0101:addDisplay(ccSkin0101,0)
		local bone01 = armature11:getBone("zhao1_1_01")
		local ccSkin01 = CCSkin:create(filePath)
		bone01:addDisplay(ccSkin01, 0)
		AudioHelper.playEffect("audio/effect/texiao_zhaomu_zhao1_1.mp3")
		armature11:getAnimation():play("zhao1_1", -1, -1, 0)
		addArmature(armature11)
	end

	local function showArmature2( ... )
		local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhao2.ExportJson",
			animationName = "zhao2",
			loop = 0,
			fnMovementCall = function ( sender, MovementEventType, frameEventName )
				if (MovementEventType == 1) then
					sender:removeFromParentAndCleanup(true)
					performWithDelay(m_UIMain, showArmature2, 1)
					
				end
			end
		})
		addArmature(armature2)

	end

	local function showArmature3( ... )
		local armature3 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhao3.ExportJson",
			animationName = "zhao3",
		})
		addArmature(armature3)
	end



	local function showArmature1( ... )
		local armature1 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhao1.ExportJson",
			animationName = "zhao1",
			loop = 0,

			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if frameEventName == "2" then
					showArmature3()
					showArmature4()
					showArmature2()

					-- 支持 #34080 【酒馆】招募音效
					-- AudioHelper.playSpecialEffect("texiao_zhaomu_zhao2.mp3")
				elseif frameEventName == "1" then
					showArmature11()
				end
			end
		})
		armature1:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2))
		local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
		armature1:setScale(fScale)

		AudioHelper.playSpecialEffect("texiao_zhaomu_zhao1.mp3")
		m_UIMain:addNode(armature1)
	end

	if (m_nRecruitType == 4 or m_nRecruitType == 5 or m_nRecruitType == 6 or m_isLowerAgain) then
		m_isLowerAgain = nil
		showArmature3()
		showArmature4()
		showArmature2()

		showArmature11()
		return
	end

	showArmature1()
end

--recruitType = 5 代表装备碎片合成
function create( tbHeroInfo, recruitType, callback)
	m_fnCallback = nil
	m_aniDone = false
	if callback then
		m_fnCallback = callback
	end

	PreRequest.setIsCanShowAchieveTip(false)
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideFiveLevelGiftView"
	if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.removeGuideView()
		GuideCtrl.setPersistenceGuide("shop","7")
	end

	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 7) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.removeGuideView()
		GuideCtrl.setPersistenceGuide("copy2Box","13")
	end

	m_nFragNum = nil
	m_nRecruitType = recruitType

	if (recruitType == 4 or recruitType == 5 or recruitType == 6) then
		m_htid = tbHeroInfo.tid
		m_nFragNum = tbHeroInfo.num
		m_nItemType = tbHeroInfo.iType
		m_nItemChildType = tbHeroInfo.iType
	else
		for k, oneInfo in pairs(tbHeroInfo) do
			if (oneInfo.hero) then
				for k,v in pairs(oneInfo.hero) do
					m_hid = tonumber(k)
					m_htid = tonumber(v)
					m_nFragNum = 1
				end
				m_nItemType = 1
			end

			if (oneInfo.heroFrag) then
				for k,v in pairs(oneInfo.heroFrag) do
					local fragTid = tonumber(k)
					m_htid = tonumber(DB_Item_hero_fragment.getDataById(fragTid).aimItem)
					m_hid = HeroModel.getHidByHtid(m_htid)
					m_nFragNum = tonumber(v)
				end
				m_nItemType = 2
			end

			if (oneInfo.item) then
				for k,v in pairs(oneInfo.item) do
					m_htid = tonumber(k)
					m_nFragNum = tonumber(v)
				end
				m_nItemType = 3
			end

			if (oneInfo.treasFrag) then
				for k,v in pairs(oneInfo.treasFrag) do
					m_htid = tonumber(k)
					m_nFragNum = tonumber(v)
				end
				m_nItemType = 4
			end
		end
	end

	m_UIMain = g_fnLoadUI("ui/shop_recruit_hero.json")
	-- 设置所有动画播放完毕大概的时机 sunyunpeng 2016-01-29
    performWithDelayFrame(m_UIMain,function ( ... )
    	m_aniDone = true
    end,20)

	init()
	LayerManager.addLayoutNoScale(m_UIMain)
	
	UIHelper.registExitAndEnterCall(m_UIMain, function ( ... )
		if(effectId)then
			AudioHelper.stopEffect(effectId)
			UIHelper.removeArmatureFileCache()
		end
	end)

	setBtnTouchEnabled(false)
	if recruitType == 4 then
		showPreAnimation()
	else
		showPreAnimation()
	end
end


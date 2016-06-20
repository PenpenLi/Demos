-- FileName: MainFormation.lua
-- Author: zhaoqiangjun
-- Date: 14-3-29
-- Purpose: function description of module


module("MainFormation", package.seeall)

--引用的json文件。
local jsonformain   = "ui/formation_main.json"
local jsonforup     = "ui/formation_up.json"
local jsonforupCheck= "ui/formation_up_check.json"
local jsonforbg     = "ui/formation_bg.json"
local jsonforBack   = "ui/formation_view.json"
local jsonforLittle = "ui/formation_littlef.json"

--UI控件变量
local mUModel = UserModel
local mUI = UIHelper
local mLayerM = LayerManager
local mDBheros = DB_Heroes
local mFUtil = FormationUtil
local mItemUtil = ItemUtil
local mData = DataCache
local mFTools = MainFormationTools
local mFormLitSCV = FormLitFriScrollView
local mFormLitFriV = FormLitFriView
local widgetMain
local widgetUp
local widgetBg
local m_i18n = gi18n
local m_getWidget = g_fnGetWidgetByName
local m_fnLoadUI = g_fnLoadUI
local _speModel = FormationSpecialModel
--local _fData = FormationData

local mainPage
local heroPageView
local heroHeadList
local layHeroInfoLayout
local layHeros
local _isShowPvpBtn = false 	-- 是否显示切磋按钮

-- 一键装备按钮
local oneKeyEquipBtn    -- 一键装备按钮.
local BTN_GURU --强化大师按钮
local curHeroHid        = 3    --当前装备的英雄的hid。3表示位置为空英雄。
local equipType         = true --装备类型。

local showLitFriPos     = 100   --显示小伙伴页面。
local focusTag			= 124
local SHOW_SELF_SQUAD   = 11000
local SHOW_THEM_SQUAD   = 11001

local showSquadTye = SHOW_SELF_SQUAD

--英雄的装备相关
local conchButton
local equipBtn
local equipLabel		
local imgTips 		--装备红点集合
local imgConchTips	--空岛贝红点集合
local conch
local mLastChangeEquipInfo
local mNewChangeHero

--英雄形象相关
local EvenStarLayout    --偶数层
local OddnStarLayout    --奇数层

--英雄的名字
local labHeroName       --英雄名字
local labHeroJinJie     --进阶等级
local imgAddJinJie      --进阶等级前面的加号

local openUnionColor    = ccc3(0x00 ,0x8a  ,0x00 )         --开放的羁绊
local normUnionColor    = ccc3(0x82  ,0x57  ,0x00 )         --未开放的羁绊

--英雄等级
local heroLevel
local heroSumLevel
--羁绊技能
local fetterLabels --羁绊label
--资质相关属性
local arrtNumLabels --属性label
local heroQualityLabel  --资质

local heroPage
local heroOpenForm      --根据网络数据得到的中间数据
-- local litHeroOpenPos    --小伙伴开启的位置
local treaOpenPos       --宝物开启位置
local tbTreaInfoData    --纪录当前宝物数据
--空岛贝开启位置
local fitConchOpenPos

-- 英雄和空白人的位置和锚点
local _tbHeroPos = {
	pos,
	anchorPos,
	emptyPos,
	emptyAnchorPos,
}

--显示对方阵容的数据区
local externHeroInfo
local allheroInfo
local allextraInfo
local externHeroId
--函数生命区
----------
local m_curPageNum = - 1
local m_outPageNum = 0
----------
--伙伴原始属性
local originEquipAttr
--最终伙伴属性
local finalEquipAttr
--最终羁绊颜色
local finalLinkColor

local otherLv = nil 		--查看阵容中主角的等级
local m_heroInitInfo
local m_bodyBttons
local m_headTips	--上方的红点集合
local m_conchTip	--空岛贝红点
local m_equipTip	--装备红点
local m_showAmr
local m_showTrea
local _newEffect = nil
local _guruEffect = nil
local _transEffect = nil
local _isLoadDelay = true 	-- 是否延时加载装备图标等
local _effectLayer = nil 	-- 放置临时特效的层
local _curMusicId = nil

--模块名
function moduleName()
	return "MainFormation"
end

function destroy( ... )
	otherLv = nil
	m_showAmr = false
	m_showTrea = false
	m_conchTip = nil
	m_equipTip = nil
	m_headTips = nil
	heroPageView = nil
	mFormLitSCV.cleanScrollView()
	widgetMain = nil
	widgetUp = nil
	widgetBg = nil
	imgTips = nil
	imgConchTips = nil
	equipBtn = nil
	equipLabel = nil
	m_bodyBttons = nil
	layHeroInfoLayout = nil
	layHeros = nil
	mLastChangeEquipInfo = nil
	_newEffect = nil
	_guruEffect = nil
	_transEffect = nil
	showSquadTye = SHOW_SELF_SQUAD
	_isLoadDelay = true
	if (UIHelper.isGood(_effectLayer)) then
		_effectLayer:removeFromParentAndCleanup(true)
		_effectLayer = nil
	end
	mFTools.removeFlyText()
	mFTools.removeAllAuto()
	removeObserver()
	package.loaded["MainFormation"] = nil
end

local function initFormData( ... )
	m_headTips = {}
	m_bodyBttons = {}
	layHeroInfoLayout = nil
	m_heroInitInfo = {}
	conch = {conchLayout = 1 , btn = {0,0,0,0,0,0,0,0} , label = {0,0,0,0,0,0,0,0}}
	originEquipAttr = {}
	finalEquipAttr 	= {}
	finalLinkColor = {}

	m_curPageNum = - 1
	m_outPageNum = 0
	curHeroHid   = 3    --当前装备的英雄的hid。
	equipType    = true --装备类型。
end

-----------------修改 by wm--------------------
--是否在滚动
local function isAutoScrolling( ... )
	local b1 = heroPageView and heroPageView:isAutoScrolling() or false
	local b2 = mainPage and mainPage:isAutoScrolling() or false
	return b1 or b2 
end

--初始化label
local function fnResetLabel( _label )
	if(not _label) then
		return
	end
	-- _label:stopAllActions()
	_label:setScale(1)
	_label:setText("")
end

--重置飞的数字和数值label
local function fnCleanNumberLabel( ... )
	mFTools.removeFlyText()
	mFTools.removeAllAuto()
	local pNode = arrtNumLabels
	for k,v in pairs(pNode) do
		fnResetLabel(v)
	end
end

--[[desc:切换时清掉属性动画
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnCleanLabelAni( ... )
	logger:debug(finalEquipAttr)
	fnCleanNumberLabel()
	local pNode = arrtNumLabels
	for k,v in pairs(pNode) do
		v:setText(finalEquipAttr[k])
	end
	for i=1 , table.count(fetterLabels or {}) do
		fetterLabels[i]:setScale(1)
		if(finalLinkColor[i]) then
			fetterLabels[i]:setColor(finalLinkColor[i])
		end
	end
	finalLinkColor = {}
	mLastChangeEquipInfo = nil
	mNewChangeHero = nil
	-- 清除残余特效
	_effectLayer:removeAllChildren()
	_effectLayer:removeAllNodes()
	stopHeroMusic()
end

--[[desc:根据hid获取herodata和heroinfo
    _herohid: 伙伴的hid
    return: 是否有返回值，返回值说明  
—]]
local function fnGetHeroDataByHid( _hid )
	if(not _hid) then
		return nil , nil
	end
	local heroInfo = getHeroInfoByHid(_hid) or nil
	local heroData = nil
	if(heroInfo) then
		heroData = mDBheros.getDataById(heroInfo.htid) or nil
	end
	return heroData , heroInfo
end

--显示上阵伙伴,
--@return showType:1 需要滚动到羁绊信息处，0不需要
local function showPartner(hpos, heroInfo, showtype)
	local isSelf = isSelf()
	--当前为空的话跳转选择伙伴界面，否则显示个人信息
	if(heroInfo == nil) then
		AudioHelper.playCommonEffect()
		if(isSelf) then
			mLayerM.addUILoading()
			require "script/module/formation/FriendSelectCtrl"
			local pFriendSelect = FriendSelectCtrl
			local battleCompanModule = pFriendSelect.create(1 ,hpos + 1,curHeroHid)
			mLayerM.addLayoutNoScale(battleCompanModule, widgetBg)
		end
		return
	end
	AudioHelper.playInfoEffect()

	require "script/module/partner/PartnerInfoCtrl"
    local pHeroValue = heroInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
    local layoutType 
    local tbherosInfo = {}
    local heroInfoIndex 
    require "script/battle/BattleState"
    local battleState = BattleState.isPlaying()
    if (not externHeroInfo) then                          -- 自己阵容
    	layoutType = 5
    elseif (externHeroInfo and battleState)  then         -- 战斗结算(战斗场景没有退出) 面板
    	layoutType = 4
    elseif (externHeroInfo and not battleState)  then     -- 非战斗结算面板
    	layoutType = 3
    else
    	layoutType = 1
    end
    local tArgs = {}

    local function returnArgs( tempHeroInfo )
        return {htid = tempHeroInfo.htid ,hid = tempHeroInfo.hid or 0,strengthenLevel = tempHeroInfo.level or 0,transLevel = tempHeroInfo.evolve_level or 0,awake = tempHeroInfo.awake_attr }
    end 

    heroInfo.location = hpos+ 1
    tArgs.heroInfo = returnArgs(pHeroValue)
    tArgs.externHeroInfo = externHeroInfo
    tArgs.pageViewType = externHeroInfo and 2 or 1

	if showtype == 1 then
		layer = PartnerInfoCtrl.showJiBan(tArgs,layoutType)
	elseif showtype == 2 then
		layer = PartnerInfoCtrl.showJeuXing(tArgs,layoutType)
	else
		layer = PartnerInfoCtrl.create(tArgs,layoutType)     --所选择武将信息22
	end
    LayerManager.addLayoutNoScale(layer)
end


--[[desc:添加伙伴身体button
    _herohid: 伙伴的hid
    _hpos: 对应位置（从1起）
    _isChange: 新增或改变
    _showChange: 显示body进场动画
    return: 是否有返回值，返回值说明  
—]]
local function fnAddHeroBody( _herohid , _hpos , _isChange , _showChange)
	local hpos = _isChange and _hpos - 1 or _hpos
	local herohid = _herohid or 3
	local heroData , heroInfo = fnGetHeroDataByHid(herohid)
	-- 查看他人阵容时，该位置人不存在则不显示空位置
	if (not isSelf() and not isHeroExist(herohid)) then
		return
	end
	logger:debug("look:"..herohid.." pos:"..hpos.." count:"..heroPageView:getPages():count().." isChange:"..tostring(_isChange))
	local pLay = nil
	local bodyBtn = nil

	local pLay = heroPageView:getPage(hpos)
	if(pLay) then
		bodyBtn = m_bodyBttons[tostring(hpos)] or nil 
		if(bodyBtn) then
			bodyBtn:setTouchEnabled(false)
			bodyBtn:removeFromParentAndCleanup(true)
			bodyBtn = nil
			m_bodyBttons[tostring(hpos)] = nil
		end
	else
		pLay = Layout:create()
		heroPageView:addWidgetToPage(pLay, hpos, true)
		if(_isChange) then
			return
		end
	end
	--当前人物点击事件
	local function fnPshowPart( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if(isAutoScrolling()) then
				return
			end
			local ppos = tonumber(sender:getTag()) or 0
			if(ppos ~= m_curPageNum) then
				return
			end
			if(mainPage:getCurPageIndex() ~= 0) then
				return
			end
			--清空飘字
			fnCleanLabelAni()
			--显示小伙伴列表
			logger:debug({heroInfo=heroInfo})
			logger:debug("huxiaozhouhuxiaozhouhuxiaozhou")
			if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 2) then
				logger:debug("huxiaozhouhuxiaozhouhuxiaozhou")
				showPartner(ppos, heroInfo, 2)
			else
				showPartner(ppos, heroInfo, 0)
			end
			
		end
	end

	--创建人物显示按钮
	bodyBtn = Button:create()
	bodyBtn:setTag(hpos)
	pLay:addChild(bodyBtn)
	bodyBtn:addTouchEventListener(fnPshowPart)
	m_bodyBttons[tostring(hpos)] = bodyBtn

	if(bodyBtn) then
		local pfile1 = nil
		local pfile2 = nil
		-- 延时加载人物
		performWithDelayFrame(widgetBg, function ( ... )
			if(heroData) then
				pfile1 = "images/base/hero/body_img/" .. heroData.body_img_id
				pfile2 = pfile1
				bodyBtn:setAnchorPoint(_tbHeroPos.anchorPos)
				bodyBtn:setPosition(_tbHeroPos.pos)
			--黑影
			else
				pfile1 = "images/formation/testselect.png"
				bodyBtn:setAnchorPoint(_tbHeroPos.emptyAnchorPos)
				bodyBtn:setPosition(_tbHeroPos.emptyPos)
			end
			bodyBtn:loadTextures(pfile1,pfile2,nil)
		end, _isLoadDelay and 1 or 0)
		
		if(heroData) then
			--播放呼吸特效
			mUI.fnPlayHuxiAni(bodyBtn)
		end
		--是否播放进场动画
		if(_showChange) then
			mFTools.runHeroImgAni(bodyBtn)
		end
	end
end

--[[desc:添加伙伴身体button
    _herohid: 伙伴的hid
    _hpos: 对应位置（从1起）
    _level: 锁显示的等级
    _isChange: 新增或改变
    return: 是否有返回值，返回值说明  
—]]
local function fnAddHeroHead( _herohid , _hpos , _level , _isChange)
	local hpos = _hpos
	local herohid = _herohid or 3
	local addLockImage = nil
	local headFrameImage = nil
	-- 查看他人阵容时，该位置人不存在则不显示空位置
	if (not isSelf() and not isHeroExist(herohid)) then
		return
	end
	if(_isChange) then
		addLockImage = tolua.cast(heroHeadList:getItem(_hpos-1),"Layout")
		local pTag = addLockImage:getTag()
		if tonumber(pTag) ~= 0 then
			headFrameImage = m_getWidget(addLockImage, "IMG_FRAME_BG")
			local button = headFrameImage:getChildByTag(tonumber(pTag))
			if button then
				button:removeFromParentAndCleanup(true)
				button = nil
			end
		end
	else
		local layFormImage = m_getWidget(widgetUp, "LAY_FORMATION_TEST")
		addLockImage = layFormImage:clone()
		local headImage = m_getWidget(addLockImage, "IMG_ACTOR")	--替补标记
		headFrameImage = m_getWidget(addLockImage, "IMG_FRAME_BG")	--底框
		local lineImage = m_getWidget(addLockImage, "IMG_LITTLE_SLANT")
		lineImage:setVisible(false)
		local ppos1 = _isChange and hpos - 1 or hpos
		if(isSelf()) then
			m_headTips[ppos1+1] = m_getWidget(addLockImage, "IMG_PHOTO_TIP")
			m_headTips[ppos1+1]:setVisible(false)
			if(not m_headTips[ppos1+1]:getNodeByTag(10)) then
				local copyTipAnimination = UIHelper.createRedTipAnimination()
				copyTipAnimination:setTag(10)
				m_headTips[ppos1+1]:addNode(copyTipAnimination,10)
			end
		end
		--最后一个添加替补标记
		if(ppos1 >= mFTools.fnGetSquadNum()) then
			headImage:setVisible(true)
		else
			headImage:setVisible(false)
		end
	end
	--IMG_ACTOR 替补标示 处理

	local pTag = 3

	if(_level) then
		logger:debug(_level)
		local levelLabel = m_getWidget(addLockImage, "TFD_LVL")
		local openLvlLab = m_getWidget(addLockImage, "TFD_LVL_JIKAIFANG")
		levelLabel:setText(tostring(_level))
		--mUI.labelNewStroke(levelLabel)
		--mUI.labelNewStroke(openLvlLab)
		pTag = 0
		--headFrameImage:loadTexture("images/base/potential/border.png")
	else
		-- 隐藏锁图
		addLockImage.TFD_LVL:setVisible(false)
		addLockImage.TFD_LVL_JIKAIFANG:setVisible(false)
		addLockImage.IMG_LOCK:setVisible(false)

		addLockImage:setVisible(false)

		local heroData = fnGetHeroDataByHid(herohid)
		local ppos2 = _isChange and hpos or hpos + 1
		--顶部头像点击事件
		local function pEventHeadBtn( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if(isAutoScrolling()) then
					return
				end
				AudioHelper.playCommonEffect()
				local pPage = ppos2 - 1
				if(m_curPageNum ~= pPage or mainPage:getCurPageIndex() ~= 0) then
					fnCleanLabelAni()
					if(m_heroInitInfo and m_heroInitInfo[tostring(pPage)]) then
						fnAddHeroBody(m_heroInitInfo[tostring(pPage)] , ppos2, true)
						m_heroInitInfo[tostring(pPage)] = false
					end
					heroPageView:scrollToPage(pPage)
				end
				scrollMainPage(0)
			end
		end

		local btn = headFrameImage--widgetUp.IMG_FRAME_BG
		btn:setTouchEnabled(true)
		-- local btn = Button:create()
		-- local bgFile = "images/base/potential/officer_n.png"
		-- btn:loadTextures(bgFile,bgFile,nil) -- 用高亮边框初始化按钮
		-- 高亮框
		local pFocuseImg = ImageView:create()
		pFocuseImg:loadTexture("images/base/potential/officer_h.png")
		pFocuseImg:setTag(focusTag)
		btn:addChild(pFocuseImg)
		pFocuseImg:setVisible(false)

		if(not heroData) then
			-- local addBtnBg = ImageView:create()
			-- addBtnBg:loadTexture("images/base/potential/border.png")
			-- btn:addChild(addBtnBg)
			-- 闪烁的“+”
			local AddSprite = mUI.fadeInAndOutImage("ui/add_blue.png")
			AddSprite:setPosition(ccp(0, 0))
			btn:addNode(AddSprite)
			performWithDelayFrame(widgetBg, function ( ... )
				addLockImage:setVisible(true)
			end, _isLoadDelay and hpos or 0)
		else
			-- 延时加载人物头像
			performWithDelayFrame(widgetBg, function ( ... )
				local imgHead = HeroUtil.createHeroIconBtnByHtid(heroData.id) -- 品质背景和头像图片
				if(imgHead) then
					btn:addChild(imgHead)--,-3)
					addLockImage:setVisible(true)
				end
			end, _isLoadDelay and hpos or 0)
			pTag = tonumber(herohid)
		end

		if(btn) then
			btn:setTag(pTag)
			--headFrameImage:addChild(btn)
			btn:addTouchEventListener(pEventHeadBtn)
		end
	end

	addLockImage:setTag(pTag)
	if(not _isChange) then
		heroHeadList:pushBackCustomItem(addLockImage)
	end
end

-- 添加主船头像 自己阵容不显示
local function fnAddShipHead( shipId, pos )
	logger:debug("addShipPos:"..pos)
	shipId = tonumber(shipId) or nil
	--shipId = ShipData.getNowShipId()
	if (isSelf()) then
		return
	end
	if (not shipId or shipId == 0) then
		return
	end
	local layFormImage = m_getWidget(widgetUp, "LAY_FORMATION_TEST")
	local shipImg = layFormImage:clone()
	shipImg.IMG_LOCK:setVisible(false)
	shipImg.TFD_LVL:setVisible(false)
	shipImg.TFD_LVL_JIKAIFANG:setVisible(false)
	shipImg.img_border:setVisible(false)
	shipImg.IMG_ACTOR:setVisible(false)

	--performWithDelayFrame(widgetBg, function ( ... )
		-- 船icon
		local shipIcon = ImageView:create()
		local iconImg, iconBg, iconBorder = ShipMainModel.getShipIconById(shipId)
		shipIcon:loadTexture(iconBg) -- 加载背景图片
		local imgItem = ImageView:create()
		imgItem:loadTexture(iconImg)
		shipIcon:addChild(imgItem) -- 加载物品图标, 附加到Button上
		local imgBorder = ImageView:create()
		imgBorder:loadTexture(iconBorder)
		shipIcon:addChild(imgBorder)
	--end, _isLoadDelay and pos or 0)
	
	-- 高亮框
	local pFocuseImg = ImageView:create()
	pFocuseImg:loadTexture("images/base/potential/officer_h.png")
	pFocuseImg:setTag(focusTag)
	shipImg.IMG_FRAME_BG:addChild(pFocuseImg)
	pFocuseImg:setVisible(false)

	shipImg.IMG_FRAME_BG:setTouchEnabled(true)
	shipImg.IMG_FRAME_BG:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			scrollMainPage(1)
		end
	end)

	shipImg.IMG_FRAME_BG:addChild(shipIcon)
	heroHeadList:pushBackCustomItem(shipImg)
end

--[[desc:初始化时添加伙伴头像和body的对象
    _herohid: 伙伴的hid
    _hpos: 对应位置（从1起）
    return: 是否有返回值，返回值说明  
—]]
local function fnHeroHeadInit( _heroHid , _hpos)
	local heroHid = tonumber(_heroHid) or nil
	local hpos = tonumber(_hpos) or nil
	local pShowLevel = nil
	local pSquadNum = tonumber(mFTools.fnGetSquadNum())
	if(hpos > pSquadNum) then
		local pLevel = tonumber(mUModel.getHeroLevel())
		if(showSquadTye == SHOW_THEM_SQUAD) then
			pLevel = tonumber(otherLv)
		end
		local pOpenLevel = mFTools.fnGetBenchOpenLevel(hpos - pSquadNum)
		if(pOpenLevel > pLevel) then
			pShowLevel = pOpenLevel
			heroHid = nil
		end
	else
		if(hpos > tonumber(heroOpenForm)) then
			pShowLevel = mFUtil.getFormationPosLevel(hpos)
			heroHid = nil
		end
	end

	local ppos = hpos-1

	fnAddHeroHead(heroHid, ppos , pShowLevel)
	if(not pShowLevel) then
		if(ppos == heroPage) then
			fnAddHeroBody(heroHid, ppos)
			m_heroInitInfo[tostring(ppos)] = false
		else
			fnAddHeroBody(heroHid, hpos , true)
			m_heroInitInfo[tostring(ppos)] = heroHid
		end
	end
end

-----------------------------------------

local function removeOneArmorInfo( mtype )
	local i = tonumber(mtype)
	if(i < 1 or i > 4) then
		return
	end
	equipLabel[1][i]:setVisible(false)
	equipBtn[i]:removeChildByTag(i,true)
	local p_countImgbg = imgTips[i] or nil
	if(p_countImgbg) then
		p_countImgbg:setVisible(false)
		-- p_countImgbg:removeAllNodes()
	end
	local tbLevels = {widgetMain.IMG_WEAPON_LEVEL, widgetMain.IMG_NECKLACE_LEVEL, widgetMain.IMG_HEAD_LEVEL, widgetMain.IMG_ARMOR_LEVEL}
	tbLevels[i]:setVisible(false)
end

--去掉装备显示的内容图片以及文字
local function removeAllArmorInfo( ... )
	for i=1,4 do
		removeOneArmorInfo(i)
	end
end

local function removeOneTreasureInfo( mtype)
	local i = tonumber(mtype)
	if(i < 1 or i > 4) then
		return
	end
	equipLabel[2][i]:setVisible(false)
	mFTools.fnInitExclusiveAndFetterIcon(equipBtn[i+4],i)
	local p_countImgbg = imgTips[i+4] or nil
	if(p_countImgbg) then
		p_countImgbg:setVisible(false)
		-- p_countImgbg:removeAllNodes()
	end
	local tbLevels = {widgetMain.IMG_WIND_LEVEL, widgetMain.IMG_THUNDER_LEVEL, widgetMain.IMG_WATER_LEVEL}
	if tbLevels[i] then
		tbLevels[i]:setVisible(false)
	end
end

--去掉所有宝物的信息
local function removeAllTreasureInfo( )
	for i=1,4 do
		removeOneTreasureInfo(i)
	end
end

local function removeOneConchInfo( mtype , changeConchLayout)
	local i = tonumber(mtype)
	if(i < 1 or i > 6) then
		return
	end
	if(conch.label and conch.label[i] and (tonumber(conch.label[i]) ~= 0)) then
		conch.label[i]:setText("")
		conch.label[i]:setVisible(false)
	end
	if(conch.btn and conch.btn[i] and (tonumber(conch.btn[i]) ~= 0)) then
		conch.btn[i]:removeChildByTag(i,true)
	end
	local p_countImgbg = imgConchTips[i] or nil
	if(p_countImgbg) then
		p_countImgbg:setVisible(false)
	end

	if(changeConchLayout) then
		if(conch.conchLayout) then
		local pV = conch.conchLayout:isVisible()
			changeConch(pV)
		end
	end
end

--去掉战魂的信息
local function removeConchInfo( )
	--文字置空
	--装备去掉
	for i=1,6 do
		removeOneConchInfo(i , false)
	end

	if(conch.conchLayout) then
		local pV = conch.conchLayout:isVisible()
		changeConch(pV)
	end
end

local function fnResetAttTable( ... )
	for k,v in pairs(finalEquipAttr) do
		v = 0
		originEquipAttr[k] = 0
	end
end

local function removeAllLinkGroup( ... )
	for k,v in pairs(fetterLabels or {}) do
		v:setText("")
	end
	--战斗力信息显示空
	fnCleanNumberLabel()

	if (_newEffect ~= nil) then
		_newEffect:setVisible(false)
	end

	widgetMain.IMG_CAN_ACTIVATE_RED:setVisible(false)
	--yucong 不显示
	--heroQualityLabel:setStringValue("")
end

--显示伙伴羁绊技能
local function showHeroLinkGroupWithHero(heroInfo, heroHid)
	removeAllLinkGroup()
	local linkGroup = heroInfo.link_group1
	local linkGroupArr = nil
	local isHaveReached = false 	-- 是否存在可以激活的羁绊
	if linkGroup then
		local pNodes = fetterLabels
		linkGroupArr = lua_string_split(linkGroup, ",")
		require "db/DB_Union_profit"
		local tbLableNameInfo = {}
		for i,v in ipairs(linkGroupArr) do
			local heroUnionInfo = DB_Union_profit.getDataById(v)
			-- 检查某个羁绊是否开启
			local openUnion = false
			-- if (isNpc == false) then
				if (showSquadTye == SHOW_SELF_SQUAD) then
					--获取羁绊是否开启
					openUnion, _,  __, tBond = mFUtil.isUnionActive(v, heroHid)
					if (tBond.state == BondManager.BOND_REACHED) then
						isHaveReached = true
					end
				elseif (showSquadTye == SHOW_THEM_SQUAD) then
					local curHeroData   = getHeroInfoByHid(heroHid)
					openUnion = mFUtil.isBattleUnionActive(v, heroHid, curHeroData, externHeroInfo)
				end
			-- end

			local unionArributeIds = heroUnionInfo.union_arribute_ids
	        if (not tbLableNameInfo[unionArributeIds]) then
	            tbLableNameInfo[unionArributeIds] = {}
	            tbLableNameInfo[unionArributeIds].nums = 1
	        else
	            tbLableNameInfo[unionArributeIds].nums = tbLableNameInfo[unionArributeIds].nums + 1
	        end
	        -- 显示技能的名称index
	        local unionArributeIds = heroUnionInfo.union_arribute_ids
	        local LableNameIndex = "Ⅰ"
	        if (tonumber(tbLableNameInfo[unionArributeIds].nums) == 1 ) then
	            LableNameIndex =  "Ⅰ" 
	        elseif(tonumber(tbLableNameInfo[unionArributeIds].nums) == 2) then
	            LableNameIndex = "Ⅱ" 
	        elseif(tonumber(tbLableNameInfo[unionArributeIds].nums) == 3 ) then
	            LableNameIndex = "Ⅲ"
	        elseif(tonumber(tbLableNameInfo[unionArributeIds].nums) == 4) then
	            LableNameIndex =  "Ⅳ" 
	        end
	        local LableName = heroUnionInfo.union_arribute_type .. LableNameIndex

        	-- 根据检查结果显示不同的颜色
        	if (pNodes[i]) then
				pNodes[i]:setText(LableName)--(heroUnionInfo.union_arribute_type)
				pNodes[i]:setColor(openUnion and openUnionColor or normUnionColor)
			end
		end
	end

	_newEffect:setVisible(isHaveReached)
	widgetMain.IMG_CAN_ACTIVATE_RED:setVisible(isHaveReached)
	MainFormationTools.fnSetTips(widgetMain.IMG_CAN_ACTIVATE_RED, isHaveReached)
	widgetMain.IMG_CAN_ACTIVATE:setVisible(false)
end
--显示伙伴的三围等信息
local function showPartnerQualityAndMeasurements(herohid,heroInfo)
	local pInfo
	--读取属性
	if (showSquadTye == SHOW_SELF_SQUAD) then
		require "script/module/partner/HeroFightUtil"
		local pdic = HeroFightUtil.getAllForceValuesByHid(herohid)
		if(not table.isEmpty(pdic)) then
			pInfo = {pdic.life,pdic.physicalAttack,pdic.physicalDefend
					,pdic.magicAttack,pdic.magicDefend,pdic.speed}
		end
	elseif (showSquadTye   == SHOW_THEM_SQUAD) then
		local pif = getHeroInfoByHid(herohid)
		if(not table.isEmpty(pif)) then
			pInfo = {pif.max_hp,pif.physical_atk,pif.physical_def
						,pif.magical_atk,pif.magical_def,pif.speed}
		end
	end
	--设置属性
	for k,v in pairs(arrtNumLabels) do
		local pv = pInfo[k] or ""
		v:setText(pv)
	end
	local heroQuality = heroInfo.heroQuality
	--yucong 不显示
	--heroQualityLabel:setStringValue(heroQuality or "0")
end

local function getUserName( ... )
	if (showSquadTye == SHOW_SELF_SQUAD) then
		return mUModel.getUserName()
	elseif (showSquadTye == SHOW_THEM_SQUAD) then
		return externHeroInfo.uname
	end
end

--显示英雄的名称信息
local function showHeroNameInfo(heroInfo)
	local pName = ""
	local heroId = heroInfo.model_id
	if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or ((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
		if (showSquadTye == SHOW_SELF_SQUAD) then
			pName = mUModel.getUserName()
		elseif (showSquadTye == SHOW_THEM_SQUAD) then
			pName = externHeroInfo.uname
		end
	else
		pName = heroInfo.name
	end
	labHeroName:setText(pName)
	UIHelper.labelNewStroke(labHeroName, ccc3(0x28, 0x00, 0x00), 1)
	return pName
end

--显示英雄的星级
local function showHeroInfoStarLevel(heroInfo)
	local isOpen = false--SwitchModel.getSwitchOpenState(ksSwitchAwake)
	local level = DB_Switch.getDataById(ksSwitchAwake).level
	
	local nStar = 0
	if showSquadTye == SHOW_SELF_SQUAD then
		if (heroInfo and level <= UserModel.getHeroLevel() and heroInfo.localInfo.disillusion_consume_id) then
			isOpen = true
			nStar = tonumber(heroInfo.awake_attr.star_lv)
		end
	else
		if (heroInfo) then
			local dbHero = DB_Heroes.getDataById(tonumber(heroInfo.htid))
			if (level <= tonumber(externHeroInfo.level) and dbHero.disillusion_consume_id) then
				isOpen = true
				nStar = tonumber(heroInfo.awakeInfo.star_lv)
			end
		end
	end
	for i = 1, 5 do
		local starImg1 = g_fnGetWidgetByName(widgetMain, "IMG_STAR_ON"..i)
		local starImg2 = g_fnGetWidgetByName(widgetMain, "IMG_STAR"..i)
		if (not isOpen) then
		--if (true) then
			starImg1:setVisible(false)
			starImg2:setVisible(false)
		else
			starImg1:setVisible(i <= nStar)
			starImg2:setVisible(true)
		end
	end
end

local function showConchSpTip(v, pPos , pConch)
	local pI = tonumber(pPos)
	local showPoint = false 
	if(pI <= fitConchOpenPos) then
		showPoint = mItemUtil.justiceConchInfo(v, pConch)
	end
	local countImgbg
	if(pI >= 1 and pI <= 6) then
		countImgbg = imgConchTips[pI] or nil
	end
	return mFTools.fnSetTips(countImgbg, showPoint)
end

local function freshConchSpTip( pConch )
	if(showSquadTye ~= SHOW_SELF_SQUAD) then
		return false
	end
	local pB = false
	for i=1,6 do
		if(i <= fitConchOpenPos) then
			local v = pConch and pConch[tostring(i)] or nil
			local pShow = showConchSpTip(v,i,pConch)
			if(not pB and pShow) then
				pB = true
			end
		end
	end
	return pB
end

-- 创建空岛贝显示
local function showConchByInfo( pConch, pPos, pShowState)
	local v = pConch and pConch[tostring(pPos)] or nil
	local pI = tonumber(pPos)
	local conchItem, conchInfo
	local pShow = false
	if(v and tonumber(v) ~= 0) then
		conchItem, conchInfo = mItemUtil.createBtnByTemplateIdWithLevel(v, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if(isAutoScrolling()) then
					return
				end
				AudioHelper.playInfoEffect()
				v.heroPage = m_curPageNum
				v.hid = curHeroHid
				v.pos = pI
				v.equipType = conchInfo.type

				require "script/module/conch/ConchStrength/SkyPieaInfoCtrl"
				if(showSquadTye == SHOW_SELF_SQUAD) then
					if not isHeroExist(curHeroHid) then
						ShowNotice.showShellInfo(m_i18n[1211])
						return
					end
					fnCleanLabelAni()
					SkyPieaInfoCtrl.createForFormation(v ,m_curPageNum, imgConchTips[pI]:isVisible())--整容查看空岛贝
				elseif(showSquadTye == SHOW_THEM_SQUAD) then
					fnCleanLabelAni()
					SkyPieaInfoCtrl.createForOtherFormation(v,pConch, externHeroInfo.level)--他人整容查看空岛贝
				end
			end
		end, 3)
		if(pI > 0 and pI < 7) then
			conchItem:setTag(pI)
			conchItem:setTouchEnabled(pShowState)
			conch.btn[pI]:addChild(conchItem)
			pColor = HeroPublicUtil.getLightColorByStarLv(conchInfo.quality)
			conch.label[pI]:setColor(pColor)
			conch.label[pI]:setText(conchInfo.name)
			mUI.labelNewStroke(conch.label[pI])
			conch.label[pI]:setVisible(true)
		end
	end
	if(showSquadTye == SHOW_SELF_SQUAD) then
		if(pI <= fitConchOpenPos) then
			pShow = showConchSpTip(v,pI,pConch)
		end
	end
	return pShow
end

--显示空岛贝
local function showConch(pConch)
	removeConchInfo()
	local pColor
	local pShowState = conch.conchLayout:isVisible()
	local pB = false
	for i=1,6 do
		local pShow = showConchByInfo(pConch, i, pShowState)
		if(not pB and pShow) then
			pB = true
		end
	end
	return pB
end

--判断红点的显示
local function showEquipSpTip(v, pPos)
	local pI = tonumber(pPos)
	local showPoint = mItemUtil.justiceEquipOrTreasureInfo(v, pI, 1)
	local countImgbg
	if(pI >= 1 and pI <= 4) then
		countImgbg = imgTips[pI] or nil
	end
	--根据数据设置红点精灵的可见性
	logger:debug(showPoint)
	return mFTools.fnSetTips(countImgbg, showPoint)
end

--刷新红点
--return 是否有红点显示
local function freshEquipSpTip( equipTable )
	if(showSquadTye ~= SHOW_SELF_SQUAD) then
		return false
	end
	local pB = false
	for i,v in pairs(equipTable) do
		local pShow = showEquipSpTip(v,i)
		if(not pB and pShow) then
			pB = true
		end
	end
	return pB
end

local function showEquipByInfo(equipTable , pPos)
	local v = equipTable[tostring(pPos)] or 0
	local pI = tonumber(pPos)
	local armItem,armInfo,itemTemid
	local pShow = false
	local tbLevels = {widgetMain.IMG_WEAPON_LEVEL, widgetMain.IMG_NECKLACE_LEVEL, widgetMain.IMG_HEAD_LEVEL, widgetMain.IMG_ARMOR_LEVEL}
	local tbLabels = {"LABN_WEAPON_LEVEL", "LABN_NECKLACE_LEVEL", "LABN_HEAD_LEVEL", "LABN_ARMOR_LEVEL"}
	tbLevels[pI]:setVisible(false)
	if tonumber(v) ~= 0 then
		performWithDelayFrame(widgetBg, function ( ... )
			logger:debug("asfsdf")
			itemTemid = tonumber(v.item_template_id)
			--创建装备、宝物等图标按键
			armItem,armInfo = mItemUtil.createBtnByTemplateIdWithLevel(v, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					if(isAutoScrolling()) then
						return
					end
					v.heroPage = m_curPageNum
					v.equipType = armInfo.type
					v.hid = curHeroHid

					require "script/module/equipment/EquipInfoCtrl"
					AudioHelper.playInfoEffect()
					if showSquadTye == SHOW_SELF_SQUAD then
						if not isHeroExist(curHeroHid) then
							ShowNotice.showShellInfo(m_i18n[1211])
							return
						end
						fnCleanLabelAni()
						EquipInfoCtrl.createForFormation(v,m_curPageNum, imgTips[pI]:isVisible()) --zhangjunwu 2014-12-15 ,add m_curPageNum
						-- EquipInfoCtrl.updateEquipInfo() -- zhangqi, 2014-07-10
					elseif showSquadTye == SHOW_THEM_SQUAD then
						fnCleanLabelAni()
						EquipInfoCtrl.createForOtherFormation(v,equipTable, externHeroInfo.level)
						-- EquipInfoCtrl.updateEquipInfo() -- zhangqi, 2014-08-05, 加载装备信息面板后必须调用以满足套装面板的适配
					end
				end
			end, 1) -- zhangqi, 20140505, 弹出装备信息面板

			if(pI>0 and pI<5) then
				armItem:setTag(pI)
				local armColor = HeroPublicUtil.getLightColorByStarLv(armInfo.quality)
				equipBtn[pI]:addChild(armItem)
				equipLabel[1][pI]:setColor(armColor)
				equipLabel[1][pI]:setText(armInfo.name)
				mUI.labelNewStroke(equipLabel[1][pI])
				equipLabel[1][pI]:setVisible(true)
				if (SwitchModel.getSwitchOpenState(ksSwitchEquipFixed)) then
					tbLevels[pI]:setVisible(true)
					local levelLabel = m_getWidget(tbLevels[pI], tbLabels[pI])
					--levelLabel:setText(v.va_item_text.armEnchantLevel)
					levelLabel:setStringValue(v.va_item_text.armEnchantLevel or 0)
				end
			end
		end, _isLoadDelay and 1 or 0)
	end
	logger:debug(showSquadTye)
	if(showSquadTye == SHOW_SELF_SQUAD) then
		pShow = showEquipSpTip(v,pI)
	end
	return pShow
end

--显示装备
local function showEquip(equipTable)
	removeAllArmorInfo()
	local pB = false
	for i,v in pairs(equipTable) do
		local pShow = showEquipByInfo(equipTable,i)
		if(not pB and pShow) then
			pB = true
		end
	end
	return pB
end

--去往宝物详情界面
local function onTreaInfoEvent(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		if(isAutoScrolling()) then
			return
		end
		AudioHelper.playInfoEffect()
		local tbTreaInfo = tbTreaInfoData[""..sender:getTag()]
		fnCleanLabelAni()
		require "script/module/treasure/NewTreaInfoCtrl"

		-- require "script/module/treasure/treaInfoCtrl"
		if (showSquadTye == SHOW_THEM_SQUAD) then
			local isPlaying = BattleState.isPlaying()
			if (isHeroExist(curHeroHid)) then
				NewTreaInfoCtrl.createBtTid(tbTreaInfo.item_template_id, tbTreaInfo.va_item_text.treasureLevel, tbTreaInfo.va_item_text.treasureEvolve,3)
				return
			end
		end
		NewTreaInfoCtrl.createByItemId(tbTreaInfo.item_id,2, imgTips[sender:getTag()+4].isNeedChange)
	end
end

local function showTreasureSpTip( treasureInfo, i, pLay, treaTabel, onlyID, uniconIDs)
	local pShow = false	
	if (showSquadTye == SHOW_SELF_SQUAD) then
		local treaOpenPosNum = tonumber(treaOpenPos)
		local isNeedChange = false
		local canRefine = false
		if(i <= treaOpenPosNum) then
			isNeedChange = mItemUtil.justiceTreaInfo(treasureInfo, treaTabel, onlyID, uniconIDs)
			canRefine = ItemUtil.isTreasureCanRefine(treasureInfo)
		end
		-- local showPoint = mItemUtil.justiceEquipOrTreasureInfo(treasureInfo, i, 2)
		local countImgbg
		if(i >= 1 and i <= 3) then
			countImgbg = imgTips[i+4] or nil
		end
		pShow = mFTools.fnSetTips(countImgbg, isNeedChange or canRefine)
		countImgbg.isNeedChange = isNeedChange
		countImgbg.canRefine = canRefine
	end

	local pItid = -1
	if(treasureInfo and tonumber(treasureInfo) ~= 0) then
		pItid = treasureInfo.item_template_id or -1
	end

	local pHtid = getHeroInfoByHid(curHeroHid).htid
	local pExclusiveID = mFTools.getExclusiveTreaureID(pHtid)
	local pItem_template_ids = mFTools.getFetterTreaureID(pHtid)
	mFTools.getExclusiveAndFetterIcon(pLay , i , pItid , pExclusiveID , pItem_template_ids)
	return pShow
end

local function freshTreasureSpTip( treasure )
	local pB = false
	local treaOpenPosNum = tonumber(treaOpenPos)
	tbTreaInfoData = treasure
	local openTreasureLvArr = mFUtil.getTreasureOpenLvInfo()
	local pOnly, pUnion
	if(showSquadTye == SHOW_SELF_SQUAD) then
		pOnly, pUnion = mFUtil.fnGetOnlyAndUniconTrea(curHeroHid) 
	end
	for pPos,v in ipairs(openTreasureLvArr) do
		local treasureInfo = tbTreaInfoData[tostring(pPos)]
		local i = tonumber(pPos)
		local ppNum = i + 4
		local pLay = nil
		if (i <= treaOpenPosNum) then
			pLay = equipBtn[ppNum]
		end
		local pShow = showTreasureSpTip(treasureInfo, i, pLay, tbTreaInfoData, pOnly, pUnion)
		if(not pB and pShow) then
			pB = true
		end
	end
	return pB
end

local function showTreasureByInfo( treaInfos, pPos, onlyID, uniconIDs)
	local treaOpenPosNum = tonumber(treaOpenPos)
	local treasureInfo = treaInfos[tostring(pPos)]
	local i = tonumber(pPos)
	local pLay = nil
	local tbLevels = {widgetMain.IMG_WIND_LEVEL, widgetMain.IMG_THUNDER_LEVEL, widgetMain.IMG_WATER_LEVEL}
	local tbLabels = {"LABN_WIND_LEVEL", "LABN_THUNDER_LEVEL", "LABN_WATER_LEVEL"}
	tbLevels[i]:setVisible(false)
	if (i <= treaOpenPosNum) then
		local treaItem, treaInfo
		local ppNum = i + 4
		if (treasureInfo and tonumber(treasureInfo) ~= 0) then
			performWithDelayFrame(widgetBg, function ( ... )
				treaItem,treaInfo = mItemUtil.createBtnByTemplateIdWithLevel(treasureInfo, onTreaInfoEvent, 2) --zhangqi, 2014-05-05 ItemButton.createWithItemTempid(itemTemid)
				treaItem:setTag(i)    --|zhaoqiangjun再次修改
				
				if(ppNum < 9 and ppNum > 4) then
					equipBtn[ppNum]:addChild(treaItem)
					pLay = equipBtn[ppNum]
					local treaColor = HeroPublicUtil.getLightColorByStarLv(treaInfo.quality)
					equipLabel[2][i]:setColor(treaColor)
					equipLabel[2][i]:setText(treaInfo.name)
					mUI.labelNewStroke(equipLabel[2][i])
					equipLabel[2][i]:setVisible(true)
					if (tonumber(treaInfo.isUpgrade) == 1 and SwitchModel.getSwitchOpenState(ksSwitchTreasureFixed)) then
						tbLevels[i]:setVisible(true)
						local levelLabel = m_getWidget(tbLevels[i], tbLabels[i])
						-- levelLabel:setText(treasureInfo.va_item_text.treasureEvolve)
						levelLabel:setStringValue(treasureInfo.va_item_text.treasureEvolve or 0)
					end
				end
			end, _isLoadDelay and 1 or 0)
		end
	else
		local levelLabel = m_getWidget(widgetMain, "TFD_TREASURE_LOCKINFO" .. i)
		--mUI.labelNewStroke(levelLabel)
		local lvlOpenLab = m_getWidget(widgetMain, "TFD_TREASURE_JIKAIFANG" .. i)
		lvlOpenLab:setText(m_i18n[1201])
		--mUI.labelNewStroke(lvlOpenLab)
	end

	-- if(not onlyID or not uniconIDs) then
	-- 	return false
	-- end
	return showTreasureSpTip(treasureInfo, i, pLay, treaInfos, onlyID, uniconIDs)
end

function showSpecialTreasure( specialInfo )
	widgetMain.IMG_FIRE_LEVEL:setVisible(false)
	local btnLayer = widgetMain.BTN_TREASURE_FIRE
	-- 清空显示
	btnLayer:removeChildByTag(SpecialConst.TAG_SPECIAL_ICON, true)
	btnLayer.TFD_FIRE_NAME:setVisible(false)
	--btnLayer.IMG_FIRE_JIBAN:setVisible(false)
	--btnLayer.IMG_FIRE_ZHUANSHU:setVisible(false)
	btnLayer:setTouchEnabled(true)
	--logger:debug("specialInfo")
	-- 红点
	if (isHeroExist(curHeroHid) and showSquadTye == SHOW_SELF_SQUAD) then
		local isTip = FormationSpecialModel.isShowTip(curHeroHid)
		mFTools.fnSetTips(btnLayer.IMG_FIRE_TIP, isTip)
	end
	if (not specialInfo or table.isEmpty(specialInfo)) then
		return
	end
	if (not _speModel.checkSpecialLevel(otherLv)) then
		return
	end
	--logger:debug({specialInfo2 = specialInfo})
	local treaItem
	local treaInfo
	-- 创建图标
	treaItem, treaInfo = mItemUtil.createBtnByTemplateIdWithLevel(specialInfo, function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
			if (isAutoScrolling()) then
				return
			end
			fnCleanLabelAni()
			local id = tonumber(specialInfo.item_template_id)
			local evolve = tonumber(specialInfo.va_item_text.exclusiveEvolve)
			local data = {}
			local index = 0
			if (showSquadTye == SHOW_SELF_SQUAD) then
				local layer = SpecTreaInfoCtrl.create(id, evolve, specialInfo.item_id,0)
				LayerManager.addLayoutNoScale(layer)
			else
				-- 查看他人宝物信息，暂时不能滑动
    			local isPlaying = BattleState.isPlaying()
				local layer = SpecTreaInfoCtrl.create(id, evolve,nil, isPlaying and -1 or 2)
				LayerManager.addLayoutNoScale(layer)
			end
		end
	end, 4)
	treaItem:setTag(SpecialConst.TAG_SPECIAL_ICON)
	btnLayer:addChild(treaItem)
	-- 专属宝物名称
	local treaColor = HeroPublicUtil.getLightColorByStarLv(treaInfo.quality)
	btnLayer.TFD_FIRE_NAME:setColor(treaColor)
	btnLayer.TFD_FIRE_NAME:setText(treaInfo.name)
	mUI.labelNewStroke(btnLayer.TFD_FIRE_NAME)
	btnLayer.TFD_FIRE_NAME:setVisible(true)
	btnLayer:setTouchEnabled(false)
end

--显示宝物
local function showTreasure(treasure)
	tbTreaInfoData = treasure
	removeAllTreasureInfo()
	local pB = false
	local openTreasureLvArr = mFUtil.getTreasureOpenLvInfo()
	local pOnly, pUnion
	if(showSquadTye == SHOW_SELF_SQUAD) then
		pOnly, pUnion = mFUtil.fnGetOnlyAndUniconTrea(curHeroHid) 
	end
	for i,v in ipairs(openTreasureLvArr) do
		local pShow = showTreasureByInfo(treasure, i, pOnly, pUnion)
		if(not pB and pShow) then
			pB = true
		end
	end
	return pB
end

--读取原始的属性值。
local function readOriginalQuality( ... )
	local pNode = arrtNumLabels
	for k,v in pairs(pNode) do
		originEquipAttr[k] = v:getStringValue()
	end
end

--判断是否显示强化大师
local function fnIsHaveQHMaster( _heroInfo )
	if (showSquadTye ~= SHOW_SELF_SQUAD) then
		return false
	end
	local heroInfo = _heroInfo or nil
	if(not heroInfo) then
		return false
	end

	local armInfo 	= heroInfo.equip.arming
	local treasureInfo 	= heroInfo.equip.treasure
	local pCan = false
	for i=1 , 4 do
		local equip = armInfo[tostring(i)] or 0
		local treasure = treasureInfo[tostring(i)] or 0
		if (tonumber(equip) ~= 0) or (tonumber(treasure) ~= 0)then
			pCan = true
		end
	end
	
	if(pCan) then
		return true
	else
		return false
	end
end

--强化大师可用性
local function fnSetQHMasterAvailable( _herohid )
	local pDB , heroInfo = fnGetHeroDataByHid(_herohid)
	BTN_GURU = m_getWidget(widgetMain , "BTN_GURU")
	--对方不显示强化大师
	if(showSquadTye == SHOW_THEM_SQUAD) then
		_guruEffect:setVisible(false)
		-- 隐藏强化大师弹出框
		setGuruGroupVisible(false, false)
		return
	end
	widgetMain.BTN_GURU:setVisible(false)
	if(BTN_GURU and _guruEffect) then
		if(fnIsHaveQHMaster(heroInfo)) then 
			_guruEffect:setVisible(true)
			BTN_GURU:setTouchEnabled(true)
		else
			_guruEffect:setVisible(false)
			BTN_GURU:setTouchEnabled(false)
			-- 隐藏强化大师弹出框
			setGuruGroupVisible(false, false)
		end
	end
end

--点击伙伴头像时的信息
local function headTouchEventListener(herohid, doNotRead, pNotChangeEquips)
	TimeUtil.timeStart("MainFormation headTouchEventListener")
	showWidgetMain()
	--首先将文字设置为空
	labHeroName:setText(" ")
	logger:debug("headTouchEventListener")
	--labHeroJinJie:setStringValue("")
	--heroLevel:setText("")
	widgetMain.lay_lv_fit:setVisible(false)
	--强化大师按钮是否显示
	fnSetQHMasterAvailable(herohid)
	m_conchTip:setVisible(false)
	m_equipTip:setVisible(false)
	m_showTrea = false
	m_showAmr = false
	widgetMain.BTN_AWAKE:setVisible(false)
	widgetMain.BTN_AWAKE:setTouchEnabled(false)

	curHeroHid = tonumber(herohid)
	--3或者-1代表没有英雄
	if(not isHeroExist(curHeroHid)) then
		logger:debug("no hero")
		--清空所有数据显示
		fnResetAttTable()
		--imgAddJinJie:setVisible(false)
		removeAllLinkGroup()
		removeAllTreasureInfo()
		removeAllArmorInfo()
		removeConchInfo()
		showSpecialTreasure()
		showHeroInfoStarLevel()
		widgetMain.IMG_CAN_ADVANCE:setVisible(false)
		widgetMain.IMG_CAN_ADVANCE:setTouchEnabled(false)
		widgetMain.img_name_bg:setVisible(false)
		--显示星星层的隐藏
		--yucong 不显示
		--OddnStarLayout:setVisible(false)
		--EvenStarLayout:setVisible(false)
		if showSquadTye == SHOW_SELF_SQUAD  then
			equipBtn[9]:setVisible(false)
			equipBtn[9]:setEnabled(false)
		end

		require "script/module/guide/GuideFiveLevelGiftView"
		if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 6) then

			require "script/module/guide/GuideCtrl"
			GuideCtrl.createkFiveLevelGiftGuide(7)
			heroPageView:setTouchEnabled(false)
			mainPage:setTouchEnabled(false)
			hideActiveEffect()
		end

		require "script/module/guide/GuideCopy2BoxView"
		if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 10) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createCopy2BoxGuide(11)
			heroPageView:setTouchEnabled(false)
			mainPage:setTouchEnabled(false)
			hideActiveEffect()
		end

		require "script/module/guide/GuideForthFormationView"
		if (GuideModel.getGuideClass() == ksGuideForthFormation and GuideForthFormationView.guideStep == 2) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createForthFormationGuide(3,nil,function (  )
				GuideCtrl.removeGuide()
				heroPageView:setTouchEnabled(true)
				heroHeadList:setTouchEnabled(true)
			end)
			hideActiveEffect()
		end

		return
	else
		--imgAddJinJie:setVisible(true)
	end
	-- 需要显示装备以及切换英雄显示
	local heroInfo  = getHeroInfoByHid(herohid)
	local heroHtid = heroInfo.htid
	local heroDBInfo = mDBheros.getDataById(heroHtid)
	logger:debug("MUSIC NAME:"..(heroDBInfo.debut_word or "null"))
	stopHeroMusic()
	if (heroDBInfo.debut_word) then
		-- 屏蔽滑动人物音效
		if (doNotRead) then
			_curMusicId = AudioHelper.playHeroEffect(heroDBInfo.debut_word..".mp3")
		end
	end
	
	-- zhangqi, 2015-01-09, 去主角修改
	-- if HeroModel.isNecessaryHero(heroHtid) then
	-- 	equipBtn.fastExchangBtn:setVisible(false)
	-- 	equipBtn.fastExchangBtn:setEnabled(false)
	-- else
		if showSquadTye == SHOW_SELF_SQUAD  then
			equipBtn[9]:setVisible(true)
			equipBtn[9]:setEnabled(true)
		else
			equipBtn[9]:setVisible(false)
			equipBtn[9]:setEnabled(false)
		end
	-- end

	--装备
	local equip = nil
	if(showSquadTye == SHOW_SELF_SQUAD) then
		equip = heroInfo.equip
	elseif(showSquadTye == SHOW_THEM_SQUAD) then
		equip = heroInfo.equipInfo
	end
	if(not pNotChangeEquips) then
		-- 装备放置
		TimeUtil.timeStart("createEquip")
		local arming = equip.arming
		if arming then
			m_showAmr = showEquip(arming)
			if(m_showAmr) then
				m_equipTip:setVisible(true)
			end
		end
		TimeUtil.timeEnd("createEquip")
		TimeUtil.timeStart("createConch")
		-- 空岛贝放置。
		local pConch = equip.conch
		if pConch then
			local pB = showConch(pConch)
			if(pB) then
				m_conchTip:setVisible(true)
			end
		end
		TimeUtil.timeEnd("createConch")
		-- 时装显示的接口
		local dress = equip.dress
		if dress then
			-- 可以显示时装
		end
		TimeUtil.timeStart("createTreasure")
		-- 宝物放置
		local treasure = equip.treasure
		m_showTrea = showTreasure(treasure)
		if(m_showTrea) then
			m_equipTip:setVisible(true)
		end
		TimeUtil.timeEnd("createTreasure")
		-- 技能书显示
		local skillBook = equip.skillBook
		if skillBook then
			-- 可以显示技能书
		end
		_isLoadDelay = false
	else
		if(showSquadTye == SHOW_SELF_SQUAD) then
			local arming = equip.arming
			if(arming) then
				m_showAmr = freshEquipSpTip(arming)
				if(m_showAmr) then
					m_equipTip:setVisible(true)
				end
			end
			local pConch = equip.conch
			if(pConch) then
				local pB = freshConchSpTip(pConch)
				if(pB) then
					m_conchTip:setVisible(true)
				end
			end
		end
		local treasure = equip.treasure
		m_showTrea = freshTreasureSpTip(treasure)
		if(m_showTrea) then
			m_equipTip:setVisible(true)
		end
	end
	TimeUtil.timeStart("createExclusive")
	showSpecialTreasure(equip.exclusive[SpecialConst.SPECIAL_POS])
	TimeUtil.timeEnd("createExclusive")
	changeConch(conch.conchLayout:isVisible())

	local nameColor = HeroPublicUtil.getLightColorByStarLv(heroDBInfo.star_lv)
	labHeroName:setColor(nameColor)
	--等级
	--heroLevel:setText(tostring(heroInfo.level) .."/"..heroSumLevel)
	widgetMain.lay_lv_fit:setVisible(true)
	widgetMain.TFD_LVL_NOW:setText(tostring(heroInfo.level))
	widgetMain.TFD_LVL_LIMIT:setText(tostring(heroSumLevel))
	-- 更新位置
	widgetMain.TFD_LVL_NOW:setAnchorPoint(ccp(0, 0.5))
	widgetMain.TFD_SLANT:setAnchorPoint(ccp(0, 0.5))
	widgetMain.TFD_LVL_LIMIT:setAnchorPoint(ccp(0, 0.5))
	widgetMain.TFD_LVL_NOW:setPositionX(widgetMain.tfd_dengji:getPositionX() + widgetMain.tfd_dengji:getContentSize().width/2)
	widgetMain.TFD_SLANT:setPositionX(widgetMain.TFD_LVL_NOW:getPositionX() + widgetMain.TFD_LVL_NOW:getContentSize().width)
	widgetMain.TFD_LVL_LIMIT:setPositionX(widgetMain.TFD_SLANT:getPositionX() + widgetMain.TFD_SLANT:getContentSize().width)
	--显示伙伴羁绊技能
	showHeroLinkGroupWithHero(heroDBInfo, herohid)

	--显示资质以及三围
	showPartnerQualityAndMeasurements(herohid,heroDBInfo)
	--获得该伙伴的属性信息。
	if(doNotRead) then
		showFlyQuality()
	else
		readOriginalQuality()
	end
 
	--显示英雄的名字及其他问题
	local heroName = showHeroNameInfo(heroDBInfo)
	labHeroName:setText(heroName.." +"..tostring(heroInfo.evolve_level or 0))
	UIHelper.labelNewStroke(labHeroName, ccc3(0x28, 0x00, 0x00), 1)

	--显示英雄的星级
	showHeroInfoStarLevel(heroInfo)
	-- 是否可进阶
	if (isSelf()) then
		local isCanTrans = PartnerTransUtil.checkPartnerCanTransByHid(herohid)
		widgetMain.IMG_CAN_ADVANCE:setVisible(isCanTrans)
		widgetMain.IMG_CAN_ADVANCE:setTouchEnabled(isCanTrans)
	else
		widgetMain.IMG_CAN_ADVANCE:setVisible(false)
		widgetMain.IMG_CAN_ADVANCE:setTouchEnabled(false)
	end
	widgetMain.img_name_bg:setVisible(true)
	-- 觉醒入口
	local isOpen = SwitchModel.getSwitchOpenState(ksSwitchAwake)
	-- 功能节点开启 查看自己阵容 伙伴能觉醒
	if (showSquadTye == SHOW_SELF_SQUAD and isOpen and heroInfo.localInfo.disillusion_consume_id) then
		widgetMain.BTN_AWAKE:setVisible(true)
		widgetMain.BTN_AWAKE:setTouchEnabled(true)
		local isShowTip = MainAwakeModel.isCanAwakeByHid(curHeroHid)
		logger:debug(isShowTip)
		MainFormationTools.fnSetTips(widgetMain.IMG_AWAKE_TIP, isShowTip)
	end
	TimeUtil.timeEnd("MainFormation headTouchEventListener")
end

--重置英雄头像列表选中效果
local function fnSetHeroHeadFocus()
	local sumpage = tonumber(heroHeadList:getItems():count())
	for i = 1,sumpage,1 do
		local heroHead 	= tolua.cast(heroHeadList:getItem(tonumber(i - 1)), "Layout")
		local heroTag 	= heroHead:getTag()
		if tonumber(heroTag) ~= 0 then
			local headFrameImage = m_getWidget(heroHead, "IMG_FRAME_BG")
			
			local highImg = headFrameImage:getChildByTag(tonumber(focusTag))
			highImg:setVisible(false)
		end
	end
end

--偏移滑动列表的位置
local function OffsetPage( page, heroHead )
	local hwidth = heroHeadList:getViewSize().width
	local curOffset = heroHeadList:getHContentOffset()
	local mostOffset = curOffset - hwidth
	local needOffset = page * heroHead:getSize().width
	local herowidth = heroHead:getSize().width	

	local pNumber = heroHeadList:getItems():count()
	if(page == 0) then
		heroHeadList:jumpToLeft()
	else
		local pW = nil
		--当前偏移
		if (needOffset < - curOffset) then
			if(needOffset + herowidth > - curOffset) then
				heroHeadList:setContentOffset(ccp(- (page-1) * herowidth, 0), false)
			else
				heroHeadList:setContentOffset(ccp(- page * herowidth, 0), false)
			end
		elseif(needOffset + herowidth > - mostOffset) then
			heroHeadList:setContentOffset(ccp(mostOffset, 0), false)
		end

		local pW = nil
		if(pW) then
			local pPercent =  math.abs(pW)/ hwidth * 100
			heroHeadList:jumpToPercentHorizontal(pPercent)
		end
	end
end

--滑动英雄身像
local function heroPageViewEventListener(sender, eventType)
	if (eventType == PAGEVIEW_EVENT_TURNING) then

		local pageView = tolua.cast(sender, "PageView")
		local page = pageView:getCurPageIndex()
		local sumpage = heroPageView:getPages():count()
		
		if page ~= m_curPageNum then
			fnCleanLabelAni()
			--设置头像的焦点
			fnSetHeroHeadFocus()
			--获取头像实例
			local heroHead = tolua.cast(heroHeadList:getItem(tonumber(page)), "Button")
			local heroTag = heroHead:getTag()
			--头像的背景
			local headFrameImage = m_getWidget(heroHead, "IMG_FRAME_BG")
			local highImg = headFrameImage:getChildByTag(tonumber(focusTag))
			highImg:setVisible(true)

			local pNum = page+1
			--取hid
			if(m_heroInitInfo and m_heroInitInfo[tostring(page)]) then
				fnAddHeroBody(m_heroInitInfo[tostring(page)],pNum,true)
				m_heroInitInfo[tostring(page)] = false
			end

			--根据ListView的偏移来改变位置。
			OffsetPage(page, heroHead)

			--查看偏移位置。
			m_curPageNum = page
			local herohid = tonumber(heroHead:getTag())
			--手动调用点击头像的
			headTouchEventListener(herohid)
			--记录当前人物的属性值，用于显示变化的label
			rememberQuality()
		else
			if page + 1 == sumpage  and m_outPageNum == 0 and pageView:getTouchDir() == 2 then
				-- if(not layHeroInfoLayout) then
				-- 	fnInitLittleFriendPage()
				-- end
				scrollMainPage(1)
				logger:debug("scroll to ship")
			elseif(pageView:getTouchDir() == 1) then
				scrollMainPage(0)
			end
		end
		--事件过后直接设置为false，重置点击事件。
	end
end

--滑动整个列表
local function mainPageViewEventListener(sender, eventType)
	if (eventType == PAGEVIEW_EVENT_TURNING) then
		logger:debug("mainPage scroll")
		local pageView = tolua.cast(sender, "PageView")
		local page = pageView:getCurPageIndex()
		local curHeroPage = heroPageView:getCurPageIndex()
		fnSetHeroHeadFocus()
		local pCount , pNumber
		if (page == 1) then
			pCount = tonumber(heroHeadList:getItems():count()) - 1
			pNumber = heroHeadList:getItems():count()
			--切换页面时，需要将小伙伴界面上的推荐伙伴页面给移除。
			mFormLitFriV.closeRecomFri()
			-- if(layHeros) then
			-- 	layHeros:setVisible(false)
			-- end
			-- if(layHeroInfoLayout) then
			-- 	layHeroInfoLayout:setVisible(true)
			-- end
			pageView:setTouchEnabled(true)
		elseif(page == 0) then
			-- if(layHeros) then
			-- 	layHeros:setVisible(true)
			-- end
			-- if(layHeroInfoLayout) then
			-- 	layHeroInfoLayout:setVisible(false)
			-- end
			heroPageView:setTouchEnabled(not BTUtil:getGuideState())
			mFTools.fnSetLinkNumberTrue()
			pCount = curHeroPage
			pNumber = m_curPageNum
			pageView:setTouchEnabled(false)
		end
		if(pCount and pNumber) then
			local heroHead = tolua.cast(heroHeadList:getItem(pCount), "Button")
			local heroTag = heroHead:getTag()
			local headFrameImage = m_getWidget(heroHead, "IMG_FRAME_BG")
			local highImg = headFrameImage:getChildByTag(tonumber(focusTag))
			highImg:setVisible(true)

			OffsetPage(pNumber, heroHead)
			if(page == 0) then
				if((showSquadTye == SHOW_SELF_SQUAD) and (tonumber(heroTag) > 3))then
					local heroInfo = HeroModel.getHeroByHid(heroTag)
					local herotid = heroInfo.htid
					local heroData = mDBheros.getDataById(herotid)
					showHeroLinkGroupWithHero(heroData, heroTag)
					showPartnerQualityAndMeasurements(heroTag, heroData)
				end
			end
		end
		m_outPageNum = page
	end
end

--为指定位置加上伙伴
--pshowChange: 是否显示更新效果 pshowAllChange:是否更新所有数据 pNotChangeEquips: 是否更新装备
local function heroHeadImageAndEventListenerWithPos(herohid , hpos , pshowChange , pshowAllChange, pNotChangeEquips)
	local heroInfo = HeroModel.getHeroByHid(herohid)
	if(m_heroInitInfo and m_heroInitInfo[tostring(hpos-1)]) then
		m_heroInitInfo[tostring(hpos-1)] = false
	end

	if(not heroInfo) then
		if(pshowAllChange) then
			curheroHid = 3
			headTouchEventListener(3 , pshowChange)
		end
		fnAddHeroHead(nil , hpos , nil , true)
		fnAddHeroBody(nil , hpos , true , false)
		return
	else
		fnAddHeroHead(herohid , hpos , nil , true)
		fnAddHeroBody(herohid , hpos , true , pshowChange)
	end

	local heroData = mDBheros.getDataById(heroInfo.htid)

	--直接修改一些东西,比如名字
	if(pshowAllChange) then
		curheroHid = herohid
		logger:debug(curHeroHid)
		if(_showChange) then
			local pName = showHeroNameInfo(heroData)
			mNewChangeHero = heroInfo
			mFTools.showUpName(pName)
		end
		headTouchEventListener(herohid, pshowChange, pNotChangeEquips)
	end

end

-- 选择上阵小伙伴
local function showSelectLittleFriendView(heroInfo ,litHeroPos)
	if heroInfo then
		require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = heroInfo--PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        logger:debug({pHeroValue=pHeroValue})
        local tbherosInfo = {}
        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.id ,strengthenLevel = pHeroValue.sLevel ,transLevel = pHeroValue.evolve_level,heroValue = pHeroValue }
        table.insert(tbherosInfo,heroInfo)
        local tArgs = {}
        tArgs.tbHeros = tbherosInfo
        tArgs.index = 1
        logger:debug({tArgs=tArgs})
        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer)

	else
		require "script/module/formation/FriendSelectCtrl"
		local pFriendSelect = FriendSelectCtrl
		local battleCompanModule = pFriendSelect.create(2, litHeroPos, curHeroHid)
		mLayerM.addLayoutNoScale(battleCompanModule, widgetMain)
	end
end

-- 显示伙伴羁绊信息
local function showLittFriendLinkGroupInfo( p_litFriendData, p_benchData , p_level)
	local pLitFriendData = p_litFriendData or nil
	local pBenchData = p_benchData or nil

	local pLevel = tonumber(p_level) or 0

	if(showSquadTye == SHOW_SELF_SQUAD) then
		if(not pLitFriendData) then
			pLitFriendData = mData:getSquad()
		end
		if(not pBenchData) then
			pBenchData = mData:getBench()
		end
		if(not pLevel or pLevel == 0) then
			pLevel = mUModel.getHeroLevel()
		end
	end

	local tbLitFriend = {
		benchOpen = mFTools.fnGetBenchNum(pLevel) , 
		heroOpenForm = heroOpenForm ,
		squadType = showSquadTye ,
		litFriendData = pLitFriendData ,
		benchData = pBenchData ,
		uname = getUserName() ,
	}
	if (showSquadTye == SHOW_THEM_SQUAD) then
		tbLitFriend.externHero = externHeroInfo
	end

	if(not layHeroInfoLayout) then
		logger:debug("mainPage addWidgetToPage")
		--加载小伙伴界面
		layHeroInfoLayout = m_fnLoadUI(jsonforLittle)
		mainPage:removePageAtIndex(1)
		mainPage:addWidgetToPage(layHeroInfoLayout,1,true)
		mainPage:visit()
		local heroLayout = m_getWidget(layHeroInfoLayout,"LAY_JIBAN")
		heroLayout:removeFromParent()
	end
	mFormLitSCV.createFormLitFriend(tbLitFriend, layHeroInfoLayout)
	if(heroPageView) then
		if(heroPage > showLitFriPos) then
			mFormLitSCV.fnShowJiBan()	
		end		
		heroHeadList:visit()
	end
end

--显示小伙伴界面
local function showLittleFriendView(retArr)
	-- local extraData = retArr
	-- if(not extraData) then
	-- 	extraData = mData.getExtra()
	-- end

	-- if showSquadTye == SHOW_SELF_SQUAD then
	-- 	-- mFormLitFriV.create(layHeroInfoLayout, extraData , nil, litHeroOpenPos, widgetBg)
	-- 	mFormLitFriV.create(layHeroInfoLayout, extraData , nil, widgetBg)
	-- else
	-- 	-- litHeroOpenPos = 8 					--他人位置的不显示是否开启小伙伴位置。
	-- 	-- mFormLitFriV.create(layHeroInfoLayout, extraData , externHeroInfo, litHeroOpenPos, widgetBg)
	-- 	mFormLitFriV.create(layHeroInfoLayout, extraData , externHeroInfo, widgetBg)
	-- end
end

local function sortSquadData( squadData )
	local sortTable = {}
	for key,value in pairs(squadData or {}) do
		sortTable[tonumber(key)] = value
	end
	return sortTable
end

--添加头像，并且设置事件。
--p_retData: 阵容信息
--p_benchData: 替补信息
local function refreshHeadListView( p_retData , p_benchData)
	local retData = p_retData or nil
	local pBenchData = p_benchData or nil
	if(showSquadTye == SHOW_SELF_SQUAD) then
		if(not retData) then
			retData = mData:getSquad()	
		end
		if(not pBenchData) then
			pBenchData = mData:getBench()
		end
	end

	if (heroHeadList) then
		TimeUtil.timeStart("createFormationData")
		local formationData = {}
		--添加正常的头像
		local pSquadTable = mFTools.fnSortData(retData)
		local pSqNum = mFTools.fnGetSquadNum()
		for i = 1 , pSqNum do
			local v = 0
			if(showSquadTye == SHOW_SELF_SQUAD) then
				v = pSquadTable[i-1] or nil
			elseif(showSquadTye == SHOW_THEM_SQUAD) then
				v = pSquadTable[i] or nil
			end
			--fnHeroHeadInit(v,i)
			formationData[i] = tonumber(v)
		end

		--替补按钮
		local pBenchTable = mFTools.fnSortData(pBenchData)
		local pLevel = tonumber(mUModel.getHeroLevel())
		if(showSquadTye == SHOW_THEM_SQUAD) then
			pLevel = tonumber(otherLv)
		end
		local pBenchNum = mFTools.fnGetBenchNum(pLevel)
		for key = 1 , pBenchNum do
			local v = 0
			if(showSquadTye == SHOW_SELF_SQUAD) then
				v = pBenchTable[key-1] or 0
			elseif(showSquadTye == SHOW_THEM_SQUAD) then
				local pInfo = pBenchTable[key] or nil
				if(pInfo and (tonumber(pInfo) ~= 0)) then
					v = pInfo.hid or 0
				end
			end
			local i = key + pSqNum
			--fnHeroHeadInit(v,i)
			formationData[i] = tonumber(v)
		end

		if (showSquadTye == SHOW_THEM_SQUAD) then
			for i = 1, #formationData do
				for j = i + 1, #formationData do
					local v1 = formationData[i]
					local v2 = formationData[j]
					if (v1 == 0 and v2 ~= 0) then
						local temp = formationData[i]
						formationData[i] = formationData[j]
						formationData[j] = temp
					end
				end
			end
		end
		TimeUtil.timeEnd("createFormationData")
		TimeUtil.timeStart("createHeadAndBody") -- 66ms
		for k,v in pairs(formationData) do
			fnHeroHeadInit(v,k)
		end
		-- 添加主船头像
		if (externHeroInfo) then
			fnAddShipHead(externHeroInfo.main_ship, #formationData + 1)
		end
		logger:debug({formationData = formationData})
		TimeUtil.timeEnd("createHeadAndBody")
			
		heroHeadList:removeItem(0)

		heroPage = heroPage or 0
		heroPage = heroPage < 0 and 0 or heroPage
		if(heroPage < showLitFriPos) then
			local pListCount = tonumber(heroHeadList:getItems():count())-- - 1
			heroPage = heroPage < pListCount and heroPage or 0
		end

		if(heroPage < showLitFriPos) then
			--显示当前的用户信息。
			heroPageView:initToPage(heroPage)
			scrollMainPage(0)
		else
			headTouchEventListener(3)
			performWithDelay(widgetBg,function()
				if(not layHeroInfoLayout) then
					fnInitLittleFriendPage()
				end
				scrollMainPage(1)
			end,0.01)	
		end		
		heroHeadList:visit()
	end
end

--初始化武将查看pageView
local function fnInitHeroPageView()
	--武将滑动层
	heroPageView = m_getWidget(widgetMain, "PGV_HERO")
	if (heroPageView) then
		heroPageView:addEventListenerPageView(heroPageViewEventListener)
	end

end
--初始化上阵页面的PageView
local function fnInitFormationPageView()
	mainPage = m_getWidget(widgetMain, "PGV_MAIN")

	if (mainPage) then
		mainPage:addEventListenerPageView(mainPageViewEventListener)
		mainPage:setTouchEnabled(false)

		layHeros = m_getWidget(mainPage, "LAY_HEROS")
	end
	if (showSquadTye == SHOW_THEM_SQUAD) then
		local shipId = tonumber(externHeroInfo.main_ship) or 0
		logger:debug("主船id:"..shipId)
		if (shipId > 0) then
			layHeroInfoLayout = ShipInfoCtrl.createViewForFormation(externHeroInfo.main_ship_info)
			mainPage:removePageAtIndex(1)
			mainPage:addWidgetToPage(layHeroInfoLayout,1,true)
			mainPage:visit()
		end
	end
end

--绑定按钮与事件
local function fnBindBtnCallback(p_equipBtn,p_equipcallBack)
	if(not p_equipBtn or not p_equipcallBack) then
		return 
	end

	p_equipBtn:addTouchEventListener(function (sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			--显示英雄选择界面。
			if(isAutoScrolling()) then
				return
			end
			p_equipcallBack(sender)
		end
	end)
end

--处理装备空岛贝的请求
local function oneKeyConchCallBack( cbFlag, dictData, bRet )
	if(bRet) then

		local equip = dictData.ret
		if (table.count(equip.conch) > 0) then
			ShowNotice.showShellInfo(m_i18n[1212])
		else
			ShowNotice.showShellInfo(m_i18n[1213])
			return
		end

		mUModel.updateFightValue()

		fnCleanLabelAni()

		local heroInfo = HeroModel.getHeroByHid(curHeroHid)
		local pChangesType = {0,0,0,0}
		if equip.conch then
			--等级
			--heroLevel:setText(tostring(heroInfo.level).."/"..heroSumLevel)
			widgetMain.TFD_LVL_NOW:setText(tostring(heroInfo.level))
			widgetMain.TFD_LVL_LIMIT:setText(tostring(heroSumLevel))
			--装备
			local heroequip = heroInfo.equip
			-- 装备放置
			local heroconch = heroequip.conch
			local pConch = heroconch
			for k,v in pairs(equip.conch) do
				local p1 = pConch[k] and pConch[k].item_id or 0
				local p2 = v and v.item_id or 0
				if(tonumber(p1) ~= tonumber(p2)) then
					pChangesType[tonumber(k)] = k
				end
				--对于原来在背包中的需要去掉
				pConch[k] = v
				mItemUtil.solveBagLackInfo(v, 3)
			end
			local pShowState = conch.conchLayout:isVisible()
			for k,v in pairs(pChangesType) do
				if(v and tonumber(v) ~= 0) then
					removeOneConchInfo(v,true)
					showConchByInfo(pConch,v,pShowState)
				end
			end

			local pB = freshConchSpTip(pConch)
			if(pB) then
				m_conchTip:setVisible(true)
			else
				m_conchTip:setVisible(false)
			end 
		end

		local heroHtid          = heroInfo.htid
		local heroDBInfo        = mDBheros.getDataById(heroHtid)

		--显示资质以及三围
		showPartnerQualityAndMeasurements(curHeroHid,heroDBInfo)
		--飘字。
		mUModel.setInfoChanged(true)
		mUModel.updateFightValue()
		showFlyQuality()
	end
end

--处理装备装备和宝物的请求(一键装备的网络回调)
local function oneKeyEquipMentsCallBack(cbFlag, dictData, bRet)
	if bRet then
		--获取到可以一键装备的装备
		local equip = dictData.ret
		if (table.count(equip.arming) > 0 or table.count(equip.treasure) > 0) then
			ShowNotice.showShellInfo(m_i18n[1212])	--装备成功
		else
			ShowNotice.showShellInfo(m_i18n[1213])	--当前没有装备
			return
		end
		
		mUModel.updateFightValue()

		fnCleanLabelAni()
		
		local heroInfo = HeroModel.getHeroByHid(curHeroHid)
		local pChangesType = {0,0,0,0}
		local pB = false

		require "script/module/formation/MainEquipMasterCtrl"
		local befor = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(heroInfo)

		if(equip.arming) then
			--等级
			--heroLevel:setText(tostring(heroInfo.level).."/"..heroSumLevel)
			widgetMain.TFD_LVL_NOW:setText(tostring(heroInfo.level))
			widgetMain.TFD_LVL_LIMIT:setText(tostring(heroSumLevel))
			--装备
			local heroequip = heroInfo.equip
			-- 装备放置
			local heroarming = heroequip.arming
			local arming = heroarming
			
			for k,v in pairs(equip.arming) do
				local p1 = arming[k] and arming[k].item_id or 0
				local p2 = v and v.item_id or 0
				if(tonumber(p1) ~= tonumber(p2)) then
					pChangesType[tonumber(k)] = k
				end
				arming[k] = v
				if(v and v.item_template_id) then

				    --对于原来在背包中的需要去掉
				    mItemUtil.solveBagLackInfo(v, 1)

					local pDb = mItemUtil.getItemById(v.item_template_id)
					local suitID = pDb.jobLimit or nil
					if(suitID) then
						if(not mLastChangeEquipInfo) then
							mLastChangeEquipInfo = { }
						end
						if(not mLastChangeEquipInfo[""..suitID]) then
							mLastChangeEquipInfo[""..suitID] = { suit = suitID , info = {}}
						end
						local ppTB = {name = pDb.name, quality = pDb.quality}
						table.insert(mLastChangeEquipInfo[""..suitID].info , ppTB)
					end
				end
			end

			if(mLastChangeEquipInfo) then
				local armID = {}
				for k,v in pairs(arming) do
					if(v.item_template_id) then
						table.insert(armID,v.item_template_id)
					end
				end
				mLastChangeEquipInfo.arm = armID
			end

			for k,v in pairs(pChangesType) do
				if(v and tonumber(v) ~= 0) then
					removeOneArmorInfo(v)
					local pShow = showEquipByInfo(arming,v)
					if(pShow) then
						pB = true
					end
				end
			end

		end

		pChangesType = {0,0,0,0}
		if equip.treasure then
			--等级
			--heroLevel:setText(tostring(heroInfo.level).."/"..heroSumLevel)
			widgetMain.TFD_LVL_NOW:setText(tostring(heroInfo.level))
			widgetMain.TFD_LVL_LIMIT:setText(tostring(heroSumLevel))
			--装备
			local heroequip     = heroInfo.equip
			-- 装备放置
			local herotreasure  = heroequip.treasure
			local treasure      = herotreasure
			for k,v in pairs(equip.treasure) do
				local p1 = treasure[k] and treasure[k].item_id or 0
				local p2 = v and v.item_id or 0
				if(tonumber(p1) ~= tonumber(p2)) then
					pChangesType[tonumber(k)] = k
				end
				--对于原来在背包中的需要去掉
				mItemUtil.solveBagLackInfo(v, 2)

				v.equip_hid = "" .. curHeroHid
				v.pos = "" .. k
				treasure[k]     = v
			end
			for k,v in pairs(pChangesType) do
				if(v and tonumber(v) ~= 0) then
					removeOneTreasureInfo(v)
					local pShow = showTreasureByInfo(treasure,v)
					-- if(pShow) then
					-- 	pB = true
					-- end
				end
			end
			local pShow = freshTreasureSpTip(treasure)
			if(pShow) then
				pB = true
			end
		end

		if(pB) then
			m_equipTip:setVisible(true)
		else
			m_equipTip:setVisible(false)
		end

		require "script/module/formation/MainEquipMasterCtrl"
		local after = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(heroInfo)
		local pStringinfo = MainEquipMasterCtrl.fnGetAllMasterChangeString(befor,after)
		
		mUModel.setInfoChanged(true)
		mUModel.updateFightValue({[curHeroHid] = {}})

		local heroHtid          = heroInfo.htid
		local heroDBInfo        = mDBheros.getDataById(heroHtid)
		removeAllLinkGroup()
		--显示伙伴羁绊技能
		showHeroLinkGroupWithHero(heroDBInfo, curHeroHid)
		--显示资质以及三围
		showPartnerQualityAndMeasurements(curHeroHid,heroDBInfo)
		--飘字。
		showFlyQuality(nil, pStringinfo)

		--刷新下羁绊信息
		mFormLitSCV.refreshScrollView()
		--清空装备背包数据 ,背包推送后会重新初始化装备背包的数据
		require "script/module/equipment/MainEquipmentCtrl"
		MainEquipmentCtrl.cleanArmData()

		fnSetQHMasterAvailable(curHeroHid)
	end
end

--显示数字变化
local function showNumerChangeAni( ... )
	mFTools.showAttrChangeInfo( mFTools.fnShowFightForceChangeAni )
end

--打开强化大师
local function fnShowEquipMaster( p_index , p_heroInfo)
	local heroInfo = p_heroInfo
	local pindext = p_index
	if(not heroInfo) then
		heroInfo = getHeroInfoByHid(curHeroHid) or nil
	end
	require "script/module/formation/MainEquipMasterCtrl"
	--MainEquipMasterCtrl.create(heroInfo , m_curPageNum , pindext)
	mLayerM.addLayoutNoScale(MainEquipMasterCtrl.create(heroInfo , m_curPageNum , pindext), mLayerM.getModuleRootLayout())
	PlayerPanel.addForStrenMaster()
end


--[[desc:强化大师的按键处理
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]

function onKeyEquipMaster( sender, eventType )
	if (not widgetMain.IMG_GURU_BG:isVisible()) then
		return
	end
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if(not isHeroExist(curHeroHid)) then
			ShowNotice.showShellInfo(m_i18n[1211])	--当前阵上没有伙伴
			return;
		end

		local heroInfo 	= getHeroInfoByHid(curHeroHid) or nil
		if(not heroInfo) then
			ShowNotice.showShellInfo(m_i18n[1211])	--当前阵上没有伙伴
			return 
		end

		local armInfo 	= heroInfo.equip.arming
		local treasureInfo 	= heroInfo.equip.treasure
		local pCan = false
		--英雄是否有穿戴装备或者宝物
		for i=1 , 4 do
			local equip = armInfo[tostring(i)] or 0
			local treasure = treasureInfo[tostring(i)] or 0
			if (tonumber(equip) ~= 0) or (tonumber(treasure) ~= 0)then
				pCan = true
			end
		end
		fnCleanLabelAni()
		if(pCan) then
			fnShowEquipMaster(nil,heroInfo)
		else
			ShowNotice.showShellInfo(m_i18n[1248])	--当前伙伴没有任何装备或宝物
		end
	end
end

function setGuruGroupVisible( visible, isPlay )
	if (isPlay == nil) then
		isPlay = true
	end
	if (isPlay) then
		local action = nil
		if (visible) then
			action = FormationUtil.getGuruPopAction(widgetMain.IMG_GURU_BG)
		else
			action = FormationUtil.getGuruPushAction(widgetMain.IMG_GURU_BG)
		end
		widgetMain.IMG_GURU_BG:runAction(action)
	else
		widgetMain.IMG_GURU_BG:setVisible(visible)
		widgetMain.IMG_GURU_BG:setTouchEnabled(visible)
	end
end

-- 强化组按键
function onBtnMasterGroup( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local visible = not widgetMain.IMG_GURU_BG:isVisible()
		setGuruGroupVisible(visible)
	end
end

-- 全身强化
function onBtnAutoStren( sender, eventType )
	if (not widgetMain.IMG_GURU_BG:isVisible()) then
		return
	end
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		MainEquipMasterCtrl.fnGetAllStrOpenLv()
		if (not MainEquipMasterCtrl.isOneKeyEnabled(true)) then
			return
		end
		
		local heroInfo  = getHeroInfoByHid(curHeroHid)
		g_attribManager:createBoardLight({
			bRetain = true,
		})
		MainEquipMasterCtrl.onAutoStren(heroInfo, function ( tbMasterChangeData )
			logger:debug("onBtnAutoStrenOK")
			updateHeroEquipment(nil, true)
			--readOriginalQuality()
			rememberQuality()

			local attribDes = {"life", "physicalAttack", "physicalDefend", "magicAttack", "magicDefend", "speed"}
			for k,v in pairs(arrtNumLabels) do
				v:setText(tbMasterChangeData.orignData[attribDes[k]])
			end
			--CCDirector:sharedDirector():getScheduler():setTimeScale(0.4)
			-- 创建属性板出现的特效
			local particleWidgets = {}
			local playLayer = nil
			function createBoardEffect( ... )
				particleWidgets = MainFormationTools.playAutoStrenEffect(tbMasterChangeData, arrtNumLabels)
				-- 创建粒子特效
				for k, pos in pairs(particleWidgets) do
					local particleEffect = g_attribManager:createJinJieShuZi({
						fnMovementCall = function ( sender, MovementEventType, frameEventName )
							if (MovementEventType == 1) then
								sender:removeFromParentAndCleanup(true)
							end
						end,
					})
					particleEffect:setAnchorPoint(ccp(0.5, 0.5))
					particleEffect:setPosition(pos)
					_effectLayer:addNode(particleEffect)
				end
				
				-- local boardEffect = g_attribManager:createBoardLight({
				-- 	fnMovementCall = function ( sender, MovementEventType, frameEventName )
				-- 		if (MovementEventType == 1) then
				-- 			sender:removeFromParentAndCleanup(true)
				-- 			-- 创建粒子特效
				-- 			for k, pos in pairs(particleWidgets) do
				-- 				local particleEffect = g_attribManager:createJinJieShuZi({
				-- 					fnMovementCall = function ( sender, MovementEventType, frameEventName )
				-- 						if (MovementEventType == 1) then
				-- 							sender:removeFromParentAndCleanup(true)
				-- 						end
				-- 					end,
				-- 				})
				-- 				particleEffect:setAnchorPoint(ccp(0.5, 0.5))
				-- 				particleEffect:setPosition(pos)
				-- 				_effectLayer:addNode(particleEffect)
				-- 			end
				-- 		end
				-- 	end,
				-- 	fnFrameCall = {
				-- 		function ( ... )
				-- 			particleWidgets = MainFormationTools.playAutoStrenEffect(tbMasterChangeData, arrtNumLabels)
				-- 			-- if (playLayer) then
				-- 			-- 	playLayer:runAction(playLayer.getBgAction())
				-- 			-- 	playLayer = nil
				-- 			-- end
				-- 		end,
				-- 		function ( ... )
				-- 			-- -- 创建粒子特效
				-- 			-- for k, pos in pairs(particleWidgets) do
				-- 			-- 	local particleEffect = g_attribManager:createJinJieShuZi({
				-- 			-- 		fnMovementCall = function ( sender, MovementEventType, frameEventName )
				-- 			-- 			if (MovementEventType == 1) then
				-- 			-- 				sender:removeFromParentAndCleanup(true)
				-- 			-- 			end
				-- 			-- 		end,
				-- 			-- 	})
				-- 			-- 	particleEffect:setAnchorPoint(ccp(0.5, 0.5))
				-- 			-- 	particleEffect:setPosition(pos)
				-- 			-- 	_effectLayer:addNode(particleEffect)
				-- 			-- end
				-- 		end,
				-- 	},
				-- })
				-- boardEffect:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
				-- _effectLayer:addNode(boardEffect)
			end
			logger:debug(tbMasterChangeData.tChangePos)
			local equipImgs = {widgetMain.img_weaponframe, widgetMain.img_necklaceframe, widgetMain.img_headframe, widgetMain.img_armorframe}
			local equipCount = table.count(tbMasterChangeData.tChangePos)
			logger:debug(equipCount)
			-- particleWidgets, playLayer = MainFormationTools.playAutoStrenEffect(tbMasterChangeData, arrtNumLabels)
			AudioHelper.playEffect("audio/effect/texiao_allqianghua.mp3")
			for k, widget in pairs(equipImgs) do
				local equipInfo = heroInfo.equip.arming[tostring(k)]
				if (tbMasterChangeData.tChangePos[k] == 1) then
					local animationName = "guru_equip_light_"..equipInfo.itemDesc.quality
					local strenEffect = UIHelper.createArmatureNode({
						filePath = "images/effect/formation/guru_equip_light/guru_equip_light.ExportJson",
						animationName = animationName,
						bRetain = true,
						fnMovementCall = function ( sender, MovementEventType, frameEventName )
							if (MovementEventType == 1) then
								sender:removeFromParentAndCleanup(true)
							end
						end,
						fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
							equipCount = equipCount - 1
							local frame = tostring(equipInfo.itemDesc.quality - 2)
							if (frameEventName == frame and equipCount == 0) then 
								createBoardEffect()
							end
						end,
					})
					strenEffect:setPosition(ccp(widget:getWorldPosition().x, widget:getWorldPosition().y))
					_effectLayer:addNode(strenEffect)
				end
			end
			
		end)
	end
end

--一键装备按钮
local function oneKeyEquipEvent()
	AudioHelper.playCommonEffect()

	if(not isHeroExist(curHeroHid)) then
		ShowNotice.showShellInfo(m_i18n[1211])
		return
	end

	local params = CCArray:createWithObject(CCString:create(tostring(curHeroHid)))
	local pBool = conch.conchLayout:isVisible()
	if(pBool) then
		if(not SwitchModel.getSwitchOpenState(ksSwitchBattleSoul , true)) then
			return
		end
		RequestCenter.hero_equipBestConch(oneKeyConchCallBack, params)
	else
		if(not SwitchModel.getSwitchOpenState(ksSwitchWeaponForge , true)) then
			return
		end
		RequestCenter.hero_equipBestArming(oneKeyEquipMentsCallBack, params)
	end
end

-- 添加装备按钮回调
local function onAddEquipCallback( sender )
	--modified by zhaoqiangjun

	if (showSquadTye == SHOW_THEM_SQUAD) then
		return
	end

	if(not SwitchModel.getSwitchOpenState(ksSwitchWeaponForge,true)) then
		AudioHelper.playCommonEffect()
		-- ShowNotice.showShellInfo("需7级开启，穿戴装备可提升战斗力")
		return
	end
	
	--检查装备栏位上的装备，如果不是空装备就返回
	if isHeroExist(curHeroHid) then
		local heroInfo 	= getHeroInfoByHid(curHeroHid)
		local armInfo 	= heroInfo.equip.arming
		local equip 	= armInfo[tostring(sender:getTag())] or 0
		if tonumber(equip) ~= 0 then
			return
		end
	end
	
	AudioHelper.playCommonEffect()
	--有英雄
	if curHeroHid ~= 3 then
		require "script/module/equipment/EquipSelectCtrl"
		fnCleanLabelAni()
		local tbChangeInfo = {hid = curHeroHid, equipType = sender:getTag(), heroPage = heroPage}
		local equipList = EquipSelectCtrl.create(tbChangeInfo, sender:getTag(), curHeroHid), mLayerM.getModuleRootLayout()
		mLayerM.addLayoutNoScale(equipList, mLayerM.getModuleRootLayout())
		UIHelper.changepPaomao(equipList) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
	else
		--当前阵上没有伙伴
		ShowNotice.showShellInfo(m_i18n[1211])	
	end
end 

-- 添加宝物按钮回调
local function onAddTreasureCallBack( sender )
	--modified by zhaoqiangjun

	if (showSquadTye == SHOW_THEM_SQUAD) then
		return
	end

	--首先判断功能节点，宝物功能节点没开就返回
	if(not SwitchModel.getSwitchOpenState(ksSwitchTreasure,true)) then
		AudioHelper.playCommonEffect()
		return
	end

	--检查装备栏位上的装备，如果不是空装备就返回
	if isHeroExist(curHeroHid) then
		local heroInfo 	= getHeroInfoByHid(curHeroHid)
		local armInfo 	= heroInfo.equip.treasure
		local equip 	= armInfo[tostring(sender:getTag() - 4)]
		if(equip and tonumber(equip) ~= 0 )then
			return
		end
	end
	
	AudioHelper.playCommonEffect()
	if (isHeroExist(curHeroHid)) then
		require "db/DB_Normal_config"
		local strTreaOpenLv = DB_Normal_config.getDataById(1).treasureOpenLevel
		tbLv = string.split(strTreaOpenLv, ",")
		local pTag = tonumber(sender:getTag())
		if(tonumber(tbLv[pTag - 4]) > mUModel.getHeroLevel()) then
			local pStr = tbLv[pTag - 4] .. m_i18n[1201]
			ShowNotice.showShellInfo(pStr)
			return
		end
		fnCleanLabelAni()
		require "script/module/formation/AddTreaChooseCtrl"
		local tbInfo = {hid = curHeroHid, treaType = sender:getTag(), heroPage = heroPage, from = 4}
		local treasList = AddTreaChooseCtrl.create(tbInfo)
		mLayerM.addLayoutNoScale(treasList, mLayerM.getModuleRootLayout())
		UIHelper.changepPaomao(treasList) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
	else
		ShowNotice.showShellInfo(m_i18n[1211])
	end
end

-- 添加空岛贝按钮回调
local function onAddConchCallBack( sender )
	if (showSquadTye == SHOW_THEM_SQUAD) then
		return
	end

	if(not SwitchModel.getSwitchOpenState(ksSwitchBattleSoul,true)) then
		AudioHelper.playCommonEffect()
		return
	end

	--检查装备栏位上的装备，如果不是空装备就返回
	if isHeroExist(curHeroHid) then
		local heroInfo 	= getHeroInfoByHid(curHeroHid)
		local armInfo 	= heroInfo.equip.conch
		local equip 	= armInfo[tostring(sender:getTag())]
		if(equip and tonumber(equip) ~= 0 )then
			return
		end
	end

	AudioHelper.playCommonEffect()
	if (isHeroExist(curHeroHid)) then
		fnCleanLabelAni()
		--跳转选择空岛贝
		local pOpen = mFUtil.isConchOpenByPos(sender:getTag())
		if (not pOpen) then
			return
		end
		require "script/module/conch/ConchStrength/SkyPleaSelect"
		local selectLayout = SkyPleaSelect.create(curHeroHid, sender:getTag())
		if(selectLayout)then
			mLayerM.addLayoutNoScale(selectLayout,mLayerM.getModuleRootLayout())
			UIHelper.changepPaomao(selectLayout) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
		end
	else
		ShowNotice.showShellInfo(m_i18n[1211])
	end
end

--快速更换伙伴
local function fnFastExchange()
	AudioHelper.playCommonEffect()
	local pString = mFTools.fnCheckChangeID(curHeroHid) or nil
	if(pString) then
		ShowNotice.showShellInfo(pString)
		return
	end
	fnCleanLabelAni()
	require "script/module/formation/FriendSelectCtrl"
	local pFriendSelect = FriendSelectCtrl
	local battleCompanModule = pFriendSelect.create(1 ,m_curPageNum + 1 ,curHeroHid)
	mLayerM.addLayoutNoScale(battleCompanModule, widgetBg)
	--GlobalNotify.postNotify(BondManager.BOND_MSG.CB_BOND_OPEN)
end

-- 装备、空岛贝切换按钮的逻辑
function changeConch( isShow )

	conch.conchLayout:setVisible(isShow)
	for i=1,6 do
		conch.btn[i]:setTouchEnabled(isShow)
		if(conch.btn[i]:getChildByTag(i)) then
			conch.btn[i]:getChildByTag(i):setTouchEnabled(isShow)
		end
	end
	local btn_conch = m_getWidget(widgetMain, "BTN_AIR_PANEL")
	btn_conch:setTouchEnabled(not isShow)
	btn_conch:setVisible(not isShow)
	if(not SwitchModel.getSwitchOpenState(ksSwitchBattleSoul , false)) then
		btn_conch:setTouchEnabled(false)
		btn_conch:setVisible(false)
	end

	local equipLayout = m_getWidget(widgetMain, "LAY_BTNS_ZHUANGBEI")
	equipLayout:setVisible(not isShow)
	for i=1,8 do
		equipBtn[i]:setTouchEnabled(not isShow)
		if(i<5) then
			if(equipBtn[i]:getChildByTag(i)) then
				equipBtn[i]:getChildByTag(i):setTouchEnabled(not isShow)
			end
		else
			if(equipBtn[i]:getChildByTag(i-4)) then
				equipBtn[i]:getChildByTag(i-4):setTouchEnabled(not isShow)
			end
		end
	end
	local specialItem = widgetMain.BTN_TREASURE_FIRE:getChildByTag(SpecialConst.TAG_SPECIAL_ICON)
	if (specialItem) then
		specialItem:setTouchEnabled(not isShow)
	end
	local btn_equip = m_getWidget(widgetMain, "BTN_EQUIP_PANEL")
	btn_equip:setTouchEnabled(isShow)
	btn_equip:setVisible(isShow)
end

--空岛贝与装备的切换按键响应
local function onConchEvent( sender )
	-- 判断等级是否满足跳转条件
	local isOpen = true
	if(not SwitchModel.getSwitchOpenState(ksSwitchBattleSoul , true)) then
		isOpen = false
	end
	AudioHelper.playCommonEffect()
	local pBool = conch.conchLayout:isVisible()
	-- if(not pBool) then
		
	-- end
	if (isOpen == false) then
		return
	end
	changeConch(not pBool)
end


--得到经常操作的按钮信息
local function fnLoadAllBtnAndEvent()
	oneKeyEquipBtn = m_getWidget(widgetMain, "BTN_ONEKEYEQUIP")	--一键装备
	BTN_GURU = m_getWidget(widgetMain , "BTN_GURU")	--强化装备
	if (showSquadTye == SHOW_SELF_SQUAD) then
		fnBindBtnCallback(oneKeyEquipBtn, oneKeyEquipEvent)
		--fnBindBtnCallback(BTN_GURU, onBtnMasterGroup)
		BTN_GURU:addTouchEventListener(onBtnMasterGroup)
	elseif(showSquadTye == SHOW_THEM_SQUAD) then
		BTN_GURU:removeFromParent()
		oneKeyEquipBtn:removeFromParent()
		-- yucong UI更换,暂时不显示
		-- local onekeyImg = m_getWidget(widgetMain, "img_onekey_di")	--一键装备的底框
		-- onekeyImg:removeFromParent()
	end
	mUI.titleShadow(oneKeyEquipBtn, m_i18n[1203])

	local heroSelectBtn = m_getWidget(widgetMain, "BTN_SELECT")	--选择伙伴黑影
	--保存黑影的位置
	--heroPos = ccp(heroSelectBtn:getPositionX(), heroSelectBtn:getPositionY())
	_tbHeroPos.pos = ccp(widgetMain.BTN_HERO:getPositionX(), widgetMain.BTN_HERO:getPositionY())
	--heroAnchorPos = heroSelectBtn:getAnchorPoint()
	_tbHeroPos.anchorPos = widgetMain.BTN_HERO:getAnchorPoint()
	_tbHeroPos.emptyPos = ccp(heroSelectBtn:getPositionX(), heroSelectBtn:getPositionY())
	_tbHeroPos.emptyAnchorPos = heroSelectBtn:getAnchorPoint()
	-- heroSelectBtn:setVisible(false)
	heroSelectBtn:removeFromParentAndCleanup(true)

	equipBtn = {"","","","","","","","",""}
	--装备、宝物、更换伙伴按钮
	local pStrs = {"BTN_WEAPON","BTN_NECKLACE","BTN_HEAD","BTN_ARMOR",
			"BTN_TREASURE_WIND","BTN_TREASURE_THUNDER","BTN_TREASURE_WATER","BTN_TREASURE_FIRE",
			"BTN_FASTCHANGE"}
	--英雄装备、宝物
	for i=1,#pStrs do
		equipBtn[i] = m_getWidget(widgetMain, pStrs[i])
		equipBtn[i]:setTag(i)
		if(i <= 4) then
			fnBindBtnCallback(equipBtn[i],onAddEquipCallback)
		elseif(i <= 7) then
			equipBtn[i]:setTouchEnabled(true)
			mFTools.fnInitExclusiveAndFetterIcon(equipBtn[i],i-4)
			fnBindBtnCallback(equipBtn[i],onAddTreasureCallBack)
		elseif (i == 9) then
			if(showSquadTye == SHOW_THEM_SQUAD) then
				equipBtn[i]:setVisible(false)
				equipBtn[i]:setEnabled(false)
			else
				fnBindBtnCallback(equipBtn[i], fnFastExchange)
			end
		end
	end
	-- 专属宝物栏位
	widgetMain.BTN_TREASURE_FIRE:addTouchEventListener(onBtnAddSpecial)

	--英雄的空岛贝 中间的按钮
	local btn_conch = m_getWidget(widgetMain, "BTN_AIR_PANEL")
	fnBindBtnCallback(btn_conch, onConchEvent)
	btn_conch:setEnabled(true)
	m_conchTip = m_getWidget(btn_conch, "IMG_AIR_TIP")
	mFTools.fnSetTips(m_conchTip, false)

	btn_conch = m_getWidget(widgetMain, "BTN_EQUIP_PANEL")
	fnBindBtnCallback(btn_conch, onConchEvent)
	btn_conch:setEnabled(false)
	m_equipTip = m_getWidget(btn_conch, "IMG_EQUIP_TIP")
	mFTools.fnSetTips(m_equipTip, false)


	conch.conchLayout = m_getWidget(widgetMain, "LAY_BTNS_AIR")
	conch.conchLayout:setVisible(false)
	
	for i=1,6 do
		conch.btn[i] = m_getWidget(widgetMain, "BTN_AIR"..i)
		conch.btn[i]:setTag(i)
		fnBindBtnCallback(conch.btn[i],onAddConchCallBack)
	end
 	
 	-- 可进阶按钮
 	widgetMain.IMG_CAN_ADVANCE:setTouchEnabled(true)
 	widgetMain.IMG_CAN_ADVANCE:addTouchEventListener(function ( sender, eventType )
 		if (eventType == TOUCH_EVENT_ENDED) then
 			AudioHelper.playCommonEffect()
 			local heroInfo = getHeroInfoByHid(curHeroHid)
 			require "script/module/partner/PartnerTransCtrl"
 			PartnerTransCtrl.create(curHeroHid, 2, m_curPageNum + 1)
 		end
 	end)

 	-- 隐藏强化大师弹出框
 	setGuruGroupVisible(false, false)
 	widgetMain.IMG_GURU_BG.BTN_NEW_GURU:addTouchEventListener(onKeyEquipMaster)
 	widgetMain.IMG_GURU_BG.BTN_ONEKEY_STR:addTouchEventListener(onBtnAutoStren)
 	widgetMain.IMG_GURU_BG:addTouchEventListener(onBtnMasterGroup)
 	-- 觉醒入口
 	widgetMain.BTN_AWAKE:addTouchEventListener(onBtnAwake)
end

-- yucong 此方法无调用
local function benchCallback( sender)
	if showSquadTye == SHOW_SELF_SQUAD then
		ShowNotice.showShellInfo(m_i18n[1216])
	end
end

--得到装备及战魂的label显示
local function fnLoadAllLabelFunction()
	labHeroName = m_getWidget(widgetMain, "TFD_WUJIANG")
	--labHeroJinJie = m_getWidget(widgetMain, "LABN_TRANSFER_NUM")
	--imgAddJinJie = m_getWidget(widgetMain, "img_add")
	local labLevel = m_getWidget(widgetMain, "tfd_dengji")
	--mUI.labelShadow(labLevel)
	--yucong 暂时去除不显示
	--[[
	local labJiBan = m_getWidget(widgetMain, "tfd_jiban")
	mUI.labelShadow(labJiBan)
	mUI.labelStroke(labJiBan, ccc3(0x68, 0x0f,0x00), 2)

	
	local imgChain = m_getWidget(widgetMain, "img_chain")
	imgChain:setScale(g_fScaleX)

	local laytapup= m_getWidget(widgetUp,"LAY_TAB_UP")
	local tapUpSize = laytapup:getSize()
	laytapup:setSize(CCSizeMake(tapUpSize.width*g_fScaleX ,tapUpSize.height*g_fScaleX))
	local imgtapup = m_getWidget(widgetUp,"IMG_TAB_UP")
	imgtapup:setScale(g_fScaleX)
	local imgtapdown = m_getWidget(widgetUp,"IMG_TAB_DOWN")
	imgtapdown:setScale(g_fScaleX)
	]]

	--装备红点集合
	imgTips = {"","","","","","","","",}
	local pStrs0 = {"IMG_WEAPON_TIP","IMG_NECK_TIP","IMG_HEAD_TIP","IMG_ARMOR_TIP"
			,"IMG_WIND_TIP","IMG_THUNDER_TIP","IMG_WATER_TIP","IMG_FIRE_TIP"}
	for i=1,8 do
		imgTips[i] = m_getWidget(widgetMain, pStrs0[i])
	end

	--空岛贝红点集合
	imgConchTips = {"","","","","","",}
	for i=1,6 do
		imgConchTips[i] = m_getWidget(widgetMain , "IMG_AIR_TIP"..i)
	end
	equipLabel = {
		{"","","",""},
		{"","","",""},
	}

	local pStrs1 = {"TFD_WEAPON_NAME","TFD_NECKLACE_NAME","TFD_HEAD_NAME","TFD_ARMOR_NAME"}
	local pStrs2 = {"TFD_WIND_NAME","TFD_THUNDER_NAME","TFD_WATER_NAME","TFD_FIRE_NAME"}
	for i=1,4 do
		equipLabel[1][i] = m_getWidget(widgetMain, pStrs1[i])
		equipLabel[2][i] = m_getWidget(widgetMain, pStrs2[i])
	end

	--处理空岛贝的底框
	local pAdd, pOpen, pB, pL, pInfo
	for i=1,6 do
		conch.label[i] = m_getWidget(widgetMain, "TFD_AIR_NAME"..i)
		pAdd = m_getWidget(widgetMain, "IMG_ADD"..i)
		pAdd:setVisible(false)
		pOpen = m_getWidget(widgetMain, "IMG_AIR_LOCK"..i)
		if (showSquadTye == SHOW_SELF_SQUAD) then
			pB, pL = mFUtil.isConchOpenByPos(i)
			if(pB) then
				pOpen:setVisible(false)
				local AddSprite = mUI.fadeInAndOutImage("ui/add_blue.png")
				AddSprite:setPosition(ccp(0, 0))
				pAdd:getParent():addNode(AddSprite , -1)
			else
				pInfo = m_getWidget(widgetMain, "TFD_AIR_LOCKINFO"..i)
				pInfo:setText(pL)
				mUI.labelNewStroke(pInfo)
				pInfo = m_getWidget(widgetMain, "TFD_AIR_JIKAIFANG"..i)
				pInfo:setText(m_i18n[1201])
				mUI.labelNewStroke(pInfo)
			end
		else
			pOpen:setVisible(false)
		end
	end

	mUI.labelNewStroke(widgetMain.tfd_base_title, ccc3(0x92, 0x53, 0x1b), 2)
	mUI.labelNewStroke(widgetMain.tfd_jiban_title, ccc3(0x92, 0x53, 0x1b), 2)
	widgetMain.tfd_base_title:setText(m_i18n[1113])
	widgetMain.tfd_jiban_title:setText(m_i18n[1116])
end

--载入羁绊Label 及三围 及星星
local function fnLoadLinkGroupLabel()
	fetterLabels = {"1","1","1","1","1","1"}
	for i=1,6 do
		local pFetterLabel = m_getWidget(widgetMain, "TFD_JIBAN_" .. i)
		fetterLabels[i] = pFetterLabel
	end

	arrtNumLabels = {"1","1","1","1","1","1"}
	local pStrs = {"TFD_SHENGMING_NUM" , "TFD_WUGONG_NUM" , "TFD_WUFANG_NUM"
					,"TFD_FAGONG_NUM" , "TFD_FAFANG_NUM" , "TFD_SPEED_NUM"}
    for i =1,6 do
    	local pNumLabel = m_getWidget(widgetMain, pStrs[i])
    	-- table.insert(arrtNumLabels , pNumLabel)
    	arrtNumLabels[i] = pNumLabel
    end
	-- 等级
	widgetMain.tfd_dengji:setText(m_i18n[1618])

	local botImgBtn = m_getWidget(widgetMain, "img_jiban_paper")

	botImgBtn:setTouchEnabled(true)
	botImgBtn:addTouchEventListener(function ( sender,eventType )
		if(eventType == TOUCH_EVENT_ENDED) then
			if(isAutoScrolling()) then
				return
			end
			if isHeroExist(curHeroHid) then
				local heroInfo = getHeroInfoByHid(tonumber(curHeroHid))
				local hpos = m_curPageNum
				fnCleanLabelAni()
				showPartner(hpos, heroInfo, 1)
			end
		end
	end)

	widgetMain.img_base_paper:setTouchEnabled(true)
	widgetMain.img_base_paper:addTouchEventListener(function ( sender,eventType )
		if(eventType == TOUCH_EVENT_ENDED) then
			if(isAutoScrolling()) then
				return
			end
			if isHeroExist(curHeroHid) then
				local heroInfo = getHeroInfoByHid(tonumber(curHeroHid))
				local hpos = m_curPageNum
				fnCleanLabelAni()
				showPartner(hpos, heroInfo, 0)
			end
		end
	end)
end

--播放入场动画
local function fnPlayComeInEffect( isInit )
	local equipLayout = m_getWidget(widgetMain, "LAY_BTNS_ZHUANGBEI")
	local pInit = isInit or false
	mFTools.fnShowComeInAni(equipLayout , pInit)
end

--初始化小伙伴界面
function fnInitLittleFriendPage( ... )
	-- yucong 小伙伴屏蔽
	if (1) then
		return
	end

	local pSquadData = nil
	local pBenchData = nil
	local pLv = nil
	local pExtraData = nil

	if (showSquadTye == SHOW_THEM_SQUAD) then
		pSquadData = externHeroInfo.squad
		pBenchData = externHeroInfo.arrBench
		pExtraData = allextraInfo
		pLv = otherLv
	end

	showLittFriendLinkGroupInfo(pSquadData , pBenchData , pLv)
	--小伙伴界面下方
	showLittleFriendView(pExtraData)
	layHeroInfoLayout:setVisible(false)
end

--处理阵容的数据
local function fnDoSquadData()
	--刷新阵容、替补、小伙伴头像显示
	refreshHeadListView()
	performWithDelay(widgetBg, function ( ... )
		-- 计算红点
		mItemUtil.justiceBagInfo()
		--更新上方编队的红点
		fnUpdateHeadTips()
	end, 1/60)
	
	--小伙伴界面
	if(heroPage >= showLitFriPos) then
		fnInitLittleFriendPage()
		layHeroInfoLayout:setVisible(true)
		return
	end

	if(tonumber(heroPage) == 0) then
		performWithDelay(widgetBg,function()
			--入场动作
			fnPlayComeInEffect(false)
		end,0.01)
	-- else
	-- 	fnInitLittleFriendPage()
	end
	
end
--处理小伙伴数据
local function fnDoExtraData( ... )
	mFTools.fnGetFormationDatas(2 , fnDoSquadData)
end
--处理替补数据
local function fnDoBenchData( ... )
	mFTools.fnGetFormationDatas(3 , fnDoExtraData)
end

--初始化阵容相关数据信息
local function fnGetFormationSquad( ... )
	mFTools.fnGetFormationDatas(1 , fnDoBenchData)
end

--添加伙伴内容主页面和滑动控件
local function fnAddFormationMain()
	widgetMain = m_fnLoadUI(jsonformain)
	widgetBg:addChild(widgetMain)
	-- 武将查看 pageView
	fnInitHeroPageView()
	-- 阵容界面 pageView
	fnInitFormationPageView()

	_effectLayer = Layout:create()
	_effectLayer:setSize(g_winSize)
	CCDirector:sharedDirector():getRunningScene():addChild(_effectLayer, 1000)
end

local function backToOtherView( )
	--播放音效
	AudioHelper.playBackEffect()

	layHeroInfoLayout = nil
	mLastChangeEquipInfo = nil
	mFTools.removeFlyText()
	fnCleanLabelAni()
	mLayerM.removeLayout()
	destroy()
end


local function unlockAllTreatImg( pLv )
	local pLevel = tonumber(pLv) or mUModel.getHeroLevel()
	--取栏位开启的等级限制
	local tbLv = mFUtil.getTreasureOpenLvInfo()
	-- local strTreaOpenLv = DB_Normal_config.getDataById(1).treasureOpenLevel
	-- local tbLv = string.split(strTreaOpenLv, ",")
	local imgLabels = {"TFD_WIND_NAME", "TFD_THUNDER_NAME", "TFD_WATER_NAME", "TFD_FIRE_NAME"}
	for i=1,#tbLv do
		local pImage = m_getWidget(widgetMain, "IMG_TREASURE_LOCK" .. i)
		if(pImage) then
			-- yucong 获取宝物文字
			local treasureImgLabel = m_getWidget(widgetMain, imgLabels[i])
			--加锁
			if(tonumber(tbLv[i]) > pLevel) then
				local plv = m_getWidget(pImage, "TFD_TREASURE_LOCKINFO" .. i) 
				plv:setText(tbLv[i])
				local pString = m_getWidget(pImage, "TFD_TREASURE_JIKAIFANG" .. i) 
				pString:setText(m_i18n[1201])
				--有锁不显示宝物文字
				if (treasureImgLabel) then
					treasureImgLabel:setVisible(false)
				end
			else
				--移除锁图
				pImage:removeFromParentAndCleanup(true)

				if (treasureImgLabel) then
					treasureImgLabel:setVisible(true)
				end
			end
		end
	end
	-- 专属宝物的锁
	-- 判断等级
	local level = nil
	if (showSquadTye == SHOW_THEM_SQUAD) then
		level = otherLv
	else
	end
	if (_speModel.checkSpecialLevel(level)) then --  or showSquadTye == SHOW_THEM_SQUAD
		widgetMain.IMG_TREASURE_LOCK4:setVisible(false)
	else
		widgetMain.TFD_TREASURE_LOCKINFO4:setText(tostring(_speModel.getSpecialLevel()))
		widgetMain.TFD_TREASURE_JIKAIFANG4:setText(m_i18n[1201])
		--UIHelper.labelNewStroke(widgetMain.TFD_TREASURE_LOCKINFO4)
		--UIHelper.labelNewStroke(widgetMain.TFD_TREASURE_JIKAIFANG4)
	end
end

--显示布阵界面
local function onShowBuzhen( sender,eventType )
	local labBuzhen = m_getWidget(sender, "TFD_DEPLOY")
	if (eventType == TOUCH_EVENT_ENDED) then
		if(isAutoScrolling()) then
			return
		end
		AudioHelper.playCommonEffect()

		labBuzhen:setFontSize(26);		--设置按钮字体。
		if (showSquadTye == SHOW_THEM_SQUAD) then
			mLayerM.removeLayout()
		elseif(showSquadTye == SHOW_SELF_SQUAD) then
			require "script/module/formation/Buzhen"
			fnCleanLabelAni()
			Buzhen:init()
		end
	elseif (eventType == TOUCH_EVENT_MOVED) then
		local focus = sender:isFocused()
		if focus then
			labBuzhen:setFontSize(22);
		else
			labBuzhen:setFontSize(26);
		end
	elseif (eventType == TOUCH_EVENT_CANCELED) then
		labBuzhen:setFontSize(26);		--设置按钮字体。
	elseif (eventType == TOUCH_EVENT_BEGAN) then
		labBuzhen:setFontSize(22);		--设置按钮字体。
	end
end

--添加伙伴的列表
local function fnAddFriendList()
	if(showSquadTye == SHOW_SELF_SQUAD) then
		widgetUp = m_fnLoadUI(jsonforup)

		-- 布阵界面入口
		local buzhenBtn = m_getWidget(widgetUp,"BTN_DEPLOY_N")
		local labBuzhen = m_getWidget(buzhenBtn, "TFD_DEPLOY")
		mUI.labelShadow(labBuzhen)
		buzhenBtn:addTouchEventListener(onShowBuzhen)
	elseif (showSquadTye == SHOW_THEM_SQUAD) then
		widgetUp = m_fnLoadUI(jsonforupCheck)
	end
	
	widgetUp:setSize(g_winSize)

	widgetBg:addChild(widgetUp)
	heroHeadList = m_getWidget(widgetUp,"LSV_LITTLE_HERO")
	heroHeadList:setBounceEnabled(false)
	
	
end

--处理阵型信息
local function handleSquadHeroInfo(allSquadData , benchData)
	-------------------对方阵容的伙伴信息----------
	allheroInfo = {}
	local arrHero   = externHeroInfo.arrHero
	local arrExtra  = externHeroInfo.littleFriend
	for i = 1,#allSquadData do
		for k,v in pairs (arrHero) do
			if( allSquadData[i] == v.hid) then
				allheroInfo[tostring(v.hid)] = v
			end
		end
	end
	for k,v in pairs (benchData) do
		if(tonumber(v) ~= 0) then
			allheroInfo[tostring(v.hid)] = v
		end
	end
	-------------------对方阵容的小伙伴信息----------
	allextraInfo = {}
	if arrExtra then
		for k,v in pairs (arrExtra) do
			allextraInfo[tostring(v.position)] = v.hid
		end
		-- for i = 1,litHeroOpenPos do
		-- 	allextraInfo[tostring(i)] = 0
		-- 	for k,v in pairs (arrExtra) do
		-- 		if( tonumber(k) == i) then
		-- 			allextraInfo[tostring(v.position)] = v.hid
		-- 		end
		-- 	end
		-- end
	end
end

function initEffect( ... )
	-- 羁绊特效
	--if (not _newEffect) then
		_newEffect = FormationUtil.getActiveEffect()
		_newEffect:setAnchorPoint(widgetMain.IMG_CAN_ACTIVATE:getAnchorPoint())
		_newEffect:setPosition(ccp(widgetMain.IMG_CAN_ACTIVATE:getPositionX(), widgetMain.IMG_CAN_ACTIVATE:getPositionY()))
		widgetMain.img_jiban_paper:addNode(_newEffect)
		_newEffect:setVisible(false)
	--end
	-- 强化大师按钮特效
	--if (not _guruEffect) then
		_guruEffect = FormationUtil.getGuruEffect()
		_guruEffect:setAnchorPoint(widgetMain.BTN_GURU:getAnchorPoint())
		_guruEffect:setPosition(ccp(widgetMain.BTN_GURU:getPositionX(), widgetMain.BTN_GURU:getPositionY()))
		widgetMain.BTN_GURU:getParent():addNode(_guruEffect, widgetMain.BTN_GURU:getZOrder())
	--end

	-- 可进阶特效
	_transEffect = FormationUtil.getTransEffect()
	_transEffect:setPosition(ccp(0, 0))
	widgetMain.IMG_CAN_ADVANCE:addNode(_transEffect)
	widgetMain.IMG_CAN_ADVANCE:setVisible(false)
	widgetMain.IMG_CAN_ADVANCE:setTouchEnabled(false)
end

function notifications( ... )
	return {
		[BondManager.BOND_MSG.CB_BOND_OPEN]	= fnMSG_BOND_OPEN,
		[SpecialConst.MSG_RELOAD_SPECIAL] = fnMSG_RELOAD_SPECIAL,
		[SpecialConst.MSG_SPECIAL_SELECT_CLOSED] = fnMSG_SPECIAL_SELECT_CLOSED,
		[SpecialConst.MSG_PLAY_ATTRIB] = fnMSG_PLAY_ATTRIB,
		[SpecialConst.MSG_LOAD_SPECIAL_SUCCESS] = fnMSG_LOAD_SPECIAL_SUCCESS,
		["MSG_SHIP_LSV_TOUCH"] = fnMSG_SHIP_LSV_TOUCH,
		["MSG_UPDATE_TREASURE_TIP"] = fnMSG_UPDATE_TREASURE_TIP,
	}
end

-------------------------------供外部可调用 function ----------------------

--初始化入口函数
function create( scrollPage )
	TimeUtil.timeStart("MainFormationCreate") -- iPad Mini 1232ms
	initFormData()
	showSquadTye = SHOW_SELF_SQUAD
	curHeroHid = 3
	externHeroInfo = nil

	-----------------处理阵容的本地数据--------------
	heroSumLevel = mUModel.getHeroLevel()
	-- 阵容的背景UI
	heroPage = scrollPage
	-- yucong 屏蔽小伙伴
	if (heroPage >= showLitFriPos) then
		heroPage = 0
	end
	if(tonumber(heroPage) == 0) then
		mFTools.fnAddComeInWait()
	end
	
	widgetBg = m_fnLoadUI(jsonforbg) -- iPad Mini 100ms
	widgetBg:setSize(g_winSize)
	widgetBg.img_bg:setScaleX(g_fScaleX)

	UIHelper.registExitAndEnterCall(widgetBg, function ( ... )
		removeObserver()
		stopHeroMusic()
	end, function ( ... )
		-- 云鹏的返回机制隐藏的界面会调用onexit，取消了事件，当重新显示后，手动调用刷新
		fnMSG_RELOAD_SPECIAL()
		addObserver()
	end)

	-- heroOpenForm, litHeroOpenPos = mFUtil.fnGetFormationPos()
	
	-- 阵容格子的开启数量
	heroOpenForm = mFUtil.fnGetFormationPos()
	-- 宝物和空岛贝的开启数量
	fitConchOpenPos, treaOpenPos = mFUtil.getTreasureAndConchOpenPos()
	-----------------开始载入json文件----------------
	TimeUtil.timeStart("xxxxxxxx")
	-- 加载主页面信息、pageView
	fnAddFormationMain() -- iPad Mini 650ms
	TimeUtil.timeEnd("xxxxxxxx")
	-- 加载上方滑动信息和布阵入口
	fnAddFriendList()
	
	initEffect()
	--加载按钮的点击事件
	fnLoadAllBtnAndEvent()
	--载入所有装备
	fnLoadAllLabelFunction()
	--羁绊
	fnLoadLinkGroupLabel()
	--解锁宝物格
	unlockAllTreatImg()
	--添加伙伴列表
	
	-----------------获取阵容，小伙伴的信息数据--------
	TimeUtil.timeStart("MainFormationAllThing")
	fnGetFormationSquad() --约0.8s
	TimeUtil.timeEnd("MainFormationAllThing")
	if(tonumber(heroPage) == 0) then
		fnPlayComeInEffect(true)
	end
	TimeUtil.timeEnd("MainFormationCreate")
	--------------------------- new guide begin -------------------------------------
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideFormationView"
	if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createFormationGuide(2)
		heroHeadList:setTouchEnabled(false)
		heroPageView:setTouchEnabled(false)
		mainPage:setTouchEnabled(false)
		hideActiveEffect()
	end

	require "script/module/guide/GuideFiveLevelGiftView"
	if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 5) then

		require "script/module/guide/GuideCtrl"
		GuideCtrl.createkFiveLevelGiftGuide(6)
		heroHeadList:setTouchEnabled(false)
		heroPageView:setTouchEnabled(false)
		mainPage:setTouchEnabled(false)
		hideActiveEffect()
	end

	require "script/module/guide/GuideEquipView"
	if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		local pos = equipBtn[1]:getWorldPosition()
		logger:debug("ccp.x = %s, ccp.y = %s",pos.x, pos.y)
		GuideCtrl.createEquipGuide(2, 0, ccp(pos.x - 181, pos.y))
		hideActiveEffect()
	end

	require "script/module/guide/GuideForthFormationView"
	if (GuideModel.getGuideClass() == ksGuideForthFormation and GuideForthFormationView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createForthFormationGuide(2)
		heroHeadList:setTouchEnabled(false)
		hideActiveEffect()
	end

	require "script/module/guide/GuideTreasView"
	if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createTreasGuide(3)
		hideActiveEffect()
	end

	require "script/module/guide/GuideCopyBoxView"
	if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 5) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopyBoxGuide(6)
		heroHeadList:setTouchEnabled(false)
		heroPageView:setTouchEnabled(false)
		mainPage:setTouchEnabled(false)
		hideActiveEffect()
	end

	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 9) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(10)
		heroHeadList:setTouchEnabled(false)
		heroPageView:setTouchEnabled(false)
		mainPage:setTouchEnabled(false)
		hideActiveEffect()
	end

	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createAwakeGuide(2)
		heroHeadList:setTouchEnabled(false)
		heroPageView:setTouchEnabled(false)
		mainPage:setTouchEnabled(false)
		hideActiveEffect()
	end

	---------------------------- new guide end --------------------------------------
	return widgetBg
end

--根据别的地方创建的阵容信息
function createWithOtherUserInfo( uid , exHeroInfo, isShowPvpBtn )
	logger:debug("createWithOtherUserInfo")
	mFTools.fnAddComeInWait()
	initFormData()
	showSquadTye    = SHOW_THEM_SQUAD

	externHeroInfo  = exHeroInfo
	externHeroId    = uid
	curHeroHid      = 3
	_isShowPvpBtn	= isShowPvpBtn

	local allSquadData = exHeroInfo.squad
	local allBenchData = exHeroInfo.arrBench

	otherLv = externHeroInfo.level--获得玩家的等级

	-- heroOpenForm,litHeroOpenPos = mFUtil.fnGetFormationPos(otherLv)
	heroOpenForm = mFUtil.fnGetFormationPos(otherLv)
	fitConchOpenPos, treaOpenPos = mFUtil.getOtherTreasureAndConchOpenPos(otherLv)
	--处理阵型信息
	handleSquadHeroInfo(allSquadData , allBenchData)

	--判断是否是Npc英雄
	-- if (tonumber(externHeroId) > 10000 and tonumber(externHeroId) < 16000) then
	-- 	isNpc = true
	-- end

	-----------------处理阵容的本地数据--------------
	heroSumLevel    = otherLv
	-- 阵容的背景UI
	heroPage        = 0

	widgetBg        = m_fnLoadUI(jsonforbg)
	widgetBg:setSize(g_winSize)

	-- yucong 隐藏不需要渲染的
	LayerManager.hideAllLayout(MainFormation.moduleName())
	mUI.registExitAndEnterCall(widgetBg, function ( ... )
		removeObserver()
        LayerManager.remuseAllLayoutVisible(MainFormation.moduleName())
    end)

	local bgImage = m_getWidget(widgetBg, "img_bg")
	bgImage:setScaleX(g_fScaleX)

	addObserver()
	-----------------开始载入json文件----------------
	--添加阵容上的内容
	fnAddFormationMain()
	fnAddFriendList()
	initEffect()
	local widgetBack = m_fnLoadUI(jsonforBack)
	widgetBack:setSize(g_winSize)
	widgetBg:addChild(widgetBack)

	local btnBackOther = m_getWidget(widgetBack ,"BTN_BACK")
	fnBindBtnCallback(btnBackOther, backToOtherView)
	mUI.titleShadow(btnBackOther, m_i18n[1019])

	-- 切磋按钮
	widgetBack.BTN_ATK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("start_fight.mp3")
			if (externHeroId) then
				PVP.doPVP(tonumber(externHeroId))
			end
		end
	end)
	mUI.titleShadow(widgetBack.BTN_ATK, m_i18n[6701])
	widgetBack.BTN_ATK:setVisible(isShowPvpBtn)
	widgetBack.BTN_ATK:setTouchEnabled(isShowPvpBtn)

	--载入所有装备名。
	fnLoadAllBtnAndEvent()
	fnLoadAllLabelFunction()
	--羁绊
	fnLoadLinkGroupLabel()
	--解锁宝物格
	unlockAllTreatImg(heroSumLevel)

	refreshHeadListView(allSquadData , allBenchData)

	--移动UI部分
	local labPlayerName = m_getWidget(widgetBack ,"TFD_PLAYER_NAME")
	labPlayerName:setText(externHeroInfo.uname)
	--显示阵容的战斗力
	local m_fightForce = mFTools.calcFightForce(allheroInfo , allextraInfo ,externHeroInfo)
	local labnFightForce = m_getWidget(widgetBack, "TFD_ZHANDOULI")
	labnFightForce:setText(tostring(m_fightForce) or "0")
	-- return widgetBg
	mLayerM.addLayoutNoScale(widgetBg)

	--播放入场动画
	fnPlayComeInEffect(true)
	fnPlayComeInEffect()

end

function addObserver( ... )
	for msg, func in pairs(notifications()) do
		GlobalNotify.addObserver(msg, func, false, msg.."MainFormation")
	end
end

function removeObserver( ... )
	for msg, func in pairs(notifications()) do
		GlobalNotify.removeObserver(msg, msg.."MainFormation")
	end
end

--------------根据hid获得伙伴信息----------
function getHeroInfoByHid( herohid )
	local heroInfo
	if showSquadTye     == SHOW_SELF_SQUAD then
		heroInfo        =  HeroModel.getHeroByHid(herohid)

		if (heroInfo) then
			-- 装备信息为空，则赋初值
			local arming = heroInfo.equip.arming
			--logger:debug({heroInfoExclusive = heroInfo.equip})
			if (table.isEmpty(arming)) then
				for i = 1, 4 do
					arming[tostring(i)] = "0"	-- 不存在的手动置0，否则数据中当前条不存在，判断红点时会忽略掉
				end
			end
		end
	elseif showSquadTye == SHOW_THEM_SQUAD then
		heroInfo        =  allheroInfo[tostring(herohid)]
	end
	return heroInfo
end

function setHeroPageViewTouchEnabled ( bParams )
	if(heroPageView) then
		heroPageView:setTouchEnabled(bParams or false)
	end
end

--选择人物后更新阵容
function updateFormation(hpos, hid, pOnlyUpdateHead, pNotChange, pNotChangeEquips)
	local pShowAllChange = true
	local pShowChange = true
	if(pOnlyUpdateHead) then
		pShowAllChange = false
	end
	if(pNotChange) then
		pShowChange = false
	end
	--mFormLitSCV.refreshScrollView()
	heroPageView:scrollToPage(hpos - 1)
	heroHeadImageAndEventListenerWithPos(hid ,hpos , pShowChange , pShowAllChange, pNotChangeEquips)
	fnUpdateHeadFocus()
	mItemUtil.fnUpdateOneHeroRedByPos(tonumber(hpos) - 1)
end

--获取当前英雄页 ， －1表示当前在小伙伴
function fnGetHeroPageCurIndex( ... )
	local pageView = tolua.cast(mainPage, "PageView")
	local page = pageView:getCurPageIndex()
	if(page == 0) then
		local curHeroPage = heroPageView:getCurPageIndex()
		return curHeroPage
	end
	return -1
end
--记录当前人物的属性值，用于显示变化的label
function rememberQuality( ... )
	local pNode = arrtNumLabels
	for k,v in pairs(pNode) do
		finalEquipAttr[k] = v:getStringValue()
		originEquipAttr[k] = v:getStringValue()
	end
	logger:debug(finalEquipAttr)
	logger:debug(originEquipAttr)
end

--获取原本的人物资质信息
function showFlyQuality( p_lastChangeEquipInfo, showStrings, uninId)
	logger:debug(originEquipAttr)

	-- 套装信息
	if(p_lastChangeEquipInfo) then
		mLastChangeEquipInfo = p_lastChangeEquipInfo
	end

	local pOld = {}
	local pNew = {}
	--属性文字
	local pNode = arrtNumLabels
	for k,v in pairs(pNode) do
		pOld[k] = originEquipAttr[k]
		pNew[k] = v:getStringValue()
		finalEquipAttr[k] = v:getStringValue()
		v:setText(originEquipAttr[k])
	end
	--logger:debug({pOld = pOld})
	--logger:debug({pNew = pNew})
	mFTools.setNumerialInfo(pOld , pNew , pNode)

	for k,v in pairs(finalEquipAttr) do
		originEquipAttr[k] = v
	end

	--if(not mLastChangeEquipInfo and not showStrings) then
		-- if(not mNewChangeHero) then
		-- 	showNumerChangeAni()	-- 只有基本属性


		-- else
		-- 	local pTb = mFTools.fnGetFormationLinkChanged(mNewChangeHero)
		-- 	if(not pTb or #pTb == 0) then
		-- 		showNumerChangeAni()
		-- 	else
		-- 		local pNodes = fetterLabels
		-- 		finalLinkColor = {}
		-- 		for i = 1 , 6 do
		-- 			table.insert(finalLinkColor , normUnionColor)
		-- 		end
		-- 		for k,v in pairs(pTb) do
		-- 			local pK = v.key
		-- 			if(pK and finalLinkColor[pK]) then
		-- 				finalLinkColor[pK] = openUnionColor
		-- 			end
		-- 		end
				
		-- 		local pNode = m_getWidget(widgetBg, "img_relation")
		-- 		mFTools.showLinkChangeInfo(pTb , pNode , pNodes , showNumerChangeAni)
		-- 		mNewChangeHero = nil
		-- 	end
	-- 	end
	-- else
		BTN_GURU = m_getWidget(widgetMain , "BTN_GURU")
		local pos = ccp(BTN_GURU:getPositionX(),BTN_GURU:getPositionY())
		local realPos = BTN_GURU:getParent():convertToWorldSpace(pos)
		mFTools.showEquipChangeInfo(mLastChangeEquipInfo, mFTools.fnShowFightForceChangeAni, showStrings, realPos, uninId)	-- 有套装或者强化大师属性
		mLastChangeEquipInfo = nil
	--end
end

function updateHeroConch( mtype )
	local pType = tonumber(mtype) or 0
	if(pType == 0) then
		removeConchInfo()
	else
		removeOneConchInfo(mtype,true)
	end
	-- removeAllLinkGroup() -- zhangqi, 2015-06-17, 空岛贝和羁绊无关，注释掉
	local heroInfo      = HeroModel.getHeroByHid(curHeroHid)
	local heroequip     = heroInfo.equip
	local heroHtid      = tonumber(heroInfo.htid)
	local heroDBInfo    = mDBheros.getDataById(heroHtid)
	--显示伙伴的装备信息
	local pConch        = heroequip.conch
	local pB = false
	if(pConch) then
		if(pType == 0) then
			pB = showConch(pConch)
		else
			local pShowState = conch.conchLayout:isVisible()
			showConchByInfo(pConch, pType, pShowState)
			pB = freshConchSpTip(pConch)
		end
	end
	if(pB) then
		m_conchTip:setVisible(true)
	else
		m_conchTip:setVisible(false)
	end 
	
	freshNormal( heroDBInfo, true ) -- zhangqi, 2015-06-17
end

--更新阵容上英雄装备,根据装备的类型来判断是否需要显示红点
-- playArmOn 是否播放armOn音效
function updateHeroEquipment( mtype, notRemember, playArmOn )
	notRemember = notRemember or false
	if (playArmOn == nil) then
		playArmOn = true
	else
		playArmOn = false
	end
	if (playArmOn) then
		AudioHelper.playArmOn()
	end
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideEquipView"
	if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		local pos = equipBtn[1]:getWorldPosition()
		logger:debug("ccp.x = %s, ccp.y = %s",pos.x, pos.y)
		GuideCtrl.createEquipGuide(4, 0, pos)
		hideActiveEffect()
	end
	if(not mtype) then
		removeAllArmorInfo()
	else
		removeOneArmorInfo(mtype)
	end
	removeAllLinkGroup()
	local heroInfo      = HeroModel.getHeroByHid(curHeroHid)
	local heroequip     = heroInfo.equip
	local heroHtid      = tonumber(heroInfo.htid)
	local heroDBInfo    = mDBheros.getDataById(heroHtid)
	--显示伙伴的装备信息
	local arming        = heroequip.arming
	if(arming) then
		if(not mtype) then
			m_showAmr = showEquip(arming)
		else
			showEquipByInfo(arming,mtype)
			m_showAmr = freshEquipSpTip(arming)
		end
	end
	if(m_showAmr or m_showTrea) then
		m_equipTip:setVisible(true)
	else
		m_equipTip:setVisible(false)
	end

	if(mtype) then
		mLastChangeEquipInfo = nil
		local armInfo = arming[tostring(mtype)] or nil
		if(armInfo and armInfo.itemDesc) then
			local suitID = armInfo.itemDesc.jobLimit or nil
			if(suitID) then
				local armID = {}
				for k,v in pairs(arming) do
					table.insert(armID,v.item_template_id)
				end
				mLastChangeEquipInfo = {arm = armID}
				mLastChangeEquipInfo[""..suitID] = { suit = suitID , info = {}}

				local ppTB = {name = armInfo.itemDesc.name, quality = armInfo.itemDesc.quality}
				table.insert(mLastChangeEquipInfo[""..suitID].info , ppTB)
			end
		end
	end

	freshNormal(heroDBInfo)

	if(not mtype and not notRemember) then
		rememberQuality()
	end
end

--卸下身上的装备 
function removeHeroEquipment( mtype )
	--AudioHelper.playArmOff()
	if(not mtype) then
		removeAllArmorInfo()
	else
		removeOneArmorInfo(mtype)
	end
	removeAllLinkGroup()
	local heroInfo      = HeroModel.getHeroByHid(curHeroHid)
	local heroequip     = heroInfo.equip
	local heroHtid      = tonumber(heroInfo.htid)
	local heroDBInfo    = mDBheros.getDataById(heroHtid)
	--显示伙伴的装备信息
	local arming        = heroequip.arming
	if(arming) then
		if(not mtype) then
			showEquip(arming)
		else
			showEquipByInfo(arming,mtype)
		end
	end
	--给对应的装备栏位加上感叹号
	local countImgbg = nil
	local ppum = tonumber(mtype)
	if(ppum >= 1 and ppum <= 4) then
		countImgbg = imgTips[ppum] or nil
	end
	mFTools.fnSetTips(countImgbg, true)
	m_showAmr = true
	m_equipTip:setVisible(true)
	freshNormal( heroDBInfo )
end

--卸下身上的宝物
function removeHeroTreasure( mtype )
	-- AudioHelper.playArmOff()
	if(not mtype) then
		removeAllTreasureInfo()
	else
		removeOneTreasureInfo(mtype)
	end
	removeAllLinkGroup()
	local heroInfo      = HeroModel.getHeroByHid(curHeroHid)
	local heroequip     = heroInfo.equip
	local heroHtid      = tonumber(heroInfo.htid)
	local heroDBInfo    = mDBheros.getDataById(heroHtid)
	--显示伙伴的装备信息
	local treasure        = heroequip.treasure
	if(not mtype) then
		m_showTrea = showTreasure(treasure)
	else
		showTreasureByInfo(treasure,mtype)
		m_showTrea = freshTreasureSpTip(treasure)
	end
	
	m_equipTip:setVisible(m_showTrea)
	freshNormal( heroDBInfo )
end
--更新阵容上英雄宝物
function updateHeroTreasure( mtype )
	AudioHelper.playArmOn()
	if(not mtype) then
		removeAllTreasureInfo()
	else
		removeOneTreasureInfo(mtype)
	end
	removeAllLinkGroup()
	local heroInfo      = HeroModel.getHeroByHid(curHeroHid)
	local heroequip     = heroInfo.equip
	local heroHtid      = tonumber(heroInfo.htid)
	local heroDBInfo    = mDBheros.getDataById(heroHtid)
	--显示伙伴的装备信息
	local treasure        = heroequip.treasure
	if(not mtype) then
		m_showTrea = showTreasure(treasure)
	else
		showTreasureByInfo(treasure,mtype)
		m_showTrea = freshTreasureSpTip(treasure)
	end
	if(m_showAmr or m_showTrea) then
		m_equipTip:setVisible(true)
	else
		m_equipTip:setVisible(false)
	end
	freshNormal( heroDBInfo )
end

-- zhangqi, 2015-06-17, 增加参数 bNotNeedLink，true:不需要羁绊信息的处理，false或nil:需要羁绊信息处理
function freshNormal( heroDBInfo, bNotNeedLink )
	if (not bNotNeedLink) then
		showHeroLinkGroupWithHero(heroDBInfo, curHeroHid) --显示伙伴羁绊技能
	end

	showPartnerQualityAndMeasurements(curHeroHid,heroDBInfo) --显示资质以及三围

	-- mFormLitSCV.refreshScrollView() -- zhangqi, 2015-06-17, 暂时注释掉小伙伴的处理
	mItemUtil.justiceBagInfo() -- 红点显示处理

	fnSetQHMasterAvailable(curHeroHid)
end

function fnShowEquipMaster2()
	fnShowEquipMaster(2)
end

function fnShowEquipMaster3()
	fnShowEquipMaster(3)
end

function fnShowEquipMaster4()
	fnShowEquipMaster(4)
end

--更新头标记位置
function fnUpdateHeadFocus( ... )
	local pageView = tolua.cast(mainPage, "PageView")
	local page = pageView:getCurPageIndex()
	fnSetHeroHeadFocus()
	if(page == 0) then
		local curHeroPage = heroPageView:getCurPageIndex()
		
		local heroHead = tolua.cast(heroHeadList:getItem(curHeroPage), "Button")
		local heroTag = heroHead:getTag()
		local headFrameImage = m_getWidget(heroHead, "IMG_FRAME_BG")
		local highImg = headFrameImage:getChildByTag(tonumber(focusTag))
		highImg:setVisible(true)
		-- local button = headFrameImage:getChildByTag(tonumber(heroTag)) or nil
		-- if button then
		-- 	local pC = button:getChildByTag(focusTag)
		-- 	if(pC) then
		-- 		pC:setVisible(true)
		-- 	end
		-- end
	end
end

--刷新小伙伴界面
function refreshLittleFriendView(retArr)
	-- mFormLitFriV.refreshView(retArr, tonumber(litHeroOpenPos))
	-- mFormLitFriV.refreshView(retArr)
end

--更新小伙伴
function refreshExtra(curHeroHid,hpos)
	mUModel.setInfoChanged(true) -- 标记需要更新战斗力数值
	
	local extraData = mData.getExtra()
	extraData[tonumber(hpos)] = tostring(curHeroHid)
	mData.setExtra(extraData)
	refreshLittleFriendView(extraData)

	mFormLitSCV.refreshScrollView()
end

--更新小伙伴
function updateExtra(curHeroHid,hpos)
	mUModel.setInfoChanged(true) -- 标记需要更新战斗力数值

	local extraData = mData.getExtra()
	extraData[tonumber(hpos)] = tostring(curHeroHid)
	mData.setExtra(extraData)
	-- showLittleFriendView(extraData)
	refreshLittleFriendView(extraData)

	local heroinfo = getHeroInfoByHid(curHeroHid)
	local pName = nil
	if(heroinfo) then
		local pDB =	mDBheros.getDataById(heroinfo.htid)
		pName = pDB.name or ""
	end
	if(tonumber(pName) ~= 0) then
		mFTools.showUpName(pName)
	end
	
	mFormLitSCV.refreshScrollView()

	local pTb = mFTools.fnGetLinkChanged(heroinfo)
	if(pTb and #pTb > 0) then
		local plabel = m_getWidget(layHeroInfoLayout ,"LABN_TOTAL_NUM") 
		local pNumber = tonumber(mFormLitSCV.getAddJibanNum()) or 0
		local pNew = tonumber(plabel:getStringValue()) or 0
		local pOld = pNew - pNumber
		plabel:setStringValue(pOld)
		mFTools.fnSetLinkNumberInfo(pOld , pNew , plabel)

		local pNode = m_getWidget(layHeroInfoLayout ,"IMG_TOTAL_NUMBG") 
		mFTools.showLinkChangeInfo(pTb , pNode , nil , mFTools.showSellInfo)
	end
end

function showWidgetMain()
	if(not widgetMain) then
		return
	end
	widgetMain:setEnabled(true)
	--重置星星信息。
	if isHeroExist(curHeroHid) then
		local heroInfo   = getHeroInfoByHid(curHeroHid)
		local heroDBInfo = mDBheros.getDataById(heroInfo.htid)
		showHeroInfoStarLevel(heroInfo)
	end
end

-- zhangqi, 2014-05-14, 显示布阵后隐藏阵容主界面
function hideWidgetMain( ... )
	if(not widgetMain) then
		return
	end
	widgetMain:setEnabled(false)
end

--滑动到第几个英雄
function scrollHeroPage( pPageNum )
	local pNum = tonumber(pPageNum) or 0
	if(pNum == m_curPageNum) then
		return
	end
	if(not heroPageView) then
		return
	end
	local sumpage = heroPageView:getPages():count()
	if(pNum < 0 or pNum > sumpage - 1) then
		pNum = 0
	end
	heroPageView:scrollToPage(pNum)
end

--[[desc:设置mainpage跳转到1或0
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function scrollMainPage( pPageNum )
	logger:debug("scrollMainPage")
	local pNum = tonumber(pPageNum) or 0
	-- yucong 小伙伴屏蔽
	if( pNum ~= 1 and
		 pNum ~= 0) then
		pNum = 0
	end
	if (mainPage:getPages():count() < pNum + 1) then
		return
	end
	if(pNum == 1) then
		if (showSquadTye == SHOW_SELF_SQUAD) then
			return
		end
		if(layHeroInfoLayout) then
			layHeroInfoLayout:setVisible(true)
		end
		heroPageView:setTouchEnabled(false)
	elseif(pNum == 0) then
		if(layHeros) then
			layHeros:setVisible(true)
		end
	end
	--yucong 小伙伴屏蔽
	if (mainPage:getCurPageIndex() ~= pNum) then
		mainPage:scrollToPage(pNum)
	end
end

--[[desc:设置头像列表到直接的page
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function setHeadStartPage( p_page )
	local pPage = p_page or 0
	if(pPage < 0 ) then
		pPage = 0
	end
	if(pPage == 0) then
		return
	end

	local pListCount = tonumber(heroHeadList:getItems():count()) - 1
	if(pPage > pListCount) then
		pPage = pListCount
	end
	local heroHead = tolua.cast(heroHeadList:getItem(pPage), "Button")
	OffsetPage(pPage , heroHead)
	heroHeadList:visit()
end
--更新上方编队的红点
function fnUpdateHeadTips( tipTable )
	if(not UIHelper.isGood(widgetMain)) then
		return
	end
	if(showSquadTye ~= SHOW_SELF_SQUAD) then
		return
	end
	local pTips = tipTable or mItemUtil.fnGetHeroRedTips()
	if(table.isEmpty(m_headTips) or table.isEmpty(pTips)) then
		return
	end
	for k,v in pairs(m_headTips) do
		v:setVisible(pTips[k])
	end
end

--[[desc:判断羁绊是否需要显示红点
    arg1: 第几个伙伴。
    return: 若有参数，返回该位置是否显示红点，布尔型。若无，返回红点数据table。 
—]]
function JudgeBondRedPoint( pos )
	local tbBondRed = {}
	local orignType = showSquadTye
	showSquadTye = SHOW_SELF_SQUAD
	local tbHeroHids = {}
	local tbSquardInfo = DataCache.getSquad()
	if (tbSquardInfo) then 
		for k,v in pairs(tbSquardInfo) do
			tbHeroHids[tonumber(k)] = v
		end
		local benchId = DataCache.getBench()['0']
		tbHeroHids[#tbHeroHids + 1] = benchId

		logger:debug({tbHeroHids = tbHeroHids})
		for k,v in pairs(tbHeroHids) do
			if (tonumber(v) ~= 3 and tonumber(v) ~= -1 and tonumber(v) ~= 0) then
				logger:debug(v)
				local bondHtid = getHeroInfoByHid(tonumber(v)).htid
				local tbHeroInfo = mDBheros.getDataById(bondHtid)
				local bondInfo = tbHeroInfo.link_group1

				if bondInfo then
					local tbBondInfo = lua_string_split(bondInfo, ",")
				
					for i,j in ipairs(tbBondInfo) do
						if (showSquadTye == SHOW_SELF_SQUAD) then
							___, _,  __, tBond = mFUtil.isUnionActive(j, v)
							if (tBond.state == BondManager.BOND_REACHED) then
								tbBondRed[tonumber(k) + 1] = true
								break
							end
						end
					end
				end
			end
		end
	end
	showSquadTye = orignType
	logger:debug({tbBondRed = tbBondRed})

	if (pos) then
		return tbBondRed[tonumber(pos)]
	end

	return tbBondRed
end

-- 专属宝物栏位回调
function onBtnAddSpecial( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 判断等级
		if (not _speModel.checkSpecialLevel(otherLv)) then
			ShowNotice.showShellInfo("".._speModel.getSpecialLevel()..m_i18n[6935])--"级装备专属宝物"
			return
		end
		-- 滚动中或者他人阵容，不予操作
		if (isAutoScrolling() or showSquadTye == SHOW_THEM_SQUAD) then
			return
		end
		if (not isHeroExist(curHeroHid)) then
			ShowNotice.showShellInfo(m_i18n[1211])
			return
		end
		
		local curHtid = HeroModel.getHtidByHid(curHeroHid)
		local specialId = _speModel.getHeroSpecialId(curHtid)
		if (specialId == 0) then
			ShowNotice.showShellInfo(m_i18n[6934])--"该伙伴没有对应的专属宝物"
			return
		end
		local state = FormationSpecialModel.getSpecTreaOnHeroStat(curHtid, curHeroHid)
		if (state == 1) then
			return
		end
		fnCleanLabelAni()
		-- 背包中有，则选择列表
		if (_speModel.isHaveSpecialTreasure(curHtid)) then
			local layer = AddSpecialTreaCtrl.create(curHeroHid)
			LayerManager.addLayoutNoScale(layer, widgetBg)
			UIHelper.changepPaomao(layer)
			hideWidgetMain()
		else
			if (specialId ~= 0) then
				-- 否则提示获取途径
				local specTreaDrop = SpecTreaDrop:new()

				local curModuleName = LayerManager.curModuleName()

				local dropLayout = specTreaDrop:create(specialId,curHtid)
				LayerManager.addLayout(dropLayout)
			end
		end
	end
end

function hideActiveEffect( ... )
	_newEffect:setVisible(false)
	widgetMain.IMG_CAN_ACTIVATE_RED:setVisible(false)
end

function stopHeroMusic( ... )
	logger:debug("stopHeroMusic")
	if (_curMusicId) then
		AudioHelper.stopEffect(_curMusicId)
		_curMusicId = nil
	end
end

function isHeroExist( hid )
	if (hid == nil or tonumber(hid) <= 3) then
		return false
	end
	return true
end

function isSelf( ... )
	return showSquadTye == SHOW_SELF_SQUAD
end

function onBtnAwake( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		MainAwakeCtrl.create(1, curHeroHid)
	end
end

--------------------- notifications --------------------
-- 激活羁绊 刷新
function fnMSG_BOND_OPEN( ... )
	logger:debug("fnMSG_BOND_OPEN")
	local pos = m_curPageNum + 1
	logger:debug("pos:"..pos.." hid:"..curHeroHid)
	updateFormation(pos, curHeroHid, nil, nil, true)
end

-- 通知刷新专属宝物栏位
function fnMSG_RELOAD_SPECIAL( ... )
	logger:debug("fnMSG_RELOAD_SPECIAL")
	local heroInfo  = getHeroInfoByHid(curHeroHid)
	if (heroInfo) then
		showSpecialTreasure(heroInfo.equip.exclusive[SpecialConst.SPECIAL_POS])
		freshNormal(heroInfo, true)
	end
end

-- 专属宝物选择列表关闭
function fnMSG_SPECIAL_SELECT_CLOSED( ... )
	showWidgetMain()
end

-- 飚属性字
function fnMSG_PLAY_ATTRIB( ... )
	logger:debug("fnMSG_PLAY_ATTRIB")
	showFlyQuality(nil, nil)
end

-- 添加专属宝物成功
function fnMSG_LOAD_SPECIAL_SUCCESS( ... )
	fnMSG_RELOAD_SPECIAL()
	fnMSG_PLAY_ATTRIB()
end

function fnMSG_SHIP_LSV_TOUCH( eventType )
	mainPage:setTouchEnabled(false)
	if (eventType == TOUCH_EVENT_BEGAN) then
		mainPage:setTouchEnabled(false)
	elseif (eventType == TOUCH_EVENT_ENDED) then
		mainPage:setTouchEnabled(true)
	elseif (eventType == TOUCH_EVENT_CANCELED) then
		mainPage:setTouchEnabled(true)
	end
end

-- 刷新饰品红点
-- 因为存在饰品推送的问题，红点计算不及时
function fnMSG_UPDATE_TREASURE_TIP( ... )
	local heroInfo = HeroModel.getHeroByHid(curHeroHid)
	local treasure = heroInfo.equip.treasure
	m_showTrea = freshTreasureSpTip(treasure)
	if(m_showAmr or m_showTrea) then
		m_equipTip:setVisible(true)
	else
		m_equipTip:setVisible(false)
	end
	ItemUtil.justiceBagInfo()
end
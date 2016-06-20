
-- FileName: MainAstrologyView.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose:占卜屋主界面
--[[TODO List]]

module("MainAstrologyView", package.seeall)

-- UI控件引用变量 --
local m_btnExplain 				= nil		--说明按钮
local m_btnRefresh 				= nil 		--刷新按钮
local m_btnReward 				=  nil		--查看奖励按钮

local m_TFD_SURPLUS_TIMES 		= nil		--今日可占卜的次数
local m_TFD_ALL_TIMES 			= nil		--今日可占卜的总次数
local m_TFD_LIGHT_NUM 			= nil 		--激活几张卡牌
local m_TFD_AWARD_NUM			= nil		--奖励几个运势
local m_TFD_REFRESH_NUM			= nil		--奖励几个运势
local m_TFD_STARS_NUM 			= nil 		--已经占卜的运势个数 j进度条上的数字
local m_TFD_OWN_NUM         	= nil       --神龙令的个数
local m_TFD_AWARD_POINT_NUM     = nil       --积分
local img_scale 				= nil       --星级进度条上的刻度
-- 模块局部变量 --
local m_tbAstrologyInfo		 	= nil 		--占卜信息
local m_fnGetWidget 			= g_fnGetWidgetByName
local m_i18nString 				= gi18nString

local m_tbRrewardStarInfo		= nil		--奖励运势信息
local m_tbDbAstrology			= nil		--占卜本地配置信息
local m_nAstroTimes 			= 16		--总占卜次数
local m_tbEventListener 		= nil
local m_nTimeCardEffect 		= 0 			--用来记录星星特效的数值，大于等于四表示特效播完了
local progress  				= nil 		--进度条
local m_updateTimer 			= nil

m_UIMain						= nil  	   	--主画布	

require "db/DB_Astrology"
require "db/DB_Aster"

local function init(...)
	m_nTimeCardEffect = 0
	m_UIMain = nil
	m_updateTimer = nil
end


function getMainLay()
    return m_UIMain
end


function destroy(...)
	package.loaded["MainAstrologyView"] = nil
	m_UIMain = nil
end

function moduleName()
	return "MainAstrologyView"
end

function getProcessPos( ... )
	local posPercent = img_scale:getPositionPercent()
	local parentNode = img_scale:getParent()
	local parentSize = parentNode:getContentSize()
	local posX = parentSize.width * posPercent.x
	local posY  = parentSize.height * posPercent.y
	return parentNode:convertToWorldSpaceAR(CCPointMake(posX,posY))
end

function create( tbEventListener )
	logger:debug("MainAstrologyView create count")
	m_tbEventListener = tbEventListener
	m_UIMain = g_fnLoadUI("ui/astrology.json")

		UIHelper.registExitAndEnterCall(m_UIMain,
		function()
			m_UIMain = nil 
		end,
		function()
		end
		)
	--按钮获取
	m_btnExplain = m_fnGetWidget(m_UIMain, "BTN_HELP")
	m_btnRefresh = m_fnGetWidget(m_UIMain, "BTN_REFRESH")
	m_btnReward = m_fnGetWidget(m_UIMain, "BTN_AWARD")

	--注册事件
	m_btnExplain:addTouchEventListener(m_tbEventListener.onExplain)
	m_btnRefresh:addTouchEventListener(m_tbEventListener.onRefresh)
	m_btnReward:addTouchEventListener(m_tbEventListener.onReward)

	local i18ntfd_Cost1 = m_fnGetWidget(m_UIMain,"tfd_refresh_cost_0") --消耗
	local i18ntfd_Cost2 = m_fnGetWidget(m_UIMain,"tfd_refresh_cost_1") --一个或
	local i18ntfd_Cost3 = m_fnGetWidget(m_UIMain,"tfd_own") --拥有（

	progress = m_fnGetWidget(m_UIMain,"LOAD_ASTROLOGY_EXP") --进度条
	--18n赋值
	--m_btnRefresh:setTitleText(m_i18nString(2081))
	UIHelper.titleShadow(m_btnRefresh,m_i18nString(2081))
	UIHelper.titleShadow(m_btnReward,m_i18nString(2303))
	i18ntfd_Cost3:setText(m_i18nString(2306))
	i18ntfd_Cost2:setText(m_i18nString(2305))
	i18ntfd_Cost1:setText(m_i18nString(2304))

	m_TFD_SURPLUS_TIMES = m_fnGetWidget(m_UIMain,"TFD_SURPLUS_TIMES")
	m_TFD_ALL_TIMES = m_fnGetWidget(m_UIMain,"TFD_ALL_TIMES")
	m_TFD_LIGHT_NUM = m_fnGetWidget(m_UIMain,"TFD_LIGHT_NUM")
	m_TFD_AWARD_NUM = m_fnGetWidget(m_UIMain,"TFD_AWARD_STAR_NUM")
	m_TFD_REFRESH_NUM = m_fnGetWidget(m_UIMain,"TFD_REFRESH_TIMES_NUM")
	m_TFD_STARS_NUM = m_fnGetWidget(m_UIMain,"LABN_STARS_NUM")
	m_TFD_OWN_NUM   = m_fnGetWidget(m_UIMain,"TFD_OWN_NUM")
	m_TFD_AWARD_POINT_NUM = m_fnGetWidget(m_UIMain,"LABN_AWARD_NUM")
	img_scale = m_fnGetWidget(m_UIMain,"img_scale") 	--进度条上的星术

	--今日占卜次数
	local i18n_tfd_today_times = m_fnGetWidget(m_UIMain,"tfd_today_times")
	UIHelper.labelAddStroke(i18n_tfd_today_times,m_i18nString(2307))
	--免费刷新次数
	local i18n_tfd_refresh_times = m_fnGetWidget(m_UIMain,"tfd_refresh_times")
	UIHelper.labelAddStroke(i18n_tfd_refresh_times,m_i18nString(2308))
	--c从后端拉取数据并更新界面

	UIHelper.registExitAndEnterCall(m_UIMain, function ( ... )
		m_UIMain = nil
	end)

	--适配缩放
	local  img_astor_purple_bg = m_fnGetWidget(m_UIMain,"img_astor_purple_bg")
	img_astor_purple_bg:setScale(g_fScaleX)

	local  img_desktop = m_fnGetWidget(m_UIMain,"img_desktop")
	--img_desktop:setScale(g_fScaleX)
	
	local  lay_constellation_astrology = m_fnGetWidget(m_UIMain,"lay_constellation_astrology")
	--lay_constellation_astrology:setScale(g_fScaleX)
	return m_UIMain
end

--查看奖励上的可领奖次数  --leftPrize:可领取奖励的次数
function setCanGetPriceNum()

	local leftPrize = MainAstrologyModel.getCanRewardCount(m_tbAstrologyInfo)

	local curStarNum = m_tbAstrologyInfo.integral

	local tipImage = m_fnGetWidget(m_UIMain,"img_award_tip")
	if(leftPrize == 0) then
		tipImage:setEnabled(false)
	else
		tipImage:setEnabled(true)
		m_TFD_AWARD_POINT_NUM:setStringValue(tonumber(leftPrize))
	end
end

--根据后端数据刷新界面
function updateUILay( ... )
	--点亮四个卡牌，奖励运势
	local currentRewardStar
	local needStarNum = "4"
	if(tonumber(m_tbAstrologyInfo.target_finish_num)+1<=#m_tbRrewardStarInfo) then
		local rewardData = m_tbRrewardStarInfo[tonumber(m_tbAstrologyInfo.target_finish_num)+1]
		currentRewardStar = tonumber(lua_string_split(rewardData,"|")[2])
		needStarNum = lua_string_split(rewardData,"|")[1]
	end
	MainAstrologyModel.setDiviInfo(m_tbAstrologyInfo)
	--查看奖励上的可领奖次数
	setCanGetPriceNum()

	--需要点亮的星星数目
	UIHelper.labelAddStroke(m_TFD_LIGHT_NUM , needStarNum) --
	--更新奖励运势数值
	currentRewardStar = currentRewardStar==nil and 0 or currentRewardStar
	--m_TFD_AWARD_NUM:setText(tostring(currentRewardStar))
	UIHelper.labelAddStroke(m_TFD_AWARD_NUM , tostring(currentRewardStar)) --

	--当前的剩余占卜次数
	m_TFD_SURPLUS_TIMES:setText(m_nAstroTimes - m_tbAstrologyInfo.divi_times)

	--今日免费刷新次数
	m_TFD_REFRESH_NUM:setText(m_tbAstrologyInfo.free_refresh_num)
	--已经占卜的运势个数

	--UIHelper.labelEffect(m_TFD_STARS_NUM , m_tbAstrologyInfo.integral) --
	m_TFD_STARS_NUM:setStringValue(tonumber(m_tbAstrologyInfo.integral))

	--m_TFD_STARS_NUM:setText(m_tbAstrologyInfo.integral)
	--拥有神龙令的个数
	m_TFD_OWN_NUM:setText(getResheshItemNum())
	--总占卜次数
	m_TFD_ALL_TIMES:setText(tostring(m_nAstroTimes))
	--更新进度条


	logger:debug( MainAstrologyCtrl.m_bNeedBigAnimating)
	if( MainAstrologyCtrl.m_bNeedBigAnimating) then

		startProgressScheduler()
	else
		local curStar = tonumber(m_tbAstrologyInfo.integral)
		local maxStar = tonumber(m_tbDbAstrology.star_max)
		local npercent = curStar / maxStar * 100
		logger:debug(curStar / maxStar)
		img_scale:setPositionPercent(ccp(curStar / maxStar,img_scale:getPositionPercent().y))

		progress:setPercent((npercent > 100) and 100 or npercent)
		MainAstrologyCtrl.removeUnTouchLayer()
	end

	--更新五个可选图标
	for i=1,5 do
		local starId = m_tbAstrologyInfo.va_divine.current[i]
		local starInfo = DB_Aster.getDataById(tonumber(starId))
		logger:debug(starId)
		logger:debug(starInfo)
		local astroBtn = m_fnGetWidget(m_UIMain,"BTN_TAROT_" .. i)
		local astroLightbtn  = m_fnGetWidget(m_UIMain,"BTN_LIGHTING_TAROT_" .. i)

		-- astroLightbtn:removeAllChildrenWithCleanup(true)
		-- astroBtn:removeAllChildrenWithCleanup(true)
		astroBtn:removeAllNodes()
		astroLightbtn:removeAllNodes()

		astroBtn:loadTextureNormal("images/others/" .. starInfo.icon)
		astroBtn:loadTexturePressed("images/others/" .. starInfo.icon)
		astroBtn:addTouchEventListener(m_tbEventListener.onStar)
		astroBtn:setEnabled(false)
		astroBtn:setTag(i-1)

		astroLightbtn:addTouchEventListener(m_tbEventListener.onStar)

		astroLightbtn:setTag(i-1)
		astroLightbtn:removeAllChildrenWithCleanup(true)
		--astroLightbtn:removeNodeByTag(100)
		astroLightbtn:setEnabled(false)

		--台柱特效父节点
		local  img_effect1 =  m_fnGetWidget(m_UIMain,"img_effect" .. i)
		img_effect1:removeNodeByTag(199)
		--判断是否有可选星
		local isFind = false
		for j=1,4 do
			local starTargetId = m_tbAstrologyInfo.va_divine.target[j]
			if(starId~=nil and starId == starTargetId and tonumber(m_tbAstrologyInfo.va_divine.lighted[j])==0)then

				isFind = true
				break
			end
		end

		if(isFind == true) then
				astroLightbtn:setEnabled(true)
				--astroBtn:setEnabled(false)
				--台柱特效
				local tbParams = {
					filePath  = "images/effect/astrology/zhanbu1.ExportJson",
					animationName = "zhanbu1",}


				local effectNode = UIHelper.createArmatureNode(tbParams)
				effectNode:setPositionY(- (img_effect1:getContentSize().height / 2))
				img_effect1:addNode(effectNode,10,199)	

				--上下移动特效
				local tbParams1_1 = {
					filePath  = "images/effect/astrology/zhanbu1_1.ExportJson",
					animationName = "zhanbu1_1",}

				local effectNode1_1 = UIHelper.createArmatureNode(tbParams1_1)


				local ccSkin1 = CCSkin:create("images/others/" .. starInfo.icon)
	
				effectNode1_1:getBone("zhanbu1_1_2"):addDisplay(ccSkin1, 0)

				effectNode1_1:setAnchorPoint(ccp(0.5, 0.5))
				astroLightbtn:addNode(effectNode1_1,0,100);

				logger:debug("astroLightbtn" .. i)
		else
			astroBtn:setEnabled(true)
		end

	end

	--更新4个目标图标
	for i=1,4 do
		local starTargetId = m_tbAstrologyInfo.va_divine.target[i]
		local starTargetInfo = DB_Aster.getDataById(tonumber(starTargetId))

		local astroTargetImg = m_fnGetWidget(m_UIMain,"IMG_TARGET_CARD_" .. i)
		astroTargetImg:loadTexture("images/others/" .. starTargetInfo.icon)
		astroTargetImg:setColor(ccc3(111,111,111))
		astroTargetImg:removeNodeByTag(101)
		--判断是否有可选星
		if(tonumber(m_tbAstrologyInfo.va_divine.lighted[i]) == 1)then
			addTargetCardLightEffect(astroTargetImg)
		end
	end
end
--给目标卡牌增加s闪光特效
function addTargetCardLightEffect( TargetImg )
	TargetImg:removeNodeByTag(101)
	TargetImg:setColor(ccc3(255,255,255))
	local tbParams = {
		filePath = "images/effect/astrology/zhanbu3.ExportJson",
		animationName = "zhanbu3",}

	local effectNode = UIHelper.createArmatureNode(tbParams)
	effectNode:getAnimation():setSpeedScale(0.75)
	TargetImg:addNode(effectNode,-10,101);
end
--给目标卡牌增加五角星特效
function addTargetCardLStarEffect( TargetImg )
	local tbParams = {
		filePath = "images/effect/astrology/zhanbu2.ExportJson",
		animationName = "zhanbu2",}



	local effectNode = UIHelper.createArmatureNode(tbParams)
	TargetImg:addNode(effectNode,12222,100)
	--星座进度位置坐标（世界坐标点）
	local targetPos = getProcessPos()
	--转换到卡牌坐标系
	local posInCardSpace = TargetImg:convertToNodeSpaceAR(targetPos)
	logger:debug("local posInCardSpace = TargetImg:convertToNodeSpaceAR(targetPos)")
	local function removeSelf ( ... )
		effectNode:removeFromParentAndCleanup(true)
		m_nTimeCardEffect = m_nTimeCardEffect + 1
		logger:debug(m_nTimeCardEffect)
		if(m_nTimeCardEffect >= 4 ) then
			updateUILay()
		end
	end

	local array = CCArray:create()
	local callfunc = CCCallFunc:create(removeSelf)
	local move = CCEaseOut:create(CCMoveTo:create(0.75, posInCardSpace), 0.5) 
	--local move = CCMoveTo:create(1.0, posInCardSpace)
	array:addObject(move)
	array:addObject(callfunc)
	local action = CCSequence:create(array)
	effectNode:runAction(action)
end

--给目标卡牌增加合成特效
function addTargetCardCompos(TargetImg )
	TargetImg:setColor(ccc3(255,255,255))

	local effectNode = nil
	local function addStarEffectCall( ... )
		effectNode:removeFromParentAndCleanup(true)
		addTargetCardLStarEffect(TargetImg)
	end

	local tbParams = {
		filePath = "images/effect/astrology/zhanbu4.ExportJson",
		animationName = "zhanbu4",
		fnMovementCall = addStarEffectCall,
		}

	effectNode = UIHelper.createArmatureNode(tbParams)
	TargetImg:addNode(effectNode);

	--音效
	-- AudioHelper.playEffect("audio/effect/texiao_duobao02_1.mp3")
	--AudioHelper.playEffect("audio/effect/texiao_duobao02_1.mp3")
end


--拥有神龙令的个数
function getResheshItemNum( ... )
	local itemNum = ItemUtil.getCacheItemNumBy(60013)
	logger:debug(itemNum)
	return itemNum
		-- ItemUtil.reduceItemByGid(kGid, nil, true)
end

--更新数据，并刷新界面
-- tbAstrologyInfo :占卜数据
function updateAstroView()
	if(m_UIMain == nil) then
		return
	end

	m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo
	
	m_tbDbAstrology = DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
	m_tbRrewardStarInfo = lua_string_split(m_tbDbAstrology.target_reward_stars,",")

	local allLightClosed = true
	for i=1,4 do
		if((m_tbAstrologyInfo.va_divine.lighted[i]) == "1") then
			allLightClosed = false
			break
		end
	end
	--占卜四个目标卡牌后的特效
	local allStarLighted = MainAstrologyCtrl.m_bNeedBigAnimating

	if(allStarLighted) then

		m_nTimeCardEffect = 0
		for i=1,4 do
			local astroTargetImg = m_fnGetWidget(m_UIMain,"IMG_TARGET_CARD_" .. i)
			--先让四个卡牌都闪亮起来
			addTargetCardLightEffect(astroTargetImg)
			--然后再发出zhanbu5特效
			addTargetCardCompos(astroTargetImg)
			
		end
		AudioHelper.playEffect("audio/effect/texiao_duobao02_1.mp3")
	else
		updateUILay()

	end
end
--
local function updateProgressBar( ... )
	--当前的星数
	local curStar = tonumber(m_tbAstrologyInfo.integral)
	local maxStar = tonumber(m_tbDbAstrology.star_max)
	local npercent = curStar / maxStar * 100

	if(progress == nil ) then
		return 
	end
	--当前刻度值
	local curPercent = progress:getPercent()
	curPercent = curPercent + 1
	--标尺的x坐标值
	local curPosPercent = img_scale:getPositionPercent().x
	curPosPercent = curPosPercent + 0.01

	logger:debug(curPercent .. "||| |" .. npercent)

	if(curPercent > npercent or curPercent > 100) then
		stopProgressScheduler()
		--移除屏蔽层
		MainAstrologyCtrl.removeUnTouchLayer()
	else
		progress:setPercent((curPercent > 100) and 100 or curPercent)
		curPosPercent = (curPosPercent > 1) and 1 or curPosPercent
		img_scale:setPositionPercent(ccp(curPosPercent,img_scale:getPositionPercent().y))
	end

 
end
-- 启动scheduler
function startProgressScheduler()

	if(m_updateTimer == nil) then
		m_updateTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateProgressBar, 0.0, false)
	end

end

-- 停止scheduler
function stopProgressScheduler()
	if(m_updateTimer)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_updateTimer)
		m_updateTimer = nil
	end
end

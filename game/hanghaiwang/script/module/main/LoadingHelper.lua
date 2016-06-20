-- FileName: LoadingHelper.lua
-- Author: zhangqi
-- Date: 2015-10-24
-- Purpose: 登录和后端请求loading动画相关的方法
--[[TODO List]]

module("LoadingHelper", package.seeall)

-- 模块局部变量 --
local m_i18n = gi18n
local nZTopLayer = 9999999 -- 最顶层触摸特效层的显示层级，最高
-- zhangqi, 2016-01-26, 把各loading层级修改为只比触摸特效层依次低一点的层级，避免被其他层挡住
local nZLoading = nZTopLayer - 4 -- 后端请求 loading 的层级和tag
local nZLogin = nZTopLayer - 3 -- 登录时的loading 层级和tag
local nZRegist = nZTopLayer - 2 -- 登陆或者新建角色时的loading 层级和tag

local m_nLoginTimeout = 30 -- 默认登录loading超时时间为30秒
local m_nRpcTimeout = 10 -- 默认后端请求超时时间10秒

local _fnTimeoutScheduler = {}

local _layLoading     -- 加载界面widgetRoot


function getRpcTag()
	return nZLoading
end

function getLoginTag( ... )
	return nZLogin
end

function getRegistTag( ... )
	return nZRegist
end

local function curScene( ... )
	local scene = CCDirector:sharedDirector():getRunningScene()
	return assert(scene, "getRunningScene error")
end

local function loadingIsExist( loadingType )
	local scene = curScene()
	local rpcLoading = scene:getChildByTag(nZLoading)
	local loginLoading = scene:getChildByTag(nZLogin)
	local registLoading = scene:getChildByTag(nZRegist)
	if (loadingType == nZLoading) then
		return loginLoading or rpcLoading
	elseif (loadingType == nZRegist) then
		return registLoading
	else
		return loginLoading
	end
end

local function createLoading()
	local layLoading = g_fnLoadUI("ui/loading.json")

	local layer = OneTouchGroup:create()
	-- layer:retain()
	layer:setTouchPriority(g_tbTouchPriority.talk)
	layer:addWidget(layLoading)

	return layer, layLoading
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function createRegistLoading()
	local layLoading = g_fnLoadUI("ui/regist_loading.json")
	local layer = OneTouchGroup:create()

	layer:setTouchPriority(g_tbTouchPriority.talk)
	layer:addWidget(layLoading)

	_layLoading = layLoading

	return layer, layLoading
end

local function createLoadingAction()
	-- zhangqi, 2015-12-16, 恢复最新的Loading动画
	local spriteBg = CCSprite:create("images/others/loading2.png")
	local szBg = spriteBg:getContentSize()
	local sprite = CCSprite:create("images/others/loading1.png")
	sprite:setPosition(ccp(szBg.width/2, szBg.height/2))
	spriteBg:addChild(sprite)

	spriteBg:setScale(g_fScaleX)
 	sprite:runAction(CCRepeatForever:create(CCRotateBy:create(1.5, 360)))

	return spriteBg
	-- -- zhangqi, 2015-12-07, 新资源监修未过，暂时替换回监修过的老资源
	-- local sprite = CCSprite:create("images/others/loading_old.png")
	-- sprite:setScale(g_fScaleX)
	-- sprite:runAction(CCRepeatForever:create(CCRotateBy:create(1.5, 360)))
	-- return sprite
end

-- 添加船舵动画到loading画布
local function addLoadingAnimat(layLoading)
	local layAnimat = layLoading.LAY_ANIMATION
	local szAnimat = layAnimat:getSize()

	local actSprit = createLoadingAction()
	actSprit:setPosition(ccp(szAnimat.width/2, szAnimat.height/2))
	layAnimat:addNode(actSprit, 100)
end

-- 初始化后端请求的loading画布，loading需要延迟0.5-1秒显示
local function initRpcLoading( layLoading )
	local layMain = layLoading.LAY_MAIN
	layMain:setVisible(false)

	performWithDelay(layLoading, function ( ... )
		addLoadingAnimat(layLoading)
		layMain:setVisible(true)
	end, 0.7)
end

-- loading 的文字动画
local function addLoadingTextAnimat( labText )
	local txtOrig = labText:getStringValue()
	local szLabText = labText:getSize()

	local labPoint = UIHelper.createUILabel( ".", g_sFontName, 24, ccc3(0xff, 0xff, 0xff))
	labPoint:setAnchorPoint(ccp(0, 0))
	labPoint:setPosition(ccp(szLabText.width/2, -szLabText.height/2))
	labText:addChild(labPoint)

	-- 。。。 三个点  相隔0.2s 出现  三个都出现后 在一起过 1s  消散  如此反复
	local tbTxt = {".", "..", "..."}
	local arrAct = CCArray:create()
	for i, txt in ipairs(tbTxt) do
		arrAct:addObject(CCDelayTime:create(0.2))
		arrAct:addObject(CCCallFunc:create(function ( ... )
			labPoint:setText(txt)
		end))
	end
	arrAct:addObject(CCDelayTime:create(1))
	labPoint:runAction(CCRepeatForever:create(CCSequence:create(arrAct)))
end

--[[desc:获取伙伴id对应的信息
    arg1: 伙伴id
    return: tbInfo
—]]
function getShowInfo( loadingId )
	local dbLoading = DB_New_loading.getDataById(loadingId)
	local dbHero = DB_Heroes.getDataById(dbLoading.heroid)
	local tbHeroInfo = {}

	tbHeroInfo.nameImg = "images/partner_name/"..tostring(loadingId)..".png"
	tbHeroInfo.bodyImg = HeroUtil.getHeroBodyImgByHTID(tonumber(dbLoading.heroid))
	tbHeroInfo.desc = dbHero.desc
	tbHeroInfo.place = dbHero.place
	tbHeroInfo.quality = dbHero.heroQuality  -- 资质不是品质
	tbHeroInfo.potential = dbHero.potential  -- 品质
	tbHeroInfo.potentialImg = "images/common/hero_star/star_" .. tostring(tbHeroInfo.potential) .. ".png"

	return tbHeroInfo
end

--[[desc:添加登陆界面上的效果
    arg1: 
    return: 
—]]
function reloadRegistLoading( layLoading, loadingId )
	local tbHeroInfo = getShowInfo( loadingId )
	layLoading.IMG_PARTNER:loadTexture(tbHeroInfo.bodyImg)
	layLoading.IMG_NAME:loadTexture(tbHeroInfo.nameImg)
	layLoading.TFD_LOCATION_TXT:setText(tbHeroInfo.place)
	layLoading.TFD_DESC:setText(tbHeroInfo.desc)
	layLoading.IMG_QUALITY:loadTexture(tbHeroInfo.potentialImg)
	layLoading.TFD_SCORE:setText("资质："..tostring(tbHeroInfo.quality))
	layLoading.img_load_bg:setScale(g_fScaleX)
	layLoading.img_bubble:setScaleX(g_fScaleX)
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function initRegistLoading( layLoading )
	local loadArray = CCArray:create()
	
	local loadingId
	if (UserHandler.isNewUser) then
		loadingId = 1
	else
		math.randomseed(os.time())
		loadingId = math.random(2, table.count(DB_New_loading.New_loading))
	end

	reloadRegistLoading(layLoading, loadingId)

	local ballPositionY = layLoading.IMG_PROGRESS_BALL:getPositionY()
	local ballPositionX = layLoading.IMG_PROGRESS_BALL:getPositionX()

	-- 下方进度条移动的动画
	local registArray = CCArray:create()
	registArray:addObject(CCMoveTo:create(1, ccp(ballPositionX + g_winSize.width/3, ballPositionY)))
	registArray:addObject(CCDelayTime:create(0.5))
	registArray:addObject(CCMoveTo:create(1, ccp(ballPositionX + g_winSize.width*2/3, ballPositionY)))
	registArray:addObject(CCDelayTime:create(0.4))
	registArray:addObject(CCMoveTo:create(0.5, ccp(ballPositionX + g_winSize.width*3/4, ballPositionY)))
--	registArray:addObject(CCDelayTime:create(0.4))
--	registArray:addObject(CCMoveTo:create(1.4, ccp(ballPositionX + g_winSize.width, ballPositionY)))
	local registSeq = CCSequence:create(registArray)
	layLoading.IMG_PROGRESS_BALL:runAction(registSeq)
end

--[[desc:将进度条设置为100%
    arg1: 
    return:  
—]]
function setProgressBarOver(  )
	if (_layLoading) and (_layLoading.IMG_PROGRESS_BALL) then
		_layLoading.IMG_PROGRESS_BALL:stopAllActions()
		_layLoading.IMG_PROGRESS_BALL:setPositionX(g_winSize.width/2)
	end
end


--[[desc:创建并显示loading面板, 如果已显示则不重复创建
    tbArgs: table
    		tbArgs.text：需要显示的提示文字;
    		tbArgs.timeout: loading的超时时间，小于0则不设置超时
			tbArgs.nTag: nZLogin 表示登录Loading, nZLoading 表示是数据请求Loading（http请求和后端请求）
			tbArgs.bRpc: true, 表示是后端请求的laoding
    return: 是否有返回值，返回值说明  
—]]
function addLoadingLayer( tbArgs )
	logger:debug({addLoadingLayer_tbArgs = tbArgs})

	local tagLayer = assert(tbArgs.nTag, "loading layer must has a tag")
	if (loadingIsExist(tagLayer)) then
		logger:debug("tagLayer exit")
		return
	end

	local layerLoading
	local layLoading
	if (tagLayer == nZRegist) then
		layerLoading, layLoading = createRegistLoading()
	else
		layerLoading, layLoading = createLoading()
	end

	curScene():addChild(layerLoading, tagLayer, tagLayer)
	logger:debug("LoadingHelper addLoadingLayer")

	 -- 后端请求和登录请求需求不同，loading需要延迟0.5-1秒显示
	if (tagLayer == nZLoading) then	
		local labText = layLoading.tfd_wait -- loading 文字
		labText:setText(tbArgs.text or m_i18n[4746])
		addLoadingTextAnimat(labText)
		initRpcLoading(layLoading)
	elseif (tagLayer == nZRegist) then	
		initRegistLoading(layLoading)
	else
		local labText = layLoading.tfd_wait -- loading 文字
		labText:setText(tbArgs.text or m_i18n[4746])
		addLoadingTextAnimat(labText)
		addLoadingAnimat(layLoading)
	end

	if (tbArgs.timeout and tbArgs.timeout > 0) then
		-- 超时 30 秒后自动删除loading面板，玩家可以继续操作
		_fnTimeoutScheduler[tagLayer] = GlobalScheduler.scheduleFunc(function ( ... )
			logger:debug("Loading timeout: %d", tbArgs.timeout)

			removeLoadingLayer(tagLayer)

			if (tbArgs.timeout >= m_nLoginTimeout) then -- 登录超时处理
				logger:debug("login loading timeout")
				-- zhangqi, 2015-05-22, 为了避免重连失效导致战斗场景卡住，重连超时后弹出返回登陆面板
				UIHelper.showNetworkDlg(nil, function ( ... )
					removeNetworkDlg()
				end, true, m_i18n[4210]) -- true 模拟被抢号，只显示返回登陆按钮，但提示文字还是网络异常提示
			else
				if (tbArgs.bRpc) then -- 2015-11-03, 判断如果是后端请求超时才认为是网络断开
					logger:debug("rpc loading timeout")
					LoginHelper.netWorkFailed() -- 后端请求超时处理
				end
			end
		end, tbArgs.timeout or m_nLoginTimeout)
	end
end

-- nType, nZLoading 表示rpc loading, nZLogin 表示登录loading nZRegist表示登陆和新建账号用的loading
function removeLoadingLayer( nType )
	if (not table.isEmpty(_fnTimeoutScheduler)) then
		if (_fnTimeoutScheduler[nType]) then
			_fnTimeoutScheduler[nType]()
			_fnTimeoutScheduler[nType] = nil
		end
	end

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene:getChildByTag(nType)) then
		logger:debug("removeLoadingLayer: %d", nType)
		runningScene:removeChildByTag(nType, true)
	end
end

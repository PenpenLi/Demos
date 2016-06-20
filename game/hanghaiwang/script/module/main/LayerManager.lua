-- FileName: LayerManager.lua
-- Author: zhangqi
-- Date: 2014-05-29
-- Purpose: 所有层的管理器
--[[TODO List]]

module("LayerManager", package.seeall)

require "script/module/main/LoadingHelper"
require "script/model/user/UserModel"
require "script/module/public/DropUtil"


-- UI控件引用变量 --
local uiLayer -- OneTouchGroup 对象，添加根容器，并add到runningScene
local layRoot -- 最底层容器，满足适配，放置所有UI, Z-order 0
local layModule -- 当前显示的功能模块，默认是主船，Z-order 0-0-1
local topLayer -- 全局触屏特效接受层, 点击屏幕任意处播放粒子特效

-- 模块局部变量 --
local nZPlayer = 2 -- 玩家信息面板zorder
local nZModule = 0 -- 功能模块Z-order
local nZGuide = 30000 -- 新手引导层
local nZSwitch = 30050 -- 新功能开启面板
local nZTalk = 30100 -- 对话层
local nZLoading = LoadingHelper.getRpcTag() -- 35000 -- 网络请求 loading bar 在runningScene上的层级
local nZLogin = LoadingHelper.getLoginTag() -- 35001 -- 登录时的loading 层级和tag
local nZRegist = LoadingHelper.getRegistTag() -- 35002 -- 登陆时创建角色时的loading 层级和tag
local nZPop = 10000 -- 弹出窗口的初始Zorder
local nPopLayoutTag = 666666 -- popLayer 要附加的layout的tag
local nZTopLayer = 9999999 -- 最顶层触摸特效层的显示层级，最高
local nZNetworkFailed = nZTopLayer - 1 -- 网络断开时的层级，第二高
local nZUILogin = 60000 -- 模块切换时屏蔽触摸事件用的面板
local nShieldLayoutTag = 666669 -- ShieldLayout 的 tag，用于检测是否存在, zhangqi, 2015-03-19
local tbTags = {1, 2, 3}

local m_i18n = gi18n
local m_strCurName = "" -- 当前功能模块的名称
local m_resumLayerType = nil -- changmodule的类型
local m_tbCurKeep = {}  --  当前模块保留的信息
local m_tbCurbClean = false --是否强制清理不需要的公共模块局部变量
local m_tbLayerStack = {} -- 添加其他模块的容器栈，添加新的入栈，模块remove时出栈
local m_tbLayoutStack = {} -- 附加到parent上的Layout的容器栈
local m_tbPopNoScaleLayerStack = {} --  不做缩放的layout
local m_tbTypeStack = {} -- 记录当前addLayout的类型，1, OneTouchGroup; 2, Layout
local m_fnGetWidget = g_fnGetWidgetByName
local m_touchPriority = g_tbTouchPriority
local m_fnRemoveLayout -- removeLayout 后调用的callback

local visibleViews = {} -- table中每个值都是一个CCArray 每个CCArray都记录当前界面要隐藏的scene上所有显示的节点
local m_tbPubModule = {"PaoMaDeng", "PlayerPanel", "MainMenu"} -- 公共模块对应模块名

local m_nLoginTimeout = 30 -- 默认登录loading超时时间为30秒
local m_nRpcTimeout = 10 -- 默认后端请求超时时间10秒



local m_moduleMusic = {
	["MainShip"]= "main.mp3",
	["ExplorMainCtrl"] = "main.mp3",
	["MainCopy"] = "main.mp3",
	["MainFdsCtrl"] = "main.mp3",
	["MainMailCtrl"] = "main.mp3",
	["GuildListCtrl"] = "main.mp3",  
	["MainGuildView"] = "main.mp3",  --工会
	["OpenServerCtrl"]  = "main.mp3",  --开服狂欢
	["MainRecoveryCtrl"] = "fight_easy.mp3",  --回收
	["SBListCtrl"] = "fight_easy.mp3",  --宝物背包
	["MainEquipmentCtrl"] = "fight_easy.mp3", --装备背包
	["EquipFixCtrl"] = "fight_easy.mp3",   --装备附魔
	["MainFormation"]="fight_easy.mp3",  --阵容
	["MainPartner"] = "fight_easy.mp3",  --伙伴背包
	["PartnerStrenCtrl"] = "fight_easy.mp3",  --伙伴强化
	["PartnerTransCtrl"] = "fight_easy.mp3",  --伙伴进阶
	["MainTreaBagCtrl"] = "fight_easy.mp3", --饰品背包
	["PartnerBondCtrl"] = "fight_easy.mp3",  --伙伴加成
	["MainShopCtrl"] = "fight_easy.mp3",   --酒馆
	["MainActivityCtrl"] = "fight_easy.mp3",  --日常
	["MainTrainCtrl"] = "fight_easy.mp3",  --修炼
	["MainCopyCtrl"] = "fight_easy.mp3",  --日常副本
	-- ["MainWorldBossCtrl"] = "fight3.mp3",  --世界boss
}


-- 模块局部方法 --

-- zhangqi, 2015-06-01, 移除所有可能屏蔽常规弹出层的触摸高优先级层
-- 包括对话、功能开启、新手引导层
function removePriorityTouchLayer( ... )
	removeTalkLayer()
	removeSwitchDlg()
	removeGuideLayer()
	removeLoginLoading()
end

--zhangqi, 2014-11-25, 战斗时候会隐藏所有ui，这里的功能是在未退出战斗时提前显示据点界面
function showItemHolder( )
	for i, layer in ipairs(m_tbLayerStack) do
		if (layer:getWidgetByName(g_HolderLayout)~=nil) then
			layer:setVisible(true)
			return
		end
	end
end

-- zhangqi, 2014-07-25, 禁用 uiLayer 和 底层的其他 popLayer 的触摸
function disabledTouchOfOtherLayer(bBattle)
	if (uiLayer:isTouchEnabled()) then
		uiLayer:setTouchEnabled(false)
	end
	if (bBattle) then
		uiLayer:setVisible(false)
	end

	for i, layer in ipairs(m_tbLayerStack) do
		if (layer:isTouchEnabled()) then
			layer:setTouchEnabled(false)
		end
		if (bBattle) then
			layer:setVisible(false)
		end
	end
end

--[[desc:判断某个界面是否在不显示列表 liweidong
    arg1: layer
    return: true 在则不能显示，false不在，则显示  
—]]
function layerIsInHideList(layer)
	for _,val in pairs(visibleViews) do
		for i=1,val:count() do
			local childNode = tolua.cast(val:objectAtIndex(i-1),"CCNode")
			if (layer==childNode) then
				return true
			end
		end
	end
	return false
end

local function visibleAllOther(...)
	if (not uiLayer:isVisible()) then
		if (not layerIsInHideList(uiLayer)) then --liweidong 增加判断是否要显示
			uiLayer:setVisible(true)
		end
	end
	for i, layer in ipairs(m_tbLayerStack) do
		if (not layer:isVisible()) then
			if (not layerIsInHideList(layer)) then --liweidong 增加判断是否要显示
				layer:setVisible(true)
			end
		end
	end
end
-- 关闭一个popLayer时启用下层的 popLayer 的触摸
function enabledTouchOfOtherLayer(bInBattle)
	logger:debug("enabledTouchOfOtherLayer: bInBattle = %s", tostring(bInBattle))
	if (#m_tbLayerStack == 0) then
		uiLayer:clearTouchStat()
		if (not uiLayer:isTouchEnabled()) then
			uiLayer:setTouchEnabled(true)
		end
		if ((not bInBattle) and (not uiLayer:isVisible())) then
			uiLayer:setVisible(true)
		end
	elseif (#m_tbLayerStack >= 1) then
		logger:debug("enabledTouchOfOtherLayer: m_tbLayerStack.count = %d", #m_tbLayerStack)
		local popLayer = m_tbLayerStack[#m_tbLayerStack]
		-- addLayout时，之前的OneTouchGroup可能刚响应了began事件，记录了被触摸的状态
		-- 如果此时弹出了，当关闭刚add的OneTouchGroup时，之前的那个就不能再响应触摸了，需要清除一下触摸状态
		popLayer:clearTouchStat()  -- zhangqi, 2014-08-22
		popLayer:setTouchEnabled(true)

		local widget = popLayer:getWidgetByTag(nPopLayoutTag)
		if (widget) then
			logger:debug("widget.name = %s", widget:getName())
			widget:setTouchEnabled(false) -- zhangqi, 2014-07-30, 画布的root layout要关闭交互才能不屏蔽popLayer上其他控件的事件传递
		end
		-- end

		if (not bInBattle) then
			visibleAllOther()
		end
		-- logger:debug("bShow = %s", tostring(bShow))
	else
		uiLayer:clearTouchStat()
		uiLayer:setTouchEnabled(true)
		visibleAllOther()
	end
end

--[[desc:用 wigModule 替换当前模块，当前模块会被remove掉
    wigModule: widget对象，需要显示的模块根容器
	strName: 切换模块的名称，每个主模块会提供moduleName()方法, 这个参数通常例如：MainShip.moduleName()
	tbKeep: 存放需要保留的公共模块的Tag（对应 nZPmd, nZPlayer, nZMenu)
			例如 副本模块 只需要保留主菜单，需要传入(copyWidget, MainCopy.moduleName(), {3})
    bClean: 是否强制清理不需要的公共模块局部变量, 默认不清理
    resumLayerType:1 不清除当前模块所有信息，专为处理掉落引导需要返回的模块 2 当模块返回来时的处理
    return:  
—]]

function changeModule( wigModule, strName, tbKeep, bClean,resumLayerType)
	if (wigModule) then
		logger:debug("changeModule: curName = %s, newName = %s", m_strCurName, strName)
		m_resumLayerType = resumLayerType
		local oldModuleName = m_strCurName -- 2015-04-15, zhangqi

		if (strName ~= m_strCurName) then
			-- 2013-03-11, 平台统计需求，离开游戏主界面, 主要用于判断在主界面才显示平台的悬浮图标，每次进入离开都要统计
			if (Platform.isPlatform()) then
				if (strName == "MainShip") then -- 进入主界面
					Platform.sendInformationToPlatform(Platform.kEnterTheGameHall)
				end

				if (m_strCurName == "MainShip") then -- 离开主界面
					Platform.sendInformationToPlatform(Platform.kLeaveTheGameHall)
				end
			end

			local tempKeep = tbKeep or {1, 2, 3}

			-- 删除添加到mainscene的已存在的layout

			if (not resumLayerType) then
				for i = 1, #m_tbTypeStack do
					removeLayout()
				end
				DropUtil.releaseAllRsumInfo()
				MReleaseUtil.releaseAllObj()
				-- 清空 PMD 的堆栈信息
				clearPMDParents() -- 2015-10-27
			elseif(resumLayerType == 1) then
				-- 引导过来的界面 需要在删除前缓存起来一份，返回一个可以重新添加缓存界面的函数
				DropUtil.setSourceAndAim(strName,m_strCurName)  	 		-- 建立一个 来源和 终点 模块的一对一映射
				removeAllPopLayout(m_strCurName)
				clearPMDParents()
			elseif(resumLayerType == 2) then
				logger:debug({m_tbTypeStack =  #m_tbTypeStack})
				for i = 1, #m_tbTypeStack do
					removeLayout()
				end
				-- 引导返回的时候清空 PMD 的堆栈信息 ，重新添加堆栈信息。先把wigModule的跑马灯位置设置好
				clearPMDParents() -- 2015-10-27
			end

			local curLayout = layRoot:getChildByTag(nZModule)
			if ((curLayout and not resumLayerType) or resumLayerType == 2)then 
				curLayout:removeFromParentAndCleanup(true) -- 删除当前模块
				local curModule = _G[m_strCurName] -- package.loaded[m_strCurName]
				if (curModule) then
					curModule.destroy() -- 调用被删除模块的析构函数，自定义的清扫工作
					curModule = nil -- 完全的释放模块
				end
			elseif (resumLayerType  == 1) then     --  如果是引导过去的,或者是需要返回的
				local curModule = _G[m_strCurName] -- package.loaded[m_strCurName]

				if (curModule) then
    				DropUtil.insertReturnInfo(m_strCurName,"tbKeep", m_tbCurKeep)
    				DropUtil.insertReturnInfo(m_strCurName,"bClean", m_tbCurbClean)
    				PlayerPanel.insertReturnInfo(m_strCurName)
					DropUtil.insertModuleLayout(m_strCurName,curLayout)

				end
				curLayout:removeFromParentAndCleanup(false) -- 删除当前模块,不停止动画

			end

			layModule = wigModule -- 20140505, 保存当前模块的主画布，方便在模块上添加弹出的UI

			layRoot:addChild(layModule, nZModule, nZModule) -- 添加新模块

			m_strCurName = strName
			m_tbCurKeep = tbKeep
			m_tbCurbClean = bClean

			-- layModule:setTouchEnabled(true)

			--删除不需要保留的公用模块
			local tbExcept = table.complement(tbTags, tempKeep)
			for i, v in ipairs(tbExcept) do
				logger:debug({tbExcept=tbExcept})
				local widget = layRoot:getChildByTag(v)
				if (widget) then
					widget:removeFromParentAndCleanup(true)
				end
--				if (bClean) then -- zhangqi, 不需要重新创建定制信息面板时指定true把以前的清理一下，避免更新人物属性导致找不到对象的问题
--					local mod = package.loaded[m_tbPubModule[v]]
--					if (mod) then
--						mod.destroy()
--					end
--				end
			end

			--创建需要显示的公用模块
			for _, v in ipairs(tempKeep) do
				--if (tbTags[v]) then -- 检查 tag 有效性，只能是公共模块的tag
				local widget = layRoot:getChildByTag(v)
				-- zhangqi,2015-10-08, 信息条修改为附加到模块的根画布，此处不再处理信息条的创建(tonumber(v) ~= nZPlayer)
				if (not widget and tonumber(v) ~= nZPlayer and resumLayerType == nil  ) then -- 如果不存在则创建
					logger:debug("MainScene.CreatePublic: v = %d", v)
					require "script/module/main/MainScene"
					MainScene.CreatePublic(v)
				else
					-- 2015-04-15, zhangqi, 增加如果是进出主界面的模块切换就创建新的跑马灯
					local cond1 = (m_strCurName == "MainShip" and oldModuleName ~= "MainShip")
					local cond2 = (m_strCurName ~= "MainShip" and oldModuleName == "MainShip")
					-- if (v == tbTags[1] and (cond1 or cond2)) then -- 是跑马灯, 删除重建
					-- 		widget:removeFromParentAndCleanup(true)
					-- 		logger:debug("LayerManager create PaoMaDeng: v = %d", v)
					-- 		require "script/module/main/MainScene"
					-- 		MainScene.CreatePublic(v)
					-- 	end

					-- 2015-10-27
					if (v == tbTags[1]) then
						if (cond1 or cond2) then
							widget:removeFromParentAndCleanup(true)
							logger:debug("LayerManager create PaoMaDeng: v = %d", v)
							require "script/module/main/MainScene"
							MainScene.CreatePublic(v)
						elseif (TopBar.getLayBar()) then
							logger:debug("TopBar.getLayBar")
							setPaomadeng(wigModule, 1,"changeModule-setPaomadeng")
						else
							require "script/module/main/MainScene"
							logger:debug("MainScene_CreatePublic")
							MainScene.CreatePublic(v)
						end
					else
						require "script/module/main/MainScene"
						MainScene.CreatePublic(v)
					end
				end
				--end
			end
			resumLayerName = oldModuleName
			uiLayer:clearTouchStat() -- zhangqi, 2014-08-22, 清除切换前可能保存的已触摸状态，避免不再响应触摸的问题
		end

	end

	--yangna 2016.1.5 不同模块音乐切换  
	if (m_moduleMusic[m_strCurName]) then 
		-- AudioHelper.playSceneMusic(m_moduleMusic[m_strCurName])
		AudioHelper.playMainMusic()
	end 

	--zhangjunwu 2014-09-12 切换模块之后删除添加的触摸屏蔽层
	begainRemoveUILoading()
	addShieldLayout()
	require("script/module/rapidSale/RapidSaleCtrl")
	RapidSaleCtrl.create(strName)
	m_resumLayerType = nil

	delTextureCache()  --liweidong changeModule时释放内存
end

-- 添加一个层到runningScene的指定Zorder
local function addToRunningScene(layer, Zorder)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(layer, Zorder, Zorder)
end

local function removeFromRunningScene( tag )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene:getChildByTag(tag)) then
		runningScene:removeChildByTag(tag, true)
	end
end

-- 弹出对话层
function addTalkLayer( widget )
	local layout = tolua.cast(widget, "Layout")
	layout:setTouchEnabled(true)
	layout:setBackGroundColorType(LAYOUT_COLOR_SOLID) -- 设置单色模式
	layout:setBackGroundColor(ccc3(0x00, 0x00, 0x00))
	layout:setBackGroundColorOpacity(100)

	local layer = OneTouchGroup:create()
	layer:setTouchPriority(m_touchPriority.talk)
	layer:addWidget(layout)
	addToRunningScene(layer, nZTalk)
end

function removeTalkLayer( ... )
	removeFromRunningScene(nZTalk)
end

function getTalkLayer( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local layer = runningScene:getChildByTag(nZTalk)
	return layer
end

-- 弹出新功能开启面板
function addSwitchDlg( widget )
	logger:debug("g_closeGuide= %s",g_tGuideState.g_closeGuide)
	if g_tGuideState.g_closeGuide then -- 增加一个开关 在GlobalVars.lua 中 设置成true 后就关闭引导
		return 
	end
	local layout = tolua.cast(widget, "Layout")
	layout:setTouchEnabled(true)
	local layer = OneTouchGroup:create()
	layer:setTouchPriority(m_touchPriority.switch)
	layer:addWidget(layout)
	addToRunningScene(layer, nZSwitch)
end

function removeSwitchDlg( ... )
	removeFromRunningScene(nZSwitch)
end

function getSwitchDlg(  )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local layer = runningScene:getChildByTag(nZSwitch)
	return layer
end

-- 弹出新手引导层
function addGuideLayer( ccLayer )
	logger:debug("g_closeGuide= %s",g_tGuideState.g_closeGuide)
	if g_tGuideState.g_closeGuide then -- -- 增加一个开关 在GlobalVars.lua 中 设置成true 后就关闭引导
		return 
	end
	ccLayer:setTouchPriority(m_touchPriority.guide)
	addToRunningScene(ccLayer, nZGuide)

	-- local layer = OneTouchGroup:create()
	-- layer:setTouchPriority(m_touchPriority.guide + 1)
	-- layer:addChild(ccLayer)
	-- addToRunningScene(layer, nZGuide)
end

function removeGuideLayer( ... )
	removeFromRunningScene(nZGuide)
end

function getGuideLayer( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local layer = runningScene:getChildByTag(nZGuide)
	return layer
end

-- 弹出网络错误的面板, zhangqi, 2104-09-04
function addNetworkDlg( dlg )
	local popLayer = OneTouchGroup:create()
	popLayer:setTouchPriority(g_tbTouchPriority.network)
	popLayer:addWidget(dlg)
	addToRunningScene(popLayer, nZNetworkFailed)
end

function removeNetworkDlg( ... )
	removeFromRunningScene(nZNetworkFailed)
end

function networkDlgIsShow( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	return runningScene:getChildByTag(nZNetworkFailed)
end


function isInBattle( ... )
	local widget
	for i, layer in ipairs(m_tbLayerStack) do
		widget = layer:getWidgetByTag(nPopLayoutTag)
		if (widget) then
			logger:debug("In Battle wigLayout:getName() = %s", widget:getName())
			if (widget:getName() == g_battleLayout) then
				return true
			end
		end
	end
	return false
end

local function isBattleLayer( layout )
	if (layout) then
		return layout:getName() == g_battleLayout
	end
	return false
end

-- 添加新的全屏层容器layout时 让其他全屏层容器和底层modulelayout自动隐藏
function hideOtherNoScaleLayout( ... )
	if (#m_tbPopNoScaleLayerStack == 0) then
		local curLayout = layRoot:getChildByTag(nZModule)
		if (curLayout) then
			curLayout:setVisible(false)
		end
	else
		for i,v in ipairs(m_tbPopNoScaleLayerStack) do
			local noScalelayout = m_tbPopNoScaleLayerStack[i]
			noScalelayout:setVisible(false)
		end
	end
end

--[[desc:addLayout弹框调用 不显示放大效果
    arg1: layout
    return: nil
—]]
function addLayoutNoScale(wigLayout, parent, nPriority, customZorder)
	-- hideOtherNoScaleLayout()
	return addLayout(wigLayout,parent,nPriority,customZorder,true)
end
--[[desc:添加一个新的层容器
    wigLayout: 层容器对象
    parent: 要附加到的父容器，如果为nil则默认加到TouchGroup的最高层
    nPriority: 指定特殊的触摸优先级
    customZorder: 指定特殊的Zorder
    scale: nil或false时显示放大效果，true时不显示放大效果
    return:   
—]]


-- menghao 让一个UI在addLayout到屏幕时不会改变颜色,addLayout前调用
local bLockOpacity
function lockOpacity()
	bLockOpacity = true
end

--  增加掉落功能返回时 缓存的layout界面
function addPopLayer( popLayerTb,visible )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local popLayer = popLayerTb.popLayer
	local popType = popLayerTb.popType
	local popZ = nZPop + #m_tbLayerStack + 1
	runningScene:addChild(popLayer, popZ, popZ)
	-- disabledTouchOfOtherLayer(isBattleLayer(wigLayout)) -- 禁用 uiLayer 和 底层的其他 popLayer 的触摸
	table.insert(m_tbLayerStack, popLayer)
	if (popType ==  1) then
		hideOtherNoScaleLayout()  -- 隐藏其他全屏容器层
		table.insert(m_tbPopNoScaleLayerStack,popLayer)
	end
	table.insert(m_tbTypeStack, 1)
	addShieldLayout()
	begainRemoveUILoading()
end


--  增加掉落功能返回时 缓存的添加到module上的 界面
function addModuleChildLayer( popLayerTb,visible )
	local curModule = getModuleRootLayout()
	addLayoutNoScale(popLayerTb.popLayer,curModule)
end


function addLayout( wigLayout, parent, nPriority, customZorder, scale)

	addCommonLayout({wigLayout = wigLayout, parent = parent, nPriority = nPriority, customZorder = customZorder, scale = scale,})

end

--[[
	新接口兼容老接口 参数形式修改为table
	tParams = {
		wigLayout = , 
		parent, 
		nPriority, 
		customZorder, 
		scale,
		以上为老接口使用字段 
		animation, 新增 是否新的弹出动画
	}
]]


function addCommonLayout( tParams )
	if (tParams.wigLayout) then

		local tbExcept = {"partner_information", "treasure_fetter", "equip_taozhuang_info", "layForShield","copy_result_layout","Explor_mask_layout","Enter_Explor_layout","Activity_Select_Hard_Layout", "all_bag"}
		local lay = tolua.cast(tParams.wigLayout, "Layout")

		logger:debug("lay:getName() = %s", lay:getName())
		local bOpacity = not table.include(tbExcept, {lay:getName()})

		if not tParams.scale then
			UIHelper.layOutScaleAction(tParams)
		end

		if tParams.animation then
			UIHelper.openAnimation(tParams)
		end


		tParams.wigLayout:setTouchEnabled(true)

		if (lay and (bOpacity and not bLockOpacity)) then -- 如果画布名称不在 tbExcept 中才设置半透明
			logger:debug("set background")
			tParams.wigLayout:setBackGroundColorType(LAYOUT_COLOR_SOLID) -- 设置单色模式
			tParams.wigLayout:setBackGroundColor(ccc3(0x00, 0x00, 0x00))
			tParams.wigLayout:setBackGroundColorOpacity(166)
		end
		bLockOpacity = nil

		if (tParams.parent) then
			tParams.wigLayout.isLayout = true
			tParams.parent:addChild(tParams.wigLayout)
			logger:debug({parent=tParams.parent})
			logger:debug({wigLayout=tParams.wigLayout})

			-- table.insert(m_tbLayerStack, wigLayout)
			table.insert(m_tbLayoutStack, tParams.wigLayout)
			table.insert(m_tbTypeStack, 2)
		else
			-- modified by zhangqi， 为了使CCTableView列表里物品按钮弹出的面板具有屏蔽效果，需要添加一层TouchGroup来吃掉触摸事件
			local popLayer = OneTouchGroup:create() -- TouchGroup:create()
			popLayer:addWidget(tParams.wigLayout)
			tParams.wigLayout:setTag(nPopLayoutTag)

			local popZ = nZPop + #m_tbLayerStack + 1

			if (tParams.customZorder) then -- 如果有给定的Zorder
				popZ = tParams.customZorder
			end

			if (tParams.nPriority) then
				popLayer:setTouchPriority(tParams.nPriority)
			else
				popLayer:setTouchPriority(- #m_tbLayerStack - 1)
			end
			logger:debug("zorder = %d, priority = %d", popZ, popLayer:getTouchPriority())

			local runningScene = CCDirector:sharedDirector():getRunningScene()
			if (not runningScene) then
				runningScene = CCScene:create()
				CCDirector:sharedDirector():runWithScene(runningScene)
			end
			runningScene:addChild(popLayer, popZ, popZ)
			if (tParams.scale) then
				table.insert(m_tbPopNoScaleLayerStack, popLayer)   -- 不做缩放的layout
			end

			disabledTouchOfOtherLayer(isBattleLayer(tParams.wigLayout)) -- 禁用 uiLayer 和 底层的其他 popLayer 的触摸

			table.insert(m_tbLayerStack, popLayer)
			table.insert(m_tbTypeStack, 1)
		end
		addShieldLayout()
		--zhangjunwu 2014-09-12 切换模块之后删除添加的触摸屏蔽层
		begainRemoveUILoading()
	end


	delTextureCache() --liweidong addlayout时释放内存
end




--[[desc:屏蔽旧界面往新界面传递触摸 添加屏蔽层
    arg1: nil
    return: nil
—]]
function addShieldLayout()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene == nil) then
		return
	end
	local touchLayer = OneTouchGroup:create()
	touchLayer:setTag(nShieldLayoutTag) -- 2015-03-19
	touchLayer:setTouchPriority(g_tbTouchPriority.ShieldLayout)
	local  t_layou = Layout:create()
	t_layou:setTouchEnabled(true)
	touchLayer:addWidget(t_layou)
	runningScene:addChild(touchLayer)

	performWithDelay(runningScene,function()
		local shield = runningScene:getChildByTag(nShieldLayoutTag)
		if (shield) then
			shield:removeFromParentAndCleanup(true)
		end
	end, 0.01)
end

--[[desc:隐藏场景上的所有节点 调用之后必须在退出界面时调用remuseAllLayoutVisible
    arg1: key 标识某个界面 传入moduleName()即可
    return: nil 
—]]
function hideAllLayout(key)
	local scene = CCDirector:sharedDirector():getRunningScene()
	visibleViews[key] = CCArray:create()

	visibleViews[key]:retain()
	local sceneChildArray = scene:getChildren()
	for idx=1,sceneChildArray:count() do
		----print("childNode:",idx,sceneChildArray:count() )
		local childNode = tolua.cast(sceneChildArray:objectAtIndex(idx-1),"CCNode")
		if(childNode~=nil and childNode:isVisible()==true and childNode~=topLayer)then
			childNode:setVisible(false)
			visibleViews[key]:addObject(childNode)
		end
	end
end

--[[desc:恢复场景上的所有隐藏节点的显示
    arg1:  key 标识某个界面 传入moduleName即可
    return: nil  
—]]
function remuseAllLayoutVisible(key)
	--CCLuaLog("enter remuseAllLayoutVisible")
	if(visibleViews[key]~=nil)then
		for idx=1,visibleViews[key]:count() do
			local childNode = tolua.cast(visibleViews[key]:objectAtIndex(idx-1),"CCNode")
			if(childNode~=nil)then
				childNode:setVisible(true)
			end
		end
		visibleViews[key]:removeAllObjects()
		visibleViews[key]:release()
		visibleViews[key] = nil
	end
end

function addRemoveLayoutCallback( fnCallback )
	m_fnRemoveLayout = fnCallback
end

function checkNoScalePopLayer( layer )
	logger:debug({m_tbPopNoScaleLayerStack=m_tbPopNoScaleLayerStack})
	local removedLayIsNoScale = false
	local stackIndex = 0
	local layerIndex = #m_tbPopNoScaleLayerStack
	for i=1,#m_tbPopNoScaleLayerStack do
		local tempPopLayer = m_tbPopNoScaleLayerStack[i]
		logger:debug({layer = layer})
		logger:debug({tempPopLayer = tempPopLayer})
		if (tempPopLayer == layer) then
			removedLayIsNoScale = true
			stackIndex = i
			break
		end
	end
	return removedLayIsNoScale,stackIndex
end

--删除全屏容器layout
function removeNoScaleLayer( removelayer )
	local removedLayIsNoScale,layerIndex = checkNoScalePopLayer(removelayer)  -- 判断该容器是否是全屏容器layout
	logger:debug({layerIndex=layerIndex})
	-- 删掉全屏容器layout之前 然后其后面的界面显示出来
	if (layerIndex >1 ) then
		local poplayer = m_tbPopNoScaleLayerStack[layerIndex-1]
		poplayer:setVisible(true)
		table.remove(m_tbPopNoScaleLayerStack,layerIndex)
	elseif (layerIndex == 1 ) then
		local curLayout = layRoot:getChildByTag(nZModule)
		if (curLayout) then
			curLayout:setVisible(true)
		end
		table.remove(m_tbPopNoScaleLayerStack,layerIndex)
	end
end



--[[
	新接口 兼容老接口 removeLayout 参数形式修改为table
	add by huxiaozhou 20151030
	tParams = {
		Flag = number --  云鹏用得参数 remove的时候 cleanup 是否为true
		action = true -- 表示有关闭动画
		endPos = ccp  -- runAction 的DesPos
	}
--]]
function removeCommonLayout( tParams )
	local clearFlag = (tParams.Flag == 2) and 2 or 1
	logger:debug({m_tbPopNoScaleLayerStack=m_tbPopNoScaleLayerStack})

	local function removeFuc( ... )
		local removelayer 
		if (m_tbTypeStack and (#m_tbTypeStack > 0)) then
			local popType = table.remove(m_tbTypeStack)
			if (popType == 1) then
				if (m_tbLayerStack and (#m_tbLayerStack > 0)) then
					local popLayer = tolua.cast(table.remove(m_tbLayerStack), "CCNode")

					if (popLayer) then
						removelayer = popLayer
						popLayer:removeFromParentAndCleanup((clearFlag == 1))
						enabledTouchOfOtherLayer(isInBattle())
					end
				end
			else
				if (m_tbLayoutStack and (#m_tbLayoutStack > 0)) then
					local layout = table.remove(m_tbLayoutStack)
					if (layout) then
						removelayer = popLayer
						layout:removeFromParentAndCleanup((clearFlag == 1))
					end
				end
			end

			if (m_fnRemoveLayout and type(m_fnRemoveLayout) == "function") then
				m_fnRemoveLayout()
			end
		end
		removeNoScaleLayer(removelayer)   --删除全屏容器layout 先判断removelayer是否是全屏容器layout 
		addShieldLayout()
	end


	if tParams.action then
		UIHelper.closeAnimation({widget = getCurrentPopLayer() ,callback = removeFuc, endPos = tParams.endPos})
	else
		removeFuc()
	end
	delTextureCache()  ---liweidong removeLayout时调用 
end



-- 删除根容器上最近添加的 其他层容器
-- clearFlag --  删除界面 是否停止动画   -- add by sunyunpeng
function removeLayout( Flag )
	removeCommonLayout({Flag = Flag})
end

-- 2014-12-04, 指定了popLayer或Layout名称，先查找，如果没有则不做任何操作
function removeLayoutByName( sName )
	if (sName and m_tbTypeStack and (#m_tbTypeStack > 0)) then
		local popType = m_tbTypeStack[#m_tbTypeStack]
		if ( popType == 1 ) then
			if (m_tbLayerStack and (#m_tbLayerStack > 0)) then
				local layout = m_tbLayerStack[#m_tbLayerStack]:getWidgetByName(sName)
				if (layout) then
					removeLayout()
				end
			end
		else
			if (m_tbLayoutStack and (#m_tbLayoutStack > 0)) then
				local layout = m_tbLayoutStack[#m_tbLayoutStack]
				if (layout and layout:getName() == sName ) then
					removeLayout()
				end
			end
		end
	end
end

-- 隐藏当前所有在 当前模块上 弹出的poplayout
function removeAllPopLayout( moduleLayoutName )
	logger:debug({m_tbTypeStack=m_tbTypeStack})

	local haveParentIndex = 1
	local noParentIndex = 1

	for i=1,#m_tbTypeStack do
		local layerType = m_tbTypeStack[i]

		if (layerType == 2) then                          -- 指定了父节点的界面
			local childLayer = m_tbLayoutStack[haveParentIndex]
			local childisGood = UIHelper.isGood(childLayer)
			local parent = childLayer:getParent()
			local curModuleLayer = getModuleRootLayout()
			if (parent == curModuleLayer and childisGood)  then
				local bpopIsNoScal = checkNoScalePopLayer(childLayer)
				local popType = bpopIsNoScal and 1 or 0
				local parentisGood = UIHelper.isGood(parent)
				DropUtil.insertModeluChildLayout(moduleLayoutName,childLayer,popType)    -- 添加curLayout 上的 child界面缓存
			end
			haveParentIndex =  haveParentIndex + 1
		else                                                --没有知道父节点的界面
			local poplayer = m_tbLayerStack[noParentIndex]
			local bpopIsNoScal = checkNoScalePopLayer(poplayer)
			local popType = bpopIsNoScal and 1 or 0
			DropUtil.insertPopLayout(moduleLayoutName,poplayer,popType)  -- 添加界面缓存
			noParentIndex =  noParentIndex + 1
		end
	end

	for i=1,#m_tbTypeStack do
		removeLayout(2)
	end

end

-- 点击登录按钮后显示的loading面板, 进入主页后自动消失
function addLoginLoading( sPrompt, bNoTimeout)
	logger:debug("XXXXQQQQ:addLoginLoading")
	local tbArgs = {text = m_i18n[4746], nTag = nZLogin}
	tbArgs.timeout = bNoTimeout == true and nil or m_nLoginTimeout
	LoadingHelper.addLoadingLayer(tbArgs)
end

function removeLoginLoading( ... )
	logger:debug("XXXXQQQQ:removeLoginLoading")
	LoadingHelper.removeLoadingLayer(nZLogin)
end

-- 登陆时和创建角色的时候的loading
function addRegistLoading( sPrompt, bNoTimeout )
	-- 注释的部分是新loading界面的功能，换loading的时候放开即可
--	local tbArgs = {nTag = nZRegist}
--	tbArgs.timeout = bNoTimeout == true and nil or m_nLoginTimeout
--	LoadingHelper.addLoadingLayer(tbArgs)
	addLoginLoading( sPrompt, bNoTimeout)
end

function removeRegistLoading( ... )
	-- 注释的部分是新loading界面的功能，换loading的时候放开即可
--	LoadingHelper.setProgressBarOver()
--	local runningScene = CCDirector:sharedDirector():getRunningScene()
--	performWithDelay(runningScene,function()
--		LoadingHelper.removeLoadingLayer(nZRegist)
--	end,1/60)
	LoadingHelper.removeLoadingLayer(nZLogin)
end

-- 发送网络请求显示的loading 面板, removeTimeout: remove自己的超时时间，单位秒，默认10秒
-- local loadingTimes = 0 --liweidong 当前添加了几层网络层  同时发送多个请求，不能移除网络层 --以下注释不要删除 如果线上包测试出现：快速连点报错的情况，把本行注释放开
-- zhangqi, 2015-11-02, 增加参数 bRpc，true表示后端请求的loading，nil或false表示其他URL请求
function addLoading( removeTimeout, bRpc )
	logger:debug("XXXXQQQQ:addLoading")
	-- loadingTimes = loadingTimes+1 --以下注释不要删除 如果线上包测试出现：快速连点报错的情况，把本行注释放开

	LoadingHelper.addLoadingLayer({text = m_i18n[4747], timeout = m_nRpcTimeout, nTag = nZLoading, bRpc = bRpc})
end

function removeLoading( ... )
	logger:debug("XXXXQQQQ:removeLoading")
	--以下注释不要删除 如果线上包测试出现：快速连点报错的情况，把以下注释放开
	-- --liweidong 同时发送多个请求，不能移除网络层
	-- loadingTimes = loadingTimes-1
	-- if (loadingTimes>0) then
	-- 	return
	-- end
	-- loadingTimes = 0

	LoadingHelper.removeLoadingLayer(nZLoading)
end
function addCopyLoading()
	logger:debug("XXXXQQQQ:addCopyLoading")
	local tbArgs = {text = m_i18n[4747], nTag = nZLogin}
	tbArgs.timeout = bNoTimeout == true and nil or m_nLoginTimeout
	LoadingHelper.addLoadingLayer(tbArgs)
end
function removeCopyLoading()
	logger:debug("XXXXQQQQ:removeCopyLoading")
	LoadingHelper.removeLoadingLayer(nZLogin)
end

-- 模块切换显示的loading 面板，屏蔽按钮
function addUILoading()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene:getChildByTag(nZUILogin)) then
		logger:debug("UILoading  exist")
		return
	end
	local popLayer = OneTouchGroup:create()
	popLayer:setTouchPriority(g_tbTouchPriority.talk)
	--popLayer:addWidget(m_layLoading)
	local popZ = #m_tbLayerStack + 1 + nZUILogin
	runningScene:addChild(popLayer, popZ + 2000000, nZUILogin)
	logger:debug("addUILoading——————————————")
	performWithDelay(runningScene,function()
		begainRemoveUILoading()
	end,10)
end

function begainRemoveUILoading( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if(runningScene and runningScene:getChildByTag(nZUILogin))then
		local actionArray = CCArray:create()
		actionArray:addObject(CCDelayTime:create(0.1))

		actionArray:addObject(CCCallFuncN:create(function ( ... )
			logger:debug("removeUILoading: %d", nZUILogin)
			runningScene:removeChildByTag(nZUILogin, true)
		end))

		runningScene:runAction(CCSequence:create(actionArray))
	end
end


-- add by yangna 2015.4.16 添加需要手动删除的屏蔽层 
local nUILayerTag = 600101
function addUILayer( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene:getChildByTag(nUILayerTag)) then
		logger:debug("addUILayer  exist")
		return
	end
	local popLayer = OneTouchGroup:create()
	popLayer:setTouchPriority(g_tbTouchPriority.talk)
	runningScene:addChild(popLayer, 2000000, nUILayerTag)
end

--add by yangna 2015.4.16 删除屏蔽层
function removeUILayer( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if(runningScene and runningScene:getChildByTag(nUILayerTag))then
		local actionArray = CCArray:create()
		actionArray:addObject(CCDelayTime:create(0.1))
		actionArray:addObject(CCCallFuncN:create(function ( ... )
			logger:debug("removeUILoading: %d", nUILayerTag)
			runningScene:removeChildByTag(nUILayerTag, true)
		end))
		runningScene:runAction(CCSequence:create(actionArray))
	end
end


-- 返回当前模块的画布容器对象
function getModuleRootLayout( ... )
	return layModule
end

function getUIGroup( ... )
	return uiLayer
end
-- 2016-01-08
function removeLogoLayer( ... )
	local uiLayer = getUIGroup()
    local logoLayer = uiLayer:getChildByTag(11118888)
    if (logoLayer) then
    	logoLayer:removeFromParentAndCleanup(true)
    end
end

function getRootLayout( ... )
	return layRoot
end

function curModuleName( ... )
	return m_strCurName or ""
end

function isRunningModule( refModule )
	if (refModule and type(refModule.moduleName == "function")) then
		return (refModule.moduleName() == m_strCurName)
	end
end

function getChangModuleType( ... )
	return m_resumLayerType
end

function setCurModuleName( sName )
	m_strCurName = sName
end

function getCurrentPopLayer( ... )
	if (m_tbLayerStack and #m_tbLayerStack > 0) then
		return m_tbLayerStack[#m_tbLayerStack]
	else
		return uiLayer
	end
end


local tbPMDParents = {}
local tbPMDZOrders = {}
-- 先 changemodule 然后 再setPaomadeng
function clearPMDParents( ... )
	local changModuleType = getChangModuleType()
	if (changModuleType and changModuleType == 1) then
		for i=#tbPMDParents,2,-1 do
			local PMDParent = tbPMDParents[i]
			local PMDZOrder = tbPMDZOrders[i]
			DropUtil.insertCallFn(curModuleName(),function ( ... )
	                logger:debug(PMDParent)
	                logger:debug(PMDZOrder)
	                if (PMDParent ~= getModuleRootLayout()) then
	                	LayerManager.setPaomadeng(PMDParent, PMDZOrder,"clearPMDParents-setPaomadeng")
	                end
	            end)
		end
	end

	for i = 1, #tbPMDParents do
		-- if (changModuleType and changModuleType == 1) then
			local PMDParent = tbPMDParents[#tbPMDParents]
			local curPMD = PMDParent:getChildByName("PaoMaDeng")
			if (curPMD) then
				curPMD:removeFromParentAndCleanup(true)
				curPMD = nil
			end
		-- end
		table.remove(tbPMDParents)
		table.remove(tbPMDZOrders)
	end

end

function insertPMDParents( PMDParent,PMDZOrder )
	table.insert(tbPMDParents, PMDParent)
	table.insert(tbPMDZOrders, PMDZOrder)
end

function setPaomadeng( curParent, zOrder,str )
	local PMDParent
	if (table.isEmpty(tbPMDParents)) then
		PMDParent = layRoot
		logger:debug({layRoot = layRoot})
		tbPMDParents = {layRoot}
		tbPMDZOrders = {1}
	else
		PMDParent = tbPMDParents[#tbPMDParents]
	end

	local PMD = PMDParent:getChildByName("PaoMaDeng")
	if (PMD) then
		logger:debug("转移topbar")
		local barType = PMD.tttopBarType
		if (barType == "yellowTB") then
			PMD:removeFromParentAndCleanup(true)
			PMDParent.fngfvbnvbnvbnvn = true
			require "script/module/main/TopBar"
			PMD = TopBar.create(true)
			PMD:setName("PaoMaDeng")
			curParent:addChild(PMD, zOrder or 0, 1)
		else
			PMD:retain()
			PMD:removeFromParentAndCleanup(false)
			-- PMDParent:removeChild(PMD, false)
			curParent:addChild(PMD, zOrder or 0, 1)
			PMD:setName("PaoMaDeng")
			PMD:release()
		end
	else
		logger:debug("新创建一个topbar")
		require "script/module/main/TopBar"
		PMD = TopBar.create()
		PMD:setName("PaoMaDeng")
		curParent:addChild(PMD, zOrder or 0, 1)

		tbPMDParents = {}
		tbPMDZOrders = {}
	end

	table.insert(tbPMDParents, curParent)
	table.insert(tbPMDZOrders, zOrder or 0)

end

function resetPaomadeng()
	local changModuleType = getChangModuleType()
	logger:debug({resetPaomadeng = changModuleType})
	if (changModuleType and changModuleType == 1) then
		-- local PMDParent = tbPMDParents[#tbPMDParents]
		-- local curPMD = PMDParent:getChildByName("PaoMaDeng")
		-- curPMD:removeFromParentAndCleanup(true)
		return
	end

	local PMDParent = tbPMDParents[#tbPMDParents]
	logger:debug(PMDParent)

	table.remove(tbPMDParents)
	table.remove(tbPMDZOrders)
	if (table.isEmpty(tbPMDParents)) then
		logger:debug("移除topbar")
	else
		logger:debug("重置topbar")
		local PMD = PMDParent:getChildByName("PaoMaDeng")
		logger:debug(PMD)

		if (PMD) then
			PMD:retain()
			PMDParent:removeChild(PMD, false)
			local NextPMDParent = tbPMDParents[#tbPMDParents]
			local zOrder = tbPMDZOrders[#tbPMDZOrders]
			-- if (PMDParent == layRoot) then
			-- 	logger:debug("PMDParent != layRoot")
			-- 	local yellowBar = PMDParent:getChildByName("PaoMaDeng")
			-- 	if (PMDParent.fngfvbnvbnvbnvn) then
			-- 		-- yellowBar:setEnabled(true)
			-- 		-- yellowBar:setVisible(true)
			-- 		require "script/module/main/TopBar"
			-- 		local PMDNew = TopBar.create()
			-- 		PMDNew:setName("PaoMaDeng")
			-- 		PMDParent:addChild(PMDNew, zOrder or 0, 1)
			-- 	else
			-- 		PMDParent:addChild(PMD, zOrder or 1, 1)
			-- 	end
			-- else
				logger:debug("PMDParent != layRoot")
				NextPMDParent:addChild(PMD, zOrder or 0, 1)
			-- end
			PMD:release()
		end
	end

end
function delTextureCache()
	-- local memberMax = 60
	-- if (CCTextureCache:sharedTextureCache():getDumpCachedTextureInfo()/1024>memberMax) then
	-- 	logger:debug("remove unuse Textures info:============")
	-- 	-- CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
	-- 	CCTextureCache:sharedTextureCache():removeUnusedTextures()
	-- end
	-- logger:debug("use Textures info:============")
	-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end
function init(...)
	if (not uiLayer) then
		m_strCurName = ""
		uiLayer = OneTouchGroup:create() --
		uiLayer:setTag(55555)
		-- uiLayer:setTouchPriority(-1)

		layRoot = Layout:create()

		layRoot:setSize(g_winSize)
		uiLayer:addWidget(layRoot)

		-- m_layLoading = createLoading()
	end

	if (not topLayer) then
		topLayer = CCLayer:create()
		topLayer:setTouchEnabled(true)
		topLayer:registerScriptTouchHandler(function ( eventType, x, y )
			if (eventType == "began") then
				logger:debug("topLayer on began: x = %f, y = %f", x, y)
				-- 播放例子特效
				local waveNode = CCParticleSystemQuad:create("images/effect/zhu_dianji/zhu_dianji.plist")
				waveNode:setAutoRemoveOnFinish(true)
				waveNode:setPosition(ccp(x, y))
				topLayer:addChild(waveNode)
				-- delTextureCache()  ---liweidong test
				-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
			end
		end,
		false, g_tbTouchPriority.touchEffect)
	end


	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene) then
		runningScene:removeAllChildrenWithCleanup(true)
		runningScene:addChild(uiLayer)
		runningScene:addChild(topLayer, nZTopLayer, nZTopLayer)
	else
		local sceneGame = CCScene:create()
		sceneGame:addChild(uiLayer)
		sceneGame:addChild(topLayer, nZTopLayer, nZTopLayer)
		CCDirector:sharedDirector():runWithScene(sceneGame)
		runningScene = sceneGame
	end
	--liweidong 测试内存临时代码
	-- local uiLayer = OneTouchGroup:create()
	-- uiLayer:setContentSize(CCSizeMake(100,100))
	-- local layRoot = Layout:create()
	-- layRoot:setTouchEnabled(false)
	-- layRoot:setSize(CCSizeMake(100,100))
	-- uiLayer:addWidget(layRoot)
	-- -- runningScene:addChild(uiLayer,nZTopLayer)
	-- local btn = Button:create()
	-- btn:loadTextures("ui/3.png", nil, nil) 
	-- layRoot:addChild(btn)
	-- btn:addTouchEventListener(function(sender, eventType)
	-- 			if (eventType == TOUCH_EVENT_ENDED) then
	-- 				CCTextureCache:sharedTextureCache():removeUnusedTextures()
	-- 				CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
	-- 			end
	-- 		end
	-- 	)
end

function destroy(...)
	-- if (m_layLoading) then
	-- 	m_layLoading:release()
	-- 	m_layLoading = nil
	-- end

	-- m_animat = nil

	m_strCurName = ""
	m_tbLayerStack = nil
	uiLayer = nil
	layRoot = nil

	package.loaded["LayerManager"] = nil
end

function moduleName()
	return "LayerManager"
end

function create(...)

end

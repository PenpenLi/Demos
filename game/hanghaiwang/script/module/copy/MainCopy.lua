-- FileName: MainCopy.lua
-- Author: xianghuiZhang
-- Date: 2014-03-31
-- Purpose: 普通副本、精英副本、探索世界地图

module("MainCopy", package.seeall)

require "script/module/copy/copyData"
require "script/model/user/UserModel"
require "script/module/public/Cell/CopyCell"
require "script/module/public/HZListView"
require "script/module/copy/ExplorEntCtrl"
require "script/module/copy/ExplorData"

-- 引用数据库文件
require "db/DB_Copy"
require "db/DB_Elitecopy"
require "db/DB_World"
require "db/DB_Stronghold"
require "db/DB_Copy_entrance"
require "script/module/copy/itemCopy"
require "script/module/guild/GuildDataModel"
require "script/module/guild/GuildUtil"
require "script/module/guildCopy/GCItemModel"
require "script/module/guide/GuideModel"
require "script/module/guide/GuideEliteView"
	
-- UI控件引用变量 --
local curCopyLayer --当前副本容器层
local copyGeneral -- 普通副本容器层
local copyElite-- 精英副本容器层
local copyExplor --探索副本容器层

local nZPlayer = 2 -- 玩家信息面板zorder

local copyListLayer-- 普通副本列表容器层
local topExpLayer -- 头部经验条
local topCopyTagLayer -- 头部副本选项
--local itemCopyLayer -- 进入副本挑战
local scrollViewLayout --主场景scroll
local scrollView --主场景scroll
local fogLayer --迷雾
local m_imgWorldBg  -- 背景地图，20140516，zhangqi

local nomalBtn -- 普通副本按钮
local eliteBtn -- 精英副本按钮
local explorBtn --探索副本按钮
local awakeBtn -- 觉醒副本


local zOrderYeqian = 100
local m_minShipTag =766 --小船tag

-- 模块局部变量 --
-- local m_nBgRate = g_fScaleY -- zhangqi, 20140516, 优先高度适配
local mapId--当前mapid
local mapInfo --当前地图数据
local curEntranceId = 1 --当前入口id
local curCopyBattleId = 1 --当前攻打的副本id
local curCopyFlogId=1 --当前云攻打的副本id
local curCopyPosX=0
local curCopyPosY=0 --当前副本的坐标
local curScrolInerWidth=0  --可滑动区域大小。
local canExploreNum=0  --可探索副本个数
local isNoramlFocused = true --默认加载普通副本
local blCopyStyle = 1 --当前场景类型
local copyStartTag = 10000
local curWorldData --当前世界中各个副本的数据集合
local tbShowCopyData = nil --普通副本列表cell的数据集合
local curPX = 0 --当前scrollview定位点
local copyTipTag = 100000
local layPower = nil -- zhangqi, 2014-07-29, 角色信息条
local scrolloffset =nil --记录滚动层偏移位置，当点击返回时还原
--普通副本列表
local m_layCell
local listView = false

local layoutMain --主界面layer
local GuildBattleBg = nil --战斗引导背景
--局部变量优化
local DB_Copy_entrance = DB_Copy_entrance
local DB_Copy = DB_Copy
local DB_Elitecopy = DB_Elitecopy
local DB_World = DB_World
local DB_Stronghold = DB_Stronghold
local GuildDataModel = GuildDataModel
local GuildUtil = GuildUtil
local GCItemModel = GCItemModel
local UserModel = UserModel
local lua_string_split = lua_string_split
local copyEntrancePath = copyEntrancePath
local copyNormalPath = copyNormalPath
local g_fnGetWidgetByName = g_fnGetWidgetByName
local itemCopy = itemCopy
local UIHelper = UIHelper
local performWithDelay = performWithDelay
local performWithDelayFrame = performWithDelayFrame
local gi18n = gi18n
local m_i18n = gi18n
-- ui文件名称 --
local jsonMain = "ui/copy_main.json"
local jsonyeqian= "ui/copy_yeqian.json"
local jsonElite= "ui/elite_main.json"
local jsonExplor = "ui/explore_map.json"
local jsonCopyList= "ui/copy_entrance3.json"

local function removeCrossAct( node )
	node:removeFromParentAndCleanup(true)
end

--进入普通副本动画
function normalCopyAction( imgPath,parent )
	if (parent) then
		actionPrent = parent
	else
		actionPrent = curCopyLayer
	end
	if (actionPrent:getChildByTag(copyTipTag)) then
		actionPrent:getChildByTag(copyTipTag):removeFromParentAndCleanup(true)
	end

	local crossSprite = CCSprite:create(imgPath)
	local posy = g_winSize.height-g_winSize.height*32/100-crossSprite:getContentSize().height/2
	crossSprite:setPosition(ccp(0,posy))
	actionPrent:addNode(crossSprite,100,copyTipTag)

	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.5, ccp(g_winSize.width/2,posy)))
	array:addObject(CCDelayTime:create(1))
	--array:addObject(CCFadeIn:create(1))
	array:addObject(CCFadeOut:create(1))
	array:addObject(CCCallFuncN:create(removeCrossAct))
	local action = CCSequence:create(array)
	crossSprite:runAction(action)
end

-- 切换副本后按钮是否高亮
local function copyBtnFocused()
	--nomalBtn:setFocused(blCopyStyle~=1)
	nomalBtn:setVisible(not(blCopyStyle==1 or blCopyStyle==3))
	nomalBtn:setTouchEnabled(not(blCopyStyle==1 or blCopyStyle==3))

	eliteBtn:setVisible(blCopyStyle==1)
	eliteBtn:setTouchEnabled(blCopyStyle==1) --liweidong 20151123 屏蔽精英副本
	
	awakeBtn:setVisible(blCopyStyle==1) -- or blCopyStyle==2)
	awakeBtn:setTouchEnabled(blCopyStyle==1)-- or blCopyStyle==2)
	--升级面板上出现同一针跳出副本 屏蔽层不能移除问题
	-- LayerManager.addUILayer()
	-- performWithDelayFrame(layoutMain, function()
	-- 		LayerManager.removeUILayer()
	-- 	end,1)
	topCopyTagLayer.BTN_UNION_EXPLAIN:setEnabled(false)
	topCopyTagLayer.BTN_UNION:setEnabled(false)
	performWithDelayFrame(layoutMain, function()
			if (blCopyStyle==1) then
				require "script/module/guild/GuildDataModel"
				require "script/module/guild/GuildUtil"
				if (GuildDataModel.getIsHasInGuild() and GuildUtil.isGuildCopyOpen()) then
					topCopyTagLayer.BTN_UNION:setEnabled(true)
				end
			end
		end,1
		)
	
end

-- 切换副本后按钮是否高亮
local function buttonTagFocus( ... )
	copyBtnFocused()
end

-- 副本标签按钮点击
function onEventClickTag( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()		--切换页签音效

		require "script/module/switch/SwitchModel"
		--isNoramlFocused = (isNoramlFocused and not isNoramlFocused) or not isNoramlFocused
		if (sender==nomalBtn) then
			local layout = Layout:create()
			LayerManager.changeModule(layout,"temp_module_change", {3}, true)
			local layCopy = MainCopy.create()
			if (layCopy) then
				LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
				PlayerPanel.addForCopy()
				MainCopy.updateBGSize()
				MainCopy.setFogLayer()
				normalCopyAction("images/copy/ncopy/into_nor_copy.png")
			end
		end
		if (sender==eliteBtn) then
			if (not SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,true)) then
				return
			end
			local layout = Layout:create()
			LayerManager.changeModule(layout,"temp_module_change", {3}, true)
			local layCopy = MainCopy.create(2,false)
			if (layCopy) then
				LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
				PlayerPanel.addForCopy()
				MainCopy.updateBGSize()
				MainCopy.setFogLayer()
				normalCopyAction("images/copy/ecopy/into_elite_copy.png")
			end
		end
		if (sender==explorBtn) then
			if (not SwitchModel.getSwitchOpenState(ksSwitchExplore,true)) then
				return
			end
			extraToExploreScene()
		end
	end
	
end

-- 副本切换动画
function exchangeCopyLayer()
	if (isNoramlFocused) then
		requestCopyData(mapId)
	else
		requestEliteData()
	end
end

-- 初始加载配置数据
function init( ... )
	--初始化世界数据
	worldinitBase()
	UpdateEliteInfo()
	performWithDelayFrame(layoutMain,function()
			--更新主菜单按钮的小红点
			require "script/module/main/MainScene"
			MainScene.updateCopyTip()
		end,5)
	buttonTagFocus()
end

--[[desc:更新探索次数和探索小红点
    arg1: nil
    return: nil  
—]]
function UpdateExplorInfo()
	
end

--[[desc:更新精英副本小红点
    arg1: nil
    return: nil  
—]]
function UpdateEliteInfo()
	--李卫东  更新精英副本按钮状态
	--精英副本上增加红点，显示剩余次数
	local worldData = DataCache.getEliteCopyData()
	local countImgbg = g_fnGetWidgetByName(eliteBtn, "IMG_TIP_ELITE", "ImageView")
	if (worldData~=nil) then
	    local numCopyAttack = g_fnGetWidgetByName(countImgbg, "LABN_TIP_ELITE")--数字标签
	    numCopyAttack:setStringValue(worldData.can_defeat_num or 3 .. "")
	    if (worldData.can_defeat_num and tonumber(worldData.can_defeat_num)>0) then
	    	countImgbg:setVisible(true)
	    else
	    	countImgbg:setVisible(false)
	    end
    else
		countImgbg:setVisible(false)
	end
end

-- 从副本返回到副本大地图 更新引导
function updateGuideView( ... )
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuidePartnerAdvView"
	if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 8) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createPartnerAdvGuide(9)
		scrollView:setTouchEnabled(false)
	end
	require "script/module/guide/GuideCopyBoxView"
	if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 4) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopyBoxGuide(5)
	end

	require "script/module/guide/GuideCopy2BoxView"
	if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 4) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createCopy2BoxGuide(5)
	end
end


-- 更新当前界面
function updateInit( ... )
	init()
	
	--李卫东 返回世界地址播放
	if (isCrossFirstEntrance()) then  --为了实现第一次进入副本不播放副本背景音乐，直接播放战斗背景音乐
		AudioHelper.playMainMusic()
	end
end

--获取地图中的所有副本
function fnGetWorldCopy( ... )
	local copyidTmp = (isNoramlFocused and mapInfo.normal_id) or mapInfo.elite_id
	local copyArr = lua_string_split(copyidTmp,"|")
	-- --logger:debug("fnGetWorldCopy")
	-- --logger:debug(copyArr)
	return copyArr
end

-- zhangqqi, 20140516, 根据适配需要更新背景地图的size。
-- 只有加载副本模块后更新size才有效，所以提供此方法供外部调用
function updateBGSize( ... )
	local scalenum=g_CopyBgRate1136-->1 and g_CopyBgRate1136 or 1
	if (copyGeneral) then
		local scvGeneral = g_fnGetWidgetByName(copyGeneral, "SCV_MAIN")
		local imgGeneral = g_fnGetWidgetByName(copyGeneral, "IMG_BG1")
		local szOld = scvGeneral:getInnerContainerSize()
		local db = DB_Copy_entrance.getDataById(curCopyBattleId)
		scvGeneral:setInnerContainerSize(CCSizeMake(db.scv_area*scalenum, szOld.height*scalenum)) -- 重新设置滚动区域size
		imgGeneral:setScale(scalenum)
		-- if (tonumber(curPX) > 0) then
		-- 	scvGeneral:jumpToPercentHorizontal(curPX * 100)
		-- end
	end
	if (copyElite) then
		local scvElite= g_fnGetWidgetByName(copyElite, "SCV_MAIN")
		local imgElite = g_fnGetWidgetByName(copyElite, "IMG_BG1")

		local szOld = scvElite:getInnerContainerSize()
		local db = DB_Elitecopy.getDataById(curCopyBattleId)
		scvElite:setInnerContainerSize(CCSizeMake(db.scv_area*scalenum, szOld.height*scalenum)) -- 重新设置滚动区域size
		
		-- scvElite:setInnerContainerSize(CCSizeMake(szOldElite.width*scalenum, szOldElite.height*scalenum)) -- 重新设置滚动区域size

		imgElite:setScale(scalenum)
		local imgMengban = g_fnGetWidgetByName(copyElite, "IMG_MENGBAN")
		-- imgMengban:setAnchorPoint(ccp(0,0.5))
		-- local mengbanSceleX=(g_winSize.width+400)/(imgMengban:getSize().width*scalenum) --(700/(imgMengban:getSize().width*scalenum))
		-- logger:debug({mengbanSceleX = mengbanSceleX})
		-- logger:debug({mengbanwidth=imgMengban:getSize().width})
		imgMengban:setScale(1.5)
	end
	if (copyExplor) then
		local scvExplore= g_fnGetWidgetByName(copyExplor, "SCV_MAIN")
		local imgExplore = g_fnGetWidgetByName(copyExplor, "IMG_BG1")

		local szOldExplore = scvExplore:getInnerContainerSize()
		scvExplore:setInnerContainerSize(CCSizeMake(szOldExplore.width*scalenum, szOldExplore.height*scalenum)) -- 重新设置滚动区域size
		imgExplore:setScale(scalenum)
	end
end

local function fnSetWorldLayer( ... )
	if (mapInfo.world_pic) then
		----logger:debug("images/copy/world/" .. mapInfo.world_pic)
		m_imgWorldBg = g_fnGetWidgetByName(curCopyLayer, "IMG_BG1")
		----logger:debug("m_imgWorldBg " .. m_imgWorldBg:getSize().width .. "heirgg " .. m_imgWorldBg:getSize().height)
		if (mapInfo.world_num) then
			local worldNum = tonumber(mapInfo.world_num)
			-- local itemTagCopy = m_imgWorldBg:getChildByTag(curCopyBattleId)
			-- logger:debug(curCopyBattleId)
			-- logger:debug(itemTagCopy:getPositionX())
			local entceItemData = nil
			if (copyGeneral) then
				entceItemData = DB_Copy_entrance.getDataById(curCopyBattleId)
			end
			if (copyElite) then
				entceItemData = DB_Elitecopy.getDataById(curCopyBattleId)
			end
			local copyPosition = lua_string_split(entceItemData.position,",")


			local scrollx = -copyPosition[1]*g_CopyBgRate1136+400*g_CopyBgRate1136
			if (scrollx>=0) then
				scrollx=0
			end
			if (scrollx<-worldNum*1065*g_CopyBgRate1136+g_winSize.width) then
				scrollx=-worldNum*1065*g_CopyBgRate1136+g_winSize.width
			end
			logger:debug(scrollx)
			for i=1,worldNum do
				local imgBg_ = g_fnGetWidgetByName(m_imgWorldBg, "IMG_BG1_" .. i)
				local texture = CCTextureCache:sharedTextureCache():textureForKey("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")
				if (texture) then
					imgBg_:loadTexture("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")
				else
					if (i*1065*g_CopyBgRate1136<math.abs(scrollx) or (i-1)*1065*g_CopyBgRate1136>math.abs(scrollx)+g_winSize.width) then
						if ((i-1)*1065<entceItemData.scv_area) then --没有超出可滑动区域
							performWithDelayFrame(curCopyLayer, function()
									imgBg_:loadTexture("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")
								end
								, 3)
						end
					else
						imgBg_:loadTexture("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")
						logger:debug("load backgroud" ..i)
						logger:debug(i*1065*g_CopyBgRate1136)
						LayerManager.addCopyLoading()
						performWithDelayFrame(curCopyLayer, function()
								LayerManager.removeCopyLoading()
							end
							, 8)
					end
				end
			end
		end
	end
end

-- 加载地图数据
function worldinitBase( ... )
	
	if (isNoramlFocused) then
		if (blCopyStyle==1) then
			if (copyExplor) then
				copyExplor:removeFromParent()
				copyExplor=nil
			end
			if (copyElite) then
				copyElite:removeFromParent()
				copyElite=nil
			end
			--世界地图滚动层
			TimeUtil.timeStart("loadCopyUI")
			if (copyGeneral==nil) then
				copyGeneral = g_fnLoadUI(jsonMain)
				copyGeneral:setSize(g_winSize)
				layoutMain:addChild(copyGeneral)
			end
			TimeUtil.timeEnd("loadCopyUI")
			curCopyLayer = copyGeneral
		else
			if (copyGeneral) then
				copyGeneral:removeFromParent()
				copyGeneral=nil
			end
			if (copyExplor) then
				copyExplor:removeFromParent()
				copyExplor=nil
			end
			if (copyElite) then
				copyElite:removeFromParent()
				copyElite=nil
			end
			--探索标签
			copyExplor = g_fnLoadUI(jsonExplor)
			layoutMain:addChild(copyExplor)
			copyExplor.BTN_BACK:addTouchEventListener(function( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playBackEffect()
						MainScene.homeCallback()
					end
				end)
			UIHelper.titleShadow(copyExplor.BTN_BACK, gi18n[1019])
			curCopyLayer = copyExplor
		end
		curWorldData = DataCache.getNormalCopyData()
	else
		logger:debug("copyGeneralupdate pos")
		if (copyGeneral) then
			copyGeneral:removeFromParent()
			copyGeneral=nil
		end
		if (copyExplor) then
			copyExplor:removeFromParent()
			copyExplor=nil
		end
		if (copyElite) then
			copyElite:removeFromParent()
			copyElite=nil
		end
		
		--精英副本标签
		copyElite = g_fnLoadUI(jsonElite)
		layoutMain:addChild(copyElite)

		local imgMengban = g_fnGetWidgetByName(copyElite, "IMG_MENGBAN")
		imgMengban:setAnchorPoint(ccp(0.5,0.5))
		local function updateEliteMengban()
			local bgPos = imgMengban:convertToWorldSpace(ccp(0,0))
			if (bgPos.x~=g_winSize.width/2) then
				imgMengban:setPosition(ccp(imgMengban:getPositionX()-bgPos.x+g_winSize.width/2,imgMengban:getPositionY()))
			end
		end
		updateEliteMengban()
		schedule(imgMengban,updateEliteMengban,0.01)
		imgMengban:setVisible(true)

		curCopyLayer = copyElite
		curWorldData = DataCache.getEliteCopyData()
	end

	if (curWorldData ~= nil) then
		mapId = curWorldData.world_id or 20001
		mapInfo = DB_World.getDataById(mapId)

		scrollView = g_fnGetWidgetByName(curCopyLayer, "SCV_MAIN")
		if (scrollView) then
			-- scrollView:setSizeType(1) -- zhangqi, 20140516
			scrollViewLayout = g_fnGetWidgetByName(scrollView, "LAY_SCROLLVIEW", "Layout")
			if (scrollViewLayout and mapInfo~=nil) then
				m_imgWorldBg = g_fnGetWidgetByName(curCopyLayer, "IMG_BG1")
				local isSetFog=true
				if (isNoramlFocused) then
					if (blCopyStyle==1) then
						TimeUtil.timeStart("createCurCopyId")
						setCurCopyid()
						TimeUtil.timeEnd("createCurCopyId")
						TimeUtil.timeStart("createCurCopy")
						setEntranceLayer(curCopyLayer)
						TimeUtil.timeEnd("createCurCopy")
					else
						setExplorEntranceLayer(curCopyLayer)
						isSetFog=false
					end
				else
					setEliteCopyLayerInfo(curCopyLayer)
				end
				TimeUtil.timeStart("createFogTime")
				setFogLayer()
				TimeUtil.timeEnd("createFogTime")
				if (isSetFog) then --不是探索地图  探索地图单独处理
					TimeUtil.timeStart("createMapTime")
					fnSetWorldLayer() --  初始化世界地图n张背景图
					TimeUtil.timeEnd("createMapTime")
				
					setNextWorldLayer() --设置下一个副本相关操作
				end
			end
		end
	end



	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideEliteView"
	if (GuideModel.getGuideClass() == ksGuideEliteCopy and GuideEliteView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createEliteGuide(3)
		----logger:debug("GuideCtrl.createEliteGuide(3)")
		scrollView:setTouchEnabled(false)
	end
end

--------------------------------普通副本相关-----------------------------
--获取当前副本所有据点
local function fnGetCopyBase( copy_id )
	local tbBase = {}
	if(copy_id ~= nil) then
		local copyItemInfo = DB_Copy.getDataById(copy_id)
		for i=1,30 do
			local key = "baseid_"..i
			if (copyItemInfo[key] ~= nil) then
				table.insert(tbBase,copyItemInfo[key])
			end
		end
	end
	return tbBase
end

-- 判断是否打过某个副本的所有据点
local function fnAttackedBase( tbProInfo )
	if (tbProInfo) then
		for k,v in pairs(tbProInfo) do
			--据点简单 v[1]
			if (v[tostring(1)]==nil or v[tostring(1)].status==nil or tonumber(v[tostring(1)].status)<3) then  --状态：0是没有开启  1是能显示  2是能攻击  3是通关
				return false
			end
		end
	end
	return true
end

-- 判断是否完成攻打当前副本
function fngetAttacked( tbCopyInfo )
	-- --logger:debug("==========copy info")
	-- --logger:debug(tbCopyInfo)
	local blsucced = false
	if (tbCopyInfo ~= nil) then
		if (tbCopyInfo.va_copy_info ~=nil) then
			local progressInfo = tbCopyInfo.va_copy_info.baselv_info
			local copyBaseData = fnGetCopyBase(tbCopyInfo.copy_id)
			if (table.count(progressInfo) >= #copyBaseData and fnAttackedBase(progressInfo)) then
				blsucced = true
			end
		end
	end
	return blsucced
end

--[[desc:判读某个副本是否开启
    arg1: 副本id
    return: bool  
—]]
function fnCrossCopy(copyId)
	local itemNetData = fnGetCopyItem(copyId)
	local cross = fngetAttacked(itemNetData)
	return cross
end

--通过入口获取副本列表
local function fnNorCopyByEntance( entranceId )
	local pNum = table.count(DB_Copy_entrance.Copy_entrance) or 0
	local pID = tonumber(entranceId) or 0
	if (pID > 0 and pID <= pNum) then
		local dbEntrance = DB_Copy_entrance.getDataById(entranceId)
		if (dbEntrance.normal_copyid) then
			local copyArr = lua_string_split(dbEntrance.normal_copyid,"|")
			return copyArr
		end
	end
	return nil
end

-- 返回是否正在攻打的副本,如果是则返回下一个copyid
function fngetNowAndWill( tbCopyInfo )
	local blcur = false
	local nextCopyId = nil
	if (tbCopyInfo ~= nil) then
		if (tbCopyInfo.va_copy_info ~=nil) then

			local progressInfo = tbCopyInfo.va_copy_info.baselv_info
			if (progressInfo) then
				for k,v in pairs(progressInfo) do
					if (tonumber(v[tostring(1)].status) >= 2) then --状态：0是没有开启  1是能显示  2是能攻击  3是通关
						blcur = true
					end
				end
			end
			if(blcur and tbCopyInfo.copy_id) then
				local copyArr = fnNorCopyByEntance(curEntranceId)
				for k,v in ipairs(copyArr) do
					if (tonumber(v) == tonumber(tbCopyInfo.copy_id)) then
						nextCopyId = copyArr[k+1]
					end
				end
			end
		end
	end
	return blcur,nextCopyId
end

-- 匹配当前普通副本网络数据
function fnGetCopyItem( vk )
	local curNetData = DataCache.getNormalCopyData().copy_list
	return curNetData[tostring(vk)]
	-- local tbCopyInfo = nil
	-- local curNetData = nil
	-- if (not curWorldData) then
	-- 	if (DataCache.getNormalCopyData()==nil) then
	-- 		return nil
	-- 	end
	-- 	curNetData = DataCache.getNormalCopyData().copy_list
	-- elseif(not curWorldData.copy_list) then
	-- 	curNetData = DataCache.getNormalCopyData().copy_list
	-- else
	-- 	curNetData = curWorldData.copy_list --从网络获取的副本进度
	-- end
	-- ----logger:debug(curNetData)
	-- if (curNetData) then
	-- 	for k,v in pairs(curNetData) do
	-- 		if(v.copy_id) then
	-- 			----logger:debug("vk " .. vk .."v.copy_id " .. v.copy_id)
	-- 			if (tonumber(v.copy_id) == tonumber(vk)) then
	-- 				tbCopyInfo = v
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- ----logger:debug(v)
	-- return tbCopyInfo
end

local closeCopyList = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		UIHelper.closeCallback() -- zhangqi, 加入音效
		listView=false
		copyListLayer=nil
	end
end

----副本列表cell
local function tableCellTouched( sender, eventType )
	local press = g_fnGetWidgetByName(sender, "IMG_PRESS")
	if (eventType == TOUCH_EVENT_BEGAN ) then
		press:setVisible(true)
	else
		press:setVisible(false)
	end

	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playEnterCopy()
		local copyId = sender:getTag()
		toItemCopy(copyId)
	end
end

local function cellAtIndex( tbData, idx)
	local cell = CopyCell:new(m_layCell)
	cell:init(tbData)
	cell:refresh(tbData,idx)
	return cell
end

function loadListView( ... )
	if (loadListView==nil) then
		return
	end
	local imgbg = g_fnGetWidgetByName(copyListLayer,"img_bg")
	local list = g_fnGetWidgetByName(copyListLayer, "LSV_MAIN")
	if (#tbShowCopyData < 3 and #tbShowCopyData > 0) then
		imgbg:setSize(CCSizeMake(imgbg:getSize().width, 660))
		list:setSize(CCSizeMake(list:getSize().width, 500))
	else
		imgbg:setSize(CCSizeMake(imgbg:getSize().width, 910))
		list:setSize(CCSizeMake(list:getSize().width, 741))
	end


	
	UIHelper.initListView(list)

	local nIdx, cell = 0, nil
	for i, item in ipairs(tbShowCopyData) do
		list:pushBackDefaultItem()

    	nIdx = i - 1
    	cell = list:getItem(nIdx)  -- cell 索引从 0 开始

    	local copyName = g_fnGetWidgetByName(cell, "TFD_COPY1_NAME")
    	copyName:setText(item.copyName)
    	UIHelper.labelNewStroke(copyName, ccc3(0x28,0,0),2)
    	if item.passText~=nil then
    		copyName:setColor(ccc3(0xd8,0xd8,0xd8))
    	else
    		copyName:setColor(ccc3(0xFE,0xFF,0xFF))
    	end
    	UIHelper.labelNewStroke( copyName, ccc3(0,0,0), 2 )

    	local wonStar = g_fnGetWidgetByName(cell, "TFD_OWN1")
    	wonStar:setText(item.score)
    	UIHelper.labelNewStroke(wonStar, ccc3(0x4f,0x18,0),2)

    	local xiegang = g_fnGetWidgetByName(cell, "tfd_xiegang1")
    	UIHelper.labelNewStroke(xiegang, ccc3(0x4f,0x18,0),2)

    	local allStar = g_fnGetWidgetByName(cell, "TFD_TOTAL1")
    	allStar:setText(item.all_stars)
    	UIHelper.labelNewStroke(allStar, ccc3(0x4f,0x18,0),2)
    	--box tip
    	local boxtip = g_fnGetWidgetByName(cell, "IMG_BOX")
    	boxtip:setVisible(item.isShowBoxTip)
    	if (item.isShowBoxTip) then
	    	local m_arAni1 = UIHelper.createArmatureNode({
											filePath = "images/effect/box_tip/box_tip.ExportJson",
											animationName = "box_tip",
											bRetain=true
										})
			boxtip:addNode(m_arAni1)
		end

    	local passTip = g_fnGetWidgetByName(cell, "IMG_COPY_PASSED")
    	passTip:setVisible(item.cross==1)
    	
    	local imgBg = g_fnGetWidgetByName(cell, "IMG_COPY1")
    	imgBg:loadTexture(item.normalImg)
    	
    	cell:setTag(item.copyId)
    	cell:setTouchEnabled(true)
    	cell:addTouchEventListener(tableCellTouched)

    	local openBlank = g_fnGetWidgetByName(cell, "LAY_BLACK")
    	openBlank:setVisible(item.passText~=nil)
    	
    	local lockTip = g_fnGetWidgetByName(cell, "IMG_LOCK")
    	lockTip:setVisible(item.passText~=nil)

    	local nameNormal = g_fnGetWidgetByName(cell, "IMG_NAMEBG_NORMAL")
    	-- nameNormal:setVisible(item.passText==nil)

    	-- local nameGray = g_fnGetWidgetByName(cell, "IMG_NAMEBG_GREY")
    	-- nameGray:setVisible(item.passText~=nil)

    	local layStar = g_fnGetWidgetByName(cell, "LAY_STAR1")
    	layStar:setVisible(item.passText==nil)

    	local imgPress = g_fnGetWidgetByName(cell, "IMG_PRESS")
    	imgPress:setVisible(false)

    	local condition = g_fnGetWidgetByName(cell, "TFD_CONDITION")
    	condition:setText(item.passText and item.passText or "")
    	UIHelper.labelNewStroke( condition, ccc3(0x38,0x05,0x0b), 2 )
	end
end

local function initListView()
	loadListView()
end

function upCopyListView( ... )
	getCopyData()
	if(listView) then
		loadListView()
	end
end

function getCopyData( ... )
	tbShowCopyData = {}
	local copyArr = fnNorCopyByEntance(curEntranceId)
	if (copyArr) then
		local curCopyPt = 0
		for k,v in ipairs(copyArr) do
			local itemNetData = fnGetCopyItem(v)
			local blCur,nextCopyid = fngetNowAndWill(itemNetData)
			local cross = fngetAttacked(itemNetData)
			if true then --(cross or (curCopyPt == tonumber(v)) or blCur) then
				local tbKeyData = {}
				local copyItemData = DB_Copy.getDataById(v)
				-- local copyPosition = lua_string_split(copyItemData.position,",") -- zhangqi, 20140627, position字段已弃用
				tbKeyData.copyId = v
				tbKeyData.toucheEvent = toItemCopy
				if (copyItemData.choose_graph) then
					tbKeyData.normalImg = copyNormalPath.."choose_graph/"..copyItemData.choose_graph ..".png"
				end
				tbKeyData.copyName = copyItemData.name
				require "script/module/copy/itemCopy"
				tbKeyData.score = itemNetData and itemNetData.score or 0 --itemCopy.fnGetStarByBaseAndHard(v,1)+itemCopy.fnGetStarByBaseAndHard(v,2) --
				----logger:debug("copy star==++"..tbKeyData.score)
				local stars = lua_string_split(copyItemData.all_stars, "|")
				local totalStart=0
				for _,v in pairs(stars) do
					totalStart=totalStart+v
				end
				tbKeyData.all_stars = totalStart
				  
				if (cross) then
					tbKeyData.cross = 1
				else
					tbKeyData.cross = 0
				end

				local passText = nil
				local lastproData = nil
				local lastCpyId = copyArr[k-1]
				if (lastCpyId) then
					lastproData = fnGetCopyItem(lastCpyId)
				end
				-- if (curWorldData.copy_list[v] == nil) then
				-- 	passText = string.format(gi18n[1302],tostring(fnGetClearance(v))) 
				-- else
				if (lastproData and (not fngetAttacked(lastproData))) then
					-- if(tbKeyData.cross == 0 and lastCpyId) then
					local lastDbItemData = DB_Copy.getDataById(lastCpyId)
					passText = string.format(gi18n[1302],tostring(lastDbItemData.name))
					-- end
				elseif ((not copyIsOpened(v)) and copyItemData.limit_level ~= nil) then
					local levelCopy = tonumber(copyItemData.limit_level)
					if (levelCopy > UserModel.getHeroLevel()) then
						local tmpStr = gi18n[1969]
						passText = string.format(tmpStr,tostring(levelCopy))
					end
				end
				tbKeyData.passText = passText

				--显示入口宝箱tip
				require "script/module/copy/itemCopy"
				local isShowBoxTip = false
				if curWorldData.copy_list[""..v] and itemCopy.isShowCopyRewardBoxTip( curWorldData.copy_list[""..v] ) then
					isShowBoxTip=true
				end
				tbKeyData.isShowBoxTip=isShowBoxTip

				table.insert(tbShowCopyData,tbKeyData)

				--副本是否可点击
				if (blCur) then
					curCopyPt = tonumber(nextCopyid)
				end
			end
		end
	end

	local function sortId( a,b )
		if (b and a) then
			return tonumber(a.copyId) > tonumber(b.copyId)
		end
	end
	--table.sort( tbShowCopyData, sortId )
end

-- 加载普通副本列表
function setCopyListLayer( ... )
	local entItemInfo = DB_Copy_entrance.getDataById(curEntranceId)
	local tfdEntName = g_fnGetWidgetByName(copyListLayer, "IMG_TITLE")
	----logger:debug("copy name img=="..copyNormalPath .. "name_big/".. entItemInfo.name_big..".png")
	tfdEntName:loadTexture(copyNormalPath .. "name_big/".. entItemInfo.name_big..".png")


	local btnClose = g_fnGetWidgetByName(copyListLayer, "BTN_CLOSE")
	btnClose:addTouchEventListener(closeCopyList)
	listView = true
	initListView()
end

-- 获取普通副本通关条件
function fnGetClearance( copy_id )
	local copyItemData = DB_Copy.getDataById(copy_id)
	local baseItemInfo = DB_Stronghold.getDataById(copyItemData.pre_baseid)
	local copyData = DB_Copy.getDataById(baseItemInfo.copy_id)
	return copyData.name
end

--判断一个副本（不是入口）是否已经开启
function copyIsOpened(copyId)
	local strTag = tostring(copyId)
	local curWorldData = DataCache.getNormalCopyData()
	if (curWorldData and curWorldData.copy_list) then
		if (curWorldData.copy_list[strTag] ~= nil) then
			return true
		end
	end
	return false
end
--生成新副本数据 开启新副本，前端自己生成一份数据
--原因：在其他地方升级开启新副本时没有拉去最新开启副本数据
--如果升级时拉取的话，在副本中升级先拉取了数据，利用老数据的一些判断就会错误，会引起更大问题
function createNewCopyData(copyId)
	copyId = tostring(copyId)
	local copyList = DataCache.getNormalCopyData().copy_list
	if (copyList[copyId]~=nil) then
		return
	end
	local db = DB_Copy.getDataById(copyId)
	copyList[copyId]={
		va_copy_info = {
			baselv_info = {
				[tostring(db.baseid_1)] = {
					["1"] = {
						status = "2"
						}
					}
				}
			},
		copy_id = "8",
		uid = "146770",
		last_rfr_time = "1454039450.000000",
		score = "0",
	}
end
-- 单个普通副本点击
function toItemCopy( tagCopyId,difficult,backFun)
	logger:debug("toItemCopy")
	local copyArr = fnNorCopyByEntance(curEntranceId)
	local passText = nil
	local lastproData = nil
	local lastCpyId = tagCopyId-1>0 and tostring(tagCopyId-1) or nil
	if (lastCpyId) then
		lastproData = fnGetCopyItem(lastCpyId)
	end

	local strTag = tostring(tagCopyId)
	local copyItemInfo = DB_Copy.getDataById(strTag)
	local curWorldData = DataCache.getNormalCopyData()

	-- if (curWorldData.copy_list[strTag] == nil) then
	-- 	passText = string.format(gi18n[1302],tostring(fnGetClearance(strTag))) 
	-- else
	logger:debug({lastproData = lastproData})
	logger:debug({fngetAttackedlastproData = fngetAttacked(lastproData)})
	logger:debug({curWorldData = curWorldData})
	if (lastproData and (not fngetAttacked(lastproData))) then
		logger:debug("string.format(gi18n[1302],tostrin")
		-- if(lastCpyId) then
		local lastDbItemData = DB_Copy.getDataById(lastCpyId)
		passText = string.format(gi18n[1302],tostring(lastDbItemData.name))
		-- end
	elseif ((not copyIsOpened(strTag)) and copyItemInfo.limit_level ~= nil) then
		local levelCopy = tonumber(copyItemInfo.limit_level)
		if (levelCopy > UserModel.getHeroLevel()) then
			local tmpStr = gi18n[1969]
			passText = string.format(tmpStr,tostring(levelCopy))
		end
	end
	if (passText) then
		ShowNotice.showShellInfo(passText)
		return
	end
	-- if (not copyIsOpened(strTag)) then
	-- 	if (copyItemInfo.limit_level ~= nil) then
	-- 		local levelCopy = tonumber(copyItemInfo.limit_level)
	-- 		if (levelCopy > UserModel.getHeroLevel()) then
	-- 			local tmpStr=gi18n[1970]
	-- 			ShowNotice.showShellInfo(string.format(tmpStr,tostring(levelCopy)))
	-- 			return
	-- 		end
	-- 	end
	-- end
	createNewCopyData(strTag)
	if (curWorldData and curWorldData.copy_list) then
		if true then --(curWorldData.copy_list[strTag] ~= nil) then
			if (layoutMain) then
				scrolloffset=scrollView:getJumpOffset()
			end
			require "script/module/copy/itemCopy"
			local layout = itemCopy.create(tagCopyId,curWorldData.copy_list[strTag],difficult,backFun)
			layout:setName(g_HolderLayout)
			if (layout) then
				if (isInMap()) then
					-- logger:debug("main copy in map")
					LayerManager.addLayoutNoScale(layout)
				else
					if (type(backFun)=="function") then
						LayerManager.addLayoutNoScale(layout)
                    	LayerManager.setCurModuleName("MainCopy")
					else
						logger:debug("{curWorldData=curWorldData}11")
						local tmpLayout = Layout:create()
						LayerManager.changeModule(tmpLayout,moduleName(), {}, true)
						LayerManager.addLayoutNoScale(layout)
					end
					-- LayerManager.changeModule(layout, moduleName(), {}, true)
				end
				itemCopy.initScrollView()
				itemCopy.fnShowDialog()
			end
		else
			logger:debug("ShowNotice.showShellInfo")
			ShowNotice.showShellInfo(string.format(gi18n[1302],tostring(fnGetClearance(strTag))))
		end
	end
end
--还原滚动层位置
function resetScrollOffset()
	if (scrolloffset==nil) then
		return
	end
	scrollView:setJumpOffset(scrolloffset)
end
--设置当前滚动层位置
function setScrollOffset()
	scrolloffset=scrollView:getJumpOffset()
end

--------------------------------新加入口相关----------------------
--获取地图中的所有入口
function fnGetWorldEntrance( ... )
	local copyidTmp = (isNoramlFocused and mapInfo.entrance) or mapInfo.elite_id
	local copyArr = lua_string_split(copyidTmp,"|")
	return copyArr
end

--通关入口id获取当前入口对应的副本星数
local function fngetEntranceScore( entId )
	local curNetData = DataCache.getNormalCopyData().copy_list
	if (curNetData) then
		local curScore = 0
		local dbCopyTemp = DB_Copy_entrance.getDataById(entId)
		if (dbCopyTemp.normal_copyid) then
			local noramlArr = lua_string_split(dbCopyTemp.normal_copyid,"|")
			for k,v in pairs(curNetData) do
				for _,dbv in ipairs(noramlArr) do
					if (tonumber(v.copy_id) == tonumber(dbv)) then
						curScore = curScore + tonumber(v.score)
						break
					end
				end
			end
		end
		return curScore,dbCopyTemp.star_total
	end
end

--通过判断入口所有据点已通关判断是否通关此入口
function getCrossEntrance( entId )
	-- logger:debug("wm----entId : " .. tostring(entId))
	local nCross = true
	local copyArr = fnNorCopyByEntance(entId)
	if (copyArr) then
		for k,v in ipairs(copyArr) do
			----logger:debug(copyArr)
			local curNetData = DataCache.getNormalCopyData().copy_list
			if (type(curNetData[tostring(v+1)])~="table") then
				local itemNetData = fnGetCopyItem(v)
				local cross = fngetAttacked(itemNetData)
				if (not cross) then
					-- nCross = false
					return false
				end
			end
		end
	else
		nCross = false
	end
	return nCross
end

--[[desc:liweidong 判断副本第一关的第一个据点是否已经打过
    arg1: nil
    return: true打过 or false没打过
—]]
function isCrossFirstEntrance()
	return UserModel.getHeroLevel()>1
	-- local tbCopyInfo=fnGetCopyItem(1)
	-- local blsucced = false
	-- if (tbCopyInfo ~= nil) then
	-- 	if (tbCopyInfo.va_copy_info ~=nil) then
	-- 		local progressInfo = tbCopyInfo.va_copy_info.baselv_info
	-- 		if (progressInfo["1001"][tostring(1)].status and tonumber(progressInfo["1001"][tostring(1)].status)>=3) then
	-- 			blsucced= true
	-- 		end
	-- 	end
	-- end
	-- return blsucced
end

--[[desc:liweidong 副本入口跳动
    arg1: node 跳动对象
    return: nil  
—]]
local runBeatAction=nil
runBeatAction= function(node)
	local actions = CCArray:create()
	actions:addObject(CCScaleTo:create(0.75, 1.0))
	actions:addObject(CCScaleTo:create(0.75, 1.03))
	--actions:addObject(CCDelayTime:create(1.5))
	node:runAction(CCRepeatForever:create(CCSequence:create(actions)))
end
--获得当前攻打副本
function setCurCopyid()
	local copyArr = fnGetWorldEntrance()
	local curCopyPt = 0
	for k,v in pairs(copyArr) do
		-- local itemNetData = fnGetCopyItem(v)
		local curCopyItemName = nil --当前可攻打副本名称图标
		-- TimeUtil.timeStart("getCrossEntrance"..v)
		local cross = getCrossEntrance(v)
		-- TimeUtil.timeEnd("getCrossEntrance"..v)
		if (cross) then
			curCopyPt = curCopyPt + 1
		end
		--是否当前入口
		if (curCopyPt + 1 == tonumber(k) or cross) then
			curCopyBattleId = v
			curCopyFlogId=v
		end
	end
end
-- 加载入口信息
function setEntranceLayer(copyLayer)
	local imgMainBg_= g_fnGetWidgetByName(copyLayer, "IMG_BG1")
	local itemCopyLayer1 = g_fnGetWidgetByName(copyLayer, "LAY_COPY", "Layout")
	itemCopyLayer1:setVisible(false)
	local copyArr = fnGetWorldEntrance()
	local curCopyPt = 0
	local lastEntranceId = 0
	curScrolInerWidth=0

	-- local entceItemData = DB_Copy_entrance.getDataById(curCopyBattleId)
	-- local copyPosition = lua_string_split(entceItemData.position,",")
	-- local scrollx = -copyPosition[1]*g_CopyBgRate1136+400*g_CopyBgRate1136

	for k,v in ipairs(copyArr) do
		-- local itemNetData = fnGetCopyItem(v)
		TimeUtil.timeStart("createOneCopy"..v)
		local curCopyItemName = nil --当前可攻打副本名称图标
		local cross = getCrossEntrance(v)
		if (cross) then
			curCopyPt = curCopyPt + 1
		end
		----logger:debug("current copy id" ..curCopyPt)
		if(cross or (curCopyPt+1 == tonumber(k)) or (curCopyPt+4 >= tonumber(k))) then
			logger:debug("enter copy enter inf"..v)
			local lastEntranceIdUse=lastEntranceId

			local function createCopyInfo(delayFrame)
				TimeUtil.timeStart("createItemInfo"..v)
				logger:debug("enter copy enter111 inf"..v)
				local imgMainBg_= g_fnGetWidgetByName(copyLayer, "IMG_BG1")
				local itemCopyLayer = g_fnGetWidgetByName(copyLayer, "LAY_COPY", "Layout")
				itemCopyLayer:setVisible(false)

				local entceItemData = DB_Copy_entrance.getDataById(v)
				local copyPosition = lua_string_split(entceItemData.position,",")

				local itemCopy_ = itemCopyLayer:clone()
				itemCopy_:setVisible(true)
				itemCopy_:setTag(entceItemData.id)
				-- zhangqi, 20140516, 副本入口配置坐标乘以缩放比率，并以背景图为父节点，才能符合适配需求
				local size = m_imgWorldBg:getSize()
				local pst = ccp(copyPosition[1]/size.width, copyPosition[2]/size.height)
				itemCopy_:setPositionPercent(pst)
				logger:debug("item pos:" .. pst.x .. ":" .. pst.y .. " id:" .. v .. " _" .. entceItemData.id)
				-- itemCopy_:setPositionPercent(g_GetPercentPosition(m_imgWorldBg,copyPosition[1], copyPosition[2]))
				if(imgMainBg_:getChildByTag(entceItemData.id) ~= nil) then
					logger:debug("remove item buy id " .. entceItemData.id .. ":" .. v)
					imgMainBg_:removeChildByTag(entceItemData.id,true)
				end

				if (v%100==16 or v%100==20) then
					logger:debug("radd item   11")
					imgMainBg_:addChild(itemCopy_,21)
				else
					imgMainBg_:addChild(itemCopy_,20)
					logger:debug("add item  10")
				end
				local itemCopyBtn = g_fnGetWidgetByName(itemCopy_, "BTN_COPY1", "Button")
				--副本名称背景
				local itemCopyImg_ = g_fnGetWidgetByName(itemCopy_, "IMG_CPNAME_SAMPLE")
				if (itemCopyBtn) then
					-- itemCopyBtn:setScale(g_fScaleX)
					itemCopyBtn:setTag(entceItemData.id)
					itemCopyBtn:addTouchEventListener(toEntranceItem)
					if (curCopyPt+2 <= tonumber(k)) then
						itemCopyBtn:loadTextureNormal(copyEntrancePath.."disableImg/copy_a_"..entceItemData.picture)
						itemCopyBtn:loadTexturePressed(copyEntrancePath.."disableImg/copy_a_"..entceItemData.picture)
						itemCopyImg_:loadTexture(copyNormalPath .. "worldnameimage/copy_name_a_bg.png")
					else
						itemCopyBtn:loadTextureNormal(copyEntrancePath.."normalImg/copy_n_"..entceItemData.picture)
						performWithDelayFrame(curCopyLayer, function()
								itemCopyBtn:loadTexturePressed(copyEntrancePath.."selectedImg/copy_h_"..entceItemData.picture)
							end,
							delayFrame)
						if (curCopyPt+1 == tonumber(k)) or (curCopyPt==#copyArr and tonumber(k)==#copyArr) then
							runBeatAction(itemCopyBtn)
							fnShowCopyShip(v,1)
							itemCopyImg_:loadTexture("images/copy/light_ncopy.png")
							curCopyItemName=itemCopyImg_
							curScrolInerWidth=entceItemData.scv_area
						end
					end
				end

				--副本名称图片和坐标
				local itemCopyTBg = g_fnGetWidgetByName(itemCopyImg_, "IMG_CPNAME_SAMPLE")
				itemCopyTBg:setPositionType(POSITION_ABSOLUTE)
				local pos = lua_string_split(entceItemData.name_position,",")
				itemCopyTBg:setPosition(ccp(tonumber(pos[1]),tonumber(pos[2])))

				local itemCopyTitle_ = g_fnGetWidgetByName(itemCopyImg_, "IMG_COPY_NAME")
				itemCopyTitle_:loadTexture(copyNormalPath .. "worldnameimage/".. entceItemData.name)
				if (curCopyItemName) then
					performWithDelayFrame(curCopyLayer, function()
						setCurNameEffect(curCopyItemName,1) --当前副本特效
					end,1)
				end
				--副本星数
				local score = fngetEntranceScore(v)
				local itemCurStar_ = g_fnGetWidgetByName(itemCopy_, "LABN_STAR_OWN")
				itemCurStar_:setStringValue(score)

				local itemCopyStar_ = g_fnGetWidgetByName(itemCopy_, "LABN_STAR_TOTAL")
				itemCopyStar_:setStringValue(entceItemData.star_total)
				TimeUtil.timeEnd("createItemInfo"..v)
				TimeUtil.timeStart("createItemLine"..v)
				--显示路线
				if (tonumber(lastEntranceIdUse) ~= 0) then
					fnLineToEntrance(lastEntranceIdUse,entceItemData.id)
				end
				local boxTip = g_fnGetWidgetByName(itemCopy_, "IMG_BOX_TIP")
				boxTip:setVisible(false)
				if (not(curCopyPt+2 <= tonumber(k))) then
					performWithDelayFrame(curCopyLayer, function()
							TimeUtil.timeStart("createItemBoxTip"..k)
							--显示入口宝箱tip
							local enterCopyIds=fnNorCopyByEntance(v)
							local isShowBoxTip = false
							for _,val in pairs(enterCopyIds) do
								if (curCopyPt+2 ~= tonumber(k)) and curWorldData.copy_list[""..val] and itemCopy.isShowCopyRewardBoxTip( curWorldData.copy_list[""..val] ) then
									isShowBoxTip=true
									break
								end
							end
							if (isShowBoxTip) then
								local m_arAni1 = UIHelper.createArmatureNode({
										filePath = "images/effect/box_tip/box_tip.ExportJson",
										animationName = "box_tip",
										bRetain=true
									})
								boxTip:removeAllChildrenWithCleanup(true)
								boxTip:addNode(m_arAni1)
							end
							boxTip:setVisible(isShowBoxTip)
							TimeUtil.timeEnd("createItemBoxTip"..k)
						end,
						delayFrame)
				end
				TimeUtil.timeEnd("createItemLine"..v)
			end
			if (v+4<tonumber(curCopyBattleId)) then
				performWithDelayFrame(curCopyLayer, function()
						createCopyInfo(3)
						logger:debug("delay create copy info ======")
					end,
					2)
			else
				createCopyInfo(5)
			end

			local entceItemData = DB_Copy_entrance.getDataById(v)
			lastEntranceId = entceItemData.id
		else
			break
		end
		TimeUtil.timeEnd("createOneCopy"..v)
	end
end


--获取db所有id
function getNormalCopyDbIds()
	require "db/DB_Copy"
	local ids = {}
	-- for keys,val in pairs(DB_Copy.Copy) do
	-- 	local keyArr = lua_string_split(keys, "_")
	-- 	ids[#ids+1]=tonumber(keyArr[2])
	-- 	--table.insert(ids,tonumber(keyArr[2]))
	-- end
	for i=1,table.count(DB_Copy.Copy) do
		table.insert(ids,i)
	end
	return ids
end
-- 加载入口信息
function setExplorEntranceLayer(copyLayer)
	local imgMainBg_= g_fnGetWidgetByName(copyLayer, "LAY_SCROLLVIEW")
	-- local itemCopyLayer = g_fnGetWidgetByName(copyLayer, "LAY_COPY", "Layout")
	-- itemCopyLayer:setVisible(false)
	local copyArr = getNormalCopyDbIds()
	logger:debug("explore copy num:")
	logger:debug(copyArr)
	local curCopyPt = 0
	local lastEntranceId = 0
	local curCopyBtn = nil
	local curCopyNameImg = nil
	curCopyBattleId=1
	local grayBaseNum = 3 --读配置

	local exploreBtns={}
	for i=1,15 do
		local itemCopyBtn = g_fnGetWidgetByName(imgMainBg_, "BTN_"..i)
		if itemCopyBtn and itemCopyBtn.setVisible then
			itemCopyBtn:setVisible(false)
			exploreBtns[i]=itemCopyBtn
		end
	end
	local function parentClick( sender, eventType )
		local bFocus = sender:isFocused()
		local exploreNameBtn = g_fnGetWidgetByName(sender, "BTN_MAP")
		exploreNameBtn:setFocused(bFocus)
		if (eventType == TOUCH_EVENT_ENDED) then
			toEntranceExplor(sender,eventType)
		end

	end
	local function childrenClick( sender, eventType )
		local bFocus = sender:isFocused()
		sender:getParent():setFocused(bFocus)
		if (eventType == TOUCH_EVENT_ENDED) then
			toEntranceExplor(sender,eventType)
		end
	end
	local canExploreKey=0 --记录可探索副本数
	curScrolInerWidth=0
	for k,copyV in ipairs(copyArr) do
		-- local itemNetData = fnGetCopyItem(v)
		local cross = fnCrossCopy(copyV)
		local copeInfoData=DB_Copy.getDataById(copyV)
		local canExplorStatus = copeInfoData.is_exploration==1 and true or false
		if canExplorStatus then
			canExploreKey=canExploreKey+1
		end
		if (cross and canExplorStatus) then
			curCopyPt = curCopyPt + 1
			canExploreNum = curCopyPt
		end
		if (cross or (curCopyPt+grayBaseNum >= canExploreKey)) and canExplorStatus then
			
			logger:debug(k)
			logger:debug(canExploreKey)
			logger:debug(copyV)
			local exploreBtn=exploreBtns[canExploreKey]
			exploreBtn:setVisible(true)
			exploreBtn:setTag(copyV)
			local exploreNameBtn = g_fnGetWidgetByName(exploreBtn, "BTN_MAP")
			exploreNameBtn:setTag(copyV)
			
			exploreNameBtn:loadTextureNormal("images/explore/explorname/copy".. canExploreKey.."_1"..".png")
			exploreBtn:addTouchEventListener(parentClick)
			exploreNameBtn:addTouchEventListener(childrenClick)
			
			if (curCopyPt < canExploreKey) then
				exploreNameBtn:loadTextureDisabled("images/explore/explorname/copy".. canExploreKey.."_3"..".png")
				exploreNameBtn:setBright(false)
				exploreBtn:setBright(false)
			else
				local tmpExploreKey = canExploreKey
				performWithDelayFrame(imgMainBg_,function()
						exploreNameBtn:loadTexturePressed("images/explore/explorname/copy".. tmpExploreKey.."_2"..".png")
					end,k)
			end
			--是否当前入口
			if (curCopyPt == canExploreKey) then
				curCopyFlogId = copyV
				curCopyBattleId=copyV
				curScrolInerWidth=0
			end
			--lastEntranceId = copyV
		end

	end
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideExploreView"
	if (GuideModel.getGuideClass() == ksGuideExplore and GuideExploreView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createExploreGuide(3)
		scrollView:setTouchEnabled(false)
	end


	if (curCopyBtn) then
		setCurNameEffect(curCopyNameImg)
		runBeatAction(curCopyBtn)
		fnShowCopyShip(curCopyBattleId,1)
	end
end

--判断上一个入口是否通关
local function fnCrossEnceLast( entId )
	local entItemInfo = DB_Copy_entrance.getDataById(entId)
	if (entItemInfo.world_id) then
		local worldEnt = DB_World.getDataById(entItemInfo.world_id)
		if(worldEnt.entrance) then
			local lastEntId = 0
			local noramlArr = lua_string_split(worldEnt.entrance,"|")
			for _,v in ipairs(noramlArr) do
				if (tonumber(v) == tonumber(entId)) then
					break
				else
					lastEntId = tonumber(v)
				end
			end
			if (lastEntId == 0 or getCrossEntrance(lastEntId)) then
				return true
			else
				local lastEntItemInfo = DB_Copy_entrance.getDataById(lastEntId)
				local lastCopyIds= lua_string_split(lastEntItemInfo.normal_copyid,"|")
				local entInfoName=DB_Copy.getDataById(tonumber(lastCopyIds[#lastCopyIds]))
				return false,entInfoName.name  --liweidong 应该是entInfo.name 一个入口可能对应多个副本
			end
		end
	end
end

-- 跳转到单个入口进入副本列表
local function toCopyListOrItem( entranceId )
	require "script/module/guide/GuideEquipView"
	if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 11) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.removeGuide()
	end
    GuideCtrl.removeGuideView()

	local cross,entName = fnCrossEnceLast(entranceId)
	--local cross = getCrossEntrance(entranceId)
	if (cross) then
		curEntranceId = entranceId
		getCopyData()
		if (#tbShowCopyData == 1) then
			--LayerManager.removeLayout()
			--一个入口一个副本情况
			toItemCopy(tbShowCopyData[1].copyId)
		else
			--一个入口多个副本情况
			copyListLayer = g_fnLoadUI(jsonCopyList)
			LayerManager.addLayout(copyListLayer)
			setCopyListLayer()
		end
	else
		ShowNotice.showShellInfo(string.format(gi18n[1302],entName))
	end
end

-- 单个入口点击
function toEntranceItem( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		----logger:debug("play enter copy =============")
		AudioHelper.playEnterCopy() --进入副本音效  
		local strTag = tostring(sender:getTag())
		toCopyListOrItem(strTag)
	end
end

--点击探索入口
function toEntranceExplor( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playEnterCopy() --进入副本音效  
		-- local entranceId = sender:getTag()
		-- ----logger:debug("explor id==" .. entranceId)
		-- local cross = getCrossEntrance(entranceId)
		
		-- local entceItemData = DB_Copy_entrance.getDataById(entranceId)

		-- local copyArr = lua_string_split(entceItemData.normal_copyid,"|")
		-- local copyV = copyArr[#copyArr]

		local copyV=sender:getTag()
		logger:debug("click expore copy id:" ..copyV)
		local cross = fnCrossCopy(copyV)

		local copeInfoData=DB_Copy.getDataById(copyV)
		local canExplorStatus = copeInfoData.is_exploration==1 and true or false

		-- if (cross) then
			
			if (canExplorStatus) then
				ExplorData.initExplore(entranceId)
		    	--进入探索
				----logger:debug("enter explor id==" .. entranceId)
				local explorlayer=ExplorEntCtrl.create(copyV)
				explorlayer:setName("Enter_Explor_layout")
				LayerManager.addLayoutNoScale(explorlayer) 
				
			else
				ShowNotice.showShellInfo(gi18n[1971])
			end
		-- else
		-- 	if (canExplorStatus) then
		-- 		local tmpStr=gi18n[1972]
		-- 		ShowNotice.showShellInfo(string.format(tmpStr,copeInfoData.name,copeInfoData.name))
		-- 	else
		-- 		ShowNotice.showShellInfo(gi18n[1971])
		-- 	end
		-- end
	end
end
--[[desc:liweidong 显示当前副本小船
    arg1: id 副本id copyType 副本类型 1普通 2精英
    return: nil  
—]]
function fnShowCopyShip(id,copyType)
	local copyData = copyType==1 and DB_Copy_entrance.getDataById(id) or DB_Elitecopy.getDataById(id)
	if (copyData.ship_position ~= nil) then
		local pointArr=lua_string_split(copyData.ship_position,",")

		--获取主船形象id
		m_imgWorldBg:removeNodeByTag(m_minShipTag)
		local home_graph  = UIHelper.getHomeShipID()
		local ship = CCSprite:create("images/ship/ship_tiny/ship" .. home_graph .. ".png")
		ship:setTag(m_minShipTag)
		ship:setPosition(ccp(tonumber(pointArr[1]),tonumber(pointArr[2])))
		m_imgWorldBg:addNode(ship,12)
		--runBeatAction(ship)
	end
end
--副本之间的连线显示
function fnLineToEntrance( from,to)
	----[[
	if (from and to) then
		from=from%100
		to=to%100
		local lineImg = "line_" .. from .. "_" .. to .. ".png"
		local entanceFrom =  DB_Copy_entrance.getDataById(from) 
		local entanceTo = DB_Copy_entrance.getDataById(to) 
		if (entanceFrom.point_position ~= nil and entanceTo.point_position~= nil) then
			local posFromArr = lua_string_split(entanceFrom.point_position,",")
			local posToArr = lua_string_split(entanceTo.point_position,",")
			local posLineToArr = lua_string_split(entanceTo.line_position,",")

			if (#posFromArr == 2 and #posToArr == 2 and #posLineToArr == 2) then
				
				--起始点入口图标
				local tagFrom = copyStartTag+tonumber(from)
				if (m_imgWorldBg:getNodeByTag(tagFrom)) then
					logger:debug("remove line by tag " ..tagFrom)
					-- m_imgWorldBg:removeNodeByTag(tagFrom)
				else
					local pointLine = CCSprite:create(copyEntLinePath.."line_point_h.png")
					pointLine:setTag(tagFrom)
					pointLine:setPosition(ccp(tonumber(posFromArr[1]),tonumber(posFromArr[2])))
					m_imgWorldBg:addNode(pointLine,9)
				end

				--结束点入口图标
				local tagTo = copyStartTag+tonumber(to)
				if (m_imgWorldBg:getNodeByTag(tagTo)) then
					logger:debug("remove line by tag " ..tagTo)
					--curCopyLayer:getChildByTag(tagTo):runAction(CCMoveBy:create(0.1,ccp(10,10)))
					--m_imgWorldBg:getNodeByTag(tagTo):removeFromParentAndCleanup(true)
					-- m_imgWorldBg:removeNodeByTag(tagTo)
				else
					local endPointImg = copyEntLinePath.."line_point_a.png"
					if (curCopyBattleId%100>=to) then
						endPointImg = copyEntLinePath.."line_point_h.png"
						-- tagTo = tagTo+99999
					end
					local pointLineTo = CCSprite:create(endPointImg)
					pointLineTo:setTag(tagTo)
					pointLineTo:setPosition(ccp(tonumber(posToArr[1]),tonumber(posToArr[2])))
					m_imgWorldBg:addNode(pointLineTo,9)
				end

				--画链接线
				local tagLine=copyStartTag+tonumber(to)+1000
				
				if (m_imgWorldBg:getNodeByTag(tagLine)) then
					logger:debug("remove line by tag " ..tagLine)
					--curCopyLayer:getChildByTag(tagTo):runAction(CCMoveBy:create(0.1,ccp(10,10)))
					--m_imgWorldBg:getNodeByTag(tagLine):removeFromParentAndCleanup(true)
					-- m_imgWorldBg:removeNodeByTag(tagLine)
				else
					local lineSprite = CCSprite:create(copyEntLinePath..lineImg)
					lineSprite:setTag(tagLine)
					local xPos = tonumber(posLineToArr[1])
					local yPos = tonumber(posLineToArr[2])
					lineSprite:setPosition(ccp(xPos,yPos))
					m_imgWorldBg:addNode(lineSprite,8)
				end

			end

		end
	end
	----]]
end
--------------------------------精英副本相关-----------------------------
-- 获取精英副本通关条件
function fnGetEliteClearance( copy_id )
	local copyItemData = DB_Copy.getDataById(copy_id)
	if (copyItemData) then
		----logger:debug("copy_id " .. copy_id)
		local copyItemInfo = fnGetCopyItem(copy_id)
		if (copyItemInfo == nil) then
			return copyItemData.name
		end
		if (fnAttackedBase(copyItemInfo.va_copy_info.baselv_info)) then
			local tbElite = DB_Elitecopy.getArrDataByField("next_eliteid",copyItemData.next_eliteid)
			if (tbElite[1]) then
				return tbElite[1].name
			end
		else
			return copyItemData.name
		end
	end
	return nil
end

-- 匹配当前精英副本网络数据，是否可显示/点击,-1为不可显示,0为可显示，1为可攻击，2为已通关
local function fnGetEliteCopyItem( vk )
	local numCopyClick = -1
	if (curWorldData.va_copy_info) then
		local progress = curWorldData.va_copy_info.progress
		if (progress and table.count(progress) > 0) then
			for k,v in pairs(progress) do
				local vInt = tonumber(v)
				local kInt = tonumber(k)
				if (kInt == tonumber(vk)) then
					numCopyClick = vInt
				end
			end
		else
			local copyArr = fnGetWorldCopy()
			if (copyArr) then
				if (tonumber(copyArr[1]) == tonumber(vk)) then
					numCopyClick = 0
				end
			end
		end
	else
		local copyArr = fnGetWorldCopy()
		if (copyArr) then
			if (tonumber(copyArr[1]) == tonumber(vk)) then
				numCopyClick = 0
			end
		end
	end
	return numCopyClick
end

--判断是否开启该精英副本 1为未通关普通副本，2为未打过上一个精英副本
function fnOpenCurElite( eliteId )
	local copyItemData = DB_Elitecopy.getDataById(eliteId)
	local itemNetData = fnGetCopyItem(copyItemData.pre_copyid)

	local lastElite = nil
	local copyArr = fnGetWorldCopy()
	for k,v in ipairs(copyArr) do
		if (tonumber(v) == tonumber(eliteId)) then
			break
		else
			lastElite = v
		end
	end
	if(not fngetAttacked(itemNetData)) then --通关普通副本
		return 1
	elseif(fnGetEliteCopyItem(lastElite) ~= 2) then --通关上一个精英副本
		return 2
	end
end

local function toEliteCopy( copyId )
	if (curWorldData.can_defeat_num) then
		if (tonumber(curWorldData.can_defeat_num) <= 0) then
			ShowNotice.showShellInfo(gi18n[1973])
			return
		end
	end

	local numAttack = fnGetEliteCopyItem(copyId)
	if (numAttack > 0) then
		require "script/module/copy/battleEliteMonster"
		local layout = battleEliteMonster.create(copyId)
		LayerManager.addLayout(layout)
	else
		local eliteData = DB_Elitecopy.getDataById(copyId)
		local status = fnOpenCurElite(copyId)
		----logger:debug("status" .. status)
		if (status == 1 or status == 2) then
			local norCopyName = fnGetEliteClearance(eliteData.pre_copyid)
			if (norCopyName) then
				ShowNotice.showShellInfo(string.format(gi18n[1302], norCopyName))
			else
				ShowNotice.showShellInfo(gi18n[1974])
			end
		end
	end
end
-- 单个精英副本点击
local function onEliteCopy( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playEnterCopy() --进入副本音效
		--onEliteCopy
		local strTag = sender:getTag()
		----logger:debug("strTag:" .. strTag)
		toEliteCopy(strTag)
	end
end

--通关普通副本后，判断开启下一个精英副本,普通副本id
function openCopyToElite( copyId )
	local copyData = DB_Copy.getDataById(copyId)
	if (copyData.next_eliteid) then
		local status = fnOpenCurElite(copyData.next_eliteid)
		local numAttack = fnGetEliteCopyItem(copyData.next_eliteid)
		if (numAttack ~= 2) then
			if(status == 1 or status == 2) then
				DataCache.openCurEliteData(copyData.next_eliteid,0)
			else
				DataCache.openCurEliteData(copyData.next_eliteid,1)
			end
		end
	end
end

--打过当前精英本，开启下一个精英副本,eliteId为当前副本id
function eliteOpenData( eliteId )
	local copyItemData = DB_Elitecopy.getDataById(eliteId)
	if (copyItemData.next_eliteid==nil) then
		return
	end
	local attackStatus = fnGetEliteCopyItem(copyItemData.next_eliteid)
	logger:debug("on elite battle win ")
	logger:debug(copyItemData.next_eliteid)
	logger:debug(attackStatus)
	if(attackStatus ~= 2) then --通关精英副本
		local copyItem2 = DB_Elitecopy.getDataById(copyItemData.next_eliteid)
		local itemNetData = fnGetCopyItem(copyItem2.pre_copyid)
		if(fngetAttacked(itemNetData)) then --通关普通副本
			DataCache.updateEliteData(eliteId,copyItemData.next_eliteid,2,1) --可打
			if (copyItem2.next_eliteid) then
				DataCache.openCurEliteData(copyItem2.next_eliteid,0) --下一个副本可显
			end
		else
			DataCache.updateEliteData(eliteId,copyItemData.next_eliteid,2,0) --可显
		end
	end
end
-- 加载精英副本信息
function setEliteCopyLayerInfo(copyLayer)
	local imgMainBg_= g_fnGetWidgetByName(copyLayer, "IMG_BG1")
	--剩余次数
	local numCopyAttack = g_fnGetWidgetByName(copyLayer, "TFD_TIMES_NUM")
	numCopyAttack:setText(curWorldData.can_defeat_num or 3 .. "")
	local itemCopyLayer = g_fnGetWidgetByName(copyLayer, "LAY_COPY")
	itemCopyLayer:setVisible(false)
	local copyArr = fnGetWorldCopy()
	----logger:debug("curWorldData")
	----logger:debug(curWorldData)
	curCopyBattleId = 200001
	local lastEntranceId = 0
	local curCopyBtn = nil
	local curCopyNameImg = nil
	for k,v in ipairs(copyArr) do
		logger:debug("explor enter id . " .. v)
		local numAttack = fnGetEliteCopyItem(v)
		--logger:debug("numAttack" .. numAttack)
		if(numAttack > -1) then
			if(numAttack > 0) then
				curCopyBattleId = tonumber(v)
				curCopyFlogId = tonumber(v)
			end

			local copyItemData = DB_Elitecopy.getDataById(v)
			local copyPosition = lua_string_split(copyItemData.position,",")

			if (itemCopyLayer) then
				local itemCopy_ = itemCopyLayer:clone()
				itemCopy_:setVisible(true)
				itemCopy_:setTag(copyItemData.id)
				-- zhangqi, 20140516, 副本入口配置坐标乘以缩放比率，并以背景图为父节点，才能符合适配需求
				local size = m_imgWorldBg:getSize()
				local pst = ccp(copyPosition[1]/size.width, copyPosition[2]/size.height)
				itemCopy_:setPositionPercent(pst)
				local itemCopyBtn = g_fnGetWidgetByName(itemCopy_, "BTN_COPY1", "Button")
				--副本名称
				local itemCopyImg_ = g_fnGetWidgetByName(itemCopy_, "IMG_CPNAME_SAMPLE", "ImageView")
				if (itemCopyBtn) then
					-- itemCopyBtn:setScale(g_fScaleX)
					itemCopyBtn:setTag(copyItemData.id)
					itemCopyBtn:addTouchEventListener(onEliteCopy)
					--itemCopyBtn:loadTextureNormal(copyElitePath .."thumbnail/"..copyItemData.thumbnail)
					--liweidong 精英副本增加按钮三种状态
					if (numAttack>=1) then
						itemCopyBtn:loadTextureNormal(copyEntrancePath.."normalImg/copy_n_"..copyItemData.thumbnail)  --copyItemData.picture
						itemCopyBtn:loadTexturePressed(copyEntrancePath.."selectedImg/copy_h_"..copyItemData.thumbnail)
						curCopyBtn=itemCopyBtn
						curCopyNameImg=itemCopyImg_
					else
						itemCopyBtn:loadTextureNormal(copyEntrancePath.."disableImg/copy_a_"..copyItemData.thumbnail)
						itemCopyBtn:loadTexturePressed(copyEntrancePath.."disableImg/copy_a_"..copyItemData.thumbnail)
						itemCopyImg_:loadTexture(copyNormalPath .. "worldnameimage/copy_name_a_bg.png")
					end
				end

				if(imgMainBg_:getChildByTag(copyItemData.id) ~= nil) then
					--logger:debug("removemainbgcopy")
					imgMainBg_:removeChildByTag(copyItemData.id,true)
				end
				if (v%100==17 or v%100==20) then
					imgMainBg_:addChild(itemCopy_,11)
				else
					imgMainBg_:addChild(itemCopy_,10)
				end

				
				--副本名称图片和坐标
				local entceItemData = DB_Copy_entrance.getDataById(v%100)
				local itemCopyTBg = g_fnGetWidgetByName(itemCopyImg_, "IMG_CPNAME_SAMPLE")
				itemCopyTBg:setPositionType(POSITION_ABSOLUTE)
				local pos = lua_string_split(entceItemData.name_position,",")
				itemCopyTBg:setPosition(ccp(tonumber(pos[1]),tonumber(pos[2])))

				local itemCopyTitle_ = g_fnGetWidgetByName(itemCopyImg_, "IMG_COPY_NAME")
				itemCopyTitle_:loadTexture(copyNormalPath .. "worldnameimage/".. copyItemData.name_png)

				-- --通关条件
				-- local itemClearance_ = g_fnGetWidgetByName(itemCopy_, "TFD_NORMAL_COPY")

				-- if (numAttack == 0) then
				-- 	local norCopyName = fnGetEliteClearance(copyItemData.pre_copyid)
				-- 	if (norCopyName) then
				-- 		itemClearance_:setText(string.format(gi18n[1301],norCopyName))
				-- 	else
				-- 		itemClearance_:setVisible(false)
				-- 	end
				-- else
				-- 	itemClearance_:setVisible(false)
				-- -- end

				--显示路线
				if (lastEntranceId ~= 0) then
					fnLineToEntrance(lastEntranceId,v)
				end
				lastEntranceId = tonumber(v)
			end

		end

		if (numAttack == 0) then
			break
		end
	end

	if (curCopyBtn) then
		setCurNameEffect(curCopyNameImg)
		runBeatAction(curCopyBtn)
		fnShowCopyShip(curCopyBattleId,2)
	end

end


--[[desc:为当前据点名称增加特效果
    arg1: curCopyNameImg 当前据点名字背景图片
    return: nil  
—]]
function setCurNameEffect(curCopyNameImg,mapType)
	local imgfile = mapType==1 and "images/copy/light_ncopy.png" or "images/copy/light_ecopy.png"
	curCopyNameImg:loadTexture(imgfile)
	
	
	local action1=CCMoveBy:create(0.75,ccp(0,-5))
	local action2=CCMoveBy:create(0.75,ccp(0,5))
	curCopyNameImg:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(action1,action2)))

	local copyAni = UIHelper.createArmatureNode({
		filePath = "images/effect/copypoint/copy.ExportJson",
		animationName = "copy",
	})
	copyAni:setAnchorPoint(ccp(0.5, 0.5))
	copyAni:setPosition(ccp(0,40))
	curCopyNameImg:addNode(copyAni,10)
end
--------------------------------迷雾与传送阵相关-----------------------------
-- 迷雾布局数据
function setFogLayer( ... )
	-- do return end
	if (blCopyStyle==3) then --探索不需要处理迷雾
		setExplorMapOffset()
		return
	end
	if (blCopyStyle==2) then --探索不需要处理迷雾
		local db = DB_Elitecopy.getDataById(curCopyBattleId)
		m_imgWorldBg.IMG_FOG_SAMPLE:setPositionType(POSITION_ABSOLUTE)
		m_imgWorldBg.IMG_FOG_SAMPLE:setPosition(ccp(db.scv_area,m_imgWorldBg.IMG_FOG_SAMPLE:getPositionY()))
		setMapOffset()
		return
	end
	local db = DB_Copy_entrance.getDataById(curCopyBattleId)
	m_imgWorldBg.IMG_FOG_SAMPLE:setPositionType(POSITION_ABSOLUTE)
	m_imgWorldBg.IMG_FOG_SAMPLE:setPosition(ccp(db.scv_area,m_imgWorldBg.IMG_FOG_SAMPLE:getPositionY()))
	setMapOffset()

	-- local fogbg,x,y = getFogInfo()
	-- if (fogbg and x and mapInfo.fog_num) then
	-- 	local fogNum = tonumber(mapInfo.fog_num)
	-- 	setMapOffset()
	-- 	for i=1,fogNum do
	-- 		local fogLayer = g_fnGetWidgetByName(m_imgWorldBg, "IMG_FOG_" .. i)
	-- 		local texture = CCTextureCache:sharedTextureCache():textureForKey(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 		if (texture) then
	-- 			fogLayer:loadTexture(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 		else
	-- 			performWithDelayFrame(curCopyLayer, function()
	-- 						--liweidong 设置抗锯齿 云彩之前渐变太明显
	-- 						local texture=CCTextureCache:sharedTextureCache():addImage(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 						texture:setAliasTexParameters()
	-- 						fogLayer:loadTexture(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 					end
	-- 					, 4)
	-- 		end
	-- 	end
	-- 	--logger:debug("curCopyBattleIds " .. curCopyBattleId)
		
	-- end

end
--设置scrollView定位
function setMapOffset()
	local sampleCopyId = curCopyBattleId%100
	-- if (tonumber(curCopyBattleId) > 3 and 200001 ~= curCopyBattleId) then
	if (sampleCopyId>3) then
		local itemTagCopy = m_imgWorldBg:getChildByTag(curCopyBattleId)
		-- local itemCopyPos = itemTagCopy:getPositionPercent()

		--curPX = itemCopyPos.x
		-- local szOld = scrollView:getInnerContainerSize()
		-- curPX = itemTagCopy:getPositionX()/szOld.width --*g_CopyBgRate1136
		-- logger:debug("cur offset .." .. itemTagCopy:getPositionX())
		-- curPX = (tonumber(x)*g_fScaleX  + g_winSize.width / 4 ) / m_imgWorldBg:getContentSize().width
		--logger:debug("fogbg" .. fogPath .. fogbg .. "\nx.pos" .. curPX)
		-- scrollView:scrollToPercentHorizontal(curPX,0.2,true)
		
		-- scrollView:jumpToPercentHorizontal(curPX * 100)
		scrollView:setJumpOffset(ccp(-itemTagCopy:getPositionX()*g_CopyBgRate1136+400*g_CopyBgRate1136,scrollView:getJumpOffset().y))
	else
		scrollView:jumpToPercentHorizontal(0)
	end
end
--设置探索scrollView定位
function setExplorMapOffset()
	
	if (canExploreNum>3) then --(tonumber(curCopyBattleId) > 3 and 200001 ~= curCopyBattleId) then

		local itemTagCopy = m_imgWorldBg:getChildByTag(curCopyBattleId)
		-- local itemCopyPos = itemTagCopy:getPositionPercent()

		scrollView:setJumpOffset(ccp(-itemTagCopy:getPositionX()*g_CopyBgRate1136+400*g_CopyBgRate1136,scrollView:getJumpOffset().y))
	else
		scrollView:jumpToPercentHorizontal(0)
	end
end
-- 获取迷雾图片与坐标
function getFogInfo( ... )
	local fogbg = nil
	local pX = nil
	local pY = nil
	if (mapInfo.change_fog) then -- zhangqi, 20140627, 没有迷雾时change_fog = nil, 增加判断避免解析nil错误
		local fogArr = lua_string_split(mapInfo.change_fog,"|")
		for i,value in pairs(fogArr) do
			local idbgArr = lua_string_split(value,",")
			if (#idbgArr == 2) then
				--logger:debug("idbgArr" .. idbgArr[1] .. "curCopyBattleId" .. curCopyFlogId)
				if ( tonumber(idbgArr[1]) == tonumber(curCopyFlogId)) then
					fogbg = idbgArr[2]
					local copyItemInfo = nil
					if (isNoramlFocused) then
						copyItemInfo = DB_Copy_entrance.getDataById(curCopyFlogId)
					else
						copyItemInfo = DB_Elitecopy.getDataById(curCopyFlogId)
					end
					local positionValue = copyItemInfo.position
					if (positionValue) then
						local fogPosition = lua_string_split(positionValue,",")
						if (#fogPosition == 2) then
							pX = fogPosition[1]
							pY = fogPosition[2]
						end
					end
				end
			end
		end
	end
	return fogbg,pX,pY
end

-- 加载地图传送阵
function setNextWorldLayer( ... )
	local nextWorldBtn = g_fnGetWidgetByName(curCopyLayer, "BTN_CHANGE_MAP", "Button")
	if (nextWorldBtn) then
		local fngetCopy = fnGetWorldCopy()
		if (curWorldData.copy_list) then
			local lastCopyInfo = curWorldData.copy_list[tostring(#fngetCopy)]
			--判断是否通关副本出现下一个地图入口
			--logger:debug(mapInfo)
			if (mapInfo.nextid ~= nil and fngetAttacked(lastCopyInfo)) then
				--logger:debug("mapInfo.nextid " .. mapInfo.nextid)
				local nextPosition = lua_string_split(mapInfo.next_position,",")
				local x = tonumber(nextPosition[1])
				local y = tonumber(nextPosition[2])
				--logger:debug("x " .. x .. "y " .. y)
				nextWorldBtn:setTag(mapInfo.nextid)
				nextWorldBtn:setVisible(true)
				nextWorldBtn:setPositionPercent(g_GetPercentPosition(scrollViewLayout,x, y))
				nextWorldBtn:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playEnterCopy()

						mapId = sender:getTag()
						requestCopyData(sender:getTag())
					end
				end)
			else
				nextWorldBtn:setVisible(false)
			end
		else
			nextWorldBtn:setVisible(false)
		end

		--判断是否存在上一个地图
		if (mapInfo.lastid ~= nil) then
			local lastPosition = lua_string_split(mapInfo.last_position,",")
			local x = tonumber(lastPosition[1])
			local y = tonumber(lastPosition[2])
			local lastWorldBtn = nextWorldBtn:clone()
			lastWorldBtn:setVisible(true)
			lastWorldBtn:setTag(mapInfo.lastid)
			lastWorldBtn:setPositionPercent(g_GetPercentPosition(scrollViewLayout,x, y))
			lastWorldBtn:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playEnterCopy()
					
					mapId = sender:getTag()
					requestCopyData(sender:getTag())
				end
			end)
			scrollViewLayout:addChild(lastWorldBtn)
		end


	end
end

-----------数据请求返回处理
--[[
    @desc   普通副本的回调
    @para   void
    @return void
--]]
local function getNormalCopyCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok" )then
		local tbRet = dictData.ret
		tbRet.world_id = mapId
		DataCache.setNormalCopyData( tbRet )
		init()
	end
end

-- 请求普通世界地图副本数据
function requestCopyData( worldId )
	local args = CCArray:create()
	args:addObject(CCInteger:create(worldId))
	RequestCenter.getNormalCopyList(getNormalCopyCallback,args)
end

--[[
    @desc   精英副本的回调
    @para   void
    @return void
--]]
function getEliteCopyCallback( cbFlag, dictData, bRet )
	if(dictData and dictData.ret) then
		init()
	end
end
--通关一个副本后，世界地图显示对话
function showPassCopyDialog()
	--在副本世界地图中显示开启新副本对话，并删除标识 liweidong
	require "script/model/user/UserModel"
	local pass_dialogid=CCUserDefault:sharedUserDefault():getIntegerForKey("pass_dialogid_"..UserModel.getUserUid())

	if (tonumber(pass_dialogid)~=0) then
		CCUserDefault:sharedUserDefault():setIntegerForKey("pass_dialogid_"..UserModel.getUserUid(), 0)
	    CCUserDefault:sharedUserDefault():flush()
	    local nextCopyInfo=DB_Copy.getDataById(pass_dialogid)
	    if (nextCopyInfo.pass_dialogid) then
	    	require "script/module/talk/TalkCtrl"
		    TalkCtrl.create(nextCopyInfo.pass_dialogid)
		    TalkCtrl.setCallbackFunction(function() SwitchCtrl.setSwitchView() end)
			SwitchCtrl.setSwitchViewByTalk()
		end
	end
end
-- 初始函数，加载UI资源文件 isshowDialog --是否加载地图对话
function create( copyTpye,normal,isshowDialog)
	--重置公共变量
	blCopyStyle = copyTpye==nil and 1 or copyTpye --copyTpye 副本类型1普通，2精英 3探索
	-- nNewBaseId = 0 --开启新据点的id
	-- isFirstPassCopy_1 = false
	isNoramlFocused = normal==nil and true or normal  --normal 精英副本和普通副本的标识，探索的数据来源也属于普通副本，本标识用户从精英副本还是普通副本获取数据

	if (isshowDialog==nil and blCopyStyle==1) then   --isshowDialog 是否进入世界地图显示对话 并且当前在普通副本
		showPassCopyDialog()
	end
	--主背景UI
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
					listView = false
					copyListLayer=nil
					copyExplor=nil
					copyGeneral=nil
					copyElite=nil
					logger:debug("on exit")
				end,
				function()
				end
			)
		
		TimeUtil.timeStart("copyLoadUI1")
		--副本标签
		topCopyTagLayer = g_fnLoadUI(jsonyeqian)
		TimeUtil.timeEnd("copyLoadUI1")
		topCopyTagLayer:setSize(g_winSize)
		layoutMain:addChild(topCopyTagLayer,zOrderYeqian)

		-- topCopyTagLayer.BTN_AWAKE:setEnabled(false)
		topCopyTagLayer.BTN_AWAKE:addTouchEventListener(
				function( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playTabEffect()		--切换页签音效
						logger:debug()
						if (SwitchModel.getSwitchOpenState(ksSwitchAwake,true)) then
							copyAwakeCtrl.create()--觉醒副本
						end
					end
				end
			)
		awakeBtn = topCopyTagLayer.BTN_AWAKE
		nomalBtn = g_fnGetWidgetByName(topCopyTagLayer, "BTN_NORMAL")
		eliteBtn = g_fnGetWidgetByName(topCopyTagLayer, "BTN_ELITE")
		--explorBtn = g_fnGetWidgetByName(topCopyTagLayer, "BTN_EXPLORE")
		--探索红点
		-- require "script/module/copy/ExplorMainCtrl"
		-- ExplorMainCtrl.setExplorRedByBtn(explorBtn)
		
		nomalBtn:addTouchEventListener(onEventClickTag)
		eliteBtn:addTouchEventListener(onEventClickTag)
		-- eliteBtn:setEnabled(false) --liweidong 20151123 屏蔽精英副本
		--公会副本相关页签
		require "script/module/guildCopy/GCItemModel"
		topCopyTagLayer.LABN_TIP_UNION:setStringValue(GCItemModel.getAtackNum())
		if (GCItemModel.getAtackNum()<=0 or not GuildCopyModel.isHaveAttackingCopy() ) then
			topCopyTagLayer.IMG_TIP_UNION:setVisible(false)
		end
		topCopyTagLayer.BTN_UNION:addTouchEventListener(function( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()
					require "script/module/guild/GuildDataModel"
					if (not GuildDataModel.getIsHasInGuild() or  not(GuildUtil.isGuildCopyOpen()) ) then
						ShowNotice.showShellInfo(m_i18n[5954]) --TODO
					end
					-- require "script/module/guildCopy/GuildCopyMapCtrl"
					-- GuildCopyMapCtrl.create()
					require "script/module/guild/MainGuildCtrl"
					MainGuildCtrl.enterCopy()
				end
			end)
		--explorBtn:addTouchEventListener(onEventClickTag)
		-- buttonTagFocus()
		init()
	end
	performWithDelayFrame(layoutMain, function()
			--------------------------------- new guide begin -------------------------------------------
			require "script/module/guide/GuideModel"
			require "script/module/guide/GuideFormationView"
			if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 6) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.createFormationGuide(7)
				scrollView:setTouchEnabled(false)
			end
			---------------------------------- new guide end -------------------------formation 1 end---------

			--------------------------- new guide begin -------------------------------------
			-- require "script/module/guide/GuideModel"
			require "script/module/guide/GuidePartnerAdvView"
			if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 5) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.createPartnerAdvGuide(6)
				scrollView:setTouchEnabled(false)
			end
			if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 13) then

				require "script/module/guide/GuideCtrl"
				GuideCtrl.createkFiveLevelGiftGuide(14)
				scrollView:setTouchEnabled(false)
			end

			require "script/module/guide/GuideEquipView"
			if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 9) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.removeGuide()
			end

			require "script/module/guide/GuideEliteView"
			if (GuideModel.getGuideClass() == ksGuideEliteCopy and GuideEliteView.guideStep == 1) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.createEliteGuide(2)
				scrollView:setTouchEnabled(false)
			end

			require "script/module/guide/GuideExploreView"
			if (GuideModel.getGuideClass() == ksGuideExplore and GuideExploreView.guideStep == 1) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.createExploreGuide(2)
				scrollView:setTouchEnabled(false)
			end

		    require "script/module/guide/GuideCopyBoxView"
		    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 10) then
		        require "script/module/guide/GuideCtrl"
		        GuideCtrl.createCopyBoxGuide(11)
		        scrollView:setTouchEnabled(false)
		    end

		   	require "script/module/guide/GuideCopy2BoxView"
		    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 17) then
		        require "script/module/guide/GuideCtrl"
		        GuideCtrl.createCopy2BoxGuide(18)
		        scrollView:setTouchEnabled(false)
		    end

			require "script/module/guide/GuideEquipView"
			if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == 10) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.createEquipGuide(11)
				scrollView:setTouchEnabled(false)
			end

			require "script/module/guide/GuideTreasView"
			if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 6) then
				require "script/module/guide/GuideCtrl"
				GuideCtrl.createTreasGuide(7)
				scrollView:setTouchEnabled(false)
			end

			require "script/module/guide/GuideAwakeView"
		   if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 6) then
		        require "script/module/guide/GuideCtrl"
		        GuideCtrl.createAwakeGuide(7)
		        scrollView:setTouchEnabled(false)
		    end

			---------------------------- new guide end --------------------------------------

		end,5
		)
	
	layoutMain:setSize(g_winSize)
	return layoutMain
end


--[[desc:设置本界面（世界地图）显示和隐藏
    arg1: show bool值 
    return: nil
—]]
function setMainCopyVisible(show)
	if (layoutMain) then
		layoutMain:setVisible(show)
	end
end
 

---------------------------------------新手引导外部调用使用------------------

--跳转到某个普通副本 或精英副本， copyId 副本id,copyType 副本类型1为普通副本2为精英副本
function extraToCopyScene( copyId,copyType,difficult,backFun)
	-- if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
	MainCopy.destroy()
	if (copyType == 2) then
		isNoramlFocused = false
	else
		isNoramlFocused = true
	end
	if (not isNoramlFocused) then
		if (MainCopy.moduleName() == LayerManager.curModuleName()) then
			local layout = Layout:create()
			LayerManager.changeModule(layout, "changeCopyModuleTmp", {}, true)
		end
		local layCopy = MainCopy.create(copyType,isNoramlFocused,0)  --这里要进入某个普通副本 或 某个精英副本，所在不能显示通关副本对话
		LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
		require "script/module/main/PlayerPanel"
		PlayerPanel.addForCopy()
		MainCopy.updateBGSize()
	end
	if (copyType == 2) then
		toEliteCopy(copyId)
	else
		local copyData = DB_Copy.getDataById(copyId)
		toItemCopy(copyId,difficult,backFun)
		
		--liweidong 下面不要删除
		-- toCopyListOrItem(copyData.entrance_id)
		-- if (#tbShowCopyData > 1) then
		-- 	--logger:debug("to item copy======".. difficult)
		-- 	toItemCopy(copyId,difficult)
		-- end
	end
	-- end
end

--进入探索地图
function extraToExploreScene()
	if (not SwitchModel.getSwitchOpenState(ksSwitchExplore,true)) then
		return
	end
	if (MainCopy.moduleName() == LayerManager.curModuleName()) then
		local layout = Layout:create()
		LayerManager.changeModule(layout, "changeCopyModuleTmp", {}, true)
	end
	
	if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
		local layCopy = MainCopy.create(3)
		if (layCopy) then
			LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true) --MainCopy.moduleName()
			PlayerPanel.addForExplorMapNew() --PlayerPanel.addForExplorMap()
			MainCopy.updateBGSize()
			MainCopy.setFogLayer()
		end
	end
end


--[[desc:liweidong 引导战斗第二次战斗回调
    arg1: nil
    return: nil 
—]]
local function guildBattleSecondCallback()
	----logger:debug("battle first2 =======================")
	
	MainCopy.extraToCopyScene(1,1)
	itemCopy.onClickBaseEvent(1001)	
end
--[[desc:liweidong 引导战斗第一次战斗回调 方法1  回调有两个方法
    arg1: nil
    return: nil 
—]]
local function guildBattleFirstCallback()
	----logger:debug("battle first =======================")
	--显示临时场景背景 需要屏蔽ItemCopy的触摸
	

	GuildBattleBg=Layout:create()
	LayerManager.addLayout(GuildBattleBg)
	
	local img = ImageView:create()
	img:loadTexture("images/copy/ncopy/overallimage/bgcopy10_xiaohuayuan.jpg")
	img:setAnchorPoint(ccp(0,0))
	GuildBattleBg:addChild(img,998)
	img:setScale(g_fScaleX)
end



--[[desc:liweidong 引导战斗第一次战斗回调 方法2  回调有两个方法
    arg1: nil
    return: nil  
—]]
local function guildBattleFirstCallback2()
	--显示临时场景背景 需要屏蔽ItemCopy的触摸
	require "script/module/talk/TalkCtrl"
	TalkCtrl.create(206)
	TalkCtrl.setCallbackFunction(function ( ... )
			--调用第二次战斗
			BattleModule.playTutorial2(guildBattleSecondCallback)
			--img:removeFromParentAndCleanup(true)
			GuildBattleBg:removeChildByTag(998,true)
		end
	)
end

--[[desc: liweidong 新手引导直接进入战斗场景 非据点战斗(引导战斗)
    arg1: nil
    return: nil  
—]]
function enterGuildBattle()
	-- 2013-03-11, 平台统计需求，新手剧情之后(即进入首个副本)
	if (Platform.isPlatform()) then
		Platform.sendInformationToPlatform(Platform.kOutOfStoryLine)
	end
	require "script/module/main/MainScene"
	guildBattleSecondCallback()
end

--baseId 传入据点id
local function extraToCopyArmy( baseId,baseNetData,difficult)
	if (baseId ~= nil and baseNetData ~= nil) then
		require "script/module/copy/battleMonster"
		local battleMLayout = battleMonster.create(baseId,baseNetData,difficult)
		if (battleMLayout ~= nil) then
			LayerManager.addLayout(battleMLayout)
		end
	end
end

--影子界面前往攻打据点
function heroFragToCopyBase( copyId,baseId,baseNetData,difficult,backFun)
	-- if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
		logger:debug("hero frag ========"..difficult)
		extraToCopyScene(copyId,1,tonumber(difficult),backFun)
		-- extraToCopyArmy(baseId,baseNetData,tonumber(difficult))
		-- itemCopy.onClickBaseEvent(baseId)
		itemCopy.guidGetSplit(baseId)
	-- end
end
--装备、宝物 前往攻打精英副本
function enterToEliteCopyBase(copyId)
	if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
		extraToCopyScene(copyId,2)
	end
end
--装备、宝物获取 前往探索主界面
function enterToExploreBase(copyId)
	require "script/module/copy/ExplorMainCtrl"
	if (ExplorMainCtrl.moduleName() ~= LayerManager.curModuleName()) then
		local explorMain = ExplorMainCtrl.create(copyId)
		LayerManager.changeModule(explorMain, ExplorMainCtrl.moduleName(), {1,3}, false,1)
		PlayerPanel.addForExplorNew()
	end
end
--装备、宝物获取 前往探索主界面 --正常changemodule
function enterToExploreBaseNormal(copyId)
	require "script/module/copy/ExplorMainCtrl"
	if (ExplorMainCtrl.moduleName() ~= LayerManager.curModuleName()) then
		local explorMain = ExplorMainCtrl.create(copyId)
		LayerManager.changeModule(explorMain, ExplorMainCtrl.moduleName(), {1,3}, false)
		PlayerPanel.addForExplorNew()
	end
end
--0点重置数据
function resetCopyData()
	-- 普通副本
	local function preGetNormalCopyCallback( cbFlag, dictData, bRet )
		if(bRet)then
			logger:debug("preGetNormalCopyCallback")
			DataCache.setNormalCopyData( dictData.ret )
			require "script/module/copy/battleMonster"
			battleMonster.resetNightConfig()
		end
	end
	RequestCenter.getLastNormalCopyList(preGetNormalCopyCallback)
	--精英副本
	if (not SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,false)) then
		return
	end
	local eliteData = DataCache.getEliteCopyData()
	eliteData.can_defeat_num=3
	if (layoutMain) then
		worldinitBase()
	end
end
--当前是否在探索地图
function isInExploreMap()
	return blCopyStyle==3
end
--当前是否在地图中
function isInMap()
	return layoutMain and true or false
end
function moduleName()
	return "MainCopy"
end

-- 析构函数，释放纹理资源
function destroy( ... )
	copyGeneral = nil
	copyElite = nil
	copyExplor=nil
	layPower = nil
	layoutMain=nil
	package.loaded["MainCopy"] = nil
end

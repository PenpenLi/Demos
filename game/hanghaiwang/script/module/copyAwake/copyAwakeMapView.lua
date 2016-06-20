-- FileName: copyAwakeMapView.lua
-- Author: liweidong
-- Date: 2015-11-16
-- Purpose: 觉醒副本世界地图View
--[[TODO List]]

module("copyAwakeMapView", package.seeall)

-- UI控件引用变量 --
local _layoutMain=nil
local _enterenceCopy=nil --入口UI的复制
-- 模块局部变量 --
local _copyStartTag = 10000 --线路tag基数
local _copyLineTag = 1000 --线路tag增加
local _awakeCopyWordId = 40000 --觉醒副本地图
local _zOrderYeqian = 100 --副本页签order
local _curOpenedCopy =0 --当前副本
local m_i18n = gi18n
local _shipTag = 7653 --小船tag

local function init(...)

end

function destroy(...)
	package.loaded["copyAwakeMapView"] = nil
end

function moduleName()
    return "copyAwakeMapView"
end

--副本之间的连线显示
function fnLineToEntrance( from,to)
	logger:debug("lineImg:" .. from .. "_" .. to)
	local m_imgWorldBg = _layoutMain.IMG_BG1
	if (from and to) then
		local entanceFrom =  DB_Disillusion_copy.getDataById(from) 
		local entanceTo = DB_Disillusion_copy.getDataById(to) 
		from=from%100
		to=to%100
		local lineImg = "line_" .. from .. "_" .. to .. ".png"
		logger:debug("lineImg:" .. lineImg)
		if (entanceFrom.point_position ~= nil and entanceTo.point_position~= nil) then
			local posFromArr = lua_string_split(entanceFrom.point_position,",")
			local posToArr = lua_string_split(entanceTo.point_position,",")
			local posLineToArr = lua_string_split(entanceTo.line_position,",")

			if (#posFromArr == 2 and #posToArr == 2 and #posLineToArr == 2) then
				--起始点入口图标
				local tagFrom = _copyStartTag+tonumber(from)
				if (m_imgWorldBg:getNodeByTag(tagFrom)) then
					m_imgWorldBg:removeNodeByTag(tagFrom)
				end
				local pointLine = CCSprite:create("images/copy/ncopy/lineimage/line_point_h.png")
				pointLine:setTag(tagFrom)
				pointLine:setPosition(ccp(tonumber(posFromArr[1]),tonumber(posFromArr[2])))
				m_imgWorldBg:addNode(pointLine,9)

				--结束点入口图标
				local tagTo = _copyStartTag+tonumber(to)
				if (m_imgWorldBg:getNodeByTag(tagTo)) then
					m_imgWorldBg:removeNodeByTag(tagTo)
				end
				local endPointImg = "images/copy/ncopy/lineimage/line_point_a.png"
				if (_curOpenedCopy%100>=to) then
					endPointImg = copyEntLinePath.."line_point_h.png"
				end
				local pointLineTo = CCSprite:create(endPointImg)
				pointLineTo:setTag(tagTo)
				pointLineTo:setPosition(ccp(tonumber(posToArr[1]),tonumber(posToArr[2])))
				m_imgWorldBg:addNode(pointLineTo,9)

				--画链接线
				local tagLine=_copyStartTag+tonumber(to)+_copyLineTag
				local lineSprite = CCSprite:create("images/copy/ncopy/lineimage/"..lineImg)
				lineSprite:setTag(tagLine)
				if (lineSprite ~= nil) then
					if (m_imgWorldBg:getNodeByTag(tagLine)) then
						m_imgWorldBg:removeNodeByTag(tagLine)
					end
					local xPos = tonumber(posLineToArr[1])
					local yPos = tonumber(posLineToArr[2])
					lineSprite:setPosition(ccp(xPos,yPos))
					m_imgWorldBg:addNode(lineSprite,8)
				end
			end

		end
	end
end
--设置地图背景图片
local function setMapBackground( )
	logger:debug({_curOpenedCopy = _curOpenedCopy})
	local entceItemData=DB_Disillusion_copy.getDataById(_curOpenedCopy)
	logger:debug({entceItemData = entceItemData})
	local mapInfo = DB_World.getDataById(_awakeCopyWordId)
	if (mapInfo.world_pic) then
		if (mapInfo.world_num) then
			local worldNum = tonumber(mapInfo.world_num)
			for i=1,worldNum do
				-- _layoutMain["IMG_BG1_"..i]:loadTexture("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")

				if ((i-1)*1065<entceItemData.scv_area) then --没有超出可滑动区域
					_layoutMain["IMG_BG1_"..i]:loadTexture("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")
				end
			end
		end
	end
end
-- 显示迷雾
function setFogLayer( ... )
	-- local mapInfo = DB_World.getDataById(_awakeCopyWordId)
	-- local fogArr = lua_string_split(mapInfo.change_fog,"|")
	-- local function setFog(fogbg)
	-- 	local fogPath = "images/copy/fog/"
	-- 	local fogNum = tonumber(mapInfo.fog_num)
	-- 	for i=1,fogNum do
	-- 		local fogLayer = _layoutMain["IMG_FOG_" .. i]
	-- 		local texture = CCTextureCache:sharedTextureCache():textureForKey(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 		if (texture) then
	-- 			fogLayer:loadTexture(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 		else
	-- 			performWithDelay(_layoutMain, function()
	-- 						--liweidong 设置抗锯齿 云彩之前渐变太明显
	-- 						local texture=CCTextureCache:sharedTextureCache():addImage(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 						texture:setAliasTexParameters()
	-- 						fogLayer:loadTexture(fogPath .. fogbg .. "/" .. i .. ".png")
	-- 					end
	-- 					, 0.01)
	-- 		end
	-- 	end
	-- end
	-- if (_curOpenedCopy==0) then
	-- 	setFog("fog1")
	-- else
	-- 	for i,value in pairs(fogArr) do
	-- 		local idbgArr = lua_string_split(value,",")
	-- 		if (#idbgArr == 2) then
	-- 			if ( tonumber(idbgArr[1]) == tonumber(_curOpenedCopy)) then
	-- 				setFog(idbgArr[2])
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end
end
--画入口
function drawEntrance()
	local copyInfos = copyAwakeModel.getMapEnterenceInfo()
	logger:debug({copyInfos=copyInfos})
	local lastEntranceId = 0
	_curOpenedCopy = 500001
	for k,v in ipairs(copyInfos) do
		logger:debug("id:" .. v.id)
		if (v.curEntrance) then
			_curOpenedCopy = v.id
		end
		if(_layoutMain.IMG_BG1:getChildByTag(v.id) ~= nil) then
			_layoutMain.IMG_BG1:removeChildByTag(v.id,true)
		end
		local entceItemData=v.db
		local copyPosition = lua_string_split(entceItemData.position,",")
		local itemCopy_ = _enterenceCopy:clone()
		itemCopy_:setVisible(true)
		itemCopy_:setTag(v.id)
		itemCopy_:setPosition(ccp(copyPosition[1], copyPosition[2]))
		if (v.id%100==20) then
			_layoutMain.IMG_BG1:addChild(itemCopy_,10)
		else
			_layoutMain.IMG_BG1:addChild(itemCopy_,9)
		end

		if (itemCopy_.BTN_COPY1) then
			itemCopy_.BTN_COPY1:setTag(v.id)
			itemCopy_.BTN_COPY1:addTouchEventListener(function( sender,eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playEnterCopy()
							if (v.clickStatus==0) then
								copyAwakeCtrl.onClickGrayEnterence(v.id)
							else
								copyAwakeCtrl.onClickEnterence(v.id)
							end
						end 
					end)
			if (v.clickStatus==0) then
				itemCopy_.BTN_COPY1:loadTextureNormal("images/copy/ncopy/entranceimage/disableImg/copy_a_"..entceItemData.image)
				itemCopy_.BTN_COPY1:loadTexturePressed("images/copy/ncopy/entranceimage/disableImg/copy_a_"..entceItemData.image)
				itemCopy_.IMG_CPNAME_SAMPLE:loadTexture("images/copy/ncopy/worldnameimage/copy_name_a_bg.png")
				itemCopy_.IMG_BOX_TIP:setVisible(false)
			else
				itemCopy_.BTN_COPY1:loadTextureNormal("images/copy/ncopy/entranceimage/normalImg/copy_n_"..entceItemData.image)
				itemCopy_.BTN_COPY1:loadTexturePressed("images/copy/ncopy/entranceimage/selectedImg/copy_h_"..entceItemData.image)
				local boxStatus = copyAwakeModel.getRewardStatusById(v.id)
				if (boxStatus) then
					itemCopy_.IMG_BOX_TIP:setVisible(true)
					local m_arAni1 = UIHelper.createArmatureNode({
							filePath = "images/effect/box_tip/box_tip.ExportJson",
							animationName = "box_tip",
							bRetain=true
						})
					itemCopy_.IMG_BOX_TIP:removeAllChildrenWithCleanup(true)
					itemCopy_.IMG_BOX_TIP:addNode(m_arAni1)
				else
					itemCopy_.IMG_BOX_TIP:setVisible(false)
				end
			end
		end
		--副本名称图片和坐标
		itemCopy_.IMG_CPNAME_SAMPLE:setPositionType(POSITION_ABSOLUTE)
		local pos = lua_string_split(entceItemData.name_position,",")
		itemCopy_.IMG_CPNAME_SAMPLE:setPosition(ccp(tonumber(pos[1]),tonumber(pos[2])))
		itemCopy_.IMG_COPY_NAME:loadTexture("images/copy/ncopy/worldnameimage/copy_name_".. entceItemData.name_graph)
		if (v.curEntrance) then
			setCurNameEffect(itemCopy_.IMG_CPNAME_SAMPLE) --当前副本特效
			runBeatAction(itemCopy_.BTN_COPY1)
			-- fnShowCopyShip(v.id)
		end
		--得星
		local haveStar,allStar = copyAwakeModel.getCopyStarById(v.id)
		itemCopy_.LABN_STAR_OWN:setStringValue(haveStar)
		itemCopy_.LABN_STAR_TOTAL:setStringValue(allStar)
		

		--显示路线
		if (tonumber(lastEntranceId) ~= 0) then
			fnLineToEntrance(lastEntranceId,v.id)
		end
		lastEntranceId=v.id
	end
end
--设置当前入口名称动画
function setCurNameEffect(curCopyNameImg)
	local imgfile = "images/copy/light_ecopy.png"
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
--入口呼吸动作
function runBeatAction(node)
	local actions = CCArray:create()
	actions:addObject(CCScaleTo:create(0.75, 1.0))
	actions:addObject(CCScaleTo:create(0.75, 1.03))
	--actions:addObject(CCDelayTime:create(1.5))
	node:runAction(CCRepeatForever:create(CCSequence:create(actions)))
end

--国际化
function setUIStyleAndI18n(base)
	-- base.BTN_BACK:setTitleText(m_i18n[1019])
	-- base.TFD_SOLDIER_LEVEL:setText(m_i18n[1067])
	-- base.tfd_soldier_con:setText(m_i18n[3708])
	-- base.tfd_active:setText(m_i18n[5931])
	-- base.tfd_soldier_title:setText(m_i18n[5955])

	-- UIHelper.titleShadow(base.BTN_BACK)

	-- UIHelper.labelNewStroke( base.tfd_soldier_title, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_SOLDIER_LV, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_SOLDIER_LEVEL, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.tfd_soldier_con, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.tfd_active, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_SOLDIER_CON_NUM, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_SOLDIER_CON_SLANT, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_SOLDIER_CON_NUM2, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_ACTIVE_NUM, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_ACTIVE_SLANT, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_ACTIVE_NUM2, ccc3(0x28,0x00,0x00), 2 )
	-- UIHelper.labelNewStroke( base.TFD_PROGRESS, ccc3(0x28,0x00,0x00), 2 )
end
--加载UI
function loadUI()
	_layoutMain = g_fnLoadUI("ui/dcopy_main.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		)
	setUIStyleAndI18n(_layoutMain)
	--副本标签
	local topCopyTagLayer = g_fnLoadUI("ui/copy_yeqian.json")
	topCopyTagLayer:setSize(g_winSize)
	_layoutMain:addChild(topCopyTagLayer,_zOrderYeqian)
	_layoutMain.BTN_ELITE:setEnabled(false)
	_layoutMain.BTN_UNION:setEnabled(false)
	_layoutMain.BTN_UNION_EXPLAIN:setEnabled(false)
	_layoutMain.BTN_AWAKE:setEnabled(false)
	--切换副本
	_layoutMain.BTN_NORMAL:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then 
				AudioHelper.playTabEffect()
				copyAwakeCtrl.toCopyMap()
			end 
		end)
	_enterenceCopy = _layoutMain.LAY_COPY
	_enterenceCopy:setPositionType(POSITION_ABSOLUTE)
	_enterenceCopy:setVisible(false)
	updateUI()
	local entceItemData=DB_Disillusion_copy.getDataById(_curOpenedCopy)
	setMapBackground() --加载背景
	--缩放
	local scalenum=g_CopyBgRate1136-->1 and g_CopyBgRate1136 or 1
	_layoutMain.IMG_BG1:setScale(scalenum)
	local szOld = _layoutMain.SCV_MAIN:getInnerContainerSize()
	-- _layoutMain.SCV_MAIN:setInnerContainerSize(CCSizeMake(szOld.width*scalenum, szOld.height*scalenum)) -- 重新设置滚动区域size
	_layoutMain.SCV_MAIN:setInnerContainerSize(CCSizeMake(entceItemData.scv_area*scalenum, szOld.height*scalenum)) -- 重新设置滚动区域size
	
	--迷雾定位
	_layoutMain.IMG_FOG_SAMPLE:setPositionType(POSITION_ABSOLUTE)
	_layoutMain.IMG_FOG_SAMPLE:setPosition(ccp(entceItemData.scv_area,_layoutMain.IMG_FOG_SAMPLE:getPositionY()))


	local imgMengban = _layoutMain.IMG_MENGBAN
	local mengbanSceleX=(g_winSize.width+400)/(imgMengban:getContentSize().width/(imgMengban:getContentSize().width*scalenum))
	imgMengban:setScale(mengbanSceleX)

	imgMengban:ignoreContentAdaptWithSize(true)
	imgMengban:setPositionType(POSITION_ABSOLUTE)
	local function updateEliteMengban()
		local bgPos = imgMengban:convertToWorldSpace(ccp(0,0))
		if (bgPos.x~=-200) then
			imgMengban:setPosition(ccp(imgMengban:getPositionX()-bgPos.x-200,imgMengban:getPositionY()))
		end
	end
	updateEliteMengban()
	schedule(imgMengban,updateEliteMengban,0.01)
	imgMengban:setVisible(true)

	_layoutMain.BTN_CHANGE_MAP:setEnabled(false) --地图传送阵，功能先不开发，先注掉。
	MainCopy.normalCopyAction("images/copy/copy_awake.png",_layoutMain)
	return _layoutMain
end
--定位滚动位置
function updateScvPostion()
	if (tonumber(_curOpenedCopy%100)>3) then
		logger:debug("enter SCV_MAIN jump")
		local scalenum=g_CopyBgRate1136-->1 and g_CopyBgRate1136 or 1
		local curNode = _layoutMain.IMG_BG1:getChildByTag(_curOpenedCopy)
		_layoutMain.SCV_MAIN:setJumpOffset(ccp(-curNode:getPositionX()*scalenum+400*scalenum,_layoutMain.SCV_MAIN:getJumpOffset().y))
		
	end
end
--更新界面
function updateUI()
	if (_layoutMain==nil) then
		return
	end
	drawEntrance() --画入口
	setFogLayer() --重新加载迷雾
	require "script/module/guide/GuideAwakeView"
   if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 7) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createAwakeGuide(8)
        _layoutMain.SCV_MAIN:setTouchEnabled(false)
    end
end

function create(...)
	return loadUI()
end

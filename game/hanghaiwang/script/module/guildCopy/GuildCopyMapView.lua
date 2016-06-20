-- FileName: GuildCopyMapView.lua
-- Author: liweidong
-- Date: 2015-06-01
-- Purpose: 公会副本地图
--[[TODO List]]

module("GuildCopyMapView", package.seeall)

-- UI控件引用变量 --
local _layoutMain=nil
local _enterenceCopy=nil --入口UI的复制
-- 模块局部变量 --
local _copyStartTag = 10000 --线路tag基数
local _copyLineTag = 1000 --线路tag增加
local _guildCopyWordId = 30000 --公会副本地图
local _curOpenedMaxCopy = 0 --当前开启过的最大copy 
local _curPenedCopyNum = 0  --当前开启过的副本数
local _zOrderYeqian = 100 --副本页签order
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GuildCopyMapView"] = nil
end

function moduleName()
    return "GuildCopyMapView"
end

--副本之间的连线显示
function fnLineToEntrance( from,to)
	require "db/DB_Legion_newcopy"
	local m_imgWorldBg = _layoutMain.IMG_BG1
	if (from and to) then
		local entanceFrom =  DB_Legion_newcopy.getDataById(from) 
		local entanceTo = DB_Legion_newcopy.getDataById(to) 
		from=from%100
		to=to%100
		local lineImg = "line_" .. from .. "_" .. to .. ".png"
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
				if (_curOpenedMaxCopy%100>=to) then
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
	local entceItemData=DB_Legion_newcopy.getDataById(_curOpenedMaxCopy)
	local mapInfo = DB_World.getDataById(_guildCopyWordId)
	if (mapInfo.world_pic) then
		if (mapInfo.world_num) then
			local worldNum = tonumber(mapInfo.world_num)
			for i=1,worldNum do
				if ((i-1)*1065<entceItemData.scv_area) then --没有超出可滑动区域
					_layoutMain["IMG_BG1_"..i]:loadTexture("images/copy/world/" .. mapInfo.world_pic .. "/" .. i .. ".jpg")
				end
			end
		end
	end
end
-- 显示迷雾
function setFogLayer( ... )
	-- local mapInfo = DB_World.getDataById(_guildCopyWordId)
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
	-- if (_curOpenedMaxCopy==0) then
	-- 	setFog("fog1")
	-- else
	-- 	for i,value in pairs(fogArr) do
	-- 		local idbgArr = lua_string_split(value,",")
	-- 		if (#idbgArr == 2) then
	-- 			if ( tonumber(idbgArr[1]) == tonumber(_curOpenedMaxCopy)) then
	-- 				setFog(idbgArr[2])
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end
end
--画入口
function drawEntrance()
	require "script/module/guildCopy/GuildCopyModel"
	require "db/DB_Legion_newcopy"
	require "db/DB_World"
	
	local worldDb = DB_World.getDataById(_guildCopyWordId)
	local copyIds = lua_string_split(worldDb.legion_id, "|")
	local curCopyPt = 0
	local lastEntranceIdUse=0
	for k,v in ipairs(copyIds) do
		local cross = GuildCopyModel.getCopyOpenStatus(v)
		if (cross==1) then
			curCopyPt = curCopyPt + 1
			_curOpenedMaxCopy=tonumber(v)
		end
		if(cross==1 or (curCopyPt+1 == tonumber(k))) then
			if(_layoutMain.IMG_BG1:getChildByTag(v) ~= nil) then
				_layoutMain.IMG_BG1:removeChildByTag(v,true)
			end
			local entceItemData=DB_Legion_newcopy.getDataById(v)
			local copyPosition = lua_string_split(entceItemData.position,",")
			local itemCopy_ = _enterenceCopy:clone()
			itemCopy_:setTag(v)
			itemCopy_:setPosition(ccp(copyPosition[1], copyPosition[2]))
			if (v%100==20) then
				_layoutMain.IMG_BG1:addChild(itemCopy_,10)
			else
				_layoutMain.IMG_BG1:addChild(itemCopy_,9)
			end
			
			
			if (itemCopy_.BTN_COPY1) then
				itemCopy_.BTN_COPY1:setTag(v)
				itemCopy_.BTN_COPY1:addTouchEventListener(GuildCopyMapCtrl.onClickEnterence)
				if (curCopyPt < tonumber(k)) then
					itemCopy_.BTN_COPY1:loadTextureNormal("images/copy/ncopy/entranceimage/disableImg/copy_a_"..entceItemData.image)
					itemCopy_.BTN_COPY1:loadTexturePressed("images/copy/ncopy/entranceimage/disableImg/copy_a_"..entceItemData.image)
					itemCopy_.IMG_CPNAME_SAMPLE:loadTexture("images/copy/ncopy/worldnameimage/copy_name_a_bg.png")
				else
					itemCopy_.BTN_COPY1:loadTextureNormal("images/copy/ncopy/entranceimage/normalImg/copy_n_"..entceItemData.image)
					itemCopy_.BTN_COPY1:loadTexturePressed("images/copy/ncopy/entranceimage/selectedImg/copy_h_"..entceItemData.image)
					-- if (curCopyPt+1 == tonumber(k)) or (curCopyPt==#copyArr and tonumber(k)==#copyArr) then
					-- 	runBeatAction(itemCopyBtn)
					-- 	fnShowCopyShip(v,1)
					-- 	IMG_CPNAME_SAMPLE:loadTexture("images/copy/light_ncopy.png")
					-- 	curCopyItemName=IMG_CPNAME_SAMPLE
					-- 	curScrolInerWidth=entceItemData.scv_area
					-- end
				end
			end
			--进度
			local percent = GuildCopyModel.getProgressOfCopy(v)
			percent = (percent > 100) and 100 or percent
			itemCopy_.LOAD_PROGRESS:setPercent(percent)
			itemCopy_.TFD_PROGRESS:setText(percent.."%")
			itemCopy_.IMG_PROGRESS_BG:setVisible(cross==1)
			if (v%100==15) then
				itemCopy_.IMG_PROGRESS_BG:setPositionType(POSITION_ABSOLUTE)
				itemCopy_.IMG_PROGRESS_BG:setPosition(ccp(itemCopy_.IMG_PROGRESS_BG:getPositionX(),itemCopy_.IMG_PROGRESS_BG:getPositionY()-30))
			end
			--副本名称图片和坐标
			itemCopy_.IMG_CPNAME_SAMPLE:setPositionType(POSITION_ABSOLUTE)
			local pos = lua_string_split(entceItemData.name_position,",")
			itemCopy_.IMG_CPNAME_SAMPLE:setPosition(ccp(tonumber(pos[1]),tonumber(pos[2])))
			itemCopy_.IMG_COPY_NAME:loadTexture("images/copy/ncopy/worldnameimage/copy_name_".. entceItemData.name_graph)
			logger:debug("item info: " .. pos[1] .." " .. pos[2] .. ";" .."images/copy/ncopy/worldnameimage/copy_name_".. entceItemData.name_graph)
			-- if (curCopyItemName) then
			-- 	setCurNameEffect(curCopyItemName,1) --当前副本特效
			-- end

			--显示路线
			if (tonumber(lastEntranceIdUse) ~= 0) then
				fnLineToEntrance(lastEntranceIdUse,entceItemData.id)
			end
			lastEntranceIdUse=v
			
		end
	end
	_curPenedCopyNum = curCopyPt
end
--国际化
function setUIStyleAndI18n(base)
	base.BTN_RECORD:setTitleText(m_i18n[5930])
	base.BTN_BACK:setTitleText(m_i18n[1019])
	base.TFD_SOLDIER_LEVEL:setText(m_i18n[1067])
	base.tfd_soldier_con:setText(m_i18n[3708])
	base.tfd_active:setText(m_i18n[5931])
	base.tfd_soldier_title:setText(m_i18n[5955])

	UIHelper.titleShadow(base.BTN_RECORD)
	UIHelper.titleShadow(base.BTN_BACK)

	UIHelper.labelNewStroke( base.tfd_soldier_title, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_SOLDIER_LV, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_SOLDIER_LEVEL, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_soldier_con, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.tfd_active, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_SOLDIER_CON_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_SOLDIER_CON_SLANT, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_SOLDIER_CON_NUM2, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_ACTIVE_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_ACTIVE_SLANT, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_ACTIVE_NUM2, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_PROGRESS, ccc3(0x28,0x00,0x00), 2 )
end
--加载UI
function loadUI()
	_layoutMain = g_fnLoadUI("ui/copy_union_world.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				-- local curModuleName = LayerManager.curModuleName()
				-- local retainLayer = DropUtil.checkLayoutIsRetain( curModuleName,_layoutMain)
				-- if (not retainLayer) then
				local changeModuleType = LayerManager.getChangModuleType()
				if (changeModuleType and changeModuleType == 1) then
					return
				end
				_layoutMain=nil
				_enterenceCopy:release()
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
	topCopyTagLayer.BTN_AWAKE:setEnabled(false)
	--切换副本
	_layoutMain.BTN_NORMAL:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then 
				AudioHelper.playCommonEffect()
				GuildCopyMapCtrl.onNormallCoyp()
			end 
		end)
	--说明按钮
	_layoutMain.BTN_UNION_EXPLAIN:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then 
				AudioHelper.playCommonEffect()
				GuildCopyMapCtrl.onExplore()
			end 
		end)
	
	_layoutMain.BTN_RECORD:addTouchEventListener(GuildCopyMapCtrl.onSharedRecord)
	_layoutMain.BTN_BACK:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then 
				AudioHelper.playCloseEffect()
				GuildCopyMapCtrl.onReturnGuild()
			end 
		end)
	_enterenceCopy = _layoutMain.LAY_COPY
	_enterenceCopy:removeFromParent()
	_enterenceCopy:setPositionType(POSITION_ABSOLUTE)
	_enterenceCopy:retain()
	updateUI()
	setMapBackground() --加载背景
	LayerManager.changeModule(_layoutMain, moduleName(), {3}, true)
	-- PlayerPanel.addForActivityCopy()
	PlayerPanel.addForCopy()
	local entceItemData=DB_Legion_newcopy.getDataById(_curOpenedMaxCopy)
	--迷雾定位
	_layoutMain.IMG_FOG_SAMPLE:setPositionType(POSITION_ABSOLUTE)
	_layoutMain.IMG_FOG_SAMPLE:setPosition(ccp(entceItemData.scv_area,_layoutMain.IMG_FOG_SAMPLE:getPositionY()))
	--缩放
	local scalenum=g_CopyBgRate1136-->1 and g_CopyBgRate1136 or 1
	_layoutMain.IMG_BG1:setScale(scalenum)
	local szOld = _layoutMain.SCV_MAIN:getInnerContainerSize()
	_layoutMain.SCV_MAIN:setInnerContainerSize(CCSizeMake(entceItemData.scv_area*scalenum, szOld.height*scalenum)) -- 重新设置滚动区域size
	--定位
	if (tonumber(_curPenedCopyNum)>3) then
		local curNode = _layoutMain.IMG_BG1:getChildByTag(_curOpenedMaxCopy)
		_layoutMain.SCV_MAIN:setJumpOffset(ccp(-curNode:getPositionX()*scalenum+400*scalenum,_layoutMain.SCV_MAIN:getJumpOffset().y))
	end
end
--更新界面
function updateUI()
	drawEntrance() --画入口
	setFogLayer() --重新加载迷雾
	--等级
	_layoutMain.TFD_SOLDIER_LV:setText(GuildDataModel.getGuildCopyLv())
	local ownDonate = GuildDataModel.getGuildDonate()
	local needDonate = GuildUtil.getCopyNeedExpByLv(tonumber(GuildDataModel.getGuildCopyLv()) + 1 )
	
	_layoutMain.TFD_SOLDIER_CON_NUM:setText(ownDonate)
	_layoutMain.TFD_SOLDIER_CON_NUM2:setText(needDonate) --(string.format("%d/%d",needDonate,ownDonate))
	_layoutMain.TFD_ACTIVE_NUM:setText(GuildCopyModel.getActitveyNum()) --(GuildCopyModel.getActitveyNum().."/"..GuildCopyModel.getActivtiyMaxNum())
	_layoutMain.TFD_ACTIVE_NUM2:setText(GuildCopyModel.getActivtiyMaxNum())
end
function create(...)
	loadUI()
	MainCopy.normalCopyAction("images/copy/copy_union.png",_layoutMain)
end

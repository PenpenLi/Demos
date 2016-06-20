-- FileName: MainMineView.lua
-- Author: zhangqi
-- Date: 2015-04-10
-- Purpose: 资源矿主界面UI
--[[TODO List]]
MainMineView = class("MainMineView")

require "db/DB_Res"
require "db/DB_Normal_config"
require "script/network/RequestCenter"
require "script/module/public/GlobalNotify"
require "script/module/mine/MineConst"
require "script/module/mine/MineUtil"
require "script/utils/NewTimeUtil"

-- 模块局部变量 --
local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName
local DB_Res 		= DB_Res
local _nTime		= TimeUtil
local MineModel		= MineModel
local MineUtil		= MineUtil
local MineConst		= MineConst
local _tagShipEffect = 12
local _tagShip		= 11
local _bgEffect		= nil
local _guideEffect  = nil
local _curPageBtn	= nil
local kUseNewListView = true
local _scrollTime	= 0.5
local _listOffset	= nil

----------------- 控件 -------------------
local _mainLayer = nil
----------------- 控件 -------------------
local _controllerDelegate = nil 	-- controller委托

----------------- 常量 -------------------
local MINE_NUM			= 5 -- 每一页的矿坑数量
local SCHEDULE_UPDATE	= "MainMineView-Update"	
local _tbColor			= {
	Mine_Have	= ccc3(0xff, 0xff, 0xff),
	Mine_Empty	= ccc3(0xff, 0x00, 0x00),
	Stroke 		= ccc3(0x28, 0x00, 0x00),
}
----------------- 常量 -------------------

function showMailTip( ... )
	local tipNode = _mainLayer.BTN_MAIL.IMG_RED
	if(not tipNode:getNodeByTag(10)) then
		local tipAni = UIHelper.createRedTipAnimination()
		tipAni:setTag(10)
		tipNode:addNode(tipAni,10)
	end
	tipNode:setVisible(true)
end

-- 奖励按钮可见性
function setRewardBtnEnabled()
	if (MineModel.getGainInfo().nSilver <= 0 and MineModel.getGainInfo().nWood) then
		_mainLayer.BTN_GET:setVisible(false)
		_mainLayer.BTN_GET:setTouchEnabled(false)
	else
		_mainLayer.BTN_GET:setVisible(true)
		_mainLayer.BTN_GET:setTouchEnabled(true)

		-- 领取资源的特效
		_mainLayer.BTN_GET:removeAllNodes()
		_mainLayer.BTN_GET:setTouchEnabled(true)
		if (_mainLayer.BTN_GET:getNodeByTag(1) == nil) then
			local btnGetArmature = UIHelper.createArmatureNode({
					filePath = MineModel.getEffectPath("reward"),
					animationName = "res_reward",
					loop = 1,
				})	
			_mainLayer.BTN_GET:addNode(btnGetArmature, 1)
			btnGetArmature:setTag(1)
		end
	end
end

-- 清空个人矿坑信息
function clear_Self( ... )
	local layers = {_mainLayer.lay_nor_res, _mainLayer.lay_gold_res}
	for k, layer in pairs(layers) do
		layer.LABN_UP:setStringValue("0")
		layer.TFD_RES_SITUATION:setText(m_i18n[5604])	-- "未开采"
		layer.TFD_RES_SITUATION:setColor(_tbColor.Mine_Empty)
		UIHelper.labelNewStroke(layer.TFD_RES_SITUATION, _tbColor.Stroke, 2)
		layer.LOAD_PROGRESS:setPercent(0)
		layer.TFD_PROGRESS:setVisible(false)
		UIHelper.labelNewStroke(layer.TFD_PROGRESS, _tbColor.Stroke, 2)

		local normalFile = "images/resource/small_res/res_empty.png"
		layer.BTN_NOR_RES:loadTextures(normalFile, normalFile, normalFile)
	end
end

-- 清空资源矿的显示
function clear_Mine( ... )
	for i = 1, MINE_NUM do
		local layer = m_fnGetWidget(_mainLayer.lay_res, "LAY_RES_"..i)
		layer.TFD_NAME:setText(m_i18n[5667]) -- yucong_todo
		layer.TFD_UNIONS:setVisible(false)
		layer.IMG_UNIONS_ARROW:setVisible(false)
		-- UIHelper.labelNewStroke(layer.TFD_NAME, _tbColor.Stroke, 2) -- 2016-3-11描边又注掉了
		-- UIHelper.labelNewStroke(layer.TFD_UNIONS, _tbColor.Stroke, 2) -- 2016-3-11描边又注掉了

		local normalFile = MineModel.getHelperPeopleImg() --"images/resource/people/res_people_1.png"
		layer.IMG_PUBLIC_PEOPLE_1:loadTexture(normalFile)
		layer.IMG_PUBLIC_PEOPLE_2:loadTexture(normalFile)
		layer.IMG_PUBLIC_PEOPLE_3:loadTexture(normalFile)
		layer.img_add_bg:setVisible(false)

		layer.img_ship:setVisible(false)
	end
end

function refreshLsv( lsv, idx )
		--logger:debug("refresh:"..idx)
		local resInfo = MineModel.getDBMineInfo()[idx + 1]
		local cell = lsv:getItem(idx).item
		--lsv:pushBackDefaultItem()
		local label = tolua.cast(cell.BTN_TAB:getTitleTTF(), "CCLabelTTF")
		--logger:debug("xxxxx:"..label:getString())
		label:setString(tostring(idx + 1))
		label:setColor(ccc3(0xBA, 0x4A, 0x00))
		-- 页面切换添加事件
		cell.BTN_TAB:addTouchEventListener(onSwitchPage)
		cell.BTN_TAB:setTag(tonumber(idx + 1))

		if (MineModel.getPage() == idx + 1) then
			if (_curPageBtn) then
				_curPageBtn:setFocused(false)
				_curPageBtn:setTouchEnabled(true)
				_curPageBtn = nil
			end
			_curPageBtn = cell.BTN_TAB
			_curPageBtn:setFocused(true)
			_curPageBtn:setTouchEnabled(false)
		else
			cell.BTN_TAB:setFocused(false)
			cell.BTN_TAB:setTouchEnabled(true)
		end
	end

-- 重新加载改区域的一键找矿类型
function reload_FindMine( ... )
	local layer = _mainLayer.lay_bottom_btn
	layer.IMG_FIND_BG:setEnabled(false) -- 一键找矿选择面板默认不显示

	-- 获取当前区域的探索类型
	local tTypes = MineModel.getDBExploreInfo()[MineModel.getArea()]
	logger:debug(tTypes)
	for k, type in pairs(tTypes) do
		logger:debug(type)
		type = tonumber(type)
		-- local labName = m_fnGetWidget(layer.IMG_FIND_BG, "TFD_FIND_" .. k)
		-- labName:setText(MineUtil.getMineTypeDescribe(type))

		local btn = m_fnGetWidget(layer.IMG_FIND_BG, "BTN_FIND_" .. k)
		local img = MineModel.getMineImg(type)
		btn:loadTextures(img, img, img)
		-- 1.类型1、2、3、4的缩放比例为55%
		-- 2.类型5、6、7、8的缩放比例为45%
		if (type == 1 or type == 2 or type == 3 or type == 4) then
			btn:setScale(0.55)
		elseif (type == 5 or type == 6 or type == 7 or type == 8) then
			btn:setScale(0.45)
		end
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				removeGuideEffect()
				_controllerDelegate.getExplorePit(type)
			end
		end)
	end
end

-- 重新加载矿山的显示图
function reload_Mine_Display( ... )
	-- 更新资源矿类型的显示
	for i = 1, 5 do
		local info = MineModel.getDBMineInfo()[MineModel.getPage()]
		local numType = info["res_type"..tostring(i)]
		local mineFile = MineModel.getMineImg(numType, false)--"images/resource/normal_res/"..tostring(info["res_icon"..tostring(i)])
		logger:debug(mineFile)
		local layer = m_fnGetWidget(_mainLayer.lay_res, "LAY_RES_"..tostring(i))
		layer.BTN_RES_1:setTag(i)
		layer.BTN_RES_1:addTouchEventListener(onCheckMine)

		local mineEffect = UIHelper.createArmatureNode({
							filePath = MineModel.getEffectPath( "island" , numType ),
							animationName = MineModel.getEffectName(numType),
							bRetain = true,
						})
		local waterEffect = UIHelper.createArmatureNode({
							filePath = MineModel.getEffectPath( "island" , "shui" ),
							animationName = MineModel.getEffectName(numType , "shui"),
							bRetain = true,
						})

		local preEffect = layer.BTN_RES_1:getNodeByTag(i + 100)
		if (preEffect) then
			logger:debug({preEffect = preEffect})
			layer.BTN_RES_1:removeNodeByTag(i+100)
		end
		layer.BTN_RES_1:addNode(mineEffect,2)
		mineEffect:setTag(i + 100)
		local preWater = layer.BTN_RES_1:getNodeByTag(i + 200)
		if (preWater) then
			layer.BTN_RES_1:removeNodeByTag(i+200)
			layer.BTN_RES_1:addNode(waterEffect,1)
			waterEffect:setTag(i + 200)
		else
			layer.BTN_RES_1:addNode(waterEffect,1)
			waterEffect:setTag(i + 200)
		end

		layer.img_add_bg:setVisible(false)
	end
end

-- 加载listview内部组件
function reload_LSV()
	if (kUseNewListView) then
		UIHelper.reloadListView(_mainLayer.LSV_TAB, #MineModel.getDBMineInfo(), refreshLsv)
	else
		_mainLayer.LSV_TAB:removeAllItems()
		for k, resInfo in pairs(MineModel.getDBMineInfo()) do
			_mainLayer.LSV_TAB:pushBackDefaultItem()
			local cell = _mainLayer.LSV_TAB:getItem(tonumber(k) - 1)
			local label = tolua.cast(cell.BTN_TAB:getTitleTTF(), "CCLabelTTF")
			label:setString(tostring(k))
			label:setColor(ccc3(0xBA, 0x4A, 0x00))
			-- 页面切换添加事件
			cell.BTN_TAB:addTouchEventListener(onSwitchPage)
			cell.BTN_TAB:setTag(tonumber(k))
		end
	end

	_mainLayer.LSV_TAB:jumpToLeft()
end

-- 根据数据加载个人的矿山
function reload_SelfWithData( tbData, layer, isHelp )
	for i = 1, 3 do
		local peopleIMG = m_fnGetWidget(layer, "IMG_PEOPLE_"..i)
		local hUid = nil
		if (table.isEmpty(tbData) == false) then
			local guards = tbData.arrGuard[i] or {}
			hUid = table.isEmpty(guards) and nil or guards.uid
		end
		local imgFile = MineModel.getHelperPeopleImg(hUid)
		peopleIMG:loadTexture(imgFile)
	end

	if (table.isEmpty(tbData)) then
		layer.img_add_bg:setVisible(false)
		return
	elseif (MineModel.convertDomainToArea(tonumber(tbData.domain_id)) ~= MineModel.AREA_GOLD) then
		layer.img_add_bg:setVisible(true)
	end
	-- yucong 2015-12-9 隐藏控件
	layer.img_add_bg:setVisible(false)

	-- 已占领时间的百分比
	local passPercent, strTime = MineUtil.getPassPercent(tbData, isHelp)
	-- 协助军提升的百分比
	local fPercent = MineModel.calc_armyPercent(#tbData.arrGuard)
	layer.LABN_UP:setStringValue(fPercent)
	local txt = isHelp and m_i18n[5603] or m_i18n[5602] --isHelp and "已协助" or "已占领"
	layer.TFD_RES_SITUATION:setText(txt)	--yucong_todo
	layer.TFD_RES_SITUATION:setColor(_tbColor.Mine_Have)
	--local strTime = MineUtil.getPitOccupyTimeStr(tbData)
	layer.TFD_PROGRESS:setText(math.floor(passPercent).."%")
	layer.TFD_PROGRESS:setVisible(true)
	--layer.TFD_RES_TIME:setText(strTime)
	--layer.TFD_RES_TIME:setVisible(true)
	layer.LOAD_PROGRESS:setPercent(passPercent)
	local data = DB_Res.getDataById(tbData.domain_id)
	local btnFile = MineModel.getMineImg(data["res_type"..tostring(tbData.pit_id)], true, passPercent)
	layer.BTN_NOR_RES:loadTextures(btnFile, btnFile, btnFile)
end

-- 加载个人矿山信息
function reload_Self()
	logger:debug("reload_Self")

	clear_Self()

	local tbSelfInfo = MineModel.getSelfInfo()
	-- normal
	if (table.isEmpty(tbSelfInfo.tNormal) == false) then
		reload_SelfWithData(tbSelfInfo.tNormal, _mainLayer.lay_nor_res, false)
	else
		reload_SelfWithData(tbSelfInfo.tHelp, _mainLayer.lay_nor_res, true)
	end
	-- gold
	reload_SelfWithData(tbSelfInfo.tGold, _mainLayer.lay_gold_res, false)

	setSelfShip()
end

-- 设置自己矿的小船
function setSelfShip( ... )
	-- 查看矿坑如果是自己的，则增加小船
	local tbSelfInfo = MineModel.getSelfInfo()
	if (not table.isEmpty(tbSelfInfo.tNormal)) then
		setSelfShipWithData(tbSelfInfo.tNormal)
	end
	if (not table.isEmpty(tbSelfInfo.tGold)) then
		setSelfShipWithData(tbSelfInfo.tGold)
	end
end

function setSelfShipWithData( tbData )
	local domainId = tbData.domain_id
	local area = MineModel.convertDomainToArea(tonumber(domainId))
	local page = MineModel.convertDomainToPage(tonumber(domainId))
	-- 如果切换的区域与当前区域不一样，则重新读取区域数据
	if (MineModel.getArea() == area and MineModel.getPage() == page) then
		--logger:debug("这一页第"..tbData.pit_id.."个时自己的")
		local layer = m_fnGetWidget(_mainLayer.lay_res, "LAY_RES_"..tostring(tbData.pit_id))
		local shipImg = layer.img_ship:getChildByTag(_tagShip) --
		if (not shipImg) then
			shipImg = MineModel.getShipTinyImg()
			shipImg:setPosition(ccp(0, 0))
			shipImg:setTag(_tagShip)
			shipImg:runAction(MineModel.getShipEffect()) --MineModel.getShipEffect()
			layer.img_ship:addChild(shipImg)
		end
		local effect = layer.img_ship:getNodeByTag(_tagShipEffect)
		if (not effect) then
			effect = MineModel.getShipWaveEffect()
			effect:setPosition(ccp(0, 0))
			effect:setTag(_tagShipEffect)
			layer.img_ship:addNode(effect, -1)
		end
		layer.img_ship:setZOrder(3)
		layer.img_ship:setVisible(true)
	end
end

-- 刷新资源矿的显示
function reload_Mine()
	logger:debug("reload_Mine")
 
	clear_Mine()
	local gid, gname, count = MineModel.isHaveGCImprove()
	logger:debug("GC ID:"..(gid or "null"))
	logger:debug("GC NAME:"..(gname or "null"))
	logger:debug("GC NUM:"..(count or "null"))
	for k, v in pairs(MineModel.getOccupyInfo()) do
		--assert(tonumber(v.domain_id) == tonumber(MineModel.getDBMineInfo()[MineModel.getPage()].id), "reload_Mine:DomainID is not cur Page")
		if (tonumber(v.domain_id) ~= tonumber(MineModel.getDBMineInfo()[MineModel.getPage()].id)) then
			--assert(false, "MainMineView：当前占领信息与当前页面不匹配")
			-- 当发现数据与页码不匹配时，自动跳转到数据指定的页码
			-- switchPage(MineModel.convertDomainToPage(tonumber(v.domain_id)))
			logger:debug("MainMineView：当前占领信息与当前页面不匹配")
			return
		end

		local layer = m_fnGetWidget(_mainLayer.lay_res, "LAY_RES_"..tostring(v.pit_id))
		-- 人物等级和人名
		local txt = string.format(m_i18n[1813].." %s", tostring(v.level), v.uname)
		layer.TFD_NAME:setText(txt)
		layer.TFD_NAME:setVisible(true)
		-- 公会名
		if (v.guild_id ~= nil and tonumber(v.guild_id) ~= 0) then
			layer.TFD_UNIONS:setText("["..v.guild_name.."]")
			layer.TFD_UNIONS:setVisible(true)
			-- 公会加成
			if (gid and gid == tonumber(v.guild_id)) then
				layer.IMG_UNIONS_ARROW:setVisible(true)
				layer.IMG_UNIONS_ARROW:setPositionType(0)
				layer.IMG_UNIONS_ARROW:setPositionX(layer.TFD_UNIONS:getPositionX() + layer.TFD_UNIONS:getSize().width/2 + layer.IMG_UNIONS_ARROW:getSize().width/2)
			end
		end
		-- 小人显示
		for k1, guards in pairs(v.arrGuard or {}) do
			local peopleIMG = m_fnGetWidget(layer, "IMG_PUBLIC_PEOPLE_"..k1)
			local imgFile = MineModel.getHelperPeopleImg(guards.uid) 
			peopleIMG:loadTexture(imgFile)
		end
		
		-- 百分比
		local fPercent = MineModel.calc_armyPercent(#v.arrGuard)
		layer.LABN_UP:setStringValue(fPercent)

		if (MineModel.convertDomainToArea(tonumber(v.domain_id)) ~= MineModel.AREA_GOLD) then
			layer.img_add_bg:setVisible(true)
		end
		-- yucong 2015-12-9 隐藏控件
		layer.img_add_bg:setVisible(false)
	end

	-------------- listView 偏移量 ------------------
	local lsv = _mainLayer.LSV_TAB
	lsv:visit()
	local isRun = isRun(_mainLayer.LSV_TAB, MineModel.getPage())
	if (not _isAutoScroll and not isRun) then
		--lsv:setJumpOffset(UIHelper.calc_lsvOffset(lsv, MineModel.getPage()))
		UIHelper.reloadListView(_mainLayer.LSV_TAB, #MineModel.getDBMineInfo(), refreshLsv, MineModel.getPage() - 1)
	end

	if (gid) then
		_mainLayer.lay_txt_1:setVisible(false)
		_mainLayer.lay_txt_2:setVisible(true)
		local bsize = CCSizeMake(_mainLayer.tfd_2_2:getSize().width, _mainLayer.tfd_2_2:getSize().height)
		_mainLayer.lay_txt_2.tfd_2_2:setText("["..gname.."]")
		local esize = CCSizeMake(_mainLayer.tfd_2_2:getSize().width, _mainLayer.tfd_2_2:getSize().height)
		local delta = bsize.width - esize.width
		_mainLayer.tfd_2_1:setPositionType(0)
		_mainLayer.tfd_2_1:setPositionX(_mainLayer.tfd_2_1:getPositionX() + delta/2)

		_mainLayer.lay_txt_2.tfd_2_2:setPositionType(0)
		_mainLayer.lay_txt_2.tfd_2_2:setPosition(ccp(_mainLayer.lay_txt_2.tfd_2_1:getPositionX() + _mainLayer.lay_txt_2.tfd_2_1:getSize().width/2 + _mainLayer.lay_txt_2.tfd_2_2:getSize().width/2, _mainLayer.lay_txt_2.tfd_2_2:getPositionY()))
		_mainLayer.lay_txt_2.tfd_2_3:setPositionType(0)
		_mainLayer.lay_txt_2.tfd_2_3:setPosition(ccp(_mainLayer.lay_txt_2.tfd_2_2:getPositionX() + _mainLayer.lay_txt_2.tfd_2_2:getSize().width/2 + _mainLayer.lay_txt_2.tfd_2_3:getSize().width/2, _mainLayer.lay_txt_2.tfd_2_3:getPositionY()))

		_mainLayer.lay_txt_2.tfd_2_5:setText(count..m_i18n[3575])
	else
		_mainLayer.lay_txt_1:setVisible(true)
		_mainLayer.lay_txt_2:setVisible(false)
	end
end

-- 刷新界面和数据
function reload( ... )
	-- 获取资源区信息
	_controllerDelegate.getInfoByDomainId(MineModel.getPage())
	_controllerDelegate.getSelfPitsInfo()
	--TimeUtil.timeStart("mineEffect") -- 500ms
	performWithDelayFrame(_mainLayer, function ( ... )
		-- 刷新当前页的矿山外形
		reload_Mine_Display()
		-- 初始化特效
		initEffect()
	end, 1)
	
	--TimeUtil.timeEnd("mineEffect")
end

-- 设置按钮的选中状态 1:页码 2:区域
function setBtnSelected( type )
	if (type == 1) then
		-- local count = _mainLayer.LSV_TAB:getItems():count()
		-- for i = 0, count - 1 do
		-- 	local cell = _mainLayer.LSV_TAB:getItem(i)
		-- 	if (cell) then
		-- 		cell.BTN_TAB:setFocused(cell.BTN_TAB:getTag() == MineModel.getPage())
		-- 		cell.BTN_TAB:setTouchEnabled(not (cell.BTN_TAB:getTag() == MineModel.getPage()))
		-- 	end
		-- end
	else
		local curArea = MineModel.getArea()
		local tbBtns = {_mainLayer.lay_bottom_btn.BTN_AREA_N, --[[_mainLayer.lay_bottom_btn.BTN_AREA_H,]] _mainLayer.lay_bottom_btn.BTN_AREA_G}
		for i, btn in ipairs(tbBtns) do
			btn:setFocused(btn:getTag() == curArea)
			btn:setTouchEnabled(not (btn:getTag() == curArea))
		end
	end
end

-- 跳转到指定区域
function switchArea( area, page )
	logger:debug("Area : "..tostring(area))
	local toPage = page or 1
	assert(area > 0 and area < 4, "switchArea:area not exist!")
	MineModel.setArea(area)
	-- 获取
	MineModel.handleDatas(MineModel.getArea())

	setBtnSelected(2)
	reload_LSV()
	reload_FindMine()
	switchPage(toPage)
end

-- 根据切换到指定domainId的区域
function switchAreaWithDomainId( domainId )
	local area = MineModel.convertDomainToArea(tonumber(domainId))
	local page = MineModel.convertDomainToPage(tonumber(domainId))
	-- 如果切换的区域与当前区域不一样，则重新读取区域数据
	if (MineModel.getArea() ~= area) then
		MineModel.handleDatas(area)
	end

	switchArea(area, page)
end

-- 跳转到指定的页面
function switchPage( index )
	logger:debug("switchPage "..tostring(index))
	if (_curPageBtn) then
		_curPageBtn:setFocused(false)
		_curPageBtn:setTouchEnabled(true)
		_curPageBtn = nil
	end
	local cell = _mainLayer.LSV_TAB:getItem(index - 1)
	if (kUseNewListView) then
		cell = cell.item
	end
	if (cell) then
		_curPageBtn = cell.BTN_TAB
		_curPageBtn:setFocused(true)
		_curPageBtn:setTouchEnabled(false)
	end

	MineModel.setPage(index)
	setBtnSelected(1)

	reload()
end

function checkMine( pitId )
	assert(pitId <= MINE_NUM and pitId > 0, "checkMine: pitId"..tostring(pitId).." not exist!")
	require "script/module/mine/MineInfoCtrl"
	-- domain_id 资源区id
	local domainId = MineModel.getCurDomainId()
	
	-- 已被占领的传入占领数据
	local tInfo = MineModel.getOccupyInfoWithId(domainId, pitId)
	
	if (tInfo == nil) then 	-- 空矿
		tInfo = {domain_id = domainId, pit_id = pitId}
	end

	local mineType = MineModel.getMineState(domainId, pitId, MineModel.getArea())
	logger:debug(tInfo)
	logger:debug(mineType)
	local layer = MineInfoCtrl.create(tInfo, mineType)
	LayerManager.addLayout(layer)
end

-- 切换区域 按钮事件
function onSwitchArea( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playTabEffect()
		removeGuideEffect()
		switchArea(sender:getTag())
	end
end

-- 切换页面回调 按钮事件
function onSwitchPage( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		removeGuideEffect()
		switchPage(sender:getTag())
	end
end

-- 矿位点击回调 按钮事件
function onCheckMine( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("jianglizhongxin.mp3")
		removeGuideEffect()
		checkMine(sender:getTag())
	end
end

-- 翻页
function onTurnPage( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (_isAutoScroll) then
			return
		end
		local count = #MineModel.getDBMineInfo()
		local cellWidth = _mainLayer.LSV_TAB:getInnerContainerSize().width / count
		local num = 0
		if (sender:getTag() == 1) then
			num = -math.min(6, MineModel.getPage() - 1)
		else
			num = math.min(6, count - MineModel.getPage())
		end
		if (num ~= 0) then
			local isRun = isRun(_mainLayer.LSV_TAB, MineModel.getPage())
			logger:debug(isRun)
			if (isRun) then
				_listOffset = math.min(_listOffset - cellWidth * num, 0)
				_mainLayer.LSV_TAB:setJumpOffset(ccp(_listOffset, 0))--, _scrollTime, false)
				--UIHelper.reloadListView(_mainLayer.LSV_TAB, #MineModel.getDBMineInfo(), refreshLsv, num - 1)
				_isAutoScroll = true
				performWithDelay(_mainLayer, function ( ... )
					_isAutoScroll = false
				end, _scrollTime)
			end
			switchPage(MineModel.getPage() + num)
		end
	end
end

function isRun( listView, aimPos )
	local cell = listView:getItem(aimPos - 1)
	local listPos=listView:getWorldPosition()
	local listRect=CCRectMake(listPos.x,listPos.y,listView:getViewSize().width,listView:getViewSize().height)
	local leftBorder = listRect.origin.x
	local rightBorder = listRect.origin.x + listView:getViewSize().width-- * listView:getScaleX()
	if cell then
		local cellPos=cell:getWorldPosition()
		local cellRight = cellPos.x+cell:getSize().width
		local cellLeft = cellPos.x

		-- 如果在cell 在 listview 外部 右边外部 左边外部不用处理
		if cellLeft >= rightBorder then
			return false
		end
		if cellRight <= leftBorder then
			return false
		end
		return true
	end
	return false
end

-- 计时器
function fnUpdate( ... )
	if (MineModel.getSelfInfo() == nil) then
		return
	end

	local isHelp = false
	local normalData = nil--MineModel.getSelfInfo().tNormal or MineModel.getSelfInfo().tHelp
	if (table.isEmpty(MineModel.getSelfInfo().tNormal) == false) then
		normalData = MineModel.getSelfInfo().tNormal
	elseif (table.isEmpty(MineModel.getSelfInfo().tHelp) == false) then
		normalData = MineModel.getSelfInfo().tHelp
		isHelp = true
	end
	local goldData = MineModel.getSelfInfo().tGold

	function setTime( data, layer, isH )
		if (table.isEmpty(data) == false) then
			local passPercent, Time = MineUtil.getPassPercent(data, isH)
			--local Time = MineUtil.getPitOccupyTimeStr(data)
			--local timeStr = _nTime.getTimeString(goldTime)
			layer.TFD_RES_TIME:setText(Time)
			layer.TFD_RES_TIME:setVisible(false)

			local info = DB_Res.getDataById(data.domain_id)
			local btnFile = MineModel.getMineImg(info["res_type"..tostring(data.pit_id)], true, passPercent)
			layer.BTN_NOR_RES:loadTextures(btnFile, btnFile, btnFile)
			layer.LOAD_PROGRESS:setPercent(passPercent)
			layer.TFD_PROGRESS:setText(math.floor(passPercent).."%")
		else
			layer.TFD_RES_TIME:setVisible(false)
		end
	end

	setTime(normalData, _mainLayer.lay_nor_res, isHelp)
	setTime(goldData, _mainLayer.lay_gold_res, false)
end

-- 通知事件与回调方法
function notifications( ... )
	return {
		[MineModel._MSG_.CB_GET_DOMAIN_INFO] 			= fnMSG_CB_GETDOMAIN,		-- 拉取矿区信息
		[MineModel._MSG_.CB_GET_SELFPITS] 			= fnMSG_CB_GETSELFPITS,		-- 拉取个人矿区信息
		[MineModel._MSG_.CB_EXPLORE] 					= fnMSG_CB_EXPLORE,			-- 一键找矿信息
		[MineModel._MSG_.CB_BROADCAST] 				= fnMSG_CB_BROADCAST,		-- 广播推送
		[MineModel._MSG_.CB_GETREWARD] 				= fnMSG_CB_GETREWARD,		-- 拉取奖励信息
		[MineModel._MSG_.CB_RECREWARD] 				= fnMSG_CB_RECREWARD,		-- 领取奖励
		[MineModel._MSG_.CB_PUSH_REWARD] 				= fnMSG_CB_PUSH_REWARD,		-- 奖励推送
		[MineModel._MSG_.CB_PUSH_MAIL_TIP]			= fnMSG_CB_PUSH_MAIL_TIP,	-- 邮件红点推送
		[MineConst.MineBattleEvt.MINE_BEGIN_BATTLE]	= fnMSG_MINE_BEGIN_BATTLE,	-- 战斗开始
		[MineConst.MineBattleEvt.MINE_END_BATTLE] 	= fnMSG_MINE_END_BATTLE,	-- 战斗结束
		[GlobalNotify.RECONN_OK] 					= fnMSG_RECONN_OK,			-- 重连成功
		[MineModel._MSG_.CB_SWITCH_AREA]				= fnCB_SWITCH_AREA,			-- 切换区域
	}
end

-- 设置controller委托
function MainMineView:setController( controller )
	assert(controller, "MainMineView:controller delegate is null!")
	_controllerDelegate = controller
end

function updateLsv( ... )
	-- 实时保存listview偏移
	--if (not _listOffset) then
		_listOffset = _mainLayer.LSV_TAB:getContentOffset()
	--end
end

------------------------- 初始化方法 -------------------------
function MainMineView:ctor(fnCloseCallback)
	_mainLayer = g_fnLoadUI("ui/resource_main.json")
	_mainLayer:retain()	-- 先拉取数据，创建完界面，再changeLayer
	_mainLayer.img_bg:setScaleX(g_fScaleX) -- 背景图适配
	_mainLayer.img_bg:setScaleY(g_fScaleY) -- 背景图适配
	local scheduleId = nil
	-- 注册onExit()
	UIHelper.registExitAndEnterCall(_mainLayer, function ( ... )
		GlobalScheduler.removeCallback(SCHEDULE_UPDATE)

		_controllerDelegate.removePushNotify()

		for msg, func in pairs(notifications()) do
			GlobalNotify.removeObserver(msg, msg)
		end
		if (scheduleId) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleId)
			scheduleId = nil
		end

		_mainLayer:release()
		_mainLayer = nil
		_bgEffect = nil
		_guideEffect = nil
		_curPageBtn = nil
    end, function ( ... )
    	-- 开启计时器
		GlobalScheduler.addCallback(SCHEDULE_UPDATE, fnUpdate)
		scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateLsv, 2/60, false)
    end)
	
	-- 添加监听
	self:addObserver()
end

function MainMineView:create(domainId, isCheckMine)
	-- 默认
	local area = MineModel.AREA_NORMAL
	local page = 1
	if (domainId) then
		-- 指定跳转到
		area = MineModel.convertDomainToArea(tonumber(domainId))
		page = MineModel.convertDomainToPage(tonumber(domainId))
	end
	logger:debug(domainId)
	-- 默认区域
	MineModel.setArea(area)
	MineModel.setPage(page)
	-- 是否默认打开某个矿坑
	MineModel.getSwitch().isCheckMine = isCheckMine or 0
	-- 获取区域DB数据
	MineModel.handleDatas(MineModel.getArea())
	-- 获取探索类型
	MineModel.handleExploreDatas()
	-- 获取矿坑类型数据
	MineModel.handlePitTypeInfo()
	-- 初始化框架
	self:initFrame()
	-- 进入指定页面
	switchArea(MineModel.getArea(), MineModel.getPage())	-- 默认显示普通矿区
	performWithDelay(_mainLayer, function ( ... )
		-- 拉取奖励信息
		_controllerDelegate.getSelfReward(false)
	end, 0.01)

	require "script/module/guide/GuideResView"
    if (GuideModel.getGuideClass() == ksGuideResource and GuideResView.guideStep == 2) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createResGuide(3,nil, nil, function (  )
        	GuideCtrl.removeGuide()
        end) 
    end 
	return _mainLayer
end

-- 注册通知事件
function MainMineView:addObserver( ... )
	for msg, func in pairs(notifications()) do
		GlobalNotify.addObserver(msg, func, false, msg)
	end
end

function MainMineView:initFrame( ... )
	self:initFloatAction()
	self:initTop()
	self:initMiddle()
	self:initAreaBtn()
end

-- 初始化一键找矿的选择面板
function MainMineView:initFindBar(  )
	reload_FindMine()
end

function MainMineView:initSelfMine( ... )
	function checkSelfMine( tInfo, mineType )
		if (tInfo == nil or table.isEmpty(tInfo)) then
			assert(false, "tInfo is null")
		end
		require "script/module/mine/MineInfoCtrl"
		local layer = MineInfoCtrl.create(tInfo, mineType)
		LayerManager.addLayout(layer)
		switchAreaWithDomainId(tInfo.domain_id)
	end
	function onTouch_Normal( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			removeGuideEffect()
			if (table.isEmpty(MineModel.getSelfInfo().tNormal) and table.isEmpty(MineModel.getSelfInfo().tHelp)) then
				local txt = MineModel.getArea() ~= MineModel.AREA_GOLD and m_i18n[5645] or m_i18n[5656]
				ShowNotice.showShellInfo(txt) --("你还没有占领或协助资源矿")
				return
			end
			local tInfo = nil--MineModel.getSelfInfo().tNormal or MineModel.getSelfInfo().tHelp
			if (not table.isEmpty(MineModel.getSelfInfo().tNormal)) then
				tInfo = MineModel.getSelfInfo().tNormal
			elseif (not table.isEmpty(MineModel.getSelfInfo().tHelp)) then
				tInfo = MineModel.getSelfInfo().tHelp
			end
			local mineType = MineModel.getMineState(tInfo.domain_id, tInfo.pit_id, MineModel.AREA_NORMAL)
			checkSelfMine(tInfo, mineType)
		end
	end
	function onTouch_Gold( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			removeGuideEffect()
			if (table.isEmpty(MineModel.getSelfInfo().tGold)) then
				--local txt = MineModel.getArea() == MineModel.AREA_GOLD and m_i18n[5644] or m_i18n[5643]
				switchArea(MineModel.AREA_GOLD)
				ShowNotice.showShellInfo(m_i18n[5644]) -- (txt)
				return
			end
			local tInfo = MineModel.getSelfInfo().tGold
			checkSelfMine(tInfo, MineConst.MineInfoType.MINE_SELF_GOLD)
		end
	end
	_mainLayer.lay_nor_res.BTN_NOR_RES:addTouchEventListener(onTouch_Normal)
	_mainLayer.lay_gold_res.BTN_NOR_RES:addTouchEventListener(onTouch_Gold)

	_mainLayer.lay_nor_res:addTouchEventListener(onTouch_Normal)
	_mainLayer.lay_gold_res:addTouchEventListener(onTouch_Gold)
	-- 不显示小人和增幅
	
	-- 隐藏时间
	_mainLayer.lay_nor_res.TFD_RES_TIME:setVisible(false)
	_mainLayer.lay_gold_res.TFD_RES_TIME:setVisible(false)
end

function MainMineView:initTop( ... )
	local layTop = m_fnGetWidget(_mainLayer, "lay_up_btn")

	self:initSelfMine()

	UIHelper.titleShadow(_mainLayer.BTN_BACK, m_i18n[1019])	-- 返回
	_mainLayer.BTN_BACK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			
			_controllerDelegate.leave()
		end
	end)

	-- 判断邮件红点是否显示
	if (g_redPoint.newMineMail.visible) then
		showMailTip()
	end
	--UIHelper.titleShadow(_mainLayer.BTN_MAIL, "邮 件") -- 邮件
	_mainLayer.BTN_MAIL:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("renwu.mp3")
			_mainLayer.BTN_MAIL.IMG_RED:setVisible(false)
			require "script/module/mine/MineMailCtrl"
			local layMail = MineMailCtrl.create()
  	 		LayerManager.changeModule(layMail, MineMailCtrl.moduleName(), {1, 3},true)
			PlayerPanel.addForActivityCopy()

		end
	end)

	--UIHelper.titleShadow(_mainLayer.BTN_FIND, m_i18n[1955] --[["一键找矿"]])
	_mainLayer.BTN_FIND:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			removeGuideEffect()
			local bShow = not _mainLayer.IMG_FIND_BG:isEnabled()
			_mainLayer.IMG_FIND_BG:setEnabled(bShow)
		end
	end)

	setRewardBtnEnabled()
	--UIHelper.titleShadow(_mainLayer.BTN_GET, m_i18n[5668])	-- 领取资源
	_mainLayer.BTN_GET:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			removeGuideEffect()
			_controllerDelegate.getSelfReward(true)
		end
	end)

	_mainLayer.lay_txt_1.tfd_1_1:setText(m_i18n[5680])--"同一页的资源岛被同一公会占领"
	_mainLayer.lay_txt_1.tfd_1_2:setText(m_i18n[5681])--"收益将有额外加成！"
	
	_mainLayer.lay_txt_2.tfd_2_1:setText(m_i18n[5682])--"该页的资源岛已被"
	_mainLayer.lay_txt_2.tfd_2_3:setText(m_i18n[5683])--"公会占领"
	_mainLayer.lay_txt_2.tfd_2_4:setText(m_i18n[5684])--"享受"
	_mainLayer.lay_txt_2.tfd_2_6:setText(m_i18n[5685])--"额外收益加成！"
end

-- 帮助页面
function MainMineView:showHelpDlg( ... )
	local layHelp = g_fnLoadUI("ui/resource_help.json")
	-- layHelp.TFD_DESC_TITLE:setText(m_i18n[2043])
	layHelp.tfd_desc:setText(m_i18n[5601])
	layHelp.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	
	LayerManager.addLayout(layHelp)
end

-- 初始化矿信息
function MainMineView:initMiddle( ... )
	_mainLayer.IMG_PAOMADENG:setVisible(false)

	--UIHelper.titleShadow(_mainLayer.BTN_HELP, m_i18n[2043])
	_mainLayer.BTN_HELP:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("renwu.mp3")
			removeGuideEffect()
			self:showHelpDlg()
			--fnMSG_CB_BROADCAST()
		end
	end)

	-- 初始化listview
	if (not kUseNewListView) then
		UIHelper.initListView(_mainLayer.LSV_TAB)
	else
		UIHelper.initListViewCell(_mainLayer.LSV_TAB)
	end
	_mainLayer.LSV_TAB:setScaleX(g_fScaleX)
	-- 开启裁切
	_mainLayer.LSV_TAB:setClippingEnabled(true)
	_mainLayer.LSV_TAB:setZOrder(1)

	_mainLayer.img_right:setTouchEnabled(true)
	_mainLayer.img_right:addTouchEventListener(onTurnPage)
	_mainLayer.img_right:setTag(2)
	_mainLayer.img_left:setTouchEnabled(true)
	_mainLayer.img_left:addTouchEventListener(onTurnPage)
	_mainLayer.img_left:setTag(1)
end

function MainMineView:initFloatAction( ... )
	_mainLayer.img_bg:runAction(MineModel.getFloatAction())
	_mainLayer.lay_res:runAction(MineModel.getFloatAction())
end

-- 拉取数据时初始化特效
function initEffect( ... )
	if (not _bgEffect) then
		_bgEffect = UIHelper.createArmatureNode({
			filePath = MineModel.getEffectPath("sea"),
			animationName = "res_sea",
			loop = 1,
			bRetain = true,
		})
		-- 背景特效
		_bgEffect:setAnchorPoint(ccp(_mainLayer.img_bg:getAnchorPoint().x, _mainLayer.img_bg:getAnchorPoint().y))
		_bgEffect:setPosition(ccp(_mainLayer.img_bg:getPositionX(), _mainLayer.img_bg:getPositionY()))
		_mainLayer:addNode(_bgEffect, -1)
		_mainLayer.img_bg:setZOrder(-2)
	end
end

function removeGuideEffect( ... )
	if (_guideEffect) then
		_guideEffect:Armature():setVisible(false)
	end
end

function addExploreEffect( pitId )
	if (not _guideEffect) then
		_guideEffect = EffGuide:new()
		_mainLayer:addNode(_guideEffect:Armature(),9999)
	end
	local layer = m_fnGetWidget(_mainLayer.lay_res, "LAY_RES_"..tostring(pitId))
	local pos = layer.BTN_RES_1:getWorldPosition()
	_guideEffect:Armature():setPosition(ccp(pos.x, pos.y))
	_guideEffect:Armature():setVisible(true)
end

-- ************************ 初始底部区域的控件 ************************
function MainMineView:initAreaBtn( ... )
	local tbNames	= {m_i18n[5605], m_i18n[5606], m_i18n[5607]} --{"普通区域", "高级区域", "金币区域"}
	local tbTags	= {MineModel.AREA_NORMAL, --[[MineModel.AREA_HIGH,]] MineModel.AREA_GOLD}
	local tbBtns	= {_mainLayer.lay_bottom_btn.BTN_AREA_N, --[[_mainLayer.lay_bottom_btn.BTN_AREA_H,]] _mainLayer.lay_bottom_btn.BTN_AREA_G}	
	for i, btn in ipairs(tbBtns) do
		--UIHelper.titleShadow(btn, tbNames[i])
		local label = tolua.cast(btn:getTitleTTF(), "CCLabelTTF")
		label:setString(tbNames[i])
		btn:setTag(tbTags[i])
		btn:addTouchEventListener(onSwitchArea)
	end
	local label = tolua.cast(_mainLayer.lay_bottom_btn.BTN_AREA_G:getTitleTTF(), "CCLabelTTF")
	label:setFlipX(false)
end

-- 后端数据获取完成的其他操作
function fnGetDataEnd( ... )
	--_controllerDelegate.replaceLayer()

	-- 刷新矿坑信息窗口
	if (MineModel.getSwitch().isReloadInfoView) then
		MineModel.getSwitch().isReloadInfoView = false
		-- 刷新mineinfoview
		_controllerDelegate.reloadMineInfoView()
	end
	-- 打开矿坑界面
	if (MineModel.getSwitch().isCheckMine > 0) then
		checkMine(MineModel.getSwitch().isCheckMine)
		MineModel.getSwitch().isCheckMine = 0
	end
end

------------------------- Notification 根据新数据刷新界面 -------------------------

-- 获取后端矿区信息后的通知
function fnMSG_CB_GETDOMAIN( ... )
	logger:debug("fnMSG_CB_GETDOMAIN")

	reload_Mine()
	-- 获取自己的信息
	--_controllerDelegate.getSelfPitsInfo()
end

-- 获取后端自己矿区信息后的通知
function fnMSG_CB_GETSELFPITS()
	logger:debug("fnMSG_CB_GETSELFPITS")

	reload_Self()

	fnGetDataEnd()
end

function fnMSG_CB_EXPLORE( ... )
	logger:debug("fnMSG_CB_EXPLORE")

	if (table.isEmpty(MineModel.getExploreInfo())) then
		ShowNotice.showShellInfo(m_i18n[5637]) --("当前没有空的资源矿")	-- yucong_todo
		return
	end
	ShowNotice.showShellInfo(m_i18n[5638]) --("找到空的资源矿，请尽快占领")
	switchAreaWithDomainId(MineModel.getExploreInfo().domain_id)

	addExploreEffect(tonumber(MineModel.getExploreInfo().pit_id))

	MineModel.setExploreInfo({})
end
-- 广播
function fnMSG_CB_BROADCAST( ... )
	logger:debug("fnMSG_CB_BROADCAST")

	local data = MineModel.getBroardcast() or {}
	logger:debug(data)
	if (table.isEmpty(data)) then
		return true
	end
	if (_mainLayer.lay_paomadeng.IMG_PAOMADENG:isVisible()) then
		return true
	end
	local tTxt, strTxt = MineModel.getBroardcastContent(data)

	local layer = _mainLayer.lay_paomadeng.IMG_PAOMADENG
	layer.TFD_PAOMADENG:setVisible(false)
	layer:setVisible(true)
 	_mainLayer.lay_paomadeng:setClippingEnabled(true)

	------- 创建富文本 --------
	local colors = {ccc3(0x4d, 0xec, 0x15), ccc3(255, 255, 255), ccc3(0x4d, 0xec, 0x15), ccc3(255, 255, 255), 
					ccc3(0xee, 0x46, 0xec), ccc3(255, 255, 255), ccc3(0xff, 0xf6, 0x00)}
	local tbColor = {}
	for k,v in pairs(colors) do
		local data = {color = v, font = g_sFontCuYuan, size = 20}
		table.insert(tbColor, data)
	end

 	-- 用于获取width
 	local label = CCLabelTTF:create(strTxt, g_sFontCuYuan, 20)
 	-- 数据源
 	local richStr =  UIHelper.concatString(tTxt)
 	local textInfo = {richStr, tbColor}

 	local richText = BTRichText.create(textInfo, nil, nil)
 	richText:setSize(label:getContentSize())
 	richText:setAnchorPoint(ccp(0, 0.5))
 	richText:setPosition(ccp(layer:getSize().width/2,layer.TFD_PAOMADENG:getPositionY()))
 	layer:addChild(richText)
 	-- 移动动作
 	local actionArray = CCArray:create()
  	actionArray:addObject(CCMoveBy:create(15*g_fScaleX, ccp(-label:getContentSize().width - layer:getSize().width, 0)))
  	actionArray:addObject(CCCallFunc:create(function ( ... )
  		layer:setVisible(false)
  		richText:removeFromParentAndCleanup(true)
  	end))
  	richText:runAction(CCSequence:create(actionArray))
end
-- 拉取奖励信息完成
function fnMSG_CB_GETREWARD( ... )
	logger:debug("fnMSG_CB_GETREWARD")
	setRewardBtnEnabled()
end
-- 领取奖励完成
function fnMSG_CB_RECREWARD( ... )
	logger:debug("fnMSG_CB_RECREWARD")
	--ShowNotice.showShellInfo("恭喜船长获得"..tostring(MineModel.getGainInfo().nSilver).."贝里")
	ShowNotice.showShellInfo(m_i18n[2073]..tostring(MineModel.getGainInfo().nSilver)..m_i18n[1520].."，"..tostring(MineModel.getGainInfo().nWood)..m_i18n[5679])
	MineModel.getGainInfo().nSilver = 0
	MineModel.getGainInfo().nWood = 0
	setRewardBtnEnabled()
end
-- 奖励推送
function fnMSG_CB_PUSH_REWARD( ... )
	logger:debug("fnMSG_CB_PUSH_REWARD")
	setRewardBtnEnabled()
end
-- 邮件红点
function fnMSG_CB_PUSH_MAIL_TIP( ... )
	logger:debug("fnMSG_CB_PUSH_MAIL_TIP")
	showMailTip()
end

-- 战斗开始，标记暂停，不刷新界面
function fnMSG_MINE_BEGIN_BATTLE( ... )
	logger:debug("fnMSG_MINE_BEGIN_BATTLE")
	MineModel.getSwitch().isPause = true
end

-- 战斗结束，重置暂停标记，重新加载数据
function fnMSG_MINE_END_BATTLE( ... )
	logger:debug("fnMSG_MINE_END_BATTLE")
	MineModel.getSwitch().isPause = false
	reload()
end

-- 重连完成，刷新界面s
function fnMSG_RECONN_OK( ... )
	logger:debug("fnRECONN_OK")
	-- 重新注册推送
	_controllerDelegate.addPushNotify()
	-- 标记刷新矿坑信息窗口
	MineModel.getSwitch().isReloadInfoView = true
	-- 刷新界面
	reload()
end

-- 切换区域
function fnCB_SWITCH_AREA( tb )
	switchArea(tb.area, tb.page)
end
-- FileName: GCItemView.lua
-- Author: liweidong
-- Date: 2015-06-01
-- Purpose: 公会副本据点列表
--[[TODO List]]

module("GCItemView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
local _holdCopy = nil --据点的copy
-- 模块局部变量 --
local _copyId = nil
local _copyDb = nil
local _curBasePos={x=0,y=0} --当前据点坐标
local m_i18n = gi18n


local function init(...)

end

function destroy(...)
	package.loaded["GCItemView"] = nil
end

function moduleName()
    return "GCItemView"
end
-- 副本单独信息条
function updateInfoBar()
	if (_layoutMain==nil) then
		return
	end
	_layoutMain.IMG_MAX:setEnabled(false)
	setExp(_layoutMain.LOAD_EXP_BAR,_layoutMain.LABN_EXP_NUM,_layoutMain.LABN_EXP_NUM3)

	_layoutMain.TFD_LV:setText("Lv."..UserModel.getUserInfo().level)

	if(_layoutMain.LABN_POWER_NUM) then
		local nPowerNum = tonumber(UserModel.getUserInfo().execution)
		_layoutMain.LABN_POWER_NUM:setStringValue(nPowerNum)
		_layoutMain.LABN_POWER_NUM3:setStringValue(g_maxEnergyNum)
		local nPercent = intPercent(nPowerNum, g_maxEnergyNum)
		_layoutMain.LOAD_POWER_BAR:setPercent((nPercent > 100) and 100 or nPercent)
	end
end
function setExp( barWidget, labMem, labDomi )
	require "db/DB_Level_up_exp"
	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nLevelUpExp = tUpExp["lv_"..(tonumber(tbUserInfo.level)+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值

	if(labMem) then
		labMem:setStringValue(nExpNum)
		labDomi:setStringValue(nLevelUpExp)
	end
	local nPercent = intPercent(nExpNum, nLevelUpExp)
	barWidget:setPercent((nPercent > 100) and 100 or nPercent)

	local userLevel = UserModel.getUserInfo().level
	local maxUserLevel = UserModel.getUserMaxLevel()

	if(tonumber(userLevel) >= maxUserLevel) then
		labMem:setEnabled(false)
		labDomi:setEnabled(false)
		barWidget.img_slant:setEnabled(false)
		barWidget.IMG_MAX:setEnabled(true)
		barWidget:setPercent(100)
	end
end

--需要攻打的据点动画回调
function actionBaseBack( node )
	curBaseTopAction(node.TFD_NAME)
	curBaseAction(node.BTN_IN)
end
--当前可打据点头部动画
function curBaseTopAction( parentNode )
	-- local m_arAni1 = UIHelper.createArmatureNode({
	-- 	filePath = "images/effect/mubiao_1/mubiao_1.ExportJson",
	-- 	animationName = "mubiao_1",
	-- 	loop = -1,
	-- })
	-- m_arAni1:setAnchorPoint(ccp(0.5,0.2))
	-- parentNode:addNode(m_arAni1,100)
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = animationPath .. "mubiao/mubiao.ExportJson",
		animationName = "mubiao",
		loop = -1,
	})
	m_arAni1:setAnchorPoint(ccp(0.42,0.2))
	parentNode:addNode(m_arAni1,100)
end
--当前可打据点底部动画
function curBaseAction( parentNode )
	-- local m_arAni1 = UIHelper.createArmatureNode({
	-- 	filePath = "images/effect/mubiao_2/mubiao_2.ExportJson",
	-- 	animationName = "mubiao_2",
	-- 	loop = -1,
	-- })
	-- m_arAni1:setAnchorPoint(ccp(0.5,1))
	-- m_arAni1:setPosition(ccp(parentNode.BTN_IN:getPositionX(),parentNode.BTN_IN:getPositionY()))
	-- parentNode:addNode(m_arAni1,-100)
end
-- 复制怪物据点
function createArmy( x,y,infoTable,state,modelType )
	local itemBaseCopy = _holdCopy:clone()
	itemBaseCopy:setTag(infoTable.id)
	itemBaseCopy:setPosition(ccp(x-itemBaseCopy:getSize().width/2, y))
	logger:debug("pos:%s,%s",x,y)
	_layoutMain.LAY_TOTAL:addChild(itemBaseCopy,modelType) --liweidong  让据点记录自己的类型
	--当前攻打的据点动画
	if(state < 100) then
		itemBaseCopy:setPosition(ccp(itemBaseCopy:getPositionX(),itemBaseCopy:getPositionY()+_layoutMain.IMG_BG:getSize().height*0.5))
		local moveByPos = CCMoveBy:create(0.5, ccp(0,-_layoutMain.IMG_BG:getSize().height*0.5-10))
		local easeSine=CCEaseExponentialIn:create(moveByPos)
		local easeMove=CCEaseElasticOut:create(CCMoveBy:create(0.3, ccp(0,10)))
		local array = CCArray:create()
		array:addObject(easeSine)
		array:addObject(easeMove)
		array:addObject(CCCallFuncN:create(actionBaseBack))
		local action = CCSequence:create(array)
		itemBaseCopy:runAction(action)
	end

	itemBaseCopy.TFD_NAME:setText(infoTable.name)
	UIHelper.labelNewStroke(itemBaseCopy.TFD_NAME)
	itemBaseCopy.IMG_ALREADY_DEAD:setVisible(state==100)
	itemBaseCopy.IMG_PROGRESS:setVisible(state~=100)
	itemBaseCopy.LAY_ALREADY_KILL:setVisible(state==100)
	itemBaseCopy.LOAD_PROGRESS:setPercent(state)
	itemBaseCopy.TFD_PROGRESS:setText(state.."%")

	itemBaseCopy.IMG_HEAD:loadTexture("images/base/hero/head_icon/"..infoTable.icon)
	itemBaseCopy.IMG_PHOTO_BG:loadTexture("images/copy/ncopy/fortpotential/stronghold_bg_n.png")
	--点击据点内容，开始战斗准备界面
	local toBattle = function ( sender, eventType )
		local bFocus = sender:isFocused()
		if (bFocus) then
			itemBaseCopy.IMG_HEAD:setScale(0.85)
			itemBaseCopy.IMG_PHOTO_BG:loadTexture("images/copy/ncopy/fortpotential/stronghold_bg_h.png")
		else
			itemBaseCopy.IMG_HEAD:setScale(1)
			itemBaseCopy.IMG_PHOTO_BG:loadTexture("images/copy/ncopy/fortpotential/stronghold_bg_n.png")
		end

		if (eventType == TOUCH_EVENT_ENDED) then
			GCItemCtrl.onBaseStrongHold(_copyId,sender:getTag())
		end
	end
	itemBaseCopy.BTN_IN:setTag(infoTable.id)
	itemBaseCopy.BTN_IN:addTouchEventListener(toBattle)

	itemBaseCopy.BTN_IN:loadTextureNormal("images/copy/ncopy/fortpotential/"..modelType..".png") 
	itemBaseCopy.BTN_IN:loadTexturePressed("images/copy/ncopy/fortpotential/"..modelType.."_pressed.png")
	itemBaseCopy.BTN_IN:setPositionType(POSITION_ABSOLUTE)
	if (tonumber(modelType)==1) then
		itemBaseCopy.BTN_IN:setPosition(ccp(0, -10))
	elseif  (tonumber(modelType)==2) then
		itemBaseCopy.BTN_IN:setPosition(ccp(0, -5))
	else
		itemBaseCopy.BTN_IN:setPosition(ccp(0, 1))
	end
end
-- 计算据点坐标
function copyBaseArmy(baseId_,state )

	local baseItemInfo = DB_Stronghold.getDataById(baseId_)
	local normalTable = copy.models.normal
	local m_copyBgHeight = _layoutMain.IMG_BG:getSize().height
	for i,values in pairs(normalTable) do
		local armyId = values.looks.look.armyID
		local modelUrl = values.looks.look.modelURL
		if (tonumber(armyId) == tonumber(baseItemInfo.id) and modelUrl ~= nil) then
			local nimgModel = lua_string_split(modelUrl,".swf")
			createArmy(values.x, m_copyBgHeight - values.y,baseItemInfo,state,nimgModel[1])
			_curBasePos.x=values.x
			_curBasePos.y=m_copyBgHeight - values.y
			break
		end
	end
end
--画据点
function initStrongHold()
	if (_layoutMain==nil) then
		return
	end
	local copyItemFIle = "db/cxmlLua/lcopy" .. _copyId%100 -- 引入全局变量 copy
	package.loaded[copyItemFIle] = nil  --释放存储的模块
	require(copyItemFIle)
	
	local copyInfo = _copyDb
	--删除
	for i=1,30 do
		local fieldName = "base"..i
		local baseId = copyInfo[fieldName]
		if baseId~=nil and (_layoutMain.LAY_TOTAL:getChildByTag(baseId) ~= nil) then
			_layoutMain.LAY_TOTAL:removeChildByTag(baseId,true)
		end
		if baseId~=nil and (_layoutMain.LAY_TOTAL:getChildByTag(baseId+5000) ~= nil) then
			_layoutMain.LAY_TOTAL:removeChildByTag(baseId+5000,true)
		end
	end
	--重画
	for i=1,30 do
		local fieldName = "base"..i
		local baseId = copyInfo[fieldName]
		if(baseId ~= nil) then
			local state = GCItemModel.getStrongHoldStatus(_copyId,baseId)
			if state ~= nil then
				if (state == -1) then
					break
				end 
				copyBaseArmy(baseId,tonumber(state))
			end
		end
	end
end
--更新UI
function updateUI()
	initStrongHold()
	updateAtackNum()
end
--更新剩余挑战次数
function updateAtackNum()
	if (_layoutMain==nil) then
		return
	end
	--挑战次数
	logger:debug("attack num:"..GCItemModel.getAtackNum())
	_layoutMain.TFD_TIMES_NUM:setText(GCItemModel.getAtackNum())
end
function setUIStyleAndI18n(base)
	base.TFD_TIMES:setText(m_i18n[1352])
	
	UIHelper.labelNewStroke( base.TFD_PROGRESS, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_TIMES, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_TIMES_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( base.TFD_LIMIT, ccc3(0x28,0x00,0x00), 2 )
end
--初始化UI
function initUI()
	LayerManager.hideAllLayout("GCItemView")
	_layoutMain = g_fnLoadUI("ui/union_stronghold.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				-- local curModuleName = LayerManager.curModuleName()
				-- local retainLayer = DropUtil.checkLayoutIsRetain( curModuleName,_layoutMain)
				local changeModuleType = LayerManager.getChangModuleType()
				if (changeModuleType and changeModuleType == 1) then
					return
				end
				-- if (not retainLayer) then
				_layoutMain=nil
				_holdCopy:release()
				LayerManager.remuseAllLayoutVisible("GCItemView")
			end,
			function()
			end
		) 
	setUIStyleAndI18n(_layoutMain)

	updateInfoBar()
	_layoutMain.TFD_COPY_NAME:setText(_copyDb.name)
	_layoutMain.IMG_COPY_NAME:setScale(g_fScaleX)
	--可攻打时间
	require "script/module/guildCopy/GCItemModel"
	local _,startTime,endTime = GCItemModel.getCopyAttackTimeInfo()
	_layoutMain.TFD_LIMIT:setText(string.format(m_i18n[5934],startTime,endTime))
	_holdCopy = _layoutMain.LAY_STRONGHOLD
	_holdCopy:removeFromParent()
	_holdCopy:setPositionType(POSITION_ABSOLUTE)
	_holdCopy:retain()
	updateUI()
	--背景
	_layoutMain.IMG_BG:loadTexture("images/copy/ncopy/overallimage/"..copy.background)
	
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	_layoutMain.BTN_BUZHEN:addTouchEventListener(GCItemCtrl.onBuzhen)
	_layoutMain.BTN_ADD:addTouchEventListener(function( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				GCItemCtrl.onAddTimes()
			end 
		end)
	_layoutMain.BTN_RANK:addTouchEventListener(function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				GCItemCtrl.onEnterRank(_copyId)
			end 
		end)
	_layoutMain.BTN_REWARD:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			GCItemCtrl.onEnterRewardQuene(_copyId)
		end
	end)

	_layoutMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			GCItemCtrl.onBack()
		end
	end)

	return _layoutMain
end
--影藏本界面的显示
function hideView()
	
end
--设置scrollView定位和缩放问题
function setScrollViewPos()
	--缩放
	local scalenum=g_fScaleX
	_layoutMain.IMG_BG:setScale(scalenum)
	local szOld = _layoutMain.SCV_MAIN:getInnerContainerSize()
	_layoutMain.SCV_MAIN:setInnerContainerSize(CCSizeMake(szOld.width*scalenum, szOld.height*scalenum)) -- 重新设置滚动区域size
	--定位
	local posy = -_curBasePos.y*scalenum+400*scalenum
	posy = posy>0 and 0 or posy
	_layoutMain.SCV_MAIN:setJumpOffset(ccp(_layoutMain.SCV_MAIN:getJumpOffset().x,posy))
end
function create(id)
	_copyId = id
	require "db/DB_Legion_newcopy"
	_copyDb = DB_Legion_newcopy.getDataById(id)
	return initUI()
end

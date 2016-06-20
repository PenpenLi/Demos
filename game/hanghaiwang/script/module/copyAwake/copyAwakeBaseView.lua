-- FileName: copyAwakeBaseView.lua
-- Author: liweidong
-- Date: 2015-11-17
-- Purpose: 据点列表view
--[[TODO List]]

module("copyAwakeBaseView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
local _holdCopy = nil --据点的copy
local m_fnGetWidget = g_fnGetWidgetByName
-- 模块局部变量 --
local _copyId = nil
local _copyDb = nil
local _curBasePos={x=0,y=0} --当前据点坐标
local m_i18n = gi18n
local _rewardAnimationTag = 8643
local _callBack = nil --去获取引导回调
local nScrollToPos = nil
local curItemBase = nil

local function init(...)

end

function destroy(...)
	package.loaded["copyAwakeBaseView"] = nil
end

function moduleName()
    return "copyAwakeBaseView"
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
end
--当前可打据点头部动画
function curBaseTopAction( parentNode )
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = animationPath .. "mubiao/mubiao.ExportJson",
		animationName = "mubiao",
		loop = -1,
	})
	m_arAni1:setAnchorPoint(ccp(0.42,0.2))
	parentNode:addNode(m_arAni1,100)
end
-- 复制怪物据点
function createArmy( x,y,infoTable,state,modelType )
	local itemBaseCopy = _holdCopy:clone()
	itemBaseCopy:setTag(infoTable.id)
	itemBaseCopy:setPosition(ccp(x-itemBaseCopy:getSize().width/2, y))
	logger:debug("pos:%s,%s",x,y)
	nScrollToPos = ccp(x, y)
	curItemBase=itemBaseCopy
	_layoutMain.LAY_TOTAL:addChild(itemBaseCopy,modelType) --liweidong  让据点记录自己的类型
	--当前攻打的据点动画
	if(state == 0) then
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
			-- AudioHelper.playCommonEffect()
			AudioHelper.playBtnEffect("start_fight.mp3")
			copyAwakeCtrl.onClickBase(_copyId,infoTable.id)
			_layoutMain.SCV_MAIN:setTouchEnabled(true)
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
	-- 显示据点星级
	local starNums = 3
	local getStarNum = copyAwakeModel.getHoldStarNumber(_copyId,infoTable.id)

	local star1 = itemBaseCopy.IMG_STAR1
	local star2 = itemBaseCopy.IMG_STAR2
	local star3 = itemBaseCopy.IMG_STAR3
	if(star1 and star2 and star3) then
		local tbStarArr = {}
		if (starNums == 1) then
			star1:setVisible(false)
			star3:setVisible(false)
			if(getStarNum <= 0) then
				table.insert(tbStarArr,star2)
			end
		elseif(starNums == 2) then
			star1:setPositionPercent(ccp(star1:getPositionPercent().x + 0.1, star1:getPositionPercent().y))
			star2:setPositionPercent(ccp(star2:getPositionPercent().x + 0.1, star2:getPositionPercent().y))
			star3:setVisible(false)
			if(getStarNum == 0) then
				table.insert(tbStarArr,star1)
				table.insert(tbStarArr,star2)
			elseif(getStarNum == 1) then
				table.insert(tbStarArr,star2)
			end
		elseif(starNums == 3) then
			if(getStarNum == 0) then
				table.insert(tbStarArr,star1)
				table.insert(tbStarArr,star2)
				table.insert(tbStarArr,star3)
			elseif(getStarNum == 1) then
				table.insert(tbStarArr,star2)
				table.insert(tbStarArr,star3)
			elseif(getStarNum == 2) then
				table.insert(tbStarArr,star3)
			end
		end
		for _,v in pairs(tbStarArr) do
			UIHelper.setWidgetGray(v,true)
		end
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
	local copyInfo = _copyDb
	local copyItemFIle = "db/cxmlLua/dcopy" .. _copyId%100 -- 引入全局变量 copy
	package.loaded[copyItemFIle] = nil  --释放存储的模块
	require(copyItemFIle)

	local baseIds = lua_string_split(copyInfo.bases,"|")
	--删除
	for k,v in ipairs(baseIds) do
		if (_layoutMain.LAY_TOTAL:getChildByTag(v) ~= nil) then
			_layoutMain.LAY_TOTAL:removeChildByTag(v,true)
		end
	end
	--重画
	for k,v in ipairs(baseIds) do
		local state = copyAwakeModel.getStrongHoldStatus(_copyId,v)
		if state ~= nil then
			if (state == -1) then
				break
			end
			logger:debug("base id .. " .. v)
			copyBaseArmy(v,tonumber(state))
		end
	end
end
--副本通关后显示通关提示动画
function showClearanceTip( copyId )
	if (not(_layoutMain and _layoutMain.addNode)) then
		return
	end
	if (copyId%100==22) then
		return
	end
	local copyNextInfo = DB_Disillusion_copy.getDataById(copyId)
	local tipSprite = CCSprite:create("images/copy/new_copy_open_bg.png")
	tipSprite:setPosition(ccp(g_winSize.width,g_winSize.height/2 + 50))
	_layoutMain:addNode(tipSprite)

	local tipTTf = CCLabelTTF:create(copyNextInfo.name,g_sFontPangWa,50)
	tipTTf:enableStroke(ccc3(0xff, 0xff, 0xff), 10)
	tipTTf:setFontFillColor(ccc3(0xc4, 0x25, 0x00))
	tipSprite:addChild(tipTTf)
	tipTTf:setPosition(ccp(tipSprite:getContentSize().width/2,tipSprite:getContentSize().height/2))

	local imgOpen = CCSprite:create("images/copy/newcopyopen.png")
	imgOpen:setPosition(ccp(tipSprite:getContentSize().width/2,0))
	tipSprite:addChild(imgOpen)

	function clearTipSeqBack( node )
		node:removeFromParentAndCleanup(true)
	end
	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.5, ccp(g_winSize.width/2,g_winSize.height/2 + 50)))
	array:addObject(CCDelayTime:create(2))
	array:addObject(CCFadeIn:create(1))
	array:addObject(CCFadeOut:create(1))
	array:addObject(CCCallFuncN:create(clearTipSeqBack))
	local action = CCSequence:create(array)
	tipSprite:runAction(action)
end
--更新UI
function updateUI()
	if (_layoutMain==nil) then
		return
	end
	initStrongHold()
	updateCopyBaseInfo()
			
	require "script/module/guide/GuideAwakeView"
    if (GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 8) then
    	LayerManager.addUILayer()
    	performWithDelay(_layoutMain,function()
    				LayerManager.removeUILayer()
			        require "script/module/guide/GuideCtrl"
			        GuideCtrl.createAwakeGuide(9,nil, getHolePos())
			        _layoutMain.SCV_MAIN:setTouchEnabled(false)
		        end,0.85)
    end
end
--更新副本一些基本信息
function updateCopyBaseInfo()
	local hStar,aStar = copyAwakeModel.getCopyStarById(_copyId)
	_layoutMain.TFD_STAR_OWN:setText(hStar)
	_layoutMain.TFD_STAR_TOTAL:setText(aStar)
	_layoutMain.TFD_STAR_DOWN:setText(hStar .. "/" .. aStar)
	setRewardBox(hStar,aStar)
end
--设置奖励宝箱相关
function setRewardBox(hStar,aStar)
	local copyInfo = _copyDb
	local rewardStatus = copyAwakeModel.getCopyRewardStatusById(_copyId)
	local reward1 = _layoutMain.LAY_COPPER
	local reward2 = _layoutMain.LAY_SILVER
	local reward3 = _layoutMain.LAY_GOLD
	reward1:setVisible(false)
	reward2:setVisible(false)
	reward3:setVisible(false)
	local hardSpitImg2 = _layoutMain.IMG_DIVIDE2
	local hardSpitImg1 = _layoutMain.IMG_DIVIDE1
	if (reward1 and reward2 and reward3 and copyInfo.starlevel) then
		local startLv = lua_string_split(copyInfo.starlevel,",")
		local tbgoldBtn
		if (#startLv == 1) then
			reward1:setVisible(false)
			reward2:setVisible(false)
			reward3:setVisible(true)
			-- starProgressMax=35
			hardSpitImg2:setVisible(false)
			hardSpitImg1:setVisible(false)
			tbgoldBtn = {"GOLD","COPPER","SILVER"}
		elseif (#startLv == 2) then
			reward1:setVisible(false)
			reward2:setVisible(true)
			reward3:setVisible(true)
			hardSpitImg1:setVisible(false)
			tbgoldBtn = {"SILVER","GOLD","COPPER"}
		else
			reward1:setVisible(true)
			reward2:setVisible(true)
			reward3:setVisible(true)
			tbgoldBtn = {"COPPER","SILVER","GOLD"}
		end
		-- local hStar,aStar = fnGetCopyDifficultyStar(itemNetData,copyDifficulty) 
		local curAllScore = aStar
		local scoreBar=_layoutMain.LOAD_PROGRESS_BAR
		local percent = hStar/curAllScore*100
		scoreBar:setPercent(percent)
		if (#startLv == 2 and tonumber(hStar)<=tonumber(startLv[1])) then
			scoreBar:setPercent(hStar/tonumber(startLv[1])*66.6)
		end
		if (#startLv == 2 and tonumber(hStar)>tonumber(startLv[1])) then
			scoreBar:setPercent((hStar-tonumber(startLv[1]))/(tonumber(startLv[2])-tonumber(startLv[1]))*33.3+66.6)
		end
		
		--显示相应的widget
		local function fnShowWidget(tbWidget,showWidget )
			for k,v in ipairs(tbWidget) do
				if (v == showWidget) then
					showWidget:setEnabled(true)
					showWidget:setVisible(true)
				else
					v:setEnabled(false)
					v:setVisible(false)
				end
			end
		end
		for k,v in ipairs(startLv) do
			if (k <= #tbgoldBtn and k<= #rewardStatus) then
				local reward_colse = m_fnGetWidget(_layoutMain, "BTN_"..tbgoldBtn[k].."_CLOSE", "Button")
				local reward_open = m_fnGetWidget(_layoutMain, "BTN_"..tbgoldBtn[k].."_CANOPEN", "Button")
				local reward_opened = m_fnGetWidget(_layoutMain, "BTN_"..tbgoldBtn[k].."_OPENED", "Button")
				local reward_num = m_fnGetWidget(_layoutMain, "TFD_"..tbgoldBtn[k].."_NUM")
				local rewardEffect = g_fnGetWidgetByName(_layoutMain, "IMG_"..tbgoldBtn[k].."_EFFECT")
				reward_num:setText(v)
				local wardTb = {reward_colse,reward_open,reward_opened,rewardEffect}
				local onrecReward = function( sender,eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						copyAwakeCtrl.onclickRewardBox(_copyId,k)
					end
				end
				if (rewardStatus[k]==2) then
					fnShowWidget(wardTb,reward_opened)
					reward_opened:setTag(k)
					reward_opened:addTouchEventListener(onrecReward)
				elseif (rewardStatus[k]==1) then
					fnShowWidget(wardTb,reward_open)
					rewardEffect:setEnabled(true)
					rewardEffect:setVisible(true)
					
					reward_open:setTag(k)
					reward_open:addTouchEventListener(onrecReward)
					if (tbgoldBtn[k] == "GOLD") then
						fnAnimationOpenBox(reward_open,"copy_box",3,"copy_box_goden")
					elseif (tbgoldBtn[k] == "SILVER") then
						fnAnimationOpenBox(reward_open,"copy_box",2,"copy_box_silver")
					else
						fnAnimationOpenBox(reward_open,"copy_box",1,"copy_box_copper")
					end
				else
					fnShowWidget(wardTb,reward_colse)
					reward_colse:setTag(k)
					reward_colse:addTouchEventListener(onrecReward)
				end
			end

		end
	end
end
--宝箱动画
function fnAnimationOpenBox( rewardBtn,fileName,anchor,playname)
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = animationPath..fileName.."/"..fileName..".ExportJson",
		animationName = playname,
	})
	m_arAni1:setTag(_rewardAnimationTag)
	if (anchor == 1) then
		-- m_arAni1:setAnchorPoint(ccp(0.5,0.48))
		--m_arAni1:setScale(1.2)
	elseif (anchor == 2) then
		-- m_arAni1:setAnchorPoint(ccp(0.50,0.48))
	end
	-- m_arAni1:setPosition(pos)
	if (rewardBtn:getChildByTag(_rewardAnimationTag)) then
		rewardBtn:getChildByTag(_rewardAnimationTag):removeFromParentAndCleanup(true)
	end
	-- m_arAni1:getAnimation():setSpeedScale(0.5)
	rewardBtn:addNode(m_arAni1)
end
function setUIStyleAndI18n(base)
	-- base.TFD_TIMES:setText(m_i18n[1352])
	-- UIHelper.labelNewStroke( base.TFD_PROGRESS, ccc3(0x28,0x00,0x00), 2 )
end
--初始化UI
function initUI()
	LayerManager.hideAllLayout("copyAwakeBaseView")
	_layoutMain = g_fnLoadUI("ui/dcopy_scene.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_holdCopy:release()
				_layoutMain=nil
				_holdCopy = nil --据点的copy
				m_fnGetWidget = g_fnGetWidgetByName
				_copyId = nil
				_copyDb = nil
				_callBack = nil --去获取引导回调
				nScrollToPos = nil
				curItemBase = nil
				LayerManager.remuseAllLayoutVisible("copyAwakeBaseView")
			end,
			function()
			end
		) 
	setUIStyleAndI18n(_layoutMain)
	updateInfoBar()
	_layoutMain.TFD_COPY_NAME:setText(_copyDb.name)
	_layoutMain.IMG_COPY_NAME:setScale(g_fScaleX)
	
	_holdCopy = _layoutMain.LAY_STRONGHOLD
	_holdCopy:removeFromParent()
	_holdCopy:setPositionType(POSITION_ABSOLUTE)
	_holdCopy:retain()
	updateUI()
	--背景
	_layoutMain.IMG_BG:loadTexture("images/copy/ncopy/overallimage/"..copy.background)
	
	_layoutMain.BTN_CLOSE:addTouchEventListener(function( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playBackEffect()
				copyAwakeCtrl.onBaseHoldBack(_callBack)
			end 
		end)
	_layoutMain.BTN_BUZHEN:addTouchEventListener(function( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				copyAwakeCtrl.onBuzheng()
			end 
		end)

	return _layoutMain
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
-- 返回新手引导挖洞的左下角坐标
function getHolePos( ... )
	-- curItemBase:convertToWorldSpace(ccp(0,0))
	-- local p2=ccp(nScrollToPos.x*g_fScaleX,(nScrollToPos.y+50)*g_fScaleX+(_layoutMain.SCV_MAIN:getContentOffset()-_layoutMain.SCV_MAIN:getInnerContainerSize().height))
	-- return ccp(curItemBase:getContentSize().width/2+curItemBase:getPositionX(),p2.y+(g_fScaleY>1 and 20 or 0))
	local pos = curItemBase:convertToWorldSpace(ccp(curItemBase:getSize().width/2,curItemBase:getSize().height/2))
	return pos
end
function create(copyId,callBack)
	_copyId = copyId
	_copyDb = DB_Disillusion_copy.getDataById(copyId)
	_callBack = callBack
	return initUI()
end

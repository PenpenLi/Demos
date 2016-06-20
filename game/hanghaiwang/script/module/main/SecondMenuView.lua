-- FileName: SecondMenuView.lua
-- Author: yangna
-- Date: 2015-10-27
-- Purpose: 主页面的二级菜单
--[[TODO List]]

module("SecondMenuView", package.seeall)

-- UI控件引用变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n

-- 模块局部变量 --
local tbRedPoint = {}
local jsonMain = "ui/home_function.json"
local _layMain = nil


local function init(...)
	tbRedPoint.train = nil
	tbRedPoint.friend = nil
end

function destroy(...)
	package.loaded["SecondMenuView"] = nil
end

function moduleName()
    return "SecondMenuView"
end

--占卜屋
function onAstrology( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainMenuBtn()
		if (SwitchModel.getSwitchOpenState(ksSwitchStar, true)) then
			--从后端读取数据然后初始化界面
			require "script/module/astrology/MainAstrologyModel"
			MainAstrologyModel.createViewByGetAstrologyInfo()
		end
	end
end

-- 设置
function onConfig( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		UserModel.recordUsrOperationByCondition("onConfig", 1) -- 打点记录  用户操作 2016-01-05
		AudioHelper.playMainUIEffect() -- zhangqi, 2015-12-25

		require "script/module/config/ConfigMainCtrl"

		-- ConfigMainCtrl层删除时，LayerManager会禁用下一层的_layMain.LAY_ROOT的触摸事件。回调方法里手动打开
		local function callback( ... )
			if (_layMain.LAY_ROOT) then 
				_layMain.LAY_ROOT:setTouchEnabled(true)
			end 
		end
		local layConfig = ConfigMainCtrl.create(callback)
		LayerManager.addLayout(layConfig)
	end
end

--邮件
function onMail( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("renwu.mp3")
		require "script/module/mail/MainMailCtrl"
		local layMail = MainMailCtrl.create()
		LayerManager.changeModule(layMail, MainMailCtrl.moduleName(), {1, 3},true)

		--点击邮件后则取消红点
		g_redPoint.newMail.visible = false
	end
end

--好友
function onToFriends(sender,eventType)
	if(eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect() -- zhangqi, 2015-12-25
		require "script/module/friends/MainFdsCtrl"
		LayerManager.changeModule(MainFdsCtrl.create(), MainFdsCtrl.moduleName(), {1, 3}, true)
		PlayerPanel.addForActivity()
	end
end

-- 修炼
function onTrain( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playMainUIEffect()
		
		if (SwitchModel.getSwitchOpenState(ksSwitchDestiny,true)) then
			require "script/module/Train/MainTrainCtrl"
			MainTrainCtrl.create()
		end
	end
end

--更新好友可领取耐力红点
function updateFriendRedPoint( ... )
		--显示好友数量
		require "script/module/friends/staminaFdsCtrl"
		logger:debug("updateFriendRedPoint: getStaminaNum = " .. staminaFdsCtrl.getStaminaNum())
		
		local num=0
		tbRedPoint.friend = nil

		-- 耐力
		if(staminaFdsCtrl.getStaminaNum()>0 and staminaFdsCtrl.getTodayReceiveTimes()>0) then
			num = num + staminaFdsCtrl.getStaminaNum()
			tbRedPoint.friend = true
			logger:debug("可领取的耐力")
			logger:debug({num=num})
		end
		-- 好友申请
		require "script/module/friends/FriendsApplyModel"
		if(FriendsApplyModel.getApplyNum()>0)then
			tbRedPoint.friend  = true
			num = num + FriendsApplyModel.getApplyNum()
			logger:debug("好友申请")
			logger:debug({num=num})
		end


	if(_layMain) then
		local imgFriendTip = m_fnGetWidget(_layMain, "IMG_FRIEND_TIP")
		imgFriendTip:setVisible(false)

		if(tbRedPoint.friend)then
			local tfdFriendTip = m_fnGetWidget(imgFriendTip, "LABN_FRIEND_TIP")
			tfdFriendTip:setStringValue(num)
			imgFriendTip:setVisible(true)
		end
	end
end

--修炼红点
function updateTrainRedPoint( ... )
	if (SwitchModel.getSwitchOpenState(ksSwitchDestiny,false)) then
		require "script/module/Train/MainTrainModel"
		require "db/DB_Train"

		local function callback( data )
			MainTrainModel.setTrainData(data)
			tbRedPoint.train = nil
			if (MainTrainModel.getTrainData()) then 
				local nextId = MainTrainModel.getNextTrainId()
				if (nextId<table.count(DB_Train.Train)) then 
					local data = DB_Train.getDataById(nextId)
					tbRedPoint.train = tonumber(MainTrainModel.getLeftScore()) >= tonumber(data.costCopystar) and true or nil
				end 
			end 
			
			-- 拉取修炼数据后更新主页面二级菜单红点 
			if (LayerManager.curModuleName() == "MainShip") then
				MainShip.updateSecMenuBtnTip()
			end 
		end

		-- 需要获取新的副本星数
		RequestCenter.train_getTrainInfo(function (cbFlag, dictData, bRet)
			logger:debug(dictData)
			if (bRet) then 
				callback(dictData.ret)
			end 
		end)
	end
end


-- 更新二级菜单子按钮的红点
function updateSecMenuLayTip( ... )
	updateFriendRedPoint()
	updateTrainRedPoint()
end

function getTipState( ... )
	return tbRedPoint.train or tbRedPoint.friend
end


function initUI( ... )
	local tbData = { "BTN_TRAIN","BTN_FRIEND","BTN_MAIL","BTN_MENU","BTN_ZHANBU",}
	local tbCallFunc = { onTrain, onToFriends, onMail,onConfig, onAstrology}
	for i=1,#tbData do 
		_layMain[tbData[i]]:addTouchEventListener(tbCallFunc[i])
	end 

	-- 	--占卜中心
	-- if (SwitchModel.getSwitchOpenState(ksSwitchStar, false)) then
	-- 	require "script/module/astrology/MainAstrologyModel"
	-- 	MainAstrologyModel.hasRedPoint()
	-- end
	-- logger:debug("占卜需要红点么？")
	-- logger:debug(g_redPoint.diviStar.visible)

	-- local imgTipAstr = m_fnGetWidget(widgetRoot,"IMG_TIP_ASTROLOGY")
	-- imgTipAstr:removeAllNodes()
	-- if (g_redPoint.diviStar.visible) then
	-- 	imgTipAstr:addNode(UIHelper.createRedTipAnimination())
	-- 	m_boatTipFlag.zb = true
	-- else
	-- 	m_boatTipFlag.zb = false
	-- end

	updateFriendRedPoint()

	if (not SwitchModel.getSwitchOpenState(ksSwitchDestiny,false)) then
		_layMain.BTN_TRAIN:setVisible(false)
		_layMain.BTN_TRAIN:setEnabled(false)
	else 
		_layMain.BTN_TRAIN:setVisible(true)
		_layMain.BTN_TRAIN:setEnabled(true)
		
		local imgTipDestiny = _layMain.IMG_TRAIN_TIP  
		imgTipDestiny:removeAllNodes()
		if (tbRedPoint.train ) then	
			imgTipDestiny:addNode(UIHelper.createRedTipAnimination())
		end 
	end 
end

local FRAME_TIME = 1/60

function openAction( )
-- 第1 帧      比例 10 ：0	
-- 第6帧       比例 10 ：100
-- 第16帧      比例 100：100

	_layMain.LAY_ROOT:setTouchEnabled(false)
	_layMain.IMG_CIRCLE:setTouchEnabled(false)
	_layMain.BTN_ZHANBU:setTouchEnabled(false)
	_layMain.BTN_MENU:setTouchEnabled(false)
	_layMain.BTN_TRAIN:setTouchEnabled(false)
	_layMain.BTN_FRIEND:setTouchEnabled(false)
	_layMain.BTN_MAIL:setTouchEnabled(false)


	_layMain.IMG_CIRCLE:setScale(0)
	local delay0 = CCDelayTime:create(14*FRAME_TIME)
	local scale1 = CCScaleTo:create(1*FRAME_TIME,0.1,0)
	local scale2 = CCScaleTo:create(5*FRAME_TIME,0.1,1)
	local scale3 = CCScaleTo:create(10*FRAME_TIME,1,1)
	local callback = CCCallFunc:create(function ( ... )
		_layMain.LAY_ROOT:setTouchEnabled(true)
		_layMain.IMG_CIRCLE:setTouchEnabled(true)
		_layMain.BTN_ZHANBU:setTouchEnabled(true)
		_layMain.BTN_MENU:setTouchEnabled(true)
		_layMain.BTN_TRAIN:setTouchEnabled(true)
		_layMain.BTN_FRIEND:setTouchEnabled(true)
		_layMain.BTN_MAIL:setTouchEnabled(true)
	end)
	local array = CCArray:create()
	array:addObject(delay0)
	array:addObject(scale1)
	array:addObject(scale2)
	array:addObject(scale3)
	array:addObject(callback)
	local seq = CCSequence:create(array)
	_layMain.IMG_CIRCLE:runAction(seq)

end


function closeAction( )
-- 第1 帧      比例 100：100
-- 第6帧       比例 105：100
-- 第16帧      比例 10 ：100
-- 第20帧      比例 10 ：0
	_layMain.LAY_ROOT:setTouchEnabled(false)
	_layMain.IMG_CIRCLE:setTouchEnabled(false)
	_layMain.BTN_ZHANBU:setTouchEnabled(false)
	_layMain.BTN_MENU:setTouchEnabled(false)
	_layMain.BTN_TRAIN:setTouchEnabled(false)
	_layMain.BTN_FRIEND:setTouchEnabled(false)
	_layMain.BTN_MAIL:setTouchEnabled(false)

	local delay1 = CCDelayTime:create(1*FRAME_TIME) 
	local scale1 = CCScaleTo:create(5*FRAME_TIME,1.05,1)
	local scale2 = CCScaleTo:create(10*FRAME_TIME,0.1,1)
	local scale3 = CCScaleTo:create(4*FRAME_TIME,0.1,0)
	local callback = CCCallFunc:create(function ( ... )
		LayerManager.removeLayout()
	end)
	local  array = CCArray:create()
	array:addObject(delay1)
	array:addObject(scale1)
	array:addObject(scale2)
	array:addObject(scale3)
	array:addObject(callback)
	local seq = CCSequence:create(array)
	_layMain.IMG_CIRCLE:runAction(seq)
end

function create(...)
	_layMain = g_fnLoadUI(jsonMain)

	_layMain.LAY_ROOT:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			MainShip.updateSecMenuBtnByType(0)
			closeAction(_layMain)
		end
	end)
	_layMain.LAY_ROOT:setTouchEnabled(false)

	_layMain.IMG_CIRCLE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			MainShip.updateSecMenuBtnByType(0)
			closeAction(_layMain)
		end
	end)
	_layMain.IMG_CIRCLE:setTouchEnabled(false)


	UIHelper.registExitAndEnterCall(_layMain,
		function ( ... )
			_layMain = nil
		end,
		function ( ... )
		
		end)

	initUI()

	return  _layMain
end


function addSecondMenu( ... )
	local secMenulay = create()
	LayerManager.lockOpacity()  --添加画布时候 黑屏颜色去掉
	LayerManager.addLayoutNoScale(secMenulay)
	openAction()
end



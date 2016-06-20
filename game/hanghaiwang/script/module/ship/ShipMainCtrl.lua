-- FileName: ShipMainCtrl.lua
-- Author: LvNanchun
-- Date: 2015-10-16
-- Purpose: 主船主界面控制
--[[TODO List]]

module("ShipMainCtrl", package.seeall)
require "script/module/ship/ShipMainView"

-- UI variable --

-- module local variable --
local _shipMainViewInstance
local _nowMainShip
local _flag
local _fnRetCallBack
local _i18n = gi18n

local function init(...)

end

function destroy(...)
    package.loaded["ShipMainCtrl"] = nil
end

function moduleName()
    return "ShipMainCtrl"
end

-- 装备按钮网络回调
local function btnEquipNetWork( cbFlag, dictData, bRet )
	if (bRet) then
		if (dictData.ret == "ok") then
			-- 第一时间删除战斗力动画
			MainFormationTools.removeFlyText()
			-- 修改数据
			ShipData.setMainShipId(_nowMainShip)
			-- 刷新listview
			refreshListView(_nowMainShip)
			-- 带动画刷新主界面
			refreshView(1)
			-- 修改战斗力
			UserModel.setInfoChanged(true)
			-- 计算船炮战斗力
			CannonModel.setFightValue()
			UserModel.updateFightValue()
			updateInfoBar()
			-- 修改装备的主船形象
			UserModel.setShipFigure(_nowMainShip)
		end
	end
end

-- 装备按钮回调
local function btnEquipCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 构造参数
		local tbArgs = Network.argsHandler(_nowMainShip)
		RequestCenter.mainship_wear(btnEquipNetWork, tbArgs)
	end
end

-- 查看信息点击船
local function fnInfoCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 第一时间删除战斗力动画
		MainFormationTools.removeFlyText()
		require "script/module/ship/shipInfo/ShipInfoCtrl"
		ShipInfoCtrl.create(_nowMainShip)
	end
end

-- 返回按钮回调
local function fnBackCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		-- 第一时间删除战斗力动画
		MainFormationTools.removeFlyText()
		if (_flag == "main") then
			local layout = MainShip.create()
			if (layout) then
				LayerManager.changeModule(layout, MainShip.moduleName(), {1, 3}, true)
				PlayerPanel.addForMainShip()

				require "script/module/guide/GuideCtrl"
				require "script/module/guide/GuideShipMainView"
				if GuideShipMainView.guideStep == 5 and GuideModel.getGuideClass() == ksGuideMainShip then
					GuideCtrl.createShipMainGuide(6)
				end

			end
		elseif (_flag == "bag") then
			MainBagCtrl.create()
		elseif (_flag == "resolve") then
			logger:debug("from resolve")
			if (_fnRetCallBack and _fnRetCallBack.from) then
				_fnRetCallBack.from()
			end
		end
	end
end

-- 强化按钮
local function fnStrengCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 第一时间删除战斗力动画
		MainFormationTools.removeFlyText()
		require "script/module/ship/shipStrength/ShipStrengthCtrl"
		ShipStrengthCtrl.create(_nowMainShip)
	end
end

-- 重生按钮
local function btnRebornCallback( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 第一时间删除战斗力动画
		MainFormationTools.removeFlyText()
		local shipInfo = ShipData.getShipInfoById(_nowMainShip)
		local isShipActivated, shiplv = ShipData.getIfShipActivatedById(_nowMainShip) 
		if (not isShipActivated) then
			ShowNotice.showShellInfo(_i18n[7503])
			return
		elseif (ShipData.getNowShipId() == _nowMainShip) then
			ShowNotice.showShellInfo(_i18n[7504])
			return
		elseif (UserModel.getGoldNumber() < tonumber(shipInfo.reborn_gold)) then
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			return
		else
			require "script/module/ship/shipReborn/ShipRebornCtrl"
			-- resetShipId用于传入当前界面的shipid，刷新时保证保留在当前界面
			local function resetMainView( resetShipId )
				refreshListView(resetShipId)
				refreshView(_nowMainShip)
			end
			ShipRebornCtrl.create(_nowMainShip, shiplv, resetMainView)
		end
	end
end

-- 激活网络回调
local function activateNetworkCallBack( cbFlag, dictData, bRet )
	if (bRet) then
		if (dictData.ret == "ok") then
			-- 第一时间删除战斗力动画
			MainFormationTools.removeFlyText()
			-- 激活修改数据
			ShipData.activateShipById(_nowMainShip)
			-- 刷新界面
			refreshListView(_nowMainShip)
			refreshView()
			-- 修改战斗力
			UserModel.setInfoChanged(true)
			UserModel.updateFightValue()
			MainFormationTools.fnShowFightForceChangeAni()
			updateInfoBar()
			if (SwitchModel.getSwitchOpenState( ksSwitchCannonAndBall )) then
				local activeBulletId = CannonModel.getActiveBullet(_nowMainShip)
				logger:debug("ShipMainCtrl_ActiveBullet shipId:".._nowMainShip.." bulletId:"..activeBulletId)
				ShipBulletBagModel.addBullet(activeBulletId)
				CannonModel.insertCannonBall(activeBulletId)
			end
		end
	end
end

-- 激活按钮回调
local function btnActivateCallBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		
		-- 构造参数
		local tbArgs = Network.argsHandler(_nowMainShip)
		RequestCenter.mainship_active(activateNetworkCallBack, tbArgs)
	end
end

--[[desc:刷新激活面板的函数
    arg1: 无
    return: 无
—]]
function refreshActivatePanel()
	-- 设置激活面板信息
	local activateInfo = ShipMainModel.getActivateInfoById(_nowMainShip)
	logger:debug({activateInfo = activateInfo})

	-- 激活道具不足按钮回调
	local function btnActivateNotEnough( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			-- 第一时间删除战斗力动画
			MainFormationTools.removeFlyText()
			ShowNotice.showShellInfo(_i18n[1409])
			PublicInfoCtrl.createItemDropInfoViewByTid(activateInfo.tid, function ( ... )
				refreshView()
			end)
		end
	end
	-- 判断道具是否充足
	if (activateInfo.isEnough) then
		activateInfo.fnActivate = btnActivateCallBack
	else
		activateInfo.fnActivate = btnActivateNotEnough
	end

	-- 道具图标按钮事件
	activateInfo.fnIconBtn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			PublicInfoCtrl.createItemDropInfoViewByTid(activateInfo.tid, nil, true)
		end
	end

	_shipMainViewInstance:refreshActivatePanel( activateInfo )
end

--[[desc:刷新信息面板的函数
    arg1: refreshType值为1的时候需要播放动画
    return: 无
—]]
function refreshInfoPanel( refreshType )
	-- 设置属性面板信息
	local attrInfo = ShipMainModel.getAttrInfo(_nowMainShip)
	-- 判断是否能重生
	if (attrInfo.strengthLevel == 0) then
		attrInfo.canReborn = false
	else
		attrInfo.canReborn = true
		local rebornGoldNum = ShipMainModel.getRebornGoldById(attrInfo.shipId)
		if (rebornGoldNum == 0) then
			attrInfo.rebornFree = true
		else
			attrInfo.rebornFree = false
			attrInfo.rebornGoldNum = rebornGoldNum
		end
	end

	-- 判断是否需要动画
	-- 若refreshType为1时需要加动画，否则不加
	if (refreshType == 1) then
		attrInfo.needAni = true
		attrInfo.aniInfo = ShipMainModel.getPreSubAttr()
	else
		attrInfo.needAni = false
	end

	_shipMainViewInstance:refreshInfoPanel( attrInfo, refreshType )
end

--[[desc:刷新listView
    arg1: 当前光圈所处的船的id
    return: 无  
—]]
function refreshListView( shipId )
	local tbShipInfo = ShipMainModel.getListViewInfo()
	logger:debug({tbShipInfo = tbShipInfo})

	_nowMainShip = shipId or tbShipInfo[1].id

	tbShipInfo.fnBtn = function ( cellId )
		_nowMainShip = cellId
		refreshView()
	end

	_shipMainViewInstance:reloadListView( tbShipInfo, _nowMainShip )
end

--[[desc:刷新界面
    arg1: refreshType值为1的时候需要播放动画
    return: 无
—]]
function refreshView( refreshType )
	local nowShipInfo
	for k,v in ipairs(ShipMainModel.getListViewInfo()) do 
		if (v.id == _nowMainShip) then
			nowShipInfo = v
			break 
		end
	end

	local fnCallBack

	if (nowShipInfo.state == 1 or nowShipInfo.state == 2) then
		fnCallBack = function ( ... )
			-- 刷新下方的信息界面
			refreshInfoPanel( refreshType )
		end
	elseif (nowShipInfo.state == 3) then
		fnCallBack = function ( ... )
			-- 刷新激活面板信息
			refreshActivatePanel()
		end
	end

	_shipMainViewInstance:refreshView( nowShipInfo, fnCallBack )
end

--[[desc:创建一个滚动的背景动画
    arg1: layMain主UI控件
    return: 是否有返回值，返回值说明  
—]]
function getBgUpdateFun( layMain )
	local layRoot = layMain.LAY_NEW_BG

	local imgWave1 = layMain.IMG_WAVE1
	local imgWave2 = layMain.IMG_WAVE2
	local imgCloud1 = layMain.IMG_CLOUD1 
	local imgCloud2 = layMain.IMG_CLOUD2 
	local imgIsland = layMain.IMG_ISLAND 

	---[[
	local imgWaveCopy2 = imgWave1:clone()
	layRoot:addChild(imgWaveCopy2)

	local imgWaveCopy = imgWave2:clone()
	layRoot:addChild(imgWaveCopy)

	local imgCloud1Copy = imgCloud1:clone()
	layRoot:addChild(imgCloud1Copy)

	local imgCloud2Copy = imgCloud2:clone()
	layRoot:addChild(imgCloud2Copy)

	local imgIslandCopy = imgIsland:clone()
	layRoot:addChild(imgIslandCopy)
	--]]
	local posXWave = imgWave2:getPositionX()
	local posXWave2 = imgWave1:getPositionX()
	local posXCloud1 = imgCloud1:getPositionX()
	local posXCloud2 = imgCloud2:getPositionX()
	local posXIsland = imgIsland:getPositionX()

	local function updateUI( ... )
		imgWave2:setPositionX(imgWave2:getPositionX() - 0.6)
		imgWaveCopy:setPositionX(imgWave2:getPositionX() + imgWave2:getSize().width - 2)

		imgWave1:setPositionX(imgWave1:getPositionX() + 0.7)
		imgWaveCopy2:setPositionX(imgWave1:getPositionX() - imgWave1:getSize().width + 2)

		imgCloud1:setPositionX(imgCloud1:getPositionX() + 0.4)
		imgCloud1Copy:setPositionX(imgCloud1:getPositionX() - imgCloud1:getSize().width + 2)

		imgCloud2:setPositionX(imgCloud2:getPositionX() + 0.2)
		imgCloud2Copy:setPositionX(imgCloud2:getPositionX() - imgCloud2:getSize().width + 2)

		imgIsland:setPositionX(imgIsland:getPositionX() + 0.55)
		imgIslandCopy:setPositionX(imgIsland:getPositionX() - imgIsland:getSize().width + 2)

		if imgWave2:getPositionX() < posXWave - imgWave2:getSize().width then
			imgWave2:setPositionX(posXWave)
			imgWaveCopy:setPositionX(posXWave + imgWave2:getSize().width - 2)
		end
		if imgWave1:getPositionX() > posXWave + imgWave1:getSize().width then
			imgWave1:setPositionX(posXWave2)
			imgWaveCopy2:setPositionX(posXWave2 - imgWave1:getSize().width + 2)
		end
		if imgCloud1:getPositionX() > posXCloud1 + imgCloud1:getSize().width then
			imgCloud1:setPositionX(posXCloud1)
			imgCloud1Copy:setPositionX(posXCloud1 - imgCloud1:getSize().width + 2)
		end
		if imgCloud2:getPositionX() > posXCloud2 + imgCloud2:getSize().width then
			imgCloud2:setPositionX(posXCloud2)
			imgCloud2Copy:setPositionX(posXCloud2 - imgCloud2:getSize().width + 2)
		end
		if imgIsland:getPositionX() > posXIsland + imgIsland:getSize().width then
			imgIsland:setPositionX(posXIsland)
			imgIslandCopy:setPositionX(posXIsland - imgIsland:getSize().width + 2)
		end
	end

	return updateUI
end


-- 战舰装备界面
function btnArmBattleShip( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		if (SwitchModel.getSwitchOpenState(ksSwitchMainShip,true) and  SwitchModel.getSwitchOpenState( ksSwitchCannonAndBall , true )) then
			-- 第一时间删除战斗力动画
			MainFormationTools.removeFlyText()
			AudioHelper.playCommonEffect()
			require "script/module/ship/armBattleShip/ArmShipCtrl"
			ArmShipCtrl.create(_nowMainShip)
		end
	end
end


-- flag=="bag"表示从背包，flag=="main"表示从主界面
function create( shipId, flag, fnRetCallback )
	_shipMainViewInstance = ShipMainView:new()
	-- 刷新listView顺便确定_nowMainShip的值
	refreshListView(shipId)
	refreshView()
	_flag = flag

	-- 构建按钮事件的table
	local tbBtnEvent = {}
	tbBtnEvent.reborn = btnRebornCallback
	tbBtnEvent.armShip = btnArmBattleShip
	tbBtnEvent.strength = fnStrengCallBack
	tbBtnEvent.back = fnBackCallBack
	tbBtnEvent.info = fnInfoCallBack
	tbBtnEvent.equip = btnEquipCallBack

	local mainView = _shipMainViewInstance:create( shipId, tbBtnEvent )
logger:debug({fnRetCallback = fnRetCallback})
	if (fnRetCallback) then
		_fnRetCallBack = fnRetCallback
		LayerManager.changeModule(mainView, moduleName(), {1}, true, 1)
	else
		LayerManager.changeModule(mainView, moduleName(), {1})
	end

	PlayerPanel.addForPartnerStrength()
end


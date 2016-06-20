-- FileName: MainMineCtrl.lua
-- Author: zhangqi
-- Date: 2015-04-10
-- Purpose: 资源矿主控模块
--[[TODO List]]

module("MainMineCtrl", package.seeall)

require "script/module/mine/MineInfoCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_instanceView
local _mineLayer	= nil

local _mModel		= MineModel
local MineRequest	= MineRequest
local _isCreateDlg	= false

-- 刷新矿坑显示
function updateMine( data )
	_mModel.updateMine(data)
end

function reloadMineInfoView( ... )
	logger:debug("reloadMineInfoView")
	local tbOccupyData = _mModel.getOccupyInfo()
	logger:debug(tbOccupyData)
	for i = 1, 5 do
		local data = tbOccupyData[i]
		if (data == nil) then
			data = {domain_id = _mModel.getCurDomainId(), pit_id = i}
		end
		logger:debug(data)
		reloadMineInfoViewWithData(data)
	end
end

-- 刷新弹出框
function reloadMineInfoViewWithData( tbData )
	logger:debug("reloadMineInfoViewWithData")
	logger:debug(tbData)
	local tInfo = _mModel.getOccupyInfoWithId(tbData.domain_id, tbData.pit_id)
	if (tInfo == nil) then 	-- 空矿
		tInfo = {domain_id = tbData.domain_id, pit_id = tbData.pit_id}
	end
	logger:debug(tInfo)
	local mineType = _mModel.getMineState(tbData.domain_id, tbData.pit_id, _mModel.getArea())
	MineInfoCtrl.refresh(tInfo, mineType)
end

-- @param area 区域分类:
-- MineModel.AREA_NORMAL = 2 	--普通区域
-- MineModel.AREA_HIGH 	= 1 	--高级区域(现在没有了，被策划屏蔽)
-- MineModel.AREA_GOLD 	= 3 	--金币区域
-- @param page 页码，默认1
function switchArea( area, page )
	--MainMineView.switchArea(area, page)
	GlobalNotify.postNotify(_mModel._MSG_.CB_SWITCH_AREA, {area = area, page = page})
end
------------------------- 后端回调 -------------------------
-- 拉取区域信息回调
function onGetDomainInfoCallback(cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onGetDomainInfoCallback")
		logger:debug({dictData = dictData})

		local tbOccupyInfo = _mModel.getOccupyInfo()
		tbOccupyInfo = {}
		for k,v in pairs(dictData.ret) do
			tbOccupyInfo[tonumber(v.pit_id)] = v
		end
		_mModel.setOccupyInfo(tbOccupyInfo)

		--reload_Mine()
		GlobalNotify.postNotify(_mModel._MSG_.CB_GET_DOMAIN_INFO)	-- 发送通知，放置直接调用已销毁的界面

		--getSelfPitsInfo()
	end
end

-- 拉取个人信息回调
function onGetSelfPitsInfo( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onGetSelfPitsInfo")
		logger:debug({dictData = dictData})

		local tbSelfInfo = _mModel.getSelfInfo()
		tbSelfInfo = {}
		local data = dictData.ret
		
		for k1,v1 in pairs(data) do
			if (k1 == "pits") then
				for k,v in pairs(data.pits or {}) do
					-- 自己的矿，区分两个矿源
					if (tonumber(v.uid) == tonumber(UserModel.getUserUid())) then
						if (_mModel.convertDomainToArea(tonumber(v.domain_id)) ~= _mModel.AREA_GOLD) then
							tbSelfInfo.tNormal = v
						else
							tbSelfInfo.tGold = v
						end
					-- 不是自己的矿，保存到协助军数据
					else
						tbSelfInfo.tHelp = v
					end
				end
			else
				tbSelfInfo[k1] = v1
			end
		end
		logger:debug({_tbSelfInfoNormal = tbSelfInfo})
		_mModel.setSelfInfo(tbSelfInfo)
		replaceLayer()
		--reload_Self()
		GlobalNotify.postNotify(_mModel._MSG_.CB_GET_SELFPITS)	-- 发送通知，放置直接调用已销毁的界面
	end
end

-- 一键探索回调
function onExplorePit( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onExplorePit")
		
		_mModel.setExploreInfo(dictData.ret)
		logger:debug(dictData.ret)
		GlobalNotify.postNotify(_mModel._MSG_.CB_EXPLORE)	-- 发送通知，放置直接调用已销毁的界面
	end
end

-- 拉取奖励信息回调
function onGetSelfReward( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onGetSelfReward")
		logger:debug(dictData.ret)
		local data = dictData.ret
		local tbGainInfo = _mModel.getGainInfo()
		tbGainInfo.nSilver = tonumber(data.total_silver)
		_mModel.setGainInfo(tbGainInfo)
		--
		if (_isCreateDlg) then
			onCreateGainDlg()	-- 创建奖励界面
		else
			GlobalNotify.postNotify(_mModel._MSG_.CB_GETREWARD)	-- 发送通知，放置直接调用已销毁的界面
		end
	end
end

-- 领取奖励回调
function onRecReward(cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onRecReward")
		local data = dictData.ret
		UserModel.addSilverNumber(_mModel.getGainInfo().nSilver)
		GlobalNotify.postNotify(_mModel._MSG_.CB_RECREWARD)		-- 发送通知，放置直接调用已销毁的界面
	end
end

-- 退出资源矿回调
function onLeave( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onLeave")
		require "script/module/activity/MainActivityCtrl"
		--MainScene.homeCallback()
		local layActivity = MainActivityCtrl.create()
		LayerManager.changeModule(layActivity, MainActivityCtrl.moduleName(), {1,3}, true)
		PlayerPanel.addForActivity()
	end
end

------------------------- 后端推送 -------------------------
-- 接收更新矿坑推送
function onPush_Pit( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onPush_Pit")
		logger:debug({dictDataPush = dictData.ret})
		logger:debug(_mModel.getOccupyInfo())
		if (table.isEmpty(dictData.ret)) then
			return
		end
		local data = dictData.ret

		-- 刷新矿坑信息
		updateMine(data)

		reloadMineInfoViewWithData(data)

		-- 刷新活动红点
		GlobalNotify.postNotify(_mModel._MSG_.CB_REFRESH_TIP)
	end
end

-- 接收抢矿广播推送
function onPush_Broadcast( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onPush_Broadcast")
		logger:debug(dictData.ret)
		_mModel.setBroardcast(dictData.ret)
		
		GlobalNotify.postNotify(_mModel._MSG_.CB_BROADCAST)
	end
end

-- 奖励推送
function onPush_Reward( cbFlag, dictData, bRet )
	if (bRet) then
		logger:debug("onPush_Reward")
		local tGainInfo = _mModel.getGainInfo()
		tGainInfo.nSilver = tonumber(dictData.ret.silver)
		_mModel.setGainInfo(tGainInfo)

		-- 此通知两处监听
		-- 1.资源矿界面监听显示按钮
		-- 2.奖励界面监听刷新数值显示
		GlobalNotify.postNotify(_mModel._MSG_.CB_PUSH_REWARD)
	end
end

------------------- 请求后端接口 -----------------------
-- 获取资源区信息
function getInfoByDomainId( index )
	local info = _mModel.getDBMineInfo()[index]	-- 矿区信息
	assert(info, "DomainId not exist!")
	RequestCenter.mineral_getInfoByDomainId(onGetDomainInfoCallback, Network.argsHandlerOfTable({info.id}))
end

-- 获取自己的信息
function getSelfPitsInfo( ... )
	RequestCenter.mineral_getSelfPitsInfo(onGetSelfPitsInfo)
end

-- 一键探索
function getExplorePit( mineType )
	RequestCenter.mineral_explorePit(onExplorePit, Network.argsHandlerOfTable({mineType}))
end

-- 获取奖励
-- 分为两处拉取
-- 1.打开资源矿界面拉取用户是否有奖励	isCreateDlg = false
-- 2.打开奖励界面拉取最新奖励信息		isCreateDlg = true
function getSelfReward( isCreateDlg )
	_isCreateDlg = isCreateDlg
	RequestCenter.mineral_getSelfReward(onGetSelfReward)
end

-- 领取奖励
function recReward( ... )
	RequestCenter.mineral_recReward(onRecReward)
end

-- 离开
function leave( ... )
	RequestCenter.mineral_leave(onLeave)
end

------------------- 方法 -----------------------

-- 显示领取资源
function onCreateGainDlg( ... )
	local layGet = g_fnLoadUI("ui/resource_get_reward.json")
	local tGainInfo = _mModel.getGainInfo()
	layGet.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	layGet.TFD_DESC:setText(m_i18n[5613])

	layGet.TFD_BELLY:setText(tGainInfo.nSilver)

	UIHelper.titleShadow(layGet.BTN_GET, m_i18n[2628])
	layGet.BTN_GET:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTansuo02()
			-- 发领取请求
			recReward()
			LayerManager.removeLayout() -- 关闭领取对话框
		end
	end)

	LayerManager.addLayout(layGet)
end

function addPushNotify( ... )
	-- 注册后端推送监听
	-- Network.re_rpc(onPush_Pit, "push.mineral.update", "push.mineral.update")
	-- Network.re_rpc(onPush_Broadcast, "push.mineral.rob", "push.mineral.rob")
	-- Network.re_rpc(onPush_Reward, "push.mineral.reward", "push.mineral.reward")
	--MineRequest.addPushNotify()
end

function removePushNotify( ... )
	-- Network.remove_re_rpc("push.mineral.update")
	-- Network.remove_re_rpc("push.mineral.rob")
	-- Network.remove_re_rpc("push.mineral.reward")
	--MineRequest.removePushNotify()
end

-- 开始结构是打开界面，然后获取数据；后来修改成先获取数据，再打开界面，基于最小修改的情况，增加此函数
function replaceLayer( ... )
	if (_mineLayer) then
		logger:debug("replaceLayer")
		TimeUtil.timeEnd("mineCreate")
		LayerManager.changeModule(_mineLayer, moduleName(), {1}, true)
		PlayerPanel.addForActivityCopy()
		_mineLayer = nil

		addPushNotify()
	end
end

------------------------- xxxx -------------------------
function create(domainId, isCheckMine)
	TimeUtil.timeStart("mineCreate")
	require "script/module/mine/MainMineView"
	m_instanceView = MainMineView:new()
	m_instanceView:setController(MainMineCtrl)	-- 为view设置自己为操作代理
	_mineLayer = m_instanceView:create(domainId, isCheckMine)
	--replaceLayer()
	-- LayerManager.changeModule(layView, moduleName(), {1}, true)
	-- PlayerPanel.addForActivityCopy()
end

function loadData( ... )
	create()
end

local function init(...)
	m_instanceView = nil
end

function destroy(...)
	m_instanceView = nil
	_mineLayer = nil
	_mModel.destroy()
	package.loaded["MainMineCtrl"] = nil
end

function moduleName()
    return "MainMineCtrl"
end

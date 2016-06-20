-- FileName: MainImpelDownCtrl.lua
-- Author: Xufei
-- Date: 2015-09-09
-- Purpose: 深海监狱 控制模块
--[[TODO List]]

module("MainImpelDownCtrl", package.seeall)

-- UI控件引用变量 --
local _instanceImpelDownView = nil
local _dropCallback = nil
local _i18n = gi18n
-- 模块局部变量 --

function fnBack( ... )
	-- logger:debug("ImpelDownCtrl fnback")
	-- if (m_MainView) then
	-- 	m_MainView:playMusic()
	-- end
end

function fnGo( ... )
	-- logger:debug("ImpelDownCtrl retainFn")
	-- if (m_MainView) then
	-- 	m_MainView:clearMusic()
	-- end
end



function destroy(...)
	_instanceImpelDownView = nil
	package.loaded["MainImpelDownCtrl"] = nil
end

function moduleName()
    return "MainImpelDownCtrl"
end

-- 零点时恢复重置次数
function refreashResetTimes( ... )
	ImpelDownMainModel.resetRefreshTimes()
	if (_instanceImpelDownView) then
		_instanceImpelDownView:showResetButton()
	end
	GlobalNotify.postNotify("IMPEL_DOWN_UPDATE_TIP")
end

local function getBtnFunctions( ... )
	local tbEvent = {}
	-- 返回按钮
	tbEvent.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			
			if (_dropCallback and _dropCallback.returnCallFn) then
				_dropCallback.returnCallFn()
			else 
				MainActivityCtrl.create()
			end
		end
	end

	tbEvent.onShop = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/impelDown/ImpelShop/ImpelShopCtrl"
			ImpelShopCtrl.create()
		end
	end

	return tbEvent
end

function getBtnOnStrategy( ... )
	local onStrategy = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playStrategy()
			local nowLayerInfo = ImpelDownMainModel.getCurLvAndName()
			if (nowLayerInfo.Effect) then
				StrategyCtrl.create({type=4,name=nowLayerInfo.name,param1=nowLayerInfo.layerId,
					callback1 = function ( ... )
						
					end,
					callback2 = function ( ... )
						GlobalNotify.postNotify("IMPEL_DOWN_BACK_MUSIC")
					end
				})
			else
				ShowNotice.showShellInfo(_i18n[7816])--深海监狱已通关，没有攻略可看啦~
				return
			end
		end
	end	
	return onStrategy
end

local function initImpelDownMainView( ... )
	require "script/module/impelDown/ImpelDownMainView"
	_instanceImpelDownView = ImpelDownMainView:new()
	local view = _instanceImpelDownView:create(getBtnFunctions())
	if (view) then
		if (_dropCallback) then
			LayerManager.changeModule(view, moduleName(), {1,3}, true, 1)
		else
			LayerManager.changeModule(view, moduleName(), {1,3}, true)
		end
		PlayerPanel.addForImpelDown()
	end
end

local function createView( ... )
	local function getImpelDownInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
		 	require "script/module/impelDown/ImpelDownMainModel"
			ImpelDownMainModel.setImpelDownInfo(dictData.ret)
			initImpelDownMainView()
		end
	end
	RequestCenter.impelDown_getTowerInfo(getImpelDownInfoCallback)
end

function create(  DropCallback )
	logger:debug("start_深海监狱")
	_dropCallback = DropCallback
	createView()
end

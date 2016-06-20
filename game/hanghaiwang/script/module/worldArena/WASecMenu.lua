-- FileName: WASecMenu.lua
-- Author: huxiaozhou
-- Date: 2016-02-18
-- Purpose: 挑战界面 二级菜单按钮
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WASecMenu", package.seeall)

-- UI控件引用变量 --
local _mainWidget = nil
local json = "ui/function_spread.json"

local function init(...)

end

function destroy(...)
	package.loaded["WASecMenu"] = nil
end

function moduleName()
    return "WASecMenu"
end

function create(...)
	_mainWidget = g_fnLoadUI(json)
	_mainWidget:setSize(g_winSize)
	_mainWidget.LAY_ROOT.LAY_MAIN:setTouchEnabled(true)
	_mainWidget.LAY_ROOT.LAY_MAIN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			WAMainView.updateSecMenuBtnByType(0)
			closeAction()
		end
	end)

	WAUtil.bindingBtnFun(_mainWidget.BTN_EXPLAIN, WAEntryCtrl.onHelp) -- 帮助说明
	WAUtil.bindingBtnFun(_mainWidget.BTN_PREVIEW, WAEntryCtrl.onPreViewRewards) -- 奖励预览
	WAUtil.bindingBtnFun(_mainWidget.BTN_RANK, WAEntryCtrl.onRank) -- 排行榜
	WAUtil.bindingBtnFun(_mainWidget.BTN_BET, WAEntryCtrl.onBet) -- 押注	
	WAUtil.bindingBtnFun(_mainWidget.BTN_RECORD, WAEntryCtrl.onRecord) -- 对战记录
	WAUtil.bindingBtnFun(_mainWidget.BTN_MESSAGE, WAEntryCtrl.onMsg) -- 留言

	UIHelper.registExitAndEnterCall(_mainWidget,function (  )
		GlobalNotify.removeObserver("WABETREDPOINT", "WABETREDPOINTSECMENU")
		_mainWidget = nil
	end, function (  )
		logger:debug("WABETREDPOINTSECMENU")
		GlobalNotify.addObserver("WABETREDPOINT",updateBetRedPoint, false, "WABETREDPOINTSECMENU")
	end)
	LayerManager.lockOpacity()  --添加画布时候 黑屏颜色去掉
	LayerManager.addLayoutNoScale(_mainWidget)
	updateBetRedPoint()
	openAction()
end

-- 打开
local FRAME_TIME = 1/60
function openAction(  )
-- 第1 帧      比例 10 ：0	
-- 第6帧       比例 10 ：100
-- 第16帧      比例 100：100

	_mainWidget.LAY_ROOT.LAY_MAIN:setTouchEnabled(false)
	_mainWidget.IMG_CIRCLE:setScale(0)
	local delay0 = CCDelayTime:create(14*FRAME_TIME)
	local scale1 = CCScaleTo:create(1*FRAME_TIME,0.1,0)
	local scale2 = CCScaleTo:create(5*FRAME_TIME,0.1,1)
	local scale3 = CCScaleTo:create(10*FRAME_TIME,1,1)
	local callback = CCCallFunc:create(function ( ... )
		_mainWidget.LAY_ROOT.LAY_MAIN:setTouchEnabled(true)
	end)
	local array = CCArray:create()
	array:addObject(delay0)
	array:addObject(scale1)
	array:addObject(scale2)
	array:addObject(scale3)
	array:addObject(callback)
	local seq = CCSequence:create(array)
	_mainWidget.IMG_CIRCLE:runAction(seq)
end

-- 关闭
function closeAction(  )
	-- 第1 帧      比例 100：100
-- 第6帧       比例 105：100
-- 第16帧      比例 10 ：100
-- 第20帧      比例 10 ：0
	_mainWidget.LAY_ROOT:setTouchEnabled(false)
	_mainWidget.IMG_CIRCLE:setTouchEnabled(false)

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
	_mainWidget.IMG_CIRCLE:runAction(seq)
end

function updateBetRedPoint(  )
	if _mainWidget and _mainWidget.IMG_POINT then
		_mainWidget.IMG_POINT:setEnabled(WABetModel.getIsShowRedPoint())
	end
end


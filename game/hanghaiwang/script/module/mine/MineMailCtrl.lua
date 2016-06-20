-- FileName: MineMailCtrl.lua
-- Author: sunyunpeng
-- Date: 2015-06-01
-- Purpose: 资源矿邮件信息ctrl
--[[TODO List]]

module("MineMailCtrl", package.seeall)

require "script/module/mine/MineMailView"
require "script/module/mine/MineMailService"
require "script/module/mine/MineMailData"
require "script/module/mine/MainMineCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --
local _tabSelected = nil   --用来保存选中的tab对象
_curPage = 1       		--标签切换时用来记录当前显示的时那个标签 1仇人信息 2资源到期 3 抢夺信息
local _notifyFunTB = nil
local m_i18n = gi18n

local m_color = {normal = ccc3(0xbf, 0x93, 0x67), selected = ccc3(0xff, 0xff, 0xff)} --  g_TabTitleColor



local function init(...)
	_tabSelected = nil
	_curPage = 1
	_notifyFunTB = {MineMailData._MSG_.CB_PUSH_MAIL_REVENGETIP , MineMailData._MSG_.CB_PUSH_MAIL_RESOURCETIP}
end

function moduleName()
	return "MineMailCtrl"
end



function destroy(...)
	package.loaded["MineMailCtrl"] = nil
end

function moduleName()
    return "MineMailCtrl"
end


--仇人信息
function loadAllRevengeData(  )
	-- 创建下一步UI
	local function createNext( ... ) 
		logger:debug("get loadAllRevengeData list call back")
		MineMailData.showMineMailData = MineMailData.getShowRevengeData(MineMailData.mineRevengeData,1)
		MineMailView.updateTableData(MineMailData.showMineMailData,1)
	end
	MineMailService.getRevengeMailList(0,10,"true",createNext)
end

--资源到期
function loadResourcesExhaust(  )
	local function createNext( ... )
		logger:debug("get loadResourcesExhaust list call back")
		MineMailData.showMineMailData = MineMailData.getShowResourceData(MineMailData.mineExhaustData,2)
		MineMailView.updateTableData(MineMailData.showMineMailData,2)
	end
	MineMailService.getResourceExhaustMailList(0,10,"true",createNext)
end

--抢夺信息
function loadGrabDetail(  )
	local function createNext( ... )
		logger:debug("get onGrabDetail list call back")
		MineMailData.showMineMailData = MineMailData.getShowRobLogMailData(MineMailData.mineGrabData,3)
		logger:debug({MailDataShowMailData=MineMailData.showMineMailData})
		MineMailView.updateTableData(MineMailData.showMineMailData,2)
	end
	MineMailService.getGrabMailList(0,10,"true",createNext)
end

--反击
function fnCounterAttack( uid ,domainType)
	local function createNext( domainId,pitId )
		logger:debug({domainId=domainId})
		logger:debug({pitId=pitId})

		if (not domainId) then
			ShowNotice.showShellInfo(m_i18n[5672])      --"当前玩家没有矿"
			return
		end
		MainMineCtrl.create(tonumber(domainId),tonumber(pitId))
	end 
	MineMailService.getDomainInfoOfUser(uid,domainType,createNext)
end

--卡牌返回按钮
local function fnOnBack( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playBackEffect()
        UIHelper.onClose()
    end
end


-- 更新仇人信息红点
function updateRevengeRedTip( ... )
    local FirstTabShowTag  =  g_redPoint.newMineMail.FirstTabShowRed
    if (FirstTabShowTag) then
    	MineMailView.showMailTip( 1 )
    end
end

-- 更新资源到期红点
function updateResourceRedTip( ... )
    local SecondTabShowTag =  g_redPoint.newMineMail.SecondTabShowRed
    if (SecondTabShowTag) then
    	MineMailView.showMailTip( 2 )
    end
end

function create(...)
	logger:debug("MineMailCtrl")
	init()
	local tbBtnEvent = {}
	-- 仇人信息
	tbBtnEvent.onRevengeDetail = function ( )
			loadAllRevengeData()
			MineMailView.updateTipNode( 1 )
			_curPage = 1
		
		-- end
	end
	-- 资源到期
	tbBtnEvent.onResourcesExhaust = function ( )
			loadResourcesExhaust()
			MineMailView.updateTipNode( 2 )
			_curPage = 2
			
		-- end
	end
	-- 抢夺信息
	tbBtnEvent.onGrabDetail = function ( )
		
			logger:debug("tbBtnEvent.onGrabDetail")
			loadGrabDetail()
			MineMailView.updateTipNode( 3 )
			_curPage = 3

	end
	-- 返回
	tbBtnEvent.onBack = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect() 
			logger:debug("tbBtnEvent.onBack")
			MainMineCtrl.create()
		end
	end
  
	local layMain = MineMailView.create(tbBtnEvent)

	loadAllRevengeData()
	MineMailView.updateTipNode( 1 )

	require "script/module/public/UIHelper"
	-- UIHelper.registExitAndEnterCall(layMain,exitCall,enterCall)

		-- 注册onExit()  更新红点
	UIHelper.registExitAndEnterCall(layMain, function ( ... )		
		GlobalNotify.removeObserver(_notifyFunTB[1], _notifyFunTB[1])
		GlobalNotify.removeObserver(_notifyFunTB[2], _notifyFunTB[2])

    end,function ( ... )
    		-- 添加监听		更新红点
		GlobalNotify.addObserver(_notifyFunTB[1], updateRevengeRedTip, false, _notifyFunTB[1])
		GlobalNotify.addObserver(_notifyFunTB[2], updateResourceRedTip, false, _notifyFunTB[2])
    end)
	
	updateRevengeRedTip(  ) -- 更新红点
	updateResourceRedTip(  )
	-- PlayerPanel.addForActivityCopy()
	
	return layMain
end

--选择界面的回调函数 ，用来释放tableview
function exitCall( ... )
	--MainMailView.destruct()
end

function enterCall( ... )
	logger:debug("enter call")
	require "script/module/PlayerInfo/PartnerInfoBar"
	local infoBar = PartnerInfoBar:new()
	infoBar:create()
end

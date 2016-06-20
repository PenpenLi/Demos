-- FileName: MainMailCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-06-02
-- Purpose: 邮件主界面ctrl


module("MainMailCtrl", package.seeall)


require "script/module/mail/MainMailView"
require "script/module/mail/MailService"
require "script/module/mail/MailData"

-- UI控件引用变量 --


-- 模块局部变量 --
local m_tabSelected = nil   --用来保存选中的tab对象
m_curPage = 1       		--标签切换时用来记录当前显示的时那个标签 1全部 2战斗 3 好友 4 系统

local function init(...)
	m_tabSelected = nil
	m_curPage = 1
end


function destroy(...)
	package.loaded["MainMailCtrl"] = nil
end


function moduleName()
	return "MainMailCtrl"
end

--[[desc:切换标签
    arg1: 被点击的tab
    return: 返回false表示点击了一个已经被选中的tab，则不再处理点击事件，返回true则表示标签页切换 
—]]
function setTabFocused( sender )
	if(m_tabSelected == nil)then
		m_tabSelected = sender
		m_tabSelected:setFocused(true)
		m_tabSelected:setTitleColor(g_TabTitleColor.selected)
		return true
	else
		if(m_tabSelected ==  sender) then
			m_tabSelected:setFocused(true)
			m_tabSelected:setTitleColor(g_TabTitleColor.selected)
			return false
		else
			m_tabSelected:setFocused(false)
			m_tabSelected:setTitleColor(g_TabTitleColor.normal)
			m_tabSelected = sender
			m_tabSelected:setFocused(true)
			m_tabSelected:setTitleColor(g_TabTitleColor.selected)
			return true
		end
	end
end
--请求所有邮件
function loadAllMailData(  )
	-- 创建下一步UI
	local function createNext( ... )
		-- 创建全部邮件列表
		logger:debug("get mainlBox list call back")
		MailData.showMailData = MailData.getShowMailData(MailData.allMailData)
		MainMailView.updateTableData(MailData.showMailData)
	end
	-- 初始化全部邮件数据
	MailService.getMailBoxList(0,10,"true",createNext)
end
--请求好友邮件
function loadFrdMailData(  )
	-- 创建下一步UI
	local function createNext( ... )
		-- 创建全部邮件列表
		logger:debug("get frdBox list call back")
		MailData.showMailData = MailData.getShowMailData(MailData.friendMailData)
		MainMailView.updateTableData(MailData.showMailData)
	end

	MailService.getPlayMailList(0,10,"true",createNext)
end
--请求战斗邮件
function loadBatterMailData(  )
	-- 创建下一步UI
	local function createNext( ... )
		-- 创建全部邮件列表
		logger:debug("get batterBox list call back")
		MailData.showMailData = MailData.getShowMailData(MailData.battleMailData)
		MainMailView.updateTableData(MailData.showMailData)
	end
	MailService.getBattleMailList(0,10,"true",createNext)
end
--请求系统邮件
function loadSysMailData()
	-- 创建下一步UI
	local function createNext( ... )
		-- 创建全部邮件列表
		logger:debug("get syslBox list call back")
		MailData.showMailData = MailData.getShowMailData(MailData.systemMailData)
		MainMailView.updateTableData(MailData.showMailData)
	end
	MailService.getSysMailList(0,10,"true",createNext)
end

function create(...)
	init()
	local tbBtnEvent = {}
	-- 按钮 全部
	tbBtnEvent.onAllMail = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect() 
			if(setTabFocused(sender) == false) then
				return
			else
				logger:debug("tbBtnEvent.onAllMail")
				loadAllMailData()
				m_curPage = 1
			end
		end
	end
	-- 按钮 战斗
	tbBtnEvent.onFightMail = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect() 
			if(setTabFocused(sender) == false) then
				return
			else
				logger:debug("tbBtnEvent.onFightMail" .. sender:getTag())
				loadBatterMailData()
				m_curPage = 2
			end

		end
	end
	-- 按钮 好友
	tbBtnEvent.onFriendMail = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect() 
			if(setTabFocused(sender) == false) then
				return
			else
				logger:debug("tbBtnEvent.onFriendMail")
				loadFrdMailData()
				m_curPage =3
			end

		end
	end
	-- 按钮 系统
	tbBtnEvent.onSystemMail = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect() 
			if(setTabFocused(sender) == false) then
				return
			else
				logger:debug("tbBtnEvent.onSystemMail")
				loadSysMailData()
				m_curPage = 4
			end

		end
	end

	local layMain = MainMailView.create(tbBtnEvent)

	loadAllMailData()

	require "script/module/public/UIHelper"
	UIHelper.registExitAndEnterCall(layMain,exitCall,enterCall)

	return layMain
end
--选择界面的回调函数 ，用来释放tableview
function exitCall( ... )
	MainMailView.destruct()
end

function enterCall( ... )
	logger:debug("enter call")
			require "script/module/PlayerInfo/PartnerInfoBar"
		local infoBar = PartnerInfoBar:new()
		infoBar:create()
end

-- FileName: GCConfirmOpenView.lua
-- Author: liweidong
-- Date: 2015-06-03
-- Purpose: 开启副本确认框
--[[TODO List]]

module("GCConfirmOpenView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
-- 模块局部变量 --
local _copyDb = nil
local _copyID = nil
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCConfirmOpenView"] = nil
end

function moduleName()
    return "GCConfirmOpenView"
end
function setOpenUII18n(base)
	UIHelper.titleShadow(base.BTN_CONFIRM)
	UIHelper.titleShadow(base.BTN_CANCEL)
	base.BTN_CONFIRM:setTitleText(m_i18n[5901])
	base.BTN_CANCEL:setTitleText(m_i18n[1625])
	base.tfd_open:setText(m_i18n[5938])
	base.tfd_need:setText(m_i18n[5939])
	base.tfd_own:setText(m_i18n[5940])
	base.tfd_confirm:setText(m_i18n[5941])
end
--初始化开启确认框UI
function initOpenUI()
	_layoutMain = g_fnLoadUI("ui/union_copy_openconfirm.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 
	setOpenUII18n(_layoutMain)

	_layoutMain.TFD_COPY:setText(_copyDb.name)
	_layoutMain.TFD_NEED_NUM:setText(_copyDb.open_need_vital)
	_layoutMain.TFD_OWN_NUM:setText(GuildCopyModel.getActitveyNum())
	--按钮事件
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	_layoutMain.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)
	_layoutMain.BTN_CONFIRM:addTouchEventListener(function(sender, eventType )
		if (eventType ~= TOUCH_EVENT_ENDED) then
			return
		end
		GCConfirmOpenCtrl.onConfirmOpen(_copyID)
	end)

	return _layoutMain
end
function setResetUII18n(base)
	UIHelper.titleShadow(base.BTN_CONFIRM)
	UIHelper.titleShadow(base.BTN_CANCEL)
	base.BTN_CONFIRM:setTitleText(m_i18n[5901])
	base.BTN_CANCEL:setTitleText(m_i18n[1625])
	base.tfd_open:setText(m_i18n[4377])
	base.tfd_need:setText(m_i18n[5939])
	base.tfd_own:setText(m_i18n[5940])
	base.tfd_confirm:setText(m_i18n[5942])
end
--初始化重置确认框UI
function initResetUI()
	_layoutMain = g_fnLoadUI("ui/union_copy_openconfirm.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 
	setResetUII18n(_layoutMain)

	_layoutMain.TFD_COPY:setText(_copyDb.name)
	_layoutMain.TFD_NEED_NUM:setText(_copyDb.open_need_vital)
	_layoutMain.TFD_OWN_NUM:setText(GuildCopyModel.getActitveyNum())
	--按钮事件
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	_layoutMain.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)
	_layoutMain.BTN_CONFIRM:addTouchEventListener(function(sender, eventType )
		if (eventType ~= TOUCH_EVENT_ENDED) then
			return
		end
		GCConfirmOpenCtrl.onConfirmReset(_copyID)
	end)

	return _layoutMain
end
--confirmType=1时是重置确认框
function create(id,confirmType)
	require "db/DB_Legion_newcopy"
	_copyID = id
	_copyDb=DB_Legion_newcopy.getDataById(id)
	if (confirmType==1) then
		return initResetUI()
	else
		return initOpenUI()
	end
end

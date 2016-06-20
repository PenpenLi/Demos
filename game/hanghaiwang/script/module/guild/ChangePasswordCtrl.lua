-- FileName: ChangePasswordCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-16
-- Purpose: function description of module
--[[TODO List]]

module("ChangePasswordCtrl", package.seeall)
require "script/module/guild/ChangePasswordView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString


local function init(...)

end

function destroy(...)
	package.loaded["ChangePasswordCtrl"] = nil
end

function moduleName()
    return "ChangePasswordCtrl"
end

function create(...)
	local tbEvents = {}
	-- 确定
	tbEvents.fnConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnConfirm")
			AudioHelper.playCommonEffect() 
			local tbStrCode = ChangePasswordView.getCodeBoxText()

			if tbStrCode.new ~= tbStrCode.confirm then
				ShowNotice.showShellInfo(m_i18n[3545])
			elseif tbStrCode.origin == "" then
				ShowNotice.showShellInfo(m_i18n[3543])
			elseif tbStrCode.new == "" then
				ShowNotice.showShellInfo(m_i18n[3541])
			elseif string.len(tbStrCode.new) < 4 then
				ShowNotice.showShellInfo(m_i18n[3544])
			else
				local createParams = CCArray:create()
		        createParams:addObject(CCString:create(tbStrCode.origin))
		        createParams:addObject(CCString:create(tbStrCode.new))

		        function codeReturn(cbFlag, dictData, bRet)
					if not bRet then
				        return
				    end
				    LayerManager.removeLayout()
			    	if dictData.ret == "err_passwd" then
			    		ShowNotice.showShellInfo(m_i18n[3559])
			    	elseif dictData.ret == "ok" then
			    		ShowNotice.showShellInfo(m_i18n[3546])
			    	end
				end

				RequestCenter.guild_modifyPasswd(codeReturn,createParams)
			end

		end
	end

	-- 取消
	tbEvents.fnCancel = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnCancel")
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end

	--  关闭
	tbEvents.fnClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	local view = ChangePasswordView.create(tbEvents)
	LayerManager.addLayout(view)
end

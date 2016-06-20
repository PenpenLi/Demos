-- FileName: GuildAnnounceCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-16
-- Purpose: function description of module
--[[TODO List]]
-- 工会宣言控制器

module("GuildAnnounceCtrl", package.seeall)
require "script/module/guild/GuildAnnounceView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["GuildAnnounceCtrl"] = nil
end

function moduleName()
    return "GuildAnnounceCtrl"
end


function create(sType)

	local sModifiedType = sType

	local tbEvents = {}
	-- 确定
	tbEvents.fnConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnConfirm")
			AudioHelper.playCommonEffect()
			local str = GuildAnnounceView:getAnnounceText()
			if (sModifiedType == "post") then
				logger:debug(utfstrlen(str))
				 if tonumber(utfstrlen(str)) > 40 then
				 	ShowNotice.showShellInfo(m_i18n[3561])
		            return
		        end
		        local createParams = CCArray:create()
		        if string.len(str) == 0 then
		            createParams:addObject(CCString:create(m_i18nString(3562,GuildDataModel.getGildName())))
		        else
		           createParams:addObject(CCString:create(str))
		        end

		        function postReturn(cbFlag, dictData, bRet)
				    if not bRet then
				        return
				    end

			        if dictData.ret.ret == "ok" then
			        	ShowNotice.showShellInfo(m_i18nString(3572,m_i18n[3560]))
			            GuildDataModel.setPost(dictData.ret.post)
			            MainGuildView.updatePost()
						LayerManager.removeLayout()

			        end
				end

		        local createMes = RequestCenter.guild_modifyPost(postReturn,createParams)
		        print(createMes)
			else
				 if tonumber(utfstrlen(str)) > 20 then
				 	 ShowNotice.showShellInfo(m_i18n[3533])
	            	return
	        	end 

		    	local createParams = CCArray:create()
		        if string.len(str) == 0 then
		            createParams:addObject(CCString:create(m_i18n[3532]))
		        else
		    	   createParams:addObject(CCString:create(str))
		        end

		        function sloganReturn(cbFlag, dictData, bRet)
					if not bRet then
				        return
				    end
			    	if dictData.ret.ret == "ok" then
			    		ShowNotice.showShellInfo(m_i18nString(3572,m_i18n[3505]))
			    		GuildDataModel.setSlogan(dictData.ret.slogan)
			    		LayerManager.removeLayout()
			    	end
				end
				
		    	RequestCenter.guild_modifySlogan(sloganReturn,createParams)
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

	local view = GuildAnnounceView.create(tbEvents,sModifiedType)
	LayerManager.addLayout(view)
end

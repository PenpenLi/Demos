-- FileName: GuildCreateCtrl.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("GuildCreateCtrl", package.seeall)
require "script/module/guild/GuildCreateView"
-- UI控件引用变量 --

-- 模块局部变量 --

local m_typeId

local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["GuildCreateCtrl"] = nil
end

function moduleName()
    return "GuildCreateCtrl"
end


function fnHandlerOfNetwork(cbFlag, dictData, bRet)
    if not bRet then
        return
    end
    if cbFlag == "guild.createGuild" then
        if dictData.ret.ret == "ok" then
        	ShowNotice.showShellInfo(m_i18n[3529])
         	if (m_typeId == 1) then
       			UserModel.addGoldNumber(tonumber(-GuildUtil.getCreateNeedGold()))
       		else
       			UserModel.addSilverNumber(tonumber(-GuildUtil.getCreateNeedSilver()))
       		end
       		LayerManager.removeLayout()
       		MainGuildCtrl.create()
        elseif dictData.ret.ret == "used" then
        	ShowNotice.showShellInfo(m_i18n[3527])
        elseif dictData.ret.ret == "blank" then
        	ShowNotice.showShellInfo(m_i18n[3569])
        elseif dictData.ret.ret == "exceed" then
        	ShowNotice.showShellInfo(m_i18n[3567])
        elseif dictData.ret.ret == "harmony" then
        	ShowNotice.showShellInfo(m_i18n[3525])
        end
    end
end

	


function create(...)
	local tbEvents = {}
	-- 创建 军团 按钮事件

	--是否金币创建, 0银币, 1金币, 默认0银币
	tbEvents.fnGold = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playCommonEffect()

            local userInfo = UserModel.getUserInfo()
			
			if tonumber(userInfo.gold_num) < tonumber(GuildUtil.getCreateNeedGold()) then
				LayerManager.removeLayout()
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
		    else
		        local guildName = GuildCreateView.getNameBoxText()
		        -- function trim (s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end
		    	-- guildName = trim(guildName)
		    	if (string.find(guildName," ") ~= nil or  string.find(guildName," ") ~= nil) then
		    		ShowNotice.showShellInfo(m_i18n[3569])
		        elseif guildName == "" then
		        	ShowNotice.showShellInfo(m_i18n[3526])
		        elseif utfstrlen(guildName) > 6 then
		        	ShowNotice.showShellInfo(m_i18n[3571])
		        else
		            function fnConfirmEvent( sender, eventType )
		            	if (eventType == TOUCH_EVENT_ENDED) then
			            	local createParams = CCArray:create()
				            createParams:addObject(CCString:create(guildName))
				            createParams:addObject(CCInteger:create(1))
				            logger:debug(utfstrlen(m_i18n[3532]))
				            if tonumber(utfstrlen(m_i18n[3532])) > 20 then
				            	ShowNotice.showShellInfo(m_i18n[3533])
				            	return
				            end
				             if tonumber(utfstrlen(m_i18nString(3562,guildName))) > 40 then
				            	ShowNotice.showShellInfo(m_i18n[3561])
				            	return
				            end
				            createParams:addObject(CCString:create(m_i18n[3532]))
				            createParams:addObject(CCString:create(m_i18nString(3562,guildName)))
				            createParams:addObject(CCString:create("123456"))
				            createParams:addObject(CCInteger:create(GuildDataModel.getGuildIconId()))
				            m_typeId = 1
				            RequestCenter.guild_createGuild(fnHandlerOfNetwork,createParams)
				        end
		            end

		            	local richText = BTRichText.create(m_i18n[3528],nil,nil,GuildUtil.getCreateNeedGold())
						richText:setAlignCenter(true)
						richText:setSize(CCSizeMake(400,100))
		            local alert = UIHelper.createCommonDlg(nil,richText,fnConfirmEvent)
		            LayerManager.addLayout(alert)
		        end
		    end
		end
	end

	tbEvents.fnSilver = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnSilver")
			AudioHelper.playCommonEffect()

			local userInfo = UserModel.getUserInfo()
		    if tonumber(userInfo.silver_num) < tonumber(GuildUtil.getCreateNeedSilver()) then
		        ShowNotice.showShellInfo(m_i18n[3568])
		    else
		       local guildName = GuildCreateView.getNameBoxText()
		        if guildName == "" or guildName == " " then
		        	ShowNotice.showShellInfo(m_i18n[3526])
		        elseif utfstrlen(guildName) > 6 then
		        	ShowNotice.showShellInfo(m_i18n[3571])
		        else
		        	function fnConfirmEvent( sender, eventType )
		        		if (eventType == TOUCH_EVENT_ENDED) then
				            local createParams = CCArray:create()
				            createParams:addObject(CCString:create(guildName))
				            createParams:addObject(CCInteger:create(0))
				            createParams:addObject(CCString:create(m_i18n[3532]))
				            createParams:addObject(CCString:create(m_i18nString(3562,guildName)))
				            createParams:addObject(CCString:create("123456"))
				            createParams:addObject(CCInteger:create(GuildDataModel.getGuildIconId()))
				            m_typeId = 0
				            RequestCenter.guild_createGuild(fnHandlerOfNetwork,createParams)
				        end
			         end
		            --  local alert = UIHelper.createCommonDlg(m_i18nString(3528,GuildUtil.getCreateNeedSilver() .. m_i18n[1520]),nil, fnConfirmEvent)
		            -- LayerManager.addLayout(alert)
		            local richText = BTRichText.create(m_i18n[3588],nil,nil,GuildUtil.getCreateNeedSilver())
					richText:setAlignCenter(true)
					richText:setSize(CCSizeMake(400,100))
		            local alert = UIHelper.createCommonDlg(nil,richText,fnConfirmEvent)
		            LayerManager.addLayout(alert)
		        end
		    end

		end
	end
	tbEvents.fnClose = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	tbEvents.fnChooseIcon = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvents.fnChooseIcon")
			require "script/module/guild/icon/GuildIconCtrl"
			GuildIconCtrl.create(GuildCreateView.updateIcon)
		end
	end
	local view = GuildCreateView.create(tbEvents)
	return view
end

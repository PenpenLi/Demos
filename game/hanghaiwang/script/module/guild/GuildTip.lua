-- FileName: GuildTip.lua
-- Author: huxiaozhou
-- Date: 2014-09-23
-- Purpose: function description of module
--[[TODO List]]
--  


module("GuildTip", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local tbMemberInfo
local m_sKinds
local m_bVP
local m_i18n = gi18n
local m_i18nString = gi18nString


local function init(...)
	tbMemberInfo = {}
    m_bVP = false
end

function destroy(...)
	package.loaded["GuildTip"] = nil
end

function moduleName()
    return "GuildTip"
end

function create(sKinds,tbInfo)
	init()
	m_sKinds = sKinds
	tbMemberInfo = tbInfo
     if tonumber(tbMemberInfo.member_type) == 2 then
        m_bVP = true
     else
        m_bVP = false
     end
    logger:debug(tbMemberInfo)
    createDlg()
end

function createDlg(  )
	local richText = nil

	if (m_sKinds == "quit") then
		local str = m_i18nString(3630, "|"..GuildDataModel.getGildName() .. "|")  --"确定要退出|" .."[" .. GuildDataModel.getGildName() .. "]" .."|吗？"

		local tbRich = { str, 
							{
								{size = 24,color={r=0x8f;g=0x2d;b=0x02},font=g_FontPangWa}, 
								{color={r=0x00;g=0x93;b=0x11},size = 24,font=g_FontPangWa},
                                {size = 24,color={r=0x8f;g=0x2d;b=0x02},font=g_FontPangWa}, 
							}
						}

	   richText = BTRichText.create(tbRich)

	elseif(m_sKinds == "kick") then
        local str = m_i18nString(3626, "|".. tbMemberInfo.uname .. "|")  --"确定要将|" .."[" .. tbMemberInfo.uname .. "]" .."|踢出联盟吗？"

        local tbRich = { str, 
                            {
                                {size = 24,color={r=0x8f;g=0x2d;b=0x02},font=g_FontPangWa}, 
                                {color={r=0x00;g=0x93;b=0x11},size = 24,font=g_FontPangWa},
                                {size = 24,color={r=0x8f;g=0x2d;b=0x02},font=g_FontPangWa}, 
                            }
                        }
        richText = BTRichText.create(tbRich)
	end


    richText:setAlignCenter(true)
    richText:setSize(CCSizeMake(400,100))
    local view = UIHelper.createCommonDlg(nil, richText,confirmCb)


    if (m_sKinds == "kick") then
        -- 今日还可踢出人数
        local kicknum = GuildDataModel.getRemainKickNum()
        local str = m_i18nString(3595,kicknum)
        local tbRich = { str, 
                            {
                                {size = 24,color={r=0x8f;g=0x2d;b=0x02},font=g_FontPangWa}, 
                            }
                        }
        local richTextAdd = BTRichText.create(tbRich)
        local parentNode = richText:getParent()
        local posx,posy = richText:getPosition()
        parentNode:addChild(richTextAdd)
        richTextAdd:setPosition(ccp(posx,posy))
        richTextAdd:setAnchorPoint(ccp(0.5,0.5))
        richTextAdd:setAlignCenter(true)
        richTextAdd:setSize(CCSizeMake(400,100))
        richText:setPosition(ccp(posx,posy-50))
    end 

    LayerManager.addLayout(view)
end


function quitReturn(cbFlag, dictData, bRet)
    if not bRet then
        return
    end
    if (cbFlag == "guild.quitGuild") then
        if dictData.ret == "ok" then
            tbMemberInfo = nil
            ShowNotice.showShellInfo(m_i18n[3682])
            GuildDataModel.cleanCache()
            LayerManager.removeLayout()
            MainGuildCtrl.create()
        end
        if dictData.ret == "failed" then
            LayerManager.removeLayout()
            ShowNotice.showShellInfo(m_i18n[3683])
        end
        if dictData.ret == "forbidden" then
            LayerManager.removeLayout()
            -- ShowNotice.showShellInfo("城池争夺战报名结束前一小时至城池争夺战结束无法退出军团")
             ShowNotice.showShellInfo(m_i18n[3672])
        end
    end
end


function goReturn(cbFlag, dictData, bRet)
    if not bRet then
        return
    end
    if (cbFlag == "guild.kickMember")then
        if dictData.ret == "ok" then
            GuildDataModel.removeOneMember(tbMemberInfo.uid)
            ShowNotice.showShellInfo(m_i18n[3684])
            GuildDataModel.addGuildMemberNum(-1)
            if m_bVP == true then
                GuildDataModel.addGuildVPNum(-1)
            end
            GuildDataModel.setKickNum(GuildDataModel.getKickNum() + 1)  --更新剔除数量
            GuildMemberCtrl.refreshMemberList(1)
            LayerManager.removeLayout()
        end
        if dictData.ret == "failed" then
            -- ShowNotice.showShellInfo(m_i18n[3685])
            LayerManager.removeLayout()
            ShowNotice.showShellInfo(m_i18n[3593])  --玩家已退出工会
            GuildMemberCtrl.reloadMemberList()
        end
        if dictData.ret == "forbidden" then
            -- ShowNotice.showShellInfo("城池争夺战报名结束前一小时至城池争夺战结束无法将成员踢出军团")
             ShowNotice.showShellInfo(m_i18n[3672])
        end

        if (dictData.ret == "limited") then 
            LayerManager.removeLayout()
            ShowNotice.showShellInfo(m_i18n[3596])    --今日可踢出人数已满，无法踢人
            local dbinfo = DB_Legion.getDataById(1)
            GuildDataModel.setKickNum(dbinfo.deleteNumLimit)
            GuildMemberView.refreashKickLabel()
        end 
    end
end

function confirmCb(sender, eventType)
    --退出军团
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        if m_sKinds == "quit" then
            RequestCenter.guild_quitGuild(quitReturn,nil)
        end
        -- 剔出军团
        if m_sKinds == "kick" then
            local createParams = CCArray:create()
            createParams:addObject(CCInteger:create(tbMemberInfo.uid))
            RequestCenter.guild_kickMember(goReturn,createParams)
        end
    end
end
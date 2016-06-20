-- FileName: GuildHallCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-09-20
-- Purpose: function description of module
--[[TODO List]]
-- 联盟大厅控制器

module("GuildHallCtrl", package.seeall)
require "script/module/guild/hall/GuildHallView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["GuildHallCtrl"] = nil
end

function moduleName()
    return "GuildHallCtrl"
end


-- 建设Action
function buildAction( donateType)
	local _curDonateInfo = GuildUtil.getDonateInfoBy(donateType)
	local isCan = false


	if(GuildDataModel.getMineDonateTimes()<=0)then
		ShowNotice.showShellInfo(m_i18n[3734])
		return
	end

	-- vip
	if(UserModel.getVipLevel() < _curDonateInfo.needVip)then
		ShowNotice.showShellInfo(m_i18nString(3735,_curDonateInfo.needVip))
		return
	end
		
	if(_curDonateInfo.silver and _curDonateInfo.silver > 0)then
		if(UserModel.getSilverNumber() < _curDonateInfo.silver )then
			ShowNotice.showShellInfo(m_i18n[3718])
			PublicInfoCtrl.createItemInfoViewByTid(60406,nil,true)  -- 贝里掉落界面
			return
		else
			isCan = true
		end

	elseif(_curDonateInfo.gold and _curDonateInfo.gold > 0)then
		if(UserModel.getGoldNumber() < _curDonateInfo.gold )then
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			return
		else
			isCan = true
		end
	end

	

	if(isCan == true)then
		-- 建设回调
		function buildCallback(  cbFlag, dictData, bRet  )
			if( dictData.ret == "ok")then
				-- ShowNotice.showShellInfo("今日建设完毕，获得" .. _curDonateInfo.guildDonate .. "军团建设度" .. _curDonateInfo.sigleDonate .. "个人贡献度")
				
				-- 修改UserModel
				if(_curDonateInfo.silver and _curDonateInfo.silver > 0)then
					UserModel.addSilverNumber(-_curDonateInfo.silver)
				elseif(_curDonateInfo.gold and _curDonateInfo.gold > 0)then
					UserModel.addGoldNumber(-_curDonateInfo.gold)
				end
				-- 修改军团
				GuildDataModel.setMineContriTime(TimeUtil.getSvrTimeByOffset())
				GuildDataModel.setMineContriType(donateType)
				GuildDataModel.addMineDonateTimes(-1)
				GuildDataModel.addSigleDonate(_curDonateInfo.sigleDonate)
				GuildDataModel.addGuildDonate(_curDonateInfo.guildDonate)
				-- 插入自己捐献的数据 更新贡献信息列表
				local tab = {}
				tab.uname = UserModel.getUserName()
				tab.record_data = _curDonateInfo.guildDonate
				tab.record_type = donateType
				if #GuildDataModel._recordList >=5 then
					table.remove(GuildDataModel._recordList)
				end
				table.insert(GuildDataModel._recordList,1,tab)
				GuildHallView.updateUI()
				GuildHallView.playContriEffect(_curDonateInfo)
			elseif(dictData.ret== "insigntime") then
				ShowNotice.showShellInfo(m_i18n[3737])
			end
		end



		local args = Network.argsHandler(donateType)
		RequestCenter.guild_contribute(buildCallback, args)
	end
end


function createView( )
	local tbEvents = {}
	-- 关闭
	tbEvents.fnClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playBackEffect()
			MainGuildCtrl.getGuildInfo()
		end
	end

	-- 建设
	tbEvents.fnConstruct = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnConstruct")
			AudioHelper.playCommonEffect()
			if GuildUtil.isInJoinCD() == false then
				buildAction(sender:getTag())
			else
				ShowNotice.showShellInfo(m_i18n[3738])
			end
			
			
		end
	end
	local view = GuildHallView.create(tbEvents)
	LayerManager.changeModule(view, GuildHallCtrl.moduleName(), {1}, true)
	PlayerPanel.addForUnionPublic()
end

function create(...)
	-- 拉数据回调
	function recordCallBack( cbFlag, dictData, bRet )
		if(dictData.err == "ok") then
			GuildDataModel._recordList = dictData.ret
			createView( )
		end
	end
	RequestCenter.guild_record(recordCallBack)
end

-- FileName: AdvRecruitCtrl.lua
-- Author: zhangqi
-- Date: 2015-04-03
-- Purpose: 慕名而来奇遇事件主控模块
--[[TODO List]]

module("AdvRecruitCtrl", package.seeall)

-- 模块局部变量 --
local m_i18n = gi18n
local m_defTimeString = "00:00:00"

local function init(...)
	m_viewInstance = nil
end

function destroy(...)
	init()
	package.loaded["AdvRecruitCtrl"] = nil
end

function moduleName()
    return "AdvRecruitCtrl"
end

function create(eventInfoId)
	init()

	require "script/module/adventure/AdventureModel"
	local tbEvent = AdventureModel.getEventItemById(eventInfoId)

	require "db/DB_Exploration_things"
	local dbData = DB_Exploration_things.getDataById(tbEvent.etid)
	logger:debug(dbData)

	require "db/DB_Heroes"
	local dbHero = DB_Heroes.getDataById(dbData.heroID)

	local tbArgs = {}

	tbArgs.complete = tbEvent.complete -- 记录事件是否完成
	
	tbArgs.sTitle = dbData.title
	tbArgs.sModelImg = "images/base/hero/body_img/" .. dbHero.body_img_id
	tbArgs.sName = dbHero.name

	tbArgs.ModelEvent = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
	        require "script/module/partner/PartnerInfoCtrl"
	        local pHeroValue = dbHero --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
	        local heroInfo = {htid = dbHero.fragment ,hid = 0 ,strengthenLevel = 0 ,transLevel = 0,showOnly = true}
	        tbArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tbArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)

		end
	end

	tbArgs.desc = dbData.desc

	local path, quality = string.match(dbData.foodIcon, "(.*)|(.*)")
	tbArgs.iconPath = "images/base/props/" .. path
	tbArgs.iconQuality = string.format("images/base/potential/color_%s.png", quality)
	tbArgs.iconBorder = string.format("images/base/potential/equip_%s.png", quality)
	tbArgs.sIconName = dbData.foodName
	tbArgs.nQuality = tonumber(quality)

	tbArgs.nCostNum = dbData.heroPrice
	tbArgs.sTime = "18:25:11"

	tbArgs.fnRecruitCallback = function ( ... )
		logger:debug("btnRecruit on clicked, need gold: %d", tbArgs.nCostNum)
		if (UserModel.getGoldNumber() < tbArgs.nCostNum) then
			AudioHelper.playCommonEffect()
			LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
			return
		end

		if (m_viewInstance:getCDString() == m_defTimeString) then
			require "script/module/public/ShowNotice"
			AudioHelper.playCommonEffect()
			ShowNotice.showShellInfo(m_i18n[4364])
			return
		end

		AudioHelper.playBtnEffect("buttonbuy.mp3")
		-- 招募请求回调
		local function recruitCallback( cbFlag, dictData, bRet )
			if (bRet) then
				AdventureModel.setEventCompleted(eventInfoId) -- 置事件完成状态

				UserModel.addGoldNumber(-tbArgs.nCostNum) -- 招募成功扣金币
				-- 影子和伙伴都有推送，不用手工添加到背包

				m_viewInstance:updateOKState() -- 刷新奇遇事件的UI

				-- 构造播放招募动画需要的信息
				local data = {}
				data.tid = dbData.heroID -- 前端默认配置的可招募伙伴tid
				data.num = 1 -- 默认招募的是伙伴，数量为 1
				data.iType = 1 -- 默认招募伙伴为1，影子为 2

				Logger.debug("recruitCallback: dictData ", dictData)
				local ret = dictData.ret
				if (ret and ret.heroFrag and (not table.isEmpty(ret.heroFrag)) ) then
					data.iType = 2 
					for fragId, num in pairs(ret.heroFrag) do
						data.tid = tonumber(DB_Item_hero_fragment.getDataById(fragId).aimItem)
						data.num = tonumber(num)
						break -- 如果有多个影子只取第一个
					end
				end

				require "script/module/shop/RecruitService"
				require "script/module/shop/HeroDisplay"
				HeroDisplay.create(data, 4)
			end
		end

		-- 发送招募请求
		logger:debug("eventInfoId = " .. eventInfoId)
		local tbRpcArgs = {tonumber(eventInfoId),}
		RequestCenter.exploreDoEvent(recruitCallback, Network.argsHandlerOfTable(tbRpcArgs))
	end


	require "script/module/adventure/AdvRecruitView"
	m_viewInstance = AdvRecruitView:new()
	return m_viewInstance:create(tbArgs)
end

function updateCD( sTime )
	if (m_viewInstance) then
		m_viewInstance:updateCD(sTime)
	end
end

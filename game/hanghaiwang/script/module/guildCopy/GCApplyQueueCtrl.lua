-- FileName: GCApplyQueueCtrl.lua
-- Author: yangna
-- Date: 2015-06-04
-- Purpose: 插队界面
--[[TODO List]]

module("GCApplyQueueCtrl", package.seeall)
require "script/module/guildCopy/GCApplyQueueView"
require "script/module/guildCopy/GuildCopyModel"
require "script/module/guild/GuildDataModel"
require "script/module/guildCopy/GCRewardQueueUtil"
-- UI控件引用变量 --

-- 模块局部变量 --
local _tbArgs = {}
local _tbQueueData = nil
local m_i18n = gi18n


local function init(...)

end

function destroy(...)
	package.loaded["GCApplyQueueCtrl"] = nil
end

function moduleName()
    return "GCApplyQueueCtrl"
end

local function addTipLayer( ... )
	local layout = g_fnLoadUI("ui/union_cut_tip.json")
	local nRank = GCRewardQueueUtil.getIndex(_tbQueueData.queue) 
	layout.TFD_RANK_NOW:setText(string.format(m_i18n[5909],nRank)) 
	layout.TFD_NEED_GIVE:setText(tostring(GCRewardQueueModel.getCutNeed()))  --消耗贡献
	layout.TFD_OWN_NUM:setText(tostring(GuildDataModel.getSigleDoante()))   --个人拥有贡献度
	
	-- 每人补偿贡献度
	local nNeedGet = GCRewardQueueModel.getCutCompensate(nRank)
	layout.TFD_NEED_GIVE2:setText(tostring(nNeedGet))

	layout.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	layout.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)
		
	UIHelper.titleShadow(layout.BTN_CANCEL,m_i18n[1625])
	UIHelper.titleShadow(layout.BTN_CONFIRM,m_i18n[5901])	  
	layout.BTN_CONFIRM:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			LayerManager.removeLayout()

			if (tonumber(GuildDataModel.getSigleDoante()) < tonumber(GCRewardQueueModel.getCutNeed())) then 
				ShowNotice.showShellInfo(m_i18n[5902])   -- "个人贡献度不足，无法插队"
				return 
			end 

			-- 插队时间判定
			if (not GCRewardQueueModel.isCanInsertQueue()) then 
				ShowNotice.showShellInfo(string.format(m_i18n[5903],GCRewardQueueModel.getCurForbidTime()))   --"小于%d秒内不可插队"
				return 
			end 

			local copyid = GCRewardQueueModel.getCurCopyId()

			local function callback( cbFlag, dictData, bRet )
				logger:debug("插队返回")
				logger:debug(dictData)

				if (bRet) then 
					if (dictData.ret.res=="close") then 
						ShowNotice.showShellInfo(m_i18n[5904])   --"会长未开启插队功能"
					elseif (dictData.ret.res=="ok") then 
					    GuildDataModel.addSigleDonate(-tonumber(GCRewardQueueModel.getCutNeed()))
						GuildCopyModel.addJumpNum()

						-- 刷新单个副本数据
						local tbCopyData = DataCache.getGuildCopyData()
						tbCopyData[dictData.ret.gc_id] = dictData.ret
						GCRewardQueueModel.initPlayerQueueInfo(copyid)   --刷新新队伍信息

						-- 刷新ui和数据
						GCApplyQueueCtrl.resetData()
						GCRewardQueueCtrl.resetData()
					else
						ShowNotice.showShellInfo(m_i18n[5905])   --"队列信息已变化" 

						-- local function re_callback( cbFlag, dictData, bRet )
						-- 	if (bRet) then 
						-- 		-- 刷新单个副本数据
						-- 		local tbCopyData = DataCache.getGuildCopyData()
						-- 		tbCopyData[dictData.ret.gc_id] = dictData.ret
						-- 		GCRewardQueueModel.initPlayerQueueInfo(copyid)   --刷新新队伍信息

						-- 		-- 刷新ui和数据
						-- 		GCApplyQueueCtrl.resetData()
						-- 		GCRewardQueueCtrl.resetData()
						-- 	end 
						-- end

						-- -- 拉取单个副本数据，刷新当前页面
						-- local arg = Network.argsHandler(tonumber(copyid))
						-- RequestCenter.guildCopy_getOneCopyInfo(re_callback,arg)
					end 
				end 
			end
		
			local rewardType = _tbQueueData.rewardConf[1]
			local subtype = _tbQueueData.rewardConf[2]
			local isJump = 1
			local arg = Network.argsHandler(tonumber(copyid),rewardType,subtype,isJump)
			RequestCenter.guildCopy_queueHere(callback,arg)
		end
	end)

	LayerManager.addLayout(layout)
end

-- 插队
_tbArgs.onInsert = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 判断今日是否已经插过队
		if (GuildCopyModel.getJumpNum()>0) then 
			ShowNotice.showShellInfo(m_i18n[5906])   --"您今日已经插过队了"
			return 
		end 

		-- 是否在队伍中
		if (not GCRewardQueueUtil.isUserInQueue(_tbQueueData.queue)) then 
			ShowNotice.showShellInfo(m_i18n[5907])   --"需要先申请该奖励才可以插队"
			return 
		end 
		-- 插队时间判定
		if (not GCRewardQueueModel.isCanInsertQueue()) then 
			ShowNotice.showShellInfo(string.format(m_i18n[5903],GCRewardQueueModel.getCurForbidTime()))   --"小于%d秒内不可插队"
			return 
		end 

		local copyid = GCRewardQueueModel.getCurCopyId()

		local function callback( cbFlag, dictData, bRet )
			logger:debug(dictData)

			if (bRet) then 
				-- 刷新单个副本数据
				local tbCopyData = DataCache.getGuildCopyData()
				tbCopyData[dictData.ret.gc_id] = dictData.ret
				GCRewardQueueModel.initPlayerQueueInfo(copyid)   --刷新新队伍信息

				-- 刷新ui和数据
				GCApplyQueueCtrl.resetData()
				GCRewardQueueCtrl.resetData()


				local index = GCRewardQueueUtil.getIndex(_tbQueueData.queue)
				if (index==1) then 
					ShowNotice.showShellInfo(m_i18n[5908])   --"当前已经是第一名"
				elseif (index>1) then
					addTipLayer()
				else
					ShowNotice.showShellInfo(m_i18n[5907])   --"需要先申请该奖励才可以插队"
				end 
			end 
		end

		-- 拉取单个副本数据，刷新当前页面
		local arg = Network.argsHandler(tonumber(copyid))
		RequestCenter.guildCopy_getOneCopyInfo(callback,arg)
	end
end

-- 插队后刷新数据和页面
-- 1 玩家还再队伍中 2 玩家不再队伍中 3 玩家不再队伍中且该物品不在奖励中了
function resetData( ... )
	local data = _tbQueueData
	_tbQueueData = GCRewardQueueModel.getUserQueueData()
	
	if ( _tbQueueData==nil) then 
		logger:debug("发奖之后，玩家已经不在队伍中")
		local copyid = GCRewardQueueModel.getCurCopyId()
		local tbCopyRewardData = GCRewardQueueModel.getRewardQueueData(copyid)
		for k, v in pairs(tbCopyRewardData) do 
			if (data.rewardConf[1]==v.rewardConf[1] and data.rewardConf[2]==v.rewardConf[2] and data.rewardConf[3]==v.rewardConf[3]) then 
				_tbQueueData = v 
				break
			end 
		end 
	end 

	-- 奖励中也没有的
	if (not _tbQueueData) then 
		_tbQueueData = {}
		_tbQueueData.queue = {}
		_tbQueueData.visibleNum = 0
	end 


	logger:debug("刷新队列数据")
	logger:debug(_tbQueueData)

	GCApplyQueueView.refreashUI(_tbQueueData)
end


function create(tbQueueData)
	_tbQueueData = tbQueueData
	local layout = GCApplyQueueView.create(_tbArgs,tbQueueData)
	LayerManager.addLayout(layout)
end

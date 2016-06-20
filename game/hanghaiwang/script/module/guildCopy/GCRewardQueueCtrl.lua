-- FileName: GCRewardQueueCtrl.lua
-- Author: yangna
-- Date: 2015-06-03
-- Purpose: 奖励队列
--[[TODO List]]

module("GCRewardQueueCtrl", package.seeall)

require "script/module/guildCopy/GCRewardQueueView"
require "script/module/guildCopy/GuildCopyModel"
require "script/module/guildCopy/GCRewardQueueModel"
require "script/module/guildCopy/GCApplyQueueCtrl"
require "script/network/RequestCenter"
require "script/network/Network"
require "db/DB_Legion_newcopy"
require "script/module/guildCopy/GCRewardQueueUtil"


-- UI控件引用变量 --

-- 模块局部变量 --
local _tbArgs = {}
local _tbRewardData = nil
local _copyId = nil
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCRewardQueueCtrl"] = nil
end

function moduleName()
    return "GCRewardQueueCtrl"
end


--[[desc:是否放弃当前队伍提示
    tbOldData：原队伍所在的奖励数据
    newQueneid: 新申请的队伍id,（当前奖励数据id）
    callback:
—]]
local function addTipLayer( tbOldData,newQueneid,callback )
	local layout = g_fnLoadUI("ui/union_abadon_reward.json")

	local tbData = GCRewardQueueModel.getIconAndNameByOne(tbOldData)
	local oldname = tbData.name
	local rank = GCRewardQueueUtil.getIndex(tbOldData.queue)
	local lay_fit1 = layout.LAY_FIT1
	lay_fit1.TFD_ITEM_NAME:setText("[" .. oldname .. "]")
	lay_fit1.TFD_RANK_NUM:setText(rank)
	lay_fit1.TFD_ITEM_NAME:setColor(g_QulityColor[tbData.quality])


	local copyName = DB_Legion_newcopy.getDataById(GCRewardQueueModel.getUserCopyId()).name
	lay_fit1.TFD_ITEM_COPY:setText(copyName)  --旧副本名


	if (newQueneid) then 
		local tbData = GCRewardQueueModel.getIconAndNameByOne(_tbRewardData[newQueneid])
		local newname = tbData.name
		layout.TFD_ITEM_NAME_NEW:setText("[" .. newname .. "]")
		layout.TFD_ITEM_NAME_NEW:setColor(g_QulityColor[tbData.quality])
		local copyName = DB_Legion_newcopy.getDataById(_copyId).name
		layout.TFD_ITEM_COPY_NEW:setText(copyName) --新副本名
	else
		layout.LAY_FIT3:setVisible(false)
	end 

	UIHelper.titleShadow(layout.BTN_CANCEL,m_i18n[1993])
	UIHelper.titleShadow(layout.BTN_CONFIRM,m_i18n[5901])   --"确认"
	layout.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)
	layout.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	layout.BTN_CONFIRM:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			LayerManager.removeLayout()
			callback()
		end 
	end)
	LayerManager.addLayout(layout)
end

-- 申请
_tbArgs.onApply = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		
		local nTag = sender:getTag()
		-- 是否已经在队列中
		local isInQueue = GCRewardQueueModel.getIsInQueue()
		local tbOldQueueData = nil  --之前队伍所在的数据
		if (isInQueue) then 
			tbOldQueueData = GCRewardQueueModel.getUserQueueData()
		end 

		local function callBack(cbFlag, dictData, bRet)
			logger:debug(cbFlag)
			logger:debug(dictData)
			logger:debug(bRet)
			if (bRet) then 
				ShowNotice.showShellInfo(string.format(m_i18n[5911],sender.itemname))  --"加入%s申请队列成功"

				if (isInQueue) then 
					GCRewardQueueUtil.removeUser(tbOldQueueData.queue)
				end 

				-- 刷新单个副本数据
				local tbCopyData = DataCache.getGuildCopyData()
				tbCopyData[dictData.ret.gc_id] = dictData.ret
				GCRewardQueueModel.initPlayerQueueInfo(_copyId)   --刷新新队伍信息
				resetData()
			end 
		end

	
		if (isInQueue) then 
			addTipLayer( tbOldQueueData ,nTag,function ( ... )
				local rewardType = _tbRewardData[nTag].rewardConf[1]
				local subtype = _tbRewardData[nTag].rewardConf[2]
				local isJump = 0
				local arg = Network.argsHandler(tonumber(_copyId),rewardType,subtype,isJump)
				RequestCenter.guildCopy_queueHere(callBack,arg)
			end)
		else 
			local rewardType = _tbRewardData[nTag].rewardConf[1]
			local subtype = _tbRewardData[nTag].rewardConf[2]
			local isJump = 0
			local arg = Network.argsHandler(tonumber(_copyId),rewardType,subtype,isJump)
			RequestCenter.guildCopy_queueHere(callBack,arg)
		end 
	end 
end

-- 放弃申请
_tbArgs.onAbandon = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()

		local tbOldQueueData = GCRewardQueueModel.getUserQueueData()

		local function callBack(cbFlag, dictData, bRet)
			if (bRet) then 
				ShowNotice.showShellInfo(m_i18n[5912])  --"成功放弃申请"
				GCRewardQueueModel.setIsInQueue(false,nil,nil)

				-- 刷新单个副本数据
				local tbCopyData = DataCache.getGuildCopyData()
				tbCopyData[dictData.ret.gc_id] = dictData.ret
				resetData()
			end 
		end
		
		addTipLayer(tbOldQueueData,nil,function ( ... )
			local copyid = GCRewardQueueModel.getCurCopyId()
			local rewardType = tbOldQueueData.rewardConf[1]
			local subtype = tbOldQueueData.rewardConf[2]
			local arg = Network.argsHandler(tonumber(copyid),rewardType,subtype)
			RequestCenter.guildCopy_leaveQueue(callBack,arg)
		end)
	end
end

-- 队列详情
_tbArgs.onQueneContent = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local nTag = sender:getTag()
		GCApplyQueueCtrl.create(_tbRewardData[nTag])
	end
end

-- 插队排队刷新数据
function resetData( )
	_tbRewardData = GCRewardQueueModel.getRewardQueueData(_copyId)
	if (GCRewardQueueView.getMainLay()) then 
		GCRewardQueueView.refreashListView(_tbRewardData)
	end 
end


function create(copyId)
	_copyId = copyId

	-- 刷新当前副本数据
	local function callback( cbFlag, dictData, bRet )
		logger:debug(dictData)
		if (bRet) then 
			-- 刷新单个副本数据
			GCRewardQueueModel.setCurCopyId(_copyId)
			local tbCopyData = DataCache.getGuildCopyData()
			tbCopyData[dictData.ret.gc_id] = dictData.ret
				
			-- 定位玩家所在的队伍
			GCRewardQueueModel.initPlayerQueueInfo()
			_tbRewardData = GCRewardQueueModel.getRewardQueueData(_copyId)
			local rewardRankView = GCRewardQueueView.create(_tbArgs, _tbRewardData)
			LayerManager.addLayout(rewardRankView)
		end 
	end

	-- 拉取单个副本数据，刷新当前页面
	local arg = Network.argsHandler(tonumber(_copyId))
	RequestCenter.guildCopy_getOneCopyInfo(callback,arg)



end

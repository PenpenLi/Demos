-- FileName: MainRankCtrl.lua
-- Author: zhangjunwu
-- Date: 2016-02-03
-- Purpose: 排行榜ctrl
--[[TODO List]]

module("MainRankCtrl", package.seeall)
require "script/module/rank/MainRankView"
require "script/module/rank/RankService"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18nString = gi18nString

function destroy(...)
	package.loaded["MainRankCtrl"] = nil
end

function moduleName()
    return "MainRankCtrl"
end

function onChatIcon( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (not SwitchModel.getSwitchOpenState(ksSwitchGuild,true)) then
			return 
		end
		local uid = sender:getTag()

		
		
		local bFirend = false
		function requestFunc(cbFlag, dictData, bRet)
			if(bRet == true)then
				local dataRet = dictData.ret
				if(dataRet == "true" or dataRet == true )then
					bFirend = true
				end
				if(dataRet == "false" or dataRet == false  )then
					bFirend = false
				end
			end
			local tbLeaderInfo  = RankModel.getCurRankUnionDatabyLeaderUid(uid)
			logger:debug(tbLeaderInfo)
			if(tbLeaderInfo) then
				--构造交流界面所需要的数据
				local tbUserInfo 		= {}
				tbUserInfo.isFriend	 	= bFirend
				tbUserInfo.uname 		= tbLeaderInfo.leader_name
				tbUserInfo.utid     	= tbLeaderInfo.leader_utid
				tbUserInfo.level 		= tbLeaderInfo.leader_level
				tbUserInfo.fight_force  = tbLeaderInfo.leader_force
				tbUserInfo.type 		= "1"
				tbUserInfo.dress      	= tbLeaderInfo.leader_dress
				tbUserInfo.uid 			= uid
				tbUserInfo.figure 		= tbLeaderInfo.leader_figure
				CommunicationCtrl.create(tbUserInfo)
			end

		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(tonumber(uid)))
		Network.rpc(requestFunc, "friend.isFriend", "friend.isFriend", args, true)
	end
end

-- 申请按钮回调
function applyCallFun(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		
		if (not SwitchModel.getSwitchOpenState(ksSwitchGuild,true)) then
			return 
		end


		--军团id
		local tag = sender:getTag()
		local tbUnionData = RankModel.getCurRankUnionDatabyUnionId(tag)
		-- 已经申请3个了不可以申请
		local applyCount = RankModel.getApplyNum()

		if(applyCount >= g_ApplyMax)then
			local str = m_i18nString(3511) --"您当前申请的军团已达到上限！"
			ShowNotice.showShellInfo(str)
			return
		end
		-- 申请军团请求回调
		local function getApplyCallback(  cbFlag, dictData, bRet  )
			if(dictData.err == "ok")then
				if( dictData.ret == "ok")then
					tbUnionData.apply = 1
					applyCount = applyCount + 1
					RankModel.setApplyNum(applyCount)
					MainRankView.reloadGuildListView()
					local str = m_i18nString(3514) --"申请联盟成功，请等待审核~"
					ShowNotice.showShellInfo(str)
				end
			end
		end
		-- 申请接口参数
		local args = CCArray:create()
		args:addObject(CCInteger:create(tag))
		RequestCenter.guild_applyGuild(getApplyCallback,args)
	end
end

-- 撤销申请按钮回调
function applyCancleCallFun(sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		local tag = sender:getTag()   --军团id
		local tbUnionData = RankModel.getCurRankUnionDatabyUnionId(tag)
		-- 已经申请3个了不可以申请
		local applyCount = RankModel.getApplyNum()
		-- 取消申请军团请求回调
		local function getCancelApplyCallback(  cbFlag, dictData, bRet  )
			if(dictData.err == "ok")then
				if( bRet)then
					tbUnionData.apply = 0
					applyCount = applyCount - 1
					RankModel.setApplyNum(applyCount)
					MainRankView.reloadGuildListView()
				end
			end
		end
		local args = CCArray:create()
		args:addObject(CCInteger:create(tag))
		RequestCenter.guild_cancelApply(getCancelApplyCallback,args)
	end
end


-- 更多军团请求回调
function getMoreGuildListCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		if(not table.isEmpty(dictData.ret))then
			--新军团的个数
			local newDataCount =  table.count(dictData.ret.data)
			-- 军团10条数据
			RankModel.setRankListData( dictData.ret.data, dictData.ret.offset )
			MainRankView.reloadGuildListView()
		end
	end
end
-- 更多军团按钮回调
function onMoreCell( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("更多军团按钮回调")
		-- 音效
		AudioHelper.playCommonEffect()
		local indexTab = RankModel.getCurTabIndex()
		local offset = sender:getTag()
		sender:setTouchEnabled(false)
		if(indexTab == RankModel.T_GuildRank) then
			
			-- 列表数据
			local args = CCArray:create()
			args:addObject(CCInteger:create(offset))
			args:addObject(CCInteger:create(10))
			args:addObject(CCInteger:create(1))
			RequestCenter.guild_getGuildList(getMoreGuildListCallback,args)
		else
			local allData = RankModel.getAllRankData()
			logger:debug(offset)
			RankModel.setOtherRankListData(allData,offset)
			MainRankView.reloadGuildListView()
		end
	end
end


-- 对方阵容按钮
function onFormation( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("对方阵容按钮")
		-- 音效
		AudioHelper.playCommonEffect()
		FormationCtrl.loadFormationWithUid(sender:getTag(), true)
	end
end

local function getRankDataCallBack( ... )
	-- 创建全部邮件列表
	-- MainMailView.updateTableData(MailData.showMailData)
	LayerManager.removeUILayer()
	MainRankView.initListViewBy()
end

function create()
	local tbOnTouch = {}
	-- tab点击按钮
	tbOnTouch.onTabBtn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local nPreIndex = RankModel.getCurTabIndex()
			local indexTab = sender:getTag()

			if(indexTab == RankModel.T_GuildRank and nPreIndex ~= indexTab) then
				RankModel.fnCleanListData()
				RankService.getGuildRankList(0,10,getRankDataCallBack)

			elseif(indexTab == RankModel.T_FightRank and nPreIndex ~= indexTab) then
				RankModel.fnCleanListData()
				RankService.getFightRankList(0,10,getRankDataCallBack)

			elseif(indexTab == RankModel.T_LevelRank and nPreIndex ~= indexTab) then
				RankModel.fnCleanListData()
				RankService.getLevelRankList(0,10,getRankDataCallBack)

			elseif(indexTab == RankModel.T_PrisonRank and nPreIndex ~= indexTab) then
				RankModel.fnCleanListData()
				RankService.getPrisonRankList(0,10,getRankDataCallBack)

			elseif(indexTab == RankModel.T_CopyRank and nPreIndex ~= indexTab) then
				RankModel.fnCleanListData()
				RankService.getCopyRankList(0,10,getRankDataCallBack)
			end
			MainRankView.setTabBtnStats(indexTab)
			RankModel.setCurTabIndex(indexTab)
		end
	end	


	local function requestFunc( cbFlag, dictData, bRet )
		if(not table.isEmpty(dictData.ret))then

			RankModel.fnCleanListData()
			RankModel.setTotleNum(table.count(dictData.ret[2]))
			RankModel.setAllRankData(dictData.ret[2])
			RankModel.setSelfRankValue(dictData.ret[1].selfRank)
			logger:debug(dictData.ret[2])
			RankModel.setOtherRankListData( dictData.ret[2],0)
			
			LayerManager.removeUILayer()

			local layMain = MainRankView.create( tbOnTouch )
			LayerManager.changeModule(layMain, MainRankView.moduleName(), {1, 3}, true)
			PlayerPanel.addForPublic()
			MainRankView.initListViewBy()
			MainRankView.setTabBtnStats(RankModel.T_FightRank)
		end
	end
	-- 列表数据
	local args = CCArray:create()
	-- args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(100))
	RequestCenter.user_rankByFightForce(requestFunc,args)
	-- RequestCenter.copy_getCopyProRank(requestFunc,args)

end

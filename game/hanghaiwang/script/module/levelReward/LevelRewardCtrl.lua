-- FileName: LevelRewardCtrl.lua
-- Author: menghao
-- Date: 2014-06-13
-- Purpose: 等级奖励ctrl


module("LevelRewardCtrl", package.seeall)


require "script/module/levelReward/LevelRewardCopyView"
require "db/DB_Level_reward"


-- UI控件引用变量 --


-- 模块局部变量 --
local m_tbDataSource
local index
local m_nType

-- zhangqi, 2015-11-26, 增加一个滑动礼包列表的方法供外部调用
function scrollToReward( ... )
	local totalCnt = m_tbDataSource == nil and 0 or #m_tbDataSource
	logger:debug({index = index, totalCnt = totalCnt})
	NewLevelRewardView.scrollPassGetRow( index or totalCnt)
end

-- 获取所有奖励的信息
function getAllRewardData(tbReceivedReward)
	local tData = {}
	for k,v in pairs(DB_Level_reward.Level_reward) do
		table.insert(tData, v)
	end

	local rewardData = {}
	for k,v in pairs(tData) do
		table.insert(rewardData, DB_Level_reward.getDataById(v[1]))
	end

	local function keySort ( rewardData_1, rewardData_2 )
		return tonumber(rewardData_1.level ) < tonumber(rewardData_2.level)
	end
	table.sort( rewardData, keySort)

	m_tbDataSource = {}
	index = nil
	dataNums = 0
	for k,v in pairs(rewardData) do
		local tbData = {}
		tbData.title = v.level
		tbData.level = tonumber(v.level)
		-- status 0为不可领取，1为可领取但没领取，2为可领已经领取
		tbData.status = 0
		if (tonumber(v.level) <= tonumber(UserModel.getHeroLevel())) then
			tbData.status = 1
			if tbReceivedReward then
				for i=1,#tbReceivedReward do
					if (tonumber(tbReceivedReward[i]) == tonumber(v.id)) then
						tbData.status = 2
					end
				end
			end
		end
		if ((not index) and tbData.status ~= 2) then
			index = v.id
		end
		tbData.rid = v.id
		tbData.item = {}
		for i=1,4 do
			if v["reward_type" .. i] then
				local tb = {}
				tb.icon = { reward_type = v["reward_type" .. i], reward_values = v["reward_values" .. i]}
				tb.name = v["reward_desc" .. i]
				tb.quality = v["reward_quality" .. i]
				if i == 1 then
					tb.desc = v.reward_content1
				end
				table.insert(tbData.item, tb)
			end
		end
		table.insert(m_tbDataSource, tbData)
		dataNums =  dataNums + 1
	end

	return m_tbDataSource
end


-- 获取等级礼包的网络信息
local function showLayer()
	local function onClose( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	require "script/module/levelReward/LevelRewardNewView"
	require "script/module/levelReward/NewLevelRewardView"
	local layMain
	if (m_nType == 2) then -- 2显示列表
		layMain = LevelRewardNewView.create({closeEvent = onClose, tbData = m_tbDataSource, index = index,listViewType=1})
		LayerManager.addLayout(layMain)
		LevelRewardNewView.scrollPassGetRow( index or #m_tbDataSource)
	elseif (m_nType == 3) then --
		local view = NewLevelRewardView.create({tbData = m_tbDataSource, index = index})
		MainWonderfulActCtrl.addLayChild(view)
		-- scrollToReward() -- zhangqi, 2015-11-26
	else
		layMain = LevelRewardCopyView.create(m_tbDataSource[index])
		LayerManager.addLayout(layMain)
	end
end


local function init(...)

end


function destroy(...)
	package.loaded["LevelRewardCtrl"] = nil
end


function moduleName()
	return "LevelRewardCtrl"
end


-- 升级后更新数据
function updateForLVUp( ... )
	local lv = UserModel.getHeroLevel()
	local i = index
	while (m_tbDataSource[i] and lv >= m_tbDataSource[i].level) do
		-- 如果原本不可领取
		if (m_tbDataSource[i].status == 0) then
			m_tbDataSource[i].status = 1
		end
		i = i + 1
	end
end


-- 获取可领取的奖励数
function getRewardNum( ... )
	local num = 0
	for i=1,#m_tbDataSource do
		if (m_tbDataSource[i].status == 1) then
			num = num + 1
		end
	end
	return num
end


function setRewardStatus( idx )
	-- m_tbDataSource[idx].status = 2
	while index <= #m_tbDataSource and m_tbDataSource[index].status == 2 do
		index = index + 1
	end
	if index > #m_tbDataSource then
		index = nil
	end
	
end


function getCurRewardInfo( ... )
	return m_tbDataSource[index]
end

function getAllRewardInfo( ... )
	return m_tbDataSource
end


-- type默认为主页入口，传入1为副本处入口
function create( nType )
	m_nType = nil
	m_nType = nType or nil
	if (not SwitchModel.getSwitchOpenState(ksSwitchLevelGift,true)) then
		return
	end
	showLayer()

end


-- FileName: NewUpgrageModel.lua
-- Author: Xufei
-- Date: 2015-07-22
-- Purpose: 升级模块改版 数据模块
--[[TODO List]]

module("NewUpgrageModel", package.seeall)
require "db/DB_Normal_config"
require "db/DB_Level_up_guide"

-- UI控件引用变量 --

-- 模块局部变量 --
local _noticeText = nil

--得到引导图标路径
function getImagePath( imgName )
	local imgPath = "images/upgrade/"
	return (imgPath .. imgName)
end

--[[desc:得到升级引导信息的数据
    arg1: 无
    return: {1={name="", icon="", desc="", lv="", jump="", effect=""}, 2={...}, 3={...}} 
—]]
function getGuideData()
	local level = tonumber(UserModel.getUserInfo().level)
	local dbLevelUpGuide = DB_Level_up_guide.getDataById(level)
	local tbData = {}
	--目前配置是三个引导，每个引导有六条数据
	for i = 1, 3 do
		tbData[i] = {}
		tbData[i].name = dbLevelUpGuide["name"..i]
		tbData[i].icon = dbLevelUpGuide["icon"..i]
		tbData[i].desc = dbLevelUpGuide["desc"..i]
		tbData[i].lv = dbLevelUpGuide["lv"..i]
		tbData[i].jump = dbLevelUpGuide["jump"..i]
		tbData[i].effect = dbLevelUpGuide["effect"..i]
	end

	logger:debug({dataGuide = tbData})
	return tbData
end

--[[desc:得到面板显示等级体力耐力的数据
    arg1: 无
    return: {oldLv="", newLv="", oldExecu="", newExecu="", 
    		oldStami="", newStami="", openExplore=""}
—]]
function getValueData()
	local userInfo = UserModel.getUserInfo()
	local tbData = {}
	local tbUpgradeRewards = getUpgradeRewards()
	--得到升级前的数据
	tbData.oldLv = tostring(userInfo.level - 1)
	tbData.oldExecu = tostring(userInfo.execution) - tbUpgradeRewards.execu
	tbData.oldStami = tostring(userInfo.stamina) - tbUpgradeRewards.stami
	--得到升级后的数据
	tbData.newLv = tostring(userInfo.level)
	tbData.newExecu = tostring(userInfo.execution)
	tbData.newStami = tostring(userInfo.stamina)
	--得到是否开启了探索
	tbData.openExplore = (SwitchModel.getSwitchOpenState(ksSwitchExplore, false))

	logger:debug({dataValue = tbData})
	return tbData
end

--[[desc:更新升级后的体力和耐力用户数据
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function addUpgradeRewards()
	local tbUpgradeRewards = getUpgradeRewards()
	UserModel.addEnergyValue(tbUpgradeRewards.execu)
	UserModel.addStaminaNumber(tbUpgradeRewards.stami)
end

--[[desc:获得升级时奖励的体力和耐力数
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function getUpgradeRewards()
	tbUpgradeRewards = {}
	--得到配置的奖励额度
	local execuInfo = lua_string_split(DB_Normal_config.getDataById(1).Level_execution, '|')
	local stamiInfo = lua_string_split(DB_Normal_config.getDataById(1).Level_stamina, '|')
	--得到对应等级的奖励额度
	local oldLevel = tonumber(UserModel.getUserInfo().level-1)
	tbUpgradeRewards.execu = tonumber(execuInfo[oldLevel])
	tbUpgradeRewards.stami = tonumber(stamiInfo[oldLevel])

	return tbUpgradeRewards
end




local function init(...)

end

function destroy(...)
	package.loaded["NewUpgrageModel"] = nil
end

function moduleName()
    return "NewUpgrageModel"
end

function create(...)

end

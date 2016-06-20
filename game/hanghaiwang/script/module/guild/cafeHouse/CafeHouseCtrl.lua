-- FileName: CafeHouseCtrl.lua
-- Author: menghao
-- Date: 2014-09-16
-- Purpose: 人鱼咖啡厅ctrl


module("CafeHouseCtrl", package.seeall)


require "script/module/guild/cafeHouse/CafeHouseView"
require "script/module/guild/cafeHouse/CafeRewardCtrl"
require "script/module/guild/GuildDataModel"
require "script/module/guild/GuildUtil"

require "db/DB_Legion_feast"


-- UI控件引用变量 --


-- 模块局部变量 --
local mi18n = gi18n


local function init(...)

end


function destroy(...)
	package.loaded["CafeHouseCtrl"] = nil
end


function moduleName()
	return "CafeHouseCtrl"
end



function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	if not bRet then
		return
	end

	if (cbFlag == "guild.reward") then
		if dictData.ret.ret == "ok" then
			GuildDataModel.addBaiGuangongTimes(-1)
			GuildDataModel.addSigleDonate(-DB_Legion_feast.getDataById(1).contributeCost)

			local function showReward( ... )
				local nowLevel = dictData.ret.level
				local guanGongInfo = DB_Legion_feast.getDataById(1)

				local tbItem = {}
				local rate = OutputMultiplyUtil.getMultiplyRateNum(7)  --限时福利奖励倍率
				-- 体力
				local growTili = math.floor(guanGongInfo.baseExecution + guanGongInfo.growExecution * nowLevel / 100)
				growTili = math.floor(growTili * rate / 10000)  
				UserModel.addEnergyValue(growTili)
				if (growTili > 0) then
					table.insert(tbItem, {icon = ItemUtil.getSmallPhyIconByNum(growTili), name = mi18n[1922]})
				end

				-- 耐力
				local growNaili = math.floor(guanGongInfo.baseStamina + guanGongInfo.growStamina * nowLevel / 100)
				growNaili = math.floor(growNaili * rate / 10000)  
				UserModel.addStaminaNumber(growNaili)
				if (growNaili > 0) then
					table.insert(tbItem, {icon = ItemUtil.getStaminaIconByNum(growNaili), name = mi18n[1923]})
				end

				-- 声望
				local itemNumP = math.floor(guanGongInfo.basePrestige + guanGongInfo.growPrestige * nowLevel / 100)
				itemNumP = math.floor(itemNumP * rate / 10000)  
				UserModel.addPrestigeNum(tonumber(itemNumP))
				if (itemNumP > 0) then
					table.insert(tbItem, {icon = ItemUtil.getPrestigeIconByNum(itemNumP), name = mi18n[1921]})
				end

				-- 银币
				local itemNumSi = math.floor(guanGongInfo.baseSilver + guanGongInfo.growSilver * nowLevel / 100)
				itemNumSi = math.floor(itemNumSi * rate / 10000)  
				logger:debug("itemNumSi = %s", itemNumSi)
				UserModel.addSilverNumber(tonumber(itemNumSi))
				if (itemNumSi > 0) then
					table.insert(tbItem, {icon = ItemUtil.getSiliverIconByNum(itemNumSi), name = mi18n[1520]})
				end

				-- 金币
				local itemNumG = math.floor(guanGongInfo.baseGold + guanGongInfo.growGold * nowLevel / 100)
				itemNumG = math.floor(itemNumG * rate / 10000)  
				UserModel.addGoldNumber(tonumber(itemNumG))
				if (itemNumG > 0) then
					table.insert(tbItem, {icon = ItemUtil.getGoldIconByNum(itemNumG), name = mi18n[2220]})
				end

				local layReward = UIHelper.createGetRewardInfoDlg( gi18n[3739], tbItem )
				LayerManager.addLayout(layReward)
			end

			-- 弹出奖励框
			showReward()
			CafeHouseView.afterDrink()

		end
		if dictData.ret.ret == "failed" then
			ShowNotice.showShellInfo(mi18n[3740])
			CafeHouseView.setString(0)
		end
		if dictData.ret.ret == "exceed" then
			ShowNotice.showShellInfo(mi18n[3741])
			CafeHouseView.setString(0)
		end
	end
end


function baiGuangong()
	local curTime = TimeUtil.getSvrTimeByOffset()
	local date = TimeUtil.getLocalOffsetDate("*t", curTime)
	local nowHour = date.hour
	local nowMin = date.min
	local nowSec = date.sec

	local nowTime = tonumber(nowHour)*10000 + tonumber(nowMin)*100 + tonumber(nowSec)
	local totalGongxian = GuildDataModel.getSigleDoante()

	if (GuildUtil.getCafeCD() ~= 0) then
		ShowNotice.showShellInfo(mi18n[3742])
		return
	end

	if (tonumber(GuildDataModel.getBaiGuangongTimes()) <= 0) then
		ShowNotice.showShellInfo(mi18n[3727])
	elseif (tonumber(DB_Legion_feast.getDataById(1).contributeCost) > tonumber(totalGongxian)) then
		ShowNotice.showShellInfo(mi18n[3745])
	elseif ((tonumber(nowTime) < tonumber(DB_Legion_feast.getDataById(1).beginTime)) or (tonumber(nowHour) > tonumber(DB_Legion_feast.getDataById(1).endTime))) then
		ShowNotice.showShellInfo(mi18n[3741])
	else
		Network.rpc(fnHandlerOfNetwork, "guild.reward","guild.reward", nil, true)
	end
end


function create(...)
	local tbEvents = {}

	tbEvents.onBack = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			MainGuildCtrl.create()
		end
	end

	tbEvents.onReward = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			CafeRewardCtrl.create()
		end
	end

	tbEvents.onDrink = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			baiGuangong()
		end
	end


	local layMain = CafeHouseView.create(tbEvents)
	layMain:addChild(GuildMenuCtrl.create(), 10, 10)

	LayerManager.changeModule( layMain, CafeHouseCtrl.moduleName(), {1}, true)
	PlayerPanel.addForUnionPublic()
end


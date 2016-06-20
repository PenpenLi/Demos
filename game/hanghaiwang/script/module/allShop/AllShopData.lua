-- FileName: AllShopData.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 商店入口整合 数据
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("AllShopData", package.seeall)
require "db/DB_Allshop"
require "script/module/switch/SwitchModel"
require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleData"
require "script/module/arena/MainArenaCtrl"

local function shopRed(  )
	return (DataCache.getRecuitFreeNum() ~= 0) or (DataCache.getCanReceiveVipNUm() ~= 0)
end

local function showMysteryRed(  )
	return MysteryCastleData.isMysteryNewIn() and tonumber(MysteryCastleData.getFreeTimes())>0
end

local function getShopRedNum(  )
	return DataCache.getRecuitFreeNum()+DataCache.getCanReceiveVipNUm()
end

local function getSpeRedNum(  )
	return TreaShopData.getFreeTimes()
end

local function showSpeRed(  )
	return tonumber(TreaShopData.getFreeTimes()) > 0
end

local function showBuyBoxRed(  )
	require "script/module/wonderfulActivity/buyBox/BuyBoxData"
	return tonumber(BuyBoxData.getAllKeyNum()) > 0
end

local function getAwakeRedNum(  )
	return AwakeShopModel.getFreeTimes()
end

local function showAwakeRed(  )
	return tonumber(AwakeShopModel.getFreeTimes()) > 0
end



local function fnBackHere( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		MainScene.homeCallback()
		local view = AllShopCtrl.create()
		LayerManager.addCommonLayout({wigLayout = view, scale = true, animation = true})
	end
end

local function goShop( ... )
		if(not SwitchModel.getSwitchOpenState(ksSwitchShop,true)) then
			return
		end
		require "script/module/shop/MainShopCtrl"
		if (MainShopCtrl.moduleName() ~= LayerManager.curModuleName()) then
			local layShop = MainShopCtrl.create()
			if (layShop) then
				LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
				PlayerPanel.addForPublic()
			end
			MainScene.updateBgLightOfMenu()
		end
end

local function goCastle(  )
	require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleCtrl"
	MysteryCastleCtrl.create(fnBackHere)
end


local function goGuildShop(  )
	if GuildDataModel.getIsHasInGuild() == false then
		ShowNotice.showShellInfo("加入任意公会，才可使用公会商店功能！")--TODO
		return
	end
	require "script/module/guild/MainGuildCtrl"
	MainGuildCtrl.enterShop(fnBackHere)
end

local function goArenaShop()
	require "script/module/arena/ArenaCtrl"
	MainArenaCtrl.getArenaInfo(function (  )
		ArenaCtrl.create(ArenaCtrl.tbType.shop, fnBackHere)
	end)
	
end


local function goSkyPieaShop()
	require "script/module/SkyPiea/SkyPieaShop/SkyPieaShopCtrl"
	SkyPieaShopCtrl.create(fnBackHere)
end

local function goSpecialShop(  )
	require "script/module/treaShop/TreaShopCtrl"
	TreaShopCtrl.create(nil,fnBackHere)
end

local function goEquipShop( )
	require "script/module/impelDown/ImpelShop/ImpelShopCtrl"
	local Arg = {}
	Arg.from = function ( ... )
		fnBackHere(nil, TOUCH_EVENT_ENDED)
	end
	ImpelShopCtrl.create(Arg)
end

local function goAwakeShop(  )
	AwakeShopCtrl.create(fnBackHere)
end

local function goBuyBox(  )
	require "script/module/wonderfulActivity/buyBox/BuyBoxCtrl"
	BuyBoxCtrl.create(nil, fnBackHere)
end

--[[
酒馆 1, 竞技场商店 2， 神秘商店 3， 公会商店 4，装备商店5， 宝物商店6， 神秘空岛商店 7
--]]
local tDbIds = {
				--{id = 1, name = "shop", func = goShop, showRed = shopRed,num=getShopRedNum}, 
				{id = 9, name = "buyBox", func = goBuyBox, showRed = showBuyBoxRed,num=BuyBoxData.getAllKeyNum},
				{id = 6, name = "special", func = goSpecialShop, showRed=showSpeRed, num = getSpeRedNum},
				{id = 2, name = "arena", func = goArenaShop, showRed=function (  ) return false end}, 
				{id = 3, name = "castle", func = goCastle, showRed=showMysteryRed,num=MysteryCastleData.getFreeTimes}, 
				{id = 4, name = "guild", func = goGuildShop, showRed=function (  ) return false end},
				{id = 5, name = "equip", func = goEquipShop, showRed=function (  ) return false end},
				 {id = 7, name = "skyPiea", func = goSkyPieaShop, showRed = function (  ) return false end,},
				 {id = 8, name = "awake", func = goAwakeShop, showRed = showAwakeRed,num=getAwakeRedNum},}
-- local tSwitchIDs = {ksSwitchShop, ksSwitchArena, ksSwitchResolve, ksSwitchGuild, ksSwitchImpelDown, ksSwitchSpeShop, ksSwitchTower}
local tSwitchIDs = {ksSwitchBuyTreasBox,ksSwitchSpeShop, ksSwitchArena, ksSwitchResolve,  ksSwitchGuild, ksSwitchImpelDown, ksSwitchTower, ksSwitchAwake}

function getFilePathById( id )
	local picPath
	if (tonumber(id) ==  3) then
		picPath =  "images/wonderfullAct/"
	else
		picPath =  "images/drop/"
	end
	return picPath
end



function getOpenShopData( )
	local tbShopData = {}
	for i,switchId in ipairs(tSwitchIDs) do
		if(SwitchModel.getSwitchOpenState(switchId,false)) then
			local tIds = tDbIds[i]
			logger:debug({tIds = tIds})
			local tData = DB_Allshop.getDataById(tIds.id)
			tData.func = tIds.func
			tData.showRed = tIds.showRed
			tData.num = tIds.num
			tData.type = tIds.name
			tData.filePath = getFilePathById(tIds.id) .. tData.icon
			table.insert(tbShopData, tData)
		end
	end
	local tOpenData = {}
	local tTemp = {}
	for i,v in ipairs(tbShopData or {}) do
		table.insert(tTemp, v)
		if i%2 == 0 or i==#tbShopData then
			table.insert(tOpenData, tTemp)
			tTemp = {}
		end
	end

	return tOpenData
end


function getIsShowRedTip( ... )
	return showMysteryRed() or showSpeRed() or showBuyBoxRed() or showAwakeRed()
end

function isShowAllShopBtn(  )
	require "db/DB_Normal_config"
	local tData = DB_Normal_config.getDataById(1)
	return tonumber(tData.allshop_start_level) <= tonumber(UserModel.getAvatarLevel()) 
end

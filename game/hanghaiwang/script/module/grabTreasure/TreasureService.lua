-- Filename: TreasureService..lua
-- Author: lichenyang
-- Date: 2013-11-2
-- Purpose: 宝物网络业务层


module("TreasureService", package.seeall)


require "script/module/grabTreasure/TreasureData"
require "script/model/user/UserModel"
require "script/module/public/ItemUtil"


local mi18n = gi18n


-- 获取所有碎片信息（ID和num）
function getSeizerInfo( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			TreasureData.seizerInfoData = dictData.ret
			TreasureData.setCurGrabNum()

			if(callbackFunc ~= nil) then
				callbackFunc()
			end
		end
	end

	RequestCenter.fragseize_getSeizerInfo(requestFunc) -- zhangqi, 2015-09-14
end

-- 获取可抢夺用户信息
function getRecRicher( callbackFunc , item_temple_id)
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			TreasureData.robberInfo = dictData.ret
			if(callbackFunc ~= nil) then
				callbackFunc()
			end
		end
	end

	TreasureData.tbRobberInfo = nil

	local args = CCArray:create()
	args:addObject(CCInteger:create(item_temple_id))
	args:addObject(CCInteger:create(4))
	RequestCenter.fragseize_getRecRicher(requestFunc, args) -- zhangqi, 2015-09-14
end


-- 宝物合成
function fuse( treasure_id, callbackFunc )
	local fragments = TreasureData.getTreasureFragments(treasure_id)
	local treasureId = treasure_id -- zhangqi, 2015-09-29
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug({trea_fuse_dictData = dictData})
		if (bRet) then
			--修改消耗的碎片
			for k,v in pairs(fragments) do
				local itemArr = string.split(v, "|")
				local fragmentID = itemArr[1]
				local numNeed = tonumber(itemArr[2])

				TreasureData.addFragment(fragmentID, -numNeed)
			end
			if(callbackFunc ~= nil) then
				callbackFunc(true, treasureId)
			end
		else
			callbackFunc(false, treasureId)
			return
		end
	end

	local args = CCArray:create()
	args:addObject(CCString:create(treasure_id))
	RequestCenter.trea_fuse(requestFunc,args)
end

-- 被人抢夺通知
function registerPushSeize( callback )
	local callback = function ( callbackFlag, dictReciveData, bSucceed )
		if (bSucceed == true) then

			TreasureData.addFragment(tostring(dictReciveData.ret.fragId), 0 - tonumber(dictReciveData.ret.fragNum))
			if(callback ~= nil) then
				callback()
			end
		end
	end
	RequestCenter.re_fragseize_seize(callback) -- zhangqi, 2015-09-14
end


-- 开启免战
function whiteFlag( freeType, callbackFunc)
	if(tonumber(freeType) ==1) then
		if(UserModel.getGoldNumber()< tonumber(TreasureData.getGlodByShieldTime())) then
			ShowNotice.showShellInfo(mi18n[2440])

			return
		end
	elseif(tonumber(freeType) ==2) then
		local itemTable = TreasureData.getShieldItemInfo()
		local itemInfo = ItemUtil.getCacheItemInfoBy(tonumber(itemTable[1].itemTid))
		if(itemInfo== nil or tonumber(itemInfo.item_num)< tonumber(itemTable[1].num) ) then
			ShowNotice.showShellInfo(mi18n[2441])
			return
		end
	end

	local function requestCallback( cbFlag, dictData, bRet )
		if(bRet == true) then
			--修改消耗的碎片
			if(freeType == 1 ) then
				print("============= ========== ====== =======  ====   === reasureData.getGlodByShieldTime() ", TreasureData.getGlodByShieldTime())
				UserModel.addGoldNumber(-tonumber(TreasureData.getGlodByShieldTime()))
			end

			require "script/utils/TimeUtil"
			if(TreasureData.isShieldState()) then
				local message = mi18n[2444] .. TreasureData.getUsingShieldAddTime() .. mi18n[2445]
				ShowNotice.showShellInfo(message)
			else
				local message = mi18n[2443] .. TreasureData.getUsingShieldAddTime() .. mi18n[2445]
				ShowNotice.showShellInfo(message)
			end
			TreasureData.addShieldTime()
			if(callbackFunc ~= nil) then
				callbackFunc(true)
			end
		end
	end

	local function requestFunc( ... )
		local args = CCArray:create()
		args:addObject(CCInteger:create(freeType))
		Network.rpc(requestCallback, "fragseize.whiteFlag", "fragseize.whiteFlag", args, true)
	end

	local preRequest = function ( ... )
		require "db/DB_Loot"
		require "db/DB_Item_treasure"
		local lootInfo 		= DB_Loot.getDataById(1)
		if(TreasureData.getHaveShieldTime() +  tonumber(lootInfo.shieldTime) > tonumber(lootInfo.shieldTimeLimit)) then
			LayerManager.addLayout(UIHelper.createCommonDlg(
				gi18nString(2438, TreasureData.getUsingShieldAddTime()),
				nil, function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						requestFunc()
						LayerManager.removeLayout()
					end
				end))
		else
			requestFunc()
		end
	end

	local function sureWhite( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			preRequest()
			LayerManager.removeLayout()
		end
	end

	if(TreasureData.isGlobalShieldState()) then
		LayerManager.addLayout(UIHelper.createCommonDlg(mi18n[2442], nil, sureWhite, nil, UIHelper.onClose))
	else
		preRequest()
	end
end


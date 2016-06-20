-- FileName: ChaWelCtrl.lua
-- Author: liweidong
-- Date: 2015-10-19
-- Purpose: 挑战福利ctrl
--[[TODO List]]

module("ChaWelCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ChaWelCtrl"] = nil
end

function moduleName()
    return "ChaWelCtrl"
end

function create(...)
	
	if (ChaWelModel.getCurActitveDbInfo()==nil) then
		ShowNotice.showShellInfo("本轮活动已结束") --TODO
		return
	end
	function getInfoCallback( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({challengeWelfare_getInfo = dictData})
			ChaWelModel.setNewAniState(1)
			local listCell = ChaWelModel.getCell()
			listCell:removeNodeByTag(100)
			ChaWelModel.setChallengeWelInfo(dictData.ret)
			require "script/module/wonderfulActivity/challengeWelfare/ChaWelView" 
			local view = ChaWelView.create()
			MainWonderfulActCtrl.addLayChild(view)

			if (WonderfulActModel.tbBtnActList.challengeWelfare) then
				if (ChaWelModel.getRedTipStatus()>0) then
					WonderfulActModel.tbBtnActList.challengeWelfare:setVisible(true)
					local numberLab = g_fnGetWidgetByName(WonderfulActModel.tbBtnActList.challengeWelfare,"LABN_TIP_EAT")
					numberLab:setStringValue(ChaWelModel.getRedTipStatus())
				else
					WonderfulActModel.tbBtnActList.challengeWelfare:setVisible(false)
				end
			end
		end
	end
	RequestCenter.challengeWelfare_getInfo(getInfoCallback)
end

--点击领取
function onClickGetReward(idx)
	if (ChaWelView.isActiveEnd()) then
		ShowNotice.showShellInfo("本轮活动已结束")
		AudioHelper.playCommonEffect()
		return
	end
	local db = ChaWelModel.getCurActitveDbInfo()
	if (db==nil) then
		ShowNotice.showShellInfo("本轮活动已结束")
		AudioHelper.playCommonEffect()
		return
	end
	if (ItemUtil.isBagFull(true)) then
		return
	end
	function getRewardCallback( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({challengeWelfare_getReward = dictData})
			-- local tbReward = ItemDropUtil.getAdvDropItem({},true) 
			-- ItemDropUtil.refreshUserInfo(tbReward) -- 同步更新贝里、金币的缓存
			local listData = ChaWelModel.getListData()
			local item = listData[idx]
			local tbReward = RewardUtil.parseRewards(item.reward,true)
			local dlg = UIHelper.createRewardDlg(tbReward)
			LayerManager.addLayoutNoScale(dlg)

			ChaWelModel.setRewardStautsByIdx(tonumber(idx))
			ChaWelView.updateUI()

			if (WonderfulActModel.tbBtnActList.challengeWelfare) then
				if (ChaWelModel.getRedTipStatus()>0) then
					WonderfulActModel.tbBtnActList.challengeWelfare:setVisible(true)
					local numberLab = g_fnGetWidgetByName(WonderfulActModel.tbBtnActList.challengeWelfare,"LABN_TIP_EAT")
					numberLab:setStringValue(ChaWelModel.getRedTipStatus())
				else
					WonderfulActModel.tbBtnActList.challengeWelfare:setVisible(false)
				end
			end
		end
	end
	local tbRpcArgs = {db.type,idx-1}
	RequestCenter.challengeWelfare_getReward(getRewardCallback,Network.argsHandlerOfTable(tbRpcArgs))
	AudioHelper.playBtnEffect("tansuo02.mp3")
end
--点击前往完成
function onToComplet(idx)
	if (ChaWelView.isActiveEnd()) then
		ShowNotice.showShellInfo("本轮活动已结束")
		return
	end
	local db = ChaWelModel.getCurActitveDbInfo()
	if (db==nil) then
		ShowNotice.showShellInfo("本轮活动已结束")
		return
	end
	doGoTo(tonumber(db.type))
end
--执行前往
function doGoTo(type)
	if (type==1) then
		require "script/module/copy/MainCopy"
		if (MainCopy.moduleName() ~= LayerManager.curModuleName() or MainCopy.isInExploreMap()) then
			MainCopy.destroy()
			LayerManager.changeModule(Layout:create(), "ExploreAndCopyChange", {}, true)
		
			local layCopy = MainCopy.create()
			if (layCopy) then
				LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
				PlayerPanel.addForCopy()
				MainCopy.updateBGSize()
				MainCopy.setFogLayer()
				
			end
		end
	elseif (type==4) then
		require "script/module/copy/MainCopy"
		MainCopy.extraToExploreScene()
	elseif (type==3) then
		require "script/module/SkyPiea/MainSkyPieaCtrl"
		if (MainSkyPieaCtrl.moduleName() ~= LayerManager.curModuleName()) then
			require "script/module/switch/SwitchModel"
			if(not SwitchModel.getSwitchOpenState(ksSwitchTower,true)) then
				return
			end
		end
		MainSkyPieaCtrl.create()
	elseif (type==2) then
		require "script/module/arena/MainArenaCtrl"  
		if (MainArenaCtrl.moduleName() ~= LayerManager.curModuleName()) then
			require "script/module/switch/SwitchModel"
			if(SwitchModel.getSwitchOpenState(ksSwitchArena,true)) then
			   MainArenaCtrl.create()
			end
		end
	elseif (type==5) then
		--去酒馆 huxiaozhou
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
		goShop()
	elseif (type==6) then
		--去开宝箱
		require "script/module/wonderfulActivity/buyBox/BuyBoxCtrl"
		BuyBoxCtrl.create(nil, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playBackEffect()
					MainScene.homeCallback()
				end
			end)
	end
end
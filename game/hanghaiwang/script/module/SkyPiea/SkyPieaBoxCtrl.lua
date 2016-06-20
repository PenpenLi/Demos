-- FileName: SkyPieaBoxCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-1-14
-- Purpose: 空岛宝箱层开启箱子ctrl


module("SkyPieaBoxCtrl", package.seeall)


require "script/module/SkyPiea/SkyPieaBoxView"


-- UI控件引用变量 --
local popLayer 			= nil 
local m_i18nString = gi18nString
-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaBoxCtrl"] = nil
end


function moduleName()
	return "SkyPieaBoxCtrl"
end

function addUnTouchLayer(  )
	if(popLayer == nil) then
		popLayer = OneTouchGroup:create()
		popLayer:setTouchPriority(g_tbTouchPriority.explore)
		CCDirector:sharedDirector():getRunningScene():addChild(popLayer)
	end
end

function removeUnTouchLayer(  )
	if (popLayer) then
		popLayer:removeFromParentAndCleanup(true)
		popLayer=nil
	end
end

local function openGoldBoxCallBack( cbFlag, dictData, bRet )
	if(bRet) then

		local price = SkyPieaModel.getBuyOpenBoxGoldByTimes()
		UserModel.addGoldNumber(-tonumber(price))

		--增加一次购买次数
		SkyPieaModel.addBuyBoxTimes()
		--更新下次购买的金币数  UI
		SkyPieaBoxView.setGoldUI()

		--弹出奖励框
		local sRewardItems = ""
		for k,v in ipairs(dictData.ret) do
			local tbReward = DB_Sky_piea_box.getDataById(v)
			logger:debug(tbReward.RewardItem)
			sRewardItems = sRewardItems .. tbReward.RewardItem .. ","
		end

		local tbRewards = RewardUtil.parseRewards(sRewardItems,true)

		--更新空岛贝和金币 贝里数据
		updateInfoBar() -- 新信息条统一更新方法

		local rewardLay = UIHelper.createRewardDlg(tbRewards,function ()
																LayerManager.removeLayout()
																SkyPieaBoxView.setMainUIVisible(true)
															 end
													)

		addUnTouchLayer()
		SkyPieaBoxView.addOpenAnimationNode(function ()
												removeUnTouchLayer()
												SkyPieaBoxView.setMainUIVisible(false)
												LayerManager.addLayoutNoScale(rewardLay)

											end
										)
	end
end


local function removeFreeRewardLayout( ... )

end

function create(...)

	local tbEvent = {}

	-- 离开按钮事件
	tbEvent.onLeave = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onLeave")

			AudioHelper.playCloseEffect()
			if(SkyPieaUtil.isShowRewardTimeAlert() == true) then
			 	return 
			end

			local args = CCArray:create()
			local curLayerNum = SkyPieaModel.getCurFloor()
			args:addObject(CCInteger:create(curLayerNum))
			RequestCenter.skyPieaLeaveChest(function (cbFlag, dictData, bRet)
				if(bRet) then
					SkyPieaModel.resetBoxInfo()
					SkyPieaUtil.fnContinue()

				end
			end
			,args)
		end
	end

	-- 开启按钮事件
	tbEvent.onOpen = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onOpen")

			AudioHelper.playCommonEffect()
			if(SkyPieaUtil.isShowRewardTimeAlert() == true) then
			 	return 
			end
			
			local costPrice = tonumber(SkyPieaModel.getBuyOpenBoxGoldByTimes())
			local curGoldNum = UserModel.getGoldNumber()

			local bCanOpen = SkyPieaModel.canOpenBox()
			logger:debug("还可以继续开宝箱么？")
			logger:debug(bCanOpen)
			if(bCanOpen == false) then
				ShowNotice.showShellInfo(m_i18nString(5479)) --"没有开启次数"
				return
			end


			if(curGoldNum >= costPrice)then
				local args = CCArray:create()
				local curLayerNum = SkyPieaModel.getCurFloor()
				args:addObject(CCInteger:create(curLayerNum))
				args:addObject(CCInteger:create(1))
				RequestCenter.skyPieaDealChest(openGoldBoxCallBack,args)
			else
				-- ShowNotice.showShellInfo("钱不够哦")
				local noGoldAlert = UIHelper.createNoGoldAlertDlg()
				LayerManager.addLayout(noGoldAlert)
			end
		end
	end

	--处理购买宝箱界面没有点击离开按钮的逻辑
	local bNeedFreeBox =  SkyPieaModel.needShowFreeBoxLayer()
	local bNeedGoldBox =  SkyPieaModel.needShowGoldBoxLayer()
	logger:debug("needShowFreeBoxLayer = %s" , bNeedFreeBox)
	--处理购买宝箱界面没有点击离开按钮的逻辑
	logger:debug("needShowGoldBoxLayer = %s" , bNeedGoldBox) 
	--是否是开启免费宝箱
	if(bNeedFreeBox) then
			local function getFreeBoxInfoCallBack(cbFlag, dictData, bRet)
				if(bRet) then
					local rewardInfo = {}
					local sRewardItems = ""
					for k,v in ipairs(dictData.ret) do
						local tbReward = DB_Sky_piea_box.getDataById(v)
						logger:debug(tbReward)
						sRewardItems = sRewardItems .. tbReward.RewardItem .. ","
					end
					--更新本地数据
					SkyPieaModel.setFreeBoxState()

					local tbRewards = RewardUtil.parseRewards(sRewardItems ,true)

					--更新空岛贝和金币 贝里数据
					updateInfoBar() -- 新信息条统一更新方法

					LayerManager.addLayoutNoScale(UIHelper.createRewardDlg(tbRewards,
								function ( ... ) -- zhangqi, 2015-12-29
									LayerManager.removeLayout()
									LayerManager.addLayout(SkyPieaBoxView.create(tbEvent))
								end
							)
					)
				end
			end

		SkyPieaUtil.getFreeBoxReward(getFreeBoxInfoCallBack)
	--是否是开启金币宝箱
	elseif(bNeedGoldBox) then
		local layMain = SkyPieaBoxView.create(tbEvent)
		LayerManager.lockOpacity(layMain)
		LayerManager.addLayout(layMain)
	end
end


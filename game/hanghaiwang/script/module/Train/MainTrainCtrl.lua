-- FileName: MainTrainCtrl.lua
-- Author: yangna
-- Date: 2015-10-25
-- Purpose: 修炼系统
--[[TODO List]]

module("MainTrainCtrl", package.seeall)

require "script/module/Train/MainTrainView"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n

local tbBtnEvent = {}

local function init(...)

end

function destroy(...)
	package.loaded["MainTrainCtrl"] = nil
end

function moduleName()
    return "MainTrainCtrl"
end

--返回按钮执行的动作事件
tbBtnEvent.onBacks = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()
		require "script/module/main/MainScene"
		MainScene.homeCallback()
	end
end

tbBtnEvent.onTrain = function ( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then 
		AudioHelper.playCommonEffect()

		MainTrainModel.resetPageId()
		MainTrainView.resetPageView(MainTrainModel.getPageId())

		if ( tonumber(MainTrainModel.getCurTrainId()) >= table.count(DB_Train.Train)) then 
			local dlg = UIHelper.createCommonDlg(m_i18n[2710] , nil ,onClose ,1)  
			LayerManager.addLayoutNoScale(dlg) 
			return 
		end 

		local data = DB_Train.getDataById(MainTrainModel.getNextTrainId())
		local sliverNum = UserModel.getSilverNumber()
		if (sliverNum < tonumber(data.silverCost)) then 
			PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
			ShowNotice.showShellInfo(m_i18n[2702])-- 贝里不足 无法改造
		elseif(tonumber(MainTrainModel.getLeftScore()) < tonumber(data.costCopystar)) then 
			local dlg = UIHelper.createCommonDlg(m_i18n[2701] , nil ,onClose ,1)   --星不足
			LayerManager.addLayout(dlg)
		else 
			-- 根据奖励内容判断背包是否已满
			if (data.reward) then 
				local rewardTids = MainTrainModel.getRewrdItems(data.reward)
				if(not table.isEmpty(rewardTids) and ItemUtil.bagIsFullWithTids(rewardTids,true)) then
					return  
				end
			end 

			MainTrainView.stopLastEffect()   --连击停止上次播放特效
			LayerManager:addUILayer() --联网之前添加屏蔽层

			RequestCenter.train_trainBreak(function (cbFlag, dictData, bRet)
				logger:debug(dictData)
				if (bRet) then 
					logger:debug("GuideTrainView.guideStep === " .. GuideTrainView.guideStep)
					if (GuideModel.getGuideClass() == ksGuideDestiny
						and (GuideTrainView.guideStep == 2 or GuideTrainView.guideStep == 3 or GuideTrainView.guideStep == 4)) then
						GuideCtrl.setPersistenceGuide("destiny","close")
					end

					MainTrainView.rememberProperty(1)  --更新前属性
					MainTrainModel.setLastTrainId(MainTrainModel.getNextTrainId())
					MainTrainModel.setLastPageId(MainTrainModel.getPageId())
					MainTrainModel.setCurTrainId(MainTrainModel.getCurTrainId()+1)
					MainTrainModel.resetPageId()
					MainTrainModel.refreashBaseInfo()
					UserModel.setInfoChanged(true)  --标记战斗力需要刷新
					MainTrainModel.addLeftScore(-data.costCopystar)
					UserModel.updateFightValue() --战斗里刷新
					UserModel.addSilverNumber(-data.silverCost)  --金币刷新（刷新贝里方法里包含了刷新战斗力）
					MainTrainView.rememberProperty(2)  --更新后属性

					local runningScene = CCDirector:sharedDirector():getRunningScene()
					if (not data.reward) then   --非宝箱，屏蔽层1秒去掉。宝箱，屏蔽层等弹奖励页面时删掉
						performWithDelay(runningScene,function()
							LayerManager:removeUILayer() --删除屏蔽层
						end,0.8)
					end 

					MainTrainView.refreashUI(data.reward and true or false)
				else
					LayerManager:removeUILayer() --联网错误直接删除屏蔽层
				end 
			end)
		end 

		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideTrainView"
		if (GuideModel.getGuideClass() == ksGuideDestiny and GuideTrainView.guideStep == 3) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createTrainGuide(4,0,function() GuideCtrl.createTrainGuide(5,0,function () GuideCtrl.removeGuide() end) end)
		end
	end 
end


local function dataInit( ... )
	MainTrainModel.resetPageId()
	MainTrainModel.refreashBaseInfo()
	local m_layMain = MainTrainView.create(tbBtnEvent)

	-- UIHelper.registExitAndEnterCall(m_layMain,function ( ... )--放在了view中注册
	-- 	LayerManager:removeUILayer() --防止修炼中途刷服
	-- end)

	LayerManager.changeModule(m_layMain, MainTrainCtrl.moduleName(), {1,3}, true)  --公共模块保留跑马灯
	PlayerPanel.addForPartnerStrength() 

	---------------  new guide step 3 begin -----
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideTrainView"
	if (GuideModel.getGuideClass() == ksGuideDestiny and GuideTrainView.guideStep == 2) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createTrainGuide(3)
	end
	---------------  new guide step 3 end -----
end


function create(...)
	-- 需要获取新的副本星数
	RequestCenter.train_getTrainInfo(function (cbFlag, dictData, bRet)
		logger:debug(dictData)
		if (bRet) then 
			logger:debug("最新数据")
			logger:debug(dictData)
			MainTrainModel.setTrainData(dictData.ret)
			dataInit()
		end 
	end)
end

-- FileName: MainAstrologyCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-06-20
-- Purpose: 占卜屋主界面
--[[TODO List]]

module("MainAstrologyCtrl", package.seeall)
require "script/module/astrology/MainAstrologyView"
require "script/module/astrology/AstrologyExplainCtrl"
require "script/module/astrology/AstrologyRewardCtrl"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_tbAstrologyInfo = nil
local m_refreshByType 	= 0  	--0为免费刷新次数，1为神龙令，2为金币
local m_i18nString = gi18nString
m_bNeedBigAnimating = false 	-- 当前播放动画是否是带有合并动画：四个目标星座都亮了得时候

local popLayer  		= nil

local function init(...) 
	m_tbAstrologyInfo 	= nil
	m_bNeedBigAnimating = false
	popLayer = nil 
end

function destroy(...)
	package.loaded["MainAstrologyCtrl"] = nil
end

function moduleName()
    return "MainAstrologyCtrl"
end

--刷新后端的回调
function refreshAstrologyCallBack(cbFlag, dictData, bRet)
	if (bRet) then
		--免费刷新次数
		local refreshFreeNum = tonumber(m_tbAstrologyInfo.free_refresh_num)
		--神龙令
		local refreshItemNum = MainAstrologyView.getResheshItemNum()

		if(refreshFreeNum <=0 and refreshItemNum <=0) then

			logger:debug("reduce ten gold")
			UserModel.addGoldNumber(-10)
			
		end

		getAstrologyInfo()

	end
end


--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function create(tbAstrologyInfo)
	init()

	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, removeAnimationState, nil, "RECONN_removeAnimationState")

	local tbEventListener = {}
	--说明按钮事件回调
	tbEventListener.onExplain = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("explain clicked")
			AudioHelper.playCommonEffect() 
			LayerManager.addLayout(AstrologyExplainCtrl.create())
		end
	end
	--刷新按钮事件回调
	tbEventListener.onRefresh = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onRefresh clickeddddddd")
			AudioHelper.playCommonEffect() 
			--今日已无占卜次数，无法刷新"
			logger:debug(tonumber(m_tbAstrologyInfo.divi_times))
			if(16 - tonumber(m_tbAstrologyInfo.divi_times) <= 0) then
				local sTips = m_i18nString(2319)
				local dlg = UIHelper.createCommonDlg(sTips, nil, nil,1)
				LayerManager.addLayout(dlg)
				return
			end
			 --有存在的目标星座时提示是否刷新
		      for i=1,#m_tbAstrologyInfo.va_divine.target do
		            if(tonumber(m_tbAstrologyInfo.va_divine.lighted[i]) == 0)then
		                for j=1,5 do
		                    local starId = m_tbAstrologyInfo.va_divine.current[j]
		                    if(starId~=nil and starId == m_tbAstrologyInfo.va_divine.target[i])then
		                        logger:debug("ffff")
		                        local function confirmRefresh()
		                        	LayerManager:removeLayout()
									startRefresh()
		                        end
		                         --"当前已有目标星座，确认刷新？"
		                        local dlg1 = UIHelper.createCommonDlg(m_i18nString(2323),nil, confirmRefresh)
		                        LayerManager.addLayout(dlg1)
		                        return
		                    end
		                end
		            end
		        end
		    --刷新逻辑    
			startRefresh()
		end
	end
	--查看奖励按钮事件回调
	tbEventListener.onReward = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onReward clicked")
			AudioHelper.playCommonEffect() 
			--logger:debug(m_tbAstrologyInfo)
			LayerManager.addLayout(AstrologyRewardCtrl.create())
		end
	end
	--占卜回调
	tbEventListener.onStar = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onStar clicked")
			AudioHelper.playCommonEffect() 
			--占卜次数已用完
			if(tonumber(m_tbAstrologyInfo.divi_times) >= 16)then	
					--[2318] = "今日的占卜次数已用完",        
				 local dlg1 = UIHelper.createCommonDlg(m_i18nString(2318),nil,nil,1)
				  LayerManager.addLayout(dlg1)
				return
			end
			--占卜已满    

			local dbAstrology = DB_Astrology.getDataById(tonumber(m_tbAstrologyInfo.prize_level))
			if(tonumber(m_tbAstrologyInfo.integral)>=dbAstrology.star_max)then	
			 --"今日已达到最高星数，请明天再试"	        
				 local dlg1 = UIHelper.createCommonDlg(m_i18nString(2325),nil,nil,1)
				  LayerManager.addLayout(dlg1)
				return
			end
			--占卜特效
			local pos = sender:getTag()
			--添加屏蔽层
			addUnTouchLayer()
			--音效
			AudioHelper.playEffect("audio/effect/texiao01_dandao.mp3")

			local tbParams = {

								filePath = "images/effect/astrology/zhanbu2.ExportJson",
								animationName = "zhanbu2",
							}
							
				local effectNode = UIHelper.createArmatureNode(tbParams)
				sender:addNode(effectNode,12222222,100)
				--星座进度位置坐标（世界坐标点）
				local targetPos = MainAstrologyView.getProcessPos()
				--转换到卡牌坐标系
				local posInCardSpace = sender:convertToNodeSpaceAR(targetPos)

				local function removeSelf ( ... )
					effectNode:removeFromParentAndCleanup(true)
					astrologyLogic(pos)
				end

				local array = CCArray:create()
				local callfunc = CCCallFunc:create(removeSelf)
				local move = CCEaseOut:create(CCMoveTo:create(0.75, posInCardSpace), 0.5) 

				-- CCMoveTo:create(1.0, posInCardSpace)
				array:addObject(move)    
				array:addObject(callfunc)
				local action = CCSequence:create(array)
				effectNode:runAction(action)
	

		end
	end

	m_tbAstrologyInfo = tbAstrologyInfo
	local layMain = MainAstrologyView.create( tbEventListener)
	MainAstrologyView.updateAstroView()

	--新手引导
 	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideAstrologyView"
    if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 2) then 
        require "script/module/guide/GuideCtrl"
    	GuideCtrl.createAstrologyGuide(3,nil,function (  )
    		GuideCtrl.createAstrologyGuide(4)
    	end)
    end


	return layMain
end
--占星逻辑
function astrologyLogic(pos)

 	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideAstrologyView"

	if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 7) then 
        require "script/module/guide/GuideCtrl"
    	GuideCtrl.createAstrologyGuide(8,0)
    end

	if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 6) then 
        require "script/module/guide/GuideCtrl"
    	GuideCtrl.createAstrologyGuide(7)
    end

	if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 5) then 
        require "script/module/guide/GuideCtrl"
    	GuideCtrl.createAstrologyGuide(6)
    end

    if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 4) then 
        require "script/module/guide/GuideCtrl"
    	GuideCtrl.createAstrologyGuide(5)
    	--resetdivine
    end
    
    setBigAnimateState(pos)
    local args = CCArray:create()
	args:addObject(CCInteger:create(pos))
	RequestCenter.divine_divi(diviCallback,args)
end

--移除一键屏蔽层，并停止控制
function removeAnimationState()
	removeUnTouchLayer()
end

--占星回调
function diviCallback(cbFlag, dictData, bRet)
	logger:debug(dictData)
	if(bRet) then
		if (GuideModel.getGuideClass() == ksGuideAstrology and GuideAstrologyView.guideStep == 5) then
			GuideCtrl.setPersistenceGuide("astrology","close")
		end
		getAstrologyInfo()
	else

		removeUnTouchLayer()
	end
end

--从后端读取占卜的数据 然后是刷新界面
function getAstrologyInfo()

	function getAstrologyInfoCallBack(cbFlag, dictData, bRet)
		if(bRet)then

			m_tbAstrologyInfo = dictData.ret
			table.hcopy(dictData.ret, m_tbAstrologyInfo)
			--g更新主界面
			MainAstrologyModel.setDiviInfo(m_tbAstrologyInfo) 

			MainAstrologyView.updateAstroView()

		else
			removeUnTouchLayer()
		end
	end
	
	RequestCenter.divine_getDiviInfo(getAstrologyInfoCallBack,CCArray:create())
end

--判断当前占卜的是星座否是第四个需要点亮的星座
--如果是第四个需要点亮的星座，则需要合成动画来展示
function setBigAnimateState( diviPos )
	local tbUnLight = {}

	for i=1,4 do
		local starTargetLight = m_tbAstrologyInfo.va_divine.lighted[i]
		local starTargetId = m_tbAstrologyInfo.va_divine.target[i]
		logger:debug(starTargetId)
		--判断z占卜目标是否是没有被点亮的
		if(tonumber(starTargetLight) == 0)then

			table.insert(tbUnLight,starTargetId)	
		end
	end

	local diviId = m_tbAstrologyInfo.va_divine.current[diviPos + 1]

	if(table.count(tbUnLight) == 1 and tbUnLight[1] == diviId) then
		m_bNeedBigAnimating = true
	else
		m_bNeedBigAnimating = false
	end
end

--更新数据，并刷新界面
function setAstrologyDataFromRewardView()
	m_tbAstrologyInfo = MainAstrologyModel.m_tbAstrologyInfo
	--g更新主界面
	m_bNeedBigAnimating = false
	--MainAstrologyModel.m_tbAstrologyInfo = 
	MainAstrologyView.updateAstroView()
end


--奖励有物品的话需要更新背包后再从后端取数据
function refrashBagDelegete( ... )
	getAstrologyInfo()
end

--刷新逻辑
function startRefresh( ... )
	--免费刷新次数
	local refreshFreeNum = tonumber(m_tbAstrologyInfo.free_refresh_num)
	--神龙令
	local refreshItemNum = MainAstrologyView.getResheshItemNum()
	logger:debug(refreshFreeNum .. refreshItemNum .. UserModel.getGoldNumber())
	if(refreshFreeNum > 0 or refreshItemNum > 0 or UserModel.getGoldNumber() >= 10) then
		if(refreshItemNum > 0) then
			-- 	--注册背包推送回调
			PreRequest.setBagDataChangedDelete(refrashBagDelegete) 
		end

		m_bNeedBigAnimating = false
		RequestCenter.divine_refreshCurstar(refreshAstrologyCallBack,CCArray:create())
		return
	else
		--金币不足
		require "script/module/public/UIHelper"
		local noGoldAlert = UIHelper.createNoGoldAlertDlg()
		LayerManager.addLayout(noGoldAlert)
	end
end

function addUnTouchLayer(  )
	--增加屏蔽，一键探索开始之后 任何位置都不可点击，也不中途停止
	if(popLayer == nil) then
		popLayer = OneTouchGroup:create()
		popLayer:setTouchPriority(g_tbTouchPriority.explore)
		CCDirector:sharedDirector():getRunningScene():addChild(popLayer)
	end
end

function removeUnTouchLayer(  )
	--增加屏蔽，一键探索开始之后 任何位置都不可点击，也不中途停止
	logger:debug("enter remove key Explore==========")
	if (popLayer) then
		popLayer:removeFromParentAndCleanup(true)
		popLayer=nil
	end
end
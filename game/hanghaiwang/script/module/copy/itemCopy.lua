-- FileName: itemCopy.lua
-- Author: xianghuiZhang
-- Date: 2014-03-31
-- Purpose: 据点地图界面

module("itemCopy", package.seeall)

require "script/module/copy/copyData"

require "script/module/copy/battleMonster"

require "db/DB_Stronghold"
require "db/DB_Copy"


-- UI控件引用变量 --
local copyItemLayer -- 普通副本容器层
local baseLayout --添加据点的容器
local demoBaseLay --默认的据点，用来copy的
local passBoxLay  --默认的pass宝箱
local m_scvMain -- 滑动层容器，zhangqi，2014-07-15
local m_layBuZhen	--布阵的Layout
-- local imgTipTrain   -- 天命入口按钮上的红色提示
-- ui文件名称 --
local jsonItemCopy= "ui/copy_scene.json"

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local nZPlayer = 2 -- 玩家信息面板zorder, zhangqi
local m_i18n = gi18n
local m_i18nString = gi18nString
copyID=1 --副本id
copyDifficulty = 1 --副本难度  1简单、2普通 3、困难
local copyDifficultyCount = 1 --副本难度数目

local copyInfo --副本信息
local itemNetData --获取网络存储信息
local m_copyBgHeight --可移动场景的背景高度
local nCurBaseId --当前选择的据点id
local nItemNewBaseId = 0 --当前开启的新据点的id
local m_nBgRate = g_fScaleX -- zhangqi, 2014-05-15, 据点地图优先满足适配宽度的缩放比率
local nScaleHeight = 50
local nScrollToPos = 0 --界面初始化需要移动的位置
local nscrllToTop=0
-- local copyItemInfo -- 点击的副本信息
local rewardAnimationTag = 10
local beforValues --上一个据点坐标信息
local exitCallBackFun = nil --退出本界面时的回掉方法，有时不一定返回到副本地图
local GuidGetSplitTag = 8674 --获取途径指引tag
-- 获取网络返回的攻打状态
local function fnGetAttStaus( infoId )
	if (infoId==nil) then
		return nil
	end

	local status = nil
	local vaInfo = itemNetData.va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if ((tonumber(k) == tonumber(infoId)) and v[tostring(copyDifficulty)] and v[tostring(copyDifficulty)].status) then
			status = v[tostring(copyDifficulty)].status
		end
	end
	return status
end
-- 获取网络返回的攻打状态
function fnGetAttStausOfDifficulty( infoId,difficult,copydata)
	local itemData=copydata~=nil and copydata or itemNetData
	if (infoId==nil) then
		return nil
	end

	local status = nil
	local vaInfo = itemData.va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if ((tonumber(k) == tonumber(infoId)) and v[tostring(difficult)] and v[tostring(difficult)].status) then
			status = v[tostring(difficult)].status
		end
	end
	return status
end

--[[desc:获取某个据点得星数
    arg1: baseId 据点id difficult  难度 简单1，困难 2 
    return:  数值型
—]]
function fnGetStarByBaseAndHard(baseId,difficult)
	local curWorldData = DataCache.getNormalCopyData()
	local itemData=curWorldData.copy_list[""..copyID]

	local getStar = itemData.va_copy_info.baselv_info[tostring(baseId)]
	local getStarNum= 0 --获得的新数
	if (getStar~=nil and getStar[tostring(difficult)] and getStar[tostring(difficult)].score) then
		getStarNum=tonumber(getStar[tostring(copyDifficulty)].score)
	end
	return getStarNum
end
--[[desc:返回某个副本某个据点某个难度的的攻打状态 
    arg1: baseId 据点id ,difficult 难度 简单1，困难2 
    return: true 攻打过，false未攻打过  
—]]
function fnGetAttStausByCopyBaseHard( baseId,difficult)
	local curWorldData = DataCache.getNormalCopyData()
	local itemData=curWorldData.copy_list[""..copyID]

	if (baseId==nil or itemData==nil or itemData.va_copy_info==nil or itemData.va_copy_info.baselv_info==nil) then
		return false
	end
	local nstatus = 0
	local vaInfo = itemData.va_copy_info.baselv_info
	for k,v in pairs(vaInfo) do
		if ((tonumber(k) == tonumber(baseId)) and v[tostring(difficult)] and v[tostring(difficult)].status) then
			nstatus = v[tostring(difficult)].status
		end
	end

	-- local curEliteData = DataCache.getEliteCopyData()

	-- local estatus = 0
	-- if curEliteData.va_copy_info and curEliteData.va_copy_info.progress and curEliteData.va_copy_info.progress[""..baseId] then
	-- 	estatus=curEliteData.va_copy_info.progress[""..baseId]
	-- end
	return tonumber(nstatus)>=3  ---不需要判断精英副本是否已经通关 or tonumber(estatus)>=2
end
-- 初始副本时是否需要对话
function fnShowDialog( ... )
	local states = fnGetAttStaus(copyInfo.baseid_1)
	if (copyInfo.dialogid ~= nil and states ~= nil) then
		if (tonumber(states) <= 2 and copyDifficulty==1) then

			logger:debug("copyInfo.dialogid"..copyInfo.dialogid)
			require "script/module/talk/TalkCtrl"
			TalkCtrl.create(copyInfo.dialogid)
			SwitchCtrl.setSwitchViewByTalk()
			TalkCtrl.setCallbackFunction(function ( ... )
				SwitchCtrl.setSwitchView()
			end)
		end
		-- TalkLayer.setCallbackFunction(fnDialogCallback)
	end
end

function showView( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- demoBaseLay:setVisible(true)
		require "script/module/formation/Buzhen"
		Buzhen.fnCleanupFormation()
		LayerManager.removeLayout()
		AudioHelper.playBackEffect() --返回音效
	end
end

function hideView( ... )
-- demoBaseLay:setVisible(false)
end


local function setExp( barWidget, labMem, labDomi )
	require "db/DB_Level_up_exp"
	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nLevelUpExp = tUpExp["lv_"..(tonumber(tbUserInfo.level)+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值

	if(labMem) then
		labMem:setStringValue(nExpNum)
		labDomi:setStringValue(nLevelUpExp)
	end

	local nPercent = intPercent(nExpNum, nLevelUpExp)
	barWidget:setPercent((nPercent > 100) and 100 or nPercent)


	-- 如果等级达到顶级之后则  --zhangjunwu
	local userLevel = UserModel.getUserInfo().level
	local maxUserLevel = UserModel.getUserMaxLevel()

	if(tonumber(userLevel) >= maxUserLevel) then
		labMem:setEnabled(false)
		labDomi:setEnabled(false)
		local img_slant = m_fnGetWidget(barWidget,"img_slant")
		img_slant:setEnabled(false)
		local IMG_MAX = m_fnGetWidget(barWidget,"IMG_MAX")
		IMG_MAX:setEnabled(true)
		barWidget:setPercent(100)
	end
end
-- 副本单独信息条
function updateInfoBar()
	if (copyItemLayer==nil) then
		return
	end
	local barExp = m_fnGetWidget(copyItemLayer,"LOAD_EXP_BAR")
	local labExpNum = m_fnGetWidget(copyItemLayer,"LABN_EXP_NUM")
	local labExpDom = m_fnGetWidget(copyItemLayer,"LABN_EXP_NUM3")
	
	local IMG_MAX = m_fnGetWidget(copyItemLayer,"IMG_MAX")
	IMG_MAX:setEnabled(false)

	if (barExp) then
		setExp(barExp, labExpNum, labExpDom)
	end
	local userLevel = m_fnGetWidget(copyItemLayer,"TFD_LV")
	userLevel:setText("Lv."..UserModel.getUserInfo().level)

	local barPower = m_fnGetWidget(copyItemLayer,"LOAD_POWER_BAR")
	local labPowerNum = m_fnGetWidget(copyItemLayer,"LABN_POWER_NUM")
	local labPowerDom = m_fnGetWidget(copyItemLayer,"LABN_POWER_NUM3")
	if(labPowerNum) then
		local nPowerNum = tonumber(UserModel.getUserInfo().execution)
		labPowerNum:setStringValue(nPowerNum)
		labPowerDom:setStringValue(g_maxEnergyNum)
		local nPercent = intPercent(nPowerNum, g_maxEnergyNum)
		barPower:setPercent((nPercent > 100) and 100 or nPercent)
	end
end

--获取当前副本所有据点
local function fnGetCopyBase( copy_id )
	local tbBase = {}
	if(copy_id ~= nil) then
		local copyItemInfo = DB_Copy.getDataById(copy_id)
		for i=1,30 do
			local key = "baseid_"..i
			if (copyItemInfo[key] ~= nil) then
				table.insert(tbBase,copyItemInfo[key])
			end
		end
	end
	return tbBase
end
-- 判断是否打过某个副本某个难度的所有据点
local function fnAttackedBase( tbProInfo,difficult)
	if (tbProInfo) then
		for k,v in pairs(tbProInfo) do
			if (v[tostring(difficult)]==nil or v[tostring(difficult)].status==nil or tonumber(v[tostring(difficult)].status)<3) then  --状态：0是没有开启  1是能显示  2是能攻击  3是通关
				return false
			end
		end
	end
	return true
end
--判断是否通过副本的某个难度 1 简单，2 普通  3困难
local function getCrossCopyDifficulty(tbCopyInfo,diffcult)
	if (tonumber(diffcult)==0) then
		return true
	end
	local blsucced = false
	local progressInfo = tbCopyInfo.va_copy_info.baselv_info
	local copyBaseData = fnGetCopyBase(tbCopyInfo.copy_id)
	if (table.count(progressInfo) >= #copyBaseData and fnAttackedBase(progressInfo,diffcult)) then
		blsucced = true
	end
	return blsucced
end
--获取副本某个难度的得星
local function fnGetCopyDifficultyStar(tbCopyInfo,diffcult)
	local copyItemData = DB_Copy.getDataById(tbCopyInfo.copy_id)
	local stars = lua_string_split(copyItemData.all_stars, "|")
	local allStar = stars[diffcult]~=nil and tonumber(stars[diffcult]) or 0
	local getStar=0
	for k,v in pairs(tbCopyInfo.va_copy_info.baselv_info) do
		--据点简单 v[1]
		if (v[tostring(diffcult)]~=nil and v[tostring(diffcult)].score~=nil) then  --状态：0是没有开启  1是能显示  2是能攻击  3是通关
			getStar=getStar+tonumber(v[tostring(diffcult)].score)
		end
	end
	return getStar,allStar
end
-- 初始函数，加载UI资源文件
function create( copyid,itemInfo,toDifficult,backFun)
	--MainCopy.setMainCopyVisible(false)
	logger:debug({itemInfo = itemInfo})
	LayerManager.hideAllLayout("itemCopy")
	itemNetData=itemInfo
	copyID = copyid
	exitCallBackFun = backFun
	copyInfo = DB_Copy.getDataById(copyID)
	copyItemLayer = g_fnLoadUI(jsonItemCopy)
	if (copyItemLayer) then
		UIHelper.registExitAndEnterCall(copyItemLayer,
				function()
					copyItemLayer=nil

					LayerManager.remuseAllLayoutVisible("itemCopy")
				end,
				function()
				end
			) 

		m_scvMain = m_fnGetWidget(copyItemLayer, "SCV_MAIN", "ScrollView")
		m_layBuZhen = m_fnGetWidget(copyItemLayer, "LAY_BUZHEN")
		-- imgTipTrain = m_fnGetWidget(copyItemLayer,"IMG_TRAIN_TIP")

		local imgMengban = g_fnGetWidgetByName(m_scvMain, "IMG_MENGBAN")
		-- imgMengban:ignoreContentAdaptWithSize(true)
		-- local scrollView = g_fnGetWidgetByName(copyElite, "SCV_MAIN")
		imgMengban:setPositionType(POSITION_ABSOLUTE)
		local function updateEliteMengban()
			local bgPos = imgMengban:convertToWorldSpace(ccp(0,0))
			if (bgPos.y~=-200) then
				imgMengban:setPosition(ccp(imgMengban:getPositionX(),imgMengban:getPositionY()-bgPos.y-200))
			end
		end
		schedule(imgMengban,updateEliteMengban,0.01)

		local btnBack = m_fnGetWidget(copyItemLayer, "BTN_CLOSE", "Button")
		if (btnBack) then
			--UIHelper.titleShadow(btnBack, m_i18n[1019])
			btnBack:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playBackEffect() --返回音效
					if (type(exitCallBackFun)=="function") then
						LayerManager.removeLayout()
						exitCallBackFun()
						return
					end
					if (MainCopy.isInMap()) then --当前存在世界地图
						logger:debug("in map")
						MainCopy.updateInit()
						MainCopy.updateBGSize()
						MainCopy.upCopyListView()
						MainCopy.resetScrollOffset()
						LayerManager.addUILayer()
						performWithDelay(copyItemLayer, function()
								LayerManager.removeLayout()
								MainCopy.showPassCopyDialog() --显示通关对话
								LayerManager.removeUILayer()
							end,
							0.01)
					else  --跳过世界地图进入的副本
						logger:debug("not in map")
						local layCopy = MainCopy.create()
						local tmpLayout = Layout:create()
						LayerManager.changeModule(tmpLayout,"temp_module_change", {}, true)
						LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
						PlayerPanel.addForCopy()
						MainCopy.updateBGSize()
						MainCopy.setFogLayer()
						-- MainCopy.resetScrollOffset()
						LayerManager.addUILayer()
						performWithDelay(layCopy, function()
								LayerManager.removeLayout()
								MainCopy.showPassCopyDialog() --显示通关对话
								LayerManager.removeUILayer()
							end,
							0.01)
					end

					MainCopy.updateGuideView() -- 从副本回归副本大地图更新新手引导 

				end
			end)
		end

		local buZhenBtn = m_fnGetWidget(copyItemLayer, "BTN_BUZHEN")
		buZhenBtn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				--显示布阵界面。
				require "script/module/formation/Buzhen"
				Buzhen.createForCopy(itemCopy.showView)
				itemCopy.hideView()
				AudioHelper.playCommonEffect()
			end

		end)
 		--探索
 		local exploreBtn = m_fnGetWidget(copyItemLayer, "BTN_EXPLORE")
 		exploreBtn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				MainCopy.extraToExploreScene()
			end

		end)
		--探索红点
		require "script/module/copy/ExplorMainCtrl"
		ExplorMainCtrl.setExplorRedByBtn(exploreBtn)
		--副本难度个数
		local copyItemData = DB_Copy.getDataById(copyID)
		local stars = lua_string_split(copyItemData.all_stars, "|")
		copyDifficultyCount = #stars
		
		--设置副本默认难度
		if (copyDifficultyCount==1) then
			copyDifficulty=1
		elseif (copyDifficultyCount==2) then
			copyDifficulty=1
			local getStar,AllStar =fnGetCopyDifficultyStar(itemNetData,1)
			logger:debug("simaple reward:")
			logger:debug(isCanGetStarReward(1))

			if (isCanGetStarReward(1)) then --简单副本中有可领取的宝箱
				copyDifficulty=1
			elseif (getStar<AllStar) then   --简单副本中星数还不满
				copyDifficulty=1
			else
				copyDifficulty=2
			end
		else
			copyDifficulty=1
			if (getCrossCopyDifficulty(itemNetData,1)) then
				copyDifficulty=2
			end
			if (getCrossCopyDifficulty(itemNetData,2)) then
				copyDifficulty=3
			end
		end
		if (toDifficult) then
			copyDifficulty=tonumber(toDifficult)
		end
		logger:debug(toDifficult)
		logger:debug("item init difficult=====".. copyDifficulty)
		--点击难度选项
		local function onChangeDifficulty( sender, eventType )
			if (eventType ~= TOUCH_EVENT_ENDED) then
				return
			end
			
			AudioHelper.playTabEffect()		--切换页签音效

			local difficult = copyDifficulty==1 and 2 or 1
			if (copyDifficultyCount==1) then
				return
			end
			-- if difficult==copyDifficulty then
			-- 	--hardLayout:setEnabled(false)
			-- 	return
			-- end
			local isCanChange = true
			local changeText = ""
			if (difficult==2) then
				if (not getCrossCopyDifficulty(itemNetData,1)) then
					isCanChange=false
					local tmpStr = gi18n[1966]
					changeText=string.format(tmpStr,copyItemData.name)
				end
			end
			if (difficult ==3) then
				if (not getCrossCopyDifficulty(itemNetData,2)) then
					isCanChange=false
					local tmpStr = gi18n[1967]
					changeText=string.format(tmpStr,copyItemData.name)
				end
			end
			if (not isCanChange) then
				ShowNotice.showShellInfo(changeText)
				return
			end
			
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/copy_flag/copy_flag.ExportJson")
			CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/battle/skillEffect/heimu0.pvr.ccz", "images/battle/skillEffect/heimu0.plist", "images/effect/copy_flag/copy_flag.ExportJson")
			local createFlag = function()
				--显示结果动作完成之前不可操作屏蔽层
				local layout = Layout:create()
				LayerManager.addLayoutNoScale(layout)
				--播放切换旗帜特效果
				local armaflag
				local function afterFlagArm(bone, frameEventName, originFrameIndex, currentFrameIndex)
					if (frameEventName == "1" or frameEventName == "2") then
					
						local screenAnim
						local function afterScreen( sender, MovementEventType )
							if (MovementEventType ~= EVT_COMPLETE and MovementEventType ~= EVT_LOOP_COMPLETE) then 
								return
							end
							
							--移除屏蔽层
							LayerManager.removeLayout()
							screenAnim:removeFromParentAndCleanup(true)
							
						end --end fun afterScreen
						screenAnim = UIHelper.createArmatureNode({
							filePath = "images/battle/skillEffect/heimu.ExportJson",
							imagePath = "images/battle/skillEffect/heimu0.pvr.ccz",
							plistPath = "images/battle/skillEffect/heimu0.plist",
							animationName = "heimu",
							loop = 0,
							fnMovementCall=afterScreen,
							fnFrameCall=function(bone, frameEventName, originFrameIndex, currentFrameIndex)
								if (frameEventName == "zhenshijian") then
									screenAnim:getAnimation():gotoAndPause(30)
									--加载页面
									copyDifficulty=difficult
									initBaseLayout(itemNetData)

									local lay_nandu = m_fnGetWidget(copyItemLayer, "LAY_HIDE")
									lay_nandu:setEnabled(true)
									armaflag:removeFromParentAndCleanup(true)

									
									performWithDelay(screenAnim,function()
											screenAnim:getAnimation():gotoAndPlay(30)
										end
										,0.01
										)
								end
							end
							}
						)
						screenAnim:setPosition(ccp(g_winSize.width/2,g_winSize.height/2))
						copyItemLayer:addNode(screenAnim,100,9899)
					end --end if (frameEventName == "1" or frameEventName == "2") then
									
				end -- end fun afterFlagArm
				
				armaflag = UIHelper.createArmatureNode({
					filePath = "images/effect/copy_flag/copy_flag.ExportJson",
					animationName = "copy_falg"..difficult,
					loop = 0,
					fnFrameCall=afterFlagArm
					}
				)
				local effectBg = m_fnGetWidget(copyItemLayer, "IMG_EFFECT")
				effectBg:addNode(armaflag,90,9890)

				local lay_nandu = m_fnGetWidget(copyItemLayer, "LAY_HIDE")
				lay_nandu:setEnabled(false)
			end --end createFlag
			performWithDelay(copyItemLayer, createFlag, 0.01)
			delGuidGetSplit() --删除指引
		end  --end onChangeDifficulty
		local simpleImg = m_fnGetWidget(copyItemLayer, "BTN_LEFT")
		--simpleImg:setTag(1)
		--simpleImg:setTouchEnabled(true)
		--simpleImg:setEnabled(false)
		simpleImg:addTouchEventListener(onChangeDifficulty)
		local simpleBtn = m_fnGetWidget(copyItemLayer, "BTN_RIGHT")
		--simpleBtn:setTag(1)
		--simpleBtn:setEnabled(false)
		simpleBtn:addTouchEventListener(onChangeDifficulty)

		local normalImg = m_fnGetWidget(copyItemLayer, "BTN_LEFT2")
		--normalImg:setTag(2)
		--normalImg:setEnabled(false)
		normalImg:addTouchEventListener(onChangeDifficulty)
		local normalBtn = m_fnGetWidget(copyItemLayer, "BTN_RIGHT2")
		--normalBtn:setTag(2)
		--normalBtn:setEnabled(false)
		normalBtn:addTouchEventListener(onChangeDifficulty)

		local lineBtn = m_fnGetWidget(copyItemLayer, "BTN_ROPE")
		lineBtn:addTouchEventListener(onChangeDifficulty)

	
		initBaseLayout(itemInfo)

		-- fnShowDialog() --初始副本需要对话

		hasTipDestiny()
		

		return copyItemLayer
	end
end

--------加入天命入口按钮上的红色标志的控制------------add by lizy  2014.8.8
function hasTipDestiny( ... )
	
end
-- zhangqi, 2014-07-15, 返回新手引导挖洞的左下角坐标
function getHolePos( ... )

	local p2=ccp(nScrollToPos.x*m_nBgRate,(nScrollToPos.y+nScaleHeight)*m_nBgRate+(m_scvMain:getContentOffset()-m_scvMain:getInnerContainerSize().height))
	return ccp(curItemBase:getContentSize().width/2+curItemBase:getPositionX(),p2.y+(g_fScaleY>1 and 20 or 0))
end

-- 外部调用create创建据点场景后，需要调用 initScrollView 初始化据点地图背景位置到最底部
function initScrollView()
	if (m_scvMain) then
		local szOld = m_scvMain:getInnerContainerSize()
		logger:debug("old size.x = %f, y = %f", szOld.width, szOld.height)
		logger:debug("new size.x = %f, y = %f", szOld.width*m_nBgRate, szOld.height*m_nBgRate)
		m_scvMain:setInnerContainerSize(CCSizeMake(szOld.width*m_nBgRate, szOld.height*m_nBgRate))

		local imgBg = m_fnGetWidget(copyItemLayer, "IMG_BG")
		imgBg:setScale(m_nBgRate) -- 按适配屏宽缩放背景图
		local imgMengban = g_fnGetWidgetByName(copyItemLayer, "IMG_MENGBAN")
		local mengbanSceleX=(g_winSize.height+400)/(imgMengban:getContentSize().height/(imgMengban:getContentSize().height*m_nBgRate))
		imgMengban:setScale(mengbanSceleX)

		local per = m_scvMain:getInnerContainerSize().height  - nScrollToPos.y * m_nBgRate
		m_scvMain:jumpToPercentVertical(per/szOld.height* m_nBgRate * 100)
		if (nscrllToTop==1) then
			m_scvMain:jumpToPercentVertical(0)
		end
		logger:debug("dfasdsafasd")
		logger:debug(per/szOld.height* m_nBgRate * 100)
		-- m_scvMain:jumpToBottom()
		--------------------------------- new guide begin -------------------------------------------
		require "script/module/guide/GuideModel"
		require "script/module/guide/GuideFormationView"
		if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 7) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createFormationGuide(8, getHolePos())
			m_scvMain:setTouchEnabled(false)
		end

		--------------------------- new guide begin -------------------------------------
		logger:debug("GuidePartnerAdvView.guideStep top == " .. GuidePartnerAdvView.guideStep)

		require "script/module/guide/GuidePartnerAdvView"
		if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 6) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createPartnerAdvGuide(7, nil, getHolePos())
			m_scvMain:setTouchEnabled(false)
		end
		if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 9) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createPartnerAdvGuide(10, nil, getHolePos())
			m_scvMain:setTouchEnabled(false)
		end
		require "script/module/guide/GuideFiveLevelGiftView"
		if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 14) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.createkFiveLevelGiftGuide(15, nil, getHolePos())-- 2014-07-15
			m_scvMain:setTouchEnabled(false)
		end

		 require "script/module/guide/GuideCopyBoxView"
	    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 11) then
	        require "script/module/guide/GuideCtrl"
	        GuideCtrl.createCopyBoxGuide(12,nil, getHolePos())
	        m_scvMain:setTouchEnabled(false)
	    end

	    require "script/module/guide/GuideCopy2BoxView"
	    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 18) then
	        require "script/module/guide/GuideCtrl"
	        GuideCtrl.createCopy2BoxGuide(19,0,getHolePos())
	        m_scvMain:setTouchEnabled(false)
	    end

		---------------------------- new guide end --------------------------------------
	end
end

--播放副本音乐
function playCopyAudio( ... )
	if (copyInfo) then
		if(copyInfo.music_path) then
			require "script/module/config/AudioHelper"
			--李卫东 返回世界地址播放
			if (MainCopy.isCrossFirstEntrance()) then  --为了实现第一次进入副本不播放副本背景音乐，直接播放战斗背景音乐
				AudioHelper.playSceneMusic(copyInfo.music_path)
			else
				performWithDelayFrame(nil,function()
						AudioHelper.stopMusic()
					end,1)
			end
		end
	end
end

-- 数据更新后，重新加载界面
function initBaseLayout( itemInfo,newbaseId )
	if not(copyItemLayer and copyItemLayer.addChild) then
		return
	end
	logger:debug("function initBaseLayout")
	m_scvMain:setTouchEnabled(true)
	-- local node = CCNode:create()
	-- copyItemLayer:addNode(node)
	itemNetData = itemInfo
	nItemNewBaseId = newbaseId or 0

	init()

	--播放副本音乐
	playCopyAudio()
	--更新红点
	hasTipDestiny()
	--定位界面到当前攻打的据点
	if (m_scvMain) then
		local per = m_scvMain:getInnerContainerSize().height - nScrollToPos.y * m_nBgRate
		m_scvMain:jumpToPercentVertical(per/m_scvMain:getInnerContainerSize().height * 100)
		if (nscrllToTop==1) then
			m_scvMain:jumpToPercentVertical(0)
		end
	end

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuidePartnerAdvView"
	if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 7) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createPartnerAdvGuide(8)
		m_scvMain:setTouchEnabled(false)
	end

	if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 11) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createPartnerAdvGuide(12, nil, getHolePos())
		m_scvMain:setTouchEnabled(false)
	end

	require "script/module/guide/GuideCopyBoxView"
    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 13) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopyBoxGuide(14,nil, getHolePos())
        m_scvMain:setTouchEnabled(false)
    end
end
function isShowCopyRewardBoxTip(copydata)
	local boxTipShow = false
	for i=1,copyDifficultyCount do
		if (isCanGetStarReward(i,copydata) or isHavePassRewardBox(i,copydata)) then
			boxTipShow=true
			break
		end
	end
	return boxTipShow
end
--返回某个副本 某个难度 某个宝箱是否可领取 参数：副本id,难度，宝箱id(1,2,3)
function isCanGetCopyRewardByids(copyid,difficult,boxid)
	local copyData = DataCache.getNormalCopyData()
	local copyInfo =copyData.copy_list[""..copyid]
	return isCanGetStarRewardByBoxid(difficult,copyInfo,boxid)
end
--判断副本某个难度是否有可领取的星星宝箱 copydata 为空时表示当前副本数据，不为空是外部调用
function isCanGetStarRewardByBoxid(difficulty,copydata,boxid)
	local itemData=copydata~=nil and copydata or itemNetData
	local bt2={0,0,0}
	if (itemData.va_copy_info and itemData.va_copy_info.box_info and itemData.va_copy_info.box_info[tostring(difficulty)] and itemData.va_copy_info.box_info[tostring(difficulty)].star_box) then
		for i=1,3 do
			if (itemData.va_copy_info.box_info[tostring(difficulty)].star_box[tostring(i)]) then
				bt2[i]=tonumber(itemData.va_copy_info.box_info[tostring(difficulty)].star_box[tostring(i)])
			end
		end
	end
	local copyDbinfo = copyInfo
	if (copydata) then
		copyDbinfo =DB_Copy.getDataById(copydata.copy_id)
	end
	if(copyDbinfo and copyDbinfo.starlevel) then
		local startLv = lua_string_split(copyDbinfo.starlevel,",")
		local getScore = fnGetCopyDifficultyStar(itemData,difficulty)
		for k,v in ipairs(startLv) do
			if (k<= #bt2  and k==boxid) then
				if (getScore >= tonumber(v)) and (bt2[k] ~= 1) then
					return 2  --可以领
				elseif bt2[k] == 1 then
					return 1  --已领取
				end
			end
		end
	end
	return 0 --没领过
end
--显示选择难度按钮
local function showSelectDifficultyInfo()

	--四个难度按钮
	local simpleLeft = m_fnGetWidget(copyItemLayer, "BTN_LEFT")
	local simpleRight = m_fnGetWidget(copyItemLayer, "BTN_RIGHT")

	local normalLeft = m_fnGetWidget(copyItemLayer, "BTN_LEFT2")
	local normalRight = m_fnGetWidget(copyItemLayer, "BTN_RIGHT2")

	if (copyDifficultyCount==1) then
		simpleLeft:setVisible(true)
		simpleLeft:setTouchEnabled(true)
		simpleRight:setVisible(false)
		simpleLeft:setTouchEnabled(false)
		normalLeft:setVisible(false)
		simpleLeft:setTouchEnabled(false)
		normalRight:setVisible(false)
		simpleLeft:setTouchEnabled(false)
	else
		if (copyDifficulty==1) then
			simpleLeft:setVisible(true)
			simpleLeft:setTouchEnabled(true)
			simpleRight:setVisible(false)
			simpleLeft:setTouchEnabled(false)
			normalLeft:setVisible(false)
			simpleLeft:setTouchEnabled(false)
			normalRight:setVisible(true)
			simpleLeft:setTouchEnabled(true)
		end
		if (copyDifficulty==2) then
			simpleLeft:setVisible(false)
			simpleLeft:setTouchEnabled(false)
			simpleRight:setVisible(true)
			simpleLeft:setTouchEnabled(true)
			normalLeft:setVisible(true)
			simpleLeft:setTouchEnabled(true)
			normalRight:setVisible(true)
			simpleLeft:setTouchEnabled(true)
		end
	end
	--一个红点tip
	local redTip2 = m_fnGetWidget(copyItemLayer, "IMG_STAR_TIP2")
	redTip2:setVisible(false)
	
	if (copyDifficulty==1) then
		if (getCrossCopyDifficulty(itemNetData,1)) then
			local get1,all1 = fnGetCopyDifficultyStar(itemNetData,2)
			logger:debug(get1,all1)
			if (tonumber(get1)<tonumber(all1)) then
				redTip2:setVisible(true)
			end
		end
	end
	if (copyDifficulty==2) then
		if (getCrossCopyDifficulty(itemNetData,0)) then
			local get1,all1 = fnGetCopyDifficultyStar(itemNetData,1)
			logger:debug(get1,all1)
			if (tonumber(get1)<tonumber(all1)) then
				redTip2:setVisible(true)
			end
		end
	end
	--两个宝箱tip
	local boxTip1 = m_fnGetWidget(copyItemLayer, "IMG_BOX_TIP1")
	boxTip1:setVisible(false)
	local boxTip2 = m_fnGetWidget(copyItemLayer, "IMG_BOX_TIP2")
	boxTip2:setVisible(false)

	local simpleRed,normalRed,simpleBox,normalBox
	if (copyDifficulty==1) then
		simpleBox,normalBox=boxTip1,boxTip2
	end
	if (copyDifficulty==2) then
		simpleBox,normalBox=boxTip2,boxTip1
	end 

	if (isCanGetStarReward(1) or isHavePassRewardBox(1)) then
		local m_arAni1 = UIHelper.createArmatureNode({
				filePath = "images/effect/box_tip/box_tip.ExportJson",
				animationName = "box_tip"
			})
		simpleBox:removeAllChildrenWithCleanup(true)
		simpleBox:addNode(m_arAni1)
		simpleBox:setVisible(true)
	end
	if (isCanGetStarReward(2) or isHavePassRewardBox(2)) then
		local m_arAni1 = UIHelper.createArmatureNode({
				filePath = "images/effect/box_tip/box_tip.ExportJson",
				animationName = "box_tip"
			})
		normalBox:removeAllChildrenWithCleanup(true)
		normalBox:addNode(m_arAni1)
		normalBox:setVisible(true)
	end
	--优先显示宝箱tip
	if (boxTip2:isVisible()==true) then
		redTip2:setVisible(false)
	end
	--困难难度上的颜色透明层
	local colorLayou = m_fnGetWidget(copyItemLayer, "LAY_HARD_BG")
	if (copyDifficulty~=1) then
		colorLayou:setVisible(true)
	else
		colorLayou:setVisible(false)
	end
	
end
-- 初始加载配置数据
function init( ... )
	nscrllToTop=0
	updateInfoBar()
	--hasTipDestiny()
	copyInfo = DB_Copy.getDataById(copyID)
	--替换副本名称
	local tfdcopyName = m_fnGetWidget(copyItemLayer, "TFD_COPY_NAME")
	if (tfdcopyName) then
		UIHelper.labelStroke(tfdcopyName)
		--UIHelper.labelShadow(tfdcopyName,CCSizeMake(4, -4))
		tfdcopyName:setText(copyInfo.name)
	end
	--显示选择难度信息
	showSelectDifficultyInfo()


	baseLayout = m_fnGetWidget(copyItemLayer, "LAY_TOTAL", "Layout")
	if (baseLayout) then
		local copyItemFIle = "db/cxmlLua/copy_" .. copyID.."_"..copyDifficulty -- 引入全局变量 copy
		package.loaded[copyItemFIle] = nil  --释放存储的模块
		require(copyItemFIle)

		--替换副本背景图片
		local copyBgImg = m_fnGetWidget(baseLayout, "IMG_BG", "ImageView")
		if (copyBgImg) then
			logger:debug(copyNormalPath.."overallimage/"..copy.background)
			copyBgImg:loadTexture(copyNormalPath.."overallimage/"..copy.background)
			m_copyBgHeight = copyBgImg:getContentSize().height
		end
		--创建据点
		createBaseLayer()
	end

	--领取奖励
	local rewardLayout = m_fnGetWidget(copyItemLayer, "LAY_REWARD", "Layout")
	if (rewardLayout) then
		receiveReward(rewardLayout)
	end

	--显示当前星数
	local getStar,allStar=fnGetCopyDifficultyStar(itemNetData,copyDifficulty)
	local itemCurStar_ = m_fnGetWidget(copyItemLayer, "TFD_STAR_OWN") --STAR_OWN
	if (itemCurStar_) then
		itemCurStar_:setText(getStar)
		--UIHelper.labelStroke(itemCurStar_)
	end

	if (itemCurStar_) then
		local itemCopyStar_ = m_fnGetWidget(copyItemLayer, "TFD_STAR_TOTAL")
		itemCopyStar_:setText(allStar)
		--UIHelper.labelStroke(itemCopyStar_)
	end

	local starNumProgress = m_fnGetWidget(copyItemLayer, "TFD_STAR_DOWN")
	starNumProgress:setText(getStar.."/"..allStar)
	-- showClearanceTip(1)
	--liweidong 缩放进度背景
	local progressbg = m_fnGetWidget(copyItemLayer, "img_progress")
	progressbg:setScale(g_fScaleX)

	local topInfo = m_fnGetWidget(copyItemLayer, "IMG_COPY_NAME")
	topInfo:setScale(g_fScaleX)

	local setSizeBg = m_fnGetWidget(copyItemLayer, "LAY_SETSIZE")
	setSizeBg:setSize(CCSizeMake(setSizeBg:getContentSize().width*g_fScaleX,setSizeBg:getContentSize().height*g_fScaleX))
end
--获取途径指引
function guidGetSplit(id)
	local guidItem = baseLayout:getChildByTag(id)
	if (not guidItem) then
		return
	end
	local effect = EffGuide.new()
	effect.mArmature:setPosition(ccp(guidItem:getContentSize().width/2+guidItem:getPositionX(),guidItem:getContentSize().height/2+guidItem:getPositionY()))
	baseLayout:addNode(effect.mArmature,10,GuidGetSplitTag)
	local y = -guidItem:getPositionY()*m_nBgRate+400*m_nBgRate
	if (y>0) then
		y=0
	end
	m_scvMain:setJumpOffset(ccp(m_scvMain:getJumpOffset().x,y))
end
--删除获取途径指引
function delGuidGetSplit()
	if (baseLayout:getNodeByTag(GuidGetSplitTag)) then
		baseLayout:removeNodeByTag(GuidGetSplitTag)
	end
end
-- 创建据点layout
function createBaseLayer( ... )
	logger:debug("enter create base layer:======")
	demoBaseLay = m_fnGetWidget(baseLayout, "LAY_STRONGHOLD")
	-- passBoxLay	= m_fnGetWidget(baseLayout, "LAY_BOX")
	if (demoBaseLay and baseLayout) then
		for i=1,30 do
			local fieldName = "baseid_"..i
			local baseId = copyInfo[fieldName]
			local state = fnGetAttStaus(baseId)
			if baseId~=nil and (baseLayout:getChildByTag(baseId) ~= nil) then
				baseLayout:removeChildByTag(baseId,true)
			end
			if baseId~=nil and (baseLayout:getChildByTag(baseId+5000) ~= nil) then
				baseLayout:removeChildByTag(baseId+5000,true)
			end
			if(baseId ~= nil) then
				copyPassRewardBox(baseId,state)
				if state ~= nil then
					copyBaseArmy(baseId,tonumber(state))
				end
			end
		end
		--demoBaseLay:setVisible(false)
		-- passBoxLay:setVisible(false)
	end
end

--显示相应的widget
local function fnShowWidget(tbWidget,showWidget )
	for k,v in ipairs(tbWidget) do
		if (v == showWidget) then
			showWidget:setEnabled(true)
			showWidget:setVisible(true)
		else
			v:setEnabled(false)
			v:setVisible(false)
		end
	end
end

--获取据点星数
local function fnGetBaseStar( tbStar )
	return 3
end

--把控件绘制成灰色
local function fnGrayStar( tbWidget )
	for _,v in pairs(tbWidget) do
		UIHelper.setWidgetGray(v,true)
	end
end

--去战斗
function fnShowLayout( ... )
	-- AudioHelper.setMusicVolume(1)
	local battleMLayout = battleMonster.create(nCurBaseId,itemNetData,copyDifficulty)
	if (battleMLayout ~= nil) then
		LayerManager.addLayout(battleMLayout)
	end
end

--攻打据点时完成对话框对话
local function fnDialogCallback( ... )
	fnShowLayout()
end

--当前可打据点底部动画
local function curBaseAction( parentNode )
	-- local m_arAni1 = UIHelper.createArmatureNode({
	-- 	filePath = animationPath .. "mubiao_2/mubiao_2.ExportJson",
	-- 	animationName = "mubiao_2",
	-- 	loop = -1,
	-- })
	-- local itemArmyBtn = m_fnGetWidget(parentNode, "BTN_IN")
	-- m_arAni1:setAnchorPoint(ccp(0.1,0))
	-- m_arAni1:setPosition(ccp(itemArmyBtn:getPositionX(),itemArmyBtn:getPositionY()))
	-- parentNode:addNode(m_arAni1,-100)
end

--当前可打据点头部动画
local function curBaseTopAction( parentNode )
	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = animationPath .. "mubiao/mubiao.ExportJson",
		animationName = "mubiao",
		loop = -1,
	})
	m_arAni1:setAnchorPoint(ccp(0.42,0.2))
	parentNode:addNode(m_arAni1,100)
end

--需要攻打的据点动画回调
local function actionBaseBack( node )
	local itemArmyTitle_ = m_fnGetWidget(node, "TFD_NAME")
	local itemArmyBtn = m_fnGetWidget(node, "BTN_IN")
	curBaseTopAction(itemArmyTitle_)
	curBaseAction(node)

end
--判断副本某个难度通关宝箱是否有未领取
function isHavePassRewardBox(difficult,copydata)
	local itemData=copydata~=nil and copydata or itemNetData

	logger:debug(itemData)
	local copyDbinfo = copyInfo
	if (copydata) then
		copyDbinfo =DB_Copy.getDataById(copydata.copy_id)
	end


	for i=1,30 do
		local fieldName = "baseid_"..i
		local baseId = copyDbinfo[fieldName]
		local state = fnGetAttStausOfDifficulty(baseId,difficult,copydata)

		if(baseId ~= nil and state ~= nil) then
			local baseItemInfo = DB_Stronghold.getDataById(baseId)
			local passBoxKey = {"simple_box","normal_box","hard_box"}
			if (baseItemInfo[passBoxKey[tonumber(difficult)]]) then
				if (tonumber(state)>=3) then
					if (itemData.va_copy_info.baselv_info[""..baseId][""..difficult]==nil or itemData.va_copy_info.baselv_info[""..baseId][""..difficult].boxstatus==nil or tonumber(itemData.va_copy_info.baselv_info[""..baseId][""..difficult].boxstatus)~=1) then
						return true
					end
				end
			end
		end
	end
	return false
end
function onPassRewardBoxBtn(sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	local baseId=sender:getTag()
	local baseItemInfo = DB_Stronghold.getDataById(baseId)
	local state = fnGetAttStaus(baseId)
	--领取状态，= 1为已领取，2为未领取,3为未开启
	local status=1
	if (state==nil or tonumber(state)<3) then
		status=3
	elseif (itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty].boxstatus==nil or tonumber(itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty].boxstatus)~=1) then
		status=2
	else
		status=1
	end
	require "script/module/copy/passCopyReward"
	LayerManager.addLayoutNoScale(passCopyReward.create(status,baseItemInfo,copyDifficulty,baseId))
	AudioHelper.playCommonEffect()
end
--创建副本通关宝箱
function copyPassRewardBox(baseId,state)
	-- do return end
	copyItemLayer.LAY_BOX:setVisible(false)
	local baseItemInfo = DB_Stronghold.getDataById(baseId)
	local passBoxKey = {"simple_box","normal_box","hard_box"}
	if baseItemInfo[passBoxKey[tonumber(copyDifficulty)]] then
		logger:debug("show pass box======"..baseId)
		copyItemLayer.LAY_BOX:setVisible(true)
		copyItemLayer.LAY_BOX.BTN_BOX_EMPTY:setTag(baseId)
		copyItemLayer.LAY_BOX.BTN_BOX_CLOSE:setTag(baseId)
		copyItemLayer.LAY_BOX.BTN_BOX_CANOPEN:setTag(baseId)
		copyItemLayer.LAY_BOX.BTN_BOX_EMPTY:setEnabled(false)
		copyItemLayer.LAY_BOX.BTN_BOX_CLOSE:setEnabled(false)
		copyItemLayer.LAY_BOX.BTN_BOX_CANOPEN:setEnabled(false)
		copyItemLayer.LAY_BOX.IMG_STR_EFFECT:removeAllNodes()


		if (state==nil or tonumber(state)<3) then
			copyItemLayer.LAY_BOX.BTN_BOX_CLOSE:setEnabled(true)
		elseif (itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty].boxstatus==nil or tonumber(itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty].boxstatus)~=1) then
			copyItemLayer.LAY_BOX.BTN_BOX_CANOPEN:setEnabled(true)
			local m_arAni1 = UIHelper.createArmatureNode({
					filePath = animationPath.."copy_box/copy_box.ExportJson", -- 2016-01-21, 避免安卓底包找不到文件
					animationName = "copy_box_goden_big",
				})
			copyItemLayer.LAY_BOX.IMG_STR_EFFECT:addNode(m_arAni1)
		else
			copyItemLayer.LAY_BOX.BTN_BOX_EMPTY:setEnabled(true)
		end
		--点击按钮
		copyItemLayer.LAY_BOX.BTN_BOX_CLOSE:addTouchEventListener(onPassRewardBoxBtn)
		copyItemLayer.LAY_BOX.BTN_BOX_CANOPEN:addTouchEventListener(onPassRewardBoxBtn)
		copyItemLayer.LAY_BOX.BTN_BOX_EMPTY:addTouchEventListener(onPassRewardBoxBtn)
	end
end
-- 根据副本内容获取相应的据点
function copyBaseArmy( baseId_,state )
	logger:debug("enter copy base army:======")
	local baseItemInfo = DB_Stronghold.getDataById(baseId_)
	local normalTable = copy.models.normal
	logger:debug(normalTable)
	for i,values in pairs(normalTable) do
		local armyId = values.looks.look.armyID
		local modelUrl = values.looks.look.modelURL
		if (tonumber(armyId) == tonumber(baseItemInfo.id) and modelUrl ~= nil) then
			local nimgModel = lua_string_split(modelUrl,".swf")
			logger:debug("m_copyBgHeight = %f", m_copyBgHeight)
			createArmy(values.x, m_copyBgHeight - values.y,baseItemInfo,state,nimgModel[1])
			if (tonumber(baseItemInfo.id)%100==10 and tonumber(beforValues)>tonumber(values.y)) then
				nscrllToTop=1
			end
			beforValues=values.y
			logger:debug("base x,y:"..beforValues)
		end
	end
end

-- 复制怪物据点
function createArmy( x,y,infoTable,state,modelType )

	logger:debug("xxx"..x.."y"..y)
	if(baseLayout:getChildByTag(infoTable.id) ~= nil) then
		baseLayout:removeChildByTag(infoTable.id,true)
	end
	demoBaseLay = m_fnGetWidget(baseLayout, "LAY_STRONGHOLD")
	demoBaseLay:setVisible(false)
	demoBaseLay:setEnabled(false)
	local itemBaseCopy = demoBaseLay:clone()
	itemBaseCopy:setVisible(true)
	itemBaseCopy:setEnabled(true)
	itemBaseCopy:setTag(infoTable.id)
	baseLayout:addChild(itemBaseCopy,modelType) --liweidong  让据点记录自己的类型

	curItemBase=itemBaseCopy

	logger:debug("perX = %f, perY = %f", x*m_nBgRate, (y-nScaleHeight)*m_nBgRate)
	local positionPer = g_GetPercentPosition(baseLayout, (x-itemBaseCopy:getContentSize().width/2)*m_nBgRate, (y-nScaleHeight)*m_nBgRate)

	if (nItemNewBaseId == infoTable.id) then
		itemBaseCopy:setPositionPercent(ccp(positionPer.x,positionPer.y+0.5))
		local moveByPos = CCMoveBy:create(0.5, ccp(0,-baseLayout:getContentSize().height*0.5))
		local easeSine=CCEaseExponentialIn:create(moveByPos)
		local easeMove=CCEaseElasticOut:create(CCMoveBy:create(0.3, ccp(0,10)))
		local array = CCArray:create()
		array:addObject(easeSine)
		array:addObject(easeMove)
		array:addObject(CCCallFuncN:create(actionBaseBack))
		local action = CCSequence:create(array)
		itemBaseCopy:runAction(action)
		-- nScrollToPos = (positionPer.y+0.5) * baseLayout:getContentSize().height
	else
		itemBaseCopy:setPositionPercent(positionPer)
		--当前攻打的据点动画
		if(state < 3) then
			--actionBaseBack(itemBaseCopy)
			itemBaseCopy:setPositionPercent(ccp(positionPer.x,positionPer.y+0.5))
			local moveByPos = CCMoveBy:create(0.5, ccp(0,-baseLayout:getContentSize().height*0.5))
			local easeSine=CCEaseExponentialIn:create(moveByPos)
			local easeMove=CCEaseElasticOut:create(CCMoveBy:create(0.3, ccp(0,10)))
			local array = CCArray:create()
			array:addObject(easeSine)
			array:addObject(easeMove)
			array:addObject(CCCallFuncN:create(actionBaseBack))
			local action = CCSequence:create(array)
			itemBaseCopy:runAction(action)
		end

	end
	nScrollToPos = ccp(x, y)
	--获取当前可打据点的世界坐标, 2014-07-14, zhangqi
	-- local wd = itemBaseCopy:getParent():convertToWorldSpace(ccp(x,y))
	local wX = x*g_fScaleX -- positionPer.x*baseLayout:getSize().width
	local wY =  y*g_fScaleY -- positionPer.y*baseLayout:getSize().height
	logger:debug("armyId = %d, newX = %f, newY = %f", infoTable.id, wX, wY)
	local wd = baseLayout:convertToWorldSpace(ccp(x,y))
	-- local worldPoint = itemBaseCopy:getWorldPositon()
	-- local wd = CCDirector:sharedDirector():convertToUI(ccp(x,y))
	logger:debug("armyId = %d, X = %f, Y = %f", infoTable.id, x, y)
	logger:debug("nScrollToPos.y = %f", nScrollToPos.y)
	logger:debug("armyId = %d, worldX = %f, worldY = %f", infoTable.id, wd.x, wd.y)


	local itemArmyTitle_ = m_fnGetWidget(itemBaseCopy, "TFD_NAME", "Label")
	if (itemArmyTitle_) then
		itemArmyTitle_:setText(infoTable.name)
		--UIHelper.labelStroke(itemArmyTitle_)
		UIHelper.labelNewStroke(itemArmyTitle_)
	end

	local itemArmyBtn = m_fnGetWidget(itemBaseCopy, "BTN_IN", "Button")
	if (itemArmyBtn) then
		local itemArmyImg_ = m_fnGetWidget(itemBaseCopy, "IMG_HEAD", "ImageView")
		--itemArmyImg_:setPositionPercent(ccp(0,0.05))
		if (itemArmyImg_) then
			itemArmyImg_:loadTexture(HeroheadPath..infoTable.icon)
		end
		local itemArmyBgImg = m_fnGetWidget(itemBaseCopy, "IMG_PHOTO_BG", "ImageView")
		itemArmyBgImg:loadTexture(armyBorderPath.."stronghold_bg_n.png")
		--点击据点内容，开始战斗准备界面
		local toBattle = function ( sender, eventType )
			local bFocus = sender:isFocused()
			if (bFocus) then
				itemArmyImg_:setScale(0.85)
				itemArmyBgImg:loadTexture(armyBorderPath.."stronghold_bg_h.png")
			else
				itemArmyImg_:setScale(1)
				itemArmyBgImg:loadTexture(armyBorderPath.."stronghold_bg_n.png")
			end

			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playBtnEffect("start_fight.mp3") --进入战斗音效
				nCurBaseId = sender:getTag()
				onClickBaseEvent(nCurBaseId)
			end
		end
		itemArmyBtn:setTag(infoTable.id)
		itemArmyBtn:addTouchEventListener(toBattle)

		itemArmyBtn:loadTextureNormal(armyBorderPath..modelType..".png")
		itemArmyBtn:loadTexturePressed(armyBorderPath..modelType.."_pressed.png")
		itemArmyBtn:setPositionType(POSITION_ABSOLUTE)
		if (tonumber(modelType)==1) then
			itemArmyBtn:setPosition(ccp(0, -10))
		elseif  (tonumber(modelType)==2) then
			itemArmyBtn:setPosition(ccp(0, -5))
		else
			itemArmyBtn:setPosition(ccp(0, 1))
		end
		--itemArmyBtn:loadTexturePressed(armyBorderPath..modelType.."_pressed.png")

		

	end

	-- 显示据点星级
	local starNums = tonumber(fnGetBaseStar(infoTable))
	local getStar = itemNetData.va_copy_info.baselv_info[tostring(infoTable.id)]
	local getStarNum= 0 --获得的新数
	if (getStar~=nil and getStar[tostring(copyDifficulty)] and getStar[tostring(copyDifficulty)].score) then
		getStarNum=tonumber(getStar[tostring(copyDifficulty)].score)
	end
	state = 2 + getStarNum

	local star1 = m_fnGetWidget(itemBaseCopy, "IMG_STAR1", "ImageView")
	local star2 = m_fnGetWidget(itemBaseCopy, "IMG_STAR2", "ImageView")
	local star3 = m_fnGetWidget(itemBaseCopy, "IMG_STAR3", "ImageView")
	if(star1 and star2 and star3) then
		local tbStarArr = {}
		if (starNums == 1) then
			star1:setVisible(false)
			star3:setVisible(false)
			if(state < 3) then
				table.insert(tbStarArr,star2)
			end
		elseif(starNums == 2) then
			star1:setPositionPercent(ccp(star1:getPositionPercent().x + 0.1, star1:getPositionPercent().y))
			star2:setPositionPercent(ccp(star2:getPositionPercent().x + 0.1, star2:getPositionPercent().y))
			star3:setVisible(false)
			if(state < 3) then
				table.insert(tbStarArr,star1)
				table.insert(tbStarArr,star2)
			elseif(state < 4) then
				table.insert(tbStarArr,star2)
			end
		elseif(starNums == 3) then
			if(state < 3) then
				table.insert(tbStarArr,star1)
				table.insert(tbStarArr,star2)
				table.insert(tbStarArr,star3)
			elseif(state < 4) then
				table.insert(tbStarArr,star2)
				table.insert(tbStarArr,star3)
			elseif(state < 5) then
				table.insert(tbStarArr,star3)
			end
		end

		fnGrayStar(tbStarArr)
	end

end


--[[desc:liweidong 点击据点按钮回调函数
    arg1: nCurBaseId 被点击的据点id
    return: nil 
—]]
function onClickBaseEvent(id)
	nCurBaseId=id
	require "script/module/guide/GuideCtrl"
	GuideCtrl.removeGuideView()
	--------------------- new guide end remove ---------------------------
	local strongItem = DB_Stronghold.getDataById(id)
	if (strongItem.pre_dialog_id ~= nil) then
		local attStatus = fnGetAttStaus(id)
		if(attStatus ~= nil) then
			if (tonumber(attStatus) <= 2 and copyDifficulty==1) then

				require "script/module/talk/TalkCtrl"
				TalkCtrl.create(strongItem.pre_dialog_id)
				-- local talkLayer = TalkLayer.createTalkLayer(strongItem.pre_dialog_id)
				TalkCtrl.setCallbackFunction(fnDialogCallback)
			else
				fnShowLayout()
			end
		else
			fnShowLayout()
		end
	else
		fnShowLayout()
	end
end

---------------底部领取奖励
--宝箱动画
local function fnAnimationOpenBox( rewardBtn,fileName,anchor,playname)
	local m_arAni1 = UIHelper.createArmatureNode({
		--imagePath = animationPath..anitName.."/"..anitName.."0.png",
		--plistPath = animationPath..anitName.."/"..anitName.."0.plist",
		filePath = animationPath..fileName.."/"..fileName..".ExportJson",
		animationName = playname,
	})
	m_arAni1:setTag(rewardAnimationTag)
	if (anchor == 1) then
		-- m_arAni1:setAnchorPoint(ccp(0.5,0.48))
		--m_arAni1:setScale(1.2)
	elseif (anchor == 2) then
		-- m_arAni1:setAnchorPoint(ccp(0.50,0.48))
	end
	-- m_arAni1:setPosition(pos)
	if (rewardBtn:getChildByTag(rewardAnimationTag)) then
		rewardBtn:getChildByTag(rewardAnimationTag):removeFromParentAndCleanup(true)
	end
	-- m_arAni1:getAnimation():setSpeedScale(0.5)
	rewardBtn:addNode(m_arAni1)
end

--点击领取奖励,tag = 3为已领取状态，2为可领取状态，1为关闭状态
local function onrecReward( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug ("sendertag",sender:getTag())
		local tag = sender:getTag()
		require "script/module/copy/copyReward"
		--local bt2 = i2bit(itemNetData.prized_num,3)
		local bt2={0,0,0}
		if (itemNetData.va_copy_info.box_info and itemNetData.va_copy_info.box_info[tostring(copyDifficulty)] and itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box) then
			for i=1,3 do
				if (itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box[tostring(i)]) then
					bt2[i]=itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box[tostring(i)]
				end
			end
		end
		logger:debug("bt2"..bt2[tag])
		local getScore = fnGetCopyDifficultyStar(itemNetData,copyDifficulty)
		LayerManager.addLayoutNoScale(copyReward.create(tag,bt2[tag],getScore,copyInfo,copyDifficulty))
		-- AudioHelper.playCommonEffect()
		AudioHelper.playSpecialEffect("dianji_fubenbaoxiang.mp3")
	end
end
--判断副本某个难度是否有可领取的星星宝箱 copydata 为空时表示当前副本数据，不为空是外部调用
function isCanGetStarReward(difficulty,copydata)
	local itemData=copydata~=nil and copydata or itemNetData
	local bt2={0,0,0}
	if (itemData.va_copy_info and itemData.va_copy_info.box_info and itemData.va_copy_info.box_info[tostring(difficulty)] and itemData.va_copy_info.box_info[tostring(difficulty)].star_box) then
		for i=1,3 do
			if (itemData.va_copy_info.box_info[tostring(difficulty)].star_box[tostring(i)]) then
				bt2[i]=tonumber(itemData.va_copy_info.box_info[tostring(difficulty)].star_box[tostring(i)])
			end
		end
	end
	
	local copyDbinfo = copyInfo
	if (copydata) then
		copyDbinfo =DB_Copy.getDataById(copydata.copy_id)
	end
	if(copyDbinfo and copyDbinfo.starlevel) then
		local startLv = lua_string_split(copyDbinfo.starlevel,",")
		local getScore = fnGetCopyDifficultyStar(itemData,difficulty)
		for k,v in ipairs(startLv) do
			if (k<= #bt2) then
				if (getScore >= tonumber(v)) and (bt2[k] ~= 1) then
					return true
				end
			end
		end
	end
	return false
end
--领取奖励
function receiveReward( receiveLayout_ )

	local reward1 = m_fnGetWidget(receiveLayout_, "LAY_COPPER", "Layout")
	local reward2 = m_fnGetWidget(receiveLayout_, "LAY_SILVER", "Layout")
	local reward3 = m_fnGetWidget(receiveLayout_, "LAY_GOLD", "Layout")
	reward1:setVisible(false)
	reward2:setVisible(false)
	reward3:setVisible(false)
	local hardSpitImg2 = m_fnGetWidget(receiveLayout_, "IMG_DIVIDE2")
	local hardSpitImg1 = m_fnGetWidget(receiveLayout_, "IMG_DIVIDE1")
	
	if (reward1 and reward2 and reward3 and copyInfo.starlevel) then

		local startLv = lua_string_split(copyInfo.starlevel,",")
		local tbgoldBtn
		if (#startLv == 1) then
			reward1:setVisible(false)
			reward2:setVisible(false)
			reward3:setVisible(true)
			-- starProgressMax=35
			hardSpitImg2:setVisible(false)
			hardSpitImg1:setVisible(false)
			tbgoldBtn = {"GOLD","COPPER","SILVER"}
		elseif (#startLv == 2) then
			reward1:setVisible(false)
			reward2:setVisible(true)
			reward3:setVisible(true)
			-- starProgressMax=65
			hardSpitImg1:setVisible(false)
			tbgoldBtn = {"SILVER","GOLD","COPPER"}
		else
			reward1:setVisible(true)
			reward2:setVisible(true)
			reward3:setVisible(true)
			tbgoldBtn = {"COPPER","SILVER","GOLD"}
		end
		local bt2={0,0,0}
		if (itemNetData.va_copy_info.box_info and itemNetData.va_copy_info.box_info[tostring(copyDifficulty)] and itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box) then
			for i=1,3 do
				if (itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box[tostring(i)]) then
					bt2[i]=tonumber(itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box[tostring(i)])
				end
			end
		end

		--local bt2 = i2bit(tonumber(itemNetData.prized_num),3)
		local getScore,allScore = fnGetCopyDifficultyStar(itemNetData,copyDifficulty) 
		local curAllScore = allScore
		local scoreBar=m_fnGetWidget(receiveLayout_, "LOAD_PROGRESS_BAR")
		local percent = getScore/curAllScore*100
		scoreBar:setPercent(percent)

		if (#startLv == 2 and tonumber(getScore)<=tonumber(startLv[1])) then
			scoreBar:setPercent(getScore/tonumber(startLv[1])*66.6)
		end
		if (#startLv == 2 and tonumber(getScore)>tonumber(startLv[1])) then
			scoreBar:setPercent((getScore-tonumber(startLv[1]))/(tonumber(startLv[2])-tonumber(startLv[1]))*33.3+66.6)
		end
		
		
		for k,v in ipairs(startLv) do
			if (k <= #tbgoldBtn and k<= #bt2) then
				local reward_colse = m_fnGetWidget(receiveLayout_, "BTN_"..tbgoldBtn[k].."_CLOSE", "Button")
				local reward_open = m_fnGetWidget(receiveLayout_, "BTN_"..tbgoldBtn[k].."_CANOPEN", "Button")
				local reward_opened = m_fnGetWidget(receiveLayout_, "BTN_"..tbgoldBtn[k].."_OPENED", "Button")
				local reward_num = m_fnGetWidget(receiveLayout_, "TFD_"..tbgoldBtn[k].."_NUM")
				local rewardEffect = g_fnGetWidgetByName(receiveLayout_, "IMG_"..tbgoldBtn[k].."_EFFECT")
				reward_num:setText(v)
				--UIHelper.labelStroke(reward_num)

				local wardTb = {reward_colse,reward_open,reward_opened,rewardEffect}

				if (getScore >= tonumber(v)) then
					if (bt2[k] == 1) then
						fnShowWidget(wardTb,reward_opened)
						reward_opened:setTag(k)
						reward_opened:addTouchEventListener(onrecReward)
					else
						fnShowWidget(wardTb,reward_open)
						rewardEffect:setEnabled(true)
						rewardEffect:setVisible(true)
						
						reward_open:setTag(k)
						reward_open:addTouchEventListener(onrecReward)
						if (tbgoldBtn[k] == "GOLD") then
							-- fnAnimationOpenBox(rewardEffect,"copy_box",3,"copy_box_goden")
							-- fnAnimationOpenBox(reward_open,"copy_box_1",3,"copy_box")
							fnAnimationOpenBox(reward_open,"copy_box",3,"copy_box_goden")
						elseif (tbgoldBtn[k] == "SILVER") then
							-- fnAnimationOpenBox(rewardEffect,"copy_box",2,"copy_box_silver")
							-- fnAnimationOpenBox(reward_open,"copy_box_1",2,"copy_box")
							fnAnimationOpenBox(reward_open,"copy_box",2,"copy_box_silver")
						else
							-- fnAnimationOpenBox(rewardEffect,"copy_box",1,"copy_box_copper")
							-- fnAnimationOpenBox(reward_open,"copy_box_1",1,"copy_box")
							fnAnimationOpenBox(reward_open,"copy_box",1,"copy_box_copper")
						end
					end
				else
					fnShowWidget(wardTb,reward_colse)
					reward_colse:setTag(k)
					reward_colse:addTouchEventListener(onrecReward)
				end
			end

		end
	end
end

--通关动画回调
function clearTipSeqBack( node )
	node:removeFromParentAndCleanup(true)
end

--副本通关后显示通关提示动画
function showClearanceTip( copyId )
	if (not(copyItemLayer and copyItemLayer.addChild)) then
		return
	end
	local afterAnim=function()
		if (copyId==19) then
			return
		end
		local copyNextInfo = DB_Copy.getDataById(copyId)
		logger:debug("copyNextInfo.name" .. copyNextInfo.name)
		if (copyNextInfo.name ~= nil) then
			local tipSprite = CCSprite:create("images/copy/new_copy_open_bg.png")
			tipSprite:setPosition(ccp(g_winSize.width,g_winSize.height/2 + 50))
			copyItemLayer:addNode(tipSprite)

			local tipTTf = CCLabelTTF:create(copyNextInfo.name,g_sFontPangWa,60)
			tipTTf:enableStroke(ccc3(0x65, 0x05, 0xf0), 3) 
			tipTTf:setFontFillColor(ccc3(0xff, 0xff, 0xf2))
			tipSprite:addChild(tipTTf)
			tipTTf:setPosition(ccp(tipSprite:getContentSize().width/2,tipSprite:getContentSize().height/2))

			-- local  layer1 = CCLayerGradient:create(ccc4(0xc4,0x25,0x00,255), ccc4(0xff,0x78,0x00,255), ccp(0, 0.5))
			-- layer1:setContentSize(CCSizeMake(80,30))
			--   	tipTTf:addChild(layer1)

			local imgOpen = CCSprite:create("images/copy/newcopyopen.png")
			imgOpen:setPosition(ccp(tipSprite:getContentSize().width/2,-10))
			tipSprite:addChild(imgOpen)

			local array = CCArray:create()
			array:addObject(CCMoveTo:create(0.5, ccp(g_winSize.width/2,g_winSize.height/2 + 50)))
			array:addObject(CCDelayTime:create(2))
			array:addObject(CCFadeIn:create(1))
			array:addObject(CCFadeOut:create(1))
			array:addObject(CCCallFuncN:create(clearTipSeqBack))
			local action = CCSequence:create(array)
			tipSprite:runAction(action)
		end
	end
	if (copyDifficultyCount>=2 and copyDifficulty==1) then
		screenAnim = UIHelper.createArmatureNode({
								filePath = "images/effect/skypiea/bell_duang.ExportJson",
								animationName = "copy_nandu",
								loop = 0,
								fnMovementCall=afterAnim
								}
							)
		screenAnim:setPosition(ccp(g_winSize.width/2,g_winSize.height/2 + 50))
		copyItemLayer:addNode(screenAnim)
	else
		afterAnim()
	end
end

-----------数据请求返回处理
--[[
    @desc   普通副本的回调
    @para   void
    @return void
--]]
function getCopyBattleCallback( cbFlag, dictData, bRet )
	if(dictData and dictData.ret) then

	end
end

--处理领取奖励后的宝箱数据
function doBoxState( boxId )
	-- local bt2 = i2bit(tonumber(itemNetData.prized_num),3)
	-- logger:debug(bt2)
	if (boxId ~= nil) then
		if (itemNetData.va_copy_info.box_info==nil) then
			itemNetData.va_copy_info.box_info={}
		end
		if (itemNetData.va_copy_info.box_info[tostring(copyDifficulty)]==nil) then
			itemNetData.va_copy_info.box_info[tostring(copyDifficulty)] ={}
		end
		if (itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box==nil) then
			itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box={}
		end

		itemNetData.va_copy_info.box_info[tostring(copyDifficulty)].star_box[tostring(boxId)]=1
		
		local rewardLayout = m_fnGetWidget(copyItemLayer, "LAY_REWARD", "Layout")
		if (rewardLayout) then
			receiveReward(rewardLayout)
		end
		--刷新难度选择相关
		showSelectDifficultyInfo()
	end
end
--处理领取通关奖励后的宝箱数据
function doPassBoxState( baseId )
	-- local bt2 = i2bit(tonumber(itemNetData.prized_num),3)
	-- logger:debug(bt2)
	logger:debug("get pass reward =====" .. baseId)
	if (baseId ~= nil) then

		if (itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty]==nil) then
			itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty]={}
		end
		itemNetData.va_copy_info.baselv_info[""..baseId][""..copyDifficulty].boxstatus=1
		logger:debug("get pass reward =========")
		logger:debug(itemNetData)
		--刷新pass box ui
		for i=1,30 do
			local fieldName = "baseid_"..i
			local baseId_ = copyInfo[fieldName]
			local state = fnGetAttStaus(baseId_)
			if (baseId_~=nil and (baseLayout:getChildByTag(baseId_+5000) ~= nil)) then
				baseLayout:removeChildByTag(baseId_+5000,true)
			end
			if(baseId_ ~= nil) then
				copyPassRewardBox(baseId_,state)
			end
		end
		--刷新难度选择相关
		showSelectDifficultyInfo()

	end
end
--当前界面是否存在 
function isInItemCopy()
	return copyItemLayer and true or false
end
-- 析构函数，释放纹理资源
function destroy( ... )

end

--add by huxiaozhou for new hand guide --
function disableSCV( )
	local scvItem = m_fnGetWidget(copyItemLayer, "SCV_MAIN", "ScrollView")
	scvItem:setTouchEnabled(false)
end

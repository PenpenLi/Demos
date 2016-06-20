-- FileName: ExplorMainCtrl.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 主探索界面
--[[TODO List]]

require "script/module/copy/ExploreProgressRewardCtrl"
require "script/module/switch/SwitchCtrl"
require "script/module/copy/ExploreKeyCtrl"

module("ExplorMainCtrl", package.seeall)

-- UI控件引用变量 --
local layoutMain = nil
local mainLayer = nil
local actionLayer = nil --动作容器
local aniShip =nil
local effectNode=nil
local addEffect=nil  --+1特效
local mNumValueTemplate=nil --数值条clone
-- 模块局部变量 --
local copeInfoData = nil
local m_fnGetWidget = g_fnGetWidgetByName
local isExploreIng=false
local m_upstatus = false --本次探索升级状态
local gi18n = gi18n
local exploreConsumeType = 1 --探索消耗类型1为耐力 2为道具


local function init(...)
	local copyname = m_fnGetWidget(mainLayer, "TFD_COPY_NAME")
	copyname:setText(copeInfoData.name)
	update()
	UpdateExplorInfo()
	local needStam = m_fnGetWidget(mainLayer, "TFD_RECOVER_TIME_2")
	needStam:setText(ExplorData.getNeedStaminaNumber())

	UIHelper.labelNewStroke( mainLayer.TFD_LEFT_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayer.TFD_RIGHT_NUM, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayer.tfd_slant, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.labelNewStroke( mainLayer.tfd_progress, ccc3(0x28,0x00,0x00), 2 )
end

--更新探索进度
function update()
	local min,max,rewardnum = ExplorData.getExploreProgress()
	mainLayer.TFD_LEFT_NUM:setText(min)
	mainLayer.TFD_RIGHT_NUM:setText(max)
	
	local npercent = min / max * 100
	local progress = m_fnGetWidget(mainLayer, "LOAD_FINISH")
	progress:setPercent((npercent > 100) and 100 or npercent)

	--进度奖励
	local rewardBtn = m_fnGetWidget(mainLayer, "IMG_SUPAR_REWARD_BG")
	rewardBtn:removeAllChildrenWithCleanup(true)
	rewardBtn:addChild(ExploreProgressRewardCtrl.create(update))

end
--显示+1特效
function showAddEffect()
	addEffect:setVisible(true)
	addEffect:getAnimation():playWithIndex(0,-1,-1,0)--("tansuo", -1, -1, 0)
end

function updateExploreTimes()
	local stamina = UserModel.getStaminaNumber()
	local stamBg = m_fnGetWidget(mainLayer, "LAY_NUM")
	local itemBg = m_fnGetWidget(mainLayer, "LAY_ITEM")
	if (stamina>=ExplorData.getNeedStaminaNumber() or ItemUtil.getCacheItemNumBy(60019)<=0) then --当有内力 或 没有道具时 显示内力
		itemBg:setVisible(false)
		stamBg:setVisible(true)
		local stamTimes = m_fnGetWidget(stamBg, "TFD_EXPLORE_NUM_2")
		stamTimes:setText(UserModel.getStaminaNumber().."/"..UserModel.getMaxStaminaNumber())
		local needStam = m_fnGetWidget(stamBg, "TFD_RECOVER_TIME_2")
		needStam:setText(ExplorData.getNeedStaminaNumber())
	else
		itemBg:setVisible(true)
		stamBg:setVisible(false)
		local haveNum = m_fnGetWidget(itemBg, "TFD_ITEM_NUM_2")
		haveNum:setText(ItemUtil.getCacheItemNumBy(60019))
	end
	--更新奇遇事件按钮
	require "script/module/adventure/AdventureModel"
	AdventureModel.refreshAdventureData()
	local eventNum = AdventureModel.getAdventureEventNum()
	local eventRedNum = AdventureModel.getAdventureRedNum()
	local thingBtn = m_fnGetWidget(mainLayer, "BTN_THINGS")
	local imgRed = m_fnGetWidget(mainLayer, "IMG_TIP")
	local lbRed = m_fnGetWidget(mainLayer, "LABN_TIP")
	if (eventNum<=0) then
		-- thingBtn:setBright(false)
		UIHelper.setWidgetGray(thingBtn,true)
		--thingBtn:setTouchEnabled(false)
	else
		-- thingBtn:setBright(true)
		UIHelper.setWidgetGray(thingBtn,false)
		--thingBtn:setTouchEnabled(true)
	end
	if (eventRedNum<=0) then
		imgRed:setVisible(false)
	else
		imgRed:setVisible(true)
		lbRed:setStringValue(eventRedNum)
	end
end
--[[desc:更新探索次数和时间
    arg1: nil
    return: nil  
—]]
function UpdateExplorInfo()
	updateExploreTimes()
	schedule(layoutMain,updateExploreTimes,1.0)
end
function destroy(...)
	--SwitchCtrl.postBattleNotification(GlobalNotify.END_EXPLORE)
	package.loaded["ExplorMainCtrl"] = nil
end

function moduleName()
    return "ExplorMainCtrl"
end
--奖励预览回调
local function previewCallback(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	local itemArr=lua_string_split(copeInfoData.preview_reward,",")
	local items = {}
	for i,v in ipairs(itemArr) do
		local itemObj = ItemUtil.getItemById(tonumber(v))
		local item = {}
		item.tid = v
		item.num = 1
		item.name = itemObj.name
		item.quality = itemObj.quality
		item.icon = ItemUtil.createBtnByTemplateId(v,
							function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
								if (eventType == TOUCH_EVENT_ENDED) then
									PublicInfoCtrl.createItemInfoViewByTid(v)
								end
							end)
		table.insert(items,item)
	end
	local brow=UIHelper.createRewardPreviewDlg(gi18n[1952], items, function()
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end, copeInfoData.name..gi18n[1953])
	LayerManager.addLayout(brow)
end

--一键探索
function onCheckBox( sender, eventType )
	if (layoutMain==nil) then
		return
	end
	AudioHelper.playCommonEffect()
	sender = layoutMain.CBX_ONE_KEYBOARD
	if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
		local vipArr=DB_Vip.getArrDataByField("level",UserModel.getVipLevel())
		local vipInfo = lua_string_split(vipArr[1].isOpenAKeyExploration,"|")
		if (tonumber(vipInfo[1])==0 and UserModel.getHeroLevel()<tonumber(vipInfo[2])) then
			ShowNotice.showShellInfo(gi18n[4304])
			sender:setSelectedState(false)
		else
			sender:setSelectedState(true)
			local selectbg = m_fnGetWidget(mainLayer, "tfd_keyboard")
			selectbg:setText(gi18n[1954])
		end
	end
	if (eventType == CHECKBOX_STATE_EVENT_UNSELECTED) then
		sender:setSelectedState(false)
		local selectbg = m_fnGetWidget(mainLayer, "tfd_keyboard")
		selectbg:setText(gi18n[1955])
		setExploreStatus(false)
		-- --显示探索指针
		-- performWithDelay(layoutMain,
		-- 		function()
		-- 			setExploreStatus(false)
		-- 		end
		-- 			,1.0)
	end
end

function create(ncopyid)
	SimpleAudioEngine:sharedEngine():preloadEffect("audio/effect/explore02.mp3")
	SimpleAudioEngine:sharedEngine():preloadEffect("audio/effect/explore_thing.mp3")
	isExploreIng=false
	copeInfoData=DB_Copy.getDataById(ncopyid)
	--主背景UI
	layoutMain = Layout:create()

	local rewardlay = g_fnLoadUI("ui/explore_num_reward.json")
	mNumValueTemplate = m_fnGetWidget(rewardlay,"img_bg")
	mNumValueTemplate:retain()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					AudioHelper.playMainMusic()
					SwitchCtrl.postBattleNotification(GlobalNotify.END_EXPLORE)
					layoutMain=nil
					mNumValueTemplate:release()
					mNumValueTemplate = nil
				end,
				function()
				end
			)
		AudioHelper.playSceneMusic(copeInfoData.explore_music)
		mainLayer = g_fnLoadUI("ui/explore_main.json")
		mainLayer:setSize(g_winSize)
		layoutMain:addChild(mainLayer)
		mainLayer:setTouchEnabled(true)
		mainLayer:addTouchEventListener(explorCallback)

		actionLayer = CCLayer:create()
		mainLayer:addNode(actionLayer)
		--添加add特效果
		local tbParams = {
						filePath  = "images/effect/explore/explore_add/explore_add.ExportJson",
	                    }
	    addEffect = UIHelper.createArmatureNode(tbParams)
	    addEffect:setVisible(false)
		mainLayer.IMG_ADD:addNode(addEffect)
		--开始探索文字特效
		tbParams = {
						filePath  = "images/effect/explore/explore_desc/explore_desc.ExportJson",
	                    }
	    local startEffect = UIHelper.createArmatureNode(tbParams)
	    startEffect:getAnimation():playWithIndex(0,-1,-1,-1)
		mainLayer.IMG_EXPLORE_EFFECT:addNode(startEffect)
		--奇遇icon下发光特效
		tbParams = {
						filePath  = "images/effect/battle_result/win_drop.ExportJson",
						animationName = "win_drop_blue",
						loop=-1
	                    }
	    local guangEffect = UIHelper.createArmatureNode(tbParams)
		mainLayer.img_item_bg:addNode(guangEffect)
		mainLayer.img_item_bg:setVisible(false)

		local selectbtn = m_fnGetWidget(mainLayer, "CBX_ONE_KEYBOARD")
		selectbtn:setSelectedState(false)
		selectbtn:addEventListenerCheckBox(onCheckBox)

		local function selectBgEvent(sender, eventType)
			if (eventType ~= TOUCH_EVENT_ENDED) then
				return
			end
			if (selectbtn:getSelectedState()) then
				onCheckBox(selectbtn,CHECKBOX_STATE_EVENT_UNSELECTED)
			else
				onCheckBox(selectbtn,CHECKBOX_STATE_EVENT_SELECTED)
			end
		end
		local selectbg = m_fnGetWidget(mainLayer, "lay_cbx")
		selectbg:setTouchEnabled(true)
		selectbg:addTouchEventListener(selectBgEvent)

		local closeBtn = m_fnGetWidget(mainLayer, "BTN_BACK")
		UIHelper.titleShadow(closeBtn, gi18n[1019])
		closeBtn:addTouchEventListener(
			function(sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playBackEffect()
					require "script/module/copy/MainCopy"
					if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
						require "script/module/public/DropUtil"
      					local returnflag = DropUtil.getReturn("ExplorMainCtrl")
      					if (returnflag) then
      						return
      					end

						MainCopy.destroy()
						local layCopy = MainCopy.create(3,true)
						if (layCopy) then
							LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
							PlayerPanel.addForExplorMapNew()
							MainCopy.updateBGSize()
							MainCopy.setFogLayer()
							MainCopy.resetScrollOffset()
						end
					end
				end
			end
			)
		local thingBtn = m_fnGetWidget(mainLayer, "BTN_THINGS")
		-- UIHelper.titleShadow(thingBtn, "奇遇事件") --TODO
		thingBtn:addTouchEventListener(
			function(sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					require "script/module/adventure/AdventureModel"
					AdventureModel.refreshAdventureData()
					local eventNum = AdventureModel.getAdventureEventNum()
					if (eventNum<=0) then
						ShowNotice.showShellInfo(gi18n[4367])
						return
					end
					require "script/module/adventure/AdventureMainCtrl"
					if (AdventureMainCtrl.moduleName() ~= LayerManager.curModuleName()) then
						AdventureMainCtrl.destroy()
						local layCopy = AdventureMainCtrl.create(ncopyid)
						if (layCopy) then
							LayerManager.changeModule(layCopy, AdventureMainCtrl.moduleName(), {1}, true)
							PlayerPanel.addForActivityCopy()
						end
					end
				end
			end
			)

		local grabBtn = m_fnGetWidget(mainLayer, "BTN_GRAB")
		grabBtn:setEnabled(false) -- zhangqi, 2015-10-10, 夺宝入口暂时隐藏
		-- grabBtn:addTouchEventListener(
		-- 	function(sender, eventType)
		-- 		if (eventType == TOUCH_EVENT_ENDED) then
		-- 			AudioHelper.playCommonEffect()
		-- 			if(not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure,true)) then
		-- 				return
		-- 			end
		-- 		    require "script/module/grabTreasure/MainGrabTreasureCtrl"
		-- 		    MainGrabTreasureCtrl.create(nil,nil,ncopyid)
		-- 		end
		-- 	end
		-- 	)

		local BTN_BOX = m_fnGetWidget(mainLayer, "BTN_BOX")
		BTN_BOX:setEnabled(true) -- zhangjunwu, 2016-1-4, 开宝箱入口
		BTN_BOX:setTouchEnabled(true) -- zhangjunwu, 2016-1-4, 开宝箱入口
		local nKeyNum = BuyBoxData.getAllKeyNum()
		BTN_BOX.IMG_BOX_TIP:setEnabled(true)
		if(nKeyNum > 0) then
			BTN_BOX.IMG_BOX_TIP:setEnabled(true)
			BTN_BOX.LABN_BOX_TIP:setStringValue(nKeyNum)
		else
			BTN_BOX.IMG_BOX_TIP:setEnabled(false)
		end
		BTN_BOX:addTouchEventListener(

			function(sender, eventType)
				logger:debug("kaixiangzi")
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					if(SwitchModel.getSwitchOpenState(ksSwitchBuyTreasBox,true)) then

						require "script/module/wonderfulActivity/buyBox/BuyBoxCtrl"
						BuyBoxCtrl.create(ncopyid)
					end
				end
			end
			)

		if(not SwitchModel.getSwitchOpenState(ksSwitchBuyTreasBox,false)) then

			BTN_BOX:setEnabled(false)
		end

		
		local previewBtn = m_fnGetWidget(mainLayer, "BTN_REWARD_PREVIEW")
		previewBtn:addTouchEventListener(previewCallback)


		local shopBtn = m_fnGetWidget(mainLayer, "BTN_SHOP")
		
		if(SwitchModel.getSwitchOpenState(ksSwitchSpeShop,false)) then
			shopBtn.IMG_RED:setEnabled(tonumber(TreaShopData.getFreeTimes()) > 0)
			shopBtn:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					require "script/module/treaShop/TreaShopCtrl"
					TreaShopCtrl.create(ncopyid)
				end
			end)
		else
			shopBtn:setEnabled(false)
		end



		-- local explorBtn = m_fnGetWidget(mainLayer, "BTN_EXPLORE")
		-- explorBtn:addTouchEventListener(explorCallback)
    	
		GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function()
					isExploreIng=false
				end,
				true
			)

		-- 缩放背景
		local layRoot = m_fnGetWidget(mainLayer, "IMG_BG")
	    local tbParams = {
						filePath  = "images/effect/explore/tansuo/tansuo.ExportJson",
	                    
	                    fnMovementCall = function ( sender, MovementEventType , frameEventName)
	                        if (MovementEventType == 1) then
	                          --  sender:removeFromParentAndCleanup(true)
	                        end
	                    end,
	                    fnFrameCall=function(bone, frameEventName, originFrameIndex, currentFrameIndex)
							-- if (frameEventName == "1") then
							-- 	AudioHelper.playEffect("audio/effect/explore01.mp3")
							-- end
							-- if (frameEventName == "2") then
							-- 	AudioHelper.playEffect("audio/effect/A006_step_02.mp3")
							-- end
							-- if (frameEventName == "3") then
							-- 	AudioHelper.playEffect("audio/effect/A006_step_03.mp3")
							-- end
						end,
	                    }

	    effectNode = UIHelper.createArmatureNode(tbParams)
	    local filePath="images/explore/explore_bg/" .. copeInfoData.explore_bg
	    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(filePath..".plist", filePath..".png")
	    
	    local ccSkin1_1 = CCSkin:createWithSpriteFrameName(copeInfoData.explore_bg.."_2.png")
		effectNode:getBone("tansuo_1_1"):addDisplay(ccSkin1_1, 0)
		local ccSkin1 = CCSkin:createWithSpriteFrameName(copeInfoData.explore_bg.."_2.png")
		effectNode:getBone("tansuo_1"):addDisplay(ccSkin1, 0)
		local ccSkin2 = CCSkin:createWithSpriteFrameName(copeInfoData.explore_bg.."_1.png")
		effectNode:getBone("tansuo_2"):addDisplay(ccSkin2, 0)
		local ccSkin2_1 = CCSkin:createWithSpriteFrameName(copeInfoData.explore_bg.."_1.png")
		effectNode:getBone("tansuo_2_1"):addDisplay(ccSkin2_1, 0)

		--图片比较大，使用比较少，这类图片创建后需要立即删除缓存 liweidong
		CCTextureCache:sharedTextureCache():removeTextureForKey(filePath..".png")
	    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(filePath..".plist")

	    layRoot:addNode(effectNode)
		layRoot:setScale(g_fScaleX)

		local layHome = m_fnGetWidget(mainLayer, "lay_home_paomadeng")
		layHome:setScale(g_fScaleX)
		local imgOperate = m_fnGetWidget(mainLayer, "img_operate")
		imgOperate:setScale(g_fScaleX)
		
		--主船动画
		--addMainShipAnimation()
		init()
	end
	SwitchCtrl.postBattleNotification(GlobalNotify.BEGIN_EXPLORE)

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideExploreView"
	if (GuideModel.getGuideClass() == ksGuideExplore and GuideExploreView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createExploreGuide(4)
	end

	require "script/module/guide/GuideTreasView"
	if (GuideModel.getGuideClass() == ksGuideTreasure and GuideTreasView.guideStep == 8) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.removeGuide()
	end
	
	local vipArr=DB_Vip.getArrDataByField("level",UserModel.getVipLevel())
	local vipInfo = lua_string_split(vipArr[1].isOpenAKeyExploration,"|")
	layoutMain.tfd_vip:setText(gi18n[4347])
	if (tonumber(vipInfo[1])==0 and UserModel.getHeroLevel()<tonumber(vipInfo[2])) then
	-- if (vipArr[1].isOpenAKeyExploration==0) then
		layoutMain.tfd_vip:setVisible(true)
	else
		layoutMain.tfd_vip:setVisible(false)
	end
	return layoutMain
end
--显示数值奖励
function showRewardValue(rewards)
	if (table.count(rewards)<=0) then
		return 0.01
	end
	-- local rewardlay = g_fnLoadUI("ui/explore_num_reward.json")
	local template = mNumValueTemplate --m_fnGetWidget(rewardlay,"img_bg")
	logger:debug(rewards)
	local times = 0.15
	local num=0
	for _,info in pairs(rewards) do
		local rewardbg = template:clone()
		rewardbg:setVisible(false)
		rewardbg:setPositionType(POSITION_ABSOLUTE)
		rewardbg:setScale(g_fScaleX)
		actionLayer:addChild(rewardbg)

		local iconbg = m_fnGetWidget(rewardbg,"IMG_NUM")
		iconbg:addChild(info[1])
		local typename = m_fnGetWidget(rewardbg,"TFD_REWARD_TYPE")
		typename:setText(info[2])
		local value = m_fnGetWidget(rewardbg,"TFD_REWARD_NUM")
		value:setText(" + "..info[3])
		--暴击
		local bout = m_fnGetWidget(rewardbg,"IMG_TIMES")
		bout:setVisible(false)
		if (info[4]~=nil and info[4]>1) then
			local boutImg = ImageView:create()
			boutImg:loadTexture("images/common/explore_times_"..info[4]..".png")
			bout:addChild(boutImg)
		end

		local actions = CCArray:create()
		actions:addObject(CCDelayTime:create(num*0.15))
		actions:addObject(CCShow:create())

		actions:addObject(CCEaseOut:create(CCMoveTo:create(0.1, ccp(rewardbg:getPositionX(),rewardbg:getPositionY()+320-num*(54*g_fScaleY))), 0.5))
		if (num>=0) then
			actions:addObject(CCTargetedAction:create(bout,CCShow:create()))
		end
		local times = num
		actions:addObject(CCCallFuncN:create(function(node)
				if ((tonumber(info[4])==2 or tonumber(info[4])==4) and times==0) then
					AudioHelper.playSpecialEffect("explore03_X2X4.mp3")
				elseif (tonumber(info[4])==8 and times==0) then
					AudioHelper.playSpecialEffect("explore03_X8.mp3")
				else
					AudioHelper.playSpecialEffect("explore02.mp3")
				end
			end)
		)
		actions:addObject(CCDelayTime:create(0.8))
		actions:addObject(CCEaseIn:create(CCMoveTo:create(0.1, ccp(rewardbg:getPositionX(),rewardbg:getPositionY()+640-num*(54*g_fScaleY))), 0.5))
		--CCMoveBy:create(0.15, ccp(0,320))
		actions:addObject(CCHide:create())

		--actions:addObject(CCDelayTime:create(5.0))
		actions:addObject(CCCallFuncN:create(function(node)
				node:removeFromParentAndCleanup(true)
			end)
		)
		actions:retain()
		UIHelper.registExitAndEnterCall(rewardbg,function()
				actions:release()
			end)
		performWithDelayFrame(rewardbg,function()
				-- if (rewardbg:numberOfRunningActions()<1) then
				-- 	rewardbg:runAction(CCSequence:create(actions))
				-- end
				rewardbg:runAction(CCSequence:create(actions))
			end,1)

		num=num+1
	end
	times = times*(num+1)+1
	-- if (times<2.0) then times=2.0 end
	logger:debug("run times explor value" .. times)
	return times
end
--生成数值奖励数据
function createValueData(resInfo,eventInfo)
	local items = {}
	if (resInfo.silver) then
		--贝利
		local valArr = {}
		local imgIcon = ImageView:create()
    	imgIcon:loadTexture("images/common/explore_belly.png")
		table.insert(valArr,imgIcon)
		table.insert(valArr,gi18n[1520])
		table.insert(valArr,resInfo.silver)
		local oSliver = math.floor(resInfo.silver/(OutputMultiplyUtil.getMultiplyRateNum(3)/10000))
		local base1,base2,bout=0,0,1 --贝利1，8 暴击倍数
		local arr=string.split(eventInfo.reward,",")
		for _,info in pairs(arr) do
			local val = string.split(info,"|")
			logger:debug(val)
			if (tonumber(val[1])==1) then
				base1=tonumber(val[3])
			end
			if (tonumber(val[1])==8) then
				base2=val[3]*UserModel.getHeroLevel()
			end
		end
		if (tonumber(base1)~=0 and oSliver%base1==0) then
			bout=math.modf(oSliver/base1)
		end
		if (tonumber(base2)~=0 and oSliver%base2==0) then
			bout=math.modf(oSliver/base2)
		end
		table.insert(valArr,bout)
		table.insert(items,valArr)
		UserModel.addSilverNumber(resInfo.silver)
	end
	if (resInfo.jewel) then
		--海魂
		local valArr = {}
		table.insert(valArr,ItemUtil.getJewelIconByNum())
		table.insert(valArr,gi18n[2082])
		table.insert(valArr,resInfo.jewel)
		table.insert(items,valArr)
		UserModel.addJewelNum(resInfo.jewel)
	end
	if (resInfo.prestige) then
		--声望
		local valArr = {}
		table.insert(valArr,ItemUtil.getPrestigeIconByNum())
		table.insert(valArr,gi18n[1921])
		table.insert(valArr,resInfo.prestige)
		table.insert(items,valArr)
		UserModel.addPrestigeNum(resInfo.prestige)
	end
	if (resInfo.gold) then
		--金币
		local valArr = {}
		table.insert(valArr,ItemUtil.getGoldIconByNum())
		table.insert(valArr,gi18n[2220])
		table.insert(valArr,resInfo.gold)
		table.insert(items,valArr)
		UserModel.addGoldNumber(resInfo.gold)
	end
	if (resInfo.execution) then
		--体力
		local valArr = {}
		table.insert(valArr,ItemUtil.getSmallPhyIconByNum())
		table.insert(valArr,gi18n[1922])
		table.insert(valArr,resInfo.execution)
		table.insert(items,valArr)
		UserModel.addEnergyValue(resInfo.execution)
	end
	if (resInfo.stamina) then
		--耐力
		local valArr = {}
		table.insert(valArr,ItemUtil.getStaminaIconByNum())
		table.insert(valArr,gi18n[1923])
		table.insert(valArr,resInfo.stamina)
		table.insert(items,valArr)
		UserModel.addStaminaNumber(resInfo.stamina)
	end
	local bLvUp = false
	if (resInfo.exp) then
		--经验
		local valArr = {}
		local imgIcon = ImageView:create()
    	imgIcon:loadTexture("images/common/explore_exp.png")
		table.insert(valArr,imgIcon)
		table.insert(valArr,gi18n[1975])
		table.insert(valArr,resInfo.exp)
		local oExp = math.floor(resInfo.exp/(OutputMultiplyUtil.getMultiplyRateNum(3)/10000))
		local base1,base2,bout=0,0,1 --贝利1，8 暴击倍数
		local arr=string.split(eventInfo.reward,",")
		for _,info in pairs(arr) do
			local val = string.split(info,"|")
			logger:debug(val)
			if (tonumber(val[1])==16) then
				base1=val[3]
			end
			if (tonumber(val[1])==17) then
				base2=val[3]*UserModel.getHeroLevel()
			end
		end
		if (tonumber(base1)~=0 and oExp%base1==0) then
			bout=math.modf(oExp/base1)
		end
		if (tonumber(base2)~=0 and oExp%base2==0) then
			bout=math.modf(oExp/base2)
		end
		table.insert(valArr,bout)
		if (UserModel.hasReachedMaxLevel()) then -- 经验达到满级
			valArr[3]=0
		end
		table.insert(items,valArr)
		--判断是否升级 调用升级面板
		bLvUp=getExpLevelUp(resInfo.exp)
		
	end 
	--宝物结晶resInfo.rime
	if (resInfo.item and resInfo.item["60029"]~=nil) then
		local rime= tonumber(resInfo.item["60029"])
		logger:debug({rime=rime})
		--经验
		local valArr = {}
		local imgIcon = ImageView:create()
    	imgIcon:loadTexture("images/common/explore_trea.png")
		table.insert(valArr,imgIcon)
		table.insert(valArr,gi18n[4390])
		table.insert(valArr,rime)
		local oRime = math.floor(rime/(OutputMultiplyUtil.getMultiplyRateNum(3)/10000))
		local base1,base2,bout=0,0,1 --贝利1，8 暴击倍数
		local arr=string.split(eventInfo.reward,",")
		for _,info in pairs(arr) do
			local val = string.split(info,"|")
			logger:debug(val)
			if (tonumber(val[1])==7 and tonumber(val[2])==60029) then
				base1=val[3]
			end
		end
		if (tonumber(base1)~=0 and oRime%base1==0) then
			bout=math.modf(oRime/base1)
		end
		table.insert(valArr,bout)
		table.insert(items,valArr)
		resInfo.item["60029"]=nil
		if (table.count(resInfo.item)<=0) then
			resInfo.item = nil
		end
		logger:debug({resInfo=resInfo})
		-- UserModel.addRimeNum(rime,true)
	end  
    return items,bLvUp
end
--判断是否升级
function getExpLevelUp(nAddExp)
	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
	local nNewExpNum = (nExpNum + nAddExp)%nLevelUpExp -- 得到当前显示的经验值分子
	logger:debug("lastExp = " .. nExpNum .. " addExp = " .. nAddExp .. " nextExp = " .. nLevelUpExp .. " newExp = " .. nNewExpNum)

	local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp; -- 获得经验后是否升级
	if (UserModel.hasReachedMaxLevel()) then
		bLvUp=false
	end
	
	UserModel.addExpValue(nAddExp, "explore")
	return bLvUp
end
--执行升级
function playLevelUp(curr_stamina,stamina_time)
	if (m_upstatus) then
		performWithDelay(layoutMain,function()
			logger:debug("up level remove explore layer=======")
				LayerManager.removeLayoutByName("Explor_mask_layout")  --有升级 点击探索按钮时增加的屏蔽层
				GlobalNotify.postNotify(GlobalNotify.LEVEL_UP)
				UserModel.setStaminaNumber(curr_stamina)
				UserModel.setStaminaTime(stamina_time)
			end
			,0.01
			)
	end
end
--执行探索请求
function exploreReqEvent()
	if isExploreIng==true then
		return
	end
	isExploreIng =true
	local function exploreCallback(cbFlag, dictData, bRet)
		if(dictData.ret~=nil and dictData.err=="ok")then
			isExploreIng=false
			local resInfo=dictData.ret[1]
			logger:debug({exploreData=dictData})
			--添加代码减少探索次数 增加探索进度
			ExplorData.subStaminaByExplore(exploreConsumeType)  --改为消耗耐力  addExploreTimesEvent(-1)
			-- UserModel.setStaminaNumber(resInfo.curr_stamina)
			-- UserModel.setStaminaTime(resInfo.stamina_time)
			if (tonumber(resInfo.has_reward)==1) then
				local function getExploreInfoCallBack( cbFlag, res, bRet ) 
			 		 DataCache.setExploreInfo(res.ret)
			 		 updateExploreTimes()
			 		 update()
			 	end
				RequestCenter.explorInfo(getExploreInfoCallBack)
				UserModel.setStaminaNumber(resInfo.curr_stamina)
				UserModel.setStaminaTime(resInfo.stamina_time)
				return
			end

			if (resInfo.ret~="ok") then
				--后端返回没有耐力，不作任何操作
				UserModel.setStaminaNumber(resInfo.curr_stamina)
				UserModel.setStaminaTime(resInfo.stamina_time)
				return
			end
			--显示结果动作完成之前不可操作屏蔽层
			local layout = Layout:create()
			layout:setName("Explor_mask_layout")
			LayerManager.addLayoutNoScale(layout)
			logger:debug("add explore layer=======")
			--GlobalNotify.removeObserver(GlobalNotify.NETWORK_FAILED,"REMOVE_EXPLORE_TOP_LAYER")
			logger:debug(dictData.ret)
			setExploreStatus(true)
			effectNode:getAnimation():playWithIndex(0,-1,-1,0)--("tansuo", -1, -1, 0)
			-- AudioHelper.playBtnEffect("tansuo.mp3")
			AudioHelper.playEffect("audio/effect/explore01.mp3")
			-- performWithDelay(layoutMain,
			-- 	function()
			-- 		setExploreStatus(false)
			-- 	end
			-- 		,1.5)
			
			
			logger:debug("explore back data ========")
			logger:debug(dictData.ret)
			require "db/DB_Exploration_things"
			local eventInfo=DB_Exploration_things.getDataById(resInfo.event)
			local addvalue,upstatus = createValueData(resInfo,eventInfo) --生成数值奖励数据 并同步数据
			m_upstatus = upstatus
			

			updateExploreTimes()
			ExplorData.addExploreProgress()
			update()
			showAddEffect()
			performWithDelay(layoutMain,function() 
							updateInfoBar() --刷新宝物结晶
						end
					,0.5)
			if (eventInfo.thingType==1) then  --只显示数值奖励
				local times=showRewardValue(addvalue)
				if (not upstatus) then
					UserModel.setStaminaNumber(resInfo.curr_stamina)
					UserModel.setStaminaTime(resInfo.stamina_time)
					performWithDelay(layoutMain,function() 
							LayerManager.removeLayoutByName("Explor_mask_layout")
							ExploreKeyCtrl.completeExplore() --完成一次探索
							setExploreStatus(false)
							require "script/module/guide/GuideModel"
							require "script/module/guide/GuideExploreView"
							if (GuideModel.getGuideClass() == ksGuideExplore and GuideExploreView.guideStep == 4) then
								require "script/module/guide/GuideCtrl"
								GuideCtrl.createExploreGuide(5,0)
							end
						end
					,times)  --如果没有升级 点击探索按钮时增加的屏蔽层 ，交给升级动画执行前移除
				else
					ExploreKeyCtrl.removeKeyExplore() --遇到升级停止一键探索
				end
				performWithDelay(layoutMain,function() 
							playLevelUp(resInfo.curr_stamina,resInfo.stamina_time)
						end
					,times-0.15)
			elseif (eventInfo.thingType==2) then --只显示item奖励
				performWithDelay(layoutMain,
					function()
						if (not upstatus) then
							LayerManager.removeLayoutByName("Explor_mask_layout") --点击探索按钮时增加的屏蔽层
							UserModel.setStaminaNumber(resInfo.curr_stamina)
							UserModel.setStaminaTime(resInfo.stamina_time)
						else
							ExploreKeyCtrl.removeKeyExplore() --遇到升级停止一键探索
						end
						require "script/module/copy/ExplorRewardCtrl"
						local iteminfo=resInfo.item
						if (resInfo.item==nil) then
							iteminfo=resInfo.treasureFrag
						end
						if (iteminfo) then
							local reward = ExplorRewardCtrl.create(iteminfo,resInfo.event,function()
									setExploreStatus(false)
								end)
							LayerManager.addLayoutNoScale(reward)
							playLevelUp(resInfo.curr_stamina,resInfo.stamina_time)
						end
						
					end
						,0.5)
			elseif (eventInfo.thingType==3) then --同时显示数值和item奖励
				local times=showRewardValue(addvalue)
				if (not upstatus) then
					UserModel.setStaminaNumber(resInfo.curr_stamina)
					UserModel.setStaminaTime(resInfo.stamina_time)
					performWithDelay(layoutMain,function() 
							LayerManager.removeLayoutByName("Explor_mask_layout")
						end
					,times)  --如果没有升级 点击探索按钮时增加的屏蔽层 ，交给升级动画执行前移除
				else
					ExploreKeyCtrl.removeKeyExplore() --遇到升级停止一键探索
				end

				performWithDelay(layoutMain,
					function()
						require "script/module/copy/ExplorRewardCtrl"
						local iteminfo=resInfo.item
						if (resInfo.item==nil) then
							iteminfo=resInfo.treasureFrag
						end
						if (iteminfo) then
							local reward = ExplorRewardCtrl.create(iteminfo,resInfo.event,function()
									setExploreStatus(false)
								end)
							LayerManager.addLayoutNoScale(reward)
							playLevelUp(resInfo.curr_stamina,resInfo.stamina_time)
						end
						
					end
						,times-0.15)
			else --奇遇事件
				if (upstatus) then
					ExploreKeyCtrl.removeKeyExplore() --遇到升级停止一键探索
				else
					UserModel.setStaminaNumber(resInfo.curr_stamina)
					UserModel.setStaminaTime(resInfo.stamina_time)
				end
				--增加奇遇事件
				function showAdventureAnim()
					performWithDelay(layoutMain,function() 
							playLevelUp(resInfo.curr_stamina,resInfo.stamina_time)
						end
					,0.01)
					AudioHelper.playSpecialEffect("explore_thing.mp3")
					tbParams = {
									filePath  = "images/effect/explore/explore_thing/explore_thing.ExportJson",
				                    }
				    local thingEffect =nil
				    thingEffect = UIHelper.createArmatureNode({
							filePath  = "images/effect/explore/explore_thing/explore_thing.ExportJson",
							animationName = "explore_thing",
							loop = 0,
							fnFrameCall=function(bone, frameEventName, originFrameIndex, currentFrameIndex)
									if (frameEventName == "1") then
										logger:debug("show Adventure item:")
										logger:debug("images/adventure/menuicon/"..eventInfo.icon)
										mainLayer.img_item_bg:setVisible(true)
										mainLayer.img_item_bg:setPosition(ccp(mainLayer.img_item_pos:getPositionX(),mainLayer.img_item_pos:getPositionY()))
										mainLayer.img_item_bg.img_icon:loadTexture("images/adventure/menuicon/"..eventInfo.icon)
										mainLayer.IMG_THING_NAME:loadTexture("images/adventure/supar_thing_name/"..eventInfo.icon)
										mainLayer.img_item_bg:setScale(0.3)
										local actionArr = CCArray:create()
										actionArr:addObject(CCScaleTo:create(0.1,1.2))
										actionArr:addObject(CCScaleTo:create(0.06,1.0))
										actionArr:addObject(CCDelayTime:create(0.8))
										-- local movePos=mainLayer.BTN_THINGS:getPosition() -- convertToWorldSpace(ccp(mainLayer.BTN_THINGS:getContentSize().width/2,mainLayer.BTN_THINGS:getContentSize().height/2))
										actionArr:addObject(CCEaseIn:create(CCMoveTo:create(0.3,ccp(mainLayer.BTN_THINGS:getPositionX(),mainLayer.BTN_THINGS:getPositionY())),2))
										actionArr:addObject(CCHide:create())
										actionArr:addObject(CCCallFunc:create(function()
												LayerManager.removeLayoutByName("Explor_mask_layout")
												ExploreKeyCtrl.completeExplore() --完成一次探索
												setExploreStatus(false)
												require "script/module/adventure/AdventureModel"
												AdventureModel.addAdventureData(resInfo)
												AdventureModel.refreshAdventureData()
												-- mainLayer.img_item_bg:setPosition(ccp(mainLayer.img_item_pos:getPositionX(),mainLayer.img_item_pos:getPositionY()))
												local eventNum = AdventureModel.getAdventureEventNum()
												if (eventNum==1) then
													local buttonEffect = UIHelper.createArmatureNode({
															filePath  = "images/effect/explore/explore_btn/explore_btn.ExportJson",
															animationName = "explore_btn",
															loop = 0,
															fnMovementCall=function() 
																	mainLayer.BTN_THINGS:removeNodeByTag(100)
																end
															})
													buttonEffect:setPosition(ccp(0,0))
													mainLayer.BTN_THINGS:addNode(buttonEffect,100,100)
												end
											end
											))
										mainLayer.img_item_bg:runAction(CCSequence:create(actionArr))
		 			    			end
								end,
							fnMovementCall=function() 
									mainLayer.img_effect:removeNodeByTag(100)
								end
							}
						)
				    mainLayer.img_effect:addNode(thingEffect,100,100)
				end
				--数值奖励
				local times=showRewardValue(addvalue) --数值奖励
				--物品奖励
				local promptRewardTime=0.5
				if (times>1.15) then
					promptRewardTime=times-0.15
				end
				local iteminfo=resInfo.item
				if (resInfo.item==nil) then
					iteminfo=resInfo.treasureFrag
				end
				if (iteminfo) then
					performWithDelay(layoutMain,
						function()
							require "script/module/copy/ExplorRewardCtrl"
							local reward = ExplorRewardCtrl.create(iteminfo,resInfo.event,showAdventureAnim,true)
							LayerManager.addLayoutNoScale(reward)
						end
							,promptRewardTime)
				end
				--显示奇遇事件
				if (times<=1.15 and iteminfo==nil) then
					showAdventureAnim()
				elseif (times>1.15 and iteminfo==nil) then
					performWithDelay(layoutMain,function() 
								showAdventureAnim()
							end
						,times) 
				elseif (times>1.15 and iteminfo~=nil) then

				end

			end
		end
	end
	local arr = CCArray:create()
	arr:addObject(CCInteger:create(copeInfoData.id))
	arr:addObject(CCInteger:create(1))
	arr:addObject(CCInteger:create(exploreConsumeType-1))
	RequestCenter.exploreReq(exploreCallback,arr)
end
--探索按键回调
function explorCallback(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	-- AudioHelper.playMainMenuBtn()
	AudioHelper.playCommonEffect()

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideExploreView"
	if (GuideModel.getGuideClass() == ksGuideExplore and GuideExploreView.guideStep == 5) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.removeGuide()
	end
	GuideCtrl.removeGuideView()

	local selectbtn = m_fnGetWidget(mainLayer, "CBX_ONE_KEYBOARD")
	if (selectbtn:getSelectedState()) then
		ExploreKeyCtrl.create(mainLayer) --控制权转交给一键探索控制器 并直接返回
		return
	end
	fnBeginExplore()
end
--开始探索
function fnBeginExplore()
	-- --探索次数
	-- local timeInfo = ExplorData.getExploreTimeInfo()
	--判断耐力
	if (UserModel.getStaminaNumber()<ExplorData.getNeedStaminaNumber() and ItemUtil.getCacheItemNumBy(60019)<=0) then
		ExploreKeyCtrl.removeKeyExplore()
		require "script/module/arena/ArenaBuyCtrl"
		local buyLayout = ArenaBuyCtrl.createForArena(updateExploreTimes)
		LayerManager.addLayoutNoScale(buyLayout)
		return
	end
	if (UserModel.getStaminaNumber()>=ExplorData.getNeedStaminaNumber()) then
		exploreConsumeType=1
	else
		exploreConsumeType=2
	end
	-- 检查背包是否已满 
	if (ItemUtil.isBagFull(true)) then
		ExploreKeyCtrl.removeKeyExplore()
		--ShowNotice.showShellInfo("背包已满,请整理背包")
		return
	end
	--判断奖励进度是否已满
	local min,max=ExplorData.getExploreProgress()
	if (min>=max) then
		ExploreKeyCtrl.removeKeyExplore()
		ShowNotice.showShellInfo(gi18n[4345])  --"惊喜奖励进度条已满，请先领取惊喜奖励"
		--ExploreProgressRewardCtrl.autoClickGetReward(update)
		return
	end
	-- local explorBtn = m_fnGetWidget(mainLayer, "BTN_EXPLORE")
	-- local effectNode = explorBtn:getNodeByTag(100)
	-- effectNode:getAnimation():play("refresh", -1, -1, 0) --特效
	exploreReqEvent()
end

--设置探索状态
function setExploreStatus(status,showExplorBtn)
	local promptAnim = m_fnGetWidget(mainLayer, "IMG_EXPLORE_EFFECT")
	promptAnim:getActionManager():removeAllActionsFromTarget(promptAnim)
	if (status) then
		promptAnim:setVisible(false)
	else
		if (not ExploreKeyCtrl.isInKeyExplore()) then
			promptAnim:setVisible(true)
		end
	end
end


--根据突破等级获取主船动画 
function addMainShipAnimation( ... )
	--主船动画
	local lay_ship = m_fnGetWidget(mainLayer, "lay_ship")
	local imgShip = m_fnGetWidget(mainLayer, "img_ship")
	imgShip:setVisible(false)
	local tbShipPos = ccp(imgShip:getPositionX(),imgShip:getPositionY())
	local explore_graph = UIHelper.getExploreShipID()
	UIHelper.addShipAnimation( lay_ship,explore_graph,tbShipPos,ccp(0.5, 0.5),0.7,nil,nil )
end


--探索红点
function setExplorRedByBtn(explorBtn)
	require "script/module/copy/ExplorData"
	local function updateExploreRed()
		local explorRed = m_fnGetWidget(explorBtn, "IMG_EXPLORE_TIP")
		local status,num=ExplorData.getRedStatus()
		explorRed:setVisible(status)
		local redTip = m_fnGetWidget(explorBtn, "LABN_EXPLORE_TIP")
		redTip:setStringValue(num)
	end
	schedule(explorBtn,updateExploreRed,0.5)
	updateExploreRed()
end

-- zhangqi, 2015-10-10, ExplorRewardCtrl中新手引导用到
function getRobBtnWorldPos( ... )
	return mainLayer.BTN_GRAB:convertToWorldSpace(ccp(0,0))
end
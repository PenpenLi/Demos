-- FileName: MainCopyCtrl.lua
-- Author: 
-- Date: 2015-01-10
-- Purpose: 活动副本主界面
--[[TODO List]]

module("MainCopyCtrl", package.seeall)

-- UI控件引用变量 --
local layoutMain = nil
local pageItem = nil
local battleCopyId =nil --当前战斗的副本id
-- 模块局部变量 --
local selectIdx = 1 --选择列表id
local isdrogToRight=false --记录当前手指滑动的方向是不是向右滑动

local function init(...)

end

function destroy(...)
	package.loaded["MainCopyCtrl"] = nil
end

function moduleName()
    return "MainCopyCtrl"
end
--点击菜单
function onClickMenu( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect()
	local menuIds,pageIds = MainCopyModel.getActivityListData()
	local idx = sender:getTag()
	local id = menuIds[idx]
	local db=DB_Activitycopy.getDataById(id)
	if (MainCopyModel.activityIsOpened(id)==false) then
		ShowNotice.showShellInfo(MainCopyModel.getActivityOpenLv(id))
		return
	end
	if (MainCopyModel.activityIsOnTime(id)==false) then
		ShowNotice.showShellInfo(string.format(gi18n[4317],tostring(MainCopyModel.getActivityOpenTimeStr(id))))--"该活动副本（%s）开启"
		return
	end
	selectIdx=idx
	local menuList = g_fnGetWidgetByName(layoutMain, "LSV_MAIN")
	local cell = menuList:getItem(selectIdx-1) 
	UIHelper.autoSetListOffset(menuList,cell)
	updateUI()
	local page = g_fnGetWidgetByName(layoutMain, "PGV_MAIN")
	page:ListToPage(selectIdx-1)
	
end
--更新UI
function updateUI()
	if (layoutMain==nil) then
		return
	end
	require "script/module/copyActivity/MainCopyModel"
	local menuIds,pageIds = MainCopyModel.getActivityListData()
	logger:debug("menuIds=====")
	logger:debug(menuIds)
	logger:debug(pageIds)
	local menuList = g_fnGetWidgetByName(layoutMain, "LSV_MAIN")
	menuList:removeAllItems()
	UIHelper.initListWithNumAndCell(menuList,#menuIds)

	local i = 0
	for k,v in pairs(menuIds) do
		cell = menuList:getItem(i)  -- cell 索引从 0 开始

		local db=DB_Activitycopy.getDataById(v)
		local lock = g_fnGetWidgetByName(cell, "IMG_LOCK")
		local tip = g_fnGetWidgetByName(cell, "IMG_TIP")
		local lvLimit = g_fnGetWidgetByName(cell, "TFD_LEVEL")
		UIHelper.labelNewStroke(lvLimit, ccc3(0,0,0), 2)
		local timeLimit =g_fnGetWidgetByName(cell, "TFD_TIME")
		UIHelper.labelNewStroke(timeLimit, ccc3(0,0,0), 2)
		local isCanClick=false
		if (MainCopyModel.activityIsOpened(v)==false) then
			lock:setVisible(true)
			tip:setVisible(false)
			lvLimit:setVisible(true)
			lvLimit:setText(MainCopyModel.getActivityOpenLv(v))
			timeLimit:setVisible(false)
		elseif (MainCopyModel.activityIsOnTime(v)==false) then
			lock:setVisible(false)
			tip:setVisible(false)
			lvLimit:setVisible(false)
			timeLimit:setVisible(true)
			timeLimit:setText(MainCopyModel.getActivityOpenTimeStr(v))
		else
			isCanClick=true
			lock:setVisible(false)
			tip:setVisible(true)
			lvLimit:setVisible(false)
			timeLimit:setVisible(false)

			local num = MainCopyModel.getRemainAtackTimes(v)
			local tipNum = g_fnGetWidgetByName(cell, "LABN_TIP_NUM")
			tipNum:setStringValue(num)
			if num<=0 then
				tip:setVisible(false)
			end
		end

		local light = g_fnGetWidgetByName(cell, "IMG_LIGHT")
		if selectIdx-1==i then
			light:setVisible(true)
		else
			light:setVisible(false)
		end
		local ImgBtn = g_fnGetWidgetByName(cell, "IMG_MONSTER_SMALL")
		ImgBtn:setTouchEnabled(true)
		-- local imgPath=isCanClick and "images/copy/acopy/".. db.image_small ..".png" or "images/copy/acopy/"..db.image_small .."_a.png"
		ImgBtn:loadTexture("images/copy/acopy/".. db.image_small ..".png")
		ImgBtn:setTag(i+1)
		ImgBtn:addTouchEventListener(onClickMenu)

		cell.IMG_NAME:loadTexture("images/copy/acopy/".. db.image_small .."_name.png")

		if (isCanClick) then
			cell.IMG_NAME:setGray(false)
			ImgBtn:setGray(false)
		else
			cell.IMG_NAME:setGray(true)
			ImgBtn:setGray(true)
		end
		local ImgMinBg = g_fnGetWidgetByName(cell, "IMG_CLOSE_BG")
		ImgMinBg:setVisible(not isCanClick)
		i=i+1
	end

	local page = g_fnGetWidgetByName(layoutMain, "PGV_MAIN")
	page:removeAllPages()
	local i=1
	for k,v in pairs(pageIds) do
		local db=DB_Activitycopy.getDataById(v)
		
		local cell = tolua.cast(pageItem:clone(), "Layout")
		page:addPage(cell)
		local img = g_fnGetWidgetByName(cell, "IMG_MONSTER_BIG")
		img:setTouchEnabled(true)
		img:setTag(v)
		img:getActionManager():removeAllActionsFromTarget(img)
		UIHelper.fnPlayHuxiAni(img)
		img:addTouchEventListener(onCanlageClick)
		img:loadTexture("images/base/hero/body_img/"..db.image_big)

		local content = g_fnGetWidgetByName(cell, "TFD_DESCRIPTION")
		content:setText(db.desc)
		if i==selectIdx then
			initPageBaseInfo(v)
		end
		i=i+1
	end
end


--更新当前页 不在翻页内的内容 奖励 挑战 次数等
function initPageBaseInfo(id)
	local db=DB_Activitycopy.getDataById(id)
	local dropTitle = g_fnGetWidgetByName(layoutMain, "TFD_PREVIEW_TITLE")
	-- dropTitle:loadTexture("images/copy/acopy/"..db.reward_desc..".png")
	dropTitle:setText(db.reward_desc)
	UIHelper.labelNewStroke(dropTitle, ccc3(0x28,0x00,0x00), 2)
	local remainTimes = g_fnGetWidgetByName(layoutMain, "TFD_TIMES_NUM")
	remainTimes:setText(MainCopyModel.getRemainAtackTimes(id))
	UIHelper.labelNewStroke(remainTimes, ccc3(0x28,0x00,0x00), 2)
	local needStrength = g_fnGetWidgetByName(layoutMain, "TFD_TILI")
	needStrength:setText(db.attack_energy) --TODO消耗体力：
	UIHelper.labelNewStroke(needStrength, ccc3(0x28,0x00,0x00), 2)
	local timeInfo = g_fnGetWidgetByName(layoutMain, "tfd_times_info")
	UIHelper.labelNewStroke(timeInfo, ccc3(0x28,0x00,0x00), 2)

	local previewBtn = g_fnGetWidgetByName(layoutMain, "BTN_PREVIEW")
	previewBtn:setTag(id)


	local canlageBtn = g_fnGetWidgetByName(layoutMain, "BTN_CHALLENGE")
	canlageBtn:setTag(id)


	local addBtn = g_fnGetWidgetByName(layoutMain, "BTN_ADD")
	addBtn:setTag(id)
end
--滑动英雄身像
local function heroPageViewEventListener(sender, eventType)
	logger:debug("heroPageEventViewListener")
	if (eventType == PAGEVIEW_EVENT_TURNING) then

		local pageView = tolua.cast(sender, "PageView")
		local page = pageView:getCurPageIndex()
		if (selectIdx==page+1) then
			if (isdrogToRight) then
				local menuIds,pageIds = MainCopyModel.getActivityListData()
				if (menuIds[selectIdx+1]~=nil) then
					if (MainCopyModel.activityIsOpened(menuIds[selectIdx+1])) then
						ShowNotice.showShellInfo(gi18n[4318]) --下一活动副本不在活动期间内
					else
						ShowNotice.showShellInfo(gi18n[4319]) --"下一活动副本未开启"
					end
				end
			end
			return
		end
		local menuList = g_fnGetWidgetByName(layoutMain, "LSV_MAIN")
		local cell = menuList:getItem(page) 

		UIHelper.autoSetListOffset(menuList,cell)
		selectIdx=page+1
		updateUI()
	end
end
--奖励预览
function onPreviewClick( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	local id = sender:getTag()
	local db=DB_Activitycopy.getDataById(id)
	if (db.type==1) then
		require "script/module/copyActivity/BellyRewardPreview"
		BellyRewardPreview.create(id)
	else
		require "script/module/copyActivity/CommonRewardPreview"
		CommonRewardPreview.create(id)
	end
end
--挑战
function onCanlageClick( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideAcopyView"
    if (GuideModel.getGuideClass() == ksGuideAcopy and GuideAcopyView.guideStep == 4) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createAcopyGuide(5,0,function (  )
        	GuideCtrl.removeGuide()
        end) 
    end 

	local id = sender:getTag()

	local db=DB_Activitycopy.getDataById(id)
	--判断剩余次数
	if (MainCopyModel.getRemainAtackTimes(id)<=0) then
		require "script/module/copyActivity/BuyBattleTimes"
		BuyBattleTimes.create(id)
		return
	end
	--判断体力是否够
	if (UserModel.getEnergyValue()<tonumber(db.attack_energy)) then
		require "script/module/copy/copyUsePills"
		LayerManager.addLayout(copyUsePills.create())
		return
	end
	--检查背包是否满
	if (db.type==3 and ItemUtil.isBagFull(true)) then
		return
	end
	battleCopyId=id
	if (db.type==1) then
		require "script/module/copyActivity/BellyChanlage"
		BellyChanlage.create(id)
	else
		require "script/module/copyActivity/ChanlageSelectHard"
		ChanlageSelectHard.create(id)
	end
end
--加载触摸 用于记录当前是否向右滑动
function setTouchPropertyEvent()
   local layer = CCLayer:create()
   layer:setTouchEnabled(true)
   local firstx,firsty=0,0
    local function onTouch(eventType, x,y)
        if eventType == "began" then
             firstx,firsty=x,y
            return true
        elseif eventType == "moved" then

        elseif eventType=="ended" then
        	if (firstx-x>20) then
	            isdrogToRight=true
	        else
	        	isdrogToRight=false
	        end
        end
    end
    layer:registerScriptTouchHandler(onTouch,false,-10000,false)
    layoutMain:addNode(layer)
end
function create(defaultId)
	-- defaultId = 300003
	--主背景UI
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
					pageItem:release()
				end,
				function()
				end
			) 
		--副本标签
		local mainLayout = g_fnLoadUI("ui/acopy_main.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)
		
		local bgEffect = UIHelper.createArmatureNode({
							filePath  = "images/effect/xiaobing/xiaobing.ExportJson",
							animationName = "xiaobing",
							loop = -1
							})
		bgEffect:setScale(g_fScaleX)
		layoutMain.IMG_XIAOBING_EFFECT:addNode(bgEffect)
		
		local img_bg = g_fnGetWidgetByName(layoutMain, "img_bg")
		img_bg:setScale(g_fScaleX)

		local easyBg = g_fnGetWidgetByName(layoutMain, "LAY_EASY")
		--easyBg:setScale(g_fScaleX)
		-- easyBg:setSize(CCSizeMake(easyBg:getContentSize().width*g_fScaleX,easyBg:getContentSize().height*g_fScaleX))

		local lsv_bg = g_fnGetWidgetByName(layoutMain, "IMG_LSV_BG")

		
		local function onBack( sender, eventType )
			if (eventType ~= TOUCH_EVENT_ENDED) then
				return
			end
			AudioHelper.playBackEffect()
			require "script/module/activity/MainActivityCtrl"
			if (MainActivityCtrl.moduleName() ~= LayerManager.curModuleName()) then
				local  layCopy  =  MainActivityCtrl.create()
				if (layCopy) then
					LayerManager.changeModule(layCopy, MainActivityCtrl.moduleName(), {1,3}, true)
					PlayerPanel.addForActivity()
				end
			end
		end

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_BACK")
		backBtn:addTouchEventListener(onBack)
		UIHelper.titleShadow(backBtn)

		local addBtn = g_fnGetWidgetByName(layoutMain, "BTN_ADD")
		addBtn:addTouchEventListener(
					function ( sender, eventType )
						if (eventType ~= TOUCH_EVENT_ENDED) then
							return
						end
						AudioHelper.playCommonEffect() 
						local id = sender:getTag()
						--判断剩余次数
						if (MainCopyModel.getRemainAtackTimes(id)<=0) then
							require "script/module/copyActivity/BuyBattleTimes"
							BuyBattleTimes.create(id)
						else
							ShowNotice.showShellInfo(gi18n[4320]) --TODO"剩余次数用完才可以购买"
						end
					end
			)

		local previewBtn = g_fnGetWidgetByName(layoutMain, "BTN_PREVIEW")
		previewBtn:addTouchEventListener(onPreviewClick)

		local canlageBtn = g_fnGetWidgetByName(layoutMain, "BTN_CHALLENGE")
		canlageBtn:addTouchEventListener(onCanlageClick)
		UIHelper.titleShadow(canlageBtn)

		local page = g_fnGetWidgetByName(layoutMain, "LAY_PAGE")
		pageItem = page:clone()
		pageItem:retain()

		local heroPageView = g_fnGetWidgetByName(layoutMain, "PGV_MAIN")
		heroPageView:addEventListenerPageView(heroPageViewEventListener)
		setTouchPropertyEvent()

		local menuList = g_fnGetWidgetByName(layoutMain, "LSV_MAIN")
		UIHelper.initListView(menuList)

		selectIdx=1
		if (tonumber(defaultId)) then
			local menuIds,pageIds = MainCopyModel.getActivityListData()
			for k,v in ipairs(pageIds) do
				if (tonumber(defaultId)==tonumber(v)) then
					selectIdx=k
					break
				end
			end
		end
		init()
		updateUI()
		performWithDelayFrame(layoutMain,function()
				local page = g_fnGetWidgetByName(layoutMain, "PGV_MAIN")
				page:ListToPage(selectIdx-1)
			end,1)
		
	end
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideAcopyView"
    if (GuideModel.getGuideClass() == ksGuideAcopy and GuideAcopyView.guideStep == 2) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createAcopyGuide(3,0,function (  )
        	GuideCtrl.createAcopyGuide(4)
        end) 
    end 
	LayerManager.changeModule(layoutMain, moduleName(), {1}, true)
	PlayerPanel.addForActivityCopy()
end

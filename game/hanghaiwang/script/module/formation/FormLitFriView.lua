-- FileName: FormLitFriView.lua
-- Author: zhaoqiangjun
-- Date: 14-7-29
-- Purpose: function description of module

require "db/DB_Heroes"
require "script/network/Network"
require "script/module/public/ItemUtil"
require "db/DB_Formation"
require "script/module/public/ShowNotice"

module("FormLitFriView", package.seeall)

local littleOpenFile = "ui/formation_littlef_tip.json"
local widgetlittleOpen		--开启小伙伴位置的提示框。
-- local litHeroPos

local m_formWidget			--阵容的主UI.
local m_widgetBg 			--阵容UI的背景
local m_tabFormFriData		--阵容上小伙伴的列表
local m_tabFormLitFriData 	--阵容上小伙伴的详细信息
local extraTab = {}

local openPos 				--小伙伴开放的位置
local extraPosArr

local m_i18n = gi18n	--国际化函数

local m_getWidget = g_fnGetWidgetByName	--将全局函数局域化。
local m_mainFM = MainFormation
local m_mainFMT = MainFormationTools

local SHOW_SELF_SQUAD = 10001
local SHOW_THEM_SQUAD = 10002
local showSquadTye

local showRecomFri
local mLayMain
local m_LSV_View
local m_UpdateName = "formlitfriview-update"
local LAY_ARROW_UP
local LAY_ARROW_DOWN
local function getHeroInfoByHid( heroHid )
	local heroInfo
	if showSquadTye == SHOW_THEM_SQUAD then
		heroInfo = extraTab[heroHid - 1 ..""]
	else
		heroInfo = HeroModel.getHeroByHid(heroHid)
	end
	return heroInfo
end

local function loadFromLitFriData( ... )
	local f_tabLitFriData = {}

	local f_formData 			= DB_Formation.getDataById(1)
	local f_litFriData 			= f_formData.openFriendByLv
	local f_tabLitFriArr 		= lua_string_split(f_litFriData, ",")
	for i,v in ipairs(f_tabLitFriArr) do
		
		local f_tabLitFriKey 	= lua_string_split(v, "|")
		local f_key = tostring(f_tabLitFriKey[2])
		local f_val = f_tabLitFriKey[1]
		f_tabLitFriData[f_key] 	= f_val
	end

	m_tabFormFriData = f_tabLitFriData
end

local function showLitFriSelect( heroInfo, plitHeroPos )
	if heroInfo then
		AudioHelper.playInfoEffect()
		local tArgs={selectedHeroes=heroInfo, externHero = m_tabFormLitFriData}

		require "script/module/partner/PartnerInfoCtrl"
        local pHeroValue = heroInfo --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.id ,strengthenLevel = pHeroValue.sLevel ,transLevel = pHeroValue.evolve_level,heroValue = pHeroValue }
        local tArgs = {}
        tArgs.heroInfo = heroInfo
        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
        LayerManager.addLayoutNoScale(layer)
        
	else
		AudioHelper.playCommonEffect()
		require "script/module/formation/FriendSelectCtrl"
		local battleCompanModule = FriendSelectCtrl.create(2, plitHeroPos, 0)
		LayerManager.addLayoutNoScale(battleCompanModule, m_widgetBg)
		UIHelper.changepPaomao(battleCompanModule) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
	end
end

local function getLitHeroInfo( litHeroOpenPos )
	local arrExtra = m_tabFormLitFriData.littleFriend
	if arrExtra then
		for k,v in pairs (arrExtra) do
			extraTab[tostring(v.position)] = v
		end
		-- for i = 1,litHeroOpenPos do
		-- 	extraTab[tostring(i - 1)] = {hid = 0}
		-- 	for k,v in pairs (arrExtra) do
		-- 		if( tonumber(v.position) == i - 1) then
		-- 			extraTab[tostring(v.position)] = v
		-- 		end
		-- 	end
		-- end
	end
end

local function hideAllHero( ... )
	local mlsv = m_getWidget(m_formWidget, "LSV_LITTLEF_MAIN")
	mlsv:setVisible(false)
	-- for i=1,8 do
	-- 	local f_litFriImg	= m_getWidget(m_formWidget, "IMG_LITTLE_NAME" .. i)
	-- 	f_litFriImg:setVisible(false)
	-- end
end

--如果成功打开，该值会返回ok

local function openExtraCallback( cbFlag, dictData, bRet )
	LayerManager.removeLayout()
	if bRet then
		local retStr = dictData.ret
		if (retStr == "ok") then
			ShowNotice.showShellInfo(m_i18n[1239])
			local pExtraData = DataCache.getExtra()
			pExtraData[tonumber(openPos)] = "0"
			DataCache.setExtra(pExtraData)
			extraPosArr = pExtraData
			-- refreshView(extraPosArr, litHeroPos)
			refreshView(extraPosArr)
		else
			ShowNotice.showShellInfo(m_i18n[1240])
		end
	end
end

local function openLitPosByLvOrVip( pos, neednum, ownnum, needLv, needVip )
	require "script/model/user/UserModel"
    local userLevel = UserModel.getHeroLevel()
    local vipLevel	= UserModel.getVipLevel()
    if ((tonumber(userLevel) < tonumber(needLv)) and (tonumber(vipLevel) < tonumber(needVip))) then
    	--等级且VIP等级都不足
		ShowNotice.showShellInfo(m_i18n[1241])
    else
    	if tonumber(ownnum) < tonumber(neednum) then
    		--物品不足
			ShowNotice.showShellInfo(m_i18n[1242])
    	else
    		--正式请求
    		openPos = pos

    -- 		local pTest = true
    -- 		if(pTest) then
    -- 			ShowNotice.showShellInfo(m_i18n[1239])
				-- local pExtraData = DataCache.getExtra()
				-- pExtraData[tonumber(openPos)] = "0"
				-- DataCache.setExtra(pExtraData)
				-- extraPosArr = pExtraData
				-- refreshView(extraPosArr)
    -- 			return
    -- 		end
			local params = CCArray:createWithObject(CCString:create(tostring(pos - 1)))
			RequestCenter.formation_openExtra( openExtraCallback, params)
    	end
    end
end

local function showOpenLittleAlert( pos, openLv )
	widgetlittleOpen = g_fnLoadUI(littleOpenFile)

	local formDBInfo 	= DB_Formation.getDataById(1)
	local consumeInfo 	= formDBInfo.consume_item		--开启消耗的物品及数量
	local openLvInfo 	= formDBInfo.consume_needlv		--开启需要的等级
	local openVipInfo 	= formDBInfo.consume_needvip	--开启需要的VIP等级（和等级比较只需要满足一个就行了）
	local itemArr 		= lua_string_split(consumeInfo, ",")
	local lvArr			= lua_string_split(openLvInfo, ",")
	local vipArr 		= lua_string_split(openVipInfo, ",")

	local needItem	= lua_string_split(itemArr[pos], "|")
	local needLv 	= lvArr[pos]
	local needVip 	= vipArr[pos]
	local needItemid	= needItem[1]
	local neednum		= needItem[2]
	local ownnum 		= ItemUtil.getNumInBagByTid(needItemid)

	local labupnormal 	= m_getWidget(widgetlittleOpen, "TFD_ORIGIN")	--原始开启等级
	local labLvVipOpen	= m_getWidget(widgetlittleOpen, "TFD_DES")		--道具开启等级或者vip等级
	local labOwnNum 	= m_getWidget(widgetlittleOpen, "TFD_OWN")		--拥有的道具量
	local labNeedNum	= m_getWidget(widgetlittleOpen, "TFD_NEED")		--开启位置需要的道具数量

	local btnOpenPos	= m_getWidget(widgetlittleOpen, "BTN_CONFIRM")	--开启位置按钮
	UIHelper.titleShadow(btnOpenPos, m_i18n[1324]..m_i18n[4007])
	local btnGetItem 	= m_getWidget(widgetlittleOpen, "BTN_GAIN")		--获取物品
	local btnCloseItem	= m_getWidget(widgetlittleOpen, "BTN_CLOSE")

	if tonumber(openLv) >= 999 then
		local imgLitFir = m_getWidget(widgetlittleOpen, "img_title_2")
		imgLitFir:setVisible(false)
		labupnormal:setText("")
	else
		local pppstr = string.format(m_i18n[1243],tostring(openLv))
		labupnormal:setText(pppstr)
	end

	local pppstr
	if tonumber(needLv) >= 999 and tonumber(needVip) < 999 then
		pppstr = string.format(m_i18n[1244],"VIP"..needVip)
		-- labLvVipOpen:setText("船长达到".."VIP".. needVip .."即可使用“船员证”提前开启哦~")
	elseif tonumber(needVip) >= 999 and tonumber(needLv) < 999 then
		pppstr = string.format(m_i18n[1244],needLv..m_i18n[3643])
		-- labLvVipOpen:setText("船长达到".. needLv .."级" .. "即可使用“船员证”提前开启哦~")
	else
		pppstr = string.format(m_i18n[1244],needLv..m_i18n[3643]..m_i18n[1222]..m_i18n[1223]..needVip)
		-- labLvVipOpen:setText("船长达到".. needLv .."级或VIP".. needVip .."即可使用“船员证”提前开启哦~")
	end
	labLvVipOpen:setText(pppstr)

	labOwnNum:setText("".. ownnum)
	labNeedNum:setText("".. neednum)
	if tonumber(ownnum) > tonumber(neednum) then
		labOwnNum:setColor(ccc3(36 ,220 ,9  ))
	else
		labOwnNum:setColor(ccc3(249 ,18  ,0  ))
	end

	btnOpenPos:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
							--判断数量，并且确定是否发送请求
							openLitPosByLvOrVip(pos, neednum, ownnum, needLv, needVip)
						end
					end)
	btnGetItem:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							--获取物品的按钮
							AudioHelper.playCommonEffect()
							ShowNotice.showShellInfo(m_i18n[1347])
						end
					end)
	btnCloseItem:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							--获取物品的按钮
							AudioHelper.playBackEffect()
							LayerManager.removeLayout()
						end
					end)

	LayerManager.addLayout(widgetlittleOpen)
end

local function unLockLitFriend( pos, openLv )
	-- if tonumber(openLv) > 999 then
	-- 	ShowNotice.showShellInfo("请先解锁前面的小伙伴位置!")
	-- else
		if tonumber(pos) > tonumber(openPos) then
			ShowNotice.showShellInfo(m_i18n[1245])
		else
			showOpenLittleAlert(pos, openLv)
		end
	-- end

	-- logger:debug("unlock pos:".. pos)

	-- ItemUtil.getNumInBagByTid(60318)
	--先检查物品.
end

local function fnGetItem(cell , time)
    local pItem = m_getWidget(cell,"LAY_CELL1")
    if(tonumber(time) == 1) then
        return pItem
    end
    local pItem2 = m_getWidget(cell,"LAY_CELL" .. time)
    pItem2:addChild(pItem:clone())
    return pItem2
end


local function updateArrow( ... )
	if(not m_LSV_View) then
		return
	end
	-- 检测是不是滑动到底部 和 顶部
	local offset = m_LSV_View:getContentOffset()
	local lisvSizeH = m_LSV_View:getSize().height
	local lisvContainerH = m_LSV_View:getInnerContainerSize().height 
	-- logger:debug("offset = " .. offset)
	-- logger:debug("lisvSizeH = " .. lisvSizeH)
	-- logger:debug("lisvContainerH = " .. lisvContainerH)

	if (offset - lisvSizeH < 1) then
		LAY_ARROW_UP:setVisible(false)
	else
		LAY_ARROW_UP:setVisible(true)
	end

	if(offset- lisvContainerH <0) then
		LAY_ARROW_DOWN:setVisible(true)
	else
		LAY_ARROW_DOWN:setVisible(false)
	end
end

--刷新小伙伴界面
-- function refreshView( extraArr, litHeroOpenPos)
function refreshView( extraArr)

	-- removeAllLittleFInfo()
	local unLock = true			--放置点击解锁的地方
	local pExtraArr = extraArr or {}
	-- hideAllHero()
	if showSquadTye == SHOW_THEM_SQUAD then
		-- getLitHeroInfo(litHeroOpenPos)
		getLitHeroInfo()
	end
	--当前的小伙伴的位置.
	local litFriNumber = table.count(m_tabFormFriData)
	-- logger:debug("wm----extraTab : %s", tostring(litFriNumber))
	-- logger:debug(extraTab)
	-- logger:debug(pExtraArr)
	local mHeroLv = UserModel.getHeroLevel() 
	local nIdx = 0
	local time = 1
	m_LSV_View:removeAllItems()
	if(litFriNumber > 8) then
		m_LSV_View:setTouchEnabled(true)
		GlobalScheduler.addCallback(m_UpdateName,updateArrow)
	else
		m_LSV_View:setTouchEnabled(false)
		GlobalScheduler.removeCallback(m_UpdateName)
	end
	for i = 1,litFriNumber do
		-- logger:debug("wm----litFriNumber : " .. i)
		if(nIdx ~= math.ceil(i/4)) then
        	m_LSV_View:pushBackDefaultItem()
      	end
      	nIdx = i/4
      	nIdx = math.ceil(nIdx) 
    	local cell = m_LSV_View:getItem(nIdx-1)  -- cell 索引从 0 
    	if(time > 4) then
         	time = 1
      	end
    	local item = fnGetItem(cell , time)
    	time = time + 1


		local nature = false

		local f_litFriBtn 	= m_getWidget(item, "BTN_XIAOHUOBAN_1")
		f_litFriBtn:removeChildByTag(100,true)
		local f_litFriName 	= m_getWidget(item, "TFD_LITTLEF_NAME1")
		local f_litFriImg	= m_getWidget(item, "IMG_LITTLE_NAME1")
		f_litFriImg:setVisible(false)
		local f_litAddImage = m_getWidget(item, "IMG_ADD1")
		local f_litLockIcon = m_getWidget(item, "IMG_HEAD_BG_1")
		f_litLockIcon:setVisible(true)
		local f_litFriLevel = m_getWidget(item, "LABN_TRANSFER1")
		local f_litOpenLvl 	= m_getWidget(item, "TFD_SMALL_JIKAIFANG1")
		local f_litImgLock 	= m_getWidget(item, "IMG_CLICK1")
		f_litImgLock:setVisible(true)
		local f_litFreBgImg = m_getWidget(item, "IMG_HEAD_BG_1")

		-- logger:debug("extraTab:" ..i)
		-- logger:debug(extraTab)
		local herohid
		if showSquadTye     == SHOW_SELF_SQUAD then
			herohid = tonumber(pExtraArr[i])
		elseif showSquadTye == SHOW_THEM_SQUAD then
			local pInfo = extraTab[tostring(i - 1)]
			herohid = pInfo and tonumber(extraTab[tostring(i - 1)].hid) or 0
		end

		local litheroHead
		local litheroLvl
		local litheroName
		local heroExit
		local heroNameColor

		local openLv = tonumber(m_tabFormFriData[tostring(i)])
		if(herohid < 0 and mHeroLv >= openLv ) then
			herohid = 0
		end

		if(tonumber(herohid) >= 0) then
			f_litImgLock:setVisible(false)
			if (tonumber(herohid) > 0) then
				local heroInfo
				if showSquadTye     == SHOW_SELF_SQUAD then
					heroInfo  = getHeroInfoByHid(herohid)
					litheroLvl = heroInfo.evolve_level
				elseif showSquadTye == SHOW_THEM_SQUAD then
					heroInfo  = getHeroInfoByHid(i)
					litheroLvl = 0
				end

				local herotid   = heroInfo.htid
				heroExit        = true
				local litheroInfo   = DB_Heroes.getDataById(herotid)
				
				heroNameColor       = HeroPublicUtil.getDarkColorByStarLv(litheroInfo.star_lv)
				litheroHead = HeroUtil.createHeroIconBtnByHtid(herotid , nil , function(sender, eventType)
					if(eventType == TOUCH_EVENT_ENDED) then
						m_mainFMT.fnSetLinkNumberTrue()
						showLitFriSelect(heroInfo, i)
					end
				end)
				litheroName = litheroInfo.name
			else
				heroExit = false
				litheroLvl = 0
				litheroName = ""
				litheroHead = Button:create()
				--对方阵容不需要显示加号-----------------
				litheroHead:loadTextureNormal("images/base/potential/border.png")
				litheroHead:loadTexturePressed("images/base/potential/border.png")
				if showSquadTye == SHOW_SELF_SQUAD then

					local AddSprite = UIHelper.fadeInAndOutImage("ui/add_blue.png")
					AddSprite:setPosition(ccp(0, 0))
					litheroHead:addNode(AddSprite)
					litheroHead:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							m_mainFMT.fnSetLinkNumberTrue()
							showLitFriSelect(nil, i)
						end
					end)
				end
			end
			if heroExit then
				f_litFriName:setColor(heroNameColor)
				f_litFriImg:setVisible(true)
				UIHelper.labelEffect(f_litFriName)
			else
				f_litFriImg:setVisible(false)
			end

			if litheroLvl == 0 then
				f_litAddImage:setVisible(false)
				f_litFriLevel:setStringValue(tostring(""))
			else
				f_litAddImage:setVisible(true)
				f_litFriLevel:setStringValue(tostring(litheroLvl))
			end

			f_litFreBgImg:setVisible(false)
			f_litFriName:setText(tostring(litheroName))
			litheroHead:setTag(100)
			f_litFriBtn:addChild(litheroHead)
		elseif(tonumber(herohid) == -1) then
			local f_labLitFreOpen = m_getWidget(item, "TFD_JIBAN_OPEN_1")
			
			if unLock then 			--是否显示点击解锁需要根据等级和vip等级来确定
				openPos = i 		--当前显示点击解锁的位置
				unLock = false
				
				local formDBInfo 	= DB_Formation.getDataById(1)
				local openLvInfo 	= formDBInfo.consume_needlv		--开启需要的等级
				local openVipInfo 	= formDBInfo.consume_needvip	--开启需要的VIP等级（和等级比较只需要满足一个就行了）
				local lvArr			= lua_string_split(openLvInfo, ",")
				local vipArr 		= lua_string_split(openVipInfo, ",")
				local needLv 	= lvArr[i]
				local needVip 	= vipArr[i]

				if tonumber(needLv) >= 999 and tonumber(needVip) >= 999 then 			--同时需要999级，说明是无法用道具开启了。
					f_litImgLock:setVisible(false)
					if (tonumber(openLv) < 999) then
						nature = true
					end
				else
					f_litImgLock:setVisible(true)
					f_labLitFreOpen:setVisible(false)
					f_litLockIcon:setVisible(false)
					f_litOpenLvl:setVisible(false)
				end
			else
				f_litImgLock:setVisible(false)
			end
			
			if tonumber(openLv) >= 999 then
				f_labLitFreOpen:setVisible(false)
				f_litOpenLvl:setVisible(false)
			else
				f_labLitFreOpen:setVisible(true)
				f_litOpenLvl:setVisible(true)
				f_labLitFreOpen:setText(tostring(openLv))
				UIHelper.labelEffect(f_litOpenLvl)
				UIHelper.labelEffect(f_labLitFreOpen)
			end
			--小伙伴的锁的位置添加事件
			f_litFriBtn:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
							if nature then
								ShowNotice.showShellInfo(openLv .. m_i18n[1246])
							else
								m_mainFMT.fnSetLinkNumberTrue()
								unLockLitFriend(i, openLv)
							end
						end
					end)
			f_litFriName:setText("")
			f_litAddImage:setVisible(false)
			f_litFriLevel:setStringValue("")
		end
	end
end

function setShowRecomFalse( ... )
	showRecomFri = false
end

--关闭推荐小伙伴页面
function closeRecomFri( ... )
	if showRecomFri then
		LayerManager.removeLayout()
	end
	if(mLayMain) then
		mLayMain:setVisible(true)
	end
	if showSquadTye == SHOW_THEM_SQUAD then
		local recomLitFri = m_getWidget(m_formWidget, "BTN_RECOMMAND")
		local btnFormLitFri = m_getWidget(m_formWidget, "BTN_JIBAN_INFORMATION")
		local btnPartLitFri = m_getWidget(m_formWidget, "BTN_PARTNER")
		--设置推荐小伙伴在查看阵容中不显示
		if showSquadTye == SHOW_THEM_SQUAD then
			recomLitFri:setEnabled(false)
			recomLitFri:setVisible(false)
			btnFormLitFri:setVisible(false)
			btnFormLitFri:setEnabled(false)
			btnPartLitFri:setEnabled(false)
			btnPartLitFri:setVisible(false)
		end
	end
end

local function showRecommandFri( ... )
	local extra = extraPosArr[1]
	if tonumber(extra) >= 0 then
		require "script/module/formation/RecomLitFriSelect"
		local recomFriView = RecomLitFriSelect.create(mLayMain)
		LayerManager.addLayoutNoScale(recomFriView, m_formWidget)
		showRecomFri = true
	else
		ShowNotice.showShellInfo(m_i18n[1247])
	end
end
--界面适配
local function fitFrameScale( ... )
	local imgBack = m_getWidget(m_formWidget ,"IMG_BG")
	imgBack:setScale(g_fScaleX)
end

-- function create( widget, extraArr, extraData, litHeroOpenPos, widgetBg)
function create( widget, extraArr, extraData, widgetBg)
	extraTab = {}
	if extraData then
		m_tabFormLitFriData = extraData
		showSquadTye = SHOW_THEM_SQUAD
	else
		m_tabFormLitFriData = nil
		showSquadTye = SHOW_SELF_SQUAD
	end
	m_widgetBg 	= widgetBg
	m_formWidget 	= widget
	
	fitFrameScale()
   
	mLayMain = m_getWidget(m_formWidget, "LAY_XIAOHUOBAN_MAIN")
	mLayMain:setTouchEnabled(true)
	mLayMain:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							local plength = sender:getTouchEndPos().x - sender:getTouchStartPos().x
							if(plength > g_winSize.width*0.25) then
								m_mainFM.scrollMainPage(0)
							end
						end
					end)
	local recomLitFri = m_getWidget(m_formWidget, "BTN_RECOMMAND")
	recomLitFri:addTouchEventListener(function(sender, eventType)
						if(eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
							showRecommandFri( )
						end
					end)
	LAY_ARROW_UP = m_getWidget(m_formWidget, "LAY_ARROW_UP")
	LAY_ARROW_UP:setVisible(false)
	LAY_ARROW_DOWN = m_getWidget(m_formWidget, "LAY_ARROW_DOWN")
	LAY_ARROW_DOWN:setVisible(false)

	m_LSV_View = m_getWidget(m_formWidget,"LSV_LITTLEF_MAIN") --listview
    UIHelper.initListView(m_LSV_View)

    local IMG_ARROW_UP = m_getWidget(m_formWidget, "IMG_ARROW_UP")
    IMG_ARROW_UP:setVisible(false)
    local arrowUp = UIHelper.fadeInAndOutImage("ui/2X2.png")
    arrowUp:setPosition(IMG_ARROW_UP:getPosition())
    LAY_ARROW_UP:addNode(arrowUp)

  
	local IMG_ARROW_DOWN = m_getWidget(m_formWidget, "IMG_ARROW_DOWN")
	IMG_ARROW_DOWN:setVisible(false)
	local arrowBottom = UIHelper.fadeInAndOutImage("ui/2X2.png")
	arrowBottom:setPosition(IMG_ARROW_DOWN:getPosition())
	LAY_ARROW_DOWN:addNode(arrowBottom)


	loadFromLitFriData()
	-- refreshView(extraArr, tonumber(litHeroOpenPos))
	refreshView(extraArr)
	-- litHeroPos = litHeroOpenPos
	extraPosArr = extraArr

	showRecomFri = false

	UIHelper.registExitAndEnterCall(mLayMain, function ( ... )
		GlobalScheduler.removeCallback(m_UpdateName)
		mLayMain = nil
		m_LSV_View = nil
	end)
end
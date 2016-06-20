-- FileName: MainRecoveryCtrl.lua
-- Author:zhangjunwu
-- Date: 2015-09-21
-- Purpose: 回收模块主控制器
module("MainRecoveryCtrl", package.seeall)

require "script/module/resolve/MainRecoveryView"
require "script/module/resolve/RecoverPreShowCtrl"

-- UI控件引用变量 --

-- 模块局部变量 --
local m_nType = 1
local m_nIsShow = 1
local m_i18nString = gi18nString
local popLayer = nil
local tbTabDataLoaded = {false,false,false,false,false,false,false}

local m_tbRebornHeroInfo = nil

local function init()
	m_tbRebornHeroInfo = nil
	ResolveModel.resetAutoAddSelectIndex()
	m_nType = 1
	m_nIsShow = 1
	popLayer = nil
	tbTabDataLoaded = {false,false,false,false,false,false,false}
end

function setShowState(nShow)
	m_nIsShow = nShow
end

function getPlusSprite()
	local armature4 = UIHelper.createArmatureNode({
		filePath = "images/effect/hero_transfer/qh2_guangzheng/qh2_guangzheng.ExportJson",
		animationName = "guangzheng_xiao_renwu" ,
		loop = -1,
	})
	return armature4
end

function destroy(...)
	package.loaded["MainRecoveryCtrl"] = nil
end

function moduleName()
	return "MainRecoveryCtrl"
end

function enterCall( ... )
	logger:debug("enter call")
end

function fnOpenListView(  )
	require "script/module/resolve/ResolveSelectCtrl"
	local tbListData = ResolveModel.getAllAddDataByType()

	if(#tbListData == 0 ) then
		ShowNotice.showShellInfo(ResolveModel.tbNoItemTips[m_nType])
		return 
	end
	--排序列表数据
	ResolveModel.sortListData()

	local tbSelectedInfo = ResolveModel.getSelectedData()
	local tbTemp = {}
	table.hcopy(tbSelectedInfo,tbTemp)
	logger:debug(tbTemp)
	local m_laySelectView = ResolveSelectCtrl.create(tbListData,m_nType,tbTemp)
	UIHelper.registExitAndEnterCall(m_laySelectView,function (  )
			LayerManager.resetPaomadeng()
			ResolveSelectCtrl.destruct()
	end,enterCall)

	LayerManager.addLayoutNoScale(m_laySelectView)
	m_laySelectView:setBackGroundColorOpacity(0)
	LayerManager.setPaomadeng(m_laySelectView, 100)
end


local function fnShopReturnByType( nType )
	--添加声音
	AudioHelper.playCommonEffect()
	local curModuleName = LayerManager.curModuleName()
	DropUtil.getReturn(curModuleName)
	goTabByType(nType)
	MainRecoveryView.setValueByType()
end

--点击tab的时候判断是否需要读取数据
function fnGetDataBy( _index )
	local bLoad = tbTabDataLoaded[_index]
		logger:debug({bLoad = bLoad})
	if(bLoad == false) then
		if(_index == ResolveTabType.E_Shadow) then
			ResolveModel.getFilterHeroList()
		elseif(_index == ResolveTabType.E_Equip) then
			ResolveModel.getFiltersForEquips()
		elseif(_index == ResolveTabType.E_Treas) then
			ResolveModel.getFiltersForTreas()
		elseif(_index == ResolveTabType.E_SPTreas) then
			ResolveModel.getFiltersForSPTreas()
		elseif(_index == ResolveTabType.E_SuperShip) then
			logger:debug("	ResolveModel.getFiltersForShipInfo()")
			ResolveModel.getFiltersForShipInfo()
		elseif(_index == ResolveTabType.E_Parnter) then
			ResolveModel.getFilterPartnerList()
		elseif(_index == ResolveTabType.E_Reborn) then
			ResolveModel.getFilterPartnerList()
		end
		tbTabDataLoaded[_index] = true
	end
	logger:debug({tbTabDataLoaded = tbTabDataLoaded})
end

function create(ntype )
	init()
	local tbOnTouch = {}
	ResolveModel.setRecoveryType(ntype or 1)
	m_nType = ResolveModel.getRecoveryType()
	-- 神秘商店按钮
	tbOnTouch.onShop = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/guide/GuideCtrl"
			GuideCtrl.removeGuideView()
			require "script/module/wonderfulActivity/MainWonderfulActCtrl"
			
			if(m_nType == ResolveModel.T_Parnter or m_nType == ResolveModel.T_Shadow or m_nType == ResolveModel.T_RebornParnter or m_nType == ResolveModel.T_Treasure) then
				local function treaShopReturn( sender,eventType )
					if eventType == TOUCH_EVENT_ENDED then
						fnShopReturnByType(m_nType)
						-- MainRecoveryView.setValueByType()
						ResolveModel.getFilterPartnerList()
					end
				end 
				local funcall = treaShopReturn
				require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleCtrl"
				MysteryCastleCtrl.create(funcall, 1)
			elseif(m_nType == ResolveModel.T_Equip ) then
					--go to equip shop
					local function equipShopReturn( sender,eventType )
						fnShopReturnByType(ResolveModel.T_Equip)
						-- ResolveModel.getFiltersForEquips()
						-- MainRecoveryView.setValueByType()
					end 
					require "script/module/impelDown/ImpelShop/ImpelShopCtrl"
					local Arg = {}
					Arg.from = equipShopReturn
					Arg.cache = true
					logger:debug("getSwitchOpenState")
					if (SwitchModel.getSwitchOpenState(ksSwitchImpelDown,true)) then
						ImpelShopCtrl.create(Arg)
					end
			elseif(m_nType == ResolveModel.T_SPShipItem)then
					--go to super ship
					require "script/module/ship/ShipMainCtrl"
					local function equipShopReturn( sender,eventType )
						fnShopReturnByType(ResolveModel.T_SPShipItem)
						-- MainRecoveryView.setValueByType()
					end 
					local Arg = {}
					Arg.from = equipShopReturn
					Arg.cache = true
					ShipMainCtrl.create(nil, "resolve",Arg)
			elseif(m_nType == ResolveModel.T_SPTreasure )then
					--go to special treasure shop
					if( not SwitchModel.getSwitchOpenState(ksSwitchSpeShop,true)) then
						return
					end
					local function treaShopReturn( sender,eventType )
						if eventType == TOUCH_EVENT_ENDED then
							fnShopReturnByType(m_nType)
							ResolveModel.getFiltersForSPTreas()
							ResolveModel.getFiltersForTreas()
							-- MainRecoveryView.setValueByType()
						end
					end 
					require "script/module/treaShop/TreaShopCtrl"
					local funcall = treaShopReturn
					TreaShopCtrl.create(nil,funcall,1)
			end
		end
	end
	-- tab点击按钮
	tbOnTouch.onTabBtn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local indexTab = sender:getTag()

			if(indexTab == ResolveModel.T_SPShipItem) then
				if (SwitchModel.getSwitchOpenState(ksSwitchMainShip,true) == false) then
					return
				end
			elseif(indexTab == ResolveModel.T_RebornParnter)then
				if (SwitchModel.getSwitchOpenState(ksSwitchReborn,true) == false) then
					return
				end
			end


			MainRecoveryView.setTabBtnStats(indexTab)
			MainRecoveryView.setShopBtnState(indexTab)
			m_nType = indexTab
			MainRecoveryView.setAddBtnAuto(true)
			ResolveModel.resetAutoAddSelectIndex()
			MainRecoveryView.createSelectedIcons()
			logger:debug(indexTab)
			fnGetDataBy(indexTab)
		end
	end	
	-- 说明点击按钮
	tbOnTouch.onExplain = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playEffect("audio/effect/renwu.mp3")
			local layIntroduce = g_fnLoadUI("ui/help_decompose.json")
			LayerManager.addLayout(layIntroduce)

			local i18nDesc = g_fnGetWidgetByName(layIntroduce, "tfd_desc")
			i18nDesc:setText(ResolveModel.tbHelpTips[m_nType])

			local btnClose = g_fnGetWidgetByName(layIntroduce,"BTN_CLOSE")
			btnClose:addTouchEventListener(function ( sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()

					LayerManager.removeLayout()
				end
			end	)

		end
	end	

	--换一组点击按钮
	tbOnTouch.onChange = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			ResolveModel.addItemData()
			MainRecoveryView.createSelectedIcons()
		end
	end	
	-- 自动添加按钮点击
	tbOnTouch.onAutoAdd = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local tbAutoData = ResolveModel.getAutoAddDataByType()
			local tbAllData = ResolveModel.getAllAddDataByType()
			logger:debug(m_nType)
			if(#tbAllData == 0 ) then
				ShowNotice.showShellInfo(ResolveModel.tbNoItemTips[m_nType])
				return 
			end

			if(#tbAutoData == 0 ) then
				ShowNotice.showShellInfo(ResolveModel.tbAddAutoTips[m_nType])
			else
				ResolveModel.addItemData()
				MainRecoveryView.createSelectedIcons()
				MainRecoveryView.setAddBtnAuto(false)
			end
		end
	end	
	-- 回收点击按钮
	tbOnTouch.onRecovery = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("回收按钮点击")
			m_nIsShow = 1
			beginToResolve()
		end
	end	
	-- 重生点击按钮
	tbOnTouch.onReborn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("重生点击按钮")
			m_nIsShow = 1
			beginToResolve()
		end
	end	
	tbOnTouch.onOpenList = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("onOpenList")
			AudioHelper.playCommonEffect()
			fnOpenListView()
		end
	end
	local layMain = MainRecoveryView.create( tbOnTouch )
	return layMain
end

function goTabByType(nTabIndex)
	m_nType = nTabIndex
	MainRecoveryView.setTabBtnStats(nTabIndex)
	MainRecoveryView.setShopBtnState(nTabIndex)
	ResolveModel.setRecoveryType(nTabIndex)
	ResolveModel.resetAutoAddSelectIndex()
	MainRecoveryView.scrollPassGetRow(m_nType)
	MainRecoveryView.createSelectedIcons()
end

--bAdd 是否加到玩家的属性值里
local function getRewardData( dictData ,bRet,bAdd)
	local tbRewardItems = {}

	--展示面板需要的数据
	local tbItems = {}
	local tbRowItems = {}
	local nCount  = 0
	if bRet then

		--如果是武将重生，那么预览里则需要显示武将
		if(m_nType == ResolveModel.T_RebornParnter) then
			local tbHeroInfo =m_tbRebornHeroInfo
			local rebornHeroInfo = m_tbRebornHeroInfo
			local heroTid  = tonumber(rebornHeroInfo.htid )

			local dbHeroBreak = DB_Hero_break.Hero_break
			-- logger:debug(heroTid)
			for k,v in pairs(dbHeroBreak) do 
				-- logger:debug(v[2])
				if(v[2] == heroTid) then
					heroTid = v[1]
					break
				end
			end
			-- logger:debug(heroTid)
			local heroInfo = {}
			local tbHeroInfo1 = nil
			heroInfo.icon ,tbHeroInfo1 = HeroUtil.createHeroIconBtnByHtid(heroTid)
			heroInfo.name = tbHeroInfo1.name
			heroInfo.quality = tbHeroInfo1.potential
			table.insert( tbRowItems, heroInfo )
			table.insert( tbRewardItems, heroInfo)
		end

		if(dictData.ret.silver) then
			local silverInfo = {}
			silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
			silverInfo.name = m_i18nString(1520)
			silverInfo.quality = 1
			table.insert( tbRowItems, silverInfo )
			table.insert( tbRewardItems, silverInfo)

			if(bAdd) then
				UserModel.addSilverNumber(dictData.ret.silver)
			end
		end
		if(dictData.ret.awakeRime) then
			local awakeRimeInfo = {}
			awakeRimeInfo.icon = ItemUtil.getEquipAwakeIconByNum(dictData.ret.awakeRime)
			awakeRimeInfo.name = m_i18nString(7417)
			awakeRimeInfo.quality = 1
			table.insert( tbRowItems, awakeRimeInfo )
			table.insert( tbRewardItems, awakeRimeInfo)

			if(bAdd) then
				UserModel.addAwakeRimeNum(dictData.ret.awakeRime)
			end
		end

		if(dictData.ret.jewel) then
			local jewelInfo = {}
			jewelInfo.icon = ItemUtil.getJewelIconByNum(dictData.ret.jewel)
			jewelInfo.name = m_i18nString(2082)
			jewelInfo.quality = 5
			table.insert( tbRowItems, jewelInfo )
			table.insert( tbRewardItems, jewelInfo )

			if(bAdd) then
				UserModel.addJewelNum(dictData.ret.jewel)
			end
		end
		if(dictData.ret.rime) then
			local rimeInfo = {}
			rimeInfo.icon = ItemUtil.getRimeIconByNum(dictData.ret.rime)
			rimeInfo.name = m_i18nString(6921)
			rimeInfo.quality = 5
			table.insert( tbRowItems, rimeInfo )
			table.insert( tbRewardItems, rimeInfo )

			if(bAdd) then
				UserModel.addRimeNum(dictData.ret.rime)
			end
		end

		if(dictData.ret.prison) then
			local prisonInfo = {}
			prisonInfo.icon = ItemUtil.getPrisonGoldIconByNum(dictData.ret.prison)
			prisonInfo.name = m_i18nString(7032)
			prisonInfo.quality = 5
			table.insert( tbRowItems, prisonInfo )
			table.insert( tbRewardItems, prisonInfo )
			if(bAdd) then
				UserModel.addImpelDownNum(dictData.ret.prison)
			end	
		end
		
		local treasInfo = dictData.ret.treasFrag or {}
		for k,v in pairs(treasInfo) do
			local itemData = {}
			local itemDesc = {}
			itemData.icon ,itemDesc= ItemUtil.createBtnByTemplateIdAndNumber(k,tonumber(v))
			itemData.name = itemDesc.name
			itemData.quality = itemDesc.quality
			if(#tbRowItems == 4) then
				table.insert( tbItems, tbRowItems )
				tbRowItems = {}
			end
			logger:debug(itemData)
			table.insert( tbRowItems, itemData )
			table.insert( tbRewardItems, itemData )
		end



		local itemInfo = dictData.ret.item or {}
		for k,v in pairs(itemInfo) do
			local itemData = {}
			local itemDesc = {}
			itemData.icon ,itemDesc= ItemUtil.createBtnByTemplateIdAndNumber(k,tonumber(v))
			itemData.name = itemDesc.name
			itemData.quality = itemDesc.quality
			if(#tbRowItems == 4) then
				table.insert( tbItems, tbRowItems )
				tbRowItems = {}
			end
			logger:debug(itemData)
			table.insert( tbRowItems, itemData )
			table.insert( tbRewardItems, itemData )
		end
		logger:debug(tbRowItems)
		if(#tbRowItems <= 4) then
			table.insert( tbItems, tbRowItems )
			tbRowItems = {}
		end
	end
	return tbRewardItems,tbItems
end

--炼化后端返回的回调
function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	--重生需要显示伙伴本体，所以暂时缓冲一下需要重生的伙伴的信息 
	if(m_nType ==ResolveModel.T_RebornParnter)then
		m_tbRebornHeroInfo = {}
		--更新金币
		local tbHeroInfo = ResolveModel.getSelectedData()
		m_tbRebornHeroInfo = tbHeroInfo[1]
	end

	--展示面板需要的数据
	if(m_nIsShow == 1) then
		local tbRewardInfo , tbItems = getRewardData(dictData,bRet)
		logger:debug(tbRewardInfo)
		logger:debug(tbItems)
		RecoverPreShowCtrl.create(tbItems,m_nType)
	else
		--加特效
		local function call()
			local tbRewardInfo , tbItems = getRewardData(dictData,bRet,true)
			local function showParnterNotice(  )
				LayerManager.removeLayout()
				if(m_nType == ResolveModel.T_Parnter) then
					ResolveModel.refreshPartnerData()
				end
				ResolveModel.resetAutoAddSelectIndex()
				-- MainRecoveryView.createSelectedIcons()
				MainRecoveryView.setValueByType()
				MainRecoveryView.setAddBtnAuto(true)

			end
			removeUnTouchLayer()
			local layReward = UIHelper.createGetRewardInfoDlg(m_i18nString(3341), tbRewardInfo ,showParnterNotice)
		end

		--如果回收的是专属宝物，并且专属宝物和武将关联了，则需要手动从背包里删除此专属宝物
		if(m_nType == ResolveModel.T_SPTreasure) then
			ResolveModel.removeSpTreasBy()
			--如果回收的所有专属宝物都在武将身上有关联，则没有背包推送，需要手动刷新数据
			if(ResolveModel.isAllTreasOnHeros() == true) then
				ResolveModel.refreshSPTreasData()
			end
		elseif(m_nType == ResolveModel.T_Parnter) then
			--如果回收的是伙伴，并且专属宝物和武将关联了，则需要手动从背包重置次宝物的属性
			ResolveModel.resetSpTreasBy()
		end

		addUnTouchLayer()
		--重生和回收的特效分开
		if(m_nType ==ResolveModel.T_RebornParnter)then
			--更新金币
			local tbHeroInfo = ResolveModel.getSelectedData()
			local rebornHeroInfo = tbHeroInfo[1]
			local rebirth_basegold = tonumber(rebornHeroInfo.rebirth_basegold )or 0
			local enLevel = tonumber(rebornHeroInfo.sTransferValue )or 0
			if(rebirth_basegold > 0)then
				UserModel.addGoldNumber(- (rebirth_basegold * (enLevel + 1)),true)
			end

			MainRecoveryView.showRebornAnimation(call)

		else
			MainRecoveryView.showAnimation(call)
		end
	end
end

--开始炼化
function beginToResolve()

	local arg = CCArray:create()
	-- arg:retain()
	local subArg = CCArray:create()
	-- subArg:retain()
	local tbSelected = ResolveModel.getSelectedData()
	if(#tbSelected == 0) then
		ShowNotice.showShellInfo(ResolveModel.tbNoRecoverItemTips[m_nType])
		return 
	end
	--和曾峥商量的结果是除了影子回收，其他的回收都要判断背包是否满了，而且是所有背包判断 2015-10-19 16：21

	--2015-10-29  伙伴：判断专属宝物背包、道具背包（优先弹出宝物背包的提示）
	-- 装备：判断道具背包  饰品：判断道具背包   宝物：判断道具背包 主船：判断道具背包

	if(m_nType == ResolveModel.T_Parnter) then
		if(ItemUtil.isSpecialTreasBagFull(true) == true or ItemUtil.isPropBagFull(true) == true) then
			return 
		end
	elseif(m_nType == ResolveModel.T_Equip or m_nType == ResolveModel.T_Treasure or m_nType == ResolveModel.T_SPTreasure) then
		if(ItemUtil.isPropBagFull(true) == true) then
			return 
		end
	elseif(m_nType == ResolveModel.T_RebornParnter) then


		local tbHeroInfo = ResolveModel.getSelectedData()
		local rebornHeroInfo = tbHeroInfo[1]
		local rebirth_basegold = tonumber(rebornHeroInfo.rebirth_basegold )or 0
		local enLevel = tonumber(rebornHeroInfo.sTransferValue )or 0
		if(rebirth_basegold > 0)then
			if(rebirth_basegold * (enLevel + 1) > UserModel.getGoldNumber()) then
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				return 
			end
		end


		if(ItemUtil.isSpecialTreasFragBagFull(true) == true or ItemUtil.isPropBagFull(true) == true) then
			return 
		end
	end
	for i = 1,#tbSelected do
		subArg:addObject(CCInteger:create(tbSelected[i].id))
	end
	arg:addObject(subArg)
	logger:debug(m_nIsShow)
	arg:addObject(CCInteger:create(m_nIsShow))

	if(m_nType == ResolveModel.T_Parnter) then
		RequestCenter.resolveHero(fnHandlerOfNetwork,arg)

	elseif(m_nType == ResolveModel.T_Shadow) then
		RequestCenter.resolveHeroFrag(fnHandlerOfNetwork,arg)

	elseif(m_nType == ResolveModel.T_Equip) then
		RequestCenter.resolveEquips(fnHandlerOfNetwork,arg)

	elseif(m_nType == ResolveModel.T_Treasure) then
		RequestCenter.resolveTreasures(fnHandlerOfNetwork,arg)

	elseif(m_nType == ResolveModel.T_SPShipItem) then
		RequestCenter.resolveShipItem(fnHandlerOfNetwork,arg)

	elseif(m_nType == ResolveModel.T_SPTreasure) then
		local hidArg = CCArray:create()
		for i = 1,#tbSelected do
			hidArg:addObject(CCInteger:create(tbSelected[i].equip_hid or 0))
		end
		arg:addObject(hidArg)
		RequestCenter.resolveExclusive(fnHandlerOfNetwork,arg)
	elseif(m_nType == ResolveModel.T_RebornParnter) then
		local hidArg = CCArray:create()
		logger:debug(tbSelected)
		hidArg:addObject(CCInteger:create(tbSelected[1].id))
		hidArg:addObject(CCInteger:create(m_nIsShow))
		RequestCenter.resolveRebornHero(fnHandlerOfNetwork,hidArg)
	end
	
	if(m_nIsShow == 0) then
		PreRequest.setBagDataChangedDelete(ResolveModel.bagDeleget)
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

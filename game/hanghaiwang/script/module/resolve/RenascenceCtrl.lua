-- FileName: RenascenceCtrl.lua
-- Author: menghao
-- Date: 2014-05-21
-- Purpose: 重生ctrl


module("RenascenceCtrl", package.seeall)


require "script/module/resolve/RenascenceView"
require "script/module/resolve/RenascenceChooseCtrl"


-- UI控件引用变量 --


-- 模块局部变量 --
local mi18n = gi18n

local m_selectedHeroId = nil
local m_selectedItemId = nil
local m_selectedTreaId = nil
local m_nGoldNeedNumber = nil


function changeID( heroInfo, equipInfo, treaInfo )
	m_selectedHeroId = heroInfo.id
	m_selectedItemId = equipInfo.id
	m_selectedTreaId = treaInfo.id

	if m_selectedHeroId then
		m_nGoldNeedNumber = heroInfo.goldNeed
		local heroSprite = HeroUtil.getHeroBodySpriteByHTID(heroInfo.tid)
		heroSprite:setScale(0.55)
		-- local btnIcon, dbHero = HeroUtil.createHeroIconBtnByHtid( heroInfo.tid, nil )
		RenascenceView.updateUIForAdd(heroSprite, m_nGoldNeedNumber, heroInfo.name, heroInfo.quality)
	end
	if m_selectedItemId then
		m_nGoldNeedNumber = equipInfo.goldNeed
		local btnIcon,tbItem = ItemUtil.createBtnByTemplateId( equipInfo.tid)
		local iconImgV  = CCSprite:create(tbItem.iconBigPath)

		RenascenceView.updateUIForAdd(iconImgV, m_nGoldNeedNumber, equipInfo.name, equipInfo.quality)
	end
	if m_selectedTreaId then
		m_nGoldNeedNumber = treaInfo.goldNeed

		local btnIcon,tbItem = ItemUtil.createBtnByTemplateId( treaInfo.tid)
		local iconImgV  = CCSprite:create(tbItem.iconBigPath)
		
		RenascenceView.updateUIForAdd(iconImgV, m_nGoldNeedNumber, treaInfo.name, treaInfo.quality)
	end
	if (not m_selectedHeroId) and (not m_selectedItemId) and (not m_selectedTreaId) then
		RenascenceView.removeUI()
	end
end


function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornHero" then
		UserModel.addGoldNumber(tonumber(-m_nGoldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))

		local pDB = HeroUtil.getHeroInfoByHid(m_selectedHeroId)
		logger:debug({wm___pDB = pDB})
		local beforeID
		if(pDB and pDB.localInfo) then
			beforeID = pDB.localInfo.before_id
		end
		logger:debug("wm----beforeID : %s",tostring(beforeID))
		if(beforeID) then
			HeroModel.setHtidByHid(m_selectedHeroId, beforeID)
		end

		HeroModel.setHeroLevelByHid(m_selectedHeroId,1)
		local heroInfo = HeroModel.getHeroByHid(m_selectedHeroId)
		HeroModel.addEvolveLevelByHid(m_selectedHeroId,-heroInfo.evolve_level)
		HeroModel.setHeroSoulByHid(m_selectedHeroId,0)

		--刷新伙伴列表数据   2014-10-27  zhangjunwu
		require "script/module/partner/MainPartner"
		MainPartner.replaceHeroDataByHid(m_selectedHeroId)

		if(MainPartner) then
			MainPartner.refreshYingZiListView()
		end

		m_selectedHeroId = nil

		local function afterAnimation( ... )
			local tbItem = {}

			local silverInfo = {}
			silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
			silverInfo.name = mi18n[1520]
			table.insert( tbItem, silverInfo )

			if dictData.ret.item then
				for k, v in pairs(dictData.ret.item) do
					local itemInfo = {}
					local dbItem = assert(ItemUtil.getItemById(tonumber(k)), "createBtnByTemplateId--not found id: " .. k)
					itemInfo.icon = ItemUtil.createBtnByItemAndNum(dbItem, v)
					itemInfo.name = dbItem.name
					table.insert(tbItem, itemInfo)
				end
			end

			if dictData.ret.hero then
				for k,v in pairs(dictData.ret.hero) do
					local heroInfo = {}
					heroInfo.icon = HeroUtil.createHeroIconBtnByHtid(v.htid)
					heroInfo.name = HeroUtil.getHeroLocalInfoByHtid(v.htid).name
					for i=1,v.num do
						table.insert(tbItem, heroInfo)
					end
				end
			end

			local layReward = UIHelper.createGetRewardInfoDlg( mi18n[2040], tbItem )
			LayerManager.addLayout(layReward)
		end
		RenascenceView.showAnimation(afterAnimation)
	end
end


function fnHandlerOfItemNetwork(cbFlag,dictData,bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornItem" then
		UserModel.addGoldNumber(tonumber(-m_nGoldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		DataCache.resetArmInfoByItemID(m_selectedItemId)



		--更新本地数据
		local isFreeEquip = DataCache.setArmEnchantLevelBy(m_selectedItemId, 0)
		if(isFreeEquip)then
			DataCache.setArmEnchantExpBy(m_selectedItemId, 0)

		else

			local hid  = ItemUtil.getEquipInfoFromHeroByItemId(tonumber(m_selectedItemId)).hid
			HeroModel.setHeroEquipEnchanteLevelBy(hid, m_selectedItemId, 0 )
			HeroModel.setHeroEquipEnchantExplBy(hid, m_selectedItemId, 0)
			UserModel.setInfoChanged(true) -- zhangqi, 2014-12-13, 阵上伙伴的装备强化成功后标记需要刷新战斗力

		end

		--更新背包数据
		require "script/module/equipment/MainEquipmentCtrl"
		local equipInfo  = ItemUtil.getItemInfoByItemId(m_selectedItemId)
		MainEquipmentCtrl.replaceEquipDataByGid(nil,equipInfo)



		m_selectedItemId = nil

		local function afterAnimation( ... )
			local tbItem = {}

			local silverInfo = {}
			silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
			silverInfo.name = mi18n[1520]
			table.insert( tbItem, silverInfo )

			if dictData.ret.item then
				for k, v in pairs(dictData.ret.item) do
					local itemInfo = {}
					local dbItem = assert(ItemUtil.getItemById(tonumber(k)), "createBtnByTemplateId--not found id: " .. k)
					itemInfo.icon = ItemUtil.createBtnByItemAndNum(dbItem, v)
					itemInfo.name = dbItem.name
					table.insert(tbItem, itemInfo)
				end
			end

			local layReward = UIHelper.createGetRewardInfoDlg( mi18n[2040], tbItem )
			LayerManager.addLayout(layReward)

		end
		RenascenceView.showAnimation(afterAnimation)
	end
end


function fnHandlerOfGoodNetwork(cbFlag,dictData,bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornTreasure" then
		UserModel.addGoldNumber(tonumber(-m_nGoldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		DataCache.resetTreasureInfoByItemID(m_selectedTreaId)


		--更新背包数据 zhangjunwu 2015-3-11
		--y因为有背包推送，所以此处不做处理

		-- 更新背包数据 zhangjunwu 2015-3-11
		local tb_treasModife = {}
		tb_treasModife.deleteData = {}
		tb_treasModife.insertData = {}
		tb_treasModife.replaceData = {}

		local treasInfo  = ItemUtil.getItemInfoByItemId(m_selectedTreaId)
		logger:debug(treasInfo)
		table.insert(tb_treasModife.replaceData,treasInfo.gid)
		-- require "script/module/bag/MainBagCtrl"
		-- MainBagCtrl.updataTreasData(tb_treasModife) -- zhangqi, 2015-10-26, updataTreasData 优化代码时已删除

		-- 重生后推送红点背包
		ItemUtil.pushitemCallback(treasInfo, 2)

		------------------------

		m_selectedTreaId = nil

		local function afterAnimation( ... )
			local tbItem = {}

			local silverInfo = {}
			silverInfo.icon = ItemUtil.getSiliverIconByNum(dictData.ret.silver)
			silverInfo.name = mi18n[1520]
			table.insert( tbItem, silverInfo )

			if dictData.ret.item then
				for k, v in pairs(dictData.ret.item) do
					local itemInfo = {}
					local dbItem = assert(ItemUtil.getItemById(tonumber(k)), "createBtnByTemplateId--not found id: " .. k)
					itemInfo.icon = ItemUtil.createBtnByItemAndNum(dbItem, v)
					itemInfo.name = dbItem.name
					table.insert(tbItem, itemInfo)
				end
			end

			local layReward = UIHelper.createGetRewardInfoDlg( mi18n[2040], tbItem )
			LayerManager.addLayout(layReward)
		end
		RenascenceView.showAnimation(afterAnimation)
	end
end


local function init(...)
	m_selectedHeroId = nil
	m_selectedItemId = nil
	m_selectedTreaId = nil
	m_nGoldNeedNumber = nil
end


function destroy(...)
	package.loaded["RenascenceCtrl"] = nil
end


function moduleName()
	return "RenascenceCtrl"
end


function create(...)
	init()

	local tbEventListener = {}

	tbEventListener.onIconBg = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local layChoose = RenascenceChooseCtrl.create( m_selectedHeroId, m_selectedItemId, m_selectedTreaId )
			LayerManager.addLayoutNoScale(layChoose)
			layChoose:setBackGroundColorOpacity(0)
		end
	end

	tbEventListener.onDesc = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local layIntroduce = g_fnLoadUI("ui/help_renascence.json")
			LayerManager.addLayout(layIntroduce)

			local i18nDesc = g_fnGetWidgetByName(layIntroduce, "tfd_desc")
			i18nDesc:setText(mi18n[2001])

			-- local i18nTitle = g_fnGetWidgetByName(layIntroduce, "TFD_DESC_TITLE")
			-- UIHelper.labelEffect(i18nTitle, mi18n[2043])

			local btnClose = g_fnGetWidgetByName(layIntroduce,"BTN_CLOSE")
			btnClose:addTouchEventListener(function ( sender, eventType)
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCloseEffect()

					LayerManager.removeLayout()
				end
			end	)
		end
	end

	-- 重生按钮事件
	tbEventListener.onRenascene = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			sender:setEnabled(false)
			local userInfo = UserModel.getUserInfo()
			if (m_selectedItemId == nil and m_selectedHeroId == nil and m_selectedTreaId == nil) then
				ShowNotice.showShellInfo(mi18n[2041])
				sender:setEnabled(true)
				return
			elseif tonumber(userInfo.gold_num) < m_nGoldNeedNumber then
				local layDlg = UIHelper.createNoGoldAlertDlg()
				LayerManager.addLayout(layDlg)
				sender:setEnabled(true)
				return
			else
				logger:debug(m_selectedHeroId)
				if m_selectedHeroId then
					if ItemUtil.isPropBagFull(true) then
						sender:setEnabled(true)
					elseif ItemUtil.isTreasBagFull(true) then
						sender:setEnabled(true)
					elseif ItemUtil.isEquipBagFull(true) then 	-- 判断装备背包
						sender:setEnabled(true)
					else
						local arg = CCArray:create()
						arg:addObject(CCInteger:create(m_selectedHeroId))

						Network.rpc(fnHandlerOfNetwork, "mysteryshop.rebornHero","mysteryshop.rebornHero", arg, true)
					end
				elseif m_selectedItemId then
					if ItemUtil.isPropBagFull(true) then
						sender:setEnabled(true)
					elseif ItemUtil.isEquipBagFull(true) then 	-- 判断装备背包
						sender:setEnabled(true)
					else
						local arg = CCArray:create()
						local itemArg = CCArray:create()
						itemArg:addObject(CCInteger:create(m_selectedItemId))
						arg:addObject(itemArg)
						Network.rpc(fnHandlerOfItemNetwork,"mysteryshop.rebornItem","mysteryshop.rebornItem",arg,true)
					end
				else
					if ItemUtil.isPropBagFull(true) then
						sender:setEnabled(true)
					elseif ItemUtil.isTreasBagFull(true) then
						sender:setEnabled(true)
					else
						local subArg = CCArray:create()
						local itemArg = CCArray:create()
						itemArg:addObject(CCInteger:create(m_selectedTreaId))
						subArg:addObject(itemArg)
						require "script/network/Network"
						Network.rpc(fnHandlerOfGoodNetwork,"mysteryshop.rebornTreasure","mysteryshop.rebornTreasure",subArg,true)
					end
				end
			end
		end
	end

	local layMain = RenascenceView.create( tbEventListener )
	return layMain
end


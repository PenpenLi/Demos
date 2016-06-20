-- FileName: PartnerBreak.lua
-- Author: wangming
-- Date: 15-04-08
-- Purpose: function description of module

module("PartnerBreak", package.seeall)
require "script/module/public/ShowNotice"
require "script/module/config/AudioHelper"
require "script/module/public/UIHelper"
require "db/DB_Heroes"
require "db/DB_Awake_ability"
require "script/model/hero/HeroModel"
require "script/module/partner/HeroFightUtil"

-- vars
local m_i18n = gi18n
local m_i18nString = gi18nString
local mUILoad = g_fnLoadUI
local m_fnGetWidgetByName = g_fnGetWidgetByName
local mUI = UIHelper

local _formerModuleName
local numSourceType = 1 --界面返回的module，默认1为武将界面，2为阵容界面，3为小伙伴界面
local numSrcLocation --为阵容界面传入的伙伴位置，返回阵容时候再进行回传

local partner_break

local tForceValue --突破前的数据
local tNewHeroArgs --突破后的数据

local tPreData
local tAfterData


local m_fnGetNeedItemInfo
-- local m_fnGetNewHtid
local m_fnGetDB_break
local nListViewItemTouchAble = true
--英雄进阶前数据显示label
local layBeforeHeroBody     --IMG_BEFORE_HERO_BODY 武将全身像
local layAfterHeroBody     --IMG_BEFORE_HERO_BODY 武将全身像

local buttonInfos --item按钮信息

--英雄进阶后数据显示label

local tfdAfterLevel
local tfdAfterHP
local tfdAfterPhyAttack
local tfdAfterMagicAttack
local tfdAfterPhyDefend
local thdAfterMagicDefend

--不可进阶是隐藏
local imgArrow
local layHeroAfterProperty           --LAY_HREO_AFTER_PROPERTY

--武将进化网络标石
local _sNetworkFlagOfHeroBreak
-- 进阶需要的物品数组
local m_tbNeedItems = {}
-- 当前英雄属性结构
local m_tbHeroAttr
-- 突破后的英雄属性
local m_tbHeroBreakedAttr
-- 来自父级界面的参数结构
local m_tParentParam
--进阶成功界面需要的数据
local m_tbSucceedNeedData = {}
--标记是否可进阶
local m_bCanTransfer

-- 进阶需要的物品或卡牌类型
local m_ksTypeOfItem=101
local m_ksTypeOfCard=102
-- 进阶所需物品种类标识
local m_nItemTypeProps = 10
local m_nItemTypeTreas = 11
local m_nItemTypeArms = 1
local m_nItemTypeHeroFrag = 7

local btnTransferag     = 100
local bTransed           = false         --是否精炼过，如果强化过，则在推出界面后更新伙伴界面数据
-- 初始化和析构
function init( tParam )
	logger:debug("tParam")

	m_bCanTransfer = true
	buttonInfos = {}
	m_tbNeedItems = {}
	if tParam then
		m_tParentParam = tParam
		if tParam.selectedHeroes then
			if #tParam.selectedHeroes >= 1 then
				m_tbHeroAttr = tParam.selectedHeroes[1]
			else
				m_tbHeroAttr = tParam.selectedHeroes
			end
		end
	end
	if(m_tbHeroAttr and m_tbHeroAttr.hid and not m_tbHeroAttr.equip) then
		require "script/model/hero/HeroModel"
		local hero_data = HeroModel.getHeroByHid(m_tbHeroAttr.hid)
		if(hero_data) then
			m_tbHeroAttr.equip = hero_data.equip
		end
	end

	m_tbHeroBreakedAttr = m_fnGetDB_break(m_tbHeroAttr)
	logger:debug("m_tbHeroBreakedAttr: ")

	m_fnGetNeedItemInfo()

end

function destroy( ... )
	package.loaded["PartnerBreak"] = nil
end

function moduleName()
	return "PartnerBreak"
end

--加通用描边字
function fnlabelNewStroke( widgetName )
	UIHelper.labelNewStroke(widgetName,ccc3(0x45,0x05,0x05))
end

local function fnGoSuccess( ... )
	local tags = {selectedHeroes = m_tbHeroAttr}
	local parmaTags = {tag1 = tags,tag2 = numSourceType,tag3 = numSrcLocation}
	require "script/module/partner/PartnerBreakSucceed"
	PartnerBreakSucceed.create(m_tbSucceedNeedData,parmaTags)
end

local function playSuccess( sender, MovementEventType, movementID )
	if (MovementEventType == 1) then
		nListViewItemTouchAble = true
		sender:removeFromParentAndCleanup(true)
		fnGoSuccess()
	end
end

local function transferAnimation( ... )

	for k,v in pairs(buttonInfos) do
		v:setTouchEnabled(false)
	end
	nListViewItemTouchAble = false

	local layModel =  m_fnGetWidgetByName(partner_break, "lay_hero_transfer_model")
	for i=1,4 do
		local btnlay = m_fnGetWidgetByName(layModel, "BTN_TRANSFER_CONSUME_ICON_BG_" .. i)
		btnlay:setTouchEnabled(false)
	end

	local btnTransferStar = m_fnGetWidgetByName(partner_break, "BTN_TRANSFER_STAR")
	btnTransferStar:setTouchEnabled(false)

	local btnBack = m_fnGetWidgetByName(partner_break, "BTN_TRANSFER_CLOSE")
	btnBack:setTouchEnabled(false)

	local BTN_PREVIEW = m_fnGetWidgetByName(partner_break, "BTN_PREVIEW")
	BTN_PREVIEW:setTouchEnabled(false)
	local BTN_INFORMATION = m_fnGetWidgetByName(partner_break, "BTN_INFORMATION")
	BTN_INFORMATION:setTouchEnabled(false)

	layBeforeHeroBody:setTouchEnabled(false)
	layAfterHeroBody:setTouchEnabled(false)

	--处理动画
	AudioHelper.playEffect("audio/effect/texiao_jinjie1.mp3")
	if (partner_break) then
		local m_arAni1 = mUI.createArmatureNode({
			imagePath = "images/effect/jinjie/jinjie10.png",
			plistPath = "images/effect/jinjie/jinjie10.plist",
			filePath = "images/effect/jinjie/jinjie1.ExportJson",
			animationName = "jinjie1",
			loop = 0,
			fnMovementCall = playSuccess,
		})

		local px = layBeforeHeroBody:getPositionX()
		local py = layBeforeHeroBody:getPositionY()
		local pWold = layBeforeHeroBody:getParent():convertToWorldSpace(ccp(px , py))

		m_arAni1:setPosition(ccp(pWold.x , pWold.y + layBeforeHeroBody:getContentSize().height*0.5))

		-- m_arAni1:setPosition(ccp(pWold.x + imgBeforeHeroBody:getContentSize().width / 2 ,pWold.y + imgBeforeHeroBody:getContentSize().height / 2 ))
		if (partner_break:getChildByTag(btnTransferag)) then
			partner_break:getChildByTag(btnTransferag):removeFromParentAndCleanup(true)
		end
		partner_break:addNode(m_arAni1,1000,btnTransferag)
	end
end

m_fnGetDB_break = function (tParam)
	require "db/DB_Heroes"
	local db_hero = DB_Heroes.getDataById(tParam.htid)
	if(db_hero.break_id) then
		require "db/DB_Hero_break"
		local db_break = DB_Hero_break.getDataById(db_hero.break_id)
		return db_break
	end
	return nil
end

-- 网络事件处理
local function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	logger:debug("request END")

	if not bRet then
		logger:debug("突破失败")
        logger:debug("进阶失败")
        -- 移除屏蔽层
		LayerManager.removeLayout()
		return
	end
	--武将卡牌强化
	if (cbFlag == _sNetworkFlagOfHeroBreak) then
		-- 进阶成功后处理
		local tRet = dictData.ret
		logger:debug("wm----tRet")


		-- 减去消耗的武将数组

		-- 修改武将进阶后的模板id
		if (tonumber(m_tbHeroAttr.htid) == tonumber(UserModel.getAvatarHtid()) ) then
			UserModel.setAvatarHtid(m_tbHeroBreakedAttr.after_id) -- 如果进阶的是玩家角色，需要更新htid
		end
		HeroModel.setHtidByHid(m_tbHeroAttr.hid, m_tbHeroBreakedAttr.after_id)
		m_tbHeroAttr.htid = m_tbHeroBreakedAttr.after_id
		-- 添加图鉴
		DataCache.addHeroBook({m_tbHeroAttr.htid})

		local tuoPoAni = mUI.createArmatureNode({
		filePath = "images/effect/partner_break/break2/break_2.ExportJson",
		animationName = "break_2",
        loop = 0,
        fnMovementCall = function ( ... )
    	    if(movementType == EVT_COMPLETE) then
        		tuoPoAni:removeFromParentAndCleanup(true)
        		fnGoSuccess()
			end
        end,
        fnFrameCall = function( bone,frameEventName,originFrameIndex,currentFrameIndex )
	            if(frameEventName == "1") then
					local layBeforeHeroBodyImg = layBeforeHeroBody:getVirtualRenderer()
					layBeforeHeroBodyImg:runAction(CCSpawn:createWithTwoActions(
	                                                            CCScaleTo:create(5/60, 0.9 ),
	                                                            CCFadeTo:create(5/60,255 *0.5)
	                                                        ))

	            elseif (frameEventName == "2") then
					local layAfterHeroBodyImg = layAfterHeroBody:getVirtualRenderer()
					layAfterHeroBodyImg:runAction(CCSpawn:createWithTwoActions(
	                                                            CCScaleTo:create(5/60, 1),
	                                                            CCFadeTo:create(5/60,255)
	                                                        ))
	            elseif (frameEventName == "3") then
	    			fnGoSuccess()
	            end
	        end
    	})
		tuoPoAni:setAnchorPoint(ccp(0.5,0.5))
		local laySize = layBeforeHeroBody:getParent():getContentSize()
		tuoPoAni:setPosition(ccp(laySize.width * 0.5,laySize.height * 0.5 ))
		layBeforeHeroBody:getParent():addNode(tuoPoAni)
		-- transferAnimation()


		require "script/model/user/UserModel"       
	 	local curHeroHid = tonumber(m_tbHeroAttr.hid)
        -- local updataInfo = {[hid] = {HeroFightUtil.FORCEVALUEPART.LEVEL , HeroFightUtil.FORCEVALUEPART.UNION},}
		UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
		UserModel.updateFightValue({[curHeroHid] = {}})-- 生成新的hid 所以所有部分战斗力都要重新计算
		UserModel.addSilverNumber(-tonumber(m_tbHeroAttr.cost_coin)) -- 减去消耗的贝里数目

		bTransed = true
	end
end

-- 创建物品列表TableView
m_fnGetNeedItemInfo = function ()
	local pDB_break = m_fnGetDB_break(m_tbHeroAttr)
	if(not pDB_break) then
		m_tbNeedItems = nil
		return
	end
	local new_htid = pDB_break.after_id
	logger:debug("wm----m_tbHeroAttr")
	-- 进阶需要的进阶等级
	m_tbHeroAttr.need_advancelv = tonumber(pDB_break.need_advancelv) or 0
	-- 进阶需要的英雄等级
	m_tbHeroAttr.need_strlv = tonumber(pDB_break.need_strlv) or 0
	-- 进阶需要的花费贝里
	m_tbHeroAttr.cost_coin = tonumber(pDB_break.cost_belly) or 0

	-- 进阶需要的物品ID及数量组
	local sItemNeeded = pDB_break.cost_item
	local tArrItemNeeded = string.split(sItemNeeded, ",")
	local tArrItems = {}
	require "script/module/public/ItemUtil"
	for i=1, #tArrItemNeeded do
		local data = string.split(tArrItemNeeded[i], "|")
		if #data < 2 then
			data[2] = 1
		end
		logger:debug("data[1]"..data[1])
		local tMapItem = {id=tonumber(data[1]), needCount=tonumber(data[2]), realCount=0}
		local tDB = ItemUtil.getItemById(tMapItem.id)

		tMapItem.file = tDB.imgFullPath
		tMapItem.bg = tDB.bgFullPath
		tMapItem.type = m_ksTypeOfItem
		tMapItem.item_type = tDB.item_type
		table.insert(tArrItems, tMapItem)
	end

	-- 获取物品相关数据
	local bag = DataCache.getRemoteBagInfo()
	local treas = bag.treas
	local props = bag.props
	local arms = bag.arm
	local heroFrag = bag.heroFrag
	if props then
		for k, v in pairs(props) do
			for i=1, #tArrItems do
				if tArrItems[i].item_type == m_nItemTypeProps and tonumber(v.item_template_id) == tArrItems[i].id then
					if v.item_id then
						tArrItems[i].itemId = tonumber(v.item_id)
					end
					tArrItems[i].realCount = tArrItems[i].realCount + tonumber(v.item_num)
				end
			end
		end
	end
	if treas then
		for k, v in pairs(treas) do
			for i=1, #tArrItems do
				if tArrItems[i].item_type == m_nItemTypeTreas and tonumber(v.item_template_id) == tArrItems[i].id then
					if v.va_item_text and v.va_item_text.treasureLevel and tonumber(v.va_item_text.treasureLevel)==0 then
						tArrItems[i].realCount = tArrItems[i].realCount +  tonumber(v.item_num)
						if tArrItems[i].itemId == nil then
							tArrItems[i].itemId = {}
						end
						table.insert(tArrItems[i].itemId, v.item_id)
					end
				end
			end
		end
	end
	if arms then
		for k, v in pairs(arms) do
			for i=1, #tArrItems do
				if tArrItems[i].item_type == m_nItemTypeArms and tonumber(v.item_template_id) == tArrItems[i].id then
					if v.va_item_text and v.va_item_text.armReinforceLevel and tonumber(v.va_item_text.armReinforceLevel)==0 then
						tArrItems[i].realCount = tArrItems[i].realCount +  tonumber(v.item_num)
						if tArrItems[i].itemId == nil then
							tArrItems[i].itemId = {}
						end
						table.insert(tArrItems[i].itemId, v.item_id)
					end
				end
			end
		end
	end
	if heroFrag then
		for k, v in pairs(heroFrag) do
			for i=1, #tArrItems do
				if tArrItems[i].item_type == m_nItemTypeHeroFrag and tonumber(v.item_template_id) == tArrItems[i].id then
					if v.va_item_text and tonumber(v.item_num) > 0 then
						tArrItems[i].realCount = tArrItems[i].realCount +  tonumber(v.item_num)
						if v.item_id then
							tArrItems[i].itemId = tonumber(v.item_id)
						end
					end
				end
			end
		end
	end

	-- tableview中单元项数组
	local tCellItems = {}
	-- 把物品信息加入单元项数组
	for i=1, #tArrItems do
		table.insert(tCellItems, tArrItems[i])
	end

	m_tbNeedItems = tCellItems
	logger:debug("m_tbNeedItems: ", #m_tbNeedItems)
end

local function onBtnBreakBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then

		-- zhangjunwu, 2014-10-24, ，判断是否有过至少一次精炼成功，来判断是否需要更新伙伴界面的数据
		fnFreshYingziList()

		AudioHelper.playBackEffect()
		if (_formerModuleName == "MainFormation") then
			require "script/module/formation/MainFormation"
			logger:debug("wm-----numSrcLocation : " .. numSrcLocation)
			local layPartner = MainFormation.create(numSrcLocation - 1)
			if (layPartner) then
				-- zhangqi, 不需要重新创建定制信息面板时指定true把以前的清理一下，避免更新人物属性导致找不到对象的问题
				LayerManager.changeModule(layPartner, MainFormation.moduleName(), {1,3}, true)
			end
		else
			require "script/module/partner/MainPartner"
			local layPartner = MainPartner.create()
			if (layPartner) then
				LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3})
				PlayerPanel.addForPartnerStrength()
			end
		end
	end
end

-- 所有名将的个数
function getAllStarsNumber( )
	local starListArr = DataCache.getStarArr()
	local t_num = 0
	if( not table.isEmpty(starListArr))then
		t_num = #starListArr
	end
	return t_num
end


local function onBtnBreakStart( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 音效
		AudioHelper.playCommonEffect()

		-- local ptest = true
		-- if(ptest) then
		--     -- transferAnimation()
		--     fnGoSuccess()
		--     return
		-- end

		-- 判断进阶功能节点是否开启了，如果没开启则返回
		require "script/model/DataCache"
		if (not SwitchModel.getSwitchOpenState(ksSwitchHeroBreak,true)) then
			return
		end
		-- if (not m_tbHeroAttr) then
		--     ShowNotice.showShellInfo("请先选择需要进阶的伙伴")
		--     return
		-- end
		if m_tbHeroBreakedAttr == nil then --wm_todo
			ShowNotice.showShellInfo(m_i18n[1120])
			return
		end


		-- 判断武将等级是否足够和进阶等级是否足够
		m_tbHeroAttr.level = tonumber(m_tbHeroAttr.level)
		m_tbHeroAttr.evolve_level = tonumber(m_tbHeroAttr.evolve_level)
		if(m_tbHeroAttr.need_strlv > m_tbHeroAttr.level or m_tbHeroAttr.need_advancelv > m_tbHeroAttr.evolve_level) then
			local pstring = m_i18nString(1158,tostring(m_tbHeroAttr.need_strlv),tostring(m_tbHeroAttr.need_advancelv))
			--local pstring = string.format("伙伴达到%s级并进阶＋%s才可以突破",tostring(m_tbHeroAttr.need_strlv ),tostring(m_tbHeroAttr.need_advancelv))--wm_todo
			ShowNotice.showShellInfo(pstring)
			return
		end
		-- 判断突破条件是否满足
		for i=1, #m_tbNeedItems do
			local item = m_tbNeedItems[i]
			if item.needCount > item.realCount then
				if item.type == m_ksTypeOfCard then
					--ShowNotice.showShellInfo("突破所需卡牌数量不足")
				else
					local dropcallfn = function ( ... )
						logger:debug("m_fnGetNeedItemInfo")
						m_fnGetNeedItemInfo()
						fnInitConsum()
					end
					PublicInfoCtrl.createItemDropInfoViewByTid(60025,dropcallfn,true)  -- 突破石不足引导界面
					ShowNotice.showShellInfo(m_i18n[1150])--wm_todo
				end
				return
			end
		end
		-- 判断玩家贝里数量是否足够
		if m_tbHeroAttr.cost_coin > UserModel.getSilverNumber() then
			PublicInfoCtrl.createItemDropInfoViewByTid(60406)  -- 贝里不足引导界面
			ShowNotice.showShellInfo(m_i18n[1151])--wm_todo
			return
		end
		require "script/network/RequestCenter"
		local args = CCArray:createWithObject(CCInteger:create(m_tbHeroAttr.hid))
		local sub_args = CCArray:create()
		local args_item = CCDictionary:create()
		for i=1, #m_tbNeedItems do
			local item = m_tbNeedItems[i]
			if item.type == m_ksTypeOfCard then
				if item.realCount > item.needCount then
					table.sort(item.cards, function (p1, p2)
						return p1.level < p2.level
					end)
				end
				for j=1, item.needCount do
					sub_args:addObject(CCInteger:create(item.cards[j].hid))
				end
			else
				if( type(item.itemId) == "table") then
					for i=1, item.needCount do
						args_item:setObject(CCInteger:create(1), tostring(item.itemId[i]))
					end
				else
					args_item:setObject(CCInteger:create(item.needCount), tostring(item.itemId))
				end
			end
		end
		-- args:addObject(sub_args)
		args:addObject(args_item)
		        -- 播放动画时加屏蔽层
        local layout = Layout:create()
        layout:setName("layForShield")
        LayerManager.addLayout(layout)

		_sNetworkFlagOfHeroBreak = RequestCenter.hero_heroBreak(fnHandlerOfNetwork, args)
	end
end

--获取当前解锁的技能
local function fnGetNewWakeName( awakeIdsPre, awakeIdsAfter )
	if (awakeIdsPre and awakeIdsAfter) then
		local tbAfter = {}
		local growAwake = string.split(awakeIdsAfter, ",")
		for _,value in ipairs(growAwake) do
			local growAwake = string.split(value, "|")
			table.insert(tbAfter,growAwake)
		end
		local tbPre = {}
		local growAwake = string.split(awakeIdsPre, ",")
		for _,value in ipairs(growAwake) do
			local growAwake = string.split(value, "|")
			table.insert(tbPre,growAwake)
		end

		local tbAfterLen = #tbAfter
		local pAwakeID = tonumber(tbAfter[tbAfterLen][3])
		local awakeInfo = DB_Awake_ability.getDataById(pAwakeID)
		local awkae_type = tonumber(tbAfter[tbAfterLen][1])
		local pppstr = ""
		local pLv = tonumber(tbAfter[tbAfterLen][2]) or 0
		if(awkae_type == 1)then
			pppstr = string.format(m_i18n[1712],m_i18n[1001]..pLv)
		elseif(awkae_type == 2) then
			pppstr = string.format(m_i18n[1712],m_i18n[1005].."+"..pLv)
		end
		return awakeInfo.name , awakeInfo, pppstr

			-- for k,v in pairs(tbAfter) do
			--     local pID = tonumber(v[3]) or 0
			--     local pHave = false
			--     for k2,v2 in pairs(tbPre) do
			--         local pID2 = tonumber(v2[3]) or -1
			--         if(pID == pID2) then
			--             pHave = true
			--         end
			--     end
			--     if(not pHave) then
			--         local pAwakeID = tonumber(v[3])
			--         local awakeInfo = DB_Awake_ability.getDataById(pAwakeID)
			--         local awkae_type = tonumber(v[1])
			--         local pppstr = ""
			--         local pLv = tonumber(v[2]) or 0
			--         if(awkae_type == 1)then
			--             pppstr = string.format(m_i18n[1712],m_i18n[1001]..pLv)
			--         elseif(awkae_type == 2) then
			--             pppstr = string.format(m_i18n[1712],m_i18n[1005].."+"..pLv)
			--         end
			--         return awakeInfo.name , awakeInfo, pppstr
			--     end
			-- end


	end
	return "",nil,nil
end

function fnFreshYingziList( ... )
	if(bTransed) then
		if(MainPartner) then
			MainPartner.refreshYingZiListView()
		end
		bTransed = false
	end
end

local function fnInitTb( ... )
	local m_preTb = DB_Heroes.getDataById(m_tbHeroAttr.htid)
	logger:debug("tPreDB: ", m_tbHeroAttr.htid)
	m_tbSucceedNeedData = {}
	local tPreHeroArgs = {}
	tPreHeroArgs = table.hcopy(m_tbHeroAttr, tPreHeroArgs)
	-- 属性值列表
	tForceValue = nil
	if tPreHeroArgs.hid ~=nil then
		tForceValue = HeroFightUtil.getAllForceValuesByHid(tPreHeroArgs.hid)
		-- tForceValue = HeroFightUtil.getAllForceValuesByHid(tPreHeroArgs.hid)
	end
    
	tPreData = {level = m_tbHeroAttr.level}
	tPreData.file = "images/base/hero/body_img/" .. m_preTb.halflen_img_id
	-- if (m_preTb.country ~= nil  and m_preTb.country ~= 0) then
	tPreData.heroCamp = HeroModel.getCiconByCidAndlevel(m_preTb.country, m_preTb.star_lv)
	-- end
	tPreData.heroBg = "images/common/hero_show/quality/"..m_preTb.potential..".png"
	tPreData.life = tForceValue.life
	tPreData.phyAttack = tForceValue.physicalAttack
	tPreData.magicAttack = tForceValue.magicAttack
	tPreData.phyDefned = tForceValue.physicalDefend
	tPreData.magicDefend = tForceValue.magicDefend
	tPreData.potential = m_preTb.potential
	tPreData.need_strlv = m_tbHeroAttr.need_strlv
	tPreData.star_lv = m_preTb.star_lv
	tPreData.db_hero = m_tbHeroAttr.db_hero or m_tbHeroAttr.localInfo or ""
	tPreData.evolve_level = m_tbHeroAttr.evolve_level
	tPreData.need_advancelv = m_tbHeroAttr.need_advancelv
	tPreData.body_img_id = m_preTb.body_img_id
	tPreData.heroQuality = m_preTb.heroQuality
	tPreData.m_preTb = m_preTb


	table.insert(m_tbSucceedNeedData, tPreData)

	local pDB_break = m_fnGetDB_break(m_tbHeroAttr)
	tNewHeroArgs = nil
	if (pDB_break ~= nil) then --可进阶new_htid
		local m_afterTb = DB_Heroes.getDataById(pDB_break.after_id)
		tNewHeroArgs = {}
		--m_tbHeroAttr.db_hero = m_afterTb
		tNewHeroArgs=table.hcopy(m_tbHeroAttr, tNewHeroArgs)
		tNewHeroArgs.db_hero = m_afterTb
		tNewHeroArgs.htid = m_tbHeroBreakedAttr.after_id
		local ndb_hero = DB_Heroes.getDataById(tNewHeroArgs.htid)
		tNewHeroArgs.heroQuality = ndb_hero.heroQuality
		tNewHeroArgs.name = heroName
		tNewHeroArgs.evolve_level = m_tbHeroAttr.evolve_level
		tNewHeroArgs.type = 1

		if (tNewHeroArgs.hid ~= nil) then
			tNewHeroArgs.force_values = HeroFightUtil.getNewAllForceValues(tNewHeroArgs,nil,nil,true)
		end

		--解锁的技能
		local awakeName,awakeInfo,openInfo = fnGetNewWakeName(m_preTb.grow_awake_id,m_afterTb.grow_awake_id)
		tNewHeroArgs.awakeInfo = awakeInfo
		tNewHeroArgs.awakeOpen = openInfo

		--初始化进阶后 进阶成功界面所需要显示的信息
		tAfterData = {level = m_tbHeroAttr.level}
		tAfterData.quality = tonumber(m_afterTb.star_lv) or 3
		tAfterData.heroQuality = tonumber(m_afterTb.heroQuality) or 1
		tAfterData.file = "images/base/hero/body_img/" .. m_afterTb.halflen_img_id
		tAfterData.heroCamp = HeroModel.getCiconByCidAndlevel(m_afterTb.country, m_afterTb.star_lv)
		tAfterData.heroBg = "images/common/hero_show/quality/"..m_afterTb.potential..".png"
		tAfterData.starLv = m_afterTb.star_lv
		tAfterData.life = tNewHeroArgs.force_values.life
		tAfterData.phyAttack = tNewHeroArgs.force_values.physicalAttack
		tAfterData.magicAttack = tNewHeroArgs.force_values.magicAttack
		tAfterData.phyDefned = tNewHeroArgs.force_values.physicalDefend
		tAfterData.magicDefend = tNewHeroArgs.force_values.magicDefend
		tAfterData.wakeName = awakeName
		tAfterData.wakeDes = awakeInfo and awakeInfo.des or nil
		tAfterData.wakeLimit = openInfo
		tAfterData.potential = m_afterTb.potential
		tAfterData.awakeOpen = awakeInfo
		tAfterData.awakeInfo = openInfo
		tAfterData.awakeInfoName = awakeInfo.name 
		tAfterData.des = awakeInfo.des
		tAfterData.body_img_id = m_afterTb.body_img_id
		tAfterData.rage_skill_attack = m_afterTb.rage_skill_attack
		tAfterData.m_afterTb = m_afterTb

		table.insert(m_tbSucceedNeedData, tAfterData)
	end

end

-- 显示技能突破信息
function funInitLaySkill( ... )
	--local skillLay = m_fnGetWidgetByName(partner_break, "LAY_SKILL")


	--local TFD_JIBAN = m_fnGetWidgetByName(skillLay,"TFD_JIBAN")
	--TFD_JIBAN:setText(m_i18n[1152])
	--UIHelper.labelNewStroke(TFD_JIBAN , ccc3( 0x28 , 0x0e , 0x04))

	-- local TFD_JIBAN_UP = m_fnGetWidgetByName(skillLay,"TFD_JIBAN_UP")
	-- TFD_JIBAN_UP:setText(m_i18n[1153])
	-- UIHelper.labelNewStroke(TFD_JIBAN_UP , ccc3( 0x28 , 0x0e , 0x04))

	-- local TFD_SKILL_UP = m_fnGetWidgetByName(skillLay,"TFD_SKILL_UP")
	-- TFD_SKILL_UP:setText(m_i18n[1154])
	-- UIHelper.labelNewStroke(TFD_SKILL_UP , ccc3( 0x28 , 0x0e , 0x04))

	-- local TFD_ANGER_NAME = m_fnGetWidgetByName(skillLay,"TFD_ANGER_NAME")
	-- TFD_ANGER_NAME:setText("")
	-- local TFD_ANGER_INFO = m_fnGetWidgetByName(skillLay,"TFD_ANGER_INFO")
	-- TFD_ANGER_INFO:setText("")


	--进阶后伙伴数据
	-- if (tNewHeroArgs and m_afterTb) then --可进阶new_htid

	-- 	require "db/skill"
	-- 	local skilAngerText = skill.getDataById(m_afterTb.rage_skill_attack)

	-- 	--TFD_ANGER_NAME:setText(skilAngerText.name)
	-- 	local pDB_break = m_fnGetDB_break(m_tbHeroAttr)
	-- 	--TFD_ANGER_INFO:setText(pDB_break.anger_skill or "")
	-- else
	-- 	btnList:setTouchEnabled(false)
	-- 	btnList:setVisible(false)
	-- end
end


-- 显示LAY_CONSUME部分
function fnInitConsum( ... )
	--进阶消耗贝里
	local consumeLay = m_fnGetWidgetByName(partner_break, "LAY_CONSUME")
	local tfd_consume = m_fnGetWidgetByName(consumeLay, "tfd_consume")
	--UIHelper.labelNewStroke(tfd_consume , ccc3( 0x28 , 0x04 , 0x04))


	local btnStart = m_fnGetWidgetByName(consumeLay, "BTN_BREAK")
	btnStart:addTouchEventListener(onBtnBreakStart)
	mUI.titleShadow(btnStart,m_i18n[1155])--wm_todo

	local itemNums = table.count(m_tbNeedItems)
	for i=1,4 do
		if(i <= itemNums) then
			local layitem = m_fnGetWidgetByName(consumeLay, "LAY_ITEM")
			-- btnlay:stopAllActions()
			layitem:setVisible(true)
			-- mUI.runFloatAction(btnlay)

			local tdfConsumeName = m_fnGetWidgetByName(layitem, "TFD_ITEM_NAME")

			local itemInfo = ItemUtil.getItemById(m_tbNeedItems[i].id)
			tdfConsumeName:setText(itemInfo.name)
			tdfConsumeName:setColor(g_QulityColor[itemInfo.quality])

			local function btnLayShow( sender ,eventType )
				if eventType == TOUCH_EVENT_ENDED then
					AudioHelper.playCommonEffect()
					local itemTid = m_tbNeedItems[i].id
					local itemInfo = ItemUtil.getItemById(itemTid)
					if (itemInfo.isNormal) then
						local dropcallfn = function ( ... )
							logger:debug("m_fnGetNeedItemInfo")
							m_fnGetNeedItemInfo()
							fnInitConsum()
						end
						PublicInfoCtrl.createItemDropInfoViewByTid(60025,dropcallfn,nil)  -- 突破石头掉落引导界面

					elseif(itemInfo.isHeroFragment) then
						require "script/module/public/FragmentDrop"
						local fragmentDrop = FragmentDrop:new()
						local dropcallfn = function ( ... )
							m_fnGetNeedItemInfo()
							fnInitConsum()
						end
						
						local fragmentDroplayout = fragmentDrop:create(itemTid,dropcallfn)
						
						LayerManager.addLayout(fragmentDroplayout)
					end
				end
			end

			local btnlay = ItemUtil.createBtnByItem(itemInfo,btnLayShow)
			local IMG_ITEM = m_fnGetWidgetByName(consumeLay, "IMG_ITEM")
			IMG_ITEM:removeAllChildren()
			IMG_ITEM:addChild(btnlay)

			local nNeedCount = tonumber(m_tbNeedItems[i].needCount)
			local nRealCount = tonumber(m_tbNeedItems[i].realCount)

			local labnNumLeft = m_fnGetWidgetByName(layitem, "TFD_NUM_LEFT")
			local labnNumRight = m_fnGetWidgetByName(layitem, "TFD_NUM_RIGHT")

			if( nNeedCount > nRealCount) then
				labnNumLeft:setColor(ccc3(0xff,0x36,0x00))
			else
				labnNumLeft:setColor(ccc3(0x59,0x1f,0x00))
			end

			labnNumLeft:setText(nRealCount)
			labnNumRight:setText(nNeedCount)

		end
	end

	local TFD_CONSUME_NUM = m_fnGetWidgetByName(consumeLay, "TFD_CONSUME_NUM")
	TFD_CONSUME_NUM:setText(m_tbHeroAttr.cost_coin)

end

local function fnInitBeforeProperty( ... )
	--突破前英雄数据
	local attrBeforePart = m_fnGetWidgetByName(partner_break, "img_attr_bg")
	-- local tfd_attr = m_fnGetWidgetByName(propertyLay, "tfd_attr")
	-- tfd_attr:setText(m_i18n[1156])--wm_todo 	突破后属性
	-- UIHelper.labelNewStroke(tfd_attr , ccc3( 0x28 , 0x0e , 0x04))


	local ptfds = {}
	for i=1,5 do
		local LAY_ATTR = m_fnGetWidgetByName(attrBeforePart, "LAY_ATTR"..i)
		local TFD_ATTR_NAME = m_fnGetWidgetByName(LAY_ATTR, "TFD_ATTR_NAME" .. i)
		fnlabelNewStroke(TFD_ATTR_NAME)
		TFD_ATTR_NAME:setText(m_i18n[1047+i-1])
		local TFD_ATTR_NUM = m_fnGetWidgetByName(LAY_ATTR, "TFD_ATTR_NUM" .. i)
		fnlabelNewStroke(TFD_ATTR_NUM)

		-- local TFD_ATTR_ADD = m_fnGetWidgetByName(attrBeforePart, "TFD_ATTR_ADD" .. i)
		--table.insert(ptfds,{TFD_ATTR_NUM,TFD_ATTR_ADD})
		table.insert(ptfds,TFD_ATTR_NUM)
	end

	ptfds[1]:setText(tPreData.life)
	ptfds[2]:setText(tPreData.phyAttack)
	ptfds[3]:setText(tPreData.magicAttack)
	ptfds[4]:setText(tPreData.phyDefned)
	ptfds[5]:setText(tPreData.magicDefend)

	-- 等级和进阶需求面板
	local layNeed = m_fnGetWidgetByName(attrBeforePart, "LAY_NEED")

	-- 等级
	local TFD_STRLV = m_fnGetWidgetByName(layNeed, "tfd_limit")
	fnlabelNewStroke(TFD_STRLV)
	TFD_STRLV:setText(m_i18n[1160]) --wm_todoi18n 需要等级
	local TFD_NOWLV = m_fnGetWidgetByName(layNeed, "TFD_LV_NOW1")  --当前LV todo
	fnlabelNewStroke(TFD_NOWLV)
	TFD_NOWLV:setText(tPreData.level)

	local tfd_slant1 = m_fnGetWidgetByName(layNeed, "tfd_slant1")  
	fnlabelNewStroke(tfd_slant1)

	if (tonumber(tPreData.level) < tonumber(tPreData.need_strlv)) then
		TFD_NOWLV:setColor(ccc3(0xff,0x36,0x00))
	else
		TFD_NOWLV:setColor(ccc3(0xff,0x8d,0x2c))
	end

	-- 名字和资质
	local layPrePartner = m_fnGetWidgetByName(attrBeforePart, "LAY_NAME1")

	local tfdPreName = m_fnGetWidgetByName(attrBeforePart, "TFD_PARTNER_NAME")
	tfdPreName:setVisible(true)
	local tfdPreAdvanceLv = m_fnGetWidgetByName(attrBeforePart, "TFD_ADVANCE_LV")
	tfdPreAdvanceLv:setVisible(true)
	local pQulity1 = tonumber(tPreData.star_lv) or 3
	tfdPreName:setText(tAfterData.m_afterTb.name)  --localInfo
	tfdPreName:setFontSize(26)
	tfdPreName:setColor(g_QulityColor2[pQulity1])
	UIHelper.labelNewStroke(tfdPreName , ccc3( 0x28 , 0x00 , 0x00))

	tfdPreAdvanceLv:setText("+".. tPreData.evolve_level)
	tfdPreAdvanceLv:setFontSize(26)
	tfdPreAdvanceLv:setColor(g_QulityColor2[pQulity1])
	UIHelper.labelNewStroke(tfdPreAdvanceLv , ccc3( 0x28 , 0x00 , 0x00))

	local TFD_STRLV = m_fnGetWidgetByName(layNeed, "TFD_STRLV")
	fnlabelNewStroke(TFD_STRLV)
	TFD_STRLV:setText(tPreData.need_strlv)
	local tfd_desc2 = m_fnGetWidgetByName(layNeed, "tfd_desc2")
	fnlabelNewStroke(tfd_desc2)
	tfd_desc2:setText(m_i18n[1168])--wm_todo[]"需要进阶"
	local TFD_STRLV_2 = m_fnGetWidgetByName(layNeed, "TFD_STRLV_2")
	fnlabelNewStroke(TFD_STRLV_2)
	TFD_STRLV_2:setText(tPreData.need_advancelv)
	local TFD_LV_NOW2 = m_fnGetWidgetByName(layNeed, "TFD_LV_NOW2") -- 当前进阶等级 todo
	fnlabelNewStroke(TFD_LV_NOW2)
	TFD_LV_NOW2:setText(tPreData.evolve_level)

	local tfd_slant2 = m_fnGetWidgetByName(layNeed, "tfd_slant2")  
	fnlabelNewStroke(tfd_slant2)

	if (tonumber(tPreData.evolve_level) < tonumber(tPreData.need_advancelv)) then
		TFD_LV_NOW2:setColor(ccc3(0xff,0x36,0x00))
	else
		TFD_LV_NOW2:setColor(ccc3(0xff,0x8d,0x2c))
	end

end


-- 显示突破后属性部分
function fnInitAfterProperty( ... )

	if (tAfterData.m_afterTb) then --可进阶new_htid

		local newPropertyPart = m_fnGetWidgetByName(partner_break, "img_attr_bg2")
		local IMG_ARROW = m_fnGetWidgetByName(partner_break, "IMG_ARROW")
  --       local arrowArmature = UIHelper.createArmatureNode({
		-- 	filePath = "images/effect/partner_break/break1/break_1.ExportJson",
		-- 	animationName = "break_1",
		-- 	}
		-- )

        --IMG_ARROW:addNode(arrowArmature)
		local newInfoLsv = m_fnGetWidgetByName(newPropertyPart, "LSV_NEW_INFO")
		local btnList = m_fnGetWidgetByName(newInfoLsv, "BTN_INFORMATION")
		--mUI.titleShadow(btnList,m_i18n[1164])--wm_todo
		if(tNewHeroArgs) then
			btnList:setTouchEnabled(true)
			btnList:setVisible(true)
			btnList:addTouchEventListener(function (sender ,eventType )
				if eventType == TOUCH_EVENT_ENDED then
					AudioHelper.playInfoEffect()
					-- 现实进阶伙伴信息
					require "script/module/partner/PartnerInfoCtrl"
			        local pHeroValue = tNewHeroArgs--PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
			        logger:debug({pHeroValue=pHeroValue})
			        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.hid ,strengthenLevel = pHeroValue.level ,transLevel = pHeroValue.evolve_level ,readOnly =  true,heroValue = pHeroValue}
			        local tArgs = {}
			        tArgs.heroInfo = heroInfo
			        logger:debug({tArgs=tArgs})
			        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
			        LayerManager.addLayoutNoScale(layer)

				end
			end)
		else
			btnList:setTouchEnabled(false)
			btnList:setVisible(false)
		end

		--突破后英雄数据

		local ptfdsAfter = {}
		for i=1,5 do
			local LAY_ATTR = m_fnGetWidgetByName(newPropertyPart, "LAY_ATTR"..i)
			local TFD_ATTR_NAME = m_fnGetWidgetByName(LAY_ATTR, "TFD_ATTR_NAME" .. i)
			fnlabelNewStroke(TFD_ATTR_NAME)
			TFD_ATTR_NAME:setText(m_i18n[1047+i-1])
			local TFD_ATTR_NUM = m_fnGetWidgetByName(LAY_ATTR, "TFD_ATTR_NUM" .. i)
			fnlabelNewStroke(TFD_ATTR_NUM)

			local imgTransfer = m_fnGetWidgetByName(LAY_ATTR, "img_transfer")
			imgTransfer:runAction(CCPlace:create(ccp(imgTransfer:getPositionX(),imgTransfer:getPositionY() - 5)))
			local imgTransferPic = imgTransfer:getVirtualRenderer()
			imgTransfer:setOpacity(0)

			local actionArray = CCArray:create()
			-- 控件节点 和节点中得 getVirtualRenderer 运动方向是反的。。。。
			actionArray:addObject(
                           	CCSpawn:createWithTwoActions(
                                                            CCMoveBy:create(0.5, ccp(5, 0)),
                                                            CCFadeIn:create(0.5)
                                                        )
                           )
			actionArray:addObject(
                           	CCSpawn:createWithTwoActions(
                                                            CCMoveBy:create(0.5, ccp(5, 0)),
                                                            CCFadeOut:create(0.5)
                                                        )
                           )
			actionArray:addObject(CCCallFuncN:create(function ( sender )
				sender:setPositionX(sender:getPositionX() - 10)
			end))

			local seq = CCSequence:create(actionArray)
			local repeatAction = CCRepeatForever:create(seq)
			imgTransferPic:runAction(repeatAction)
			-- local TFD_ATTR_ADD = m_fnGetWidgetByName(attrBeforePart, "TFD_ATTR_ADD" .. i)
			--table.insert(ptfds,{TFD_ATTR_NUM,TFD_ATTR_ADD})
			table.insert(ptfdsAfter,TFD_ATTR_NUM)
		end

		-- local p1 = tonumber(tNewHeroArgs.force_values.life) - tonumber(tForceValue.life)
		-- local p2 = tonumber(tNewHeroArgs.force_values.physicalAttack) - tonumber(tForceValue.physicalAttack)
		-- local p3 = tonumber(tNewHeroArgs.force_values.magicAttack) - tonumber(tForceValue.magicAttack)
		-- local p4 = tonumber(tNewHeroArgs.force_values.physicalDefend) - tonumber(tForceValue.physicalDefend)
		-- local p5 = tonumber(tNewHeroArgs.force_values.magicDefend) - tonumber(tForceValue.magicDefend)
		--初始化进阶后 进阶成功界面所需要显示的信息





		local p1 = tonumber(tAfterData.life)
		local p2 = tonumber(tAfterData.phyAttack) 
		local p3 = tonumber(tAfterData.magicAttack) 
		local p4 = tonumber(tAfterData.phyDefned) 
		local p5 = tonumber(tAfterData.magicDefend)

		ptfdsAfter[1]:setText(p1)
		ptfdsAfter[2]:setText(p2)
		ptfdsAfter[3]:setText(p3)
		ptfdsAfter[4]:setText(p4)
		ptfdsAfter[5]:setText(p5)

    	-- 新增潜能 羁绊 技能描述
		local TFD_ABILITY_AWAKE = m_fnGetWidgetByName(newPropertyPart,"TFD_ABILITY_AWAKE")
		--TFD_JIBAN:setText(m_i18n[1152])
		fnlabelNewStroke(TFD_ABILITY_AWAKE)
		TFD_ABILITY_AWAKE:setText(m_i18n[1162])

		local TFD_JIBAN = m_fnGetWidgetByName(newPropertyPart,"TFD_JIBAN")
		--TFD_JIBAN:setText(m_i18n[1152])
		fnlabelNewStroke(TFD_JIBAN)
		TFD_JIBAN:setText(m_i18n[1165])
		--UIHelper.labelNewStroke(TFD_JIBAN , ccc3( 0x28 , 0x0e , 0x04))

		local TFD_JIBAN_UP = m_fnGetWidgetByName(newPropertyPart,"TFD_JIBAN_UP")
		--TFD_JIBAN_UP:setText(m_i18n[1153])
		fnlabelNewStroke(TFD_JIBAN_UP)
		--TFD_JIBAN_UP:setColor(ccc3(0xff,0xfa,0x00))
		TFD_JIBAN_UP:setText(m_i18n[1166])
		--UIHelper.labelNewStroke(TFD_JIBAN_UP , ccc3( 0x28 , 0x0e , 0x04))

		local TFD_SKILL_UP = m_fnGetWidgetByName(newPropertyPart,"TFD_SKILL_UP")
		-- TFD_SKILL_UP:setText(m_i18n[1154])
		fnlabelNewStroke(TFD_SKILL_UP)
		TFD_SKILL_UP:setText(m_i18n[1167])
		--UIHelper.labelNewStroke(TFD_SKILL_UP , ccc3( 0x28 , 0x0e , 0x04))

		local TFD_ANGER_NAME = m_fnGetWidgetByName(newPropertyPart,"TFD_ANGER_NAME")
		fnlabelNewStroke(TFD_ANGER_NAME)
		TFD_ANGER_NAME:setText("")
		TFD_ANGER_NAME:setColor(ccc3(0xff,0xea,0x00))
		local TFD_ANGER_INFO = m_fnGetWidgetByName(newPropertyPart,"TFD_ANGER_INFO")
		fnlabelNewStroke(TFD_ANGER_INFO)
		TFD_ANGER_INFO:setColor(ccc3(0xff,0xea,0x00))
		TFD_ANGER_INFO:setText("")


		--进阶后伙伴数据
		--if (tNewHeroArgs and m_afterTb) then --可进阶new_htid
		local skilAngerText = skill.getDataById(tAfterData.rage_skill_attack)

		TFD_ANGER_NAME:setText(skilAngerText.name)
		local pDB_break = m_fnGetDB_break(m_tbHeroAttr)
		TFD_ANGER_INFO:setText(pDB_break.anger_skill or "")
		-- else
		-- 	btnList:setTouchEnabled(false)
		-- 	btnList:setVisible(false)
		-- end
		local tfdAfterName = m_fnGetWidgetByName(newPropertyPart, "TFD_PARTNER_NAME")
		tfdAfterName:setVisible(true)
		local tfdAfterAdvanceLv = m_fnGetWidgetByName(newPropertyPart, "TFD_ADVANCE_LV")
		tfdAfterAdvanceLv:setVisible(true)

		local pQulity2 = tonumber(tAfterData.starLv) or 3
		tfdAfterName:setColor(g_QulityColor2[pQulity2])
		tfdAfterName:setText(tAfterData.m_afterTb.name or "")
		tfdAfterName:setColor(g_QulityColor2[pQulity2])
		tfdAfterName:setFontSize(26)
		UIHelper.labelNewStroke(tfdAfterName , ccc3( 0x28 , 0x00 , 0x00))
		local pEvoLv = m_tbHeroAttr.evolve_level or 0
		tfdAfterAdvanceLv:setText("+"..pEvoLv)
		tfdAfterAdvanceLv:setColor(g_QulityColor2[pQulity2])
		tfdAfterAdvanceLv:setFontSize(26)
		UIHelper.labelNewStroke(tfdAfterAdvanceLv , ccc3( 0x28 , 0x00 , 0x00))

		-- 新增潜能
		local TFD_ABILITY_NAME = m_fnGetWidgetByName(newPropertyPart, "TFD_ABILITY_NAME")
		TFD_ABILITY_NAME:setVisible(true)
		fnlabelNewStroke(TFD_ABILITY_NAME)
		local TFD_ABILITY_INFO = m_fnGetWidgetByName(newPropertyPart, "TFD_ABILITY_INFO")
		TFD_ABILITY_INFO:setVisible(true)


		--突破后伙伴数据
		if (tAfterData.m_afterTb) then --可进阶new_htid
			if(tAfterData.awakeInfo and tAfterData.awakeOpen) then
				TFD_ABILITY_NAME:setText(tAfterData.wakeName)

			    local sizeInfo = TFD_ABILITY_INFO:getSize()
			    --local sAttr = tAfterData.des .. tAfterData.awakeOpen 
			    local sAttr = tAfterData.des

			    local labAttr = UIHelper.createUILabel( sAttr, g_sFontCuYuan, 22, ccc3(0xff,0xea,0x00))
				labAttr:setAnchorPoint(ccp(0, 1))
				labAttr:setPosition(ccp(-0.5 * sizeInfo.width, sizeInfo.height * 0.65))
				labAttr:ignoreContentAdaptWithSize(false)
				labAttr:setSize(CCSizeMake(sizeInfo.width * 0.9, 0))
				local rSize = labAttr:getVirtualRenderer():getContentSize()
				labAttr:setSize(CCSizeMake(rSize.width, rSize.height))
				--TFD_ABILITY_INFO:addChild(labAttr)
			    TFD_ABILITY_INFO:setSize(CCSizeMake(TFD_ABILITY_INFO:getSize().width,rSize.height * 1.15))

				TFD_ABILITY_INFO:setText(sAttr)
				--TFD_ABILITY_INFO:setColor(ccc3(0xff,0xea,0x00))
				fnlabelNewStroke(TFD_ABILITY_INFO)
				--TFD_ABILITY_LIMIT:setText(tNewHeroArgs.awakeOpen)
			else
				TFD_ABILITY_NAME:setText(m_i18n[1093])
				TFD_ABILITY_INFO:setVisible(false)
			end
		else
			btnList:setTouchEnabled(false)
			btnList:setVisible(false)
			tfdAfterName:setVisible(false)
			TFD_ABILITY_NAME:setVisible(false)
			-- TFD_ABILITY_LIMIT:setVisible(false)
			TFD_ABILITY_INFO:setVisible(false)
		end
		--TFD_ABILITY_NAME:setColor(ccc3(0xff,0xff,0x66))
		--TFD_ABILITY_NAME:setFontSize(26)
		--UIHelper.labelNewStroke(TFD_ABILITY_NAME , ccc3( 0xd9 , 0x29 , 0x00),3)


		--TFD_ABILITY_INFO:setColor(ccc3(0xf7,0xd2,0x8e))
		TFD_ABILITY_INFO:setFontSize(22)
		UIHelper.labelNewStroke(TFD_ABILITY_INFO , ccc3( 0x28 , 0x00 , 0x00))
	else
		newPropertyPart:setEnabled(false)
		IMG_ARROW:setEnabled(false)
	end

end

local function fnInitModel( ... )
	local layModel =  m_fnGetWidgetByName(partner_break, "LAY_PARTNER")

	local BTN_PREVIEW = m_fnGetWidgetByName(layModel, "BTN_PREVIEW")
	BTN_PREVIEW:addTouchEventListener(function (sender ,eventType )
		if eventType == TOUCH_EVENT_ENDED then
			-- AudioHelper.playInfoEffect()
			AudioHelper.playCommonEffect()
			require "script/module/partner/PartnerBreakPreview"
			local breakPreview = PartnerBreakPreview:new()
			LayerManager.addLayout(breakPreview:create())
		end
	end)

	-- 突破钱的英雄信息
	layBeforeHeroBody = m_fnGetWidgetByName(layModel, "IMG_BEFORE")
	layBeforeHeroBody:loadTexture("images/base/hero/body_img/" .. tPreData.body_img_id)
	layBeforeHeroBody:setTouchEnabled(true)
	layBeforeHeroBody:addTouchEventListener(function (sender ,eventType )
		if eventType == TOUCH_EVENT_ENDED then
			AudioHelper.playInfoEffect()
			-- 现实进阶伙伴信息
			require "script/module/partner/PartnerInfoCtrl"
	        local pHeroValue = m_tbHeroAttr --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
	        local tbherosInfo = {}
	        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.hid ,strengthenLevel = pHeroValue.level ,transLevel = pHeroValue.evolve_level}
	        local tArgs = {}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)

		end
	end)

	--mUI.fnPlayHuxiAni(layBeforeHeroBody)

	local pQulity = tonumber(tPreData.star_lv) or 3
	local tfdScore = m_fnGetWidgetByName(layModel, "TFD_BEFORE_SCORE")
	tfdScore:setText(m_i18n[1003])
	tfdScore:setColor(ccc3(0xf7,0xd2,0x8e))
	tfdScore:setFontSize(22)


	local pEvoLv = tPreData.heroQuality or 1
	local tfdPreNum = m_fnGetWidgetByName(layModel, "TFD_BEFORE_SCORE_NUM")
	tfdPreNum:setColor(ccc3(0xf7,0xd2,0x8e))
	tfdPreNum:setFontSize(22)
	tfdPreNum:setText(pEvoLv)


	-- 突破后的英雄信息
	if (tAfterData.m_afterTb) then
		layAfterHeroBody = m_fnGetWidgetByName(layModel, "IMG_AFTER")
		layAfterHeroBody:loadTexture("images/base/hero/body_img/" .. tAfterData.body_img_id)
		layAfterHeroBody:setOpacity(255 * 0.5)
		layAfterHeroBody:getVirtualRenderer():setScale(0.9)
		layAfterHeroBody:setTouchEnabled(true)
		layAfterHeroBody:addTouchEventListener(function (sender ,eventType )
			if eventType == TOUCH_EVENT_ENDED then
				AudioHelper.playInfoEffect()
				-- 现实进阶伙伴信息
				require "script/module/partner/PartnerInfoCtrl"
		        local pHeroValue = tNewHeroArgs --PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
		        local tbherosInfo = {}
		        local heroInfo = {htid = pHeroValue.htid ,hid = pHeroValue.hid,strengthenLevel = pHeroValue.level ,transLevel = pHeroValue.evolve_level,readOnly = true ,heroValue = pHeroValue}
		        table.insert(tbherosInfo,heroInfo)
		        local tArgs = {}
		        tArgs.heroInfo = heroInfo
		        local layer = PartnerInfoCtrl.create(tArgs,4)     --所选择武将信息22
		        LayerManager.addLayoutNoScale(layer)

			end
		end)

		--mUI.fnPlayHuxiAni(layAfterHeroBody)

		local pQulity2 = tonumber(tAfterData.quality) or 3
		-- local TFD_BEFORE_COLOR = m_fnGetWidgetByName(layModel, "TFD_AFTER_COLOR")
		-- TFD_BEFORE_COLOR:setColor(g_QulityColor2[pQulity2])
		-- TFD_BEFORE_COLOR:setText("橙色伙伴") --wm_todo
		local tfdScore = m_fnGetWidgetByName(layModel, "TFD_AFTER_SCORE")
		--tfdScore:setColor(g_QulityColor2[pQulity2])
		tfdScore:setText(m_i18n[1003])
		tfdScore:setColor(ccc3(0xf7,0xd2,0x8e))
		tfdScore:setFontSize(22)
		local pEvoLv = tAfterData.heroQuality or 1
		local tfafterNum = m_fnGetWidgetByName(layModel, "TFD_AFTER_SCORE_NUM")
		--tfafterNum:setColor(g_QulityColor2[pQulity2])
		tfafterNum:setColor(ccc3(0xf7,0xd2,0x8e))
		tfafterNum:setFontSize(22)
		tfafterNum:setText(pEvoLv)
	else
		layAfterHeroBody:setEnabled(false)
	end

	--local tfdOwnBelly = m_fnGetWidgetByName(partner_break, "TFD_BELLY_OWN_NUM")
	--tfdOwnBelly:setText(UserModel.getSilverNumber())

end

function changepPaomao( ... )
	LayerManager.setPaomadeng(partner_break, 0)
	mUI.registExitAndEnterCall(partner_break, function ( ... )
		LayerManager.resetPaomadeng()
	end)
end

function fnFresh( tParam , srcType , srcLocation)
	if (srcType) then
		numSourceType = srcType
		numSrcLocation = srcLocation
	else
		numSourceType  = 1
	end

	initLay()

	for k,v in pairs(buttonInfos) do
		v:setTouchEnabled(true)
	end
	nListViewItemTouchAble = true

	-- local layModel =  m_fnGetWidgetByName(partner_break, "lay_hero_transfer_model")
	-- for i=1,4 do
	-- 	local btnlay = m_fnGetWidgetByName(layModel, "BTN_TRANSFER_CONSUME_ICON_BG_" .. i)
	-- 	btnlay:setTouchEnabled(true)
	-- end

	-- local btnTransferStar = m_fnGetWidgetByName(partner_break, "BTN_TRANSFER_STAR")
	-- btnTransferStar:setTouchEnabled(true)

	-- local btnBack = m_fnGetWidgetByName(partner_break, "BTN_TRANSFER_CLOSE")
	-- btnBack:setTouchEnabled(true)

	local BTN_PREVIEW = m_fnGetWidgetByName(partner_break, "BTN_PREVIEW")
	BTN_PREVIEW:setTouchEnabled(true)
	local BTN_INFORMATION = m_fnGetWidgetByName(partner_break, "BTN_INFORMATION")
	BTN_INFORMATION:setTouchEnabled(true)


	layBeforeHeroBody:setTouchEnabled(true)
	layAfterHeroBody:setTouchEnabled(true)
end

-- 初始化各部分lay
function initLay()
	fnInitTb()  -- 初始化所需要的数据
	fnInitModel()  -- 显示突破前后伙伴图片信息
	--funInitLayPatner()  --  显示图像和突破信息部分
	--funInitLaySkill()  -- 显示突破技能信息部分
	fnInitBeforeProperty()  -- 显示突破前属性值部分
	fnInitAfterProperty()  -- 显示突破后属性值部分
	fnInitConsum()  --  显示最后消费部分
end


--tParam: 来自MainPartner 的所选择的武将的信息
function create( tParam,srcType,srcLocation )
	_formerModuleName = LayerManager.curModuleName()

	if (srcType) then
		numSourceType = srcType
		numSrcLocation = srcLocation
	else
		numSourceType  = 1
	end

	init(tParam)
	-- 从其他界面返回 重建页面
	-- tParam 为初始化页面的参数
	local resumLayerFn = function ( ... )
	    local layer = create(tParam,srcType,srcLocation)
     
	   	LayerManager.changeModule(layer, moduleName(), {1}, true)
	   	PlayerPanel.addForPartnerStrength()
	   	changepPaomao()
	end


	partner_break = mUILoad("ui/break_main.json")
	if (partner_break) then
		partner_break:setSize(g_winSize)
		if(g_winSize.width ~= 640) then
			local layBg = m_fnGetWidgetByName(partner_break, "IMG_BG")
			layBg:setScale(g_winSize.width/640)
		end
	end

	local btnBack = m_fnGetWidgetByName(partner_break, "BTN_CLOSE")
	btnBack:addTouchEventListener(onBtnBreakBack)

	initLay()

	return partner_break
end





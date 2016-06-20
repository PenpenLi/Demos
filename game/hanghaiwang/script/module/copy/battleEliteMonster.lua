-- FileName: battleEliteMonster.lua
-- Author:liwedong
-- Date: 2014-12-19
-- Purpose: 精英副本开始战斗前确认界面
--[[TODO List]]

module("battleEliteMonster", package.seeall)

require "script/module/copy/MainCopy"

-- UI控件引用变量 --
local elitecpLayer

-- 模块局部变量 --
local curCopyId --当前精英副本的id
local copyItemData --副本db信息
local baseItemInfo --据点信息

local copyWithEliteDrop = "ui/elite_drop.json"

function init(...)
	copyItemData = DB_Elitecopy.getDataById(curCopyId)
	if (copyItemData.baseids) then
		baseItemInfo = DB_Stronghold.getDataById(copyItemData.baseids)
	end
	elitecpLayer.TFD_POWER_NUM:setText(copyItemData.energy)
	elitecpLayer.TFD_NUM_MONEY1:setText(math.floor(baseItemInfo.coin_simple*OutputMultiplyUtil.getMultiplyRateNum(12)/10000))
	elitecpLayer.TFD_EXP_NUM:setText(math.floor(baseItemInfo.exp_simple*UserModel.getHeroLevel()*OutputMultiplyUtil.getMultiplyRateNum(12)/10000))

	elitecpLayer.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
			AudioHelper.playStrategy()
				local baseDb = baseItemInfo
				local baseName = baseDb.name
				tbData={
			        type=2,-- 类型 普通副本＝1，精英副本＝2，觉醒副本＝3，深海＝4，世界boss＝5,
			        name = baseName, --据点名称（世界boss传boss名称，深海传当前层：第xx层）,
			        param1 = curCopyId, --普通副本，精英副本，觉醒副本传副本ID；深海传当前层数，世界boss传boss ID
			        param2 = copyItemData.baseids, --普通副本，觉醒副本传据点id ，其他模块不用传
			        param3 = nil, --普通副本 传据点难度，其他不需要
			        callback1 = nil,--攻略页面点查看战报时调用，可传nil，,   (用于世界boss处理音乐)
			        callback2 = nil, --查看战报战斗播放结束，结算面板关闭时调用，可传nil, (用于世界boss处理音乐)
			    }
				StrategyCtrl.create( tbData )
			end)

end
--获取精英副本需要扣除的体力
function getEliteConstEnergy()
	return copyItemData.energy
end
function destroy(...)
	package.loaded["battleEliteMonster"] = nil
end

function moduleName()
	return "battleEliteMonster"
end

local onBtnClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		LayerManager.removeLayout()
		AudioHelper.playBackEffect()
	end
end

--[[
    @desc   战斗的回调
    @para   void
    @return void
--]]
local getBattleCallback = function ( tbNewCopyBase, blisWin, tbextraReward )
	if(blisWin) then
		local defeatNum = DataCache.getEliteCopyLeftNum()
		defeatNum = defeatNum - 1 >= 0 and - 1 or 0
		DataCache.addCanDefatNum(defeatNum)
		MainCopy.eliteOpenData(curCopyId)
		MainCopy.updateInit()
		MainCopy.updateBGSize()
		MainCopy.resetScrollOffset()
	end
end

local onBtnFight = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		if (GuideModel.getGuideClass() == ksGuideEliteCopy and GuideEliteView.guideStep == 4) then
			require "script/module/guide/GuideCtrl"
			GuideCtrl.removeGuide()
		end
		AudioHelper.playBtnEffect("start_fight.mp3")
		MainCopy.setScrollOffset()
		require "script/module/guide/GuideCtrl"
		GuideCtrl.removeGuideView()
		local tbUserInfo = UserModel.getUserInfo()
		-- 检查体力是否足够
		if (tonumber(tbUserInfo.execution) < getEliteConstEnergy()) then --tonumber(baseItemInfo.cost_energy_simple)) then 
			require "script/module/copy/copyUsePills"
			LayerManager.addLayout(copyUsePills.create())
			return
		end
		-- 检查背包是否已满
		local isShowAlert = true
		if (ItemUtil.isBagFull(isShowAlert)) then
		-- if (ItemUtil.isSpecialTreasBagFull(isShowAlert) or ItemUtil.isSpecialTreasFragBagFull(isShowAlert) or ItemUtil.isPropBagFull(isShowAlert) or ItemUtil.isPartnerFull(isShowAlert) or ItemUtil.isEquipBagFull(isShowAlert) or ItemUtil.isTreasBagFull(isShowAlert) or ItemUtil.isArmFragBagFull(isShowAlert)) then -- 改为检测所有背包 liweidong (ItemUtil.isBagFullExPartner(true)) then
			return
		end
		LayerManager.removeLayout()
		PreRequest.setIsCanShowAchieveTip(false)
		require "script/battle/BattleModule"
		BattleModule.playCopyStyleBattle(curCopyId, baseItemInfo.id, 1, getBattleCallback, COPY_TYPE_ECOPY) --最后的2是副本类型 2精英副本、1普通副本、4贝利副本、3普通活动副本
	end
end

--副本信息
local function fnCopyInfoLayer( ... )
	--头像部分
	local imgFrame = g_fnGetWidgetByName(elitecpLayer, "IMG_FRAME")
	local imgHead = g_fnGetWidgetByName(elitecpLayer, "IMG_HEAD")

	imgFrame:loadTexture(armyBorderPath.."3.png")
	imgFrame:setPositionType(POSITION_ABSOLUTE)
	imgFrame:setPosition(ccp(0, 1))

	imgHead:loadTexture(HeroheadPath..baseItemInfo.icon)

	--信息部分
	local tfdName = g_fnGetWidgetByName(elitecpLayer, "TFD_NAME")
	-- local tfdSilver = g_fnGetWidgetByName(elitecpLayer, "TFD_SILVER_NUM")
	-- local tfdSoulNum = g_fnGetWidgetByName(elitecpLayer, "TFD_CARD_NUM")

	tfdName:setText(copyItemData.name or 0)
	-- tfdSilver:setText(baseItemInfo.coin_normal or 0)
	-- tfdSoulNum:setText(lua_string_split(baseItemInfo.normal_exp_card, "|")[2] or 0)

	-- UIHelper.labelStroke(tfdName)
	-- UIHelper.labelShadow(tfdName,CCSizeMake(4,-4))

	-- UIHelper.labelStroke(tfdSilver)
	-- UIHelper.labelStroke(tfdSoulNum)
end

--副本掉落
local function fnCopyDropLayer( ... )
	local scvScroll = g_fnGetWidgetByName(elitecpLayer, "SCV_DROP")
	local layContent = g_fnGetWidgetByName(elitecpLayer, "LAY_CONTENT_SIZE")
	local scvW = scvScroll:getInnerContainerSize().width
	local svnH = scvScroll:getInnerContainerSize().height
	local layDrop = g_fnGetWidgetByName(elitecpLayer, "LAY_DROP1")
	local tfdDrop = g_fnGetWidgetByName(elitecpLayer, "tfd_drop")
	tfdDrop:setText(gi18n[1305])
	--UIHelper.labelShadow(tfdDrop)

	if(baseItemInfo.reward_item_id_simple ~= nil) then

		local simReward = baseItemInfo.reward_item_id_simple
		local dropIdArr = lua_string_split(simReward,",")
		local _,otherRewardIds = OutputMultiplyUtil.getAdditionalDrop()
		if (otherRewardIds) then
			for _,id in ipairs(otherRewardIds) do
				dropIdArr[#dropIdArr+1] = id
			end
		end
		local dropCount = #dropIdArr

		--计算scv高度
		local cellHeight = layDrop:getSize().height --+ 10
		if( dropCount > 10) then
			svnH = math.ceil(dropCount/5)  * cellHeight * g_fScaleX
			scvScroll:setInnerContainerSize(CCSizeMake(scvW, svnH))
			scvScroll:jumpToTop()
			layContent:setSize(CCSizeMake(scvW, svnH))
		else
			scvScroll:setBounceEnabled(false)
		end

		--开始物品布局
		for k,v in ipairs(dropIdArr) do
			local dropIds = lua_string_split(dropIdArr[k],"|")
			if (dropIds[1] ~= nil) then
				local layDropCell = layDrop:clone()
				layContent:addChild(layDropCell)
				-- layDropCell:setPositionType(POSITION_ABSOLUTE)
				local percentW = ((0 + layDropCell:getSize().width) * math.fmod(k-1,5) + 0) / scvW
				local percentH = 1 - cellHeight * math.ceil(k/5) / layContent:getSize().height
				layDropCell:setPositionPercent(ccp(percentW,percentH))

				local layImage = g_fnGetWidgetByName(layDropCell, "IMG_1")
				local soulItem,soulInfo = ItemUtil.createBtnByTemplateId(dropIds[1],
					function ( sender,eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							PublicInfoCtrl.createItemInfoViewByTid(tonumber(dropIds[1]))
						end
					end
					)
				soulItem:setTag(k)
				layImage:addChild(soulItem)

				local goodsTitle = g_fnGetWidgetByName(layDropCell, "TFD_NAME_1")
				if (goodsTitle) then
					UIHelper.labelEffect(goodsTitle,soulInfo.name)
					if (soulInfo.quality ~= nil) then
						local color =  g_QulityColor[tonumber(soulInfo.quality)]
						if(color ~= nil) then
							goodsTitle:setColor(color)
						end
					end
				end
			end
		end

	end

	layDrop:setVisible(false)
end

function create( copyId )
	require "script/module/copy/copyWin"
	copyWin.battalCopyType=2 --战斗类型为精英副本
	
	curCopyId = copyId

	

	elitecpLayer = g_fnLoadUI(copyWithEliteDrop)
	UIHelper.registExitAndEnterCall(elitecpLayer, nil,function ( ... )
				elitecpLayer=nil
			end)
	init()
	
	local btnClose = g_fnGetWidgetByName(elitecpLayer, "BTN_CLOSE")
	btnClose:addTouchEventListener(onBtnClose)

	local btnFight = g_fnGetWidgetByName(elitecpLayer, "BTN_FIGHT")
	btnFight:addTouchEventListener(onBtnFight)
	UIHelper.titleShadow(btnFight,gi18n[1308])

	if (copyItemData and baseItemInfo) then
		fnCopyInfoLayer()

		fnCopyDropLayer()
	end
	

	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideEliteView"
	if (GuideModel.getGuideClass() == ksGuideEliteCopy and GuideEliteView.guideStep == 3) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createEliteGuide(4)
	end
	
	return elitecpLayer
end

-- FileName: treaInfoView.lua
-- Author:menghao
-- Date: 2014-04-00
-- Purpose: 宝物信息UI模块
--[[TODO List]]

module("treaInfoView", package.seeall)

-- UI控件引用变量 --
local jsonTreaFetter = "ui/treasure_fetter.json"
local m_mainView
local layLsvMain
local tbRatainedUI = {}

-- 模块局部变量 --
local tbTreaInfo --当前界面所需要的数据
local jsonFetterBool = false --区分是否存在羁绊
local fnOnCallBack --点击事件集合
local numStarCout = 5 --宝物的星级总数
local numProCout = 2 --宝物的属性最大值
local numProUnlock = 5 --解锁属性最大值
local numSrcType --来源类型
local m_nHeroLv -- 装备此宝物的伙伴等级
local _isChangeBtnTip = false -- 更换按钮的红点是否显示

local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_fromType = g_treaInfoFrom


local function init(...)

end

function destroy(...)
	package.loaded["treaInfoView"] = nil
end

function moduleName()
	return "treaInfoView"
end

function fnlabelNewStroke( widget )
	UIHelper.labelNewStroke(widget,ccc3(0x92,0x53,0x1b),2)
end

--根据星级隐藏图标
local function fnHiddenStar( infoLayer,starLevel )
	for i=1,numStarCout do
		if (starLevel < i) then
			local imgStar = m_fnGetWidget(infoLayer,"IMG_STAR_" .. i)
			imgStar:setVisible(false)
		end
	end
end

--底部按钮控制
local function fnLayBottom( layBtns )
	local layFromFor = m_fnGetWidget(layBtns,"LAY_BTNS_FROMFOR")       -- 阵容界面
	local layFromInfo = m_fnGetWidget(layBtns,"LAY_BTNS_FROMINFO")     -- 背包界面
	local layFromRob = m_fnGetWidget(layBtns,"LAY_BTNS_FROMROB")       -- 夺宝界面
	local layFromRefine = m_fnGetWidget(layBtns,"LAY_BTNS_FROMREFINE") -- 精炼界面

	logger:debug({fnLayBottom_numSrcType=numSrcType})
	logger:debug({fnLayBottom_numSrcType=m_fromType.layFromOtherType})

	-- 获取途径 可进阶 1
	if (numSrcType == 1) then 
		local btnClose = m_fnGetWidget(layFromInfo,"BTN_CLOSE_INFO")
		local btnChangded = UIHelper.chagneGuildTOOk(btnClose)
		if (not btnChangded) then
			btnClose:addTouchEventListener(fnOnCallBack.onDrop)

		 	UIHelper.titleShadow(btnClose,m_i18n[1098])

			layFromFor:removeFromParent()
			layFromRob:removeFromParent()
			layFromRefine:removeFromParent()
		end
	-- 确定，可进阶 2
	elseif(numSrcType == 2) then
		local btnUnload = m_fnGetWidget(layFromFor,"BTN_UNLOAD")
		btnUnload:addTouchEventListener(fnOnCallBack.onBtnUnload)
		UIHelper.titleShadow(btnUnload,m_i18n[1710])

		local btnChange = m_fnGetWidget(layFromFor, "BTN_CHANGE")
		btnChange:addTouchEventListener(fnOnCallBack.onChange)
		UIHelper.titleShadow(btnChange,m_i18n[1638])

		-- 红点
		if (_isChangeBtnTip == true) then
			if(not btnChange.IMG_CHANGE_TIP:getNodeByTag(10)) then
				local tip = UIHelper.createRedTipAnimination()
				tip:setTag(10)
				btnChange.IMG_CHANGE_TIP:addNode(tip,10)
			end
		end
		btnChange.IMG_CHANGE_TIP:setVisible(_isChangeBtnTip)

		layFromInfo:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()

	-- 确定，不可进阶 3
	elseif (numSrcType == 3) then         -- 确定,信息面板用这个
		local btnClose = m_fnGetWidget(layFromInfo, "BTN_CLOSE_INFO")

		local curModuleName = LayerManager.curModuleName()
    	local isPlaying = BattleState.isPlaying()
    	logger:debug({isPlaying = isPlaying})
    	logger:debug({curModuleName = curModuleName})

		UIHelper.titleShadow(btnClose,m_i18n[1029])
		btnClose:addTouchEventListener(fnOnCallBack.onBtnOK)
		layFromFor:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()
	-- 获取途径，不可进阶 4
	elseif (numSrcType == 4) then         -- 确定,信息面板用这个
		local btnClose = m_fnGetWidget(layFromInfo, "BTN_CLOSE_INFO")

		local curModuleName = LayerManager.curModuleName()
    	local isPlaying = BattleState.isPlaying()
    	logger:debug({isPlaying = isPlaying})
    	logger:debug({curModuleName = curModuleName})

		-- 碎片背包
		if (curModuleName == "MainTreaBagCtrl" or not isPlaying) then
			local btnChangded = UIHelper.chagneGuildTOOk(btnClose)
			if (not btnChangded) then
				UIHelper.titleShadow(btnClose,m_i18n[1098])
				btnClose:addTouchEventListener(fnOnCallBack.onDrop)
			end
		else
			UIHelper.titleShadow(btnClose,m_i18n[1029])
			btnClose:addTouchEventListener(fnOnCallBack.onBtnOK)
		end
		layFromFor:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()
	-- 抢夺 ，不可进阶  5
	elseif(numSrcType == 5) then
		layFromFor:removeFromParent()
		layFromInfo:removeFromParent()
		layFromRefine:removeFromParent()

		local btnRob = m_fnGetWidget(layFromRefine, "BTN_ROB")
		btnRob:addTouchEventListener(fnOnCallBack.onBtnRob)
		
	else
		local btnClose = m_fnGetWidget(layFromInfo,"BTN_CLOSE_INFO")
		btnClose:addTouchEventListener(fnOnCallBack.onBtnOK)
		layFromFor:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()
	end
end

-- 判断是否有基本属性
local function fnGetBaseInfoLayer( m_layBase ,forgeUnlock)
	local imgPaperTitle = m_layBase.img_paper_title
	local tfdBaseAttr = m_layBase.tfd_base_attr
	tfdBaseAttr:setText(m_i18n[1073])
	fnlabelNewStroke(tfdBaseAttr)

	for i,v in ipairs(forgeUnlock or {}) do
		local unLockLevel = tonumber(v.unLockLevel)

		if (unLockLevel == 0) then

			local lay_base_fit = m_layBase.lay_base_fit
			local tfdBase = lay_base_fit.TFD_BASE_ATTR1
			local tfdBaseNum = lay_base_fit.TFD_BASE_ATTR1_NUM

			tfdBase:setText(v.baseInfo.displayName)
			tfdBaseNum:setText(v.displayNum)

			layLsvMain:pushBackCustomItem(m_layBase)
			return
		end

	end

end 


-- 判断是否有强化属性
local function fnGetStrLayer( m_layStr )
	local tfdExpAttr = m_fnGetWidget(m_layStr,"TFD_ATTR_EXP")
	local tfdExpNum = m_fnGetWidget(m_layStr,"TFD_ATTR_EXP_NUM")
	local tfdattr = m_fnGetWidget(m_layStr,"tfd_attr")
	tfdattr:setText(m_i18n[1679])
	fnlabelNewStroke(tfdattr)

	local btnPreview = m_fnGetWidget(m_layStr,"BTN_STRENGTHEN")
	UIHelper.titleShadow(btnPreview,m_i18n[1054])
	btnPreview:addTouchEventListener(fnOnCallBack.onBtnForge)

	if (numSrcType ~= 1  and numSrcType ~= 2) then
		btnPreview:setEnabled(false)
	end

	for i=1,numProCout do
		local tfdAttr = m_fnGetWidget(m_layStr,"TFD_ATTR" .. i)
		local tfdNum = m_fnGetWidget(m_layStr,"TFD_ATTR" .. i .. "_NUM")

		tfdAttr:setEnabled(false)
		tfdNum:setEnabled(false)
	end

	tfdExpAttr:setEnabled(false)
	tfdExpNum:setEnabled(false)

	local treasureLv = m_fnGetWidget(m_layStr,"TFD_LV_NUM")
	local treaDb = tbTreaInfo.treaData.dbData
	local curMaxLv

	if (treaDb.level_interval ~= 0) then
		local hLv = m_nHeroLv or UserModel.getHeroLevel()
		curMaxLv = math.floor(hLv / treaDb.level_interval)
		if (curMaxLv > treaDb.level_limited) then
			curMaxLv = treaDb.level_limited
		end
	else
		curMaxLv = treaDb.level_limited
	end

	treasureLv:setText(tbTreaInfo.level .. "/" .. curMaxLv)

	if (not tbTreaInfo.isExpTreasure) then
		local tbPro = tbTreaInfo.property
		for i=1,#tbPro do

			local tfdAttr = m_fnGetWidget(m_layStr,"TFD_ATTR" .. i)
			local tfdNum = m_fnGetWidget(m_layStr,"TFD_ATTR" .. i .. "_NUM")

			tfdAttr:setEnabled(true)
			tfdNum:setEnabled(true)

			tfdAttr:setText(tbPro[i].name)
			tfdNum:setText("+" .. tbPro[i].value)
		end
	else
		tfdExpAttr:setEnabled(true)
		tfdExpNum:setEnabled(true)

		local add_exp = tonumber(tbTreaInfo.exp) + tonumber(tbTreaInfo.treaData.va_item_text.treasureExp)
		tfdExpNum:setText("+" .. add_exp)
	end
	layLsvMain:pushBackCustomItem(m_layStr)
end


-- 判断是否有专属属性
local function fnGetZsLayer( layZhuanshu )
	if (tbTreaInfo.awakeInfo) then
		local tfdZhuanshuDes = m_fnGetWidget(layZhuanshu, "TFD_ZHUANSHU_DES")
		local tfdHeroName = m_fnGetWidget(layZhuanshu, "TFD_PARTNER_NAME_Z")
		local tfdTreaName = m_fnGetWidget(layZhuanshu, "TFD_TREASURE_NAME_Z")
		local tfdZhuanshu = m_fnGetWidget(layZhuanshu, "tfd_zhuanshu")
		fnlabelNewStroke(tfdZhuanshu)

		tfdZhuanshuDes:setText(tbTreaInfo.awakeInfo.awakeDes)

		tfdHeroName:setText(tbTreaInfo.awakeInfo.heroName)
		tfdHeroName:setColor(g_QulityColor[tbTreaInfo.awakeInfo.heroQuality])

		tfdTreaName:setText(tbTreaInfo.name)
		tfdTreaName:setColor(g_QulityColor[tonumber(tbTreaInfo.quality)])

		layLsvMain:pushBackCustomItem(layZhuanshu)
	end
end

-- 判断强化解锁属性
local function fnGetForgUnlock( layStarAbility,forgeUnlock )
	local layStarAbilitySize = layStarAbility:getContentSize()
	local layStarAbilitySizeHeight = layStarAbilitySize.height

	local img_paper_title = m_fnGetWidget(layStarAbility, "img_paper_title")
	fnlabelNewStroke(img_paper_title.TFD_ABILITY)

	local treaDb = tbTreaInfo.treaData.dbData
	local forgeUnlockTb = {}
	-- 删去等级为0的

	for i,v in ipairs(forgeUnlock or {}) do
		local unLockLevel = tonumber(v.unLockLevel)
		if (unLockLevel ~= 0) then
			initunLockLevel = initunLockLevel == 0 and unLockLevel
			table.insert(forgeUnlockTb,v)
		end
	end

	local desStrTb = {}
	local desStrLel = {}


	if (#forgeUnlockTb == 0) then
		return
	end

	local firstLayAbility = layStarAbility["LAY_ABILITY" .. 1]
	local LayAbilitySize = firstLayAbility:getContentSize()
	local LayAbilitySizeHeight = LayAbilitySize.height

	for i,v in ipairs(forgeUnlockTb or {}) do
		local unLockLevel = tonumber(v.unLockLevel)

		if (not desStrTb[unLockLevel]) then
			desStrTb[unLockLevel] = {}
		end
		table.insert(desStrTb[unLockLevel], v)
	end

	for k,v in pairs(desStrTb) do
		table.insert(desStrLel, k)
	end

    table.sort(
    			desStrLel, function (a,b) return tonumber(a) < tonumber(b) end
        	   )

	local abilityNums = 1
	for k,v in pairs(desStrLel or {}) do
		local tempDesTB = desStrTb[v]
		local tempDes = ""
		for i,tempDesInfo in ipairs(tempDesTB or {}) do
			local displayName = tempDesInfo.baseInfo.displayName
			local displayNum = tempDesInfo.displayNum

			if (i > 1) then
				tempDes = tempDes .. ","
			end
			tempDes = tempDes .. displayName .. "+" .. displayNum 
		end
		tempDes = tempDes .. "(" .. m_i18nString(1141,v)   .. ")"

		local layAbility = layStarAbility["LAY_ABILITY" .. abilityNums]
		local tfdAbility = layAbility.TFD_ABILITY
		tfdAbility:setText(tempDes)
		abilityNums = abilityNums + 1
	end

	local deleteH = 0
	for i= #desStrLel ,9 do
		local layAbility = layStarAbility["LAY_ABILITY" .. i]
		layAbility:removeFromParentAndCleanup(true)
		deleteH = deleteH + LayAbilitySizeHeight
	end

	layStarAbility:setSize(CCSizeMake(layStarAbilitySize.width,layStarAbilitySizeHeight - deleteH))
	layLsvMain:pushBackCustomItem(layStarAbility)

end 


--判断是否有精炼属性
function fnEvolveLayer( layJingLian )
	local tbEvolceInfo = tbTreaInfo.treaEvolve[1]

	local btnRefine =  m_fnGetWidget(layJingLian,"BTN_JINGLIAN")
	UIHelper.titleShadow(btnRefine,m_i18n[1705])
	btnRefine:addTouchEventListener(fnOnCallBack.onBtnFefining)
    
	local tfdJinglianTitle =  m_fnGetWidget(layJingLian,"tfd_jinglian_title")
	tfdJinglianTitle:setText(m_i18n[1707])
	fnlabelNewStroke(tfdJinglianTitle)

    local treaEvolveLv
    local treaData = tbTreaInfo.treaData

    logger:debug({fnEvolveLayer = fnEvolveLayer})

    if (treaData.va_item_text.treasureEvolve) then
	    treaEvolveLv = tonumber(treaData.va_item_text.treasureEvolve)
	end

	if (numSrcType ~= 1 and numSrcType ~= 2) then
		btnRefine:setEnabled(false)
	end

	if (treaEvolveLv ~= nil) then  --numSrcType ==5 表示从别人阵容入口查看精炼属性
		require "db/DB_Treasurerefine"
		local treaRefineDB =  DB_Treasurerefine.getDataById(tbTreaInfo.treaData.dbData.id)
		local refineLevelInterval = treaRefineDB.refine_interval
		local maxRefineLevel = 0
		if (tonumber(refineLevelInterval) == 0)	then
			maxRefineLevel = tonumber(treaRefineDB.max_upgrade_level)
		else
			maxRefineLevel = math.floor(tonumber(tbTreaInfo.level) / tonumber(refineLevelInterval))
		end

		local tbUpgradeAffix = lua_string_split(treaData.dbData.upgrade_affix, ",")
		local tbBaseArr = {}
		for i,upgradeAffix in ipairs(tbUpgradeAffix) do
			local tbAffix = {}
			local upgradeAffix = lua_string_split(upgradeAffix, "|")
			local upgradeAffixNum = tonumber(upgradeAffix[2]) * tonumber(treaEvolveLv)
			table.insert(tbAffix,upgradeAffix[1])
			table.insert(tbAffix,upgradeAffixNum)
			table.insert(tbBaseArr,tbAffix)
		end

		local treaUpgrade = treaEvolveLv .."/" .. (maxRefineLevel)
		local tfdPercent = m_fnGetWidget(layJingLian, "TFD_JINGLIANLV_NUM")
		tfdPercent:setText(treaUpgrade)
		for i = 1, 3 do
			local proBaseArr = tbBaseArr[i]
			local attrIndex = i + 6
			local tfdAttr = m_fnGetWidget(layJingLian, "TFD_ATTR" .. attrIndex)
			local tfdValue = m_fnGetWidget(layJingLian,"TFD_ATTR" .. attrIndex .. "_NUM")
				
			if (proBaseArr) then
				local baseInfo,displayNum,realNum = ItemUtil.getAttrNameAndValueDisplay(tonumber(proBaseArr[1]),tonumber(proBaseArr[2]))
				tfdAttr:setText(baseInfo)
				tfdValue:setText("+" .. displayNum)
			else
				tfdAttr:setEnabled(false)
				tfdValue:setEnabled(false)
			end
		end
		layLsvMain:pushBackCustomItem(layJingLian)
	end
end


--判读是否有宝物羁绊
local function fnGetUnionLayer( layJiBan )
	local unionInfo = treaInfoModel.fnGetUnionInfo(tbTreaInfo.treaData.dbData.union_info) -- zhangqi, 2015-06-15

	local layTotal = m_fnGetWidget(layJiBan,"LAY_CELL_TOTAL")
	local layCellTitle = m_fnGetWidget(layJiBan,"img_paper_title")
	local layCellSpace = 120

	local layBg = m_fnGetWidget(layJiBan,"IMG_JIBAN_PAPER_BG")
	local labBgSize = layBg:getSize()

	local layCellRef = m_fnGetWidget(layJiBan,"LAY_JIBAN_CELL")
	layCellRef:retain()
	table.insert(tbRatainedUI,layCellRef)

	local layCellHeiht = layCellRef:getSize().height
	local layInitSizeHeight = layCellTitle:getSize().height
	local layCellInitPosY = 180  -- 最顶上的cell 距离顶部距离
	local layCellPosY = layCellRef:getPositionY()       -- 最底下的cell 开始高度

	if (#unionInfo ~= 0) then
		for i = #unionInfo ,1 ,-1 do
			local tempUnion = unionInfo[i]

			local layCellCopy = layCellRef:clone()
			layCellRef:removeFromParentAndCleanup(true)

			local tfdPartnerName = m_fnGetWidget(layCellCopy,"TFD_PARTNER_NAME")
			tfdPartnerName:setColor(tempUnion.nameColor)
			tfdPartnerName:setText(tempUnion.heroName)
			UIHelper.labelStroke(tfdPartnerName)

			local tfdJiBanName = m_fnGetWidget(layCellCopy,"TFD_JIBAN_NAME")
			tfdJiBanName:setText(tempUnion.unionName)

			local tfdJiBanDes = m_fnGetWidget(layCellCopy,"TFD_JIBAN_DES")
			local tfdJiBanDesDb = string.split(tempUnion.unionDesc,",") or {"",""}
			-- tfdJiBanDes:setText(tfdJiBanDesDb[1]  ..  v.unionProfitNum .. "%," .. tfdJiBanDesDb[2] )

			tfdJiBanDes:setText(tfdJiBanDesDb[1]  ..  tempUnion.unionProfitNum .. "%," .. (#tfdJiBanDesDb > 1 and tfdJiBanDesDb[2] or ""))

			local layHero = m_fnGetWidget(layCellCopy,"LAY_PHOTO")
			tempUnion.itemIcon:setPosition(ccp(tempUnion.itemIcon:getSize().width/2,tempUnion.itemIcon:getSize().height/2))
			tempUnion.itemIcon:setTouchEnabled(false)
			layHero:addChild(tempUnion.itemIcon)

			layCellCopy:runAction(CCPlace:create(ccp(layCellCopy:getPositionX(),layCellPosY)))
			layCellPosY = layCellPosY + layCellSpace

			layTotal:addChild(layCellCopy)

		end
		
		layJiBan:setSize(CCSizeMake(layJiBan:getSize().width,layCellInitPosY + 120 * (#unionInfo -1)))
		layLsvMain:pushBackCustomItem(layJiBan)
	end

	local layCellTitleRef = layCellTitle:clone()
	local tfdJiban = m_fnGetWidget(layCellTitleRef,"tfd_jiban")
	tfdJiban:setText(m_i18n[1116])--  宝物羁绊 属性加成
	fnlabelNewStroke(tfdJiban)
	layCellTitleRef:runAction(CCPlace:create(ccp(labBgSize.width * 0.5,120 * (#unionInfo -1) + 160  )))
	layCellTitle:removeFromParentAndCleanup(true)
	layTotal:addChild(layCellTitleRef)

end
-- 显示简介
local  function fnGetInfoLayer( layInfo )
	local tfdDes = m_fnGetWidget(layInfo,"TFD_DES")
	local tfdDesTitle = m_fnGetWidget(layInfo,"tfd_des_title")
	tfdDesTitle:setText(m_i18n[1118])
	fnlabelNewStroke(tfdDesTitle)

	tfdDes:setText(tbTreaInfo.treaData.dbData.info)
	layLsvMain:pushBackCustomItem(layInfo)
end


--信息面板赋值
local function fnSetDataLayer( infoLayer )
	local nQuality = tonumber(tbTreaInfo.quality)
	local color = g_QulityColor2[nQuality]

	local treasImgName = m_fnGetWidget(infoLayer,"TFD_NAME1")
	treasImgName:setText(tbTreaInfo.name)
	treasImgName:setColor(color)
	UIHelper.labelNewStroke(treasImgName,ccc3(28,0,0))
	UIHelper.labelShadow(treasImgName,CCSizeMake(2,-2))


	local treasPinJiTxt = m_fnGetWidget(infoLayer,"TFD_PINJI_TXT")
	treasPinJiTxt:setText(m_i18n[4901])
	treasPinJiTxt:setColor(g_QulityColor3[nQuality])
	
	--UIHelper.labelNewStroke(treasPinJiTxt,ccc3(28,0,0))
	--UIHelper.labelShadow(treasPinJiTxt,CCSizeMake(2,-2))

	local treasPinJi = m_fnGetWidget(infoLayer,"TFD_PINJI")
	treasPinJi:setText(tbTreaInfo.base_score)
	treasPinJi:setColor(g_QulityColor3[nQuality])
	-- UIHelper.labelNewStroke(treasPinJi,ccc3(28,0,0))
	-- UIHelper.labelShadow(treasPinJi,CCSizeMake(2,-2))


	-- local qualityName = m_fnGetWidget(infoLayer,"TFD_QUALITY")
	-- local qualityNameI18n = g_QulityTextIndex[nQuality]
	-- qualityName:setText(m_i18n[qualityNameI18n])
	-- qualityName:setColor(color)
	-- UIHelper.labelNewStroke(qualityName,ccc3(28,0,0))
	-- UIHelper.labelShadow(qualityName,CCSizeMake(2,-2))
	local qualityImag = m_fnGetWidget(infoLayer,"IMG_QUALITY")
	qualityImag:loadTexture(g_QulityImageIndex[nQuality])


	local imgArm = m_fnGetWidget(infoLayer,"IMG_ARM")
	imgArm:loadTexture(tbTreaInfo.icon_big)
	UIHelper.runFloatAction(imgArm)

	local treaDb = tbTreaInfo.treaData.dbData

	-- local m_treasureType = m_fnGetWidget(infoLayer, "TFD_TREASURE_TYPE")
	local m_treasureType = m_fnGetWidget(infoLayer, "IMG_TREASURE_TYPE")

	if (treaDb.isExpTreasure) then
		m_treasureType:loadTexture("images/treasure/new_type/treasure_type_exp.png")
	else
		local treaType = treaDb.type
		logger:debug({treaType=treaType})
		m_treasureType:loadTexture("images/treasure/new_type/treasure_type" .. treaType .. ".png")
	end

	-- if (treaDb.type == 1) then
	-- 	m_treasureType:setText(m_i18n[1818])
	-- 	m_treasureType:setColor(ccc3(0x94,0x00,0xe5))
	-- elseif (treaDb.type == 2) then
	-- 	m_treasureType:setText(m_i18n[1737])
	-- 	m_treasureType:setColor(ccc3(0xcb,0x00,0x23))
	-- elseif (treaDb.type == 3) then
	-- 	m_treasureType:setText(m_i18n[1819])
	-- 	m_treasureType:setColor(ccc3(0x39,0xa1,0x14))
	-- elseif (treaDb.type == 4) then
	-- 	m_treasureType:setText(m_i18n[1817])
	-- 	m_treasureType:setColor(ccc3(0x12,0x72,0xc3))
	-- elseif (treaDb.type == 0 and treaDb.isExpTreasure == nil) then
	-- 	m_treasureType:setText(m_i18n[1738])
	-- 	m_treasureType:setColor(ccc3(0x12,0xb4,0xc3))
	-- elseif	(treaDb.type == 0 and treaDb.isExpTreasure == 1) then
	-- 	m_treasureType:setText(m_i18n[1822])
	-- 	m_treasureType:setColor(ccc3(0xe1,0x9e,0x03))
	-- end

	-- UIHelper.labelNewStroke(m_treasureType,ccc3(28,0,0))
	-- UIHelper.labelShadow(m_treasureType,CCSizeMake(2,-2))


	-- 显示精炼等级
	local treaEvolveLv = tonumber(tbTreaInfo.treaData.va_item_text.treasureEvolve)
	local tfdJingLianLV = m_fnGetWidget(infoLayer,"TFD_JINGLIAN_LV")
	local lableText = "(+" .. (treaEvolveLv or 0) .. ")"
	tfdJingLianLV:setColor(color)

	local tbEvolceInfo = tbTreaInfo.treaEvolve[1]
	if (treaEvolveLv~= nil) then
		tfdJingLianLV:setText(lableText)
	else
		tfdJingLianLV:setText(" ")
	end


	UIHelper.labelNewStroke(tfdJingLianLV,ccc3(28,0,0))
	UIHelper.labelShadow(tfdJingLianLV,CCSizeMake(2,-2))

	layLsvMain = m_fnGetWidget(infoLayer,"LSV_MAIN")
	local layBase = m_fnGetWidget(infoLayer,"LAY_BASE_INFO")
	local layStr = m_fnGetWidget(layLsvMain,"LAY_STR_INFO")
	local layZhuanshu = m_fnGetWidget(layLsvMain, "LAY_ZHUANSHU")
	local layJingLian = m_fnGetWidget(layLsvMain,"LAY_JINGLIAN_INFO")
	
	local layStrAbility = m_fnGetWidget(layLsvMain,"LAY_STR_ABILITY")
	layStrAbility:retain()
	table.insert(tbRatainedUI,layStrAbility)

	local layJiBan = m_fnGetWidget(layLsvMain,"LAY_JIBAN")
	layJiBan:retain()
	table.insert(tbRatainedUI,layJiBan)
	local layInfo =  m_fnGetWidget(layLsvMain,"LAY_DESC_INFO")
	layInfo:retain()
	table.insert(tbRatainedUI,layInfo)
	local layBtns = m_fnGetWidget(infoLayer,"LAY_BTNS")

	layLsvMain:removeAllItems()

	local forgeUnlock = treaInfoModel.getTreaForgeUnclock(treaDb) 


	fnGetBaseInfoLayer( layBase,forgeUnlock )  --  显示基本属性
	fnGetStrLayer( layStr ) --   显示强化属性

	fnEvolveLayer( layJingLian )  --   显示精炼属性

	performWithDelay(infoLayer, function(...)
		fnGetForgUnlock( layStrAbility,forgeUnlock ) --  显示强化解锁属性
    end, 0.05)

	performWithDelay(infoLayer, function(...)
		fnGetUnionLayer( layJiBan ) --  显示羁绊属性
    end, 0.05)

    performWithDelay(infoLayer, function(...)
		fnGetInfoLayer( layInfo ) -- 显示简介
    end, 0.07)

	fnLayBottom( layBtns ) --   根据从不同途径进入 而显示不同的底部按钮
end

--加载界面
local function fnLoadTreaFetterInfo( ... )
	local treasureLayer= g_fnLoadUI(jsonTreaFetter)
	m_mainView = treasureLayer

	treasureLayer:setName("treasure_fetter") -- 用于不加半透明的特殊处理

	LayerManager.setPaomadeng(treasureLayer)
	UIHelper.registExitAndEnterCall(treasureLayer, function ( ... )
		-- local curModuleName = LayerManager.curModuleName()
  --   	local retainLayer = DropUtil.checkLayoutIsRetain( curModuleName,treasureLayer)
  --   	if (retainLayer) then
  --   		DropUtil.insertCallFn(curModuleName,function ( ... )
  --   			LayerManager.setPaomadeng(retainLayer, 0)
  --   		end)
  --   		return
  --   	end

  		for i,v in ipairs(tbRatainedUI) do
  			local retainedUI = table.remove(tbRatainedUI)
  			retainedUI:release()
  		end
		LayerManager.resetPaomadeng()
		LayerManager.remuseAllLayoutVisible("treaInfoCtrl")
	end)

	local returnBack = m_fnGetWidget(treasureLayer,"BTN_BACK")

	local imgBg = m_fnGetWidget(treasureLayer,"img_bg1")
	imgBg:setScale(g_fScaleX)


	returnBack:addTouchEventListener(fnOnCallBack.onBtnClose)

	fnSetDataLayer(treasureLayer)

	return treasureLayer
end

function refreshLayou( fetterType,treasInfo,srcType,callBack, heroLv, isDrawTip,treasureLayer )
	fnOnCallBack = callBack
	tbRatainedUI = {}
	logger:debug({treasInfo=treasInfo})
	logger:debug({srcType=srcType})

	tbTreaInfo = treasInfo
	numSrcType = srcType
	m_nHeroLv = heroLv
	_isChangeBtnTip = isDrawTip or false

	fnSetDataLayer(treasureLayer)
end


function create(fetterType,treasInfo,srcType,callBack, heroLv, isDrawTip)
	fnOnCallBack = callBack
	tbRatainedUI = {}
	logger:debug({treasInfo=treasInfo})
	logger:debug({srcType=srcType})

	tbTreaInfo = treasInfo
	numSrcType = srcType
	m_nHeroLv = heroLv
	_isChangeBtnTip = isDrawTip or false

	logger:debug(_isChangeBtnTip)
	return fnLoadTreaFetterInfo()
end

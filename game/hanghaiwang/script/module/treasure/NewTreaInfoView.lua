-- FileName: NewTreaInfoView.lua
-- Author: sunyunpeng
-- Date: 2016-01-23
-- Purpose: function description of module
--[[TODO List]]


-- UI控件引用变量 --

-- 模块局部变量 --
NewTreaInfoView = class("NewTreaInfoView")


function NewTreaInfoView:moduleName( ... )
    return "NewTreaInfoView"
end


function NewTreaInfoView:initAllVariable( ... )
   
end


-- 初始化背景
function NewTreaInfoView:ctor(  )
    self:initAllVariable()
    LayerManager.hideAllLayout(NewTreaInfoView:moduleName())
    self.mainLayout = g_fnLoadUI("ui/treasure_fetter.json")
    
    local mainLayout = self.mainLayout

    LayerManager.setPaomadeng(mainLayout)
    UIHelper.registExitAndEnterCall(mainLayout, function ( ... )
         -- 重新设置跑马灯
        for i=1,#self.tbRatainedUI do
        	local retainedUI = table.remove(self.tbRatainedUI)
  			retainedUI:release()
        end
        LayerManager.resetPaomadeng()
        LayerManager.remuseAllLayoutVisible(self:moduleName())

    end,function ( ... )
    end)

    -- 返回按键
    local btnBack = mainLayout.BTN_BACK
    local m_i18n = gi18n
    UIHelper.titleShadow(btnBack,m_i18n[1019])
    btnBack:addTouchEventListener(function (  sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
            AudioHelper.playBackEffect()
            LayerManager.removeLayout(mainLayout)
        end
    end)

end

function NewTreaInfoView:create( treaInfoData,srcType,redPoindShow )
	self.srcType  = srcType
	self.redPoindShow = redPoindShow
	self.tbRatainedUI = {}

    self.treaInfoData = treaInfoData
    self.treaInfo = treaInfoData:getModleData()
    self:initHeader()
    -- listView部分
    self:initCenter( )

    return self.mainLayout
end


function NewTreaInfoView:initHeader( ... )
	local m_i18n = gi18n

	local mainLayout = self.mainLayout
	local treaDB = self.treaInfo.treaDb

	local nQuality = tonumber(treaDB.quality)
	local color = g_QulityColor2[nQuality]

	local treasImgName = mainLayout.TFD_NAME1
	treasImgName:setText(treaDB.name)
	treasImgName:setColor(color)
	UIHelper.labelNewStroke(treasImgName,ccc3(28,0,0))
	UIHelper.labelShadow(treasImgName,CCSizeMake(2,-2))


	local treasPinJiTxt = mainLayout.TFD_PINJI_TXT
	treasPinJiTxt:setText(m_i18n[4901])
	treasPinJiTxt:setColor(g_QulityColor3[nQuality])
	

	local treasPinJi = mainLayout.TFD_PINJI
	treasPinJi:setText(treaDB.base_score)
	treasPinJi:setColor(g_QulityColor3[nQuality])

	local qualityImag = mainLayout.IMG_QUALITY
	qualityImag:loadTexture(g_QulityImageIndex[nQuality])


	local imgArm = mainLayout.IMG_ARM
	imgArm:loadTexture("images/base/treas/big/" .. treaDB.icon_big)
	UIHelper.runFloatAction(imgArm)

	local m_treasureType = mainLayout.IMG_TREASURE_TYPE

	if (treaDB.isExpTreasure) then
		m_treasureType:loadTexture("images/treasure/new_type/treasure_type_exp.png")
	else
		local treaType = treaDB.type
		logger:debug({treaType=treaType})
		m_treasureType:loadTexture("images/treasure/new_type/treasure_type" .. treaType .. ".png")
	end

	-- 显示精炼等级
	local tfdJingLianLV = mainLayout.TFD_JINGLIAN_LV

	if (tonumber(treaDB.isUpgrade) == 1  and self.treaInfo.refineLel ) then
		local treaEvolveLv = tonumber(self.treaInfo.refineLel)
		local lableText = "(+" .. (treaEvolveLv or 0) .. ")"
		tfdJingLianLV:setColor(color)
		tfdJingLianLV:setText(lableText)

		UIHelper.labelNewStroke(tfdJingLianLV,ccc3(28,0,0))
		UIHelper.labelShadow(tfdJingLianLV,CCSizeMake(2,-2))

	else
		tfdJingLianLV:setText(" ")
	end

end

function NewTreaInfoView:initCenter( ... )
	local mainLayout = self.mainLayout
	local treaDB = self.treaInfo.treaDb

	local layLsvMain = mainLayout.LSV_MAIN
	local layBase = mainLayout.LAY_BASE_INFO
	local layStr = mainLayout.LAY_STR_INFO
	local layZhuanshu = mainLayout.LAY_ZHUANSHU
	local layJingLian = mainLayout.LAY_JINGLIAN_INFO

	local tbRatainedUI = self.tbRatainedUI
	
	local layStrAbility = mainLayout.LAY_STR_ABILITY
	layStrAbility:retain()
	table.insert(tbRatainedUI,layStrAbility)

	local layJiBan = mainLayout.LAY_JIBAN
	layJiBan:retain()
	table.insert(tbRatainedUI,layJiBan)
	local layInfo =  mainLayout.LAY_DESC_INFO
	layInfo:retain()
	table.insert(tbRatainedUI,layInfo)
	local layBtns = mainLayout.LAY_BTNS

	layLsvMain:removeAllItems()

	local forgeUnlock = treaInfoModel.getTreaForgeUnclock(treaDB) 

	self:fnGetBaseInfoLayer( layBase,layLsvMain,forgeUnlock )  --  显示基本属性
	self:fnGetStrLayer( layStr,layLsvMain ) --   显示强化属性

	self:fnEvolveLayer( layJingLian ,layLsvMain)  --   显示精炼属性

	performWithDelay(layLsvMain, function(...)
		self:fnGetForgUnlock( layStrAbility,forgeUnlock ,layLsvMain) --  显示强化解锁属性
    end, 0.05)

	performWithDelay(layLsvMain, function(...)
		self:fnGetUnionLayer( layJiBan ,layLsvMain) --  显示羁绊属性
    end, 0.05)

    performWithDelay(layLsvMain, function(...)
		self:fnGetInfoLayer( layInfo ,layLsvMain) -- 显示简介
    end, 0.07)

	self:fnLayBottom( layBtns ) --   根据从不同途径进入 而显示不同的底部按钮
end
	
function NewTreaInfoView:fnlabelNewStroke( widget )
	UIHelper.labelNewStroke(widget,ccc3(0x92,0x53,0x1b),2)
end


-- 判断是否有基本属性
function NewTreaInfoView:fnGetBaseInfoLayer( layBase ,layLsvMain,forgeUnlock )
	local m_i18n = gi18n

	local imgPaperTitle = layBase.img_paper_title
	local tfdBaseAttr = layBase.tfd_base_attr
	tfdBaseAttr:setText(m_i18n[1073])
	self:fnlabelNewStroke(tfdBaseAttr)

	for i,v in ipairs(forgeUnlock or {}) do
		local unLockLevel = tonumber(v.unLockLevel)

		if (unLockLevel == 0) then

			local lay_base_fit = layBase.lay_base_fit
			local tfdBase = lay_base_fit.TFD_BASE_ATTR1
			local tfdBaseNum = lay_base_fit.TFD_BASE_ATTR1_NUM

			tfdBase:setText(v.baseInfo.displayName)
			tfdBaseNum:setText(v.displayNum)

			layLsvMain:pushBackCustomItem(layBase)
			return
		end
	end
end 


-- 判断是否有强化属性
function NewTreaInfoView:fnGetStrLayer( layStr ,layLsvMain)
	local numSrcType = self.srcType

	local m_i18n = gi18n
	local treaInfo = self.treaInfo
	local treaDB = self.treaInfo.treaDb

	if (treaInfo.treaDb.isExpTreasure == 1 or tonumber(treaInfo.treaDb.id) == 501010) then
		return
	end

	local tfdExpAttr = layStr.TFD_ATTR_EXP
	local tfdExpNum = layStr.TFD_ATTR_EXP_NUM
	local tfdattr = layStr.tfd_attr
	tfdattr:setText(m_i18n[1679])
	self:fnlabelNewStroke(tfdattr)

	local btnStren = layStr.BTN_STRENGTHEN
	UIHelper.titleShadow(btnStren,m_i18n[1054])
	btnStren:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then

			AudioHelper.playCommonEffect()
			NewTreaInfoCtrl.onBtnForge(self.treaInfo)
		end
	end)

	if (not self.treaInfo.itemId or not numSrcType) then
		btnStren:setEnabled(false)
	end

	for i=1,2 do
		local tfdAttr = layStr["TFD_ATTR" .. i]
		local tfdNum = layStr["TFD_ATTR" .. i .. "_NUM"]

		tfdAttr:setEnabled(false)
		tfdNum:setEnabled(false)
	end

	tfdExpAttr:setEnabled(false)
	tfdExpNum:setEnabled(false)

	local treasureLv = layStr.TFD_LV_NUM
	local curMaxLv

	if (treaDB.level_interval ~= 0) then
		local hLv = m_nHeroLv or UserModel.getHeroLevel()
		curMaxLv = math.floor(hLv / treaDB.level_interval)
		if (curMaxLv > treaDB.level_limited) then
			curMaxLv = treaDB.level_limited
		end
	else
		curMaxLv = treaDB.level_limited
	end

	treasureLv:setText(treaInfo.forgLel .. "/" .. curMaxLv)

	if (not treaDB.isExpTreasure) then
		local tbPro = treaInfo.property
		for i=1,#tbPro do

			local tfdAttr = layStr["TFD_ATTR" .. i]
			local tfdNum = layStr["TFD_ATTR" .. i .. "_NUM"]

			tfdAttr:setEnabled(true)
			tfdNum:setEnabled(true)

			tfdAttr:setText(tbPro[i].name)
			tfdNum:setText("+" .. tbPro[i].value)
		end
	else
		tfdExpAttr:setEnabled(true)
		tfdExpNum:setEnabled(true)

	end
	layLsvMain:pushBackCustomItem(layStr)
end


-- 判断是否有专属属性
function NewTreaInfoView:fnGetZsLayer( layZhuanshu,layLsvMain )

	local awakeInfo = self.treaInfo.awakeInfo
	if (awakeInfo) then
		local tfdZhuanshuDes = layZhuanshu.TFD_ZHUANSHU_DES
		local tfdHeroName = layZhuanshu.TFD_PARTNER_NAME_Z
		local tfdTreaName = layZhuanshu.TFD_TREASURE_NAME_Z
		local tfdZhuanshu = layZhuanshu.tfd_zhuanshu
		self:fnlabelNewStroke(tfdZhuanshu)

		tfdZhuanshuDes:setText(awakeInfo.awakeDes)

		tfdHeroName:setText(awakeInfo.heroName)
		tfdHeroName:setColor(g_QulityColor[awakeInfo.heroQuality])

		tfdTreaName:setText(awakeInfo.name)
		tfdTreaName:setColor(g_QulityColor[tonumber(awakeInfo.quality)])

		layLsvMain:pushBackCustomItem(layZhuanshu)
	end
end

-- 判断强化解锁属性
function NewTreaInfoView:fnGetForgUnlock( layStarAbility,forgeUnlock ,layLsvMain)
	local treaCurLel = tonumber(self.treaInfo.forgLel or 0)
	local m_i18n = gi18n
	local m_i18nString = gi18nString

	local treaInfo = self.treaInfo
	local refineLel = treaInfo.refineLel 
	local forgLel = treaInfo.forgLel  
	local treaDB = treaInfo.treaDb

	local layStarAbilitySize = layStarAbility:getContentSize()
	local layStarAbilitySizeHeight = layStarAbilitySize.height

	local img_paper_title = layStarAbility.img_paper_title
	self:fnlabelNewStroke(img_paper_title.TFD_ABILITY)

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
		local unLockWarnigStr = treaCurLel < tonumber(v) and "(" .. m_i18nString(1141,v)   .. ")" or  " "
		tempDes = tempDes .. unLockWarnigStr

		local layAbility = layStarAbility["LAY_ABILITY" .. abilityNums]
		local tfdAbility = layAbility.TFD_ABILITY

		tfdAbility:setText(tempDes)

		tfdAbility:setColor(treaCurLel >= tonumber(v) and ccc3( 0x01, 0x8a, 0x00) or  ccc3( 0x7f, 0x5f, 0x20))

		abilityNums = abilityNums + 1
	end

	local deleteH = 0
	for i= #desStrLel + 1 ,9 do
		local layAbility = layStarAbility["LAY_ABILITY" .. i]
		layAbility:removeFromParentAndCleanup(true)
		deleteH = deleteH + LayAbilitySizeHeight
	end

	layStarAbility:setSize(CCSizeMake(layStarAbilitySize.width,layStarAbilitySizeHeight - deleteH))
	layLsvMain:pushBackCustomItem(layStarAbility)


end 


--判断是否有精炼属性
function NewTreaInfoView:fnEvolveLayer( layJingLian,layLsvMain )
	local m_i18n = gi18n
	local numSrcType = self.srcType

	local treaInfo = self.treaInfo
	local refineLel = treaInfo.refineLel 
	local forgLel = treaInfo.forgLel  

	local treaDB = treaInfo.treaDb


	if(tonumber(treaDB.isUpgrade) ~= 1)then
		return
	end
	
	local btnRefine =  layJingLian.BTN_JINGLIAN
	UIHelper.titleShadow(btnRefine,m_i18n[1705])
	btnRefine:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then

			AudioHelper.playCommonEffect()
			NewTreaInfoCtrl.onRefine(self.treaInfo)
		end
	end)
    
	local tfdJinglianTitle =  layJingLian.tfd_jinglian_title
	tfdJinglianTitle:setText(m_i18n[1707])
	self:fnlabelNewStroke(tfdJinglianTitle)


	if (not self.treaInfo.itemId or not numSrcType) then
		btnRefine:setEnabled(false)
	else
		local canRefineAndCostTrea = treaRefineCtrl.checkTreaCanRefineByItemId(self.treaInfo.itemId,true)
		if (canRefineAndCostTrea) then
			btnRefine.IMG_JINGLIAN_TIP:removeAllNodes()
			local redPoint = UIHelper.createRedTipAnimination()
			btnRefine.IMG_JINGLIAN_TIP:addNode(redPoint)
		end
	end

	require "db/DB_Treasurerefine"
	local treaRefineDB =  DB_Treasurerefine.getDataById(treaDB.id)
	local refineLevelInterval = treaRefineDB.refine_interval
	local maxRefineLevel = 0
	if (tonumber(refineLevelInterval) == 0)	then
		maxRefineLevel = tonumber(treaRefineDB.max_upgrade_level)
	else
		maxRefineLevel = math.floor(tonumber(forgLel) / tonumber(refineLevelInterval))
	end

	local tbUpgradeAffix = lua_string_split(treaDB.upgrade_affix, ",")
	local tbBaseArr = {}
	for i,upgradeAffix in ipairs(tbUpgradeAffix) do
		local tbAffix = {}
		local upgradeAffix = lua_string_split(upgradeAffix, "|")
		local upgradeAffixNum = tonumber(upgradeAffix[2]) * tonumber(refineLel)
		table.insert(tbAffix,upgradeAffix[1])
		table.insert(tbAffix,upgradeAffixNum)
		table.insert(tbBaseArr,tbAffix)
	end

	local treaUpgrade = refineLel .."/" .. (maxRefineLevel)
	local tfdPercent = layJingLian.TFD_JINGLIANLV_NUM
	tfdPercent:setText(treaUpgrade)
	for i = 1, 3 do
		local proBaseArr = tbBaseArr[i]
		local attrIndex = i + 6
		local tfdAttr = layJingLian["TFD_ATTR" .. attrIndex]
		local tfdValue = layJingLian["TFD_ATTR" .. attrIndex .. "_NUM"]
			
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


--判读是否有宝物羁绊
function NewTreaInfoView:fnGetUnionLayer( layJiBan,layLsvMain )
	local m_i18n = gi18n

	local treaInfo = self.treaInfo
	local refineLel = treaInfo.refineLel 
	local forgLel = treaInfo.forgLel  

	local treaDB = treaInfo.treaDb

	local unionInfo = treaInfoModel.fnGetUnionInfo(treaDB.union_info) -- zhangqi, 2015-06-15

	local layTotal = layJiBan.LAY_CELL_TOTAL
	local layCellTitle = layJiBan.img_paper_title
	local layCellSpace = 120

	local layBg = layJiBan.IMG_JIBAN_PAPER_BG
	local labBgSize = layBg:getSize()

	local layCellRef = layJiBan.LAY_JIBAN_CELL
	layCellRef:retain()

	local tbRatainedUI = self.tbRatainedUI
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

			local tfdPartnerName = layCellCopy.TFD_PARTNER_NAME
			tfdPartnerName:setColor(tempUnion.nameColor)
			tfdPartnerName:setText(tempUnion.heroName)
			UIHelper.labelStroke(tfdPartnerName)

			local tfdJiBanName = layCellCopy.TFD_JIBAN_NAME
			tfdJiBanName:setText(tempUnion.unionName)

			local tfdJiBanDes = layCellCopy.TFD_JIBAN_DES
			local tfdJiBanDesDb = string.split(tempUnion.unionDesc,",") or {"",""}
			-- tfdJiBanDes:setText(tfdJiBanDesDb[1]  ..  v.unionProfitNum .. "%," .. tfdJiBanDesDb[2] )

			tfdJiBanDes:setText(tfdJiBanDesDb[1]  ..  tempUnion.unionProfitNum .. "%," .. (#tfdJiBanDesDb > 1 and tfdJiBanDesDb[2] or ""))

			local layHero = layCellCopy.LAY_PHOTO
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
	local tfdJiban = layCellTitleRef.tfd_jiban
	tfdJiban:setText(m_i18n[1116])--  宝物羁绊 属性加成
	self:fnlabelNewStroke(tfdJiban)
	layCellTitleRef:runAction(CCPlace:create(ccp(labBgSize.width * 0.5,120 * (#unionInfo -1) + 160  )))
	layCellTitle:removeFromParentAndCleanup(true)
	layTotal:addChild(layCellTitleRef)

end

-- 显示简介
function NewTreaInfoView:fnGetInfoLayer( layInfo,layLsvMain )
	local m_i18n = gi18n

	local treaInfo = self.treaInfo
	local refineLel = treaInfo.refineLel 
	local forgLel = treaInfo.forgLel  
	local treaDB = treaInfo.treaDb

	local tfdDes = layInfo.TFD_DES
	local tfdDesTitle = layInfo.tfd_des_title
	tfdDesTitle:setText(m_i18n[1118])
	self:fnlabelNewStroke(tfdDesTitle)

	tfdDes:setText(treaDB.info)
	layLsvMain:pushBackCustomItem(layInfo)
end


--底部按钮控制
function NewTreaInfoView:fnLayBottom( layBtns )
	local m_i18n = gi18n
	local treaInfo = self.treaInfo

	local numSrcType = self.srcType
	local layFromFor = layBtns.LAY_BTNS_FROMFOR       -- 阵容界面
	local layFromInfo = layBtns.LAY_BTNS_FROMINFO     -- 背包界面
	local layFromRob = layBtns.LAY_BTNS_FROMROB       -- 夺宝界面
	local layFromRefine = layBtns.LAY_BTNS_FROMREFINE -- 精炼界面

	-- 确定 1
	if (numSrcType == 1 or not numSrcType) then 
		local btnClose = layFromInfo.BTN_CLOSE_INFO
		UIHelper.titleShadow(btnClose,m_i18n[1029])
		btnClose:addTouchEventListener(function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				NewTreaInfoCtrl.onBtnClose()
			end
		end) 

		layFromFor:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()
	-- 阵容 换装 2
	elseif(numSrcType == 2) then
		local btnUnload = layFromFor.BTN_UNLOAD
		btnUnload:addTouchEventListener(function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				-- AudioHelper.playCommonEffect()
				AudioHelper.playArmOff()
				NewTreaInfoCtrl.onBtnUnload(treaInfo)
			end
		end) 
		UIHelper.titleShadow(btnUnload,m_i18n[1710])

		local btnChange = layFromFor.BTN_CHANGE
		btnChange:addTouchEventListener(function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				logger:debug({NewTreaInfoCtrl_btnChange = treaInfo})
				NewTreaInfoCtrl.onChange(treaInfo)
			end
		end) 
		UIHelper.titleShadow(btnChange,m_i18n[1638])

		-- 红点
		if (self.redPoindShow == true) then
			if(not btnChange.IMG_CHANGE_TIP:getNodeByTag(10)) then
				local tip = UIHelper.createRedTipAnimination()
				tip:setTag(10)
				btnChange.IMG_CHANGE_TIP:addNode(tip,10)
			end
		end
		btnChange.IMG_CHANGE_TIP:setVisible(self.redPoindShow)

		layFromInfo:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()


	-- 获取途径 3
	elseif (numSrcType == 3) then         -- 确定,信息面板用这个
		local btnClose = layFromInfo.BTN_CLOSE_INFO

		local curModuleName = LayerManager.curModuleName()
    	local isPlaying = BattleState.isPlaying()

		-- 碎片背包
		if (curModuleName == "MainTreaBagCtrl" or not isPlaying) then
			local btnChangded = UIHelper.chagneGuildTOOk(btnClose)
			if (not btnChangded) then
				UIHelper.titleShadow(btnClose,m_i18n[1098])
				btnClose:addTouchEventListener(function ( sender,eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						NewTreaInfoCtrl.onDrop(treaInfo)
					end
				end) 
			end
		else
			UIHelper.titleShadow(btnClose,m_i18n[1029])
			btnClose:addTouchEventListener(function ( sender,eventType )
				if (eventType == TOUCH_EVENT_ENDED) then

					AudioHelper.playBackEffect()
					NewTreaInfoCtrl.onBtnClose()
				end
			end)
		end
		layFromFor:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()
		
	else
		local btnClose = layFromInfo.BTN_CLOSE_INFO
		btnClose:addTouchEventListener(function ( sender,eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playBackEffect()
				NewTreaInfoCtrl.onBtnClose()
			end
		end)
		layFromFor:removeFromParent()
		layFromRob:removeFromParent()
		layFromRefine:removeFromParent()
	end
end












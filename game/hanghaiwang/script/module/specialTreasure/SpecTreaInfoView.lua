-- FileName: SpecTreaInfoView.lua
-- Author: sunyunpeng
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

-- module("SpecTreaInfoView", package.seeall)
SpecTreaInfoView = class("SpecTreaInfoView")
require "script/module/specialTreasure/SpecTreaModel"
-- UI控件引用变量 --

-- 模块局部变量 --

function SpecTreaInfoView:moduleName()
	return "SpecTreaInfoView"
end

function SpecTreaInfoView:ctor( ... )
	self.mainLayout = g_fnLoadUI("ui/special_inifo.json")
	local imgBg = self.mainLayout.img_bg1
	-- 适配
	imgBg:setScale(g_fScaleX)
end


function SpecTreaInfoView:init( speTreaData )
	self.tbReatainedUI = {}
	self.speTreaInfo = speTreaData:getModleData()
	self.footerBtnType = self.speTreaInfo.footerBtnType

	logger:debug({SpecTreaInfoView_init =self.footerBtnType })

	self:initBg()
	self:initHeader()
	self:initListView()
	self:initFooter()
	return self.mainLayout
end


function SpecTreaInfoView:fnlabelNewStroke( widget )
	UIHelper.labelNewStroke(widget,ccc3(0x92,0x53,0x1b),2)
end

-- 初始化layout模板
function SpecTreaInfoView:initBg(  )
	LayerManager.hideAllLayout(self:moduleName())

	LayerManager.setPaomadeng(self.mainLayout)
	UIHelper.registExitAndEnterCall(self.mainLayout, function ( ... )
		for i,v in ipairs(self.tbReatainedUI) do
			local ratainedUI = table.remove(self.tbReatainedUI)
			ratainedUI:release()
		end
		LayerManager.resetPaomadeng()
		LayerManager.remuseAllLayoutVisible(self:moduleName())
	end)

	local btnBack = self.mainLayout.BTN_BACK
	btnBack:addTouchEventListener(function (  sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
	 		LayerManager.removeLayout()
	 	end
	end)
end

-- 创建宝物图像，标题头信息
function SpecTreaInfoView:initHeader(  )
	local m_i18n = gi18n

	local treaDB = self.speTreaInfo.speTreaDb
	-- 宝物图像模型
	local imgArm = self.mainLayout.IMG_ARM
	imgArm:loadTexture("images/base/exclusive/big/" .. treaDB.icon_big)
	UIHelper.runFloatAction(imgArm)

	-- 宝物品级
	local nQuality = tonumber(treaDB.quality)
	local imgQuality = self.mainLayout.IMG_QUALITY
	local tfdPinJi = self.mainLayout.TFD_PINJI
	tfdPinJi:setText(m_i18n[4901])
	tfdPinJi:setColor(g_QulityColor3[nQuality])

	local tfdPinJiTxt = self.mainLayout.TFD_PINJI_TXT
	tfdPinJiTxt:setText(treaDB.base_score)
	tfdPinJiTxt:setColor(g_QulityColor3[nQuality])

end

-- 初始化列表
function SpecTreaInfoView:initListView(  )
	self:initListViewBanner()
	self:initListViewContainer()
end

-- 列表banner
function SpecTreaInfoView:initListViewBanner(  )
	local nameBg = self.mainLayout.img_treasure_namebg
	local treaDB = self.speTreaInfo.speTreaDb
	local nQuality = tonumber(treaDB.quality)
	-- 宝物名字
	local tfdName
	tfdName = self.mainLayout.TFD_NAME1
	tfdName:setText(self.speTreaInfo.speTreaDb.name)
	tfdName:setColor(g_QulityColor2[nQuality])
	self:fnlabelNewStroke(tfdName)
	-- 精炼等级
	local tfdJingLianLV = self.mainLayout.TFD_JINGLIAN_LV
	local refineLel = self.speTreaInfo.refineLel or 0
	tfdJingLianLV:setText("(+" .. refineLel .. ")")
	tfdJingLianLV:setColor(g_QulityColor2[nQuality])
	self:fnlabelNewStroke(tfdJingLianLV)
	tfdJingLianLV:setEnabled(refineLel ~= 0)
end

-- 基础信息lay
function SpecTreaInfoView:fnGetBaseInfo( layBaseInfo )
	local m_i18n = gi18n

	local refineLel = self.speTreaInfo.refineLel or 0
	-- local baseInfo = SpecTreaModel.fnGetTreaProperty(self.speTreaInfo.speTreaDb.id,refineLel)
	local baseAtrr = lua_string_split(self.speTreaInfo.speTreaDb.base_attr, ",")
	-- lay的title
	local layTitle = layBaseInfo.tfd_base_attr
	layTitle:setText(m_i18n[1073])
	self:fnlabelNewStroke(layTitle)
	-- lay的属性
	for i=1,#baseAtrr do
		local attrItemName = "lay_base_fit" .. i
		local attrItem = layBaseInfo[attrItemName]

		local attrItemInfo = lua_string_split(baseAtrr[i],"|")
		local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(attrItemInfo[1]),tonumber(attrItemInfo[2]))

		local tfdAttrName = attrItem.TFD_BASE_ATTR1
		local tfdAttrNum = attrItem.TFD_BASE_ATTR1_NUM

		tfdAttrName:setText(baseInfo.displayName)
		tfdAttrNum:setText("+" .. displayNum)
	end
	self.layLsvMain:pushBackCustomItem(layBaseInfo)

end

-- 进阶信息lay
function SpecTreaInfoView:fnGetAdvanceInfo( layAdvanceInfo )
	local treaDB = self.speTreaInfo.speTreaDb
	if (treaDB.id == 720001) then
		return
	end
	local m_i18n = gi18n
	-- lay的title
	local layTitle = layAdvanceInfo.tfd_advance_attr
	layTitle:setText(m_i18n[6908])
	self:fnlabelNewStroke(layTitle)
	-- 计算进阶信息属性
	local advanceRefineLel = self.speTreaInfo.refineLel 
	local increaAtrrTb = SpecTreaModel.fnGetTreaAdvanceProperty( treaDB.id,advanceRefineLel)
	-- if (not advanceRefineLel or advanceRefineLel ==  0) then  --  如果是0级 或者是碎片
	-- 	increaAtrr =  lua_string_split("1|0,2|0,3|0,4|0,5|0",",")
	-- else
	-- 	increaAtrr =  lua_string_split(treaDB["increase_attr" .. advanceRefineLel], ",")
	-- end
	--最大进阶等级
	local maxRefineLevel = self.speTreaInfo.maxRefineLevel
	local tfdAdvanceLv = layAdvanceInfo.TFD_ADVANCE_LV_NUM
	local nowRefineLel = self.speTreaInfo.refineLel  or 0
	if (maxRefineLevel) then
		tfdAdvanceLv:setText(nowRefineLel..  "/" .. maxRefineLevel)
	else
		tfdAdvanceLv:setEnabled(false)
	end

	-- 进阶属性
	for i=1,#increaAtrrTb do
		local attrItemName = "lay_advance_fit" .. i
		local attrItem = layAdvanceInfo[attrItemName]

		local increaAtrr = increaAtrrTb[i]
		-- local increaAtrrDB = lua_string_split(increaAtrr[i], "|")
		-- local baseInfo,displayNum,realNum = ItemUtil.getAtrrNameAndNum(tonumber(increaAtrrDB[1]),increaAtrrDB[2])
		local tfdAttrName = attrItem.TFD_ADVANCE_ATTR1
		local tfdAttrNum = attrItem.TFD_ADVANCE_ATTR1_NUM

		tfdAttrName:setText(increaAtrr.name)
		tfdAttrNum:setText("+" .. increaAtrr.value)
	end
	-- 进阶按钮对应事件
	local btnAdvance = layAdvanceInfo.BTN_ADVANCE
	btnAdvance:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/specialTreasure/SpecTreaRefineCtrl"
			local curModuleName = LayerManager.curModuleName()
			SpecTreaRefineCtrl.create(self.speTreaInfo.itemId)
		end
	end)

	if (not self.footerBtnType or self.footerBtnType == -1  or self.footerBtnType == 2) then
		btnAdvance:setEnabled(false)
	end
	self.layLsvMain:pushBackCustomItem(layAdvanceInfo)

end

-- UIlable自适应高度
-- return tfdBeforeSizeWidth 之前的宽度 tfdBeforeSizeHeight 高度 affterSizeHeight变化后的高度
function SpecTreaInfoView:labelScaleChangedWithStr( UIlableWidet,textInfo )
    local tfdBeforeSize = UIlableWidet:getContentSize()
    local tfdBeforeSizeHeight = tfdBeforeSize.height  -- 必须把高度值单独取出来放进变量里 否则值会变
    local tfdBeforeSizeWidth = tfdBeforeSize.width  -- 必须把高度值单独取出来放进变量里 否则值会变

    -- UIlableWidet:ignoreContentAdaptWithSize(false)
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSize.width,0))
    UIlableWidet:setText(textInfo)
    local tfdAffterSize =  UIlableWidet:getVirtualRenderer():getContentSize()
    local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
    local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSizeWidth,affterSizeHeight))

    return tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight

end


-- 能力信息lay
function SpecTreaInfoView:fnGetAbility( layAbility )

	local layAbilitySize = layAbility:getContentSize()
	local layAbilitySizeHeight = layAbilitySize.height

	local treaDB = self.speTreaInfo.speTreaDb
	if (treaDB.id == 720001) then
		return
	end
	local m_i18n = gi18n
	local m_i18nString = gi18nString

	local nowRefineLel = tonumber(self.speTreaInfo.refineLel or 0)
	-- lay的title
	local layTitle = layAbility.tfd_ability
	layTitle:setText(m_i18n[6909])
	self:fnlabelNewStroke(layTitle)

	-- 进阶能力信息添加
	local awkenInfo = SpecTreaModel.fnGetTreaAwakenInfo(treaDB.id)
	local abilityLaySize = nil
	local abilityLaySizeHeight = 0

	local tfdInfoSize = nil
	local tfdInfoSizeHeight = 0
	local addH = 0
	for i,v in ipairs(awkenInfo) do
		local abilityItemInfoDb = awkenInfo[i]
		local awakenAttr = abilityItemInfoDb.awakenAttr
		local refineLevelLimit = tonumber(awakenAttr[1].refineLevelLimit)
		
		local ability = layAbility["LAY_ABILITY" .. i]
		if (not abilityLaySize) then
			abilityLaySize = ability:getContentSize()
			abilityLaySizeHeight = abilityLaySize.height
		end

		local tfdName = ability["TFD_NAME" .. i]
		tfdName:setText(m_i18nString(6943 , i))
		if (nowRefineLel >= refineLevelLimit) then
			tfdName:setColor(ccc3( 0x01, 0x8a, 0x00))
		end
		
		local limitInfo = m_i18nString(6944 , refineLevelLimit) -- "(进阶到" .. awakenAttr[1].refineLevelLimit .. "解锁)"
		local abilityInfo = abilityItemInfoDb.info

		local tfdInfo = ability["TFD_INFO" .. i]
		if (not tfdInfoSize) then
			tfdInfoSize = tfdInfo:getContentSize()
			tfdInfoSizeHeight = tfdInfoSize.height
		end

		-- tfdInfo:setText(abilityInfo .. limitInfo)
		local desStr = abilityInfo .. limitInfo
		local tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight = self:labelScaleChangedWithStr(tfdInfo,desStr)
		addH = addH + affterSizeHeight - tfdBeforeSizeHeight
		if (nowRefineLel >= refineLevelLimit) then
			tfdInfo:setColor(ccc3( 0x01, 0x8a, 0x00))
		end
	end

	local deletH = 0
	for i= #awkenInfo + 1,10 do
		local ability = layAbility["LAY_ABILITY" .. i]
		ability:removeFromParentAndCleanup(true)
		deletH = deletH + abilityLaySizeHeight
	end

	layAbility:setSize(CCSizeMake(layAbilitySize.width,layAbilitySizeHeight + addH - deletH))

	self.layLsvMain:pushBackCustomItem(layAbility)
end





--宝物所属信息界面lay
function SpecTreaInfoView:fnGetSpecical( laySpecial )
	local treaDB = self.speTreaInfo.speTreaDb
	if (treaDB.id == 720001) then
		return
	end
	local m_i18n = gi18n
	local m_i18nString = gi18nString
	--
	local tbHeroInfo = self.speTreaInfo.tbHeroInfo
	local nowRefineLel = tonumber(self.speTreaInfo.refineLel or 0)

	if (not tbHeroInfo or #tbHeroInfo == 0) then
		return
	end
	local hid = self.speTreaInfo.hid
	local ownerInfo = nil
	if (hid and tonumber(hid) ~= 0) then
		ownerInfo =  HeroModel.getHeroByHid(hid)
	end

	-- lay Title
	local layTitle = laySpecial.tfd_special_title
	local layBg = laySpecial.IMG_SPECIAL_PAPER_BG
	layTitle:setText(m_i18n[6949])
	self:fnlabelNewStroke(layTitle)
	--
	local layPartnerRef = laySpecial.LAY_PARTNER

	local layPartnerRefPos = layPartnerRef:getPositionPercent()
	local layPartnerRefSize = layPartnerRef:getSize()
	local laySpecialNewHeight =  laySpecial:getSize().height + (#tbHeroInfo - 1) * layPartnerRefSize.height
	local layPartnerRefSizePersent = layPartnerRefSize.height / laySpecialNewHeight

	layPartnerRef:retain()
	table.insert(self.tbReatainedUI,layPartnerRef)
	layPartnerRef:removeFromParentAndCleanup(true)

	-- heroId 和awakeId 多个英雄“ hero11|hero12 ,hero21 | hero22” 对多个觉醒技能 “ wakeid1|wakeid2 ,wakeid3 | wakeid4” 
	-- heromodelid是heroId中的所有原型id。“hero1|hero2”
	for i,heroInfo in ipairs(tbHeroInfo or {}) do
		local tbHeroIds = heroInfo.tbHeroIds or {}
		local tbawakeIds = heroInfo.tbawakeIds or {}
		local normalColor = ccc3(0x82,0x57,0x00)
		local onHeroColor = ccc3(0x01,0x8a,0x00)
		local showHeroId = heroInfo.heromodelid
		local showAwakeId = nil

		local layPartner = layPartnerRef:clone()

		-- 设置初始原型id awakeid
		for i,heroId in ipairs(tbHeroIds or {}) do
			if (tonumber(heroId) == tonumber(showHeroId)) then
				showAwakeId = tbawakeIds[i]
			end
		end
		-- 如果宝物有人穿戴
		local isOnHero = false
		local onColor =  ccc3( 0x01, 0x8a, 0x00)

		if (ownerInfo) then
			for i,heroId in ipairs(tbHeroIds or {}) do
				if (tonumber(heroId) == tonumber(ownerInfo.htid))  then
					showHeroId = heroId
					showAwakeId = tbawakeIds[i]
					isOnHero =  true
				end
			end
		end

		local showHeroDB =  DB_Heroes.getDataById(showHeroId)
		local showAwakeDB 
		if (showAwakeId and tonumber(showAwakeId) ~= 0) then
			showAwakeDB = DB_Awake_ability.getDataById(showAwakeId)
		end
		-- 头像
		local layPhoto = layPartner.LAY_PHOTO 
		local btnlay = HeroUtil.createHeroIconBtnByHtid(showHeroId)
		local layPhotoSize = layPhoto:getSize()
		btnlay:setPosition(ccp(layPhotoSize.width * 0.5,layPhotoSize.height * 0.5))
		layPhoto:addChild(btnlay)
		-- 名字
		local tfdPartnerName = layPartner.TFD_PARTNER_NAME 
		tfdPartnerName:setText(showHeroDB.name)
		tfdPartnerName:setColor(g_QulityColor[tonumber(showHeroDB.star_lv)])
		-- 技能描述
		local tfdDes = layPartner.TFD_SPECIAL_DES
		local treaFeild = showHeroDB.treaureId
		local tbTrea = lua_string_split(treaFeild,"|")
		
		local limitDes =  m_i18nString(6952,tbTrea[3])
		if (showAwakeDB) then
			tfdDes:setText(showAwakeDB.des  .. (nowRefineLel < tonumber(tbTrea[3]) and m_i18nString(6952,tbTrea[3]) or ""))
		else
			tfdDes:setText(gi18nString(6950,showHeroDB.name))
		end
		tfdDes:setColor((nowRefineLel >= tonumber(tbTrea[3]) and isOnHero) and onHeroColor or normalColor)

		layPartner:setPositionPercent(ccp(layPartnerRefPos.x,layPartnerRefPos.y + (i - 1) * layPartnerRefSizePersent))
		layBg:addChild(layPartner)
	end

	laySpecial:setSize(CCSizeMake(laySpecial:getSize().width,laySpecialNewHeight ))
	self.layLsvMain:pushBackCustomItem(laySpecial)
end

-- 简介lay
function SpecTreaInfoView:fnGetDescInfo( layDescInfo )
	local m_i18n = gi18n
	-- lay的title
	local layTitle = layDescInfo.tfd_des_title
	self:fnlabelNewStroke(layTitle)
	layTitle:setText(m_i18n[1118])
	-- 简介描述
	local tfdDes = layDescInfo.TFD_DES
	tfdDes:setText(self.speTreaInfo.speTreaDb.info)
	self.layLsvMain:pushBackCustomItem(layDescInfo)

end

-- 列表内容
function SpecTreaInfoView:initListViewContainer( speTreaInfo )
	self.layLsvMain = self.mainLayout.LSV_MAIN
	-- 基础信息lay
	local layBaseInfo = self.mainLayout.LAY_BASE_INFO
	-- 进阶信息lay
	local layAdvanceInfo = self.mainLayout.LAY_ADVANCE_INFO
	-- 能力信息lay
	local layAbility = self.mainLayout.LAY_ABILITY
	layAbility:retain()
	table.insert(self.tbReatainedUI,layAbility)
	-- 宝物所属信息界面lay
	local laySpecial = self.mainLayout.LAY_SPECIAL
	laySpecial:retain()
	table.insert(self.tbReatainedUI,laySpecial)
	-- 简介lay
	local layDescInfo = self.mainLayout.LAY_DESC_INFO
	layDescInfo:retain()
	table.insert(self.tbReatainedUI,layDescInfo)
	--------------------------------------------------------
	self.layLsvMain:removeAllItems()
	--------------------------------------------------------
	self:fnGetBaseInfo(layBaseInfo)
	self:fnGetAdvanceInfo(layAdvanceInfo)

	performWithDelay(self.layLsvMain, function(...)
		self:fnGetAbility(layAbility)
    end, 0.05)

    	performWithDelay(self.layLsvMain, function(...)
		self:fnGetSpecical(laySpecial)
    end, 0.07)

    performWithDelay(self.layLsvMain, function(...)
		self:fnGetDescInfo(layDescInfo)
    end, 0.09)

end

-- 底边栏内容
function SpecTreaInfoView:initFooter( ... )
	local m_i18n = gi18n

	local advanceRefineLel = self.speTreaInfo.refineLel 
	local specFragTid = self.speTreaInfo.speTreaFragDb.id

	local layBtns = self.mainLayout.LAY_BTNS
	local btnOk = layBtns.BTN_UNLOAD
	-- 获取途径

	if ( self.footerBtnType ==  1 or self.footerBtnType ==  2) then   --   如果是随便则显示掉落
		local btnHCangded = UIHelper.chagneGuildTOOk(btnOk)
		if (not btnHCangded) then
			btnOk:setTitleText(m_i18n[1098])
			btnOk:addTouchEventListener(function ( sender,eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					require "script/module/public/DropUtil"
					local curModuleName = LayerManager.curModuleName()
					local callFn
					if (curModuleName == "SBListCtrl") then
    					callFn = function ( ... )
							require "script/module/specialBag/SBListCtrl"
							SBListCtrl.refreshItemList()
						end
	    			end

					require "script/module/public/FragmentDrop"
					local fragmentDrop = FragmentDrop:new()
					local dropLayout = fragmentDrop:create(specFragTid,callFn)
					LayerManager.addLayout(dropLayout)
				end
			end)
		end
	else
	-- 返回
		btnOk:addTouchEventListener(function (  sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
		 		LayerManager.removeLayout(_mainLayout)
	 		end
		end)
	end
end













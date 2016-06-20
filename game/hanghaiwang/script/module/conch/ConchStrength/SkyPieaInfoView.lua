-- FileName: SkyPieaInfoView.lua
-- Author: wangming
-- Date: 2015-02-27
-- Purpose: 空岛贝信息显示 三种方式
--[[TODO List]]

module("SkyPieaInfoView", package.seeall)

-- UI控件引用变量 --
local mItemUtil = ItemUtil
local m_i18n = gi18n
local m_getWidget = g_fnGetWidgetByName
local mUI = UIHelper
local mLayerM = LayerManager
local mainLayout
-- 模块局部变量 --
local mConchInfo
local mViewType
local _isChangeBtnTip = false -- 更换按钮的红点是否可见

local function init(...)

end

function destroy(...)
	package.loaded["SkyPieaInfoView"] = nil
end

function moduleName()
    return "SkyPieaInfoView"
end

--ui信息初始化
local function initConchInfo( ... )	
	local pDb = mConchInfo.itemDesc

	local tfdName = m_getWidget(mainLayout, "TFD_CONCH_NAME")
	tfdName:setText(pDb.name)
	tfdName:setColor(HeroPublicUtil.getLightColorByStarLv(pDb.quality))
	UIHelper.labelNewStroke(tfdName, ccc3(0x24, 0x00, 0x00))

	local pIcon = mItemUtil.createBtnByItem(pDb)
	local imgIcon = m_getWidget(mainLayout, "IMG_ICON")
	imgIcon:addChild(pIcon)

	local tfdLv = m_getWidget(mainLayout, "TFD_LEVEL")
	tfdLv:setText("Lv." .. mConchInfo.lv)

	local pAttrInfo
	local pT = ""
	if (mItemUtil.fnIsExpConchType(pDb.type) ) then -- 如果是经验空岛贝
        pAttrInfo = {{name = m_i18n[1723], num = pDb.baseExp},}
	else
		pT = "："
		pAttrInfo = mItemUtil.getConchNumerialByItemId(mConchInfo.item_id , nil ,mConchInfo)
	end
	if(table.count(pAttrInfo) > 0) then
		local tfdAffix = m_getWidget(mainLayout, "TFD_AFFIX")
		local pStr = string.format("%s%s",pAttrInfo[1].name , pT)
		tfdAffix:setText(pStr)
		local tfdAffixNum = m_getWidget(mainLayout, "TFD_AFFIX_NUM")
		tfdAffixNum:setText(pAttrInfo[1].num)
	else
		local imgAffixBg = m_getWidget(mainLayout, "img_affix_bg_1")
		imgAffixBg:setVisible(false)
	end

	local imgStar
	for i=1,6 do
		if(i > pDb.quality) then
			imgStar = m_getWidget(mainLayout, "IMG_STAR_" .. i)
			imgStar:setVisible(false)
		end
	end

	local imgType = m_getWidget(mainLayout, "IMG_TYPE_NAME")
	imgType:loadTexture(mUI.fnGetConchTypeFilePath(pDb.type))

end

--确定按钮
local function fnOnSure( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		mLayerM.removeLayout()
	end
end

--关闭按钮
local function fnOnClose( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		mLayerM.removeLayout()
	end
end

--更换按钮
local function fnOnChange( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		mLayerM.removeLayout()
		local curHeroHid = mConchInfo.hid or 3
		local curItemId = mConchInfo.item_id
		local curPos = mConchInfo.pos
		require "script/module/conch/ConchStrength/SkyPleaSelect"
		local selectLayout = SkyPleaSelect.create(curHeroHid, curPos, curItemId)
		if(selectLayout)then
			mLayerM.addLayoutNoScale(selectLayout,mLayerM.getModuleRootLayout())
			UIHelper.changepPaomao(selectLayout) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
		end
	end
end

--升级按钮
local function fnOnStrength( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- if( mItemUtil.fnIsExpConchType(mConchInfo.itemDesc.type) ) then-- 经验空岛贝
		-- 	ShowNotice.showShellInfo(m_i18n[5509])
		-- 	return
		-- end
		mLayerM.removeLayout()
		local pType = "formation"
		if(mViewType ~= 1) then
			pType = "bag"
		end
		require "script/module/conch/ConchStrength/SkyPieaStrenthMain"
		SkyPieaStrenthMain.create(mConchInfo,pType)
	end
end

function create(tbConch,viewType, isChangeBtnTip)
	mConchInfo = tbConch
	mViewType = tonumber(viewType) or 2
	_isChangeBtnTip = isChangeBtnTip or false

	logger:debug("wm----createConch")
	logger:debug(mConchInfo)
		--副本标签
	if (mViewType == 1) then
		mainLayout = g_fnLoadUI("ui/conch_info.json")
		local tfdDesc = m_getWidget(mainLayout, "TFD_DESC")
		tfdDesc:setText(m_i18n[5505])
		local btnConfirm = m_getWidget(mainLayout, "BTN_CONFIRM")
		btnConfirm:addTouchEventListener(fnOnChange)
		mUI.titleShadow(btnConfirm,m_i18n[5506])
		--更换
		local btnConfirmSure = m_getWidget(mainLayout, "BTN_CONFIRM_SURE")
		btnConfirmSure:addTouchEventListener(fnOnStrength)
		mUI.titleShadow(btnConfirmSure, m_i18n[5507])
		--去升级
	else
		mainLayout = g_fnLoadUI("ui/conch_info_bag.json")
		local btnConfirm = m_getWidget(mainLayout, "BTN_CONFIRM")
		--去升级
		local btnConfirmSure = m_getWidget(mainLayout, "BTN_CONFIRM_SURE")
		local btSure = m_getWidget(mainLayout, "BTN_SURE")
		if (mViewType == 2) then
			btnConfirm:removeFromParentAndCleanup(true)
			btnConfirmSure:removeFromParentAndCleanup(true)
			btSure:addTouchEventListener(fnOnSure)
			mUI.titleShadow(btSure, m_i18n[5508])
		else
			btSure:removeFromParentAndCleanup(true)
			btnConfirm:addTouchEventListener(fnOnStrength)
			mUI.titleShadow(btnConfirm, m_i18n[5507])

			btnConfirmSure:addTouchEventListener(fnOnSure)
			mUI.titleShadow(btnConfirmSure, m_i18n[5508])
		end
	end

	-- 红点
	if (mainLayout.BTN_CONFIRM and mainLayout.BTN_CONFIRM.IMG_RED) then
		if (_isChangeBtnTip == true) then
			if(not mainLayout.BTN_CONFIRM.IMG_RED:getNodeByTag(10)) then
				local tip = UIHelper.createRedTipAnimination()
				tip:setTag(10)
				mainLayout.BTN_CONFIRM.IMG_RED:addNode(tip,10)
			end
		end
		mainLayout.BTN_CONFIRM.IMG_RED:setVisible(_isChangeBtnTip)
	end

	local backBtn = m_getWidget(mainLayout, "BTN_CLOSE")
	backBtn:addTouchEventListener(fnOnClose)

	initConchInfo()

	return mainLayout
end

-- FileName: SkyPieaBuffView.lua
-- Author: zhangjunwu
-- Date: 2015-1-14
-- Purpose: 空岛buff层选择buff view


module("SkyPieaBuffView", package.seeall)


-- UI控件引用变量 --
local m_UIMain
local m_tfdNowStarNum

local m_i18n = gi18n
local m_i18nString = gi18nString

-- 模块局部变量 --
local m_fnGetWidget 		= g_fnGetWidgetByName
local m_tbAffixItem			= {}

local function init(...)
	m_tbAffixItem			= nil
	m_tbAffixItem			= {}
end


function destroy(...)
	package.loaded["SkyPieaBuffView"] = nil
end


function moduleName()
	return "SkyPieaBuffView"
end

local function getBuffInfoBy(buffId)
	local buffInfo = 	DB_Sky_piea_buff.getDataById(buffId)

end

function setStarLabelValue()

	m_tfdNowStarNum:setText(SkyPieaModel.getStarNum() .. "")

end


function setBtnBuffGray( _btnBuff )
	-- UIHelper.setWidgetGray(_btnBuff,true)

	local IMG_GRAY = m_fnGetWidget(_btnBuff,"IMG_GRAY")
	IMG_GRAY:setEnabled(true)
		
end

--更新界面，设置次buff为已购买
function updateBoughtBuffView( _index )
	local buffLay = m_fnGetWidget(m_UIMain,"img_unless_" .. _index)

	local IMG_CHOOSE = m_fnGetWidget(buffLay,"IMG_CHOOSE")
	local BTN_BUFF = m_fnGetWidget(buffLay,"BTN_BUFF_BG")
	IMG_CHOOSE:setEnabled(true)
	BTN_BUFF:setTouchEnabled(false)


	setBtnBuffGray(buffLay)
end

function testFn()
	local buffLay = m_fnGetWidget(m_UIMain,"img_unless_" .. 1)
	UIHelper.setWidgetGray(buffLay,false)
end

function create(tbEvent,tbBuffInfo)

	init()

	m_UIMain = g_fnLoadUI("ui/air_buff.json")

	local imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	local btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	btnClose:addTouchEventListener(tbEvent.onClose)

	local btnGo = m_fnGetWidget(m_UIMain, "BTN_GO")
	btnGo:addTouchEventListener(tbEvent.onGoOn)
	UIHelper.titleShadow(btnGo, m_i18nString(5419))
	-- buff选择部分
	local tfdDesc = m_fnGetWidget(m_UIMain, "tfd_choose_desc")
	local tfd_now_star_txt = m_fnGetWidget(m_UIMain, "tfd_now_star_txt")
	tfd_now_star_txt:setText(m_i18nString(5472))

	m_tfdNowStarNum = m_fnGetWidget(m_UIMain, "TFD_NOW_STAR")
	m_tfdNowStarNum:setText(SkyPieaModel.getStarNum() .. "")
	-- UIHelper.labelNewStroke(m_tfdNowStarNum)

	local tbBuffData = tbBuffInfo

	for i=1,3 do
		local buffItem = m_fnGetWidget(m_UIMain,"img_unless_" .. i)
		

		local BTN_BUFF = m_fnGetWidget(buffItem, "BTN_BUFF_BG" )
		BTN_BUFF:setTag(i)

		local IMG_BUFF_NAME = m_fnGetWidget(buffItem, "IMG_BUFF_NAME" )
		IMG_BUFF_NAME:loadTexture(tbBuffData[i].nameImg)



		local imgIcon = m_fnGetWidget(buffItem, "IMG_ICON")
		imgIcon:loadTexture(tbBuffData[i].iconImg)


		local LAY_BUFF_DESC = m_fnGetWidget(buffItem ,"LAY_BUFF_DESC")

		local richText = tbBuffData[i].richText
		richText:setSize(LAY_BUFF_DESC:getSize())
		richText:setAnchorPoint(ccp(0.0,0.0))
		richText:ignoreContentAdaptWithSize(false)  -- 自动换行
		LAY_BUFF_DESC:addChild(richText)
		richText:setAlignCenter(true)
		richText:setVerticalSpace(-3)
		richText:release()


		local tfdCostNum = m_fnGetWidget(buffItem, "TFD_COST_STAR_NUM")
		tfdCostNum:setText(tostring(tbBuffData[i].costStarNum))
		UIHelper.labelNewStroke(tfdCostNum)


		logger:debug("%s buff被处理过了没有 %s" ,tbBuffData[i].name,tbBuffData[i].status )
		local IMG_CHOOSE = m_fnGetWidget(buffItem,"IMG_CHOOSE")
		IMG_CHOOSE:setEnabled(false)		

		local IMG_GRAY = m_fnGetWidget(buffItem,"IMG_GRAY")
		IMG_GRAY:setEnabled(false)
		--海没有处理过次buff
		if(tonumber(tbBuffData[i].status) == 1) then
			IMG_CHOOSE:setEnabled(true)
			setBtnBuffGray(buffItem)
		else
			BTN_BUFF:addTouchEventListener(tbEvent.onBuff)
		end
	end

	setBuffUI()

	return m_UIMain
end

--每次更新属性前，删除上一次的属性item、
local function removeAffixItem()
	for i,v in ipairs(m_tbAffixItem) do
		v:removeFromParentAndCleanup(true)
	end
	m_tbAffixItem = nil
	m_tbAffixItem = {}
end

local nBuffGap = 20
--设置此次爬塔的buff加成信息界面
function setBuffUI()
	--每次更新属性前，删除上一次的属性item、
	removeAffixItem()

	local buffAddedInfo = SkyPieaModel.getBuffInfoBought()

	local img_buff_parent 	= m_fnGetWidget(m_UIMain,"LAY_TEST_BUFF")   --buff父节点
	local LAY_BUFF 			= m_fnGetWidget(m_UIMain,"LAY_OWN_BUFF")   --buff父节点
	LAY_BUFF:setEnabled(true)

	local posY = LAY_BUFF:getPositionY()
	local posX = LAY_BUFF:getPositionX()
	local sizeBuff = LAY_BUFF:getSize()

	local index = 1

	--用来存放buff属性的icon图片，来判断俩属性是否需要砍掉一个
	local tbAttrImage = {}

	local function isImageExist( _iconImg )
		for i,v in ipairs(tbAttrImage) do
			if(v == _iconImg) then
				return true
			end
		end
		return false
	end

	for k,v in pairs(buffAddedInfo) do
		local buffClone = LAY_BUFF:clone()
		buffClone:setPositionType(POSITION_ABSOLUTE)

		local tb_DBInfo = SkyPieaUtil.getOwnBuffDataByAffixId(k)

		if(isImageExist(tb_DBInfo.smallIconImg) == true) then
			logger:debug("同类buff已经存在")
		else
			--图片
			local IMG_OWN_ICON = m_fnGetWidget(buffClone,"IMG_OWN_ICON")
			IMG_OWN_ICON:loadTexture(tb_DBInfo.smallIconImg)

			local IMG_BUFF_NAME = m_fnGetWidget(buffClone,"IMG_OWN_DESC")
			IMG_BUFF_NAME:loadTexture(tb_DBInfo.smallNameImg)

			local TFD_OWN_DESC_NUM = m_fnGetWidget(buffClone,"TFD_OWN_DESC_NUM")
			TFD_OWN_DESC_NUM:setText("+" .. v/100 .. "%")
			-- UIHelper.labelNewStroke(TFD_OWN_DESC_NUM)

			table.insert(tbAttrImage,tb_DBInfo.smallIconImg)
			table.insert(m_tbAffixItem, buffClone)

			img_buff_parent:addChild(buffClone)
			index = index + 1
		end
	end


	local nBuffCount = table.count(m_tbAffixItem)
	local	nStartPosX = (img_buff_parent:getSize().width  - sizeBuff.width * nBuffCount - nBuffGap * nBuffCount) / 2
	for i,v in ipairs(m_tbAffixItem) do
		v:setPosition(ccp(nStartPosX +  (sizeBuff.width + nBuffGap) * (i - 1), posY))
	end

	LAY_BUFF:setEnabled(false)
end

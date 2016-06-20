-- FileName: GameBookView.lua
-- Author: LvNanchun
-- Date: 2015-12-22
-- Purpose: function description of module
--[[TODO List]]

GameBookView = class("GameBookView")

-- UI variable --

-- module local variable --
local _fnGetWidget = g_fnGetWidgetByName
local _gColor = g_QulityColor

function GameBookView:moduleName()
    return "GameBookView"
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function setBtnColor( btn, ttfColor )
	local ttf = tolua.cast(btn:getTitleTTF(), "CCLabelTTF")
	ttf:setColor(ttfColor)
end

function GameBookView:ctor( tbIndex )
	self._layMain = g_fnLoadUI("ui/game_book.json")

	UIHelper.initListView(self._layMain.LSV_BTN)
	-- 根据传入的index信息定位在某个cell
	if (tbIndex) then 
		-- 未传主tab定位点默认定在1
		self:reloadMainTab(tbIndex.mainTab or 1)
	else
		self:reloadMainTab(1)
	end

	-- 用于伙伴图鉴界面的listView是否已经初始化
	self._bInit1 = false
	-- 用于我要变强界面的listView是否已经初始化
	self._bInit2 = false
	-- 推荐阵容里面的cell里面的listView是否已经初始化
	self._bInit3 = false

	self._ICON_TAG = 9999

	-- 初始化控件显示状态
	UIHelper.titleShadow(self._layMain.BTN_L)
	UIHelper.titleShadow(self._layMain.BTN_M)
	UIHelper.titleShadow(self._layMain.BTN_R)
	setBtnColor(self._layMain.BTN_L, ccc3(0xff, 0xde, 0xad))
	setBtnColor(self._layMain.BTN_M, ccc3(0xff, 0xde, 0xad))
	setBtnColor(self._layMain.BTN_R, ccc3(0xff, 0xde, 0xad))
end

--[[desc:存储当前界面显示的按钮，以便在第二次点击的时候不反映
    arg1: 按钮类型，信息索引
    return: 无
—]]
function GameBookView:setMainListPreBtn( nowListBtn )
	self._nowListBtn:setTouchEnabled(true)
	self._nowListBtn:setFocused(false)
	self._nowListBtn = nowListBtn
	self._nowListBtn:setTouchEnabled(false)
	self._nowListBtn:setFocused(true)
end

--[[desc:根据左侧listView按钮的按钮类型初始化中间的界面
    arg1: 按钮类型
    return: 无 
—]]
function GameBookView:initLayByBtnType( btnType )
	self._layMain.lay_bg_2:setEnabled(false)
	self._layMain.lay_bg_3:setEnabled(false)
	self._layMain.lay_bg_1:setEnabled(false)
	if (btnType == 1) then
		self._layMain.lay_bg_1:setEnabled(true)
		self._layMain.lay_bg_1.lay_cell_way:setEnabled(true)
		self._layMain.lay_bg_1.lay_cell_type:setEnabled(true)
		if (not self._bInit3) then
			UIHelper.initListView(self._layMain.lay_bg_1.lay_cell_type.LSV_TYPE)
			self._bInit3 = true
		end
		UIHelper.initListViewCell(self._layMain.lay_bg_1.LSV_BG_1, self._layMain.lay_bg_1.lay_cell_type)
		self._layMain.lay_bg_1.lay_cell_way:setEnabled(false)
		self._layMain.lay_bg_1.lay_cell_type:setEnabled(false)
	elseif (btnType == 2) then
		self._layMain.lay_bg_2:setEnabled(true)
		if (not self._bInit1) then
			UIHelper.initListView(self._layMain.lay_bg_2.LSV_HERO)
			UIHelper.initListView(self._layMain.lay_bg_2.LSV_BG_2)
			self._bInit1 = true
		end
	elseif (btnType == 3) then
		self._layMain.lay_bg_3:setEnabled(true)
		if (not self._bInit2) then
			UIHelper.initListViewCell(self._layMain.lay_bg_3.LSV_BG_3)
			self._bInit2 = true
		end
	elseif (btnType == 4) then
		self._layMain.lay_bg_1:setEnabled(true)
		self._layMain.lay_bg_1.lay_cell_way:setEnabled(true)
		self._layMain.lay_bg_1.lay_cell_type:setEnabled(true)
		UIHelper.initListViewCell(self._layMain.lay_bg_1.LSV_BG_1, self._layMain.lay_bg_1.lay_cell_way)
		self._layMain.lay_bg_1.lay_cell_way:setEnabled(false)
		self._layMain.lay_bg_1.lay_cell_type:setEnabled(false)
	end
end

--[[desc:刷新推荐阵容中央显示区
    arg1: 刷新用的table
    return: 无  
—]]
function GameBookView:reloadMainLayFormation( tbFormationInfo )
	local function updateFormationCell( list, i )
		local cell = list:getItem(i)
		local cellInfo = GameBookModel.getRecommendFormationInfo(i + 1)

		cell.tfd_type:setText(cellInfo.formationName)
		UIHelper.initListWithNumAndCell(cell.LSV_TYPE, #cellInfo.heroList)
		if (#cellInfo.heroList <= 5) then
			cell.LSV_TYPE:setTouchEnabled(false)
		else
			cell.LSV_TYPE:setTouchEnabled(true)
		end
		for j = 1, #cellInfo.heroList do
			local iconCell = cell.LSV_TYPE:getItem(j - 1)
			local heroIcon = HeroUtil.createHeroIconBtnByHtid( cellInfo.heroList[j], nil, function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playInfoEffect()
					local descView = PartnerDescView:new()
					LayerManager.addLayout(descView:create(cellInfo.heroList[j]))
				end
			end)
			if (iconCell.LAY_TYPE_HEAD:getChildByTag(self._ICON_TAG)) then
				iconCell.LAY_TYPE_HEAD:removeAllChildren()
			end
			iconCell.LAY_TYPE_HEAD:addChild(heroIcon, 1, self._ICON_TAG)
			heroIcon:setPosition(ccp(iconCell.LAY_TYPE_HEAD:getSize().width/2, iconCell.LAY_TYPE_HEAD:getSize().height/2))
		end
	end
	UIHelper.reloadListView(self._layMain.lay_bg_1.LSV_BG_1, #tbFormationInfo, updateFormationCell, 0, true)
end

--[[desc:刷新推荐伙伴中央显示区
    arg1: 伙伴信息的table
    return: 无
—]]
function GameBookView:reloadMainLayRecommendPartner( tbPartnerInfo )
	UIHelper.labelAddNewStroke(self._layMain.lay_bg_2.tfd_hero, "推荐伙伴", ccc3(0x9c, 0x4d, 0x00))
	UIHelper.initListWithNumAndCell(self._layMain.lay_bg_2.LSV_HERO, #tbPartnerInfo.heroList)
	UIHelper.initListWithNumAndCell(self._layMain.lay_bg_2.LSV_BG_2, #tbPartnerInfo.heroList)
	self._layMain.lay_bg_2.LSV_BG_2:jumpToTop()
	-- 伙伴数量小与6个的时候手动居中
	if (#tbPartnerInfo.heroList < 6) then
		self._layMain.lay_bg_2.LSV_HERO:setTouchEnabled(true)
		local subPositionX = self._layMain.lay_bg_2.LSV_HERO.lay_hero_bg:getSize().width * ((6 - #tbPartnerInfo.heroList) * 0.5)
		self._layMain.lay_bg_2.LSV_HERO:setPositionX(subPositionX)
	else
		self._layMain.lay_bg_2.LSV_HERO:setPositionX(0)
	end
	for i = 1, #tbPartnerInfo.heroList do
		-- 横着的listView的设置
		local cell1 = self._layMain.lay_bg_2.LSV_HERO:getItem(i - 1)
		if (cell1.LAY_ICON:getChildByTag(self._ICON_TAG)) then
			cell1.LAY_ICON:removeAllChildren()
		end
		local heroIcon1 = HeroUtil.createHeroIconBtnByHtid(tbPartnerInfo.heroList[i], nil, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playInfoEffect()
				local descView = PartnerDescView:new()
				LayerManager.addLayout(descView:create(tbPartnerInfo.heroList[i]))
			end
		end)
		cell1.LAY_ICON:addChild(heroIcon1, 1, self._ICON_TAG)
		heroIcon1:setPosition(ccp(cell1.LAY_ICON:getSize().width/2, cell1.LAY_ICON:getSize().height/2))
		-- 竖着的listView的设置
		local cell2 = self._layMain.lay_bg_2.LSV_BG_2:getItem(i - 1)
		if (cell2.LAY_HEAD:getChildByTag(self._ICON_TAG)) then
			cell2.LAY_HEAD:removeAllChildren()
		end
		local heroIcon2 = HeroUtil.createHeroIconBtnByHtid(tbPartnerInfo.heroList[i], nil, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playInfoEffect()
				local descView = PartnerDescView:new()
				LayerManager.addLayout(descView:create(tbPartnerInfo.heroList[i]))
			end
		end)
		cell2.LAY_HEAD:addChild(heroIcon2, 1, self._ICON_TAG)
		heroIcon2:setPosition(ccp(cell2.LAY_HEAD:getSize().width/2, cell2.LAY_HEAD:getSize().height/2))
		cell2.tfd_name:setText(tbPartnerInfo.heroInfo[i].name)
		cell2.tfd_name:setColor(_gColor[tbPartnerInfo.heroInfo[i].quality])
		cell2.TFD_DESC:setText(tbPartnerInfo.heroInfo[i].desc)
	end
end

--[[desc:刷新我要变强的中央的区域
    arg1: 刷新的信息
    return: 无
—]]
function GameBookView:reloadMainLayWantStrong( tbStrongInfo )
	GameBookModel.setCellData( tbStrongInfo, "strong" )
	local function updateStrongCell( list, i )
		local cellInfo = GameBookModel.getCellDataByIndex(i + 1, "strong")
		local cell = list:getItem(i)

		cell.IMG_WAY:loadTexture(cellInfo.imgPath)
		cell.tfd_way_name:setText(cellInfo.name)
		cell.TFD_WAY_DESC:setText(cellInfo.desc)
	end
	UIHelper.reloadListView(self._layMain.lay_bg_1.LSV_BG_1, #tbStrongInfo, updateStrongCell, 0, true)
end

--[[desc:刷新伙伴图鉴中央的区域
    arg1: 刷新的信息
    return: 无
—]]
function GameBookView:reloadPartnerDictionary( tbDictionaryInfo, tbHaveNumInfo )
	UIHelper.labelAddNewStroke(self._layMain.lay_bg_3.TFD_NUM, "数量："..tostring(tbHaveNumInfo.hadNum).."/"..tostring(tbHaveNumInfo.totalNum), ccc3(0x9c, 0x4d, 0x00))
	GameBookModel.setCellData(tbDictionaryInfo, "partner")
	local function updateDictionaryCell( list, i )
		local cell = list:getItem(i)
		local cellInfo = GameBookModel.getCellDataByIndex(i + 1, "partner")

		for i = 1,3 do
			local iconWidget = _fnGetWidget(cell, "lay_book_bg_" .. tostring(i))
			if (cellInfo[i]) then
				iconWidget:setEnabled(true)
				iconWidget.TFD_BOOK_NAME:setText(cellInfo[i].name)
				iconWidget.TFD_BOOK_NAME:setColor(_gColor[cellInfo[i].quality])
				if (iconWidget.LAY_BOOK_HEAD:getChildByTag(self._ICON_TAG)) then
					iconWidget.LAY_BOOK_HEAD:removeAllChildren()
				end
				local heroIcon = HeroUtil.createHeroIconBtnByHtid(cellInfo[i].id, nil, function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playInfoEffect()
						local heroInfo = {htid = cellInfo[i].id ,hid = 0,strengthenLevel = 0 ,transLevel = 0,showOnly = true }
	        			local tArgs = {}
	        			tArgs.heroInfo = heroInfo
	        			local layer = PartnerInfoCtrl.create(tArgs,4)
	        			LayerManager.addLayoutNoScale(layer)
					end
				end)
				iconWidget.LAY_BOOK_HEAD:addChild(heroIcon, 1, self._ICON_TAG)
				heroIcon:setPosition(ccp(iconWidget.LAY_BOOK_HEAD:getSize().width/2, iconWidget.LAY_BOOK_HEAD:getSize().height/2))
				if (cellInfo[i].bHad) then
					UIHelper.setWidgetGray(heroIcon, false)
					iconWidget.TFD_BOOK_NAME:setColor(ccc3(0x7f, 0x5f, 0x20))
					iconWidget.TFD_BOOK_BROKEN:setColor(ccc3(0xb4, 0x92, 0x5f))
				else
					UIHelper.setWidgetGray(heroIcon, true)
					iconWidget.TFD_BOOK_NAME:setColor(ccc3(0x64, 0x64, 0x64))
					iconWidget.TFD_BOOK_BROKEN:setColor(ccc3(0x9c, 0x9c, 0x9c))
				end
				if (cellInfo[i].canBreak) then
					iconWidget.TFD_BOOK_BROKEN:setEnabled(true)
					iconWidget.TFD_BOOK_BROKEN:setText("(可突破为橙色)")
				else
					iconWidget.TFD_BOOK_BROKEN:setEnabled(false)
				end
			else
				iconWidget:setEnabled(false)
			end
		end
	end
	UIHelper.reloadListView(self._layMain.lay_bg_3.LSV_BG_3, #tbDictionaryInfo, updateDictionaryCell, 0, true)
end

--[[desc:刷新左侧listView
    arg1: listView的数据
    return: 无
—]]
function GameBookView:reloadMainList( mainListInfo )
	local listInfo = mainListInfo.tbList
	UIHelper.initListWithNumAndCell(self._layMain.LSV_BTN, #listInfo)
	self._layMain.LSV_BTN:jumpToTop()
	if (#listInfo < 6) then
		self._layMain.LSV_BTN:setTouchEnabled(false)
	else
		self._layMain.LSV_BTN:setTouchEnabled(true)
	end
	for i,v in ipairs(listInfo) do 
		local cell = self._layMain.LSV_BTN:getItem(i - 1)
		cell.BTN_TAB:setTouchEnabled(true)
		cell.BTN_TAB:setFocused(false)
		cell.BTN_TAB:setTitleText(v.btnName)
		setBtnColor(cell.BTN_TAB, ccc3(0x7f, 0x5f, 0x20))
		cell.BTN_TAB:addTouchEventListener(v.btnFunc)
	end
	-- 禁用第一个即当前按钮
	self._nowListBtn = self._layMain.LSV_BTN:getItem(0).BTN_TAB
	self._nowListBtn:setFocused(true)
	self._nowListBtn:setTouchEnabled(false)
end

--[[desc:刷新主列表的显示状态
    arg1: 将要选中的按钮
    return: 无
—]]
function GameBookView:reloadMainTab( mainTabIndex )
	if (self.preMainTab) then
		self.preMainTab:setFocused(false)
		self.preMainTab:setTouchEnabled(true)
		setBtnColor(self.preMainTab, ccc3(0xff, 0xde, 0xad))
	end

	if (mainTabIndex == 2) then
		self._layMain.BTN_M:setFocused(true)
		self._layMain.BTN_M:setTouchEnabled(false)
		self.preMainTab = self._layMain.BTN_M
	elseif (mainTabIndex == 3) then
		self._layMain.BTN_R:setFocused(true)
		self._layMain.BTN_R:setTouchEnabled(false)
		self.preMainTab = self._layMain.BTN_R
	else
		self._layMain.BTN_L:setFocused(true)
		self._layMain.BTN_L:setTouchEnabled(false)
		self.preMainTab = self._layMain.BTN_L
	end
	setBtnColor(self.preMainTab, ccc3(0xff, 0xff, 0xff))
end

--[[desc:刷新战斗力
    arg1: 战斗力数值，提升按钮按钮事件
    return: 无 
—]]
function GameBookView:reloadFightValue( fightValue, onRise )
	self._layMain.LABN_FIGHT:setStringValue(fightValue)
	self._layMain.BTN_UP:addTouchEventListener(onRise)
end

function GameBookView:create( tbBtn, tbInfo )
	-- 主要的按钮事件
	self._layMain.BTN_CLOSE:addTouchEventListener(tbBtn.onClose)
	self._layMain.BTN_L:addTouchEventListener(tbBtn.onRecommendFormation)
	self._layMain.BTN_M:addTouchEventListener(tbBtn.onPartnerDictionary)
	self._layMain.BTN_R:addTouchEventListener(tbBtn.onWantStrong)

	return self._layMain
end


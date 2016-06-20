-- FileName: WARankView.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

WARankView = class("WARankView")

-- UI控件引用变量 --

-- 模块局部变量 --
local RICH_TEXT_TAG = 125565
local _fnGetWidget = g_fnGetWidgetByName

function WARankView:updateCellCommon( lsv,idx )
	local rankInfo = WARankModel.getNowTabInfo()
	local tbData = rankInfo[idx+1]
	local cell = lsv:getItem(idx).item

	cell.IMG_RANK_NUM1:setVisible(idx == 0)
	cell.IMG_RANK_NUM2:setVisible(idx == 1)
	cell.IMG_RANK_NUM3:setVisible(idx == 2)
	cell.IMG_RANK:setVisible(idx>2)
	cell.LABN_RANK_AFTER4:setVisible(idx>2)
	cell.LABN_RANK_AFTER4:setStringValue(tostring(idx+1))
	cell.TFD_SERVER_NUM:setText("S."..tbData.server_id)
	cell.TFD_PLAYER_NAME:setText(tbData.uname)
	cell.TFD_LV_NUM:setText(tbData.level)
	cell.TFD_ZHANDOULI_NUM:setText(tbData.fight_force)
	logger:debug({print_tbdata_guildName = tbData.guild_name})
	if (tbData.guild_name == nil or tbData.guild_name == "") then
		cell.tfd_union_desc:setVisible(false)
		cell.TFD_UNION_NAME:setVisible(false)
	else
		cell.tfd_union_desc:setVisible(true)
		cell.TFD_UNION_NAME:setVisible(true)
		cell.TFD_UNION_NAME:setText(tbData.guild_name)
	end

	local color = UserModel.getPotentialColor({htid = tbData.figure})
	cell.TFD_PLAYER_NAME:setColor(color)
	cell.TFD_SERVER_NUM:setColor(color)
	local icon = HeroUtil.createHeroIconBtnByHtid(tonumber(tbData.figure))
	cell.IMG_FRAME_BG:removeAllChildrenWithCleanup(true)
	cell.IMG_FRAME_BG:addChild(icon)

	cell.BTN_FORMATION:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect() 
			local serverId = tbData.server_id
			local pid = tbData.pid
			WAService.getFighterDetail(serverId, pid, FormationCtrl.loadDiffServerFormation)
		end
	end)
end

function WARankView:showContiRank( rankInfo )
	if (rankInfo.myRankInfo) then
		self.layMain.TFD_RANK_NUM:setText(rankInfo.myRankInfo.rank)
		self.layMain.TFD_KILL_NUM:setText(rankInfo.myRankInfo.max_conti_num)
		self.layMain.tfd_my_kill:setText("最大连杀：")
		self.layMain.tfd_my_kill:setVisible(true)
		self.layMain.TFD_KILL_NUM:setVisible(true)
	else
		self.layMain.TFD_RANK_NUM:setText("未上榜")
		self.layMain.tfd_my_kill:setVisible(false)
		self.layMain.TFD_KILL_NUM:setVisible(false)
	end
		
	local function updateCellByIdex( lsv, idx )
		local tbData = rankInfo[idx+1]
		local cell = lsv:getItem(idx).item

		cell.LAY_KILL:setVisible(true)
		cell.tfd_kill_desc:setText("最大连杀：")
		cell.TFD_KILL_NUM:setText(tbData.max_conti_num)
		self:updateCellCommon( lsv,idx )
	end
	UIHelper.reloadListView(self.listView,#rankInfo,updateCellByIdex, 0)
end

function WARankView:showKillRank( rankInfo )
	if (rankInfo.myRankInfo) then
		self.layMain.TFD_RANK_NUM:setText(rankInfo.myRankInfo.rank)
		self.layMain.TFD_KILL_NUM:setText(rankInfo.myRankInfo.kill_num)
		self.layMain.tfd_my_kill:setText("击杀：")
		self.layMain.tfd_my_kill:setVisible(true)
		self.layMain.TFD_KILL_NUM:setVisible(true)
	else
		self.layMain.TFD_RANK_NUM:setText("未上榜")
		self.layMain.tfd_my_kill:setVisible(false)
		self.layMain.TFD_KILL_NUM:setVisible(false)
	end
	
	local function updateCellByIdex( lsv, idx )
		local tbData = rankInfo[idx+1]
		local cell = lsv:getItem(idx).item

		cell.tfd_kill_desc:setText("击杀：")
		cell.TFD_KILL_NUM:setText(tbData.kill_num)
		cell.LAY_KILL:setVisible(true)
		self:updateCellCommon( lsv,idx )
	end
	UIHelper.reloadListView(self.listView,#rankInfo,updateCellByIdex, 0)
end

function WARankView:showPosRank( rankInfo )
	if (rankInfo.myRankInfo) then
		self.layMain.TFD_RANK_NUM:setText(rankInfo.myRankInfo.rank)

		self.layMain.tfd_my_kill:setVisible(false)
		self.layMain.TFD_KILL_NUM:setVisible(false)
	else
		self.layMain.TFD_RANK_NUM:setText("未上榜")
		self.layMain.tfd_my_kill:setVisible(false)
		self.layMain.TFD_KILL_NUM:setVisible(false)
	end

	local function updateCellByIdex( lsv, idx )
		local tbData = rankInfo[idx+1]
		local cell = lsv:getItem(idx).item

		cell.LAY_KILL:setVisible(false)
		self:updateCellCommon( lsv,idx )
	end
	UIHelper.reloadListView(self.listView,#rankInfo,updateCellByIdex, 0)
end

function WARankView:showRankView( ... )
	local rankInfo = WARankModel.getNowTabInfo()
	local tabNum = WARankModel.getTabNum()
	for i = 1, 3 do
		local btnTab = _fnGetWidget(self.layMain, "BTN_RANK"..i)
		btnTab:setFocused(i == tonumber(tabNum))
		btnTab:setTouchEnabled(i ~= tonumber(tabNum))
		btnTab:setTag(i)
		btnTab:addTouchEventListener(WARankCtrl.getBtnFunByName("onChooseTab"))
	end

	--self.listView:removeAllItems()
	if (tonumber(tabNum)==1) then
		self:showContiRank(rankInfo)
	elseif (tonumber(tabNum)==2) then
		self:showKillRank(rankInfo)
	elseif (tonumber(tabNum)==3) then
		self:showPosRank(rankInfo)
	end
	--self.listView:jumpToPercentVertical(0)
	--UIHelper.setSliding( self.listView )
end

function WARankView:setBtnEvent( ... )
	self.layMain.BTN_CLOSE:addTouchEventListener(WARankCtrl.getBtnFunByName("onClose"))
	self.layMain.BTN_CONFIRM:addTouchEventListener(WARankCtrl.getBtnFunByName("onConfirm"))	
end

function WARankView:init(...)
	self.layMain = nil
end

function WARankView:destroy(...)
	package.loaded["WARankView"] = nil
end

function WARankView:moduleName()
    return "WARankView"
end

function WARankView:ctor( ... )
	self:init()
	self.layMain = g_fnLoadUI("ui/ranking_list.json")
end

function WARankView:create(...)
	UIHelper.registExitAndEnterCall(self.layMain,
		function()
			self.layMain = nil
		end,
		function()
		end
	)
	self.listView = self.layMain.LSV_LIST

	UIHelper.initListViewCell(self.listView)

	UIHelper.titleShadow( self.layMain.BTN_CONFIRM )
	
	self:showRankView()
	self:setBtnEvent()
	return self.layMain	
end

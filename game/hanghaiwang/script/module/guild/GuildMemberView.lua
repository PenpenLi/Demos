-- FileName: GuildMemberView.lua
-- Author: zhangqi
-- Date: 2014-09-19
-- Purpose: 联盟成员UI显示，包括成员列表和审核列表
--[[TODO List]]

module("GuildMemberView", package.seeall)


-- UI控件引用变量 --
local m_layMain  -- 成员模块主画布，包括页签按钮和返回

local m_layMember -- 成员列表主画布
local m_layMemberView
local m_layMemberCell

local m_layVerify -- 审核列表主画布
local m_btnSort -- 排序按钮
local m_btnRefuseAll -- 一键拒绝按钮
local m_layVerifyView -- 审核TableView
local m_layVerifyCell -- 审核cell

local m_btnVerify
local m_btnMember

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_color = g_TabTitleColor

local m_nRemainNum 	-- 剩余可同意数

local m_szVerifyCell -- 审核cell size

local m_tbTabs -- 页签按钮
local m_tbLists -- 列表 TableView
local m_tbView -- 列表容器，存放成员和审核的画布，便于切换显示状态

local m_tbTabCall -- 页签按钮事件回调

local m_sSortBtn -- 上次选择某个排序按钮的控件名称，用于对勾的显示
local m_curSortBtn -- 当前排序按钮名称

local m_redTipTag=1256

-- 所有排序按钮的标题和排序函数
local m_tbSortBtn = {
	["BTN_TIME"] = {title = m_i18n[3549], label = "tfd_time",fnSort = function (usr1, usr2) return tonumber(usr1.applyTime) > tonumber(usr2.applyTime) end },
	["BTN_LV"] = {title = m_i18n[3550], label = "tfd_lv", fnSort = function (usr1, usr2) return tonumber(usr1.level) > tonumber(usr2.level) end },
	["BTN_ZHANDOULI"] = {title = m_i18n[3551], label = "tfd_zhandouli", fnSort = function (usr1, usr2) return tonumber(usr1.fight) > tonumber(usr2.fight) end },
	["BTN_PVP"] = {title = m_i18n[3552], label = "tfd_pvp", fnSort = function (usr1, usr2) return (tonumber(usr1.arenaRank) or 100000) < tonumber(usr2.arenaRank or 100000) end },
}

local function init(...)
	m_tbTabs = {}
	m_tbLists = {}
	m_tbView = {}
	m_tbTabCall = {}
	m_sSortBtn = "BTN_TIME" -- 默认是时间排序
	m_curSortBtn = m_sSortBtn
end

function setReturnInfo(  )
	-- body
end

function destroy(...)
	if (m_layVerifyCell) then
		-- m_layVerifyCell:release() --liweidong 在onexit中调用了
		m_layVerifyCell = nil
	end
	if (m_layMemberCell) then
		-- m_layMemberCell:release()  --liweidong 在onexit中调用了
		m_layMemberCell = nil
	end

	m_tbTabs = nil
	m_tbLists = nil
	m_tbView = nil
	m_tbTabCall = nil

	m_layMain = nil

	package.loaded["GuildMemberView"] = nil
end

function moduleName()
	return "GuildMemberView"
end


local function changeTabStat(btn, bStat)
	local tabStat = bStat
	for i, tab in ipairs(m_tbTabs) do
		tabStat = (tab == btn) and bStat or (not bStat)

		tab:setFocused(tabStat)
		tab:setTitleColor(tabStat and m_color.selected or m_color.normal)
		tab:setTouchEnabled(not tabStat)
		if (m_tbView[i]) then
			m_tbView[i]:setEnabled(tabStat)
			m_tbLists[i]:refresh()
		elseif (tabStat) then
			local func = m_tbTabCall[i]
			if (func) then
				func()
			end
		end
	end
end


function changeByFlag( nFlag )
	changeTabStat(m_tbTabs[nFlag], true)
end


function checkBtnVerify( ... )
	if (GuildDataModel.getMineSigleGuildInfo().member_type == "0") then
		m_btnVerify:setEnabled(false)
		GuildMenuCtrl.update()
	end
end


function isOn( ... )
	return m_layMain
end


function create(tbListInfo, nFlag)
	if (not m_layMain) then
		init()
		m_layMain = g_fnLoadUI("ui/union_member_yeqian.json")
	end

	local imgBG = m_fnGetWidget(m_layMain, "img_bg")
	imgBG:setScale(g_fScaleX)

	local imgBackGround = m_fnGetWidget(m_layMain, "img_background")
	imgBackGround:setScale(g_fScaleX)

	local imgTabBg = m_fnGetWidget(m_layMain, "img_tab")
	imgTabBg:setScale(g_fScaleX)

	m_btnMember = m_fnGetWidget(m_layMain, "BTN_MEMBER")
	m_tbTabs[1] = m_btnMember
	m_tbTabCall[1] = tbListInfo.onMember
	UIHelper.titleShadow(m_btnMember, m_i18nString(3509, "  "))
	m_btnMember:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			changeTabStat(sender, true)
		end
	end)

	m_btnVerify = m_fnGetWidget(m_layMain, "BTN_VERIFY")
	m_tbTabs[2] = m_btnVerify
	m_tbTabCall[2] = tbListInfo.onVerify



	UIHelper.titleShadow(m_btnVerify, m_i18nString(3510, "  "))
	m_btnVerify:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			if (isHaveRedTip()) then   --红点已经存在的情况才删除，防止已经点开成员列表后推送的消息被取消
				g_redPoint.newGuildMemApply.visible = false 
				updateVerifyBtnTip()
				GlobalNotify.postNotify( "NEW_GUILD_MEMBER_APPLY")
			end 
			changeTabStat(sender, true)
		end
	end)

	local btnBack = m_fnGetWidget(m_layMain, "BTN_BACK")
	UIHelper.titleShadow(btnBack, m_i18n[1019])
	btnBack:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBackEffect()
			require "script/module/guild/MainGuildCtrl"
			MainGuildCtrl.create()
		end
	end)

	changeTabStat(m_tbTabs[nFlag], true) -- 成员页签保持按下状态

	require "script/module/guild/GuildMenuCtrl"
	m_layMain:addChild(GuildMenuCtrl.create()) -- 添加联盟主菜单
	checkBtnVerify()

	updateVerifyBtnTip()  --更新审核按钮红点

	UIHelper.registExitAndEnterCall(m_layMain, function ( ... )
		m_layMain = nil
	end)

	return m_layMain
end


-- 剩余可踢出人数label
function refreashKickLabel( ... )
	if (m_tbView and m_tbView[1]) then 
		local identity = GuildDataModel.getUserGuildIdentity()
		m_tbView[1].LABN_REMAIN_NUM:setVisible((identity==1 or identity==2) and true or false)
		local num = GuildDataModel.getRemainKickNum()
		m_tbView[1].LABN_REMAIN_NUM:setStringValue(num)
		m_tbView[1].img_remain_bg:setVisible((identity==1 or identity==2) and true or false)
	end 
end


function initMemberList( tbInfo, tabIndex )
	m_layMember = g_fnLoadUI("ui/union_member_list.json") -- 成员列表
	m_layMain:addChild(m_layMember)
	m_tbView[1] = m_layMember
	m_layMember.tfd_remain:setText(m_i18n[3594])
	m_layMember.tfd_ren:setText(m_i18n[3575])
	refreashKickLabel()

	m_layMemberView = m_fnGetWidget(m_layMember, "LAY_FORTBV") -- 列表容器layout
	m_layMemberCell = m_fnGetWidget(m_layMemberView, "LAY_CELL")
	m_layMemberCell:retain()
	m_layMemberCell:removeFromParentAndCleanup(true)

	m_tbLists[tabIndex] = HZListView:new()
	local hzList = m_tbLists[tabIndex]
	local tbCfg = createMemberViewCfg(tabIndex, tbInfo)

	if (hzList:init(tbCfg)) then
		local hzLayout = TableViewLayout:create(hzList:getView())
		m_layMemberView:addChild(hzLayout)
		hzList:refresh()
	end
	--liweidong 防止内存泄漏
	UIHelper.registExitAndEnterCall(m_layMember,function()
			m_layMemberCell:release()
		end
		)
end


function createMemberViewCfg( tabIndex, tbInfo )
	-- 构造列表需要的数据
	local szVerify = m_layMemberCell:getSize()
	local tbView = {}
	tbView.szCell = (tabIndex == 1 and CCSizeMake(szVerify.width * g_fScaleX, szVerify.height * g_fScaleX))
	tbView.tbDataSource = tbInfo.data

	require "script/module/guild/MemberCell"
	tbView.CellAtIndexCallback = function (tbData)
		local instCell = MemberCell:new(m_layMemberCell)
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:refresh(tbData)
		return instCell
	end

	local szView = m_layMemberView:getSize()
	tbView.szView = CCSizeMake(szView.width, szView.height)

	return tbView
end

-- 初始化审核列表
function initVerifyList( tbInfo, tabIndex )
	m_layVerify = g_fnLoadUI("ui/union_verify_list.json") -- 审核列表
	m_layMain:addChild(m_layVerify)
	m_tbView[2] = m_layVerify

	local tfdRemain = m_fnGetWidget(m_layVerify, "tfd_remain")
	local labnRemainNum = m_fnGetWidget(m_layVerify, "LABN_REMAIN_NUM")
	local tfdRen = m_fnGetWidget(m_layVerify, "tfd_ren")
	tfdRemain:setText(m_i18n[3574])
	m_nRemainNum = GuildUtil.isCanAgreeNum() - GuildDataModel.getJoinNum()
	labnRemainNum:setStringValue(m_nRemainNum)
	tfdRen:setText(m_i18n[3575])

	m_btnSort = m_fnGetWidget(m_layVerify, "BTN_SEQUENCE") -- 排序
	UIHelper.titleShadow(m_btnSort, m_i18n[3549])
	m_btnSort:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			tbInfo.onSort()
		end
	end)

	m_btnRefuseAll = m_fnGetWidget(m_layVerify, "BTN_REFUSEALL") -- 一键拒绝
	UIHelper.titleShadow(m_btnRefuseAll, m_i18n[3515])
	m_btnRefuseAll:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			tbInfo.onRefuseAll()
		end
	end)

	m_layVerifyView = m_fnGetWidget(m_layVerify, "LAY_FORTBV") -- 列表容器layout
	m_layVerifyCell = m_fnGetWidget(m_layVerifyView, "LAY_CELL")
	m_layVerifyCell:retain()
	m_layVerifyCell:removeFromParentAndCleanup(true)

	m_tbLists[tabIndex] = HZListView:new()
	local hzList = m_tbLists[tabIndex]
	local tbCfg = createVerifyViewCfg(tabIndex, tbInfo)

	if (hzList:init(tbCfg)) then
		local hzLayout = TableViewLayout:create(hzList:getView())
		m_layVerifyView:addChild(hzLayout)
		hzList:refresh()
	end
	--liweidong 防止内存泄漏
	UIHelper.registExitAndEnterCall(m_layVerify,function()
			m_layVerifyCell:release()
		end
		)
end

function createVerifyViewCfg( tabIndex, tbInfo )
	-- 构造列表需要的数据
	local szVerify = m_layVerifyCell:getSize()
	local tbView = {}
	tbView.szCell = (tabIndex == 2 and CCSizeMake(szVerify.width * g_fScaleX, szVerify.height * g_fScaleX))
	tbView.tbDataSource = tbInfo.data

	require "script/module/guild/VerifyCell"
	tbView.CellAtIndexCallback = function (tbData)
		local instCell = VerifyCell:new(m_layVerifyCell)
		instCell:init(CELL_USE_TYPE.BAG)
		instCell:refresh(tbData)
		return instCell
	end

	local szView = m_layVerifyView:getSize()
	tbView.szView = CCSizeMake(szView.width, szView.height)

	return tbView
end


function refreshMembers( tbData, num)
	if (m_tbLists and m_tbLists[1] ) then
		local hzList = m_tbLists[1]
		hzList:changeData(tbData)

		if (num) then
			hzList:refreshNotReload()
			hzList:reloadDataByOffset()
		else
			hzList:reloadDataByBeforeOffset()
		end
		
		-- 剩余可踢出人数
		refreashKickLabel()
	end
end


function refreshVerify( tbData, num , bAgree)
	if (m_tbLists and m_tbLists[2]) then
		local hzList = m_tbLists[2]
		hzList:changeData(tbData)

		if (num) then -- 如果指定了删除条数，就原地刷新，否则全表刷新
			hzList:refreshNotReload()
			hzList:reloadDataDelByOffset(num)
		else
			hzList:refresh()
		end
	end

	if (m_layVerify and bAgree) then
		local labnRemainNum = m_fnGetWidget(m_layVerify, "LABN_REMAIN_NUM")
		m_nRemainNum = m_nRemainNum - 1
		labnRemainNum:setStringValue(m_nRemainNum)
	end
end

function showSortDlg( tbData )
	local layMain = g_fnLoadUI("union_verify_sequence.json")

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE") -- 关闭
	btnClose:addTouchEventListener(UIHelper.onClose)

	local btnCancel = m_fnGetWidget(layMain, "BTN_CANCEL") -- 取消
	UIHelper.titleShadow(btnCancel, m_i18n[1325])
	btnCancel:addTouchEventListener(UIHelper.onClose)

	local fnSort = nil -- 最终的排序函数
	local imgLastCheck = nil -- 上次显示的对勾控件引用，控制显示和隐藏
	for name, dat in pairs(m_tbSortBtn) do
		local btn = m_fnGetWidget(layMain, name)
		local label = m_fnGetWidget(layMain, dat.label)
		label:setText(dat.title)
		UIHelper.titleShadow(btn, "")
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				fnSort = dat.fnSort
				if (imgLastCheck) then
					imgLastCheck:setEnabled(false)
				end
				imgLastCheck = m_fnGetWidget(sender, "IMG_CHECK")
				imgLastCheck:setEnabled(true)
				m_curSortBtn = name
			end
		end)
		local imgChk = m_fnGetWidget(btn, "IMG_CHECK")
		imgChk:setEnabled(false)
		if (name == m_sSortBtn) then
			imgLastCheck = imgChk
			imgChk:setEnabled(true)
		end
	end

	local btnOK = m_fnGetWidget(layMain, "BTN_CONFIRM") -- 确定
	UIHelper.titleShadow(btnOK, m_i18n[1324])
	btnOK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (m_sSortBtn == m_curSortBtn) then
				LayerManager.removeLayout() -- 关闭排序选择面板
				return
			end
			m_sSortBtn = m_curSortBtn
			m_btnSort:setTitleText(m_tbSortBtn[m_curSortBtn].title)
			if (fnSort and tbData) then
				table.sort(tbData, fnSort)
			end
			refreshVerify(tbData) -- 刷新列表
			LayerManager.removeLayout() -- 关闭排序选择面板
		end
	end)
	LayerManager.addLayout(layMain)
end
		
-- 审核按钮红点
function updateVerifyBtnTip( ... )
	if (not m_layMain) then 
		return 
	end 

	local img_tip = m_fnGetWidget(m_layMain, "IMG_TIP") -- 成员按钮红点
	if (GuildDataModel.getMineSigleGuildInfo().member_type == "1" or GuildDataModel.getMineSigleGuildInfo().member_type == "2") then
		if (g_redPoint.newGuildMemApply.visible) then 
			img_tip:removeAllNodes()
			img_tip:addNode(UIHelper.createRedTipAnimination(),0,m_redTipTag)
			
		else 
			img_tip:removeAllNodes()
		end 
	else 
		img_tip:removeAllNodes()
	end 

end

function isHaveRedTip( ... )
	if (not m_layMain) then 
		return false
	end 
	local img_tip = m_fnGetWidget(m_layMain, "IMG_TIP") -- 成员按钮红点
	if (img_tip:getNodeByTag(m_redTipTag)) then 
		return true
	end 
	return false
end

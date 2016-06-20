-- FileName: MainAccSignView.lua
-- Author: zhangjunwu
-- Date: 2014-11-25
-- Purpose: 开服礼包界面模块
--[[TODO List]]

module("MainAccSignView", package.seeall)

-- UI控件引用变量 --
local m_MainUI 			= nil 
local m_fnGetWidget 	= g_fnGetWidgetByName

local m_i18n 			= gi18n
local m_i18nString 		= gi18nString

-- 模块局部变量 --
local m_layTotal 		= nil 	--listview父节点 
local m_mainView 		= nil   -- 纵向的主ListView
local acc_reward_json 	= "ui/reward_server.json"
local m_szRowCell 				-- 行cell的size

local m_RowCellClone 				-- 行cell

local m_tbAccRewardData = nil
local TAG_LIST_VIEW  	= 1231

local function init(...)
	m_layTotal = nil
	m_tbAccRewardData = nil
	m_mainView = nil 
	m_MainUI = nil
end

function destroy(...)
	
	package.loaded["MainAccSignView"] = nil
end

function moduleName()
    return "MainAccSignView"
end

--如果玩家已经拥有次武将，则自动转换为武将碎片
local function getHeroFragTidByHeroTid(heroTid)
	local heroData = DB_Heroes.getDataById(heroTid) 
	local heroFragTid = heroData.fragment
	local heroFragData = DB_Item_hero_fragment.getDataById(heroFragTid)
	local nMaxStack = heroFragData.max_stack
	logger:debug(heroFragTid .. "|" .. nMaxStack)
	return heroFragTid .. "|" .. nMaxStack
end

-- 向服务器传递领取Id的回调函数
local function receiveCallback(btnGetReward, receiveData, imgRecieved)

	btnGetReward:setEnabled(false)
	imgRecieved:setEnabled(true)

	local tbItem = {}
	for i=1,receiveData.reward_num do
		local tb = {}

		local button = nil
		if(receiveData["reward_type" .. i]== 13) then
				local heroValue = receiveData["reward_value" .. i]
				local heroTid  = lua_string_split(heroValue,"|")[1]
				local hid = HeroModel.getHidByHtid(tonumber(heroTid))
				logger:debug(hid)
				if(hid ~= 0) then
					button = UIHelper.getItemIconAndUpdate(nil, getHeroFragTidByHeroTid(heroTid))
				else

					button = HeroUtil.createHeroIconBtnByHtid(heroTid,nil,function (sender,eventType)
		                if (eventType == TOUCH_EVENT_ENDED) then
		                    PublicInfoCtrl.createHeroInfoView(heroTid)
		                end
		           	end) 
				end
		else
			 button = UIHelper.getItemIconAndUpdate(receiveData["reward_type" .. i], receiveData["reward_value" .. i])
		end

		tb.icon = button
		tb.name = receiveData["reward_desc" .. i]
		tb.quality = receiveData["reward_quality" .. i]
		table.insert(tbItem, tb)
	end
	local layReward = UIHelper.createGetRewardInfoDlg( gi18n[1935], tbItem)
	LayerManager.addLayout(layReward)
	--require "script/module/levelReward/LevelRewardCtrl"
	AccSignModel.updateAccGotData(btnGetReward:getTag())
	--更新红点数字
	WonderfulActModel.tbBtnActList.accReward:setVisible(true)
	local numberLab = g_fnGetWidgetByName(WonderfulActModel.tbBtnActList.accReward,"LABN_TIP_EAT")
	numberLab:setStringValue(AccSignModel.getCanGotRewardNum())

	local IMG_TIP = m_fnGetWidget(WonderfulActModel.tbBtnActList.accReward,"IMG_TIP") -- 小红点
	if(AccSignModel.getCanGotRewardNum() == 0 ) then
		IMG_TIP:setEnabled(false)
	end
	-- MainWonderfulActCtrl.reSetAccReward()
	-- MainShip.fnSetBtnLevel()
end


--1、贝里,2、将魂,3、金币,4、体力,5、耐力,6、物品,7、多个物品,8、等级*贝里,9、等级*将魂
-- 领取按钮的回调函数
local function btnGetCallback(btnGetReward, imgRecieved)

	local curReceiveID = btnGetReward:getTag()
	local receiveData =  DB_Accumulate_sign.getDataById(curReceiveID)

	logger:debug(curReceiveID)
	logger:debug(receiveData)

	-- 判断背包是否已满
	for i = 1, tonumber(receiveData.reward_num) do
		local rewardType = tonumber(receiveData["reward_type" .. i])


		if (rewardType == 1 or rewardType == 2 or rewardType == 3 or rewardType == 8 or rewardType == 9) then
			logger:debug("贝里：将魂，金币，8、等级*贝里,9、等级*将魂 此物品不需要判断背包")
		else

			local rewardValue = receiveData["reward_value" .. i]

			local tbReward  = lua_string_split(rewardValue,"|") or nil

			logger:debug(tbReward)

			local itemInfo = nil
			if(tbReward) then
				itemInfo = ItemUtil.getItemById(tbReward[1])
			end
			--logger:debug(itemInfo)
			if(itemInfo and itemInfo.fnBagFull) then
				local bagIsFull = itemInfo.fnBagFull(true)
				logger:debug(bagIsFull)
				if(bagIsFull == true) then
					return
				end
			end
		end
	end

	local args = CCArray:create()
	args:addObject(CCInteger:create(curReceiveID))
	RequestCenter.sign_gainAccSignReward(
		function (cbFlag, dictData, bRet)
			if(bRet)then
				receiveCallback(btnGetReward, receiveData, imgRecieved)
			end
		end, args)
end


local function initRowView( tbRowData, colCell )
	logger:debug(tbRowData)
	local button = nil
	if(tbRowData.icon.reward_type == 13) then
			local heroValue = tbRowData.icon.reward_values
			local heroTid  = lua_string_split(heroValue,"|")[1]
			button = HeroUtil.createHeroIconBtnByHtid(heroTid,nil,function (sender,eventType)
                if (eventType == TOUCH_EVENT_ENDED) then
                    PublicInfoCtrl.createHeroInfoView(heroTid)
                end
           	end) 
	else
		 button = UIHelper.getItemIcon(tbRowData.icon.reward_type, tbRowData.icon.reward_values)
	end
	local imgGood = g_fnGetWidgetByName(colCell,"IMG_GOODS") --物品背景
	imgGood:addChild(button)
	local labName = g_fnGetWidgetByName(colCell,"TFD_GOODS_NAME")
	UIHelper.labelEffect(labName, tbRowData.name)
	logger:debug(tbRowData.name .. "ddd" .. tbRowData.quality)
	labName:setColor(g_QulityColor[tonumber(tbRowData.quality)])
end

local function initRowCell( tbRowData, rowCell )
	local TFD_CELL_TITLE = m_fnGetWidget(rowCell,"TFD_CELL_TITLE")
	local tfd_kaifu = m_fnGetWidget(rowCell,"tfd_kaifu")

	TFD_CELL_TITLE:setText(tostring(tbRowData.add_up_days))
	tfd_kaifu:setText(m_i18n[1936])

	
	local imgRecieved = m_fnGetWidget(rowCell, "IMG_RECIEVED")
	local btnGetReward = m_fnGetWidget(rowCell,"BTN_GET_REWARD")
	btnGetReward:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTansuo02()
			btnGetCallback(sender, imgRecieved)
		end
	end)


	UIHelper.titleShadow(btnGetReward, gi18n[2628])

	btnGetReward:setEnabled(true)
	btnGetReward:setBright(true)
	btnGetReward:setTouchEnabled(true)
	btnGetReward:removeAllNodes()
	btnGetReward:setTag(tbRowData.rid)

	imgRecieved:setEnabled(false)


	local acc_got = AccSignModel.getAccGotTimes()
	local singTimes = tonumber(AccSignModel.getSignTimes()) 

	logger:debug(acc_got)
	logger:debug(singTimes)
	logger:debug(tbRowData.rid)
	if(table.isEmpty(acc_got)) then
		if(tonumber(tbRowData.add_up_days ) > tonumber(singTimes)) then
			imgRecieved:setEnabled(false)

			btnGetReward:setBright(false)
			btnGetReward:setTouchEnabled(false)
		end
	else
		if(tonumber(tbRowData.add_up_days ) > tonumber(singTimes)) then
			imgRecieved:setEnabled(false)

			btnGetReward:setBright(false)
			btnGetReward:setTouchEnabled(false)
		end
		for k, v in pairs(acc_got) do

			if(tonumber(v) == tonumber(tbRowData.rid )) then
				btnGetReward:setEnabled(false)
				imgRecieved:setEnabled(true)

			end
		end
	end
end

local function createMainListView( ... )
	local cfgList = {posType = POSITON_ABSOLUTE}
	m_mainView = UIHelper.createListView(cfgList)

	local rowCellRef = m_RowCellClone


	m_szRowCell = m_RowCellClone:getSize()
	m_mainView:setItemModel(m_RowCellClone)
	

	local rowCell, colCell, colLayout, colCellRef
	for i, rowData in ipairs(m_tbAccRewardData) do
		m_mainView:pushBackDefaultItem()
		rowCell = m_mainView:getItem(i - 1)  -- rowCell 索引从 0 开始

		-- 创建每行的ListView
		colLayout = m_fnGetWidget(rowCell, "LAY_FORTBV")
		colCellRef = m_fnGetWidget(colLayout, "LAY_CLONE")
		
		local colCellCopy = colCellRef:clone()
		colCellRef:removeFromParentAndCleanup(true)

		initRowCell(rowData, rowCell) -- 初始化每行的cell

		local oneItemPercent = (colCellCopy:getSize().width) / colLayout:getSize().width

		for j, colData in ipairs(rowData.item) do
			local colCell = colCellCopy:clone()
			colCell:setPositionPercent(ccp(oneItemPercent * (j - 1), 0))
			colLayout:addChild(colCell)

			initRowView(colData, colCell) -- 初始化每行上的listView的cell
		end

	end

	return m_mainView
end

function scrollPassGetRow( idxRow )
	if (m_mainView) then
		logger:debug("开服礼包列表应该跳转到第%s 行",idxRow)
		local colGap = m_mainView:getItemsMargin() -- 行cell间隔

		local passNum = idxRow - 1
		logger:debug(passNum)
		local hScrollTo = (m_szRowCell.height + colGap) * passNum

		local szInner = m_mainView:getInnerContainerSize()
		local szView = m_mainView:getSize()

		local totalHeight = (m_szRowCell.height + colGap) * #m_tbAccRewardData
		logger:debug(totalHeight)
		m_mainView:setInnerContainerSize(CCSizeMake(szInner.width, totalHeight))
		local percent = (hScrollTo/(szInner.height - szView.height)) * 100

		logger:debug(percent)

		m_mainView:jumpToPercentVertical(percent)


	end
end

function fnFreshListView()

	function accSignInfoCallbck(cbFlag, dictData, bRet )
		if(dictData.err == "ok") then
			if(  not table.isEmpty(dictData.ret)) then

				AccSignModel.setAccSignInfo(dictData.ret)
				logger:debug(m_tbAccRewardData)

				--m_mainView:removeFromParentAndCleanup(false)
				if(m_layTotal ~= nil ) then 
					m_layTotal:removeChildByTag(TAG_LIST_VIEW,true)
					m_layTotal:addChild(createMainListView(),1000,TAG_LIST_VIEW)

					local currentIndex = AccSignModel.getCurrentIndex()
					scrollPassGetRow(currentIndex)
				end
			end
		end

	end

	Network.rpc(accSignInfoCallbck, "sign.getAccInfo" , "sign.getAccInfo", nil , true)
end

function create(tbEvent,tbInfo)
	init()
	m_MainUI = g_fnLoadUI(acc_reward_json)

	UIHelper.registExitAndEnterCall(m_MainUI,
		function()
			init()
		end,
		function()
		end
	)

	m_tbAccRewardData = tbInfo

	-- local btnClose = m_fnGetWidget(m_MainUI,"BTN_CLOSE")
	-- btnClose:addTouchEventListener(tbEvent.onClose)

	m_layTotal = m_fnGetWidget(m_MainUI,"LAY_TOTAL")


	local IMG_BG_MAIN = m_fnGetWidget(m_MainUI, "IMG_BG_MAIN")
	IMG_BG_MAIN:setScale(g_fScaleX)

	-- m_MainUI.img_bg:setScale(g_fScaleX)

	-- m_MainUI.IMG_REWARD_BG:setScaleX(g_fScaleX)

	local rowCellRef = m_fnGetWidget(m_layTotal, "LAY_CELL")



	m_RowCellClone = rowCellRef:clone()

	local layCellSize = m_RowCellClone:getSize()

	m_RowCellClone:setSize(CCSizeMake( layCellSize.width * g_fScaleX,layCellSize.height * g_fScaleX))
	m_RowCellClone.IMG_CELL:setScale(g_fScaleX)
	-- 
	rowCellRef:removeFromParentAndCleanup(true)
	
	m_layTotal:addChild(createMainListView(),1000,TAG_LIST_VIEW)


	local tfd_regist = m_fnGetWidget(m_MainUI,"tfd_regist")  --登录第
	tfd_regist:setText(m_i18nString(1936))
	UIHelper.labelNewStroke(tfd_regist, ccc3(0x28,0x00,0x00), 2 )

	local tfd_fuhao = m_fnGetWidget(m_MainUI,"tfd_fuhao")  --登录第
	tfd_fuhao:removeFromParentAndCleanup(true)
	-- UIHelper.labelNewStroke(tfd_fuhao, ccc3(0x28,0x00,0x00), 2 )

	local tfd_seven = m_fnGetWidget(m_MainUI,"tfd_seven")  --登录第
	UIHelper.labelNewStroke(tfd_seven, ccc3(0x28,0x00,0x00), 2 )
	tfd_seven:setText(m_i18n[1999])

	local tfd_fivestar = m_fnGetWidget(m_MainUI,"tfd_fivestar")  --天，可通过影子合成五星伙伴“
	tfd_fivestar:setText(m_i18nString(1938))
	UIHelper.labelNewStroke(tfd_fivestar, ccc3(0x28,0x00,0x00), 2 )

	
	local tfd_suolong = m_fnGetWidget(m_MainUI,"tfd_suolong")  --天路飞
	tfd_suolong:setText(m_i18nString(1939))
	UIHelper.labelNewStroke(tfd_suolong, ccc3(0x28,0x00,0x00), 2 )

	return m_MainUI
end

-- FileName: GrabEnemyListView.lua
-- Author: menghao
-- Date: 2015-04-10
-- Purpose: 夺宝仇人列表view


module("GrabEnemyListView", package.seeall)


-- UI控件引用变量 --
local m_UIMain
local m_lsvEnemy


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local mi18n = gi18n
local m_tbEnemyList


function destroy(...)
	package.loaded["GrabEnemyListView"] = nil
end


function moduleName()
	return "GrabEnemyListView"
end


function showEnemyInfo( tbEnemyData )
	local strName = tbEnemyData.uname

	local UIDesc = g_fnLoadUI("ui/enemy_desc.json")

	local btnClose = m_fnGetWidget(UIDesc, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local lsv = m_fnGetWidget(UIDesc, "LSV_MAIN")
	UIHelper.initListView(lsv)

	local historyNum = #tbEnemyData.history
	for i=1,historyNum do
		lsv:pushBackDefaultItem()
		local wigCell = lsv:getItem(i - 1)
		local tfdTime = m_fnGetWidget(wigCell, "TFD_TIME")
		local tfdDesc = m_fnGetWidget(wigCell, "TFD_DESC")

		local fragId = tbEnemyData.history[historyNum - i + 1].fragId
		local eTime = tbEnemyData.history[historyNum - i + 1].eTime
		require "db/DB_Item_treasure_fragment"
		local afterTime = TimeUtil.getSvrTimeByOffset() - eTime
		local strTime
		if (afterTime < 60 * 60) then
			strTime = math.floor(afterTime / 60) .. mi18n[2463]
		else
			strTime = math.floor(afterTime / 60 / 60) ..  mi18n[2464]
		end
		local strDesc = strName ..  mi18n[2465] .. DB_Item_treasure_fragment.getDataById(fragId).name ..  mi18n[2466]
		tfdTime:setText(strTime)
		tfdDesc:setText(strDesc)
	end

	LayerManager.addLayout(UIDesc)
end


function showCanGrabFrags( tbEnemyData, tbFragsData )
	local tbFragsInfo = {}
	for k, v in pairs(tbFragsData) do
		table.insert(tbFragsInfo, {id = tonumber(k), num = tonumber(v)})
	end
	if (table.isEmpty(tbFragsInfo)) then
		ShowNotice.showShellInfo(mi18n[2460])
		return
	end
	logger:debug({tbFragsInfo = tbFragsInfo})

	local UIFrags = g_fnLoadUI("ui/grab_enemy_treasue.json")

	local btnClose = m_fnGetWidget(UIFrags, "BTN_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)

	local lsv = m_fnGetWidget(UIFrags, "LSV_MAIN")
	UIHelper.initListView(lsv)

	for i = 1, math.ceil(#tbFragsInfo / 3) do
		lsv:pushBackDefaultItem()
		local wigCell = lsv:getItem(i - 1)

		for j=1,3 do
			local imgBG = m_fnGetWidget(wigCell, "img_item_bg" .. j)
			if (i * 3 - 3 + j <= #tbFragsInfo) then
				local btnBG = m_fnGetWidget(imgBG, "BTN_ITEM_BG")
				local tfdName = m_fnGetWidget(imgBG, "TFD_NAME")
				local btnGrab = m_fnGetWidget(imgBG, "BTN_GRAB")
				UIHelper.titleShadow(btnGrab, "抢夺")

				local dbInfo = DB_Item_treasure_fragment.getDataById(tbFragsInfo[i * 3 - 3 + j].id)
				local btn = ItemUtil.createBtnByTemplateIdAndNumber(tbFragsInfo[i * 3 - 3 + j].id, tbFragsInfo[i * 3 - 3 + j].num, function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then

					end
				end)
				btnBG:addChild(btn)
				tfdName:setText(dbInfo.name)
				tfdName:setColor(g_QulityColor2[dbInfo.quality])


				btnGrab:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						local nEnemyTime = tonumber(DB_Loot.getDataById(1).enemyTime)
						if (tbEnemyData.history[1].eTime + nEnemyTime - TimeUtil.getSvrTimeByOffset()) <= 1 then
							LayerManager.removeLayout()
							-- ShowNotice.showShellInfo("他已不是你的仇人")
							ShowNotice.showShellInfo(mi18n[2467])
							return
						end

						RobTreasureCtrl.robByData(tbEnemyData, tbFragsInfo[i * 3 - 3 + j].id, "0")
					end
				end)
			else
				imgBG:setEnabled(false)
			end
		end
	end

	LayerManager.addLayout(UIFrags)
end


function setLsvCellAtIndex( idx )
	m_lsvEnemy:pushBackDefaultItem()

	local widgetCell = m_lsvEnemy:getItem(idx - 1)

	local imgCell = m_fnGetWidget(widgetCell, "img_cell")
	imgCell:setScale(g_fScaleX)

	local tbData = m_tbEnemyList[idx]

	--[[
	enemy_list => array(
		0 => array(
			'uid' => int
			'uname' => string,仇人名字
			'figure' => ,
			'fight_force' =>
			'robNum' => int,掠夺的次数
			'history' => array(
				array(fragId => int,eTime => int,),
				.
				. 
			)										
		)
	)
	--]]


	-- 头像
	local imgIconBG = m_fnGetWidget(widgetCell, "IMG_ICON_BG")
	local imgIcon = m_fnGetWidget(widgetCell, "IMG_ICON")
	local playerIcon = HeroUtil.createHeroIconBtnByHtid(tbData.figure, nil, function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then

		end
	end)
	imgIconBG:addChild(playerIcon)

	-- 等级名字战斗力
	local tfdLevel = m_fnGetWidget(widgetCell, "TFD_LEVEL")
	local tfdName = m_fnGetWidget(widgetCell, "TFD_NAME")
	local tfdFight = m_fnGetWidget(widgetCell, "tfd_fight")
	local tfdFightNum = m_fnGetWidget(widgetCell, "TFD_FIGHT_NUM")
	tfdLevel:setText("Lv." .. tbData.level)
	tfdName:setText(tbData.uname)
	local name_color =  UserModel.getPotentialColor({htid = tbData.figure,bright = false}) 
	tfdName:setColor(name_color)
	tfdFight:setText(mi18n[2468])
	tfdFightNum:setText(tbData.fight_force)

	-- 按钮
	local btnDesc = m_fnGetWidget(widgetCell, "BTN_DESC")
	local btnBelly = m_fnGetWidget(widgetCell, "BTN_BELLY")
	local btnGrab = m_fnGetWidget(widgetCell, "BTN_GRAB")
	UIHelper.titleShadow(btnDesc, mi18n[2455])
	UIHelper.titleShadow(btnBelly, mi18n[2457])
	UIHelper.titleShadow(btnGrab, mi18n[2456])

	btnDesc:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			showEnemyInfo(tbData)
		end
	end)
	if (tonumber(tbData.robNum) == 0) then
		btnBelly:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()

				if(tonumber(TreasureData.seizerInfoData.curSeizeNum) <= 0)then
					require "script/module/grabTreasure/GrabBuyCtrl"
					local buyView = GrabBuyCtrl.create()
					return
				end

				local args = CCArray:create()
				args:addObject(CCInteger:create(tbData.uid))
				RequestCenter.fragseize_robEnemy(function ( cbFlag, dictData, bRet )
					if (bRet) then
						UIHelper.setWidgetGray(btnBelly, true)
						UIHelper.titleShadow(btnBelly, mi18n[2458])
						btnBelly:setTouchEnabled(false)
						if (tonumber(dictData.ret) == 0) then
							ShowNotice.showShellInfo(mi18n[2457])
						else
							ShowNotice.showShellInfo(mi18n[2458] .. dictData.ret .. mi18n[1520])

							TreasureData.setSeizeNum()
							TreasureData.setCurGrabNum()
							UserModel.addSilverNumber(tonumber(dictData.ret))

							updateInfoBar() -- 新信息条统一刷新方法
						end
					end
				end,
				args)
			end
		end)
	else
		UIHelper.setWidgetGray(btnBelly, true)
		UIHelper.titleShadow(btnBelly, mi18n[2458])
		btnBelly:setTouchEnabled(false)
	end
	btnGrab:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local args = CCArray:create()
			args:addObject(CCInteger:create(tbData.uid))
			RequestCenter.fragseize_getEnemyFragInfo(function ( cbFlag, dictData, bRet )
				showCanGrabFrags(tbData, dictData.ret)
			end,
			args)
		end
	end)

	-- 时间
	require "db/DB_Loot"
	local nEnemyTime = tonumber(DB_Loot.getDataById(1).enemyTime)

	local tfdTime = m_fnGetWidget(widgetCell, "tfd_time")
	local tfdTimeNum = m_fnGetWidget(widgetCell, "TFD_TIME_NUM")
	tfdTime:setText(mi18n[2459])
	tfdTimeNum:setText(TimeUtil.getTimeString(tbData.history[1].eTime + nEnemyTime - TimeUtil.getSvrTimeByOffset()))
	schedule(tfdTime, function ( ... )
		tfdTimeNum:setText(TimeUtil.getTimeString(tbData.history[1].eTime + nEnemyTime - TimeUtil.getSvrTimeByOffset()))
		if (tbData.history[1].eTime + nEnemyTime - TimeUtil.getSvrTimeByOffset()) <= 0 then
			-- m_tbEnemyList[idx] = nil
			table.remove(m_tbEnemyList, idx)
			local ii = m_lsvEnemy:getIndex(widgetCell)
			m_lsvEnemy:removeItem(ii)
		end
	end, 1)
end


function create( onBack )
	m_tbEnemyList = TreasureData.getEnemyList()
	logger:debug({m_tbEnemyList = m_tbEnemyList})

	m_UIMain = g_fnLoadUI("ui/grab_enemy.json")

	-- 适配
	local imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	local imgSmallBG = m_fnGetWidget(m_UIMain, "img_small_bg")
	local imgChian = m_fnGetWidget(m_UIMain, "img_partner_chain")
	imgBG:setScale(g_fScaleX)
	imgSmallBG:setScale(g_fScaleX)
	imgChian:setScale(g_fScaleX)

	local btnTab1 = m_fnGetWidget(m_UIMain, "BTN_TAB1")
	local imgTips = m_fnGetWidget(m_UIMain, "IMG_TAB_TIPS")
	local labnNum = m_fnGetWidget(m_UIMain, "LABN_NUM")
	imgTips:setEnabled(false)
	UIHelper.titleShadow(btnTab1, mi18n[2469]) -- TODO mh

	local btnBack = m_fnGetWidget(m_UIMain, "BTN_BACK")
	btnBack:addTouchEventListener(onBack)
	UIHelper.titleShadow(btnBack, mi18n[1019]) -- TODO mh

	m_lsvEnemy = m_fnGetWidget(m_UIMain, "LSV_MAIN")

	local defaultItem = m_lsvEnemy:getItem(0)
	local size = defaultItem:getSize()
	defaultItem:setSize(CCSizeMake(size.width * g_fScaleX, size.height * g_fScaleX))
	m_lsvEnemy:setItemModel(defaultItem)
	m_lsvEnemy:removeAllItems()

	for i=1,#m_tbEnemyList do
		setLsvCellAtIndex(i)
	end

	return m_UIMain
end


-- FileName: MineInfoView.lua
-- Author: zhangqi
-- Date: 2015-04-11
-- Purpose: 矿点信息显示的UI
--  modified by huxiaozhou 

MineInfoView = class("MineInfoView")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local _imgTitlePath = "images/resource/title_res/title_res_%s.png"
local _imgGuardPath = "images/resource/people/"
function MineInfoView:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/resource_info.json")
end

function MineInfoView:create(tbArgs)

	self.tbArgs = tbArgs

	local layMain = self.layMain

	local imgTitle = m_fnGetWidget(layMain, "IMG_TITLE") -- 标题
	imgTitle:loadTexture(string.format(_imgTitlePath, self.tbArgs.res_type))

	local btnClose = m_fnGetWidget(layMain, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)

	-- 岛屿产量
	local i18n_yield = m_fnGetWidget(layMain, "tfd_yield")
	i18n_yield:setText(m_i18n[5615])--"岛屿产量"
	local labYieldNum = m_fnGetWidget(layMain, "TFD_YIELD_NUM")
	local multiplyRate = OutputMultiplyUtil.getMultiplyRateNum( 1 )/10000 -- 限时福利活动倍率
	logger:debug({multiplyRate = multiplyRate})
	labYieldNum:setText(math.floor(tbArgs.res_attr[1]*multiplyRate))



	local bShow, value = MineUtil.getShowGCInCom(tbArgs.pit_id)
	logger:debug({getShowGCInCom = {bShow, value}})
	self.layMain.TFD_JIACHENG:setEnabled(bShow)
	self.layMain.TFD_JIACHENG:setText(bShow and m_i18nString(5678,value) or "")


	-- 占领时间
	local i18n_hold_time = m_fnGetWidget(layMain, "tfd_time")
	i18n_hold_time:setText(m_i18n[5616])--"占领时间"

	self.labHoldTime = m_fnGetWidget(layMain, "TFD_TIME_NUM")
	self.labDelayNum = m_fnGetWidget(layMain, "TFD_CAN_ADD_TIME") -- 可延长次数
	

	-- 占领海贼
	local i18n_holder = m_fnGetWidget(layMain, "tfd_name")
	i18n_holder:setText(m_i18n[5617])--"占领海贼"

	self.labNoHolder = m_fnGetWidget(layMain, "TFD_NO_PLAYER") -- 无
	self.labHolderLv = m_fnGetWidget(layMain, "TFD_LV") -- 占领者等级
	self.labHolderName = m_fnGetWidget(layMain, "TFD_PLAYER_NAME") -- 占领者昵称
	self.labHolderName:setColor(UserModel.getPotentialColor({htid = tbArgs.figure})) -- 2015-07-29

	self.labNoHolder:setEnabled(true)
	self.labNoHolder:setText(m_i18n[1093])
	self.labHolderLv:setEnabled(true)
	self.labHolderName:setEnabled(true)
	if MineConst.MineInfoType.MINE_NONE == tbArgs.infoType then -- 普通空旷
		self.labDelayNum:setEnabled(false)
		self.labHolderLv:setEnabled(false)
		self.labHolderName:setEnabled(false)
		self.layMain.TFD_JIACHENG:setEnabled(false)
	elseif MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType  then -- 别人普通矿
		self.labHoldTime:setText(TimeUtil.getTimeString(TimeUtil.getSvrTimeByOffset() - tbArgs.occupy_time))
		self.labHolderLv:setText("Lv." .. tbArgs.level)
		self.labHolderName:setText(tbArgs.uname)

		self.labNoHolder:setEnabled(false)
		self.labDelayNum:setEnabled(false)
	elseif MineConst.MineInfoType.MINE_SELF == tbArgs.infoType  then -- 自己普通矿
		self.labHoldTime:setText(TimeUtil.getTimeString(TimeUtil.getSvrTimeByOffset() - tbArgs.occupy_time))
		self.labHolderLv:setText("Lv." .. tbArgs.level)
		self.labHolderName:setText(tbArgs.uname)
		if tbArgs.delay_times then
			self.labDelayNum:setText(m_i18nString(5622,2-tbArgs.delay_times))
		else
			self.labDelayNum:setEnabled(false)
		end
		self.labNoHolder:setEnabled(false)
	elseif MineConst.MineInfoType.MINE_SELF_GOURD == tbArgs.infoType then -- 自己协助的普通矿
		self.tbArgs.guard_start_time = MineModel.getSelfGuardStartTime()
		self.labHoldTime:setText(TimeUtil.getTimeString(TimeUtil.getSvrTimeByOffset() - tbArgs.occupy_time))
		self.labHolderLv:setText("Lv." .. tbArgs.level)
		self.labHolderName:setText(tbArgs.uname)
		self.labDelayNum:setEnabled(false)
		self.labNoHolder:setEnabled(false)
	elseif MineConst.MineInfoType.MINE_SELF_GOLD == tbArgs.infoType  then -- 自己金矿
		self.labHoldTime:setText(TimeUtil.getTimeString(TimeUtil.getSvrTimeByOffset() - tbArgs.occupy_time))
		self.labHolderLv:setText("Lv." .. tbArgs.level)
		self.labHolderName:setText(tbArgs.uname)
		if tbArgs.delay_times then
			self.labDelayNum:setText(m_i18nString(5622,2-tbArgs.delay_times))
		else
			self.labDelayNum:setEnabled(false)
		end
		self.labNoHolder:setEnabled(false)
	elseif MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then -- 别人金矿
		self.labHoldTime:setText(TimeUtil.getTimeString(TimeUtil.getSvrTimeByOffset() - tbArgs.occupy_time))
		self.labHolderLv:setText("Lv." .. tbArgs.level)
		self.labHolderName:setText(tbArgs.uname)

		self.labNoHolder:setEnabled(false)
		self.labDelayNum:setEnabled(false)
	elseif MineConst.MineInfoType.MINE_NONE_GOLD == tbArgs.infoType  then -- 空金矿
		self.labDelayNum:setEnabled(false)
		self.labHolderLv:setEnabled(false)
		self.labHolderName:setEnabled(false)
		self.layMain.TFD_JIACHENG:setEnabled(false)
	end
	

	self.labHoldTime:setText(MineUtil.getPitOccupyTimeStr(tbArgs))

	local function updateMineTime(  )
		self.labHoldTime:setText(MineUtil.getPitOccupyTimeStr(self.tbArgs))
	end

	UIHelper.registExitAndEnterCall(self.labHoldTime, function (  )
		GlobalScheduler.removeCallback("updateMineTime")
	end, function (  )
		GlobalScheduler.addCallback("updateMineTime", updateMineTime) 
	end)

	-- 协助军信息
	self:initHelper()

	-- 占领时间选择
	self:initTimeSelect()

	local i18n_ext_desc = m_fnGetWidget(layMain, "tfd_desc") -- "每天23:00-09:00抢夺资源矿需要额外花费20金币"
	if MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then -- 别人金矿
		i18n_ext_desc:setText(m_i18n[5631]) 
	else
		i18n_ext_desc:setEnabled(false)
	end
	-- 控制按钮初始化
	self:initBottomButton()

	return layMain
end

-- 初始化协助军信息
function MineInfoView:initHelper( ... )
	-- for test
	local tbArgs = self.tbArgs
	tbArgs.nHelperNum = table.count(tbArgs.arrGuard)
	tbArgs.nHelperMax = tbArgs.res_attr[3]
	tbArgs.tbHelperName = {}
	for i,v in ipairs(tbArgs.arrGuard or {}) do
		table.insert(tbArgs.tbHelperName, v)
	end
	tbArgs.bHelper = false

	if MineConst.MineInfoType.MINE_SELF_GOURD == tbArgs.infoType then
		tbArgs.bHelper = true
	end

	tbArgs.bGoldMine = false
	if  MineConst.MineInfoType.MINE_SELF_GOLD == tbArgs.infoType 
		or MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType 
		or MineConst.MineInfoType.MINE_NONE_GOLD == tbArgs.infoType then
		tbArgs.bGoldMine = true
	end

	local imgBg = m_fnGetWidget(self.layMain, "img_help_bg")

	local i18n_helper = m_fnGetWidget(imgBg, "tfd_help")
	i18n_helper:setText(m_i18n[5618])
	local labHelperNum = m_fnGetWidget(imgBg, "TFD_HELP_NUM") -- 当前协助军数量
	labHelperNum:setText(tbArgs.nHelperNum .. "/" .. tbArgs.nHelperMax)

	self.labHelperTime = m_fnGetWidget(imgBg, "TFD_HELP_TIME") -- 协助总时间
	self.labHelperTime:setEnabled(false)
	
	local layNoHelp = m_fnGetWidget(imgBg, "LAY_NO_HELP")
	local layHaveHelp = m_fnGetWidget(imgBg, "LAY_HAVE_HELP")
	-- 如果是金币矿
	local labGold = m_fnGetWidget(imgBg, "tfd_gold")
	if (tbArgs.bGoldMine) then
		labGold:setText(m_i18n[5623]) --"金币矿区不可进行协助"
		layHaveHelp:setEnabled(false)
	else
		layNoHelp:setEnabled(false)
		for i = 1, tbArgs.nHelperMax do -- 所有协助军昵称
			local labName = m_fnGetWidget(imgBg, "TFD_HELP_" .. i)
			local imgPeople = m_fnGetWidget(imgBg, "IMG_PEOPLE_".. i)
			local tGuard = tbArgs.tbHelperName[i] or {}
			logger:debug({tGuard = tGuard})
			if tGuard.uname then
				labName:setText(tGuard.uname)
				labName:setColor(UserModel.getPotentialColor({htid = tGuard.figure}))
			else
				labName:setText(m_i18n[5621])
				labName:setColor(ccc3(89,21,0))
			end

			if tGuard.uid then
				if tonumber(tGuard.uid) == UserModel.getUserUid() then
					imgPeople:loadTexture(_imgGuardPath .. "res_people_3.png")
				else
					imgPeople:loadTexture(_imgGuardPath .. "res_people_2.png")
				end
			else
				imgPeople:loadTexture(_imgGuardPath .. "res_people_1.png")
			end
		end
	end

	-- 玩家是否是协助军
	local i18n_helper_time = m_fnGetWidget(imgBg, "tfd_already_time")
	self.labMyHelperTime = m_fnGetWidget(imgBg, "TFD_ALREADY_TIME_NUM") -- 已协助时间，1秒刷新1次
	self.labMyBelly = m_fnGetWidget(imgBg, "TFD_INCOME_BELLY") -- 协助可获得贝里，5秒刷新1次
	if (tbArgs.bHelper) then -- 如果当前玩家是协助军
		i18n_helper_time:setText(m_i18n[5624])--"已协助时间"

		local function updateMineGuardBelly(  )
			local nTime = TimeUtil.getSvrTimeByOffset() - tbArgs.guard_start_time or 0
			local sTime = TimeUtil.getTimeString(nTime)
			tbArgs.nBelly = MineUtil.guardBelly(tbArgs, nTime)
			self.labMyHelperTime:setText(sTime)
			self.labMyBelly:setText(m_i18nString(5625,tbArgs.nBelly))
		end
		updateMineGuardBelly()
		UIHelper.registExitAndEnterCall(self.labMyHelperTime, function (  )
			GlobalScheduler.removeCallback("updateMineGuardBelly")
		end, function (  )
			GlobalScheduler.addCallback("updateMineGuardBelly", updateMineGuardBelly) 
		end)

		
	else
		i18n_helper_time:setEnabled(false)
		self.labMyHelperTime:setEnabled(false)
		self.labMyBelly:setEnabled(false)
	end

	-- 抢夺按钮
	self.btnGrab = m_fnGetWidget(imgBg, "BTN_GRAB")
	self.btnHelp = m_fnGetWidget(imgBg, "BTN_HELP")

	self.btnGrab:setEnabled(false)
	self.btnHelp:setEnabled(false)

	if MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType  then -- 别人普通矿
		if MineUtil.hasNormal() then
			self.btnGrab:setEnabled(true)
		else
			self.btnHelp:setEnabled(true)
		end
	end

	self.btnGrab:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				logger:debug("%s clicked", sender:getName())

				if MineConst.MineInfoType.MINE_NONE == tbArgs.infoType then -- 普通空旷
					ShowNotice.showShellInfo(m_i18n[5653])
				elseif MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType  then -- 别人普通矿
					if not MineUtil.hasNormal() then
						ShowNotice.showShellInfo(m_i18n[5645]) --"你还没有占领或协助资源矿",
						return
					end

					if MineUtil.hasGuarder(tbArgs) then
						ShowNotice.showShellInfo(m_i18n[5654])
						return
					end
					if MineUtil.isGuardMax(MineModel.getSelfInfo().tNormal) then
						ShowNotice.showShellInfo(m_i18n[5649]) --"您的协助者已满，无法抢夺！",
						return
					end

					if MineUtil.getRobGuardNeedPower() > UserModel.getEnergyValue() then --体力不足
						require "script/module/copy/copyUsePills"
						LayerManager.addLayout(copyUsePills.create())
						return
					end

					require "script/module/mine/MineGrabGuard"
					tbArgs.fnRobGuard = function ( uid )
						
						RequestCenter.mineral_robGuard(function (cbFlag, dictData, bRet)
							if dictData.err ~= "ok" then
								return
							end
							LayerManager.removeLayout()
							LayerManager.removeLayout()

							if dictData.ret.errCode and  tonumber(dictData.ret.errCode)==6 then
								ShowNotice.showShellInfo(m_i18n[5635]) 
								return
							end

							if dictData.ret.errCode and  tonumber(dictData.ret.errCode)==7 then
								ShowNotice.showShellInfo(m_i18n[5662]) 
								return
							end

							if dictData.ret.errCode and  tonumber(dictData.ret.errCode)==8 then
								ShowNotice.showShellInfo(m_i18n[5663]) 
								return
							end
							

							UserModel.addEnergyValue(-MineUtil.getRobGuardNeedPower()) -- 扣除体力


							local function battleCallback(  )
								
							end
							local tData = {}
							tData.pit_id = tbArgs.pit_id
							tData.domain_id = tbArgs.domain_id
							tData.uname = tbArgs.uname
							tData.uid = tbArgs.uid
							-- require "script/module/mine/MineWinCtrl"
							local fight_ret = dictData.ret.fight_ret
							require "script/battle/BattleModule"
							BattleModule.playMineBattle(fight_ret,battleCallback,tData)
							GlobalNotify.postNotify(MineConst.MineBattleEvt.MINE_BEGIN_BATTLE)

						end,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id,uid}))
					end


					local view = MineGrabGuard.create(tbArgs)
					view.layMain:setName("GRABGUARD")
					LayerManager.addLayout(view.layMain)

				elseif MineConst.MineInfoType.MINE_SELF == tbArgs.infoType  then -- 自己普通矿
					ShowNotice.showShellInfo(m_i18n[5648]) -- "无法抢夺自己的协助者！"
				elseif MineConst.MineInfoType.MINE_SELF_GOURD == tbArgs.infoType then -- 自己协助的普通矿
					ShowNotice.showShellInfo(m_i18n[5655])
				end
	


			end
		end)
end

-- 初始化选择占领时间的UI
function MineInfoView:initTimeSelect( ... )
	local tbArgs = self.tbArgs
	tbArgs.bDelayMax = false
	-- local tbTemp = {
	-- 	{hour = 8, nBelly = 99999, nCostPower = 5, nGold = 10},
	-- 	{hour = 16, nBelly = 999999, nCostPower = 10, nGold = 20},
	-- 	{hour = 24, nBelly = 9999999, nCostPower = 20, nGold = 40},
	-- }
	local tbTemp = MineUtil.getDelayData(tbArgs)
	tbArgs.tbTimeSelect = {}

	local imgBg = m_fnGetWidget(self.layMain, "img_add_bg")
	local i18n_title = m_fnGetWidget(imgBg, "TFD_ADD")
	i18n_title:setText(m_i18n[5620]) --"延长占领时间"

	local i18n_DelayMax = m_fnGetWidget(imgBg, "TFD_ADD_DESC") -- "已达最大延长时间"
	local layAddChoose = m_fnGetWidget(imgBg, "LAY_ADD_CHOOSE")
	
	if MineConst.MineInfoType.MINE_SELF == tbArgs.infoType or 
	   MineConst.MineInfoType.MINE_SELF_GOLD == tbArgs.infoType then
		if tbArgs.delay_times and tonumber(tbArgs.delay_times) >=2  then
			tbArgs.bDelayMax = true
		end
		i18n_title:setText(m_i18n[5619])
		i18n_DelayMax:setText(m_i18n[5629])--"已达最大延长时间")
		i18n_DelayMax:setEnabled(tbArgs.bDelayMax)
		layAddChoose:setEnabled(not tbArgs.bDelayMax)
		local num = tonumber(tbArgs.delay_times) or 0
		for i=1,3 do
			if i+num>=3 then
				tbArgs.tbTimeSelect[i] = {}
			else
				tbArgs.tbTimeSelect[i] = tbTemp[i]
			end
		end
		logger:debug(tbArgs.tbTimeSelect)
	elseif MineConst.MineInfoType.MINE_SELF_GOURD == tbArgs.infoType then
		i18n_DelayMax:setText(m_i18n[5630])--"协助海贼无法延长占领时间")
		i18n_title:setText(m_i18n[5619])
		layAddChoose:setEnabled(tbArgs.bDelayMax)
		return
	elseif MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType or
		   MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then
		 i18n_DelayMax:setEnabled(false)
		 layAddChoose:setEnabled(true)
		for i=1,3 do
			if i>1 then
				tbArgs.tbTimeSelect[i] = {}
			else
				tbArgs.tbTimeSelect[i] = tbTemp[i]
			end
		end

	else
		for i,v in ipairs(tbTemp) do
			tbArgs.tbTimeSelect[i] = v
		end
		i18n_DelayMax:setEnabled(tbArgs.bDelayMax)
		layAddChoose:setEnabled(true)
	end

	self.tbCBX = {} -- 保存CheckBox控件的引用, 实现单选
	for i, data in ipairs(tbArgs.tbTimeSelect) do
		self:initSingleSelect(m_fnGetWidget(imgBg, "IMG_ADD_" .. i), i, data)
	end
end

-- 初始化单个占领时间选择的UI
function MineInfoView:initSingleSelect( imgBg, idx, tbData )
	if table.isEmpty(tbData) then
		imgBg:setEnabled(false)
		return
	end	

	imgBg:setEnabled(true)
	self.tbCBX[idx] = m_fnGetWidget(imgBg, "CBX_ADD") -- 复选框
	self.tbCBX[idx]:setTag(idx-1)
	if idx-1 == 0 then
		self.nTimeLevel = 0
		self.tbCBX[idx]:setSelectedState(true)
		self.lastSelect = self.tbCBX[idx] -- 默认选中第一个
	else
		self.tbCBX[idx]:setSelectedState(false) -- 默认不选中
	end
	

	self.tbCBX[idx]:addEventListenerCheckBox(function ( sender, eventType )
		AudioHelper.playCommonEffect()

		local timeIdx = sender:getTag()
		
		if (self.lastSelect ~= sender) then
			self.lastSelect:setSelectedState(false)
		elseif (self.lastSelect == sender) then
			self.lastSelect:setSelectedState(true)
		end
		self.lastSelect = sender
		self.nTimeLevel = timeIdx

	end)

	local i18n_time = m_fnGetWidget(imgBg, "TFD_ADD_TIME")

	if MineConst.MineInfoType.MINE_SELF == self.tbArgs.infoType  then
		i18n_time:setText(m_i18n[5628]) --"延长时间：",
	else
		i18n_time:setText(m_i18n[5626]) --"占领时间：",
	end

	
	local labTime = m_fnGetWidget(imgBg, "TFD_ADD_TIME_NUM")
	labTime:setText(tbData.hour .. m_i18n[1977])

	local i18n_income = m_fnGetWidget(imgBg, "TFD_INCOME")
	i18n_income:setText(m_i18n[5627])--"预估收益：")
	local labIncome = m_fnGetWidget(imgBg, "TFD_INCOME_NUM")
	labIncome:setText(tbData.nBelly)
	imgBg.TFD_TREE_NUM:setText(tbData.nWood)

	local i18n_cost = m_fnGetWidget(imgBg, "TFD_COST")
	i18n_cost:setText(m_i18n[2409])
	local labCost = m_fnGetWidget(imgBg, "TFD_PHYSICAL_NUM")
	labCost:setText(tbData.nCostPower)
	local labGold = m_fnGetWidget(imgBg, "TFD_GOLD_NUM")
	labGold:setText(tbData.nGold)

	imgBg.tfd_physical:setText(m_i18n[1922])
	imgBg.tfd_belly:setText(m_i18n[1520])
	imgBg.tfd_gold:setText(m_i18n[2220])
end

function MineInfoView:showAlert( sType )
	local sType = sType
	if sType == "normal" then
		if not MineUtil.hasGold() then
			local comDlg = UIHelper.createCommonDlg(m_i18n[5675], nil, function (  )
				LayerManager.removeLayout()
				LayerManager.removeLayout()
				MainMineCtrl.switchArea(MineModel.AREA_GOLD)
				ShowNotice.showShellInfo(m_i18n[5644])
			end, 2)
			LayerManager.addLayout(comDlg)
		else
			ShowNotice.showShellInfo(m_i18n[5646])
		end
	elseif sType == "gold" then
		if not MineUtil.hasNormal() then
			local comDlg = UIHelper.createCommonDlg(m_i18n[5676], nil, function (  )
				LayerManager.removeLayout()
				LayerManager.removeLayout()
				MainMineCtrl.switchArea(MineModel.AREA_NORMAL)
				ShowNotice.showShellInfo(m_i18n[5677])
			end, 2)
			LayerManager.addLayout(comDlg)
		else
			ShowNotice.showShellInfo(m_i18n[5657])
		end
	end
		
end


-- 初始化底部按钮
function MineInfoView:initBottomButton( ... )
	-- for test
	local tbArgs = self.tbArgs
	tbArgs.bHolded = false
	if not (MineConst.MineInfoType.MINE_NONE == tbArgs.infoType 
		or MineConst.MineInfoType.MINE_SELF_GOURD == tbArgs.infoType
		or MineConst.MineInfoType.MINE_NONE_GOLD == tbArgs.infoType
		or MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType) then -- 表示显示中间按钮
		tbArgs.bHolded = true
	end

	-- 站矿
	tbArgs.fnHoldCallback = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType or
				 MineConst.MineInfoType.MINE_NONE == tbArgs.infoType then
				if MineUtil.hasNormal() then
					
					self:showAlert("normal")
					return
				end
				if MineUtil.hasGuard() then
					ShowNotice.showShellInfo(m_i18n[5646])
					return
				end
			end
			
			if MineConst.MineInfoType.MINE_NONE_GOLD == tbArgs.infoType or 
				MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then
				if MineUtil.hasGold() then
					self:showAlert("gold")
					return
				end
			end

			local tbCost = tbArgs.tbTimeSelect[self.nTimeLevel+1]
			if tonumber(tbCost.nCostPower) > UserModel.getEnergyValue() then --体力不足
				require "script/module/copy/copyUsePills"
				LayerManager.addLayout(copyUsePills.create())
				return
			end
			if tonumber(tbCost.nGold) > UserModel.getGoldNumber() then -- 金币不足
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				return
			end

			RequestCenter.mineral_capturePit(function (cbFlag, dictData, bRet)
				if dictData.err ~= "ok" then
					return
				end
				if dictData.ret.errCode and  tonumber(dictData.ret.errCode)==1 then
					ShowNotice.showShellInfo(m_i18n[5635]) --5635] = "资源矿信息已发生变化，请重新占领。",
					return
				end

				LayerManager.removeLayout()

				UserModel.addGoldNumber(-tbCost.nGold) -- 扣除金币
				UserModel.addEnergyValue(-tbCost.nCostPower) -- 扣除体力


				local function battleCallback(  )
					
				end
				local tData = {}
				tData.pit_id = tbArgs.pit_id
				tData.domain_id = tbArgs.domain_id
				tData.uname = DB_Stronghold.getDataById(tbArgs.res_attr[2]).name
				logger:debug({tData = tData})
				local fight_ret = dictData.ret.fight_ret
				require "script/battle/BattleModule"
				BattleModule.playMineBattle(fight_ret,battleCallback,tData)
				GlobalNotify.postNotify(MineConst.MineBattleEvt.MINE_BEGIN_BATTLE) 
			end,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id,self.nTimeLevel}))
		end
	end

	-- 抢别人的矿
	tbArgs.fnGrabCallBack = function (sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType then
				if MineUtil.hasNormal() then
					self:showAlert("normal")
					return
				end
				if MineUtil.hasGuard() then
					ShowNotice.showShellInfo(m_i18n[5646])
					return
				end
			end
			
			if MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then
				if MineUtil.hasGold() then
					
					self:showAlert("gold")
					return
				end
			end

			local tbCost = tbArgs.tbTimeSelect[self.nTimeLevel+1]
			if tonumber(tbCost.nCostPower) > UserModel.getEnergyValue() then --体力不足
				require "script/module/copy/copyUsePills"
				LayerManager.addLayout(copyUsePills.create())
				return
			end
			local gold, bExtra = MineUtil.getExtraGold()
			if MineConst.MineInfoType.MINE_OTHER_GOLD ~= tbArgs.infoType then
				gold = 0
			end

			if tonumber(tbCost.nGold+gold) > UserModel.getGoldNumber() then -- 金币不足
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				return
			end

			local function netCallBack(cbFlag, dictData, bRet)
				if dictData.err ~= "ok" then
					return
				end
				if dictData.ret.errCode and  tonumber(dictData.ret.errCode)==2 then
					ShowNotice.showShellInfo(m_i18n[5635]) --5635] = "资源矿信息已发生变化，请重新占领。"
					return
				end

				LayerManager.removeLayout()

				UserModel.addGoldNumber(-tbCost.nGold) -- 扣除金币
				UserModel.addEnergyValue(-tbCost.nCostPower) -- 扣除体力
				UserModel.addGoldNumber(-gold)
				local function battleCallback(  )
					
				end
				local tData = {}
				tData.pit_id = tbArgs.pit_id
				tData.domain_id = tbArgs.domain_id
				tData.uname = tbArgs.uname
				tData.uid = tbArgs.uid
				local fight_ret = dictData.ret.fight_ret

				require "script/battle/BattleModule"
				BattleModule.playMineBattle(fight_ret,battleCallback,tData)
				GlobalNotify.postNotify(MineConst.MineBattleEvt.MINE_BEGIN_BATTLE) 

			end

			if  bExtra and  MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then
				RequestCenter.mineral_grabPitByGold(netCallBack,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id}))
			else
				RequestCenter.mineral_gradPit(netCallBack,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id}))
			end
		end
	end

	-- 延时
	tbArgs.fnDelayCallback = function (sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			if tonumber(tbArgs.delay_times) >= 2 then
				ShowNotice.showShellInfo(m_i18n[5629])
				return 
			end


			local delayTimes = self.nTimeLevel +1
			logger:debug("delayTimes = %s", delayTimes)

			local tbCost = tbArgs.tbTimeSelect[self.nTimeLevel+1]
			if tonumber(tbCost.nCostPower) > UserModel.getEnergyValue() then --体力不足
				require "script/module/copy/copyUsePills"
				LayerManager.addLayout(copyUsePills.create())
				return
			end
			if tonumber(tbCost.nGold) > UserModel.getGoldNumber() then -- 金币不足
				LayerManager.addLayout(UIHelper.createNoGoldAlertDlg())
				return
			end

			RequestCenter.mineral_delayPitDueTime(function (cbFlag, dictData, bRet)
				if dictData.err ~= "ok" then
					return
				end

				if dictData.ret.errCode and (tonumber(dictData.ret.errCode)==12)then
					ShowNotice.showShellInfo(m_i18n[5666]) 
					return
				end

				LayerManager.removeLayout()

				UserModel.addGoldNumber(-tbCost.nGold) -- 扣除金币
				UserModel.addEnergyValue(-tbCost.nCostPower) -- 扣除体力
				
				ShowNotice.showShellInfo(m_i18nString(5651,tbCost.hour))
				GlobalNotify.postNotify(MineConst.MineEvent.DELAY_PIT_DUETIME,{tbArgs.domain_id, tbArgs.pit_id,delayTimes}) 
			end,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id, delayTimes}))
		end
	end

	--放弃占领
	tbArgs.fnAbandanCallback = function (sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			RequestCenter.mineral_giveUpPit(function (cbFlag, dictData, bRet)
				if dictData.err ~= "ok" then
					return
				end
				LayerManager.removeLayout()
				ShowNotice.showShellInfo(m_i18n[5640]) -- "放弃资源岛成功",
				LayerManager.removeLayout()	
				MineModel.updateMine({domain_id = tbArgs.domain_id, pit_id = tbArgs.pit_id})	
		
				GlobalNotify.postNotify(MineConst.MineEvent.GIVEUP_PIT,{tbArgs.domain_id, tbArgs.pit_id}) 

			end,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id,}))

		end
	end

	-- 协助
	tbArgs.fnHelpCallback = function (sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			-- 是否可以抢夺协助军 1 首先判断是否有自己的矿坑， 2 判断协助军是否已经满了，
			if MineUtil.hasNormal() then
				ShowNotice.showShellInfo(m_i18n[5646]) --"同时只可占领一座普通海域或高级海域的资源矿。",
				return
			end
			if MineUtil.hasGuard() then
				ShowNotice.showShellInfo(m_i18n[5642]) --"同时只可协助一座资源岛。",
				return
			end

			if MineUtil.isGuardMax(tbArgs) then
				ShowNotice.showShellInfo(m_i18n[5649])
				return
			end


			RequestCenter.mineral_assistPit(function (cbFlag, dictData, bRet)
				if dictData.err ~= "ok" then
					return
				end

				if dictData.ret.errCode and (tonumber(dictData.ret.errCode)==5  or tonumber(dictData.ret.errCode)==8 )then
					ShowNotice.showShellInfo(m_i18n[5661]) --5635] = "资源矿信息已发生变化，请重新协助。",
					return
				end

				if dictData.ret.errCode and tonumber(dictData.ret.errCode)==11  then
					ShowNotice.showShellInfo(m_i18n[5665])
					return
				end

				LayerManager.removeLayout()
				ShowNotice.showShellInfo(m_i18n[5641])
								
				GlobalNotify.postNotify(MineConst.MineEvent.ASSIST_PIT,{tbArgs.domain_id, tbArgs.pit_id}) 

			end,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id,}))
		end
	end

	-- 放弃协助
	tbArgs.fnAbandonAssistPit = function (sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			RequestCenter.mineral_abandonAssistPit(function (cbFlag, dictData, bRet)
				if dictData.err ~= "ok" then
					return
				end
				LayerManager.removeLayout()
				LayerManager.removeLayout()

				if dictData.ret.errCode and (tonumber(dictData.ret.errCode)==10)then
					ShowNotice.showShellInfo(m_i18n[5664])
					return
				end

				ShowNotice.showShellInfo(m_i18n[5658])
								
				GlobalNotify.postNotify(MineConst.MineEvent.ABANDON_ASSIST_PIT,{tbArgs.domain_id, tbArgs.pit_id}) 

			end,Network.argsHandlerOfTable({tbArgs.domain_id, tbArgs.pit_id,}))
		end
	end

	local layMain = self.layMain

	local btnHold = m_fnGetWidget(layMain, "BTN_3")
	btnHold:setEnabled(not tbArgs.bHolded)

	local btnDelay = m_fnGetWidget(layMain, "BTN_1")
	btnDelay:setEnabled(tbArgs.bHolded)
	local btnAbandon = m_fnGetWidget(layMain, "BTN_2")
	btnAbandon:setEnabled(tbArgs.bHolded)

	if MineConst.MineInfoType.MINE_NONE == tbArgs.infoType or -------
	   MineConst.MineInfoType.MINE_NONE_GOLD == tbArgs.infoType then-----------
		UIHelper.titleShadow(btnHold, m_i18n[5611]) -- 占领
		btnHold:addTouchEventListener(tbArgs.fnHoldCallback)
	elseif MineConst.MineInfoType.MINE_OTHER == tbArgs.infoType then----------
			btnDelay:setEnabled(false)
			btnAbandon:setEnabled(false)
			btnHold:setEnabled(true)
			btnHold:addTouchEventListener(tbArgs.fnGrabCallBack)
			UIHelper.titleShadow(btnHold, m_i18n[5611]) -- 占领
	elseif MineConst.MineInfoType.MINE_SELF == tbArgs.infoType ----------------
		or MineConst.MineInfoType.MINE_SELF_GOLD == tbArgs.infoType then-----------
		UIHelper.titleShadow(btnDelay, m_i18n[5608]) -- "延长占领"
		UIHelper.titleShadow(btnAbandon, m_i18n[5609]) --"放弃占领",
		btnDelay:addTouchEventListener(tbArgs.fnDelayCallback )
		btnAbandon:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				local alert = UIHelper.createCommonDlg(m_i18n[5639], nil, tbArgs.fnAbandanCallback) --"您确认放弃资源岛吗？",
				alert:setName("MINEALERT")
				LayerManager.addLayout(alert) 
			end
		end )
	elseif MineConst.MineInfoType.MINE_SELF_GOURD == tbArgs.infoType then-------------
		UIHelper.titleShadow(btnHold, m_i18n[5612]) -- 放弃协助
		btnHold:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				local alert = UIHelper.createCommonDlg(m_i18n[5647], nil, tbArgs.fnAbandonAssistPit) --"您确认放弃协助资源岛吗？",
				alert:setName("MINEALERT")
				LayerManager.addLayout(alert)
			end
		end)
	elseif MineConst.MineInfoType.MINE_OTHER_GOLD == tbArgs.infoType then-----------
		UIHelper.titleShadow(btnHold, m_i18n[5611]) -- 占领
		btnHold:addTouchEventListener(tbArgs.fnGrabCallBack)
	end
	self.btnHelp:addTouchEventListener(tbArgs.fnHelpCallback)

end

function  MineInfoView:refreshUI(tbArgs) 
	LayerManager.removeLayoutByName("MINEALERT")
	LayerManager.removeLayoutByName("GRABGUARD")
	self:create(tbArgs)
end

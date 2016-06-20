-- FileName: fightMore.lua
-- Author: zhangqi
-- Date: 2014-04-12
-- Purpose: 战5次、战10次的结算面板

module("fightMore", package.seeall)

require "script/GlobalVars"
require "script/utils/LuaUtil"
require "script/model/user/UserModel"
require "script/module/public/EffectHelper"
require "script/module/copy/copyTreasure"
-- UI控件引用变量 --
local layMain -- 战斗结算界面
local labTeamName -- 小队名称 "TFD_NAME"
local btnConfirm -- 确认按钮 "BTN_CONFIRM"

local lsvReward -- 多次奖励ListView "LSV_REWARD"
local layFirstRew -- 默认第一次奖励的单元容器 "LAY_REWARD"

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local fnCreateOnce -- 创建一次的奖励信息
local fnFillItemList -- 一次的奖励物品列表
local fnSetExp -- 处理经验值和经验条的显示
local m_ROWITEM = 5 -- 掉落物品每行3个
local m_nRowCount = 0 -- 掉落战利品的实际行数，用于调整面板的实际高度显示
local nLsvItemHight = 0 -- 一行战利品列表容器的高度
local tbTimeStr = {gi18n[1956],gi18n[1957],gi18n[1958],gi18n[1959],gi18n[1960],gi18n[1961],gi18n[1962],gi18n[1963],gi18n[1964],gi18n[1965]}  -- 临时用，应该有正式的国际化资源代替
local tbDegreeStr = {"simple", "normal", "hard"}
local tbHold -- 据点信息
local m_newHeight = 0 -- 实际的列表高度

local isHaveTreasure = false  --是否有天降宝物
-- menghao
local m_bLvUpdated


local function init(...)
	m_newHeight = 0
end

function destroy(...)

end

function moduleName()
	return "fightMore"
end

--[[desc: 创建普通副本和精英副本战斗胜利结算面板
    nBaseId: 据点id
    nDegree: 难易程度
    tbRewards: array 型 table, doBattle接口返回结果的reward字段值，包含多次的reward，按次序递增
    return: widget对象
—]]
local m_tbRewardByRow = {}
function create( nBaseId, nDegree,resultdata)
	tbRewards=resultdata.reward
	init()
	logger:debug("resultdata==")
	logger:debug(resultdata)
	logger:debug("resultdata==end")
	--判断是否有宝物
	isHaveTreasure=false
	local num = 0
	if (resultdata.extra_reward) then
		for _,v in pairs(resultdata.extra_reward) do
			num=num+1
		end
	end
	if (num>0) then
		isHaveTreasure=true
	end
	if (isHaveTreasure) then   --需要在结算面板中把天降宝物获得的奖励提前修改，因为可能不走天降宝物界面
			---[[修改天降宝物获得的数值奖励
		local treasureData=resultdata.extra_reward
		local tmp=treasureData.silver and UserModel.addSilverNumber(tonumber(treasureData.silver))
		--]]
	end


	layMain = g_fnLoadUI("ui/copy_continue.json")
	UIHelper.registExitAndEnterCall(layMain,
				function()
					layMain=nil
				end,
				function()
				end
			)
	-- 绑定确定按钮事件
	btnConfirm = m_fnGetWidget(layMain, "BTN_CONFIRM")
	UIHelper.titleShadow(btnConfirm, m_i18n[1029])
	btnConfirm:addTouchEventListener(function( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
			if (isHaveTreasure) then
				-- copyTreasure.initinfo(emptyfun,resultdata.extra_reward)
				-- copyTreasure.showTreasureDialog()
				local callback = function()
					LayerManager:removeLayout()
					SwitchCtrl.postBattleNotification("END_BATTLE")
				end
				local treasureReward = copyTreasure.create(callback,resultdata.extra_reward)
				LayerManager.addLayout(treasureReward)
			else
            	SwitchCtrl.postBattleNotification("END_BATTLE")
			end
		end
	end)

	btnConfirm:setTouchEnabled(false)
	UIHelper.setWidgetGray(btnConfirm,true)

	m_tbRewardByRow = nil 
	m_tbRewardByRow = {}
	require "db/DB_Stronghold"
	tbHold = DB_Stronghold.getDataById(nBaseId) --据点信息

	-- 怪物小队名称
	-- labTeamName = m_fnGetWidget(layMain, "TFD_NAME")
	-- labTeamName:setText(tbHold.name)
	-- UIHelper.labelShadow(labTeamName, CCSizeMake(4, -4))
	-- --UIHelper.labelStroke(labTeamName)
	-- UIHelper.labelNewStroke( labTeamName, ccc3(0xff,0xdc,0x7c), 2 )

	-- 奖励列表
	lsvReward = m_fnGetWidget(layMain, "LSV_REWARD")
	-- 默认的第一次面板
	layFirstRew = m_fnGetWidget(lsvReward, "LAY_REWARD")
	-- layFirstRew:setBackGroundColorType(LAYOUT_COLOR_SOLID) -- 设置单色模式
	-- layFirstRew:setBackGroundColor(ccc3(0x00, 0x00, 0x00))
	-- layFirstRew:setBackGroundColorOpacity(200)

	local szLsv = layFirstRew:getSize()
	logger:debug("szLsv.w = %f, h = %f", szLsv.width, szLsv.height)
	local refReward = layFirstRew:clone() -- 先clone一个原始状态的奖励面板，避免先处理默认面板后导致状态变化影响循环里的clone

	-- 创建一到多次的面板
	m_bLvUpdated = false
	logger:debug(m_newHeight)
	fnCreateOnce(layFirstRew, 1, tbRewards[1])
	m_newHeight = m_newHeight + layFirstRew:getSize().height 
	logger:debug(m_newHeight)
	for i = 2, #tbRewards do
		local layRew = refReward:clone()
		fnCreateOnce(layRew, i, tbRewards[i])
		logger:debug("layRew.w = %f, h = %f", layRew:getSize().width, layRew:getSize().height)
		logger:debug("layRew.posX  = %f, h = %f", layRew:getPositionX(), layRew:getPositionY())
		lsvReward:pushBackCustomItem(layRew)
		m_newHeight = m_newHeight + layRew:getSize().height 
		logger:debug(m_newHeight)

	end
	-- do return layMain end
	m_newHeight = m_newHeight + (#tbRewards) * lsvReward:getItemsMargin()
	
	-- performWithDelay(lsvReward, function ( ... )
	-- 	logger:debug(lsvReward:getInnerContainerSize().height)
	-- end, 0.1)
	-- lsvReward:setInnerContainerSize(CCSizeMake(lsvReward:getSize().width, m_newHeight))
	local FRAME_TIME = 1/60
 	-- local nItemTime =  15 * FRAME_TIME + 2 * FRAME_TIME + 10 * FRAME_TIME + 2 * FRAME_TIME + 10 * FRAME_TIME
 	local nItemTime =  10  * FRAME_TIME + 10  * FRAME_TIME 

 	local nRowTime = 0.0
	for i,v in ipairs(m_tbRewardByRow) do
		local itemCell = lsvReward:getItem(i-1)
		for _i,_v in ipairs(v.tb) do
			local layItem = _v 
			local callfunc1 = CCDelayTime:create(6*1 / 60 * (_i - 1)  + nRowTime)
			if(i==2) then
				itemCell:setVisible(false)
			end
			-- local callfunc1 = CCDelayTime:create( nRowTime)
			local callfunc2 = CCCallFunc:create(function ( ... )
					layItem:setVisible(true)
					if(_i < 2) then
						AudioHelper.playBtnEffect("saodangjiesuan.mp3")
					end
					if(i==2) then
						itemCell:setVisible(true)
					end
					local tbNode = UIHelper.getTbChildren(layItem)
					for k,v in pairs(tbNode) do 
						local imgRender = v:getVirtualRenderer()
						imgRender:setScale(1.3)

			           local inone2 = CCArray:create()
			           inone2:addObject(CCScaleTo:create(1/60,1.3))
			           inone2:addObject(CCFadeTo:create(1/60,1*122))

			           local inone3 = CCArray:create()
			           inone3:addObject(CCScaleTo:create(1/60,1.06))
			           inone3:addObject(CCFadeTo:create(1/60,1*255))

						local array = CCArray:create()

						if(_i == 1)then
							array:addObject(CCDelayTime:create(2 * FRAME_TIME)) 
						end
						array:addObject(CCSpawn:create(inone2))
						array:addObject(CCDelayTime:create(2 * FRAME_TIME)) 
						array:addObject(CCSpawn:create(inone3))					
						array:addObject(CCScaleTo:create(2 * FRAME_TIME , 0.95))  
						array:addObject(CCDelayTime:create(3 * FRAME_TIME)) 
						array:addObject(CCScaleTo:create(2 * FRAME_TIME , 1.0))  
						local seq = CCSequence:create(array)
						local imgRender = v:getVirtualRenderer()
						imgRender:runAction(seq)
					end 
			end)
			local sequence = CCSequence:createWithTwoActions(callfunc1, callfunc2)
			layItem:runAction(sequence)
		end

		-- local itemCell = lsvReward:getItem(i-1)
		nRowTime = nRowTime + 10/ 60 * table.count(v.tb) + nItemTime
		local call1 = CCDelayTime:create(nRowTime)
		local call2 = CCCallFunc:create(function ( ... )
							logger:debug("itemCell:getSize().height")
							logger:debug(itemCell:getSize().height)
							
							local posy = itemCell:getPositionY() + itemCell:getSize().height - lsvReward:getSize().height
							local ccper = (1 -   posy / (lsvReward:getInnerContainerSize().height - lsvReward:getSize().height) )* 100
							
							local containerSizeHeight = lsvReward:getInnerContainerSize().height
							local SizeHeight 		  = lsvReward:getSize().height

							local ccper = (1 -   posy / (lsvReward:getInnerContainerSize().height - lsvReward:getSize().height) )* 100
							if( table.count(v.tb) > 5) then
								ccper = ccper + 7
							end
							ccper = ccper>100 and 100 or ccper
							if(containerSizeHeight == SizeHeight) then
								ccper = 100
							end

							ccper = ccper>100 and 100 or ccper
							lsvReward:scrollToPercentVertical(ccper, 20*1/60, false)
							if(i >= table.count(m_tbRewardByRow)) then
								-- btnConfirm:setEnabled(true)
								btnConfirm:setTouchEnabled(true)
								UIHelper.setWidgetGray(btnConfirm,false)
							end
						end)

		local sequence1 = CCSequence:createWithTwoActions(call1, call2)
		if(itemCell) then

			itemCell:runAction(sequence1)
		end
		if(i >2) then
			nRowTime = nRowTime + 10/60 
		end
	end

	--创建结算面板的动画特效
	-- local IMG_RAINBOW = m_fnGetWidget(layMain,"IMG_RAINBOW")
	-- local IMG_TITLE = nil --m_fnGetWidget(layMain,"IMG_TITLE")
	-- local winAnimation = EffBattleWin:new({imgTitle = IMG_TITLE, imgRainBow = IMG_RAINBOW})
	
	return layMain
end

--[[desc: 创建一次的奖励信息面板
    layCell: layout对象，面板容器
    nTimes: 当前战斗序数
    tbReward: 本次战斗奖励信息
    return: 是否有返回值，返回值说明  
—]]
fnCreateOnce = function ( layCell, nTimes, tbReward )
	logger:debug("fightMore:fnCreateOnce, nTimes = %d", nTimes)
	logger:debug(tbReward)

	local labTimes = m_fnGetWidget(layCell, "TFD_TIMES")
	-- labTimes:setText("第" .. tbTimeStr[nTimes] .. "次")
	-- labTimes:setText(m_i18nString(1365, tbTimeStr[nTimes]))
	-- UIHelper.labelAddStroke(labTimes, m_i18nString(1365, tbTimeStr[nTimes]), ccc3(0x43, 0x28, 0x12))
	labTimes:setText(m_i18nString(1365, tbTimeStr[nTimes]))
	UIHelper.labelNewStroke(labTimes,ccc3(0x92, 0x53, 0x1b),2)
	--UIHelper.labelShadow(labTimes, CCSizeMake(3, -3))

	-- local i18nReward = m_fnGetWidget(layCell, "TFD_GAIN") -- [1330] = "获得战利品",
	-- UIHelper.labelAddStroke(i18nReward, m_i18n[1330])
	-- 贝里
	-- local labI18nSilver = m_fnGetWidget(layCell, "tfd_money")
	-- labI18nSilver:setText(m_i18n[1328])
	local labSilverNum = m_fnGetWidget(layCell, "TFD_MONEY_NUM")
	labSilverNum:setText(tostring(tbReward.silver or 0))
	-- 经验
	local i18nExp = m_fnGetWidget(layMain, "tfd_exp")
	i18nExp:setText(m_i18n[1725])
	local labExpNum = m_fnGetWidget(layCell, "TFD_EXP_NUM")
	labExpNum:setText(tostring(tbReward.exp or 0))
	-- 经验条
	local bLvUpdated, nLevel = false -- 获得经验后是否升级
	local barExp = m_fnGetWidget(layCell, "LOAD_EXP_BAR")

	local labnExp = m_fnGetWidget(layCell, "TFD_EXP")
	UIHelper.labelNewStroke(labnExp,ccc3(0x28, 0x00, 0x00),2)

	-- local labnExp = m_fnGetWidget(layCell, "LABN_EXP1")
	-- local labnExpDom = m_fnGetWidget(layCell,"LABN_EXP2")

	--UIHelper.labelStroke(labExp)
	bLvUpdated, nLevel = fnSetExp(barExp, labnExp,labnExpDom, tonumber(tbReward.exp or 0),labExpNum)

	--修改缓存信息
	UserModel.addExpValue(tonumber(tbReward.exp),"dobattle")
	UserModel.addSilverNumber(tonumber(tbReward.silver))
	local levelStr = tbDegreeStr[nDegree] or tbDegreeStr[1]
	local costEnegy = (nDegree == 0) and 0 or (tbHold["cost_energy_" .. levelStr] or 0) --策划确认NPC战(难度为0)不扣体力
	UserModel.addEnergyValue(-1*tonumber(costEnegy)) -- 减少体力

	-- local i18nReward = m_fnGetWidget(layCell, "TFD_REWARD") -- "获得战利品"
	-- UIHelper.labelAddStroke(i18nReward, m_i18n[1330])

	-- 获得武将和物品
	local layRewardNum = m_fnGetWidget(layCell, "LAY_REWARD_NUM")
	local layDropList = m_fnGetWidget(layCell, "IMG_SPOIL_BG")
	local bDrop = fnFillItemList(layDropList, tbReward.hero, tbReward.item) -- 填充武将或物品列表
	local szDropList = layDropList:getSize()
	local szCell = layCell:getSize()
	if (not bDrop) then -- 没有掉落, cell 减去 掉落表的高度
		layDropList:removeFromParentAndCleanup(true) -- 删除默认的战利品列表父节点背景
		layCell:setSize(CCSizeMake(szCell.width, szCell.height - szDropList.height))
		--layRewardNum:setPositionPercent(ccp(0, 0))
	elseif (m_nRowCount > 1) then
		logger:debug(szCell.height + (m_nRowCount-1)*nLsvItemHight)
		layCell:setSize(CCSizeMake(szCell.width, szCell.height + (m_nRowCount-1)*nLsvItemHight))

		local ppDrop = ccp(layDropList:getPosition())
		--layDropList:setPositionPercent(g_GetPercentPosition(layCell, ppDrop.x, szDropList.height)) -- 设置掉落列表坐标

		local ppRewardNum = ccp(layRewardNum:getPosition())
		--layRewardNum:setPositionPercent(g_GetPercentPosition(layCell, ppRewardNum.x, szDropList.height + (ppRewardNum.y - ppDrop.y)))
	end

	logger:debug(layCell:getSize().height)
	-- 等级
	local labLevel = m_fnGetWidget(layCell, "TFD_LV")
	--UIHelper.labelAddStroke(labLevel, nLevel)
	labLevel:setText(nLevel)
	if (bLvUpdated) then -- 如果升级播放升级特效，显示升级信息面板
		logger:debug("level updated !")
		m_bLvUpdated = true
	end
	logger:debug("create once OK")
end


-- menghao 返回有没有升级
function isLevelUp( ... )
	return m_bLvUpdated
end


--[[desc: 创建一次战斗结束的物品列表
    layParent: 父容器对象，一次结算信息面板
    tbHero: 奖励中的武将
    tbItem: 奖励中的物品
    return: 是否有返回值，返回值说明  
—]]
fnFillItemList = function ( layParent, tbHero, tbItem ,nTimes)
	logger:debug(tbHero)
	logger:debug(tbItem)

	local tbHtids = {}
	--排序 1宝物
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isTreasure) then
			table.insert(tbHtids, {tid = v.item_template_id, num = v.item_num})
			table.remove(tbItem,_)
		end
	end
	--排序 2宝物碎片
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isTreasureFragment) then
			table.insert(tbHtids, {tid = v.item_template_id, num = v.item_num})
			table.remove(tbItem,_)
		end
	end
	--排序 3装备
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isArm) then
			table.insert(tbHtids, {tid = v.item_template_id, num = v.item_num})
			table.remove(tbItem,_)
		end
	end
	--排序 4装备碎片
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isFragment) then
			table.insert(tbHtids, {tid = v.item_template_id, num = v.item_num})
			table.remove(tbItem,_)
		end
	end
	--排序 5影子
	for _, v in ipairs(tbItem or {}) do
		local item = ItemUtil.getItemById(v.item_template_id)
		if (item.isHeroFragment) then
			table.insert(tbHtids, {tid = v.item_template_id, num = v.item_num})
			table.remove(tbItem,_)
		end
	end
	
	for k, v in pairs(tbHero or {}) do
		table.insert(tbHtids, {tid = k, num = tonumber(v)}) -- zhangqi, 2014-07-16, 改成掉落影子，属于物品
	end
	for _, v in ipairs(tbItem or {}) do
		table.insert(tbHtids, {tid = v.item_template_id, num = tonumber(v.item_num)})
	end
	logger:debug("fightMore:fnFillItemList")
	logger:debug(tbHtids)
	-- table.insert(tbHtids,tbHtids[1])
	-- table.insert(tbHtids,tbHtids[1])
	-- table.insert(tbHtids,tbHtids[1])	
	-- table.insert(tbHtids,tbHtids[1])
	-- table.insert(tbHtids,tbHtids[1])

	local lsvDrop = m_fnGetWidget(layParent, "LSV_DROP") -- 参考用的物品列表
	lsvDrop:setPositionType(POSITION_ABSOLUTE)
	nLsvItemHight = lsvDrop:getSize().height

	local nHtidCount = #tbHtids
	if (nHtidCount <= 0) then
		return false -- 如果没有掉落
	end

	m_nRowCount = math.floor(nHtidCount/m_ROWITEM) + (nHtidCount%m_ROWITEM > 0 and 1 or 0)
	logger:debug("nHtidCount = %d, m_nRowCount = %d", nHtidCount, m_nRowCount)

	local szBg = layParent:getSize()
	if (m_nRowCount > 1) then -- 如果掉落列表超过1行，需要拓高列表背景的高度
		layParent:setSize(CCSizeMake(szBg.width, szBg.height + (m_nRowCount-1)*nLsvItemHight))
	end


	-- local listHight = 0
	local percentPoint = ccp(lsvDrop:getPosition()) --lsvDrop:getPercentPoint() -- 获取clone参考对象的百分比坐标
	local loopCount = m_nRowCount - 1
	local tb = {}
	for i = 0, loopCount do -- 从 0 开始，方便tbHtids的一维索引变二维
		local lsvCell = lsvDrop:clone()
		lsvCell:setTag(i)
		for j = 1, m_ROWITEM do
			local tbTid = tbHtids[j+i*m_ROWITEM]
			if (tbTid) then
				logger:debug("i = %d, j = %d, htid = %d", i, j, tonumber(tbTid.htid) or tonumber(tbTid.tid))
				local layItem = m_fnGetWidget(lsvCell, "LAY_DROP" .. j)
				local tbInfo, btnItem

				local clickItem=nil
				if (tbTid.htid) then -- 是helro
					btnItem, tbInfo = HeroUtil.createHeroIconBtnByHtid(tbTid.htid,function ( sender,eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							PublicInfoCtrl.createItemInfoViewByTid(tonumber(tbTid.htid),tbTid.num)
						end
					end
					,tbTid.num)
				layItem:setTag(tonumber(tbTid.htid))
				else
					btnItem, tbInfo = ItemUtil.createBtnByTemplateIdAndNumber(tbTid.tid, tbTid.num,function ( sender,eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
							PublicInfoCtrl.createItemInfoViewByTid(tonumber(tbTid.tid))
						end
					end)
					layItem:setTag(tonumber(tbTid.tid))
				end
			
				local imgDef = m_fnGetWidget(layItem, "IMG_" .. j)
				imgDef:addChild(btnItem)
				local labName = m_fnGetWidget(layItem, "TFD_NAME_" .. j)
				UIHelper.labelEffect(labName, tbInfo.name)
				if (tbInfo.quality ~= nil) then
					local color =  g_QulityColor[tonumber(tbInfo.quality)]
					if(color ~= nil) then
						labName:setColor(color)
					end
				end
				layItem:setVisible(false)
				table.insert(tb,layItem)
			else
				local layItem = m_fnGetWidget(lsvCell, "LAY_DROP" .. j)
				layItem:setEnabled(false)
			end
		end
		layParent:addChild(lsvCell)
		lsvCell:setPosition(ccp(percentPoint.x, layParent:getSize().height - (i+1)*nLsvItemHight))
	end

	local tb1 = {}
	tb1.tb = tb
	-- tb1.height = szBg.height  + LAY_REWARD_NUM:getSize().height
	table.insert(m_tbRewardByRow,tb1)
	lsvDrop:removeFromParentAndCleanup(true) -- 删除clone用的参考cell

	return true
end -- end for fnFillItemList

fnSetExp = function( barWidget, labnExp,labnExpDom ,nAddExp,labExpNum)
	require "db/DB_Level_up_exp"
	local tbUserInfo = UserModel.getUserInfo()
	local tUpExp = DB_Level_up_exp.getDataById(2)
	local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
	local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
	local nExpNum = tonumber(tbUserInfo.exp_num) -- 当前的经验值
	local nNewExpNum = (nExpNum + nAddExp)%nLevelUpExp -- 得到当前显示的经验值分子
	logger:debug("lastExp = " .. nExpNum .. " addExp = " .. nAddExp .. " nextExp = " .. nLevelUpExp .. " newExp = " .. nNewExpNum)

	local bLvUp = (nExpNum + nAddExp) >= nLevelUpExp; -- 获得经验后是否升级
	logger:debug("old level = " .. nCurLevel)
	nCurLevel = bLvUp and (nCurLevel + 1) or nCurLevel
	logger:debug("new level = " .. nCurLevel)
	nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 重新计算下一等级需要的经验值，作为分母

	labnExp:setText(nNewExpNum .. "/" .. nLevelUpExp)


	-- labnExp:setStringValue(nNewExpNum)
	-- labnExp:setStringValue(nNewExpNum)
	-- labnExpDom:setStringValue(nLevelUpExp)

	local nPercent = intPercent(nNewExpNum, nLevelUpExp)
	barWidget:setPercent((nPercent > 100) and 100 or nPercent)


	local img_slant  = m_fnGetWidget(barWidget,"img_slant")
	local IMG_MAX = m_fnGetWidget(barWidget,"IMG_MAX")

	IMG_MAX:setEnabled(false)

	--如果达到顶级则显示的经验为0
	local  nMaxLevel = UserModel.getUserMaxLevel()
	logger:debug(" nCurLevel" .. nCurLevel .. " nMaxLevel" .. nMaxLevel)
	if(nCurLevel >= nMaxLevel) then
		barWidget:setPercent(100)
		--z添加max图片
		labnExp:setEnabled(false)
		-- labnExpDom:setEnabled(false)
		-- img_slant:setEnabled(false)

		IMG_MAX:setEnabled(true)

		labExpNum:setText(tostring(0))
	end

	return bLvUp, nCurLevel
end

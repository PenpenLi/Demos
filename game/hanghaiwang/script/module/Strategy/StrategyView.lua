-- FileName: StrategyView.lua
-- Author: yangna
-- Date: 2016-02-04
-- Purpose: 查看攻略
--[[TODO List]]

module("StrategyView", package.seeall)

-- UI控件引用变量 --
local m_battle_report = "ui/battle_report.json"
local m_battle_boss_report = "ui/battle_boss_report.json"
local m_layMain
local m_lsv

-- 模块局部变量 --
local m_tbArgs
local m_type = 1 

local m_i18n = gi18n
local m_i18nString = gi18nString

function destroy(...)
	package.loaded["StrategyView"] = nil
end

function moduleName()
    return "StrategyView"
end


function initListView( ... )
	m_lsv:removeAllItems()
	local tbData = StrategyModel.getStrategyData()
	local tbTitle = { m_i18n[7801],m_i18n[7802],m_i18n[7803] }  --"首位通关","最近通关","极限通关" 

	for i=1,#tbData do
		 --后端返回的数据会存在不连续的情况，如副本只有1，3条，2条已经过期 
		if (table.count(tbData[i]) > 0) then 
			m_lsv:pushBackDefaultItem()
			local cell = m_lsv:getItem(i-1)
			
			local heroIcon = HeroUtil.createHeroIconBtnByHtid(tbData[i].figure, nil, m_tbArgs.onHead)
			heroIcon.data = tbData[i]
	        cell.LAY_ITEM:addChild(heroIcon)
	        local size = cell.LAY_ITEM:getSize()
	        heroIcon:setPosition(ccp(size.width/2,size.height/2))

	        cell.tfd_lv_num:setText(tbData[i].level)
	        cell.tfd_name:setText(tbData[i].uname)
	        cell.tfd_fight:setText(tbData[i].fight_force)

	        local guildname = tbData[i].guild_name
	        if (m_type==5) then
	        	if (guildname) then 
		        	guildname = "【" .. guildname .. "】"
		        	cell.tfd_legion_name:setText(guildname)
	        	else
	        		cell.tfd_legion_name:setVisible(false) 
	        	end 
	        else
	        	cell.tfd_legion_name:setText(guildname or m_i18n[7815] )  --"未加入工会"
	        end 

	        local len = #tbData[i].arrBrid
			cell.BTN_LOOK.brid = tbData[i].arrBrid[len]  --战报id
			cell.BTN_LOOK:setTag(i)
	        cell.BTN_LOOK:addTouchEventListener(m_tbArgs.onBattleReport)
	        UIHelper.titleShadow(cell.BTN_LOOK)

	        local timeStr = TimeUtil.getTimeStringWithFormat(tbData[i].extra.date,"%Y/%m/%d")
	        cell.tfd_time:setText(timeStr)

	        if (m_type==5) then 
	        	cell.tfd_damage_num:setText(tbData[i].extra.damage)
	        	cell.tfd_time_pass:setText(m_i18n[1128])   --"攻击"
	        	cell.tfd_rank:setText(string.format(m_i18n[7819] ,i)) --"第%d名"
	        else
	        	cell.tfd_time_pass:setText(m_i18n[7804])    --"通关"
	        	cell.tfd_rank:setText(tbTitle[i])
	        end 
		end 
	end 
end

function create(tbParams,tbArgs)
	m_type = tbParams.type
	m_tbArgs = tbArgs
	local filename 
	if (m_type == 5) then 
		filename = m_battle_boss_report 
	else 
		filename = m_battle_report
	end 

	m_layMain = g_fnLoadUI(filename)
	m_layMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	m_layMain.tfd_copy_name:setText(tbParams.name)

	m_lsv = m_layMain.LSV_MAIN
	UIHelper.initListView(m_lsv)

	m_lsv:setTouchEnabled(false)   --2016.3.9 策划需求，禁止listview滚动
	initListView()

	return m_layMain
end

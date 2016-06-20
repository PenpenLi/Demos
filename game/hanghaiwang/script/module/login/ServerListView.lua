-- FileName: ServerListView.lua
-- Author: menghao
-- Date: 2014-07-10
-- Purpose: 服务器列表view
-- modified
--[[
2016-01-08, zhangqi, 加入新的最近登录信息，包括角色名和等级
]]


module("ServerListView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_lsvMain
local m_layCell1
local m_layCell2


-- 模块局部变量 --
local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end


function destroy(...)
	package.loaded["ServerListView"] = nil
end


function moduleName()
	return "ServerListView"
end

local function setImage( tbData, itemCell, index )
	local imgNew = m_fnGetWidget(itemCell, "IMG_NEW_" .. index)
	local imgHot = m_fnGetWidget(itemCell, "IMG_HOT_" .. index)
	local tfdName = m_fnGetWidget(itemCell, "TFD_SERVER_NAME" .. index)
	tfdName:setText(tbData.name)
	if tbData.new ~= 1 then
		imgNew:setEnabled(false)
	end
	if tbData.hot ~= 1 then
		imgHot:setEnabled(false)
	end
	if (tbData.tj == 1) then
		imgNew:setEnabled(true) -- 2016-01-20，如果是推荐服显示新服标记
		imgHot:setEnabled(false)
	end
end

local function setLastLoginInfo( tbData, itemCell, index )
	logger:debug({setLastLoginInfo = "setLastLoginInfo", tbData = tbData, index = index})
	-- level = 6
	-- groupid = 120001
	-- uname = "混沌6"
	-- figure = "10173"
				
	local labUName = m_fnGetWidget(itemCell, "TFD_PLAYER_NAME" .. index) 
	local title = string.format(m_i18n[4779], tbData.uname, tostring(tbData.level))
	labUName:setText(title or "")
	-- 2016-01-08, 根据玩家头像id获取品质颜色，设置角色名颜色
	labUName:setColor(UserModel.getPotentialColor({bright = false, htid = tonumber(tbData.figure or 10173)}))

	local tfdName = m_fnGetWidget(itemCell, "TFD_SERVER_NAME" .. index)
	tfdName:setText(tbData.name)
end
                                                                                                
-- zhangqi, web端没有返回最近登录信息时清理相关UI
local function clearLastLoginUI( ... )                                                              
    -- body IMG_RECENT_SERVER LAY_ZHANWEI1 LAY_SERVER2_CLONE1 LAY_ZHANWEI2                          
    if (m_lsvMain) then                                                                             
        local imgTitle = m_fnGetWidget(m_lsvMain, "IMG_RECENT_SERVER")                              
        imgTitle:removeFromParentAndCleanup(true)                                                   
                                                                                                    
        for i = 0, 1 do -- 只能删除LAY_ZHANWEI1 LAY_SERVER2_CLONE1, 多删除LAY_ZHANWEI2会导致全服列表
            m_lsvMain:removeItem(i)                                                                 
        end                                                                                         
    end                                                                                             
end                                                                                                 

local function createList( tbListData, cellIdx )
	logger:debug(tbListData)
	local layCell = (cellIdx == 1 and m_layCell1 or m_layCell2)

	-- 增加条件，如果是最近登录列表且相关信息中不含玩家昵称时（线下）就不显示
	if (not tbListData or #tbListData == 0 or (cellIdx == 1 and tbListData[1].uname == nil)) then
		layCell:setEnabled(false)
		if (cellIdx == 1) then                                                                 
		    clearLastLoginUI() -- zhangqi, 2016-01-16, 如果最近登录服务器列表为空则删除相关控件
		end                                                                                    
		return
	end

	m_lsvMain:setItemModel(layCell)

	local tNum = (#tbListData + 1) / 2
	local index = m_lsvMain:getIndex(layCell) - 1
	for i=2,tNum do
		if (cellIdx == 1) then
			m_lsvMain:insertDefaultItem(index + i)
		elseif (cellIdx == 2) then
			m_lsvMain:pushBackDefaultItem()
		end
	end

	for i=1,tNum do
		local itemCell = m_lsvMain:getItem(index + i)
		local tbData1 = tbListData[2 * i - 1]
		local tbData2 = tbListData[2 * i]

		if tbData1 then
			local btnServer = m_fnGetWidget(itemCell, "BTN_SERVER1")
			if (cellIdx == 2) then
				setImage(tbData1, itemCell, 1)
			else
				setLastLoginInfo(tbData1, itemCell, 1)
			end

			btnServer:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()
					logger:debug({tbData1 = tbData1})
					NewLoginCtrl.setSelectServer(tbData1)
				end
			end)
		end

		if tbData2 then
			local btnServer = m_fnGetWidget(itemCell, "BTN_SERVER2")
			if (cellIdx == 2) then
				setImage(tbData2, itemCell, 2)
			else
				setLastLoginInfo(tbData2, itemCell, 2)
			end

			btnServer:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()
					logger:debug({tbData2 = tbData2})
					NewLoginCtrl.setSelectServer(tbData2)
				end
			end)
		else
			local btnServer = m_fnGetWidget(itemCell, "BTN_SERVER2")
			btnServer:setEnabled(false)
		end
	end
end

function create(tbAllServerData, recentServerList)
	m_UIMain = g_fnLoadUI("ui/regist_server.json")

	m_lsvMain = m_fnGetWidget(m_UIMain, "LSV_MAIN")
	m_layCell1 = m_fnGetWidget(m_UIMain, "LAY_SERVER2_CLONE1")
	m_layCell2 = m_fnGetWidget(m_UIMain, "LAY_SERVER2_CLONE2")

	local btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE") -- zhangqi, 2015-12-16
	btnClose:addTouchEventListener(UIHelper.onClose)

	-- 最近登陆服务器列表
	createList(recentServerList, 1)
	-- 所有服务器列表
	createList(tbAllServerData, 2)

	return m_UIMain
end


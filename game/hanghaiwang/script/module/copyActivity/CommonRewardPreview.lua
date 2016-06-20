-- FileName: CommonRewardPreview.lua
-- Author: liweidong
-- Date: 2015-01-14
-- Purpose: 非贝利副本奖励预览
--[[TODO List]]

module("CommonRewardPreview", package.seeall)

-- UI控件引用变量 --
local layoutMain

-- 模块局部变量 --
local difficult = 1 --副本难度
local copyId

local function init(...)

end

function destroy(...)
	package.loaded["CommonRewardPreview"] = nil
end

function moduleName()
    return "CommonRewardPreview"
end
--显示单个item 
function createItemInfo(cell,v)
	local itemObj = ItemUtil.getItemById(tonumber(v))
	local item = {}
	item.name = itemObj.name
	item.quality = itemObj.quality
	item.icon = ItemUtil.createBtnByTemplateId(tonumber(v),
					function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
						if (eventType == TOUCH_EVENT_ENDED) then
							PublicInfoCtrl.createItemInfoViewByTid(tonumber(v))
							--AudioHelper.playCommonEffect()
						end
					end)
	local iconBg = g_fnGetWidgetByName(cell, "IMG_REWARD")
	iconBg:removeAllChildrenWithCleanup(true)
	iconBg:addChild(item.icon)
	local itemName = g_fnGetWidgetByName(cell, "TFD_REWARD_NAME")
	itemName:setText(item.name)
	if (item.quality ~= nil) then
		local color =  g_QulityColor[tonumber(item.quality)]
		if(color ~= nil) then
			itemName:setColor(color)
		end
	end
end
--更新显示掉落物品
function updateDropList()
	local db=DB_Activitycopy.getDataById(copyId)
	local rewardArr=lua_string_split(db["preview_"..difficult] and db["preview_"..difficult] or "", ",")
	local rewardArr1=lua_string_split(rewardArr[1], "|")
	local _,otherRewardIds = OutputMultiplyUtil.getAdditionalDrop()
	if (otherRewardIds) then
		for _,id in ipairs(otherRewardIds) do
			rewardArr1[#rewardArr1+1] = id
		end
	end
	local rewardArr2=lua_string_split(rewardArr[2], "|")
	local rewardArr3=lua_string_split(rewardArr[3], "|")

	local descArr=lua_string_split(db["desc"..difficult] and db["desc"..difficult] or "", "|")
	local desc1 = g_fnGetWidgetByName(layoutMain, "TFD_STAR1_RANGE")
	desc1:setText(descArr[1] and descArr[1] or "")
	if false then -- 去掉星级奖励(db.type~=2) then
		local desc2 = g_fnGetWidgetByName(layoutMain, "TFD_STAR2_RANGE")
		desc2:setText(descArr[2] and descArr[2] or "")
		local desc3 = g_fnGetWidgetByName(layoutMain, "TFD_STAR3_RANGE")
		desc3:setText(descArr[3] and descArr[3] or "")
	end

	if false then -- 去掉星级奖励if (db.type~=2) then
		local starList3 = g_fnGetWidgetByName(layoutMain, "LSV_STAR3")
		UIHelper.initListWithNumAndCell(starList3,#rewardArr3)

		local i = 0
		for k,v in pairs(rewardArr3) do
			cell = starList3:getItem(i)  -- cell 索引从 0 开始
			createItemInfo(cell,v)
			i=i+1
		end
		if (i<=4) then
			starList3:setTouchEnabled(false)
		else
			starList3:setTouchEnabled(true)
		end

		local starList2 = g_fnGetWidgetByName(layoutMain, "LSV_STAR2")
		UIHelper.initListWithNumAndCell(starList2,#rewardArr2)

		i = 0
		for k,v in pairs(rewardArr2) do
			cell = starList2:getItem(i)  -- cell 索引从 0 开始
			createItemInfo(cell,v)
			i=i+1
		end
		if (i<=4) then
			starList2:setTouchEnabled(false)
		else
			starList2:setTouchEnabled(true)
		end
	end
	local starList1 = g_fnGetWidgetByName(layoutMain, "LSV_STAR1")
	UIHelper.initListWithNumAndCell(starList1,#rewardArr1)

	i = 0
	for k,v in pairs(rewardArr1) do
		cell = starList1:getItem(i)  -- cell 索引从 0 开始
		createItemInfo(cell,v)
		i=i+1
	end
	if (i<=4) then
		starList1:setTouchEnabled(false)
	else
		starList1:setTouchEnabled(true)
	end

end
--奖励预览
function onClickDifficult( sender, eventType )
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playTabEffect()
	local idx = sender:getTag()
	if (idx==difficult) then
		return
	end
	difficult=idx
	local db=DB_Activitycopy.getDataById(copyId)
	local openLv=lua_string_split(db.limit_lv, "|")
	if (tonumber(openLv[difficult])==999) then
		ShowNotice.showShellInfo(gi18n[4315]) --TODO"该难度暂未开启"
		return
	end
	updateDropList()
	for i=1,6 do
		local difficultBtn = g_fnGetWidgetByName(layoutMain, "BTN_HARD"..i)
		difficultBtn:setFocused(false)
		difficultBtn:setTouchEnabled(true)
		local naduLb = g_fnGetWidgetByName(layoutMain, "IMG_HARD_N"..i)
		-- naduLb:setColor(ccc3(0xAE,0x2D,0x05))
		naduLb:setVisible(true)
		local naduLb2 = g_fnGetWidgetByName(layoutMain, "IMG_HARD_H"..i)
		naduLb2:setVisible(false)
		if (i==difficult) then
			naduLb:setVisible(false)
			naduLb2:setVisible(true)
		end
		if (tonumber(openLv[i])==999) then
			difficultBtn:setBright(false)
			-- naduLb:setColor(ccc3(0x2d,0x2d,0x2d))
			-- naduLb2:setColor(ccc3(0xff,0xff,0xff))
			-- UIHelper.labelNewStroke(naduLb2, ccc3(0x00,0x00,0x00), 2)
			difficultBtn:setEnabled(false)
		end
	end
	local btn = tolua.cast(sender, "Button")
	btn:setFocused(true)
	btn:setTouchEnabled(false)
end
function create(id)
	copyId=id
	difficult=1
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			) 
		local db=DB_Activitycopy.getDataById(copyId)
		local jsonFile="ui/acopy_reward.json"
		if true then -- 去掉星级奖励 if (db.type==2) then
			jsonFile="ui/acopy_reward_shadow.json"
		end
		local mainLayout = g_fnLoadUI(jsonFile)
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

		local sureBtn = g_fnGetWidgetByName(layoutMain, "BTN_CONFIRM")
		sureBtn:addTouchEventListener(function( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()
				end
			end)
		UIHelper.titleShadow(sureBtn)

		
		local openLv=lua_string_split(db.limit_lv, "|")
		for i=1,6 do
			local difficultBtn = g_fnGetWidgetByName(layoutMain, "BTN_HARD"..i)
			difficultBtn:setTag(i)
			difficultBtn:addTouchEventListener(onClickDifficult)
			local naduLb = g_fnGetWidgetByName(layoutMain, "IMG_HARD_N"..i)
			naduLb:setVisible(true)
			local naduLb2 = g_fnGetWidgetByName(layoutMain, "IMG_HARD_H"..i)
			naduLb2:setVisible(false)
			if (i==1) then
				naduLb:setVisible(false)
				naduLb2:setVisible(true)
				difficultBtn:setFocused(true)
				difficultBtn:setTouchEnabled(false)
			end
			if (tonumber(openLv[i])==999) then
				--difficultBtn:setTouchEnabled(false)
				difficultBtn:setBright(false)
				-- naduLb:setColor(ccc3(0x2d,0x2d,0x2d))
				-- naduLb2:setColor(ccc3(0xff,0xff,0xff))
				-- UIHelper.labelNewStroke(naduLb2, ccc3(0x00,0x00,0x00), 2)
				difficultBtn:setEnabled(false)
			end
		end
		if false then -- 去掉星级奖励 if (db.type~=2) then
			local starList3 = g_fnGetWidgetByName(layoutMain, "LSV_STAR3")
			UIHelper.initListView(starList3)
			
			local starList2 = g_fnGetWidgetByName(layoutMain, "LSV_STAR2")
			UIHelper.initListView(starList2)
		end

		local starList1 = g_fnGetWidgetByName(layoutMain, "LSV_STAR1")
		UIHelper.initListView(starList1)

		updateDropList()
	end
	LayerManager.addLayout(layoutMain)
end

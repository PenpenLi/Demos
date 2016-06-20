-- FileName: BellyRewardPreview.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 显示贝利奖励预览
--[[TODO List]]

module("BellyRewardPreview", package.seeall)

-- UI控件引用变量 --
local layoutMain
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["BellyRewardPreview"] = nil
end

function moduleName()
    return "BellyRewardPreview"
end
function addArrowAction( node )
	if (not node) then
		return
	end

	local ct = 1.5 -- 渐隐渐现总时长 1.5秒
	local arrAct = CCArray:create()
	arrAct:addObject(CCFadeIn:create(ct/2))
	arrAct:addObject(CCFadeOut:create(ct/2))
	-- arrAct:addObject(CCMoveBy:create(0.05,ccp(0,1)))
	local act = CCRepeatForever:create(CCSequence:create(arrAct))
	node:runAction(act)

end
function create(id)
	layoutMain = Layout:create()
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			) 
		--副本标签
		local mainLayout = g_fnLoadUI("ui/acopy_belly_preview.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

		local sureBtn = g_fnGetWidgetByName(layoutMain, "BTN_ENSURE")
		sureBtn:addTouchEventListener(function( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					LayerManager.removeLayout()
				end
			end)
		UIHelper.titleShadow(sureBtn)
		
		local tfd_dps = g_fnGetWidgetByName(layoutMain, "tfd_dps")
		-- UIHelper.labelNewStroke(tfd_dps, ccc3(0x7a,0x2f,0x01), 2)
		local tfd_money = g_fnGetWidgetByName(layoutMain, "tfd_money")
		-- UIHelper.labelNewStroke(tfd_money, ccc3(0x7a,0x2f,0x01), 2)
		--初始化贝利奖励
		local db=DB_Activitycopy.getDataById(id)
		local rankArr=lua_string_split(db.dps, "|")
		local bellyArr=lua_string_split(db.belly, "|")
		-- for i=1,10 do
		-- 	local itemLay = g_fnGetWidgetByName(layoutMain, "LAY_RANK"..i)
		-- 	local rank = g_fnGetWidgetByName(itemLay, "TFD_RANK")
		-- 	rank:setText(rankArr[i])
		-- 	local belly = g_fnGetWidgetByName(itemLay, "TFD_GOLD")
		-- 	belly:setText(bellyArr[i])
		-- end
		--初始化list
		UIHelper.initListView(layoutMain.LSV_PREVIEW)
		UIHelper.initListWithNumAndCell(layoutMain.LSV_PREVIEW,#rankArr)
		for i=#rankArr,1,-1 do
			local realCell = layoutMain.LSV_PREVIEW:getItem(i-1)
			realCell.TFD_RANK:setText(rankArr[i])
			realCell.TFD_GOLD:setText(math.floor(bellyArr[i]*OutputMultiplyUtil.getDailyCopyRateNum(id)/10000))
		end 

		--两个箭头
		schedule(layoutMain,function()
				local cellTop = tolua.cast(layoutMain.LSV_PREVIEW:getItem(0),"Widget")
				local cellBottom = tolua.cast(layoutMain.LSV_PREVIEW:getItem(#rankArr-1),"Widget")

				local posList = layoutMain.LSV_PREVIEW:convertToWorldSpace(ccp(0,0))
				local posBcell = cellBottom:convertToWorldSpace(ccp(0,0))
				local posTcell = cellTop:convertToWorldSpace(ccp(0,0))

				if (posTcell.y>posList.y+layoutMain.LSV_PREVIEW:getSize().height) then
					-- layoutMain.IMG_ARROW_UP:setVisible(true)
				else
					layoutMain.IMG_ARROW_UP:setVisible(false)
				end

				if (posBcell.y+cellBottom:getContentSize().height<posList.y) then
					-- layoutMain.IMG_ARROW_DOWN:setVisible(true)
				else
					layoutMain.IMG_ARROW_DOWN:setVisible(false)
				end
			end,0.01)
		layoutMain.IMG_ARROW_DOWN:setVisible(false)
		layoutMain.IMG_ARROW_UP:setVisible(false)
		addArrowAction(layoutMain.IMG_ARROW_UP:getVirtualRenderer())
		performWithDelay(layoutMain,function() --两个一块闪看着太难受
				addArrowAction(layoutMain.IMG_ARROW_DOWN:getVirtualRenderer())
			end,0.1)
		
	end
	LayerManager.addLayout(layoutMain)
end

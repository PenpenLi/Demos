-- FileName: ExploreProgressRewardCtrl.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 探索进度奖励领取
--[[TODO List]]
module("ExploreProgressRewardCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local copyID = 1
local updateCallback = nil --刷新调用者的UI
local selectItem = 0
local layoutMain

local function init(...)

end

function destroy(...)
	package.loaded["ExploreProgressRewardCtrl"] = nil
end

function moduleName()
    return "ExploreProgressRewardCtrl"
end
--程序点击领奖按钮
function autoClickGetReward(callback)
	local min,max,times,rewardInfo =  ExplorData.getExploreProgress()
	if times>0 then
		getRewardCallback(nil, TOUCH_EVENT_ENDED)
	else
		getRandomReward1(nil, TOUCH_EVENT_ENDED)
	end
	updateCallback=callback
end
function create(callback)
	local min,max,times,rewardInfo =  ExplorData.getExploreProgress()
	local function previewReward( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playSpecialEffect("dianji_fubenbaoxiang.mp3")  
			if times>0 then
				getRewardCallback(sender, eventType)
			else
				getRandomReward1(sender, eventType)
			end
		end
	end
	
	local icon = Button:create()
	if (min<max) then
		icon:loadTextureNormal("ui/gold_box_close_n.png")
		icon:loadTexturePressed("ui/gold_box_close_h.png")
	else
		icon:loadTextureNormal("ui/gold_box_open_n.png")
		icon:loadTexturePressed("ui/gold_box_open_h.png")
		local mainPath = "images/effect/guide/zhishi_2"
		local mArmature = UIHelper.createArmatureNode({
			filePath = mainPath .. ".ExportJson",
			plistPath = mainPath .. "0.plist",
			imagePath = mainPath .. "0.png",
			animationName = "zhishi_2",
			loop = 1,
		})
		icon:addNode(mArmature,100,100)

	end
	icon:addTouchEventListener(previewReward)
	updateCallback=callback
	return icon
end

--显示获得的奖励
function showRewardDialog(rewardData)
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()
	local rewardData
	if (rewardnum>0) then
		rewardData={
			item={[tonumber(rewardInfo[3])]=tonumber(rewardInfo[4])}
		}
		if tonumber(rewardInfo[2])==3 then
			rewardData.item=nil
			rewardData.gold=tonumber(rewardInfo[4])
		end
	else
		local copeInfoData=DB_Copy.getDataById(1)
		local itemid = copeInfoData.supar_rewrd

		rewardData={
			item={[tonumber(itemid)]=1}
		}
	end

	local items = ItemDropUtil.getDropTreasureItem(rewardData)
	local brow = UIHelper.createGetRewardInfoDlg(gi18n[1901], items)
	LayerManager.addLayout(brow)
end
--获取奖励服务器回调
function reqRewardCallback(cbFlag, dictData, bRet)
	if(dictData.err=="ok")then
		--显示获得的奖励
		logger:debug("explore progress reward>>>>")
		logger:debug(dictData)
		local treasureData = dictData.ret
		local tmp = treasureData.silver and UserModel.addSilverNumber(tonumber(treasureData.silver))
		local tmp = treasureData.gold and UserModel.addGoldNumber(tonumber(treasureData.gold))
		showRewardDialog(treasureData)
		ExplorData.resetExploreProgressReward()
		if updateCallback then
			updateCallback()
		end
	end
end


--执行领取
function newGetRewardCallback(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	LayerManager.removeLayout()
	-- AudioHelper.playCommonEffect()
	AudioHelper.playBtnEffect("tansuo02.mp3")
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()

	if (min<max) then
		ShowNotice.showShellInfo(gi18n[4301])
		return
	end
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		--ShowNotice.showShellInfo("背包已满,请整理背包")
		return
	end
	local arr = CCArray:create()
	arr:addObject(CCInteger:create(0))
	RequestCenter.getExploreProgressReward(reqRewardCallback,arr)
end
--获得进度奖励按钮 固定奖励查看
function getRewardCallback(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	-- AudioHelper.playCommonEffect() 
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()

	-- local copeInfoData=DB_Copy.getDataById(copyID)
	-- local itemid = copeInfoData.supar_rewrd
	local rewardData={
		item={[tonumber(rewardInfo[3])]=tonumber(rewardInfo[4])}
	}
	if tonumber(rewardInfo[2])==3 then
		rewardData.item=nil
		rewardData.gold=tonumber(rewardInfo[4])
	end
	
	local btnTitle = gi18n[2629] --"确定"
	local callback = function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
			if (eventType == TOUCH_EVENT_ENDED) then
				logger:debug("enter explor progress reward click")
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
			end
		end
	if (min>=max) then
		btnTitle=gi18n[2628] --"领取"
		callback=newGetRewardCallback
	end
	logger:debug("enter explor progress reward")

	UIHelper.showExploreProgressItemDlg(rewardData,btnTitle,max.."/"..max,callback)
	
end
--随机奖励改为固定奖励
function getRandomReward1(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()

	local copeInfoData=DB_Copy.getDataById(1)
	local itemid = copeInfoData.supar_rewrd

	local rewardData={
		item={[tonumber(itemid)]=1}
	}
	-- if tonumber(rewardInfo[2])==3 then
	-- 	rewardData.item=nil
	-- 	rewardData.gold=tonumber(rewardInfo[4])
	-- end
	
	local btnTitle = gi18n[2629] --"确定"
	local callback = function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
			if (eventType == TOUCH_EVENT_ENDED) then
				logger:debug("enter explor progress reward click")
				AudioHelper.playCommonEffect()
				LayerManager.removeLayout()
			end
		end
	if (min>=max) then
		btnTitle=gi18n[2628] --"领取"
		callback=getStateRewardCallback1
	end

	UIHelper.showExploreProgressItemDlg(rewardData,btnTitle,max.."/"..max,callback)
	
end
--随机奖励改为固定奖励 执行领取固定奖励
function getStateRewardCallback1(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()

	if (min<max) then
		ShowNotice.showShellInfo(gi18n[4301])
		return
	end
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		--ShowNotice.showShellInfo("背包已满,请整理背包")
		return
	end
	--判断是否选中一个奖励
	selectItem=1
	if (selectItem==0) then
		ShowNotice.showShellInfo(gi18n[4309]) --TODO "请选择一个奖励领取"
		return
	end
	LayerManager.removeLayout()

	local arr = CCArray:create()
	arr:addObject(CCInteger:create(selectItem))
	RequestCenter.getExploreProgressReward(reqRewardCallback,arr)
end
--执行领取固定奖励
function getStateRewardCallback(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect() 
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()

	if (min<max) then
		ShowNotice.showShellInfo(gi18n[4301])
		return
	end
	-- 检查背包是否已满
	if (ItemUtil.isBagFull(true)) then
		--ShowNotice.showShellInfo("背包已满,请整理背包")
		return
	end
	--判断是否选中一个奖励
	if (selectItem==0) then
		ShowNotice.showShellInfo(gi18n[4309]) --TODO "请选择一个奖励领取"
		return
	end
	LayerManager.removeLayout()

	local arr = CCArray:create()
	arr:addObject(CCInteger:create(selectItem))
	RequestCenter.getExploreProgressReward(reqRewardCallback,arr)
end
--获取db所有id
function getNormalCopyDbIds()
	require "db/DB_Copy"
	local ids = {}
	-- for keys,val in pairs(DB_Copy.Copy) do
	-- 	local keyArr = lua_string_split(keys, "_")
	-- 	ids[#ids+1]=tonumber(keyArr[2])
	-- 	--table.insert(ids,tonumber(keyArr[2]))
	-- end
	for i=1,table.count(DB_Copy.Copy) do
		table.insert(ids,i)
	end
	return ids
end
--随机奖励查看
function getRandomReward(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCommonEffect()
	selectItem = 0
	layoutMain = Layout:create()
	local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()

	if (layoutMain) then
		--副本标签
		local mainLayer = g_fnLoadUI("ui/supar_reward_circle.json")
		mainLayer:setSize(g_winSize)
		layoutMain:addChild(mainLayer)
		
		LayerManager.addLayout(layoutMain)

		local BTN_CLOSE = g_fnGetWidgetByName(mainLayer, "BTN_CLOSE")
		BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
	end


	-- local copyArr = lua_string_split(DB_World.getDataById(10000).entrance,"|")
	local copyArr = getNormalCopyDbIds()
	local list = g_fnGetWidgetByName(layoutMain, "LSV_ITEM")
	UIHelper.initListView(list)
	local i = 0
	for k,v in pairs(copyArr) do
		-- local cross = MainCopy.getCrossEntrance(v)
		local cross = MainCopy.fnCrossCopy(v)
		if (cross) then
			-- local entceItemData = DB_Copy_entrance.getDataById(v)
			-- local copyArr = lua_string_split(entceItemData.normal_copyid,"|")
			-- local copyV = copyArr[#copyArr]
			local copeInfoData=DB_Copy.getDataById(v)
			local canExplorStatus = copeInfoData.is_exploration
			logger:debug("explore data id======"..v)
			--itemCopyBtn:setTag(entceItemData.id)
			if (canExplorStatus==1 and copeInfoData.supar_rewrd) then
				list:pushBackDefaultItem()
				cell = list:getItem(i)  -- cell 索引从 0 开始
				local cbx = g_fnGetWidgetByName(cell, "CBX_ITEM")
				cbx:setTag(v)
				cbx:addEventListenerCheckBox(onCheckBox)

				local copyName = g_fnGetWidgetByName(cell, "TFD_COPY_NAME")
				copyName:setText(copeInfoData.name)
				UIHelper.labelNewStroke(copyName,ccc3(0x31,0,0),2)

				local itemName = g_fnGetWidgetByName(cell, "TFD_ITEM_NAME")
				UIHelper.labelNewStroke(itemName,ccc3(0x31,0,0),2)

				local giftImg = g_fnGetWidgetByName(cell, "BTN_RANDGIFT_BG")
				local itemid = copeInfoData.supar_rewrd
				local icon = ItemUtil.createBtnByTemplateId(itemid,
							function ( sender, eventType )  
							end) 
				giftImg:addChild(icon)

				
				local randomIds = lua_string_split(copeInfoData.supar_reward_show, "|")
				logger:debug("randomIds ")
				logger:debug(randomIds)
				for key,val in ipairs(randomIds) do
					logger:debug(tonumber(randomIds[key]))
					local itemObj = ItemUtil.getItemById(tonumber(randomIds[key]))
					local itemName = g_fnGetWidgetByName(cell, "TFD_SHOW_NAME"..key)
					itemName:setText(itemObj.name)
					local color =  g_QulityColor2[tonumber(itemObj.quality)]
					if(color ~= nil) then
						itemName:setColor(color)
					end
					UIHelper.labelNewStroke(itemName,ccc3(0x31,0,0),2)
					
					-- local icon = ItemUtil.createBtnByTemplateIdAndNumber(tonumber(randomIds[key]),1,
					-- 	function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
					-- 	end)
					local icon = ItemUtil.createBtnByTemplateId(tonumber(randomIds[key]),
							function ( sender, eventType )  -- 道具图标按钮事件，弹出道具信息框
								if (eventType == TOUCH_EVENT_ENDED) then
									AudioHelper.playCommonEffect() 
									PublicInfoCtrl.createItemInfoViewByTid(tonumber(randomIds[key]))
								end
							end) 
					local itemImg = g_fnGetWidgetByName(cell, "BTN_SHOW"..key)
					itemImg:addChild(icon)

				end

				i=i+1
			end
		end
	end

	
	local btnTitle = gi18n[2629] --"确定" 
	local callback = UIHelper.onClose
	if (min>=max) then
		btnTitle=gi18n[2628] --"领取"
		callback=getStateRewardCallback
	end
	local BTN_GET = g_fnGetWidgetByName(layoutMain, "BTN_GET")
	UIHelper.titleShadow(BTN_GET,btnTitle)
	BTN_GET:addTouchEventListener(callback)
end

--选取一行
function onCheckBox( sender, eventType )
	AudioHelper.playCommonEffect() 
	if (eventType == CHECKBOX_STATE_EVENT_SELECTED) then
		local min,max,rewardnum,rewardInfo = ExplorData.getExploreProgress()
		if (min<max) then
			ShowNotice.showShellInfo(string.format(gi18n[4310],max))  --TODO"进度达到%d可领取奖励"
			sender:setSelectedState(false)
			return
		end
		local list = g_fnGetWidgetByName(layoutMain, "LSV_ITEM")
		local sumpage = tonumber(list:getItems():count())
		for i=1,sumpage,1 do
			cell = list:getItem(i-1)
			local cbx = g_fnGetWidgetByName(cell, "CBX_ITEM")
			cbx:setSelectedState(false)
		end
		sender:setSelectedState(true)
		selectItem=sender:getTag()
	end
	if (eventType == CHECKBOX_STATE_EVENT_UNSELECTED) then
		selectItem=0
	end
end

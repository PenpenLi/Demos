-- FileName: staminaFdsCtrl.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 好友赠送耐力控制器
--[[TODO List]]

module("staminaFdsCtrl", package.seeall)

require "script/module/friends/staminaFdsView"
-- require "script/module/friends/MainFdsView"

-- UI控件引用变量 --

-- 模块局部变量 --
local fnEventCallBack = {}
local layoutMain 
local imgTip --显示耐力数量

local function init(...)

end

function destroy(...)
	imgTip = nil
	staminaFdsView.destroy()
	package.loaded["staminaFdsCtrl"] = nil
end

function moduleName()
    return "staminaFdsCtrl"
end

fnEventCallBack.onBtnClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
    end  
end

fnEventCallBack.onBtnGoGive = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		MainFdsView.onSelectFocus(1)
    end  
end

local function getAllCallBack( cbFlag, dictData, bRet  )
	if(bRet == true)then
		print("getLoveAll")
		-- 领取耐力后更新好友已赠送状态
		local tbGiveData = staminaFdsData.getFdsGiveData(dictData.ret.list)
		if (tbGiveData ~= nil) then
			for sK,sV in ipairs(tbGiveData) do
				MainFdsCtrl.updateGiveStatus(sV)
			end
		end
		-- 可领取耐力列表
		staminaFdsData.setReceiveList( dictData.ret.list ) 
		-- 今日剩余领取次数
		local times = staminaFdsData.getTodayReceiveTimes()
		local curUseTimes = tonumber(dictData.ret.receivedNum)
		staminaFdsData.setTodayReceiveTimes( times-curUseTimes )
		-- 获得的耐力
		local oneData = staminaFdsData.getGiveStaminaNum()
		local totalData = oneData * curUseTimes
		print("totalData",totalData)
		UserModel.addStaminaNumber( totalData )
		staminaFdsView.updateListView()
		updateTipNum() --更新可领取的耐力数量
		staminaFdsView.getAllLayer(totalData,staminaFdsData.getTodayReceiveTimes())
	end
end

local function fnSureLove( ... )
	AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
	staminaFdsData.getAllLoveReq(getAllCallBack)
	LayerManager.removeLayout()
end

fnEventCallBack.onBtnGetAll = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- 判断领取列表是否为空
		local listData = staminaFdsData.getStaminaList()
		if( table.count(listData) == 0)then
			ShowNotice.showShellInfo(gi18n[4337])--"没有耐力可以领取！"
			return
		end
		-- 判断是否还有剩余次数
		local times = staminaFdsData.getTodayReceiveTimes()
		if( times <= 0)then
			ShowNotice.showShellInfo(gi18n[4338])--"今日已达领取耐力次数上限，无法领取！"
			return
		end
		
        require "script/module/public/UIHelper"
        local strMsg = gi18n[2927] --"确认全部领取并回赠好友吗?"
        local layDlg = UIHelper.createCommonDlg(strMsg, nil, fnSureLove)
        LayerManager.addLayout(layDlg)
    end
end

local function getLoveCallBack( cbFlag, dictData, bRet  )
	if(bRet == true)then
		print("getLoveItem")
		print_t(dictData)
		local isRebate = staminaFdsData.isRebateFun()
		local curUid = staminaFdsData.getUid()
		
		-- 删除已经领取的耐力
		staminaFdsData.delStaminaDataByTimeAndUid() 
		-- 今日剩余领取次数
		local times = staminaFdsData.getTodayReceiveTimes()
		staminaFdsData.setTodayReceiveTimes( times-1 )
		-- 获得的耐力
		local oneData = staminaFdsData.getGiveStaminaNum()
		UserModel.addStaminaNumber( oneData )
		staminaFdsView.updateListView()
		updateTipNum()
		if (isRebate == 0) then
			ShowNotice.showShellInfo(string.format(gi18n[4340],tonumber(oneData))) --"成功领取%d点耐力，今日已赠送过该玩家耐力"
		else
			require "script/module/friends/MainFdsCtrl"
			MainFdsCtrl.updateGiveStatus(curUid)
			ShowNotice.showShellInfo(string.format(gi18n[4341],tonumber(oneData),tonumber(oneData))) --"成功领取%d点耐力，并回赠%d点耐力"
		end

	end
end

fnEventCallBack.onBtnGetLove = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 判断领取列表是否为空
		local listData = staminaFdsData.getStaminaList()
		if( table.count(listData) == 0)then
			ShowNotice.showShellInfo(gi18n[4337]) --"没有耐力可以领取！"
			AudioHelper.playCommonEffect()
			return
		end
		-- 判断是否还有剩余次数
		local times = staminaFdsData.getTodayReceiveTimes()
		if( times <= 0)then
			AudioHelper.playCommonEffect()
			ShowNotice.showShellInfo(gi18n[4338]) --"今日已达领取耐力次数上限，无法领取！"
			return
		end
		-- -- 耐力已达上限
		-- if( UserModel.getStaminaNumber() >= UserModel.getMaxStaminaNumber() )then
		-- 	ShowNotice.showShellInfo(gi18n[4339])--"耐力已满，无法领取!"
		-- 	return
		-- end
		AudioHelper.playBtnEffect("shiyong_yaoshui.mp3")
		local status = g_fnGetWidgetByName(sender:getParent(),"TFD_STATUS")
		staminaFdsData.setUid(sender:getTag())
		staminaFdsData.setTime(status:getTag())
		staminaFdsData.getLoveReq(getLoveCallBack)
    end  
end

function setTipWidget( imgTips )
	imgTip = imgTips
	updateTipNum()
end

function updateTipNum( ... )
	if (staminaFdsCtrl.getStaminaNum() > 0 and getTodayReceiveTimes()>0) then
		imgTip:setVisible(true)
		local tfdTipNum = g_fnGetWidgetByName(imgTip,"LABN_TIP_NUM")
		tfdTipNum:setStringValue(getStaminaNum())
	else
		imgTip:setVisible(false)
	end
end

function getStaminaNum( ... )
	local num = 0
	local tbStaminaData = staminaFdsData.getStaminaList() or {}
	for k,v in pairs(tbStaminaData) do
		local tbFdsData = staminaFdsData.getThisFriendDataByUid(v.uid)

		if (tbFdsData ~= nil and tbFdsData.uname ~=nil) then
			num = num + 1
		end
	end

	return num
end

function getTodayReceiveTimes()
	local times = staminaFdsData.getTodayReceiveTimes()
	return times and times or 0
end
--外部更新耐力列表
function upStaminaList( dataRet )
	staminaFdsData.setStaminaData(dataRet)
	require "script/module/friends/MainFdsCtrl"
	if (LayerManager.curModuleName() == MainFdsCtrl.moduleName()) then -- zhangqi, 2014-07-07, 避免UI不存在时刷新报错
		staminaFdsView.updateListView()
		MainFdsView.updateStaminaTip()
	end
	--liweidong 更新首页体力红点
	if (LayerManager.curModuleName() == "MainShip") then-- zhangqi, 2014-12-30, 判断如果当前模块是主船才刷新好友红点
		-- require "script/module/main/MainShip"
		-- MainShip.updateFriendRedPoint()
		require "script/module/main/SecondMenuView"
		SecondMenuView.updateFriendRedPoint()
		
		require "script/module/main/MainShip"
		MainShip.updateSecMenuBtnTip()
	end
end

function create(...)

	layoutMain = Layout:create()
	layoutMain:addChild(staminaFdsView.create(fnEventCallBack))

	return layoutMain
end

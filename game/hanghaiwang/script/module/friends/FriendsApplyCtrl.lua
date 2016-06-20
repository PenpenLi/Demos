-- FileName: FriendsApplyCtrl.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 好友申请 控制
--[[TODO List]]

module("FriendsApplyCtrl", package.seeall)

require "script/module/friends/FriendsApplyView"
require "script/module/friends/FriendsApplyModel"
-- UI控件引用变量 --

-- 模块局部变量 --
local tbArgs = {}
local layoutMain = nil
local m_imgTip = nil
local m_i18n = gi18n

local function init(...)
	m_imgTip = nil
end

function destroy(...)
	package.loaded["FriendsApplyCtrl"] = nil
end

function moduleName()
    return "FriendsApplyCtrl"
end

-- 当前无好友，添加
tbArgs.onBtnAddFds = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		MainFdsView.onSelectFocus(2)
	end
end

-- 添加好友
tbArgs.onAddFriend = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 

		local function requestFunc( cbFlag, dictData, bRet )
			logger:debug(dictData)
			if(bRet == true)then
				if(dictData.ret == "ok")then
					ShowNotice.showShellInfo( m_i18n[4374]) -- "成功添加对方为好友"
					FriendsApplyModel.removeDataByIndex(sender:getTag() )
				    FriendsApplyView.updateList()
					updateTipNum()

					--添加好友后重新获取好友数据
					require "script/network/PreRequest"
					PreRequest.getFriendsList()
				end
				if(dictData.ret == "isfriend")then
					local str = gi18n[3664] --"对方已经是您的好友了！"
					ShowNotice.showShellInfo(str)
					FriendsApplyModel.removeDataByIndex(sender:getTag() )
				    FriendsApplyView.updateList()
				    updateTipNum()
					return
				end
				if(dictData.ret == "applicant_reach_maxnum")then
					local str = gi18n[3665] --"对方的好友数量已达上限！"
					ShowNotice.showShellInfo(str)
					return
				end
				if(dictData.ret == "accepter_reach_maxnum")then
					local str = gi18n[3666] -- "您的好友已数量达上限！"
					ShowNotice.showShellInfo(str)
					return
				end
			end
		end
		logger:debug("添加")

		-- 联网
		local uid = sender:getTag()
		local args = CCArray:create()
		args:addObject(CCInteger:create(uid))
	    args:addObject(CCString:create(""))
	    RequestCenter.friend_addFriend(requestFunc, args)
	end
end
-- 拒绝
tbArgs.onRefuse = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		logger:debug("onRefuse")

		local function requestFunc(cbFlag, dictData, bRet  )
			if(bRet == true)then
				local dataRet = dictData.ret
				if(dataRet == "ok")then
					local str = m_i18n[4375]     --"拒绝成功"
					ShowNotice.showShellInfo(str)
					FriendsApplyModel.removeDataByIndex(sender:getTag()) 
					FriendsApplyView.updateList()   
					updateTipNum()   --更新页签上的数字
				end
				if(dataRet == "isfriend")then
					local str =gi18n[3664]     --  "对方已经是您的好友了！"
					ShowNotice.showShellInfo(str)
					FriendsApplyModel.removeDataByIndex(sender:getTag() )
				    FriendsApplyView.updateList()
				    updateTipNum()   --更新页签上的数字
				end
			end
		end 

		local uid = sender:getTag()  --改cell的uid
		local args = CCArray:create()
		args:addObject(CCInteger:create(uid))
		RequestCenter.friend_rejectFriend(requestFunc, args)

	end
end


function setTipWidget( widget )
	 m_imgTip = widget
	 updateTipNum()
end 

-- 页签上的数字
function updateTipNum( )
	if (FriendsApplyModel.getApplyNum()>0) then
		m_imgTip:setVisible(true)
		local tfdTipNum = g_fnGetWidgetByName(m_imgTip,"LABN_TIP_NUM_APPLY")
		tfdTipNum:setStringValue(FriendsApplyModel.getApplyNum())
	else
		m_imgTip:setVisible(false)
	end
end


--好友申请数据 推送
function updateFdsApplyList( dataRet )
	FriendsApplyModel.setFdsApplyData(dataRet)
	-- 更新主界面 好友按钮红点数字
	if (LayerManager.curModuleName() == "MainShip") then
		-- require "script/module/main/MainShip"
		-- MainShip.updateFriendRedPoint()
		require "script/module/main/SecondMenuView"
		SecondMenuView.updateFriendRedPoint()
		require "script/module/main/MainShip"
		MainShip.updateSecMenuBtnTip()
	end

	require "script/module/friends/MainFdsCtrl"
	if(LayerManager.curModuleName()==MainFdsCtrl.moduleName())then
		if(MainFdsView.getCurrentIndex()==4)then 
			FriendsApplyView.updateList()
		end 
		updateTipNum()
	end 	
end


function create(...)
	layoutMain = Layout:create()
	layoutMain:addChild(FriendsApplyView.create(tbArgs))

	return layoutMain
end




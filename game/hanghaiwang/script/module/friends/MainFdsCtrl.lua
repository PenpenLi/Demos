-- FileName: MainFdsCtrl.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 好友列表控制器
--[[TODO List]]

module("MainFdsCtrl", package.seeall)

require "script/module/friends/MainFdsView"
require "script/module/public/ShowNotice"

-- UI控件引用变量 --
local fnEventCallBack = {}
local layoutMain
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	if (staminaFdsCtrl) then
		staminaFdsCtrl.destroy()
	end
	if (MainFdsView) then
		MainFdsView.destroy()
	end
	package.loaded["MainFdsCtrl"] = nil
end

function moduleName()
    return "MainFdsCtrl"
end


---------------我的好友界面-----------------
fnEventCallBack.onBtnClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBackEffect()	--返回音效
		require "script/module/main/MainScene"
 		MainScene.homeCallback()
    end  
end

fnEventCallBack.onBtnFocus = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		MainFdsView.onSelectFocus(sender:getTag())
		AudioHelper.playTabEffect()		--切换页签音效
    end  
end

fnEventCallBack.onBtnAddFds = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		MainFdsView.onSelectFocus(2)
    end  
end
 
-- 切磋按钮事件 huxiaozhou 2015-08-31
fnEventCallBack.onBtnPVP = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("nEventCallBack.onBtnPVP")
		require "script/module/public/PVP"
		PVP.doPVP(MainFdsData.getMsgUid())
	end
end


---------------好友列表相关事件---------------

-- 赠送好友耐力 callbackFunc: 回调
local function giveStaminaBack( cbFlag, dictData, bRet)
	if(bRet) then
		local num = MainFdsData.getGiveStaminaNum()
		-- 把当前时间设置为上次赠送时间
		MainFdsData.setGiveTimeByUid()
		MainFdsView.updateListCell(MainFdsData.objAtIndexCell())
		ShowNotice.showShellInfo(string.format(gi18n[4323],tonumber(num))) --成功赠送%d点耐力！
	end
end

-- 赠送好友耐力
fnEventCallBack.onBtnGive = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() --公共按钮音效
		MainFdsData.setMsgUid(sender:getTag())
		MainFdsData.loveFriends(giveStaminaBack)
    end  
end

fnEventCallBack.onBtnCommu = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()		--点击后会弹出详细信息时播放的音效
		print("sendertags"..sender:getTag())
		MainFdsData.setMsgUid(sender:getTag())
		MainFdsView.fnRecomdLayer(sender.figure)
    end  
end

-- 我的好友页面，更多好友
fnEventCallBack.onBtnMore = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local curPreData = MainFdsData.getPageFdsData()
		MainFdsData.cuPageNum = MainFdsData.cuPageNum + 1
		MainFdsView.insertMoreListCell(curPreData)
    end  
end


--外部加载好友信息并更新列表 
function updateFdsList( dataRet )
	MainFdsData.setFriendsList(dataRet)
	if (LayerManager.curModuleName() == moduleName()) then
		MainFdsView.updateListView()
	end
end

--外部删除好友后加载好友信息并更新列表
function delupFdsList( dataRet )
	if(MainFdsData.getFriendsList() ~= nil)then
		require "script/module/friends/staminaFdsView"
		MainFdsData.delSomeFds( dataRet )
		if (LayerManager.curModuleName() == moduleName()) then
			MainFdsView.updateListView()
			staminaFdsView.updateListView()
		end
	end
end

--上线好友更新 已经删除推送 2015.12.21
function upFdsOnline( dataRet )
	if(MainFdsData.getFriendsList() ~= nil)then
		-- 返回上线好友的uid
		MainFdsData.setFriendOnline( dataRet )
		if (LayerManager.curModuleName() == moduleName()) then
			MainFdsView.updateListView()
		end
	end
end

--下线好友更新  已经删除推送 2015.12.21
function upFdsOffline( dataRet )
	if(MainFdsData.getFriendsList() ~= nil)then
		-- 返回上线好友的uid
		MainFdsData.setFriendOffline( dataRet )
		if (LayerManager.curModuleName() == moduleName()) then
			MainFdsView.updateListView()
		end
	end
end

fnEventCallBack.updateFdsData = function ()
	require "script/network/PreRequest"
	PreRequest.getFriendsList()
end

---------------好友交流相关事件---------------
fnEventCallBack.onBtnCommt = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		LayerManager.removeLayout()
    end  
end

fnEventCallBack.onBtnMsg = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playInfoEffect()
		MainFdsView.fnMsgLayer()
    end  
end

fnEventCallBack.onBtnFor = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		print("friendsId"..MainFdsData.getMsgUid())
		AudioHelper.playInfoEffect()
		require "script/module/formation/FormationCtrl"
		FormationCtrl.loadFormationWithUid(MainFdsData.getMsgUid())
    end 
end

local function removeFdsCallBack( cbFlag, dictData, bRet  )
	if(bRet == true)then
		MainFdsData.updateMineFds() --删除当前好友
		MainFdsView.updateAllListCell()
		MainFdsView.updateFdsNum()
		MainFdsView.updateStaminaTip()
		ShowNotice.showShellInfo(gi18n[4324])--"成功删除好友"
	end
end

local function fnRemoveFds( ... )
	MainFdsData.removeFdsReq(removeFdsCallBack)
	LayerManager.removeLayout()
	LayerManager.removeLayout()
end

--删除好友
fnEventCallBack.onBtnRemove = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		if (MainFdsData.getMsgName()) then
			AudioHelper.playInfoEffect()
	        require "script/module/public/UIHelper"
	        local strMsg = string.format(gi18n[4325],MainFdsData.getMsgName()) --"确定删除好友＂%s＂吗?"
	        local layDlg = UIHelper.createCommonDlg(strMsg, nil, fnRemoveFds)
	        LayerManager.addLayout(layDlg)
	    else
	    	ShowNotice.showShellInfo(gi18n[4326]) --"该好友已不存在"
    	end
    end 
end
-------------留言相关事件--------------------
local function applyFdsCallBack( cbFlag, dictData, bRet  )
	if(bRet == true)then
		ShowNotice.showShellInfo(gi18n[4327]) --"留言成功"
	end
end

fnEventCallBack.onBtnSend = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect() 
		if (MainFdsView.msg_input:getText() ~= "") then
			MainFdsData.setMsgText(MainFdsView.msg_input:getText())
			MainFdsData.sendMsgReq(applyFdsCallBack)
			LayerManager.removeLayout()
		else
			ShowNotice.showShellInfo(gi18n[4328]) --"留言不能为空"
		end
    end  
end

-------------耐力调用事件--------------------
function updateGiveStatus( uid )
	MainFdsData.setGiveTimeBystma(uid)
end


-- 0点刷新数据
function refreashView( ... )
	local function callBack(cbFlag, dictData, bRet )
		if(not bRet)then 
			return 
		end 
		require "script/module/friends/MainFdsCtrl"
		MainFdsCtrl.updateFdsList(dictData.ret)
	end

	require "script/network/RequestCenter"
	RequestCenter.friend_getFriendInfoList(callBack,nil)
end


function create(...)
	
	layoutMain = Layout:create()
	MainFdsView.destroy()
	layoutMain:addChild(MainFdsView.create(fnEventCallBack))
	
	staminaFdsCtrl.destroy()
	MainFdsView.updateStaminaTip()
	MainFdsView.updateApplyTip()

	MainFdsView.onSelectFocus(1)
	
	--策划需求，再次请求耐力数据
	require "script/network/PreRequest"
    PreRequest.getReceiveStaminaInfo()

	return layoutMain
end
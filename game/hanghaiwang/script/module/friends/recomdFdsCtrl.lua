-- FileName: recomdFdsCtrl.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 推荐好友控制器
--[[TODO List]]

module("recomdFdsCtrl", package.seeall)

require "script/module/friends/recomdFdsView"
require "script/module/public/ShowNotice"
local m_i18n = gi18n
-- UI控件引用变量 --
local fnEventCallBack = {}

-- 模块局部变量 --
local layoutMain

local function init(...)

end

function destroy(...)
	package.loaded["recomdFdsCtrl"] = nil
end

function moduleName()
    return "recomdFdsCtrl"
end

-----------------邀请好友---------------
fnEventCallBack.onBtnInvite = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		recomdFdsData.setApplyUid(sender:getTag())
		recomdFdsData.setApplyText(m_i18n[2901])
			-- 邀请好友联网
		local  cellIdx = sender.idx
		local function applyFdsCallBack( cbFlag, dictData, bRet  )
			if(dictData.ret == "applied") then
				ShowNotice.showShellInfo(gi18n[4331])--"您已向此玩家提出了好友申请，请耐心等待"
				recomdFdsData.deleteDataById(cellIdx)
				if(recomdFdsData.getCurPageDataCount()==0)then 
					moreData()
				else 
					recomdFdsView.updateListView(true)  --更新好友列表
				end 
			elseif(dictData.ret == "reach_maxnum") then
				ShowNotice.showShellInfo(gi18n[4332])--"好友已达上限"
			elseif(dictData.ret == "alreadyfriend") then
				ShowNotice.showShellInfo(gi18n[4333])--"已经添加该玩家为好友"
				recomdFdsData.deleteDataById(cellIdx)
				if(recomdFdsData.getCurPageDataCount()==0)then 
					moreData()
				else 
					recomdFdsView.updateListView(true)  --更新好友列表
				end 
			else
				ShowNotice.showShellInfo(gi18n[4334])--"邀请成功"
				recomdFdsData.deleteDataById(cellIdx)
				if(recomdFdsData.getCurPageDataCount()==0)then 
					moreData()
				else 
					recomdFdsView.updateListView(true)  --更新好友列表
				end 
			end
		end

		if(recomdFdsData.applyFriendsReq(applyFdsCallBack)) then
			ShowNotice.showShellInfo(gi18n[4336])--"不能邀请自己为好友"
		else
			AudioHelper.playCommonEffect()
		end

    end  
end

fnEventCallBack.onBtnMore = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		moreData()
    end  
end


function moreData( ... )
	recomdFdsData.cuPageNum = recomdFdsData.cuPageNum + 1
	if(recomdFdsData.cuPageNum > recomdFdsData.getFdsPage() )then 
		recomdFdsData.cuPageNum = 1
	end 
	recomdFdsView.updateListView()
end


-----------------模糊搜索------------------
function searchFdsCallBack( cbFlag, dictData, bRet  )
	print("dictData")
	print_t(dictData)
	if(bRet == true)then
		recomdFdsData.setSearchListData(dictData.ret)
		if(table.count(dictData.ret) == 0)then
			ShowNotice.showShellInfo(gi18n[4329])--"您搜索的玩家不存在!"
			-- 显示推荐好友
			if( recomdFdsData.getRecmdFdsList() ~= nil)then
				recomdFdsData.setRecomdListData()
			end
		end
		recomdFdsView.updateListView()
	end
end

fnEventCallBack.onBtnSearch = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		if (recomdFdsView.name_input:getText() ~= "") then
			recomdFdsData.cuPageNum = 1
			recomdFdsData.setFdsName(recomdFdsView.name_input:getText())
			recomdFdsData.getRecomdFriendsReq(searchFdsCallBack)
		else
			ShowNotice.showShellInfo(gi18n[4330])--"请输入搜索的好友名称"
		end
    end  
end



function create(...)
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			recomdFdsData.setRecmdFdsList(dictData.ret)
			layoutMain:addChild(recomdFdsView.create(fnEventCallBack))
		end
	end

	layoutMain = Layout:create()
	recomdFdsData.create(requestFunc)
	
	return layoutMain
end

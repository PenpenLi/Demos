-- FileName: recomdFdsData.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 推荐好友数据model
--[[TODO List]]

module("recomdFdsData", package.seeall)

require "script/network/RequestCenter"

-- UI控件引用变量 --

-- 模块局部变量 --
cuPageNum = 1 --当前页数
local prePageDataCout = 10 --每页的数据量

local curApplyId --当前申请的好友id
local curMsgText --申请内容
local curFdsName --好友名称
local tbRecmdFdsData --推荐好友
local tbPageFdsData --好友分页数据

local tbListData --显示的临时列表数据
local function init(...)

end

function destroy(...)
	package.loaded["recomdFdsData"] = nil
end

function moduleName()
    return "recomdFdsData"
end

function create(callback)
	RequestCenter.friend_getRecomdFriends(callback,nil)
end

function setRecmdFdsList( tbData )
	cuPageNum = 1
	tbRecmdFdsData = tbData
	setRecomdListData()
end

function getRecmdFdsList( ... )
	return tbRecmdFdsData
end

function getFdsPage( ... )
	return math.ceil(#tbListData / prePageDataCout)
end

function setRecomdListData( ... )
	tbListData = tbRecmdFdsData
end

function setSearchListData( tbData )
	tbListData = tbData
end

function getPageFdsData( onCallBack )
	tbPageFdsData = {}
	local i = 1
	for k,v in pairs(tbListData) do
		if (v ~= nil) then
			if (cuPageNum * prePageDataCout >= i and (cuPageNum-1) * prePageDataCout < i) then
				v.eventBack = onCallBack
				v.idx = i
				table.insert(tbPageFdsData,v)
			end
			i = i + 1 
		end
	end

	--去掉more的板子
	-- if (cuPageNum < getFdsPage() and #tbPageFdsData > 0) then
	-- 	table.insert(tbPageFdsData,{more = true,eventBack = onCallBack})
	-- end

	logger:debug(tbPageFdsData)
	return tbPageFdsData
end
-- 按照id删除数据
function deleteDataById( id )
	if(not tbPageFdsData)then 
		return 
	end 
	for k,v in pairs(tbPageFdsData) do 
		if(v.idx==id)then 
			table.remove(tbPageFdsData,k)
		end 
	end 
end


function getCurPageDataCount( ... )
	return #tbPageFdsData
end

function getPageData( ... )
	return tbPageFdsData
end


function setApplyUid( fuid )
	curApplyId = fuid
	print("curApplyId"..curApplyId)
end

function setApplyText( content )
	curMsgText = content
end

function setFdsName( name )
	curFdsName = name
end

function updateRecomdFds( ... )
	local recmdFds = {}
	recmdFds = table.hcopy(tbRecmdFdsData,recmdFds)
	for k,v in pairs(recmdFds) do
		if (tonumber(v.uid) == curApplyId) then
			tbRecmdFdsData[k] = nil
		end
	end
	
	curApplyId = nil
end

---------数据请求
function applyFriendsReq( callback )
	require "script/model/user/UserModel"
	if(curApplyId == UserModel.getUserUid()) then
		return true
	end
	local args = Network.argsHandler(curApplyId, curMsgText)
	RequestCenter.friend_applyFriend(callback,args)
end

function getRecomdFriendsReq( callback )
	local args = Network.argsHandler(curFdsName)
	RequestCenter.friend_getRecomdByName(callback,args)
end


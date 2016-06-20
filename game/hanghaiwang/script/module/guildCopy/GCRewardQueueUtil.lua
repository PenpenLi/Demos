-- FileName: GCRewardQueueUtil.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: 
--[[TODO List]]

module("GCRewardQueueUtil", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["GCRewardQueueUtil"] = nil
end

function moduleName()
    return "GCRewardQueueUtil"
end

function create(...)

end



-- 队伍人数
function count( tbqueue )
	return table.count(tbqueue) 
end

-- 加入奖励队列,参数为nil时，操作玩家自己
function addUser( tbqueue,uid )
	local cell = {}
	cell.uid = uid or UserModel.getUserUid() 
	cell.uname = UserModel.getUserName() 
	cell.level = UserModel.getHeroLevel() 
	cell.figure = UserModel.getAvatarHtid()
	table.insert(tbqueue,cell)
end

-- 插队,参数为nil时，操作玩家自己
function insertAtFirst( tbqueue, uid )
	uid = uid or UserModel.getUserUid()
	for i=1,#tbqueue do 
		if (tbqueue[i].uid == uid) then 
			table.remove(tbqueue,i)
			break
		end 
	end 

	local cell = {}
	cell.uid = uid 
	cell.uname = UserModel.getUserName() 
	cell.level = UserModel.getHeroLevel() 
	cell.figure = UserModel.getAvatarHtid()
	table.insert(tbqueue,1,cell)
end

-- 放弃排队,参数为nil时，操作玩家自己
function removeUser( tbqueue,uid )
	uid = uid or UserModel.getUserUid()
	tbqueue = tbqueue or {}
	for i=1,#tbqueue do 
		if (tonumber(tbqueue[i].uid) == tonumber(uid)) then 
			table.remove(tbqueue,i)
			break
		end 
	end 
end

-- 玩家是否在当前队列中,参数uid为nil时，操作玩家自己
function isUserInQueue( tbqueue,uid )
	uid = uid or UserModel.getUserUid()
	tbqueue = tbqueue or {}
	local ret = false
	for k,v in pairs(tbqueue) do 
		if (tonumber(v.uid) == tonumber(uid)) then 
			ret = true
			break
		end 
	end 
	return ret
end

-- 获取指定排名的uid
function getUidByIndex( tbqueue, index )
	if (not tbqueue) then 
		return nil 
	end 

	return tbqueue[index].uid
end


-- 获取玩家在队列中的排名,参数为nil时，操作玩家自己
function getIndex(tbqueue, uid )
	uid = uid or UserModel.getUserUid()
	tbqueue = tbqueue or {}
	local index = 0
	for k,v in pairs(tbqueue) do 
		if (tonumber(v.uid) == tonumber(uid)) then 
			index = k
			break
		end 
	end 

	return tonumber(index)
end



-- FileName: FriendsApplyModel.lua
-- Author: yangna
-- Date: 2015-03-00
-- Purpose: 好友申请数据
--[[TODO List]]

module("FriendsApplyModel", package.seeall)


-- UI控件引用变量 --

-- 模块局部变量 --
local m_fdsApplyData = {}


local function init(...)

end

function destroy(...)
	package.loaded["FriendsApplyModel"] = nil
end

function moduleName()
    return "FriendsApplyModel"
end

function create(...)

end

function getApplyList( onInvite,onRefuse )
	local tbData = {}
	for k,v in pairs(m_fdsApplyData) do 
		if(v)then 
			v.onInvite = onInvite
			v.onRefuse = onRefuse
			table.insert(tbData,v)
		end 
	end 
	return tbData
end

-- 邮件template_id字段区分类型
-- const FRIEND_APPLY	=10;
-- const FRIEND_REJECT	=12;
-- const FRIEND_ADD		=11;
-- const FRIEND_DEL		=13;
-- const FRIEND_MSG		=14;
function setFdsApplyData( data )
	m_fdsApplyData = {}
	for k,v in pairs(data) do 
		if(type(v)=="table" and tonumber(v.template_id)==10 )then 
			local cell = {}
			cell.level = v.sender_level
			cell.uid = v.sender_uid
			cell.utid = v.sender_utid
			cell.uname = v.sender_uname
			cell.figure = v.sender_figure
			cell.fight_force = v.sender_fightforce
			cell.recv_time = v.recv_time
			table.insert(m_fdsApplyData,cell)
		end 
	end 
	logger:debug(m_fdsApplyData)
end

function getApplyNum( ... )
	return table.count(m_fdsApplyData)
end


function removeDataByIndex( id )
	for k,v in pairs(m_fdsApplyData) do 
		if(tonumber(v.uid) ==id)then 
			table.remove(m_fdsApplyData,k)
		end 
	end 
end

-- 根据figure获取玩家头像，返回CCNode
-- scale 头像缩放系数
function getHeaderPic( figure,scale)
	require "db/DB_Heroes"
	require "script/model/utils/HeroUtil"
	local iconPath = HeroUtil.getHeroIconImgByHTID(figure)
	logger:debug("图片路径")
	logger:debug(iconPath)
	local sp = CCSprite:create(iconPath)
	-- scale = scale or 1.0
	-- sp:setScale(scale)
	return sp
end







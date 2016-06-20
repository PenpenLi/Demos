-- FileName: GuideModel.lua
-- Author: huxiaozhou
-- Date: 2014-06-06
-- Purpose: function description of module
--[[TODO List]]
-- 新手引导数据模块

module("GuideModel", package.seeall)
require "script/GlobalVars"
-- 模块全局变量 －－


-- 模块局部变量
local guideClass = nil -- 引导类型
--local m_tbGuideConfig = {} 修改为本地存储后 注释掉

-- 设置引导类型
-- _guideClass 参见 GlobalVars 中引导类型的定义
function setGuideClass( _guideClass )
	guideClass = _guideClass or ksGuideClose
end

-- 获取当前引导类型
-- 如果当前类型是nil  则返回 定义的ksGuideClose
function getGuideClass(  )
	if (not guideClass) then
		return ksGuideClose
	else 
		return guideClass 
	end
end

-- 因为现在屏蔽掉新手引导 需要设置所有引导状态 为false
function setGuideState(bGuide )
	-- BTUtil:setGuideState(false)
	BTUtil:setGuideState(bGuide)
end

-- 得到当前用户身份信息
-- 此处的UID 是服务器id 和 userid的结合体
function getUniqueGroupUid(  )
	--得到用户信息
	require "script/model/user/UserModel"
	local userInfo = UserModel.getUserInfo()
	local userUid  = userInfo.uid

	require "script/module/login/NewLoginCtrl"
	local nowServerInfo = NewLoginCtrl.getSelectServerInfo()
	logger:debug(nowServerInfo)
	local nowGroupId 	= ""
	if(nowServerInfo == nil) then
		nowGroupId = "001"
	else
		nowGroupId = nowServerInfo.group
	end
	logger:debug("" ..CCUserDefault:getXMLFilePath())
	logger:debug("nowGroupId .. userUid = " .. nowGroupId .. userUid)
	return nowGroupId .. userUid
end

-- skey 引导名字
-- sValue 引导步数
function setPersistenceGuideData(sKey,sValue)
	assert(sKey,"sKey must not nil")
	assert(sValue,"sValue must not nil")
	CCUserDefault:sharedUserDefault():setStringForKey(getUniqueGroupUid(), sKey .. sValue)
	CCUserDefault:sharedUserDefault():flush()
end

-- 获取当前的引导状态 
function getPersistenceGuideData( )
	return CCUserDefault:sharedUserDefault():getStringForKey(getUniqueGroupUid())
end


--[==[
-- 设置引导 本地 缓存数据
function setGuideConfig( _tbGuideData)
	m_tbGuideConfig = _tbGuideData
end

-- 获取引导 缓存数据
function getGuideConfig(  )
	return m_tbGuideConfig
end

--]==]




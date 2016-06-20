-- FileName: MainMessageCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-09-22
-- Purpose: 留言板控制器
--[[TODO List]]

module("MainMessageCtrl", package.seeall)
require "script/module/guild/message/MainMessageView"
-- UI控件引用变量 --
local m_i18nString = gi18nString

-- 模块局部变量 --
local tbEvents = {}

local function init(...)
end

function destroy(...)
	package.loaded["MainMessageCtrl"] = nil
end

function moduleName()
	return "MainMessageCtrl"
end


local function getStringLength(str)
	local strLen = 0
	local i =1
	while i<= #str do
		if(string.byte(str,i) > 127) then
			-- 汉字
			strLen = strLen + 1
			i= i+ 3
		else
			i =i+1
			strLen = strLen + 1
		end
	end
	return strLen
end
--后端回调
local function senCallBack(cbFlag,dictData,bRet)
	if (bRet) then
		-- 联盟动态请求回调
		local function getMessageListCallback(  cbFlag, dictData, bRet  )
			if(bRet)then
				if(not table.isEmpty(dictData.ret))then
					-- -- 创建军团列表
					MainMessageView.refreshList(dictData.ret)
				end
			end
		end
		-- 列表数据
		local args = CCArray:create()
		args:addObject(CCInteger:create(0))
		args:addObject(CCInteger:create(100))
		RequestCenter.guild_getMessageList(getMessageListCallback,args)

	end
end


function create(...)
	logger:debug("MainMessageCtrl create")
	tbEvents = {}

	-- 返回按钮事件
	tbEvents.fnClose = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playBackEffect()

			-- LayerManager.removeLayout()
			AudioHelper.playBackEffect()
			MainGuildCtrl.getGuildInfo(true)
		end
	end

	-- 留言按钮事件
	tbEvents.fnMessage = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnMessage")
			AudioHelper.playCommonEffect()

			local messageContent = MainMessageView:getMessage()
			local leaveTimes = MainMessageView.getLeaveMessageTimes()
			--判断条件

			local messageLength = getStringLength(messageContent)
			if (messageLength <= 0) then
				local str = m_i18nString(3661) --	[3661] = "请先输入内容后再发布哦~",
				ShowNotice.showShellInfo(str)
			elseif (messageLength > 60) then
				local str = m_i18nString(3670) --"留言数字要小于80字~
				ShowNotice.showShellInfo(str)
			elseif (leaveTimes <= 0) then   --留言次数
				local str = m_i18nString(3669) --"今日留言次数已用完~
				ShowNotice.showShellInfo(str)
			else
				local args = CCArray:create()
				args:addObject(CCString:create(messageContent))
				RequestCenter.guild_leaveMessage(senCallBack,args)
			end

		end
	end

	-- 列表数据
	local args = CCArray:create()
	args:addObject(CCInteger:create(0))
	args:addObject(CCInteger:create(100))
	RequestCenter.guild_getMessageList(getMessageListCallback,args)
end

-- 联盟留言板请求回调
function getMessageListCallback(  cbFlag, dictData, bRet  )
	if(bRet)then
		if(not table.isEmpty(dictData.ret))then
			-- -- 创建军团列表
			local messageView = MainMessageView.create(tbEvents ,dictData.ret)
			messageView:addChild(GuildMenuCtrl.create())
			-- LayerManager.addLayoutNoScale(messageView)
			LayerManager.changeModule(messageView, MainMessageCtrl.moduleName(), {1}, true)

			

		end
	end
end


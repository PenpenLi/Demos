
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ26ÈÕ 18:01:06
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- FinishChildLadyBugTaskLogic
---------------------------------------------------

assert(not FinishChildLadyBugTaskLogic)
FinishChildLadyBugTaskLogic = class()

function FinishChildLadyBugTaskLogic:init(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)

	self.taskId = taskId
end

function FinishChildLadyBugTaskLogic:start(successCallback, failCallback, ...)
	assert(false == successCallback or type(successCallback) == "function")
	assert(#{...} == 0)

	local function onSuccess()
		local ladyBugInfo = UserManager:getInstance():ladyBugInfos_getLadyBugInfoById(self.taskId)
		assert(ladyBugInfo)
		if ladyBugInfo.canReward == false then
			ladyBugInfo.canReward = true
		end

		
		if successCallback then
			successCallback()
		end
	end

	local function onFail()
		if failCallback then
			failCallback()
		end
	end

	self:sendFinishChildLadyBugMsg(onSuccess, onFail)
end

function  FinishChildLadyBugTaskLogic:sendFinishChildLadyBugMsg(sendMsgSuccessCallback, sendMsgFailCallback, ...)
	assert(type(sendMsgSuccessCallback) == "function")
	assert(#{...} == 0)

	local function onSuccess()
		if sendMsgSuccessCallback then
			sendMsgSuccessCallback()
		end
	end

	local function onFailed(err)
		assert(err)
		assert(err.data)

		local assertFalseMsg = "send finish child lady bug msg Failed ! \n"
		assertFalseMsg = assertFalseMsg .. "error code: " .. err.data
		--assert(false, assertFalseMsg)
		if sendMsgFailCallback then
			sendMsgFailCallback()
		end
	end

	local http = FinishChildLadyBugTask.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:load(self.taskId)
end

function FinishChildLadyBugTaskLogic:create(taskId, ...)
	assert(type(taskId) == "number")
	assert(#{...} == 0)

	local newFinishChildLadyBugTaskLogic = FinishChildLadyBugTaskLogic.new()
	newFinishChildLadyBugTaskLogic:init(taskId)
	return newFinishChildLadyBugTaskLogic
end


-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年12月 5日 16:19:20
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- UsePropsLogic
---------------------------------------------------

assert(not UsePropsLogic)
UsePropsLogic = class()

function UsePropsLogic:init(isTempProperty, levelId, param, itemList, ...)
	assert(type(isTempProperty) == "boolean")
	assert(type(levelId) == "number")
	assert(param)
	assert(type(itemList) == "table")
	assert(#{...} == 0)

	self.itemType = false

	if isTempProperty then
		self.itemType = 1
	else
		-- Not Temp
		self.itemType = 2
	end

	self.levelId	= levelId
	self.param		= param or 0
	self.itemList	= itemList

	self.successCallback = false
end

function UsePropsLogic:setSuccessCallback(callbackFunc, ...)
	assert(type(callbackFunc) == "function")
	assert(#{...} == 0)

	self.successCallback = callbackFunc
end

function UsePropsLogic:start(popWaitTip, ...)
	--assert(type(popWaitTip) == "boolean")
	assert(#{...} == 0)

	local function onSendMsgSuccessCallback()

		if self.itemType == 2 then
			-- Decrease Prop Item Number
			for k,item in pairs(self.itemList) do
				print("decrease item:" .. item .. " 's number !")
				UserManager:getInstance():addUserPropNumber(item, -1)
			end
		end

		-- Callback
		if self.successCallback then
			self.successCallback()
		end
	end


	local function onSendMsgFailed(evt)
		if self.failedCallback then
			self.failedCallback(evt)
		end
	end

	self:sendUsePropsHttp(popWaitTip, onSendMsgSuccessCallback, onSendMsgFailed)
end

function UsePropsLogic:setFailedCallback(callback, ...)
	assert(type(callback) == "function")
	assert(#{...} == 0)

	self.failedCallback = callback
end

function UsePropsLogic:sendUsePropsHttp(popWaitTip, sendMsgSuccessCallback, sendMsgFailedCallback, ...)
	--assert(type(popWaitTip) == "boolean")
	assert(false == sendMsgSuccessCallback or type(sendMsgSuccessCallback) == "function")
	assert(false == sendMsgFailedCallback or type(sendMsgFailedCallback) == "function")
	assert(#{...} == 0)

	--  <request>
	--	  <property code="type" type="int" desc="1:临时道具,2:背包道具" />
	--	  <property code="levelId" type="int" desc="当前关卡" />
	--	  <property code="param" type="int" desc="param" />
	--	  <list code="itemList" ref="int" desc="使用道具" />
	--  </request>
	--function UsePropsHttp:load(itemType, levelId, gameMode, param, itemList)

	local function onSuccess(evt)
		if sendMsgSuccessCallback then
			sendMsgSuccessCallback(evt)
		end
	end

	local function onFailed(evt)
		--if self.failedCallback then
		--	self.failedCallback()
		--end

		if sendMsgFailedCallback then
			sendMsgFailedCallback(evt)
		end
	end

	local http = UsePropsHttp.new(popWaitTip)
	http:addEventListener(Events.kComplete, onSuccess)
	---- For Test purpose
	--http:addEventListener(Events.kComplete, onFailed)
	http:addEventListener(Events.kError, onFailed)

	---- itemType
	--local propType = false
	--if isTempProperty then
	--	print("use tempProperty !!")
	--	propType = 1
	--else
	--	print("use non temProperty !")
	--	propType = 2
	--end

	local propType = self.itemType

	-- levelId
	local levelId = self.levelId

	-- param
	local param = self.param

	-- itemList
	local itemList = self.itemList

	http:load(propType, levelId, param, itemList)
end

function UsePropsLogic:create(isTempProp, levelId, param, itemList, ...)
	assert(type(isTempProp) == "boolean")
	assert(levelId)
	assert(param)
	assert(itemList)
	assert(#{...} == 0)

	local newUsePropsCallback = UsePropsLogic.new()
	newUsePropsCallback:init(isTempProp, levelId, param, itemList)
	return newUsePropsCallback
end

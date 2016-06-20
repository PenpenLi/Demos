
UpdateDynamicPopoutAction = class(HomeScenePopoutAction)

function UpdateDynamicPopoutAction:ctor( updateVersionButton,popoutCallback )
	self.updateVersionButton = updateVersionButton
	self.popoutCallback = popoutCallback
end

function UpdateDynamicPopoutAction:popout( ... )
	local isAutoPopout = true
	if NewVersionUtil:hasDynamicUpdate() and not self.updateVersionButton.isDisposed then
		self.updateVersionButton.wrapper:setTouchEnabled(false)

		local function onSuccess( ... )
			self:next()
		end

		local function onFail( ... )
			-- self:placeholder()
			self:next()
		end

		DynamicUpdatePanel:onCheckDynamicUpdate(isAutoPopout,onSuccess,onFail)
		if self.popoutCallback then
			self.popoutCallback()
		end
	else 
		self:placeholder()
		self:next()
	end
end


function UpdateDynamicPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end
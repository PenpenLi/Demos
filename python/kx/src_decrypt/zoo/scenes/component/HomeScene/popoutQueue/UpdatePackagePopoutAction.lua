UpdatePackagePopoutAction = class(HomeScenePopoutAction)

function UpdatePackagePopoutAction:ctor( updateVersionButton,popoutCallback )
	self.updateVersionButton = updateVersionButton
	self.popoutCallback = popoutCallback
end

function UpdatePackagePopoutAction:popout( ... )
	if NewVersionUtil:hasPackageUpdate() and not self.updateVersionButton.isDisposed then 
		local position = self.updateVersionButton:getPosition()
		local panel = UpdatePageagePanel:create(position)
		if panel then
			local function onClose()
				self:next()
				if not self.updateVersionButton or self.updateVersionButton.isDisposed then return end
				self.updateVersionButton.wrapper:setTouchEnabled(true)
			end
			panel:addEventListener(kPanelEvents.kClose, onClose)
			self.updateVersionButton.wrapper:setTouchEnabled(false)
			panel:popout()

			if self.popoutCallback then
				self.popoutCallback()
			end
		else
			self:placeholder()
			self:next()
		end
	else
		self:placeholder()
		self:next()
	end
end


function UpdatePackagePopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end
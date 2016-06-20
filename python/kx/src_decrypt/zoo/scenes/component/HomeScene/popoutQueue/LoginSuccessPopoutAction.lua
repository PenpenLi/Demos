
LoginSuccessPopoutAction = class(HomeScenePopoutAction)

function LoginSuccessPopoutAction:ctor( title,message )
	self.title = title
	self.message = message
end

function LoginSuccessPopoutAction:popout( ... )
	local qqLoginPanel = QQLoginSuccessPanel:create(self.title,self.message)
	qqLoginPanel:popout()

	qqLoginPanel:addEventListener(PopoutEvents.kRemoveOnce, function( ... )
		self:next()
	end)
end


function LoginSuccessPopoutAction:getConditions( ... )
	return {"enter","enterForground","preActionNext"}
end
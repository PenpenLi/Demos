
UpdateSuccessPopoutAction = class(HomeScenePopoutAction)

function UpdateSuccessPopoutAction:ctor( ... )

end

function UpdateSuccessPopoutAction:popout( ... )
	UpdateSuccessPanel.popoutIfNecessary(function( ... )
		self:next()
	end)
end


function UpdateSuccessPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end
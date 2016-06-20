
LadyBugPanelPopoutAction = class(HomeScenePopoutAction)

function LadyBugPanelPopoutAction:ctor()
    print('LadyBugPanelPopoutAction')
end

function LadyBugPanelPopoutAction:popout( ... )

	local function ladyBugSucess()
	    local function closeCallback()
	        self:next()
	    end 
	    HomeScene:sharedInstance():startLadyBug(closeCallback)
	end
	local function ladyBugFail()
		self:placeholder()
		self:next()
	end
	local started = LadyBugMissionManager:sharedInstance():tryStartMission(ladyBugSucess, ladyBugFail)
	if not started then
		ladyBugFail()
	end


end

function LadyBugPanelPopoutAction:getConditions( ... )
	return {"enter","enterForground"}
end

Handler_3_23 = class(MacroCommand);

function Handler_3_23:execute()
	print("GameVar.tutorStage, BooleanValue", recvTable["Stage"], recvTable["BooleanValue"])
   	local BooleanValue = recvTable["BooleanValue"];
   	local Step = recvTable["Step"];
    -- print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stage, BooleanValue:", recvTable["Stage"], recvTable["BooleanValue"])
   	if BooleanValue == 1 then
   		GameVar.tutorStage = recvTable["Stage"]
	    if  GameVar.tutorStage == 0 then

	    else	

	    end

		if GameVar.tutorStage == TutorConfig.STAGE_99999 then
		    self.userProxy=self:retrieveProxy(UserProxy.name);
			if self.userProxy:getLevel() < 20 then
				if HButtonGroupMediator then
				 	local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
				 	if hBttonGroupMediator then
						hBttonGroupMediator:addTutorEffect()
					end
				end
			end
		else
			self:removeTutorEffect()
		end
	end
	
end
function Handler_3_23:removeTutorEffect()
	if HButtonGroupMediator then
	 	local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
	 	if hBttonGroupMediator then
			hBttonGroupMediator:removeTutorEffect()
		end
	end
end
Handler_3_23.new():execute();
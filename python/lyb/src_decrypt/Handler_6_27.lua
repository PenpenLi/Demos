

Handler_6_27 = class(Command);

function Handler_6_27:execute()
	local heroBankProxy = self:retrieveProxy(HeroBankProxy.name);    
	local ID = recvTable["GeneralId"];
	local isSuccess = recvTable["BooleanValue"];
	local userProxy = self:retrieveProxy(UserProxy.name)
	local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
	if isSuccess==1 then
		-- heroBankProxy.slaveGeneralArray[tostring(ID)].Potential = potential
		heroBankMediator:updatePotential(true);
		heroBankMediator:refreshBankDetailNoData();
	else
		heroBankMediator:updatePotential(false);
		heroBankMediator:refreshBankDetailNoData();
	end
end

Handler_6_27.new():execute();
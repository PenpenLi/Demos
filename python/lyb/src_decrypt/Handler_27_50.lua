require "main.model.BathFieldProxy";

Handler_27_50 = class(Command);

function Handler_27_50:execute()
  local bathFieldProxy = self:retrieveProxy(BathFieldProxy.name);
  if not bathFieldProxy then
  	bathFieldProxy = BathFieldProxy.new();
		self:registerProxy(BathFieldProxy.name,bathFieldProxy);
	end
  bathFieldProxy.data = recvTable["BathroomArray"];
	local generalListProxy = self:retrieveProxy(GeneralListProxy.name);
	local userProxy = self:retrieveProxy(UserProxy.name);
  
  local bathFieldMediator = self:retrieveMediator(BathFieldMediator.name);
  if bathFieldMediator then
		local playerTbl = {Level = generalListProxy:getLevel(),Career = userProxy:getCareer(),UserName = userProxy:getUserName()};
  	bathFieldMediator:updatePlayers(bathFieldProxy.data,playerTbl);
  end
end

Handler_27_50.new():execute();
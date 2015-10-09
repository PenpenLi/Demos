
-- red dot 取消小红点

Handler_3_42 = class(MacroCommand);

function Handler_3_42:execute()
	
    uninitializeSmallLoading();

	local reddotArr = recvTable["RedPointArray"]
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	for k,v in pairs(reddotArr) do
		local functionID = v.ID
		log("functionID=="..functionID)
		if functionID == FunctionConfig.FUNCTION_ID_47 then
        	heroHouseProxy.Hongidan_Shenqingdu = nil;
        	self:refreshBangpai();
		end
	end
end

function Handler_3_42:refreshBangpai()
	require "main.controller.command.family.BangpaiRedDotRefreshCommand";
  	BangpaiRedDotRefreshCommand.new():execute();
end

Handler_3_42.new():execute();
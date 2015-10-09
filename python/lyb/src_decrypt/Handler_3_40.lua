
-- red dot 
-- 这是服务器同步过来的最后一条数据

Handler_3_40 = class(MacroCommand);

function Handler_3_40:execute()
  	hecDC(2,200)
    uninitializeSmallLoading();
	GameData.isConnecting = false
	for k,v in pairs(recvTable["RedPointArray"]) do
		print(".3.40..",v.ID);
	end
	local reddotArr = recvTable["RedPointArray"]
	local userProxy = self:retrieveProxy(UserProxy.name);
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);

	for k,v in pairs(reddotArr) do
		local functionID = v.ID
		log("functionID=="..functionID)
		if functionID == FunctionConfig.FUNCTION_ID_5 then
			self:addSubCommand(ToRefreshReddotCommand)
			self:complete({data={type=FunctionConfig.FUNCTION_ID_5,value=1}})
		elseif functionID  == FunctionConfig.FUNCTION_ID_10 then
			self:addSubCommand(ToRefreshReddotCommand)
			self:complete({data={type=FunctionConfig.FUNCTION_ID_10,value=1}})
		elseif functionID == FunctionConfig.FUNCTION_ID_29 then
			GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_29] = true;
			if LeftButtonGroupMediator then
              local med=self:retrieveMediator(LeftButtonGroupMediator.name);
              if med then
                med:refreshQianDao();
              end
            end
        elseif functionID == FunctionConfig.FUNCTION_ID_46 then
        	heroHouseProxy.Hongidan_Huoyuedu = 1;
        	self:refreshBangpai();
        elseif functionID == FunctionConfig.FUNCTION_ID_47 then
        	heroHouseProxy.Hongidan_Shenqingdu = 1;
        	self:refreshBangpai();
		elseif functionID == FunctionConfig.FUNCTION_ID_53 then
			GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_53] = true;
			if MainSceneMediator then
	          local med=self:retrieveMediator(MainSceneMediator.name);
	          if med then
	            med:refreshMonthCard();
	          end
	        end
	    end
	end
	heroHouseProxy:setHongdianDatas();
end

function Handler_3_40:refreshBangpai()
	require "main.controller.command.family.BangpaiRedDotRefreshCommand";
  	BangpaiRedDotRefreshCommand.new():execute();
end

Handler_3_40.new():execute();
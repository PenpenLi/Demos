--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_15_2 = class(Command);

function Handler_15_2:execute()
   -- print(".15.2..UserId..EnableTitleId",recvTable["UserId"],recvTable["EnableTitleId"]);
   -- uninitializeSmallLoading();
   -- local userProxy=self:retrieveProxy(UserProxy.name);
   -- if userProxy:getUserID()==recvTable["UserId"] then
   --    userProxy:changeTitleID(recvTable["EnableTitleId"],1);

   --    local titleMediator=self:retrieveMediator(TitleMediator.name);
   --    if nil ~= titleMediator then 
   --       titleMediator:changeTitleID(recvTable["EnableTitleId"],1);
   --    end
   -- end
   -- local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
   -- if nil ~= mainSceneMediator then 
   --    mainSceneMediator:refreshTitle(recvTable["UserId"],recvTable["EnableTitleId"],1);
   -- end
end

Handler_15_2.new():execute();
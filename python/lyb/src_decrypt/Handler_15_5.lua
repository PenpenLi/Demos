--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_15_5 = class(Command);

function Handler_15_5:execute()
   -- print(".15.5..UserId..EnableTitleId",recvTable["UserId"],recvTable["EnableTitleId"]);
   -- uninitializeSmallLoading();
   -- local userProxy=self:retrieveProxy(UserProxy.name);
   -- if userProxy:getUserID()==recvTable["UserId"] then
   --    userProxy:changeTitleID(recvTable["EnableTitleId"]);

   --    local titleMediator=self:retrieveMediator(TitleMediator.name);
   --    if nil ~= titleMediator then 
   --       titleMediator:changeTitleID(recvTable["EnableTitleId"]);
   --    end
   -- end
   -- local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
   -- if nil ~= mainSceneMediator then 
   --    mainSceneMediator:refreshTitle(recvTable["UserId"],recvTable["EnableTitleId"]);
   -- end
end

Handler_15_5.new():execute();
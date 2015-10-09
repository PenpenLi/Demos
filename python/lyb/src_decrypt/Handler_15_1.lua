--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_15_1 = class(Command);

function Handler_15_1:execute()
   print(".15.1.");
   for k,v in pairs(recvTable["TitleArray"]) do
   	  print(".15.1..",v.TitleId);
   end
   uninitializeSmallLoading();
   local titleProxy=self:retrieveProxy(TitleProxy.name);
   titleProxy:refresh(recvTable["TitleArray"]);

   local titleMediator=self:retrieveMediator(TitleMediator.name);
   if nil ~= titleMediator then 
      titleMediator:refresh(recvTable["TitleArray"]);
   end
end

Handler_15_1.new():execute();
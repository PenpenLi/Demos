--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_24_8 = class(Command);

function Handler_24_8:execute()
 local huodongProxy = self:retrieveProxy(HuoDongProxy.name)
 local paramStr1 = recvTable["ParamStr1"]
 if paramStr1 == "" then
 	huodongProxy.hasBindPhone = false;
 else
 	huodongProxy.phoneNum = paramStr1;
 	huodongProxy.hasBindPhone = true;
 end


end

Handler_24_8.new():execute();
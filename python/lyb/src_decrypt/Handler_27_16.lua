--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.family.FamilyMediator";

Handler_27_16 = class(Command);

function Handler_27_16:execute()

   local familyProxy = self:retrieveProxy(FamilyProxy.name)
   familyProxy.gongGao = recvTable["ParamStr1"];
  if MainSceneMediator then
	  local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
	  if nil~=mainSceneMediator then
	  	mainSceneMediator:refreshGongGao(familyProxy.gongGao);
	  end
  end
end

Handler_27_16.new():execute();
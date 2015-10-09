--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-31

	yanchuan.xie@happyelements.com
]]

ToAddGuangboCommand=class(Command);

function ToAddGuangboCommand:ctor()
	self.class=ToAddGuangboCommand;
end

function ToAddGuangboCommand:execute()
  local userProxy=self:retrieveProxy(UserProxy.name);
  if 0==table.getn(userProxy.guangboData) then
    return;
  end
  local guangboMediator = self:retrieveMediator(GuangboMediator.name)
  if not guangboMediator then
    guangboMediator = GuangboMediator.new()
    self:registerMediator(guangboMediator:getMediatorName(),guangboMediator)
    guangboMediator:init(userProxy)
    self:registerGuangboCommands()
    self:observe(ToRemoveGuangboCommand);
  end

  guangboMediator:playGuangbo();
  self:refreshChat();
end

function ToAddGuangboCommand:registerGuangboCommands()
  require "main.controller.command.mainScene.ToRemoveGuangboCommand";
  self:registerCommand(MainSceneNotifications.TO_REMOVE_GUANGBO,ToRemoveGuangboCommand);
end


function ToAddGuangboCommand:refreshChat()
  local a=StringUtils:getBroadData(recvTable["ID"],recvTable["ParamStr1"],recvTable["ParamStr2"],recvTable["ParamStr3"],recvTable["Content"]);
  if not a or 0==table.getn(a) then
    return;
  end
  recvTable["UserName"]="";
  recvTable["Level"]=0;
  recvTable["ChatContentArray"]=a;
  recvTable["MainType"]=ConstConfig.MAIN_TYPE_CHAT;
  recvTable["SubType"]=self:getSubType();
  recvTable["TargetUserName"]="";
  recvMessage(1011,1);
end

function ToAddGuangboCommand:getSubType()
  if 52==recvTable["ID"] or 53==recvTable["ID"] or 19==recvTable["ID"] or 20==recvTable["ID"] or 22==recvTable["ID"] then
    return ConstConfig.SUB_TYPE_FACTION;
  else
    return ConstConfig.SUB_TYPE_BROAD;
  end
end
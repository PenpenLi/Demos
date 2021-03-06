Handler_23_12 = class(MacroCommand);

function Handler_23_12:execute()
  print(".23.12.IDArray");
  for k,v in pairs(recvTable["IDArray"]) do
    -- print(".23.10..",v.MailId,v.ConfigId,v.ParamStr1,v.Title,v.FromUserName,v.DateTime,v.Content,v.ByteState,v.ItemIdArray,v.ByteType);
  end
  -- print(".23.10.IDArray");
  -- for k,v in pairs(recvTable["IDArray"]) do
  --   print(".23.10..",v.ID);
  -- end

  local mailProxy = self:retrieveProxy(MailProxy.name);
  mailProxy:refreshDataDelete(recvTable["IDArray"]);

  if MailPopupMediator then
    local mailPopupMediator = self:retrieveMediator(MailPopupMediator.name);
    if nil~=mailPopupMediator then
    	mailPopupMediator:refreshMailDelete(recvTable["IDArray"]);
    end
  end

  self:addSubCommand(ToRefreshReddotCommand);
  self:complete({data={type=FunctionConfig.FUNCTION_ID_5}});
end

Handler_23_12.new():execute();
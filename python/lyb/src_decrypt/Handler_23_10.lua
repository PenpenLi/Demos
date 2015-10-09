Handler_23_10 = class(MacroCommand);

function Handler_23_10:execute()
  print(".23.10.MailArray");
  for k,v in pairs(recvTable["MailArray"]) do
    -- print(".23.10..",v.MailId,v.ConfigId,v.ParamStr1,v.Title,v.FromUserName,v.DateTime,v.Content,v.ByteState,v.ItemIdArray,v.ByteType);
  end
  -- print(".23.10.IDArray");
  -- for k,v in pairs(recvTable["IDArray"]) do
  --   print(".23.10..",v.ID);
  -- end

  local mailProxy = self:retrieveProxy(MailProxy.name);
  mailProxy:refreshData(recvTable["MailArray"], recvTable["IDArray"]);

  if MailPopupMediator then
    local mailPopupMediator = self:retrieveMediator(MailPopupMediator.name);
    if nil~=mailPopupMediator then
    	mailPopupMediator:refreshMail();
    end
  end

  self:addSubCommand(ToRefreshReddotCommand);
  self:complete({data={type=FunctionConfig.FUNCTION_ID_5}});
end

Handler_23_10.new():execute();
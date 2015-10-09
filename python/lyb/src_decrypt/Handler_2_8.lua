
Handler_2_8 = class(MacroCommand);

function Handler_2_8:execute()
      local userName = recvTable["UserName"];
      local createRoleMediator=self:retrieveMediator(CreateRoleMediator.name);
      if createRoleMediator then
          createRoleMediator:refreshUserName(userName);
      end
end

Handler_2_8.new():execute();
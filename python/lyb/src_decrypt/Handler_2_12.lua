--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-5-2

  yanchuan.xie@happyelements.com
]]

Handler_2_12 = class(MacroCommand);

function Handler_2_12:execute()
	  uninitializeSmallLoading();
      local userName = recvTable["UserName"];
      if ServerMergeMediator then
      	local serverMergeMediator=self:retrieveMediator(ServerMergeMediator.name);
      	if serverMergeMediator then
          serverMergeMediator:refreshUserName(userName);
      	end
      end
end

Handler_2_12.new():execute();
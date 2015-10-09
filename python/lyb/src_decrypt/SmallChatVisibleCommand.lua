SmallChatVisibleCommand=class(MacroCommand);

function SmallChatVisibleCommand:ctor()
  self.class=SmallChatVisibleCommand;
end

function SmallChatVisibleCommand:execute(notification)

	if SmallChatMediator then
		  local smallChatMediator=self:retrieveMediator(SmallChatMediator.name);
		  if nil ~= smallChatMediator then
		      if notification.data then
	  			 smallChatMediator:getViewComponent():setVisible(true)
		      else
				 smallChatMediator:getViewComponent():setVisible(false)
		      end
		  else
		      print("#########################SmallChatMediator");
		  end
    end
end
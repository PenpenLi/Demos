require "main.view.task.MainSceneMediator";
require "main.model.UserProxy";
TrackTaskCommand=class(Command);

function TrackTaskCommand:ctor()
	self.class=TrackTaskCommand;
end

function TrackTaskCommand:execute(notification)
   local mainScenceMediator=self:retrieveMediator(MainSceneMediator.name);

end
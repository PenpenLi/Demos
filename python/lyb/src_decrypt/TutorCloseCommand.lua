TutorCloseCommand=class(MacroCommand);

function TutorCloseCommand:ctor()
	self.class=TutorCloseCommand;
end

function TutorCloseCommand:execute(notification)
  print("!!!!!!!!!!!!!!!!!!!!TutorCloseCommand")
   if  TutorMediator then
     self:removeMediator(TutorMediator.name);
     MusicUtils:stopEffect()
   end
   if notification ~= nil then
    -- local tutorMediator = self:retrieveMediator(TutorMediator.name);	
    -- if tutorMediator then
    -- 	tutorMediator:getViewComponent():setVisible(false)
    -- end
   else
    GameVar.tutorSmallStep = 0
   end

end
QianDaoCloseCommand=class(MacroCommand);

function QianDaoCloseCommand:ctor()
	self.class=QianDaoCloseCommand;
end

function QianDaoCloseCommand:execute(notification)
	self:removeMediator(QianDaoMediator.name);
	self:unobserve(QianDaoCloseCommand);
	self:removeCommand(QianDaoNotifications.QIANDAO_UI_CLOSE,QianDaoCloseCommand);
	if LeftButtonGroupMediator then
	  local med=self:retrieveMediator(LeftButtonGroupMediator.name);
	  if med then
	    med:refreshQianDao();
	  end
	end
	-- if GameVar.tutorStage == TutorConfig.STAGE_2003 then
	-- 	sendServerTutorMsg({})
 --    end
	-- closeTutorUI();
end

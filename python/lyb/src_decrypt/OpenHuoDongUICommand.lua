

OpenHuoDongUICommand=class(Command);

function OpenHuoDongUICommand:ctor()
	self.class=OpenHuoDongUICommand;
end

function OpenHuoDongUICommand:execute(notification)
	require "main.view.huoDong.HuoDongMediator";
	require "main.controller.command.huoDong.HuoDongCloseCommand";


  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  
  self.notification = notification;
  if GameVar.tutorStage == TutorConfig.STAGE_2004 then
    openTutorUI({x=987, y=322, width = 150, height = 150, alpha = 125});
  end
  self.huoDongMed=self:retrieveMediator(HuoDongMediator.name);  
  if nil==self.huoDongMed then
    self.huoDongMed=HuoDongMediator.new();

    self:registerMediator(self.huoDongMed:getMediatorName(),self.huoDongMed);

    self.huoDongMed:initializeUI();

    self:registerQianDaoCommands();
  end

   self:observe(HuoDongCloseCommand);
   LayerManager:addLayerPopable(self.huoDongMed:getViewComponent());
    
   hecDC(3,19,1)
end

function OpenHuoDongUICommand:registerQianDaoCommands()
  self:registerCommand(HuoDongNotifications.HUODONG_UI_CLOSE, HuoDongCloseCommand);
end
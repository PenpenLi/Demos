OpenQianDaoUICommand=class(Command);

function OpenQianDaoUICommand:ctor()
	self.class=OpenQianDaoUICommand;
end

function OpenQianDaoUICommand:execute(notification)
	require "main.view.qianDao.QianDaoMediator";
	require "main.controller.command.qiandao.QianDaoCloseCommand";


  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  
  self.notification = notification;
 
  self.qianDaoMed=self:retrieveMediator(QianDaoMediator.name);  
  if nil==self.qianDaoMed then
    self.qianDaoMed=QianDaoMediator.new();

    self:registerMediator(self.qianDaoMed:getMediatorName(),self.qianDaoMed);

    self.qianDaoMed:initializeUI();

    self:registerQianDaoCommands();
  end

   self:observe(QianDaoCloseCommand);
   LayerManager:addLayerPopable(self.qianDaoMed:getViewComponent());
    
   -- if GameVar.tutorStage == TutorConfig.STAGE_2003 then
   --    openTutorUI({x=641, y=51, width = 192, height = 62, alpha = 125});
   -- end   
   hecDC(3,18,1)
end

function OpenQianDaoUICommand:registerQianDaoCommands()
  self:registerCommand(QianDaoNotifications.QIANDAO_UI_CLOSE, QianDaoCloseCommand);
end

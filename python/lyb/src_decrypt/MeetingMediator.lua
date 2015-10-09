require "main.view.meeting.ui.MeetingPopup";

MeetingMediator=class(Mediator);

function MeetingMediator:ctor()
  self.class = MeetingMediator;
	self.viewComponent=MeetingPopup.new();
end

rawset(MeetingMediator,"name","MeetingMediator");

function MeetingMediator:intializeUI()
 
end

function MeetingMediator:onRegister()
    self:getViewComponent():addEventListener("closeNotice",self.onUIClose,self);
    self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip,self);
    self:getViewComponent():addEventListener("to_Meeting_Team",self.onMeetingTeam,self);
    self:getViewComponent():addEventListener("TO_DIANJINSHOU",self.onToDianjinshou,self);  
end

function MeetingMediator:onToDianjinshou(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI, {showCurrency = false}));
end
function MeetingMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function MeetingMediator:onUIClose(event)
  self:sendNotification(MeetingNotification.new(MeetingNotifications.MEETING_CLOSE_COMMAND));
end

function MeetingMediator:onMeetingTeam(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

function MeetingMediator:setState(state)
	self.viewComponent:setState(state);
end

function MeetingMediator:setProposal(IDParamArray)
	self.viewComponent:setProposal(IDParamArray);
end
function MeetingMediator:setOfficerState(IDStateParamArray)
	self.viewComponent:setOfficerState(IDStateParamArray);
end

function MeetingMediator:onRemove()
  if self:getViewComponent().parent then
     self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
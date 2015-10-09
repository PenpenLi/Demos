require "main.view.mainScene.sevicePanel.SevicePanelUI"

SevicePanelMediator = class(Mediator)

function SevicePanelMediator:ctor()

	print("zhangke ------------SevicePanelMediator:ctor")
	-- body
	self.class = SevicePanelMediator
	self.viewComponent = SevicePanelUI.new()
end

rawset(SevicePanelMediator,"name","SevicePanelMediator");

function SevicePanelMediator:onRegister()
	-- body
	print("zhangke ------------SevicePanelMediator:onRegister")
	self.viewComponent:onInit()
	
	self.viewComponent.gonggaoButton:addEventListener(DisplayEvents.kTouchTap,self.onClickgonggaoButton,self)
	self.viewComponent.gmButton:addEventListener(DisplayEvents.kTouchTap,self.onClickgmButton,self)
	self.viewComponent.shezhiButton:addEventListener(DisplayEvents.kTouchTap,self.onClickshezhiButton,self)

	self.viewComponent.confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onClickconfirmButton,self)
	self.viewComponent.closeButton:addEventListener(DisplayEvents.kTouchTap,self.onClickcloseButton,self)


end

function SevicePanelMediator:onClickconfirmButton()
	
end

function SevicePanelMediator:onClickcloseButton()
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REMOVE_SEVICEPANEL));
end

function SevicePanelMediator:onClickgonggaoButton()
  
    sendMessage(24 ,39);
end
function SevicePanelMediator:onClickgmButton()
  
end
function SevicePanelMediator:onClickshezhiButton()

    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPERATION));
end
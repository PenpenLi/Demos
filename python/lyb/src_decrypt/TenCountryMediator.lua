require "main.view.tenCountry.TenCountryPopup";

TenCountryMediator=class(Mediator);

function TenCountryMediator:ctor()
  self.class = TenCountryMediator;
	self.viewComponent=TenCountryPopup.new();
end

rawset(TenCountryMediator,"name","TenCountryMediator");

function TenCountryMediator:intializeUI()
  -- self:getViewComponent():initializeLayer();
end

function TenCountryMediator:onRegister()
  self:getViewComponent():addEventListener("closeNotice",self.onTenCountryClose,self);
  self:getViewComponent():addEventListener("to_Attack_Team",self.onTenCountryTeam,self);
end


function TenCountryMediator:refreshTenCountryMapData()
	self:getViewComponent():refreshTenCountryMapData()
end

function TenCountryMediator:refreshTeamLayerData()
	self:getViewComponent():refreshTeamLayerData()
end

function TenCountryMediator:onRemove()
    if self:getViewComponent().parent then
        self:getViewComponent().parent:removeChild(self:getViewComponent());
    end
end

function TenCountryMediator:onTenCountryTeam(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

function TenCountryMediator:onTenCountryClose(event)
  self:sendNotification(TenCountryNotification.new(TenCountryNotifications.TEN_COUNTRY_CLOSE));
end

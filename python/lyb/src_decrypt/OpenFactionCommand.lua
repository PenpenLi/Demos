--

require "main.view.faction.FactionMediator";
require "main.view.faction.FactionCurrencyMediator";
OpenFactionCommand=class(Command);

function OpenFactionCommand:ctor()
	self.class=OpenFactionCommand;
end

function OpenFactionCommand:execute()
  self:require();

  --FactionMediator
  --setButtonGroupVisible(false)

  self.factionMediator=self:retrieveMediator(FactionMediator.name);  

  if nil==self.factionMediator then
    self.factionMediator=FactionMediator.new();

    self:registerMediator(self.factionMediator:getMediatorName(),self.factionMediator);
        
    self:refreshFactionUI();

    self:registerShadownUI();
  end

  self:observe(FactionCloseCommand);
  -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.factionMediator:getViewComponent());
  LayerManager:addLayerPopable(self.factionMediator:getViewComponent());

  setFactionCurrencyVisible(true)
  
  if GameVar.tutorStage == TutorConfig.STAGE_1012 then
    openTutorUI({x=560, y=240, width = 280, height = 171, alpha = 125});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1026 then
    local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
    if not tenCountryProxy.afterBattle then
      GameVar.tutorSmallStep = 0;
      openTutorUI({x=180, y=420, width = 220, height = 200, alpha = 125});
    end
  end
  sendMessage(19,17)
  hecDC(3,6,1)
end

--更新StrengthenUI
function OpenFactionCommand:refreshFactionUI()

  self.factionMediator:initializeUI();
end

function OpenFactionCommand:registerShadownUI()
  self:registerCommand(FactionNotifications.FACTION_UI_CLOSE, FactionCloseCommand);
  self:registerCommand(FactionNotifications.TO_TEN_COUNTRY,ToTenCountryCommand);
  -- require "main.controller.command.mainScene.ToTreasuryCommand";
  -- self:registerCommand(FactionNotifications.TO_TREASURY_COMMAND,ToTreasuryCommand);
  require "main.controller.command.mainScene.ToMeetingCommand";
  self:registerCommand(FactionNotifications.TO_MEETING_COMMAND,ToMeetingCommand);

  require "main.controller.command.shop.OpenShopUICommand";
  self:registerCommand(FactionNotifications.TO_SHOP_COMMAND,OpenShopUICommand);
end

function OpenFactionCommand:require()

  require "main.model.UserProxy";
  require "main.controller.command.faction.FactionCloseCommand";
end
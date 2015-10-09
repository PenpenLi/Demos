FactionCloseCommand=class(MacroCommand);

function FactionCloseCommand:ctor()
	self.class=FactionCloseCommand;
end

function FactionCloseCommand:execute(notification)

  self:removeMediator(FactionMediator.name);
  
  self:unobserve(FactionCloseCommand);
  setFactionCurrencyVisible(false)
  self:removeCommand(FactionNotifications.TO_TEN_COUNTRY,ToTenCountryCommand);
  -- self:removeCommand(FactionNotifications.TO_TREASURY_COMMAND,ToTreasuryCommand);
  self:removeCommand(FactionNotifications.TO_MEETING_COMMAND,ToMeetingCommand);
  -- self:removeCommand(FactionNotifications.TO_SHOP_COMMAND,OpenShopUICommand);

  if HButtonGroupMediator then
    local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
    if hBttonGroupMediator then
      hBttonGroupMediator:refreshShili();
      if GameVar.tutorStage == TutorConfig.STAGE_1012 then
        local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
      elseif GameVar.tutorStage == TutorConfig.STAGE_1026 then
        local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
        if tenCountryProxy.afterBattle then
          openTutorUI({x=29 - GameData.uiOffsetX, y=620 + GameData.uiOffsetY, width = 100, height = 85});
        end
      end
    end
  end

end

MainSceneToVipCommand=class(Command);

function MainSceneToVipCommand:ctor()
	self.class=MainSceneToVipCommand;
end

function MainSceneToVipCommand:execute()
  require "main.view.vip.VipMediator";
  require "main.controller.command.vip.VipCloseCommand";
  require "main.controller.command.vip.ToPlatformPayCommand";
  require "main.controller.notification.VipNotification";

  local vipMediator=self:retrieveMediator(VipMediator.name);

  if nil==vipMediator then
    vipMediator=VipMediator.new();
    self:registerMediator(vipMediator:getMediatorName(),vipMediator);
    vipMediator:intializeVipUI();
  end

  self:registerVipCommands();
  LayerManager:addLayerPopable(vipMediator:getViewComponent());

  if FactionMediator then
  	local factionMediator = self:retrieveMediator(FactionMediator.name);
  	if factionMediator then
  		setFactionCurrencyVisible(false)
  	end
  end

  self:observe(VipCloseCommand);
end

function MainSceneToVipCommand:registerVipCommands()
  self:registerCommand(VipNotifications.VIP_CLOSE_COMMAND,VipCloseCommand);
  self:registerCommand(VipNotifications.TO_PLATFORM_PAY,ToPlatformPayCommand); 
end
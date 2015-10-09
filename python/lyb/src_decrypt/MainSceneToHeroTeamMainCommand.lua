require "main.view.hero.heroTeam.HeroTeamMainMediator";
require "main.controller.command.hero.HeroTeamMainCloseCommand";
require "main.controller.notification.HeroHouseNotification";

MainSceneToHeroTeamMainCommand=class(Command);

function MainSceneToHeroTeamMainCommand:ctor()
	self.class=MainSceneToHeroTeamMainCommand;
end

function MainSceneToHeroTeamMainCommand:execute(notification)
	local heroTeamMainMediator=self:retrieveMediator(HeroTeamMainMediator.name);
	if not heroTeamMainMediator then
		print("=============================retrieve");	
		heroTeamMainMediator=HeroTeamMainMediator.new();
		self:registerMediator(heroTeamMainMediator:getMediatorName(),heroTeamMainMediator);
		self:registerHeroHouseCommands();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroTeamMainMediator:getViewComponent());
	self:observe(HeroTeamMainCloseCommand);
	print("=============================open");

	LayerManager:addLayerPopable(heroTeamMainMediator:getViewComponent());
	heroTeamMainMediator:initializeUI(notification.data);

	--setButtonGroupVisible(false);
end

function MainSceneToHeroTeamMainCommand:registerHeroHouseCommands()
	self:registerCommand(HeroHouseNotifications.HEROTEAMMAIN_CLOSE, HeroTeamMainCloseCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
end

require "main.view.hero.heroChangeEquipe.HeroChangeEquipeMediator";
require "main.controller.command.hero.HeroChangeEquipeCloseCommand";
require "main.controller.notification.HeroHouseNotification";

MainSceneToHeroChangeEquipeCommand=class(Command);

function MainSceneToHeroChangeEquipeCommand:ctor()
	self.class=MainSceneToHeroChangeEquipeCommand;
end

function MainSceneToHeroChangeEquipeCommand:execute(notification)
	print("??????????????????????????");
	local heroChangeEquipeMediator=self:retrieveMediator(HeroChangeEquipeMediator.name);
	if not heroChangeEquipeMediator then
		heroChangeEquipeMediator=HeroChangeEquipeMediator.new();
		self:registerMediator(heroChangeEquipeMediator:getMediatorName(),heroChangeEquipeMediator);
		heroChangeEquipeMediator:initializeUI();
		self:registerHeroChangeEquipeCommands();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroChangeEquipeMediator:getViewComponent());
	self:observe(HeroChangeEquipeCloseCommand);

	LayerManager:addLayerPopable(heroChangeEquipeMediator:getViewComponent());
end

function MainSceneToHeroChangeEquipeCommand:registerHeroChangeEquipeCommands()
	self:registerCommand(HeroHouseNotifications.HEROCHANGEEQUIPE_CLOSE, HeroChangeEquipeCloseCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
end

require "main.view.hero.heroJinJie.HeroJinJiePopupMediator";
require "main.controller.command.hero.HeroJinJieCloseCommand";
require "main.controller.notification.HeroHouseNotification";

MainSceneToHeroJinJieCommand=class(Command);

function MainSceneToHeroJinJieCommand:ctor()
	self.class=MainSceneToHeroJinJieCommand;
end

function MainSceneToHeroJinJieCommand:execute(notification)
	local heroJinJiePopupMediator=self:retrieveMediator(HeroJinJiePopupMediator.name);
	if not heroJinJiePopupMediator then
		print("=============================retrieve");	
		heroJinJiePopupMediator=HeroJinJiePopupMediator.new();
		self:registerMediator(heroJinJiePopupMediator:getMediatorName(),heroJinJiePopupMediator);
		heroJinJiePopupMediator:initializeUI();
		self:registerHeroJinJieCommands();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroJinJiePopupMediator:getViewComponent());
	self:observe(HeroJinJieCloseCommand);
	print("=============================open");

	LayerManager:addLayerPopable(heroJinJiePopupMediator:getViewComponent());
end

function MainSceneToHeroJinJieCommand:registerHeroJinJieCommands()
	self:registerCommand(HeroHouseNotifications.HEROJINJIE_CLOSE, HeroJinJieCloseCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
end

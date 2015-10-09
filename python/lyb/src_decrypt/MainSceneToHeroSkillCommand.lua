require "main.view.hero.heroSkill.HeroSkillPopupMediator";
require "main.controller.command.hero.HeroSkillCloseCommand";
require "main.controller.notification.HeroHouseNotification";

MainSceneToHeroSkillCommand=class(Command);

function MainSceneToHeroSkillCommand:ctor()
	self.class=MainSceneToHeroSkillCommand;
end

function MainSceneToHeroSkillCommand:execute(notification)
	local heroSkillPopupMediator=self:retrieveMediator(HeroSkillPopupMediator.name);
	if not heroSkillPopupMediator then
		print("=============================retrieve");	
		heroSkillPopupMediator=HeroSkillPopupMediator.new();
		self:registerMediator(heroSkillPopupMediator:getMediatorName(),heroSkillPopupMediator);
		heroSkillPopupMediator:initializeUI();
		self:registerHeroSkillCommands();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroSkillPopupMediator:getViewComponent());
	self:observe(HeroSkillCloseCommand);
	print("=============================open");

	LayerManager:addLayerPopable(heroSkillPopupMediator:getViewComponent());
end

function MainSceneToHeroSkillCommand:registerHeroSkillCommands()
	self:registerCommand(HeroHouseNotifications.HEROSKILL_CLOSE, HeroSkillCloseCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
end

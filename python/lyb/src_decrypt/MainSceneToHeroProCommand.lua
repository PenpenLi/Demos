require "main.view.hero.heroPro.HeroProPopupMediator";
require "main.controller.command.hero.HeroProCloseCommand";
require "main.controller.command.hero.HeroPutOnEquipeCommand";
require "main.controller.command.hero.HeroPutOffEquipeCommand";
require "main.controller.notification.HeroHouseNotification";

MainSceneToHeroProCommand=class(Command);

function MainSceneToHeroProCommand:ctor()
	self.class=MainSceneToHeroProCommand;
end

function MainSceneToHeroProCommand:execute(notification)
	local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
	if not heroProPopupMediator then
		heroProPopupMediator=HeroProPopupMediator.new(notification.data);
		self:registerMediator(heroProPopupMediator:getMediatorName(),heroProPopupMediator);
		self:registerHeroHouseCommands();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroProPopupMediator:getViewComponent());
	self:observe(HeroProCloseCommand);
	-- heroProPopupMediator:initializeUI(notification.data);
	LayerManager:addLayerPopable(heroProPopupMediator:getViewComponent());

 -- if GameVar.tutorStage == TutorConfig.STAGE_1006 then

 --   else

   if GameVar.tutorStage == TutorConfig.STAGE_1010 then
	 openTutorUI({x=547, y=16, width = 94, height = 42, alpha = 125});
    -- local skillId = analysis("Kapai_Kapaiku", 16, "skill")
    -- if 1 ~= heroHouseProxy:getSkillLevel(mainHero.GeneralId, skillId) then
    -- 	GameVar.tutorSmallStep = 100610
    -- end
   elseif GameVar.tutorStage == TutorConfig.STAGE_1004 then
      openTutorUI({x=855, y=491, width = 52, height = 52, alpha = 125});
   elseif GameVar.tutorStage == TutorConfig.STAGE_1008 then
      openTutorUI({x=1001, y=326, width = 109, height = 42, alpha = 125});
   elseif GameVar.tutorStage == TutorConfig.STAGE_1009 then

      -- local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
      -- local generalData = heroHouseProxy:getGeneralDataByConfigID(89)
      -- if heroHouseProxy:getSkillLevel(generalData.GeneralId, 10008920) == 1 then
        openTutorUI({x=697, y=158, width = 74, height = 74, alpha = 125}); 
      -- else
      --   GameVar.tutorSmallStep = 100903
      --   openTutorUI({x=1134, y=328, width = 70, height = 110, alpha = 125});
      -- end
   elseif GameVar.tutorStage == TutorConfig.STAGE_1014 then
      openTutorUI({x=1134, y=63, width = 70, height = 125, alpha = 125});
   elseif GameVar.tutorStage == TutorConfig.STAGE_1017 then
      openTutorUI({x=1134, y=196, width = 70, height = 110, alpha = 125});
   end

	hecDC(3,4,3);
end

function MainSceneToHeroProCommand:registerHeroHouseCommands()
	self:registerCommand(HeroHouseNotifications.HEROPRO_CLOSE, HeroProCloseCommand);
	self:registerCommand(HeroHouseNotifications.HEROEQUIPE_PUTON, HeroPutOnEquipeCommand);
	self:registerCommand(HeroHouseNotifications.HEROEQUIPE_PUTOFF, HeroPutOffEquipeCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
end

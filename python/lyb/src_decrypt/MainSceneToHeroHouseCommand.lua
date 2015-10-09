require "main.view.hero.heroHouse.HeroHousePopupMediator";
require "main.controller.command.hero.HeroHouseCloseCommand";
require "main.controller.notification.HeroHouseNotification";
require "main.controller.command.hero.HeroHouseInitCommand";
require "main.controller.command.hero.HeroHouseCheckCardCommand";

MainSceneToHeroHouseCommand=class(Command);

function MainSceneToHeroHouseCommand:ctor()
	self.class=MainSceneToHeroHouseCommand;
end

function MainSceneToHeroHouseCommand:execute(notification)
	local heroHousePopupMediator=self:retrieveMediator(HeroHousePopupMediator.name);
	if not heroHousePopupMediator then
		print("=============================retrieve");	
		heroHousePopupMediator=HeroHousePopupMediator.new();
		self:registerMediator(heroHousePopupMediator:getMediatorName(),heroHousePopupMediator);
		self:registerHeroHouseCommands();
		heroHousePopupMediator:initializeUI();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroHousePopupMediator:getViewComponent());
	self:observe(HeroHouseCloseCommand);
	log("=============================open");

	LayerManager:addLayerPopable(heroHousePopupMediator:getViewComponent());
	  
    if GameVar.tutorStage == TutorConfig.STAGE_1010 then
    	print("getXPosByConfigId")
		local xPos, page = self:getXPosByConfigId(89);--36是秦般若,44宫羽,飞流40,16是萧景睿
     	if page > 1 then
			heroHousePopupMediator:setCurrentPage(page)
     	end
     	openTutorUI({x=xPos , y=87, width = 151, height = 554, alpha = 125});
	elseif GameVar.tutorStage == TutorConfig.STAGE_1004 or GameVar.tutorStage == TutorConfig.STAGE_1014 then
		local xPos, page = self:getXPosByConfigId(89);--16是萧景睿,19是谢绮
     	openTutorUI({x=xPos , y=87, width = 151, height = 554, alpha = 125});
     	if page > 1 then
			heroHousePopupMediator:setCurrentPage(page)
     	end
	elseif GameVar.tutorStage == TutorConfig.STAGE_1006 then
		local xPos, page = self:getXPosByConfigId(77);--77是晏大夫
     	openTutorUI({x=xPos , y=87, width = 151, height = 554, alpha = 125});
     	if page > 1 then
			heroHousePopupMediator:setCurrentPage(page)
     	end
    elseif GameVar.tutorStage == TutorConfig.STAGE_1008 or GameVar.tutorStage == TutorConfig.STAGE_1009 then
	  -- 	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);		
	  -- 	local generalData = heroHouseProxy:getGeneralDataByConfigID(89);
	  -- 	if generalData.StarLevel == analysis("Kapai_Kapaiku",generalData.ConfigId, "star") then
			-- sendServerTutorMsg({})
   --    		closeTutorUI();
	  -- 		return
	  -- 	end
		local xPos, page = self:getXPosByConfigId(89);--19是谢绮
     	openTutorUI({x=xPos , y=87, width = 151, height = 554, alpha = 125});
     	if page > 1 then
			heroHousePopupMediator:setCurrentPage(page)
     	end
    elseif GameVar.tutorStage == TutorConfig.STAGE_1017 then
    	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    	local configId;
		for k, v in ipairs(heroHouseProxy.generalArray) do
			if v.Level >= 15 then
				configId = v.ConfigId;
				break;
			end
		end
		local xPos, page = self:getXPosByConfigId(configId);--19是谢绮
     	openTutorUI({x=xPos , y=87, width = 151, height = 554, alpha = 125});
     	if page > 1 then
			heroHousePopupMediator:setCurrentPage(page)
     	end
    end

	hecDC(3,4,1);
end

function MainSceneToHeroHouseCommand:getXPosByConfigId(configId)
	local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
	local generalArr = heroHouseProxy:getGeneralArray4HeroHouse();
	local index = 0;
	local isPlay = 1;
	for k, v in ipairs(generalArr) do
		index = index + 1;
		if v.ConfigId == configId then--宫羽
			isPlay = v.IsPlay;
			break;
		end
	end

	local page = math.ceil(index/6);
	local pageFix = (index - 1)%6;

	return 116 + 181 * pageFix, page
end


function MainSceneToHeroHouseCommand:registerHeroHouseCommands()
	self:registerCommand(HeroHouseNotifications.HEROHOUSE_CLOSE, HeroHouseCloseCommand);
	self:registerCommand(HeroHouseNotifications.HEROHOUSE_INIT, HeroHouseInitCommand);
	self:registerCommand(HeroHouseNotifications.HEROHOUSE_CHECKCARD, HeroHouseCheckCardCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
end

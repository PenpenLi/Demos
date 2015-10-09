require "main.view.hero.heroTeam.HeroTeamSubMediator";
require "main.controller.command.hero.HeroTeamSubCloseCommand";
require "main.controller.command.hero.HeroHouseJoinWarCommand";
require "main.controller.command.hero.HeroHouseQuitWarCommand";
require "main.controller.notification.HeroHouseNotification";

MainSceneToHeroTeamSubCommand=class(Command);

function MainSceneToHeroTeamSubCommand:ctor()
	self.class=MainSceneToHeroTeamSubCommand;
end

function MainSceneToHeroTeamSubCommand:execute(notification)
	local heroTeamSubMediator=self:retrieveMediator(HeroTeamSubMediator.name);
	if not heroTeamSubMediator then
		heroTeamSubMediator=HeroTeamSubMediator.new();
		self:registerMediator(heroTeamSubMediator:getMediatorName(),heroTeamSubMediator);
		self:registerHeroHouseCommands();
	end
	-- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(heroTeamSubMediator:getViewComponent());
	self:observe(HeroTeamSubCloseCommand);
	heroTeamSubMediator:initializeUI(notification.data);
	LayerManager:addLayerPopable(heroTeamSubMediator:getViewComponent());

  if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
    if GameVar.tutorStage == TutorConfig.STAGE_1027 then
       openTutorUI({x=1028, y=374, width = 92, height = 92, alpha = 125});--1075,0
    elseif  GameVar.tutorStage == TutorConfig.STAGE_1002 or  GameVar.tutorStage == TutorConfig.STAGE_1026 then
       openTutorUI({x=1075, y=0, width = 130, height = 144, alpha = 125});--1075,0
    elseif GameVar.tutorStage == TutorConfig.STAGE_1003 or GameVar.tutorStage == TutorConfig.STAGE_1006 then
       local xPos, yPos;
       local width, height;
       local totalCount = self:getTotalGeneralCount()

       local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
       local generalData = heroHouseProxy:getPeibingPeizhi(1)
       if generalData then
         local count = #generalData.GeneralIdArray;
         print("+++++++++++++++++++++++++++++++++++++++++++count",count)
         if totalCount == count then
           xPos, yPos = 1075,0;
           width, height = 130,144
           GameVar.tutorSmallStep = 100315;
         else
           if GameVar.tutorStage == TutorConfig.STAGE_1003 then
              xPos, yPos = self:getGeneralPosByConfigId(10)--16是言豫津
           elseif GameVar.tutorStage == TutorConfig.STAGE_1006 then
              xPos, yPos = self:getGeneralPosByConfigId(77)--16是言豫津
           end 
           width, height = 116,110
         end
         openTutorUI({x=xPos, y=yPos, width = width, height = height, alpha = 125});
       end
    elseif GameVar.tutorStage ~= TutorConfig.STAGE_1024 then
       openTutorUI({x=1075, y=0, width = 130, height = 144, alpha = 125});--1075,0
    end
  end

end
function MainSceneToHeroTeamSubCommand:getGeneralPosByConfigId(configId)
  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);

    local datas = heroHouseProxy:getGeneralArrayWithPlayer();
    local index = 0;
    local xPos = 0
    local yPos = 0
    for k, v in ipairs(datas) do
      index = index + 1;
      if v.ConfigId == configId then
        xPos = 2+(-1+index)%2*142
        yPos = 350-175*math.floor((-1+index)/2)
      end
    end
    print("==============================xPos, yPos", xPos, yPos)
  return xPos+110, yPos+127;
end
function MainSceneToHeroTeamSubCommand:getTotalGeneralCount()
    local returnValue = 0;
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    local generalArray = heroHouseProxy:getGeneralArray()
    for key,generalVO in pairs(generalArray) do
        returnValue = returnValue + 1;
    end
    return returnValue;
end

function MainSceneToHeroTeamSubCommand:registerHeroHouseCommands()
	self:registerCommand(HeroHouseNotifications.HEROTEAMSUB_CLOSE, HeroTeamSubCloseCommand);
	-- require "main.controller.command.heroScene.HeroBankToDetailTipsCommand"
	-- require "main.controller.notification.HeroBankNotification"
	-- self:registerCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
	self:registerCommand(HeroHouseNotifications.HEROHOUSE_JOINWAR, HeroHouseJoinWarCommand);
	self:registerCommand(HeroHouseNotifications.HEROHOUSE_QUITWAR, HeroHouseQuitWarCommand);
end

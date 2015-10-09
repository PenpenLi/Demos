
require "main.controller.command.requireCommand.RequireCommand1";
require "main.controller.command.requireCommand.RequireCommand2";
require "main.controller.command.requireCommand.RequireCommand3";
require "main.controller.command.requireCommand.RequireCommand4";
require "main.controller.command.requireCommand.RequireCommand5";

Handler_3_2 = class(MacroCommand);

function Handler_3_2:execute()

  hecDC(2,60)


  -- if GameData.forceToUpdate then
  --   log("Handler_3_2-1");
  --   closeSocket();
  --   log("Handler_3_2-2");
  --   return;
  -- end


	self.userProxy = self:retrieveProxy(UserProxy.name)

  platformEnterGame(GameData.ServerId,GameData.platFormUserId,GameData.userName,self.userProxy:getLevel())

  --下载礼包加入功能开启
  -- local activityProxy= self:retrieveProxy(ActivityProxy.name);
  -- activityProxy:checkData4DownLoadByOpenFunction(openFunctionProxy);

  if not MainSceneToBattleCommand then
    print("MainSceneToBattleCommand is nil")
  end
  log("Handler_3_2-3");
  require "main.controller.command.mainScene.InitMainSceneCommand";     
  InitMainSceneCommand.new():execute();
  log("Handler_3_2-4");
  
  self:registerCommand(MainSceneNotifications.TO_BATTLE,MainSceneToBattleCommand);
  self:registerCommand(BattleSceneNotifications.TO_MAINSCENE,BattleToMainCommand); 
	log("Handler_3_2-5");


  if GameVar.tutorStage == TutorConfig.STAGE_1001 then
    require "main.controller.command.mainScene.MainSceneToBattleCommand";
    self:addSubCommand(MainSceneToBattleCommand)
    GameVar.tutorStage = TutorConfig.STAGE_1001;
    local data = {data={type = GameConfig.SCENE_TYPE_2,battleType = BattleConfig.BATTLE_TYPE_4}};
    self:complete(data)
  else
    EnterCityCommand.new():execute();
  end
  
  log("Handler_3_2-6");
  local i=1;
  local TOP_LEVEL=1;
  while true do
    local boo = analysisHas("Wujiang_Wujiangshengji",i);
    if not boo then
      ConstConfig.TOP_LEVEL=-1+i;
      --print("----------ConstConfig.TOP_LEVEL------------",ConstConfig.TOP_LEVEL);
      break
    end
    i = i+1;
  end
  log("Handler_3_2-7");
end

Handler_3_2.new():execute();
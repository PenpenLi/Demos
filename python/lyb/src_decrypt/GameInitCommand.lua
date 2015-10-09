require "main.common.AvatarUtil"
require "main.controller.command.mainScene.MainSceneToChatCommand";
require "main.controller.command.mainScene.MainSceneToSmallChatCommand";
-- require "main.controller.command.mainScene.MainSceneToLoginLotteryCommand";
-- require "main.controller.command.turntable.TurntableNoticeCommand";
-- require "main.model.BulletinBoardProxy"

GameInitCommand=class(MacroCommand);

function GameInitCommand:ctor()
	self.class=GameInitCommand;
end

function GameInitCommand:execute()
  
  local userProxy = self:retrieveProxy(UserProxy.name)
  local bagProxy = self:retrieveProxy(BagProxy.name)
  local generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  userProxy.hasInit = true;
  GameData.hasInit = true;
  
  self:addSubCommand(MainSceneToSmallChatCommand);
  self:complete();
end

function GameInitCommand:initializeChat()
  --self:addSubCommand(MainSceneToChatCommand);
  -- self:addSubCommand(MainSceneToSmallChatCommand);
  --关闭初始化转盘
  --self:addSubCommand(TurntableNoticeCommand);
  self:addSubCommand(MainSceneToFirstSevenCommand);
  -- self:addSubCommand(MainSceneToLoginLotteryCommand);
  local bulletinBoardProxy = self:retrieveProxy(BulletinBoardProxy.name);
  if bulletinBoardProxy then
    if not bulletinBoardProxy:getBooleanValue() then
      self:addSubCommand(BulletinBoardOpenCommand);
    end
  end
  self:complete();
  --self:retrieveMediator(ChatPopupMediator.name):getViewComponent():onCloseButtonTap();
end
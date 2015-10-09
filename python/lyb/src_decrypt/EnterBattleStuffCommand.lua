--[[
	进战场前需要移除的东西
    @zhangke
]]

EnterBattleStuffCommand=class(MacroCommand);

function EnterBattleStuffCommand:ctor()
	self.class=EnterBattleStuffCommand;
end

function EnterBattleStuffCommand:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	if battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 then return end
	self:uninitializeChat();
	self:uninitializeSmallChat();
	self:addSubCommand(TutorCloseCommand)
	self:complete();

	self:removeBetterEquipLayers();
	self:cutDown();
	--sharedTextAnimateReward():disposeTextAnimateReward();
end

function EnterBattleStuffCommand:removeBetterEquipLayers()
	BetterEquipManager:removeLayers();
end

function EnterBattleStuffCommand:uninitializeChat()
  require "main.controller.command.chat.ChatCloseCommand";
  self:addSubCommand(ChatCloseCommand);
end

function EnterBattleStuffCommand:uninitializeSmallChat()
  require "main.controller.command.smallChat.SmallChatCloseCommand";
  self:addSubCommand(SmallChatCloseCommand);
end

DataInitializeCommand3=class(MacroCommand);

function DataInitializeCommand3:ctor()
	self.class=DataInitializeCommand3;
end

function DataInitializeCommand3:execute()

  self:requireCommand();

  self:addSubCommand(StoryLineDataInitialize);
  -- self:addSubCommand(TowerDataInitialize);
  self:addSubCommand(CountControlInitialize);
  -- self:addSubCommand(LoadingDataInitialize);
  -- self:addSubCommand(ARewardTaskDataInitialize);
  -- self:addSubCommand(EverydayTaskDataInitialize);
  -- self:addSubCommand(PrincessDataInitialize);
  self:addSubCommand(ChatListInitialize);
  self:addSubCommand(BuddyListInitialize);
  -- self:addSubCommand(AvatarDataInitialize);
  
  self:complete();
end

function DataInitializeCommand3:requireCommand()
	require "main.controller.command.data.StoryLineDataInitialize";
	-- require "main.controller.command.data.TowerDataInitialize";
	require "main.controller.command.data.CountControlInitialize";
	-- require "main.controller.command.data.LoadingDataInitialize";
	-- require "main.controller.command.data.PrincessDataInitialize";
	-- require "main.controller.command.data.ARewardTaskDataInitialize";
	-- require "main.controller.command.data.EverydayTaskDataInitialize";
	require "main.controller.command.data.ChatListInitialize";
	require "main.controller.command.data.BuddyListInitialize";
	-- require "main.controller.command.data.AvatarDataInitialize";
end
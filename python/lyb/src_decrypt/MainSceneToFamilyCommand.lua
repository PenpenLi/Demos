require "main.view.family.BangpaiMediator";

MainSceneToFamilyCommand=class(Command);

function MainSceneToFamilyCommand:ctor()
	self.class=MainSceneToFamilyCommand;
end

function MainSceneToFamilyCommand:execute()
  self:require();  
  --BangpaiMediator
  self.bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
  if self.bangpaiMediator then
    return;
  end
  if nil==self.bangpaiMediator then
    self.bangpaiMediator=BangpaiMediator.new();
    self:registerMediator(self.bangpaiMediator:getMediatorName(),self.bangpaiMediator);
    
    self:registerCommands();
  end

  -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.familyMediator:getViewComponent());
  self:observe(FamilyCloseCommand);
  LayerManager:addLayerPopable(self.bangpaiMediator:getViewComponent());
end

function MainSceneToFamilyCommand:registerCommands()
  -- self:registerCommand(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,RequestNoneFamilyLayerDataCommand);
  -- self:registerCommand(FamilyNotifications.LOOK_INTO_FAMILY,LookIntoFamilyCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_APPLY,FamilyApplyCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_FOUND,FamilyFoundCommand);

  -- self:registerCommand(FamilyNotifications.FAMILY_LEVEL_UP,FamilyLevelUpCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_DISMISS,FamilyDismissCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_TO_AGORA,FamilyToAgoraCommand);
  -- self:registerCommand(FamilyNotifications.REQUEST_FAMILY_MEMBER_ARRAY,RequestFamilyMemberArrayCommand);
  -- self:registerCommand(FamilyNotifications.REQUEST_FAMILY_APPLY_ARRAY,RequestFamilyApplyArrayCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_VERIFY,FamilyVerifyCommand);
  -- self:registerCommand(FamilyNotifications.REQUEST_FAMILY_LOG,RequestFamilyLogCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_STAND_SELECT,FamilyStandSelectCommand);
  -- --self:registerCommand(FamilyNotifications.FAMILY_INVITE,FamilyInviteCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_CHANGE_POSITIONID,FamilyChangePositionIDCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_KICK,FamilyKickCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_CHANGE_NOTICE,FamilyChangeNoticeCommand);
  -- self:registerCommand(FamilyNotifications.FAMILY_DONATE,FamilyDonateCommand);

  -- self:registerCommand(FamilyNotifications.FAMILY_ACTIVITY_ACTIVATE,FamilyActivityActivateCommand);

  -- self:registerCommand(FamilyNotifications.FAMILY_IMPEACH,FamilyImpeachCommand);
  -- self:registerCommand(FamilyNotifications.REQUEST_FAMILY_BOSS_RANK_DATA,FamilyRequestBossRankDataCommand);
  self:registerCommand(FamilyNotifications.FAMILY_CLOSE,FamilyCloseCommand);
  self:registerCommand(FamilyNotifications.FAMILY_BANQUET_COMMAND,FamilyBanquetCommand);
  self:registerCommand(FamilyNotifications.FAMILY_HOLD_BANQUET_COMMAND,FamilyHoldBanquetCommand);
  log("---------------------MainSceneToFamilyCommand----registerd");
end

function MainSceneToFamilyCommand:require()
  -- require "main.controller.command.family.RequestNoneFamilyLayerDataCommand";
  -- require "main.controller.command.family.LookIntoFamilyCommand";
  -- require "main.controller.command.family.FamilyApplyCommand";
  -- require "main.controller.command.family.FamilyFoundCommand";

  -- require "main.controller.command.family.FamilyLevelUpCommand";
  -- require "main.controller.command.family.FamilyDismissCommand";
  -- require "main.controller.command.family.FamilyToAgoraCommand";
  -- require "main.controller.command.family.RequestFamilyMemberArrayCommand";
  -- require "main.controller.command.family.RequestFamilyApplyArrayCommand";
  -- require "main.controller.command.family.FamilyVerifyCommand";
  -- require "main.controller.command.family.RequestFamilyLogCommand";
  -- require "main.controller.command.family.FamilyStandSelectCommand";
  -- require "main.controller.command.family.FamilyInviteCommand";
  -- require "main.controller.command.family.FamilyChangePositionIDCommand";
  -- require "main.controller.command.family.FamilyKickCommand";
  -- require "main.controller.command.family.FamilyChangeNoticeCommand";
  -- require "main.controller.command.family.FamilyDonateCommand";

  -- require "main.controller.command.family.FamilyActivityActivateCommand";
  -- require "main.controller.command.family.FamilyImpeachCommand";
  -- require "main.controller.command.family.FamilyRequestBossRankDataCommand";
  require "main.controller.command.family.FamilyCloseCommand";
  require "main.controller.command.family.FamilyBanquetCommand";--TODO YinHao
  require "main.controller.command.family.FamilyHoldBanquetCommand";--TODO YinHao
end
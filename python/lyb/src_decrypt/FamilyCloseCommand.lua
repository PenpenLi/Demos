--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-11-4

	yanchuan.xie@happyelements.com
]]

FamilyCloseCommand=class(Command);

function FamilyCloseCommand:ctor()
	self.class=FamilyCloseCommand;
end

function FamilyCloseCommand:execute(notification)
  local familyProxy=self:retrieveProxy(FamilyProxy.name);
  familyProxy:setData();
  
  self:removeMediator(BangpaiMediator.name);
  -- self:removeCommand(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,RequestNoneFamilyLayerDataCommand);
  -- self:removeCommand(FamilyNotifications.LOOK_INTO_FAMILY,LookIntoFamilyCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_APPLY,FamilyApplyCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_FOUND,FamilyFoundCommand);

  -- self:removeCommand(FamilyNotifications.FAMILY_LEVEL_UP,FamilyLevelUpCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_DISMISS,FamilyDismissCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_TO_AGORA,FamilyToAgoraCommand);
  -- self:removeCommand(FamilyNotifications.REQUEST_FAMILY_MEMBER_ARRAY,RequestFamilyMemberArrayCommand);
  -- self:removeCommand(FamilyNotifications.REQUEST_FAMILY_APPLY_ARRAY,RequestFamilyApplyArrayCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_VERIFY,FamilyVerifyCommand);
  -- self:removeCommand(FamilyNotifications.REQUEST_FAMILY_LOG,RequestFamilyLogCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_STAND_SELECT,FamilyStandSelectCommand);
  -- --self:removeCommand(FamilyNotifications.FAMILY_INVITE,FamilyInviteCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_CHANGE_POSITIONID,FamilyChangePositionIDCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_KICK,FamilyKickCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_CHANGE_NOTICE,FamilyChangeNoticeCommand);
  -- self:removeCommand(FamilyNotifications.FAMILY_DONATE,FamilyDonateCommand);

  -- self:removeCommand(FamilyNotifications.FAMILY_ACTIVITY_ACTIVATE,FamilyActivityActivateCommand);

  -- self:removeCommand(FamilyNotifications.FAMILY_IMPEACH,FamilyImpeachCommand);
  -- self:removeCommand(FamilyNotifications.REQUEST_FAMILY_BOSS_RANK_DATA,FamilyRequestBossRankDataCommand);
  self:removeCommand(FamilyNotifications.FAMILY_CLOSE,FamilyCloseCommand);
  self:unobserve(FamilyCloseCommand);
end
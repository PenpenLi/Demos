--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-11-4

	yanchuan.xie@happyelements.com
]]

FamilyNotifications={REQUEST_NONE_FAMILY_LAYER_DATA="requestNoneFamilyLayerData",
					 LOOK_INTO_FAMILY="lookIntoFamily",
					 FAMILY_APPLY="familyApply",
					 FAMILY_FOUND="familyFound",

					 FAMILY_LEVEL_UP="familyLevelup",
					 FAMILY_DISMISS="familyDismiss",
					 FAMILY_TO_AGORA="familyToAgora",
					 REQUEST_FAMILY_MEMBER_ARRAY="requestFamilyMemberArray",
					 REQUEST_FAMILY_APPLY_ARRAY="requestFamilyApplyArray",
					 FAMILY_VERIFY="familyVerify",
					 REQUEST_FAMILY_LOG="requestFamilyLog",
					 FAMILY_STAND_SELECT="familyFamilySelect",
					 FAMILY_INVITE="familyInvite",
					 FAMILY_CHANGE_POSITIONID="familyChangePositionID",
					 FAMILY_KICK="familyKick",
					 FAMILY_CHANGE_NOTICE="familyChangeNotice",
					 FAMILY_DONATE="familyDonate",

					 FAMILY_ACTIVITY_ACTIVATE="familyActivityActivate",

					 FAMILY_IMPEACH="familyImpeach",
					 REQUEST_FAMILY_BOSS_RANK_DATA="requestFamilyBossRankData",
					 FAMILY_BANQUET_COMMAND="FamilyBanquetCommand",
 					 FAMILY_BANQUET_CLOSE_COMMAND="FamilyBanquetCloseCommand",
 					 FAMILY_HOLD_BANQUET_COMMAND="FamilyHoldBanquetCommand",
 					 FAMILY_HOLD_BANQUET_CLOSE_COMMAND="FamilyHoldBanquetCloseCommand",
                     FAMILY_CLOSE="familyClose"};

FamilyNotification=class(Notification);

function FamilyNotification:ctor(type_string,data)
	self.class = FamilyNotification;
	self.type = type_string;
  	self.data = data;
end

function FamilyNotification:getData()
  return self.data;
end
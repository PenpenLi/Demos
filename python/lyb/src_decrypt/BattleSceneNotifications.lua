--[[
  battleScene notificaiton 
  @zhangke
  ]]
BattleSceneNotifications={
                          TO_LOTTERY="TO_LOTTERY",
                          TO_MAINSCENE="TO_MAINSCENE",
                          CLOSE_LOTTERY_MEDIATOR="CLOSE_LOTTERY_MEDIATOR",
                          CLOSE_BATTLEOVER_MEDIATOR="CLOSE_BATTLEOVER_MEDIATOR",
                          SEND_MESSAGE_FOR_CHARGE_BOX="SEND_MESSAGE_FOR_CHARGE_BOX",
                          BATTLE_DIALOG_OVER="BATTLE_DIALOG_OVER",
                          BATTLE_WORLDBOSS_CLOSE="BATTLE_WORLDBOSS_CLOSE",
                          Battle_BeAttack="Battle_BeAttack",
                          Battle_UnitID_Dead="Battle_UnitID_Dead",
                          Battle_UnitID_Hurt="Battle_UnitID_Hurt",
                          BATTLE_WUSHUANG_CLOSE="BATTLE_WUSHUANG_CLOSE",
                          BATTLE_PVPFIVE_CLOSE="BATTLE_PVPFIVE_CLOSE",
                          TO_GREENHAND_BATTLE = "TO_GREENHAND_BATTLE",
                          BATTLE_OVER_COMMADN = "BATTLE_OVER_COMMADN",
                          BATTLE_MIDDLE_DIALOG = "BATTLE_MIDDLE_DIALOG",
                          BATTLE_EXIT = "BATTLE_EXIT",
                          };

BattleSceneNotification=class(Notification);

function BattleSceneNotification:ctor(type_string,data)
	self.class = BattleSceneNotification;
	self.type = type_string;
  self.data = data;
end
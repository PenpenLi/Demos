#ifndef MOF_SYNCFIGHTINGMGR_H
#define MOF_SYNCFIGHTINGMGR_H

class SyncFightingMgr{
public:
	void reqLeaveSyncScene(void);
	void setSceneInstID(int);
	void getBattleTime(void)const;
	void getBattleTime(void);
	void removeMonserFromSyncScene(int);
	void SyncFightingMgr(void);
	void reqSyncSkill(LivingObject *,	int);
	void ackSyncMotion(ack_sync_motion);
	void clearSyncFightingData(void);
	void ackLeaveSyncScene(ack_leave_world_scene);
	void notifySyncBeSkill(notify_sync_beskill);
	void reqSyncMotion(int,cocos2d::CCPoint,cocos2d::CCPoint);
	void networkStucked(void);
	void isMyPet(int);
	void notifySyncPvpEnd(notify_sync_pvp_end);
	void ~SyncFightingMgr();
	void notifySyncBeAttack(notify_sync_beatk);
	void isEmenyClear(void);
	void ackSyncAttack(ack_sync_attack);
	void setMyPetData(obj_worldpet_info,obj_pos_info);
	void setMyselfData(obj_worldrole_info,obj_pos_info);
	void removeRoleFromSyncScene(int);
	void notifySyncPvpStart(notify_sync_pvp_start);
	void getObj4SyncID(int);
	void notifySyncChangeSpeed(notify_sync_changespeed);
	void notifyRoleLeaveTreasureFightScene(notify_sync_treasurefight_player_leave);
	void reqSyncAttack(LivingObject *, int);
	void notifyNewMonsters(notify_worldnpc_enter_scene);
	void reqSyncSkill(LivingObject *,int);
	void getSceneModID(void)const;
	void reqPing(void);
	void addRole2Scene(obj_worldrole_info,obj_pos_info);
	void reqSyncAttack(LivingObject *,int);
	void notifyNewRoles(notify_new_roles);
	void setSceneModID(int);
	void notifySyncSkill(notify_sync_skill);
	void ackSyncStop(ack_sync_stop);
	void addMonster2Scene(obj_worldnpc_info, obj_pos_info);
	void notifySyncAttack(notify_sync_attack);
	void ackPing(ack_ping);
	void syncFightingGiveUp(void);
	void setBattleTime(int);
	void setMyselfData(obj_worldrole_info, obj_pos_info);
	void notifySyncMotion(notify_sync_motion);
	void setMyPetData(obj_worldpet_info, obj_pos_info);
	void ackSyncSkill(ack_sync_skill);
	void getSceneModID(void);
	void getName4SyncID(int);
	void NotifyObjectsPos(notify_objects_pos);
	void isMyself(int);
	void addPet2Scene(obj_worldpet_info, obj_pos_info);
	void reqSyncStop(int);
	void notifyRoleLeaveScene(notify_worldplayer_leave_scene);
	void ackgetSceneObjects(ack_get_scene_objects);
	void ackEnterWorldSecne(ack_enter_world_scene);
	void reqSyncMotion(int, cocos2d::CCPoint,	cocos2d::CCPoint);
	void notifySyncStop(notify_sync_stop);
	void addPet2Scene(obj_worldpet_info,obj_pos_info);
	void addRole2Scene(obj_worldrole_info, obj_pos_info);
	void notifySyncDamage(notify_sync_damage);
	void addMonster2Scene(obj_worldnpc_info,obj_pos_info);
	void refreshPing(float);
	void getRole4SyncID(int);
}
#endif
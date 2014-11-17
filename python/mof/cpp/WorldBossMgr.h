#ifndef MOF_WORLDBOSSMGR_H
#define MOF_WORLDBOSSMGR_H

class WorldBossMgr{
public:
	void setBoss(WorldBoss *);
	void notifyWorldBossFail(notify_boss_fail);
	void setElansTime(float);
	void setWaitTime(int);
	void WorldBossMgr(void);
	void notifyOtherPlayerList(std::vector<obj_roleinfo,std::allocator<obj_roleinfo>>);
	void ackLeaveWorldBossScene(int,int);
	void notifyWorldBossHP(int);
	void notifyOtherPlayerList(std::vector<obj_roleinfo,	std::allocator<obj_roleinfo>>);
	void perSecTimer(float);
	void ackLeaveWorldBossScene(int, int);
	void reqLeaveWorldBossScene(void);
	void notifyWorldBossDead(notify_dead_boss);
	void reqEnterBossScene(int);
	void getWaitTime(void)const;
	void notifyAddOtherPlayer(obj_roleinfo);
	void getElansTime(void);
	void getWaitTime(void);
	void reqRoleBattleInfo(void);
	void ackEnterWorldBossScene(int,	int, float);
	void ackEnterWorldBossScene(int,int,int,int,int,float);
	void notifyRoleBattleInfo(notify_role_battle_info);
}
#endif
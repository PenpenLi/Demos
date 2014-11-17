#ifndef MOF_PVPMGR_H
#define MOF_PVPMGR_H

class PvPMgr{
public:
	void ackGetEnemysDatas(std::vector<obj_pvp_role,std::allocator<obj_pvp_role>>);
	void ~PvPMgr();
	void reqPvpResult(bool);
	void ackBeginPvp(ack_begin_pvp,int);
	void getEnemyInfo(int);
	void ackBeginPvp(ack_begin_pvp, int);
	void ackGetPvpData(int, int, std::vector<obj_pvp_role, std::allocator<obj_pvp_role>>, std::vector<obj_pvp_log, std::allocator<obj_pvp_log>>, int, int, int);
	void ackGetPvpData(int,int,std::vector<obj_pvp_role,std::allocator<obj_pvp_role>>,std::vector<obj_pvp_log,std::allocator<obj_pvp_log>>,int,int,int);
	void getEnemyData(void)const;
	void PvPMgr(void);
	void ackAwardResult(void);
	void getEnemyData(void);
	void ackGetEnemysDatas(std::vector<obj_pvp_role, std::allocator<obj_pvp_role>>);
	void chooseEnemy(int);
	void ackPvpResult(bool);
	void reqBeginPvp(int);
}
#endif
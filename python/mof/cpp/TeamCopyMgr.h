#ifndef MOF_TEAMCOPYMGR_H
#define MOF_TEAMCOPYMGR_H

class TeamCopyMgr{
public:
	void addFriendFight(int);
	void isFighted(int);
	void readyIntoTeamCopy(int,int);
	void isCopyFinished(int);
	void ackBeginTeamCopy(int, int, int, int, int, int, BattleProp, std::vector<int, std::allocator<int>>, obj_petBattleProp);
	void DelCopyIdFromFinish(int);
	void initMgr(std::vector<int,std::allocator<int>>,std::vector<int,std::allocator<int>>);
	void initMgr(std::vector<int,	std::allocator<int>>, std::vector<int, std::allocator<int>>);
	void resetMgr(void);
	void readyIntoTeamCopy(int, int);
	void getFriendData(void);
	void ackBeginTeamCopy(int,int,int,int,int,int,BattleProp,std::vector<int,std::allocator<int>>,obj_petBattleProp);
}
#endif
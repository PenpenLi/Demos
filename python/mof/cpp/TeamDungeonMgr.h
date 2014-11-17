#ifndef MOF_TEAMDUNGEONMGR_H
#define MOF_TEAMDUNGEONMGR_H

class TeamDungeonMgr{
public:
	void ackBeginTeamDungeon(int,int,int,int,int,int,BattleProp,std::vector<int,std::allocator<int>>,obj_petBattleProp);
	void ackBeginTeamDungeon(int, int,	int, int, int, int, BattleProp,	std::vector<int, std::allocator<int>>, obj_petBattleProp);
	void readyIntoTeamDungeon(int, int);
	void isNewFight(int);
	void getFriendData(void);
	void readyIntoTeamDungeon(int,int);
	void ackTeamDungeonData(ack_getfrienddunge_data const&);
	void ackFightedFriends(int,std::vector<int,std::allocator<int>>,int);
	void isFighted(int);
	void ~TeamDungeonMgr();
	void setLeftTimes(int);
	void TeamDungeonMgr(void);
	void getRoleUponTime(void)const;
	void resetTeamDungeonData(ack_friendDunge_reset const&);
	void getLeftTimes(void);
	void getLeftTimes(void)const;
	void setRoleUponTime(int);
	void isHalfWayQuit(int);
	void getRoleUponTime(void);
	void getRecordByIndex(int);
	void ackFightedFriends(int, std::vector<int, std::allocator<int>>,	int);
	void reqFightedFrineds(void);
}
#endif
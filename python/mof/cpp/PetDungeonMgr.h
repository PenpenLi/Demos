#ifndef MOF_PETDUNGEONMGR_H
#define MOF_PETDUNGEONMGR_H

class PetDungeonMgr{
public:
	void ackFightedFriends(int,std::vector<int,std::allocator<int>>);
	void ackBeginPetDungeon(int, int, int, int,	int, int, BattleProp, std::vector<int, std::allocator<int>>, obj_petBattleProp);
	void reqFightedFrineds(void);
	void isFighted(int);
	void ackBeginPetDungeon(int,int,int,int,int,int,BattleProp,std::vector<int,std::allocator<int>>,obj_petBattleProp);
	void readyIntoPetDungeon(int, int);
	void readyIntoPetDungeon(int,int);
	void ackFightedFriends(int,	std::vector<int, std::allocator<int>>);
	void getFriendData(void);
}
#endif
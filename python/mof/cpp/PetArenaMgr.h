#ifndef MOF_PETARENAMGR_H
#define MOF_PETARENAMGR_H

class PetArenaMgr{
public:
	void getRank(void);
	void getLosetimes(void);
	void getLosetimes(void)const;
	void getEnemyRank(void)const;
	void ackPetArenaResult(ack_commit_petpvp_battle_report);
	void reqGetMyPetList(void);
	void getPvpLvl(void);
	void ackBuyItem(int, int);
	void ackEditPetFormation(int,std::vector<int,std::allocator<int>>);
	void getArenaLvl(void);
	void petArenaLose(void);
	void setMyAllPetsHP(int);
	void setPvpLvl(int);
	void getPoint(void);
	void enterPetArena(void);
	void setPvptimes(int);
	void getMyAllPetsHP(void)const;
	void reqSearchPetArenaEnemy(int);
	void reqBuyItem(int, int);
	void getEnemyAllPetsHP(void)const;
	void ackSearchPetArenaEnemy(ack_search_petpvp_enemy);
	void petArenaGiveUp(void);
	void getEnemyRank(void);
	void getArenaLvl(void)const;
	void setEnemyAllPetsHP(int);
	void ackEditPetFormation(int,	std::vector<int, std::allocator<int>>);
	void getRank(void)const;
	void setPoint(int);
	void setRank(int);
	void setWintimes(int);
	void petArenaWin(void);
	void setArenaLvl(int);
	void setLosetimes(int);
	void setEnemyRank(int);
	void getMyAllPetsHP(void);
	void getPvptimes(void);
	void PetArenaMgr(void);
	void getMyPetsHP(void);
	void reqBuyItem(int,int);
	void reqEditPetFormation(std::vector<int, std::allocator<int>>);
	void getEnemyPetsHP(void);
	void getPvptimes(void)const;
	void getPvpLvl(void)const;
	void ackBuyItem(int,int);
	void getPoint(void)const;
	void getWintimes(void);
	void getWintimes(void)const;
	void reqGetPetArenaData(void);
	void ~PetArenaMgr();
	void getEnemyAllPetsHP(void);
	void reqBeginPetArena(void);
	void ackGetPetArenaData(ack_get_petpvp_data);
	void ackBeginPetArena(int);
	void reqEditPetFormation(std::vector<int,std::allocator<int>>);
}
#endif
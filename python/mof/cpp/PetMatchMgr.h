#ifndef MOF_PETMATCHMGR_H
#define MOF_PETMATCHMGR_H

class PetMatchMgr{
public:
	void ackPetMatchCasinoThief(int);
	void reqPetMatchCasinoThief(void);
	void ackPetDatas(int,	std::vector<obj_casino_pet, std::allocator<obj_casino_pet>>, std::vector<std::string, std::allocator<std::string>>, int, int, std::vector<int, std::allocator<int>>, int);
	void reqPetMatchDatas(void);
	void ~PetMatchMgr();
	void ackPetMatchCasinoWager(int, int,	int);
	void reqPetMatchCasinoWager(int,int,int);
	void reqPetMatchCasinoWager(int, int,	int);
	void PetMatchMgr(void);
	void ackCurrentHistory(std::string);
	void ackPetDatas(int,std::vector<obj_casino_pet,std::allocator<obj_casino_pet>>,std::vector<std::string,std::allocator<std::string>>,int,int,std::vector<int,std::allocator<int>>,int);
	void getPetMatchDataByPetId(int);
	void reqCurrentHistory(void);
	void clearData(void);
	void ackPetMatchCasinoWager(int,int,int);
}
#endif
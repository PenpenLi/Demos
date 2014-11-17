#ifndef MOF_PETELITEMGR_H
#define MOF_PETELITEMGR_H

class PetEliteMgr{
public:
	void getPetNeedNum(void);
	void setPetDeadedState(int);
	void ackIntoPetEliteCopy(int,	int);
	void petEliteActivityIsFail(void);
	void petIsDead(int);
	void petHasFighted(int);
	void getCameraControlObj(void);
	void setPetNeedNum(int);
	void getCurPetListSize(void);
	void reqLeavePetEliteCopy(bool, int, int, int);
	void reqIntoPetEliteCopy(int);
	void reqShowPetEliteUI(void);
	void fillHasFightedPet(std::vector<int, std::allocator<int>> &);
	void getPetNeedNum(void)const;
	void ackIntoPetEliteCopy(int,int);
	void bHaveThisPet(int);
	void fillHasFightedPet(std::vector<int,std::allocator<int>> &);
	void getPetBeFight(int);
	void ackShowPetEliteUI(ack_get_petidlist_copy	const&);
	void reqLeavePetEliteCopy(bool,int,int,int);
	void PetEliteMgr(void);
	void getCurPetList(void);
	void holdPetBeFight(int);
}
#endif
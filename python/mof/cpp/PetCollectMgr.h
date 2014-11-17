#ifndef MOF_PETCOLLECTMGR_H
#define MOF_PETCOLLECTMGR_H

class PetCollectMgr{
public:
	void ackIllustrationsReward(int, int, int);
	void getAllPetCollectData(void);
	void getPetCollectDatasByType(IllustrationsType);
	void ackIllustrationsList(std::vector<obj_illustrationsInfo, std::allocator<obj_illustrationsInfo>>);
	void notifyIllustrationsReward(int,int);
	void reqIllustrationsReward(int, int);
	void getPetCollectInforByID(int);
	void notifyIllustrationsReward(int,	int);
	void reqIllustrationsReward(int,int);
	void ackIllustrationsList(std::vector<obj_illustrationsInfo,std::allocator<obj_illustrationsInfo>>);
	void ackIllustrationsReward(int,int,int);
}
#endif
#ifndef MOF_CHECKPLAYERMGR_H
#define MOF_CHECKPLAYERMGR_H

class CheckPlayerMgr{
public:
	void getPlayerFashions(void);
	void reqPersonAttribute(int, bool);
	void ackPersonAttribute(int,BaseProp,BattleProp,long,std::string,Constellation,std::string,int,int,int,int,int,int,int,int,int,std::vector<int,std::allocator<int>>,int);
	void ackPersonAttribute(int, BaseProp, BattleProp,	long, std::string, Constellation, std::string, int, int, int, int, int,	int, int, int, int, std::vector<int, std::allocator<int>>, int);
	void ackPetAttribute(obj_check_pet_prop,int);
	void ackPetAttribute(obj_check_pet_prop, int);
	void ~CheckPlayerMgr();
	void reqPersonAttribute(int,bool);
	void CheckPlayerMgr(void);
	void reqPetAttribute(int);
}
#endif
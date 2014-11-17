#ifndef MOF_ORDINARYACTIVITYCFG_H
#define MOF_ORDINARYACTIVITYCFG_H

class OrdinaryActivityCfg{
public:
	void getMaxPetActivity(void);
	void getTotalPetActIds(void);
	void getSortedPetActDatas(std::vector<int,std::allocator<int>>);
	void getMaxEquipActivity(void);
	void getSortedEquipActDatas(std::vector<int, std::allocator<int>>);
	void getSortedPetActDatas(std::vector<int, std::allocator<int>>);
	void getTotalEquipActIds(void);
	void getSortedEquipActDatas(std::vector<int,std::allocator<int>>);
	void load(std::string);
	void getEquiqActivityData(int);
	void getPetActivityData(int);
}
#endif
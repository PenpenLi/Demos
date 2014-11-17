#ifndef MOF_EQUIPFUSIONCFG_H
#define MOF_EQUIPFUSIONCFG_H

class EquipFusionCfg{
public:
	void getMaxLvl(int, int, int);
	void getCostGold(int, int,	int, int);
	void getReturnGold(int, int, int, int);
	void getNeedEquipCount(int,int,int,int);
	void getFusionEffect(int, int, int, int);
	void getFusionEffect(int,int,int,int);
	void getReturnGold(int,int,int,int);
	void load(std::string);
	void getNeedEquipCount(int, int, int, int);
	void getMaxLvl(int,int,int);
	void getCostGold(int,int,int,int);
}
#endif
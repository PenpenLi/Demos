#ifndef MOF_STARCFGNEW_H
#define MOF_STARCFGNEW_H

class StarCfgNew{
public:
	void getMaxLvl(int, int, int);
	void getUpgCost(int,int,int,int,int &,int &);
	void getEffect(int,int,int,int);
	void getSellGold(int,int,int,int);
	void getUpgCost(int, int, int,	int, int &, int	&);
	void getCostCfg(int, int, int);
	void getCostCfg(int,int,int);
	void getSellGold(int, int, int, int);
	void getEffect(int, int, int, int);
	void load(std::string,std::string);
	void getMaxLvl(int,int,int);
}
#endif
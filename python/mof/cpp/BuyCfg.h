#ifndef MOF_BUYCFG_H
#define MOF_BUYCFG_H

class BuyCfg{
public:
	void costTypeToMoneyName(int);
	void getLvlTimes(int, int);
	void getAddpoint(int);
	void getCost(int,int,std::string &);
	void getCost(int, int, std::string	&);
	void getCost(int, int, int	&);
	void getCost(int,int,int &);
	void load(std::string);
	void getLvlTimes(int,int);
}
#endif
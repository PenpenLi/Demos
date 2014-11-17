#ifndef MOF_HELPERCFG_H
#define MOF_HELPERCFG_H

class HelperCfg{
public:
	void load(std::string);
	void getHelperCfgListByType(int);
	void getHelperMenuSize(void);
	void getHelperMenuById(int);
}
#endif
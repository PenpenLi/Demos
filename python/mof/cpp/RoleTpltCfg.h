#ifndef MOF_ROLETPLTCFG_H
#define MOF_ROLETPLTCFG_H

class RoleTpltCfg{
public:
	void ~RoleTpltCfg();
	void stringToObjJob(std::string);
	void getMaxAnger(void);
	void setMaxAnger(int);
	void load(std::string);
	void stringToObjSex(std::string);
}
#endif
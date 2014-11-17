#ifndef MOF_CHARGEACTIVITYCFG_H
#define MOF_CHARGEACTIVITYCFG_H

class ChargeActivityCfg{
public:
	void load(std::string);
	void getCfg(int);
	void getCfgPlatform(int,std::string);
	void ~ChargeActivityCfg();
	void getCfgPlatform(int, std::string);
}
#endif
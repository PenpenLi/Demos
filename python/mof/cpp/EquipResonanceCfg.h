#ifndef MOF_EQUIPRESONANCECFG_H
#define MOF_EQUIPRESONANCECFG_H

class EquipResonanceCfg{
public:
	void load(std::string);
	void getQualityMapSize(void);
	void getDeepenMapSize(void);
	void getQualityDef(int);
	void getDeepenDef(int);
}
#endif
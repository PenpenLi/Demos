#ifndef MOF_PETASSISTCFG_H
#define MOF_PETASSISTCFG_H

class PetAssistCfg{
public:
	void getMaxPos(void);
	void getStagePropRatio(int,int);
	void getDescName(int);
	void getPetAssistDesc(void);
	void getPropName(int);
	void getLvlByPos(int);
	void getStagePropRatio(int, int);
	void load(std::string);
}
#endif
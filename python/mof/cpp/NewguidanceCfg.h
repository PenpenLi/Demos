#ifndef MOF_NEWGUIDANCECFG_H
#define MOF_NEWGUIDANCECFG_H

class NewguidanceCfg{
public:
	void getCfgByName(std::string);
	void getNewguidanceData(int, int, std::string);
	void getNewDateFromTask(void);
	void getLevelByName(std::string);
	void getSystemPrompt(int);
	void getArrowsPrompt(int);
	void load(std::string);
	void getCfg(int);
	void getNewguidanceData(int,int,std::string);
	void getParentGuidance(Newguidance	*);
	void getNewguidanceData(int);
}
#endif
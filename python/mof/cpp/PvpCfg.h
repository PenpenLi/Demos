#ifndef MOF_PVPCFG_H
#define MOF_PVPCFG_H

class PvpCfg{
public:
	void load(std::string);
	void getTimeout(void);
	void getRankAward(int);
	void getResultAward(bool);
}
#endif
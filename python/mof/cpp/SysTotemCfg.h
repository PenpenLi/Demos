#ifndef MOF_SYSTOTEMCFG_H
#define MOF_SYSTOTEMCFG_H

class SysTotemCfg{
public:
	void calculate(BattleProp &,std::map<int,int,std::less<int>,std::allocator<std::pair<int const,int>>>	&);
	void readInfo(IniFile	&,IniFile &);
	void getInfoLvl(int,int);
	void readGroup(IniFile &);
	void findGroupById(int);
	void calculate(BattleProp &, std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int>>> &);
	void ~SysTotemCfg();
	void configCheck(void);
	void readInfo(IniFile	&, IniFile &);
	void getInfoLvl(int, int);
	void getInfo(int);
}
#endif
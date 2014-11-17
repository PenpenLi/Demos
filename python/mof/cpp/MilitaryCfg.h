#ifndef MOF_MILITARYCFG_H
#define MOF_MILITARYCFG_H

class MilitaryCfg{
public:
	void load(std::string);
	void getNextMilitaryValue(void);
	void GetLastMilitary(uint const&);
	void GetLastMilitary(unsigned	int const&);
	void setPreMilitaryIter(int);
}
#endif
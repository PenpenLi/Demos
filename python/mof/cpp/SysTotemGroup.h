#ifndef MOF_SYSTOTEMGROUP_H
#define MOF_SYSTOTEMGROUP_H

class SysTotemGroup{
public:
	void getAddMaxHp(void);
	void getHit(void)const;
	void setAddMaxHp(int);
	void getHit(void);
	void isMeetGroup(std::map<int, int,	std::less<int>,	std::allocator<std::pair<int const, int>>> &);
	void getAtk(void);
	void getPropAddLevel(void);
	void getDodge(void)const;
	void setCri(float);
	void getDodge(void);
	void getAddMaxHp(void)const;
	void getDef(void)const;
	void setDodge(float);
	void setHit(float);
	void setAtk(int);
	void getCri(void)const;
	void getDef(void);
	void setDef(int);
	void SysTotemGroup(SysTotemGroup const&);
	void SysTotemGroup(void);
	void isMeetGroup(std::map<int,int,std::less<int>,std::allocator<std::pair<int const,int>>> &);
	void getCri(void);
}
#endif
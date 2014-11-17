#ifndef MOF_SYSTOTEMLVL_H
#define MOF_SYSTOTEMLVL_H

class SysTotemLvl{
public:
	void getHit(void)const;
	void getCri(void);
	void getDodge(void)const;
	void setCri(float);
	void SysTotemLvl(void);
	void getAddMaxHp(void);
	void SysTotemLvl(SysTotemLvl const&);
	void getHit(void);
	void getDodge(void);
	void getAddMaxHp(void)const;
	void getDef(void);
	void setAddMaxHp(int);
	void getDef(void)const;
	void setDodge(float);
	void setAtk(int);
	void setHit(float);
	void getAtk(void);
	void setDef(int);
	void getCri(void)const;
}
#endif
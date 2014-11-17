#ifndef MOF_EQUIPINFO_H
#define MOF_EQUIPINFO_H

class EquipInfo{
public:
	void setMaxmp(int);
	void getMaxmp(void)const;
	void getHit(void);
	void EquipInfo(EquipInfo const&);
	void getAtk(void);
	void getMaxhp(void)const;
	void getDodge(void)const;
	void setCri(float);
	void getDodge(void);
	void getDef(void)const;
	void setDodge(float);
	void setHit(float);
	void setAtk(int);
	void getCri(void)const;
	void getHit(void)const;
	void getDef(void);
	void setDef(int);
	void EquipInfo(void);
	void getMaxmp(void);
	void setMaxhp(int);
	void getMaxhp(void);
	void getCri(void);
}
#endif
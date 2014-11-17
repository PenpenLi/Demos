#ifndef MOF_HONORDEF_H
#define MOF_HONORDEF_H

class HonorDef{
public:
	void getAddMaxHp(void);
	void getAddMaxFat(void);
	void getDef(void);
	void setAddMaxHp(int);
	void getHit(void);
	void setDodge(float);
	void getAddMaxFat(void)const;
	void getAtk(void);
	void getStre(void)const;
	void getAddMaxHp(void)const;
	void getPhys(void)const;
	void getDodge(void)const;
	void getInte(void);
	void getDodge(void);
	void getCapa(void);
	void getInte(void)const;
	void getDef(void)const;
	void setPhys(int);
	void ~HonorDef();
	void getAtk(void)const;
	void setCapa(int);
	void HonorDef(HonorDef const&);
	void setHit(float);
	void setAtk(int);
	void getPhys(void);
	void getCri(void)const;
	void HonorDef(void);
	void setAddMaxFat(int);
	void getStre(void);
	void getHit(void)const;
	void setDef(int);
	void setCri(float);
	void setStre(int);
	void setInte(int);
	void getCri(void);
}
#endif
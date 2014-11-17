#ifndef MOF_CONSTELLSTEPDEF_H
#define MOF_CONSTELLSTEPDEF_H

class ConstellStepDef{
public:
	void setHp(int);
	void getAccDef(void);
	void getConPro(void)const;
	void setConPro(float);
	void setAccDef(int);
	void getAccCri(void)const;
	void getHit(void)const;
	void getCons(void)const;
	void getDef(void);
	void getHit(void);
	void setDodge(float);
	void getCons(void);
	void getAccDef(void)const;
	void getAtk(void);
	void setAccHp(int);
	void setConProAdd(float);
	void getDodge(void)const;
	void setCri(float);
	void setCons(int);
	void getAccAtk(void);
	void getHp(void);
	void getDodge(void);
	void setAccDodge(float);
	void getAccDodge(void)const;
	void getDef(void)const;
	void getAccCri(void);
	void getAccHit(void)const;
	void setAccHit(float);
	void getAtk(void)const;
	void setAccAtk(int);
	void getHp(void)const;
	void getAccHp(void);
	void ~ConstellStepDef();
	void setHit(float);
	void setAtk(int);
	void ConstellStepDef(ConstellStepDef const&);
	void setAccCri(float);
	void getCri(void)const;
	void getAccHit(void);
	void getConPro(void);
	void setDef(int);
	void getConProAdd(void);
	void getAccHp(void)const;
	void ConstellStepDef(void);
	void getConProAdd(void)const;
	void getCri(void);
	void getAccDodge(void);
	void operator=(ConstellStepDef const&);
}
#endif
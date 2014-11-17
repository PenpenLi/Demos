#ifndef MOF_BATTLEPROP_H
#define MOF_BATTLEPROP_H

class BattleProp{
public:
	void setHp(int);
	void getMaxHp(void)const;
	void setHpIncr(int);
	void BattleProp(BattleProp const&);
	void operator+=(BattleProp&);
	void getMoveSpeed(void)const;
	void getDef(void);
	void getHit(void);
	void getAtk(void);
	void calDamage(BattleProp*,int	&);
	void BattleProp(void);
	void setCri(float);
	void getHp(void);
	void getDodge(void);
	void calCriDamage(BattleProp*);
	void ~BattleProp();
	void setDodge(float);
	void getHpIncr(void)const;
	void calDamage(BattleProp*, int &);
	void getHpIncr(void);
	void getHp(void)const;
	void getMaxMp(void);
	void setHit(float);
	void setAtk(int);
	void setMoveSpeed(int);
	void getLvl(void)const;
	void setDef(int);
	void operator=(BattleProp const&);
	void setMaxMp(int);
	void setLvl(int);
	void getLvl(void);
	void getMaxMp(void)const;
	void setMaxHp(int);
	void getMoveSpeed(void);
	void getCri(void);
	void getMaxHp(void);
}
#endif
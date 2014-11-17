#ifndef MOF_BATTLEPROPMULTIFACTOR_H
#define MOF_BATTLEPROPMULTIFACTOR_H

class BattlePropMultiFactor{
public:
	void getHpIncrFactor(void);
	void getAtkFactor(void);
	void setLvlFactor(float);
	void getCriFactor(void);
	void getMoveSpeedFactor(void)const;
	void setCriFactor(float);
	void setDodgeFactor(float);
	void setHpIncrFactor(float);
	void getDodgeFactor(void)const;
	void getDefFactor(void);
	void getHitFactor(void)const;
	void setMaxMpFactor(float);
	void BattlePropMultiFactor(void);
	void setMoveSpeedFactor(float);
	void getMaxHpFactor(void);
	void setMaxHpFactor(float);
	void setAtkFactor(float);
	void getMaxHpFactor(void)const;
	void getDodgeFactor(void);
	void getDefFactor(void)const;
	void getHpIncrFactor(void)const;
	void getMoveSpeedFactor(void);
	void setDefFactor(float);
	void getHitFactor(void);
	void setHitFactor(float);
	void getCriFactor(void)const;
}
#endif
#ifndef MOF_ROLECFGDEF_H
#define MOF_ROLECFGDEF_H

class RoleCfgDef{
public:
	void setHp(int);
	void setMaxfriendly(int);
	void getEnerge(void)const;
	void setAtkSpeed(int);
	void setEnerge(int);
	void setDungfreeTimes(int);
	void setFriendDungeTimes(int);
	void getHpnum(void)const;
	void getMaxfriendly(void);
	void setHpper(float);
	void getMaxfriendly(void)const;
	void RoleCfgDef(void);
	void setWalkSpeed(int);
	void setPhys(int);
	void getHpper(void)const;
	void getExp(void);
	void setElitefreeTimes(int);
	void setExp(int);
	void setTowertimes(int);
	void setDodge(float);
	void setMpnum(int);
	void setCapa(int);
	void setPetElitefreeTimes(int);
	void setMp(int);
	void setHit(float);
	void getEnerge(void);
	void setAtk(int);
	void setCrip(float);
	void getHpper(void);
	void getHpnum(void);
	void setDef(int);
	void setCri(float);
	void RoleCfgDef(RoleCfgDef const&);
	void setHpnum(int);
	void setStre(int);
	void setInte(int);
	void ~RoleCfgDef();
}
#endif
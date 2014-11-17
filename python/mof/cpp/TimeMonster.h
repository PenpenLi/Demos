#ifndef MOF_TIMEMONSTER_H
#define MOF_TIMEMONSTER_H

class TimeMonster{
public:
	void ~TimeMonster();
	void getAliveTimer(void);
	void getAliveTimer(void)const;
	void escape(void);
	void setAliveTimer(int);
	void death(LivingObject *);
}
#endif
#ifndef MOF_CHARGEACTIVITYDEF_H
#define MOF_CHARGEACTIVITYDEF_H

class ChargeActivityDef{
public:
	void getStartTime(void);
	void getAwardType(void);
	void getStartTime(void)const;
	void getOverTime(void)const;
	void ChargeActivityDef(void);
	void setServerId(int);
	void setAwardType(int);
	void getAwards(void);
	void getServerId(void)const;
	void getActivityId(void);
	void ~ChargeActivityDef();
	void getAwardType(void)const;
	void getOverTime(void);
	void setStartTime(int);
	void setOverTime(int);
	void setActivityId(int);
	void getServerId(void);
}
#endif
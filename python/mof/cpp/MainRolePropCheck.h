#ifndef MOF_MAINROLEPROPCHECK_H
#define MOF_MAINROLEPROPCHECK_H

class MainRolePropCheck{
public:
	void MainRolePropCheck(void);
	void getTimeStamp(void)const;
	void endCheckMainRoleProp(void);
	void getTimeStamp(void);
	void ~MainRolePropCheck();
	void getLastServerTimer(void)const;
	void sendSkillHurts(float);
	void increaseTimeStamp(float);
	void setTimeStamp(int);
	void sendHeartBeat(float);
	void startCheckMainRoleProp(VerifyPropType);
	void setLastServerTimer(int);
	void saveServerTimeStamp(int);
	void getLastServerTimer(void);
	void sendProp(float);
}
#endif
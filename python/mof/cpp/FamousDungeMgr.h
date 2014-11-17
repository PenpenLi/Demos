#ifndef MOF_FAMOUSDUNGEMGR_H
#define MOF_FAMOUSDUNGEMGR_H

class FamousDungeMgr{
public:
	void ackFamousDungeData(int, int);
	void createTimer(void);
	void ackFamousList(ack_fameshall_fameslist);
	void ackEnterFamousDunge(int,int);
	void showTimerLabel(void);
	void getFamousData(int,int);
	void getCurWave(void);
	void FamousDungeMgr(void);
	void ackResult(ack_finish_famesHall);
	void famousDungeGiveUp(void);
	void ~FamousDungeMgr();
	void famousDungeFail(void);
	void getCurWave(void)const;
	void getFamousDungeCfgDef(int);
	void perSecTimer(float);
	void ackEnterFamousDunge(int, int);
	void clearFamousList(void);
	void getCurTimeLimit(void)const;
	void getCurTimeLimit(void);
	void famousDungeWin(void);
	void setCurTimeLimit(int);
	void getFamousData(int, int);
	void getFamousCfgDef(int,int);
	void setCurWave(int);
	void reqEnterFamousDunge(int);
	void reqFamousDungeData(void);
	void getFamousCfgDef(int, int);
	void deleteTimer(void);
	void ackFamousDungeData(int,int);
}
#endif
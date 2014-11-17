#ifndef MOF_DEFENDSTATUEMGR_H
#define MOF_DEFENDSTATUEMGR_H

class DefendStatueMgr{
public:
	void defendFail(void);
	void startDefendActivity(int);
	void getWaveSum(void)const;
	void reqDefendStatueTimes(void);
	void getUsedTime(void);
	void getUsedTime(void)const;
	void monsterWaveCleared(void);
	void ~DefendStatueMgr();
	void clearPreloadMonsterXmls(void);
	void monsterLaunch(int);
	void deleteLabel(void);
	void getCurWave(void);
	void getWaveSum(void);
	void setCurWave(int);
	void setEnterTimes(int);
	void getCurWave(void)const;
	void reqEnterDefendStatue(int,int);
	void setWaveSum(int);
	void ackDefendStatueTimes(int);
	void showWave(int);
	void getRandomPosInArea(cocos2d::CCRect,int,int);
	void getEnterTimes(void)const;
	void refreshLabel(float);
	void DefendStatueMgr(void);
	void getRandomPosInArea(cocos2d::CCRect, int, int);
	void reqEnterDefendStatue(int, int);
	void getEnterTimes(void);
	void defendSuccess(void);
	void defendGiveUp(void);
	void ackLeaveDefendStatue(int);
	void setUsedTime(int);
	void ackEnterDefendStatue(int);
}
#endif
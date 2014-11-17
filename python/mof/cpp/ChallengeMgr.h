#ifndef MOF_CHALLENGEMGR_H
#define MOF_CHALLENGEMGR_H

class ChallengeMgr{
public:
	void getWaveSum(void)const;
	void ackLeaveChallenge(int, int, int);
	void ChallengeMgr(void);
	void monsterWaveCleared(void);
	void startChallengeActivity(int);
	void clearPreloadMonsterXmls(void);
	void monsterLaunch(int);
	void deleteLabel(void);
	void getCurWave(void);
	void getWaveSum(void);
	void setCurWave(int);
	void setEnterTimes(int);
	void getCurWave(void)const;
	void challengeSuccess(void);
	void setWaveSum(int);
	void showWave(int);
	void getRandomPosInArea(cocos2d::CCRect,int,int);
	void getEnterTimes(void)const;
	void refreshLabel(float);
	void ackChallengeTimes(int);
	void ackLeaveChallenge(int,int,int);
	void getLeftTime(void);
	void setLeftTime(int);
	void reqChallengeTimes(void);
	void ackEnterChallenge(int, obj_batforce_brief);
	void reqNextWave(void);
	void getRandomPosInArea(cocos2d::CCRect, int, int);
	void getCurMonsterNum(void);
	void getLeftTime(void)const;
	void reqEnterChallenge(int, int);
	void ackEnterChallenge(int,obj_batforce_brief);
	void challengeFail(void);
	void getEnterTimes(void);
	void reqEnterChallenge(int,int);
	void challengeGiveUp(void);
	void ~ChallengeMgr();
}
#endif
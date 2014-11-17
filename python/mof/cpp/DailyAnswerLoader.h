#ifndef MOF_DAILYANSWERLOADER_H
#define MOF_DAILYANSWERLOADER_H

class DailyAnswerLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~DailyAnswerLoader();
}
#endif
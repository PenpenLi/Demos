#ifndef MOF_DAILYTASKUILOADER_H
#define MOF_DAILYTASKUILOADER_H

class DailyTaskUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~DailyTaskUILoader();
}
#endif
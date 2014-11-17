#ifndef MOF_ACTIVITYUILOADER_H
#define MOF_ACTIVITYUILOADER_H

class ActivityUILoader{
public:
	void ~ActivityUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif
#ifndef MOF_TASKUILOADER_H
#define MOF_TASKUILOADER_H

class TaskUILoader{
public:
	void ~TaskUILoader();
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif
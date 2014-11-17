#ifndef MOF_TASKDIALOGLOADER_H
#define MOF_TASKDIALOGLOADER_H

class TaskDialogLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void ~TaskDialogLoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif
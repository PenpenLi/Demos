#ifndef MOF_AUTOTESTUILOADER_H
#define MOF_AUTOTESTUILOADER_H

class AutoTestUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~AutoTestUILoader();
}
#endif
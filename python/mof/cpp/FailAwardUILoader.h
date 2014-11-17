#ifndef MOF_FAILAWARDUILOADER_H
#define MOF_FAILAWARDUILOADER_H

class FailAwardUILoader{
public:
	void ~FailAwardUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif
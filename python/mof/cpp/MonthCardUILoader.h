#ifndef MOF_MONTHCARDUILOADER_H
#define MOF_MONTHCARDUILOADER_H

class MonthCardUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void ~MonthCardUILoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif
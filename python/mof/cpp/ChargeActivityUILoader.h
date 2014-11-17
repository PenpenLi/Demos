#ifndef MOF_CHARGEACTIVITYUILOADER_H
#define MOF_CHARGEACTIVITYUILOADER_H

class ChargeActivityUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~ChargeActivityUILoader();
}
#endif
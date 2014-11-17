#ifndef MOF_BATTLESUCCESSUILOADER_H
#define MOF_BATTLESUCCESSUILOADER_H

class BattleSuccessUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~BattleSuccessUILoader();
}
#endif
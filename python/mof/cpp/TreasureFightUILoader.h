#ifndef MOF_TREASUREFIGHTUILOADER_H
#define MOF_TREASUREFIGHTUILOADER_H

class TreasureFightUILoader{
public:
	void ~TreasureFightUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif
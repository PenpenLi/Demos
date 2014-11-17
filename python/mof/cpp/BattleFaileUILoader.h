#ifndef MOF_BATTLEFAILEUILOADER_H
#define MOF_BATTLEFAILEUILOADER_H

class BattleFaileUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~BattleFaileUILoader();
	void loader(void);
}
#endif
#ifndef MOF_FIGHTINGUILOADER_H
#define MOF_FIGHTINGUILOADER_H

class FightingUILoader{
public:
	void ~FightingUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif
#ifndef MOF_BATTLEDIALOGLOADER_H
#define MOF_BATTLEDIALOGLOADER_H

class BattleDialogLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~BattleDialogLoader();
}
#endif
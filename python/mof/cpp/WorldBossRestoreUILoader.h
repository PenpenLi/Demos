#ifndef MOF_WORLDBOSSRESTOREUILOADER_H
#define MOF_WORLDBOSSRESTOREUILOADER_H

class WorldBossRestoreUILoader{
public:
	void ~WorldBossRestoreUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif
#ifndef MOF_ARENAACTIVITYUILOADER_H
#define MOF_ARENAACTIVITYUILOADER_H

class ArenaActivityUILoader{
public:
	void ~ArenaActivityUILoader();
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif
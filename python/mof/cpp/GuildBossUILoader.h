#ifndef MOF_GUILDBOSSUILOADER_H
#define MOF_GUILDBOSSUILOADER_H

class GuildBossUILoader{
public:
	void ~GuildBossUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif
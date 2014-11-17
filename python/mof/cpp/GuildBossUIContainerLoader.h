#ifndef MOF_GUILDBOSSUICONTAINERLOADER_H
#define MOF_GUILDBOSSUICONTAINERLOADER_H

class GuildBossUIContainerLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~GuildBossUIContainerLoader();
}
#endif
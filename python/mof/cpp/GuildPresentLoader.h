#ifndef MOF_GUILDPRESENTLOADER_H
#define MOF_GUILDPRESENTLOADER_H

class GuildPresentLoader{
public:
	void ~GuildPresentLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif